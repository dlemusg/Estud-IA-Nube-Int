# ENTRADAS del módulo: lo que quien lo usa debe (o puede) decidir

variable "nombre" {
  description = "Nombre corto del servicio, en minúsculas y con guiones (ej. villa-nube)"
  type        = string
}

variable "entorno" {
  description = "Entorno donde corre: desarrollo o pruebas"
  type        = string
}

variable "carpeta_app" {
  description = "Ruta absoluta a la carpeta que tiene el Dockerfile"
  type        = string
}

variable "version_app" {
  description = "Versión de la aplicación; se usa como etiqueta de la imagen"
  type        = string
  default     = "1.0.0"
}

variable "puerto_interno" {
  description = "Puerto donde escucha la aplicación dentro del contenedor"
  type        = number
}

variable "puerto_externo" {
  description = "Puerto de tu computador por donde entras al servicio"
  type        = number
}

variable "variables_app" {
  description = "Variables de entorno de la aplicación (configuración, nunca contraseñas reales)"
  type        = map(string)
  default     = {}
}

variable "ruta_datos" {
  description = "Carpeta de datos dentro del contenedor; vacío si el servicio no guarda datos"
  type        = string
  default     = ""
}

variable "reinicio" {
  description = "Política de reinicio del contenedor: no, on-failure, always o unless-stopped"
  type        = string
  default     = "unless-stopped"
}
