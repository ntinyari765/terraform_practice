output "cluster_name" {
  description = "Name of the cluster"
  value       = var.cluster_name
}

output "instance_type" {
  description = "Instance type being used"
  value       = local.instance_type
}

output "min_size" {
  description = "Minimum number of instances"
  value       = local.min_size
}

output "max_size" {
  description = "Maximum number of instances"
  value       = local.max_size
}

output "environment" {
  description = "Environment this cluster is deployed in"
  value       = var.environment
}

output "alarm_arn" {
  description = "ARN of the high CPU alarm (null if monitoring disabled)"
  value       = local.enable_monitoring ? aws_cloudwatch_metric_alarm.high_cpu[0].arn : null
}