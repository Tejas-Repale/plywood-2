variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"
}

variable "encryption_type" {
  description = "The encryption type to use for the repository (AES256 or KMS)"
  type        = string
  default     = "AES256"
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images"
  type        = bool
  default     = false
}

variable "scan_on_push" {
  description = "Whether images are scanned on push"
  type        = bool
  default     = true
}

variable "repository_policy_json" {
  description = "Optional JSON policy for ECR repository access"
  type        = string
  default     = null
}

variable "prevent_destroy" {
  description = "Whether to prevent accidental deletion of ECR repository"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "ecr_repo_name" {
  type = string
}
