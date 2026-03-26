data "aws_vpc" "existing" {
  count   = var.use_existing_vpc ? 1 : 0
  default = true
}

resource "aws_vpc" "new" {
  count      = var.use_existing_vpc ? 0 : 1
  cidr_block = "10.0.0.0/16"
}

locals {
  vpc_id = var.use_existing_vpc ? data.aws_vpc.existing[0].id : aws_vpc.new[0].id
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}
locals {
  is_production          = var.environment == "production"
  instance_type          = local.is_production ? "t3.small" : "t3.micro"
  min_size               = local.is_production ? 3 : 1
  max_size               = local.is_production ? 10 : 3
  enable_monitoring      = local.is_production
  deletion_policy        = local.is_production ? "Retain" : "Delete"
  instance_ingress_ports = toset([tostring(var.server_port)])
}

resource "aws_launch_template" "example" {
  name_prefix   = "${var.cluster_name}-"
  image_id      = var.ami
  instance_type = local.instance_type

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  min_size = local.min_size
  max_size = local.max_size
  vpc_zone_identifier = data.aws_subnets.default.ids

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"
}

resource "aws_security_group_rule" "inbound" {
  for_each          = local.instance_ingress_ports
  type              = "ingress"
  security_group_id = aws_security_group.instance.id
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = local.enable_monitoring ? 1 : 0

  alarm_name          = "${var.cluster_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU utilization exceeded 80%"
}