#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=conf-https-cloudfront-policy-terraform@v1.0 defects=0}
resource "aws_cloudfront_distribution" "cf" {
  origin_group {
    origin_id = "groupS3"

    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }

    member {
      origin_id = "primaryS3"
    }

    member {
      origin_id = "failoverS3"
    }
  }
  origin {
    domain_name = aws_s3_bucket.statics.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  aliases = [data.aws_route53_zone.selected.name]
  default_cache_behavior {
    allowed_methods        = []
    cached_methods         = []
    target_origin_id       = ""
    # Compliant: `viewer_protocol_policy` is set to `redirect-to-https`.
    viewer_protocol_policy = "redirect-to-https"
  }
  restrictions {
    geo_restriction {
      restriction_type = ""
    }
  }
  viewer_certificate {
    acm_certificate_arn = "aws_acm_certificate_arn"
    minimum_protocol_version = "TLSv1.2_2018"
  }
  default_cache_behavior {
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.simple_cors.id
  }
  web_acl_id = aws_wafv2_web_acl.waf_cloudfront
  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }
  origin {
    domain_name = aws_s3_bucket.primary.bucket_regional_domain_name
    origin_id   = "primaryS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }
}
resource "aws_wafv2_web_acl_logging_configuration" "pike" {
  resource_arn            = aws_wafv2_web_acl.waf_cloudfront.arn
  log_destination_configs = ["arn:aws:logs:eu-west-2:680235478471:log-group:pike/"]
}
resource "aws_wafv2_web_acl" "waf_cloudfront" {
  name        = "managed-rule-example"
  description = "Example of a managed rule."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"

        excluded_rule {
          name = "rule-1"
        }

        scope_down_statement {
          geo_match_statement {
            country_codes = ["US", "NL"]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "rule-2"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"

        excluded_rule {
          name = "SizeRestrictions_QUERYSTRING"
        }

        scope_down_statement {
          geo_match_statement {
            country_codes = ["US", "NL"]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }


  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}
data "aws_cloudfront_response_headers_policy" "simple_cors" {
  name = "SimpleCORS"
}
# {/fact}