provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "strapi_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "strapi-vpc"
  }
}

# Subnet
resource "aws_subnet" "strapi_subnet" {
  vpc_id            = aws_vpc.strapi_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "strapi-subnet"
  }
}

# Security Group
resource "aws_security_group" "strapi_sg" {
  vpc_id = aws_vpc.strapi_vpc.id
  name   = "strapi_sg"

  description = "This group is for strapi"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "strapi-sg"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "strapi_igw" {
  vpc_id = aws_vpc.strapi_vpc.id

  tags = {
    Name = "strapi-igw"
  }
}

# Route Table
resource "aws_route_table" "strapi_route_table" {
  vpc_id = aws_vpc.strapi_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.strapi_igw.id
  }

  tags = {
    Name = "strapi-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "strapi_rta" {
  subnet_id      = aws_subnet.strapi_subnet.id
  route_table_id = aws_route_table.strapi_route_table.id
}

# EC2 Instance
resource "aws_instance" "strapi" {
  ami                    = "ami-04b70fa74e45c3917" # Update with your preferred AMI ID
  instance_type          = "t3.medium"
  key_name               = "pearl"
  subnet_id              = aws_subnet.strapi_subnet.id
  security_groups        = [aws_security_group.strapi_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nodejs npm
              sudo npm install -g pm2
              curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
              sudo apt-get install -y nodejs
              EOF

  tags = {
    Name = "Strapi-Instance"
  }
}

# Output the instance public IP
output "instance_ip" {
  value = aws_instance.strapi.public_ip
}
