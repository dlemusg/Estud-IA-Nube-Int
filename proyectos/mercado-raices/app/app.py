"""
Mercado Raíces · API de pedidos
Proyecto de práctica del curso Estud-IA · Nube Intermedio (caso ficticio).

Una cooperativa de 40 familias campesinas recibe pedidos de tiendas de barrio.
Hoy los pedidos llegan por WhatsApp y se pierden; esta API los recibe y valida.

Configuración por variables de entorno:
  PEDIDO_MINIMO   valor mínimo de un pedido en pesos (por defecto 20000)
  PORT            puerto en el que escucha gunicorn (por defecto 8080)
"""
import os
import uuid

from flask import Flask, jsonify, request

app = Flask(__name__)
app.json.ensure_ascii = False  # tildes legibles en las respuestas

PEDIDO_MINIMO = int(os.getenv("PEDIDO_MINIMO", "20000"))

# Catálogo de ejemplo (en una versión real vendría de una base de datos)
PRODUCTOS = {
    "papa-criolla": {"nombre": "Papa criolla (kg)", "precio": 4500, "stock": 120},
    "tomate": {"nombre": "Tomate chonto (kg)", "precio": 3800, "stock": 80},
    "cebolla": {"nombre": "Cebolla larga (atado)", "precio": 2500, "stock": 60},
    "aguacate": {"nombre": "Aguacate hass (unidad)", "precio": 3000, "stock": 40},
    "cafe": {"nombre": "Café de origen (libra)", "precio": 18000, "stock": 25},
}

PEDIDOS = {}


@app.get("/salud")
def salud():
    return jsonify(estado="ok", servicio="mercado-raices")


@app.get("/productos")
def productos():
    lista = [{"id": pid, **datos} for pid, datos in PRODUCTOS.items()]
    return jsonify(productos=lista)


@app.post("/pedidos")
def crear_pedido():
    datos = request.get_json(silent=True) or {}
    cliente = (datos.get("cliente") or "").strip()
    items = datos.get("items") or []

    if not cliente:
        return jsonify(error="El campo 'cliente' es obligatorio"), 400
    if not items:
        return jsonify(error="El pedido debe tener al menos un producto"), 400

    total = 0
    for item in items:
        pid = item.get("producto")
        cantidad = item.get("cantidad", 0)
        if pid not in PRODUCTOS:
            return jsonify(error=f"Producto desconocido: {pid}"), 404
        if not isinstance(cantidad, int) or cantidad < 1:
            return jsonify(error="La cantidad debe ser un número entero mayor que 0"), 400
        if cantidad > PRODUCTOS[pid]["stock"]:
            return jsonify(error=f"No hay suficiente {PRODUCTOS[pid]['nombre']}"), 409
        total += PRODUCTOS[pid]["precio"] * cantidad

    # Regla del negocio: la cooperativa no despacha pedidos pequeños
    if total < PEDIDO_MINIMO:
        return jsonify(error=f"Pedido mínimo: {PEDIDO_MINIMO} pesos", total=total), 422

    for item in items:
        PRODUCTOS[item["producto"]]["stock"] -= item["cantidad"]

    pid = uuid.uuid4().hex[:8]
    PEDIDOS[pid] = {"id": pid, "cliente": cliente, "items": items, "total": total, "estado": "RECIBIDO"}
    return jsonify(PEDIDOS[pid]), 201


@app.get("/pedidos/<pid>")
def ver_pedido(pid):
    if pid not in PEDIDOS:
        return jsonify(error="Pedido no encontrado"), 404
    return jsonify(PEDIDOS[pid])
