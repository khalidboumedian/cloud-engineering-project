output "football_data_bucket_name" {
  description = "Name of the private S3 bucket"
  value       = aws_s3_bucket.football_data.bucket
}