output "primary_bucket_arn" {
  description = "ARN of the primary bucket"
  value       = aws_s3_bucket.primary.arn
}

output "replica_bucket_arn" {
  description = "ARN of the replica bucket"
  value       = aws_s3_bucket.replica.arn
}