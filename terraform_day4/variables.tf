variable "aws_region" {
    description = "The AWS region to deploy resources in"
    type       = string
    default     = "us-east-1"
}

variable "instance_type" {
    description = "The type of EC2 instance to use"
    type       = string
    default     = "t3.micro"
}

variable "server_port" {
    description = "The port on which the web server will listen"
    type       = number
    default     = 80
}

variable "ami_id" {
    description = "The AMI ID to use for the EC2 instance"
    type       = string
    default     = "ami-0c7217cdde317cfec"
}

variable "allowed_cidr" {
    description = "The CIDR block to allow access to the web server"
    type       = string
    default     = "0.0.0.0/0"
}