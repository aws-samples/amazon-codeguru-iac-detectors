#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=configure-tls-elb-terraform@v1.0 defects=0}
resource "aws_lb_listener" "lb_listener_test" {
  load_balancer_arn = aws_lb.alb_test.arn
  port              = "80"
  protocol          = "HTTPS"
  # Compliant: load balancer is using at least TLS 1.2 .
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
# {/fact}