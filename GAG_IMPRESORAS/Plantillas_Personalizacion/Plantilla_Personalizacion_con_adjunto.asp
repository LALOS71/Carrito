<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include virtual="/includes/Idiomas.asp"-->

<%
	plantilla=Request.QueryString("plant")
	codigo_cliente=Request.QueryString("cli")
	anno_pedido=Request.QueryString("anno")
	codigo_pedido=Request.QueryString("ped")
	codigo_articulo=Request.QueryString("art")
	cantidad_articulo=Request.QueryString("cant")
	modo=Request.QueryString("modo")
	carpeta=Request.QueryString("carpeta")
	
	texto_json=session("json_" & codigo_articulo)

	'*************
	'response.write("<br>PLANITLLA: " & plantilla & " cliente: " & codigo_cliente & " a�o pedido: " & anno_pedido & " pedido: " & codigo_pedido & " articulo: " & codigo_articulo & " cantidad: " & cantidad_articulo)
	'response.write("variable sesion session('json_" & codigo_articulo & "'): " & texto_json)
	
	'para que se vean bien los acentos guardados en el fichero json
	Response.ContentType="text/html; charset=iso-8859-1"
%>
<html>

<head>

<title><%=plantilla_personalizacion_title%></title>

<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />


<style type="text/css">
 
#tabla { border: solid 1px #333;	width: 805px; }
#tabla_elemento { 
	border: solid 1px #333;	
	width: 800px; 
	-moz-border-radius: 6px; /* Firefox */
	-webkit-border-radius: 6px; /* Google Chrome y Safari */
	border-radius: 6px; /* CSS3 (Opera 10.5, IE 9 y est�ndar a ser soportado por todos los futuros navegadores) */
	
	}
#tabla tbody tr{ backgroun_d: #999; }
.fila-base{ display: none; } /* fila base oculta */


.boton_celda:hover{ background-color:#333333}
.texto_celda{
	font-family:Arial, Helvetica, sans-serif;
	font-size:11px;
	width:120px;
	
	-moz-border-radius: 4px 4px 4px 4px;/* Firefox */
	-webkit-border-radius: 4px 4px 4px 4px; /* Google Chrome y Safari */
	border-radius: 4px 4px 4px 4px; /* CSS3 (Opera 10.5, IE 9 y est�ndar a ser soportado por todos los futuros navegadores) */
}
.texto_celda2{
	font-family:Arial, Helvetica, sans-serif;
	font-size:11px;
	width:240px;
}
.obligatorio{ background: #FF3366; color:#ffffff}
.borde_celda{border: solid 1px #333;}
.boton_celda{
	border: solid 1px #333;
	background-color:#999999;
	color:#FFFFFF;	
	
	cursor: pointer; 
	/*color: #000; */
	-moz-border-radius: 6px; /* Firefox */
	-webkit-border-radius: 6px; /* Google Chrome y Safari */
	border-radius: 6px; /* CSS3 (Opera 10.5, IE 9 y est�ndar a ser soportado por todos los futuros navegadores) */
}
/*input[type="text"]{ width: 80px; } /* ancho a los elementos input="text" */
/*
.cantidad_tarjeta { width:10px};
.nombre_tarjeta { width:10px};
.apellidos_tarjeta { width:10px};
.cargo_tarjeta { width:10px};
.telefono_tarjeta { width:10px};
.fax_tarjeta { width:10px};
.movil_tarjeta { width:10px};
.email_tarjeta { width:10px};
.pagina_web_tarjeta { width:10px};
.calle_tarjeta { width:10px};
.numero_calle_tarjeta { width:10px};
.poblacion_tarjeta { width:30px};
.cp { width:30px};
.provincia_tarjeta { width:30px};
.email_prueba_tarjeta { width:30px};
.telefono2_tarjeta { width:30px};
*/

	.image_thumb{
			position:relative;
			overflow:hidden;
			padding-bottom:100%;
		}
	.image_thumb img{
			  position: absolute;
			  max-width: 100%;
			  max-height: 100%;
			  top: 50%;
			  left: 50%;
			  transform: translateX(-50%) translateY(-50%);
		}

</style>
<script type="text/javascript" src="../plugins/jquery/jquery-2.2.4.min.js"></script>
<script type="text/JavaScript" src="../plugins/printarea_2_4_0/jquery.PrintArea.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>


<script type="text/javascript" src="../plugins/bootstrap-filestyle-1.2.1/bootstrap-filestyle.js"></script>

<script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>
<!--
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
-->
<script type="text/javascript">

    
///////////////////////////////////////////////////////////
//creo el objeto que contendr� los valores de las plantillas para pasarlo a formato JSON
////////////////////////////////////////////////////////////

						
			var Plantilla_a01 = function(nombre_agencia, calle, numero_calle, poblacion, cp, provincia, telefono, movil, email, web, ocultofichero, email_pruebas){  
				 this.nombre_agencia=nombre_agencia;
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia;  
				 this.telefono = telefono;  
				 this.movil = movil;  
				 this.email = email;  
				 this.web = web;  
				 this.ocultofichero=ocultofichero;
				 this.email_pruebas = email_pruebas;  
			}  
			

			var Pedido = function(codigo_cliente, codigo_pedido,numero_plantillas){  
       				this.codigo_cliente = codigo_cliente;  
       				this.codigo_pedido = codigo_pedido;  
					this.numero_plantillas= numero_plantillas
       				this.plantillas  = new Array();  
			}  
			Pedido.prototype.addPlantilla = function(plantilla){  
           			this.plantillas.push(plantilla);  
			}  
			Pedido.prototype.getPlantillas = function(){  
           			return this.plantillas;  
			} 	 
////////////////////////////////////////////////////////////////////

function EsEmail(w_email) 
{
	var test = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/; 
	var emailReg = new RegExp(test);   
	return emailReg.test(w_email); 
}   

function EsEntero(valor) {
     var test = /^(-)?[0-9]*$/;
	 var numeroEnteroReg = new RegExp(test);
	 return numeroEnteroReg.test(valor)
 }
 
function EsEspecial(valor) {
	// para evitar estos caracteres + # % & \\ " [ ] { }
     //var test = /[+#%&\\"\[\]{}]/;
	 var test = /[+#%&\"\[\]{}]/;
	 //var test = /[+#%\\"\[\]{}]/;
	 var especialReg = new RegExp(test);
	 return especialReg.test(valor)
 }
 
 


 
$(function(){
	
	

	// Clona la fila oculta que tiene los campos base, y la agrega al final de la tabla y hace que se muestre lentamente
	$("#agregar").on('click', function(){
		//$("#tabla tbody tr:eq(0)").clone().removeClass('fila-base').appendTo("#tabla tbody");
		//$("#tabla tbody tr:eq(0)").clone().removeClass('fila-base').appendTo("#tabla tbody").hide().fadeIn('slow');
		//$("#tabla tbody").prepend($("#tabla tbody tr:eq(0)").clone().removeClass('fila-base'));
		
		//$('#tabla tbody:last').after($("#tabla tbody tr:eq(0)").clone().removeClass('fila-base'))
		//$('#body_principal').append($("#tabla tbody tr:eq(0)").clone().removeClass('fila-base'))
		
		//clona la plantilla y la a�ade al final del body_principal, haciendo un efecto de retardo al mostrarla
		//$("#tabla tbody .<%=plantilla%>").clone().removeClass('<%=plantilla%>').appendTo("#body_principal").hide().fadeIn('slow');
			
		//clona la plantilla dentro del div datos al principio, haciendo un efecto de retardo al mostrarla
		//$(".plantilla:first").clone().prependTo("#datos").hide().fadeIn('slow');
		//$("#tabla tbody .<%=plantilla%>:first").clone().appendTo("#body_principal").hide().fadeIn('slow');
		$("#contenedor_plantillas .<%=plantilla%>:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
				  
		
			
		
	});
 
 	
	// Evento borra los datos en la plantilla_a01
	$(document).on("click",".plantilla_a01 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_a01 .nombre_agencia').val('')
		$('.plantilla_a01 .calle').val('')
		$('.plantilla_a01 .numero_calle').val('')
		$('.plantilla_a01 .poblacion').val('')
		$('.plantilla_a01 .cp').val('')
		$('.plantilla_a01 .provincia').val('')
		$('.plantilla_a01 .telefono').val('')
		$('.plantilla_a01 .movil').val('')
		$('.plantilla_a01 .email').val('')
		$('.plantilla_a01 .web').val('')
		$('.plantilla_a01 .ocultofichero').val('')
		$('.plantilla_a01 .email_pruebas').val('')
		
		$('.plantilla_a01 .requerir').closest("div").addClass("has-error")
		$('.plantilla_a01 .requerir').siblings().addClass("text-danger")
		
	});
	
	
	
	
	
	$(document).on("keyup", ".requerir", function(){    
		//$( "p" ).siblings( ".selected" ).css( "background", "yellow" )
		
		if ($(this).val()=='')
			{
			$($(this).closest("div")).addClass("has-error")
			$(this).siblings().addClass("text-danger")
			}
		  else
		  	{
			$($(this).closest("div")).removeClass("has-error")
			//$($(this).closest("span")).removeClass("text-danger")
			$(this).siblings().removeClass("text-danger")
			}
	});
	
	$(document).on("keyup", ".requerir_b", function(){    
		//$( "p" ).siblings( ".selected" ).css( "background", "yellow" )
		
		if ($(this).val()=='')
			{
			$($(this).closest("div")).addClass("has-success")
			$(this).siblings().addClass("text-success")
			}
		  else
		  	{
			$($(this).closest("div")).removeClass("has-success")
			//$($(this).closest("span")).removeClass("text-danger")
			$(this).siblings().removeClass("text-success")
			}
	});
	
	$("#guardar_plantillas").on("click", function(){
		//var elementos= $(".tabla_elementos");
		//var tamanno=$(".tabla_elementos").size();
		//alert('hola')
		//console.log('dentro de de guardar plantillas click')
		hay_error='NO'
		cadena_error=''
		sumar_cantidades='SI'
		total_cantidad=0
		
		
		
		//PLANTILLA_a01		
		if ('<%=plantilla%>'=='plantilla_a01')
			{
			//no hay campos obligatorios		
			
			$(".plantilla_a01 .txtfichero_adjunto").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()!='')
						{
						var ext = ($(elemento).val().split(".").pop().toLowerCase());
						$(".ocultofichero").val('Logo_<%=codigo_cliente%>__<%=codigo_articulo%>.' + ext)
						
						/*YA NO CONTROLAMOS LA EXTENSION, PUEDE SUBIR CUALQUIER ADJUNTO
						if ($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) 
							{
							cadena_error=cadena_error + "<br>- El fichero a Seleccionar a de ser una imagen (gif, png, jpg, jpeg)"
							hay_error='SI'
							}
						*/

						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
				});
			
			}
			
		comprobando_especial=0
		$(".<%=plantilla%> input").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()!='')
						{
						if (EsEspecial($(elemento).val()))
							{
							//console.log('dentro de es especial, contenido: ' + $(elemento).val() )
		
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_caracteres_especiales%><br>'
							hay_error='SI'
							return false;
							}
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
		
		
		
		//console.log('ahora pasamos a comprobar si ha habido algun error')
		if (hay_error=='SI')
			{
			//alert(cadena_error);
			
			//console.log('ha habido error.... mostramos la descripcion')
		
			cadena='<BR><H3><%=plantilla_personalizacion_error_explicacion%></H3><BR><H5>' + cadena_error + '</H5>'
			//$("#cabecera_pantalla_avisos", window.parent.document).html("<%=plantilla_personalizacion_pantalla_avisos_cabecera%>")
			//$("#body_avisos", window.parent.document).html(cadena + "<br>");
			//$("#botones_avisos", window.parent.document).html('<p><button type="button" class="btn btn-default" data-dismiss="modal"><%=plantilla_personalizacion_pantalla_avisos_boton_cerrar%></button></p><br>');                          
			//$("#pantalla_avisos", window.parent.document).modal("show");
			
			//console.log('error: ' + cadena)
			$("#cabecera_nueva_mensajes", window.parent.document).html("<%=plantilla_personalizacion_pantalla_avisos_cabecera%>");
		    $("#body_nueva_mensajes", window.parent.document).html(cadena + "<br>");
			$("#capa_nueva_mensajes", window.parent.document).modal("show");

			
			//console.log('ha habido error: ' + cadena_error);
			}
		  else
		  	{
			//--alert('creamos el json')
			//console.log('no ha habido error y creamos el json')
			
						
			var jsonText = JSON.stringify(getFormJson());
			
			//subimos el logo al servidor
			subir_adjunto()
			//--alert(jsonText);
			
			console.log('hemos creado el json: ' + jsonText)
			
			//como da problemas con las comillas dobles del json al pasar el contenido al oculto, usamos
			//la variable de sesion para el contenido de los datos y el oculto para controlar si se han rellenado o no
			window.parent.document.getElementById('ocultodatos_personalizacion_json_<%=codigo_articulo%>').value='COMPLETADO';
			
			
			parametros='ocultoarticulo=' + '<%=codigo_articulo%>'
			parametros+= '&ocultojson=' + jsonText
			pagina_url='Annadir_Json_Articulo_Gag.asp'
			//pagina_url='Annadir_Articulo_Gag.asp?'
			
			//console.log('parametros desde plantilla_tarjetas_visita: ' + parametros)
			//console.log('url desde plantilla tarjetas visita: ' + pagina_url)
			mostrar_capa(pagina_url,'capa_annadir_json_articulo', parametros)
			
			
			//alert('Datos de Personalizaci�n del Art�culo Recogidos Correctamente')
			
			
			cadena='<br><BR><H3><%=plantilla_personalizacion_pantalla_avisos_mensaje%></H3><BR><br>'
			//$("#cabecera_pantalla_avisos", window.parent.document).html("<%=plantilla_personalizacion_pantalla_avisos_cabecera%>")
			//$("#body_avisos", window.parent.document).html(cadena + "<br>");
			//$("#botones_avisos", window.parent.document).html('<p><button type="button" class="btn btn-default" data-dismiss="modal"><%=plantilla_personalizacion_pantalla_avisos_boton_cerrar%></button></p><br>');                          
			//$("#pantalla_avisos", window.parent.document).modal("show");

			
			$("#cabecera_nueva_mensajes", window.parent.document).html("<%=plantilla_personalizacion_pantalla_avisos_cabecera%>");
		    $("#body_nueva_mensajes", window.parent.document).html(cadena + "<br>");
			$("#capa_nueva_mensajes", window.parent.document).modal("show");
			
			window.parent.$('#capa_nueva_plantilla').modal("hide");
			
			//window.parent.document.getElementById('icono_plantilla_<%=codigo_articulo%>').src='../images/Icono_Correcto_Verde.png'
			$("#icono_plantilla_<%=codigo_articulo%>", window.parent.document).removeClass("btn-warning").addClass("btn-success");
			$("#icono_plantilla_<%=codigo_articulo%>", window.parent.document).attr('title', '<%=plantilla_personalizacion_plantilla_completada%>');
													
			//console.log('cambiamos de btn-warning a btn-success en el boton "icono_plantilla_<%=codigo_articulo%>"') 										
			//window.parent.cerrar_capas('capa_informacion');
			
			//--console.log(jsonText)
			
			
			
			
			
			
			
			}
	
	
	});
	
	
	
	$("#imprimir_plantillas").on('click', function(){
		//console.log('a imprimir')
		$("#contenedor_plantillas").printArea({ mode: 'popup', popClose: true });
		//console.log('despues de imprimir')
	});
 
 	$("#cerrar_plantillas").on('click', function(){
			//window.parent.cerrar_capas('capa_informacion');
			//window.parent.cerrar_capas('capa_nueva_plantilla');
			//j$("#capa_detalle_pir").modal("show");
			window.parent.$('#capa_nueva_plantilla').modal("hide");
	});
});



function getFormJson(){ 
	//console.log('dentro de getFormJson') 
	///meto los valores de pedido, que tendr� que obtener de algun sitio...
    var pedidoObj    = new Pedido('<%=codigo_cliente%>', '<%=codigo_pedido%>', ($(".<%=plantilla%> .email_pruebas").size()-1));  
    

	//PLANTILLA_a01
	if ('<%=plantilla%>'=='plantilla_a01')
		{
		var plan_nombre_agencias = $(".plantilla_a01 .nombre_agencia");  
		var plan_calles = $(".plantilla_a01 .calle");  
		var plan_numeros_calles = $(".plantilla_a01 .numero_calle");  
		var plan_poblaciones = $(".plantilla_a01 .poblacion");  
		var plan_cps = $(".plantilla_a01 .cp");  
		var plan_provincias = $(".plantilla_a01 .provincia");  
		var plan_telefonos = $(".plantilla_a01 .telefono");  
		var plan_moviles = $(".plantilla_a01 .movil");  
		var plan_emails = $(".plantilla_a01 .email");  
		var plan_webs = $(".plantilla_a01 .web");  
		var plan_ficheros = $(".plantilla_a01 .ocultofichero");  
		var plan_emails_pruebas = $(".plantilla_a01 .email_pruebas");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_a01(
							plan_nombre_agencias[pos].value,
							plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_provincias[pos].value,
							plan_telefonos[pos].value,
							plan_moviles[pos].value,
							plan_emails[pos].value,
							plan_webs[pos].value,
							plan_ficheros[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
		
		
	
    return pedidoObj;  
}; 

 
function cargar_datos(usuario, numero_pedido, carpeta_anno, id_articulo, modo)

{

/*******************************************
ojito que para que funcione la captura de un fichero json y el iis no diga que no puede mostrar el archivo .json, 
tenemos que a�adir esas extension al iis

	* en el administrador de iis. Hay que hacer click con el bot�n derecho en el directorio virtual del sitio web.
	* Ir a Propiedades - Encabezados HTTP - bot�n Tipos MIME.
	* A�adir el tipo Mime de este modo: Extensi�n: .json y Tipo Mime: application/json
***************************************************************/
	//console.log('la plantilla para este articulo es: <%=plantilla%>')

	//clona la plantilla y la a�ade al final del body_principal, haciendo un efecto de retardo al mostrarla
	//$("#tabla tbody .<%=plantilla%>").clone().removeClass('<%=plantilla%>').appendTo("#body_principal").hide().fadeIn('slow');
	
	//console.log('entramos en cargar datos')
	//console.log('... y venimos de la pagina... document.referer: ' + document.referrer)
	$("#contenedor_plantillas .<%=plantilla%>:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');

	//console.log('despues de clonar la plantilla')
	//recuperamos los valores desde la variable de sesion si tiene contenido, por si se ha modificado con respecto al fichero
	//almacenado en disco
	
	texto_json='<%=replace(texto_json, "\", "\\")%>'
	//console.log('texto_json recuperado directo del asp: <%=texto_json%>')
	//console.log('texto_json recuperado: ' + texto_json)
	if (texto_json!='')
		{
		//console.log('contenido json hacemos el parse: ' + texto_json)
		var plantillas=JSON.parse(texto_json)
		}
	  else //del if texto_json!=''
	  	{
			if (modo=='CONSULTAR')
				{
				//CONSOLE.LOG('ENTRAMOS EN MODO CONSULTAR...')
				ruta_fichero_json='../'
				if ('<%=carpeta%>'!='')
					{
					ruta_fichero_json=ruta_fichero_json + '<%=carpeta%>' + '/'
					}
				
				ruta_fichero_json=ruta_fichero_json + 'pedidos/' + carpeta_anno + '/' + usuario + '__' + numero_pedido + '/json_' + id_articulo + '.json'
				//--alert('ruta fichero: ' + ruta_fichero_json)
				//$.ajaxSetup({ scriptCharset: "utf-8" , contentType: "application/json; charset=utf-8"})
				//$.ajaxSetup({ scriptCharset: "utf-8" , contentType: "application/json; charset=iso-8859-1"})
				//$.ajaxSetup({contentType: "application/json; charset=utf-8"})
				//con esto, configuramos ajax y jquery para que se vean bien los acentos guardados en los ficheros json
				//console.log('ruta fichero json en CONSULTAS (para coger contenido): ' + ruta_fichero_json)
				$.ajaxSetup({
					'beforeSend' : function(xhr) {
					try{
					xhr.overrideMimeType('text/html; charset=iso-8859-1');
					}
					catch(e){
					}
					}});
				
				//con esto conseguimos que se muestre el fichero con los datos correctos porque si se modifica no se ven los
				//   cambios, ya que mostraria los datos originales cacheados
				$.ajaxSetup({ cache: false });
				//$.getJSON(ruta_fichero_json, function(plantillas) {}).fail(function(error){console.log(error);});
				$.getJSON(ruta_fichero_json, function(plantillas) {

						//console.log('datataaa.plantillas.nombre: ' + plantillas.plantillas[0].nombre)
							
							
						var indice_plantillas=1
						for (x in plantillas.plantillas)
							{
							if ('<%=plantilla%>'=='plantilla_a01')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_a01:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								$('.plantilla_a01 .nombre_agencia:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].nombre_agencia)
								$('.plantilla_a01 .calle:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_a01 .numero_calle:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_a01 .poblacion:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_a01 .cp:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_a01 .provincia:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
								$('.plantilla_a01 .telefono:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_a01 .movil:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].movil)
								$('.plantilla_a01 .email:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
								$('.plantilla_a01 .web:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].web)
								$('.plantilla_a01 .ocultofichero:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].ocultofichero)
								$('.plantilla_a01 .email_pruebas:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								
								console.log('nombre del fichero: ' + plantillas.plantillas[x].ocultofichero)
								if (plantillas.plantillas[x].ocultofichero!='')
									{
									var ext = (plantillas.plantillas[x].ocultofichero.split(".").pop().toLowerCase());
									if ($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) 
										{
										$('.plantilla_a01 #enlace_al_adjunto').html(plantillas.plantillas[x].ocultofichero)
										if (plantillas.plantillas[x].ocultofichero.indexOf("Logo_") !=-1)
											{
											$('.plantilla_a01 #enlace_al_adjunto').show()
											$('.plantilla_a01 #icono_del_adjunto').hide()
											$('.plantilla_a01 .preview_imagen_fichero').show()
											}
										  else
										  	{
											$('.plantilla_a01 #enlace_al_adjunto').hide()
											$('.plantilla_a01 #icono_del_adjunto').hide()
											$('.plantilla_a01 .preview_imagen_fichero').hide()
											}
										
										}
									  else
									  	{
										$('.plantilla_a01 #enlace_al_adjunto').html('')
										$('.plantilla_a01 #enlace_al_adjunto').hide()
										$('.plantilla_a01 #icono_del_adjunto').show()
										$('.plantilla_a01 .preview_imagen_fichero').show()
										}
									
									}
								if (plantillas.codigo_pedido!='')
									{
									ruta_fichero_adjunto='../GAG/pedidos/' + carpeta_anno + '/' + plantillas.codigo_cliente + '__' + plantillas.codigo_pedido + '/' + plantillas.plantillas[x].ocultofichero
									}
								  else
								  	{
									ruta_fichero_adjunto='../GAG/pedidos/adjuntos_plantilla/' + plantillas.plantillas[x].ocultofichero
									}
								console.log('fichero_adjunto a mostrar: ' + ruta_fichero_adjunto)
								$('.plantilla_a01 .img_fichero').attr("src", ruta_fichero_adjunto );
								}
				
							
				
				
							//$('.nombre_tarjeta')[indice].val(plantillas.plantillas[x].nombre)
							//('.apellidos_tarjeta')[indice].val(plantillas.plantillas[x].apellidos)
							indice_plantillas++
							}				
								
								
								
					$(".<%=plantilla%> .requerir").closest("div").removeClass("has-error")
					$(".<%=plantilla%> .requerir").siblings().removeClass("text-danger")										
								
								
				}).fail(function(error){console.log(error);});
				
				
				}

			
		} 
		// del if texto_json!=''


		//console.log('objeto plantillas diferente de undefined: ' + plantillas)
		if (typeof plantillas != 'undefined')
			{
			var indice_plantillas=1
			for (x in plantillas.plantillas)
				{
				//console.log('dentro de si plantilla es igual a 23')
	
				if ('<%=plantilla%>'=='plantilla_a01')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_a01:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					
					$('.plantilla_a01 .nombre_agencia:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].nombre_agencia)
					$('.plantilla_a01 .calle:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_a01 .numero_calle:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_a01 .poblacion:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_a01 .cp:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_a01 .provincia:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_a01 .telefono:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_a01 .movil:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].movil)
					$('.plantilla_a01 .email:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
					$('.plantilla_a01 .web:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].web)
					$('.plantilla_a01 .ocultofichero:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].ocultofichero)
					$('.plantilla_a01 .email_pruebas:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					
					console.log('nombre delfichero: ' + plantillas.plantillas[x].ocultofichero)
					if (plantillas.plantillas[x].ocultofichero!='')
						{
						var ext = (plantillas.plantillas[x].ocultofichero.split(".").pop().toLowerCase());
						if ($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) 
							{
							$('.plantilla_a01 #enlace_al_adjunto').html(plantillas.plantillas[x].ocultofichero)
							if (plantillas.plantillas[x].ocultofichero.indexOf("Logo_") !=-1)
								{
								$('.plantilla_a01 #enlace_al_adjunto').show()
								$('.plantilla_a01 #icono_del_adjunto').hide()
								$('.plantilla_a01 .preview_imagen_fichero').show()
								}
							  else
								{
								$('.plantilla_a01 #enlace_al_adjunto').hide()
								$('.plantilla_a01 #icono_del_adjunto').hide()
								$('.plantilla_a01 .preview_imagen_fichero').hide()
								}
							}
						  else
							{
							$('.plantilla_a01 #enlace_al_adjunto').html('')
							$('.plantilla_a01 #enlace_al_adjunto').hide()
							$('.plantilla_a01 #icono_del_adjunto').show()
							$('.plantilla_a01 .preview_imagen_fichero').show()
							}
						
						}
					
					if (plantillas.codigo_pedido!='')
							{
							ruta_fichero_adjunto='../GAG/pedidos/' + carpeta_anno + '/' + plantillas.codigo_cliente + '__' + plantillas.codigo_pedido + '/' + plantillas.plantillas[x].ocultofichero
							}
						  else
							{
							ruta_fichero_adjunto='../GAG/pedidos/adjuntos_plantilla/' + plantillas.plantillas[x].ocultofichero
							}
					console.log('fichero_adjunto a mostrar: ' + ruta_fichero_adjunto)
					$('.plantilla_a01 .img_fichero').attr("src", ruta_fichero_adjunto );
					
					}
				//$('.nombre_tarjeta')[indice].val(plantillas.plantillas[x].nombre)
				//('.apellidos_tarjeta')[indice].val(plantillas.plantillas[x].apellidos)
				indice_plantillas++
				}		
				
			} //del if undefinded
			
			
			
			
		//console.log('final de cargar datos')
}		
		
		
		
		
		
		
		
		

 
/***************************************** 
$(�#agregar�), es el encargado de ejecutar la funci�n de agregado de la fila.

$(�#tabla tbody tr:eq(0)�).clone().removeClass(�fila-base�).appendTo(�#tabla tbody�), esta es la parte m�s importante, 
y parece ser la m�s complicada, pero lo explicar� paso a paso:
	1. $(�#tabla tbody tr:eq(0)�), es un selector algo confuso, pero es simple, 
			solo es necesario avanzar por pasos: seleccionamos la tabla(#tabla), 
			seguimos con el cuerpo de la tabla(tbody), la primer fila del cuerpo(tr:eq(0), 
			el cero indica la posici�n, osea el cero es el primer elemento).
	2. .clone(), clonamos lo que acabamos de seleccionar en el paso 1.
	3. removeClass(�fila-base�), quitamos la clase CSS �fila-base� (la que mantiene oculta nuestra fila base), 
			mucha atenci�n en este punto: al remover la clase �fila-base� lo estamos haciendo al clon de nuestra fila base.
	4. .appendTo(�#tabla tbody�), agregamos el clon al cuerpo de la tabla �#tabla tbody�, 
			por defecto siempre se agrega al final o como �ltimo elemento.

$(document).on(�click�,�.eliminar�,function(), el selector que ejecuta la tarea de eliminar al hacer click sobre la celda �eliminar�.

var parent = $(this).parents().get(0);, $(this).parents(): selecciona los padres de la celda eliminar o en otras palabras 
	los elementos superiores y con .get(0) seleccionamos el primer elemento superior, para dejarlo m�s f�cil: el elemento superior 
	de una celda(<td>) es una fila(<tr>).

$(parent).remove();, eliminamos o removemos la fila seleccionada.

.on, usamos .on() porque en las ultimas versiones de jQuery, esta es la nueva forma de utilizar los eventos, con el plus de que 
	tambi�n funciona con los nuevos elemento incrustados al DOM, a�adiendo los eventos autom�ticamente, reemplazando a la funcion .live(), 
	la cual es obsoleta.
*****************************/


</script>


<!-- para a�adir una variable de session con contenido json del articulo a personalizar mediante ajax-->
<script language="javascript">
function crearAjax() 
{
  var Ajax
 
  if (window.XMLHttpRequest) { // Intento de crear el objeto para Mozilla, Safari,...
    Ajax = new XMLHttpRequest();
    if (Ajax.overrideMimeType) {
      //Se establece el tipo de contenido para el objeto
      //http_request.overrideMimeType('text/xml');
      //http_request.overrideMimeType('text/html; charset=iso-8859-1');
	  Ajax.overrideMimeType('text/html; charset=iso-8859-1');
     }
   } else if (window.ActiveXObject) { // IE
    try { //Primero se prueba con la mas reciente versi�n para IE
      Ajax = new ActiveXObject("Msxml2.XMLHTTP");
     } catch (e) {
       try { //Si el explorer no esta actualizado se prueba con la versi�n anterior
         Ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {}
      }
   }
 
  if (!Ajax) {
    alert('<%=plantilla_personalizacion_error_ajax%>');
    return false;
   }
  else
  {
    return Ajax;
  }
}

	

//onclick="mostrar_capa('/Reservas_Web/Incrementar_Visita.asp?Mayorista=MUNDORED','capa_annadir_articulo')"
//mostrar_capa('Annadir_Articulo.asp?acciones=<%=accion%>','capa_annadir_articulo')

function mostrar_capa(pagina,divContenedora,parametros)
{
	//alert('entramos en mostrar capa')
	//alert('parametros.... pagina: ' + pagina + ' divcontenedora: ' + divContenedora)
    var contenedor = document.getElementById(divContenedora);
    
	
    var url_final = pagina + '?' + parametros
 
    //contenedor.innerHTML = '<img src="imagenes/loading.gif" />'
	//console.log('url_final: ' + url_final)
    var objAjax = crearAjax()
 
    objAjax.open("GET", url_final)
    objAjax.onreadystatechange = function(){
      if (objAjax.readyState == 4)
	  {
       //Se escribe el resultado en la capa contenedora
	   txt=unescape(objAjax.responseText);
	   txt2=txt.replace(/\+/gi," ");
	   contenedor.innerHTML = txt2;
      }
    }
    objAjax.send(null);
	
}



function subir_adjunto()
{
	$("#guardar_plantillas").prop("disabled",true);
	//console.log('dentro de subir_adjunto')
	
	document.getElementById('frmdatos').target = 'my_iframe'; //'my_iframe' is the name of the iframe
	document.getElementById('frmdatos').submit();
	//alert('hola')
	//$("#status").html("");
};



</script>

</head>
<body onload="cargar_datos('<%=codigo_cliente%>', '<%=codigo_pedido%>', '<%=anno_pedido%>', '<%=codigo_articulo%>', '<%=modo%>')">
							
<form id="frmdatos" name="frmdatos" action="Subir_Adjunto_Plantilla.asp" method="POST" enctype="multipart/form-data" >
 	<input type="hidden" id="ocultoanno_pedido_adjunto" name="ocultoanno_pedido_adjunto" value="<%=anno_pedido%>" />
	<input type="hidden" id="ocultocliente_adjunto" name="ocultocliente_adjunto" value="<%=codigo_cliente%>" />
	<input type="hidden" id="ocultopedido_adjunto" name="ocultopedido_adjunto" value="<%=codigo_pedido%>" />
	<input type="hidden" id="ocultoarticulo_adjunto" name="ocultoarticulo_adjunto" value="<%=codigo_articulo%>" />
	<!--iframe con el que se envia el logo al servidor-->
	<iframe id='my_iframe' name='my_iframe' src="" style="display:none "></iframe>
 

<div class="container-fluid" id="contenedor_plantillas" name="contenedor_plantillas">
			
			
	
	<div class="plantilla_a01" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
						<span>Nombre Agencia:</span>
						<input type="text" class="form-control nombre_agencia">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<span>Tfno. Fijo:</span>
						<input type="text" class="form-control telefono">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<span>Tfno M&oacute;vil:</span>
						<input type="text" class="form-control movil">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
						<span>Email:</span>
						<input type="text" class="form-control email">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
						<span>Web:</span>
						<input type="text" class="form-control web">
					</div>
					
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
						<span>Calle:</span>
						<input type="text" class="form-control calle">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<span>N&uacute;m.:</span>
						<input type="text" class="form-control numero_calle">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
						<span>Poblaci&oacute;n:</span>
						<input type="text" class="form-control poblacion">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<span>C.P.:</span>
						<input type="text" class="form-control cp">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
						<span>Provincia:</span>
						<input type="text" class="form-control provincia">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
						<span>Email Envio Prueba:</span>
						<input type="text" class="form-control email_pruebas">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   Eliminar
						</button>
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
						<span>Fichero Para el Logo:</span>
						<input type="text" class="form-control ocultofichero" id="ocultofichero" name="ocultofichero" value="" style="display:none">
						<div class="datos_fichero">
							<div class="col-sm-4 preview_imagen_fichero" style="display:none">
								<a href="#" class="thumbnail">
									<div class="image_thumb" id="icono_del_adjunto"  style="display:none">
										<img src="" class="img img-responsive full-width img_fichero" id="img_fichero" name="img_fichero" />
									</div>
									<div id="enlace_al_adjunto"  style="display:none"></div>
								</a>
							</div>
							
							<%if modo<>"CONSULTAR" then%>
								<input name="txtfichero_adjunto" id="txtfichero_adjunto" class="txtfichero_adjunto" size="27" type="file" />
							<%end if%>
							
						</div>
						
						
						
						
						
					</div>
				</div>

			</div>
		</div>
	</div><!--fin plantilla23-->	
			
			
</div>	

</form>

<div class="container-fluid" id="botones">
	<div class="row">
		<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1"></div>
		<%if modo<>"CONSULTAR" then%>
			<%if plantilla="plantilla_1" or plantilla="plantilla_11" or plantilla="plantilla_12" or plantilla="plantilla_15" then%>
				<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
					<button type="button" class="btn btn-primary btn-lg" id="agregar" name="agregar">
					   Agregar Plantilla
					</button>
				</div>
			<%end if%>
			<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1"></div>
			<% if session("usuario")<>249 and session("usuario")<>599 then 'los administradores de halcon y ecuador no pueden modificar la plantilla%>
				<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
					<button type="button" class="btn btn-primary btn-lg" id="guardar_plantillas" name="guardar_plantillas">
					   Guardar Plantillas
					</button>
				</div>
			<%end if%>
		<%end if%>
		
		
		<%'solo dejamos el boton de imprimir para nosotros
		'response.write("<br>usuario admin: " &  session("usuario_admin"))
		if session("usuario_admin")<>"" then%>
			<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1"></div>
			<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
				<button type="button" class="btn btn-primary btn-lg" id="imprimir_plantillas" name="imprimir_plantillas">
			   		Imprimir Plantilla
				</button>
			</div>
		<%end if%>
		<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1"></div>
		<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
			<button type="button" class="btn btn-lg" id="cerrar_plantillas" name="cerrar_plantillas">
			   Cerrar Plantillas
			</button>
		</div>
	</div>
	
</div>


	
<!-- NO BORRAR, es la capa que a�ade el json del articulo....-->
<div id="capa_annadir_json_articulo" style="display:none "></div>

<script language="JavaScript">


	
$(document).on("change", ".txtfichero_adjunto" , function () {
		if (this.files && this.files[0])
			{
			var reader = new FileReader();
			
			var ext = ($(this).val().split(".").pop().toLowerCase());
			console.log('fichero seleccinado: ' + $(this).val())
			console.log('extension: ' + ext)
			if ($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) 
				{
				console.log('---no es una imagen')
				$('.plantilla_a01 #enlace_al_adjunto').html($(this).val())
				$('.plantilla_a01 #enlace_al_adjunto').hide()
				$('.plantilla_a01 #icono_del_adjunto').hide()
				$(this).parent().find(".preview_imagen_fichero").hide()
				}
			  else
				{
				console.log('---es una imagen')
				$('.plantilla_a01 #enlace_al_adjunto').html('')
				$('.plantilla_a01 #enlace_al_adjunto').hide()
				$('.plantilla_a01 #icono_del_adjunto').show()
				$(this).parent().find(".preview_imagen_fichero").show()
				}

			
			elemento=this
            reader.onload = function (e) {
				$(elemento).parent().find(".img_fichero").attr("src", e.target.result);
				//$(elemento).parent().find("#enlace_al_adjunto").html($(elemento).val());
				//j$(this).parent().hide()
            }
			reader.readAsDataURL(this.files[0]);
			//j$(this).parent(".preview_imagen_fichero").find(".preview_imagen_asociada").show();
			}
		  else
		  	{
			$(this).parent().find(".img_fichero").attr("src", "");
			$(this).parent().find(".preview_imagen_fichero").hide()
			}
	
	});
    			

$(document).on("click", ".preview_imagen_fichero" , function () {  
		//console.log('ruta fichero: ' + $(this).find(".img_fichero").attr("src")) 
		mostrar_imagen($(this).find(".img_fichero").attr("src"), "Logo") 
	});	
	
mostrar_imagen = function (origen, tipo) {
		/* ya no se abre en una capa para ver la imagen, se abre un una ventana nueva por si es un pdf
		cadena="<div class='col-md-6 col-md-offset-3' style='margin-top:7px'><a href='#' class='thumbnail'><div class='image_thumb'>"
		cadena=cadena + "<img src='" + origen + "' class='img img-responsive full-width' />"
		cadena=cadena + "</div></a></div>"
		
		$('#cabecera_pantalla_avisos', window.parent.document).html(tipo)
		$('#body_avisos', window.parent.document).html(cadena);
		$('#pantalla_avisos', window.parent.document).modal("show")
		*/
		window.open(origen)
	};

</script>
</body>
</html>