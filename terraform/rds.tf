variable "DB_USERNAME" {
  type = string
  default = "cmw_wordpress"
}

variable "DB_PASSWORD" {
  type = string
}

variable "DB_NAME" {
  type = string
  default = "cmw_wordpress"
}

resource "aws_ssm_parameter" "db_password_param" {
  name = "DB_PASSWORD"
  type = "SecureString"
  value = var.DB_PASSWORD
}

resource "aws_ssm_parameter" "db_username_param" {
  name = "DB_USERNAME"
  type = "SecureString"
  value = var.DB_USERNAME
}

resource "aws_ssm_parameter" "db_name_param" {
  name = "DB_NAME"
  type = "SecureString"
  value = var.DB_NAME
}

resource "aws_db_subnet_group" "cmw_db_subnet_group" {
  name = "cmw_subnet_group"
  subnet_ids = aws_subnet.cmw_db_subnet[*].id

  tags = {
    Name = "CMW DB subnet group"
  }
}

resource "aws_db_instance" "cmw_db" {
  allocated_storage = 20
  db_name = var.DB_NAME
  db_subnet_group_name = aws_db_subnet_group.cmw_db_subnet_group.name
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t4g.micro"
  username = var.DB_USERNAME
  password = var.DB_PASSWORD
  skip_final_snapshot = true
}
