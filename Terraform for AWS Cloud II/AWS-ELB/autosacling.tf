#AutoScaling Launch Configuration
resource "aws_launch_configuration" "mytest-launchconfig" {
  name_prefix     = "mytest-launchconfig"
  image_id        = lookup(var.AMIS, var.AWS_REGION)
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.mytest_key.key_name
  security_groups = [aws_security_group.mytest-instance.id]
  user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"

  lifecycle {
    create_before_destroy = true
  }
}

#Generate Key
resource "aws_key_pair" "mytest_key" {
    key_name = "mytest_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Autoscaling Group
resource "aws_autoscaling_group" "mytest-autoscaling" {
  name                      = "mytest-autoscaling"
  vpc_zone_identifier       = [aws_subnet.mytestvpc-public-1.id, aws_subnet.mytestvpc-public-2.id]
  launch_configuration      = aws_launch_configuration.mytest-launchconfig.name
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 200
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.mytest-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "MyTest Custom EC2 instance via LB"
    propagate_at_launch = true
  }
}

output "ELB" {
  value = aws_elb.mytest-elb.dns_name
}