#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=exposed-ec2-user-data-secret-terraform@v1.0 defects=0}
resource "aws_instance" "chroma_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = "chroma-keypair"
  security_groups = [aws_security_group.chroma_sg.name]
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  monitoring = true
  ebs_optimized = true
  ebs_block_device {
    volume_type = "gp2"
    volume_size = var.ebs_volume_size
    device_name = "/dev/xvdb"
    encrypted   = true
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = var.root_volume_size
    encrypted   = true
  }
  iam_instance_profile = "test"
  # Compliant: Hard-coded secrets don't exist in EC2 user data.
  tags = local.tags
}
# {/fact}