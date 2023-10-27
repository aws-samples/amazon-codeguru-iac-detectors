#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=disabled-s3-versioning-terraform@v1.0 defects=1}
resource "aws_s3_bucket" "exampletest" {
  bucket = "pike-680235478471"
  expected_bucket_owner = "680235478471"
  # Noncompliant: S3 bucket have versioning disabled.
  versioning {
    enabled = false
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = var.bla
      }
    }
  }
  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "foobar"
      status = var.replication_enabled

      filter {
        tags = {}
      }
      destination {
        bucket        = aws_s3_bucket.destination.arn
        storage_class = "STANDARD"

        replication_time {
          status  = "Enabled"
          minutes = 15
        }

        metrics {
          status  = "Enabled"
          minutes = 15
        }
      }
    }
  }
}
resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.exampletest.id
  target_bucket = aws_s3_bucket.exampletest.id
  target_prefix = "log/"
}
resource "aws_s3_bucket_public_access_block" "access_good_1" {
  bucket = aws_s3_bucket.exampletest.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_lifecycle_configuration" "pass" {
  bucket = aws_s3_bucket.exampletest.id

  rule {
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
    filter {}
    id = "log"
    status = "Enabled"
  }
}
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.exampletest.id

  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}
# {/fact}