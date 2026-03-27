output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.example.dns_name
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.example.name
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.asg.arn
}