#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=restrict-iam-asterisk-action-terraform@v1.0 defects=1}
data "aws_iam_policy_document" "policy" {
  version = "2012-10-17"

  # Compliant: This IAM policy restricts administrative privileges.
  statement {
    actions = ["*"]
    effect  = "Allow"
    resources = [
      "*"
    ]
  }
}
# {/fact}