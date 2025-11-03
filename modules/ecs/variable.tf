variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repo URL (without tag)"
  type        = string
}

variable "image_tag" {
  description = "Image tag"
  type        = string
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "task_cpu" {
  type    = string
  default = "256"
}

variable "task_memory" {
  type    = string
  default = "512"
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "ecs_min_capacity" {
  type    = number
  default = 2
}

variable "ecs_max_capacity" {
  type    = number
  default = 5
}

variable "cpu_target_value" {
  type    = number
  default = 60
}

variable "log_retention_in_days" {
  type    = number
  default = 30
}

variable "environment_variables" {
  type = list(object({ name = string, value = string }))
  default = []
}

variable "container_secrets" {
  type = list(object({ name = string, value_from = string }))
  default = []
}

variable "target_group_arn" {
  description = "ARN of the target group to register ECS tasks with (provided by ALB module)"
  type        = string
}

variable "alb_listener_depends_on" {
  type    = any
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "alb_listener_arn" {
  description = "ARN of the ALB HTTPS listener"
  type        = string
}