# Versiones fijas: el mismo código produce lo mismo hoy y dentro de seis meses.
terraform {
  required_version = ">= 1.10"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.5"
    }
  }

  # Sin bloque "backend": el estado se guarda en esta carpeta (terraform.tfstate).
  # Sirve para aprender; en un equipo se guarda en un lugar compartido y con bloqueo.
  # Mira ../aws-opcional/backend.tf.ejemplo
}

# El proveedor habla con tu Docker. En Windows, si dice que no se puede conectar,
# usa:  -var 'docker_host=npipe:////.//pipe//docker_engine'
provider "docker" {
  host = var.docker_host
}
