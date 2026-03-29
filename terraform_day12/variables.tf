variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name for the cluster"
  type        = string
  default     = "terraform-day12"
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


