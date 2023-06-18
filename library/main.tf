module "vpc" {
  source             = "./modules/vpc"
  availability_zones = var.availability_zones
  vpc_cidr           = var.vpc_cidr
  public_subnet_ids  = var.public_subnet_ids
  private_subnet_ids = var.private_subnet_ids
}

module "rds" {
  source             = "./modules/rds"
  identifier         = var.identifier
  engine             = var.engine
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  allocated_storage  = var.allocated_storage
  db_name            = var.db_name
  username           = var.username
  password           = var.password
  private_subnet_ids = module.vpc.private_subnets
  rds_sg             = aws_security_group.rdb-instance.id
  depends_on = [module.vpc]
}

module "lambda" {
  source             = "./modules/lambda"
  function_name      = var.function_name
  handler            = var.handler
  runtime            = var.runtime
  filename           = var.filename
  private_subnet_ids = module.vpc.private_subnets
  lambda_sg          = aws_security_group.Lambda-SG.id
  db_name            = var.db_name
  username           = var.username
  password           = var.password
  host               = module.rds.rds_host

  depends_on = [module.rds]
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  apiGateway_name      = var.apiGateway_name
  api1_resource        = var.api1_resource
  api1_method          = var.http_method
  api2_method          = var.http_method
  api2_resource        = var.api2_resource
  lambda_function_name = module.lambda.lambda_function_name
  lambda_arn           = module.lambda.lambda_function_arn

  depends_on = [module.lambda]
}

module "ec2_instance" {
  source        = "./modules/instance"
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = var.instance_type
  ec2_subnet_id = module.vpc.public_subnets
  ec2_sg        = aws_security_group.Rec2-instance.id
  pb_key        = var.pb_key

}

resource "aws_security_group" "Rec2-instance" {
  vpc_id      = module.vpc.vpc_id
  name        = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.My_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.All_ip]
  }
  tags = {
    Name = "Rec2-SCG"
  }
}

resource "aws_security_group" "rdb-instance" {
  name        = "R db security group"
  description = "Example security group for RDS"

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.Rec2-instance.id]
  }
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.Lambda-SG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.All_ip]
  }
}

resource "aws_security_group" "Lambda-SG" {
  name        = "lambda security group"
  description = "lambda security group to connect to RDS"

  vpc_id = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.All_ip]
  }
}


