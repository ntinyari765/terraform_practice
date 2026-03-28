variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "appdb"
}

variable "secret_name" {
  description = "Name of the secret in AWS Secrets Manager"
  type        = string
  default     = "prod/db/credentials"
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}