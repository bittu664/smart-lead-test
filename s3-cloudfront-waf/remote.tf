terraform {
  backend "s3" {
    bucket = "ecsdemotf"
    key = "s3.tfstate"
    region = "ap-south-1"
    
  }
}