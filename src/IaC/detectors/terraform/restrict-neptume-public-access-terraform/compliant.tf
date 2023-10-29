#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=restrict-neptume-public-access-terraform@v1.0 defects=0}
resource "aws_neptune_cluster_instance" "neptune_instance" {
  count              = 2
  cluster_identifier = aws_neptune_cluster.encrypted_neptune_cluster.cluster_identifier
  engine             = "neptune"
  instance_class     = "db.r4.large"
  apply_immediately  = true
  # Compliant: Neptune Cluster instance is not publicly available.
  publicly_accessible = false
}
# {/fact}