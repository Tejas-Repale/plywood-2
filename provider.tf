###########################################################
# PROVIDER.TF — PRODUCTION READY & DE-HARDCODED
# Includes: Provider, Backend, and Global Configuration
###########################################################

terraform {
  required_version = ">= 1.6.0"

  #########################################################
  # Remote Backend Configuration (S3 + DynamoDB)
  #########################################################
  backend "s3" {
    bucket         = var.backend_bucket_name
    key            = "${var.environment}/terraform.tfstate"
    region         = var.region
    dynamodb_table = var.backend_dynamodb_table
    encrypt        = true
  }

  #########################################################
  # Required Providers
  #########################################################
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

###########################################################
# AWS Provider Configuration
###########################################################

provider "aws" {
  region  = var.region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = var.owner
      CostCenter  = var.cost_center
      Compliance  = "Yes"
    }
  }
}

###########################################################
# Optional Secondary Provider (for Global Services)
# Used by WAF/CloudFront (which require us-east-1)
###########################################################

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

###########################################################
# Random Provider (for resource suffixes)
###########################################################

provider "random" {}

###########################################################
# Data Source (Optional)
# To fetch caller identity for auditing or IAM policies
###########################################################

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

###########################################################
# Outputs (Optional — Auditing Info)
###########################################################

output "current_aws_account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "AWS Account ID used by Terraform."
}

output "current_aws_region" {
  value       = data.aws_region.current.name
  description = "AWS region currently in use."
}

output "current_iam_user" {
  value       = data.aws_caller_identity.current.arn
  description = "IAM identity executing Terraform."
}
