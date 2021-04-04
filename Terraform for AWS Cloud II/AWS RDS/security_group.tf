#Security Group for mytestvpc
resource "aws_security_group" "allow-mytest-ssh" {
  vpc_id      = aws_vpc.mytestvpc.id
  name        = "allow-mytest-ssh"
  description = "security group that allows ssh connection"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "allow-mytest-ssh"
  }
}

#Security Group for MariaDB
resource "aws_security_group" "allow-mariadb" {
  vpc_id      = aws_vpc.mytestvpc.id
  name        = "allow-mariadb"
  description = "security group for Maria DB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.allow-mytest-ssh.id]
  }
  
  tags = {
    Name = "allow-mariadb"
  }
}