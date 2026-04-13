resource "aws_db_instance" "db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "terraform_db"
  username               = "admin"
  password               = "TerraformLab123!"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.lab_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_sub.name
}

resource "aws_db_subnet_group" "db_sub" {
  name       = "terraform-db-subnet"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}