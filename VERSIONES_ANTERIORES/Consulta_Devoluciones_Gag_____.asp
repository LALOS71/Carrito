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
			.Source= .Source & " WHERE NPEDIDO=PEDIDOS.ID"
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
			.Source= .Source & " AND ESTADO='CERRADA'"
			'response.write("<br>FAMILIAS: " & .source)
			.Open
		end with

		if not disponible_devoluciones.eof then
			dinero_disponible_devoluciones=disponible_devoluciones("DISPONIBLE")	
		end if
		disponible_devoluciones.close
		set disponible_devoluciones=Nothing


%>
<html>
<head>
<title><%=consulta_pedidos_gag_title%></title>

<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-4.0.0/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-select/css/bootstrap-select.min.css">
		

<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />
<link rel="stylesheet" type="text/css" href="../plugins/datepicker/css/bootstrap-datepicker.css">

<link rel="stylesheet" type="text/css" href="../plugins/octicons_6_0_1/lib/octicons.css">

<script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css"/>
	
	<!--
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css"/>
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



<div class="modal fade" id="dialog_detalles_devolucion" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-lg" style="max-width: 95%;">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="cabecera_dialog_detalles_devolucion">Modal title</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
		<div class="row"> 
			<div class="col-12">
				<table id="lista_detalles_devolucion" name="lista_detalles_devolucion" class="table table-striped table-bordered table_detalle" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th>Pedido</th>
							<th>Ref. Art&iacute;iculo</th>
							<th>Art&iacute;culo</th>
							<th>Cantidad</th>
							<th>Total</th>
							<th>Albar&aacute;n</th>
							<th
								data-toggle="popover" 
								data-placement="bottom" 
								data-trigger="hover" 
								data-content="Unidades Aceptadas de la Devoluci&oacute;n" 
								data-original-title=""
								>Aceptadas</th>
							<th
								data-toggle="popover" 
								data-placement="bottom" 
								data-trigger="hover" 
								data-content="Unidades Rechazadas de la Devoluci&oacute;n" 
								data-original-title=""
								>Rechazadas</th>
							<th
								data-toggle="popover" 
								data-placement="bottom" 
								data-trigger="hover" 
								data-content="Unidades Pendientes de Gestionar por Globalia Artes Gr&aacute;ficas" 
								data-original-title=""
								>Pendientes</th>
							<th>Importe Aceptado</th>
						</tr>
					</thead>
				</table>
				<br /><br />
				<button type="button" class="btn btn-primary" id="cmdimprimir_devolucion" style="display:none"></button>
			</div>
		</div>
			
      </div>
    </div>
  </div>
</div>


<%response.flush()%>

<!-- contenido pricipal -->
<div class="container-fluid">
	<div class="row mt-1">
		<!--columna izquiderda-->
		<div class="col-xs-12 col-sm-12 col-md-4 col-lg-3 col-xl-3" id="columna_izquierda___">
			<!--DATOS DEL CLIENTE-->
			<div class="row">
				<div class="col-12 m-0 pr-0">
					<div class="card">
						<div class="card-body caja_gls">
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
									<b><%=session("usuario_empresa")%></b>
									<%if session("usuario_codigo_externo") <> "" then%>
										<b>&nbsp;-&nbsp;<%=session("usuario_codigo_externo")%></b>
									<%end if%>
									<br />
									<b><%=session("usuario_nombre")%></b>
									<br />
									<%=session("usuario_tipo")%>
									<br />
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
									<%if dinero_disponible_devoluciones<>0 then%>
										<span style="cursor:pointer"
											data-toggle="popover" 
											data-placement="bottom" 
											data-trigger="hover" 
											data-content="Dinero Disponible Para Futuros Pedidos" 
											data-original-title=""
											><b><font color="blue">Devoluciones: <%=dinero_disponible_devoluciones%>€</font></b></span>
										<br />
									<%end if%>
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
			  	<div class="row mt-2">
					<div class="col-6 m-0">
						<div class="card">
							<div class="card-header"><b>Pedidos</b></div>
							<div class="card-body">
								<button type="button" id="cmdconsultar_pedidos" name="cmdconsultar_pedidos" class="btn btn-primary btn-block btn-sm">
									<i class="fas fa-search"></i>
									<span>Consultar</span>
								</button>
							</div>
						</div>
					</div>
					<div class="col-6 m-0 p-0">
						<div class="card">
							<div class="card-header"><b>Devoluciones</b></div>
							<div class="card-body">
								<button type="button" id="cmdconsultar_devoluciones" name="cmdconsultar_devoluciones" class="btn btn-primary btn-block btn-sm">
										<i class="fas fa-reply"></i>
										<span>Devoluciones</span>
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
		<input type="hidden" id="ocultoimprimir_devolucion" name="ocultoimprimir_devolucion" value="" />
		<div class="col-xs-12 col-sm-12 col-md-8 col-lg-9 col-xl-9" id="columna_izquierda__">
			<!--articulos con posibilidad de devolucion-->
			<div class="row">
				<div class="col-12 pt-1">
					<div class="card">
						<div class="card-body">
							<h4 class="card-title">Art&iacute;culos Con Posibilidad de Devoluci&oacute;n</h4>&nbsp;
								
							<table id="lista_articulos_a_devolver" name="lista_articulos_a_devolver" class="table table-striped table-bordered" cellspacing="0" width="100%">
							<thead>
								<tr>
									<th><i class="fa-lg far fa-square" style="visibility:hidden "></i></th>
									<th>Referencia</th>
									<th>Descripci&oacute;n</th>
									<th>Pedido</th>
									<th>Cantidad</th>
									<th>Importe</th>
									<th>Albar&aacute;n</th>
									<th>Fecha Pedido</th>
									<th>Fecha Albar&aacute;n</th>
									
		
								</tr>
					  		</thead>
							</table>
						
						</div>
					</div>
				</div>
			</div>
			
			<!--devolucionese creadas-->
			<div class="row"> 
				<div class="col-12 pt-3">
					<div class="card">
						<div class="card-header"><h4 class="card-title">Devoluciones Creadas</h4></div>
						<div class="card-body">
							<div class="row"> 
								<div class="col-12">
									<table id="lista_devoluciones" name="lista_devoluciones" class="table table-striped table-bordered" cellspacing="0" width="80%">
									<thead>
										<tr>
											<th>Devoluci&oacute;n</th>
											<th>Fecha</th>
											<th>Estado</th>
											<th>Disponible (€)</th>
											<th>Utilizado (€)</th>
											<th></th>
				
										</tr>
									</thead>
									</table>
								</DIV>
							</DIV>
						
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
	
	consultar_articulos_a_devolver()
	consultar_devoluciones()
	
	
	//$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'})

});


chkOnClick = function(o) {  
    if ($(o).hasClass("fa-square"))
		{
		pongo='fa-check-square'
		quito='fa-square'
		}
	  else
	  	{
		pongo='fa-square'
		quito='fa-check-square'
		}
    $(o).addClass(pongo)
	$(o).removeClass(quito)
  };  

calcDataTableHeight = function(porcentaje) {
    return $(window).height()*porcentaje/100;
  }; 		


crear_solicitud_devolucion = function() {
	
	marcados=$(".fa-check-square").length
	if (marcados>0)
		{
		//debe confirmar que se crea la devolcuion		
		cadena_tabla='<h4>¿Confirma que desaa crear la devoluci&oacute;n con los siguientes art&iacute;culos?</h4><br><br>'
		cadena_tabla=cadena_tabla + '<table class="table table-bordered .table-striped"><thead><th>Referencia</th><th>Descripci&oacute;n</th><th>Pedido</th><th>Albar&aacute;n</th><th>Cantidad</th><th>Importe</th></thead>'
		cadena_tabla=cadena_tabla + '<tbody>'
		$(".fa-check-square", lst_articulos_a_devolver.rows().nodes()).each(function(i) {
		  var tr=$(this).closest("tr"), d=lst_articulos_a_devolver.row(tr).data(); 
		  nueva_cantidad = $(tr).find(".spin_cantidades").val()
		  cadena_tabla=cadena_tabla + '<tr><td>' + d.CODIGO_SAP
		  cadena_tabla=cadena_tabla + '</td><td>' + d.DESCRIPCION	
		  cadena_tabla=cadena_tabla + '</td><td>' + d.PEDIDO
		  cadena_tabla=cadena_tabla + '</td><td>' + d.ALBARAN
		  cadena_tabla=cadena_tabla + '</td><td>' + nueva_cantidad
		  cadena_tabla=cadena_tabla + '</td><td>' + (parseFloat(d.PRECIO_UNIDAD.replace(',','.')) * parseFloat(nueva_cantidad.replace(',','.'))).toFixed(2).toString()
		  cadena_tabla=cadena_tabla + '</td></tr>'				
		  
		});
		
		cadena_tabla=cadena_tabla + '</tbody></table>'
		cadena_tabla=cadena_tabla + '<h6><br><br><p><i>Una vez revisado y aceptado el detalle de la devolución, proceda a imprimir el documento que se le mostrará posteriormente y adjúntelo en la expedición con el material a devolver.'
		cadena_tabla=cadena_tabla + '<br><br>Podr&aacute; volver a imprimir dicho documento las veces que necesite pulsando el bot&oacute;n con el icono de la impresora que aparece en la pantalla donde se muestran los detalles de cada devoluci&oacute;n.'
		cadena_tabla=cadena_tabla + '<br><br>Tras comprobar el estado de la mercancía y aceptar el pedido parcial o totalmente por parte de Globalia, tendrá disponible el saldo correspondiente para canjear en sus próximos pedidos.'
		cadena_tabla=cadena_tabla + '<br><br>Saludos.</i></p></h6>'  

		bootbox.confirm({
			message: cadena_tabla,
			size: 'large',
			buttons: {
				confirm: {
					label: ' ACEPTAR ',
					className: 'btn-success'
				},
				cancel: {
					label: ' RECHAZAR ',
					className: 'btn-danger'
				}
			},
			callback: function (result) {
				//console.log('respuesta a aceptar o rechazar: ' + result);
				if (result)
					{
					//console.log('valor ocultoimprimir_devolucion: ' + $("#ocultoimprimir_devolucion").val());
					$("#ocultoimprimir_devolucion").val('SI')
					//console.log('valor ocultoimprimir_devolucion antes de llamar a crear_devolucion: ' + $("#ocultoimprimir_devolucion").val());
					crear_devolucion()
					}
			}
		});
		
		
		
		}
	  else
	  	{
			bootbox.alert({
				message: "<br><br><h4>Tiene que Marcar los Art&iacute;culos que Quiere Devolver</h4><br><br>",
				size: 'large'
			});
		}

	
  };




crear_devolucion = function() {
	
	//j$(".fa-check-square-o")
	strarticulos="#"
	cadena_error=""
	hay_error="NO"
	
			$(".fa-check-square", lst_articulos_a_devolver.rows().nodes()).each(function(i) {
			  var tr=$(this).closest("tr"), d=lst_articulos_a_devolver.row(tr).data(); 
			  nueva_cantidad = $(tr).find(".spin_cantidades").val()
				
			  strarticulos += d.IDALBARANDETALLES + "$$$" + nueva_cantidad + "#";
			});
			
			//console.log('lista articulos: ' + strarticulos);


			
			$.ajax({
				type: "post",        
				url: 'Crear_Devolucion_Gag.asp',
				data:{
						"p_articulos": strarticulos
						,"p_codcli" : '<%=session("usuario")%>'
						,"p_usuario_dir_activo" : '<%=session("usuario_directorio_activo")%>'
						},
				success: function(respuesta) {
								//console.log('respuesta recibida: ' + respuesta)
								if (respuesta.substring(0,13)=='DEVOLUCION###')
									{
									//desmarcamos el check de marcar todos los check
									//j$("#checkAll").removeClass('fa-check-square')
									//j$("#checkAll").addClass('fa-square')
									respuesta=respuesta.replace('DEVOLUCION###', '')
									$("#ocultodevolucion_a_imprimir").val(respuesta)
									//console.log('id de devolcuion recien creada antes de imprimir: ' + respuesta)
									
									
	
									id_devolucion=$("#ocultodevolucion_a_imprimir").val()
					
									//console.log('id de devolcuion recogida para imprimir: ' + id_devolucion)
									
									//hay que volver a refrescar las tablas
									consultar_articulos_a_devolver()
									consultar_devoluciones()
									
									
									
									//mostrar_devolucion(id_devolucion, 'SI')
									
									mostrar_detalles_devolucion(id_devolucion, 'si')
									//$("#dialog_detalles_devolucion").modal("show");
									$("#cabecera_dialog_detalles_devolucion").html('Devoluci&oacute;n ' + id_devolucion);
									//console.log('lanzamos el trigger de impresion de la devolucion')
									//setTimeout(autoimprimir_devolucion(), 3000)
									//$("#cmdimprimir_devolucion").click()
									
									
									//mostramos un mensaje de ok a la facturacion en bloque
									/*
									bootbox.alert({
										message: '<br><br><h4>Se Ha Creado la Solicitud de Devoluci&oacute;n.</h4><br><br>',
										size: 'large'
										});
									*/
									}
									
								  else
								  	{
									bootbox.alert({
										message: '<br><br><h4>Se Ha Producido un ERROR al Crear la Solicitud de Devoluci&oacute;n.</h4><br><br>',
										size: 'large'
										});
									}
							},
				error: function() {
							bootbox.alert({
									message: '<br><br><h4>Se Ha Producido un ERROR al Crear la Solicitud de Devoluci&oacute;n.</h4><br><br>',
									size: 'large'
									});
					}
			});
			
			

	
	//console.log('final strpir: ' + strpir)
  };
  
$("#cmdimprimir_devolucion").on("click", function() {
	//console.log('desde dentro del click de imprimir devolcuion')
	lst_detalles_devolucion.button('.buttons-print').trigger()
});

eliminar_devolucion = function(id_devolucion) {
	bootbox.confirm({
		message: "<br><br><h4>¿Confirma que desea eliminar la solicitud de devoluci&oacute;n " + id_devolucion + "?</h4>",
		size: 'large',
		buttons: {
			cancel: {
				label: '<i class="fa fa-times"></i>&nbsp;&nbsp;No&nbsp;',
				className: 'btn-danger'
			},
			confirm: {
				label: '<i class="fa fa-check"></i>&nbsp;&nbsp;Si&nbsp;',
				className: 'btn-success'
			}
		},
		callback: function (result) {
			if (result)
				{
				confirmacion_eliminacion_devolucion(id_devolucion)
				};
		}
	});
}


confirmacion_eliminacion_devolucion = function(id_devolucion) {

		$.ajax({
		type: "post",        
		url: 'Eliminar_Devolucion_Gag.asp',
		data:{"p_devolucion": id_devolucion},
		success: function(respuesta) {
						//console.log('respuesta recibida: ' + respuesta)
						if (respuesta=='0')
							{
							//desmarcamos el check de marcar todos los check
							//j$("#checkAll").removeClass('fa-check-square')
							//j$("#checkAll").addClass('fa-square')
							
							
							//mostramos un mensaje de ok a la facturacion en bloque
							bootbox.alert({
								message: '<br><br><h4>Se Ha Eliminado la Solicitud de Devoluci&oacute;n.</h4><br><br>',
								size: 'large'
								});

							
							
							//hay que volver a refrescar las tablas
							consultar_devoluciones()
							
							}
							
						  else
							{
							bootbox.alert({
								message: '<br><br><h4>Se Ha Producido un ERROR al Eliminar la Solicitud de Devoluci&oacute;n.</h4><br><br>',
								size: 'large'
								});
							}
					},
		error: function() {
					bootbox.alert({
							message: '<br><br><h4>Se Ha Producido un ERROR al Eliminar la Solicitud de Devoluci&oacute;n.</h4><br><br>',
							size: 'large'
							});
			}
	});

	
  };


mostrar_devolucion = function(id_devolucion, imprimiendo) {
	
	mostrar_detalles_devolucion(id_devolucion, imprimiendo)
	$("#dialog_detalles_devolucion").modal("show");
	$("#cabecera_dialog_detalles_devolucion").html('Devoluci&oacute;n ' + id_devolucion);
}


															
																
consultar_articulos_a_devolver = function() {  
	
		
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
        
		prm.add('p_usuario_directorio_activo', '<%=session("usuario_directorio_activo")%>')
		prm.add('p_usuario', '<%=session("usuario")%>')
		
        $.fn.dataTable.moment('DD/MM/YYYY');
        
        //deseleccioamos el registro de la lista
        $('#lista_articulos_a_devolver tbody tr').removeClass('selected');
        
        if (typeof lst_articulos_a_devolver == 'undefined') {
			//console.log('Dentro de la creacion del datatable lst_pirs')
            lst_articulos_a_devolver = $('#lista_articulos_a_devolver').DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:'../tojson/consulta_devoluciones_obtener_articulos_a_devolver.asp?' + prm.toString(),
                                                           type:'POST',
                                                           dataSrc:'ROWSET'},
                                                     order:[],
													 columnDefs: [
                                                              {className: "dt-right", targets: [3,4,5,6,7]}
															  //,{type: "date-eu", targets: [2]}
                                                            ],
													 columns:[ 
																{orderable:false,
																	//orderDataType: "dom-checkbox",
                                                                       data:function(row, type, val, meta) { 
                                                                         return '<i style="cursor:pointer" onclick="chkOnClick(this)" class="state-icon fa-lg far fa-square"></i>';
                                                                       }
                                                                      },  
																{data: 'CODIGO_SAP'},
													 			{data: 'DESCRIPCION'},
																{data: 'PEDIDO'},
																{data: "CANTIDAD_DISPONIBLE",
																		render: function(data, type, row){
																				cadena_total=''
																				//console.log('estado: ' + row.ESTADO)
																				//console.log('type: ' + type)
																				switch(type) {
																						case 'export':
																							//console.log('ES UN EXPORT estado: ' + row.ESTADO)
																							cadena_total=row.CANTIDAD_DISPONIBLE
																							break;
																							
																						case 'sort':
																							cadena_total=row.CANTIDAD_DISPONIBLE
																							break;		
																							
																						default:
																							cadena='<input class="form-control-sm form-control spin_cantidades" id="spin_cantidad_' + row.IDALBARANDETALLES + '" type="text" value="' + row.CANTIDAD_DISPONIBLE + '" name="spin_cantidad_' + row.IDALBARANDETALLES + '" size=1 style="padding:2; font-size:12px">'
																							
																							cadena_total=cadena
																						}
																					return cadena_total
																		}}, 
																
																{data: 'IMPORTE'},
																{data: 'ALBARAN'},
																{data: 'FECHA_PEDIDO'},
																{data: 'FECHA_ALBARAN'},
																//{data: 'DIFERENCIA_MESES'},
																{data: 'ID_ARTICULO', visible: false},
																{data: 'CLIENTE', visible: false},
																{data: 'PRECIO_UNIDAD', visible: false},
																{data: 'IDALBARANDETALLES', visible: false}
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
														var spin_cantidad = $(row).find('.spin_cantidades');
														//console.log('dentro de rowcallback para albaranDETALLES: ' +  data.IDALBARANDETALLES)
															$(spin_cantidad).TouchSpin({
																	min: 1,
																	max: data.CANTIDAD_DISPONIBLE,
																	verticalbuttons: true,
																	verticalup: '<i class="fas fa-angle-up"></i>',
																	verticaldown: '<i class="fas fa-angle-down"></i>'
																});
															
															$(spin_cantidad).on("touchspin.on.stopspin", function() {
																//console.log("touchspin.on.stopspin");
															  });
															  
															$(spin_cantidad).on("change", function() {
																//console.log("change");
																var row=lst_articulos_a_devolver.row($(this).closest("tr")).data()
																cantidad_nueva=$(this).val()
																precio = row.PRECIO_UNIDAD
																total_nuevo= cantidad_nueva * precio
																//console.log('cantidad nueva: ' + cantidad_nueva)
																//console.log('precio: ' + precio)
																//console.log('total_nuevo: ' + total_nuevo)
																row.IMPORTE= total_nuevo
																 
															  });
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
																		exportOptions:{columns:[1,2,3,4,5,6,7,8]}}, 
															 {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Articulos Con Posibilidad de Devolucion", extension:".xls", 
																		exportOptions:{columns:[1,2,3,4,5,6,7,8],
																						//al exportar a excel no pasa bien los decimales, le quita la coma
																						format: {
																								  body: function(data, row, column, node) {
																									  		data = $('<p>' + data + '</p>').text();
																									  		return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
																								  		}
																								}
															  }}, 
															 {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Articulos Con Posibilidad de Devolucion", //orientation:"landscape"
															 			exportOptions:{columns:[1,2,3,4,5,6,7,8]}}, 
															 {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Articulos Con Posibilidad de Devolucion", 
																		exportOptions:{columns:[1,2,3,4,5,6,7,8]}}
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
				
				//la barra de botones encima de la cabecera
				$("#lista_articulos_a_devolver").on("xhr.dt", function(e, settings, json, xhr) {
					var str="";
					str = '<button type="button" class="btn btn-primary" onclick="crear_solicitud_devolucion()"'
					str+= '	data-toggle="popover_datatable"'
					str+= '	data-placement="right"'
					str+= '	data-trigger="hover"'
					str+= '	data-content="Crear una solicitud de Devolución con los Articulos Marcados"'
					str+= '	data-original-title=""'
					str+= '><i class="fas fa-box fa-lg"></i>&nbsp;<i class="fas fa-long-arrow-alt-right fa-lg"></i>&nbsp;<i class="fas fa-truck fa-lg" aria-hidden="true"></i>&nbsp;&nbsp;Crear Devoluci&oacute;n</a>';
					str+= '</button>'
					$("div.toolbar").html(str);
					
				  }); 
				
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_articulos_a_devolver.ajax.url('../tojson/consulta_devoluciones_obtener_articulos_a_devolver.asp');
              lst_articulos_a_devolver.ajax.reload();                  
            }       
  };		



consultar_devoluciones = function() {  
      var err ="";
		
		//no hay control de errores por filtros no rellenados
		//var prm=new ajaxPrm();
        
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
        
        $.fn.dataTable.moment('DD/MM/YYYY');
        
        //deseleccioamos el registro de la lista
        $('#lista_devoluciones tbody tr').removeClass('selected');
        
        if (typeof lst_devoluciones == 'undefined') {
			//console.log('Dentro de la creacion del datatable lst_pirs')
            lst_devoluciones = $('#lista_devoluciones').DataTable({dom:'Blfrtip',
                                                          ajax:{url:'../tojson/consulta_devoluciones_obtener_devoluciones.asp',
                                                           type:'POST',
                                                           dataSrc:'ROWSET'},
                                                     order:[],
													 columnDefs: [
                                                              {className: "dt-right", targets: [0,1,3,4]}
															  //,{type: "date-eu", targets: [2]}
                                                            ],
													 columns:[ 
																{data: 'ID'},
													 			{data: 'FECHA'},
																{data: 'ESTADO'},
																{data: 'TOTAL_ACEPTADO'},
																{data: 'TOTAL_DISFRUTADO'},
																{orderable:false,
																	//orderDataType: "dom-checkbox",
                                                                       data:function(row, type, val, meta) { 
																	   		cadena=''
																	   		if (row.ESTADO=='SIN TRATAR')
																				{
																				cadena = '<button type="button" class="btn btn-primary btn-sm" onclick="eliminar_devolucion(' + row.ID + ')">'
																				cadena += '<i class="fas fa-times"></i>&nbsp;Eliminar</a>'
																				cadena += '</button>'
																				}
																			
																			return cadena;
																					
                                                                       }
                                                                      }, 
																{data: 'CODCLI', visible: false},
																{data: 'USUARIO_DIRECTORIO_ACTIVO', visible: false}
                                                            ],
															
													createdRow: function(row, data, dataIndex){
															
															/*if (parseFloat(data.HOJA_RUTA_SI)>0)
																{
																j$(row).css('background-color', '#F5FC64');
																}
															*/
													},
																
													rowId: 'extn', //para que se refresque sin perder filtros ni ordenacion
                                                    deferRender:true,
													scrollY:calcDataTableHeight(30),
													//scrollY:'10vh',
                                                    scrollCollapse:true,
    												
													language:{url:'../plugins/dataTable/lang/Spanish.json',
																"decimal": ",",
																"thousands": "."
														},
													paging:false,
                                                    processing: true,
                                                    searching:true,
													buttons:[{extend:"copy", text:'<i class="far fa-copy"></i>', titleAttr:"Copiar en Portapapeles", 
																		exportOptions:{columns:[0,1,2,3,4]}}, 
															 {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Devoluciones", extension:".xls", 
																		exportOptions:{columns:[0,1,2,3,4],
																						//al exportar a excel no pasa bien los decimales, le quita la coma
																						format: {
																								  body: function(data, row, column, node) {
																									  		data = $('<p>' + data + '</p>').text();
																									  		return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
																								  		}
																								}
															  }}, 
															 {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Devoluciones", //orientation:"landscape"
															 			exportOptions:{columns:[0,1,2,3,4]}}, 
															 {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Devoluciones", 
																		exportOptions:{columns:[0,1,2,3,4]}}
															],
															
													drawCallback: function () {
															//para que se configuren los popover-titles...
															$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
														}
                                                    });
													
				//controlamos el click, para seleccionar o desseleccionar la fila
                $("#lista_devoluciones tbody").on("click","tr", function()
					{  
                  	if (!$(this).hasClass("selected") ) 
				  		{                  
	                    lst_devoluciones.$("tr.selected").removeClass("selected");
    	                $(this).addClass("selected");
        				}            
                });
				
				//gestiona el dobleclick sobre la fila para mostrar la pantalla del detalle del pedido
				$("#lista_devoluciones tbody").on("dblclick", "tr", function(e) {
					var row=lst_devoluciones.row($(this).closest("tr")).data() 
					parametro_id=row.ID
				  	
					lst_devoluciones.$("tr.selected").removeClass("selected");
                    $(this).addClass('selected');
				  	//$(this).css('background-color', '#9FAFD1');
					//para que la cabecera de impresion ponga el nuero de devolucion correcto
					$("#ocultodevolucion_a_imprimir").val(parametro_id)
				  
				  	mostrar_devolucion(parametro_id, 'NO')
				});              
				
				
				//la barra de botones encima de la cabecera
				$("#lista_devoluciones").on("xhr.dt", function(e, settings, json, xhr) {

				  }); 
				
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_devoluciones.ajax.url('../tojson/consulta_devoluciones_obtener_devoluciones.asp');
              lst_devoluciones.ajax.reload();                  
            }       
  };		


mostrar_detalles_devolucion = function(id_devolucion, imprimiendo) {  

		//console.log('dentro de mostrar detalles devolucion para: ' + id_devolucion)
	
		var prm=new ajaxPrm();
        prm.add('p_id_devolucion', id_devolucion);
		
		cabecera_impresion='Devolución ' + id_devolucion
		
        
        $.fn.dataTable.moment('DD/MM/YYYY');
        
        //deseleccioamos el registro de la lista
        $('#lista_detalles_devolucion tbody tr').removeClass('selected');
		
		//console.log('prn to string....: ' + prm.toString())
        
        if (typeof lst_detalles_devolucion == 'undefined') {
			//console.log('Dentro de la creacion del datatable lst_detalles_devolucion')
			if ($("#ocultoimprimir_devolucion").val()=='SI')
				{
				$("#ocultoimprimir_devolucion").val('EN_INIT')
				}
			
            lst_detalles_devolucion = $('#lista_detalles_devolucion').DataTable({dom:'Blfrtip',
                                                          ajax:{url:'../tojson/consulta_devoluciones_obtener_detalles_devolucion.asp?' + prm.toString(),
                                                           type:'POST',
                                                           dataSrc:'ROWSET'},
                                                     order:[],
													 columnDefs: [
                                                              {className: "dt-right", targets: [0,3,4,5,6,7,8,9]}
															  //,{type: "date-eu", targets: [2]}
                                                            ],
													 columns:[ 		
																{data: 'ID_PEDIDO'},
																{data: 'CODIGO_SAP'},
													 			{data: 'DESCRIPCION'},
																{data: 'CANTIDAD'},
																{data: 'TOTAL'},
																{data: 'ALBARAN'},
																{data: 'UNIDADES_ACEPTADAS'},
																{data: 'UNIDADES_RECHAZADAS'},
																{data: 'UNIDADES_PENDIENTES'},
																{data: 'IMPORTE_ACEPTADO'},
																{data: 'ID', visible: false},
																{data: 'ID_DEVOLUCION', visible: false},
																{data: 'IDALBARANDETALLES', visible: false}
                                                            ],
															
													createdRow: function(row, data, dataIndex){
															
															/*if (parseFloat(data.HOJA_RUTA_SI)>0)
																{
																j$(row).css('background-color', '#F5FC64');
																}
															*/
													},
																
													rowId: 'extn', //para que se refresque sin perder filtros ni ordenacion
                                                    deferRender:true,
													//scrollY:calcDataTableHeight(40),
													//scrollX:"100%",
													//scrollY:'10vh',
                                                    //scrollCollapse:true,
													
    												
													language:{url:'../plugins/dataTable/lang/Spanish.json',
																"decimal": ",",
																"thousands": "."
														},
													paging:false,
                                                    processing: true,
                                                    searching:true,
													buttons:[{extend:"copy", text:'<i class="far fa-copy"></i>', titleAttr:"Copiar en Portapapeles", 
																		exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9]}}, 
															 {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Devolucion_<%=devolucion_seleccionada%>", extension:".xls", 
																		exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9],
																						//al exportar a excel no pasa bien los decimales, le quita la coma
																						format: {
																								  body: function(data, row, column, node) {
																									  		data = $('<p>' + data + '</p>').text();
																									  		return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
																								  		}
																								}
															  }}, 
															 {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Devolucion_" + id_devolucion, //orientation:"landscape"
															 			exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9]}}, 
															 {extend: "print"
															 			//, message: '<h3>'+cabecera_impresion+'</h3>'
																		
																		, title: function () { return ponerle_nombre();}
																		
															 			, messageTop: '<%=cabecera_para_impresion%>'
																		//messageTop: 'probando',
																		//messageBottom: 'terminado',
																		, messageBottom: '<br /><br /><i>Adjunte este documento en la expedición con el material a devolver.<br /><br />Tras comprobar el estado de la mercancía y aceptar el pedido parcial o totalmente por parte de Globalia, tendrá disponible el saldo correspondiente para canjear en sus próximos pedidos.'
																		, customize: function ( win ) {
																							$(win.document.body)
																								.css( 'font-size', '10pt' )
																								/*
																								.prepend(
																									'<img src="http://datatables.net/media/images/logo-fade.png" style="position:absolute; top:0; left:0;" />'
																								);
																								*/
																		 
																							$(win.document.body).find( 'table' )
																								.addClass( 'compact' )
																								.css( 'font-size', 'inherit' );
																							
																						}
															 
															 			, text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar"
																		, exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9]}}
															],
															
													drawCallback: function () {
															//para que se configuren los popover-titles...
															$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
															//$(".dataTables_scrollHeadInner").css({"width":"100%"});
															//$(".table_detalle").css({"width":"100%"});
															//console.log( 'en el evento drawcallback del datatable a imprimir' );
															}
                                                    });
				//controlamos el click, para seleccionar o desseleccionar la fila
                $("#lista_detalles_devolucion tbody").on("click","tr", function()
					{  
					/*
                  	if (!$(this).hasClass("selected") ) 
				  		{                  
	                    lst_devoluciones.$("tr.selected").removeClass("selected");
    	                $(this).addClass("selected");
        				}            
					*/
                });
				
				//gestiona el dobleclick sobre la fila para mostrar la pantalla del detalle del pedido
				/*
				$("#lista_detalles_devolucion").on("dblclick", "tr", function(e) {
					var row=lst_devoluciones.row($(this).closest("tr")).data() 
					parametro_id=row.ID
				  	
					$(this).addClass('selected');
				  	$(this).css('background-color', '#9FAFD1');
				  
				  	mostrar_devolucion(parametro_id)
				});              
				*/
				
				
				$("#lista_detalles_devolucion").on("init.dt", function(e, settings, json, xhr) {
					//console.log( 'en el evento init del datatable a imprimir' );
					//console.log( 'valor de ocultoimprimir_devolucion: ' + $("#ocultoimprimir_devolucion").val());
					if ($("#ocultoimprimir_devolucion").val()=='EN_INIT')
						{
						//console.log( 'lanzamos la impresion');
						$("#cmdimprimir_devolucion").click()
						$("#ocultoimprimir_devolucion").val('NO')
						}
					//console.log( 'valor de ocultoimprimir_devolucion despues del INIT: ' + $("#ocultoimprimir_devolucion").val());
					
				  });
				  
				$("#lista_detalles_devolucion").on("xhr.dt", function(e, settings, json, xhr) {
					//console.log( 'en el evento xhr del datatable a imprimir' );
					
				  }); 
				  
				 $("#lista_detalles_devolucion").on("predraw.dt", function(e, settings, json, xhr) {
					//console.log( 'en el evento predraw del datatable a imprimir' );
				  }); 
				  
				$('#lista_detalles_devolucion').on( 'draw.dt', function () {
					//console.log( 'en el evento draw del datatable a imprimir' );
					//console.log( 'valor de ocultoimprimir_devolucion: ' + $("#ocultoimprimir_devolucion").val());
					if ($("#ocultoimprimir_devolucion").val()=='EN_DRAW')
						{
						//console.log( 'lanzamos la impresion');
						$("#cmdimprimir_devolucion").click()
						$("#ocultoimprimir_devolucion").val('NO')
						}
					//console.log( 'valor de ocultoimprimir_devolucion despues del drwa: ' + $("#ocultoimprimir_devolucion").val());
					
				});
				
              }
            else{     
              //stf.lst_tra.clear().draw();
			  //console.log('no creamos el lst de detalles, lo recargamos')
			  //console.log('prn to string....: ' + prm.toString())
			  lst_detalles_devolucion.ajax.url('../tojson/consulta_devoluciones_obtener_detalles_devolucion.asp?p_id_devolucion=' + id_devolucion);
              lst_detalles_devolucion.ajax.reload(); 
			  //$('#lista_detalles_devolucion').DataTable().ajax.reload()                 
			  //console.log('despues de recargar')
			  if ($("#ocultoimprimir_devolucion").val()=='SI')
				{
				$("#ocultoimprimir_devolucion").val('EN_DRAW')
				}
			  
			  /*esto lo hace en el evento draw tambien
			  console.log( 'valor de ocultoimprimir_devolucion: ' + $("#ocultoimprimir_devolucion").val());
			  if ($("#ocultoimprimir_devolucion").val()=='SI')
				{
				console.log( 'lanzamos la impresion');
				$("#cmdimprimir_devolucion").click()
				$("#ocultoimprimir_devolucion").val('NO')
				}
			  console.log( 'valor de ocultoimprimir_devolucion despues de recargar el datatable: ' + $("#ocultoimprimir_devolucion").val());
			  */
            }  
			
			
			
		
  };		


ponerle_nombre=function(){
	return 'Devolución ' + $("#ocultodevolucion_a_imprimir").val().toString()
}


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


$("#cmdir_carrito").on("click", function () {
	<%if empleado_gls="SI" then%>
		location.href='Lista_Articulos_Gag_Empleados_GLS.asp'
	<%else%>
		location.href='Lista_Articulos_Gag.asp'
		//location.href='Lista_Articulos_Gag.asp?acciones=----'
	<%end if%>
});






$('#dialog_detalles_devolucion').on('show.bs.modal', function (e) {
  //console.log('desde el evento show.bs.modal')
})
$('#dialog_detalles_devolucion').on('shown.bs.modal', function (e) {
  //console.log('desde el evento shown.bs.modal')
  
})



</script>


</body>
<%
	'articulos.close
	
	connimprenta.close
	
	set articulos=Nothing
	
	set connimprenta=Nothing

%>
</html>
