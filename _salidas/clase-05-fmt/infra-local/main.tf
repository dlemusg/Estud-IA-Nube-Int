# Clase 5 · Tu servicio como código
# Llama al módulo servicio-web con los datos del proyecto y del entorno.
#
#   terraform init
#   terraform workspace new desarrollo
#   terraform plan  -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars
#   terraform apply -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars

module "servicio" {
  source = "./modules/servicio-web"

  nombre         = var.nombre
  entorno        = var.entorno
  carpeta_app    = abspath("${path.root}/${var.carpeta_app}")
  version_app    = var.version_app
  puerto_interno = var.puerto_interno
  puerto_externo = var.puerto_externo
  ruta_datos     = var.ruta_datos

  # La configuración final = la del proyecto + la del entorno + el nombre del entorno
  variables_app = merge(
    var.variables_app,
    var.variables_entorno,
    { ENTORNO = var.entorno }
  )
}
