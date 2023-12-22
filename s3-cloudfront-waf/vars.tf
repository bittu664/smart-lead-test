variable "aws-profile" {
  default = "ecsdemo"
}

variable "region" {
  default = "ap-south-1"
}


variable "environment" {    
  default = "stage"
}

### S3 sections

variable "bucket_name" {    
  default = "smartlead-testops"
}

variable "domain_name" {    
  default = "smartlead-testops.s3.ap-south-1.amazonaws.com"
}