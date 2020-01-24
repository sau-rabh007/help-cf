resource "aws_s3_bucket" "faro-help-front-end-staging-bucket" {
  bucket = "faro-help-front-end-staging-bucket"
  acl    = "private"

  tags = {
    Name = "${var.tag_name}"
    Environment = "${var.tag_Environment}"
    Project = "${var.tag_Project}"
  }
}


resource "aws_cloudfront_distribution" "s3_distribution_admin" {
  origin {
    domain_name = "${aws_s3_bucket.faro-help-front-end-staging-bucket.bucket_regional_domain_name}"
    origin_id   = "${aws_s3_bucket.faro-help-front-end-staging-bucket.id}"

#   s3_origin_config {
#    origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
#   }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  aliases = ["faro-help-stage.sourcefuse.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.faro-help-front-end-staging-bucket.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${aws_s3_bucket.faro-help-front-end-staging-bucket.id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.faro-help-front-end-staging-bucket.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
     restriction_type = "none"  
    }
  }

  tags = {
    Name = "${var.tag_name}"
    Environment = "${var.tag_Environment}"
    Project = "${var.tag_Project}"
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
  }
}