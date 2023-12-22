variable "aws-profile" {
  default = "ecsdemo"
}

variable "region" {
  default = "ap-south-1"
}


variable "environment" {    
  default = "stage"
}



############# FOR VPC #################



variable "vpc_id" {
  default = "vpc-09253b0652c3db024"
}

variable "vpc_cidr" {
  default = ["172.31.0.0/16"]
}

variable "vpc_azs" {
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "subnets" {
  default = ["172.31.16.0/20", "172.31.0.0/20"]
}






#### FOR Aurora DB #########

variable "cluster_identifier_name" {    
  default = "smartlead-demo"
}

variable "db_engine" {    
  default = "aurora-postgresql"
}

variable "subnet_id" {    
  default = ["subnet-0fa7ad2c5b0d5d022", "subnet-0fa7ad2c5b0d5d022", "subnet-0ac614ec40fc28368"]
}

variable "engine_version" {    
  default = "14.6"
}

variable "instance_class" {    
  default = "db.t3.medium"
}


variable "db_subnet_group_name" {    
  default = "demo-subnet-group"
}

variable "rds_security_group_name" {    
  default = "rds-postgres-prod-sg"
}

variable "aurora_availability_zones" {
  default = ["ap-south-1a", "ap-south-1c"]
}

variable "database_name" {    
  default = "postgres"
}


##### For AWS secret manager ######


variable "secret_name" {    
  default = "strapi-db-prod"
}