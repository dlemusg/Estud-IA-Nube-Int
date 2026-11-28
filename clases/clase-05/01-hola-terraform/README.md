# Hola Terraform

Tu primera infraestructura como código. No necesita Docker ni nube: Terraform crea un archivo de texto (`salida/bienvenida.txt`) y guarda un dato de configuración.

```bash
terraform init      # prepara la carpeta
terraform plan      # muestra lo que haría
terraform apply     # lo hace (escribe yes)
terraform plan -var 'equipo=Datos'      # ~ actualiza en su sitio
terraform plan -var 'ciudad=Villa Sol'  # -/+ reemplaza el archivo
terraform destroy   # lo borra todo
```

Es el ejercicio 2 de la [guía de la Clase 5](../README.md).
