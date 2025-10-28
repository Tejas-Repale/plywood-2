###########################################################
# ROOT OUTPUTS — PRODUCTION READY & DE-HARDCODED
# Includes outputs for: VPC, ALB, ECS, ECR, RDS, S3+CloudFront, WAF
###########################################################

###########################################################
# VPC MODULE OUTPUTS
###########################################################
output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs."
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs."
  value       = module.vpc.private_subnets
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  value       = module.vpc.vpc_cidr_block
}


###########################################################
# ALB MODULE OUTPUTS
###########################################################
output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB to access applications."
  value       = module.alb.alb_dns_name
}

output "alb_target_group_arn" {
  description = "Target group ARN associated with the ALB."
  value       = module.alb.target_group_arn
}

output "alb_security_group_id" {
  description = "Security Group ID attached to the ALB."
  value       = module.alb.security_group_id
}


###########################################################
# ECS MODULE OUTPUTS
###########################################################
output "ecs_cluster_id" {
  description = "ID of the ECS cluster."
  value       = module.ecs.ecs_cluster_id
}

output "ecs_service_name" {
  description = "Name of the ECS service."
  value       = module.ecs.ecs_service_name
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition."
  value       = module.ecs.task_definition_arn
}

output "ecs_service_url" {
  description = "Public URL of the ECS service (via ALB)."
  value       = "http://${module.alb.alb_dns_name}"
}


###########################################################
# ECR MODULE OUTPUTS
###########################################################
output "ecr_repository_url" {
  description = "URL of the ECR repository."
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "Name of the ECR repository."
  value       = module.ecr.repository_name
}


###########################################################
# RDS MODULE OUTPUTS
###########################################################
output "rds_instance_id" {
  description = "ID of the RDS instance."
  value       = module.rds.db_instance_id
}

output "rds_endpoint" {
  description = "RDS endpoint address for database connections."
  value       = module.rds.db_endpoint
}

output "rds_port" {
  description = "Port number on which the RDS instance listens."
  value       = module.rds.db_port
}

output "rds_username" {
  description = "Master username of the RDS instance."
  value       = module.rds.db_username
  sensitive   = true
}


###########################################################
#  S3 + CLOUDFRONT MODULE OUTPUTS
###########################################################
output "s3_bucket_name" {
  description = "Name of the S3 bucket for static hosting."
  value       = module.s3_cloudfront.s3_bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket."
  value       = module.s3_cloudfront.s3_bucket_arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = module.s3_cloudfront.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution."
  value       = module.s3_cloudfront.cloudfront_domain_name
}


###########################################################
#  WAF MODULE OUTPUTS
###########################################################
output "waf_arn" {
  description = "ARN of the WAF Web ACL."
  value       = module.waf.waf_arn
}

output "waf_name" {
  description = "Name of the WAF Web ACL."
  value       = module.waf.waf_name
}


###########################################################
#  META / AUDIT OUTPUTS
###########################################################
output "aws_account_id" {
  description = "AWS account ID executing Terraform."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "Region where Terraform is deploying resources."
  value       = var.region
}

output "terraform_workspace" {
  description = "Current Terraform workspace (environment)."
  value       = terraform.workspace
}
