# ENTRADAS de la infraestructura local.
# Hay dos tipos y vienen de dos archivos distintos:
#   proyectos/<proyecto>.tfvars  → lo que define AL SERVICIO (igual en todos los entornos)
#   entornos/<entorno>.tfvars    → lo que cambia DE UN ENTORNO A OTRO

# ---------- Del proyecto ----------
variable "nombre" {
  description = "Nombre corto del servicio (minúsculas y guiones)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]+$", var.nombre))
    error_message = "El nombre va en minúsculas, sin espacios ni tildes, por ejemplo: villa-nube."
  }
}

variable "carpeta_app" {
  description = "Carpeta con el Dockerfile, relativa a infra-local"
  type        = string
}

variable "version_app" {
  description = "Versión de la aplicación"
  type        = string
  default     = "1.0.0"
}

variable "puerto_interno" {
  description = "Puerto donde escucha la aplicación dentro del contenedor"
  type        = number
}

variable "ruta_datos" {
  description = "Carpeta de datos dentro del contenedor; vacío si no guarda datos"
  type        = string
  default     = ""
}

variable "variables_app" {
  description = "Configuración de la aplicación igual en todos los entornos"
  type        = map(string)
  default     = {}
}

# ---------- Del entorno ----------
variable "entorno" {
  description = "Entorno: desarrollo o pruebas"
  type        = string

  validation {
    condition     = contains(["desarrollo", "pruebas"], var.entorno)
    error_message = "El entorno solo puede ser desarrollo o pruebas."
  }
}

variable "puerto_externo" {
  description = "Puerto de tu computador para este entorno"
  type        = number

  validation {
    condition     = var.puerto_externo >= 1024 && var.puerto_externo <= 65535
    error_message = "Usa un puerto entre 1024 y 65535."
  }
}

variable "variables_entorno" {
  description = "Configuración que cambia según el entorno (se suma a variables_app)"
  type        = map(string)
  default     = {}
}

# ---------- De tu computador ----------
variable "docker_host" {
  description = "Dirección de Docker; vacío usa la de tu sistema"
  type        = string
  default     = null
}
