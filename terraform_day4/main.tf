provider "aws" {
    region = var.aws_region
}

resource "aws_security_group" "web_sg" {
    name = "web_sg"
    description = "Allows HTTP traffic"
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

resource "aws_instance" "web_server" {
    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "Your server has been deployed using Terraform!!" > /var/www/html/index.html
              EOF
    tags = {
        Name = "terraform-web-server"
    }
}
    output "public_ip" {
        value = aws_instance.web_server.public_ip
        description = "Public IP of the web server"
}



 