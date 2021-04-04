#Create AWS VPC
resource "aws_vpc" "mytestvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "mytestvpc"
  }
}

# Public Subnets in Custom VPC
resource "aws_subnet" "mytestvpc-public-1" {
  vpc_id                  = aws_vpc.mytestvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"

  tags = {
    Name = "mytestvpc-public-1"
  }
}

resource "aws_subnet" "mytestvpc-public-2" {
  vpc_id                  = aws_vpc.mytestvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "mytestvpc-public-2"
  }
}

resource "aws_subnet" "mytestvpc-public-3" {
  vpc_id                  = aws_vpc.mytestvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2c"

  tags = {
    Name = "mytestvpc-public-3"
  }
}

# Private Subnets in Custom VPC
resource "aws_subnet" "mytestvpc-private-1" {
  vpc_id                  = aws_vpc.mytestvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2a"

  tags = {
    Name = "mytestvpc-private-1"
  }
}

resource "aws_subnet" "mytestvpc-private-2" {
  vpc_id                  = aws_vpc.mytestvpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "mytestvpc-private-2"
  }
}

resource "aws_subnet" "mytestvpc-private-3" {
  vpc_id                  = aws_vpc.mytestvpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2c"

  tags = {
    Name = "mytestvpc-private-3"
  }
}

# Custom internet Gateway
resource "aws_internet_gateway" "mytest-gw" {
  vpc_id = aws_vpc.mytestvpc.id

  tags = {
    Name = "mytest-gw"
  }
}

#Routing Table for the Custom VPC
resource "aws_route_table" "mytest-public" {
  vpc_id = aws_vpc.mytestvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mytest-gw.id
  }

  tags = {
    Name = "mytest-public-1"
  }
}

resource "aws_route_table_association" "mytest-public-1-a" {
  subnet_id      = aws_subnet.mytestvpc-public-1.id
  route_table_id = aws_route_table.mytest-public.id
}

resource "aws_route_table_association" "mytest-public-2-a" {
  subnet_id      = aws_subnet.mytestvpc-public-2.id
  route_table_id = aws_route_table.mytest-public.id
}

resource "aws_route_table_association" "mytest-public-3-a" {
  subnet_id      = aws_subnet.mytestvpc-public-3.id
  route_table_id = aws_route_table.mytest-public.id
}
