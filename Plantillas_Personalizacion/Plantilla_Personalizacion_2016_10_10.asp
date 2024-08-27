<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
	'response.write("<br>PLANITLLA: " & plantilla & " cliente: " & codigo_cliente & " año pedido: " & anno_pedido & " pedido: " & codigo_pedido & " articulo: " & codigo_articulo & " cantidad: " & cantidad_articulo)
	'response.write("variable sesion session('json_" & codigo_articulo & "'): " & texto_json)
	'para que se vean bien los acentos guardados en el fichero json
	Response.ContentType="text/html; charset=iso-8859-1"
%>
<html>

<head>



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


<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<!--
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
-->
<script type="text/javascript">
///////////////////////////////////////////////////////////
//creo el objeto que contendrá los valores de las plantillas para pasarlo a formato JSON
////////////////////////////////////////////////////////////
			var Plantilla_1 = function(cantidad_tarjetas, nombre, apellidos, cargo, telefono, fax, movil, email, web, calle, numero_calle, poblacion, cp, provincia, email_pruebas, telefono_2){  
  			     this.cantidad_tarjetas   = cantidad_tarjetas;  
       			 this.nombre = nombre;  
				 this.apellidos = apellidos;  
				 this.cargo = cargo;
				 this.telefono = telefono;  
				 this.fax = fax;  
				 this.movil = movil;  
				 this.email = email;  
				 this.web = web;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia;  
				 this.email_pruebas = email_pruebas;  
				 this.telefono_2 = telefono_2;  
			}  
			
			var Plantilla_2 = function(telefono, email_pruebas){  
				 this.telefono = telefono;  
				 this.email_pruebas = email_pruebas;  
			}  
			
			
			var Plantilla_3 = function(telefono, email, calle, numero_calle, poblacion, cp, provincia, email_pruebas){  
				 this.telefono = telefono;  
				 this.email = email;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia;  
				 this.email_pruebas = email_pruebas;  
			}  
			
			var Plantilla_4 = function(calle, numero_calle, poblacion, cp, provincia, email_pruebas){  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia;  
				 this.email_pruebas = email_pruebas;  
			}  
						
			var Plantilla_5 = function(telefono, fax, email, calle, numero_calle, poblacion, cp, provincia, email_pruebas){  
				 this.telefono = telefono;  
				 this.fax = fax;  
				 this.email = email;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia;  
				 this.email_pruebas = email_pruebas;  
			}  

			var Plantilla_6 = function(horario, telefono, email_pruebas){  
  			     this.horario   = horario;  
				 this.telefono = telefono;  
				 this.email_pruebas = email_pruebas;  
			}  
						
			var Plantilla_7 = function(telefono, fax, email, calle, numero_calle, poblacion, cp, provincia, email_pruebas){  
				 this.telefono = telefono;  
				 this.fax = fax;  
				 this.email = email;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia;  
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
		$("#tabla tbody .<%=plantilla%>:first").clone().appendTo("#body_principal").hide().fadeIn('slow');
				  
		
			
		
	});
 
	// Evento que selecciona la fila y la elimina en la plantilla_1
	$(document).on("click",".plantilla_1 .eliminar",function(){
		//var parent = $(this).parents().get(0);
		//$(parent).remove();
		var parent = $(this).parents().get(4)
		//para que desaparezca lentamente
		$(parent).fadeOut('slow', function () {
				$(parent).remove();
			});
		
	});
	
	// Evento borra los datos en la plantilla_2
	$(document).on("click",".plantilla_2 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_2 .telefono_tarjeta').val('')
		$('.plantilla_2 .email_prueba_tarjeta').val('')
	});
	
	// Evento borra los datos en la plantilla_3
	$(document).on("click",".plantilla_3 .eliminar",function(){
		$('.plantilla_3 .telefono_tarjeta').val('')
		$('.plantilla_3 .email_tarjeta').val('')
		$('.plantilla_3 .calle_tarjeta').val('')
		$('.plantilla_3 .numero_calle_tarjeta').val('')
		$('.plantilla_3 .poblacion_tarjeta').val('')
		$('.plantilla_3 .cp_tarjeta').val('')
		$('.plantilla_3 .provincia_tarjeta').val('')
		$('.plantilla_3 .email_prueba_tarjeta').val('')
	});
	
	// Evento borra los datos en la plantilla_4
	$(document).on("click",".plantilla_4 .eliminar",function(){
		$('.plantilla_4 .calle_tarjeta').val('')
		$('.plantilla_4 .numero_calle_tarjeta').val('')
		$('.plantilla_4 .poblacion_tarjeta').val('')
		$('.plantilla_4 .cp_tarjeta').val('')
		$('.plantilla_4 .provincia_tarjeta').val('')
		$('.plantilla_4 .email_prueba_tarjeta').val('')
	});
	
	// Evento borra los datos en la plantilla_5
	$(document).on("click",".plantilla_5 .eliminar",function(){
		$('.plantilla_5 .telefono_tarjeta').val('')
		$('.plantilla_5 .fax_tarjeta').val('')
		$('.plantilla_5 .email_tarjeta').val('')
		$('.plantilla_5 .calle_tarjeta').val('')
		$('.plantilla_5 .numero_calle_tarjeta').val('')
		$('.plantilla_5 .poblacion_tarjeta').val('')
		$('.plantilla_5 .cp_tarjeta').val('')
		$('.plantilla_5 .provincia_tarjeta').val('')
		$('.plantilla_5 .email_prueba_tarjeta').val('')
	});
	
	// Evento borra los datos en la plantilla_6
	$(document).on("click",".plantilla_6 .eliminar",function(){
		$('.plantilla_6 .horario_tarjeta').val('')
		$('.plantilla_6 .telefono_tarjeta').val('')
		$('.plantilla_6 .email_prueba_tarjeta').val('')
	});
	
	// Evento borra los datos en la plantilla_7
	$(document).on("click",".plantilla_7 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_7 .telefono_tarjeta').val('')
		$('.plantilla_7 .fax_tarjeta').val('')
		$('.plantilla_7 .email_tarjeta').val('')
		$('.plantilla_7 .calle_tarjeta').val('')
		$('.plantilla_7 .numero_calle_tarjeta').val('')
		$('.plantilla_7 .poblacion_tarjeta').val('')
		$('.plantilla_7 .cp_tarjeta').val('')
		$('.plantilla_7 .provincia_tarjeta').val('')
		$('.plantilla_7 .email_prueba_tarjeta').val('')
		
	});
	
	
	/* para recorrer la coleccion de tarjetas haciendo pruebas
	$(document).on("click",".listar_elementos", function(){
			var elementos = $(".cantidad_tarjeta");
			var size = $(".cantidad_tarjeta").size();
			
			alert('hay txtnombre: ' + size)
			$('.cantidad_tarjeta').each(function(indice, elemento) {
				console.log('El elemento con el índice '+indice+' contiene '+$(elemento).val());
				alert('El elemento con el índice '+indice+' contiene '+$(elemento).val());
			});
	
	});
	*/
	
	$("#guardar_plantillas").on("click", function(){
		//var elementos= $(".tabla_elementos");
		//var tamanno=$(".tabla_elementos").size();
		//alert('hola')
		hay_error='NO'
		cadena_error=''
		sumar_cantidades='SI'
		total_cantidad=0
		
		//PLANTILLA_1		
		if ('<%=plantilla%>'=='plantilla_1')
			{
			$(".plantilla_1 .cantidad_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir una Cantidad en la Plantilla nº ' + indice + '.<br>'
						hay_error='SI'
						sumar_cantidades='NO'
						} 
					  else
						{
						if (!EsEntero($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- La Cantidad de la Plantilla nº ' + indice + ' ha de ser un Número Entero.<br>'
							hay_error='SI'
							sumar_cantidades='NO'
							}
						
						}
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_1 .nombre_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir un Nombre en la Plantilla nº ' + indice + '.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			$(".plantilla_1 .apellidos_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir Los Apellidos en la Plantilla nº ' + indice + '.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_1 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Telefono en la Plantilla nº ' + indice + '.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_1 .email_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir un Email en la Plantilla nº ' + indice + '.<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email de la Plantilla nº ' + indice + ' es incorrecto.<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_1 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Calle en la Plantilla nº ' + indice + '.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_1 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Numero de la Calle en la Plantilla nº ' + indice + '.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_1 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Población en la Plantilla nº ' + indice + '.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_1 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Código Postal en la Plantilla nº ' + indice + '.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_1 .provincia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Provincia en la Plantilla nº ' + indice + '.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_1 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir un Email para el Envio de las Pruebas en la Plantilla nº ' + indice + '.<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email para el Envio de las Pruebas de la Plantilla nº ' + indice + ' es incorrecto.<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			//alert('valor de sumar_cantidades: ' + sumar_cantidades)
			if (sumar_cantidades=='SI')
				{
				$(".plantilla_1 .cantidad_tarjeta").each(function(indice, elemento) {
						if (indice!=0)
							{
							total_cantidad= total_cantidad + parseFloat($(elemento).val())
								
							}
							//--console.log('total_cantidades: ' + total_cantidad);
					
				});
				if (total_cantidad!=<%=cantidad_articulo%>)
					{
					cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- La Suma de las Cantidades es ' + total_cantidad + ' que es diferente a <%=cantidad_articulo%>.<br>'
					hay_error='SI'
					}
				}
			}

		//PLANTILLA_2		
		if ('<%=plantilla%>'=='plantilla_2')
			{
			$(".plantilla_2 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Telefono en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});

			$(".plantilla_2 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir un Email para el Envio de las Pruebas en la Plantilla.<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email para el Envio de las Pruebas de la Plantilla es Incorrecto.<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}
			
		
		
		//PLANTILLA_3		
		if ('<%=plantilla%>'=='plantilla_3')
			{
			$(".plantilla_3 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Telefono en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_3 .email_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()!='')
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email de la Plantilla es incorrecto.<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_3 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Calle en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_3 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Numero de la Calle en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_3 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Población en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_3 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Código Postal en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_3 .provincia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Provincia en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_3 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir un Email para el Envio de las Pruebas en la Plantilla.<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email para el Envio de las Pruebas de la Plantilla es incorrecto.<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}

		
		//PLANTILLA_4		
		if ('<%=plantilla%>'=='plantilla_4')
			{
			$(".plantilla_4 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Calle en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_4 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Numero de la Calle en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_4 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Población en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_4 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Código Postal en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_4 .provincia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Provincia en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_4 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir un Email para el Envio de las Pruebas en la Plantilla.<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email para el Envio de las Pruebas de la Plantilla es incorrecto.<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}

		
		
		//PLANTILLA_5		
		if ('<%=plantilla%>'=='plantilla_5')
			{
			$(".plantilla_5 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Telefono en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_5 .email_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()!='')
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email de la Plantilla es incorrecto.<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_5 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Calle en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_5 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Numero de la Calle en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_5 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Población en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_5 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Código Postal en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_5 .provincia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Provincia en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_5 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir un Email para el Envio de las Pruebas en la Plantilla.<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email para el Envio de las Pruebas de la Plantilla es incorrecto.<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}

		
		
		//PLANTILLA_6		
		if ('<%=plantilla%>'=='plantilla_6')
			{
			$(".plantilla_6 .horario_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Horario en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			$(".plantilla_6 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Telefono en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_6 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir un Email para el Envio de las Pruebas en la Plantilla.<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email para el Envio de las Pruebas de la Plantilla es incorrecto.<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}

		
		
		//PLANTILLA_7		
		if ('<%=plantilla%>'=='plantilla_7')
			{
			$(".plantilla_7 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Telefono en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_7 .email_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()!='')
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email de la Plantilla es incorrecto.<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_7 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Calle en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_7 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Numero de la Calle en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_7 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Población en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_7 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El Código Postal en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_7 .provincia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir La Provincia en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_7 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir un Email para el Envio de las Pruebas en la Plantilla.<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- El Email para el Envio de las Pruebas de la Plantilla es incorrecto.<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}

		
		
		
		
		
		
		
		if (hay_error=='SI')
			{
			//alert(cadena_error);
			
			cadena='<BR><H3>Se Han Detectado Los Siguientes Errores:</H3><BR><H5>' + cadena_error + '</H5>'
			$("#cabecera_pantalla_avisos", window.parent.document).html("Avisos")
			$("#body_avisos", window.parent.document).html(cadena + "<br>");
			$("#botones_avisos", window.parent.document).html('<p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p><br>');                          
			$("#pantalla_avisos", window.parent.document).modal("show");

			
			//console.log(cadena_error);
			}
		  else
		  	{
			//--alert('creamos el json')
			var jsonText = JSON.stringify(getFormJson());
			//--alert(jsonText);
			
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
			$("#cabecera_pantalla_avisos", window.parent.document).html("Avisos")
			$("#body_avisos", window.parent.document).html(cadena + "<br>");
			$("#botones_avisos", window.parent.document).html('<p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p><br>');                          
			$("#pantalla_avisos", window.parent.document).modal("show");


			//window.parent.document.getElementById('icono_plantilla_<%=codigo_articulo%>').src='../images/Icono_Correcto_Verde.png'
			$("#icono_plantilla_<%=codigo_articulo%>", window.parent.document).removeClass("btn-warning").addClass("btn-success");
			$("#icono_plantilla_<%=codigo_articulo%>", window.parent.document).attr('title', 'Plantilla Para Personalizar El Art&iacute;culo.<br>YA SE HA COMPLETADO');
													
			//console.log('cambiamos de btn-warning a btn-success en el boton "icono_plantilla_<%=codigo_articulo%>"') 										
			window.parent.cerrar_capas('capa_informacion');
			
			//--console.log(jsonText)
			
			
			
			
			
			
			
			}
	
	
	});
	
	
	
	$("#cerrar_plantillas").on('click', function(){
			window.parent.cerrar_capas('capa_informacion');
	});
 
	
});



function getFormJson(){  
	///meto los valores de pedido, que tendré que obtener de algun sitio...
    var pedidoObj    = new Pedido('<%=codigo_cliente%>', '<%=codigo_pedido%>', ($(".<%=plantilla%> .email_prueba_tarjeta").size()-1));  
    
	//PLANTILLA_1
	if ('<%=plantilla%>'=='plantilla_1')
		{
		var plan_cantidades  = $(".plantilla_1 .cantidad_tarjeta");  
		var plan_nombres = $(".plantilla_1 .nombre_tarjeta");  
		var plan_apellidos = $(".plantilla_1 .apellidos_tarjeta");  
		var plan_cargos = $(".plantilla_1 .cargo_tarjeta");  
		var plan_telefonos = $(".plantilla_1 .telefono_tarjeta");  
		var plan_faxes = $(".plantilla_1 .fax_tarjeta");  
		var plan_moviles = $(".plantilla_1 .movil_tarjeta");  
		var plan_emails = $(".plantilla_1 .email_tarjeta");  
		var plan_webs = $(".plantilla_1 .pagina_web_tarjeta");  
		var plan_calles = $(".plantilla_1 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_1 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_1 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_1 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_1 .provincia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_1 .email_prueba_tarjeta");  
		var plan_telefonos_2 = $(".plantilla_1 .telefono2_tarjeta");  
		
		jQuery.each(plan_cantidades, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_1(plan_cantidades[pos].value, 
							plan_nombres[pos].value, 
							plan_apellidos[pos].value,
							plan_cargos[pos].value,
							plan_telefonos[pos].value,
							plan_faxes[pos].value,
							plan_moviles[pos].value,
							plan_emails[pos].value,
							plan_webs[pos].value,
							plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_provincias[pos].value,
							plan_emails_pruebas[pos].value,
							plan_telefonos_2[pos].value
							));  
			}
		});  
		}
		
	//PLANTILLA_2
	if ('<%=plantilla%>'=='plantilla_2')
		{
		var plan_telefonos = $(".plantilla_2 .telefono_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_2 .email_prueba_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_2(plan_telefonos[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
			
	
	//PLANTILLA_3
	if ('<%=plantilla%>'=='plantilla_3')
		{
		var plan_telefonos = $(".plantilla_3 .telefono_tarjeta");  
		var plan_emails = $(".plantilla_3 .email_tarjeta");  
		var plan_calles = $(".plantilla_3 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_3 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_3 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_3 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_3 .provincia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_3 .email_prueba_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_3(plan_telefonos[pos].value,
							plan_emails[pos].value,
							plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_provincias[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
		
	
	//PLANTILLA_4
	if ('<%=plantilla%>'=='plantilla_4')
		{
		var plan_calles = $(".plantilla_4 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_4 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_4 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_4 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_4 .provincia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_4 .email_prueba_tarjeta");  
		
		jQuery.each(plan_calles, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_4(plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_provincias[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
		
	
	
	//PLANTILLA_5
	if ('<%=plantilla%>'=='plantilla_5')
		{
		var plan_telefonos = $(".plantilla_5 .telefono_tarjeta");  
		var plan_faxes = $(".plantilla_5 .fax_tarjeta");  
		var plan_emails = $(".plantilla_5 .email_tarjeta");  
		var plan_calles = $(".plantilla_5 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_5 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_5 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_5 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_5 .provincia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_5 .email_prueba_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_5(plan_telefonos[pos].value,
							plan_faxes[pos].value,
							plan_emails[pos].value,
							plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_provincias[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
		
	
	//PLANTILLA_6
	if ('<%=plantilla%>'=='plantilla_6')
		{
		var plan_horario  = $(".plantilla_6 .horario_tarjeta");  
		var plan_telefonos = $(".plantilla_6 .telefono_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_6 .email_prueba_tarjeta");  
		
		jQuery.each(plan_horario, function(pos, item){  
			if (pos>0)
			{
			//console.log('plan_horario[pos].value contine: ' + plan_horario[pos].value)
			pedidoObj.addPlantilla(new Plantilla_6(plan_horario[pos].value, 
							plan_telefonos[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
		
	
	//PLANTILLA_7
	if ('<%=plantilla%>'=='plantilla_7')
		{
		var plan_telefonos = $(".plantilla_7 .telefono_tarjeta");  
		var plan_faxes = $(".plantilla_7 .fax_tarjeta");  
		var plan_emails = $(".plantilla_7 .email_tarjeta");  
		var plan_calles = $(".plantilla_7 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_7 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_7 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_7 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_7 .provincia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_7 .email_prueba_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_7(
							plan_telefonos[pos].value,
							plan_faxes[pos].value,
							plan_emails[pos].value,
							plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_provincias[pos].value,
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
tenemos que añadir esas extension al iis

	* en el administrador de iis. Hay que hacer click con el botón derecho en el directorio virtual del sitio web.
	* Ir a Propiedades - Encabezados HTTP - botón Tipos MIME.
	* Añadir el tipo Mime de este modo: Extensión: .json y Tipo Mime: application/json
***************************************************************/
	//console.log('la plantilla para este articulo es: <%=plantilla%>')

	//clona la plantilla y la añade al final del body_principal, haciendo un efecto de retardo al mostrarla
	//$("#tabla tbody .<%=plantilla%>").clone().removeClass('<%=plantilla%>').appendTo("#body_principal").hide().fadeIn('slow');
	$("#tabla tbody .<%=plantilla%>:first").clone().appendTo("#body_principal").hide().fadeIn('slow');

	//recuperamos los valores desde la variable de sesion si tiene contenido, por si se ha modificado con respecto al fichero
	//almacenado en disco
	texto_json='<%=texto_json%>'
	if (texto_json!='')
		{
		//console.log('contenido json: ' + texto_json)
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
				$.getJSON(ruta_fichero_json, function(plantillas) {}).fail(function(error){console.log(error);});
				}

		
		} 
		// del if texto_json!=''


		//console.log('objeto plantillas: ' + plantillas)
		if (typeof plantillas != 'undefined')
			{
			var indice_plantillas=1
			for (x in plantillas.plantillas)
				{
				//--console.log('El elemento con el contiene '+ plantillas.plantillas[x].cantidad_tarjetas);
				//la primera plantilla no necesita clonarla, ya esta creada.... el resto ya si
				if ('<%=plantilla%>'=='plantilla_1')
					{
					if (indice_plantillas!=1)
						{
						//$("#tabla tbody .plantilla_1").clone().removeClass('plantilla_1').appendTo("#body_principal").hide().fadeIn('slow');
						$("#tabla tbody .plantilla_1:first").clone().appendTo("#body_principal").hide().fadeIn('slow');
						}
					
					$('.plantilla_1 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
					
					$('.plantilla_1 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
					$('.plantilla_1 .nombre_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].nombre)
					$('.plantilla_1 .apellidos_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].apellidos)
					$('.plantilla_1 .cargo_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cargo)
					$('.plantilla_1 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_1 .fax_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fax)
					$('.plantilla_1 .movil_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].movil)
					$('.plantilla_1 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
					$('.plantilla_1 .pagina_web_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].web)
					$('.plantilla_1 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_1 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_1 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_1 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_1 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_1 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					$('.plantilla_1 .telefono2_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono_2)
					}
	
	
				if ('<%=plantilla%>'=='plantilla_2')
					{
					if (indice_plantillas!=1)
						{
						//$("#tabla tbody .plantilla_2").clone().removeClass('plantilla_2').appendTo("#body_principal").hide().fadeIn('slow');
						$("#tabla tbody .plantilla_2:first").clone().appendTo("#body_principal").hide().fadeIn('slow');
						}
					
					$('.plantilla_2 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_2 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
	
				if ('<%=plantilla%>'=='plantilla_3')
					{
					if (indice_plantillas!=1)
						{
						//$("#tabla tbody .plantilla_1").clone().removeClass('plantilla_1').appendTo("#body_principal").hide().fadeIn('slow');
						$("#tabla tbody .plantilla_3:first").clone().appendTo("#body_principal").hide().fadeIn('slow');
						}
					
					$('.plantilla_3 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_3 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
					$('.plantilla_3 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_3 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_3 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_3 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_3 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_3 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
	
				if ('<%=plantilla%>'=='plantilla_4')
					{
					if (indice_plantillas!=1)
						{
						//$("#tabla tbody .plantilla_1").clone().removeClass('plantilla_1').appendTo("#body_principal").hide().fadeIn('slow');
						$("#tabla tbody .plantilla_4:first").clone().appendTo("#body_principal").hide().fadeIn('slow');
						}
					
					$('.plantilla_4 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_4 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_4 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_4 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_4 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_4 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
				if ('<%=plantilla%>'=='plantilla_5')
					{
					if (indice_plantillas!=1)
						{
						//$("#tabla tbody .plantilla_1").clone().removeClass('plantilla_1').appendTo("#body_principal").hide().fadeIn('slow');
						$("#tabla tbody .plantilla_5:first").clone().appendTo("#body_principal").hide().fadeIn('slow');
						}
					
					$('.plantilla_5 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_5 .fax_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fax)
					$('.plantilla_5 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
					$('.plantilla_5 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_5 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_5 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_5 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_5 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_5 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
	
				if ('<%=plantilla%>'=='plantilla_6')
					{
					if (indice_plantillas!=1)
						{
						//$("#tabla tbody .plantilla_1").clone().removeClass('plantilla_1').appendTo("#body_principal").hide().fadeIn('slow');
						$("#tabla tbody .plantilla_6:first").clone().appendTo("#body_principal").hide().fadeIn('slow');
						}
					//console.log('volcamos a la caja de texto del horario: ' + plantillas.plantillas[x].horario)
					$('.plantilla_6 .horario_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].horario)
					$('.plantilla_6 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_6 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
	
				if ('<%=plantilla%>'=='plantilla_7')
					{
					if (indice_plantillas!=1)
						{
						//$("#tabla tbody .plantilla_1").clone().removeClass('plantilla_1').appendTo("#body_principal").hide().fadeIn('slow');
						$("#tabla tbody .plantilla_7:first").clone().appendTo("#body_principal").hide().fadeIn('slow');
						}
					
					$('.plantilla_7 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_7 .fax_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fax)
					$('.plantilla_7 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
					$('.plantilla_7 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_7 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_7 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_7 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_7 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_7 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
	
	
				//$('.nombre_tarjeta')[indice].val(plantillas.plantillas[x].nombre)
				//('.apellidos_tarjeta')[indice].val(plantillas.plantillas[x].apellidos)
				indice_plantillas++
				}		
				
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


<table id="tabla">
 
	<!-- Cuerpo de la tabla con los campos -->
	<tbody id="body_principal">
 
		<!-- plantillas para clonar y agregar al final -->
		<tr class="plantilla_1" style="display:none">
			<td>
				<table width="626" id="tabla_elemento">
					<tr>
						<td width="120" class="obligatorio texto_celda">&nbsp;Cantidad</td>
						<td width="120" class="obligatorio texto_celda">&nbsp;Nombre</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Apellidos</td>
						<td width="120" class="texto_celda borde_celda">&nbsp;Cargo</td>
						<td width="120" class="obligatorio texto_celda">&nbsp;Telf.</td>
					</tr>
					
					
					<tr>
						<td><input type="text" class="cantidad_tarjeta" size="8" /></td>
						<td><input type="text" class="nombre_tarjeta" size="14" /></td>
						<td colspan="2"><input type="text" class="apellidos_tarjeta" size="35" /></td>
						<td><input type="text" class="cargo_tarjeta" size="14" /></td>
						<td><input type="text" class="telefono_tarjeta" size="14" /></td>
					</tr>
					
					<tr>
						<td class="texto_celda borde_celda">&nbsp;Fax</td>
						<td class="texto_celda borde_celda">&nbsp;Movil</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Email</td>
						<td colspan="2" class="texto_celda borde_celda">&nbsp;Web</td>
						
					</tr>
					<tr>
						<td><input type="text" class="fax_tarjeta" size="14" /></td>
						<td><input type="text" class="movil_tarjeta" size="14" /></td>
						<td colspan="2"><input type="text" class="email_tarjeta" size="35" /></td>
						<td colspan="2"><input type="text" class="pagina_web_tarjeta" size="35" /></td>
						
					</tr>
					<tr>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Calle</td>
						<td width="120" class="obligatorio texto_celda">&nbsp;Num.</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Población</td>
						<td class="obligatorio texto_celda">&nbsp;C. P.</td>
					</tr>
					<tr>
						<td colspan="2"><input type="text" class="calle_tarjeta" size="35" /></td>
						<td><input type="text" class="numero_calle_tarjeta" size="14" /></td>
						<td colspan="2" ><input type="text" class="poblacion_tarjeta" size="35"/></td>
						<td><input type="text" class="cp_tarjeta"  size="14"/></td>
					</tr>
					<tr>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Provincia</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Email Envio Prueba</td>
						<td class="texto_celda borde_celda">&nbsp;Telf. 2</td>
						<td rowspan="2" align="center" class="eliminar texto_celda boton_celda ">Eliminar</td>
					</tr>
					<tr>
						<td colspan="2" ><input type="text" class="provincia_tarjeta" size="35"/></td>
						<td colspan="2" ><input type="text" class="email_prueba_tarjeta" size="35" /></td>
						<td><input type="text" class="telefono2_tarjeta" size="14" /></td>
					</tr>
					<tr>
						<td colspan="2"  class="texto_celda"><div class="obligatorio texto_celda" style="height:12px;width:20px;float:left"></div>&nbsp;Campos Obligatorios</td>
						<td class="listar_elementos texto_celda"></td>
						<td width="120">&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					
			  </table>
			</td>
		</tr>
		
		
		<tr class="plantilla_2" style="display:none">
			<td>
				<table width="626" id="tabla_elemento">
					<tr>
						<td width="120" class="obligatorio texto_celda">&nbsp;Telf.</td>
						<td colspan="3" class="obligatorio texto_celda">&nbsp;Email Envio Prueba</td>
						<td width="122" rowspan="2" align="center" class="eliminar texto_celda boton_celda " style="border:0">Eliminar</td>
					</tr>
					
					
					<tr>
						<td><input type="text" class="telefono_tarjeta" size="14" /></td>
						<td colspan="3" ><input type="text" class="email_prueba_tarjeta" size="60" /></td>
						
					</tr>
					
					<tr>
						<td colspan="3"  class="texto_celda"><div class="obligatorio texto_celda" style="height:12px;width:20px;float:left"></div>&nbsp;Campos Obligatorios</td>
						<td width="284" class="listar_elementos texto_celda"></td>
						
					</tr>
					
			  </table>
			</td>
		</tr>
		
		
		<tr class="plantilla_3" style="display:none">
			<td>
				<table width="626" id="tabla_elemento">
					<tr>
						<td width="120" class="obligatorio texto_celda">&nbsp;Telf.</td>
						<td colspan="2" class="texto_celda borde_celda">&nbsp;Email</td>
					</tr>
					
					
					<tr>
						<td><input type="text" class="telefono_tarjeta" size="14" /></td>
						<td colspan="2"><input type="text" class="email_tarjeta" size="35" /></td>
					</tr>
					
					<tr>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Calle</td>
						<td width="120" class="obligatorio texto_celda">&nbsp;Num.</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Población</td>
						<td class="obligatorio texto_celda">&nbsp;C. P.</td>
					</tr>
					<tr>
						<td colspan="2"><input type="text" class="calle_tarjeta" size="35" /></td>
						<td><input type="text" class="numero_calle_tarjeta" size="14" /></td>
						<td colspan="2" ><input type="text" class="poblacion_tarjeta" size="35"/></td>
						<td><input type="text" class="cp_tarjeta"  size="14"/></td>
					</tr>
					<tr>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Provincia</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Email Envio Prueba</td>
						<td>&nbsp;</td>
						<td rowspan="2" align="center" class="eliminar texto_celda boton_celda ">Eliminar</td>
					</tr>
					<tr>
						<td colspan="2" ><input type="text" class="provincia_tarjeta" size="35"/></td>
						<td colspan="2" ><input type="text" class="email_prueba_tarjeta" size="35" /></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"  class="texto_celda"><div class="obligatorio texto_celda" style="height:12px;width:20px;float:left"></div>&nbsp;Campos Obligatorios</td>
						<td class="listar_elementos texto_celda"></td>
						<td width="120">&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					
			  </table>
			</td>
		</tr>
		
		
		<tr class="plantilla_4" style="display:none">
			<td>
				<table width="626" id="tabla_elemento">
					<tr>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Calle</td>
						<td width="120" class="obligatorio texto_celda">&nbsp;Num.</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Población</td>
						<td class="obligatorio texto_celda">&nbsp;C. P.</td>
					</tr>
					<tr>
						<td colspan="2"><input type="text" class="calle_tarjeta" size="35" /></td>
						<td><input type="text" class="numero_calle_tarjeta" size="14" /></td>
						<td colspan="2" ><input type="text" class="poblacion_tarjeta" size="35"/></td>
						<td><input type="text" class="cp_tarjeta"  size="14"/></td>
					</tr>
					<tr>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Provincia</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Email Envio Prueba</td>
						<td>&nbsp;</td>
						<td rowspan="2" align="center" class="eliminar texto_celda boton_celda ">Eliminar</td>
					</tr>
					<tr>
						<td colspan="2" ><input type="text" class="provincia_tarjeta" size="35"/></td>
						<td colspan="2" ><input type="text" class="email_prueba_tarjeta" size="35" /></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"  class="texto_celda"><div class="obligatorio texto_celda" style="height:12px;width:20px;float:left"></div>&nbsp;Campos Obligatorios</td>
						<td class="listar_elementos texto_celda"></td>
						<td width="120">&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					
			  </table>
			</td>
		</tr>
		
		<tr class="plantilla_5" style="display:none">
			<td>
				<table width="626" id="tabla_elemento">
					<tr>
						<td width="120" class="obligatorio texto_celda">&nbsp;Telf.</td>
						<td class="texto_celda borde_celda">&nbsp;Fax</td>
						<td colspan="2" class="texto_celda borde_celda">&nbsp;Email</td>
						
					</tr>
					
					
					<tr>
						<td><input type="text" class="telefono_tarjeta" size="14" /></td>
						<td><input type="text" class="fax_tarjeta" size="14" /></td>
						<td colspan="2"><input type="text" class="email_tarjeta" size="35" /></td>
						
					</tr>
					<tr>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Calle</td>
						<td width="120" class="obligatorio texto_celda">&nbsp;Num.</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Población</td>
						<td class="obligatorio texto_celda">&nbsp;C. P.</td>
					</tr>
					<tr>
						<td colspan="2"><input type="text" class="calle_tarjeta" size="35" /></td>
						<td><input type="text" class="numero_calle_tarjeta" size="14" /></td>
						<td colspan="2" ><input type="text" class="poblacion_tarjeta" size="35"/></td>
						<td><input type="text" class="cp_tarjeta"  size="14"/></td>
					</tr>
					<tr>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Provincia</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Email Envio Prueba</td>
						<td>&nbsp;</td>
						<td rowspan="2" align="center" class="eliminar texto_celda boton_celda ">Eliminar</td>
					</tr>
					<tr>
						<td colspan="2" ><input type="text" class="provincia_tarjeta" size="35"/></td>
						<td colspan="2" ><input type="text" class="email_prueba_tarjeta" size="35" /></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"  class="texto_celda"><div class="obligatorio texto_celda" style="height:12px;width:20px;float:left"></div>&nbsp;Campos Obligatorios</td>
						<td class="listar_elementos texto_celda"></td>
						<td width="120">&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					
			  </table>
			</td>
		</tr>
		
		
		<tr class="plantilla_6" style="display:none">
			<td>
				<table width="626" id="tabla_elemento">
					<tr>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Horario</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Email Envio Prueba</td>
						<td width="120" class="obligatorio texto_celda">&nbsp;Telf.</td>
						<td rowspan="2" align="center" class="eliminar texto_celda boton_celda ">Eliminar</td>
					</tr>
					<tr>
						<td colspan="2" ><input type="text" class="horario_tarjeta" size="35"/></td>
						<td colspan="2" ><input type="text" class="email_prueba_tarjeta" size="35" /></td>
						<td><input type="text" class="telefono_tarjeta" size="14" /></td>
					</tr>
					<tr>
						<td colspan="2"  class="texto_celda"><div class="obligatorio texto_celda" style="height:12px;width:20px;float:left"></div>&nbsp;Campos Obligatorios</td>
						<td class="listar_elementos texto_celda"></td>
						<td width="120">&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					
			  </table>
			</td>
		</tr>
		
		<tr class="plantilla_7" style="display:none">
			<td>
				<table width="626" id="tabla_elemento">
					<tr>
						<td width="120" class="obligatorio texto_celda">&nbsp;Telf.</td>
						<td class="texto_celda borde_celda">&nbsp;Fax</td>
						<td colspan="2" class="texto_celda borde_celda">&nbsp;Email</td>
						
					</tr>
					
					
					<tr>
						<td><input type="text" class="telefono_tarjeta" size="14" /></td>
						<td><input type="text" class="fax_tarjeta" size="14" /></td>
						<td colspan="2"><input type="text" class="email_tarjeta" size="35" /></td>
						
					</tr>
					<tr>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Calle</td>
						<td width="120" class="obligatorio texto_celda">&nbsp;Num.</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Población</td>
						<td class="obligatorio texto_celda">&nbsp;C. P.</td>
					</tr>
					<tr>
						<td colspan="2"><input type="text" class="calle_tarjeta" size="35" /></td>
						<td><input type="text" class="numero_calle_tarjeta" size="14" /></td>
						<td colspan="2" ><input type="text" class="poblacion_tarjeta" size="35"/></td>
						<td><input type="text" class="cp_tarjeta"  size="14"/></td>
					</tr>
					<tr>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Provincia</td>
						<td colspan="2" class="obligatorio texto_celda">&nbsp;Email Envio Prueba</td>
						<td>&nbsp;</td>
						<td rowspan="2" align="center" class="eliminar texto_celda boton_celda ">Eliminar</td>
					</tr>
					<tr>
						<td colspan="2" ><input type="text" class="provincia_tarjeta" size="35"/></td>
						<td colspan="2" ><input type="text" class="email_prueba_tarjeta" size="35" /></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"  class="texto_celda"><div class="obligatorio texto_celda" style="height:12px;width:20px;float:left"></div>&nbsp;Campos Obligatorios</td>
						<td class="listar_elementos texto_celda"></td>
						<td width="120">&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					
			  </table>
			</td>
		</tr>
		
		
		
		<!-- fin de las plantillas -->
 
 
	</tbody>
</table>
<!-- Botón para agregar filas -->
<table>
<tr><td height="2px"></td></tr>
<tr>
	<%if modo<>"CONSULTAR" then%>
		<%if plantilla="plantilla_1" then%>
			<td width="7px" height="25px"></td>
			<td align="center" class="texto_celda boton_celda " id="agregar" style="border:0 ">Agregar Plantilla</td>
		<%end if%>
		<td width="20px" height="25px"></td>
		<td align="center" class="texto_celda boton_celda " id="guardar_plantillas" style="border:0">Guardar Plantillas</td>
	<%end if%>
	<td width="200px" height="25px"></td>
	<td align="center" class="texto_celda boton_celda " id="cerrar_plantillas" style="border:0 ">Cerrar Plantillas</td>
	
</tr>
</table>



	
<!-- NO BORRAR, es la capa que añade el json del articulo....-->
<div id="capa_annadir_json_articulo" style="display:none "></div>
</body>
</html>