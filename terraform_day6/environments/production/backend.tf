terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-ntinyari"
    key            = "environments/production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-state-lock-table-ntinyari"
    encrypt        = true
  }
}