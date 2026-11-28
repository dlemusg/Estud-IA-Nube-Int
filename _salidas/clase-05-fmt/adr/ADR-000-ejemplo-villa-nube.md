# ADR-000 · Describir el entorno local de Villa Nube con Terraform

**Fecha:** 2026-12-01 · **Estado:** aceptada (ejemplo del curso)

## Contexto
Hasta la Clase 4, Villa Nube se encendía con comandos escritos a mano (`docker build`, `docker run`) o con Compose. Cada persona del equipo lo hacía distinto, y para tener dos entornos (desarrollo y pruebas) había que repetir los comandos cambiando puertos y nombres. El curso pide aprender infraestructura como código, pero el grupo no tiene cuentas de nube para todos.

## Opciones que consideramos
| Opción | A favor | En contra |
|---|---|---|
| A · Seguir con comandos en el README | Nada nuevo que aprender | Cada persona lo hace distinto; nadie sabe qué está encendido |
| B · Docker Compose | Simple, ya lo conocemos | No muestra un plan antes de cambiar; manejar dos entornos es manual |
| C · Terraform con el proveedor Docker | Plan antes de cambiar, estado, módulos y entornos; el mismo flujo sirve después en AWS | Una herramienta más; el estado hay que cuidarlo |

## Decisión
Elegimos **C · Terraform con el proveedor Docker** porque enseña el flujo completo de infraestructura como código (plan, apply, estado, módulos, entornos) sin costo y sin cuenta en la nube, y el mismo flujo se usa luego con AWS.

## Consecuencias
- Ganamos: un mismo código para desarrollo y pruebas, y ver el plan antes de cambiar.
- Aceptamos: el estado vive en cada computador (no sirve para trabajar en equipo) y Compose sigue siendo más rápido para el día a día.
- Revisar cuando: el proyecto pase a una nube real; ahí el estado debe ir a un backend remoto con bloqueo.
