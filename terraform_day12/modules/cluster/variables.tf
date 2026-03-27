variable "cluster_name" {
  description = "Name for the cluster"
  type        = string
}

variable "ami" {
  description = "AMI ID to use for EC2 instances"
  type        = string
  default     = "ami-05024c2628f651b80" 
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 4
}

variable "server_port" {
  description = "Port the server listens on"
  type        = number
  default     = 8080
}

variable "app_version" {
  description = "Version of the app to display"
  type        = string
  default     = "v1"
}
variable "active_environment" {
  description = "Which environment is currently active: blue or green"
  type        = string
  default     = "blue"
}