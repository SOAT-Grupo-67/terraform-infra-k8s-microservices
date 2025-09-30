data "aws_vpc" "default" { default = true }

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "clipo-db-subnet-group"
  subnet_ids = data.aws_subnets.subnets.ids
}

resource "aws_security_group" "clipo-db-sg" {
  name   = "clipo-db-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description      = "Clipo DB Remote Access"
    from_port        = 5432
    to_port          = 5432
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

resource "aws_db_instance" "clipo_service_db" {
  identifier              = "clipo-service-db"
  db_name                 = "clipo_service_db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10
  username                = var.clipo_db_username
  password                = var.clipo_db_password
  publicly_accessible     = true

  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.clipo-db-sg.id]

  skip_final_snapshot     = true
  storage_encrypted       = true
}

resource "aws_secretsmanager_secret" "clipo_db_secret" {
  name        = "clipo-db-secret"
  description = "Credenciais e endpoint do banco de dados Clipo Service"
  recovery_window_in_days = 0 # Só usar em desenvolvimento
}

resource "aws_secretsmanager_secret_version" "clipo_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.clipo_db_secret.id
  secret_string = jsonencode({
    username = var.clipo_db_username,
    password = var.clipo_db_password,
    db_host = aws_db_instance.clipo_service_db.address,
    db_name  = aws_db_instance.clipo_service_db.db_name
  })
}

