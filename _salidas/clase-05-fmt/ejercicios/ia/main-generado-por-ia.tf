# Ejercicio 8 · Mesa del arquitecto
# Un asistente de IA recibió esta petición:
#   "Hazme el Terraform para subir la API de Villa Nube a AWS con su base de datos,
#    rápido, que funcione a la primera."
# Este es el código que entregó. Funciona... pero ¿lo aplicarías?
# Tu tarea: encontrar los problemas ANTES de que lleguen a un plan o a un apply.
# NO lo apliques: es solo para leer.

provider "aws" {
  region     = "us-east-1"
  access_key = "mi-llave-de-acceso"
  secret_key = "mi-llave-secreta"
}

resource "aws_security_group" "api" {
  name = "villa-nube-api"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "api" {
  ami                    = "ami-0abcdef1234567890"
  instance_type          = "m5.4xlarge"
  vpc_security_group_ids = [aws_security_group.api.id]
}

resource "aws_db_instance" "tramites" {
  identifier             = "villa-nube-tramites"
  engine                 = "postgres"
  instance_class         = "db.m5.large"
  allocated_storage      = 20
  username               = "admin"
  password               = "Admin123"
  publicly_accessible    = true
  skip_final_snapshot    = true
  deletion_protection    = false
  vpc_security_group_ids = [aws_security_group.api.id]
}

resource "aws_s3_bucket" "documentos" {
  bucket = "villa-nube-documentos"
}

resource "aws_s3_bucket_acl" "documentos" {
  bucket = aws_s3_bucket.documentos.id
  acl    = "public-read"
}
