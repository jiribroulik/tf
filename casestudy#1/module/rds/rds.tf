
#Call VPC Module First to get the Subnet IDs
# module "mytest-vpc" {
#     source      = "../vpc"

#     ENVIRONMENT = var.ENVIRONMENT
#     AWS_REGION  = var.AWS_REGION
# }

#Define Subnet Group for RDS Service
resource "aws_db_subnet_group" "mytest-rds-subnet-group" {

    name          = "${var.ENVIRONMENT}-mytest-db-snet"
    description   = "Allowed subnets for DB cluster instances"
    subnet_ids    = [
      "${var.vpc_private_subnet1}",
      "${var.vpc_private_subnet2}",
    ]
    tags = {
        Name         = "${var.ENVIRONMENT}_mytest_db_subnet"
    }
}

#Define Security Groups for RDS Instances
resource "aws_security_group" "mytest-rds-sg" {

  name = "${var.ENVIRONMENT}-mytest-rds-sg"
  description = "Created by MyTest"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.RDS_CIDR}"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "${var.ENVIRONMENT}-mytest-rds-sg"
   }
}

resource "aws_db_instance" "mytest-rds" {
  identifier = "${var.ENVIRONMENT}-mytest-rds"
  allocated_storage = var.MYTEST_RDS_ALLOCATED_STORAGE
  storage_type = "gp2"
  engine = var.MYTEST_RDS_ENGINE
  engine_version = var.MYTEST_RDS_ENGINE_VERSION
  instance_class = var.DB_INSTANCE_CLASS
  backup_retention_period = var.BACKUP_RETENTION_PERIOD
  publicly_accessible = var.PUBLICLY_ACCESSIBLE
  username = var.MYTEST_RDS_USERNAME
  password = var.MYTEST_RDS_PASSWORD
  vpc_security_group_ids = [aws_security_group.mytest-rds-sg.id]
  db_subnet_group_name = aws_db_subnet_group.mytest-rds-subnet-group.name
  multi_az = "false"
}

output "rds_prod_endpoint" {
  value = aws_db_instance.mytest-rds.endpoint
}