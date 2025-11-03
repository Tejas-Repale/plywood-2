output "dynamodb_table_name" {
  description = "DynamoDB table name used for Terraform state locking."
  value       = aws_dynamodb_table.terraform_locks.name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN."
  value       = aws_dynamodb_table.terraform_locks.arn
}
