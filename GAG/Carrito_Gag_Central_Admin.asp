<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->
<%





		if session("usuario")="" then
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
		end if
		
		
		
		
		
		
		
		
		
		
		'recordsets
		dim articulos
		dim datos_cliente
		
		
		'variables
		dim sql
		
		
		codigo_externo_modificacion=""
		nombre_modificacion=""
		pais_pedido=""
		
	    set articulos=Server.CreateObject("ADODB.Recordset")
		'si entra para modificar un pedido existente
		accion=Request.Form("ocultoaccion")
		'response.write("<br>valor de accion recogido de ocultoaccion: " & accion)
		if accion="" then
			'aqui viene la accion junto con el pedido y la fecha "MODIFICAR--88--fecha--codigo cliente--codigo externo cliente--nombre cliente"
			acciones=Request.QueryString("acciones")
			if acciones<>"" then
				tabla_acciones=Split(acciones,"--")
				accion=tabla_acciones(0)
				pedido_modificar=tabla_acciones(1)
				fecha_pedido=tabla_acciones(2)
				hotel_admin=tabla_acciones(3)
				codigo_externo_modificacion="" & tabla_acciones(4)
				nombre_modificacion="" & tabla_acciones(5)
				pais_pedido="" & tabla_acciones(6)
				'response.write("<br>valor de accion recogido de querystring acciones: " & acciones)
		
			end if
		end if
		
		tipo_pedido=""
		if Request.Form("ocultopedido_modificar")<>"" then
			pedido_modificar=Request.Form("ocultopedido_modificar")
		end if
		if Request.Form("ocultofecha_pedido")<>"" then
			fecha_pedido=Request.Form("ocultofecha_pedido")
		end if
		if Request.Form("ocultohotel")<>"" then
			hotel_admin=Request.Form("ocultohotel")
		end if
		
		'es la primera vez que entro a modificarlo
		if nombre_modificacion="" then
				set datos_cliente=Server.CreateObject("ADODB.Recordset")
				with datos_cliente
					.ActiveConnection=connimprenta
					.Source="SELECT * FROM V_CLIENTES WHERE ID=" & hotel_admin
					'response.write("<br>" & .source)
					.Open
				end with
				if not datos_cliente.eof then
					codigo_externo_modificacion="" & datos_cliente("codigo_externo")
					nombre_modificacion="" & datos_cliente("nombre")
					pais_pedido="" & datos_cliente("pais")
				end if
				datos_cliente.close
				set datos_cliente=Nothing
		end if
		
		
		cadena_acciones=accion & "--" & pedido_modificar & "--" & fecha_pedido & "--" & hotel_admin & "--" & codigo_externo_modificacion & "--" & nombre_modificacion & "--" & pais_pedido
		'response.write("<br>cadena_acciones: " & CADENA_ACCIONES)

		'para controlar si es una modificacion de un primer pedido de asm y hacer el descuento
		if pedido_modificar<>"" then
			set tipos_pedido=Server.CreateObject("ADODB.Recordset")
			with tipos_pedido
				.ActiveConnection=connimprenta
				.Source="SELECT PEDIDO_AUTOMATICO FROM PEDIDOS"
				.Source= .Source & " WHERE ID=" & pedido_modificar
				'response.write("<br>" & .source)
				.OPEN
			end with
	
			if not tipos_pedido.eof then
				tipo_pedido=tipos_pedido("pedido_automatico")
			end if
			
			tipos_pedido.close
			set tipos_pedido=Nothing
		end if
		
		'response.write("<br>tipo pedido: " & tipo_pedido)	
		




'Recogemos la variable borrar 
borrar=Request.Querystring("borrar")
'RESPONSE.WRITE("<BR>HAY QUE QUITAR EL ARTICULO CON CODIGO: " & BORRAR)

If borrar<>"" Then 'Si se ha pedido el borrado de un articulo
	i=1
	Do While borrar<>Session(i)
		'RESPONSE.WRITE("<BR>SESSION(" & i & "): " & session(i))
		i=i+1
	Loop
	'response.write("<br>y ahora tenemos que mover unos articulos sobre otros... Hay " & Session("numero_articulos") & " articulos en el pedido")
	
	'vacio la variable de sesion con los datos json que pueda contener el articulo personalizado
	'response.write("<br>borramos los datos json de " & session(i) & ": " & Session("json_" & Session(i)))
	Session("json_" & Session(i))=""
	For j=i to Session("numero_articulos")
		'RESPONSE.WRITE("<BR>SESSION(" & j & "): " & session(j) & " contendrá a SESSSION(" & j+1 & "): " & session(j+1))
		Session(j)=Session(j+1)
		'RESPONSE.WRITE("<BR>SESSION(" & j & "_cantidades_precios): " & session(j & "_cantidades_precios") & " contendrá a SESSSION(" & j+1 & "_cantidades_precios): " & session(j+1 & "_cantidades_precios"))
		Session(j & "_cantidades_precios")=Session((j+1) & "_cantidades_precios")
		Session(j & "_fichero_asociado")=Session((j+1) & "_fichero_asociado")
		
	Next
	Session("numero_articulos")=Session("numero_articulos")-1
		
	'response.write("<br>y al final quedan " & Session("numero_articulos") & " articulos en el pedido")
	'response.write("<br><br>ahora vemos como ha quedado despues de borrar")
	'For j=1 to Session("numero_articulos")
		'RESPONSE.WRITE("<BR>SESSION(" & j & "): " & session(j)) 
		'RESPONSE.WRITE("<BR>SESSION(" & j & "_cantidades_precios): " & session(j & "_cantidades_precios"))
	'Next
		
	
	
End if

'Si no quedan articulos en el carrito despues del borrado
cadena="Lista_Articulos_Gag_Central_Admin.asp"
If Session("numero_articulos")= 0 Then
	'history.back()
	'Response.Redirect("bottom.asp")
end if


set carrusel=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_CARRUSEL=0
		CAMPO_ORDEN_CARRUSEL=1
		CAMPO_EMPRESAS_CARRUSEL=2
		CAMPO_FICHERO_CARRUSEL=3
		with carrusel
			.ActiveConnection=connimprenta
			.Source="SELECT ID_CARRUSEL, ORDEN, EMPRESAS, FICHERO"
			.Source= .Source & " FROM CARRUSEL"
			.Source= .Source & " WHERE EMPRESAS LIKE '%###" & session("usuario_codigo_empresa") & "###%'"
			.Source= .Source & " ORDER BY ORDEN, ID_CARRUSEL"
			'response.write("<br>FAMILIAS: " & .source)
			.Open
			vacio_carrusel=false
			if not .BOF then
				tabla_carrusel=.GetRows()
			  else
				vacio_carrusel=true
			end if
		end with

		carrusel.close
		set carrusel=Nothing
		

'response.write("<br>pais pedido: " & pais_pedido)
%>
<html>
<head>
<title><%=carrito_gag_central_admin_title%></title>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />

<style>
	body {padding-top: 10px; background-color:#fff;}
	html,body{
		margin:0px;
		height:100%;
		}

	
	a.enlace { 
			text-decoration:none;
			font: bold courier }
	a.enlace:link { color:#990000}
	a.enlace:visited { color:#990000}
	a.enlace:actived {color:#990000}
	a.enlace:hover {
			font: bold italic ;color:blue}
			
	a.nosub { 
			text-decoration:none;
			}
	a.nosub:link { color:blue}
	a.nosub:visited { color:blue}
	a.nosub:actived {color:blue}
	a.nosub:hover {
			font: bold italic ;color:#8080c0}
		
</style>

<style>
/*--estilos relacionados con las capas para las plantillas de personalizacion de articulos*/
.botones_agrupacion{
  
  /*background-image:url("images/Boton_Informatica.jpg");*/
  background-repeat:no-repeat;
  background-position:center;
  float:left;
    
  height:100px;
  width:100px;
  float:left;
  
  /*background: url("images/Boton_Informatica.jpg") no-repeat center center fixed; */
  
  -webkit-background-size: cover;
  -moz-background-size: cover;
  -o-background-size: cover;
  background-size: cover;
  
  /*
  filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/Boton_Informatica_.jpg', sizingMethod='scale');
  -ms-filter: "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/Boton_Informatica_.jpg', sizingMethod='scale')";
 */
 }
  
#capa_opaca__ {
	position:absolute;
	color: black;
	background-color: #C0C0C0;
	left: 0px;
	top: 0px;
	width: 100%;
	height: 100%;
	z-index: 1000;
	text-align: center;
	visibility: visible;
	filter:alpha(opacity=40);
	-moz-opacity:.40;
	opacity:.40;
}

.aviso {
	font-family: Verdana, Arial, Helvetica, sans-serif;
  	font-size: 18px;
  	color: #000000;
  	text-align: center;
	background-color:#33FF33
}  	

#contenedorr3 { 


/* Otros estilos */ 
border:1px solid #333;
background:#eee;
padding:15px;
width:940px;

margin: 75px auto;

-moz-border-radius: 20px; /* Firefox */
-webkit-border-radius: 20px; /* Google Chrome y Safari */
border-radius: 20px; /* CSS3 (Opera 10.5, IE 9 y estándar a ser soportado por todos los futuros navegadores) */
/*
behavior:url(border-radius.htc);/* IE 8.*/

}




/*******************************
PARA LA IMAGEN DEL ARTICULO EN EL CARRITO
************/


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


/*****************************************************
PARA ROTAR Y ANIMAR LOS GLYPHICONS
******************************/

.gly-spin {
  -webkit-animation: spin 2s infinite linear;
  -moz-animation: spin 2s infinite linear;
  -o-animation: spin 2s infinite linear;
  animation: spin 2s infinite linear;
}
@-moz-keyframes spin {
  0% {
    -moz-transform: rotate(0deg);
  }
  100% {
    -moz-transform: rotate(359deg);
  }
}
@-webkit-keyframes spin {
  0% {
    -webkit-transform: rotate(0deg);
  }
  100% {
    -webkit-transform: rotate(359deg);
  }
}
@-o-keyframes spin {
  0% {
    -o-transform: rotate(0deg);
  }
  100% {
    -o-transform: rotate(359deg);
  }
}
@keyframes spin {
  0% {
    -webkit-transform: rotate(0deg);
    transform: rotate(0deg);
  }
  100% {
    -webkit-transform: rotate(359deg);
    transform: rotate(359deg);
  }
}
.gly-rotate-90 {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1);
  -webkit-transform: rotate(90deg);
  -moz-transform: rotate(90deg);
  -ms-transform: rotate(90deg);
  -o-transform: rotate(90deg);
  transform: rotate(90deg);
}
.gly-rotate-180 {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=2);
  -webkit-transform: rotate(180deg);
  -moz-transform: rotate(180deg);
  -ms-transform: rotate(180deg);
  -o-transform: rotate(180deg);
  transform: rotate(180deg);
}
.gly-rotate-270 {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
  -webkit-transform: rotate(270deg);
  -moz-transform: rotate(270deg);
  -ms-transform: rotate(270deg);
  -o-transform: rotate(270deg);
  transform: rotate(270deg);
}
.gly-flip-horizontal {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=0, mirror=1);
  -webkit-transform: scale(-1, 1);
  -moz-transform: scale(-1, 1);
  -ms-transform: scale(-1, 1);
  -o-transform: scale(-1, 1);
  transform: scale(-1, 1);
}
.gly-flip-vertical {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=2, mirror=1);
  -webkit-transform: scale(1, -1);
  -moz-transform: scale(1, -1);
  -ms-transform: scale(1, -1);
  -o-transform: scale(1, -1);
  transform: scale(1, -1);
}



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



@media screen and (min-width: 725px){
   #columna_izquierda_fija{
       position: fixed;
   }
} 

.panel_conmargen
	{
	padding-left:5px; 
	padding-right:5px; 
	padding-bottom:5px; 
	padding-top:5px;
	}
	
.panel_sinmargen
	{
	padding-left:0px; 
	padding-right:0px; 
	padding-bottom:0px; 
	padding-top:0px;
	}
	
.panel_sinmargen_lados
	{
	padding-left:0px; 
	padding-right:0px; 
	}
	
.panel_sinmargen_arribaabajo
	{
	padding-bottom:0px; 
	padding-top:0px;
	}

.panel_connmargen_lados
	{
	padding-left:5px; 
	padding-right:5px; 
	}
	
.panel_conmargen_arribaabajo
	{
	padding-bottom:5px; 
	padding-top:5px;
	}
	
.inf_general_art, .inf_pack_stock
	{
	-webkit-box-shadow: none;
    box-shadow: none;
	}
	


.table-borderless td,
.table-borderless th {
    border: 0px !important;
}


</style>

<script language="javascript">
function cambiacomaapunto (s)
{
	var saux = "";
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ",")
			saux = saux + ".";
		else
			saux = saux + s.charAt (j);
	}
	return saux;
}

// una vez calculado el resultado tenemos que volver a dejarlo como es devido, con la coma
//    representando los decimales y no el punto
function cambiapuntoacoma(s)
{
	var saux = "";
	//alert("pongo coma")
	//alert("tamaño: " + s.legth)
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ".")
			saux = saux + ",";
		else
			saux = saux + s.charAt (j);
		//alert("total: " + saux)
	}
	return saux;
}

// ademas redondeamos a 2 decimales el resultado
function redondear (v){
	var vaux;
	vaux = Math.round (v * 100);
	vaux =  vaux / 100;
	return  vaux;
}


	
	
   function mover_formulario(objetivo)
   {
   	if (objetivo=='volver')
   		accion='Lista_Articulos_Gag_Central_Admin.asp'
	  else
	  	accion='Grabar_Pedido_Gag_Central_Admin.asp';
	document.getElementById('frmpedido').action=accion
	document.getElementById('frmpedido').submit()	
	

   }
   	
function validar(pedido_minimo, total_pedido, total_pedido_iva)
{
	hay_error='NO'
	cadena_error=''
	
	//alert('<%=session("usuario_tipo")%>')
	//alert('tipo oficina: <%=session("usuario_tipo")%>\ntotal pedido: ' + total_pedido + '\npedido minimo: ' + pedido_minimo+ '\npedido con iva: ' + total_pedido_iva)
	if (<%=Session("numero_articulos")%>>0)
		{
		
		//comprobamos que los articulos personalizables con plantillas, se han rellenado los datos
		//		antes de grabar el pedido
		var sAux="";
		var frm = document.getElementById("frmpedido");
		for (i=0;i<frm.elements.length;i++)
		{
			
			//--console.log(frm.elements[i].name + ': ' + frm.elements[i].name.indexOf('ocultoarticulo_personalizable_'))
			if (frm.elements[i].name.indexOf('ocultoarticulo_personalizable_')==0)
				{
				codigo_articulo=frm.elements[i].name.substr(30,frm.elements[i].name.length)
				sAux += "CODIGO: " + codigo_articulo + " ";
				sAux += "NOMBRE: " + frm.elements[i].name + " ";
				sAux += "TIPO :  " + frm.elements[i].type + " "; ;
				sAux += "VALOR: " + frm.elements[i].value + "\n" ;
				
				//console.log('lo que se manda con oculto_datos_personalizacion_json: ' + document.getElementById('ocultodatos_personalizacion_json_' + codigo_articulo).value)
				
				if ((document.getElementById('ocultodatos_personalizacion_json_' + codigo_articulo).value=='')&&
						(document.getElementById('ocultoarticulo_personalizable_' + codigo_articulo).value=='SI'))
					{
					hay_error='SI'
					cadena_error+='<%=carrito_gag_central_admin_error_articulo_personalizable%>'
					
					}
				
				
				}
		}
		//--alert(sAux);
	
		
		
		
		
		
		if (parseFloat(pedido_minimo)>parseFloat(total_pedido))
			{
				hay_error='SI'
				cadena_error+='<%=carrito_gag_central_admin_error_pedido_minimo%>'
				
			}




		}
	  else
		{
			hay_error='SI'
			cadena_error+='<%=carrito_gag_central_admin_error_carrito_sin_articulos%>'
			
		}
	
	
	
	if (hay_error=='SI')
		{
		//alert('Se Han Detectado Los Siguientes Errores:\n\n' + cadena_error)
		cadena='<br><BR><H3><%=carrito_gag_central_admin_error_explicacion%></H3><BR><br><H5>' + cadena_error + '</H5>'
		
		$("#cabecera_pantalla_avisos").html("<%=carrito_gag_central_admin_pantalla_avisos_cabecera%>")
		$("#body_avisos").html(cadena + "<br>");
		$("#botones_avisos").html('<p><button type="button" class="btn btn-default" data-dismiss="modal"><%=carrito_gag_central_admin_pantalla_avisos_boton_cerrar%></button></p><br>');                          
		$("#pantalla_avisos").modal("show");

		}
	  else
	  	{
			document.getElementById('frmpedido').submit()
		}
		



	
				
}
</script>

<script language="javascript">
//para mostrar las capas de las plantillas de personalizacon de articulos
function mostrar_capas(capa, plantilla, cliente, anno_pedido, pedido, articulo, cantidad)
{
	document.getElementById("capa_opaca").style.height = (document.body.scrollHeight + 20) + "px";
	document.getElementById('capa_opaca').style.visibility='visible'
	
	texto_querystring='?plant=' + plantilla + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad
	document.getElementById('iframe_plantillas').src='../Plantillas_Personalizacion/Plantilla_Personalizacion.asp' + texto_querystring
	document.getElementById(capa).style.visibility='visible';
	
	
	
}

function cerrar_capas(capa)
{	
	document.getElementById('capa_opaca').style.visibility='hidden';
	document.getElementById(capa).style.visibility='hidden';
	
	
}
</script>


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
    alert('<%=carrito_gag_central_admin_error_ajax%>');
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
    
	if (parametros=='')
		{
		var url_final = pagina
		}
	  else
	  	{
	  	var url_final = pagina + '?' + parametros
		}
 
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



<!--PARA LA ANIMACION DE METER LA IMAGEN DEL ARTICULO EN EL CARRITO DE LA COMPRA-->		
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

</head>
<body style="background-color:<%=session("color_asociado_empresa")%> ">
<!-- capa opaca para que no deje pulsar nada salvo lo que salga delante (se comporte de forma modal)-->
<div id="capa_opaca" style="visibility:hidden;background-color:#000000;position:absolute;top:0px;left:0px;width:105%;min-height:110%;z-index:2;filter:alpha(opacity=50);-moz-opacity:.5;opacity:.5">
</div>

<!-- capa con la informacion a mostrar por encima del carrito-->
<div id="capa_informacion" style="visibility:hidden;z-index:3;position:absolute;width:100%; height:100%">
		<div id="contenedorr3" class="aviso">
			<p>
				<iframe src="" style="height:450px;width:910px" frameborder="0" id="iframe_plantillas" name="iframe_plantillas"></iframe>
			</p>
		</div>
</div>
<!--*******************************************************-->



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
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=carrito_gag_central_admin_pantalla_avisos_boton_cerrar_2%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->





<div class="container-fluid">
   <!--PANTALLA-->
  <div class="row">
    <!--COLUMNA IZQUIERDA -->
    <div class="col-xs-3" id="columna_izquierda_fija">


			  <!--DATOS DEL CLIENTE-->
			  <div class="panel panel-default" style="margin-bottom:0px ">
				<div class="panel-body panel_conmargen">
					<div class="col-md-12">
						<%
						nombre_logo="logo_" & session("usuario_carpeta") & ".png"
						if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
							nombre_logo="Logo_GLS.png"
						end if
						%>
						<div align="center"><img class="img-responsive" src="Images/<%=nombre_logo%>" style="max-height:90px"/></div>
						<br />
						<div align="center">	
							<button type="button" id="cmdarticulos" name="cmdarticulos" class="btn btn-primary btn-md" title="<%=carrito_gag_central_admin_consultar_articulos_alter%>">
									<i class="glyphicon glyphicon-th-list"></i>
									<span><%=carrito_gag_central_admin_consultar_articulos%></span>
									
									

							</button>
							<button type="button" id="cmdpedidos" name="cmdpedidos" class="btn btn-primary btn-md" title="<%=carrito_gag_central_admin_consultar_pedidos_alter%>">
									<i class="glyphicon glyphicon-list-alt"></i>
									<span><%=carrito_gag_central_admin_consultar_pedidos%></span>
							</button>
						</div>
						
					</div>
				</div>
			  </div>
	
	
			    
			  
				<!--OFERTAS DESTACADAS... CARRUSEL-->
				<%if not vacio_carrusel then%>
					<div class="panel panel-default" style="margin-bottom:0px;margin-top:7px ">
						<div class="panel-heading"><b>Destacados</b></div>
						<div class="panel-body panel_sinmargen_lados panel_conmargen_arribaabajo">
						
							<DIV>
							<!--COMIENZO DEL CARRUSEL-->
							<script type="text/javascript" src="../carrusel/js/carrusel_4_seg.js"></script>
							<div id="jssor_2" style="position: relative; margin: 0 auto; top: 0px; left: 0px; width: 600px; height: 500px; overflow: hidden; visibility: hidden;">
								<!-- Pantalla de "Cargando..." -->
								<div data-u="loading" style="position: absolute; top: 0px; left: 0px;">
									<div style="filter: alpha(opacity=70); opacity: 0.7; position: absolute; display: block; top: 0px; left: 0px; width: 100%; height: 100%;"></div>
									<div style="position:absolute;display:block;background:url('../carrusel/img_carrusel/loading.gif') no-repeat center center;top:0px;left:0px;width:100%;height:100%;"></div>
								</div>
								<div data-u="slides" style="cursor: default; position: relative; top: 0px; left: 0px; width: 600px; height: 500px; overflow: hidden;">
									<%for i=0 to UBound(tabla_carrusel,2)%>
										<div style="display: none;"><img data-u="image" src="../carrusel/img_carrusel/<%=tabla_carrusel(campo_fichero_carrusel,i)%>" /></div>
									<%next%>
								</div>
								<!-- Botones de Navegacion -->
								<!--
								<div data-u="navigator" class="jssorb05" style="bottom:16px;right:16px;" data-autocenter="1">
									<!-- Boton prototipo 
									<div data-u="prototype" style="width:16px;height:16px;"></div>
								</div>
								-->
								
								<!-- Flechas de Navegacion -->
								<span data-u="arrowleft" class="jssora10l" style="top:0px;left:8px;width:28px;height:40px;" data-autocenter="2"></span>
								<span data-u="arrowright" class="jssora10r" style="top:0px;right:8px;width:28px;height:40px;" data-autocenter="2"></span>
							</div>
							<script>
								jssor_slider_init('jssor_2');
							</script>
							<!-- FINALIZA EL CARRUSEL-->
							</DIV>
						</div>
					</div>
				<%end if%>		
				<!--FINAL OFERTAS DESTACADAS -- EL CARRUSEL-->
				
		</div> 
    </div>
    <!--FINAL COLUMNA DE LA IZQUIERDA-->
    
    <!--COLUMNA DE LA DERECHA-->
    <div class="col-xs-9  col-xs-offset-3">
      <div class="panel panel-default">
        <div class="panel-heading">
			<span class='fontbold'>
				<%=carrito_gag_central_admin_panel_detalle_pedido_cabecera%>
					<%if accion="MODIFICAR" THEN
						valor_cadena=carrito_gag_central_admin_panel_detalle_pedido_cabecera_modificando
						'response.write("<br>valor cadena: " & valor_cadena)
						valor_cadena= replace(valor_cadena, "XXX", pedido_modificar)
						valor_cadena= replace(valor_cadena, "YYY", codigo_externo_modificacion)
						valor_cadena= replace(valor_cadena, "ZZZ", nombre_modificacion)
						%>
						
					
						<!--
						&nbsp;-- Modificando Pedido <%=pedido_modificar%>  de la sucursal (<%=codigo_externo_modificacion%>) - <%=nombre_modificacion%>
						-->
						&nbsp;-- <%=valor_cadena%>
/					<%end if%>		
			</span>
		</div>
        <div class="panel-body">
		
		
				<form name="frmpedido" id="frmpedido" action="Grabar_Pedido_Gag_Central_Admin.asp" method="post"  enctype="multipart/form-data">
					<input type="hidden" name="ocultoacciones" id="ocultoacciones" value="<%=cadena_acciones%>" />
						
							<table class="table"> 
								<thead> 
									<tr> 
										<th class="col-md-2" title="<%=carrito_gag_central_admin_panel_detalle_pedido_titular_codigo_sap_alter%>"><%=carrito_gag_central_admin_panel_detalle_pedido_titular_codigo_sap%></th> 
										<th class="col-md-3"><%=carrito_gag_central_admin_panel_detalle_pedido_titular_articulo%></th> 
										<th class="col-md-2" style="text-align:right"><%=carrito_gag_central_admin_panel_detalle_pedido_titular_cantidad%></th> 
										<th class="col-md-2" style="text-align:right" title="<%=carrito_gag_central_admin_panel_detalle_pedido_titular_precio_unidad_alter%>"><%=carrito_gag_central_admin_panel_detalle_pedido_titular_precio_unidad%></th> 
										<th class="col-md-2" style="text-align:right"><%=carrito_gag_central_admin_panel_detalle_pedido_titular_total%></th>
										<th class="col-md-1"></th> 
									</tr> 
								</thead> 
								<tbody> 
									<%if Session("numero_articulos")=0 then%>
										<tr>
											<td align="center" colspan="8">
												<b><font class="fontbold"><%=carrito_gag_central_admin_panel_detalle_pedido_no_articulos%></font> &nbsp;&nbsp;&nbsp;
												
											</td>
										</tr>
									<%end if%>
									
									<%
									'Iniciamos las variables
									i=1 'contador de articulos
									'Session("total")=0 'precio del pedido
									total_pedido=0
									compromiso_compra_pedido="SI"
									control_compromiso_compra_pedido="SI"
									
									'Comenzamos la impresion de los articulos del carrito
									While i<=Session("numero_articulos")
										id=Session(i)
										cantidades_precios_id=Session(i & "_cantidades_precios")
										'response.write("<br>cantidades_precios_id " & Session(i & "_cantidades_precios"))
										calculos_cantidades_precios=split(cantidades_precios_id,"--")
										'multiplico la cantidad por el precio y rendondeo a 2 decimales
										'total_id=round(calculos_cantidades_precios(0) * calculos_cantidades_precios(1), 2)
										'response.write("<br>posicion: " & i & " ...Articulo: " & id & " cantidades_precios: " & cantidades_precios_id)
										'response.write("<br>Articulo: " & id & " cantidades_precios: " & cantidades_precios_id)
										
										
										
										'22-06-2016... Añadimos el left join a articulos_personalizados para ver si hay que personalizarlo
										sql="SELECT ARTICULOS.CODIGO_SAP,"
										sql=sql & " CASE WHEN ARTICULOS_IDIOMAS.DESCRIPCION IS NULL THEN ARTICULOS.DESCRIPCION ELSE" 
										sql=sql & " ARTICULOS_IDIOMAS.DESCRIPCION END AS DESCRIPCION_IDIOMA,"
										sql=sql & " ARTICULOS.COMPROMISO_COMPRA,"
										sql=sql & " V_EMPRESAS.CARPETA, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, ARTICULOS.REQUIERE_AUTORIZACION, "
										sql=sql & " ARTICULOS_PERSONALIZADOS.PLANTILLA_PERSONALIZACION"
										
										sql=sql & " FROM ARTICULOS ARTICULOS INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO"
										sql=sql & " INNER JOIN V_EMPRESAS ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA = V_EMPRESAS.Id"
										sql=sql & " LEFT JOIN ARTICULOS_PERSONALIZADOS ON ARTICULOS.ID=ARTICULOS_PERSONALIZADOS.ID_ARTICULO"
										sql=sql & " LEFT JOIN ARTICULOS_IDIOMAS"
										sql=sql & " ON (ARTICULOS.ID=ARTICULOS_IDIOMAS.ID_ARTICULO AND ARTICULOS_IDIOMAS.IDIOMA='" & UCASE(SESSION("idioma")) &"')"
			
										sql=sql & " WHERE ARTICULOS.ID=" & id
										'Response.write("<br>" & sql)
										
									
										with articulos
											.ActiveConnection=connimprenta
											.Source=sql
											'.source="SELECT ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION as articulo from articulos"
											'response.write("<br>" & .source)
											.Open
										end with
										'SI TODOS LOS ARTICULOS DEL PEDIDO, SON COMPROMISMO DE COMPRA, EL IMPORTE MINIMO SON 199 O 101
										' PERO EN CUANTO HAYA ALGUN ARTICULO SIN COMPROMISO DE COMPRA, EL IMPORTE MINIMO HA DE SER 300
										'response.write("<br>sap: " & articulos("codigo_sap"))
										'response.write("<br>desc: " & articulos("descripcion"))
										'response.write("<br>compromiso compra: " & articulos("compromiso_compra"))
										if articulos("compromiso_compra")="NO" then
											compromiso_compra_pedido="NO"
											'en cuanto hay un articulo sin compromiso de compra
											' el limite del importe del pedido sube...
											control_compromiso_compra_pedido="NO"
											colorcin="#FCFCFC"
										  else
											compromiso_compra_pedido="SI"
											colorcin="#FFFFCC"
										end if
									
									%>
								
									<tr >
										<td class="col-md-2">
											<%'22-06-2016...  comprobamos si ha de ser un articulo personalizable
											'y luego añadimos a los campos ocultos el valor de la plantilla y si es personalizable o no
											articulo_personalizado="NO"
											plantilla_personalizacion= "" & articulos("PLANTILLA_PERSONALIZACION")
											if plantilla_personalizacion<>"" THEN
												articulo_personalizado="SI"
											end if
											datos_json_articulo=session("json_" & id)
											'response.write("<br>datos_json_articulo DE LA VARIABLE DE SESION: " & datos_json_articulo)	
											
											%>
											<input type="hidden" name="ocultoarticulo_personalizable_<%=id%>" id="ocultoarticulo_personalizable_<%=id%>" value="<%=articulo_personalizado%>">
											<input type="hidden" name="ocultoplantilla_personalizacion_<%=id%>" id="ocultoplantilla_personalizacion_<%=id%>" value="<%=plantilla_personalizacion%>">
											<input type="hidden" name="ocultodatos_personalizacion_json_<%=id%>" id="ocultodatos_personalizacion_json_<%=id%>" value="">
											
											
											<div align="center">
												<a class="thumbnail" href="../Imagenes_Articulos/<%=id%>.jpg" target="_blank" title="<%=carrito_gag_central_admin_panel_detalle_pedido_imagen_articulo_alter%>" style="text-decoration:none ">
													<div class="image_thumb">
														<img src="../Imagenes_Articulos/Miniaturas/i_<%=id%>.jpg" class="img img-responsive full-width"/>
													</div>
													<%=articulos("CODIGO_SAP")%>
												</a>
											</div>
										</td>
										<td class="col-md-3">
											<%=articulos("DESCRIPCION_IDIOMA")%>
											<%'ASM no controla lo de articulo requiere autorizacion o no
											'UVE tampoco
											' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL
											', 230 AVORIS, 240 FRANQUICIAS HALCON Y 250 FRANQUICIAS ECUADOR tampoco
											if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150 _
												and session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80 _
												and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170 _
												and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230  and session("usuario_codigo_empresa")<>240_
												and session("usuario_codigo_empresa")<>250 then%>
												<%IF ARTICULOS("REQUIERE_AUTORIZACION")="SI" THEN%>
														<i class="glyphicon glyphicon-exclamation-sign" style="color:#ff0000" title="<%=carrito_gag_central_admin_panel_detalle_pedido_requiere_autorizacion_alter%>"></i>
														<input type="hidden" name="ocultoautorizacion_<%=id%>" id="ocultoautorizacion_<%=id%>" value="SI">
													<%ELSE%>
														<i class="glyphicon glyphicon-ok-sign" style="color:#00ff00" title="<%=carrito_gag_central_admin_panel_detalle_pedido_no_requiere_autorizacion_alter%>"></i>
														<input type="hidden" name="ocultoautorizacion_<%=id%>" id="ocultoautorizacion_<%=id%>" value="NO">
												<%END IF%>
											<%end if%>
									  </td>
										<td align="right" class="col-md-2">
											<input type="hidden" name="ocultocantidad_<%=id%>" id="ocultocantidad_<%=id%>" value="<%=calculos_cantidades_precios(0)%>">
											<%=calculos_cantidades_precios(0)%>
										</td>
										<td align="right" class="col-md-2">
											<input type="hidden" name="ocultoprecio_<%=id%>" id="ocultoprecio_<%=id%>" value="<%=calculos_cantidades_precios(1)%>">
											<%if compromiso_compra_pedido="SI" then%>
												<%=calculos_cantidades_precios(1)%> €/u
											  <%else%>
												<%response.write("")%>			  		
											<%end if%>
										</td>
										<td align="right" class="col-md-2">
											<%
											if compromiso_compra_pedido="SI" then
												resultado=cdbl(replace(calculos_cantidades_precios(0),".",",")) * cdbl(replace(calculos_cantidades_precios(1),".",","))
											  else
												resultado=cdbl(replace(calculos_cantidades_precios(2),".",","))
											end if
											Response.write(resultado & " €") 
											'response.write("<br>cantidad: " & calculos_cantidades_precios(0) & " precio unidad: " & calculos_cantidades_precios(1) & " total Pack: " & calculos_cantidades_precios(2))
											'response.write("<br>resultado: " & resultado & " total pedido: " & total_pedido)
											'response.write("<br>resultado: " & replace(resultado,",",".") & " total pedido: " & total_pedido)
											'response.write("<br>resultado: " & cdbl(cstr(resultado)) & " total pedido: " & total_pedido)
											'response.write("<br>compromiso compra: " & compromiso_compra_pedido)
											total_pedido=total_pedido + resultado
											'total_pedido=total_pedido + cdbl(replace(resultado,",","."))
											
											%>
											<input type="hidden" name="ocultototal_<%=id%>" id="ocultototal_<%=id%>" value="<%=resultado%>">
										
											
										</td>
										<td  class="col-md-1">
											<button type="button" class="btn btn-danger btn-sm" title="<%=carrito_gag_central_admin_panel_detalle_pedido_boton_eliminar_articulo_alter%>" onclick="location.href='Carrito_Gag_Central_Admin.asp?borrar=<%=id%>&acciones=<%=cadena_acciones%>'">

												<i class="glyphicon glyphicon-remove"></i>
											</button>
											
											<%'22-06-2016... comprobamos si es uno de los articulos
												' en los que se tiene que rellenar una plantilla
												' para personalizarlos
											carpeta_anno=""
											if fecha_pedido<>"" then
												carpeta_anno=year(fecha_pedido)
											end if
											if articulo_personalizado="SI" then%>
												<br /><br />
												<button type="button" class="btn btn-warning btn-sm"
														id="icono_plantilla_<%=id%>" name="icono_plantilla_<%=id%>" 
														title="<%=carrito_gag_central_admin_panel_detalle_pedido_boton_plantilla_alter%>"
														onclick="mostrar_capas('capa_informacion', '<%=plantilla_personalizacion%>','<%=HOTEL_ADMIN%>', '<%=carpeta_anno%>', '<%=pedido_modificar%>', '<%=id%>', '<%=calculos_cantidades_precios(0)%>')"
														>
													<i class="glyphicon glyphicon-list-alt"></i>
												</button>
											<%end if%>

										</td>
									</tr>
									
									
								
								<!------ PARA CONTROL DEL ADJUNTO------------------------------------------>
								<%if compromiso_compra_pedido="NO" and articulo_personalizado="NO" then%>
									<tr id="linea_fichero_adjunto_<%=id%>">
										<td class="item_row" colspan=6 style="border-top:none">
											
											<div class="row">
												<div class="col-sm-5  col-sm-offset-5">
															<input type="file" name="txtfichero_<%=id%>" id="txtfichero_<%=id%>" value="Seleccionar Fichero" style="display:none">
												</div>
												<div class="col-sm-2" style="text-align:right">
														<%if session(i & "_fichero_asociado")<>"" then%>
															<a href="pedidos/<%=year(fecha_pedido)%>/<%=session("usuario")%>__<%=pedido_modificar%>/<%=session(i & "_fichero_asociado")%>" target="_blank">	
																<button type="button" class="btn btn-primary btn-sm"
																	id="icono_adjunto_<%=id%>" name="icono_adjunto_<%=id%>" 
																	title="<%=carrito_gag_central_admin_panel_detalle_pedido_boton_mostrar_fichero_adjunto_alter%>"
																	style="display:none"
																	>
																
																		<i class="glyphicon glyphicon-paperclip"></i>
																</button>
															</a>
														
															<button type="button" class="btn btn-primary btn-sm"
																id="icono_modificar_adjunto_<%=id%>" name="icono_modificar_adjunto_<%=id%>" 
																title="<%=carrito_gag_central_admin_panel_detalle_pedido_boton_modificar_fichero_adjunto_alter%>"
																style="display:none"
																onclick="mostramos_txtfichero('<%=id%>')"
																>
																	<i class="glyphicon glyphicon-pencil"></i>
															</button>
														<%end if%>
													</div>
												
												<%if session(i & "_fichero_asociado")="" then%>
													<script language="javascript">
														$('#icono_adjunto_<%=id%>').hide()
														$('#icono_modificar_adjunto_<%=id%>').hide()
														$('#txtfichero_<%=id%>').show()
													</script>
												<%else%>
													<script language="javascript">
														$('#icono_adjunto_<%=id%>').show()
														$('#icono_modificar_adjunto_<%=id%>').show()
														$('#txtfichero_<%=id%>').hide()
													</script>
												<%end if%>
											</div>
										</td>
									</tr>
								<%end if%>
								<!------ FIN CONTROL DEL ADJUNTO ---------------------------------------->
	
									
			
								
								<%if accion="MODIFICAR" then%>
									<%'ahora comprobamos si es un articulo personalizable con plantilla y si ya se ha 
										'guardado el fichero json, para cargarlo en la variable oculta
										
										'si esta vacio recojo el valor desde el fichero, pero si no, lo dejo como esta
										IF Session("json_" & id)="" THEN 
											cadena_texto_json=""
											set fso_json=Server.CreateObject("Scripting.FileSystemObject")
											ruta_fichero_json= Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & HOTEL_ADMIN & "__" & pedido_modificar)
											ruta_fichero_json= ruta_fichero_json & "/json_" & id & ".json"
											'--response.write("<br>fichero json a comprobar si existe: " & ruta_fichero_json)
											if fso_json.FileExists(ruta_fichero_json) then
												Set contenido_fichero_json = fso_json.OpenTextFile(ruta_fichero_json, 1) 
												'Escribimos su contenido 
												cadena_texto_json=contenido_fichero_json.ReadAll
												'--Response.Write("El contenido es:<br>" & cadena_texto_json)
											end if
											set fso_json=nothing
											if cadena_texto_json<>"" then
												'en el oculto solo detectamos si se ha rellenado los datos de personalizacion o no
												' el valor de esos datos los gestionamos con la variable de sesion
												Session("json_" & id)=cadena_texto_json
											%>
												<%'--response.write("<br />metemos el texto en el oculto y cambiamos el icono...")%>
												<script language="javascript">
													//valor='';
													//valor=valor.'<%=cadena_texto_json%>';
													//valor=valor.replace(/(\r\n|\n|\r)/gm, '')
													document.getElementById('ocultodatos_personalizacion_json_<%=id%>').value='COMPLETADO';
													//document.getElementById('icono_plantilla_<%=id%>').src='../images/icono_correcto_verde.png';
													$("#icono_plantilla_<%=id%>").removeClass("btn-warning").addClass("btn-success");
													$("#icono_plantilla_<%=id%>").attr('title', '<%=carrito_gag_central_admin_panel_detalle_pedido_boton_plantilla_hecha_alter%>');
													//console.log('cambiamos color boton plantilla')
												</script>
											
											
											<%
											end if
										  else 'la variable de session no esta vacia%>
											<script language="javascript">
												//valor='';
												//valor=valor.'<%=cadena_texto_json%>';
												//valor=valor.replace(/(\r\n|\n|\r)/gm, '')
												document.getElementById('ocultodatos_personalizacion_json_<%=id%>').value='COMPLETADO';
												//document.getElementById('icono_plantilla_<%=id%>').src='../images/icono_correcto_verde.png';
												$("#icono_plantilla_<%=id%>").removeClass("btn-warning").addClass("btn-success" );
												$("#icono_plantilla_<%=id%>").attr('title', '<%=carrito_gag_central_admin_panel_detalle_pedido_boton_plantilla_hecha_alter%>');
													
												//console.log('cambiamos color boton plantilla 2')
											</script>
										
										<%	
										end if 'de if (session("json_".....
										%>
								
  						  <%else  'de accion MODIFICAR%>
							
							<%if Session("json_" & id)<>"" then%>
								<script language="javascript">
									//valor='';
									//valor=valor.'<%=cadena_texto_json%>';
									//valor=valor.replace(/(\r\n|\n|\r)/gm, '')
									document.getElementById('ocultodatos_personalizacion_json_<%=id%>').value='COMPLETADO';
									//document.getElementById('icono_plantilla_<%=id%>').src='../images/icono_correcto_verde.png';
									$("#icono_plantilla_<%=id%>").removeClass("btn-warning").addClass("btn-success" );
									$("#icono_plantilla_<%=id%>").attr('title', '<%=carrito_gag_central_admin_panel_detalle_pedido_boton_plantilla_hecha_alter%>');
													
									//console.log('cambiamos color boton plantilla 3')
								</script>
							<%end if%>								
						<%end if  'de accion MODIFICAR%>
						
									
									
									
									<%		
										i=i+1
										articulos.close
									Wend
									
									%>
									
									
									<%if Session("numero_articulos")<>0 then%>
										<tr>
										  <td>&nbsp;</td>
										  <th colspan=3 style="text-align:right"><%=carrito_gag_central_admin_panel_detalle_pedido_total%></th>
										  <th style="text-align:right"><%=total_pedido%> €</th>
										  <td>&nbsp;</td>
										</tr>

										<%resultado_descuento=0%>
										
										<%if tipo_pedido="PRIMER_PEDIDO_REDYSER" then
											resultado_descuento = total_pedido * 0.50
											if resultado_descuento>800 then
												resultado_descuento=800
											end if
											%>
											<tr>
											  <td>&nbsp;</td>
											  <th colspan=3 style="text-align:right;color:#880000">Descuento Primer Pedido 50% (Max. 800€) (<%=(total_pedido * 0.50)%>)</th>
											  <th style="text-align:right;color:#880000">
											  		<%
													resultado_descuento = round(resultado_descuento, 2)
													response.write(resultado_descuento)
													%>
													€
													<input name="ocultodescuento_pedido" id="ocultodescuento_pedido" type="hidden" value="<%=resultado_descuento%>" />
											  </th>
											  <td>&nbsp;</td>
											</tr>
											<tr>
											  <td>&nbsp;</td>
											  <th colspan=3 style="text-align:right;color:#880000">Total Precio Final</th>
											  <th style="text-align:right;color:#880000">
											  		<%
													resultado_total_descuento = round((total_pedido - resultado_descuento), 2)
													response.write(resultado_total_descuento)
													%>
													€
											  </th>
											  <td>&nbsp;</td>
											</tr>
										<%end if%>										
	


										<tr>
										  <td>&nbsp;</td>
										  <th colspan=3 style="text-align:right"><%=carrito_gag_central_admin_panel_detalle_pedido_pedido_minimo%></th>
										  <th style="text-align:right">
											<%
											if control_compromiso_compra_pedido="NO" then
												pedido_minimo_permitido=session("usuario_pedido_minimo_sin_compromiso")
											else
												pedido_minimo_permitido=session("usuario_pedido_minimo_con_compromiso")
											end if
											response.write(pedido_minimo_permitido & " €")
											%>
										  </th>
										  <td>&nbsp;</td>
										</tr>
										
										<%'para las franquicias hay que calcular el iva para que hagan
											'el ingreso del total mas el iva
										'****
										'al final se muestra lo del iva a las franquicias y a las propias
										'if session("usuario_tipo")="FRANQUICIA" then%>
										<%'no uso session("usuario_pais"), porque por ejemplo, si entra la oficina administradora de españa, carga 
											'el iva para un pedido de portugal
										if pais_pedido<>"PORTUGAL" then%>
											<tr>
											  <td>&nbsp;</td>
											  <th colspan=3 style="text-align:right"><%=carrito_gag_central_admin_panel_detalle_pedido_iva%> (<%=((total_pedido - resultado_descuento) * 0.21)%>)</th>
											  <th style="text-align:right">
												<%
													resultado_iva=((total_pedido - resultado_descuento) * 0.21)
													iva_21= round(resultado_iva,2)
													response.write(iva_21)
												%> 
												€
											  </th>
											  <td>&nbsp;</td>
											</tr>
										<%end if%>
										
											<tr>
											  <td>&nbsp;</td>
											  <th colspan=3 style="text-align:right"><%=carrito_gag_central_admin_panel_detalle_pedido_total_pagar%></th>
											  <th style="text-align:right">
												<%
													total_pago_iva=(total_pedido - resultado_descuento) + iva_21
													
													response.write(total_pago_iva)
												%> 
												€</th>
												<td>&nbsp;</td>
											</tr>
										<%'end if%>
										
									<%end if%>								
									
									
								</tbody> 
							</table>

										
					  
					</form>
					
				<div class="panel panel-default">
					<div class="panel-body">
						<div align="center" class="col-md-12">	
							<button type="button" id="cmdcontinuar" name="cmdcontinuar" class="btn btn-primary btn-lg" onclick="location.href='Lista_Articulos_Gag_Central_Admin_Pedir.asp?acciones=<%=cadena_acciones%>'">
									<i class="glyphicon glyphicon-plus"></i>
									<span>&nbsp;<%=carrito_gag_central_admin_panel_detalle_pedido_boton_continuar%></span>
							</button>
							<button type="button" id="cmdconfirmar" name="cmdconfirmar" class="btn btn-success btn-lg" onclick="validar('<%=pedido_minimo_permitido%>','<%=total_pedido%>','<%=total_pago_iva%>');return false">
									<i class="glyphicon glyphicon-floppy-disk"></i>
									<span>&nbsp;<%=carrito_gag_central_admin_panel_detalle_pedido_boton_confirmar%></span>
							</button>
						</div>
					</div>
				</div>
			
					
        </div><!--panel-body-->
      </div><!--panel-->
	  
	  
	  
    </div>
    <!--FINAL COLUMNA DE LA DERECHA-->
  </div>    
  <!-- FINAL DE LA PANTALLA -->
</div>
<!--FINAL CONTAINER-->












<script language="javascript">
/*
	$(function() {
            var offset = $("#columna_izquierda").offset();
            var topPadding = 15;
            $(window).scroll(function() {
                if ($(window).scrollTop() > offset.top) {
                    $("#columna_izquierda").stop().animate({
                        marginTop: $(window).scrollTop() - offset.top + topPadding
                    });
                } else {
                    $("#columna_izquierda").stop().animate({
                        marginTop: 0
                    });
                };
            });
        });
*/		
		
		
$("#cmdarticulos").on("click", function () {
	location.href='Lista_Articulos_Gag_Central_Admin.asp'
});

$("#cmdpedidos").on("click", function () {
	location.href='Consulta_Pedidos_Gag_Central_Admin.asp'
});
		
		
$("#cmdver_pedido").on("click", function () {
	location.href='Carrito_Gag_Central_Admin.asp?acciones=<%=accion%>'
});

$("#cmdborrar_pedido").on("click", function () {
	pagina_url='Vaciar_Carrito_Gag.asp'
	parametros=''
	mostrar_capa(pagina_url,'capa_annadir_articulo', parametros)
	
	
	
	cadena='<BR><BR><H4><%=carrito_gag_central_admin_pantalla_avisos_contenido%></H4><BR><BR>'	
	$("#cabecera_pantalla_avisos").html("<%=carrito_gag_central_admin_pantalla_avisos_cabecera%>")
	$("#body_avisos").html(cadena + "<br>");
	
	cadena='<p><button type="button" class="btn btn-default" data-dismiss="modal" onclick="volver_carrito()"><%=carrito_gag_central_admin_pantalla_avisos_boton_cerrar%></button></p><br>'
	$("#botones_avisos").html(cadena)                
	$("#pantalla_avisos").modal("show");
	//location.href='Vaciar_Carrito_Gag.asp'
});

volver_carrito=function(){
	location.href='Carrito_Gag_Central_Admin.asp'
}

mostramos_txtfichero=function(id_articulo){
	$('#txtfichero_' + id_articulo).show();
}

$("#cmdconsultar_pedidos").on("click", function () {
	location.href='Consulta_Pedidos_Gag_Central_Admin.asp'
});


</script>


</body>
<%
	'articulos.close
	
	connimprenta.close
	
	set articulos=Nothing
	
	set connimprenta=Nothing

%>
</html>
