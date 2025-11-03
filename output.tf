###########################################################
# GLOBAL DATA SOURCES
###########################################################

data "aws_caller_identity" "current" {}

###########################################################
# VPC MODULE OUTPUTS  (using correct output names)
###########################################################

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.vpc.private_subnet_ids
}



output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = module.vpc.vpc_cidr
}

###########################################################
# ALB MODULE OUTPUTS
###########################################################

output "alb_arn" {
  description = "ARN of the ALB."
  value       = module.alb.alb_arn
}



output "alb_target_group_arn" {
  description = "Target group ARN associated with the ALB."
  value       = module.alb.target_group_arn
}

###########################################################
# ECS MODULE OUTPUTS (correct names)
###########################################################



output "ecs_service_name" {
  description = "ECS service name."
  value       = module.ecs.service_name
}

output "ecs_task_definition_arn" {
  description = "Task definition ARN."
  value       = module.ecs.ecs_task_definition_arn
}

output "ecs_service_url" {
  description = "Public URL of ECS service behind ALB."
  value       = "http://${module.alb.alb_dns_name}"
}

###########################################################
# ECR MODULE OUTPUTS
###########################################################

output "ecr_repository_url" {
  description = "ECR repository URL."
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "Name of the ECR repo."
  value       = module.ecr.repository_name
}

###########################################################
# RDS MODULE OUTPUTS (correct names)
###########################################################


output "rds_port" {
  description = "Port on which RDS listens."
  value       = module.rds.db_port
}

output "rds_username" {
  description = "Master username of RDS."
  value       = module.rds.db_username
  sensitive   = true
}

###########################################################
# S3 + CLOUDFRONT MODULE OUTPUTS
###########################################################

output "s3_bucket_name" {
  description = "Name of S3 bucket."
  value       = module.s3_cloudfront.s3_bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID."
  value       = module.s3_cloudfront.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain URL."
  value       = module.s3_cloudfront.cloudfront_domain_name
}

###########################################################
# WAF MODULE OUTPUTS
###########################################################

output "waf_arn" {
  description = "ARN of the WAF Web ACL."
  value       = module.waf.waf_arn
}

output "waf_name" {
  description = "Name of the WAF."
  value       = module.waf.waf_name
}

###########################################################
# META OUTPUTS
###########################################################

output "aws_account_id" {
  description = "AWS account ID executing Terraform."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region."
  value       = var.region
}

output "terraform_workspace" {
  description = "Active Terraform workspace."
  value       = terraform.workspace
}
