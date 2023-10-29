#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=public-write-s3-bucket-terraform@v1.0 defects=0}
resource "aws_s3_bucket" "private-bucket" {
  provider = aws.west
  bucket = aws_s3_bucket.bucket_bad_1.id
  # Noncompliant: ACL defined which does not allow public WRITE access.
  acl = "private"
  versioning {
    enabled = true
  }
  replication_configuration {
    role = aws_iam_role.replication.arn
    rules {
      id     = "foobar"
      prefix = "foo"
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.destination.arn
        storage_class = "STANDARD"
      }
    }
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = var.bla
      }
    }
  }
  lifecycle_rule {
    id = "Delete old incomplete multi-part uploads"
    enabled = true
    abort_incomplete_multipart_upload_days = 7
  }
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.private-bucket.id

  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}
resource "aws_s3_bucket_public_access_block" "access_good_1" {
  bucket = aws_s3_bucket.private-bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
# {/fact}