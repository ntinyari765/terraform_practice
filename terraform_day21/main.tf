terraform {
  cloud {
    organization = "ntinyari-terraform"

    workspaces {
      name = "webserver-cluster-dev"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "./modules/webserver-cluster"

  cluster_name     = var.cluster_name
  environment      = var.environment
  server_port      = var.server_port
  ami              = var.ami
  use_existing_vpc = var.use_existing_vpc
  project_name     = var.project_name
  team_name        = var.team_name
  alert_email      = var.alert_email
}