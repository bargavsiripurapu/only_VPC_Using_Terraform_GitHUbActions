
# ASG with Launch template
resource "aws_instance" "web" {
  count = length(var.ec2_names)
  ami           = data.aws_ami.amazon-2.id
  instance_type = "t2.micro"
  #user_data     = filebase64("user_data.sh")
  associate_public_ip_address = true
  vpc_security_group_ids = [var.sg_id]
  subnet_id = var.subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
ebs_block_device {
    device_name           = "/dev/sdh" # or another appropriate device name
    volume_size           = 20 # specify the size of the volume in GiB
    volume_type           = "gp2" # specify the volume type (gp2, io1, io2, etc.)
    delete_on_termination = true # specify whether the volume should be deleted on instance termination
  }

  tags = {
    Name = var.ec2_names[count.index]
  }
}

resource "aws_autoscaling_group" "aws_asg" {
  # no of instances
  desired_capacity = 3
  max_size         = 5
  min_size         = 2

  # Connect to the target group
  target_group_arns = [aws_lb_target_group.tg.arn]
  vpc_zone_identifier  = var.subnets[count.index]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true
  }
}
