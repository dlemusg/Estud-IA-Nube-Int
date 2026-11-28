# SALIDAS: lo que ves al terminar el apply (y con: terraform output)

output "url" {
  description = "Abre esta dirección para probar el servicio"
  value       = module.servicio.url
}

output "contenedor" {
  description = "Para ver los registros: docker logs <contenedor>"
  value       = module.servicio.contenedor
}

output "imagen" {
  value = module.servicio.imagen
}

output "volumen" {
  value = module.servicio.volumen
}

# GUARDIA: el workspace y el archivo de entorno deben coincidir.
# Evita aplicar la configuración de pruebas sobre el estado de desarrollo (o al revés).
output "entorno" {
  value = var.entorno

  precondition {
    condition     = terraform.workspace == var.entorno
    error_message = "Estás en el workspace \"${terraform.workspace}\" pero usaste el archivo del entorno \"${var.entorno}\". Cambia con: terraform workspace select ${var.entorno}"
  }
}
