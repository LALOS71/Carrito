var j$ = jQuery.noConflict();

// j$(document).ready(function () {
// permite solo numeros, usa plugin  "jquery.numeric.js".  false, sin decimales "." o ","->separador decimal,   --   
//j$('#txtusuario').numeric(false); // sin puntuación alguna --
// });


// j$(function () {


// });  // (document).ready,  $(function () ---------------------


j$('#cmdlogin').on('click', function() {
    //http://carrito.globalia-artesgraficas.com/GAGLogin/wsLogin.asmx
    //alert('usuario y contraseña: ' + j$('#txtusuario').val() + ' --- ' + j$('#txtpassword').val()) 

   //console.log('dentro del click del cmdlogin validar_por_active_directory')
   //console.log('USUARIO: ' + j$('#txtusuario').val())

    if ((j$('#txtusuario').val() == 'UNDANET') || (j$('#txtusuario').val() == 'UNDANET_AD')) {
        no_directorio_activo(j$('#txtusuario').val())
    } else {
        url_final = 'https://carrito.globalia-artesgraficas.com/act_dir/Validar_Usuario_Actdir.asp'
            //parametros='username=' + j$('#txtusuario').val() + '&password=' + j$('#txtpassword').val()        
            //url_final= url_final + '?' + parametros
            //console.log('urlfinal' + url_final)
		//console.log('validamos por active directori')
        j$.ajax({
            type: "POST",
            //contentType: "application/json; charset=utf-8",
            //contentType: "multipart/form-data; charset=UTF-8",
            //contentType: "application/x-www-form-urlencoded",
            //dataType: "json",
            url: url_final,
            data: {
                username: j$('#txtusuario').val(),
                password: j$('#txtpassword').val()
            },
            async: false,

            //data: '{username:' + j$('#txtusuario').val() + ', password:"' + j$('#txtpassword').val() + '" }',        
            //data: JSON.stringify('{username:' + j$('#txtusuario').val() + ', password:"' + j$('#txtpassword').val() + '" }'),        

            success: function(data) {
                //console.log('valor devuelto: ' + data)
                valores = data.split('||');
                //console.log('error: ' + valores[0])
                //console.log('descripcion: ' + valores[1])
                cadena = '';
                switch (valores[0]) {
                    case '0':
                        url_final = 'Validar.asp';
						//console.log('dentro de case 0 al llamar al active directory e ir todo bien')	
                        j$.ajax({
                                type: "POST",
                                //contentType: "application/json; charset=utf-8",
                                //contentType: "multipart/form-data; charset=UTF-8",
                                //contentType: "application/x-www-form-urlencoded",
                                url: url_final,
                                data: {
                                    txtusuario: j$('#txtusuario').val()
                                },
                                success: function(data) {
                                    //console.log('lo devuelto por data al llamar a validar: ' + data)
                                    switch (data) {
                                        case '0': //no se encuentra dado de alta en la gestion de maletas  
                                            cadena = 'Este Usuario no Está Dado de Alta para Poder Utilizar Esta Aplicación';
                                            break;

                                        case '1': //se encuentra dado de alta en la gestion de maletas 
											//console.log('esta dado de alta para la gestion de maletas, case 1, antes de actualizar datos graphisoft')
											actualizar_datos_graphisoft()
											break;

                                        default:
                                            cadena = 'Se Ha Producido un error...';
                                            cadena = cadena + '<br><br>' + data;
                                            break;
                                    }
									if (cadena!='')
										{
										j$("#cabecera_pantalla_avisos").html("<h3>Error Validaci&oacute;n Usuario</h3>")
										j$("#body_avisos").html('<br><h4>' + cadena + '</h4><br>');
										j$("#pantalla_avisos").modal("show");
										
										j$("#txtusuario").val('')
										j$("#txtpassword").val('')
										//j$("#txtusuario").focus()
										
										}  

                                },
                                error: function(request, status, error) {
                                    alert(JSON.parse(request.responseText).Message);
                                }
                            })
                            //j$("frmlogin").submit();
                        break;

                    /*
					case '1': //se encuentra dado de alta en la gestion de maletas
                        actualizar_datos_graphisoft(); // primero nos traemos los datos originales nuevos o modificados en graphisoft
                        break;
					*/
                    case '1017': //usuario o contraseña incorrectos
                        cadena = valores[1];
                        break;

                    case '20106': //cuenta de usuario caducada
                        cadena = valores[1];
                        break;

                    case '20102': //contraseña caducada
                        cadena = valores[1];
                        break;

                    case '20101': //cuenta bloqueada
                        cadena = valores[1];
                        break;

                    default:
                        cadena = 'Error: ' + valores[0];
                        cadena = cadena + '<br>' + valores[1];
                        break;

                } // case --               

                if (cadena != '') {
                    j$("#cabecera_pantalla_avisos").html("<h3>Error Validaci&oacute;n Usuario</h3>");
                    j$("#body_avisos").html('<br><h4>' + cadena + '</h4><br>');
                    j$("#pantalla_avisos").modal("show");

                    j$("#txtusuario").val('');
                    j$("#txtpassword").val('');
                    //j$("#txtusuario").focus()

                }


            },
            error: function(request, status, error) {
                alert(JSON.parse(request.responseText).Message);
            }
        }); // $.ajax({
        //event.preventDefault();
    }
});

no_directorio_activo = function(usuario) {
    url_final = 'Validar.asp'

    j$.ajax({
        type: "POST",
        //contentType: "application/json; charset=utf-8",
        //contentType: "multipart/form-data; charset=UTF-8",
        //contentType: "application/x-www-form-urlencoded",
        url: url_final,
        data: {
            txtusuario: usuario
        },
        success: function(data) {
            //console.log('lo devuelto por data: ' + data)
            switch (data) {
                case '0': //no se encuentra dado de alta en la gestion de maletas  
                    cadena = 'Este Usuario no Está Dado de Alta para Poder Utilizar Esta Aplicación';
                    break;

                case '1': //se encuentra dado de alta en la gestion de maletas 
                    actualizar_datos_graphisoft(); //primero traemos los datos originales nuevos o modificados en graphisoft
                    //location.href='Gestion_Graphisoft.asp'
                    break;

                default:
                    cadena = 'Se Ha Producido un error...';
                    cadena = cadena + '<br><br>' + data;
                    break;
            }
        },
        error: function(request, status, error) {
            alert(JSON.parse(request.responseText).Message);
        }
    });
}

actualizar_datos_graphisoft = function(usuario) {
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
        url: 'Actualizar_Datos_Desde_Graphisoft_Todos.asp',
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