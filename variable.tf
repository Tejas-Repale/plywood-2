###########################################################
# GLOBAL VARIABLES (COMMON ACROSS ALL MODULES)
###########################################################

variable "project_name" {
  description = "The name of the project or application."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region for resource deployment."
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS CLI profile name for authentication."
  type        = string
  default     = "default"
}

variable "owner" {
  description = "Owner or responsible team for the infrastructure."
  type        = string
  default     = "DevOpsTeam"
}

variable "cost_center" {
  description = "Tag to track resource cost allocation."
  type        = string
  default     = "Finance-001"
}

###########################################################
# BACKEND CONFIGURATION VARIABLES
###########################################################

variable "backend_bucket_name" {
  description = "S3 bucket name to store Terraform remote state."
  type        = string
}

variable "backend_dynamodb_table" {
  description = "DynamoDB table name for Terraform state locking."
  type        = string
}

###########################################################
# VPC MODULE VARIABLES
###########################################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs across AZs."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs across AZs."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones for subnets."
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

###########################################################
# ALB MODULE VARIABLES
###########################################################

variable "alb_name" {
  description = "Name for the Application Load Balancer."
  type        = string
  default     = "app-alb"
}

variable "alb_listener_port" {
  description = "Listener port for the ALB."
  type        = number
  default     = 80
}

variable "alb_internal" {
  description = "Whether the ALB is internal (true) or internet-facing (false)."
  type        = bool
  default     = false
}

variable "alb_target_port" {
  description = "Port on which the target (ECS container) listens."
  type        = number
  default     = 8080
}

###########################################################
# ECS MODULE VARIABLES
###########################################################

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
  default     = "ecs-cluster"
}

variable "ecs_service_name" {
  description = "Name of the ECS service."
  type        = string
  default     = "ecs-service"
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS task definition."
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "Memory (MiB) for the ECS task definition."
  type        = number
  default     = 512
}

variable "ecs_desired_count" {
  description = "Number of desired ECS tasks."
  type        = number
  default     = 2
}

variable "ecs_image_url" {
  description = "ECR image URI for ECS deployment."
  type        = string
  default     = ""
}

variable "ecs_container_port" {
  description = "Container port for the ECS service."
  type        = number
  default     = 8080
}

variable "ecs_launch_type" {
  description = "Launch type for ECS service (EC2 or FARGATE)."
  type        = string
  default     = "FARGATE"
}

variable "ecs_execution_role_name" {
  description = "IAM role name for ECS task execution."
  type        = string
  default     = "ecsTaskExecutionRole"
}

###########################################################
# ECR MODULE VARIABLES
###########################################################

variable "ecr_repo_name" {
  description = "ECR repository name to store Docker images."
  type        = string
  default     = "app-repo"
}

variable "ecr_image_tag_mutability" {
  description = "Image tag mutability setting (MUTABLE/IMMUTABLE)."
  type        = string
  default     = "IMMUTABLE"
}

variable "ecr_scan_on_push" {
  description = "Enable image scan on push."
  type        = bool
  default     = true
}

###########################################################
# RDS MODULE VARIABLES
###########################################################

variable "rds_identifier" {
  description = "Identifier name for RDS instance."
  type        = string
  default     = "app-db"
}

variable "rds_engine" {
  description = "Database engine for RDS (e.g., mysql, postgres)."
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "Engine version for RDS."
  type        = string
  default     = "8.0.36"
}

variable "rds_instance_class" {
  description = "Instance type for RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "rds_username" {
  description = "Master username for RDS."
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "Master password for RDS."
  type        = string
  sensitive   = true
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS in GB."
  type        = number
  default     = 20
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ for high availability."
  type        = bool
  default     = false
}

###########################################################
# S3 + CLOUDFRONT MODULE VARIABLES
###########################################################

variable "s3_bucket_name" {
  description = "S3 bucket name for static hosting."
  type        = string
}

variable "cloudfront_comment" {
  description = "Comment for CloudFront distribution."
  type        = string
  default     = "Static website distribution"
}

variable "enable_logging" {
  description = "Enable CloudFront logging to S3."
  type        = bool
  default     = true
}

###########################################################
# WAF MODULE VARIABLES
###########################################################

variable "waf_scope" {
  description = "Scope for WAF (REGIONAL for ALB or CLOUDFRONT for global)."
  type        = string
  default     = "REGIONAL"
}

variable "associate_alb" {
  description = "Whether to associate WAF with ALB."
  type        = bool
  default     = true
}

variable "blocked_ip_addresses" {
  description = "List of IP addresses to block using WAF."
  type        = list(string)
  default     = []
}

###########################################################
# TAGGING VARIABLES
###########################################################

variable "tags" {
  description = "Map of common tags for all resources."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Owner     = "DevOpsTeam"
  }
}
