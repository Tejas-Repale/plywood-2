terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# ------------------------------------------------------------------------------
# Create ECR Repository
# ------------------------------------------------------------------------------
resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  encryption_configuration {
    encryption_type = var.encryption_type
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = merge(
    {
      Name = var.repository_name
    },
    var.tags
  )

 lifecycle {
  prevent_destroy = false

   ignore_changes = [
    name,
    encryption_configuration,
    image_tag_mutability,
    tags,
  ]
}
}

# ------------------------------------------------------------------------------
# Repository Policy (optional)
# ------------------------------------------------------------------------------
resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = var.repository_policy_json
  count      = var.repository_policy_json == null ? 0 : 1
}

# ------------------------------------------------------------------------------
# Lifecycle Policy (cleanup old images)
# ------------------------------------------------------------------------------
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Remove untagged images older than 30 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# ------------------------------------------------------------------------------
# ECR Repository Encryption Key (optional, via KMS)
# ------------------------------------------------------------------------------
resource "aws_kms_key" "ecr_kms" {
  description         = "KMS key for ECR image encryption"
  deletion_window_in_days = 10
  enable_key_rotation  = true

  tags = merge(
    {
      Name = "${var.repository_name}-kms"
    },
    var.tags
  )

  count = var.encryption_type == "KMS" ? 1 : 0
}
