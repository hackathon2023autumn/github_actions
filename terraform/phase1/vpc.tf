provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "aws-and-infra-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "aws-and-infra-vpc"
  }
}

resource "aws_subnet" "aws-and-infra-public-subnet-1a" {
  vpc_id     = aws_vpc.aws-and-infra-vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-and-infra-public-subnet-1a"
  }
}

# resource "aws_subnet" "aws-and-infra-public-subnet-1c" {
#   vpc_id     = aws_vpc.aws-and-infra-vpc.id
#   cidr_block = "10.0.11.0/24"
#   availability_zone = "ap-northeast-1c"
#   tags = {
#     Name = "aws-and-infra-public-subnet-1c"
#   }
# }

resource "aws_subnet" "aws-and-infra-private-subnet-1a" {
  vpc_id     = aws_vpc.aws-and-infra-vpc.id
  cidr_block = "10.0.20.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-and-infra-private-subnet-1a"
  }
}

resource "aws_subnet" "aws-and-infra-private-subnet-1c" {
  vpc_id     = aws_vpc.aws-and-infra-vpc.id
  cidr_block = "10.0.21.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "aws-and-infra-private-subnet-1c"
  }
}

resource "aws_internet_gateway" "aws-and-infra-igw" {
  vpc_id = aws_vpc.aws-and-infra-vpc.id

  tags = {
    Name = "aws-and-infra-igw"
  }
}

resource "aws_route_table" "aws-and-infra-public-route" {
  vpc_id = aws_vpc.aws-and-infra-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-and-infra-igw.id
  }

  tags = {
    Name = "aws-and-infra-public-route"
  }
}

resource "aws_route_table_association" "aws-and-infra_table_association-1a" {
  subnet_id = aws_subnet.aws-and-infra-public-subnet-1a.id
  route_table_id = aws_route_table.aws-and-infra-public-route.id
}

# resource "aws_route_table_association" "aws-and-infra_table_association-1c" {
#   subnet_id = aws_subnet.aws-and-infra-public-subnet-1c.id
#   route_table_id = aws_route_table.aws-and-infra-public-route.id
# }

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.aws-and-infra-vpc.id
  sensitive = true
}

output "public_subnet_1a_id"{
    description = "The ID of the aws-and-infra-public-subnet-1a"
    value       = aws_subnet.aws-and-infra-public-subnet-1a.id
    sensitive = true
}

output "aws_instance_1a_id"{
    description = "The ID of the aws_instance_1a"
    value       = aws_instance.aws-and-infra-web-1a.id
    sensitive = true
}