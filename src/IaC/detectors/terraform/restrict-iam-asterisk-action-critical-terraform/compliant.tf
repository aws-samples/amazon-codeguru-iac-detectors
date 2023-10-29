#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=restrict-iam-asterisk-action-critical-terraform@v1.0 defects=0}
resource "aws_iam_policy" "LambdaDynamoDBPolicy" {
  name        = "LambdaDynamoDBPolicy"
  description = "IAM policy for Lambda function to access DynamoDB"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowDynamodbReadWrite"
        Effect = "Allow"
        # Compliant: IAM policy actions are specified.
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
        ]
        Resource = aws_dynamodb_table.IdempotencyTable.arn
      },
    ]
  })
}
# {/fact}