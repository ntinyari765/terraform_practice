provider "aws" {
    region = var.aws_region
}

data "aws_availability_zones" "available" {
    filter {
        name = "zone-name"
        values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
    }
}

#Security Group for the EC2 instance
resource "aws_security_group" "instance_sg" {
    name = "instance-sg"

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = [var.allowed_cidr]  
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.allowed_cidr]
    }
}
# Security Group for the ALB
resource "aws_security_group" "alb_sg" {
    name = "alb-sg"

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
}

resource "aws_launch_template" "web_launch_template" {
    name_prefix = "web-launch-template-"
    image_id = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.instance_sg.id]
    user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y
    apt install -y apache2
    systemctl start apache2
    systemctl enable apache2
    echo " Day 4 Terraform | Your server has been deployed using Terraform!!" > /var/www/html/index.html
    EOF
    )

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_autoscaling_group" "web_asg" {
    name = "web-asg"
    availability_zones = data.aws_availability_zones.available.names

    target_group_arns = [aws_lb_target_group.web_tg.arn]
    health_check_type = "ELB"

    min_size = 2
    max_size = 5

    launch_template {
      id = aws_launch_template.web_launch_template.id
      version = "$Latest"
    }

    tag {
        key = "Name"
        value = "terraform-web-server"
        propagate_at_launch = true
    }

}

resource "aws_lb" "web_alb" {
    name = "web-alb"
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]
    subnets = data.aws_subnets.default.ids
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

resource "aws_lb_target_group" "web_tg" {
    name = "web-tg"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
    health_check {
        path = "/"
        interval = 30
        protocol = "HTTP"
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 2
        matcher = "200"
    }
}

resource "aws_lb_listener" "web_listener" {
    load_balancer_arn = aws_lb.web_alb.arn
    port = var.alb_port
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.web_tg.arn
    }
}

output "alb_dns_name" {
    value = aws_lb.web_alb.dns_name
    description = "DNS name of the Application Load Balancer"
}