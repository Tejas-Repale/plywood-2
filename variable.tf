variable "aws_profile" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

# VPC
variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type = bool
}

variable "repository_name" {
  type = string
}

# ECR
variable "ecr_repo_name" {
  type = string
}

# ECS
variable "image_tag" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "ecs_min_capacity" {
  type    = number
  default = 2
}

variable "ecs_max_capacity" {
  type    = number
  default = 5
}

variable "cpu_target_value" {
  type    = number
  default = 60
}

variable "log_retention_in_days" {
  type    = number
  default = 30
}

variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "container_secrets" {
  type = list(object({
    name       = string
    value_from = string
  }))
  default = []
}

# RDS
variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0.36"
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type    = number
  default = 100
}

variable "multi_az" {
  type    = bool
  default = true
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "skip_final_snapshot" {
  type    = bool
  default = false
}

variable "monitoring_interval" {
  type    = number
  default = 60
}

variable "cloudwatch_logs_exports" {
  type    = list(string)
  default = ["error", "general", "slowquery"]
}

variable "maintenance_window" {
  type    = string
  default = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  type    = string
  default = "03:00-06:00"
}

variable "kms_key_arn" {
  type    = string
  default = null
}

# ALB
variable "alb_name" {
  type = string
}

# S3/CloudFront
variable "bucket_name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "logging_bucket" {
  type = string
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "sse_algorithm" {
  type    = string
  default = "AES256"
}

variable "default_root_object" {
  type    = string
  default = "index.html"
}

variable "price_class" {
  type    = string
  default = "PriceClass_100"
}

# WAF
variable "scope" {
  type    = string
  default = "CLOUDFRONT"
}

variable "waf_managed_rule_sets" {
  type    = list(string)
  default = []
}

variable "cloudfront_comment" {
  type    = string
  default = ""
}

# Route53
variable "domain_name" {
  type    = string
  default = ""
}

variable "hosted_zone_id" {
  type    = string
  default = ""
}

# DynamoDB
variable "dynamodb_table_name" {
  type    = string
  default = ""
}

# Tags
variable "tags" {
  type    = map(string)
  default = {}
}
variable "aws_region" {
  type = string
}


variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN for ALB HTTPS listener"
  default     = null
}

variable "rds_password_secret_name" {
  type = string
}

variable "rds_backup_retention" {
  type = number
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}
