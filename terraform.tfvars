# ===========================
# 🌍 Global
# ===========================
environment = "prod"
aws_region  = "ap-south-1"

# ===========================
# 🔒 Backend
# ===========================
backend_bucket_name    = "mycompany-terraform-backend-prod"
backend_dynamodb_table = "terraform-locks"
backend_region         = "ap-south-1"

# ===========================
# 🌐 VPC
# ===========================
vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]

project_name = "plywoodbazar"

# ===========================
# 🧱 ECS
# ===========================
ecs_cluster_name        = "prod-ecs-cluster"
ecs_service_name        = "prod-web-service"
ecs_task_family         = "prod-task-family"
ecs_desired_count       = 3
ecs_cpu                 = 512
ecs_memory              = 1024
ecs_launch_type         = "FARGATE"
ecs_container_port      = 80
ecs_auto_scaling_min    = 2
ecs_auto_scaling_max    = 6
ecs_auto_scaling_target = 50

# ===========================
# 🐳 ECR
# ===========================
ecr_repo_name            = "my-application-ecr"
image_tag                = "latest"
ecr_image_tag_mutability = "MUTABLE"
ecr_scan_on_push         = true

# ===========================
# 🗄️ RDS
# ===========================
rds_identifier           = "prod-db"
rds_engine               = "mysql"
rds_engine_version       = "8.0.40"
rds_instance_class       = "db.t3.medium"
rds_allocated_storage    = 50
rds_username             = "admin"
rds_db_name              = "prod_db"
rds_password_secret_name = "prod/rds/mysql/password"
rds_multi_az             = true
rds_publicly_accessible  = false
rds_backup_retention     = 7
rds_deletion_protection  = true
rds_maintenance_window   = "Mon:00:00-Mon:03:00"
rds_backup_window        = "03:00-06:00"
rds_port                 = 3306
rds_storage_encrypted    = true

# ===========================
# 🕸️ ALB
# ===========================
alb_name                  = "my-application-alb"
alb_internal              = false
alb_idle_timeout          = 60
alb_target_group_name     = "prod-tg"
alb_target_group_port     = 80
alb_target_group_protocol = "HTTP"
alb_health_check_path     = "/health"
alb_health_check_interval = 30
alb_listener_port         = 80
alb_listener_protocol     = "HTTP"

# ✅ REMOVE subnet-xxxx — these come from VPC module output
# public_subnet_ids will be assigned automatically from module.vpc
public_subnet_ids = []

# ===========================
# ☁️ S3 + CloudFront
# ===========================
s3_bucket_name                = "prod-static-assets"
s3_force_destroy              = false
s3_versioning_enabled         = true
s3_website_index_document     = "index.html"
s3_website_error_document     = "error.html"
cloudfront_comment            = "CloudFront CDN for production assets"
cloudfront_price_class        = "PriceClass_100"
cloudfront_default_ttl        = 3600
cloudfront_min_ttl            = 0
cloudfront_max_ttl            = 86400
cloudfront_ssl_support_method = "sni-only"
acm_certificate_arn           = "arn:aws:acm:us-east-1:123456:certificate/xxxx"
logging_bucket                = "myproject-cf-logs"

# ===========================
# 🌐 Route53
# ===========================
domain_name    = "example.com"
hosted_zone_id = ""

# ===========================
# ✅ Tags
# ===========================
tags = {
  Environment = "prod"
  Project     = "ECS-FullStack-App"
  ManagedBy   = "Terraform"
  Owner       = "DevOpsTeam"
  CostCenter  = "AppInfra"
}
