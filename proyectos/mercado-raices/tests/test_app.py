"""Pruebas de Mercado Raíces. Se corren con:  pytest -v"""
import importlib
import os
import sys

import pytest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "app"))


@pytest.fixture()
def cliente():
    import app as modulo

    modulo = importlib.reload(modulo)  # catálogo y pedidos limpios en cada prueba
    return modulo.app.test_client()


def test_salud(cliente):
    r = cliente.get("/salud")
    assert r.status_code == 200
    assert r.get_json()["estado"] == "ok"


def test_lista_productos(cliente):
    productos = cliente.get("/productos").get_json()["productos"]
    assert len(productos) == 5


def test_pedido_valido(cliente):
    r = cliente.post("/pedidos", json={"cliente": "Tienda Don Luis", "items": [{"producto": "cafe", "cantidad": 2}]})
    assert r.status_code == 201
    assert r.get_json()["total"] == 36000


def test_pedido_minimo(cliente):
    r = cliente.post("/pedidos", json={"cliente": "Tienda Don Luis", "items": [{"producto": "cebolla", "cantidad": 1}]})
    assert r.status_code == 422


def test_producto_desconocido(cliente):
    r = cliente.post("/pedidos", json={"cliente": "Tienda Don Luis", "items": [{"producto": "mango", "cantidad": 10}]})
    assert r.status_code == 404


def test_sin_stock(cliente):
    r = cliente.post("/pedidos", json={"cliente": "Tienda Don Luis", "items": [{"producto": "cafe", "cantidad": 100}]})
    assert r.status_code == 409
