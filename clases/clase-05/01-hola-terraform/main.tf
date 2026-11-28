# Clase 5 · Hola Terraform
# Tu primera infraestructura como código. No necesita nube ni Docker:
# Terraform crea un archivo en tu computador y guarda un dato de configuración.
#
#   terraform init      descarga lo que necesita (una sola vez)
#   terraform plan      muestra qué haría, sin hacerlo
#   terraform apply     lo hace (pide confirmar con "yes")
#   terraform destroy   lo borra todo

# 1. QUÉ VERSIONES USAMOS
terraform {
  required_version = ">= 1.10"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# 2. ENTRADAS: los datos que pueden cambiar sin tocar el resto del código
variable "ciudad" {
  description = "Nombre de la alcaldía que da la bienvenida"
  type        = string
  default     = "Villa Nube"
}

variable "equipo" {
  description = "Equipo responsable del servicio"
  type        = string
  default     = "Plataforma"
}

# 3. RECURSOS: lo que Terraform crea y cuida
# Un archivo de texto. Si cambias su contenido, Terraform lo REEMPLAZA (lo borra y lo crea de nuevo).
resource "local_file" "bienvenida" {
  filename = "${path.module}/salida/bienvenida.txt"
  content  = "Bienvenida a la API de Trámites de ${var.ciudad}.\n"
}

# Un dato de configuración guardado en el estado. Si cambias el equipo, Terraform lo ACTUALIZA en su sitio.
resource "terraform_data" "responsable" {
  input = {
    equipo = var.equipo
    ciudad = var.ciudad
  }
}

# 4. SALIDAS: lo que Terraform te muestra al terminar
output "archivo" {
  description = "Dónde quedó el archivo"
  value       = local_file.bienvenida.filename
}

output "responsable" {
  description = "Equipo responsable registrado"
  value       = terraform_data.responsable.output.equipo
}
