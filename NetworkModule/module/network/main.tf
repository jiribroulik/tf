#AWS VPC Resource
resource "aws_vpc" "mytest_vpc" {
  cidr_block            = var.cidr_vpc
  enable_dns_support    = true
  enable_dns_hostnames  = true
  
  tags = {
    Environment         = var.environment_tag
  }
}

#AWS Internet Gateway
resource "aws_internet_gateway" "mytest_igw" {
  vpc_id        = aws_vpc.mytest_vpc.id
  
  tags = {
    Environment = var.environment_tag
  }
}

# AWS Subnet for VPC
resource "aws_subnet" "subnet_public" {
  vpc_id                    = aws_vpc.mytest_vpc.id
  cidr_block                = var.cidr_subnet
  map_public_ip_on_launch   = "true"
  availability_zone         = var.availability_zone
  
  tags = {
    Environment             = var.environment_tag
  }
}

# AWS Route Table
resource "aws_route_table" "mytest_rtb_public" {
  vpc_id            = aws_vpc.mytest_vpc.id

  route {
      cidr_block    = "0.0.0.0/0"
      gateway_id    = aws_internet_gateway.mytest_igw.id
  }

  tags = {
    Environment     = var.environment_tag
  }
}

# AWS Route Association 
resource "aws_route_table_association" "mytest_rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.mytest_rtb_public.id
}

# AWS Security group
resource "aws_security_group" "mytest_sg_22" {
  name = "mytest_sg_22"
  vpc_id = aws_vpc.mytest_vpc.id

  # SSH access from the VPC
  ingress {
      from_port     = 22
      to_port       = 22
      protocol      = "tcp"
      cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Environment     = var.environment_tag
  }
}