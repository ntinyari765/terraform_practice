terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Default provider — primary region
provider "aws" {
  region = "us-east-1"
}

# Aliased provider — secondary region
provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}

# Production account provider
provider "aws" {
  alias  = "production"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::111111111111:role/TerraformDeployRole"
  }
}

# Staging account provider
provider "aws" {
  alias  = "staging"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::222222222222:role/TerraformDeployRole"
  }
}
# Primary bucket — uses default provider (us-east-1)
resource "aws_s3_bucket" "primary" {
  bucket = var.primary_bucket_name
}

# Replica bucket — uses aliased provider (us-west-2)
resource "aws_s3_bucket" "replica" {
  provider = aws.us_west
  bucket   = var.replica_bucket_name
}
# Enable versioning on primary bucket
resource "aws_s3_bucket_versioning" "primary" {
  bucket = aws_s3_bucket.primary.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable versioning on replica bucket
resource "aws_s3_bucket_versioning" "replica" {
  provider = aws.us_west
  bucket   = aws_s3_bucket.replica.id

  versioning_configuration {
    status = "Enabled"
  }
}

# IAM role that allows S3 to perform replication
resource "aws_iam_role" "replication" {
  name = "s3-replication-role-day14"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy giving the role permission to replicate
resource "aws_iam_role_policy" "replication" {
  name = "s3-replication-policy-day14"
  role = aws_iam_role.replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.primary.arn
      },
      {
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.primary.arn}/*"
      },
      {
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.replica.arn}/*"
      }
    ]
  })
}

# Replication configuration linking primary to replica
resource "aws_s3_bucket_replication_configuration" "replication" {
  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.primary.id

  rule {
    id     = "replicate-all"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.replica.arn
      storage_class = "STANDARD"
    }
  }

  depends_on = [aws_s3_bucket_versioning.primary]
}