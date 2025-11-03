###########################################################
# PROVIDER CONFIGURATION
###########################################################

provider "aws" {
  region  = var.region
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
# (expects variables: vpc_cidr, public_subnet_cidrs, private_subnet_cidrs, availability_zones, enable_nat_gateway)
###########################################################

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  tags         = var.tags

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.availability_zones

  enable_nat_gateway   = var.enable_nat_gateway
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
}

###########################################################
# MODULE: ECR
# (module expects either "repository_name" or "ecr_repo_name" — use ecr_repo_name here)
###########################################################

module "ecr" {
  source          = "./modules/ecr"
  ecr_repo_name   = var.ecr_repo_name
  project_name    = var.project_name
  environment     = var.environment
  scan_on_push    = true
  repository_name = var.repository_name
}

###########################################################
# MODULE: ECS
# (pass all variables module/ecs/variables.tf expects)
###########################################################

module "ecs" {
  source = "./modules/ecs"

  project_name            = var.project_name
  region                  = var.region
  private_subnet_ids      = module.vpc.private_subnet_ids
  ecs_security_group_id   = aws_security_group.ecs_sg.id # or a resource you created
  alb_listener_arn        = module.alb.https_listener_arn
  ecr_repository_url      = module.ecr.repository_url
  image_tag               = var.image_tag
  container_name          = var.container_name
  container_port          = var.container_port
  target_group_arn        = module.alb.target_group_arn # <<–– important: ALB's TG ARN fed to ECS
  desired_count           = var.desired_count
  ecs_min_capacity        = var.ecs_min_capacity
  ecs_max_capacity        = var.ecs_max_capacity
  cpu_target_value        = var.cpu_target_value
  log_retention_in_days   = var.log_retention_in_days
  environment_variables   = var.environment_variables
  container_secrets       = var.container_secrets
  alb_listener_depends_on = [module.alb.alb_listener_arn] # if you want to force order, but prefer module references
  tags                    = var.tags
}

###########################################################
# MODULE: RDS
###########################################################

module "rds" {
  source = "./modules/rds"

  db_identifier  = "${var.project_name}-db"
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  subnet_ids              = module.vpc.private_subnet_ids
  security_group_ids      = module.alb.security_group_ids
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot

  monitoring_interval     = var.monitoring_interval
  cloudwatch_logs_exports = var.cloudwatch_logs_exports

  maintenance_window = var.maintenance_window
  backup_window      = var.backup_window

  kms_key_arn = var.kms_key_arn

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }

  depends_on = [module.vpc]
}

###########################################################
# MODULE: ALB
# (module expects: vpc_id, subnet_ids, security_group_ids, target_group_name, ecs_target_group_arn, certificate_arn, project_name, environment)
###########################################################
module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  alb_name              = "${var.project_name}-${var.environment}-alb"
  alb_internal          = false
  subnet_ids            = module.vpc.public_subnet_ids
  vpc_id                = module.vpc.vpc_id
  security_group_ids    = []
  ssl_policy            = ""
  listener_port         = 80
  listener_protocol     = "HTTP"

  target_group_name     = "${var.project_name}-${var.environment}-tg"
  target_group_port     = 80
  target_group_protocol = "HTTP"
  target_type           = "ip"

  health_check_healthy_threshold     = 3
  health_check_unhealthy_threshold   = 3
  health_check_timeout               = 5
  health_check_interval              = 30

  certificate_arn       = ""
  tags                  = var.tags
}

###########################################################
# MODULE: S3 + CloudFront
###########################################################

module "s3_cloudfront" {
  source = "./modules/s3_cloudfront"

  bucket_name         = var.bucket_name
  acm_certificate_arn = ""
  logging_bucket      = var.logging_bucket

  force_destroy       = var.force_destroy
  enable_versioning   = var.enable_versioning
  sse_algorithm       = var.sse_algorithm
  default_root_object = var.default_root_object
  price_class         = var.price_class
  tags                = var.tags
}

###########################################################
# MODULE: WAF
# (module expects cloudfront_comment and waf_managed_rule_sets per your earlier module variables)
###########################################################

module "waf" {
  source = "./modules/waf"

  create_alb_association = true
  alb_arn                = module.alb.alb_arn
  project_name           = var.project_name
  environment            = var.environment
  scope                  = var.scope
  waf_managed_rule_sets  = var.waf_managed_rule_sets
  depends_on             = [module.alb]

  # module required cloudfront_comment per your module variables
  cloudfront_comment = var.cloudfront_comment
}

###########################################################
# MODULE: Route53
###########################################################


# source = "./modules/route53"
 # enabled = false
  #domain_name        = var.domain_name
  #create_hosted_zone = false
  #hosted_zone_id     = var.hosted_zone_id

  #create_alb_record = var.hosted_zone_id != ""
  #record_name       = var.record_name
  #record_type       = var.record_type

  # use ALB module outputs (adjust names if your alb module uses different output attributes)
  #alb_dns_name = module.alb.alb_dns_name
  #alb_zone_id  = module.alb.alb_zone_id

  #create_cloudfront_record  = var.hosted_zone_id != ""
  #cloudfront_domain_name    = module.s3_cloudfront.cloudfront_domain
  #cloudfront_hosted_zone_id = module.s3_cloudfront.cloudfront_hosted_zone_id

  #enable_wildcard     = true
  #enable_health_check = true
  #health_check_domain = "api.${var.domain_name}"

  #tags = var.tags


###########################################################
# MODULE: DynamoDB (State Lock Table)
###########################################################

module "dynamodb_backend" {
  source = "./modules/dynamodb"

  dynamodb_table_name = "terraform-locks-${var.environment}"
  tags                = var.tags
}

###########################################################
# SECURITY GROUP: RDS
###########################################################

resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # tighten in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

###########################################################
# OUTPUTS
###########################################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = try(module.alb.alb_dns_name, module.alb.dns_name, "")
}

output "rds_endpoint" {
  value = try(module.rds.db_endpoint, module.rds.endpoint, "")
}

output "ecs_cluster_name" {
  value = try(module.ecs.cluster_name, module.ecs.cluster, "")
}

output "ecr_repo_url" {
  value = try(module.ecr.repository_url, module.ecr.repo_url, "")
}

output "cloudfront_domain" {
  value = try(module.s3_cloudfront.cloudfront_domain, module.s3_cloudfront.domain_name, "")
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow traffic from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # or module.alb.alb_sg_cidr if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
