data "archive_file" "processor_package" {
  type        = "zip"
  source_file = "${path.module}/../src/lambda_processor.py"
  output_path = "${path.module}/lambda_processor.zip"
}

resource "aws_lambda_function" "processor" {
  function_name = "football-analytics-processor"
  role          = aws_iam_role.processor_role.arn

  runtime = "python3.13"
  handler = "lambda_processor.lambda_handler"

  filename         = data.archive_file.processor_package.output_path
  source_code_hash = data.archive_file.processor_package.output_base64sha256

  timeout     = 60
  memory_size = 128

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.football_data.bucket
    }
  }

  tags = {
    Project   = "FootballAnalytics"
    ManagedBy = "Terraform"
  }
}