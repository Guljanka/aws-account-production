terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical (official Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "prod" {
  default = true
  }


data "aws_security_group" "app_sg" {
      id = var.security_group_id
}


resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [
    data.aws_security_group.app_sg.id
  ]

  tags = {
    Name        = "prod-app-server"
    Team        = "app"
    Environment = "production"
  }
}
