resource "aws_db_subnet_group" "rdb-group" {
  name       = var.rds_subnet_group
  subnet_ids = slice(var.private_subnet_ids, 2, 4)  
  tags = {
    Name = var.rds_subnet_group
  }
}

resource "aws_db_instance" "library-db" {
  identifier           = var.identifier
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  username             = var.username
  password             = var.password
  db_subnet_group_name = aws_db_subnet_group.rdb-group.name
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = true

  vpc_security_group_ids = [var.rds_sg]  

  tags = {
    Name = var.identifier
  }
  
}