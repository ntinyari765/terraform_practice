provider "aws" {
  region = var.region
}

module "cluster" {
  source = "./modules/cluster"

  cluster_name       = var.cluster_name
  app_version        = var.app_version
  active_environment = var.active_environment
  instance_type      = "t3.micro"
  min_size           = 2
  max_size           = 4
  server_port        = 8080
}