output "bucket" {
  description = "Nombre final del bucket"
  value       = aws_s3_bucket.documentos.bucket
}

output "region" {
  value = var.region
}
