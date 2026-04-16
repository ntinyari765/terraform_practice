variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., prod)"
  type        = string
}

# Primary Region Variables
variable "primary_ami_id" {
  description = "AMI ID for the primary region"
  type        = string
}

variable "primary_vpc_cidr" {
  description = "CIDR block for primary VPC"
  type        = string
}

variable "primary_public_subnet_cidrs" {
  type = list(string)
}

variable "primary_private_subnet_cidrs" {
  type = list(string)
}

variable "primary_availability_zones" {
  type = list(string)
}

# Secondary Region Variables
variable "secondary_ami_id" {
  description = "AMI ID for the secondary region"
  type        = string
}

variable "secondary_vpc_cidr" {
  description = "CIDR block for secondary VPC"
  type        = string
}

variable "secondary_public_subnet_cidrs" {
  type = list(string)
}

variable "secondary_private_subnet_cidrs" {
  type = list(string)
}

variable "secondary_availability_zones" {
  type = list(string)
}

# Shared Database Variables
variable "db_name" {
  type = string
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}