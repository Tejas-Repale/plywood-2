output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.task_role.arn
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.this.name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.this.name
}
