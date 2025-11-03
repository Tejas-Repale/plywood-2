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
# Create RDS Subnet Group
# ------------------------------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.subnet_ids
  description = "Subnet group for RDS ${var.db_identifier}"

  tags = merge(
    {
      Name = "${var.db_identifier}-subnet-group"
    },
    var.tags
  )
}

# ------------------------------------------------------------------------------
# Create RDS Parameter Group
# ------------------------------------------------------------------------------
resource "aws_db_parameter_group" "this" {
  name        = "${var.db_identifier}-param-group"
  family      = var.parameter_group_family
  description = "Parameter group for ${var.db_identifier}"

  tags = merge(
    {
      Name = "${var.db_identifier}-param-group"
    },
    var.tags
  )
}

# ------------------------------------------------------------------------------
# Create Secrets Manager secret for DB credentials
# ------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "this" {
  name        = "${var.db_identifier}-credentials"
  description = "RDS credentials for ${var.db_identifier}"

  tags = merge(
    {
      Name = "${var.db_identifier}-secret"
    },
    var.tags
  )
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

# ------------------------------------------------------------------------------
# Create RDS instance (Multi-AZ)
# ------------------------------------------------------------------------------
resource "aws_db_instance" "this" {
  identifier              = var.db_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  multi_az                = var.multi_az
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.security_group_ids
  parameter_group_name    = aws_db_parameter_group.this.name
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  storage_encrypted       = true
  kms_key_id              = var.kms_key_arn
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  port                    = var.db_port
  monitoring_interval     = var.monitoring_interval
  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports

  auto_minor_version_upgrade = true
  apply_immediately          = false

  maintenance_window  = var.maintenance_window
  backup_window       = var.backup_window

  tags = merge(
    {
      Name = var.db_identifier
    },
    var.tags
  )

  lifecycle {
    prevent_destroy = true
  }
}

# ------------------------------------------------------------------------------
# Outputs in Secrets Manager for ECS usage
# ------------------------------------------------------------------------------
resource "aws_secretsmanager_secret_policy" "this" {
  secret_arn = aws_secretsmanager_secret.this.arn
  policy     = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { AWS = "*" }
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = aws_secretsmanager_secret.this.arn
      }
    ]
  })
}
