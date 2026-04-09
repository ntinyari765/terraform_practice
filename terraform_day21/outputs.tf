output "cluster_name" {
  description = "Name of the deployed cluster"
  value       = module.webserver_cluster.cluster_name
}

output "environment" {
  description = "Environment this cluster is deployed in"
  value       = module.webserver_cluster.environment
}

output "instance_type" {
  description = "Instance type being used"
  value       = module.webserver_cluster.instance_type
}

output "min_size" {
  value = module.webserver_cluster.min_size
}

output "max_size" {
  value = module.webserver_cluster.max_size
}

output "instance_ip" {
  description = "Public IP of a running instance"
  value       = module.webserver_cluster.instance_ip
}

output "alarm_arn" {
  description = "ARN of the high CPU alarm"
  value       = module.webserver_cluster.alarm_arn
}