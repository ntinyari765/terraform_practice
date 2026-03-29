output "primary_bucket_name" {
  description = "Name of the primary bucket in us-east-1"
  value       = aws_s3_bucket.primary.id
}

output "primary_bucket_arn" {
  description = "ARN of the primary bucket"
  value       = aws_s3_bucket.primary.arn
}

output "replica_bucket_name" {
  description = "Name of the replica bucket in us-west-2"
  value       = aws_s3_bucket.replica.id
}

output "replica_bucket_arn" {
  description = "ARN of the replica bucket"
  value       = aws_s3_bucket.replica.arn
}

output "replication_role_arn" {
  description = "ARN of the IAM role used for replication"
  value       = aws_iam_role.replication.arn
}