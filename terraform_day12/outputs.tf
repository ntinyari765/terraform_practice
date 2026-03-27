output "alb_dns_name" {
  description = "The DNS name of the load balancer - use this to test your app"
  value       = module.cluster.alb_dns_name
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = module.cluster.asg_name
}