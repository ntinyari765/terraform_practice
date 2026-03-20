provider "aws" {
    region = var.aws_region
}

data "aws_availability_zones" "available" {
    filter {
        name = "zone-name"
        values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
    }
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
    filter {
    name   = "availabilityZone"
    values = data.aws_availability_zones.available.names
  }
}
resource "aws_security_group" "instance_sg" {
    name = "instance-sg"
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.allowed_cidr]
    }
    tags = {
        Name = "instance-sg"
    }
}

resource "aws_security_group" "alb_sg" {
    name = "alb-sg"
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port = var.alb_port
        to_port = var.alb_port
        protocol = "tcp"
        cidr_blocks = [var.allowed_cidr]  
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.allowed_cidr]
    }
    tags = {
        Name = "alb-sg"
    }
}

resource "aws_launch_template" "web_launch_template" {
    name_prefix = "web-launch-template-"
    image_id = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.instance_sg.id]
    user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "Hello from $(hostname)" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
    EOF
    )

    tags = {
            Name = "web-server-instance"
        }
    }

resource "aws_lb_target_group" "web_target_group" {
    name     = "web-target-group"
    port     = var.server_port
    protocol = "HTTP"
    vpc_id   = data.aws_vpc.default.id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
    }
}

resource "aws_lb" "web_alb" {
    name               = "web-alb"
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_sg.id]
    subnets            = data.aws_subnets.default.ids

    tags = {
        Name = "web-alb"
    }
}
resource "aws_lb_listener" "web_listener" {
    load_balancer_arn = aws_lb.web_alb.arn
    port              = var.alb_port
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.web_target_group.arn
    }

    tags = {
        Name = "web-listener"
    }
}

resource "aws_autoscaling_group" "web_asg" {
    name                      = "web-asg"
    max_size                  = var.max_size
    min_size                  = var.min_size
    desired_capacity          = var.min_size
    vpc_zone_identifier       = data.aws_subnets.default.ids  

    target_group_arns = [aws_lb_target_group.web_target_group.arn]   
    health_check_type = "ELB"                             

    launch_template {
        id      = aws_launch_template.web_launch_template.id
        version = "$Latest"
    }
    tag {
        key                 = "Name"
        value               = "web-asg-instance"
        propagate_at_launch = true
    }
} 