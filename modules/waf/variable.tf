variable "project_name" {
  description = "Project or environment name prefix"
  type        = string
}

variable "waf_scope" {
  description = "Scope of WAF (REGIONAL for ALB, CLOUDFRONT for global)"
  type        = string
  default     = "REGIONAL"
}

variable "associate_alb" {
  description = "Set true to associate WAF with ALB"
  type        = bool
  default     = true
}

variable "resource_arn" {
  description = "ARN of the resource (ALB or CloudFront) to associate with"
  type        = string
  default     = ""
}

variable "blocked_ip_addresses" {
  description = "Optional list of IPs to block"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  type = string
}

variable "scope" {
  type = string
}

variable "common_rule_set" {
  type    = bool
  default = true
}

variable "geo_restriction" {
  type    = list(string)
  default = []
}

variable "cloudfront_comment" {
  type = string
}

variable "waf_managed_rule_sets" {
  type = list(string)
}

variable "create_alb_association" {
  type    = bool
  default = false
}

variable "alb_arn" {
  type    = string
  default = ""
}
