#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=disabled-neptune-logging-terraform@v1.0 defects=1}
resource "aws_neptune_cluster" "test" {
  # Noncompliant: Neptune logging is not enabled.
  cluster_identifier                  = "neptune-cluster-demo"
  engine                              = "neptune"
  backup_retention_period             = 5
  preferred_backup_window             = "07:00-09:00"
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true
  apply_immediately                   = true
  storage_encrypted                   = true
  deletion_protection                 = true
  kms_key_arn                         = aws_kms_key.pike.arn
}
# {/fact}