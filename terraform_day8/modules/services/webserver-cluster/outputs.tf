output "alb_dns_name" {
  value       = aws_lb.webserver.dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.webserver.name
  description = "The name of the Auto Scaling Group"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "The ID of the ALB security group"
}

output "alb_ingress_rule_ids" {
  description = "Map of port to ALB ingress security group rule ID"
  value = {
    for port, rule in aws_security_group_rule.alb_ingress :
    port => rule.id
  }
}