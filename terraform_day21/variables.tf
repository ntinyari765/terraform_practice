variable "cluster_name" {
  description = "Name to use for all resources in the cluster"
  type        = string
  default     = "webserver-cluster-day21"
}

variable "environment" {
  description = "Deployment environment: dev, staging, or production"
  type        = string
  default     = "dev"
}

variable "server_port" {
  description = "Port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "ami" {
  description = "AMI to use for the EC2 instances"
  type        = string
  default     = "ami-0622c21dd3d2b1075"
}

variable "use_existing_vpc" {
  description = "Whether to use the default VPC or create a new one"
  type        = bool
  default     = true
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-challenge"
}

variable "team_name" {
  description = "Team that owns these resources"
  type        = string
  default     = "devops"
}

variable "alert_email" {
  description = "Email for CloudWatch alarm notifications"
  type        = string
  default     = ""
}