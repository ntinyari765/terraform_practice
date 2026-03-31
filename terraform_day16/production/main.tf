provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../modules/webserver-cluster"

  environment  = "production"
  cluster_name = "prod-cluster"
  server_port  = 8080
}

output "cluster_name" {
  value = module.webserver_cluster.cluster_name
}

output "instance_type" {
  value = module.webserver_cluster.instance_type
}

output "min_size" {
  value = module.webserver_cluster.min_size
}

output "max_size" {
  value = module.webserver_cluster.max_size
}

output "alarm_arn" {
  value = module.webserver_cluster.alarm_arn
}

# Safety flag — set to false to prevent any resources being created
variable "enable_infrastructure" {
  type    = bool
  default = false
}