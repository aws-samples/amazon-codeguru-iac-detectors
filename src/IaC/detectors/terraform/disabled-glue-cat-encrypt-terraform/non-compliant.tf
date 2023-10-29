#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=disabled-glue-cat-encrypt-terraform@v1.0 defects=1}
resource "aws_glue_data_catalog_encryption_settings" "examplea" {
  data_catalog_encryption_settings {
    connection_password_encryption {
      aws_kms_key_id = var.kms_key.id
      return_connection_password_encrypted = true
    }

    # Noncompliant: Glue Data Catalog Encryption is not enabled.
    encryption_at_rest {
      catalog_encryption_mode = ""
      sse_aws_kms_key_id = var.kms_key.id
    }
  }
}
# {/fact}