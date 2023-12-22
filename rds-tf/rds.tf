### Aurora DB creation.... ###


resource "aws_db_subnet_group" "subnet_group" {
  name       = var.db_subnet_group_name
  description = "DB subnet group "
  subnet_ids = var.subnet_id # Replace with your private subnet IDs
  
}

resource "aws_security_group" "rds_security_group" {
  name        = var.rds_security_group_name
  description = "security group for prod RDS Aurora"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"] # Adjust this for your network security
  }

  
}



### this is the main Aurora RDS Cluster creations.......

# Define a data source to fetch the Secrets Manager secret
data "aws_secretsmanager_secret" "db_credentials" {
  name = var.secret_name # Replace with your Secrets Manager secret name
}

# Define a data source to fetch the latest version of the secret
data "aws_secretsmanager_secret_version" "latest" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

resource "aws_rds_cluster" "aurora_db" {
  cluster_identifier      = var.cluster_identifier_name
  engine                  = var.db_engine
  engine_version          = var.engine_version
  availability_zones      = var.aurora_availability_zones
  database_name           = var.database_name
  master_username         = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["DATABASE_USERNAME"]
  master_password         = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["DATABASE_PASSWORD"]
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  backup_retention_period = 0
  apply_immediately = true
  #preferred_backup_window = "07:00-09:00"
  skip_final_snapshot = "true"

  tags = {
    Terraform = "true"
    Environment = var.environment

  }

  
}

resource "aws_rds_cluster_instance" "prod_instance1" {
  cluster_identifier = aws_rds_cluster.aurora_db.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora_db.engine
  engine_version     = aws_rds_cluster.aurora_db.engine_version
  

  
}

resource "aws_rds_cluster_instance" "prod_instance2" {
  cluster_identifier = aws_rds_cluster.aurora_db.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora_db.engine
  engine_version     = aws_rds_cluster.aurora_db.engine_version
  
  
}