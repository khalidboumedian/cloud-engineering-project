# IAM Role for AWS Lambda
resource "aws_iam_role" "lambda_role" {
  name = "football-analytics-lambda-role"

  # Allows the Lambda service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Allow Lambda to upload files to our S3 bucket
resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "football-analytics-s3-upload"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.football_data.arn}/raw/bundesliga/*"
      }
    ]
  })
}

# Allow Lambda to send logs to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role" "processor_role" {
  name = "football-analytics-processor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "processor_s3_policy" {
  name = "football-analytics-processor-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "s3:GetObject"
      ]

      Resource = "${aws_s3_bucket.football_data.arn}/raw/bundesliga/*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.football_data.arn}/processed/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "processor_s3_attachment" {
  role       = aws_iam_role.processor_role.name
  policy_arn = aws_iam_policy.processor_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "processor_logs_attachment" {
  role = aws_iam_role.processor_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}