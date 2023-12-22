variable "aws-profile" {
  default = "ecsdemo"
}

variable "region" {
  default = "ap-south-1"
}


variable "environment" {    
  default = "stage"
}


#### ECR repo ####

variable "ecr_repo_name" {
  default = "nodejs-apps"
}

variable "ecr_image" {    
  default = "782408168927.dkr.ecr.ap-south-1.amazonaws.com/nodejs-apps:latest"
}

variable "mongo_image_name" {
  default = "mongo:5.0.23"
}



############# FOR VPC #################



variable "vpc_id" {
  default = "vpc-09253b0652c3db024"
}

variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "vpc_azs" {
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}


variable "public_subnet_id" {    
  default = ["subnet-0fa7ad2c5b0d5d022", "subnet-075526c23d3346e4e"]
}

#variable "private_subnet_id" {    
#  default = ["subnet-0ecd4752e7f8782ea", "subnet-0efdea5704687be73"]
#}




##### FOR ECS #######

variable "aws_ecs_role_name" {    
  default = "ecs-stage"
}




variable "aws_ecs_cluster_name" {    
  default = "smartlead-stage"
}

variable "aws_cloudwatch_log_group_name" {    
  default = "smartlead-logs"
}


variable "aws_ecs_task_definition_name" {    
  default = "smartlead-mongo"
}


variable "aws_ecs_task_definition_name_for_nodejs" {    
  default = "smartlead-nodejs"
}






variable "aws_ecs_container_memory" {    
  default = "2048"
}

variable "aws_ecs_container_cpu" {    
  default = "1024"
}

variable "aws_ecs_service_name" {    
  default = "mongodb"
}


variable "aws_ecs_service_nodejs_name" {    
  default = "nodejs"
}


variable "aws_ecs_service_desired_count" {    
  default = "1"
}



variable "awslogs_stream_prefix" {    
  default = "mongodb-ops"
}


variable "awslogs_stream_prefix_nodejs" {    
  default = "nodejs-ops"
}

