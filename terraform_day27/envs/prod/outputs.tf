output "primary_region_alb_url" {
  value       = "http://${module.alb_primary.alb_dns_name}"
  description = "Direct URL to access the Primary Region (us-east-1)"
}

output "secondary_region_alb_url" {
  value       = "http://${module.alb_secondary.alb_dns_name}"
  description = "Direct URL to access the Secondary Region (us-west-2)"
}

output "primary_db_endpoint" {
  value       = module.rds_primary.db_endpoint
  description = "Primary Database connection string"
}

output "replica_db_endpoint" {
  value       = module.rds_replica.db_endpoint
  description = "Read-only Replica Database connection string"
}