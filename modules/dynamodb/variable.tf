variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table used for Terraform state locking."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the DynamoDB table."
  type        = map(string)
  default     = {}
}
