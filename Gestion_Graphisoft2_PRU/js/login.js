var j$ = jQuery.noConflict();

//por si quiero saltar la actualizacion de los datos de graphisoft (para cuando estoy probando y no me interesa la actualizacion de datos inicial)
var urlParams = new URLSearchParams(window.location.search);
var saltarParam = urlParams.get('saltar');

j$('#cmdlogin').on('click', function() {
	//console.log('validando acceso');
	cadena = ''
	
	if ((j$("#txtusuario").val() == '') || (j$("#txtpassword").val() == '')){
		//console.log('falta el usuario o la contraseña')
		cadena = 'Ha de introducir el usuario y la contraseña'
	}else{
			//validadmos
			url_final = 'Validar.asp';
			j$.ajax({
				url: url_final,
				type: 'POST',
				dataType: 'json',
				data: {
						username: j$('#txtusuario').val(),
						password: j$('#txtpassword').val()
					},
				async: false,
				crossDomain: true,
				headers: { 
							"Access-Control-Allow-Headers": "x-requested-with, x-requested-by",
							"Access-Control-Allow-Origin": "*" }, //add this line
					
				success: function(data) {
					//console.log('Código:', data.codigo);
					//console.log('Mensaje:', data.mensaje);
					if (data.codigo == 0){
						//se ha validado bien, damos acceso
						actualizar_datos_graphisoft()
						
					}else{
						//hay un error en la validacion
	                    cadena = 'Se Ha Producido un error...';
                        cadena = cadena + '<br><br>' + data.mensaje;
					}
					
					
				},
				error: function(error) {
					console.error('Ocurrió un error:', error);
				}
			});


	}

	
	if (cadena != '') {
		//console.log('tenemos que mostrar el error')
		j$("#cabecera_pantalla_avisos").html("<h3>Error Validaci&oacute;n Usuario</h3>");
		j$("#body_avisos").html('<br><h4>' + cadena + '</h4><br>');
		j$("#pantalla_avisos").modal("show");

		//j$("#txtusuario").val('');
		//j$("#txtpassword").val('');
		//j$("#txtusuario").focus()

	}
	
});
									   

actualizar_datos_graphisoft = function() {
	//console.log('dentro de actualizar datos graphisfot')
    j$("#cabecera_pantalla_avisos_actualizar_graphisoft").html("<h3>OBTENIENDO LAS HOJAS DE RUTA NUEVAS Y MODIFICACIONES DE GRAPHISOFT</h3>")
    j$("#body_avisos_actualizar_graphisoft").html('Este proceso de traerse las nuevas hojas de ruta y las posibles modificaciones desde Graphisoft hasta nuestro sistema tarda 1 minuto y medio aproximadamente.<br><br>Cuando finalice el Proceso, recibirá un aviso');
    j$("#pie_pantalla_avisos_actualizar_graphisoft").hide()
    j$("#pantalla_avisos_actualizar_graphisoft").modal("show");
    j$.ajax({
        type: 'POST',
        //contentType: "application/json; charset=utf-8",
        //contentType: "multipart/form-data; charset=UTF-8",
        //contentType: "application/x-www-form-urlencoded",
        url: 'Actualizar_Datos_Desde_Graphisoft_Todos.asp?saltar=' + saltarParam,
        success: function(data) {
            //console.log('lo devuelto por data despues de llamar a actualizar datos graphisfot todos: ' + data)
            switch (data) {
                case '1':
                    { //se encuentra dado de alta en la gestion de maletas  
                        cadena = 'Actualizaci&oacute;n realizada con exito.'
                        break
                    }

                default:
                    {
                        cadena = 'Se Ha Producido un error...'
                        cadena = cadena + '<br><br>' + data
                        break
                    }
            }

            j$("#body_avisos_actualizar_graphisoft").html(cadena);
            j$("#pie_pantalla_avisos_actualizar_graphisoft").show()
            j$("#pantalla_avisos_actualizar_graphisoft").modal("show");

        },
        error: function(request, status, error) { alert(JSON.parse(request.responseText).Message); }
    })
}

j$("#cmdcerrar_actualizacion_graphisoft").click(function() {
    location.href = 'Gestion_Graphisoft.asp'
});