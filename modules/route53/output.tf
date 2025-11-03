output "zone_id" {
  description = "Route53 Hosted Zone ID"
  value       = local.zone_id
}

output "alb_record_fqdn" {
  value       = try(aws_route53_record.alb_record[0].fqdn, null)
  description = "ALB DNS record"
}

output "cloudfront_record_fqdn" {
  value       = try(aws_route53_record.cloudfront_record[0].fqdn, null)
  description = "CloudFront DNS record"
}

output "wildcard_record_fqdn" {
  value       = try(aws_route53_record.wildcard[0].fqdn, null)
  description = "Wildcard DNS record"
}

output "health_check_id" {
  value       = try(aws_route53_health_check.alb_health_check[0].id, null)
  description = "Health Check ID"
}
