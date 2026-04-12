terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

module "static_website" {
  source = "../../modules/s3-static-website"

  bucket_name      = var.bucket_name
  environment      = var.environment
  index_document   = var.index_document
  error_document   = var.error_document
  html_source_path = "${path.module}/index.html"

  tags = {
    Owner = "terraform-challenge"
    Day   = "25"
  }
}