variable "environment" {
  description = "Deployment environment: dev, staging, or production"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging or production."
  }
}

variable "server_port" {
  description = "Port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "cluster_name" {
  description = "Name to use for all resources in the cluster"
  type        = string
}

variable "ami" {
  description = "AMI to use for the EC2 instances"
  type        = string
  default     = "ami-05024c2628f651b80"
}

variable "use_existing_vpc" {
  description = "Whether to use an existing VPC or create a new one"
  type        = bool
  default     = true
}