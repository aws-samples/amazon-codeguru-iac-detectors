#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=restrict-eks-traffic-access-terraform@v1.0 defects=1}
resource "aws_eks_cluster" "test" {
  name = "test"
  role_arn = aws_iam_role.eksrole.arn
  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id]
    # Noncompliant: `endpoint_public_access` is set to True.
    endpoint_public_access = True
  }
}
# {/fact}