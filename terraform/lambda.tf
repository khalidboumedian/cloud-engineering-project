data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/../src/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Create the AWS Lambda function
resource "aws_lambda_function" "football_collector" {
  function_name = "football-analytics-collector"

  # IAM Role used by Lambda
  role = aws_iam_role.lambda_role.arn

  # Python deployment package
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  # Python configuration
  handler = "lambda_function.lambda_handler"
  runtime = "python3.13"

  # Maximum execution time: 60 seconds
  timeout = 60

  # Memory allocation: 128 MB
  memory_size = 128

  # Environment variables
  environment {
    variables = {
      BUCKET_NAME             = aws_s3_bucket.football_data.bucket
      FOOTBALL_DATA_API_TOKEN = var.football_api_token
    }
  }

  tags = {
    Project   = "FootballAnalytics"
    ManagedBy = "Terraform"
  }
  depends_on = [
    aws_iam_role_policy.lambda_s3_policy,
    aws_iam_role_policy_attachment.lambda_logs
  ]
}