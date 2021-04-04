#Define External IP 
resource "aws_eip" "mytest-nat" {
  vpc = true
}

resource "aws_nat_gateway" "mytest-nat-gw" {
  allocation_id = aws_eip.mytest-nat.id
  subnet_id     = aws_subnet.mytestvpc-public-1.id
  depends_on    = [aws_internet_gateway.mytest-gw]
}

resource "aws_route_table" "mytest-private" {
  vpc_id = aws_vpc.mytestvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mytest-nat-gw.id
  }

  tags = {
    Name = "mytest-private"
  }
}

# route associations private
resource "aws_route_table_association" "level-private-1-a" {
  subnet_id      = aws_subnet.mytestvpc-private-1.id
  route_table_id = aws_route_table.mytest-private.id
}

resource "aws_route_table_association" "level-private-1-b" {
  subnet_id      = aws_subnet.mytestvpc-private-2.id
  route_table_id = aws_route_table.mytest-private.id
}

resource "aws_route_table_association" "level-private-1-c" {
  subnet_id      = aws_subnet.mytestvpc-private-3.id
  route_table_id = aws_route_table.mytest-private.id
}