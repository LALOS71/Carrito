<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- <link rel="stylesheet" type="text/css" href="plugins/bootstrap-4.6.2/css/bootstrap.min.css" /> -->
    <link rel="stylesheet" type="text/css" href="../../plugins/bootstrap-5.3.3/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../../estilos.css" />
    <title>Solicitar alta</title>
    <style>
        body {
            padding-top: 20px;
        }
    </style>


    <!-- Enhancement: To include TYNT -->
    <script language="javascript">
    </script>

    <!-- <script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
    <script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
    <script type="text/javascript" src="../../plugins/bootbox-4.0.0/bootbox.min.js"></script>
	 -->
    <script type="text/javascript" src="../../plugins/jquery/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="../../js/jquery-ui.min_1_10_4.js"></script>

    <script type="text/javascript" src="../../plugins/popper/popper-1.14.3.js"></script>
    <!-- <script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script> -->
    <script type="text/javascript" src="../../plugins/bootstrap-5.3.3/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../../plugins/bootbox-6.0.0/bootbox.min.js"></script>
</head>

<body>
    <div class="card mx-auto" style="width: 70%;">
        <img src="../../GAG/Images/Logo_IMPRENTA.png" class="card-img-top mx-auto" style="width: 30%;" alt="Logo globalia artes gráficas">
        <div class="card-body">
            <h3 class="card-title">Solicitar alta</h3>
            <p class="card-text">Introduce todos los datos pedidos a continuación:</p>
        </div>
        <ul class="list-group list-group-flush">
            <form action="" method="post" id="formulariosolicitaralta">
                <li class="list-group-item">
                    <!-- <fieldset> -->
                        <!-- <legend>Datos Principales:</legend> -->
                    <div class="border border-black p-3">
                        <div class="form-group mt-3">
                            <label for="txtrazonsocial">Razón Social:</label>
                            <input class="form-control" placeholder="Razón Social" name="txtrazonsocial" id="txtrazonsocial" type="text" required>
                        </div>
                        <div class="form-group mt-3">
                            <!-- <input type="hidden" name="ocultoempresa" id="ocultoempresa" value="260" /> -->
                            <label for="txtnombre">Nombre Personal o Comercial:</label>
                            <input class="form-control" placeholder="Nombre Comercial/Personal" name="txtnombre" id="txtnombre" type="text" value="" oninput="this.value = this.value.toUpperCase()" required>
                        </div>
                        <div class="form-group mt-3 mb-3">
                            <label for="txtnifcif">NIF/CIF:</label>
                            <input class="form-control" placeholder="NIF/CIF" name="txtnifcif" id="txtnifcif" type="text" required>
                        </div>
                    </div>
                    <!-- </fieldset> -->
                </li>
                <li class="list-group-item">
                    <div class="border border-black p-3">
						<h5>Datos Fiscales</h5>
                        <div class="form-group mt-3">
                            <!-- <input type="hidden" name="ocultoempresa" id="ocultoempresa" value="260" /> -->
                            <label for="txtdireccionfiscal">Dirección Fiscal:</label>
                            <input class="form-control" placeholder="Dirección Fiscal" name="txtdireccionfiscal" id="txtdireccionfiscal" type="text" value="" oninput="this.value = this.value.toUpperCase()" required>
                        </div>
                        <div class="form-group mt-3">
                            <!-- <input type="hidden" name="ocultoempresa" id="ocultoempresa" value="260" /> -->
                            <label for="txtprovinciafiscal">Provincia Fiscal:</label>
                            <input class="form-control" placeholder="Provincia Fiscal" name="txtprovinciafiscal" id="txtprovinciafiscal" type="text" value="" oninput="this.value = this.value.toUpperCase()" required>
                        </div>
                        <div class="form-group mt-3">
                            <label for="txtpoblacionfiscal">Población Fiscal:</label>
                            <input class="form-control" placeholder="Población Fiscal" name="txtpoblacionfiscal" id="txtpoblacionfiscal" type="text" required>
                        </div>
                        <div class="form-group mt-3 mb-3">
                            <label for="txtcodigopostalfiscal">Código Postal Fiscal:</label>
                            <input class="form-control" placeholder="Código Postal Fiscal" name="txtcodigopostalfiscal" id="txtcodigopostalfiscal" type="text" required>
                        </div>
                    </div>
                </li>
                <li class="list-group-item">
                <div class="border border-black p-3">
                    <div class="form-group mt-3">
                        <label for="txttelefono">Teléfono</label>
                        <input class="form-control" placeholder="Teléfono" name="txttelefono" id="txttelefono" type="tel" required>
                    </div>
                    <div class="form-group mt-3">
                        <label for="txtemail">Email De Contacto:</label>
                        <input class="form-control" placeholder="Email De Contacto" name="txtemail" id="txtemail" type="email" required>
                    </div>
                    <div class="form-group mt-3">
                        <label for="txtcontactoYmovil">Contacto y Móvil:</label>
                        <input class="form-control" placeholder="Contacto y Móvil" name="txtcontactoYmovil" id="txtcontactoYmovil" type="text" required>
                    </div>
    </div>
                </li>
                <li class="list-group-item">
                <div class="border border-black p-3">
					<h5>Dirección de Envío</h5>
					<div class="form-group mt-3">
                        <!-- <input type="hidden" name="ocultoempresa" id="ocultoempresa" value="260" /> -->
                        <label for="txtdireccion">Dirección:</label>
                        <input class="form-control" placeholder="Dirección" name="txtdireccion" id="txtdireccion" type="text" value="" oninput="this.value = this.value.toUpperCase()" required>
                    </div>
                    <div class="form-group mt-3">
                        <!-- <input type="hidden" name="ocultoempresa" id="ocultoempresa" value="260" /> -->
                        <label for="txtprovincia">Provincia:</label>
                        <input class="form-control" placeholder="Provincia" name="txtprovincia" id="txtprovincia" type="text" value="" oninput="this.value = this.value.toUpperCase()" required>
                    </div>
                    <div class="form-group mt-3">
                        <label for="txtpoblacion">Población:</label>
                        <input class="form-control" placeholder="Población" name="txtpoblacion" id="txtpoblacion" type="text" required>
                    </div>
                    <div class="form-group mt-3">
                        <label for="txtcodigopostal">Código Postal:</label>
                        <input class="form-control" placeholder="Código Postal" name="txtcodigopostal" id="txtcodigopostal" type="text" required>
                    </div>
    </div>
                </li>
            </form>
        </ul>
        <div class="card-body">
            <div>
                <div class="col-sm-6 col-md-6 col-lg-6 ">
                    <button class="btn btn-lg btn-primary btn-block" type="submit" id="cmd_solicitaralta">Solicitar alta</button>
                </div>
            </div>
        </div>
    </div>
</body>

<script language="javascript">
    enviarCorreo=function(datos){
        fetch('../correo/correo.php', {
                    method: 'POST',
                    body: datos
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('La respuesta de la red no fue exitosa');
                    }
                    //return response.json();
                })
                .then(data => {
                    // // Maneja la respuesta del servidor
                    // if (data.success) {
                    //     bootbox.hideAll();
                    //     bootbox.alert('Solicitud de alta tramitada con exito. En breve le falicitaremos los datos de acceso');
                    //     // Puedes redirigir a otra página o hacer cualquier otra acción
                    // } else {
                    //     bootbox.hideAll();
                    //     bootbox.alert('Error: Los datos no se han introducido correctamente en el sistema.');
                    //     // alert('Errores:\n' + data.errors.join('\n'));
                    //     // Muestra los errores
                    // }
                })
                .catch(error => {
                    console.error('Error:', error);
                    bootbox.alert('<h5>Se produjo un error al procesar la solicitud.</h5>');
                });
    }
    insertar=function(datos){
        fetch('../Altas/Control_Solicitar_Alta.php', {
                    method: 'POST',
                    body: datos
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('La respuesta de la red no fue exitosa');
                    }
                    return response.json();
                })
                .then(data => {
                    // Maneja la respuesta del servidor
                    if (data.success) {
                        bootbox.hideAll();
                        enviarCorreo(datos);
                        bootbox.alert('<h5>Solicitud de alta tramitada con exito. En breve le falicitaremos los datos de acceso.</h5>');
                        // Puedes redirigir a otra página o hacer cualquier otra acción
                    } else {
                        bootbox.hideAll();
                        bootbox.alert('<h5>Error: Los datos no se han introducido correctamente en el sistema.</h5>');
                        // alert('Errores:\n' + data.errors.join('\n'));
                        // Muestra los errores
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    bootbox.alert('<h5>Se produjo un error al procesar la solicitud.</h5>');
                });
    }
    captchaIncorrecto=function(){
        bootbox.hideAll();
        bootbox.alert("Captcha incorrecto");
    }
    const formulario = document.querySelector("#formulariosolicitaralta");
    const botonEnviar = document.querySelector("#cmd_solicitaralta");
    botonEnviar.addEventListener('click', () => {
        const campos = formulario.querySelectorAll('input');
        // Crear un array para almacenar mensajes de error
        let errores = [];

        // Validar cada campo
        campos.forEach(function(campo) {
            if (campo.value.trim() === '') {
                errores.push('Por favor, complete todos los campos.');
            }
        });

        // Mostrar los errores si los hay
        let campoCaptcha;
        if (errores.length > 0) {
            bootbox.alert('<h5>Error: Debe rellenar todos los campos del formulario</h5>');
        } else {
            const formData = new FormData(formulario);
            fetch('../captcha/captcha.php', {
                    method: 'GET',
                }).then(response => {
                    if (!response.ok) {
                        throw new Error('La respuesta de la red no fue exitosa');
                    }
                    return response.json();
                })
                .then(data => {
                    // Manejar los datos JSON obtenidos
                    // console.log(data);
                    bootbox.prompt({
                        title: 'Introduzca el texto que sale en la imagen',
                        message:`<img class="mb-3" src="${data.img}"/>`,
                        inputType: 'text',
                        callback: function(result) {
                            if (result==data.solucion) {
                               insertar(formData);
                            }else{
                                captchaIncorrecto();
                            }
                        }
                    });                    
                })
                .catch(error => {
                    console.error('Hubo un problema con la operación de fetch:', error);
                });
            }
        });
            
</script>

</html>