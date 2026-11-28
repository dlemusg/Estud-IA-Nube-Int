# SALIDAS del módulo: lo que el módulo devuelve a quien lo usa

output "url" {
  description = "Dirección para probar el servicio"
  value       = "http://localhost:${var.puerto_externo}"
}

output "contenedor" {
  description = "Nombre del contenedor (sirve para docker logs <nombre>)"
  value       = docker_container.app.name
}

output "imagen" {
  description = "Imagen usada, con su etiqueta"
  value       = docker_image.app.name
}

output "volumen" {
  description = "Volumen de datos, si el servicio tiene uno"
  value       = var.ruta_datos == "" ? "sin volumen" : docker_volume.datos[0].name
}
