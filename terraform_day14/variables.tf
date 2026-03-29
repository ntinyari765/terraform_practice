variable "primary_bucket_name" {
  description = "Name of the primary S3 bucket in us-east-1"
  type        = string
  default     = "my-primary-bucket-day14"
}

variable "replica_bucket_name" {
  description = "Name of the replica S3 bucket in us-west-2"
  type        = string
  default     = "my-replica-bucket-day14"
}