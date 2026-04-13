# Meridian AWS IaC — hardened baseline
terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = {
      Project            = "meridian"
      Environment        = "range"
      DataClassification = "training-only"
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "fundamentals" {
  bucket = "meridian-fundamentals-${random_id.suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "fundamentals" {
  bucket                  = aws_s3_bucket.fundamentals.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fundamentals" {
  bucket = aws_s3_bucket.fundamentals.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "fundamentals" {
  bucket = aws_s3_bucket.fundamentals.id
  versioning_configuration {
    status = "Enabled"
  }
}
