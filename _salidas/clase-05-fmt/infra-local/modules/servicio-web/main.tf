# Módulo servicio-web
# Recibe una carpeta con Dockerfile y deja el servicio encendido en un contenedor:
#   imagen (se construye)  +  volumen de datos (opcional)  +  contenedor (con puerto y variables)
# Es el mismo trabajo que hiciste a mano en la Clase 3 con docker build y docker run,
# pero escrito una vez y repetible en cualquier entorno.

# La imagen: equivale a  docker build -t <nombre>:<version> <carpeta>
resource "docker_image" "app" {
  name         = "${var.nombre}:${var.version_app}"
  keep_locally = true

  build {
    context    = var.carpeta_app
    build_args = { APP_VERSION = var.version_app }
  }
}

# El volumen: los datos que deben sobrevivir cuando el contenedor se reemplaza.
# Solo se crea si el servicio tiene una carpeta de datos (ruta_datos distinta de "").
resource "docker_volume" "datos" {
  count = var.ruta_datos == "" ? 0 : 1
  name  = "${var.nombre}-${var.entorno}-datos"
}

# El contenedor: equivale a  docker run -d -p <externo>:<interno> -e ... --name ...
resource "docker_container" "app" {
  name    = "${var.nombre}-${var.entorno}"
  image   = docker_image.app.image_id
  restart = var.reinicio

  ports {
    internal = var.puerto_interno
    external = var.puerto_externo
  }

  # Las variables de entorno llegan como un mapa y Docker las espera como "CLAVE=valor"
  env = [for clave, valor in var.variables_app : "${clave}=${valor}"]

  dynamic "volumes" {
    for_each = docker_volume.datos
    content {
      volume_name    = volumes.value.name
      container_path = var.ruta_datos
    }
  }

  labels {
    label = "estudia.entorno"
    value = var.entorno
  }
}
