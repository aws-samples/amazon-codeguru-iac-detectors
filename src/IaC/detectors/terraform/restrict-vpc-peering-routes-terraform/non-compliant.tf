#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=restrict-vpc-peering-routes-terraform@v1.0 defects=1}
resource "aws_route" "igw" {
  route_table_id         = aws_vpc.vpc.default_route_table_id
  # Noncompliant: VPC peering contains routes overly permissive to all traffic.
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  vpc_peering_connection_id = "pcx-45ff3dc1"
}
# {/fact}