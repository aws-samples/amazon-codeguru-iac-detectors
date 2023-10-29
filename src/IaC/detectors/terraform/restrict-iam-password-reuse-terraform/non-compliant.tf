#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=restrict-iam-password-reuse-terraform@v1.0 defects=1}
resource "aws_iam_account_password_policy" "pike" {
  allow_users_to_change_password = false
  hard_expiry                    = true
  max_password_age               = 90
  minimum_password_length        = 14
  # Noncompliant: `password_reuse_prevention` is less than 24.
  password_reuse_prevention      = 10
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
}
# {/fact}