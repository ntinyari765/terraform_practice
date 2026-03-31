terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Primary provider — us-east-1
provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

# Replica provider — us-west-2
provider "aws" {
  alias  = "replica"
  region = "us-west-2"
}

module "multi_region_app" {
  source   = "../modules/multi-region-app"
  app_name = "my-app"

  providers = {
    aws.primary = aws.primary
    aws.replica = aws.replica
  }
}