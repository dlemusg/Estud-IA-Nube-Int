# Estud-IA · Arquitectura en la nube · Nivel intermedio

Repositorio de trabajo del curso **Capa 2 · Arquitectura en la nube, nivel intermedio** del programa Estud-IA. Cada clase tiene su propia carpeta con la guía del estudiante, el laboratorio y las plantillas que se usan ese día.

**No necesitas experiencia previa con Docker.** Las clases van paso a paso: primero lo hace el profesor, luego lo haces con él y después en tu proyecto.

## Clases

| Clase | Semana | Tema | Carpeta |
|---|---|---|---|
| 1 | 1 | Comunidad, pacto y repaso del nivel básico | En clase |
| 2 | 1 | Del negocio a la infraestructura: DDD, draft de arquitectura y atributos de calidad | En clase |
| 3 | 2 | Del draft al contenedor: Docker paso a paso | [`clases/clase-03`](clases/clase-03/README.md) |
| 4 | 2 | Integración continua con GitHub Actions | [`clases/clase-04`](clases/clase-04/README.md) |
| 5 | 3 | Infraestructura como código y entornos con Terraform | [`clases/clase-05`](clases/clase-05/README.md) |
| 6 | 3 | Actualización, salud y reversión | Próximamente |
| 7–8 | 4 | Redes, exposición del servicio y observabilidad | Próximamente |
| 9–10 | 5 | Auditoría, portafolio y defensa | Próximamente |

## ¿No tienes proyecto propio?

En [`proyectos/`](proyectos/README.md) hay tres proyectos de práctica para elegir y usar en las clases: **Mercado Raíces** (Python), **BiciBarrio** (Node.js) y **Biblioteca La Esquina** (sitio estático). Cada uno tiene un negocio, una regla, pruebas y un Dockerfile.

## Cómo está organizado

```
clases/
  clase-03/
    README.md          guía del estudiante y ejercicios de la clase
    villa-nube/        el laboratorio tal como queda al final de esa clase
  clase-04/
    README.md          guía del estudiante de la Clase 4
    villa-nube/        lo de la Clase 3 + pruebas automáticas (ci/, fallas-ci/)
  clase-05/
    README.md          guía del estudiante de la Clase 5
    01-hola-terraform/ primer Terraform, sin Docker ni nube
    infra-local/       Villa Nube y los proyectos de práctica como código (Terraform + Docker)
    ejercicios/        planes guardados, plantilla, estado de ejemplo y código de la IA
    aws-opcional/      lo mismo en AWS, para quien tiene cuenta
    adr/               plantilla y ejemplo de registro de decisiones
.github/workflows/     los workflows de GitHub Actions (Clase 4 en adelante)
proyectos/             proyectos de práctica para quien no tiene uno propio
.devcontainer/         entorno de GitHub Codespaces para todo el curso (Docker y Terraform)
```

Cada carpeta de clase es **completa y funciona sola**: si te atrasas o faltaste, entra a la carpeta de la clase y arranca desde ahí. El laboratorio de una clase parte del de la anterior y le agrega una capa (contenedor, integración continua, despliegue, infraestructura como código, red y observación).

## Empezar

1. Instala [Docker Desktop](https://www.docker.com/products/docker-desktop/) y ábrelo. En una terminal (en Windows, Git Bash) escribe `docker run hello-world`: debe aparecer «Hello from Docker!».
2. Descarga el repositorio y entra a la carpeta de la clase:

```bash
git clone https://github.com/dlemusg/Estud-IA-Nube-Int.git estudia-nube
cd estudia-nube/clases/clase-03/villa-nube
```

3. Para recibir las carpetas de las clases siguientes, en la carpeta `estudia-nube` escribe `git pull`.

**¿No puedes instalar Docker?** En esta página de GitHub: botón **Code** → **Codespaces** → **Create codespace on main**. Se abre un editor en el navegador que ya trae Docker; en su terminal escribe `cd clases/clase-03/villa-nube`.

## El caso: Villa Nube

Villa Nube es una alcaldía ficticia. Su **API de Trámites** permite que un ciudadano radique una solicitud de certificado de residencia y la consulte. Es el caso que modelamos en la Clase 2 y el laboratorio de todo el curso. No tiene datos reales.

> Material de apoyo generado con asistencia de IA y revisado por el profesor del curso.
