variable "bucket_name" {
  description = "Name of the S3 bucket for static hosting"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket to be force deleted (use with caution)"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm"
  type        = string
  default     = "AES256"
}

variable "default_root_object" {
  description = "Default root object served by CloudFront"
  type        = string
  default     = "index.html"
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for CloudFront HTTPS"
  type        = string
}

variable "price_class" {
  description = "CloudFront price class (PriceClass_100, 200, or All)"
  type        = string
  default     = "PriceClass_100"
}

variable "logging_bucket" {
  description = "S3 bucket for CloudFront logs"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
