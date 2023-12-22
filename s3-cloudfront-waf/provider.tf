provider "aws" {
  region  = var.region
  profile = var.aws-profile
  
  

}

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}