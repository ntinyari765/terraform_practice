variable "environment" {
  description = "Deployment environment: dev, staging, or production"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "cluster_name" {
  description = "Name to use for all resources in the cluster"
  type        = string
  default     = "webserver-cluster-day21"

  validation {
    condition     = length(var.cluster_name) <= 40 && can(regex("^[a-z0-9-]+$", var.cluster_name))
    error_message = "Cluster name must be lowercase, alphanumeric, hyphens only, and 40 characters or less."
  }
}

variable "server_port" {
  description = "Port the server will use for HTTP requests"
  type        = number
  default     = 8080

  validation {
    condition     = var.server_port > 0 && var.server_port <= 65535
    error_message = "Server port must be between 1 and 65535."
  }
}

variable "ami" {
  description = "AMI to use for the EC2 instances"
  type        = string
  default     = "ami-0622c21dd3d2b1075"

  validation {
    condition     = can(regex("^ami-[a-z0-9]+$", var.ami))
    error_message = "AMI must be a valid AMI ID starting with ami-."
  }
  
}

variable "use_existing_vpc" {
  description = "Whether to use an existing default VPC or create a new one"
  type        = bool
  default     = true
}

variable "project_name" {
  description = "Name of the project these resources belong to"
  type        = string
  default     = "terraform-challenge"
}

variable "team_name" {
  description = "Team that owns these resources"
  type        = string
  default     = "devops"
}

variable "alert_email" {
  description = "Email address to send CloudWatch alarm notifications to"
  type        = string
  default     = "winjoyntinyari765@gmail.com"

  validation {
    condition     = var.alert_email == "" || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email))
    error_message = "Must be a valid email address or empty string."
  }
}