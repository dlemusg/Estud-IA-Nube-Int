# Opcional · Un bucket S3 para los documentos de Villa Nube

**Solo para quien tiene una cuenta de AWS** propia o del programa. Si no tienes cuenta, lee el plan guardado en [`../ejercicios/planes/aws-crear-bucket.txt`](../ejercicios/planes/aws-crear-bucket.txt): es exactamente lo que verías.

## Qué crea

Cuatro recursos: un bucket S3 con nombre único, versionado (guarda versiones anteriores de cada archivo), cifrado y bloqueo de acceso público. Vacío y por unas horas, su costo es de centavos o cero. **Destrúyelo al terminar.**

## Antes de empezar

1. **Nunca** escribas tus llaves de AWS en un archivo `.tf`. Configúralas en la terminal con `aws configure` (AWS CLI) o con las variables `AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY`.
2. Usa un usuario o rol con permisos solo sobre S3, no la cuenta raíz.
3. Activa una alerta de presupuesto en AWS Budgets por un monto bajo.

## Pasos

```bash
cp terraform.tfvars.ejemplo terraform.tfvars   # cambia tu usuario de GitHub
terraform init
terraform plan        # debe decir: Plan: 4 to add, 0 to change, 0 to destroy
terraform apply       # escribe yes
terraform output      # nombre del bucket
terraform destroy     # al terminar, siempre
```

## Estado remoto

`backend.tf.ejemplo` muestra cómo se guarda el estado en un bucket compartido con bloqueo (`use_lockfile = true`, disponible desde Terraform 1.10; antes se usaba una tabla de DynamoDB, hoy marcada como obsoleta). Se lee en clase; para usarlo necesitas un bucket de estados creado aparte.

## En el pipeline

El workflow de la Clase 5 solo **valida** esta carpeta: no tiene credenciales y no crea nada. Para aplicar desde GitHub Actions se usa OIDC (GitHub obtiene permisos temporales de AWS sin guardar llaves); lo veremos cuando el proyecto pase a la nube.
