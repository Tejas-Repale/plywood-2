output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "rds_port" {
  description = "Port number for RDS"
  value       = aws_db_instance.this.port
}

output "rds_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.this.arn
}

output "rds_secret_arn" {
  description = "Secret ARN storing DB credentials"
  value       = aws_secretsmanager_secret.this.arn
}

output "rds_subnet_group" {
  description = "RDS subnet group name"
  value       = aws_db_subnet_group.this.name
}

output "db_port" {
  description = "Database port"
  value       = aws_db_instance.this.port
}

output "db_username" {
  description = "Master username for RDS"
  value       = aws_db_instance.this.username
}