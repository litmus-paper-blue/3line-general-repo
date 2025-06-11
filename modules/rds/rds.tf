resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.environment}-rds-subnet-group"
  }

   lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.environment}-rds"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "17.2"
  instance_class          = var.instance_class
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  skip_final_snapshot     = true
  publicly_accessible     = true
  multi_az                = var.multi_az
  storage_encrypted       = true
  deletion_protection     = false

  tags = {
    Name = "${var.environment}-rds"
  }
}
