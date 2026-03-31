output "primary_bucket_arn" {
  value = module.multi_region_app.primary_bucket_arn
}

output "replica_bucket_arn" {
  value = module.multi_region_app.replica_bucket_arn
}