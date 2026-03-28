provider "aws" {
  region = var.region
}

data "aws_secretsmanager_secret" "db_credentials" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

locals {
  db_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.db_credentials.secret_string
  )
}

resource "aws_db_instance" "example" {
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  db_name           = var.db_name
  allocated_storage = 10
  skip_final_snapshot = true

  username = local.db_credentials["username"]
  password = local.db_credentials["password"]

  tags = {
    Name = "terraform-day13-db"
  }
}