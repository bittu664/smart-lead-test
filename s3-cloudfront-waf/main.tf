resource "aws_s3_bucket" "terraform" {
// S3 bucket settings
  bucket = var.bucket_name
  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  

  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "terraform" {
  bucket = aws_s3_bucket.terraform.id
  policy = file("./s3_bucket_policy.json")
}

resource "aws_s3_bucket_public_access_block" "terraform" {
  bucket              = aws_s3_bucket.terraform.id
  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_ownership_controls" "mybucket2-acl-ownership" {
  bucket = aws_s3_bucket.terraform.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}





###### Cloudfront ########



resource "aws_cloudfront_distribution" "s3_distribution" {
  // Replace with your own cloudfront distribution settings
  enabled             = true
  comment             = "this is for frontend "
  default_root_object = "index.html"
  web_acl_id          = aws_wafv2_web_acl.Allowed-demoips.arn

  origin {
    domain_name = var.domain_name
    origin_id   = "S3"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3"

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
  
  #price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}






############ Uploading the frontedn content #####


resource "null_resource" "upload_frontend" {
  depends_on = [aws_s3_bucket.terraform, aws_cloudfront_distribution.s3_distribution]
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "aws s3 sync ./apps s3://smartlead-testops"
    }
}



##### WAF sections #####


resource "aws_wafv2_web_acl" "Allowed-demoips" {
  name        = "Allowed-demoips"
  description = "Allowed-demoips for allowing traffic from IP set"
  scope       = "CLOUDFRONT" 
  provider    = aws.east

  default_action {
    allow {} # You can change this action based on your requirements
  }

  rule {
    name     = "AWSRateBasedRuleDomesticDOS"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = ["JP"]
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSRateBasedRuleDomesticDOS"
      sampled_requests_enabled   = true
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ExampleWebACLMetrics"
    sampled_requests_enabled   = true
  }

  
}

