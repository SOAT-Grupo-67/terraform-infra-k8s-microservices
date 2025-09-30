data "aws_vpc" "default" { default = true }

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "users-db-subnet-group"
  subnet_ids = data.aws_subnets.subnets.ids
}

resource "aws_security_group" "users-db-sg" {
  name   = "users-db-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description      = "Users DB Remote Access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]   
    ipv6_cidr_blocks = ["::/0"]       
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_db_instance" "users_service_db" {
  identifier              = "users-service-db"
  db_name                 = "users_service_db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10
  username                = var.users_db_username
  password                = var.users_db_password
  publicly_accessible     = true

  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.users-db-sg.id]

  skip_final_snapshot     = true
  storage_encrypted       = true
}

resource "aws_secretsmanager_secret" "users_db_secret" {
  name        = "users-db-secret"
  description = "Credenciais e endpoint do banco de dados Users Service"
  recovery_window_in_days = 0 # Só usar em desenvolvimento
}

resource "aws_secretsmanager_secret_version" "users_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.users_db_secret.id
  secret_string = jsonencode({
    username = var.users_db_username,
    password = var.users_db_password,
    db_host = aws_db_instance.users_service_db.address,
    db_name  = aws_db_instance.users_service_db.db_name
  })
}

