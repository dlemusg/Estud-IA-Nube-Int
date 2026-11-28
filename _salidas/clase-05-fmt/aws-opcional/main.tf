# Clase 5 · Opcional en AWS: un bucket para los documentos de Villa Nube
# Solo para quien tiene una cuenta de AWS propia o del programa.
# Cuesta centavos si lo destruyes el mismo día: al terminar corre  terraform destroy
#
# Qué crea (4 recursos):
#   1. un bucket S3 con nombre único
#   2. versionado: guarda versiones anteriores de cada archivo
#   3. cifrado de los archivos guardados
#   4. bloqueo de acceso público: nadie de internet puede leerlo

terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region

  # Etiquetas que se ponen solas a todo lo que se crea: sirven para saber
  # de quién es cada recurso y cuánto cuesta cada proyecto.
  default_tags {
    tags = {
      Proyecto    = "villa-nube"
      Entorno     = var.entorno
      Responsable = var.responsable
      Curso       = "estudia-nube-intermedio"
    }
  }
}

resource "aws_s3_bucket" "documentos" {
  # bucket_prefix: AWS completa el nombre para que sea único en el mundo
  bucket_prefix = "villa-nube-docs-${var.entorno}-"

  # Solo en laboratorio: permite borrar el bucket aunque tenga archivos
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "documentos" {
  bucket = aws_s3_bucket.documentos.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "documentos" {
  bucket = aws_s3_bucket.documentos.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "documentos" {
  bucket = aws_s3_bucket.documentos.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
