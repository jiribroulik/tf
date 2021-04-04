output "public_instance_ip" {
  value = ["${aws_instance.mytest_instance.public_ip}"]
}