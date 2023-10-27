#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=unencrypted-ebs-volumes-terraform@v1.0 defects=0}
resource "aws_launch_configuration" "demo" {
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.demo-node.name
  image_id = data.aws_ami.eks-worker.id
  instance_type = "t2.large"
  name_prefix = "terraform-eks-demo"
  security_groups = [aws_security_group.demo-node.id]
  user_data_base64 = base64encode(local.demo-node-userdata)
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  # Compliant: All data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted.
  root_block_device {
    encrypted     = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
# {/fact}