data "aws_vpc" "existing" {
  count   = var.use_existing_vpc ? 1 : 0
  default = true
}

resource "aws_vpc" "new" {
  count      = var.use_existing_vpc ? 0 : 1
  cidr_block = "10.0.0.0/16"

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-vpc"
  })
}

locals {
  vpc_id = var.use_existing_vpc ? data.aws_vpc.existing[0].id : aws_vpc.new[0].id
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }

  filter {
    name   = "availabilityZone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  }
}

locals {
  # Environment flags
  is_production          = var.environment == "production"
  instance_type          = local.is_production ? "t3.small" : "t3.micro"
  min_size               = local.is_production ? 3 : 1
  max_size               = local.is_production ? 10 : 3
  enable_monitoring      = local.is_production
  deletion_policy        = local.is_production ? "Retain" : "Delete"
  instance_ingress_ports = toset([tostring(var.server_port)])

  # Common tags applied to every resource
  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project_name
    Owner       = var.team_name
  }
}

resource "aws_launch_template" "example" {
  name_prefix   = "${var.cluster_name}-"
  image_id      = var.ami
  instance_type = local.instance_type
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.instance.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Hello, World V3" > /tmp/index.html
              cd /tmp
              nohup python3 -m http.server ${var.server_port} &
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${var.cluster_name}-instance"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-launch-template"
  })
}

resource "aws_autoscaling_group" "example" {
  min_size            = local.min_size
  max_size            = local.max_size
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

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"
  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-sg"
  })
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
resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  security_group_id = aws_security_group.instance.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
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
  alarm_actions       = [aws_sns_topic.alerts[0].arn]

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-high-cpu-alarm"
  })
}

resource "aws_sns_topic" "alerts" {
  count = local.enable_monitoring ? 1 : 0
  name  = "${var.cluster_name}-alerts"

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-alerts-topic"
  })
}

resource "aws_sns_topic_subscription" "alerts_email" {
  count     = local.enable_monitoring ? 1 : 0
  topic_arn = aws_sns_topic.alerts[0].arn
  protocol  = "email"
  endpoint  = var.alert_email
}
 data "aws_instances" "running" {
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [aws_autoscaling_group.example]
}