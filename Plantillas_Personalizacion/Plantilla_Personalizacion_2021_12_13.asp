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
	'response.write("<br>PLANITLLA: " & plantilla & " cliente: " & codigo_cliente & " año pedido: " & anno_pedido & " pedido: " & codigo_pedido & " articulo: " & codigo_articulo & " cantidad: " & cantidad_articulo)
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
			
			var Plantilla_8 = function(telefono, fax, email, calle, numero_calle, poblacion, cp, provincia, email_pruebas, horario_lu_vi, horario_sabados){  
				 this.telefono = telefono;  
				 this.fax = fax;  
				 this.email = email;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia;  
				 this.email_pruebas = email_pruebas;  
				 this.horario_lu_vi = horario_lu_vi;  
				 this.horario_sabados = horario_sabados;  
			} 

			var Plantilla_9 = function(fecha_desde, fecha_hasta, porcentaje, servicios, observaciones, calle, numero_calle, ciudad, cp, telefono, email_pruebas){  
				 this.fecha_desde = fecha_desde;  
				 this.fecha_hasta = fecha_hasta;  
				 this.porcentaje = porcentaje;  
				 this.servicios = servicios;  
				 this.observaciones = observaciones;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.ciudad = ciudad;  
				 this.cp = cp;  
				 this.telefono = telefono;
				 this.email_pruebas = email_pruebas;  
			} 

			var Plantilla_10 = function(telefono, calle, numero_calle, poblacion, cp, provincia, pais, email_pruebas){  
				 this.telefono = telefono;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia; 
				 this.pais= pais; 
				 this.email_pruebas = email_pruebas;  
			}
			
			var Plantilla_11 = function(cantidad_tarjetas, nombre, apellidos, cargo, telefono, fax, movil, email, razon_social, calle, numero_calle, poblacion, cp, provincia, email_pruebas){  
  			     this.cantidad_tarjetas   = cantidad_tarjetas;  
       			 this.nombre = nombre;  
				 this.apellidos = apellidos;  
				 this.cargo = cargo;
				 this.telefono = telefono;  
				 this.fax = fax;  
				 this.movil = movil;  
				 this.email = email;  
				 this.razon_social = razon_social;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia;  
				 this.email_pruebas = email_pruebas;  
			}  
			
			var Plantilla_12 = function(cantidad_tarjetas, nombre, apellidos, cargo, telefono, fax, movil, email, calle, numero_calle, poblacion, cp, provincia, email_pruebas){  
  			     this.cantidad_tarjetas   = cantidad_tarjetas;  
       			 this.nombre = nombre;  
				 this.apellidos = apellidos;  
				 this.cargo = cargo;
				 this.telefono = telefono;  
				 this.fax = fax;  
				 this.movil = movil;  
				 this.email = email;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia;  
				 this.email_pruebas = email_pruebas;  
			}  
			
			var Plantilla_13 = function(departamento, email_pruebas){  
				 this.departamento = departamento;  
				 this.email_pruebas = email_pruebas;  
			}
			
			var Plantilla_14 = function(calle, numero_calle, email_pruebas){  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.email_pruebas = email_pruebas;  
			}  
			
			var Plantilla_15 = function(cantidad_tarjetas, numero_agencia, localidad, telefono, fax, movil, email, razon_social, calle, numero_calle, poblacion, cp, provincia, email_pruebas){  
  			     this.cantidad_tarjetas   = cantidad_tarjetas;  
       			 this.numero_agencia = numero_agencia;  
				 this.localidad = localidad;  
				 this.telefono = telefono;  
				 this.fax = fax;  
				 this.movil = movil;  
				 this.email = email;  
				 this.razon_social = razon_social;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia;  
				 this.email_pruebas = email_pruebas;  
			}
			
			var Plantilla_16 = function(calle, numero_calle, poblacion, cp, telefono, email_pruebas){  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.telefono = telefono;  
				 this.email_pruebas = email_pruebas;  
			} 
			
			var Plantilla_17 = function(calle, numero_calle, poblacion, cp, telefono, email_agencia, email_pruebas){  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.telefono = telefono;  
				 this.email_agencia = email_agencia;
				 this.email_pruebas = email_pruebas;  
			}  
			
			var Plantilla_18 = function(razon_social, telefono, calle, numero_calle, poblacion, cp, email_pruebas, horario_lu_vi, horario_sabados){  
				 this.razon_social = razon_social;  
				 this.telefono = telefono;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.email_pruebas = email_pruebas;  
				 this.horario_lu_vi = horario_lu_vi;  
				 this.horario_sabados = horario_sabados;  
			} 
			
			var Plantilla_19 = function(razon_social, cif, calle, numero_calle, poblacion, cp, email_pruebas){  
				 this.razon_social = razon_social;  
				 this.cif = cif;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.email_pruebas = email_pruebas;  
			} 
			
			var Plantilla_20 = function(nombre_grupo, expediente, total_venta_expediente, total_coste_expediente, beneficio){  
				 this.nombre_grupo = nombre_grupo;  
				 this.expediente = expediente;  
				 this.total_venta_expediente = total_venta_expediente;  
				 this.total_coste_expediente = total_coste_expediente;  
				 this.beneficio = beneficio;  
			} 
			
			var Plantilla_21 = function(expediente){  
				 this.expediente = expediente;  
			} 
			
			var Plantilla_22 = function(telefono, email, calle, numero_calle, poblacion, cp, provincia, email_pruebas){  
				 this.telefono = telefono;  
				 this.email = email;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.provincia = provincia;  
				 this.email_pruebas = email_pruebas;  
			}
			
			var Plantilla_23 = function(calle, numero_calle, poblacion, cp, telefono, email_agencia, email_pruebas, precio_envio_internacional){  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.telefono = telefono;  
				 this.email_agencia = email_agencia;
				 this.email_pruebas = email_pruebas;  
				 this.precio_envio_internacional= precio_envio_internacional
			} 
			
			var Plantilla_24 = function(calle, numero_calle, poblacion, cp, telefono, email_agencia, email_pruebas, precio_envio_nacional){  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.telefono = telefono;  
				 this.email_agencia = email_agencia;
				 this.email_pruebas = email_pruebas;  
				 this.precio_envio_nacional= precio_envio_nacional
			}  

			var Plantilla_25 = function(calle, numero_calle, poblacion, cp, telefono, email_agencia, email_pruebas, precio_envio_nacional, precio_envio_internacional){  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.telefono = telefono;  
				 this.email_agencia = email_agencia;
				 this.email_pruebas = email_pruebas;  
				 this.precio_envio_nacional= precio_envio_nacional
				 this.precio_envio_internacional= precio_envio_internacional
			} 
			
			var Plantilla_26 = function(razon_social, cif, calle, numero_calle, poblacion, cp, email_pruebas, numero_conductor){  
				 this.razon_social = razon_social;  
				 this.cif = cif;  
				 this.calle = calle;  
				 this.numero_calle = numero_calle;  
				 this.poblacion = poblacion;  
				 this.cp = cp;  
				 this.email_pruebas = email_pruebas;
				 this.numero_conductor = numero_conductor;  
			} 
			
			var Plantilla_27 = function(razon_social, calle, numero_calle, poblacion, cp, provincia, email_pruebas){  
				 this.razon_social = razon_social;  
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
		$("#contenedor_plantillas .<%=plantilla%>:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
				  
		
			
		
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
		
		$('.plantilla_2 .requerir').closest("div").addClass("has-error")
		$('.plantilla_2 .requerir').siblings().addClass("text-danger")
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
		
		$('.plantilla_3 .requerir').closest("div").addClass("has-error")
		$('.plantilla_3 .requerir').siblings().addClass("text-danger")
	});
	
	// Evento borra los datos en la plantilla_4
	$(document).on("click",".plantilla_4 .eliminar",function(){
		$('.plantilla_4 .calle_tarjeta').val('')
		$('.plantilla_4 .numero_calle_tarjeta').val('')
		$('.plantilla_4 .poblacion_tarjeta').val('')
		$('.plantilla_4 .cp_tarjeta').val('')
		$('.plantilla_4 .provincia_tarjeta').val('')
		$('.plantilla_4 .email_prueba_tarjeta').val('')
		
		//$($('.plantilla_4 .requerir').closest("div")).addClass("has-error")
		$('.plantilla_4 .requerir').closest("div").addClass("has-error")
		$('.plantilla_4 .requerir').siblings().addClass("text-danger")
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
		
		$('.plantilla_5 .requerir').closest("div").addClass("has-error")
		$('.plantilla_5 .requerir').siblings().addClass("text-danger")
	});
	
	// Evento borra los datos en la plantilla_6
	$(document).on("click",".plantilla_6 .eliminar",function(){
		$('.plantilla_6 .horario_tarjeta').val('')
		$('.plantilla_6 .telefono_tarjeta').val('')
		$('.plantilla_6 .email_prueba_tarjeta').val('')
		
		$('.plantilla_6 .requerir').closest("div").addClass("has-error")
		$('.plantilla_6 .requerir').siblings().addClass("text-danger")
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
		
		$('.plantilla_7 .requerir').closest("div").addClass("has-error")
		$('.plantilla_7 .requerir').siblings().addClass("text-danger")
		
	});
	
	
	// Evento borra los datos en la plantilla_8
	$(document).on("click",".plantilla_8 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_8 .telefono_tarjeta').val('')
		$('.plantilla_8 .fax_tarjeta').val('')
		$('.plantilla_8 .email_tarjeta').val('')
		$('.plantilla_8 .calle_tarjeta').val('')
		$('.plantilla_8 .numero_calle_tarjeta').val('')
		$('.plantilla_8 .poblacion_tarjeta').val('')
		$('.plantilla_8 .cp_tarjeta').val('')
		$('.plantilla_8 .provincia_tarjeta').val('')
		$('.plantilla_8 .email_prueba_tarjeta').val('')
		$('.plantilla_8 .horario_lu_vi_tarjeta').val('')
		$('.plantilla_8 .horario_sabados_tarjeta').val('')
		
		$('.plantilla_8 .requerir').closest("div").addClass("has-error")
		$('.plantilla_8 .requerir').siblings().addClass("text-danger")
		
	});
	
	// Evento borra los datos en la plantilla_9
	$(document).on("click",".plantilla_9 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_9 .fecha_desde_tarjeta').val('')
		$('.plantilla_9 .fecha_hasta_tarjeta').val('')
		$('.plantilla_9 .porcentaje_tarjeta').val('')
		$('.plantilla_9 .servicios_tarjeta').val('')
		$('.plantilla_9 .observaciones_tarjeta').val('')
		$('.plantilla_9 .calle_tarjeta').val('')
		$('.plantilla_9 .numero_calle_tarjeta').val('')
		$('.plantilla_9 .poblacion_tarjeta').val('')
		$('.plantilla_9 .cp_tarjeta').val('')
		$('.plantilla_9 .telefono_tarjeta').val('')
		$('.plantilla_9 .email_prueba_tarjeta').val('')
		
		$('.plantilla_9 .requerir').closest("div").addClass("has-error")
		$('.plantilla_9 .requerir').siblings().addClass("text-danger")
		
	});

	// Evento borra los datos en la plantilla_10
	$(document).on("click",".plantilla_10 .eliminar",function(){
		$('.plantilla_10 .telefono_tarjeta').val('')
		$('.plantilla_10 .calle_tarjeta').val('')
		$('.plantilla_10 .numero_calle_tarjeta').val('')
		$('.plantilla_10 .poblacion_tarjeta').val('')
		$('.plantilla_10 .cp_tarjeta').val('')
		$('.plantilla_10 .provincia_tarjeta').val('')
		$('.plantilla_10 .pais_tarjeta').val('')
		$('.plantilla_10 .email_prueba_tarjeta').val('')
		
		$('.plantilla_10 .requerir').closest("div").addClass("has-error")
		$('.plantilla_10 .requerir').siblings().addClass("text-danger")
	});
	
	// Evento que selecciona la fila y la elimina en la plantilla_11
	$(document).on("click",".plantilla_11 .eliminar",function(){
		//var parent = $(this).parents().get(0);
		//$(parent).remove();
		var parent = $(this).parents().get(4)
		//para que desaparezca lentamente
		$(parent).fadeOut('slow', function () {
				$(parent).remove();
			});
		
	});
	
	
	// Evento que selecciona la fila y la elimina en la plantilla_12
	$(document).on("click",".plantilla_12 .eliminar",function(){
		//var parent = $(this).parents().get(0);
		//$(parent).remove();
		var parent = $(this).parents().get(4)
		//para que desaparezca lentamente
		$(parent).fadeOut('slow', function () {
				$(parent).remove();
			});
		
	});
	
	// Evento borra los datos en la plantilla_13
	$(document).on("click",".plantilla_13 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_13 .departamento_tarjeta').val('')
		$('.plantilla_13 .email_prueba_tarjeta').val('')
		
		$('.plantilla_13 .requerir').closest("div").addClass("has-error")
		$('.plantilla_13 .requerir').siblings().addClass("text-danger")
	});
	
	// Evento borra los datos en la plantilla_14
	$(document).on("click",".plantilla_14 .eliminar",function(){
		$('.plantilla_14 .calle_tarjeta').val('')
		$('.plantilla_14 .numero_calle_tarjeta').val('')
		$('.plantilla_14 .email_prueba_tarjeta').val('')
		
		$('.plantilla_14 .requerir').closest("div").addClass("has-error")
		$('.plantilla_14 .requerir').siblings().addClass("text-danger")
	});
	
	// Evento que selecciona la fila y la elimina en la plantilla_15
	$(document).on("click",".plantilla_15 .eliminar",function(){
		//var parent = $(this).parents().get(0);
		//$(parent).remove();
		var parent = $(this).parents().get(4)
		//para que desaparezca lentamente
		$(parent).fadeOut('slow', function () {
				$(parent).remove();
			});
		
	});
	
	// Evento borra los datos en la plantilla_16
	$(document).on("click",".plantilla_16 .eliminar",function(){
		$('.plantilla_16 .calle_tarjeta').val('')
		$('.plantilla_16 .numero_calle_tarjeta').val('')
		$('.plantilla_16 .poblacion_tarjeta').val('')
		$('.plantilla_16 .cp_tarjeta').val('')
		$('.plantilla_16 .telefono_tarjeta').val('')
		$('.plantilla_16 .email_prueba_tarjeta').val('')
		
		$('.plantilla_16 .requerir').closest("div").addClass("has-error")
		$('.plantilla_16 .requerir').siblings().addClass("text-danger")
	});

	// Evento borra los datos en la plantilla_17
	$(document).on("click",".plantilla_17 .eliminar",function(){
		$('.plantilla_17 .calle_tarjeta').val('')
		$('.plantilla_17 .numero_calle_tarjeta').val('')
		$('.plantilla_17 .poblacion_tarjeta').val('')
		$('.plantilla_17 .cp_tarjeta').val('')
		$('.plantilla_17 .telefono_tarjeta').val('')
		$('.plantilla_17 .email_agencia_tarjeta').val('')
		$('.plantilla_17 .email_prueba_tarjeta').val('')
		
		$('.plantilla_17 .requerir').closest("div").addClass("has-error")
		$('.plantilla_17 .requerir').siblings().addClass("text-danger")
	});
	
	// Evento borra los datos en la plantilla_18
	$(document).on("click",".plantilla_18 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_18 .razon_social_tarjeta').val('')
		$('.plantilla_18 .telefono_tarjeta').val('')
		$('.plantilla_18 .calle_tarjeta').val('')
		$('.plantilla_18 .numero_calle_tarjeta').val('')
		$('.plantilla_18 .poblacion_tarjeta').val('')
		$('.plantilla_18 .cp_tarjeta').val('')
		$('.plantilla_18 .email_prueba_tarjeta').val('')
		$('.plantilla_18 .horario_lu_vi_tarjeta').val('')
		$('.plantilla_18 .horario_sabados_tarjeta').val('')
		
		$('.plantilla_18 .requerir').closest("div").addClass("has-error")
		$('.plantilla_18 .requerir').siblings().addClass("text-danger")
		
	});
	
	// Evento borra los datos en la plantilla_19
	$(document).on("click",".plantilla_19 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_19 .razon_social_tarjeta').val('')
		$('.plantilla_19 .cif_tarjeta').val('')
		$('.plantilla_19 .calle_tarjeta').val('')
		$('.plantilla_19 .numero_calle_tarjeta').val('')
		$('.plantilla_19 .poblacion_tarjeta').val('')
		$('.plantilla_19 .cp_tarjeta').val('')
		$('.plantilla_19 .email_prueba_tarjeta').val('')
		
		$('.plantilla_19 .requerir').closest("div").addClass("has-error")
		$('.plantilla_19 .requerir').siblings().addClass("text-danger")
		
	});
	
	
	// Evento borra los datos en la plantilla_20
	$(document).on("click",".plantilla_20 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_20 .nombre_grupo_tarjeta').val('')
		$('.plantilla_20 .expediente_tarjeta').val('')
		$('.plantilla_20 .total_venta_expediente_tarjeta').val('')
		$('.plantilla_20 .total_coste_expediente_tarjeta').val('')
		$('.plantilla_20 .beneficio_tarjeta').val('')
		
		$('.plantilla_20 .requerir').closest("div").addClass("has-error")
		$('.plantilla_20 .requerir').siblings().addClass("text-danger")
	});
	
	// Evento borra los datos en la plantilla_20
	$(document).on("click",".plantilla_21 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_21 .expediente').val('')
		
		$('.plantilla_21 .requerir').closest("div").addClass("has-error")
		$('.plantilla_21 .requerir').siblings().addClass("text-danger")
	});
	
	// Evento borra los datos en la plantilla_22
	$(document).on("click",".plantilla_22 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_22 .telefono_tarjeta').val('')
		$('.plantilla_22 .email_tarjeta').val('')
		$('.plantilla_22 .calle_tarjeta').val('')
		$('.plantilla_22 .numero_calle_tarjeta').val('')
		$('.plantilla_22 .poblacion_tarjeta').val('')
		$('.plantilla_22 .cp_tarjeta').val('')
		$('.plantilla_22 .provincia_tarjeta').val('')
		$('.plantilla_22 .email_prueba_tarjeta').val('')
		
		$('.plantilla_22 .requerir').closest("div").addClass("has-error")
		$('.plantilla_22 .requerir').siblings().addClass("text-danger")
		
	});
	
	// Evento borra los datos en la plantilla_23
	$(document).on("click",".plantilla_23 .eliminar",function(){
		$('.plantilla_23 .calle_tarjeta').val('')
		$('.plantilla_23 .numero_calle_tarjeta').val('')
		$('.plantilla_23 .poblacion_tarjeta').val('')
		$('.plantilla_23 .cp_tarjeta').val('')
		$('.plantilla_23 .telefono_tarjeta').val('')
		$('.plantilla_23 .email_agencia_tarjeta').val('')
		$('.plantilla_23 .email_prueba_tarjeta').val('')
		$('.plantilla_23 .precio_envio_internacional_tarjeta').val('')
		
		$('.plantilla_23 .requerir').closest("div").addClass("has-error")
		$('.plantilla_23 .requerir').siblings().addClass("text-danger")
	});
	
	// Evento borra los datos en la plantilla_24
	$(document).on("click",".plantilla_24 .eliminar",function(){
		$('.plantilla_24 .calle_tarjeta').val('')
		$('.plantilla_24 .numero_calle_tarjeta').val('')
		$('.plantilla_24 .poblacion_tarjeta').val('')
		$('.plantilla_24 .cp_tarjeta').val('')
		$('.plantilla_24 .telefono_tarjeta').val('')
		$('.plantilla_24 .email_agencia_tarjeta').val('')
		$('.plantilla_24 .email_prueba_tarjeta').val('')
		$('.plantilla_24 .precio_envio_nacional_tarjeta').val('')
		
		$('.plantilla_24 .requerir').closest("div").addClass("has-error")
		$('.plantilla_24 .requerir').siblings().addClass("text-danger")
	});
	
	// Evento borra los datos en la plantilla_25
	$(document).on("click",".plantilla_25 .eliminar",function(){
		$('.plantilla_25 .calle_tarjeta').val('')
		$('.plantilla_25 .numero_calle_tarjeta').val('')
		$('.plantilla_25 .poblacion_tarjeta').val('')
		$('.plantilla_25 .cp_tarjeta').val('')
		$('.plantilla_25 .telefono_tarjeta').val('')
		$('.plantilla_25 .email_agencia_tarjeta').val('')
		$('.plantilla_25 .email_prueba_tarjeta').val('')
		$('.plantilla_25 .precio_envio_nacional_tarjeta').val('')
		$('.plantilla_25 .precio_envio_internacional_tarjeta').val('')
		
		$('.plantilla_25 .requerir').closest("div").addClass("has-error")
		$('.plantilla_25 .requerir').siblings().addClass("text-danger")
	});
	
	
	// Evento borra los datos en la plantilla_26
	$(document).on("click",".plantilla_26 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_26 .razon_social_tarjeta').val('')
		$('.plantilla_26 .cif_tarjeta').val('')
		$('.plantilla_26 .calle_tarjeta').val('')
		$('.plantilla_26 .numero_calle_tarjeta').val('')
		$('.plantilla_26 .poblacion_tarjeta').val('')
		$('.plantilla_26 .cp_tarjeta').val('')
		$('.plantilla_26 .email_prueba_tarjeta').val('')
		
		$('.plantilla_26 .requerir').closest("div").addClass("has-error")
		$('.plantilla_26 .requerir').siblings().addClass("text-danger")
		
	});
	
	// Evento borra los datos en la plantilla_27
	$(document).on("click",".plantilla_27 .eliminar",function(){
		//console.log('eliminar de la plantilla 2')
		$('.plantilla_27 .razon_social_tarjeta').val('')
		$('.plantilla_27 .calle_tarjeta').val('')
		$('.plantilla_27 .numero_calle_tarjeta').val('')
		$('.plantilla_27 .poblacion_tarjeta').val('')
		$('.plantilla_27 .cp_tarjeta').val('')
		$('.plantilla_27 .provincia_tarjeta').val('')
		$('.plantilla_27 .email_prueba_tarjeta').val('')
		
		$('.plantilla_27 .requerir').closest("div").addClass("has-error")
		$('.plantilla_27 .requerir').siblings().addClass("text-danger")
		
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
		
		
				//PLANTILLA_1		
		if ('<%=plantilla%>'=='plantilla_1')
			{
			$(".plantilla_1 .cantidad_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_cantidad%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						sumar_cantidades='NO'
						} 
					  else
						{
						if (!EsEntero($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_cantidad_numerico%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
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
						valor='<%=plantilla_personalizacion_error_nombre%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
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
						valor='<%=plantilla_personalizacion_error_apellidos%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
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
						valor='<%=plantilla_personalizacion_error_telefono%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
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
						valor='<%=plantilla_personalizacion_error_email%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_email_formato%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
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
						valor='<%=plantilla_personalizacion_error_calle%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
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
						valor='<%=plantilla_personalizacion_error_numero_calle%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
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
						valor='<%=plantilla_personalizacion_error_poblacion%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
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
						valor='<%=plantilla_personalizacion_error_cp%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
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
						valor='<%=plantilla_personalizacion_error_provincia%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
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
						valor='<%=plantilla_personalizacion_error_email_prueba%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_email_prueba_formato%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
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
					valor='<%=plantilla_personalizacion_error_total_cantidad%>'
					valor=valor.replace('XXX', total_cantidad)
					cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('YYY', '<%=cantidad_articulo%>') + '<br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
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
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_formato_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_provincia_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%>.<br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_provincia_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
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
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_formato_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_provincia_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_horario_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
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
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_formato_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_provincia_otros%><br>'
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
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			}
			
		//PLANTILLA_8		
		if ('<%=plantilla%>'=='plantilla_8')
			{
			$(".plantilla_8 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_8 .email_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()!='')
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_8 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_8 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_8 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_8 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_8 .provincia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_provincia_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_8 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_8 .horario_lu_vi_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_horario_lu_vi_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_8 .horario_sabados_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_horario_sabados_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}


		//PLANTILLA_9		
		if ('<%=plantilla%>'=='plantilla_9')
			{
			$(".plantilla_9 .fecha_desde_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_fecha_desde_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_9 .fecha_hasta_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_fecha_hasta_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_9 .porcentaje_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_porcentaje_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_9 .servicios_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_servicios_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			/*
			$(".plantilla_9 .observaciones_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_observaciones_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			*/
			
			$(".plantilla_9 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_9 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_9 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_ciudad_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_9 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
						
			$(".plantilla_9 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_9 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else

						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			
	
			}


		//PLANTILLA_10		
		if ('<%=plantilla%>'=='plantilla_10')
			{
			$(".plantilla_10 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_10 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_10 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_10 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_10 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_10 .provincia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_provincia_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_10 .pais_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_pais_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_10 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}

		
		
		//PLANTILLA_11		
		if ('<%=plantilla%>'=='plantilla_11')
			{
			$(".plantilla_11 .cantidad_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_cantidad%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						sumar_cantidades='NO'
						} 
					  else
						{
						if (!EsEntero($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_cantidad_numerico%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
							hay_error='SI'
							sumar_cantidades='NO'
							}
						
						}
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_11 .nombre_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_nombre%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			$(".plantilla_11 .apellidos_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_apellidos%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_11 .cargo_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_cargo%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});

			$(".plantilla_11 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_telefono%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_11 .movil_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_movil%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});

			
			$(".plantilla_11 .email_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_email%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					  else
						{
						<%'si desde GLS piden TARJETAS DE VISITA AGENCIAS (2440), tienen que poner el mail corporativo @gls-spain.es
						if session("usuario_codigo_empresa")=4 and codigo_articulo=2440 then%>
							if ($(elemento).val().toUpperCase().indexOf('@GLS-SPAIN.ES') == -1)
								{
								valor='Ha de introducir un Email Corporativo (xxxx@gls-spain.es) en la Plantilla nº ' + indice + '.'
								cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor + '<br>'
								hay_error='SI'
								}
						<%end if%>
						if (!EsEmail($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_email_formato%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_11 .razon_social_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_razon_social%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_11 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_calle%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_11 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_numero_calle%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_11 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_poblacion%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_11 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_cp%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_11 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_email_prueba%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_email_prueba_formato%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			//alert('valor de sumar_cantidades: ' + sumar_cantidades)
			if (sumar_cantidades=='SI')
				{
				$(".plantilla_11 .cantidad_tarjeta").each(function(indice, elemento) {
						if (indice!=0)
							{
							total_cantidad= total_cantidad + parseFloat($(elemento).val())
								
							}
							//--console.log('total_cantidades: ' + total_cantidad);
					
				});
				if (total_cantidad!=<%=cantidad_articulo%>)
					{
					valor='<%=plantilla_personalizacion_error_total_cantidad%>'
					valor=valor.replace('XXX', total_cantidad)
					cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('YYY', '<%=cantidad_articulo%>') + '<br>'
					hay_error='SI'
					}
				}
			}



		//PLANTILLA_12		
		if ('<%=plantilla%>'=='plantilla_12')
			{
			$(".plantilla_12 .cantidad_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_cantidad%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						sumar_cantidades='NO'
						} 
					  else
						{
						if (!EsEntero($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_cantidad_numerico%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
							hay_error='SI'
							sumar_cantidades='NO'
							}
						
						}
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_12 .nombre_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_nombre%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			$(".plantilla_12 .apellidos_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_apellidos%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_12 .cargo_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_cargo%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_12 .movil_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_movil%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});

			
			$(".plantilla_12 .email_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_email%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					  else
						{
						<%'si desde GLS piden TARJETAS DE VISITA EMPLEADOS (2706), tienen que poner el mail corporativo @gls-spain.es
						if session("usuario_codigo_empresa")=4 and codigo_articulo=2706 then%>
							if ($(elemento).val().toUpperCase().indexOf('@GLS-SPAIN.ES') == -1)
								{
								valor='Ha de introducir un Email Corporativo (xxxx@gls-spain.es) en la Plantilla nº ' + indice + '.'
								cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor + '<br>'
								hay_error='SI'
								}
						<%end if%>
						if (!EsEmail($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_email_formato%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_12 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_calle%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_12 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_numero_calle%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_12 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_poblacion%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_12 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_cp%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_12 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_email_prueba%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_email_prueba_formato%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			//alert('valor de sumar_cantidades: ' + sumar_cantidades)
			if (sumar_cantidades=='SI')
				{
				$(".plantilla_12 .cantidad_tarjeta").each(function(indice, elemento) {
						if (indice!=0)
							{
							total_cantidad= total_cantidad + parseFloat($(elemento).val())
								
							}
							//--console.log('total_cantidades: ' + total_cantidad);
					
				});
				if (total_cantidad!=<%=cantidad_articulo%>)
					{
					valor='<%=plantilla_personalizacion_error_total_cantidad%>'
					valor=valor.replace('XXX', total_cantidad)
					cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('YYY', '<%=cantidad_articulo%>') + '<br>'
					hay_error='SI'
					}
				}
			}

	
		//PLANTILLA_13		
		if ('<%=plantilla%>'=='plantilla_13')
			{
			//console.log('comprobacion de datos rellenos en la plantilla 13')
			$(".plantilla_13 .departamento_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_departamento_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});

			$(".plantilla_13 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}
			
		//PLANTILLA_14		
		if ('<%=plantilla%>'=='plantilla_14')
			{
			$(".plantilla_14 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_14 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_14 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}
			
			
		//PLANTILLA_15		
		if ('<%=plantilla%>'=='plantilla_15')
			{
			$(".plantilla_15 .cantidad_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_cantidad%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						sumar_cantidades='NO'
						} 
					  else
						{
						if (!EsEntero($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_cantidad_numerico%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
							hay_error='SI'
							sumar_cantidades='NO'
							}
						
						}
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_15 .numero_agencia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_numero_agencia%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			$(".plantilla_15 .localidad_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_localidad%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			
			$(".plantilla_15 .movil_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_movil%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});

			
			$(".plantilla_15 .email_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_email%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					  else
						{
						<%'si desde GLS piden TARJETAS DE VISITA AGENCIAS (2745), tienen que poner el mail corporativo @gls-spain.es
						if session("usuario_codigo_empresa")=4 and codigo_articulo=2745 then%>
							if ($(elemento).val().toUpperCase().indexOf('@GLS-SPAIN.ES') == -1)
								{
								valor='Ha de introducir un Email Corporativo (xxxx@gls-spain.es) en la Plantilla nº ' + indice + '.'
								cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor + '<br>'
								hay_error='SI'
								}
						<%end if%>
						if (!EsEmail($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_email_formato%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_15 .razon_social_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_razon_social%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_15 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_calle%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_15 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_numero_calle%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_15 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_poblacion%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_15 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_cp%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_15 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						valor='<%=plantilla_personalizacion_error_email_prueba%>'
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							valor='<%=plantilla_personalizacion_error_email_prueba_formato%>'
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('XXX', indice) + '<br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			//alert('valor de sumar_cantidades: ' + sumar_cantidades)
			if (sumar_cantidades=='SI')
				{
				$(".plantilla_15 .cantidad_tarjeta").each(function(indice, elemento) {
						if (indice!=0)
							{
							total_cantidad= total_cantidad + parseFloat($(elemento).val())
								
							}
							//--console.log('total_cantidades: ' + total_cantidad);
					
				});
				if (total_cantidad!=<%=cantidad_articulo%>)
					{
					valor='<%=plantilla_personalizacion_error_total_cantidad%>'
					valor=valor.replace('XXX', total_cantidad)
					cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ' + valor.replace('YYY', '<%=cantidad_articulo%>') + '<br>'
					hay_error='SI'
					}
				}
			}


		
		//PLANTILLA_16		
		if ('<%=plantilla%>'=='plantilla_16')
			{
			$(".plantilla_16 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_16 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_16 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_16 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_16 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
		

			$(".plantilla_16 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}



		//PLANTILLA_17		
		if ('<%=plantilla%>'=='plantilla_17')
			{
			$(".plantilla_17 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_17 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_17 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_17 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_17 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
		
			$(".plantilla_17 .email_agencia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
		

			$(".plantilla_17 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}

		//PLANTILLA_18		
		if ('<%=plantilla%>'=='plantilla_18')
			{
			$(".plantilla_18 .razon_social_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=replace(plantilla_personalizacion_error_razon_social," nº XXX", "")%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			$(".plantilla_18 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_18 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_18 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_18 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_18 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
	
			$(".plantilla_18 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			/*
			$(".plantilla_18 .horario_lu_vi_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_horario_lu_vi_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_18 .horario_sabados_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_horario_sabados_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			*/
			
			}


		//PLANTILLA_19		
		if ('<%=plantilla%>'=='plantilla_19')
			{
			$(".plantilla_19 .razon_social_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=replace(plantilla_personalizacion_error_razon_social," nº XXX", "")%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_19 .cif_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El CIF en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_19 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_19 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_19 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_19 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			
			$(".plantilla_19 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			
			}

		
		//PLANTILLA_20		
		if ('<%=plantilla%>'=='plantilla_20')
			{
			$(".plantilla_20 .nombre_grupo_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Introducir el Nombre del Grupo.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			});

			$(".plantilla_20 .expediente_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Introducir el Expediente.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			});
			
			$(".plantilla_20 .total_venta_expediente_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Introducir el Total Venta Expediente.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			});

			$(".plantilla_20 .total_coste_expediente_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Introducir el Total Coste Expediente.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			});

			$(".plantilla_20 .beneficio_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Introducir el Beneficio.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			});

			}

		//PLANTILLA_21	
		if ('<%=plantilla%>'=='plantilla_21')
			{
			$(".plantilla_21 .expediente").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Introducir el Expediente.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			});
			}


		//PLANTILLA_22		
		if ('<%=plantilla%>'=='plantilla_22')
			{
			$(".plantilla_22 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_22 .email_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			
			$(".plantilla_22 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_22 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_22 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_22 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_22 .provincia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_provincia_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_22 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			}
			
			
		//PLANTILLA_23		
		if ('<%=plantilla%>'=='plantilla_23')
			{
			$(".plantilla_23 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_23 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_23 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_23 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_23 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
		
			$(".plantilla_23 .email_agencia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
		

			$(".plantilla_23 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_23 .precio_envio_internacional_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de Indicar El Precio Desde Para Los Envios Internacionales.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}
			
		//PLANTILLA_24		
		if ('<%=plantilla%>'=='plantilla_24')
			{
			$(".plantilla_24 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_24 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_24 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_24 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_24 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
		
			$(".plantilla_24 .email_agencia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
		

			$(".plantilla_24 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_24 .precio_envio_nacional_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de Indicar El Precio Desde Para Los Envios Nacionales.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}
					
		//PLANTILLA_25		
		if ('<%=plantilla%>'=='plantilla_25')
			{
			$(".plantilla_25 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_25 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_25 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_25 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_25 .telefono_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_telefono_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
		
			$(".plantilla_25 .email_agencia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
		

			$(".plantilla_25 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_25 .precio_envio_nacional_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de Indicar El Precio Desde Para Los Envios Nacionales.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_25 .precio_envio_internacional_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de Indicar El Precio Desde Para Los Envios Internacionales.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			}
			
		//PLANTILLA_26		
		if ('<%=plantilla%>'=='plantilla_26')
			{
			$(".plantilla_26 .razon_social_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=replace(plantilla_personalizacion_error_razon_social," nº XXX", "")%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_26 .cif_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Ha de introducir El CIF en la Plantilla.<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_26 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_26 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_26 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_26 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			
			$(".plantilla_26 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
	
			$(".plantilla_26 .numero_conductor").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Introducir el Numero de Conductor<br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			
			}

		//PLANTILLA_27		
		if ('<%=plantilla%>'=='plantilla_27')
			{
			$(".plantilla_27 .razon_social_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=replace(plantilla_personalizacion_error_razon_social," nº XXX", "")%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_27 .calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_27 .numero_calle_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_numero_calle_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_27 .poblacion_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_poblacion_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_27 .cp_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_cp_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			$(".plantilla_27 .provincia_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_provincia_otros%><br>'
						hay_error='SI'
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
	
			$(".plantilla_27 .email_prueba_tarjeta").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()=='')
						{
						cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_otros%><br>'
						hay_error='SI'
						} 
					  else
						{
						if (!EsEmail($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_email_prueba_formato_otros%><br>'
							hay_error='SI'
							}
						
						}
						
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
			
			}

					
		//final ifs plantillas			

		comprobando_especial=0
		$(".<%=plantilla%> input").each(function(indice, elemento) {
				if (indice!=0)
					{
					if ($(elemento).val()!='')
						{
						if (EsEspecial($(elemento).val()))
							{
							cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <%=plantilla_personalizacion_error_caracteres_especiales%><br>'
							hay_error='SI'
							return false;
							}
						} 
					}
					//console.log('indice: ' + indice + ' valor en cantidad: ' + $(elemento).val());
			
			});
		
		
		
		console.log('ahora pasamos a comprobar si ha habido algun dato en blanco')
		if (hay_error=='SI')
			{
			//alert(cadena_error);
			
			cadena='<BR><H3><%=plantilla_personalizacion_error_explicacion%></H3><BR><H5>' + cadena_error + '</H5>'
			//$("#cabecera_pantalla_avisos", window.parent.document).html("<%=plantilla_personalizacion_pantalla_avisos_cabecera%>")
			//$("#body_avisos", window.parent.document).html(cadena + "<br>");
			//$("#botones_avisos", window.parent.document).html('<p><button type="button" class="btn btn-default" data-dismiss="modal"><%=plantilla_personalizacion_pantalla_avisos_boton_cerrar%></button></p><br>');                          
			//$("#pantalla_avisos", window.parent.document).modal("show");
			
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
		
	
	//PLANTILLA_8
	if ('<%=plantilla%>'=='plantilla_8')
		{
		var plan_telefonos = $(".plantilla_8 .telefono_tarjeta");  
		var plan_faxes = $(".plantilla_8 .fax_tarjeta");  
		var plan_emails = $(".plantilla_8 .email_tarjeta");  
		var plan_calles = $(".plantilla_8 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_8 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_8 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_8 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_8 .provincia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_8 .email_prueba_tarjeta");  
		var plan_horario_lu_vi = $(".plantilla_8 .horario_lu_vi_tarjeta");  
		var plan_horario_sabados = $(".plantilla_8 .horario_sabados_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_8(
							plan_telefonos[pos].value,
							plan_faxes[pos].value,
							plan_emails[pos].value,
							plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_provincias[pos].value,
							plan_emails_pruebas[pos].value,
							plan_horario_lu_vi[pos].value,
							plan_horario_sabados[pos].value
							));  
			}
		});  
		}
		
	//PLANTILLA_9
	if ('<%=plantilla%>'=='plantilla_9')
		{
		var plan_fecha_desde = $(".plantilla_9 .fecha_desde_tarjeta");  
		var plan_fecha_hasta = $(".plantilla_9 .fecha_hasta_tarjeta");  
		var plan_porcentaje = $(".plantilla_9 .porcentaje_tarjeta");  
		var plan_servicios = $(".plantilla_9 .servicios_tarjeta");  
		var plan_observaciones = $(".plantilla_9 .observaciones_tarjeta");  
		var plan_calles = $(".plantilla_9 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_9 .numero_calle_tarjeta");  
		var plan_ciudades = $(".plantilla_9 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_9 .cp_tarjeta");  
		var plan_telefonos = $(".plantilla_9 .telefono_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_9 .email_prueba_tarjeta");
		
		
		jQuery.each(plan_fecha_desde, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_9(
							plan_fecha_desde[pos].value,
							plan_fecha_hasta[pos].value,
							plan_porcentaje[pos].value,
							plan_servicios[pos].value,
							plan_observaciones[pos].value,
							plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_ciudades[pos].value,
							plan_cps[pos].value,
							plan_telefonos[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
		
		
		
	//PLANTILLA_10
	if ('<%=plantilla%>'=='plantilla_10')
		{
		var plan_telefonos = $(".plantilla_10 .telefono_tarjeta");  
		var plan_calles = $(".plantilla_10 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_10 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_10 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_10 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_10 .provincia_tarjeta");  
		var plan_paises = $(".plantilla_10 .pais_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_10 .email_prueba_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_10(plan_telefonos[pos].value,
							plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_provincias[pos].value,
							plan_paises[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
		
	
	//PLANTILLA_11
	if ('<%=plantilla%>'=='plantilla_11')
		{
		var plan_cantidades  = $(".plantilla_11 .cantidad_tarjeta");  
		var plan_nombres = $(".plantilla_11 .nombre_tarjeta");  
		var plan_apellidos = $(".plantilla_11 .apellidos_tarjeta");  
		var plan_cargos = $(".plantilla_11 .cargo_tarjeta");  
		var plan_telefonos = $(".plantilla_11 .telefono_tarjeta");  
		var plan_faxes = $(".plantilla_11 .fax_tarjeta");  
		var plan_moviles = $(".plantilla_11 .movil_tarjeta");  
		var plan_emails = $(".plantilla_11 .email_tarjeta");  
		var plan_razones_sociales = $(".plantilla_11 .razon_social_tarjeta");  
		var plan_calles = $(".plantilla_11 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_11 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_11 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_11 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_11 .provincia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_11 .email_prueba_tarjeta");  
		
		jQuery.each(plan_cantidades, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_11(plan_cantidades[pos].value, 
							plan_nombres[pos].value, 
							plan_apellidos[pos].value,
							plan_cargos[pos].value,
							plan_telefonos[pos].value,
							plan_faxes[pos].value,
							plan_moviles[pos].value,
							plan_emails[pos].value,
							plan_razones_sociales[pos].value,
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
		
		
	//PLANTILLA_12
	if ('<%=plantilla%>'=='plantilla_12')
		{
		var plan_cantidades  = $(".plantilla_12 .cantidad_tarjeta");  
		var plan_nombres = $(".plantilla_12 .nombre_tarjeta");  
		var plan_apellidos = $(".plantilla_12 .apellidos_tarjeta");  
		var plan_cargos = $(".plantilla_12 .cargo_tarjeta");  
		var plan_telefonos = $(".plantilla_12 .telefono_tarjeta");  
		var plan_faxes = $(".plantilla_12 .fax_tarjeta");  
		var plan_moviles = $(".plantilla_12 .movil_tarjeta");  
		var plan_emails = $(".plantilla_12 .email_tarjeta");  
		var plan_calles = $(".plantilla_12 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_12 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_12 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_12 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_12 .provincia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_12 .email_prueba_tarjeta");  
		
		jQuery.each(plan_cantidades, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_12(plan_cantidades[pos].value, 
							plan_nombres[pos].value, 
							plan_apellidos[pos].value,
							plan_cargos[pos].value,
							plan_telefonos[pos].value,
							plan_faxes[pos].value,
							plan_moviles[pos].value,
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
		
	//PLANTILLA_13
	if ('<%=plantilla%>'=='plantilla_13')
		{
		var plan_departamentos = $(".plantilla_13 .departamento_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_13 .email_prueba_tarjeta");  
		
		jQuery.each(plan_departamentos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_13(plan_departamentos[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
			
	//PLANTILLA_14
	if ('<%=plantilla%>'=='plantilla_14')
		{
		var plan_calles = $(".plantilla_14 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_14 .numero_calle_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_14 .email_prueba_tarjeta");  
		
		jQuery.each(plan_calles, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_14(plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
		
		
	//PLANTILLA_15
	if ('<%=plantilla%>'=='plantilla_15')
		{
		var plan_cantidades  = $(".plantilla_15 .cantidad_tarjeta");  
		var plan_numero_agencia = $(".plantilla_15 .numero_agencia_tarjeta");  
		var plan_localidad = $(".plantilla_15 .localidad_tarjeta");  
		var plan_telefonos = $(".plantilla_15 .telefono_tarjeta");  
		var plan_faxes = $(".plantilla_15 .fax_tarjeta");  
		var plan_moviles = $(".plantilla_15 .movil_tarjeta");  
		var plan_emails = $(".plantilla_15 .email_tarjeta");  
		var plan_razones_sociales = $(".plantilla_15 .razon_social_tarjeta");  
		var plan_calles = $(".plantilla_15 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_15 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_15 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_15 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_15 .provincia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_15 .email_prueba_tarjeta");  
		
		jQuery.each(plan_cantidades, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_15(plan_cantidades[pos].value, 
							plan_numero_agencia[pos].value, 
							plan_localidad[pos].value,
							plan_telefonos[pos].value,
							plan_faxes[pos].value,
							plan_moviles[pos].value,
							plan_emails[pos].value,
							plan_razones_sociales[pos].value,
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
		
		
	//PLANTILLA_16
	if ('<%=plantilla%>'=='plantilla_16')
		{
		var plan_calles = $(".plantilla_16 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_16 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_16 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_16 .cp_tarjeta");  
		var plan_telefonos = $(".plantilla_16 .telefono_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_16 .email_prueba_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_16(plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_telefonos[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
		
	//PLANTILLA_17
	if ('<%=plantilla%>'=='plantilla_17')
		{
		var plan_calles = $(".plantilla_17 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_17 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_17 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_17 .cp_tarjeta");  
		var plan_telefonos = $(".plantilla_17 .telefono_tarjeta");  
		var plan_emails_agencias = $(".plantilla_17 .email_agencia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_17 .email_prueba_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_17(plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_telefonos[pos].value,
							plan_emails_agencias[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}
		
	//PLANTILLA_18
	if ('<%=plantilla%>'=='plantilla_18')
		{
		var plan_razon_social = $(".plantilla_18 .razon_social_tarjeta");  
		var plan_telefonos = $(".plantilla_18 .telefono_tarjeta");  
		var plan_calles = $(".plantilla_18 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_18 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_18 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_18 .cp_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_18 .email_prueba_tarjeta");  
		var plan_horario_lu_vi = $(".plantilla_18 .horario_lu_vi_tarjeta");  
		var plan_horario_sabados = $(".plantilla_18 .horario_sabados_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_18(
							plan_razon_social[pos].value,
							plan_telefonos[pos].value,
							plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_emails_pruebas[pos].value,
							plan_horario_lu_vi[pos].value,
							plan_horario_sabados[pos].value
							));  
			}
		});  
		}
			
	//console.log('llegando a la plantilla 19')
	//PLANTILLA_19
	if ('<%=plantilla%>'=='plantilla_19')
		{
		var plan_razon_social = $(".plantilla_19 .razon_social_tarjeta");  
		var plan_cifs = $(".plantilla_19 .cif_tarjeta");  
		var plan_calles = $(".plantilla_19 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_19 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_19 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_19 .cp_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_19 .email_prueba_tarjeta");  
		
		jQuery.each(plan_razon_social, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_19(
							plan_razon_social[pos].value,
							plan_cifs[pos].value,
							plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_emails_pruebas[pos].value
							));  
			}
		});  
		}

	//PLANTILLA_20
	if ('<%=plantilla%>'=='plantilla_20')
		{
		var plan_nombre_grupo = $(".plantilla_20 .nombre_grupo_tarjeta");  
		var plan_expediente = $(".plantilla_20 .expediente_tarjeta");  
		var plan_total_venta_expediente = $(".plantilla_20 .total_venta_expediente_tarjeta");  
		var plan_total_coste_expediente = $(".plantilla_20 .total_coste_expediente_tarjeta");  
		var plan_beneficio = $(".plantilla_20 .beneficio_tarjeta");  
		
		jQuery.each(plan_nombre_grupo, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_20(
							plan_nombre_grupo[pos].value,
							plan_expediente[pos].value,
							plan_total_venta_expediente[pos].value,
							plan_total_coste_expediente[pos].value,
							plan_beneficio[pos].value
							));  
			}
		});  
		}
			
	//PLANTILLA_21
	if ('<%=plantilla%>'=='plantilla_21')
		{
		var plan_expediente = $(".plantilla_21 .expediente");  
		
		jQuery.each(plan_expediente, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_21(
							plan_expediente[pos].value
							));  
			}
		});  
		}

		
		
	//PLANTILLA_22
	if ('<%=plantilla%>'=='plantilla_22')
		{
		var plan_telefonos = $(".plantilla_22 .telefono_tarjeta");  
		var plan_emails = $(".plantilla_22 .email_tarjeta");  
		var plan_calles = $(".plantilla_22 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_22 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_22 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_22 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_22 .provincia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_22 .email_prueba_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_22(
							plan_telefonos[pos].value,
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
		
	
	
	//PLANTILLA_23
	if ('<%=plantilla%>'=='plantilla_23')
		{
		var plan_calles = $(".plantilla_23 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_23 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_23 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_23 .cp_tarjeta");  
		var plan_telefonos = $(".plantilla_23 .telefono_tarjeta");  
		var plan_emails_agencias = $(".plantilla_23 .email_agencia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_23 .email_prueba_tarjeta");  
		var plan_precio_envio_internacional = $(".plantilla_23 .precio_envio_internacional_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_23(plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_telefonos[pos].value,
							plan_emails_agencias[pos].value,
							plan_emails_pruebas[pos].value,
							plan_precio_envio_internacional[pos].value
							));  
			}
		});  
		}
	
	//PLANTILLA_24
	if ('<%=plantilla%>'=='plantilla_24')
		{
		var plan_calles = $(".plantilla_24 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_24 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_24 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_24 .cp_tarjeta");  
		var plan_telefonos = $(".plantilla_24 .telefono_tarjeta");  
		var plan_emails_agencias = $(".plantilla_24 .email_agencia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_24 .email_prueba_tarjeta");  
		var plan_precio_envio_nacional = $(".plantilla_24 .precio_envio_nacional_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_24(plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_telefonos[pos].value,
							plan_emails_agencias[pos].value,
							plan_emails_pruebas[pos].value,
							plan_precio_envio_nacional[pos].value
							));  
			}
		});  
		}
		
	//PLANTILLA_25
	if ('<%=plantilla%>'=='plantilla_25')
		{
		var plan_calles = $(".plantilla_25 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_25 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_25 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_25 .cp_tarjeta");  
		var plan_telefonos = $(".plantilla_25 .telefono_tarjeta");  
		var plan_emails_agencias = $(".plantilla_25 .email_agencia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_25 .email_prueba_tarjeta");  
		var plan_precio_envio_nacional = $(".plantilla_25 .precio_envio_nacional_tarjeta");  
		var plan_precio_envio_internacional = $(".plantilla_25 .precio_envio_internacional_tarjeta");  
		
		jQuery.each(plan_telefonos, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_25(plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_telefonos[pos].value,
							plan_emails_agencias[pos].value,
							plan_emails_pruebas[pos].value,
							plan_precio_envio_nacional[pos].value,
							plan_precio_envio_internacional[pos].value
							));  
			}
		});  
		}
	
	
	
	//PLANTILLA_26
	if ('<%=plantilla%>'=='plantilla_26')
		{
		var plan_razon_social = $(".plantilla_26 .razon_social_tarjeta");  
		var plan_cifs = $(".plantilla_26 .cif_tarjeta");  
		var plan_calles = $(".plantilla_26 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_26 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_26 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_26 .cp_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_26 .email_prueba_tarjeta");  
		var plan_numero_conductor = $(".plantilla_26 .numero_conductor");  
		
		jQuery.each(plan_razon_social, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_26(
							plan_razon_social[pos].value,
							plan_cifs[pos].value,
							plan_calles[pos].value,
							plan_numeros_calles[pos].value,
							plan_poblaciones[pos].value,
							plan_cps[pos].value,
							plan_emails_pruebas[pos].value,
							plan_numero_conductor[pos].value
							));  
			}
		});  
		}

	
	//PLANTILLA_27
	if ('<%=plantilla%>'=='plantilla_27')
		{
		var plan_razon_social = $(".plantilla_27 .razon_social_tarjeta");  
		var plan_calles = $(".plantilla_27 .calle_tarjeta");  
		var plan_numeros_calles = $(".plantilla_27 .numero_calle_tarjeta");  
		var plan_poblaciones = $(".plantilla_27 .poblacion_tarjeta");  
		var plan_cps = $(".plantilla_27 .cp_tarjeta");  
		var plan_provincias = $(".plantilla_27 .provincia_tarjeta");  
		var plan_emails_pruebas = $(".plantilla_27 .email_prueba_tarjeta");  
		
		jQuery.each(plan_razon_social, function(pos, item){  
			if (pos>0)
			{
			pedidoObj.addPlantilla(new Plantilla_27(
							plan_razon_social[pos].value,
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
	
	//console.log('entramos en cargar datos')
	$("#contenedor_plantillas .<%=plantilla%>:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');

	//console.log('despues de clonar la plantilla')
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
				//$.getJSON(ruta_fichero_json, function(plantillas) {}).fail(function(error){console.log(error);});
				$.getJSON(ruta_fichero_json, function(plantillas) {

						//console.log('datataaa.plantillas.nombre: ' + plantillas.plantillas[0].nombre)
							
							
						var indice_plantillas=1
						for (x in plantillas.plantillas)
							{
							//--console.log('El elemento con el contiene '+ plantillas.plantillas[x].cantidad_tarjetas);
							//la primera plantilla no necesita clonarla, ya esta creada.... el resto ya si
							if ('<%=plantilla%>'=='plantilla_1')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_1:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
									$("#contenedor_plantillas .plantilla_2:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_2 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_2 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
				
				
							if ('<%=plantilla%>'=='plantilla_3')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_3:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
									$("#contenedor_plantillas .plantilla_4:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
									$("#contenedor_plantillas .plantilla_5:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
									$("#contenedor_plantillas .plantilla_6:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
									$("#contenedor_plantillas .plantilla_7:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
				
							
							if ('<%=plantilla%>'=='plantilla_8')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_8:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_8 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_8 .fax_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fax)
								$('.plantilla_8 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
								$('.plantilla_8 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_8 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_8 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_8 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_8 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
								$('.plantilla_8 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								$('.plantilla_8 .horario_lu_vi_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].horario_lu_vi)
								$('.plantilla_8 .horario_sabados_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].horario_sabados)
								}
				
				
							if ('<%=plantilla%>'=='plantilla_9')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_9:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_9 .fecha_desde_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fecha_desde)
								$('.plantilla_9 .fecha_hasta_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fecha_hasta)
								$('.plantilla_9 .porcentaje_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].porcentaje)
								$('.plantilla_9 .servicios_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].servicios)
								$('.plantilla_9 .observaciones_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].observaciones)
								$('.plantilla_9 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_9 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_9 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].ciudad)
								$('.plantilla_9 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_9 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_9 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								
								}
				
						
							if ('<%=plantilla%>'=='plantilla_10')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_10:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_10 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_10 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_10 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_10 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_10 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_10 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
								$('.plantilla_10 .pais_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].pais)
								$('.plantilla_10 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
				
							//la primera plantilla no necesita clonarla, ya esta creada.... el resto ya si
							if ('<%=plantilla%>'=='plantilla_11')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_11:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_11 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
								
								$('.plantilla_11 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
								$('.plantilla_11 .nombre_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].nombre)
								$('.plantilla_11 .apellidos_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].apellidos)
								$('.plantilla_11 .cargo_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cargo)
								$('.plantilla_11 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_11 .fax_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fax)
								$('.plantilla_11 .movil_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].movil)
								$('.plantilla_11 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
								$('.plantilla_11 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
								$('.plantilla_11 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_11 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_11 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_11 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_11 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
								$('.plantilla_11 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
				
				
							//la primera plantilla no necesita clonarla, ya esta creada.... el resto ya si
							if ('<%=plantilla%>'=='plantilla_12')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_12:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_12 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
								
								$('.plantilla_12 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
								$('.plantilla_12 .nombre_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].nombre)
								$('.plantilla_12 .apellidos_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].apellidos)
								$('.plantilla_12 .cargo_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cargo)
								$('.plantilla_12 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_12 .fax_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fax)
								$('.plantilla_12 .movil_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].movil)
								$('.plantilla_12 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
								$('.plantilla_12 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_12 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_12 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_12 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_12 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
								$('.plantilla_12 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
				
							if ('<%=plantilla%>'=='plantilla_13')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_13:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_13 .departamento_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].departamento)
								$('.plantilla_13 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
				
				
							if ('<%=plantilla%>'=='plantilla_14')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_14:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_14 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_14 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_14 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
				
							//la primera plantilla no necesita clonarla, ya esta creada.... el resto ya si
							if ('<%=plantilla%>'=='plantilla_15')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_15:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_15 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
								
								$('.plantilla_15 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
								$('.plantilla_15 .numero_agencia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_agencia)
								$('.plantilla_15 .localidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].localidad)
								$('.plantilla_15 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_15 .fax_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fax)
								$('.plantilla_15 .movil_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].movil)
								$('.plantilla_15 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
								$('.plantilla_15 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
								$('.plantilla_15 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_15 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_15 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_15 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_15 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
								$('.plantilla_15 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
				
							if ('<%=plantilla%>'=='plantilla_16')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_16:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_16 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_16 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_16 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_16 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_16 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_16 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
				
							if ('<%=plantilla%>'=='plantilla_17')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_17:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_17 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_17 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_17 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_17 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_17 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_17 .email_agencia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_agencia)
								$('.plantilla_17 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
				
							if ('<%=plantilla%>'=='plantilla_18')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_18:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_18 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
								$('.plantilla_18 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_18 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_18 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_18 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_18 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_18 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								$('.plantilla_18 .horario_lu_vi_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].horario_lu_vi)
								$('.plantilla_18 .horario_sabados_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].horario_sabados)
								}
				
				
							if ('<%=plantilla%>'=='plantilla_19')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_19:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_19 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
								$('.plantilla_19 .cif_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cif)
								$('.plantilla_19 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_19 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_19 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_19 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_19 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
							
							if ('<%=plantilla%>'=='plantilla_20')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_20:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_20 .nombre_grupo_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].nombre_grupo)
								$('.plantilla_20 .expediente_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].expediente)
								$('.plantilla_20 .total_venta_expediente_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].total_venta_expediente)
								$('.plantilla_20 .total_coste_expediente_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].total_coste_expediente)
								$('.plantilla_20 .beneficio_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].beneficio)
								}
							
							if ('<%=plantilla%>'=='plantilla_21')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_21:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}

								$('.plantilla_21 .expediente:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].expediente)
								}
				
				
							if ('<%=plantilla%>'=='plantilla_22')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_22:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_22 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_22 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
								$('.plantilla_22 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_22 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_22 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_22 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_22 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
								$('.plantilla_22 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
				
							
							if ('<%=plantilla%>'=='plantilla_23')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_23:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_23 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_23 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_23 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_23 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_23 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_23 .email_agencia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_agencia)
								$('.plantilla_23 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								$('.plantilla_23 .precio_envio_internacional_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].precio_envio_internacional)
								}
				
				
							if ('<%=plantilla%>'=='plantilla_24')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_24:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_24 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_24 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_24 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_24 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_24 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_24 .email_agencia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_agencia)
								$('.plantilla_24 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								$('.plantilla_24 .precio_envio_nacional_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].precio_envio_nacional)
								}
				
							if ('<%=plantilla%>'=='plantilla_25')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_25:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_25 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_25 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_25 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_25 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_25 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_25 .email_agencia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_agencia)
								$('.plantilla_25 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								$('.plantilla_25 .precio_envio_nacional_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].precio_envio_nacional)
								$('.plantilla_25 .precio_envio_internacional_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].precio_envio_internacional)
								}
							
							
							if ('<%=plantilla%>'=='plantilla_26')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_26:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_26 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
								$('.plantilla_26 .cif_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cif)
								$('.plantilla_26 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_26 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_26 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_26 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_26 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								$('.plantilla_26 .numero_conductor:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_conductor)
								}
							//$('.nombre_tarjeta')[indice].val(plantillas.plantillas[x].nombre)
							//('.apellidos_tarjeta')[indice].val(plantillas.plantillas[x].apellidos)
							
							if ('<%=plantilla%>'=='plantilla_27')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_27:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_27 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
								$('.plantilla_27 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_27 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_27 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_27 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_27 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
								$('.plantilla_27 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
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
			for (x in plantillas.plantillas)
				{
				//--console.log('El elemento con el contiene '+ plantillas.plantillas[x].cantidad_tarjetas);
				//la primera plantilla no necesita clonarla, ya esta creada.... el resto ya si
				if ('<%=plantilla%>'=='plantilla_1')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_1:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
						$("#contenedor_plantillas .plantilla_2:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_2 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_2 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
	
				if ('<%=plantilla%>'=='plantilla_3')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_3:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
						$("#contenedor_plantillas .plantilla_4:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
						$("#contenedor_plantillas .plantilla_5:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
						$("#contenedor_plantillas .plantilla_6:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
						$("#contenedor_plantillas .plantilla_7:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
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
	
	
				if ('<%=plantilla%>'=='plantilla_8')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_8:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_8 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_8 .fax_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fax)
					$('.plantilla_8 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
					$('.plantilla_8 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_8 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_8 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_8 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_8 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_8 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					$('.plantilla_8 .horario_lu_vi_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].horario_lu_vi)
					$('.plantilla_8 .horario_sabados_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].horario_sabados)
					}
	
				if ('<%=plantilla%>'=='plantilla_9')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_9:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_9 .fecha_desde_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fecha_desde)
					$('.plantilla_9 .fecha_hasta_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fecha_hasta)
					$('.plantilla_9 .porcentaje_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].porcentaje)
					$('.plantilla_9 .servicios_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].servicios)
					$('.plantilla_9 .observaciones_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].observaciones)
					$('.plantilla_9 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_9 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_9 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].ciudad)
					$('.plantilla_9 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_9 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_9 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					
					}
	
	
				if ('<%=plantilla%>'=='plantilla_10')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_10:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_10 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_10 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_10 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_10 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_10 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_10 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_10 .pais_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].pais)
					$('.plantilla_10 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
				//la primera plantilla no necesita clonarla, ya esta creada.... el resto ya si
				if ('<%=plantilla%>'=='plantilla_11')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_11:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_11 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
					
					$('.plantilla_11 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
					$('.plantilla_11 .nombre_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].nombre)
					$('.plantilla_11 .apellidos_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].apellidos)
					$('.plantilla_11 .cargo_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cargo)
					$('.plantilla_11 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_11 .fax_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fax)
					$('.plantilla_11 .movil_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].movil)
					$('.plantilla_11 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
					$('.plantilla_11 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
					$('.plantilla_11 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_11 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_11 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_11 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_11 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_11 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
				//la primera plantilla no necesita clonarla, ya esta creada.... el resto ya si
				if ('<%=plantilla%>'=='plantilla_12')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_12:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_12 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
					
					$('.plantilla_12 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
					$('.plantilla_12 .nombre_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].nombre)
					$('.plantilla_12 .apellidos_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].apellidos)
					$('.plantilla_12 .cargo_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cargo)
					$('.plantilla_12 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_12 .fax_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fax)
					$('.plantilla_12 .movil_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].movil)
					$('.plantilla_12 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
					$('.plantilla_12 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_12 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_12 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_12 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_12 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_12 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
				if ('<%=plantilla%>'=='plantilla_13')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_13:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_13 .departamento_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].departamento)
					$('.plantilla_13 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
				if ('<%=plantilla%>'=='plantilla_14')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_14:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_14 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_14 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_14 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
				//la primera plantilla no necesita clonarla, ya esta creada.... el resto ya si
				if ('<%=plantilla%>'=='plantilla_15')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_15:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_15 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
					
					$('.plantilla_15 .cantidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cantidad_tarjetas)
					$('.plantilla_15 .numero_agencia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_agencia)
					$('.plantilla_15 .localidad_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].localidad)
					$('.plantilla_15 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_15 .fax_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].fax)
					$('.plantilla_15 .movil_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].movil)
					$('.plantilla_15 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
					$('.plantilla_15 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
					$('.plantilla_15 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_15 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_15 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_15 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_15 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_15 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
				if ('<%=plantilla%>'=='plantilla_16')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_16:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_16 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_16 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_16 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_16 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_16 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_16 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
	
				if ('<%=plantilla%>'=='plantilla_17')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_17:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_17 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_17 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_17 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_17 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_17 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_17 .email_agencia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_agencia)
					$('.plantilla_17 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
				
				if ('<%=plantilla%>'=='plantilla_18')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_18:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_18 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
					$('.plantilla_18 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_18 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_18 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_18 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_18 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_18 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					$('.plantilla_18 .horario_lu_vi_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].horario_lu_vi)
					$('.plantilla_18 .horario_sabados_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].horario_sabados)
					}
	
				if ('<%=plantilla%>'=='plantilla_19')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_19:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_19 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
					$('.plantilla_19 .cif_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cif)
					$('.plantilla_19 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_19 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_19 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_19 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_19 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					}
					
				if ('<%=plantilla%>'=='plantilla_20')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_20:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_20 .nombre_grupo_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].nombre_grupo)
								$('.plantilla_20 .expediente_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].expediente)
								$('.plantilla_20 .total_venta_expediente_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].total_venta_expediente)
								$('.plantilla_20 .total_coste_expediente_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].total_coste_expediente)
								$('.plantilla_20 .beneficio_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].beneficio)
								}

				if ('<%=plantilla%>'=='plantilla_21')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_21:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}

								$('.plantilla_21 .expediente:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].expediente)
								}
								
								
				if ('<%=plantilla%>'=='plantilla_22')
								{
								if (indice_plantillas!=1)
									{
									$("#contenedor_plantillas .plantilla_22:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
									}
								
								$('.plantilla_22 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
								$('.plantilla_22 .email_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email)
								$('.plantilla_22 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
								$('.plantilla_22 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
								$('.plantilla_22 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
								$('.plantilla_22 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
								$('.plantilla_22 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
								$('.plantilla_22 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
								}
				
				if ('<%=plantilla%>'=='plantilla_23')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_23:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_23 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_23 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_23 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_23 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_23 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_23 .email_agencia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_agencia)
					$('.plantilla_23 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					$('.plantilla_23 .precio_envio_internacional_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].precio_envio_internacional)
					}
												
				if ('<%=plantilla%>'=='plantilla_24')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_24:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_24 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_24 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_24 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_24 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_24 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_24 .email_agencia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_agencia)
					$('.plantilla_24 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					$('.plantilla_24 .precio_envio_nacional_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].precio_envio_nacional)
					}
					
				if ('<%=plantilla%>'=='plantilla_25')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_25:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_25 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_25 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_25 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_25 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_25 .telefono_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].telefono)
					$('.plantilla_25 .email_agencia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_agencia)
					$('.plantilla_25 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					$('.plantilla_25 .precio_envio_nacional_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].precio_envio_nacional)
					$('.plantilla_25 .precio_envio_internacional_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].precio_envio_internacional)
					}
					
					
				if ('<%=plantilla%>'=='plantilla_26')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_26:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_26 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
					$('.plantilla_26 .cif_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cif)
					$('.plantilla_26 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_26 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_26 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_26 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_26 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
					$('.plantilla_26 .numero_conductor:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_conductor)
					}
					
					
				if ('<%=plantilla%>'=='plantilla_27')
					{
					if (indice_plantillas!=1)
						{
						$("#contenedor_plantillas .plantilla_27:first").clone().appendTo("#contenedor_plantillas").hide().fadeIn('slow');
						}
					
					$('.plantilla_27 .razon_social_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].razon_social)
					$('.plantilla_27 .calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].calle)
					$('.plantilla_27 .numero_calle_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].numero_calle)
					$('.plantilla_27 .poblacion_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].poblacion)
					$('.plantilla_27 .cp_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].cp)
					$('.plantilla_27 .provincia_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].provincia)
					$('.plantilla_27 .email_prueba_tarjeta:eq(' + indice_plantillas + ')').val(plantillas.plantillas[x].email_pruebas)
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




</script>

</head>
<body onload="cargar_datos('<%=codigo_cliente%>', '<%=codigo_pedido%>', '<%=anno_pedido%>', '<%=codigo_articulo%>', '<%=modo%>')">

<div class="container-fluid" id="contenedor_plantillas" name="contenedor_plantillas">
			
			
	<div class="plantilla_1" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row form-group form-group-sm">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cantidad%>:</span>
						<input type="text" class="form-control cantidad_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_nombre%>:</span>
						<input type="text" class="form-control nombre_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_apellidos%>:</span>
						<input type="text" class="form-control apellidos_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_cargo%>:
						<input type="text" class="form-control cargo_tarjeta">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_fax%>:
						<input type="text" class="form-control fax_tarjeta">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_movil%>:
						<input type="text" class="form-control movil_tarjeta">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email%>:</span>
						<input type="text" class="form-control email_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
						<%=plantilla_personalizacion_web%>:
						<input type="text" class="form-control pagina_web_tarjeta">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_provincia%>:</span>
						<input type="text" class="form-control provincia_tarjeta requerir">
					</div>
					
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_telefono_2%>:
						<input type="text" class="form-control telefono2_tarjeta">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla1-->	
			
	<div class="plantilla_2" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3"></div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla2-->	
	
	<div class="plantilla_3" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
						<%=plantilla_personalizacion_email%>
						<input type="text" class="form-control email_tarjeta">
					</div>
					
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_provincia%>:</span>
						<input type="text" class="form-control provincia_tarjeta requerir">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla3-->	
			
	<div class="plantilla_4" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_provincia%>:</span>
						<input type="text" class="form-control provincia_tarjeta requerir">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla4-->	
								
	<div class="plantilla_5" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_fax%>:
						<input type="text" class="form-control fax_tarjeta">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
						<%=plantilla_personalizacion_email%>
						<input type="text" class="form-control email_tarjeta">
					</div>
					
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_provincia%>:</span>
						<input type="text" class="form-control provincia_tarjeta requerir">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla5-->	
			
	<div class="plantilla_6" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_horario%>:</span>
						<input type="text" class="form-control horario_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla6-->	
	
	<div class="plantilla_7" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_fax%>:
						<input type="text" class="form-control fax_tarjeta">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
						<%=plantilla_personalizacion_email%>
						<input type="text" class="form-control email_tarjeta">
					</div>
					
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_provincia%>:</span>
						<input type="text" class="form-control provincia_tarjeta requerir">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla7-->	
			
		
	<div class="plantilla_8" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_fax%>:
						<input type="text" class="form-control fax_tarjeta">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
						<%=plantilla_personalizacion_email%>
						<input type="text" class="form-control email_tarjeta">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_provincia%>:</span>
						<input type="text" class="form-control provincia_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_horario_lu_vi%>:</span>
						<input type="text" class="form-control horario_lu_vi_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_horario_sabados%>:</span>
						<input type="text" class="form-control horario_sabados_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla8-->	
			
	<div class="plantilla_9" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_fecha_desde%>:</span>
						<input type="text" class="form-control fecha_desde_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_fecha_hasta%>:</span>
						<input type="text" class="form-control fecha_hasta_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_porcentaje%>:</span>
						<input type="text" class="form-control porcentaje_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_servicios%>:</span>
						<input type="text" class="form-control servicios_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
						<%=plantilla_personalizacion_observaciones%>:
						<input type="text" class="form-control observaciones_tarjeta">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla9-->	
							

	<div class="plantilla_10" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_provincia%>:</span>
						<input type="text" class="form-control provincia_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_pais%>:</span>
						<input type="text" class="form-control pais_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla10-->	
				
		
	<div class="plantilla_11" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row form-group form-group-sm">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cantidad%>:</span>
						<input type="text" class="form-control cantidad_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_nombre%>:</span>
						<input type="text" class="form-control nombre_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_apellidos%>:</span>
						<input type="text" class="form-control apellidos_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cargo%>:</span>
						<input type="text" class="form-control cargo_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_fax%>:
						<input type="text" class="form-control fax_tarjeta">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_movil%>:</span>
						<input type="text" class="form-control movil_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email%>:</span>
						<input type="text" class="form-control email_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_razon_social%>:</span>
						<input type="text" class="form-control razon_social_tarjeta requerir">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
						<%=plantilla_personalizacion_provincia%>:
						<input type="text" class="form-control provincia_tarjeta">
					</div>
					
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla11-->	
	
	<div class="plantilla_12" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row form-group form-group-sm">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cantidad%>:</span>
						<input type="text" class="form-control cantidad_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_nombre%>:</span>
						<input type="text" class="form-control nombre_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_apellidos%>:</span>
						<input type="text" class="form-control apellidos_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cargo%>:</span>
						<input type="text" class="form-control cargo_tarjeta requerir">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_telefono%>:
						<input type="text" class="form-control telefono_tarjeta">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_fax%>:
						<input type="text" class="form-control fax_tarjeta">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_movil%>:</span>
						<input type="text" class="form-control movil_tarjeta requerir">
					</div>
					<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email%>:</span>
						<input type="text" class="form-control email_tarjeta requerir">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
						<%=plantilla_personalizacion_provincia%>:
						<input type="text" class="form-control provincia_tarjeta">
					</div>
					
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla12-->	

	<div class="plantilla_13" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_departamento%>:</span>
						<input type="text" class="form-control departamento_tarjeta requerir">
					</div>
					
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla13-->
	
	<div class="plantilla_14" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla14-->	

	<div class="plantilla_15" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row form-group form-group-sm">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cantidad%>:</span>
						<input type="text" class="form-control cantidad_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero_agencia%>:</span>
						<input type="text" class="form-control numero_agencia_tarjeta requerir">
					</div>
					<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_localidad%>:</span>
						<input type="text" class="form-control localidad_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_telefono%>:
						<input type="text" class="form-control telefono_tarjeta">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<%=plantilla_personalizacion_fax%>:
						<input type="text" class="form-control fax_tarjeta">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_movil%>:</span>
						<input type="text" class="form-control movil_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email%>:</span>
						<input type="text" class="form-control email_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_razon_social%>:</span>
						<input type="text" class="form-control razon_social_tarjeta requerir">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row form-group form-group-sm">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
						<%=plantilla_personalizacion_provincia%>:
						<input type="text" class="form-control provincia_tarjeta">
					</div>
					
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla15-->	
	
	<div class="plantilla_16" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					
					<div class="col-xs-7 col-sm-7 col-md-7 col-lg-7 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla16-->	
							
	<div class="plantilla_17" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email%>:</span>
						<input type="text" class="form-control email_agencia_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla17-->


	<div class="plantilla_18" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_razon_social%>:</span>
						<input type="text" class="form-control razon_social_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Domicilio Social:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Localidad:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
						<%=plantilla_personalizacion_horario_lu_vi%>:
						<input type="text" class="form-control horario_lu_vi_tarjeta">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
						<%=plantilla_personalizacion_horario_sabados%>:
						<input type="text" class="form-control horario_sabados_tarjeta">
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
	</div><!--fin plantilla18-->


	<div class="plantilla_19" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_razon_social%>:</span>
						<input type="text" class="form-control razon_social_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger">CIF:</span>
						<input type="text" class="form-control cif_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
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
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Domicilio Social:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Localidad:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla19-->

	<div class="plantilla_20" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-7 col-sm-7 col-md-7 col-lg-7 has-error">
						<span class="text-danger">Nombre Grupo:</span>
						<input type="text" class="form-control nombre_grupo_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger">Expediente:</span>
						<input type="text" class="form-control expediente_tarjeta requerir">
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
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Total Venta Expediente:</span>
						<input type="text" class="form-control total_venta_expediente_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Total Coste Expediente:</span>
						<input type="text" class="form-control total_coste_expediente_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Beneficio:</span>
						<input type="text" class="form-control beneficio_tarjeta requerir">
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla20-->
	
	<div class="plantilla_21" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger">Expediente:</span>
						<input type="text" class="form-control expediente requerir" id="txtexpediente" name="txtexpediente">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3"></div>
					
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   Eliminar
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla21-->
	
	
	<div class="plantilla_22" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email%></span>
						<input type="text" class="form-control email_tarjeta requerir">
					</div>
					
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger">Agencia de GLS en:</span>
						<input type="text" class="form-control provincia_tarjeta requerir">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla22-->	
	
	<div class="plantilla_23" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email%>:</span>
						<input type="text" class="form-control email_agencia_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger">Precio Desde Envios Internacionales (Sin IVA):</span>
						<input type="text" class="form-control precio_envio_internacional_tarjeta requerir">
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla23-->
	
	<div class="plantilla_24" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email%>:</span>
						<input type="text" class="form-control email_agencia_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger">Precio Desde Envios Nacionales (Sin IVA):</span>
						<input type="text" class="form-control precio_envio_nacional_tarjeta requerir">
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla24-->
	
	<div class="plantilla_25" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_calle%>:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_poblacion%>:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_telefono%>:</span>
						<input type="text" class="form-control telefono_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email%>:</span>
						<input type="text" class="form-control email_agencia_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
						<br />
						<button type="button" class="btn btn-block btn-md eliminar" id="" name="">
						   <%=plantilla_personalizacion_boton_eliminar%>
						</button>
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger">Precio Desde Envios Nacionales (Sin IVA):</span>
						<input type="text" class="form-control precio_envio_nacional_tarjeta requerir">
					</div>
					<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 has-error">
						<span class="text-danger">Precio Desde Envios Internacionales (Sin IVA):</span>
						<input type="text" class="form-control precio_envio_internacional_tarjeta requerir">
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla25-->
	
	<!--fin plantilla 26-->
	<div class="plantilla_26" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_razon_social%>:</span>
						<input type="text" class="form-control razon_social_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger">CIF:</span>
						<input type="text" class="form-control cif_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
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
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Domicilio Social:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Localidad:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Conductor Nº:</span>
						<input type="text" class="form-control numero_conductor requerir">
					</div>
				</div>
			</div>
		</div>
	</div><!--fin plantilla26-->


	<div class="plantilla_27" style="display:none">
		<div class="panel panel-default">
  			<div class="panel-body">
				<div class="row">
					<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_razon_social%>:</span>
						<input type="text" class="form-control razon_social_tarjeta requerir">
					</div>
					<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_email_envio%>:</span>
						<input type="text" class="form-control email_prueba_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Domicilio Social:</span>
						<input type="text" class="form-control calle_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_numero%>:</span>
						<input type="text" class="form-control numero_calle_tarjeta requerir">
					</div>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 has-error">
						<span class="text-danger">Localidad:</span>
						<input type="text" class="form-control poblacion_tarjeta requerir">
					</div>
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_cp%>:</span>
						<input type="text" class="form-control cp_tarjeta requerir">
					</div>
				</div>
				<div class="row">&nbsp;</div>
				<div class="row">
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 has-error">
						<span class="text-danger"><%=plantilla_personalizacion_provincia%>:</span>
						<input type="text" class="form-control provincia_tarjeta requerir">
					</div>
					<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
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
	</div><!--fin plantilla27-->

	
</div>	
<div class="container-fluid" id="botones">
	<div class="row">
		<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1"></div>
		<%if modo<>"CONSULTAR" then%>
			<%if plantilla="plantilla_1" or plantilla="plantilla_11" or plantilla="plantilla_12" or plantilla="plantilla_15" then%>
				<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
					<button type="button" class="btn btn-primary btn-lg" id="agregar" name="agregar">
					   <%=plantilla_personalizacion_boton_agragar%>
					</button>
				</div>
			<%end if%>
			<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1"></div>
			<% if session("usuario")<>249 and session("usuario")<>599 then 'los administradores de halcon y ecuador no pueden modificar la plantilla%>
				<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
					<button type="button" class="btn btn-primary btn-lg" id="guardar_plantillas" name="guardar_plantillas">
					   <%=plantilla_personalizacion_boton_guardar%>
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
			   <%=plantilla_personalizacion_boton_cerrar%>
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