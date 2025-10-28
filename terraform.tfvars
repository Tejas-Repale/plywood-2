# ===========================
# 🌍 Global Environment Config
# ===========================
environment = "prod"
aws_region  = "ap-south-1"

# ===========================
# 🔒 Backend (Remote State)
# ===========================
backend_bucket_name    = "mycompany-terraform-backend-prod"
backend_dynamodb_table = "terraform-locks"
backend_region         = "ap-south-1"

# ===========================
# 🌐 VPC Configuration
# ===========================
vpc_name             = "prod-vpc"
vpc_cidr_block       = "10.0.0.0/16"
azs                  = ["ap-south-1a", "ap-south-1b"]
public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets      = ["10.0.3.0/24", "10.0.4.0/24"]
enable_nat_gateway   = true
single_nat_gateway   = false
enable_dns_support   = true
enable_dns_hostnames = true

# ===========================
# 🧱 ECS + Cluster Configuration
# ===========================
ecs_cluster_name          = "prod-ecs-cluster"
ecs_service_name          = "prod-web-service"
ecs_task_family           = "prod-task-family"
ecs_desired_count         = 3
ecs_cpu                   = 512
ecs_memory                = 1024
ecs_launch_type           = "FARGATE"
ecs_container_port        = 80
ecs_auto_scaling_min      = 2
ecs_auto_scaling_max      = 6
ecs_auto_scaling_target   = 50

# ===========================
# 🐳 ECR Repository
# ===========================
ecr_repo_name      = "prod-app-repo"
ecr_image_tag_mutability = "MUTABLE"
ecr_scan_on_push   = true
image_tag          = "latest"

# ===========================
# 🗄️ RDS (Database) Configuration
# ===========================
rds_identifier             = "prod-db"
rds_engine                 = "mysql"
rds_engine_version         = "8.0.35"
rds_instance_class         = "db.t3.medium"
rds_allocated_storage      = 50
rds_username               = "admin"
rds_db_name                = "prod_db"
rds_backup_retention       = 7
rds_multi_az               = true
rds_publicly_accessible    = false
rds_deletion_protection    = true
rds_maintenance_window     = "Mon:00:00-Mon:03:00"
rds_backup_window          = "03:00-06:00"
rds_port                   = 3306
rds_storage_encrypted      = true
rds_parameter_group_name   = "default.mysql8.0"
rds_subnet_group_name      = "prod-rds-subnet-group"

# Store RDS password securely in AWS Secrets Manager (not here)
rds_password_secret_name = "prod/rds/mysql/password"

# ===========================
# 🕸️ Application Load Balancer
# ===========================
alb_name                 = "prod-alb"
alb_internal             = false
alb_idle_timeout         = 60
alb_target_group_name    = "prod-tg"
alb_target_group_port    = 80
alb_target_group_protocol = "HTTP"
alb_health_check_path    = "/health"
alb_health_check_interval = 30
alb_listener_port        = 80
alb_listener_protocol    = "HTTP"

# ===========================
# ☁️ S3 + CloudFront (Static Website / CDN)
# ===========================
s3_bucket_name              = "prod-static-assets"
s3_force_destroy            = false
s3_versioning_enabled       = true
s3_website_index_document   = "index.html"
s3_website_error_document   = "error.html"
cloudfront_comment          = "CloudFront CDN for production assets"
cloudfront_price_class      = "PriceClass_100"
cloudfront_default_ttl      = 3600
cloudfront_min_ttl          = 0
cloudfront_max_ttl          = 86400
cloudfront_ssl_support_method = "sni-only"

# ===========================
# 🛡️ AWS WAF (Web Application Firewall)
# ===========================
waf_name              = "prod-waf"
waf_scope             = "CLOUDFRONT"
waf_default_action    = "allow"
waf_rate_limit        = 2000
waf_managed_rule_sets = [
  {
    name        = "AWSManagedRulesCommonRuleSet"
    vendor_name = "AWS"
  },
  {
    name        = "AWSManagedRulesSQLiRuleSet"
    vendor_name = "AWS"
  },
  {
    name        = "AWSManagedRulesKnownBadInputsRuleSet"
    vendor_name = "AWS"
  }
]

# ===========================
# 🔐 IAM & Security (Optional overrides)
# ===========================
iam_role_name_ecs        = "prod-ecs-execution-role"
iam_role_name_task       = "prod-task-role"
iam_policy_arn_cloudwatch = "arn:aws:iam::aws:policy/CloudWatchFullAccess"

# ===========================
# ⚙️ Tags (for Cost Tracking / Organization)
# ===========================
tags = {
  Environment   = "prod"
  Project       = "ECS-FullStack-App"
  ManagedBy     = "Terraform"
  Owner         = "DevOpsTeam"
  CostCenter    = "AppInfra"
}
