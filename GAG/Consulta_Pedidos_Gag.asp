<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
		response.Buffer=true
		numero_registros=0
		
		
		empleado_gls=Request.Querystring("emp")
		
		ver_cadena=Request.Querystring("p_vercadena")
		
		if session("usuario")="" then
			if empleado_gls="SI" then
				Response.Redirect("../Login_GLS_Empleados.asp")
			  else
				Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
			end if
		end if

		
		
		ver_todos_registros=Request.Form("ocultover_todos_registros")
		estado_seleccionado=Request.Form("cmbestados")
		numero_pedido_seleccionado=Request.Form("txtpedido")
		fecha_i=Request.Form("txtfecha_inicio")
		fecha_f=Request.Form("txtfecha_fin")
		
		'if estado_seleccionado="" and numero_pedido_seleccionado="" and fecha_i="" and fecha_f="" then
		'		estado_seleccionado="PENDIENTE AUTORIZACION"
		'end if
		
		
		estado_consulta="SIN TRATAR"	
		'if session("usuario_tipo")="FRANQUICIA" then
		if session("usuario_tipo")="AGENCIA" then
			'las franquicias solo pueden modificar lo pendiente de pago
			estado_consulta="PENDIENTE PAGO"	
		  else
		  	'estado_consulta="AUTORIZANDO CENTRAL"	
			'QUIEREN QUE AHORA ESTE ESTADO SE LLAME ASI, PENDIENTE AUTORIZACION
			if session("usuario_requiere_autorizacion")="SI" then
				'las oficinas propias sin autorizacion, solo pueden modificar sus pendientes de autorizacion
				' y las que si tienen autorizacion podran cambiar sus sin tratar
				estado_consulta="PENDIENTE AUTORIZACION"	
			end if
		end if
		
		'recordsets
		dim pedidos
		
		
		'variables
		dim sql
		
		

	    
	    set pedidos=Server.CreateObject("ADODB.Recordset")
		
		'porque el sql de produccion es un sql expres que debe tener el formato de
		' de fecha con mes-dia-año
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
				
		'solo devolvemos x primeros registros		
		grupo_registros=10
		with pedidos
			.ActiveConnection=connimprenta
			
			.Source="SELECT"
			if ver_todos_registros<>"SI" then
				.Source= .Source & " TOP (" & grupo_registros & ")" 
			end if
			.Source= .Source & " CASE WHEN ESTADO = 'ENVIADO AL PROVEEDOR' THEN 'ENVIADO' ELSE ESTADO END AS ESTADO_FORMATEADO"
			.Source= .Source & ", CONVERT(varchar, PEDIDOS.FECHA, 103)AS FECHA_CORTA"
			.Source= .Source & ", *, (SELECT STUFF("
            .Source= .Source & " (SELECT ';' + CONVERT(nvarchar(50), FECHAVALIJA, 103)"
			.Source= .Source & " FROM V_DATOS_ALBARANES"
			'ojo hay que cambiarlo para que con globaliagift pueda aceptar numeros de pedido alfanumericos
			'.Source= .Source & " WHERE NPEDIDO=CONVERT(nvarchar(20),PEDIDOS.ID)"
			.Source= .Source & " WHERE NPEDIDO=PEDIDOS.ID"
			.Source= .Source & " ORDER BY FECHAVALIJA"
			.Source= .Source & " FOR XML PATH (''))"
			.Source= .Source & " , 1, 1, '')) AS FECHAS_VALIJA,"
			.Source= .Source & " count(*) over() AS TOTAL_REGISTROS"
			
			.Source= .Source & " FROM PEDIDOS WHERE 1=1"

			if empleado_gls="SI" then
					.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO=" & session("usuario_directorio_activo")
					.Source= .Source & " AND PEDIDO_AUTOMATICO='ROPA_EMPLEADO'" 'por si coinciden los numeros de empleado de gls con globalia...

				else			
					.Source= .Source & " AND (CODCLI=" & session("usuario")
					.Source= .Source & " OR CLIENTE_ORIGINAL=" & session("usuario") & ")"
					if session("usuario_codigo_empresa")=4 then
						.Source= .Source & " AND (PEDIDO_AUTOMATICO IS NULL OR PEDIDO_AUTOMATICO<>'ROPA_EMPLEADO')" 'las oficinas de gls no ven los pedidos de sus empleados..						
					end if
					'.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO IS NULL"
			end if
			
			

			if estado_seleccionado<>"" then
				.Source= .Source & " AND (CASE WHEN ESTADO = 'ENVIADO AL PROVEEDOR' THEN 'ENVIADO' ELSE ESTADO END) = '" & estado_seleccionado & "'"  
			end if
			if numero_pedido_seleccionado<>"" then
				.Source= .Source & " AND ID=" & numero_pedido_seleccionado
			end if
			
			if fecha_i<>"" then
				.Source= .Source & " AND (FECHA >= '" & fecha_i & "')" 
			end if
			if fecha_f<>"" then
				.Source= .Source & " AND (FECHA <= '" & fecha_f & "')"
			end if

			
			.Source= .Source & " ORDER BY FECHA desc, id desc"
			
			if ver_cadena="SI" then
				response.write("<br>PEDIDOS: " & .source)
			end if
			.Open
		end with

		

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
			if ver_cadena="SI" then
				response.write("<br>FAMILIAS: " & .source)
			end if
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
		
		
		dinero_disponible_devoluciones=0	
		set disponible_devoluciones=Server.CreateObject("ADODB.Recordset")
		CAMPO_DISPONIBLE=0
		with disponible_devoluciones
			.ActiveConnection=connimprenta
			.Source="select ROUND((ISNULL(SUM(TOTAL_ACEPTADO),0) - ISNULL(SUM(TOTAL_DISFRUTADO),0)),2) as DISPONIBLE"
			.Source= .Source & " FROM DEVOLUCIONES"
			.Source= .Source & " WHERE CODCLI = " & session("usuario") 
			if empleado_gls="SI" then
				.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO=" & session("usuario_directorio_activo")
			  else
				.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO IS NULL" 
			end if
			.Source= .Source & " AND ESTADO='CERRADA'"
			if ver_cadena="SI" then
				response.write("<br>DEVOLUCIONES: " & .source)
			end if
			.Open
		end with

		if not disponible_devoluciones.eof then
			dinero_disponible_devoluciones=disponible_devoluciones("DISPONIBLE")	
		end if
		disponible_devoluciones.close
		set disponible_devoluciones=Nothing
		
		if empleado_gls<>"SI" then
			dinero_disponible_saldos=0	
			set disponible_saldos=Server.CreateObject("ADODB.Recordset")
			CAMPO_DISPONIBLE_SALDOS=0
			with disponible_saldos
				.ActiveConnection=connimprenta
				.Source="SELECT ROUND(SUM(CASE WHEN CARGO_ABONO='CARGO' THEN (ISNULL(IMPORTE,0) - ISNULL(TOTAL_DISFRUTADO,0)) * (-1)"
				.Source= .Source & " ELSE (ISNULL(IMPORTE,0) - ISNULL(TOTAL_DISFRUTADO,0))"
				.Source= .Source & " END), 2) AS DISPONIBLE"
				.Source= .Source & " FROM SALDOS"
				.Source= .Source & " WHERE CODCLI = " & session("usuario") 
				if ver_cadena="SI" then
					response.write("<br>SALDOS: " & .source)
				end if
				.Open
			end with
		
			if not disponible_saldos.eof then
				dinero_disponible_saldos=disponible_saldos("DISPONIBLE")	
			end if
			disponible_saldos.close
			set disponible_saldos=Nothing
		end if


%>
<html>
<head>
<title><%=consulta_pedidos_gag_title%></title>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />
<link rel="stylesheet" type="text/css" href="../plugins/datepicker/css/bootstrap-datepicker.css">

<script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

<link rel="stylesheet" type="text/css" href="../plugins/octicons_6_0_1/lib/octicons.css">

<style>
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
		
		
.gly-flip-vertical {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=2, mirror=1);
  -webkit-transform: scale(1, -1);
  -moz-transform: scale(1, -1);
  -ms-transform: scale(1, -1);
  -o-transform: scale(1, -1);
  transform: scale(1, -1);
}

.gly-flip-horizontal {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=0, mirror=1);
  -webkit-transform: scale(-1, 1);
  -moz-transform: scale(-1, 1);
  -ms-transform: scale(-1, 1);
  -o-transform: scale(-1, 1);
  transform: scale(-1, 1);
  }
</style>
<style>
      .icono_boton {
        vertical-align: middle;
        font-size: 40px;
      }
      .texto_boton {
        /*font-family: "Courier-new";*/
		font-size: 1.2rem;
      }
      .contenedor_boton {
        border: 1px solid #666;
        border-radius: 6px;
        display: inline-block;
        margin: 40px;
        padding: 10px;
      }
	  
  .dinero_disponible {
        font-weight: bold;
        color: white; /* Cambia el color del texto a blanco */
        background-color: tomato; /* Cambia el color de fondo a tomato */
        border-radius: 5px; /* Hace los bordes del fondo redondeados */
        padding: 2px 5px; /* Agrega un poco de espacio alrededor del texto */
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


	
	
   
   
function borrar_pedido(numero_pedido,fecha_pedido)
{
	cadena='<br><BR><H3><%=consulta_pedidos_gag_pantalla_borrar_pedido_mensaje%></H5>'
	//console.log('cadena antes del replace: ' + cadena)
	cadena.replace('NUMERO PEDIDO: ', numero_pedido)
	cadena_error= cadena.replace('XXX', numero_pedido) + '<br>'
	//console.log('cadena DESPUIES del replace: ' + cadena.replace('XXX', numero_pedido))					
	$("#cabecera_pantalla_avisos").html("<%=consulta_pedidos_gag_pantalla_borrar_pedido_cabecera%>")
	$("#body_avisos").html(cadena_error + "<br>");
	cadena='<p><button type="button" class="btn btn-default" data-dismiss="modal" onclick="borramos_pedido('
	cadena=cadena + numero_pedido + ', \'' + fecha_pedido + '\')">'
	cadena=cadena + '&nbsp;<%=consulta_pedidos_gag_pantalla_borrar_pedido_boton_si%>&nbsp;</button>'
	cadena=cadena + '<button type="button" class="btn btn-default" data-dismiss="modal">&nbsp;<%=consulta_pedidos_gag_pantalla_borrar_pedido_boton_no%>&nbsp;</button></p>'
	$("#botones_avisos").html(cadena)                
	$("#pantalla_avisos").modal("show");
}

function borramos_pedido(numero_pedido,fecha_pedido)
{
		document.getElementById("ocultopedido_a_borrar").value=numero_pedido
		document.getElementById("ocultofecha_pedido").value=fecha_pedido
		document.getElementById("frmborrar_pedido").submit()
}
	
	
function modificar_pedido(numero_pedido)
{
	document.getElementById("ocultopedido_a_modificar").value=numero_pedido
	document.getElementById("frmmodificar_pedido").submit()
	
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
    alert('<%=consulta_pedidos_gag_error_ajax%>!');
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

<script language="javascript">
function mostrar_capas_new(capa, plantilla, cliente, anno_pedido, pedido, articulo, cantidad)
{
    
	texto_campos=''
	if (plantilla=='plantilla_a01')
		{
		fichero_plantilla='Plantilla_Personalizacion_con_adjunto.asp'
		plantilla_personalizacion=plantilla
		}
	  else
	  	{
		if (plantilla.indexOf('plantilla_rotulacion_1')>=0)
			{
			parametros_rotulacion=plantilla.split('--')
			fichero_plantilla='Plantilla_Personalizacion_Rotulacion.asp'
			plantilla_personalizacion=parametros_rotulacion[0]
			texto_campos='&campos=' + parametros_rotulacion[1]
			}
		  else
		  	{
			if (plantilla.indexOf('plantilla_rotulacion_3')>=0)
				{
				parametros_rotulacion=plantilla.split('--')
				fichero_plantilla='Plantilla_Personalizacion_Rotulacion_3.asp'
				plantilla_personalizacion=parametros_rotulacion[0]
				texto_campos='&campos=' + parametros_rotulacion[1]
				}
			  else			  
			  	{
				if (plantilla.indexOf('plantilla_rotulacion_4')>=0)
					{
					parametros_rotulacion=plantilla.split('--')
					fichero_plantilla='Plantilla_Personalizacion_Rotulacion_4.asp'
					plantilla_personalizacion=parametros_rotulacion[0]
					texto_campos='&campos=' + parametros_rotulacion[1]
					}
				  else
				  	{
					fichero_plantilla='Plantilla_Personalizacion.asp'
					plantilla_personalizacion=plantilla
					}
				}
			}
		
		
		
		
		}
	
	texto_querystring='?plant=' + plantilla_personalizacion + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad + '&modo=CONSULTAR&carpeta=GAG' + texto_campos
		
	url_iframe='../Plantillas_Personalizacion/' + fichero_plantilla + texto_querystring
	
	
	$("#cabecera_nueva_plantilla").html('Plantilla a Rellenar');
    
    $('#iframe_nueva_plantilla').attr('src', url_iframe)
    $("#capa_nueva_plantilla").modal("show");
	
	
	
	
}



//para mostrar las capas de las plantillas de personalizacon de articulos
function mostrar_capas(capa, plantilla, cliente, anno_pedido, pedido, articulo, cantidad)
{
	//redondear capa para el internet explorer
	//DD_roundies.addRule('#contenedorr3', '20px');
	/*
	var heights = window.innerHeight;
	console.log('altura ventana: ' + window.innerHeight)
	console.log('altura ventana con jquery: ' + $(window).height())
	console.log('altura opaca: ' + document.getElementById("capa_opaca").style.height )
	
	console.log('document.documentElement.clientHeight: ' + document.documentElement.clientHeight)
    console.log('document.body.scrollHeight: ' + document.body.scrollHeight)
    console.log('document.documentElement.ssrollHeight: ' + document.documentElement.scrollHeight)
    console.log('document.body.offsetHeight: ' + document.body.offsetHeight)
    console.log('document.documentElement.offsetHeight: ' + document.documentElement.offsetHeight)
	
	*/
    document.getElementById("capa_opaca").style.height = (document.body.scrollHeight + 20) + "px";
	document.getElementById('capa_opaca').style.visibility='visible'
	
	texto_querystring='?plant=' + plantilla + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad + '&modo=CONSULTAR&carpeta=GAG'
	document.getElementById('iframe_plantillas').src='../Plantillas_Personalizacion/Plantilla_Personalizacion.asp' + texto_querystring
	document.getElementById(capa).style.visibility='visible';
	
	
	
}

function cerrar_capas(capa)
{	
	document.getElementById('capa_opaca').style.visibility='hidden';
	document.getElementById(capa).style.visibility='hidden';
	
	
}
</script>


<script type="text/javascript"> 

function mostrar_detalle(pedido)
{
	document.getElementById('detalle').src='Pedido_Detalles_Gag.asp?pedido=' + pedido + '&emp=<%=empleado_gls%>'

/*no redimensiona bien en firefox, asi que utilizamos otro plugin
  $('#detalle').iframeAutoHeight({
  		minHeight: 240, // Sets the iframe height to this value if the calculated value is less
		heightOffset: 0, // Optionally add some buffer to the bottom
		//debug: true, 
		animate: true,
		diagnostics: false
  });
*/

$('#detalle').iframeHeight();
}


var flecha; 

function detener() 
{ 
   clearInterval(flecha); 
} 

function subir() 
{ 
    flecha=setInterval(function(){ 
  document.getElementById("contenidos").scrollTop -=8; 
  },50); 
} 

function bajar() 
{ 
{ 
    flecha=setInterval(function(){ 
  document.getElementById("contenidos").scrollTop +=8; 
  },50); 
} 
} 

function a_ver_todos()
	{
		//console.log('a ver todos')
		$("#ocultover_todos_registros").val('SI')
		$("#frmconsulta_pedidos").submit()
	}
</script> 

<script src="DD_roundies_0_0_2a.js"></script>
<script src="../funciones.js" type="text/javascript"></script>


<!--PARA LA ANIMACION DE METER LA IMAGEN DEL ARTICULO EN EL CARRITO DE LA COMPRA-->		
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<!--no redimensiona bien en firefox, asi que utilizamos otro plugin
<script type="text/javascript" src="../plugins/iframe_autoheight/jquery.browser.js"></script>
<script type="text/javascript" src="../plugins/iframe_autoheight/jquery.iframe-auto-height.plugin.1.9.5.js"></script>
-->
<script type="text/javascript" src="../plugins/iframe_autoheight_2/iframeheight.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<script type="text/javascript" src="../plugins/datetime-moment/moment-with-locales.js"></script>
<script type="text/javascript" src="../plugins/datepicker/js/bootstrap-datetimepicker.js"></script>



</head>
<body style="background-color:<%=session("color_asociado_empresa")%>">


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

<!-- capa nuevas plantillas -->
  <div class="modal fade" id="capa_nueva_plantilla">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_nueva_plantilla"></h4>	    
        </div>	    
        <div class="modal-body">
          <form class="form-horizontal row-border">
            <div class="form-group">
              <!--
              <iframe id='gmv.iframe_movilidad' src="" width="100%" height="0" frameborder="0" transparency="transparency" onload="gmv.redimensionar_iframe(this);"></iframe>
              -->
              
              <iframe id='iframe_nueva_plantilla' src="" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe> 	
             </div>                  
          </form>
        </div> <!-- del modal-body-->     
        
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa nuevas plantillas -->    



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
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=consulta_pedidos_gag_pantalla_avisos_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->

<script language="javascript">
	cadena='<div align="center"><br><br><img src="../images/loading4.gif"/><br /><br /><h4><%=consulta_pedidos_gag_ventana_mensajes_espera%></h4><br></div>'
	$("#cabecera_pantalla_avisos").html("<%=consulta_pedidos_gag_ventana_mensajes_cabezera_avisos%>")
	$("#pantalla_avisos .modal-header").show()
	$("#body_avisos").html(cadena + "<br><br>");
	$("#pantalla_avisos").modal("show");
	
	
</script>

<%response.flush()%>
<div class="container-fluid">
   <!--PANTALLA-->
  <div class="row">
    <!--COLUMNA IZQUIERDA -->
    <div class="col-xs-12 col-sm-12 col-md-4 col-lg-3 col-xl-3" id="columna_izquierda">
	


			  <!--DATOS DEL CLIENTE-->
			  <div class="panel panel-default">
				<div class="panel-body">
					<div class="col-md-12">
						<%
						nombre_logo="logo_" & session("usuario_carpeta") & ".png"
						if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
							nombre_logo="Logo_GLS.png"
						end if
						%>
						<div align="center"><img class="img-responsive" src="Images/<%=nombre_logo%>" style="max-height:90px"/></div>
						<br />
						
						<%if empleado_gls="SI" then%>
							<div align="left">
								<b><%=session("usuario_directorio_activo_nombre")%>&nbsp;<%=session("usuario_directorio_activo_apellidos")%></b>
					  		</div>
							<br />
						<%end if%>
						
						<div align="left">
							<%if session("usuario_codigo_empresa")<>260 then%>
								<b><%=session("usuario_empresa")%></b>
								<%if session("usuario_codigo_externo") <> "" then%>
									<b>&nbsp;-&nbsp;<%=session("usuario_codigo_externo")%></b>
								<%end if%>
								<br />
							<%end if%>
							<b><%=session("usuario_nombre")%></b>
							<br />
							<%if session("usuario_codigo_empresa")<>260 then%>
								<%=session("usuario_tipo")%>
								<br />
							<%end if%>
							<%=session("usuario_direccion")%>
							<br /> 
							<%=session("usuario_poblacion")%>
							<br />
							<%=session("usuario_cp")%>&nbsp;<%=session("usuario_provincia")%>
							<br />
							<%=session("usuario_pais")%>
							<br />
							Tel: <%=session("usuario_telefono")%>
							<br />
							Fax: <%=session("usuario_fax")%>
							<br />
						</div>
					</div>
				</div>
			  </div>
	
	
			  <!--DATOS DEL PEDIDO-->
			  <div class="panel panel-default">
				<div class="panel-heading"><b><%=consulta_pedidos_gag_panel_datos_pedido_cabecera%></b></div>
				<div class="panel-body">
					<div class="col-md-12">
						<div align="center" style="padding-bottom:6px ">
							<div style="display:inline-block"><span><img src="../images/Carrito_48x48.png" border="0" class="shopping-cart"/></span></div>
	
							<!-- NO BORRAR, es la capa que añade articulos al pedido....-->
							<div style="display:inline-block" id="capa_annadir_articulo">&nbsp;<b><%=session("numero_articulos")%></b> <%=consulta_pedidos_gag_panel_datos_pedido_articulos%></div>
						</div>
				
						<div align="center">	
							<button type="button" id="cmdver_pedido" name="cmdver_pedido" class="btn btn-primary btn-sm">
									<i class="glyphicon glyphicon-list-alt"></i>
									<span><%=consulta_pedidos_gag_panel_datos_pedido_boton_ver%></span>
							</button>
							<button type="button" id="cmdborrar_pedido" name="cmdborrar_pedido" class="btn btn-primary btn-sm">
									<i class="glyphicon glyphicon-remove"></i>
									<span><%=consulta_pedidos_gag_panel_datos_pedido_boton_borrar%></span>
							</button>
						</div>
					</div>
				</div>
			  </div>
			  
			<%if session("usuario_codigo_empresa")<>4 then%>
				  <!--PEDIDOS REALIZADOS-->
				  <div class="panel panel-default">
					<div class="panel-heading"><b><%=consulta_pedidos_gag_panel_pedidos_cabecera%></b></div>
					<div class="panel-body">
						<div align="center" class="col-md-12">	
							<button type="button" id="cmdconsultar_pedidos" name="cmdconsultar_pedidos" class="btn btn-primary btn-sm">
									<i class="glyphicon glyphicon-search"></i>
									<span>Consultar</span>
							</button>
						</div>
					</div>
				  </div>
				<%end if%>
						  
				<div class="row mt-5">
					<div class="col-12 m-0">
						<button type="button" id="cmdir_carrito" name="cmdir_carrito" class="btn btn-primary btn-block btn-sm">
								<i class="fas fa-shopping-cart"></i>
								<span>Ir Al Carrito</span>
						</button>
					</div>
				</div>		  
						  
	  
    </div>
    <!--FINAL COLUMNA DE LA IZQUIERDA-->
    
    <!--COLUMNA DE LA DERECHA-->
    <div class="col-xs-12 col-sm-12 col-md-8 col-lg-9 col-xl-9">
		<%if session("usuario_codigo_empresa")=4 then%>
			<!-- BOTONES PARA CONSULTAR PEDIDOS, DEVOLUCIONES Y SALDOS-->
			<div class="panel panel-default">
		        <div class="panel-body">
					<div class="row">
						<div class="col-lg-3" align="center">
							<button type="button" id="cmdconsultar_pedidos" name="cmdconsultar_pedidos" class="btn btn-primary btn-block btn-sm">
								<div>
								  <span class="fas fa-box-open icono_boton_"></span>
								  <span class="texto_boton_">&nbsp;Consultar Pedidos</span>
								</div>
							</button>
						</div>
						<div class="col-lg-3" align="center">
							<button type="button" id="cmdconsultar_devoluciones" name="cmdconsultar_devoluciones" class="btn btn-primary btn-block btn-sm">
									<div>
										<span class="fas fa-reply"></span>
										<span class="texto_boton-">&nbsp;Consultar Devoluciones</span>
										<%if dinero_disponible_devoluciones<>0 then%>
											<span class="dinero_disponible">&nbsp;<%=dinero_disponible_devoluciones%>€&nbsp;</span>
										<%end if%>
									</div>
							</button>
						</div>
						
						<%if empleado_gls<>"SI" then%>
							<%if session("usuario_tipo")<>"GLS PROPIA" then%>
								<div class="col-lg-3" align="center">
									<button type="button" id="cmdconsultar_saldos" name="cmdconsultar_saldos" class="btn btn-primary btn-block  btn-sm">
											<div>
												<i class="fas fa-money-bill-wave"></i>
												<span class="texto_boton-">&nbsp;Consultar Saldos</span>
												<%if dinero_disponible_saldos<>0 then%>
													<span class="dinero_disponible">&nbsp;<%=dinero_disponible_saldos%>€&nbsp;</span>
												<%end if%>
											</div>
									</button>
								</div>
							<%end if%>
							<div class="col-lg-3" align="center">
								<button type="button" name="cmdimpresoras" id="cmdimpresoras" class="btn btn-primary btn-block btn-sm">
									<i class="fas fa-print"></i> Gestión Impresoras
								</button>
							</div>
						<%end if%>
					</div>
				</div>
			</div>
			<!-- pedidos, devoluciones y saldos-->
		<%end if%>
	
      <div class="panel panel-default">
        <div class="panel-heading"><span class='fontbold'><%=consulta_pedidos_gag_panel_lista_pedidos_cabecera%></span></div>
        <div class="panel-body">
			<div class="well well-sm">
				<form id="frmconsulta_pedidos" name="frmconsulta_pedidos" action="Consulta_Pedidos_Gag.asp?emp=<%=empleado_gls%>" method="post">
						<input type="hidden" id="ocultover_todos_registros" name="ocultover_todos_registros" value="" />
						<div class="form-group row">    
							<label class="col-md-2 control-label" title="<%=consulta_pedidos_gag_panel_lista_pedidos_filtro_num_pedido_alter%>"><%=consulta_pedidos_gag_panel_lista_pedidos_filtro_num_pedido%></label>	                
							<div class="col-md-2">
								<input type="text" class="form-control" size="8" name="txtpedido" id="txtpedido" value="<%=numero_pedido_seleccionado%>" />
							</div>
							<label class="col-md-2 control-label"><%=consulta_pedidos_gag_panel_lista_pedidos_filtro_estado%></label>	                
							<div class="col-md-6">
								<select class="form-control" name="cmbestados" id="cmbestados" size="1">
									<option value=""  selected="selected"><%=consulta_pedidos_gag_panel_lista_pedidos_filtro_estado_combo_seleccionar%></option>
									<%if session("usuario_codigo_empresa")=260 then%>
										<option value="PENDIENTE PAGO">PENDIENTE PAGO</option>
									<%end if%>
									<%if session("usuario_codigo_empresa")=4 then
											IF session("usuario_tipo")="AGENCIA" THEN%>
													<option value="PENDIENTE PAGO">PENDIENTE PAGO</option>
												<%else%>
													<option value="PENDIENTE AUTORIZACION">PENDIENTE AUTORIZACION</option>
											<%end if%>
											<option value="RESERVADO">RESERVADO</option>
										<%else
											'UVE, HOSPES y GENERAL CARRITO no tiene este estado, directamente Los pedidos van a sin tratar para UVE y HOSPES
											' y a pendiente de pago en GENERAL CARRITO
											if session("usuario_codigo_empresa")<>150 AND session("usuario_codigo_empresa")<>260 AND session("usuario_codigo_empresa")<>280 then%>
												<option value="PENDIENTE AUTORIZACION">PENDIENTE AUTORIZACION</option>
											<%end if%>
									<%end if%>
									<option value="SIN TRATAR">SIN TRATAR</option>
									<option value="RECHAZADO">RECHAZADO</option>
									<option value="EN PROCESO">EN PROCESO</option>
									<option value="PENDIENTE CONFIRMACION">PENDIENTE CONFIRMACION</option>
									<option value="EN PRODUCCION">EN PRODUCCION</option>
									<option value="ENVIADO">ENVIADO</option>
								</select>
								<%if estado_seleccionado<>"" then%>
									<script language="javascript">
										document.getElementById("cmbestados").value='<%=estado_seleccionado%>'
									</script>
								<%end if%>
							</div>
						</div>  
						
						<div class="form-group row">
							<label class="col-md-2 control-label" title="<%=consulta_pedidos_gag_panel_lista_pedidos_filtro_fecha_inicio_alter%>"><%=consulta_pedidos_gag_panel_lista_pedidos_filtro_fecha_inicio%></label>	                
						  	<div class="col-md-4">
								<div class="input-group date" id="fecha_inicio">
								  <input type="Text" class="form-control" name="txtfecha_inicio" id="txtfecha_inicio" value="<%=fecha_i%>" size=7>
								  <span class="input-group-addon"><i class="glyphicon glyphicon-calendar text-primary" title="<%=consulta_pedidos_gag_panel_lista_pedidos_filtro_fecha_inicio_calendar_alter%>"></i></span>
								</div>
								<script type="text/javascript">
									$(function () {
										$('#fecha_inicio').datetimepicker({
											format: 'DD/MM/YYYY'
											});
									});
									
								</script>
							</div>
							
							<label class="col-md-2 control-label" title="<%=consulta_pedidos_gag_panel_lista_pedidos_filtro_fecha_fin_alter%>"><%=consulta_pedidos_gag_panel_lista_pedidos_filtro_fecha_fin%></label>	                
						  	<div class="col-md-4">
								<div class="input-group date" id="fecha_fin">
								  <input type="Text" class="form-control" name="txtfecha_fin" id="txtfecha_fin" value="<%=fecha_f%>" size=7>
								  <span class="input-group-addon"><i class="glyphicon glyphicon-calendar text-primary" title="<%=consulta_pedidos_gag_panel_lista_pedidos_filtro_fecha_fin_calendar_alter%>"></i></span>
								</div>
								<script type="text/javascript">
									$(function () {
										$('#fecha_fin').datetimepicker({
											format: 'DD/MM/YYYY'
											});
									});
								</script>
							</div>
							  
						  
							<div class="col-md-2">
							  <button type="submit" name="Action" id="Action" class="btn btn-primary btn-sm">
									<i class="glyphicon glyphicon-search"></i>
									<span><%=consulta_pedidos_gag_panel_lista_pedidos_boton_buscar%></span>
							  </button>
							</div>

						
						
						
						</div>
						
					</form>
				</div>
		
		
		
		
		
				<form name="frmpedido" id="frmpedido" action="" method="post">
					<table  class="col-md-12">
						<tr>
							<td align="center">
								<a href="#" onMouseOver="subir()" onMouseOut="detener()"  style="text-decoration:none " 
									data-toggle="popover" 
									title=""
									data-placement="top"
									data-trigger="hover"
									data-content="<%=consulta_pedidos_gag_panel_lista_pedidos_img_ascender%>"
									><i class="glyphicon glyphicon-chevron-up btn-lg"></i></a>
							</td>
						</tr>
						<tr>
							<td>
								<div id="contenidos" style="height:200px; overflow:hidden">
									<table class="table table-hover"> 
										<thead> 
											<tr> 
												<th title="<%=consulta_pedidos_gag_panel_lista_pedidos_cabecera_columna_num_pedido_alter%>"><%=consulta_pedidos_gag_panel_lista_pedidos_cabecera_columna_num_pedido%></th> 
												<th ><%=consulta_pedidos_gag_panel_lista_pedidos_cabecera_columna_fecha%></th> 
												<th style="text-align:center"><%=consulta_pedidos_gag_panel_lista_pedidos_cabecera_columna_estado%></th> 
												<th style="text-align:center"><%=consulta_pedidos_gag_panel_lista_pedidos_cabecera_columna_accion%></th> 
												<th style="text-align:center">Inf. Adicional</th> 
											</tr> 
										</thead> 
										<tbody> 
											
											<%
											total_registros_busqueda=0
											if pedidos.eof then%>
												<tr> 
													<td align="center" colspan="5"><h5><%=consulta_pedidos_gag_panel_lista_pedidos_no_hay_pedidos%></h5><br></td>
												</tr>
											  <%else
											  		total_registros_busqueda=pedidos("total_registros")
											end if%>
											
											
											<%while not pedidos.eof%>
												<%if numero_registros=200 then
														response.Flush()
														numero_registros=0
													else
														numero_registros=numero_registros + 1
												end if%>
												
												<tr valign="top">
													<td width="107" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("id")%></td>
													<td width="113" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("fecha_corta")%></td>
													<td width="183" align="center" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("estado_formateado")%>
														<%IF pedidos("fechas_valija")<>"" THEN%>
																<i class="glyphicon glyphicon-exclamation-sign" style="color:#FF0000;cursor:pointer"
																	data-toggle="popover" 
																	title="Env&iacute;o Programado Para Las Fechas:" 
																	data-placement="top" 
																	data-trigger="hover"
																	data-content="<%=REPLACE(pedidos("fechas_valija"), ";","<br>")%>"></i>
															<%else
																IF pedidos("ESTADO_FORMATEADO")="ENVIADO" THEN%>
																	<i class="glyphicon glyphicon-exclamation-sign" style="visibility:hidden"></i>
																<%end if
														END IF%>
													
													</td>
													<td width="211" valign="top">
														<%'veo el caso HOSPES para mostar botones o no 
														if session("usuario_codigo_empresa")=280 then
																if pedidos("estado_formateado")="SIN TRATAR" then%>
																		<button type="button" class="btn btn-danger btn-sm" title="<%=consulta_pedidos_gag_panel_lista_pedidos_boton_quitar_alter%>" onclick="borrar_pedido(<%=pedidos("id")%>,'<%=pedidos("fecha")%>')" >
																			<i class="glyphicon glyphicon-remove"></i>
																			<span>&nbsp;<%=consulta_pedidos_gag_panel_lista_pedidos_boton_quitar%></span>
																		</button>
																		<button type="button" class="btn btn-primary btn-sm" title="<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>)">
																			<i class="glyphicon glyphicon-pencil"></i>
																			<span>&nbsp;<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar%></span>
																		</button>
																<%end if
														end if%>
														
														<%'veo el caso GENERAL CARRITO para mostar botones o no 
														if session("usuario_codigo_empresa")=260 then
																if pedidos("estado_formateado")="PENDIENTE PAGO" then%>
																		<button type="button" class="btn btn-danger btn-sm" title="<%=consulta_pedidos_gag_panel_lista_pedidos_boton_quitar_alter%>" onclick="borrar_pedido(<%=pedidos("id")%>,'<%=pedidos("fecha")%>')" >
																			<i class="glyphicon glyphicon-remove"></i>
																			<span>&nbsp;<%=consulta_pedidos_gag_panel_lista_pedidos_boton_quitar%></span>
																		</button>
																		<button type="button" class="btn btn-primary btn-sm" title="<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>)">
																			<i class="glyphicon glyphicon-pencil"></i>
																			<span>&nbsp;<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar%></span>
																		</button>
																<%end if
														end if%>
													
														<%'veo el caso de ASM para mostar botones o no 
														if session("usuario_codigo_empresa")=4 then
																if pedidos("estado_formateado")="PENDIENTE PAGO" or pedidos("estado_formateado")="PENDIENTE AUTORIZACION"  or pedidos("estado_formateado")="AUTORIZACION NUEVA APERTURA"then%>
																		<button type="button" class="btn btn-danger btn-sm" title="<%=consulta_pedidos_gag_panel_lista_pedidos_boton_quitar_alter%>" onclick="borrar_pedido(<%=pedidos("id")%>,'<%=pedidos("fecha")%>')" >
																			<i class="glyphicon glyphicon-remove"></i>
																			<span>&nbsp;<%=consulta_pedidos_gag_panel_lista_pedidos_boton_quitar%></span>
																		</button>
																		<button type="button" class="btn btn-primary btn-sm" title="<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>)">
																			<i class="glyphicon glyphicon-pencil"></i>
																			<span>&nbsp;<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar%></span>
																		</button>
																<%end if%>
																<%if pedidos("estado_formateado")="PENDIENTE FIRMA" then%>
																		<button type="button" class="btn btn-primary btn-sm" title="<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>)">
																			<i class="glyphicon glyphicon-pencil"></i>
																			<span>&nbsp;<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar%></span>
																		</button>
																<%end if%>
																<%' estas 
																	'	406 ASM TETUAN (4674) 
																	'	739 MATARO NEW (7970)
																	'	526 GLS CORNELLA-MATARO (10264)
																	' son franquicias no una oficina propia	
																	' y es un caso especial, una franquicia, pero se graba en sin tratar
																if pedidos("estado_formateado")="SIN TRATAR" and (session("usuario")=4674 or session("usuario")=7970 or session("usuario")=10264) then%>
																		<button type="button" class="btn btn-danger btn-sm" title="<%=consulta_pedidos_gag_panel_lista_pedidos_boton_quitar_alter%>" onclick="borrar_pedido(<%=pedidos("id")%>,'<%=pedidos("fecha")%>')" >
																			<i class="glyphicon glyphicon-remove"></i>
																			<span>&nbsp;<%=consulta_pedidos_gag_panel_lista_pedidos_boton_quitar%></span>
																		</button>
																		<button type="button" class="btn btn-primary btn-sm" title="<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>)">
																			<i class="glyphicon glyphicon-pencil"></i>
																			<span>&nbsp;<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar%></span>
																		</button>
																<%end if%>
	
															<%else ' resto de casos diferentes a ASM%>
													
																	<%
																	'veo si todos los articulos del pedido estan en PENDIENTE AUTORIZACION, si es asi, dejo que se borre y modifique
																	set articulos_pedido=Server.CreateObject("ADODB.Recordset")
																	with articulos_pedido
																		.ActiveConnection=connimprenta
																		'CON LA INTEGRACION EN AVORIS, SE MODIFICA EN PENDIENTE DE AUTORIZACION
																		'GEOMOON solo puede modificar el pedido en PENDIENTE DE AUTORIZACION
																		'if session("usuario_codigo_empresa")<>130 then
																		'	.Source="SELECT * FROM PEDIDOS WHERE ID=" & pedidos("id") & " AND ESTADO<>'PENDIENTE AUTORIZACION' AND ESTADO<>'SIN TRATAR'"
																		'  else
																		' 	.Source="SELECT * FROM PEDIDOS WHERE ID=" & pedidos("id") & " AND ESTADO<>'PENDIENTE AUTORIZACION'"
																		'end if
																		.Source="SELECT * FROM PEDIDOS WHERE ID=" & pedidos("id") & " AND ESTADO<>'PENDIENTE AUTORIZACION'"
																		'response.write("<br>" & .source)
																		.Open
																	end with
																	
																	if articulos_pedido.eof then
																	%>
																		<button type="button" class="btn btn-danger btn-sm" title="<%=consulta_pedidos_gag_panel_lista_pedidos_boton_quitar_alter%>" onclick="borrar_pedido(<%=pedidos("id")%>,'<%=pedidos("fecha")%>')" >
																			<i class="glyphicon glyphicon-remove"></i>
																			<span>&nbsp;<%=consulta_pedidos_gag_panel_lista_pedidos_boton_quitar%></span>
																		</button>
																		<button type="button" class="btn btn-primary btn-sm" title="<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>)">
																			<i class="glyphicon glyphicon-pencil"></i>
																			<span>&nbsp;<%=consulta_pedidos_gag_panel_lista_pedidos_boton_modificar%></span>
																		</button>
																		
																	<%
																	end if
																	articulos_pedido.close
																	set articulos_pedido=Nothing
																	%>
														<%end if%>
														<%	
														if pedidos("estado_formateado")="ENVIO PARCIAL" or pedidos("estado_formateado")="ENVIADO" then
															set albaranes=Server.CreateObject("ADODB.Recordset")													
															set facturas=Server.CreateObject("ADODB.Recordset")
															
															with albaranes
																.ActiveConnection=connimprenta
																.Source="SELECT * FROM V_DATOS_ALBARANES"
																.Source= .Source & "  WHERE NPEDIDO = '" & pedidos("id") & "'"
																.Source= .Source & "  AND ANULADO=0"
																
																if ver_cadena="SI" then
																	response.write("<br>albaranes: " & .source)
																end if
																.Open
															end with
															
															if not albaranes.eof then
																while not albaranes.eof
																%>
																	  <svg class="octicon octicon-package  text-success" viewBox="0 0 16 16" version="1.1" height="16" width="16" aria-hidden="true" style="cursor:pointer;vertical-align:top"
																			data-toggle="popover" 
																			title="" 
																			data-placement="top" 
																			data-trigger="hover"
																			data-content="Albar&aacute;n&nbsp;<%=albaranes("IDALBARAN")%>" onclick="ver_albaran(<%=albaranes("IDALBARAN")%>)"
																			>
																		<path fill-rule="evenodd" d="M1 4.27v7.47c0 .45.3.84.75.97l6.5 1.73c.16.05.34.05.5 0l6.5-1.73c.45-.13.75-.52.75-.97V4.27c0-.45-.3-.84-.75-.97l-6.5-1.74a1.4 1.4 0 0 0-.5 0L1.75 3.3c-.45.13-.75.52-.75.97zm7 9.09l-6-1.59V5l6 1.61v6.75zM2 4l2.5-.67L11 5.06l-2.5.67L2 4zm13 7.77l-6 1.59V6.61l2-.55V8.5l2-.53V5.53L15 5v6.77zm-2-7.24L6.5 2.8l2-.53L15 4l-2 .53z"></path>
																	  </svg>
																	  
																<%
																	albaranes.movenext
																wend
	
																albaranes.close
																set albaranes=Nothing
															end if
															
															
															
															with facturas
																.ActiveConnection=connimprenta
																.Source="SELECT a.Factura, a.EjercicioFactura, b.fecha_cierre"
																.Source= .Source & " FROM V_DATOS_ALBARANES a"
																.Source= .Source & " left join V_DATOS_FACTURAS b"
																.Source= .Source & " on (a.factura=b.idfactura"
																.Source= .Source & " and a.ejerciciofactura=b.ejercicio)"
																.Source= .Source & " WHERE (a.IdAlbaran in ("
																.Source= .Source & " SELECT ALBARAN FROM PEDIDOS_DETALLES"
																.Source= .Source & " WHERE ID_PEDIDO=" & pedidos("id") & "))"
																.Source= .Source & " group by a.factura, a.ejerciciofactura,b.fecha_cierre"
																.Source= .Source & " having b.fecha_cierre is not null"
																
																
																
																'response.write("<br>facturas: " & .source)
																.Open
															end with
															
															
															
															cadena_facturas=""
															if not facturas.eof then%>
																&nbsp;&nbsp;&nbsp;&nbsp;
																<%while not facturas.eof%>
																	<i class="far fa-file-alt fa-lg text-danger" style="cursor:pointer"
																			data-toggle="popover" 
																			data-original-title="" 
																			data-placement="top" 
																			data-trigger="hover"
																			data-content="Factura&nbsp;<%=facturas("Factura")%>"
																			onclick="ver_factura(<%=facturas("Factura")%>, <%=facturas("EjercicioFactura")%>)"
																			></i>
																<%
																	facturas.movenext
																wend
	
															end if
													
															facturas.close
															set facturas=Nothing
														end if
														%>
														
														
														
													</td>
													<td>
														<%
														if pedidos("pedido_automatico")="GLOBALBAG" then
															response.write("MALETAS GLOBALBAG")
														end if
														%>
													
													</td>
												</tr>
												
												<%		
												pedidos.movenext
												Wend
												%>
												<%if ver_todos_registros<>"SI" AND total_registros_busqueda>grupo_registros then%>
													<tr>
														<td align="center" colspan="4">
															<i class="glyphicon glyphicon-plus btn-lg text-success" style="cursor:pointer "
																data-toggle="popover" 
																title=""
																data-placement="top"
																data-trigger="hover"
																data-content="Solo se han mostrado los <%=grupo_registros%> primeros resultados. Pulse aqu&iacute; si quiere verlos todos"
																onclick="a_ver_todos()"></i>
														</td>
													</tr>
												<%end if%>
											
										</tbody> 
									</table>
								</div>
							
							</td>
						</tr>
						<tr>
							<td align="center">
                              <a href="#" onmouseover="bajar()" onmouseout="detener()"  style="text-decoration:none " 
								  	data-toggle="popover" 
									title=""
									data-placement="top"
									data-trigger="hover"
									data-content="<%=consulta_pedidos_gag_panel_lista_pedidos_img_descender%>"
									><i class="glyphicon glyphicon-chevron-down btn-lg"></i></a> </td>
						</tr>
					</table>
				</form>

        </div><!--panel-body-->
      </div><!--panel-->


		<!--PEDIDOS REALIZADOS-->
	  <div class="panel panel-default">
	  	<div class="panel-body">
			<iframe class="col-sm-12"  width="100%" id="detalle" name="detalle" src="Pedido_Detalles_Gag.asp?emp=<%=empleado_gls%>" scrolling="no" frameborder="0" allowtransparency="yes"></iframe> 
		</div>
	  </div>

    </div>
    <!--FINAL COLUMNA DE LA DERECHA-->
  </div>    
  <!-- FINAL DE LA PANTALLA -->
</div>
<!--FINAL CONTAINER-->

<script language="javascript">
	$("#pantalla_avisos").modal("hide");
</script>


<script language="javascript">
$("#cmdver_pedido").on("click", function () {
	location.href='Carrito_Gag.asp?acciones=<%=accion%>&emp=<%=empleado_gls%>'
});

$("#cmdborrar_pedido").on("click", function () {
	pagina_url='Vaciar_Carrito_Gag.asp'
	parametros=''
	mostrar_capa(pagina_url,'capa_annadir_articulo', parametros)
	
	cadena='<BR><BR><H4><%=consulta_pedidos_gag_pantalla_avisos_carrito_vaciado%></H4><BR><BR>'
	$("#cabecera_pantalla_avisos").html("<%=consulta_pedidos_gag_pantalla_avisos_cabecera%>")
	$("#body_avisos").html(cadena + "<br>");
	$("#botones_avisos").html('<p><button type="button" class="btn btn-default" data-dismiss="modal"><%=consulta_pedidos_gag_pantalla_avisos_boton_cerrar%></button></p><br>');                          
		
	$("#pantalla_avisos").modal("show");
	
	
	//location.href='Vaciar_Carrito_Gag.asp'
});

$("#cmdconsultar_pedidos").on("click", function () {
	location.href='Consulta_Pedidos_Gag.asp?emp=<%=empleado_gls%>'
});

$("#cmdconsultar_devoluciones").on("click", function () {
	location.href='Consulta_Devoluciones_Gag.asp?emp=<%=empleado_gls%>'
});

$("#cmdconsultar_saldos").on("click", function () {
	location.href='Consulta_Saldos_Gag.asp'
});
$("#cmdimpresoras").on("click", function () {
	location.href='Consulta_Impresoras_GLS.asp'
});



$("#cmdir_carrito").on("click", function () {
	<%if empleado_gls="SI" then%>
		location.href='Lista_Articulos_Gag_Empleados_GLS.asp'
	<%else%>
		location.href='Lista_Articulos_Gag.asp'
	<%end if%>
});

ver_factura = function(factura, ejercicio) {
	//console.log('factura: ' + factura)
	//console.log('ejercicio: ' + ejercicio)
	
	
	$.ajax({
            type: "POST",
            contentType: "application/json; charset=UTF-8",
            async: false,
            url: "../Genfactura/wsGag_1.asmx/ImprimeFactura",
            data: '{idFactura: '+ factura +   
                ', Ejercicio: ' + ejercicio +
            '}',
            dataType: "json",
            success:
                function (data) {
					//alert('Se ha generdo la factura ' + factura);
					var win = window.open('', '_blank');
				    win.location.href = '../GenFactura/informes/Fact_' + factura + '_' + ejercicio + '.pdf';	
					//console.log('antes de elimiar factura')
					
					setTimeout(function() {
							//console.log('eliminamos despues del paron')
						    eliminar_factura(factura, ejercicio)
					}, (3 * 1000));
					
				 },
            error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            },
        });

	
	
}; 

ver_albaran = function(albaran) {
	//console.log('factura: ' + factura)
	//console.log('ejercicio: ' + ejercicio)
	
	
	$.ajax({
            type: "POST",
            contentType: "application/json; charset=UTF-8",
            async: false,
            url: "../Genfactura/wsGag_1.asmx/imprimeAlbaran",
            data: '{idAlbaran: '+ albaran + '}',
            dataType: "json",
            success:
                function (data) {
					//alert('Se ha generdo la factura ' + factura);
					var win = window.open('', '_blank');
				    win.location.href = '../GenFactura/informes/Alb_' + albaran + '.pdf';	
					//console.log('antes de elimiar factura')
					
					setTimeout(function() {
							//console.log('eliminamos despues del paron')
						    eliminar_albaran(albaran)
					}, (3 * 1000));
					
				 },
            error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            },
        });

	
	
}; 


eliminar_albaran = function(albaran) {
	//console.log('factura a borrar: ' + factura)
	//console.log('ejercicio a borrar: ' + ejercicio)
	
	parametros='tipo_fichero=ALBARAN&albaran=' + albaran
		
	  $.ajax({
	  	type: "POST",
		contentType: "application/json; charset=UTF-8",
		async: false,
		url: "../GenFactura/Borrar_Albaran_Factura.asp?" + parametros,
		//data: parametros,
		dataType: "json",
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		
		
		/*
		async: false,
		url:'../GenFactura/Borrar_Factura.asp', //Url a donde la enviaremos
		type:'POST', //Metodo que usaremos
		contentType:false, //Debe estar en false para que pase el objeto sin procesar
		//data:data, //Le pasamos el objeto que creamos con los archivos
		data: '{factura: '+ factura +   
                ', ejercicio: ' + ejercicio +
            '}',
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		cache:false, //Para que el formulario no guarde cache
		*/
        error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            }

	  })
	
	
	
}; 


eliminar_factura = function(factura, ejercicio) {
	//console.log('factura a borrar: ' + factura)
	//console.log('ejercicio a borrar: ' + ejercicio)
	
	parametros='tipo_fichero=FACTURA&factura=' + factura + '&ejercicio=' + ejercicio
		
	  $.ajax({
	  	type: "POST",
		contentType: "application/json; charset=UTF-8",
		async: false,
		url: "../GenFactura/Borrar_Albaran_Factura.asp?" + parametros,
		//data: parametros,
		dataType: "json",
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		
		
		/*
		async: false,
		url:'../GenFactura/Borrar_Factura.asp', //Url a donde la enviaremos
		type:'POST', //Metodo que usaremos
		contentType:false, //Debe estar en false para que pase el objeto sin procesar
		//data:data, //Le pasamos el objeto que creamos con los archivos
		data: '{factura: '+ factura +   
                ', ejercicio: ' + ejercicio +
            '}',
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		cache:false, //Para que el formulario no guarde cache
		*/
        error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            }

	  })
	
	
	
}; 


$(document).ready(function () {

  //Tooltip, activated by hover event
 /*
  $("body").tooltip({   
    selector: "[data-toggle='tooltip']",
    container: "body"
  })

  //Popover, activated by clicking
    .popover({
    selector: "[data-toggle='popover']",
    container: "body",
    html: true
  });
  //They can be chained like the example above (when using the same selector).
*/

    $('[data-toggle="popover"]').popover({html:true});   

});
</script>

<form action="Eliminar_Pedido_Gag.asp?emp=<%=empleado_gls%>" method="post" name="frmborrar_pedido" id="frmborrar_pedido">
	<input type="hidden" id="ocultopedido_a_borrar" name="ocultopedido_a_borrar" value="" />
	<input type="hidden" id="ocultofecha_pedido" name="ocultofecha_pedido" value="" />
</form>

<form action="Rellenar_Variables_Sesion_Gag.asp?emp=<%=empleado_gls%>" method="post" name="frmmodificar_pedido" id="frmmodificar_pedido">
	<input type="hidden" id="ocultopedido_a_modificar" name="ocultopedido_a_modificar" value="" />
</form>

</body>
<%
	'articulos.close
	
	connimprenta.close
	
	set articulos=Nothing
	
	set connimprenta=Nothing

%>
</html>
