fetch("PHP/articulosSinFoto/Consulta.php")
  .then((response) => response.json())
  .then((data) => {
    mostrarArticulosSinImagen(data);
  })
  .catch((error) =>
    console.error("Error al obtener los artículos sin imagen:", error)
  );

  function mostrarArticulosSinImagen(articulos) {
    const tbody = document.querySelector('#articulosSinFoto tbody');
    articulos.forEach(articulo => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${articulo.id}</td>
            <td>${articulo.codigo_sap}</td>
            <td>${articulo.descripcion}</td>
            <td>${articulo.empresa}</td>
            <td>${articulo.agrupacion_familia}</td>
            <td>${articulo.familia}</td>
            <td>${articulo.mostrar}</td>
            <td>${articulo.borrado}</td>
        `;
        tbody.appendChild(tr);
    });
}
