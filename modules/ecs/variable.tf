variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ECS networking"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets for ECS tasks"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN for ECS service load balancing"
  type        = string
}

variable "alb_listener_depends_on" {
  description = "ALB listener dependency for ECS service"
  type        = any
  default     = null
}

variable "ecr_repository_url" {
  description = "ECR repository URL for pulling container image"
  type        = string
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_port" {
  description = "Port on which container listens"
  type        = number
}

variable "task_cpu" {
  description = "CPU units for task definition"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memory (MB) for task definition"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Initial number of tasks"
  type        = number
  default     = 2
}

variable "ecs_min_capacity" {
  description = "Minimum ECS task count for autoscaling"
  type        = number
  default     = 2
}

variable "ecs_max_capacity" {
  description = "Maximum ECS task count for autoscaling"
  type        = number
  default     = 5
}

variable "cpu_target_value" {
  description = "Target CPU utilization percentage for autoscaling"
  type        = number
  default     = 60
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention days"
  type        = number
  default     = 30
}

variable "environment_variables" {
  description = "Plaintext environment variables for the container"
  type        = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "container_secrets" {
  description = "Secrets Manager ARNs for container environment variables"
  type        = list(object({
    name       = string
    value_from = string
  }))
  default = []
}

variable "tags" {
  description = "Tags for ECS resources"
  type        = map(string)
  default     = {}
}
