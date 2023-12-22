terraform {
  backend "s3" {
    bucket = "ecsdemotf"
    key = "ecs.tfstate"
    region = "ap-south-1"
    
  }
}