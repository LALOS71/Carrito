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
	response.write("<br>PLANITLLA: " & plantilla & " cliente: " & codigo_cliente & " año pedido: " & anno_pedido & " pedido: " & codigo_pedido & " articulo: " & codigo_articulo & " cantidad: " & cantidad_articulo)
	response.write("variable sesion session('json_" & codigo_articulo & "'): " & texto_json)
	
	'para que se vean bien los acentos guardados en el fichero json
	Response.ContentType="text/html; charset=iso-8859-1"
%>
<html>

<head>

<title>Plantilla Personalizaci&oacute;n</title>

<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />


<style type="text/css">
 
#tabla { border: solid 1px #333;	width: 805px; }
#tabla_elemento { 
	border: solid 1px #333;	
	width: 800px; 
	-moz-border-radius: 6px; /* Firefox */
	-webkit-border-radius: 6px; /* Google Chrome y Safari */
	border-radius: 6px; /* CSS3 (Opera 10.5, IE 9 y estándar a ser soportado por todos los futuros navegadores) */
	
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
	border-radius: 4px 4px 4px 4px; /* CSS3 (Opera 10.5, IE 9 y estándar a ser soportado por todos los futuros navegadores) */
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
	border-radius: 6px; /* CSS3 (Opera 10.5, IE 9 y estándar a ser soportado por todos los futuros navegadores) */
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

</style>
<script type="text/javascript" src="../plugins/jquery/jquery-2.2.4.min.js"></script>
<script type="text/JavaScript" src="../plugins/printarea_2_4_0/jquery.PrintArea.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>




<!--
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
-->
<script type="text/javascript">

    
///////////////////////////////////////////////////////////
//creo el objeto que contendrá los valores de las plantillas para pasarlo a formato JSON
////////////////////////////////////////////////////////////

			var Plantilla_30 = function(ciudad, email){  
				 this.ciudad = ciudad;  
				 this.email = email;  
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
     var test = /[+#%&\\"\[\]{}]/;
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
		
		//clona la plantilla y la añade al final del body_principal, haciendo un efecto de retardo al mostrarla
		//$("#tabla tbody .<%=plantilla%>").clone().removeClass('<%=plantilla%>').appendTo("#body_principal").hide().fadeIn('slow');
			
		//clona la plantilla dentro del div datos al principio, haciendo un efecto de retardo al mostrarla
		//$(".plantilla:first").clone().prependTo("#datos").hide().fadeIn('slow');
		//$("#tabla tbody .<%=plantilla%>:first").clone().appendTo("#body_principal").hide().fadeIn('slow');
		
		//$("#contenedor_plantillas .<%=plantilla%>:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
				  
		
			
		
	});
 
	
	// Evento borra los datos en la plantilla_30
	$(document).on("click",".plantilla_30 .eliminar",function(){
		
		$('.plantilla_30 .ciudad_tarjeta').val('')
		$('.plantilla_30 .email_tarjeta').val('')
		
		$('.plantilla_30 .requerir').closest("div").addClass("has-error")
		$('.plantilla_30 .requerir').siblings().addClass("text-danger")
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
		
		//console.log('ciudad tarjeta: ' + $(".plantilla_30 .ciudad_tarjeta").val())
		if ($(".plantilla_30 .ciudad_tarjeta").val()=='')
				{
				cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Ciudad en la Plantilla.<br>'
				hay_error='SI'
				} 

		//console.log('email tajeta: ' + $(".plantilla_30 .email_tarjeta").val())
		if ($(".plantilla_30 .email_tarjeta").val()=='')
				{
				cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir el Email en la Plantilla.<br>'
				hay_error='SI'
				} 
			  else
				{
				if (!EsEmail($(".plantilla_30 .email_tarjeta").val()))
					{
					cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email de la Plantilla es incorrecto.<br>'
					hay_error='SI'
					}
				
				}
				
		//console.log('cadena_error: ' + cadena_error)
		//console.log('hay error: ' + hay_error)

		comprobando_especial=0
		$(".plantilla_30 input").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()!='')
						{
						if (EsEspecial($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Los Datos No Deben Contener Caracteres Especiales: + # % & \\ "" [ ] { }<br>'
							hay_error='SI'
							return false;
							}
						} 
					}
					
			
			});
		
		
		
		if (hay_error=='SI')
			{
			//alert(cadena_error);
			
			cadena='<BR><H3>Se Han Detectado Los Siguientes Errores:</H3><BR><H5>' + cadena_error + '</H5>'
			//$("#cabecera_pantalla_avisos", window.parent.document).html("<%=plantilla_personalizacion_pantalla_avisos_cabecera%>")
			//$("#body_avisos", window.parent.document).html(cadena + "<br>");
			//$("#botones_avisos", window.parent.document).html('<p><button type="button" class="btn btn-default" data-dismiss="modal"><%=plantilla_personalizacion_pantalla_avisos_boton_cerrar%></button></p><br>');                          
			//$("#pantalla_avisos", window.parent.document).modal("show");
			
			//console.log('vamos a la capa del padre');
			$("#cabecera_nueva_mensajes", window.parent.document).html("Avisos");
		    $("#body_nueva_mensajes", window.parent.document).html(cadena + "<br>");
			$("#capa_nueva_mensajes", window.parent.document).modal("show");

			
			//console.log('ha habido error: ' + cadena_error);
			}
		  else
		  	{
			//--alert('creamos el json')
			//console.log('no ha habido error y creamos el json')
			var jsonText = JSON.stringify(getFormJson());
			//--alert(jsonText);
			
			//console.log('hemos creado el json: ' + jsonText)
			
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
			
			
			//alert('Datos de Personalización del Artículo Recogidos Correctamente')
			
			
			cadena='<br><BR><H3>Datos de Personalización del Artículo Recogidos Correctamente</H3><BR><br>'
			//$("#cabecera_pantalla_avisos", window.parent.document).html("<%=plantilla_personalizacion_pantalla_avisos_cabecera%>")
			//$("#body_avisos", window.parent.document).html(cadena + "<br>");
			//$("#botones_avisos", window.parent.document).html('<p><button type="button" class="btn btn-default" data-dismiss="modal"><%=plantilla_personalizacion_pantalla_avisos_boton_cerrar%></button></p><br>');                          
			//$("#pantalla_avisos", window.parent.document).modal("show");

			
			$("#cabecera_nueva_mensajes", window.parent.document).html("Avisos");
		    $("#body_nueva_mensajes", window.parent.document).html(cadena + "<br>");
			$("#capa_nueva_mensajes", window.parent.document).modal("show");
			
			window.parent.$('#capa_nueva_plantilla').modal("hide");
			
			//window.parent.document.getElementById('icono_plantilla_<%=codigo_articulo%>').src='../images/Icono_Correcto_Verde.png'
			$("#icono_plantilla_<%=codigo_articulo%>", window.parent.document).removeClass("btn-warning").addClass("btn-success");
			$("#icono_plantilla_<%=codigo_articulo%>", window.parent.document).attr('title', 'Plantilla Para Personalizar El Artículo. YA SE HA COMPLETADO');
													
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
	///meto los valores de pedido, que tendré que obtener de algun sitio...
    var pedidoObj    = new Pedido('<%=codigo_cliente%>', '<%=codigo_pedido%>', 1);  
    
	var plan_ciudad = $(".plantilla_30 .ciudad_tarjeta").val();  
	var plan_email = $(".plantilla_30 .email_tarjeta").val();  
		
	//console.log('plan ciudad: ' + plan_ciudad)	
	//console.log('plan email: ' + plan_email)

	pedidoObj.addPlantilla(new Plantilla_30(plan_ciudad, plan_email));  
	
    return pedidoObj;  
}; 

 
function cargar_datos(usuario, numero_pedido, carpeta_anno, id_articulo, modo)

{
console.log('entramos en cargar_datos')
/*******************************************
ojito que para que funcione la captura de un fichero json y el iis no diga que no puede mostrar el archivo .json, 
tenemos que añadir esas extension al iis

	* en el administrador de iis. Hay que hacer click con el botón derecho en el directorio virtual del sitio web.
	* Ir a Propiedades - Encabezados HTTP - botón Tipos MIME.
	* Añadir el tipo Mime de este modo: Extensión: .json y Tipo Mime: application/json
***************************************************************/
	//console.log('la plantilla para este articulo es: <%=plantilla%>')

	//clona la plantilla y la añade al final del body_principal, haciendo un efecto de retardo al mostrarla
	//$("#tabla tbody .<%=plantilla%>").clone().removeClass('<%=plantilla%>').appendTo("#body_principal").hide().fadeIn('slow');
	
	//console.log('entramos en cargar datos')
	//$("#contenedor_plantillas .<%=plantilla%>:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');

	//console.log('despues de clonar la plantilla')
	//recuperamos los valores desde la variable de sesion si tiene contenido, por si se ha modificado con respecto al fichero
	//almacenado en disco
	texto_json='<%=texto_json%>'
	console.log('texto_json: ' + texto_json)
	if (texto_json!='')
		{
		//console.log('contenido json entrasmos porque es diferente a vacio: ' + texto_json)
		var plantillas=JSON.parse(texto_json)
		}
	  else //del if texto_json!=''
	  	{
			//console.log('texto_json esta vacio....')
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
				console.log('ruta fichero json en CONSULTAS (para coger contenido): ' + ruta_fichero_json)
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
							//--console.log('El elemento con el contiene '+ plantillas.plantillas[x].cantidad_tarjetas);
							//la primera plantilla no necesita clonarla, ya esta creada.... el resto ya si
							if ('<%=plantilla%>'=='plantilla_30')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_30:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_30 .ciudad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].ciudad)
								$('.plantilla_30 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
								}
							
							
							
							indice_plantillas++
							}				
								
								
								
					$(".<%=plantilla%> .requerir").closest("div").removeClass("has-error")
					$(".<%=plantilla%> .requerir").siblings().removeClass("text-danger")										
								
								
				}).fail(function(error){console.log(error);});
				
				
				}

			
		} 
		// del if texto_json!=''


		//console.log('objeto plantillas: ' + plantillas)
		if (typeof plantillas != 'undefined')
			{
			var indice_plantillas=1
			//console.log('plantillas.plantillas.ciudad: ' + plantillas.plantillas[0].ciudad)
			//console.log('plantillas.plantillas.email: ' + plantillas.plantillas[0].email)
			$('.plantilla_30 .ciudad_tarjeta').val(plantillas.plantillas[0].ciudad)
			$('.plantilla_30 .email_tarjeta').val(plantillas.plantillas[0].email)
			} //del if undefinded
			
			
			
			
		
}		
		
		
		
		
		
		
		
		

 
/***************************************** 
$(“#agregar”), es el encargado de ejecutar la función de agregado de la fila.

$(“#tabla tbody tr:eq(0)”).clone().removeClass(‘fila-base’).appendTo(“#tabla tbody”), esta es la parte más importante, 
y parece ser la más complicada, pero lo explicaré paso a paso:
	1. $(“#tabla tbody tr:eq(0)”), es un selector algo confuso, pero es simple, 
			solo es necesario avanzar por pasos: seleccionamos la tabla(#tabla), 
			seguimos con el cuerpo de la tabla(tbody), la primer fila del cuerpo(tr:eq(0), 
			el cero indica la posición, osea el cero es el primer elemento).
	2. .clone(), clonamos lo que acabamos de seleccionar en el paso 1.
	3. removeClass(‘fila-base’), quitamos la clase CSS “fila-base” (la que mantiene oculta nuestra fila base), 
			mucha atención en este punto: al remover la clase “fila-base” lo estamos haciendo al clon de nuestra fila base.
	4. .appendTo(“#tabla tbody”), agregamos el clon al cuerpo de la tabla “#tabla tbody”, 
			por defecto siempre se agrega al final o como último elemento.

$(document).on(“click”,”.eliminar”,function(), el selector que ejecuta la tarea de eliminar al hacer click sobre la celda “eliminar“.

var parent = $(this).parents().get(0);, $(this).parents(): selecciona los padres de la celda eliminar o en otras palabras 
	los elementos superiores y con .get(0) seleccionamos el primer elemento superior, para dejarlo más fácil: el elemento superior 
	de una celda(<td>) es una fila(<tr>).

$(parent).remove();, eliminamos o removemos la fila seleccionada.

.on, usamos .on() porque en las ultimas versiones de jQuery, esta es la nueva forma de utilizar los eventos, con el plus de que 
	también funciona con los nuevos elemento incrustados al DOM, añadiendo los eventos automáticamente, reemplazando a la funcion .live(), 
	la cual es obsoleta.
*****************************/


</script>


<!-- para añadir una variable de session con contenido json del articulo a personalizar mediante ajax-->
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
    try { //Primero se prueba con la mas reciente versión para IE
      Ajax = new ActiveXObject("Msxml2.XMLHTTP");
     } catch (e) {
       try { //Si el explorer no esta actualizado se prueba con la versión anterior
         Ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {}
      }
   }
 
  if (!Ajax) {
    alert('¡Por favor, actualice su navegador!');
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




</script>

</head>
<body onload="cargar_datos('<%=codigo_cliente%>', '<%=codigo_pedido%>', '<%=anno_pedido%>', '<%=codigo_articulo%>', '<%=modo%>')">

<div class="container-fluid" id="contenedor_plantillas" name="contenedor_plantillas">
	<div class="plantilla_30" >
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger">Ciudad:</span>
						<input type="text" class="form-control ciudad_tarjeta requerir">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger">Correo Electronico:</span>
						<input type="text" class="form-control email_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   Eliminar
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla30-->	
	
	
</div>	
<div class="container-fluid" id="botones">
	<div class="row">
		<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1"></div>
		<%if modo<>"CONSULTAR" then%>
			<% if session("usuario")<>249 and session("usuario")<>599 then 'los administradores de halcon y ecuador no pueden modificar la plantilla%>
				<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
					<button type="button" class="btn btn-primary btn-lg" id="guardar_plantillas" name="guardar_plantillas">
					   Guardar Plantilla
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
			   Cerrar Plantilla
			</button>
		</div>
	</div>
	
</div>


	
<!-- NO BORRAR, es la capa que añade el json del articulo....-->
<div id="capa_annadir_json_articulo" style="display:none "></div>

<script language="JavaScript">

	
			
	
</script>
</body>
</html>