terraform {
  backend "s3" {
    bucket         = "my-terraform-backend-2025"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}

data "aws_subnet" "default_subnet" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  filter {
    name   = "availability-zone"
    values = [var.availability_zone]
  }
}

resource "tls_private_key" "web_app_key" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "web_app_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.web_app_key.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = "${path.module}/${var.private_key_filename}"
  content         = tls_private_key.web_app_key.private_key_pem
  file_permission = "0400"
}

module "security_group" {
  source              = "../../modules/security_group"
  security_group_name = "dev-web-app-sg"
}

module "ec2" {
  source           = "../../modules/ec2"
  subnet_id = data.aws_subnet.default_subnet.id 
  ami_id           = "ami-0e1bed4f06a3b463d"
  instance_type    = "t2.micro"
  key_name         = aws_key_pair.web_app_key_pair.key_name
  security_group_id = module.security_group.security_group_id
  instance_name    = "dev-web-app"
}
