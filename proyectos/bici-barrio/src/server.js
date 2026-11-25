const { crearApp } = require("./app");

const PORT = Number(process.env.PORT || 3000);

// 0.0.0.0: escuchar en todas las interfaces (necesario dentro de un contenedor)
crearApp().listen(PORT, "0.0.0.0", () => {
  console.log(`BiciBarrio escuchando en el puerto ${PORT}`);
});
