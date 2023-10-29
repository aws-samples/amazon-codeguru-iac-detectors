#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=restrict-public-ip-ec2-terraform@v1.0 defects=1}
resource "aws_instance" "public_ins" {
  ami           = "ami-0130bec6e5047f596"
  instance_type = "t3.nano"
# Noncompliant: `associate_public_ip_address` is set to true.
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.publicly_accessible_sg.id]
  subnet_id                   = aws_subnet.nondefault_1.id
  iam_instance_profile        = aws_iam_instance_profile.example_instance_profile.name
  monitoring                  = true
  ebs_optimized               = true

  metadata_options {
    http_tokens        = "required"
    http_endpoint      = "disabled"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }
# {/fact}