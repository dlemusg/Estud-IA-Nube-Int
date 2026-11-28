# infra-local · Tu servicio como código

Terraform hace lo que en la Clase 3 hacías a mano: construye la imagen, crea el volumen de datos y enciende el contenedor. Funciona con cualquier proyecto que tenga Dockerfile.

```
infra-local/
  main.tf, variables.tf, outputs.tf, versions.tf   la configuración raíz
  modules/servicio-web/     el módulo: imagen + volumen + contenedor
  proyectos/*.tfvars        lo que define a cada servicio (igual en todos los entornos)
  entornos/*.tfvars         lo que cambia entre desarrollo (puerto 8081) y pruebas (8082)
  .terraform.lock.hcl       versiones exactas de los proveedores (sí se sube a Git)
```

## Uso

Requisitos: Docker abierto y Terraform 1.10 o más nuevo.

```bash
terraform init
terraform workspace new desarrollo
terraform plan  -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars
terraform apply -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars
# Villa Nube queda en http://localhost:8081/salud
terraform destroy -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars
```

Para el entorno de pruebas: `terraform workspace new pruebas` y `entornos/pruebas.tfvars`. Cada workspace tiene su propio estado, así que los dos entornos pueden estar encendidos a la vez.

**Guardia de entorno.** Si usas el archivo de un entorno estando en el workspace de otro, Terraform se niega (`outputs.tf`). Así no se aplica la configuración de pruebas sobre el estado de desarrollo.

**Tu proyecto.** Copia `proyectos/mi-proyecto.tfvars.plantilla` como `proyectos/mi-proyecto.tfvars` y cambia lo que dice `CAMBIA`.

**Windows.** Si Terraform no se conecta a Docker, agrega `-var 'docker_host=npipe:////.//pipe//docker_engine'` a cada comando, o usa Git Bash con Docker Desktop abierto, o Codespaces.

**El estado** (`terraform.tfstate` y la carpeta `terraform.tfstate.d/`) no se sube a Git: puede contener configuración sensible y es la memoria de **tu** computador. En un equipo se guarda en un backend remoto con bloqueo; mira `../aws-opcional/backend.tf.ejemplo`.
