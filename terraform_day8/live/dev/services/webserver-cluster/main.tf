provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "github.com/ntinyari765/terraform-aws-webserver-cluster?ref=v.0.0.2"

  cluster_name  = "webservers-dev"    
  min_size      = 0
  max_size      = 0

  enable_deletion_protection = false
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}