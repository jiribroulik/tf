#AutoScaling Launch Configuration
resource "aws_launch_configuration" "mytest-launchconfig" {
  name_prefix     = "mytest-launchconfig"
  image_id        = lookup(var.AMIS, var.AWS_REGION)
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.mytest_key.key_name
}

#Generate Key
resource "aws_key_pair" "mytest_key" {
    key_name = "mytest_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Autoscaling Group
resource "aws_autoscaling_group" "mytest-autoscaling" {
  name                      = "mytest-autoscaling"
  vpc_zone_identifier       = ["subnet-9e0ad9f5", "subnet-d7a6afad"]
  launch_configuration      = aws_launch_configuration.mytest-launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 200
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "MyTest Custom EC2 instance"
    propagate_at_launch = true
  }
}

#Autoscaling Configuration policy - Scaling Alarm
resource "aws_autoscaling_policy" "mytest-cpu-policy" {
  name                   = "mytest-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.mytest-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}

#Auto scaling Cloud Watch Monitoring
resource "aws_cloudwatch_metric_alarm" "mytest-cpu-alarm" {
  alarm_name          = "mytest-cpu-alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.mytest-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.mytest-cpu-policy.arn]
}

#Auto Descaling Policy
resource "aws_autoscaling_policy" "mytest-cpu-policy-scaledown" {
  name                   = "mytest-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.mytest-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}

#Auto descaling cloud watch 
resource "aws_cloudwatch_metric_alarm" "mytest-cpu-alarm-scaledown" {
  alarm_name          = "mytest-cpu-alarm-scaledown"
  alarm_description   = "Alarm once CPU Uses Decrease"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.mytest-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.mytest-cpu-policy-scaledown.arn]
}