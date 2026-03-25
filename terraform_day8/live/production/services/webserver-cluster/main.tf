provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "github.com/ntinyari765/terraform-aws-webserver-cluster?ref=v0.0.1"

  cluster_name  = "webservers-production"
  environment   = "production"  
  min_size      = 4
  max_size      = 10

  enable_autoscaling = true  
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}