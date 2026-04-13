resource "aws_ecs_cluster" "main" {
  name = "terraform-lab-cluster"
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "ecs-lt-"
  image_id      = "ami-0c24db5dfa17078a6" # Pastikan AMI ini benar untuk region Singapore
  instance_type = "t3.micro"
  iam_instance_profile { name = aws_iam_instance_profile.ecs_node.name }

  user_data = base64encode("#!/bin/bash\necho ECS_CLUSTER=terraform-lab-cluster >> /etc/ecs/ecs.config")
}

resource "aws_autoscaling_group" "ecs_asg" {
  vpc_zone_identifier = [aws_subnet.subnet_a.id]
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
}