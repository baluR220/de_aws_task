resource "aws_db_subnet_group" "wp" {
  name       = "wp_db_subnet_group"
  subnet_ids = [aws_subnet.wp_west_2a.id, aws_subnet.wp_west_2b.id]

  tags = {
    Name = "wp_db_subnet_group"
  }
}

resource "aws_db_instance" "wp" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0.27"
  instance_class         = "db.t2.micro"
  name                   = "wp_app"
  identifier             = "wp-app"
  username               = var.db_user
  password               = var.db_secret
  db_subnet_group_name   = aws_db_subnet_group.wp.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.sg_for_db.id]

  tags = {
    Name = "wp_db"
  }
}
