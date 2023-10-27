#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: Apache-2.0

# {fact rule=exposed-ec2-user-data-secret-terraform@v1.0 defects=1}
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
  # Noncompliant: Hard-coded secrets exist in EC2 user data.
  user_data = <<EOF
  #! /bin/bash
  sudo apt-get update
  sudo apt-get install -y apache2
  sudo systemctl start apache2
  sudo systemctl enable apache2
  export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
  export AWS_SECRET_ACCESS_KEY=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
  export AWS_DEFAULT_REGION=us-west-2
  echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = local.tags
}
# {/fact}