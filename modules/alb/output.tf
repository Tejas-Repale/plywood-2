output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = aws_lb.this.zone_id
}

output "target_group_arn" {
  description = "ARN of the target group created by the ALB module"
  value       = aws_lb_target_group.this.arn
}

output "https_listener_arn" {
  description = "ARN of the ALB HTTPS listener"
  value       = aws_lb_listener.http.arn
}

output "alb_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "alb_sg_id" {
  value = (
    length(var.security_group_ids) == 0
    ? aws_security_group.alb_sg[0].id
    : var.security_group_ids[0]
  )
}

output "security_group_ids" {
  description = "ALB Security Group IDs"
  value = [for sg in aws_security_group.alb_sg : sg.id]
}

