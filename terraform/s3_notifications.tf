resource "aws_lambda_permission" "allow_s3_invoke_processor" {
  statement_id = "AllowS3InvokeProcessor"
  action       = "lambda:InvokeFunction"

  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.football_data.arn
}

resource "aws_s3_bucket_notification" "football_data_notification" {
  bucket = aws_s3_bucket.football_data.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor.arn

    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "raw/bundesliga/"
    filter_suffix = ".json"
  }

  depends_on = [
    aws_lambda_permission.allow_s3_invoke_processor
  ]
}