# Clase 5 · Guía del estudiante y ejercicios

Infraestructura declarativa y manejo de entornos · Nube Intermedio · Semana 3. No necesitas experiencia previa con Terraform: vamos paso a paso, y todo corre en tu computador, sin cuenta de nube.

## Antes de empezar

En la Clase 3 encendiste Villa Nube con comandos escritos a mano: `docker build`, `docker run -p 8080:8080 -e ...`. En la Clase 4 una máquina empezó a probar tu código cada vez que lo cambias. Pero la **infraestructura** (qué se crea, con qué puertos, con qué configuración, en qué entorno) sigue dependiendo de que alguien escriba bien los comandos.

Hoy la infraestructura se **describe en archivos**. Terraform lee esos archivos, te muestra un **plan** con lo que va a hacer antes de hacerlo, lo hace y recuerda lo que creó. El mismo código sirve para desarrollo y para pruebas, y se puede revisar como cualquier otro código.

**Te llevas:** tu proyecto descrito en Terraform, un plan leído e interpretado, dos entornos (desarrollo y pruebas) creados con el mismo código, y tu primera decisión de arquitectura escrita (ADR).

**Cómo vamos a trabajar.** Primero lo hace el profesor, luego lo haces con él y después en tu proyecto. Al final, la **Mesa del arquitecto**: una conversación sobre cuándo vale la pena todo esto y qué pasa cuando una IA escribe la infraestructura por ti. Si algo falla, copia en el chat el comando que escribiste y la primera línea que dice `Error`.

**Alistamiento (antes de la clase)**

- [ ] Docker Desktop está abierto y `docker run hello-world` funciona (lo hiciste en la Clase 3).
- [ ] Terraform instalado: en una terminal, `terraform version` muestra `Terraform v1.10` o más nuevo.
- [ ] Tienes la carpeta del curso actualizada: en la carpeta `estudia-nube`, `git pull`. Debe aparecer `clases/clase-05`.
- [ ] Opcional: mira la primera parte de Platzi M5 · Terraform. Hoy la adelantamos; en la semana 4 la retomamos.

**Instalar Terraform**

| Tu sistema | Comando |
| --- | --- |
| Windows | En PowerShell: `winget install Hashicorp.Terraform`. Cierra y vuelve a abrir la terminal (usa Git Bash para la clase) |
| macOS | `brew tap hashicorp/tap` y luego `brew install hashicorp/tap/terraform` |
| Linux | Sigue la guía oficial: developer.hashicorp.com/terraform/install |
| No puedo instalar nada | Usa **Codespaces**: en el repositorio del curso, **Code** → **Codespaces** → **Create codespace on main**. Ya trae Docker y Terraform. Si ya tenías un codespace creado antes de hoy, crea uno nuevo |

**Las 9 palabras de hoy**

| Palabra | Qué significa | En Villa Nube |
| --- | --- | --- |
| Infraestructura como código (IaC) | Describir en archivos lo que se debe crear, en lugar de hacerlo a mano | La carpeta `infra-local/` |
| Proveedor (provider) | El «traductor» que sabe hablar con una plataforma | `kreuzwerker/docker` habla con tu Docker; `hashicorp/aws` habla con AWS |
| Recurso | Una pieza de infraestructura que Terraform crea y cuida | Una imagen, un volumen y un contenedor |
| Variable (entrada) | Un dato que puede cambiar sin tocar el resto del código | `puerto_externo = 8081` |
| Salida (output) | Lo que Terraform te muestra al terminar | `url = "http://localhost:8081"` |
| Plan | La lista de lo que Terraform **haría**, antes de hacerlo | `Plan: 3 to add, 0 to change, 0 to destroy` |
| Estado (state) | La memoria de Terraform: qué creó y cómo quedó | El archivo `terraform.tfstate` |
| Módulo | Un bloque de Terraform reutilizable, con entradas y salidas | `modules/servicio-web` |
| Workspace | Un estado separado para cada entorno, con el mismo código | `desarrollo` y `pruebas` |

**Los comandos de hoy**

| Comando | Qué hace | ¿Cambia algo? |
| --- | --- | --- |
| `terraform init` | Prepara la carpeta y descarga los proveedores (una vez por carpeta) | No |
| `terraform fmt` | Ordena los espacios y la sangría de los archivos | Solo el formato |
| `terraform validate` | Revisa que el código esté bien escrito | No |
| `terraform plan` | Muestra lo que haría | **No** |
| `terraform apply` | Muestra el plan, pide `yes` y lo hace | **Sí** |
| `terraform destroy` | Borra todo lo que esta configuración creó | **Sí** |

**El laboratorio** está en `clases/clase-05` del repositorio del curso, github.com/dlemusg/Estud-IA-Nube-Int. Es un caso inventado: no uses datos personales reales ni claves de tu trabajo.

| Carpeta | Qué tiene |
| --- | --- |
| `01-hola-terraform/` | Tu primer Terraform: crea un archivo de texto. No necesita Docker |
| `infra-local/` | Villa Nube (y los proyectos de práctica) como código, con Docker |
| `infra-local/modules/servicio-web/` | El módulo: imagen + volumen + contenedor |
| `infra-local/proyectos/` | Un archivo por proyecto: lo que define al servicio |
| `infra-local/entornos/` | Un archivo por entorno: lo que cambia entre desarrollo y pruebas |
| `ejercicios/` | Planes guardados, la plantilla para completar, un estado de ejemplo y el código de la IA |
| `aws-opcional/` | Lo mismo en AWS, solo para quien tiene cuenta |
| `adr/` | Plantilla y ejemplo de registro de decisiones |

## Ejercicio 1 · ¿Qué sigues haciendo a mano?

*En parejas · apertura · 5 minutos.*

**Paso 1.** Piensa en tu proyecto (o en Villa Nube). Escribe los pasos que alguien tiene que hacer **a mano** para tener el servicio encendido en un computador nuevo.

1. ______________________
2. ______________________
3. ______________________

**Paso 2.** Marca con ⚠ el paso donde es más fácil equivocarse. Completa: «Si dos personas hacen este paso, el resultado puede ser distinto porque ______________________».

**Paso 3.** ¿Qué tendría que cambiar si quisieras **dos copias** del servicio (una para desarrollar y otra para probar)? ______________________

Ejemplo con Villa Nube: «Para tener desarrollo y pruebas tengo que repetir `docker run` cambiando el puerto, el nombre del contenedor y el volumen. Si me equivoco de puerto, las dos copias chocan».

## Ejercicio 2 · Sigue conmigo: Hola Terraform

*Individual, al mismo tiempo que el profesor · 10 minutos.* No necesita Docker ni nube. Marca la casilla cuando veas el resultado.

**Paso 1 · Entra a la carpeta y mira el código.**

```bash
cd clases/clase-05/01-hola-terraform
```

Abre `main.tf`. Tiene cuatro partes: **versiones**, **entradas** (`variable`), **recursos** (`resource`) y **salidas** (`output`). Los dos recursos son un archivo de texto (`local_file`) y un dato de configuración (`terraform_data`).

**Paso 2 · Prepara la carpeta.**

```bash
terraform init
```

- [ ] Leo `Terraform has been successfully initialized!`

**Paso 3 · Pide el plan.**

```bash
terraform plan
```

- [ ] Leo `Plan: 2 to add, 0 to change, 0 to destroy.` Todavía no se creó nada: el plan solo **muestra**.

**Paso 4 · Aplica.**

```bash
terraform apply
```

Terraform muestra el plan otra vez y pregunta `Enter a value:`. Escribe `yes` y Enter.

- [ ] Leo `Apply complete! Resources: 2 added` y las salidas `archivo` y `responsable`.
- [ ] Existe el archivo `salida/bienvenida.txt` y dice «Bienvenida a la API de Trámites de Villa Nube».
- [ ] Apareció un archivo nuevo: `terraform.tfstate`. Es la memoria de Terraform.

**Paso 5 · Dos cambios distintos.** Pide el plan cambiando una entrada, sin aplicar:

```bash
terraform plan -var 'equipo=Datos'
terraform plan -var 'ciudad=Villa Sol'
```

| Cambio | Símbolo que aparece | Resumen del plan |
| --- | --- | --- |
| `equipo=Datos` | | |
| `ciudad=Villa Sol` | | |

**Paso 6 · Bórralo.**

```bash
terraform destroy
```

Escribe `yes`.

- [ ] Leo `Destroy complete! Resources: 2 destroyed.` y el archivo desapareció.

Qué pasó: describiste lo que querías, Terraform calculó la diferencia entre eso y lo que existía, te la mostró, la hizo y la anotó en el estado. Así funciona siempre, sea un archivo, un contenedor o un servidor en AWS.

## Ejercicio 3 · Lee el plan antes de aceptar

*Individual, durante la explicación · 10 minutos.* Leer un plan es la habilidad más importante de hoy: es tu última oportunidad de detener un error antes de que pase.

**Los símbolos**

| Símbolo | En el plan dice | Qué significa | ¿Hay riesgo? |
| --- | --- | --- | --- |
| `+` | `will be created` | Crea algo nuevo | Bajo |
| `~` | `will be updated in-place` | Cambia algo sin borrarlo | Bajo o medio |
| `-/+` | `must be replaced` | **Lo borra y lo crea de nuevo** | Alto: puede cortar el servicio o perder datos |
| `-` | `will be destroyed` | Lo borra | Alto |

La frase que más importa buscar: `# forces replacement`. Te dice **qué cambio** obliga a reemplazar.

**Lee los planes guardados** en `ejercicios/planes/` (salieron de ejecutar este mismo código) y completa:

| Plan | ¿Qué recursos toca? | Resumen (`Plan: …`) | ¿Qué línea dice `forces replacement`? | ¿Lo aplicarías? ¿Por qué? |
| --- | --- | --- | --- | --- |
| `3-reemplazar.txt` (cambia los días de vigencia) | | | | |
| `4-reemplazo-en-cadena.txt` (cambia la versión a 1.1.0) | | | | |
| `6-destruir.txt` | | | | |

**Pregunta para pensar:** en `3-reemplazar.txt` el contenedor se reemplaza, pero el **volumen** no aparece en el plan. ¿Qué significa eso para las solicitudes que ya radicaron los ciudadanos? ¿Y en `6-destruir.txt`?

## Ejercicio 4 · Villa Nube como código

*Individual, siguiendo al profesor · 15 minutos.* Ahora Terraform hace lo que en la Clase 3 hiciste a mano: construye la imagen, crea el volumen y enciende el contenedor.

**Paso 1 · Entra, prepara y crea el workspace de desarrollo.**

```bash
cd ../infra-local          # desde 01-hola-terraform
terraform init
terraform workspace new desarrollo
```

- [ ] Leo `Created and switched to workspace "desarrollo"!`

**Paso 2 · Mira de dónde salen los datos.** Abre `proyectos/villa-nube.tfvars` (lo que define al servicio) y `entornos/desarrollo.tfvars` (lo que es propio de desarrollo). Completa:

| Dato | Valor | ¿En qué archivo está? |
| --- | --- | --- |
| Puerto dentro del contenedor | | |
| Puerto en tu computador | | |
| Días de vigencia del documento | | |
| Nivel de detalle de los registros (`LOG_LEVEL`) | | |

**Paso 3 · Plan y apply.** Los dos archivos van en cada comando:

```bash
terraform plan  -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars
terraform apply -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars
```

La primera vez tarda uno o dos minutos: está construyendo la imagen.

- [ ] El plan decía `3 to add` y leo `Apply complete! Resources: 3 added`.
- [ ] Abro http://localhost:8081/salud y veo `{"estado":"ok","version":"1.0.0"}`.

**Paso 4 · Las pruebas de la Clase 3, contra el entorno de desarrollo.**

```bash
URL=http://localhost:8081 bash ../../clase-04/villa-nube/scripts/verificar.sh
```

- [ ] Leo `Resultado: 5 pasaron, 0 fallaron`.
- [ ] Copio el `id` que aparece en la línea de P3: ______________________

**Paso 5 · Cambia una regla y lee el plan.** En `proyectos/villa-nube.tfvars` cambia `DIAS_VIGENCIA_DOCUMENTO = "90"` por `"30"`. Guarda y pide el plan (mismo comando del paso 3, con `plan`).

- [ ] El contenedor dice `must be replaced` y el volumen no aparece.

Aplica (`apply`, `yes`). Luego consulta la solicitud del paso 4, cambiando `EL-ID` por el que copiaste:

```bash
curl http://localhost:8081/solicitudes/EL-ID
```

- [ ] La solicitud sigue ahí: el contenedor es nuevo, pero los datos viven en el volumen.

**Paso 6 · Vuelve a 90 días** y aplica de nuevo. No destruyas todavía: lo usamos en el ejercicio 6.

## Ejercicio 5 · Completa el módulo

*En equipo · 10 minutos.* Abre `ejercicios/completa-el-modulo/main.tf.plantilla` y completa cada `___` con una palabra del banco. Cada palabra se usa una vez.

**Banco de palabras:** `docker_image` · `docker_container` · `image_id` · `puerto_interno` · `puerto_externo` · `variables_app` · `entorno` · `build`

```hcl
# 1. La imagen (equivale a docker build)
resource "___" "app" {
  name         = "${var.nombre}:${var.version_app}"
  keep_locally = true

  ___ {
    context = var.carpeta_app
  }
}

# 2. El contenedor (equivale a docker run)
resource "___" "app" {
  name  = "${var.nombre}-${var.___}"
  image = docker_image.app.___

  ports {
    internal = var.___   # dónde escucha la app DENTRO del contenedor
    external = var.___   # por dónde entras TÚ desde el navegador
  }

  env = [for clave, valor in var.___ : "${clave}=${valor}"]
}
```

**Para comprobar:** compara con `infra-local/modules/servicio-web/main.tf`.

**Dos preguntas para el equipo**

1. ¿Por qué el nombre del contenedor lleva `var.entorno`? *Pista: piensa en qué pasa si desarrollo y pruebas se llaman igual.*
2. Une cada parte del módulo con el comando de la Clase 3 que reemplaza: `docker build`, `docker volume create`, `docker run -p`, `docker run -e`.

## Ejercicio 6 · Un código, dos entornos y su memoria

*Individual o en parejas · 15 minutos.*

**Paso 1 · Crea el entorno de pruebas** con el mismo código, en otro workspace:

```bash
terraform workspace new pruebas
terraform apply -var-file=proyectos/villa-nube.tfvars -var-file=entornos/pruebas.tfvars
docker ps
```

- [ ] `docker ps` muestra **dos** contenedores: `villa-nube-desarrollo` (puerto 8081) y `villa-nube-pruebas` (puerto 8082).
- [ ] `terraform workspace list` muestra `desarrollo` y `* pruebas` (el asterisco es donde estás).

**Paso 2 · Provoca el error de la guardia.** Estando en el workspace `pruebas`, pide el plan con el archivo de **desarrollo**:

```bash
terraform plan -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars
```

- [ ] Terraform se niega: `Estás en el workspace "pruebas" pero usaste el archivo del entorno "desarrollo"`.

Esa guardia la escribimos nosotros en `outputs.tf`. ¿Qué habría pasado sin ella? ______________________

**Paso 3 · ¿Qué cambia entre entornos y qué no?** Completa para Villa Nube y luego para tu proyecto:

| Dato | ¿Igual en todos los entornos o cambia? | ¿En qué archivo va? |
| --- | --- | --- |
| El Dockerfile y el código | | |
| El puerto en tu computador | | |
| La regla de los días de vigencia | | |
| El nivel de detalle de los registros | | |
| La contraseña de la base de datos | | *(pista: en ninguno de los dos)* |

**Paso 4 · Abre la memoria de Terraform.** Abre `ejercicios/estado/estado-ejemplo.json` (es el estado real del entorno de desarrollo) y busca con Ctrl+F:

| Busca | ¿Qué encontraste? |
| --- | --- |
| `"env"` | |
| `"external"` | |
| `"serial"` | |

Si en `variables_app` hubiera una contraseña, **también quedaría escrita en el estado**. Por eso el estado no se sube a GitHub (mira el `.gitignore`) y se trata como información sensible.

**Paso 5 · ¿Y en un equipo?** Si el estado vive en tu computador, nadie más puede cambiar la infraestructura sin pisarte. Lee `aws-opcional/backend.tf.ejemplo` y responde:

1. ¿Dónde se guarda el estado? ______________________
2. ¿Qué hace `use_lockfile = true`? ______________________

**Paso 6 · Limpia.** Destruye los dos entornos:

```bash
terraform destroy -var-file=proyectos/villa-nube.tfvars -var-file=entornos/pruebas.tfvars
terraform workspace select desarrollo
terraform destroy -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars
```

- [ ] `docker ps` ya no muestra contenedores de Villa Nube.

## Ejercicio 7 · Tu proyecto como código

*Individual o con tu equipo de proyecto · 35 minutos.* Ahora describes tu proyecto con el mismo módulo.

**Paso 0 · Elige tu proyecto.** Si tu proyecto tiene Dockerfile, úsalo. Si no, elige un proyecto de práctica: ya tienen su archivo listo en `infra-local/proyectos/`.

| Proyecto | Archivo | Para probar (desarrollo) |
| --- | --- | --- |
| Mercado Raíces | `proyectos/mercado-raices.tfvars` | http://localhost:8081/salud |
| BiciBarrio | `proyectos/bici-barrio.tfvars` | http://localhost:8081/salud |
| Biblioteca La Esquina | `proyectos/biblioteca-barrio.tfvars` | http://localhost:8081/ |
| El tuyo | Copia `proyectos/mi-proyecto.tfvars.plantilla` como `proyectos/mi-proyecto.tfvars` | La ruta de tu prueba 1 |

**Paso 1 · Si es tu proyecto, completa la plantilla.** Cambia cada valor marcado con `CAMBIA`:

- `nombre`: en minúsculas y con guiones.
- `carpeta_app`: la carpeta con tu Dockerfile, **contada desde `infra-local`**. Si tu proyecto está en `~/mi-proyecto` y el curso en `~/estudia-nube`, es `"../../../../mi-proyecto"`.
- `puerto_interno`: el de `EXPOSE` en tu Dockerfile.
- `ruta_datos`: si tu app guarda datos en una carpeta (por ejemplo `/data`); si no, deja `""`.
- `variables_app`: la configuración que lee tu app. **Nunca contraseñas reales.**

**Paso 2 · Formato, validación y plan.**

```bash
terraform workspace select desarrollo
terraform fmt -recursive
terraform validate
terraform plan -var-file=proyectos/MI-ARCHIVO.tfvars -var-file=entornos/desarrollo.tfvars
```

- [ ] `validate` dice `Success! The configuration is valid.`
- [ ] Leí el plan: cuántos recursos crea y cuáles son: ______________________

**Paso 3 · Apply y prueba de humo.**

- [ ] `apply` termina en `Apply complete!` y la ruta de mi prueba 1 responde en el puerto 8081.

Si falla, lee la primera línea con `Error` y busca en la tabla de problemas frecuentes al final.

**Paso 4 · Prueba el reemplazo.** Cambia **una** variable de `variables_app` (o la versión) y pide el plan. Anota:

| Lo que cambié | Lo que el plan dice que hará | ¿Pierdo datos? ¿Se corta el servicio? |
| --- | --- | --- |
| | | |

**Paso 5 · Escribe en tu README la sección «Cómo se crea el entorno».**

```markdown
## Cómo se crea el entorno

Requisitos: Docker y Terraform 1.10 o más nuevo.

En la carpeta `infra-local`:

    terraform init
    terraform workspace new desarrollo
    terraform apply -var-file=proyectos/[mi-archivo].tfvars -var-file=entornos/desarrollo.tfvars

El servicio queda en http://localhost:8081. Para borrarlo: `terraform destroy` con los mismos archivos.

Qué crea: [imagen, contenedor, volumen…]
Qué cambia entre desarrollo y pruebas: [puerto, registros…]
Lo que todavía NO está como código: [por ejemplo: la base de datos, la red, la nube]
```

**Paso 6 · Destruye** tu entorno al terminar: `terraform destroy` con los mismos dos archivos.

**¿Tienes cuenta de AWS?** (opcional) En `aws-opcional/` está el mismo flujo para un bucket S3 privado, cifrado y con versiones. Lee su `README.md` **antes** de aplicar, y destruye al terminar. Si no tienes cuenta, lee el plan guardado `ejercicios/planes/aws-crear-bucket.txt`: es lo que verías.

**El pipeline también revisa Terraform.** En tu fork, pestaña **Actions** → **Clase 5 · Terraform** → **Run workflow**. Ese workflow revisa el formato, valida, publica el plan en el resumen de la ejecución y crea un **entorno efímero**: aplica en la máquina de GitHub, corre las pruebas de la Clase 3 y lo destruye. Es lo que viste en la Clase 4, ahora con infraestructura.

## Ejercicio 8 · Mesa del arquitecto

*En grupos · 25 minutos.* Platzi te enseña **cómo** se usa Terraform. Esta mesa es para discutir **cuándo vale la pena, qué cuesta y quién responde**. No hay una respuesta única: gana el mejor argumento.

**Parte A · ¿Consola, script o Terraform? (10 minutos)**

1. **Antes de hablar**, vota en el chat qué usarías en cada caso: **C** (consola, a mano), **S** (un script con comandos) o **T** (Terraform).
2. En tu grupo, defiendan su elección con al menos **tres criterios** de las tarjetas.
3. Una persona del grupo hace de **gerente** (pregunta «¿cuánto cuesta y cuánto se demora?») y otra de **seguridad** (pregunta «¿quién puede cambiar esto y cómo nos enteramos?»).

| Caso | Mi voto | El voto del grupo y su mejor argumento |
| --- | --- | --- |
| **1.** Una tienda de barrio tiene una sola página web en un servidor que se configura una vez al año | | |
| **2.** Villa Nube necesita desarrollo, pruebas y producción iguales, y tres personas cambian la infraestructura cada semana | | |
| **3.** Un emprendimiento quiere probar una idea en dos semanas y nadie del equipo sabe Terraform | | |

**Tarjetas de criterios:** costo · tiempo para empezar · repetir igual · riesgo de error humano · quién lo mantiene · saber quién cambió qué y cuándo · facilidad para deshacer.

**Parte B · El código que escribió la IA (10 minutos)**

Abre `ejercicios/ia/main-generado-por-ia.tf`. Un asistente de IA recibió esta petición: *«Hazme el Terraform para subir la API de Villa Nube a AWS con su base de datos, rápido, que funcione a la primera»*. El código funciona… pero ¿lo aplicarías?

Encuentren **al menos cinco problemas**. Busquen: claves escritas en el código, puertos abiertos a todo internet (`0.0.0.0/0`), datos que se pueden perder, costos exagerados, cosas públicas que deberían ser privadas.

| Línea o recurso | El problema | Qué podría pasar | Cómo lo corregirían |
| --- | --- | --- | --- |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |

**Para cerrar:** reescriban la **petición a la IA** para que el resultado sea seguro desde el principio: ______________________

La IA escribe Terraform en segundos. **Leer el plan, detectar el riesgo y decidir si se aplica sigue siendo tu trabajo.** Ese es el rol del arquitecto.

**Parte C · Tu primera decisión escrita (5 minutos)**

Copia `adr/plantilla-adr.md` en tu proyecto como `docs/adr/ADR-001.md` y escribe la decisión de hoy: ¿cómo vas a describir y crear el entorno de tu proyecto, y por qué? Mira el ejemplo `adr/ADR-000-ejemplo-villa-nube.md`. Basta con tres opciones, una decisión y dos consecuencias.

## Ejercicio 9 · Exit ticket y preparación para la Clase 6

*Individual · 5 minutos.* Responde en el formulario o por chat privado al profesor.

1. En una frase: ¿qué diferencia hay entre `terraform plan` y `terraform apply`?
2. ¿Por qué el archivo `terraform.tfstate` no se sube a GitHub?
3. En tu proyecto, ¿qué cambia entre desarrollo y pruebas?
4. ¿Qué fue lo más difícil hoy?

**Antes de la Clase 6**

- [ ] Tu archivo `.tfvars`, tu sección «Cómo se crea el entorno» y tu `ADR-001` están en GitHub.
- [ ] Sabes qué versión de tu servicio es la **estable** (por ejemplo, `1.0.0`) y cómo se ve en `/salud` o en la etiqueta de la imagen.
- [ ] Platzi: avanza en M3 · Despliegue. Mientras lo ves, piensa: «si publico una versión nueva y falla, ¿cómo vuelvo a la anterior y cómo sé que volví?».

En la Clase 6 publicamos una versión con un error a propósito, la detectamos con una prueba de salud y la revertimos.

## Comandos, problemas frecuentes y retos

**Los comandos de Villa Nube, de corrido**

```bash
cd clases/clase-05/infra-local
terraform init
terraform workspace new desarrollo        # la primera vez; después: workspace select desarrollo
terraform plan    -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars
terraform apply   -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars
terraform output                          # vuelve a mostrar las salidas
terraform state list                      # lista lo que Terraform recuerda haber creado
terraform destroy -var-file=proyectos/villa-nube.tfvars -var-file=entornos/desarrollo.tfvars
```

**Si algo falla**

| Lo que pasa | Qué revisar |
| --- | --- |
| `terraform: command not found` | Terraform no está instalado o la terminal se abrió antes de instalarlo: ciérrala y ábrela |
| `Cannot connect to the Docker daemon` o `error during connect` | Abre Docker Desktop y espera a que diga *running*. En Windows, si sigue, agrega `-var 'docker_host=npipe:////.//pipe//docker_engine'` |
| `Error: Inconsistent dependency lock file` o `Required plugins are not installed` | Te faltó `terraform init` en esta carpeta |
| `No value for required variable` | Te faltó uno de los dos `-var-file` |
| `Module output value precondition failed` | El workspace no coincide con el archivo de entorno: `terraform workspace select <entorno>` |
| `port is already allocated` | Otro contenedor usa ese puerto (quizás de la Clase 3 o 4): `docker ps` y `docker stop <nombre>` |
| El build de la imagen falla | Revisa `carpeta_app`: se cuenta desde `infra-local` y debe llegar a la carpeta del Dockerfile |
| `Error: Invalid value for variable` | Una validación te avisa: lee el mensaje (nombre en minúsculas, entorno, puerto) |
| El plan quiere reemplazar algo que no cambiaste | Busca `# forces replacement`: esa línea dice qué lo provoca. **No apliques para averiguarlo** |
| Borré `terraform.tfstate` y el contenedor sigue ahí | Terraform «olvidó» lo que creó. Bórralo a mano con `docker rm -f <nombre>` y vuelve a aplicar |

**Retos opcionales, si terminas antes**

- Agrega al módulo una salida `version` que muestre la versión de la app, y úsala en el README.
- Protege el volumen de datos para que `terraform destroy` no lo borre: busca `lifecycle { prevent_destroy = true }`. ¿Qué pasa al destruir?
- Ejecuta `terraform plan -out=plan.tfplan` y luego `terraform apply plan.tfplan`. ¿Por qué esto es más seguro que `apply` solo?
- Crea en tu fork un *environment* llamado `pruebas` con aprobación obligatoria (Settings → Environments) y úsalo en el job `efimero` del workflow. ¿Qué cambia?
- Ayuda a otra persona de tu sala: explicar es la mejor forma de aprender.

> Material de apoyo generado con asistencia de IA y revisado por el profesor del curso.
