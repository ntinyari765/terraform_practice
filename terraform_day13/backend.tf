terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket-ntinyari"
    key            = "day13/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-state-lock-table-ntinyari"
    encrypt        = true
  }
}