output "website_url" {
  value       = "https://${module.static_website.cloudfront_domain_name}"
  description = "Live website URL"
}

output "bucket_name" {
  value = module.static_website.bucket_name
}

output "cloudfront_id" {
  value = module.static_website.cloudfront_distribution_id
}