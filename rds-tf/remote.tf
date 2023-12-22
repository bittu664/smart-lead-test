terraform {
  backend "s3" {
    bucket = "ecsdemotf"
    key = "rds.tfstate"
    region = "ap-south-1"
    
  }
}