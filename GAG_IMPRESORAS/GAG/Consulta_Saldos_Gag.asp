<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
		response.Buffer=true
		numero_registros=0
		
		
		empleado_gls=Request.Querystring("emp")
		
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
			.Source= .Source & " *, (SELECT STUFF("
            .Source= .Source & " (SELECT ';' + CONVERT(nvarchar(50), FECHAVALIJA, 103)"
			.Source= .Source & " FROM V_DATOS_ALBARANES"
			.Source= .Source & " WHERE NPEDIDO = CONVERT(nvarchar(20),PEDIDOS.ID)"
			.Source= .Source & " ORDER BY FECHAVALIJA"
			.Source= .Source & " FOR XML PATH (''))"
			.Source= .Source & " , 1, 1, '')) AS FECHAS_VALIJA,"
			.Source= .Source & " count(*) over() AS TOTAL_REGISTROS"
			
			.Source= .Source & " FROM PEDIDOS WHERE 1=1"

			if empleado_gls="SI" then
					.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO=" & session("usuario_directorio_activo")
				else			
					.Source= .Source & " AND (CODCLI=" & session("usuario")
					.Source= .Source & " OR CLIENTE_ORIGINAL=" & session("usuario") & ")"
					.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO IS NULL"
			end if
			
			

			if estado_seleccionado<>"" then
				.Source= .Source & " AND ESTADO='" & estado_seleccionado & "'"
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
			
			'response.write("<br>PEDIDOS: " & .source)
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
			'response.write("<br>FAMILIAS: " & .source)
			.Open
		end with

		if not disponible_devoluciones.eof then
			dinero_disponible_devoluciones=disponible_devoluciones("DISPONIBLE")	
		end if
		disponible_devoluciones.close
		set disponible_devoluciones=Nothing



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
			'response.write("<br>SALDOS: " & .source)
			.Open
		end with

		if not disponible_saldos.eof then
			dinero_disponible_saldos=disponible_saldos("DISPONIBLE")	
		end if
		disponible_saldos.close
		set disponible_saldos=Nothing
%>
<html>
<head>
<title><%=consulta_pedidos_gag_title%></title>


	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-select/css/bootstrap-select.min.css">

	<link rel="stylesheet" type="text/css" href="../estilos.css" />	

	<link rel="stylesheet" type="text/css" href="../plugins/datepicker/css/bootstrap-datepicker.css">

	<link rel="stylesheet" type="text/css" href="../plugins/octicons_6_0_1/lib/octicons.css">

	<script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

	<link rel="stylesheet" type="text/css" href="../plugins/datatables/1.10.16/css/dataTables.bootstrap4.min.css"/>
	
	<!--
	<link rel="stylesheet" type="text/css" href="plugins/datatables/1.10.16/css/dataTables.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/DataTables-1.10.18/css/jquery.dataTables.css"/>
	-->
	<link rel="stylesheet" type="text/css" href="../plugins/Datatables_4/AutoFill-2.3.3/css/autoFill.dataTables.min.css"/>
	<link rel="stylesheet" type="text/css" href="../plugins/Datatables_4/Buttons-1.5.6/css/buttons.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="../plugins/Datatables_4/ColReorder-1.5.0/css/colReorder.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="../plugins/Datatables_4/FixedColumns-3.2.5/css/fixedColumns.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="../plugins/Datatables_4/FixedHeader-3.1.4/css/fixedHeader.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="../plugins/Datatables_4/KeyTable-2.5.0/css/keyTable.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="../plugins/Datatables_4/Responsive-2.2.2/css/responsive.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="../plugins/Datatables_4/RowGroup-1.1.0/css/rowGroup.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="../plugins/Datatables_4/RowReorder-1.2.4/css/rowReorder.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="../plugins/Datatables_4/Scroller-2.0.0/css/scroller.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="../plugins/Datatables_4/Select-1.3.0/css/select.dataTables.css"/>

	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-touchspin-master/src/jquery.bootstrap-touchspin.css" />
	
	<%'aplicamos un tipo de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	

    
	
	
	

	
	

	
<style>

	#dialog_detalles_devolucion .modal-dialog  {width:95%;}

  
	
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
  
  
  
  //----------------------------------------
		.table th { font-size: 14px; }
		.table td { font-size: 14px; }
		
		.dataTables_length {float:left;}
		.dataTables_filter {float:right;}
		.dataTables_info {float:left;}
		.dataTables_paginate {float:right;}
		.dataTables_scroll {clear:both;}
		.toolbar {float:left; padding-bottom:2px}    
		div .dt-buttons {float:right; position:relative;}
		//table.dataTable tr.selected.odd {background-color: #9FAFD1;}
		//table.dataTable tr.selected.even {background-color: #B0BED9;}
		
		
		
		//para alinear las celdas y la cabecera
		// esta en v2\plugins\dataTable\media\css\jquery.datatables.css
		// pero si lo incluimos entero muestra iconos innecesarios en la cabecera del datatable
		// salen triangulitos para ordenar ascendente o descendentemente
		table.dataTable th.dt-left,
		table.dataTable td.dt-left {text-align:left}
		
		table.dataTable th.dt-center,
		table.dataTable td.dt-center,
		table.dataTable td.dataTables_empty {text-align:center}
		
		table.dataTable th.dt-right,
		table.dataTable td.dt-right {text-align:right}
		
		table.dataTable th.dt-justify,
		table.dataTable td.dt-justify {text-align:justify}
		
		table.dataTable th.dt-nowrap,
		table.dataTable td.dt-nowrap {white-space:nowrap}
		
		table.dataTable thead th.dt-head-left,
		table.dataTable thead td.dt-head-left,
		table.dataTable tfoot th.dt-head-left,
		table.dataTable tfoot td.dt-head-left {text-align:left}
		
		table.dataTable thead th.dt-head-center,
		table.dataTable thead td.dt-head-center,
		table.dataTable tfoot th.dt-head-center,
		table.dataTable tfoot td.dt-head-center {text-align:center}
		
		table.dataTable thead th.dt-head-right,
		table.dataTable thead td.dt-head-right,
		table.dataTable tfoot th.dt-head-right,
		table.dataTable tfoot td.dt-head-right {text-align:right}
		
		table.dataTable thead th.dt-head-justify,
		table.dataTable thead td.dt-head-justify,
		table.dataTable tfoot th.dt-head-justify,
		table.dataTable tfoot td.dt-head-justify {text-align:justify}
		
		table.dataTable thead th.dt-head-nowrap,
		table.dataTable thead td.dt-head-nowrap,
		table.dataTable tfoot th.dt-head-nowrap,
		table.dataTable tfoot td.dt-head-nowrap {white-space:nowrap}
		
		table.dataTable tbody th.dt-body-left,
		table.dataTable tbody td.dt-body-left {text-align:left}
		
		table.dataTable tbody th.dt-body-center,
		table.dataTable tbody td.dt-body-center {text-align:center}
		
		table.dataTable tbody th.dt-body-right,
		table.dataTable tbody td.dt-body-right {text-align:right}
		
		table.dataTable tbody th.dt-body-justify,
		table.dataTable tbody td.dt-body-justify {text-align:justify}
		
		table.dataTable tbody th.dt-body-nowrap,
		table.dataTable tbody td.dt-body-nowrap {white-space:nowrap}
		
		table.dataTable,
		table.dataTable th,
		table.dataTable td{-webkit-box-sizing:content-box;-moz-box-sizing:content-box;box-sizing:content-box}
		
		table.dataTable tbody tr { cursor:pointer}
		//------------------------------------------
		
		
		

</style>

<style>
      .icono_boton {
        vertical-align: middle;
        font-size: 40px;
      }
      .texto_boton {
        /*font-family: "Courier-new";*/
		font-size: 0.8rem;
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
		font-size: 10px
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
    
	
	texto_querystring='?plant=' + plantilla + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad + '&modo=CONSULTAR&carpeta=GAG'
	if (plantilla=='plantilla_a01')
		{
		url_iframe='../Plantillas_Personalizacion/Plantilla_Personalizacion_con_adjunto.asp' + texto_querystring
		}
	  else
	  	{
		url_iframe='../Plantillas_Personalizacion/Plantilla_Personalizacion.asp' + texto_querystring
		}
	
	
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





</head>
<body style="background-color:<%=session("color_asociado_empresa")%>">

<div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer" id="botones_avisos">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   



<!-- contenido pricipal -->
<div class="container-fluid">
	<div class="row mt-1">
		<!--columna izquiderda-->
		<div class="col-xs-12 col-sm-12 col-md-4 col-lg-3 col-xl-3" id="columna_izquierda___">
			<!--DATOS DEL CLIENTE-->
			<div class="row">
				<div class="col-12 m-0 pr-0">
					<div class="card">
						<div class="card-body">
							<div class="card-text">
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
								
								<div class="text-left">
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
								
								<%
									cabecera_para_impresion="<div>"
									cabecera_para_impresion=cabecera_para_impresion & "<table class=""table table-bordered"">"
									cabecera_para_impresion=cabecera_para_impresion & "<tr><td>Empresa</td><td><b>" & session("usuario_empresa") & "</b></td></tr>"
									cabecera_para_impresion=cabecera_para_impresion & "<tr><td>Cliente</td><td><b>" & session("usuario_nombre") & "</b></td></tr>"
									cabecera_para_impresion=cabecera_para_impresion & "<tr><td>Direccion</td><td><b>" & session("usuario_direccion")
									cabecera_para_impresion=cabecera_para_impresion & "<br />" & session("usuario_poblacion")
									cabecera_para_impresion=cabecera_para_impresion & "<br />" & session("usuario_cp") & " " & session("usuario_provincia")
									cabecera_para_impresion=cabecera_para_impresion & "<br />" & session("usuario_pais") & "</b></td></tr>"
									cabecera_para_impresion=cabecera_para_impresion & "<tr><td>Tlfno.</td><td><b>" & session("usuario_telefono") & "</b></td></tr>"
									cabecera_para_impresion=cabecera_para_impresion & "<tr><td>Fax</td><td><b>" & session("usuario_fax") & "</b></td></tr>"
									cabecera_para_impresion=cabecera_para_impresion & "</table></div>"
									
								%>
								
							</div>
						
						</div>
					</div>
				</div>
			</div>
			
			<!--DATOS DEL PEDIDO-->
			<div class="row mt-2">
				<div class="col-12 m-0 pr-0">
					<div class="card">
						<div class="card-header"><h4 class="card-title">Datos del Pedido</h4></div>
						<div class="card-body">
							<div align="center" style="padding-bottom:6px ">
								<div style="display:inline-block"><span><img src="../images/Carrito_48x48.png" border="0" class="shopping-cart"/></span></div>
		
								<!-- NO BORRAR, es la capa que añade articulos al pedido....-->
								<div style="display:inline-block" id="capa_annadir_articulo">&nbsp;<b><%=session("numero_articulos")%></b> Art&iacute;culos</div>
							</div>
					
							<div align="center">	
								<button type="button" id="cmdver_pedido" name="cmdver_pedido" class="btn btn-primary">
										<i class="fas fa-clipboard-list"></i>
										<span>Ver Pedido</span>
								</button>
								<button type="button" id="cmdborrar_pedido" name="cmdborrar_pedido" class="btn btn-primary">
										<i class="fas fa-times"></i>										
										<span>Borrar Pedido</span>
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- consulta pedidos y devoluciones -->
			<%if session("usuario_codigo_empresa")<>4 then%>
				<div class="row mt-2">
					<div class="col-12 m-0 pr-0">
						<div class="card">
							<div class="card-header"><h5 class="card-title"><b>Pedidos Realizados</b></h5></div>
							<div class="card-body">
								<button type="button" id="cmdconsultar_pedidos" name="cmdconsultar_pedidos" class="btn btn-primary btn-sm">
									<i class="fas fa-search"></i>
									<span>Consultar</span>
								</button>
							</div>
						</div>
					</div>
				</div>
			  <%else%>
			  		<%if session("usuario_tipo")="GLS PROPIA" or empleado_gls="SI" then%>
						<div class="row"> 
							<div class="col-md-6">
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
							</div>			  
							<div class="col-md-6">
								<!--DEVOLUCIONES-->
								<div class="panel panel-default">
									<div class="panel-heading">
										<%if dinero_disponible_devoluciones<>0 then%>
											<b>Devoluc. <font color="blue"><%=dinero_disponible_devoluciones%>€</font></b>
										  <%else%>
											<b>Devoluciones</b>
										<%end if%>
									</div>
									<div class="panel-body">
										<div align="center" class="col-md-12">	
											<button type="button" id="cmdconsultar_devoluciones" name="cmdconsultar_devoluciones" class="btn btn-primary btn-sm">
													<i class="glyphicon glyphicon-search"></i>
													<span>Consultar</span>
											</button>
										</div>
									</div>
								</div>
							</div>			  
						  </div>
					<%end if%>
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
		<!-- fin columna izquierda-->
		
		
		<!--columna derecha-->
		<input type="hidden" id="ocultodevolucion_a_imprimir" name="ocultodevolucion_a_imprimir" value="" />
		<input type="hidden" id="ocultonombre_empleado_a_imprimir" name="ocultonombre_empleado_a_imprimir" value="" />
		<input type="hidden" id="ocultoimprimir_devolucion" name="ocultoimprimir_devolucion" value="" />
		<div class="col-xs-12 col-sm-12 col-md-8 col-lg-9 col-xl-9" id="columna_izquierda__">
			<!--saldos-->
			<%if session("usuario_codigo_empresa")=4 then%>
			<!-- BOTONES PARA CONSULTAR PEDIDOS, DEVOLUCIONES Y SALDOS-->
				<div class="row">
					<div class="col-12 m-0">
						<div class="card">
							<div class="card-body">
								<div class="row">
								<div class="col-lg-3" align="center">
									<button type="button" id="cmdconsultar_pedidos" name="cmdconsultar_pedidos" class="btn btn-primary btn-block btn-sm">
										<div>
										  <span class="fas fa-box-open icono_boton_"></span>
										  <span class="texto_boton">&nbsp;Consultar Pedidos</span>
										</div>
									</button>
								</div>
								<div class="col-lg-3" align="center">
									<button type="button" id="cmdconsultar_devoluciones" name="cmdconsultar_devoluciones" class="btn btn-primary btn-block btn-sm">
											<div>
											  
												<span class="fas fa-reply"></span>
												<span class="texto_boton">&nbsp;Consultar Devoluciones</span>
												<%if dinero_disponible_devoluciones<>0 then%>
													<span class="dinero_disponible">&nbsp;<%=dinero_disponible_devoluciones%>€&nbsp;</span>
												<%end if%>
											</div>
									</button>
								</div>
								<%if session("usuario_tipo")<>"GLS PROPIA" then%>
									<div class="col-lg-3" align="center">
										<button type="button" id="cmdconsultar_saldos" name="cmdconsultar_saldos" class="btn btn-primary btn-block  btn-sm">
												<div>
												  
													<i class="fas fa-money-bill-wave"></i>
													<span class="texto_boton">&nbsp;Consultar Saldos</span>
													<%if dinero_disponible_saldos<>0 then%>
														<span class="dinero_disponible">&nbsp;<%=dinero_disponible_saldos%>€&nbsp;</span>
													<%end if%>
												</div>
										</button>
									</div>
								<%end if%>
								<div class="col-lg-3" align="center">
									<button type="button" name="cmdimpresoras" id="cmdimpresoras" class="btn btn-primary btn-block btn-sm">
										<i class="fas fa-print"></i>
										<span class="texto_boton">&nbsp;Gestión Impresoras</span>
						  			</button>
								</div>
								
								
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- pedidos, devoluciones y saldos-->
			<%end if%>
			
			<div class="row">
				<div class="col-12 pt-1">
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-sm-12 col-md-10 col-lg-10">
								  <h4 class="card-title">Consulta Saldos</h4>
								</div>
								<div class="col-sm-12 col-md-2 col-lg-2">
								  <a href="manuales/Manual_Compensacion_Saldos_GLS.pdf" target="_blank" style="text-decoration:none ">
								  <button type="button" class="btn btn-primary btn-block" id="cmdmanual" name="cmdmanual"
									data-toggle="popover"
									data-placement="top"
									data-trigger="hover"
									data-content="Consultar el Manual de Saldos"
									data-original-title=""
									>
									<i class="fas fa-info-circle"></i>&nbsp;&nbsp;&nbsp;Manual
								  </button>
								  </a>
								</div>
							</div>
						
							<!--primera linea-->
							<div class="form-group row mx-2">
								<div class="col-sm-12 col-md-3 col-lg-3">
									<label for="txtfecha_inicio" class="control-label">Fecha de Inicio</label>
									<input type="date" class="form-control" name="txtfecha_inicio" id="txtfecha_inicio"  value="<%=fecha_i%>" /> 
								</div>
								<div class="col-sm-12 col-md-3 col-lg-3">
									<label for="txtfecha_fin" class="control-label">Fecha Fin</label>
									<input type="date" class="form-control" name="txtfecha_fin" id="txtfecha_fin"  value="<%=fecha_f%>" /> 
								</div>
								<div class="col-sm-12 col-md-2 col-lg-2">
									<label for="cmdconsultar" class="control-label">&nbsp;</label>
									<button type="button" class="btn btn-primary btn-block" id="cmdconsultar" name="cmdconsultar"
										data-toggle="popover"
										data-placement="top"
										data-trigger="hover"
										data-content="Consultar Saldos"
										data-original-title=""
										>
										<i class="fas fa-search"></i>&nbsp;&nbsp;&nbsp;Buscar
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-12 mt-2">
					<div class="card">
						<div class="card-body">
							<table id="lista_articulos_a_devolver" name="lista_articulos_a_devolver" class="table table-striped table-bordered" cellspacing="0" width="98%">
							<thead>
								<tr>
									<th>ID</th>
									<th>Fecha</th>
									<th>Importe</th>
									<th>Ordenante</th>
									<th>Tipo</th>
									<th>Cargo/Abono</th>
									<th>Total Canjeado</th>
									<th>Observaciones</th>
								</tr>
					  		</thead>
							</table>
						
						</div>
					</div>
				</div>
			</div>
			
		
		</div>
		<!-- fin columna derecha-->
	</div>
</div>
<!-- fin del contenido principal-->






<script type="text/javascript" src="../js/comun.js"></script>

<script type="text/javascript" src="../plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>
	
<script type="text/javascript" src="../plugins/popper/popper-1.14.3.js"></script>
    
<script type="text/javascript" src="../plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>



<script src="../funciones.js" type="text/javascript"></script>


<script type="text/javascript" src="../plugins/iframe_autoheight_2/iframeheight.js"></script>




<script type="text/javascript" src="../plugins/Datatables_4/JSZip-2.5.0/jszip.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/pdfmake-0.1.36/pdfmake.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/pdfmake-0.1.36/vfs_fonts.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/DataTables-1.10.18/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/AutoFill-2.3.3/js/dataTables.autoFill.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/Buttons-1.5.6/js/dataTables.buttons.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/Buttons-1.5.6/js/buttons.colVis.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/Buttons-1.5.6/js/buttons.flash.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/Buttons-1.5.6/js/buttons.html5.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/Buttons-1.5.6/js/buttons.print.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/ColReorder-1.5.0/js/dataTables.colReorder.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/FixedColumns-3.2.5/js/dataTables.fixedColumns.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/FixedHeader-3.1.4/js/dataTables.fixedHeader.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/KeyTable-2.5.0/js/dataTables.keyTable.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/Responsive-2.2.2/js/dataTables.responsive.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/RowGroup-1.1.0/js/dataTables.rowGroup.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/RowReorder-1.2.4/js/dataTables.rowReorder.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/Scroller-2.0.0/js/dataTables.scroller.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/Select-1.3.0/js/dataTables.select.js"></script>



<script type="text/javascript" src="../plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="../plugins/datetime-moment/datetime-moment.js"></script>  

<script type="text/javascript" src="../plugins/datetime-moment/moment-with-locales.js"></script>
<script type="text/javascript" src="../plugins/datepicker/js/bootstrap-datetimepicker.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-touchspin-master/src/jquery.bootstrap-touchspin.js"></script>

<script type="text/javascript" src="../plugins/bootbox-4.4.0/bootbox.min.js"></script>











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
	
	consultar_saldos()
	
	
	
	//$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'})

});


 

calcDataTableHeight = function(porcentaje) {
    return $(window).height()*porcentaje/100;
  }; 		










															
																
consultar_saldos = function() {  
	
		
      var err ="";
		
		var prm=new ajaxPrm();
        
		/*
		console.log('pir: ' + j$('#txtpir').val())
		console.log('estado: ' + j$('#cmbestados').val())
		console.log('expedicion: ' + j$('#txtexpedicion').val())
		console.log('fecha inicio orden: ' + j$('#txtfecha_inicio_orden').val())
		console.log('fecha fin orden: ' + j$('#txtfecha_fin_orden').val())
		console.log('fecha inicio envio: ' + j$('#txtfecha_inicio_envio').val())
		console.log('fecha fin envio: ' + j$('#txtfecha_fin_envio').val())
		console.log('fecha inicio entrega: ' + j$('#txtfecha_inicio_entrega').val())
		console.log('fecha fin entrega: ' + j$('#txtfecha_fin_entrega').val())
		*/
		
		
		
		
		/*
		prm.add('p_empresa', j$('#cmbempresas').val());
        prm.add('p_cliente', j$('#cmbclientes').val());
		prm.add('p_estado', j$('#cmbestados').val());
		prm.add('p_numero_pedido', j$('#txtpedido').val());
		prm.add('p_fecha_i', j$('#txtfecha_inicio').val());
		prm.add('p_fecha_f', j$('#txtfecha_fin').val())
		prm.add('p_pedido_automatico', j$('#cmbpedidos_automaticos').val());
		prm.add('p_articulo', j$('#ocultoarticulo_seleccionado').val());
		prm.add('p_hoja_ruta', j$('#txthoja_ruta').val());
		*/			
        
		prm.add('p_usuario', '<%=session("usuario")%>')
		prm.add('p_fecha_ini', $('#txtfecha_inicio').val())
		prm.add('p_fecha_fin', $('#txtfecha_fin').val())
		
        $.fn.dataTable.moment('DD/MM/YYYY');
        
        //deseleccioamos el registro de la lista
        $('#lista_articulos_a_devolver tbody tr').removeClass('selected');
        
        if (typeof lst_articulos_a_devolver == 'undefined') {
			//console.log('Dentro de la creacion del datatable lst_pirs')
            lst_articulos_a_devolver = $('#lista_articulos_a_devolver').DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:'../tojson/consulta_saldos_gag_obtener_saldos.asp?' + prm.toString(),
                                                           type:'POST',
                                                           dataSrc:'ROWSET'},
                                                     order:[],
													 columnDefs: [
                                                              {className: "dt-right", targets: [0,1,2,6]}
															  //,{type: "date-eu", targets: [2]}
                                                            ],
													 columns:[ 
																{data: 'ID'},
													 			{data: 'FECHA'},
																{data: 'IMPORTE'
																			,render: function (data, type, row, meta) 
																			{
																			if ( type === "display" ) //si se visualiza se formatea
																				{
																				valor=$.fn.dataTable.render.number( '.', ',', 2).display(data.replace(',', '.'))
																				return valor + ' €'
																				}
																			  else
																			  	{
																				return data //si no se para visualizar, va sin formatear
																				}	
																			}
																},
																{data: 'ORDENANTE'},
																{data: 'TIPO'},
																{data: 'CARGO_ABONO'},
																{data: 'TOTAL_DISFRUTADO'
																	,render: function (data, type, row, meta) 
																			{
																			if ( type === "display" ) //si se visualiza se formatea
																				{
																				valor=$.fn.dataTable.render.number( '.', ',', 2).display(data.replace(',', '.'))
																				if (valor!= '')
																					{
																					valor= valor + ' €'
																					}
																				return valor
																				}
																			  else
																			  	{
																				return data //si no se para visualizar, va sin formatear
																				}	
																			}
																},
																{data: 'OBSERVACIONES'}
                                                            ],
															
													createdRow: function(row, data, dataIndex){
															
															/*if (parseFloat(data.HOJA_RUTA_SI)>0)
																{
																j$(row).css('background-color', '#F5FC64');
																}
															*/
															
																							
													},
													rowCallback: function (row, data, index) {
														//stf.row_sel = data;   
														//console.log('dentro de rowcallback: ' + data);
														//$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
										
														/* PODEMOS DEFINIR LOS EVENTOS DE LOS OBJETOS DEL DATATABLE AQUI
														var cmbestados_datatable = j$(row).find('.cmbestados_datatable');
														cmbestados_datatable.on("change", function () {
															console.log('dentro del change');
														});
														
														cmbestados_datatable.on("click", function () {
															console.log('dentro del click');
														});
														*/
														
													},
															
													drawCallback: function () {
															//para que se configuren los popover-titles...
															//$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
															$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
														},
																
													rowId: 'extn', //para que se refresque sin perder filtros ni ordenacion
                                                    deferRender:true,
													scrollY:calcDataTableHeight(30),
													//scrollY:'20vh',
                                                    scrollCollapse:true,
    												
													language:{url:'../plugins/dataTable/lang/Spanish.json',
																"decimal": ",",
																"thousands": "."
														},
													paging:false,
                                                    processing: true,
                                                    searching:true,
													buttons:[{extend:"copy", text:'<i class="far fa-copy"></i>', titleAttr:"Copiar en Portapapeles", 
																		exportOptions:{columns:[0,1,2,3,4,5,6,7]}}, 
															 {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Saldos", extension:".xls", 
																		exportOptions:{columns:[0,1,2,3,4,5,6,7],
																						//al exportar a excel no pasa bien los decimales, le quita la coma
																						format: {
																								  body: function(data, row, column, node) {
																									  		data = $('<p>' + data + '</p>').text();
																									  		return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
																								  		}
																								}
															  }}, 
															 {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Saldos", //orientation:"landscape"
															 			exportOptions:{columns:[0,1,2,3,4,5,6,7]}}, 
															 {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Saldos", 
																		exportOptions:{columns:[0,1,2,3,4,5,6,7]}}
															]
													
													
													
                                                    });
													
				//controlamos el click, para seleccionar o desseleccionar la fila
                /*
				$("#lista_articulos_a_devolver tbody").on("click","tr", function()
					{  
                  	if (!$(this).hasClass("selected") ) 
				  		{                  
	                    lst_articulos_a_devolver.$("tr.selected").removeClass("selected");
    	                $(this).addClass("selected");
        				}            
                });
				*/
				//gestiona el dobleclick sobre la fila para mostrar la pantalla del detalle del pedido
				/*j$("#lista_articulos_a_devolver").on("dblclick", "tr", function(e) {
				  	var row=lst_pedidos.row(j$(this).closest("tr")).data() 
					parametro_id=row.Id
					parametro_nreg=row.Nreg
				  	
					j$(this).addClass('selected');
				  	j$(this).css('background-color', '#9FAFD1');
				  
				  	mostrar_pedido(parametro_id , parametro_nreg)

				});              
				*/
				
				
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_articulos_a_devolver.ajax.url('../tojson/consulta_saldos_gag_obtener_saldos.asp?' + prm.toString());
              lst_articulos_a_devolver.ajax.reload();                  
            }       
  };		







$("#cmdver_pedido").on("click", function () {
	location.href='Carrito_Gag.asp?acciones=<%=accion%>&emp=<%=empleado_gls%>'
});

$("#cmdborrar_pedido").on("click", function () {
	pagina_url='Vaciar_Carrito_Gag.asp'
	parametros=''
	mostrar_capa(pagina_url,'capa_annadir_articulo', parametros)
	
	cadena='<BR><BR><H4>El Carrito Ha Sido Vaciado</H4><BR><BR>'
	$("#cabecera_pantalla_avisos").html('Avisos')
	$("#body_avisos").html(cadena + "<br>");
	$("#botones_avisos").html('<p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p><br>');                          
		
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






$("#cmdconsultar").on("click", function () {
	consultar_saldos()
});

$("#cmdir_carrito").on("click", function () {
	<%if empleado_gls="SI" then%>
		location.href='Lista_Articulos_Gag_Empleados_GLS.asp'
	<%else%>
		location.href='Lista_Articulos_Gag.asp'
		//location.href='Lista_Articulos_Gag.asp?acciones=----'
	<%end if%>
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
