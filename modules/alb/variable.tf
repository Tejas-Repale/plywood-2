variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "alb_name" {
  type        = string
  description = "Name of the load balancer"
}

variable "alb_internal" {
  type        = bool
  description = "Whether the ALB is internal"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for ALB"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for SG"
}

variable "listener_port" {
  type        = number
  default     = 80
  description = "Listener port for ALB HTTP listener"
}

variable "listener_protocol" {
  type        = string
  default     = "HTTP"
  description = "Protocol for ALB listener"
}

variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN for HTTPS"
  default     = null
}

variable "target_group_name" {
  type        = string
  description = "Name for target group"
}

variable "target_group_port" {
  type        = number
  description = "Port for target group"
}

variable "target_group_protocol" {
  type        = string
  description = "Protocol for target group (HTTP or HTTPS)"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}

variable "health_check_healthy_threshold" {
  type        = number
  description = "Number of consecutive successful health checks before considering the target healthy"
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  type        = number
  description = "Number of consecutive failed health checks before considering the target unhealthy"
  default     = 3
}

variable "health_check_timeout" {
  type        = number
  description = "Amount of time, in seconds, before the health check times out"
  default     = 5
}

variable "health_check_interval" {
  type        = number
  description = "Time (in seconds) between health checks"
  default     = 30
}

variable "health_check_path" {
  type        = string
  description = "The destination path for ALB health checks"
  default     = "/"
}

variable "health_check_matcher" {
  type        = string
  description = "HTTP code matcher for the ALB health check"
  default     = "200"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach to ALB. If empty, module will create a new SG."
  default     = []
}

variable "ssl_policy" {
  description = "Security policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "target_type" {
  type    = string
  default = "instance"   # ok but we override in root
}
