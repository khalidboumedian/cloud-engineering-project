
# Allow CloudFront to read website files
data "aws_iam_policy_document" "website_cloudfront" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.website.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "website_cloudfront" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website_cloudfront.json
}

# Allow CloudFront to read football data
data "aws_iam_policy_document" "data_cloudfront" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.football_data.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.website.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "data_cloudfront" {
  bucket = aws_s3_bucket.football_data.id
  policy = data.aws_iam_policy_document.data_cloudfront.json
}