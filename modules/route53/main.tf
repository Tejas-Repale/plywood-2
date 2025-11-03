###############################################
# Route 53 Hosted Zone (Optional)
###############################################

resource "aws_route53_zone" "this" {
  count = var.create_hosted_zone ? 1 : 0
  name  = var.domain_name
  tags  = var.tags
}

locals {
  zone_id = var.create_hosted_zone ? aws_route53_zone.this[0].zone_id : var.existing_zone_id
}

####################################################
# ALB DNS Record (Alias)
####################################################

resource "aws_route53_record" "alb_record" {
  count = var.create_records ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.alb_record_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}


####################################################
# CloudFront DNS Record
####################################################

resource "aws_route53_record" "cloudfront_record" {
  count = var.create_cloudfront_record ? 1 : 0

  zone_id = local.zone_id
  name    = var.cloudfront_record_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [
    aws_route53_zone.this
  ]
}

####################################################
# Wildcard Subdomain Support (*.example.com)
####################################################

resource "aws_route53_record" "wildcard" {
  count = var.enable_wildcard ? 1 : 0

  zone_id = local.zone_id
  name    = "*.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

  depends_on = [
    aws_route53_zone.this
  ]
}

####################################################
# Health Check (Optional)
####################################################

resource "aws_route53_health_check" "alb_health_check" {
  count = var.enable_health_check ? 1 : 0

  type                            = "HTTPS"
  resource_path                   = "/"
  fqdn                            = var.health_check_domain
  failure_threshold               = 3
  request_interval                = 30
  measure_latency                 = true
  insufficient_data_health_status = "Healthy"
  regions                         = var.health_check_regions

  tags = var.tags
}

####################################################
# Failover Record (Optional)
####################################################

resource "aws_route53_record" "failover_record" {
  count = var.enable_failover ? 1 : 0

  zone_id = local.zone_id
  name    = var.failover_domain
  type    = "A"

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "primary-alb"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.alb_health_check[0].id

  depends_on = [
    aws_route53_health_check.alb_health_check
  ]
}
