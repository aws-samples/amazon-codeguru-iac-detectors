#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=secure-dms-endpoints-terraform@v1.0 defects=1}
data "aws_iam_policy_document" "task_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    # Noncompliant: IAM policies documents used "*" as a statement's action.
    actions = [
      "*"
    ]
    resources = [
      "arn:aws:s3:::my_corporate_bucket/*",
    ]
  }
}
# {/fact}