

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# data "aws_key_pair" "existing_key" {
#   key_name = "clixxkeynew"
# }


data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["AWS_DEFAULT_VPC"]
  }
}


resource "aws_security_group" "sg_22_80" {
  name   = "testSG"
  vpc_id = data.aws_vpc.existing_vpc.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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
}

data "aws_ami" "stack" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["stack-ami-golden-*"]
  }
}


data "aws_subnet" "stack_subnet" {
  filter {
    name   = "tag:Name"
    values = ["Defualt_Subnet"]
  }
}
resource "aws_instance" "application_server" {
  ami                         = data.aws_ami.stack.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.stack_subnet.id
  vpc_security_group_ids      = [aws_security_group.sg_22_80.id]
  associate_public_ip_address = true
  key_name = "clixxkeynew"

  tags = {
    Name = "Test_Instance"
  }
}

output "public_ip" {
  value = aws_instance.application_server.public_ip
}