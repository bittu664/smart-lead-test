#### AWS ECR section ######

resource "aws_ecr_repository" "ecr-demo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

###  ECS SECTION STARTED ##########


resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = var.aws_ecs_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy1" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

  
  
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy2" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"

  
  
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy3" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"

  
}





#### ECS MAIN CLUSTER CREATION PART ###########

resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = var.aws_ecs_cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    Terraform = "true"
    Environment = var.environment
  }

  
}

resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name = aws_ecs_cluster.aws-ecs-cluster.name

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}



resource "aws_cloudwatch_log_group" "log-group" {
  name = var.aws_cloudwatch_log_group_name

  

  
}


###### task definition for mongodb

resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = var.aws_ecs_task_definition_name

  container_definitions = jsonencode([
  
    {
            "name": "mongodb",
            "image": "${var.mongo_image_name}",
            "cpu": 0,
            "portMappings": [
                {
                    "name": "27017",
                    "containerPort": 27017,
                    "hostPort": 27017,
                    "protocol": "tcp",
                    "appProtocol": "http"
                }
            ],
            "essential": true,
            "environmentFiles": [],
            "mountPoints": [],
            "volumesFrom": [],
            "ulimits": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-create-group": "true",
                    "awslogs-group": "${aws_cloudwatch_log_group.log-group.id}",
                    "awslogs-region": "${var.region}",
                    "awslogs-stream-prefix": "${var.awslogs_stream_prefix}"
                },
                "secretOptions": []
            }
    }
  ])
  

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.aws_ecs_container_memory
  cpu                      = var.aws_ecs_container_cpu
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  tags = {
    Terraform = "true"
    Environment = var.environment
  }

  
}


#### task definition for nodejs

resource "aws_ecs_task_definition" "ecs-task-nodejs" {
  family = var.aws_ecs_task_definition_name_for_nodejs

  container_definitions = jsonencode([
  
    {
            "name": "nodejs",
            "image": "${var.ecr_image}",
            "cpu": 0,
            "portMappings": [
                {
                    "name": "4000",
                    "containerPort": 4000,
                    "hostPort": 4000,
                    "protocol": "tcp",
                    "appProtocol": "http"
                }
            ],
            "essential": true,
            "environmentFiles": [],
            "mountPoints": [],
            "volumesFrom": [],
            "ulimits": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-create-group": "true",
                    "awslogs-group": "${aws_cloudwatch_log_group.log-group.id}",
                    "awslogs-region": "${var.region}",
                    "awslogs-stream-prefix": "${var.awslogs_stream_prefix_nodejs}"
                },
                "secretOptions": []
            }
    }
  ])
  

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  #cpu_architecture         = "ARM64"
  memory                   = var.aws_ecs_container_memory
  cpu                      = var.aws_ecs_container_cpu
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  tags = {
    Terraform = "true"
    Environment = var.environment
  }
  
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
  
}





data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.aws-ecs-task.family
}






### security group config for ecs

resource "aws_security_group" "service_security_group" {
  vpc_id = var.vpc_id

  ingress {
    description      = "nodejs from VPC"
    from_port        = 4000
    to_port          = 4000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  ingress {
    description      = "mongodb from VPC"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Terraform = "true"
    Environment = var.environment
  }

  
}







#### Creating Mongo ECS Service......

resource "aws_ecs_service" "aws-ecs-service" {
  name                 = var.aws_ecs_service_name
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = var.aws_ecs_service_desired_count
  force_new_deployment = true

  network_configuration {
    subnets          = var.public_subnet_id
    assign_public_ip = true
    security_groups = [
      aws_security_group.service_security_group.id,
      
    ]
  }

  

  
}


#### Creating Nodejs ECS Service......



resource "aws_ecs_service" "aws-ecs-nodejs-service" {
  name                 = var.aws_ecs_service_nodejs_name
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.ecs-task-nodejs.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = var.aws_ecs_service_desired_count
  force_new_deployment = true

  network_configuration {
    subnets          = var.public_subnet_id
    assign_public_ip = true
    security_groups = [
      aws_security_group.service_security_group.id,
      
    ]
  }

  

  
}





