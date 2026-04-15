output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "target_group_arn" {
  description = "Target group ARN used by ASG"
  value       = module.alb.target_group_arn
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.asg.asg_name
}

output "launch_template_id" {
  description = "Launch template used for EC2 instances"
  value       = module.ec2.launch_template_id
}

output "launch_template_version" {
  description = "Launch template version used by ASG"
  value       = module.ec2.launch_template_version
}