terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# -------------------------------
# Optional: IP Set for custom blocking
# -------------------------------
resource "aws_wafv2_ip_set" "blocked_ips" {
  count              = length(var.blocked_ip_addresses) > 0 ? 1 : 0
  name               = "${var.project_name}-blocked-ips"
  scope              = var.waf_scope
  ip_address_version = "IPV4"
  addresses          = var.blocked_ip_addresses

  tags = merge(var.tags, {
    Name = "${var.project_name}-blocked-ips"
  })
}

# -------------------------------
# WAFv2 Web ACL
# -------------------------------
resource "aws_wafv2_web_acl" "this" {
  name        = "${var.project_name}-waf"
  description = "Managed Web ACL for ${var.project_name}"
  scope       = var.waf_scope  # REGIONAL (ALB) or CLOUDFRONT (Global)
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-waf"
    sampled_requests_enabled   = true
  }

  # -------------------------------
  # Managed AWS Rule Groups
  # -------------------------------
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 10
    override_action { 
      none {} 
      }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRules"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 20
    override_action { 
      none {} 
      }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputs"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 30
    override_action { 
      none {} 
      }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPReputation"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 40
    override_action { 
      none {} 
      }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesSQLiRuleSet"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLInjection"
      sampled_requests_enabled   = true
    }
  }

  # -------------------------------
  # Custom IP block rule (optional)
  # -------------------------------
  dynamic "rule" {
    for_each = length(var.blocked_ip_addresses) > 0 ? [1] : []
    content {
      name     = "CustomBlockedIPs"
      priority = 50
      action {
        block {}
      }
      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.blocked_ips[0].arn
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "BlockedIPs"
        sampled_requests_enabled   = true
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-waf"
  })
}

# -------------------------------
# WAF Web ACL Association (optional)
# -------------------------------


resource "aws_wafv2_web_acl_association" "alb_association" {
  count        = var.create_alb_association ? 1 : 0

  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
