<%@ language=vbscript %>
<!DOCTYPE html>
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
<html lang="es">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>Impresoras GLS</title>


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
		.table td { font-size: 12px; }
		
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
	  
	  
.acciones {
  font-size: 14px;
  width: 100px;
}

.acciones option {
  font-size: 12px;
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
				<div class="col-12 mt-2">
					<div class="card">
						<div class="card-body">
							<div class="col-12" id="detalle" name="detalle"></div>
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

$(document).ready(function() {
	mostrar_impresoras('<%=session("usuario")%>')
 	$('[data-toggle="popover"]').popover({html:true});   
});


mostrar_impresoras = function(cliente_seleccionado){
	$.ajax({
        url: "Tabla_Impresoras_GLS_Oficinas.asp",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        data: {cliente: cliente_seleccionado},
        type: "POST",
        //dataType: "json",
        success: function(data) {
            // Crear las filas de la tabla con los datos de las impresoras
            /*
			var filas = "";
            $.each(data, function(index, impresora) {
                filas += "<tr><td>" + impresora.numero_serie + "</td><td>" + impresora.fecha + "</td><td>" + impresora.estado + "</td></tr>";
            });
			*/

			//rellenamos la tabla con nuevo contenido
            $("#detalle").html(data);

            // Inicializar el datatable
            configurar_datatable()
        },
        error: function(xhr, textStatus, errorThrown) {
            console.log("Error al obtener los datos de las impresoras");
        }
    });

}







configurar_datatable = function() {
	console.log('dentro de mostrar impresoras')
	$.fn.dataTable.moment('DD/MM/YYYY');
	lst_impresoras = $("#lista_impresoras").DataTable({
		dom: '<"toolbar">Blfrtip',
		language: {
		  url: '../plugins/dataTable/lang/Spanish.json',
		  "decimal": ",",
		  "thousands": "."
		},
		columnDefs: [
		  {className: "dt-right", targets: [1]}
		],
		createdRow: function(row, data, dataIndex){
						//SI NO HAN FIRMADO TODAVIA LA DOCUMENTACION DEL PEDIDO, APARECE DE AMARILLO LA LINEA
						if (data[3] == 'PENDIENTE FIRMA')
							{
							$(row).css('background-color', '#F5FC64');
							}
						

		},
		rowId: 'extn',
		deferRender: true,
		scrollY: calcDataTableHeight(90),
		scrollCollapse: true,
		paging: false,
		processing: true,
		searching: true,
		buttons:[{extend:"copy", text:'<i class="far fa-copy"></i>', titleAttr:"Copiar en Portapapeles", 
								exportOptions:{columns:[0,1,2,3]}}, 
					 {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Impresoras_GLS", extension:".xls", 
								exportOptions:{columns:[0,1,2,3],
												//al exportar a excel no pasa bien los decimales, le quita la coma
												format: {
														  body: function(data, row, column, node) {
																	data = $('<p>' + data + '</p>').text();
																	return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
																}
														}
					  }}, 
					 {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Impresoras_GLS", //orientation:"landscape"
								exportOptions:{columns:[0,1,2,3]}}, 
					 {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Impresoras_GLS", 
								exportOptions:{columns:[0,1,2,3]}}
					]
  	})

	//la barra de botones encima de la cabecera
	//$("#lista_detalles_devolucion").on("xhr.dt", function(e, settings, json, xhr) {
   	$('#lista_impresoras').on('init.dt', function () {
					//la nueva impresora no la solicitan por aqui, es como un pedido normal, seleccionando la impresora
		$('div.toolbar').html('<button id="btnDocumentacion" class="btn btn-primary"><i class="fas fa-file-pdf"></i>&nbsp;Manual</button>');

		$('#btnDocumentacion').click(function() {
		  window.open("../Documentacion/GLS/GLS_Manual_Gestion_Impresoras.pdf");
		});
	});
  
		
  
	
  
}



$("#lista_impresoras").on("dblclick", function(e) {
			console.log("dentro del dblclick")
			/*
			var row=lst_detalles_devolucion.row(j$(this).closest("tr")).data() 
			parametro_id=row.ID
			
			//j$(this).addClass('selected');
			//j$(this).css('background-color', '#9FAFD1');
		  
			mostrar_detalles_devolucion(parametro_id)
			j$("#dialog_detalles_devolucion").modal("show")
			*/
});   
 

calcDataTableHeight = function(porcentaje) {
    return $(window).height()*porcentaje/100;
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


realizar_accion = function(sn) {
    //console.log('numero de serie: ' + sn)
	estado=$("#cmbacciones_" + sn).val()
	//console.log('estado: ' + estado)
	//console.log('dentro de realizar accion')
	
	cadena_mensaje=''	
	if (estado=='')
		{
		cadena_mensaje = cadena_mensaje + '<H5>Debe seleccionar una acción</H5>'
		}
	  else

	  	
	//console.log('vamos a ver todos los combos')
	cambios_pendientes = 0
	$('.acciones').each(function (index, value) {
		console.log('div' + index + ':' + $(this).attr('id'));
		if ($(this).val()!='') {
			cambios_pendientes++
			console.log('cambios pendientes: ' + cambios_pendientes)
		}
	});

	//console.log('cambios pendientes FINAL: ' + cambios_pendientes)
	if (cambios_pendientes > 1) {
		console.log('CAMBIOS PENDIENTES MAYOR QUE 1');
		cadena_mensaje = cadena_mensaje + '<h5>Hay un Cambio Pendiente de Guardar o Cancelar</h5>'
	}
	
	//console.log('--------------vemos el estado y los combos cambiado');
	//console.log('mensaje: ' + cadena_mensaje)
	if (cadena_mensaje == '')
		{
		$.ajax({
				url: "Modificar_Impresoras_GLS.asp",
				data: { sn_imp : sn,
						estado : estado,
						perfil : 'OFICINA',
						accion : 'DEFECTUOSA-AVERIADA-BAJA'
				 },
				type: "POST",
				dataType: "json",
				success: function(data) {
		
					// Inicializar el datatable
					console.log('volvemos de modificar impresoras.... todo correcto')
					console.log('mensaje: ' + data.mensaje)
					console.log('contenido: ' + data.contenido)
					//template strings
					cadena_mensaje_resultado = `<h5>${data.contenido}</h5>`
					bootbox.alert({message: cadena_mensaje_resultado});
					mostrar_impresoras('<%=session("usuario")%>')
				},
				error: function(xhr, textStatus, errorThrown) {
					console.log("Error al obtener los datos de las impresoras");
				}
			});
		}
	  else
	  	{
		bootbox.alert({message: cadena_mensaje});
		}

	
  }; 





</script>


</body>
<%
	'articulos.close
	
	connimprenta.close
	
	set articulos=Nothing
	
	set connimprenta=Nothing

%>
</html>
