// BiciBarrio · API de préstamo de bicicletas comunitarias
// Proyecto de práctica del curso Estud-IA · Nube Intermedio (caso ficticio).
//
// Una junta de acción comunal presta bicicletas en tres estaciones del barrio.
// Hoy llevan el registro en un cuaderno; esta API lo reemplaza.
//
// Configuración por variables de entorno:
//   MAX_MINUTOS  duración máxima de un préstamo (por defecto 120)
//   PORT         puerto en el que escucha (por defecto 3000)

const express = require("express");

function crearApp() {
  const app = express();
  app.use(express.json());

  const MAX_MINUTOS = Number(process.env.MAX_MINUTOS || 120);

  // Datos de ejemplo (en una versión real vendrían de una base de datos)
  const estaciones = {
    parque: { nombre: "Parque principal", bicis: 4 },
    biblioteca: { nombre: "Biblioteca", bicis: 2 },
    cancha: { nombre: "Cancha", bicis: 0 },
  };
  const prestamos = {};
  let siguiente = 1;

  app.get("/salud", (req, res) => res.json({ estado: "ok", servicio: "bici-barrio" }));

  app.get("/estaciones", (req, res) => {
    const lista = Object.entries(estaciones).map(([id, e]) => ({ id, ...e }));
    res.json({ estaciones: lista });
  });

  app.post("/prestamos", (req, res) => {
    const { usuario, estacion } = req.body || {};
    if (!usuario) return res.status(400).json({ error: "El campo 'usuario' es obligatorio" });
    if (!estaciones[estacion]) return res.status(404).json({ error: `Estación desconocida: ${estacion}` });

    // Regla del negocio: una persona solo puede tener un préstamo activo
    const activo = Object.values(prestamos).find((p) => p.usuario === usuario && p.estado === "ACTIVO");
    if (activo) return res.status(409).json({ error: "Ya tienes una bicicleta prestada" });

    if (estaciones[estacion].bicis === 0) {
      return res.status(409).json({ error: "No hay bicicletas en esta estación" });
    }

    estaciones[estacion].bicis -= 1;
    const id = String(siguiente++);
    prestamos[id] = { id, usuario, estacion, estado: "ACTIVO", max_minutos: MAX_MINUTOS };
    res.status(201).json(prestamos[id]);
  });

  app.post("/prestamos/:id/devolucion", (req, res) => {
    const p = prestamos[req.params.id];
    if (!p) return res.status(404).json({ error: "Préstamo no encontrado" });
    if (p.estado !== "ACTIVO") return res.status(409).json({ error: "Este préstamo ya fue devuelto" });
    p.estado = "DEVUELTO";
    estaciones[p.estacion].bicis += 1;
    res.json(p);
  });

  return app;
}

module.exports = { crearApp };
