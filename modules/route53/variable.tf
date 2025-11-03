variable "domain_name" {
  description = "Root domain name (example.com)"
  type        = string
}

variable "create_hosted_zone" {
  description = "Whether to create a hosted zone"
  type        = bool
  default     = false
}

variable "existing_zone_id" {
  description = "Existing hosted zone ID if not creating a new one"
  type        = string
  default     = null
}

variable "ttl" {
  description = "TTL for Route53 records"
  type        = number
  default     = 300
}

###############################
# ALB Record Variables
###############################
variable "create_alb_record" {
  type        = bool
  default     = true
}

variable "alb_record_name" {
  type = string
}

variable "create_records" {
  type    = bool
  default = false
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  type        = string
}
variable "alb_zone_id" {
  description = "ALB hosted zone ID"
  type        = string
}

###############################
# CloudFront Record Variables
###############################
variable "create_cloudfront_record" {
  type        = bool
  default     = true
}
variable "cloudfront_record_name" {
  description = "DNS record name pointing to CloudFront"
  type        = string
}
variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain"
  type        = string
}
variable "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID"
  type        = string
}

###############################
# Wildcard Support
###############################
variable "enable_wildcard" {
  type        = bool
  default     = false
}

###############################
# Health Check Variables
###############################
variable "enable_health_check" {
  type        = bool
  default     = false
}

variable "health_check_domain" {
  description = "Domain for health checks"
  type        = string
  default     = null
}

variable "health_check_regions" {
  type    = list(string)
  default = ["us-east-1", "us-west-1", "eu-west-1"]
}

###############################
# Failover Routing Variables
###############################
variable "enable_failover" {
  type    = bool
  default = false
}

variable "failover_domain" {
  description = "Failover DNS domain"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for all Route53 resources"
  type        = map(string)
  default     = {}
}

