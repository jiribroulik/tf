#Create AWS S3 Bucket

resource "aws_s3_bucket" "mytest-s3bucket" {
  bucket = "mytest-bucket-141"
  acl    = "private"

  tags = {
    Name = "mytest-bucket-141"
  }
}

