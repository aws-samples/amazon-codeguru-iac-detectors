#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=restrict-iam-admin-policy-terraform@v1.0 defects=1}
resource "aws_iam_policy" "ec2_pricing" {
  name        = "ec2_pricing"
  description = "allow access to ec2 instance types and pricing information"
  path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    # Noncompliant: IAM policies that allow full "*-*" administrative privileges is created.
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "*"
        ],
        Resource = "*"
      }
    ]
  })
  tags = {
    Terraformed = "true"
  }
}
# {/fact}