#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=avoid-hardcoded-credentials-terraform@v1.0 defects=0}
provider "aws" {
  # Compliant: No hard coded AWS access key and secret key exists in provider.
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.AWS_DEFAULT_REGION
}
# {/fact}