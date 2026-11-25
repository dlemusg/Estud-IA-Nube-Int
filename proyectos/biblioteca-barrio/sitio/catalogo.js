// Carga libros.json y filtra la lista mientras escribes
let libros = [];

function mostrar(filtro) {
  const texto = filtro.toLowerCase();
  const visibles = libros.filter(
    (l) => l.titulo.toLowerCase().includes(texto) || l.autor.toLowerCase().includes(texto)
  );
  document.getElementById("resumen").textContent =
    `${visibles.length} de ${libros.length} libros · ${visibles.filter((l) => l.disponible).length} disponibles`;
  document.getElementById("libros").innerHTML = visibles
    .map((l) => `<li class="${l.disponible ? "" : "prestado"}"><span class="estado">${l.disponible ? "Disponible" : "Prestado"}</span><b>${l.titulo}</b><br>${l.autor}</li>`)
    .join("");
}

fetch("libros.json")
  .then((r) => r.json())
  .then((datos) => {
    libros = datos.libros;
    mostrar("");
  });

document.getElementById("buscar").addEventListener("input", (e) => mostrar(e.target.value));
