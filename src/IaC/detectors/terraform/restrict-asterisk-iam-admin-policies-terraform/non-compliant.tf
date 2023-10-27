#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=restrict-asterisk-iam-admin-policies-terraform@v1.0 defects=1}
data "aws_iam_policy_document" "policy" {
  version = "2012-10-17"

  # Noncompliant: This IAM policy allows full "*-*" administrative privileges.
  statement {
    actions = ["*"]
    effect  = "Allow"
    resources = [
      "*"
    ]
  }
}
# {/fact}