
resource "aws_s3_bucket" "website" {
  bucket = "football-analytics-website-266735807125"

  tags = {
    Name        = "Football Analytics Website"
    Environment = "Production"
    Project     = "Football Analytics"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id

  versioning_configuration {
    status = "Enabled"
  }
}
