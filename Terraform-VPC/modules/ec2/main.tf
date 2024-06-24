resource "aws_instance" "web" {
  count = length(var.ec2_names)
  ami           = data.aws_ami.amazon-2.id
  instance_type = "t2.micro"
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

# Auto Scaling Group
resource "aws_autoscaling_group" "auto_scaling_group" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.subnets
  target_group_arns = [aws_lb_target_group.tg.arn]
  
  tag {
    key                 = "Name"
    value               = var.ec2_names[0] # Assuming all instances will have the same name tag for simplicity
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
