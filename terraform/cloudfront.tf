# 1. Origin Access Control
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "football-analytics-website-oac"
  description                       = "OAC for Football Analytics website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# 2. CloudFront Distribution
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  default_root_object = "index.html"

  # Origin 1: Website S3 bucket
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "website-s3-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  # Origin 2: Existing Football Data S3 bucket
  origin {
    domain_name = "football-analytics-266735807125-4e60a0c28e6e9f4f689c3ab616.s3.eu-north-1.amazonaws.com"
    origin_id   = "football-data-s3-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  # 3. Route football data requests to the data bucket
  ordered_cache_behavior {
    path_pattern           = "/processed/*"
    target_origin_id       = "football-data-s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 300
    max_ttl     = 300
  }

  # 4. Default behaviour: serve website files
  default_cache_behavior {
    target_origin_id       = "website-s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # 5. Geographic restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # 6. HTTPS certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
