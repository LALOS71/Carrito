let mensajeDeCarga = function () {
  bootbox.dialog({
    message:
      '<p class="text-center mb-0"><i class="fas fa-spin fa-cog"></i> Porfavor espere mientras se sube la foto...</p>',
    closeButton: false,
  });
};
let mensajeDeError = function (mensaje) {
	bootbox.alert(`Error: ${mensaje}`,
                            function() {
  								bootbox.hideAll();
                            });
//   bootbox.alert({

//     message: `<p class="text-center mb-0">Error: ${mensaje}</p>`,
//     closeButton: false,
//   });
};

let mostrar_imagen_articulo = function (codigo) {
  cadena = '<div align="center"><div class="row my-auto">';
  cadena = cadena + '<div class="mx-auto text-center">';
  cadena = cadena + "<span>";
  cadena =
    cadena +
    '<a href="Imagenes_Articulos/' +
    codigo +
    '.jpg" target="_blank" id="imagen_enlace">';
  /*cadena=cadena + '<a href="Imagenes_Articulos/' + codigo + '.jpg" target="_blank" id="imagen_enlace">'*/
  cadena =
    cadena +
    '<img class="img-responsive" src="Imagenes_Articulos/Miniaturas/i_' +
    codigo +
    ".jpg?t=" +
    new Date().getTime() +
    '" border="0" id="imagen_articulo"></a>';
  /* cadena=cadena + '<img class="img-responsive" src="Imagenes_Articulos/Miniaturas/i_' + codigo + '.jpg" border="0" id="imagen_articulo"></a>' */
  cadena = cadena + "</span>";
  cadena =
    cadena +
    '<br><label class="control-label">Pulsar sobre la imagen para verla a tamaño real</label>';
  cadena = cadena + "</div>";
  cadena = cadena + "</div>";
  cadena = cadena + "</div>";
  bootbox.hideAll();

  bootbox.dialog({
    message: cadena,
    onEscape: true,
    backdrop: true,
    size: "large",
    buttons: {
      darDeBaja: {
        label: "Dar de baja",
        className: "btn-danger",
        callback: function () {
          let formData = new FormData();
          formData.append("codigo", codigo);
          formData.append("baja", "true");
          fetch("./PHP/SubidaImagenArticulo/GestionarImagen.php", {
            method: "POST",
            body: formData,
          })
            .then((response) => {
              if (!response.ok) {
                throw new Error("Hubo un problema al procesar la solicitud.");
              }

              mostrar_imagen_articulo(codigo);
            })
            .catch((error) => {
              console.error("Error:", error);
              // Maneja errores si es necesario
            });
          return false;
        },
      },
      subirImagen: {
        label: "Seleccionar Imagen",
        className: "btn-primary",
        callback: function () {
          if (!document.querySelector("#formularioImagenes")) {
            // let botonDeSeleccionar=document.querySelector("button[data-bb-handler=subirImagen");
            let form = document.createElement("form");
            form.setAttribute("id", "formularioImagenes");
            form.setAttribute("action", "#");
            form.setAttribute("method", "POST");
            form.setAttribute("enctype", "multipart/form-data");
            form.setAttribute("class", "d-flex");

            //Creando el input file
            let fileInput = document.createElement("input");
            fileInput.setAttribute("type", "file");
            fileInput.setAttribute("id", "foto");
            fileInput.setAttribute("name", "imagen");
            fileInput.classList.add("form-control");
            form.appendChild(fileInput);

            // Botón de envío
            let submitButton = document.createElement("input");
            submitButton.setAttribute("type", "submit");
            /* submitButton.setAttribute('class', ''); */
            submitButton.classList.add("btn", "btn-primary");
            submitButton.setAttribute("value", "Subir imagen");

            form.appendChild(submitButton);

            //Añadiendolo al documento
            document.querySelector(".modal-body").appendChild(form);
            // botonDeSeleccionar.display.none;
          }

          document
            .getElementById("formularioImagenes")
            .addEventListener("submit", function (event) {
              event.preventDefault();
              let formData = new FormData(this);
              formData.append("codigo", codigo);
              mensajeDeCarga();
              fetch("./PHP/SubidaImagenArticulo/GestionarImagen.php", {
                /* headers: {
    									'Cache-Control': 'no-cache',
    									'Pragma': 'no-cache',
    									'Expires': '0'
 										}, */
                method: "POST",
                body: formData,
              })
                .then((response) => {
                  if (!response.ok) {
                    throw new Error(
                      "Hubo un problema al procesar la solicitud."
                    );
				}
				mostrar_imagen_articulo(codigo);
                  return response.json(); // Convertir la respuesta a JSON
                })
                .then((data) => {
                  if (data.error !== undefined) {
                    // console.log("No es un JPG");
					mensajeDeError(data.error);
                    // Manejar el caso específico de error
                  } else {
					mostrar_imagen_articulo(codigo);
                    // Manejar otros casos o el éxito
                  }
                })
                .catch((error) => {
                  console.error("Error:", error);
                  // Manejar errores si es necesario
                });
            });
          return false;
        },
      },
      ok: {
        label: "OK",
        className: "btn-primary",
        callback: function () {
          bootbox.hideAll();
          let imagenMostrada = document.querySelector("#imagen_articulo");
          // let src = imagenMostrada.getAttribute("src");
          let srcNueva =
            imagenMostrada.getAttribute("src") +
            "?timestamp=" +
            new Date().getTime();
          imagenMostrada.setAttribute("src", srcNueva);
        },
      },
    },
  });
};
