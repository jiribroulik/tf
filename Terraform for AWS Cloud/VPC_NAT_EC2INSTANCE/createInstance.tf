
resource "aws_key_pair" "mytest_key" {
    key_name = "mytest_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mytest_key.key_name

  vpc_security_group_ids = [aws_security_group.allow-mytest-ssh.id]
  subnet_id = aws_subnet.mytestvpc-public-2.id

  tags = {
    Name = "custom_instance"
  }

}