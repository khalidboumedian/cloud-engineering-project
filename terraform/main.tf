resource "aws_s3_bucket" "football_data" {
  bucket_prefix = "football-analytics-266735807125-"

  tags = {
    Project     = "FootballAnalytics"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "football_data" {
  bucket = aws_s3_bucket.football_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "football_data" {
  bucket = aws_s3_bucket.football_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "football_data" {
  bucket = aws_s3_bucket.football_data.id

  versioning_configuration {
    status = "Enabled"
  }
}