<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include virtual="/includes/Idiomas.asp"-->

<script language="javascript" runat="server" src="../GAG/json2_a.asp"></script>

<script language="JScript" runat="server">
function CheckProperty(obj, propName) {
    return (typeof obj[propName] != "undefined");
}
</script>

<%
	plantilla=Request.QueryString("plant")
	codigo_cliente=Request.QueryString("cli")
	anno_pedido=Request.QueryString("anno")
	codigo_pedido=Request.QueryString("ped")
	codigo_articulo=Request.QueryString("art")
	cantidad_articulo=Request.QueryString("cant")
	modo=Request.QueryString("modo")
	carpeta=Request.QueryString("carpeta")
	
	
	datos_plantilla=Request.Form("ocultodatos_plantilla_maletas")
								
	'response.write("datos devueltos: " + datos_plantilla)	
	
	
	
		valor_oculto_id=""
		valor_oculto_empresa=""
		valor_oculto_id_oficina=""
		valor_oculto_nombre_oficina=""
		valor_oculto_direccion_oficina=""		
		valor_oculto_poblacion_oficina=""
		valor_oculto_cp_oficina=""
		valor_oculto_provincia_oficina=""
		valor_oculto_pais_oficina=""
		valor_numero_empleado=""
		valor_horario_entrega=""
		valor_nif=""
		valor_razon_social=""
		valor_enviar_a=""
		valor_telefono=""
		valor_email=""
		valor_observaciones=""
		valor_domicilio_cliente=""
		valor_poblacion_cliente=""
		valor_cp_cliente=""
		valor_provincia_cliente=""
		valor_pais_cliente=""
		valor_idpais_cliente=""
		valor_domicilio_envio=""
		valor_poblacion_envio=""
		valor_cp_envio=""
		valor_provincia_envio=""
		
		
		'[{"name":"oculto_id","value":""},{"name":"oculto_id_oficina","value":"6214"},{"name":"oculto_nombre_oficina","value":"001-SALAMANCA - CANALEJAS"},
		'{"name":"oculto_poblacion_oficina","value":"SALAMANCA"},{"name":"oculto_cp_oficina","value":"37001"},{"name":"oculto_provincia_oficina","value":"SALAMANCA"},
		'{"name":"oculto_pais_oficina","value":"ESPAÑA"},{"name":"txtnumero_empleado_d","value":"19316"},{"name":"txthorario_entrega_d","value":"asdf"},
		'{"name":"txtnif_d","value":"07973028D"},{"name":"txtrazon_social_d","value":"manuel alba gallego"},{"name":"radio","value":"CLIENTE"},{"name":"txttelefono_d","value":"923w"},
		'{"name":"txtemail_d","value":"m"},{"name":"txtobservaciones_d","value":"sadfasd"},{"name":"txtdomicilio_d","value":"asdf"},{"name":"txtpoblacion_d","value":"asdf"},
		'{"name":"txtcp_d","value":"asdf"},{"name":"txtprovincia_d","value":"asdf"},{"name":"txtpais_d","value":"asdf"},{"name":"txtdomicilio_envio_d","value":""},
		'{"name":"txtpoblacion_envio_d","value":""},{"name":"txtcp_envio_d","value":""},{"name":"txtprovincia_envio_d","value":""}]
		
		
		valor_oculto_id=Request.Form("oculto_id")
		valor_oculto_empresa=Request.Form("oculto_empresa")
		valor_oculto_id_oficina=Request.Form("oculto_id_oficina")
		valor_oculto_nombre_oficina=Request.Form("oculto_nombre_oficina")
		valor_oculto_direccion_oficina=Request.Form("oculto_direccion_oficina")
		valor_oculto_poblacion_oficina=Request.Form("oculto_poblacion_oficina")
		valor_oculto_cp_oficina=Request.Form("oculto_cp_oficina")
		valor_oculto_provincia_oficina=Request.Form("oculto_provincia_oficina")
		valor_oculto_pais_oficina=Request.Form("oculto_pais_oficina")
		valor_numero_empleado=Request.Form("oculto_numero_empleado_d")
		valor_horario_entrega=Request.Form("oculto_horario_entrega_d")
		valor_nif=Request.Form("oculto_nif_d")
		valor_razon_social=Request.Form("oculto_razon_social_d")
		valor_enviar_a=Request.Form("oculto_radio_d")
		valor_telefono=Request.Form("oculto_telefono_d")
		valor_email=Request.Form("oculto_email_d")
		valor_observaciones=Request.Form("oculto_observaciones_d")
		valor_domicilio_cliente=Request.Form("oculto_domicilio_d")
		valor_poblacion_cliente=Request.Form("oculto_poblacion_d")
		valor_cp_cliente=Request.Form("oculto_cp_d")
		valor_provincia_cliente=Request.Form("oculto_provincia_d")
		valor_pais_cliente=Request.Form("oculto_pais_d")
		valor_idpais_cliente=Request.Form("oculto_idpais_d")
		valor_domicilio_envio=Request.Form("oculto_domicilio_envio_d")
		valor_poblacion_envio=Request.Form("oculto_poblacion_envio_d")
		valor_cp_envio=Request.Form("oculto_cp_envio_d")
		valor_provincia_envio=Request.Form("oculto_provincia_envio_d")
		
				
		'response.write("<br>valor_oculto_id: " & valor_oculto_id)	
		'response.write("<br>valor_oculto_empresa: " & valor_oculto_empresa)	
		'response.write("<br>valor_oculto_id_oficina: " & valor_oculto_id_oficina)	
		'response.write("<br>valor_oculto_nombre_oficina: " & valor_oculto_nombre_oficina)	
		'response.write("<br>valor_oculto_direccion_oficina: " & valor_oculto_direccion_oficina)	
		'response.write("<br>valor_oculto_poblacion_oficina: " & valor_oculto_poblacion_oficina)	
		'response.write("<br>valor_oculto_cp_oficina: " & valor_oculto_cp_oficina)	
		'response.write("<br>valor_oculto_provincia_oficina: " & valor_oculto_provincia_oficina)	
		'response.write("<br>valor_oculto_pais_oficina: " & valor_oculto_pais_oficina)	
		'response.write("<br>valor_numero_empleado: " & valor_numero_empleado)	
		'response.write("<br>valor_horario_entrega: " & valor_horario_entrega)	
		'response.write("<br>valor_nif: " & valor_nif)	
		'response.write("<br>valor_razon_social: " & valor_razon_social)	
		'response.write("<br>valor_enviar_a: " & valor_enviar_a)	
		'response.write("<br>valor_telefono: " & valor_telefono)	
		'response.write("<br>valor_email: " & valor_email)	
		'response.write("<br>valor_observaciones: " & valor_observaciones)	
		'response.write("<br>valor_domicilio_cliente: " & valor_domicilio_cliente)	
		'response.write("<br>valor_poblacion_cliente: " & valor_poblacion_cliente)	
		'response.write("<br>valor_cp_cliente: " & valor_cp_cliente)	
		'response.write("<br>valor_provincia_cliente: " & valor_provincia_cliente)	
		'response.write("<br>valor_pais_cliente: " & valor_pais_cliente)	
		'response.write("<br>valor_domicilio_envio: " & valor_domicilio_envio)	
		'response.write("<br>valor_poblacion_envio: " & valor_poblacion_envio)	
		'response.write("<br>valor_cp_envio: " & valor_cp_envio)	
		'response.write("<br>valor_provincia_envio: " & valor_provincia_envio)	
		

	
	'*************
	'response.write("<br>PLANITLLA: " & plantilla & " cliente: " & codigo_cliente & " año pedido: " & anno_pedido & " pedido: " & codigo_pedido & " articulo: " & codigo_articulo & " cantidad: " & cantidad_articulo)
	'response.write("variable sesion session('json_" & codigo_articulo & "'): " & texto_json)
	
	'para que se vean bien los acentos guardados en el fichero json
	'Response.ContentType="text/html; charset=iso-8859-1"
%>
<html>

<head>

<title>Peticion Maletas</title>

<!--
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
-->
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-4.0.0/css/bootstrap.min.css">
<link rel="stylesheet" href="../plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min.css">
<script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>


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
.vertical-align {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: row;
}
</style>


<style>
/*
style para los optionbuttons
*/
.funkyradio div {
  clear: both;
  overflow: hidden;
}

.funkyradio label {
  width: 100%;
  border-radius: 3px;
  border: 1px solid #D1D3D4;
  font-weight: normal;
}

.funkyradio input[type="radio"]:empty,
.funkyradio input[type="checkbox"]:empty {
  display: none;
}

.funkyradio input[type="radio"]:empty ~ label,
.funkyradio input[type="checkbox"]:empty ~ label {
  position: relative;
  line-height: 2.5em;
  text-indent: 3.25em;
  margin-top: 2em;
  cursor: pointer;
  -webkit-user-select: none;
     -moz-user-select: none;
      -ms-user-select: none;
          user-select: none;
}

.funkyradio input[type="radio"]:empty ~ label:before,
.funkyradio input[type="checkbox"]:empty ~ label:before {
  position: absolute;
  display: block;
  top: 0;
  bottom: 0;
  left: 0;
  content: '';
  width: 2.5em;
  /*background: #D1D3D4;*/
  background: #f0ad4e;
  border-radius: 3px 0 0 3px;
}

.funkyradio input[type="radio"]:hover:not(:checked) ~ label,
.funkyradio input[type="checkbox"]:hover:not(:checked) ~ label {
  color: #888;
}

.funkyradio input[type="radio"]:hover:not(:checked) ~ label:before,
.funkyradio input[type="checkbox"]:hover:not(:checked) ~ label:before {
  content: '\2714';
  text-indent: .9em;
  color: #C2C2C2;
}

.funkyradio input[type="radio"]:checked ~ label,
.funkyradio input[type="checkbox"]:checked ~ label {
  color: #777;
}

.funkyradio input[type="radio"]:checked ~ label:before,
.funkyradio input[type="checkbox"]:checked ~ label:before {
  content: '\2714';
  text-indent: .9em;
  color: #333;
  background-color: #ccc;
}

.funkyradio input[type="radio"]:focus ~ label:before,
.funkyradio input[type="checkbox"]:focus ~ label:before {
  box-shadow: 0 0 0 3px #999;
}

.funkyradio-default input[type="radio"]:checked ~ label:before,
.funkyradio-default input[type="checkbox"]:checked ~ label:before {
  color: #333;
  background-color: #ccc;
}

.funkyradio-primary input[type="radio"]:checked ~ label:before,
.funkyradio-primary input[type="checkbox"]:checked ~ label:before {
  color: #fff;
  background-color: #337ab7;
}

.funkyradio-success input[type="radio"]:checked ~ label:before,
.funkyradio-success input[type="checkbox"]:checked ~ label:before {
  color: #fff;
  background-color: #5cb85c;
}

.funkyradio-danger input[type="radio"]:checked ~ label:before,
.funkyradio-danger input[type="checkbox"]:checked ~ label:before {
  color: #fff;
  background-color: #d9534f;
}

.funkyradio-warning input[type="radio"]:checked ~ label:before,
.funkyradio-warning input[type="checkbox"]:checked ~ label:before {
  color: #fff;
  background-color: #f0ad4e;
}

.funkyradio-info input[type="radio"]:checked ~ label:before,
.funkyradio-info input[type="checkbox"]:checked ~ label:before {
  color: #fff;
  background-color: #5bc0de;
}


</style>

<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>




<!--
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
-->
<script type="text/javascript">

    

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
<body>




<!--
ejemplos de Option buttons y checks


<div class="col-md-6">
     <h4>Radio Buttons</h4>

    <div class="funkyradio">
        <div class="funkyradio-primary">
            <input type="radio" name="radio" id="radio2"/>
            <label for="radio2">Second Option primary</label>
        </div>
	</div>
</div>
		
		
<div class="col-md-4">
<div class="col-md-6">
     <h4>Radio Buttons</h4>

    <div class="funkyradio">
        <div class="funkyradio-default">
            <input type="radio" name="radio" id="radio1" />
            <label for="radio1">First Option default</label>
        </div>
        <div class="funkyradio-primary">
            <input type="radio" name="radio" id="radio2" checked/>
            <label for="radio2">Second Option primary</label>
        </div>
        <div class="funkyradio-success">
            <input type="radio" name="radio" id="radio3" />
            <label for="radio3">Third Option success</label>
        </div>
        <div class="funkyradio-danger">
            <input type="radio" name="radio" id="radio4" />
            <label for="radio4">Fourth Option danger</label>
        </div>
        <div class="funkyradio-warning">
            <input type="radio" name="radio" id="radio5" />
            <label for="radio5">Fifth Option warning</label>
        </div>
        <div class="funkyradio-info">
            <input type="radio" name="radio" id="radio6" />
            <label for="radio6">Sixth Option info</label>
        </div>
    </div>
</div>
<div class="col-md-6">
     <h4>Checkbox Buttons</h4>

    <div class="funkyradio">
        <div class="funkyradio-default">
            <input type="checkbox" name="checkbox" id="checkbox1" checked/>
            <label for="checkbox1">First Option default</label>
        </div>
        <div class="funkyradio-primary">
            <input type="checkbox" name="checkbox" id="checkbox2" checked/>
            <label for="checkbox2">Second Option primary</label>
        </div>
        <div class="funkyradio-success">
            <input type="checkbox" name="checkbox" id="checkbox3" checked/>
            <label for="checkbox3">Third Option success</label>
        </div>
        <div class="funkyradio-danger">
            <input type="checkbox" name="checkbox" id="checkbox4" checked/>
            <label for="checkbox4">Fourth Option danger</label>
        </div>
        <div class="funkyradio-warning">
            <input type="checkbox" name="checkbox" id="checkbox5" checked/>
            <label for="checkbox5">Fifth Option warning</label>
        </div>
        <div class="funkyradio-info">
            <input type="checkbox" name="checkbox" id="checkbox6" checked/>
            <label for="checkbox6">Sixth Option info</label>
        </div>
    </div>
</div>
</div>
-->

<div class="container-fluid" id="contenedor_plantillas">
	<form method="post" name="frmdatos" id="frmdatos" action="">
		<input type="hidden"  id="oculto_id" name="oculto_id" value="" />	
		<input type="hidden"  id="oculto_empresa" name="oculto_empresa" value="" />	
		<input type="hidden"  id="oculto_id_oficina" name="oculto_id_oficina" value="<%=session("usuario")%>" />
		<input type="hidden"  id="oculto_nombre_oficina" name="oculto_nombre_oficina" value="<%=session("usuario_nombre")%>" />
		<input type="hidden"  id="oculto_direccion_oficina" name="oculto_direccion_oficina" value="<%=session("usuario_direccion")%>" />
		<input type="hidden"  id="oculto_poblacion_oficina" name="oculto_poblacion_oficina" value="<%=session("usuario_poblacion")%>" />	
		<input type="hidden"  id="oculto_cp_oficina" name="oculto_cp_oficina" value="<%=session("usuario_cp")%>" />	
		<input type="hidden"  id="oculto_provincia_oficina" name="oculto_provincia_oficina" value="<%=session("usuario_provincia")%>" />	
		<input type="hidden"  id="oculto_pais_oficina" name="oculto_pais_oficina" value="<%=session("usuario_pais")%>" />
		
		<input type="hidden"  id="oculto_nif" name="oculto_nif" value="<%=valor_nif%>" />	
		<input type="hidden"  id="oculto_cambiado_nif_en_click" name="oculto_cambiado_nif_en_click" value="NO" />	
		
		
							
							
							
							
		<div class="card">
			<div class="card-header">Datos de La Oficina</div>	
			<div class="card-body">
				<div class="col-sm-12 col-md-12 col-lg-12">
					<div class="form-group row">
						<div class="col-sm-2 col-md-2 col-lg-2 no_franquicia">
							<label for="txtnumero_empleado_d" class="control-label">N&uacute;mero Empleado</label>
							<input type="text" class="form-control texto" style="width: 100%;"  id="txtnumero_empleado_d" name="txtnumero_empleado_d" value="" />
						</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="txthorario_entrega_d" class="control-label">Horario Entrega</label>
							<input type="text" class="form-control texto" style="width: 100%;"  id="txthorario_entrega_d" name="txthorario_entrega_d" value="" />
						</div>

				  	</div>
					
					<div class="form-group row">
						<div class="col-sm-12 col-md-12 col-lg-12">
							<div class="card">
								<div class="card-header">Dirección de La Oficina</div>	
								<div class="card-body">
									<div class="col-sm-12 col-md-12 col-lg-12">
										<div class="form-group row vertical-align">
											<div class="col-sm-9 col-md-9 col-lg-9">
												<label for="txtnombre_oficina_d" class="control-label">Oficina</label>
												<input type="text" class="form-control texto" style="width: 100%;"  id="txtnombre_oficina_d" name="txtnombre_oficina_d" value="<%=session("usuario_nombre")%>" readonly />
											</div>
											<div class="col-sm-3 col-md-3 col-lg-3">
												<div class="funkyradio">
													<div class="funkyradio-primary">
														<input type="radio" name="radio" id="radio1" value="OFICINA"/>
														<label for="radio1" class="small">Enviar a La Direccion de La Oficina</label>
													</div>
												</div>
												<div class="text-center">(no tiene gastos de env&iacute;o)</div>
											</div>
										</div>
										<div class="form-group row">
											<div class="col-sm-12 col-md-12 col-lg-12">
												<label for="txtdireccion_oficina_d" class="control-label">Direcci&oacute;n</label>
												<input type="text" class="form-control texto" style="width: 100%;"  id="txtdireccion_oficina_d" name="txtdireccion_oficina_d" value="<%=session("usuario_direccion")%>" readonly />
											</div>
										</div>
										<div class="form-group row">
											<div class="col-sm-5 col-md-5 col-lg-5">
												<label for="txtpoblacion_oficina_d" class="control-label">Poblaci&oacute;n</label>
												<input type="text" class="form-control texto" style="width: 100%;"  id="txtpoblacion_oficina_d" name="txtpoblacion_oficina_d" value="<%=session("usuario_poblacion")%>" readonly/>
											</div>
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="txtcp_oficina_d" class="control-label">C.P.</label>
												<input type="text" class="form-control texto" style="width: 100%;"  id="txtcp_oficina_d" name="txtcp_oficina_d" value="<%=session("usuario_cp")%>" readonly/>
											</div>
											<div class="col-sm-3 col-md-3 col-lg-3">
												<label for="txtprovincia_oficina_d" class="control-label">Provincia</label>
												<input type="text" class="form-control texto" style="width: 100%;"  id="txtprovincia_oficina_d" name="txtprovincia_oficina_d" value="<%=session("usuario_provincia")%>" readonly/>
											</div>
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="txtpais_oficina_d" class="control-label">Pa&iacute;s</label>
												<input type="text" class="form-control texto" style="width: 100%;"  id="txtpais_oficina_d" name="txtpais_oficina_d" value="<%=session("usuario_pais")%>" readonly />
											</div>
										</div>
									</div>
								</div>
							</div><!--del panel con la direccion de la oficina-->
						</div>
					</div>
					
										
					
					
				</div><!--del col-12 general-->
			</div><!--del body-->
		</div><!--datos de la oficina-->
		
		<div class="card mt-4">
	 				<div class="card-header">Datos del Cliente</div>	
					<div class="card-body">
					<div class="col-sm-12 col-md-12 col-lg-12">
                    	<div class="form-group row vertical-align">
							<div class="col-sm-1 col-md-1 col-lg-1">
								<label for="cmbnif_otros">&nbsp;</label>
								<select class="form-control" id="cmbnif_otros" style="width: 100%;">
									<option value="0">NO Asig</option>
									<option value="1" selected>CIF/NIF</option>                            
									<option value="2">NIE</option>            
									<option value="3">OTRO</option>
								</select>
							</div>						
						
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtnif_d" class="control-label">NIF / NIE / Otros</label>
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input class="js-typeahead-nif form-control texto" name="txtnif_d" id="txtnif_d" type="search" placeholder="" autocomplete="off" style="width: 100%;" value="">
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtrazon_social_d" class="control-label">Raz&oacute;n Social / Nombre del Cliente</label>
								<input type="text" class="form-control texto" style="width: 100%;"  id="txtrazon_social_d" name="txtrazon_social_d" value="" />
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<div class="funkyradio">
									<div class="funkyradio-primary">
										<input type="radio" name="radio" id="radio2" value="CLIENTE"/>
										<label for="radio2" class="small">Enviar a La Direccion del Cliente</label>
									</div>
								</div>
								<div class="text-center">(generar&aacute; gastos de env&iacute;o)</div>
							</div>
					    </div>
						  
						<div class="form-group row">
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtpoblacion_d" class="control-label">Tel&eacute;fono</label>
								<input type="text" class="form-control texto" style="width: 100%;"  id="txttelefono_d" name="txttelefono_d" value="" />
							</div>
							<div class="col-sm-4 col-md-4 col-lg-4">
								<label for="txtemail_d" class="control-label">Email</label>
								<input type="email" class="form-control texto" style="width: 100%;"  id="txtemail_d" name="txtemail_d" value="" />
							</div>
						</div>
						
						<!--
						<div class="form-group row">
							<div class="col-sm-12 col-md-12 col-lg-12">
								<label for="txtobservaciones_d" class="control-label">Observaciones</label>
								<input type="text" class="form-control texto" style="width: 100%;"  id="txtobservaciones_d" name="txtobservaciones_d" value="" />
							</div>
						</div>
						-->
						
						<div class="form-group row">
						  	<div class="col-sm-12 col-md-12 col-lg-12">
								<div class="card">
									<div class="card-header">Domicilio del Cliente</div>	
									<div class="card-body">
										<div class="form-group row">
											<div class="col-sm-12 col-md-12 col-lg-12">
												<label for="txtdomicilio_d" class="control-label">Domicilio</label>
												<input type="text" class="form-control texto" style="width: 100%;"  id="txtdomicilio_d" name="txtdomicilio_d" value="" />
											</div>
										</div>
				
										<div class="form-group row">
											<div class="col-sm-5 col-md-5 col-lg-5">
												<label for="txtpoblacion_d" class="control-label">Poblaci&oacute;n</label>
												<input type="text" class="form-control texto" style="width: 100%;"  id="txtpoblacion_d" name="txtpoblacion_d" value="" />
											</div>
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="txtcp_d" class="control-label">C.P.</label>
												<input type="text" class="form-control texto" style="width: 100%;"  id="txtcp_d" name="txtcp_d" value="" />
											</div>
											<div class="col-sm-3 col-md-3 col-lg-3">
												<label for="txtprovincia_d" class="control-label">Provincia</label>
												<input type="text" class="form-control texto" style="width: 100%;"  id="txtprovincia_d" name="txtprovincia_d" value="" />
											</div>
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="txtpais_d" class="control-label">Pa&iacute;s</label>
												<select class="form-control" id="cmbpaises_d" name="cmbpaises_d" style="width: 100%;">
													<option value="">Seleccionar</option>
													<option value="11">ESPAÑA</option>
													<option value="10">PORTUGAL</option>
													<option value="660">AFGANISTAN</option>
													<option value="70">ALBANIA</option>
													<option value="4">ALEMANIA</option>
													<option value="43">ANDORRA</option>
													<option value="330">ANGOLA</option>
													<option value="446">ANGUILA</option>
													<option value="891">ANTARTIDA</option>
													<option value="459">ANTIGUA Y BARBUDA</option>
													<option value="478">ANTILLAS NEERLANDESAS</option>
													<option value="632">ARABIA SAUDI</option>
													<option value="208">ARGELIA</option>
													<option value="528">ARGENTINA</option>
													<option value="77">ARMENIA</option>
													<option value="474">ARUBA</option>
													<option value="800">AUSTRALIA</option>
													<option value="38">AUSTRIA</option>
													<option value="78">AZERBAIYAN</option>
													<option value="453">BAHAMAS</option>
													<option value="640">BAHREIN</option>
													<option value="666">BANGLADESH</option>
													<option value="469">BARBADOS</option>
													<option value="17">BELGICA</option>
													<option value="421">BELICE</option>
													<option value="284">BENIN</option>
													<option value="413">BERMUDAS</option>
													<option value="73">BIELORRUSIA</option>
													<option value="516">BOLIVIA</option>
													<option value="93">BOSNIA-HERZEGOVINA</option>
													<option value="391">BOTSUANA</option>
													<option value="892">BOUVET, ISLA</option>
													<option value="508">BRASIL</option>
													<option value="703">BRUNEI</option>
													<option value="68">BULGARIA</option>
													<option value="236">BURKINA FASO</option>
													<option value="328">BURUNDI</option>
													<option value="675">BUTAN</option>
													<option value="247">CABO VERDE, REPUBLICA DE</option>
													<option value="463">CAIMAN, ISLAS</option>
													<option value="696">CAMBOYA</option>
													<option value="302">CAMERUN</option>
													<option value="404">CANADA</option>
													<option value="306">CENTROAFRICANA, REPUBLICA</option>
													<option value="244">CHAD</option>
													<option value="61">CHECA, REPUBLICA</option>
													<option value="512">CHILE</option>
													<option value="720">CHINA</option>
													<option value="600">CHIPRE</option>
													<option value="833">COCOS</option>
													<option value="480">COLOMBIA</option>
													<option value="375">COMORAS</option>
													<option value="318">CONGO</option>
													<option value="322">CONGO, REPUBLICA DEMOCRATICA</option>
													<option value="107">COOK, ISLAS</option>
													<option value="724">COREA DEL NORTE</option>
													<option value="728">COREA DEL SUR</option>
													<option value="272">COSTA DE MARFIL</option>
													<option value="436">COSTA RICA</option>
													<option value="92">CROACIA</option>
													<option value="448">CUBA</option>
													<option value="531">CURAÇAO</option>
													<option value="8">DINAMARCA</option>
													<option value="460">DOMINICA</option>
													<option value="456">DOMINICANA, REPUBLICA</option>
													<option value="500">ECUADOR</option>
													<option value="220">EGIPTO</option>
													<option value="647">EMIRATOS ARABES UNIDOS</option>
													<option value="336">ERITREA</option>
													<option value="63">ESLOVAQUIA</option>
													<option value="91">ESLOVENIA</option>
													<option value="400">ESTADOS UNIDOS DE AMERICA</option>
													<option value="53">ESTONIA</option>
													<option value="334">ETIOPIA</option>
													<option value="41">FEROE, ISLAS</option>
													<option value="708">FILIPINAS</option>
													<option value="32">FINLANDIA</option>
													<option value="815">FIYI</option>
													<option value="1">FRANCIA</option>
													<option value="314">GABON</option>
													<option value="252">GAMBIA</option>
													<option value="76">GEORGIA</option>
													<option value="893">GEORGIA DEL SUR</option>
													<option value="276">GHANA</option>
													<option value="44">GIBRALTAR</option>
													<option value="473">GRANADA</option>
													<option value="9">GRECIA</option>
													<option value="406">GROENLANDIA</option>
													<option value="831">GUAM</option>
													<option value="416">GUATEMALA</option>
													<option value="108">GUERNESEY</option>
													<option value="260">GUINEA</option>
													<option value="310">GUINEA ECUATORIAL</option>
													<option value="257">GUINEA-BISSAU</option>
													<option value="488">GUYANA</option>
													<option value="452">HAITI</option>
													<option value="835">HEARD Y MCDONALD, ISLAS</option>
													<option value="424">HONDURAS</option>
													<option value="740">HONG-KONG</option>
													<option value="64">HUNGRIA</option>
													<option value="664">INDIA</option>
													<option value="700">INDONESIA</option>
													<option value="616">IRAN</option>
													<option value="612">IRAQ</option>
													<option value="7">IRLANDA</option>
													<option value="104">ISLA DE MAN</option>
													<option value="24">ISLANDIA</option>
													<option value="624">ISRAEL</option>
													<option value="5">ITALIA</option>
													<option value="464">JAMAICA</option>
													<option value="732">JAPON</option>
													<option value="109">JERSEY</option>
													<option value="628">JORDANIA</option>
													<option value="79">KAZAJSTAN</option>
													<option value="346">KENIA</option>
													<option value="83">KIRGUISTAN</option>
													<option value="812">KIRIBATI</option>
													<option value="636">KUWAIT</option>
													<option value="684">LAOS</option>
													<option value="395">LESOTHO</option>
													<option value="54">LETONIA</option>
													<option value="604">LIBANO</option>
													<option value="268">LIBERIA</option>
													<option value="216">LIBIA</option>
													<option value="37">LIECHTENSTEIN</option>
													<option value="55">LITUANIA</option>
													<option value="18">LUXEMBURGO</option>
													<option value="743">MACAO</option>
													<option value="96">MACEDONIA</option>
													<option value="370">MADAGASCAR</option>
													<option value="701">MALASIA</option>
													<option value="386">MALAWI</option>
													<option value="667">MALDIVAS</option>
													<option value="232">MALI</option>
													<option value="46">MALTA</option>
													<option value="529">MALVINAS, ISLAS</option>
													<option value="820">MARIANAS DEL NORTE, ISLAS</option>
													<option value="204">MARRUECOS</option>
													<option value="824">MARSHALL, ISLAS</option>
													<option value="373">MAURICIO</option>
													<option value="228">MAURITANIA</option>
													<option value="377">MAYOTTE</option>
													<option value="832">MENORES ALEJADAS EE.UU, ISLAS</option>
													<option value="412">MEXICO</option>
													<option value="823">MICRONESIA</option>
													<option value="74">MOLDAVIA</option>
													<option value="101">MONACO</option>
													<option value="716">MONGOLIA</option>
													<option value="499">MONTENEGRO</option>
													<option value="470">MONTSERRAT</option>
													<option value="366">MOZAMBIQUE</option>
													<option value="676">MYANMAR</option>
													<option value="389">NAMIBIA</option>
													<option value="803">NAURU</option>
													<option value="834">NAVIDAD, ISLA</option>
													<option value="672">NEPAL</option>
													<option value="432">NICARAGUA</option>
													<option value="240">NIGER</option>
													<option value="288">NIGERIA</option>
													<option value="838">NIUE, ISLA</option>
													<option value="836">NORFOLK, ISLA</option>
													<option value="28">NORUEGA</option>
													<option value="809">NUEVA CALEDONIA</option>
													<option value="804">NUEVA ZELANDA</option>
													<option value="357">OCEANO INDICO, TERRI.BRITANICO</option>
													<option value="649">OMAN</option>
													<option value="3">PAISES BAJOS</option>
													<option value="535">PAISES BAJOS (PARTE CARIBEÑA)</option>
													<option value="662">PAKISTAN</option>
													<option value="825">PALAU</option>
													<option value="442">PANAMA</option>
													<option value="801">PAPUA NUEVA GUINEA</option>
													<option value="520">PARAGUAY</option>
													<option value="504">PERU</option>
													<option value="813">PITCAIRN</option>
													<option value="822">POLINESIA FRANCESA</option>
													<option value="60">POLONIA</option>
													<option value="401">PUERTO RICO</option>
													<option value="644">QATAR</option>
													<option value="6">REINO UNIDO</option>
													<option value="324">RUANDA</option>
													<option value="66">RUMANIA</option>
													<option value="75">RUSIA</option>
													<option value="806">SALOMON, ISLAS</option>
													<option value="428">SALVADOR, EL</option>
													<option value="819">SAMOA</option>
													<option value="830">SAMOA AMERICANA</option>
													<option value="449">SAN CRISTOBAL Y NIEVES</option>
													<option value="47">SAN MARINO</option>
													<option value="663">SAN MARTIN</option>
													<option value="408">SAN PEDRO Y MIQUELON</option>
													<option value="467">SAN VICENTE Y LAS GRANADINAS</option>
													<option value="329">SANTA ELENA</option>
													<option value="465">SANTA LUCIA</option>
													<option value="311">SANTO TOME Y PRINCIPE</option>
													<option value="248">SENEGAL</option>
													<option value="688">SERBIA</option>
													<option value="355">SEYCHELLES</option>
													<option value="264">SIERRA LEONA</option>
													<option value="706">SINGAPUR</option>
													<option value="608">SIRIA</option>
													<option value="342">SOMALIA</option>
													<option value="669">SRI LANKA</option>
													<option value="393">SUAZILANDIA</option>
													<option value="388">SUDAFRICA</option>
													<option value="224">SUDAN</option>
													<option value="30">SUECIA</option>
													<option value="39">SUIZA</option>
													<option value="492">SURINAM</option>
													<option value="680">TAILANDIA</option>
													<option value="736">TAIWAN</option>
													<option value="352">TANZANIA</option>
													<option value="82">TAYIKISTAN</option>
													<option value="625">TERRITORIO PALESTINO OCUPADO</option>
													<option value="894">TIERRAS AUSTRALES FRANCESAS</option>
													<option value="626">TIMOR LESTE</option>
													<option value="280">TOGO</option>
													<option value="839">TOKELAU, ISLAS</option>
													<option value="817">TONGA</option>
													<option value="472">TRINIDAD Y TOBAGO</option>
													<option value="212">TUNEZ</option>
													<option value="454">TURCAS Y CAICOS, ISLAS</option>
													<option value="80">TURKMENISTAN</option>
													<option value="52">TURQUIA</option>
													<option value="807">TUVALU</option>
													<option value="72">UCRANIA</option>
													<option value="350">UGANDA</option>
													<option value="524">URUGUAY</option>
													<option value="81">UZBEKISTAN</option>
													<option value="816">VANUATU</option>
													<option value="45">VATICANO, CIUDAD DEL</option>
													<option value="484">VENEZUELA</option>
													<option value="690">VIETNAM</option>
													<option value="468">VIRGENES BRITANICAS, ISLAS</option>
													<option value="457">VIRGENES DE LOS EE.UU, ISLAS</option>
													<option value="811">WALLIS Y FUTUNA, ISLAS</option>
													<option value="653">YEMEN</option>
													<option value="338">YIBUTI</option>
													<option value="378">ZAMBIA</option>
													<option value="382">ZIMBABUE</option>
													<option value="958">OTROS PAISES NO RELACIONADOS</option>
												</select>

											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						  

						</div><!--del del col-12 general-->
						
						
					</div>
	  		</div>	
			
			<div class="form-group row">
				<div class="col-sm-12 col-md-12 col-lg-12">
					<div class="card mt-4">
						<div class="card-header">Otra Dirección de Envío</div>	
						<div class="card-body">
							<div class="form-group row">
								<div class="col-sm-9 col-md-9 col-lg-9">
										
									<label for="txtdomicilio_envio_d" class="control-label">Direcci&oacute;n</label>
									<input type="text" class="form-control texto" style="width: 100%;"  id="txtdomicilio_envio_d" name="txtdomicilio_envio_d" value="" />
								</div>
								<div class="col-sm-3 col-md-3 col-lg-3">
									<div class="funkyradio">
										<div class="funkyradio-primary">
											<input type="radio" name="radio" id="radio3" value="OTRA_DIRECCION"/>
											<label for="radio3" class="small">Enviar a Esta Otra Direcci&oacute;n</label>
										</div>
									</div>
									<div class="text-center">(generar&aacute; gastos de env&iacute;o)</div>
								</div>
							</div>
	
							<div class="form-group row">
								<div class="col-sm-5 col-md-5 col-lg-5">
									<label for="txtpoblacion_envio_d" class="control-label">Poblaci&oacute;n</label>
									<input type="text" class="form-control texto" style="width: 100%;"  id="txtpoblacion_envio_d" name="txtpoblacion_envio_d" value="" />
								</div>
								<div class="col-sm-2 col-md-2 col-lg-2">
									<label for="txtcp_envio_d" class="control-label">C.P.</label>
									<input type="text" class="form-control texto" style="width: 100%;"  id="txtcp_envio_d" name="txtcp_envio_d" value="" />
								</div>
								<div class="col-sm-3 col-md-3 col-lg-3">
									<label for="txtprovincia_envio_d" class="control-label">Provincia</label>
									<input type="text" class="form-control texto" style="width: 100%;"  id="txtprovincia_envio_d" name="txtprovincia_envio_d" value="" />
								</div>
								
							</div>
						</div><!--del panel-bocy-->
					</div><!--del panel-default-->
				</div><!--del col-12-->
			  </div><!--del form-group-->
				
			<div class="form-group row">
				<div class="col-sm-12 col-md-12 col-lg-12">
					<div class="col-sm-2 col-md-2 col-lg-2 text-center">
						<button type="button" class="btn btn-primary btn-lg" id="cmdguardar_datos" name="cmdguardar_datos">
						  <span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Guardar Datos
						</button>
					</div>
				</div>
			</div>
			
			
	</form>
</div>


<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer" id="botones_avisos">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=carrito_gag_pantalla_avisos_boton_cerrar_2%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->

	
<!-- NO BORRAR, es la capa que añade el json del articulo....-->
<div id="capa_annadir_json_articulo" style="display:none "></div>


<!--PARA LA ANIMACION DE METER LA IMAGEN DEL ARTICULO EN EL CARRITO DE LA COMPRA-->		
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-filestyle-1.2.1/bootstrap-filestyle.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<script type="text/javascript" src="../plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min_unicode.js"></script>

<script language="JavaScript">
//**********************************
var j$=jQuery.noConflict();
j$(document).ready(function () {
	
	j$("#oculto_id").val('<%=valor_oculto_id%>')
	j$("#oculto_empresa").val('<%=valor_oculto_empresa%>')
	 
	j$("#txtnumero_empleado_d").val('<%=valor_numero_empleado%>')
	j$("#txthorario_entrega_d").val('<%=valor_horario_entrega%>')
	
	j$("#txtnif_d").val('<%=valor_nif%>')
	j$("#txtrazon_social_d").val('<%=valor_razon_social%>')
	j$("#txttelefono_d").val('<%=valor_telefono%>')
	j$("#txtemail_d").val('<%=valor_email%>')
	j$("#txtdomicilio_d").val('<%=valor_domicilio_cliente%>')
	j$("#txtpoblacion_d").val('<%=valor_poblacion_cliente%>')
	j$("#txtcp_d").val('<%=valor_cp_cliente%>')
	j$("#txtprovincia_d").val('<%=valor_provincia_cliente%>')
	//j$("#txtpais_d").val('<%=valor_pais_cliente%>')
	j$("#cmbpaises_d").val('<%=valor_idpais_cliente%>')
	j$("#txtdomicilio_envio_d").val('<%=valor_domicilio_envio%>')
	j$("#txtpoblacion_envio_d").val('<%=valor_poblacion_envio%>')
	j$("#txtcp_envio_d").val('<%=valor_cp_envio%>')
	j$("#txtprovincia_envio_d").val('<%=valor_provincia_envio%>')
	
	tipo_envio='<%=valor_enviar_a%>'
	if (tipo_envio=='OFICINA')
		{
		j$("#radio1").prop("checked", true)
		j$("#txtdomicilio_envio_d").val('')
		j$("#txtpoblacion_envio_d").val('')
		j$("#txtcp_envio_d").val('')
		j$("#txtprovincia_envio_d").val('')
		
		}
	if (tipo_envio=='CLIENTE')
		{
		j$("#radio2").prop("checked", true)
		j$("#txtdomicilio_envio_d").val('')
		j$("#txtpoblacion_envio_d").val('')
		j$("#txtcp_envio_d").val('')
		j$("#txtprovincia_envio_d").val('')
		
		}
	if (tipo_envio=='OTRA_DIRECCION')
		{
		j$("#radio3").prop("checked", true)
		j$("#txtdomicilio_envio_d").val('<%=valor_domicilio_envio%>')
		j$("#txtpoblacion_envio_d").val('<%=valor_poblacion_envio%>')
		j$("#txtcp_envio_d").val('<%=valor_cp_envio%>')
		j$("#txtprovincia_envio_d").val('<%=valor_provincia_envio%>')
		}
	//tenmos que configurar el ckeck de tipo de envio.... valor_enviar_a=Request.Form("oculto_radio_d")
		
	
	if ('<%=session("usuario_tipo")%>'=='FRANQUICIA')
		{
		j$(".no_franquicia" ).hide();
		}


	j$(".js-typeahead-nif").typeahead({
		
		minLength: 4,
		maxItem: 10,
		order: "asc",
		dynamic: true,
		hint: true,
		accent: true,
		blurOnTab: false,            // Blur Typeahead when Tab key is pressed, if false Tab will go though search results
	    //generateOnLoad: true,
		//searchOnFocus: true,
		//delay: 500,
		//correlativeTemplate: true,
		backdrop: {
			"background-color": "#fff",
			"opacity": "0.1",
			"filter": "alpha(opacity=10)"
		},
		//backdrop: {
		//	"background-color": "#3879d9",
		//	"opacity": "0.1",
		//	"filter": "alpha(opacity=10)"
		//},
	
		emptyTemplate: "no hay resultados para {{query}}",
		debug: true,
		source: {
			maleta: {
				//display: ["REFERENCIA", "TIPO_MALETA", "TAMANNO", "COLOR"],
				display: "NIF_FACTURAR",
				ajax: function (query) {
					return {
						type: "POST",
						url: "../tojson/Obtener_Clientes_GAG.asp",
						//{"status":true,"error":null,"data":{"user":[{"id":748137,"username":"juliocastrop","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/748137"},{"id":5741776,"username":"solevy","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/5741776"},{"id":906237,"username":"nilovna","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/906237"},{"id":612578,"username":"Thiago Talma","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/612578"},{"id":985837,"username":"ldrrp","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/985837"}],"project":[{"id":2,"project":"jQuery Validation","image":"http:\/\/www.runningcoder.org\/assets\/jqueryvalidation\/img\/jqueryvalidation-preview.jpg","version":"1.4.0","demo":11,"option":14,"callback":8}]}}
						//path: "data.user",
						path: "data",
						data: {nif: query},
						callback: {
							
							}
						}
					}
				
	 
			} //maleta
			
		},
		callback: {
			onClick: function (node, a, item, event) {
					//console.log('evento onclick')
		 
					// You can do a simple window.location of the item.href
					//console.log(JSON.stringify(item))
					//alert(JSON.stringify(item));
					
					j$("#oculto_id").val(item.ID)
					j$("#oculto_empresa").val(item.EMPRESA)
					j$("#txtrazon_social_d").val(item.NOMBRE_FISCAL_FACTURAR)
					j$("#txtdomicilio_d").val(item.DIRECCION_FACTURAR)
					j$("#txtpoblacion_d").val(item.CIUDAD_FACTURAR)
					j$("#txtcp_d").val(item.CP_FACTURAR)
					j$("#txtprovincia_d").val(item.PROVINCIA_FACTURAR)
					//j$("#txtpais_d").val(item.IDPAIS)
					j$("#cmbpaises_d").val(item.IDPAIS)
					j$("#txttelefono_d").val(item.TELEFONO)
					j$("#txtemail_d").val(item.EMAIL)
					
					//para en la modificaciones diferenciar entre seleccionar un cliente ya existente
					// o un cliente nuevo y darlo de alta
					j$("#oculto_cambiado_nif_en_click").val("SI")
					
					j$("#txtrazon_social_d").attr("readonly", true)
					j$("#txtdomicilio_d").attr("readonly", true)
					j$("#txtpoblacion_d").attr("readonly", true)
					j$("#txtcp_d").attr("readonly", true)
					j$("#txtprovincia_d").attr("readonly", true)
					//j$("#txtpais_d").attr("readonly", true)
					j$("#cmbpaises_d").attr("readonly", true)
					j$("#txttelefono_d").attr("readonly", true)
					j$("#txtemail_d").attr("readonly", true)
					
		 
				},
			onCancel: function (node, a, item, event) {
					//console.log('evento oncancel')
		 
					j$("#oculto_id").val("")
					j$("#oculto_empresa").val("")
					j$("#txtrazon_social_d").val("")
					j$("#txtdomicilio_d").val("")
					j$("#txtpoblacion_d").val("")
					j$("#txtcp_d").val("")
					j$("#txtprovincia_d").val("")
					//j$("#txtpais_d").val("")
					j$("#cmbpaises_d").val("11")
					j$("#txttelefono_d").val("")
					j$("#txtemail_d").val("")
					
					j$("#oculto_cambiado_nif_en_click").val("NO")
					
					j$("#txtrazon_social_d").attr("readonly", false)
					j$("#txtdomicilio_d").attr("readonly", false)
					j$("#txtpoblacion_d").attr("readonly", false)
					j$("#txtcp_d").attr("readonly", false)
					j$("#txtprovincia_d").attr("readonly", false)
					//j$("#txtpais_d").attr("readonly", false)
					j$("#cmbpaises_d").attr("readonly", false)
					j$("#txttelefono_d").attr("readonly", false)
					j$("#txtemail_d").attr("readonly", false)
					
		 
				},
			onResult: function (node, query) {console.log('evento onresult')}             // When the result container is displayed
			
				
				
			}
		
	
	});



/*
	//este control esta en esta url: http://www.runningcoder.org/jquerytypeahead
	j$.typeahead({
	
		
		input: '.js-typeahead-nif____',
		minLength: 2,
		maxItem: 10,
		order: "asc",
		dynamic: true,
		hint: true,
		accent: true,
		//searchOnFocus: true,
		//delay: 500,
		//correlativeTemplate: true,
		backdrop: {
			"background-color": "#fff",
			"opacity": "0.1",
			"filter": "alpha(opacity=10)"
		},
		//backdrop: {
		//	"background-color": "#3879d9",
		//	"opacity": "0.1",
		//	"filter": "alpha(opacity=10)"
		//},
	
		emptyTemplate: "no hay resultados para {{query}}",
		source: {
			maleta: {
				//display: ["REFERENCIA", "TIPO_MALETA", "TAMANNO", "COLOR"],
				display: "NIF_FACTURAR",
				ajax: function (query) {
					return {
						type: "POST",
						url: "../tojson/Obtener_Clientes_GAG.asp",
						//{"status":true,"error":null,"data":{"user":[{"id":748137,"username":"juliocastrop","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/748137"},{"id":5741776,"username":"solevy","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/5741776"},{"id":906237,"username":"nilovna","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/906237"},{"id":612578,"username":"Thiago Talma","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/612578"},{"id":985837,"username":"ldrrp","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/985837"}],"project":[{"id":2,"project":"jQuery Validation","image":"http:\/\/www.runningcoder.org\/assets\/jqueryvalidation\/img\/jqueryvalidation-preview.jpg","version":"1.4.0","demo":11,"option":14,"callback":8}]}}
						//path: "data.user",
						path: "data",
						data: {nif: query},
						callback: {
							
							}
						}
					}
				
	 
			}
			
		},
		
		
		callback: {
			
			/*
			onInit: function (node, query) {console.log('evento onInit')},               // When Typeahead is first initialized (happens only once)
			onReady: function (node, query) {console.log('evento onReady')},              // When the Typeahead initial preparation is completed
			onShowLayout: function (node, query) {console.log('evento onshowlayout')},         // Called when the layout is shown
			onHideLayout: function (node, query) {console.log('evento onhidelayout')},         // Called when the layout is hidden
			onSearch: function (node, query) {console.log('evento onsearch')},             // When data is being fetched & analyzed to give search results
			onResult: function (node, query) {console.log('evento onresult')},             // When the result container is displayed
			onLayoutBuiltBefore: function (node, query) {console.log('evento onlayoutbuiltbefore')},  // When the result HTML is build, modify it before it get showed
			onLayoutBuiltAfter: function (node, query) {console.log('evento onlayoutbuiltafter')},   // Modify the dom right after the results gets inserted in the result container
			onNavigateBefore: function (node, query) {console.log('evento onnavigatebefore')},     // When a key is pressed to navigate the results, before the navigation happens
			onNavigateAfter: function (node, query) {console.log('evento onlayoutbuiltbefore')},      // When a key is pressed to navigate the results
			onEnter: function (node, query) {console.log('evento onenter')},              // When an item in the result list is focused
			onLeave: function (node, query) {console.log('evento onleave')},              // When an item in the result list is blurred
			onClickBefore: function (node, query) {console.log('evento onclickbefore')},        // Possibility to e.preventDefault() to prevent the Typeahead behaviors
			onClickAfter: function (node, query) {console.log('evento onclickafter')},         // Happens after the default clicked behaviors has been executed
			onDropdownFilter: function (node, query) {console.log('evento ondropdownfilter')},     // When the dropdownFilter is changed, trigger this callback
			onPopulateSource: function (node, query) {console.log('evento onpopuletesource')},     // Perform operation on the source data before it gets in Typeahead data
			onCacheSave: function (node, query) {console.log('evento oncachesave')},          // Perform operation on the source data before it gets in Typeahead cache
			onSubmit: function (node, query) {console.log('evento onsubmit')},             // When Typeahead form is submitted
			onCancel: function (node, query) {console.log('evento oncancel')},              // Triggered if the typeahead had text inside and is cleared
			onSendRequest: function (node, query) {console.log('evento onsendrequest')},        // Gets called when the Ajax request(s) are sent
        	onReceiveRequest: function (node, query) {console.log('evento onrecieverequest')},     // Gets called when the Ajax request(s) are all received
        
			*/
			
			/*
			onClick: function (node, a, item, event) {
	 			console.log('evento onclick')
	 
				// You can do a simple window.location of the item.href
				//console.log(JSON.stringify(item))
				//alert(JSON.stringify(item));
				
				j$("#oculto_id").val(item.ID)
				j$("#txtrazon_social_d").val(item.NOMBRE_FISCAL_FACTURAR)
				j$("#txtdomicilio_d").val(item.DIRECCION_FACTURAR)
				j$("#txtpoblacion_d").val(item.CIUDAD_FACTURAR)
				j$("#txtcp_d").val(item.CP_FACTURAR)
				j$("#txtprovincia_d").val(item.PROVINCIA_FACTURAR)
				j$("#txtpais_d").val(item.PAIS)
				/*
				j$("#txtdomicilio_envio_d").val(item.DIRECCION)
				j$("#txtpoblacion_envio_d").val(item.POBLACION)
				j$("#txtcp_envio_d").val(item.CP)
				j$("#txtprovincia_envio_d").val(item.PROVINCIA)
				j$("#txttelefono_d").val(item.TELEFONO)
				j$("#txtemail_d").val(item.EMAIL)
				*/
				
				//j$("#cmbtamanno_maleta_entregada_d").val(item.TAMANNO)
				//j$("#txtcolor_maleta_entregada_d").val(item.COLOR)
				//console.log(item.COLOR)
				//j$(".cmb_bt").selectpicker('refresh')
				
/*				
	 
			}
			
			
			
		},
		debug: true
	}).on("typeahead:selected typeahead:autocompleted", function (e, datum) {
		j$("#oculto_id").val(datum.ID)
		j$("#txtrazon_social_d").val(datum.NOMBRE_FISCAL_FACTURAR)
		j$("#txtdomicilio_d").val(datum.DIRECCION_FACTURAR)
		j$("#txtpoblacion_d").val(datum.CIUDAD_FACTURAR)
		j$("#txtcp_d").val(datum.CP_FACTURAR)
		j$("#txtprovincia_d").val(datum.PROVINCIA_FACTURAR)
		j$("#txtpais_d").val(datum.PAIS)
		
		j$("#txtrazon_social_d").addClass("disabled")
		j$("#txtdomicilio_d").addClass("disabled")
		j$("#txtpoblacion_d").addClass("disabled")
		j$("#txtcp_d").addClass("disabled")
		j$("#txtprovincia_d").addClass("disabled")
		j$("#txtpais_d").addClass("disabled")
		
				
	}).on('keyup', function () {
		if(j$('.typeahead__item').length === 0){
			j$("#oculto_id").val("")
			j$("#txtrazon_social_d").val("")
			j$("#txtdomicilio_d").val("")
			j$("#txtpoblacion_d").val("")
			j$("#txtcp_d").val("")
			j$("#txtprovincia_d").val("")
			j$("#txtpais_d").val("")
			
			j$("#txtrazon_social_d").removeClass("disabled")
			j$("#txtdomicilio_d").removeClass("disabled")
			j$("#txtpoblacion_d").removeClass("disabled")
			j$("#txtcp_d").removeClass("disabled")
			j$("#txtprovincia_d").removeClass("disabled")
			j$("#txtpais_d").removeClass("disabled")

			
		}
	});	
	
	
*/	
	
});
	

	
	
/*
j$('#txtnif_d').on('blur', function() {
	console.log("vemos si la lista estaba vacia: " + j$(".typeahead__empty").length)
	console.log("opciones: " + j$(".typeahead__item .typeahead__group-maleta").length)
	console.log("vacio lista empty: " + j$(".typeahead__list empty").length)
	//si hay algun valor en la lista y nos lo saltamos, que de un aviso para que se seleccione
	// entre los valores existenes y asi se autorellenen los otros campos
	if (!j$(".typeahead__empty").length)
		{
		cadena='<br><BR><H3>Consejo</H3><BR><br><H5>- Si selecciona alguno de los valores sugeridos en el desplegable del DNI, NIF, CIF, NIE, se rellenarán automaticamente el resto de campos</H5>'
		window.parent.$("#cabecera_pantalla_avisos").html("Aviso")
		window.parent.$("#body_avisos").html(cadena + "<br>");
		window.parent.$("#botones_avisos").html('<p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p><br>');                          
		window.parent.$("#pantalla_avisos").modal("show");
		}
})		
*/

j$("#cmdguardar_datos").on("click", function () {
	hay_error='NO'
	cadena_error=''
	
	if ('<%=session("usuario_tipo")%>'!='FRANQUICIA')
		{
		if (j$("#txtnumero_empleado_d").val()=='')
			{
			hay_error='SI'
			cadena_error+='<br>- Se Ha de Introducir el N&uacute;mero de Empleado.'
			}
		}
	/*
	if (j$("#txthorario_entrega_d").val()=='')
		{
		hay_error='SI'
		cadena_error+='<br>- Se Ha de Introducir el Horario de Entrega.'
		}
	*/

	if (j$("#cmbnif_otros").val()=='0')
		{
		hay_error='SI'
		cadena_error+='<br>- Se Ha de Seleccionar el Tipo de Documento (DNI / NIF / NIE / Otros).'
		}
			
	if (j$("#txtnif_d").val()=='')
		{
		hay_error='SI'
		cadena_error+='<br>- Se Ha de Introducir El DNI / CIF / NIF / NIE / Otros.'
		}
	  else
	  	{
		// Si el tipo de documento NO es tipo OTROS (3), valida 
		if (j$("#cmbnif_otros").val() != 3) {
			//let resul = validarNIF(j$("#txtnif_d").val());
			resul = validarNIF(j$("#txtnif_d").val());
			if (resul == false) {
				hay_error='SI'
				cadena_error+='<br>- DNI / CIF / NIF / NIE no v&aacute;lido.'
			}
			//console.log(reg.NIF + ':->' + resul);
			// si es CIF/NIF (1)    
			if (j$("#cmbnif_otros").val() == 1 && (resul != 'DNI' &&  resul != 'CIF')) {
				hay_error='SI'
				cadena_error+='<br>- El Documento NO es un CIF, parece ser un ' + resul
			};
			// si es NIE (2 extranjero)    
			if (j$("#cmbnif_otros").val() == 2 && resul != 'NIE') {
				hay_error='SI'
				cadena_error+='<br>- El Documento NO es un NIE, parece ser un ' + resul
			};
		};
		}
		
	
	if (j$("#txtrazon_social_d").val()=='')
		{
		hay_error='SI'
		cadena_error+='<br>- Se Ha de Introducir La Raz&oacute;n Social / Nombre de Cliente.'
		}
		
	if ((j$("#txtdomicilio_d").val()=='') && (j$("#oculto_id").val()==''))
		{
		hay_error='SI'
		cadena_error+='<br>- Se Ha de Introducir el Domicilio.'
		}
	
	if ((j$("#txtpoblacion_d").val()=='') && (j$("#oculto_id").val()==''))
		{
		hay_error='SI'
		cadena_error+='<br>- Se Ha de Introducir la Poblaci&oacute;n.'
		}
	
	if ((j$("#txtcp_d").val()=='') && (j$("#oculto_id").val()==''))
		{
		hay_error='SI'
		cadena_error+='<br>- Se Ha de Introducir el C&oacute;digo Postal.'
		}
	
	if ((j$("#txtprovincia_d").val()=='') && (j$("#oculto_id").val()==''))
		{
		hay_error='SI'
		cadena_error+='<br>- Se Ha de Introducir la Provincia.'
		}
		
	/*
	if ((j$("#txtpais_d").val()=='') && (j$("#oculto_id").val()==''))
		{
		hay_error='SI'
		cadena_error+='<br>- Se Ha de Introducir el Pais.'
		}
	*/
	
	if ((j$("#cmbpaises_d").val()=='') && (j$("#oculto_id").val()==''))
		{
		hay_error='SI'
		cadena_error+='<br>- Se Ha de Introducir el Pais.'
		}
	if ((j$("#txttelefono_d").val()=='') && (j$("#oculto_id").val()==''))
		{
		hay_error='SI'
		cadena_error+='<br>- Se Ha de Introducir el Tel&eacute;fono.'
		}
	
	if (j$("#txtemail_d").val()!='')
		{
		if (!isEmail(j$("#txtemail_d").val()))
			{
			hay_error='SI'
			cadena_error+='<br>- Se Ha de Introducir un Email Correcto.'
			}
		}
	
	if (!$('#radio1').is(':checked') && !$('#radio2').is(':checked') && !$('#radio3').is(':checked'))
		{
		hay_error='SI'
		cadena_error+='<br>- Ha de Seleccionar Alguna de Las 3 Opciones donde Enviar los Articulos:'
		cadena_error+='<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- A la Dirección de La Oficina.'
		cadena_error+='<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- A la Dirección del Cliente.'
		cadena_error+='<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- A otra Dirección.'
		
		
		}
		
	//if ($('#radio1').is(':checked')) {console.log('seleccionada el ckeck 1')}
	//if ($('#radio2').is(':checked')) {console.log('seleccionada el ckeck 2')}
	//if ($('#radio3').is(':checked')) {console.log('seleccionada el ckeck 3')}
	
	//selecciona el envio a otra direccion
	if ($('#radio3').is(':checked'))
		{
		if (j$("#txtdomicilio_envio_d").val()=='')
			{
			hay_error='SI'
			cadena_error+='<br>- Se Ha de Introducir la Direcci&oacute;n de la Direcci&oacute;n de Env&iacute;o Seleccionada.'
			}
		
		if (j$("#txtpoblacion_envio_d").val()=='')
			{
			hay_error='SI'
			cadena_error+='<br>- Se Ha de Introducir la Poblaci&oacute;n de la Direcci&oacute;n de Env&iacute;o Seleccionada.'
			}
		
		if (j$("#txtcp_envio_d").val()=='')
			{
			hay_error='SI'
			cadena_error+='<br>- Se Ha de Introducir el C&oacute;digo Postal de la Direcci&oacute;n de Env&iacute;o Seleccionada.'
			}
		
		if (j$("#txtprovincia_envio_d").val()=='')
			{
			hay_error='SI'
			cadena_error+='<br>- Se Ha de Introducir la Provincia de la Direcci&oacute;n de Env&iacute;o Seleccionada.'
			}
		
		
		}
	
	/*
	j$("#txtdomicilio_envio_d").val('')
	j$("#txtpoblacion_envio_d").val('')
	j$("#txtcp_envio_d").val('')
	j$("#txtprovincia_envio_d").val('')
	*/
	
	//para saber que es un caso de una modificacion en la que se ha seleccionado
	// un cliente nuevo  que hay que dar de alta como cliente	
	if ((j$("#oculto_cambiado_nif_en_click").val()=='NO') && (j$("#txtnif_d").val()!= j$("#oculto_nif").val()))
		{
		j$("#oculto_id").val('')
		}
	
	if (hay_error=='SI')
		{
		//alert('Se Han Detectado Los Siguientes Errores:\n\n' + cadena_error)
		cadena='<br><BR><H3>Se han detectado los siguientes errores</H3><BR><br><H5>' + cadena_error + '</H5>'
		window.parent.$("#cabecera_pantalla_avisos").html("Aviso")
		window.parent.$("#body_avisos").html(cadena + "<br>");
		window.parent.$("#botones_avisos").html('<p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p><br>');                          
		window.parent.$("#pantalla_avisos").modal("show");

		}
	  else
	  	{
			
			
			$('.texto').each(function() {
				//sustituimos las comillas simples y dobles por el acento para que no den problemas
				// y tambien el \ que da problemas en json con \\
				//$(this).val( $(this).val().replace(/"/g, '´') );
				//$(this).val( $(this).val().replace('''', '´' );
				//$(this).val( $(this).val().replace('\\', '\\\\') );
			});
			
			
			
			//document.getElementById('frmpedido').submit()
			var data = JSON.stringify( j$("#frmdatos").serializeArray() ); //  <-----------
			//var jsonText = JSON.stringify(j$("#frmdatos"));
			//console.log('valores en json: ' +  data );
			//console.log('valores en json 2: ' +  jsonText );
			window.parent.$("#ocultodatos_adicionales_maletas").val(data)
			window.parent.$("#capa_maletas").modal("hide");
			window.parent.$("#icono_plantilla_maletas").removeClass("btn-warning").addClass("btn-success");
			if ($('#radio1').is(':checked'))
				{
				window.parent.$("#ocultogastos_envio_pedido").val(0)
				//console.log('antes de recalcular totales')
				window.parent.recalcular_totales()
				//console.log('despues de recalcular totales')
				window.parent.$("#fila_gastos_envio").hide()
				}
			  else
			  	{
				//console.log('antes de recalcular totales')
				window.parent.recalcular_totales()
				//console.log('despues de recalcular totales')
				window.parent.$("#fila_gastos_envio").show()
				}
			
			
		}

});

function isEmail(email) {
 var regex = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
 return regex.test(email) ? true : false;
}

function validarNIF(nif) {
 
    /*        
        Retorna: 
            False: Documento invalido.
            DNI: Correcto, se trata de un CIF/DNI
            NIE: Correcto, se trata de un NIE (extranjero)
            CIF: Correcto, se trata de un NIF (Empresa)
 
        Los DNI españoles pueden ser:
        NIF (Numero de Identificación Fiscal) - 8 numeros y una letra1
        NIE (Numero de Identificación de Extranjeros) - 1 letra2, 7 numeros y 1 letra1
        
		letra1 - Una de las siguientes: TRWAGMYFPDXBNJZSQVHLCKE
        letra2 - Una de las siguientes: XYZ           
 
        ref: https://github.com/TORR3S/Check-NIF/blob/master/checkNIF.js  
     */
    
    nif = nif.toUpperCase().replace(/[\s\-]+/g, '');
    if (/^(\d|[XYZ])\d{7}[A-Z]$/.test(nif)) {
        var num = nif.match(/\d+/);
        num = (nif[0] != 'Z' ? nif[0] != 'Y' ? 0 : 1 : 2) + num;
        if (nif[8] == 'TRWAGMYFPDXBNJZSQVHLCKE'[num % 23]) {
            return /^\d/.test(nif) ? 'DNI' : 'NIE';
        }
    }
    else if (/^[ABCDEFGHJKLMNPQRSUVW]\d{7}[\dA-J]$/.test(nif)) {
        for (var sum = 0, i = 1; i < 8; ++i) {
            var num = nif[i] << i % 2;
            var uni = num % 10;
            sum += (num - uni) / 10 + uni;
        }
        var c = (10 - sum % 10) % 10;
        if (nif[8] == c || nif[8] == 'JABCDEFGHI'[c]) {
            return /^[KLM]/.test(nif) ? 'ESP' : 'CIF';
        }
    }
    return false;
};// validarNIF

</script>
</body>
</html>