// Pruebas de BiciBarrio. Se corren con:  npm test
const { test, before, after } = require("node:test");
const assert = require("node:assert");
const { crearApp } = require("../src/app");

let servidor;
let url;

before(async () => {
  servidor = crearApp().listen(0);
  await new Promise((r) => servidor.once("listening", r));
  url = `http://127.0.0.1:${servidor.address().port}`;
});
after(() => servidor.close());

const pedir = (ruta, cuerpo) =>
  fetch(url + ruta, cuerpo ? { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(cuerpo) } : {});

test("salud responde ok", async () => {
  const r = await pedir("/salud");
  assert.strictEqual(r.status, 200);
  assert.strictEqual((await r.json()).estado, "ok");
});

test("lista tres estaciones", async () => {
  const datos = await (await pedir("/estaciones")).json();
  assert.strictEqual(datos.estaciones.length, 3);
});

test("presta una bicicleta", async () => {
  const r = await pedir("/prestamos", { usuario: "ana", estacion: "parque" });
  assert.strictEqual(r.status, 201);
});

test("una persona no puede tener dos préstamos activos", async () => {
  const r = await pedir("/prestamos", { usuario: "ana", estacion: "biblioteca" });
  assert.strictEqual(r.status, 409);
});

test("no presta en una estación sin bicicletas", async () => {
  const r = await pedir("/prestamos", { usuario: "luis", estacion: "cancha" });
  assert.strictEqual(r.status, 409);
});
