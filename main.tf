###########################################################
# ROOT MAIN.TF — PRODUCTION READY & DE-HARDCODED
# Includes modules: VPC, ALB, ECR, ECS, RDS, WAF, S3+CloudFront
###########################################################

terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = var.backend_bucket_name
    key            = "${var.environment}/terraform.tfstate"
    region         = var.region
    dynamodb_table = var.backend_dynamodb_table
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

###########################################################
# PROVIDER CONFIGURATION
###########################################################

provider "aws" {
  region = var.region
  profile = var.aws_profile
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}

###########################################################
# MODULE: VPC
###########################################################

module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  environment          = var.environment
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  enable_nat_gateway   = var.enable_nat_gateway
}

###########################################################
# MODULE: ECR
###########################################################

module "ecr" {
  source        = "./modules/ecr"
  project_name  = var.project_name
  environment   = var.environment
  ecr_repo_name = "${var.project_name}-${var.environment}-repo"
  scan_on_push  = true
}

###########################################################
# MODULE: ECS
###########################################################

module "ecs" {
  source                    = "./modules/ecs"
  project_name              = var.project_name
  environment               = var.environment
  cluster_name              = "${var.project_name}-${var.environment}-cluster"
  ecs_desired_count         = var.ecs_desired_count
  ecs_task_cpu              = var.ecs_task_cpu
  ecs_task_memory           = var.ecs_task_memory
  container_image           = module.ecr.repository_url
  container_port            = var.container_port
  subnet_ids                = module.vpc.private_subnet_ids
  security_group_ids        = [module.vpc.private_sg_id]
  assign_public_ip          = false
  enable_execute_command    = true
  depends_on                = [module.ecr, module.vpc]
}

###########################################################
# MODULE: RDS
###########################################################

module "rds" {
  source                  = "./modules/rds"
  project_name            = var.project_name
  environment             = var.environment
  db_engine               = var.db_engine
  db_engine_version       = var.db_engine_version
  db_instance_class       = var.db_instance_class
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  subnet_ids              = module.vpc.private_subnet_ids
  vpc_security_group_ids  = [module.vpc.private_sg_id]
  multi_az                = true
  allocated_storage       = 20
  max_allocated_storage   = 100
  publicly_accessible     = false
  backup_retention_period = 7
  deletion_protection     = true
  depends_on              = [module.vpc]
}

###########################################################
# MODULE: ALB
###########################################################

module "alb" {
  source                  = "./modules/alb"
  project_name            = var.project_name
  environment             = var.environment
  alb_name                = "${var.project_name}-${var.environment}-alb"
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.public_subnet_ids
  security_group_ids      = [module.vpc.public_sg_id]
  target_group_port       = var.container_port
  health_check_path       = "/"
  listener_port           = 80
  ecs_target_group_arn    = module.ecs.target_group_arn
  depends_on              = [module.vpc, module.ecs]
}

###########################################################
# MODULE: S3 + CloudFront
###########################################################

module "s3_cloudfront" {
  source                  = "./modules/s3_cloudfront"
  project_name            = var.project_name
  environment             = var.environment
  s3_bucket_name          = "${var.project_name}-${var.environment}-static"
  enable_versioning       = true
  enable_logging          = true
  index_document          = "index.html"
  error_document          = "error.html"
  allowed_methods         = ["GET", "HEAD"]
  cached_methods          = ["GET", "HEAD"]
  price_class             = "PriceClass_100"
  waf_acl_arn             = module.waf.waf_acl_arn
  depends_on              = [module.waf]
}

###########################################################
# MODULE: WAF
###########################################################

module "waf" {
  source           = "./modules/waf"
  project_name     = var.project_name
  environment      = var.environment
  scope            = "CLOUDFRONT"
  common_rule_set  = true
  geo_restriction  = ["IN", "US"]
}

###########################################################
# OUTPUTS
###########################################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecr_repo_url" {
  value = module.ecr.repository_url
}

output "cloudfront_domain" {
  value = module.s3_cloudfront.cloudfront_domain
}
