terraform {
  cloud {
    organization = "carmel-test"
    workspaces {
      name = "test-terraform-aws"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = var.region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_security_group" "my_security_group" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

resource "aws_instance" "app_server" {
  user_data = base64encode(templatefile("userdata.tpl", { IMG_TAG = var.IMAGE_TAG,
    ECR_REPOSITORY = "name",
  REGION = var.region }))
  user_data_replace_on_change = true
  key_name                    = var.key_name
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.my_security_group.id]
  tags                        = local.tags
}
