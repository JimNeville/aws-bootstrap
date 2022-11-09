terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.1.6"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "instance_security_group" {
  name        = "allow_inbound"
  description = "Allow inbound traffic"

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.project_name
  }
}

resource "aws_iam_role" "instance_role" {
  name = var.project_name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  managed_policy_arns = ["arn:aws:iam::aws:policy/CloudWatchFullAccess", "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })


  tags = {
    Name = var.project_name
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.project_name
  role = aws_iam_role.instance_role.name
}

resource "aws_instance" "app_server" {
  ami           = var.instance_ami
  instance_type = "t2.micro"
  monitoring = true
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  security_groups = [aws_security_group.instance_security_group.name]
  vpc_security_group_ids = [aws_security_group.instance_security_group.id]
  #user_data = data.sh

  timeouts {
    create = "10m"
  }
  tags = {
    Name = var.project_name
  }
}