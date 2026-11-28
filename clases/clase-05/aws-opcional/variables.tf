variable "region" {
  description = "Región de AWS donde se crea el bucket"
  type        = string
  default     = "us-east-1"
}

variable "entorno" {
  description = "desarrollo o pruebas"
  type        = string
  default     = "desarrollo"

  validation {
    condition     = contains(["desarrollo", "pruebas"], var.entorno)
    error_message = "El entorno solo puede ser desarrollo o pruebas."
  }
}

variable "responsable" {
  description = "Tu usuario de GitHub, para saber de quién es el recurso"
  type        = string
}
