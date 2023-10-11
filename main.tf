terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }

  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}


resource "aws_vpc" "splunk_vpc" {
  cidr_block           = "10.10.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "splunk-vpc"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.splunk_vpc.id
  cidr_block              = "10.10.5.0/24"
  availability_zone       = "us-east-1a"  # Change to your desired AZ
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.splunk_vpc.id
  cidr_block              = "10.10.6.0/24"
  availability_zone       = "us-east-1b"  # Change to your desired AZ
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.splunk_vpc.id
  cidr_block = "10.10.7.0/24"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.splunk_vpc.id
  cidr_block = "10.10.8.0/24"
  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_security_group" "splunk_sg" {
 vpc_id = aws_vpc.splunk_vpc.id
  name_prefix = "splunk-sg-"
  description = "Security group for Splunk"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "splunk_instance" {
  ami           = "ami-0bb4c991fa89d4b9b"  # Replace with the correct AMI ID
  instance_type = "t2.small"
  key_name      = "ec2-demo"  # Replace with your key name
  subnet_id     = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.splunk_sg.id]
  user_data = file("setup.sh")
              
}



