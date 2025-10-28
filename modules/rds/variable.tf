variable "db_identifier" {
  description = "Unique identifier for the RDS instance"
  type        = string
}

variable "engine" {
  description = "Database engine (mysql, postgres, etc.)"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Engine version for RDS"
  type        = string
  default     = "8.0.36"
}

variable "instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "The allocated storage in GBs"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage (auto-scaling)"
  type        = number
  default     = 100
}

variable "multi_az" {
  description = "If true, deploys RDS instance in multiple AZs"
  type        = bool
  default     = true
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Database port number"
  type        = number
  default     = 3306
}

variable "security_group_ids" {
  description = "List of VPC Security Groups to associate"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS subnet group"
  type        = list(string)
}

variable "parameter_group_family" {
  description = "RDS parameter group family (e.g., mysql8.0)"
  type        = string
  default     = "mysql8.0"
}

variable "deletion_protection" {
  description = "If true, RDS instance cannot be deleted"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot on deletion"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval in seconds"
  type        = number
  default     = 60
}

variable "cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = ["error", "slowquery", "general"]
}

variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "03:00-06:00"
}

variable "kms_key_arn" {
  description = "KMS key ARN for encryption"
  type        = string
  default     = null
}

variable "prevent_destroy" {
  description = "Prevents accidental DB deletion"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
