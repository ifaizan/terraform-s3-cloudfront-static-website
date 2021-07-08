resource "aws_cloudfront_origin_access_identity" "myOAI" {
  comment = "myOAI"
}

resource "aws_cloudfront_distribution" "my-static-content-cdn" {
  origin {
   domain_name = aws_s3_bucket.bucket-for-static-web.bucket_regional_domain_name
   origin_id = "primaryS3" 

   s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.myOAI.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
	allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "primaryS3"
	viewer_protocol_policy = "allow-all"
    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }
  }

  enabled = true

  restrictions {
    geo_restriction {	
      restriction_type = "none"
	}
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
