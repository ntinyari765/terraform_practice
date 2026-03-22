terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-ntinyari"
    key            = "app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-state-lock-table-ntinyari"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "dev_infra" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state-bucket-ntinyari"
    key    = "environments/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

output "dev_alb_dns" {
  description = "ALB DNS pulled from dev environment state"
  value       = data.terraform_remote_state.dev_infra.outputs.alb_dns_name
}