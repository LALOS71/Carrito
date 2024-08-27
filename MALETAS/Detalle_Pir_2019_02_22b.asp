<%@ language=vbscript%>
<!--#include file="Conexion.inc"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%

id_seleccionado=Request.QueryString("id")

CAMPO_ID_TIPOS_INCIDENCIA=0
CAMPO_TIPO_TIPOS_INCIDENCIA=1
CAMPO_DESCRIPCION_TIPOS_INCIDENCIA=2
CAMPO_ORDEN_TIPOS_INCIDENCIA=3
set tipos_incidencia=Server.CreateObject("ADODB.Recordset")
	with tipos_incidencia
		.ActiveConnection=connmaletas
		.Source="SELECT ID, TIPO, DESCRIPCION"
		.Source= .Source & " FROM TIPOS_INCIDENCIA"
		.Source= .Source & " ORDER BY ORDEN"
		'response.write("<br>" & .source)
		.Open
		vacio_tipos_incidencia=false
		if not .BOF then
			tabla_tipos_incidencia=.GetRows()
		  else
			vacio_tipos_incidencia=true
		end if
	end with

tipos_incidencia.close
set tipos_incidencia=Nothing

CAMPO_ID_ESTADOS=0
CAMPO_DESCRIPCION_ESTADOS=1
set estados=Server.CreateObject("ADODB.Recordset")
	with estados
		.ActiveConnection=connmaletas
		.Source="SELECT ID, DESCRIPCION, PERFIL, ORDEN"
		.Source= .Source & " FROM ESTADOS"
		.Source= .Source & " ORDER BY ORDEN"
		'response.write("<br>" & .source)
		.Open
		vacio_estados=false
		if not .BOF then
			tabla_estados=.GetRows()
		  else
			vacio_estados=true
		end if
	end with

estados.close
set estados=Nothing


CAMPO_ID_PROVEEDORES=0
CAMPO_DESCRIPCION_PROVEEDORES=1
set proveedores=Server.CreateObject("ADODB.Recordset")
	with proveedores
		.ActiveConnection=connmaletas
		.Source="SELECT ID, DESCRIPCION, ORDEN"
		.Source= .Source & " FROM PROVEEDORES"
		.Source= .Source & " WHERE BORRADO='NO'"
		.Source= .Source & " ORDER BY ORDEN"
		'response.write("<br>" & .source)
		.Open
		vacio_proveedores=false
		if not .BOF then
			tabla_proveedores=.GetRows()
		  else
			vacio_proveedores=true
		end if
	end with

proveedores.close
set proveedores=Nothing

CAMPO_CODIGO_TIPOS_MALETA=0
CAMPO_DESCRIPCION_TIPOS_MALETA=1
set tipos_maleta=Server.CreateObject("ADODB.Recordset")
	with tipos_maleta
		.ActiveConnection=connmaletas
		.Source="SELECT CODIGO, DESCRIPCION"
		.Source= .Source & " FROM TIPOS_MALETA"
		.Source= .Source & " WHERE BORRADO='NO'"
		.Source= .Source & " ORDER BY ORDEN"
		'response.write("<br>" & .source)
		.Open
		vacio_tipos_maleta=false
		if not .BOF then
			tabla_tipos_maleta=.GetRows()
		  else
			vacio_tipos_maleta=true
		end if
	end with

tipos_maleta.close
set tipos_maleta=Nothing


	CAMPO_ID_TIPO_MALETA_PROVEEDOR=0
	CAMPO_DESCRIPCION_TIPO_MALETA_PROVEEDOR=1
	set proveedores_tipos_maleta=Server.CreateObject("ADODB.Recordset")
		with proveedores_tipos_maleta
			.ActiveConnection=connmaletas
			.Source="SELECT A.ID_TIPO_MALETA, B.DESCRIPCION"
			.Source= .Source & " FROM PROVEEDORES_TIPOS_MALETA A"
			.Source= .Source & " INNER JOIN TIPOS_MALETA B"
			.Source= .Source & " ON B.ID=A.ID_TIPO_MALETA"
			.Source= .Source & " WHERE 1=1"
			if session("perfil_usuario")="PROVEEDOR" then
				.Source= .Source & " AND A.ID_PROVEEDOR=" & session("proveedor_usuario")
			end if
			.Source= .Source & " AND B.BORRADO='NO'"
			.Source= .Source & " GROUP BY ID_TIPO_MALETA, DESCRIPCION"
			.Source= .Source & " ORDER BY B.DESCRIPCION"
	  
			'response.write("<br>" & .source)
			.Open
			vacio_proveedores_tipos_maleta=false
			if not .BOF then
				tabla_proveedores_tipos_maleta=.GetRows()
			  else
				vacio_proveedores_tipos_maleta=true
			end if
		end with
	
	proveedores_tipos_maleta.close
	set proveedores_tipos_maleta=Nothing




	campo_id=""
	campo_fecha_orden=""
	campo_expediente=""
	campo_pir=""
	campo_fecha_pir=""
	campo_tag=""
	campo_nombre=""
	campo_apellidos=""
	campo_movil=""
	campo_fijo=""
	campo_direccion_entrega=""
	campo_cp_entrega=""
	campo_email=""
	campo_tipo_direccion_entrega=""
	campo_desde_hasta=""
	campo_fecha_desde_hasta=""
	campo_tipo_equipaje_bag_original="" 'EL QUE VIENE DE INDIANA EN LA FICHA
	campo_marca_bag_original=""
	campo_material_bag_original=""
	campo_color_bag_original=""
	campo_largo_bag_original=""
	campo_alto_bag_original=""
	campo_ancho_bag_original=""
	campo_danno_ruedas_bag_original=""
	campo_danno_asas_bag_original=""
	campo_danno_cierres_bag_original=""
	campo_danno_cremallera_bag_original=""
	campo_danno_cuerpo_maleta_bag_original=""
	campo_danno_otros_bag_original=""
	
	'RESPONSE.WRITE("<BR>1 - CAMPO_DAÑO_RUEDAS_BAG_ORIGINAL: " & campo_danno_ruedas_bag_original)
	
	campo_ruta=""
	campo_vuelos=""
	campo_tipo_bag_original="" 'COMBO QUE SELECCIONA GROUNDFORCE PARA DESPUES PODE RASGINAR EL PIR A UN PROVEEDOR
	campo_fecha_inicio=""
	campo_importe_facturacion=""
	campo_fecha_facturacion=""
	campo_fecha_envio=""
	campo_fecha_entrega_pax=""
	campo_tipo_bag_entregada=""
	campo_tamanno_bag_entregada=""
	campo_referencia_bag_entregada=""
	campo_color_bag_entregada=""
	campo_numero_expedicion=""
	campo_costes=""
	campos_observaciones_proveedor=""
	campo_estado=""
	campo_proveedor=""
	
	'RESPONSE.WRITE("<BR>2 - CAMPO_DAÑO_RUEDAS_BAG_ORIGINAL - ANTES ASIGNACION: " & campo_danno_ruedas_bag_original)
	if campo_danno_ruedas_bag_original="" then
	  	campo_danno_ruedas_bag_original=0
	end if	
	if campo_danno_asas_bag_original="" then
	  	campo_danno_asas_bag_original=0
	end if
	if campo_danno_cierres_bag_original="" then
	  	campo_danno_cierres_bag_original=0
	end if
	if campo_danno_cremallera_bag_original="" then
	  	campo_danno_cremallera_bag_original=0
	end if
	if campo_danno_cuerpo_maleta_bag_original="" then
	  	campo_danno_cuerpo_maleta_bag_original=0
	end if
	if campo_danno_otros_bag_original="" then
	  	campo_danno_otros_bag_original=0
	end if
	
	
'RESPONSE.WRITE("<BR>3 - CAMPO_DAÑO_RUEDAS_BAG_ORIGINAL - DESPUES ASIGNACION: " & campo_danno_ruedas_bag_original)

'cuando no es un alta
if id_seleccionado<>"" then
	set detalle_pir=Server.CreateObject("ADODB.Recordset")
		with detalle_pir
			.ActiveConnection=connmaletas
			.Source="SELECT ID, FECHA_ORDEN, EXPEDIENTE, PIR, FECHA_PIR, TAG, NOMBRE, APELLIDOS, MOVIL, FIJO"
			.Source= .Source & ", DIRECCION_ENTREGA, CP_ENTREGA, EMAIL, TIPO_DIRECCION_ENTREGA, DESDE_HASTA, FECHA_DESDE_HASTA"
			.Source= .Source & ", TIPO_EQUIPAJE_BAG_ORIGINAL, MARCA_BAG_ORIGINAL,  MATERIAL_BAG_ORIGINAL"
			.Source= .Source & ", COLOR_BAG_ORIGINAL, LARGO_BAG_ORIGINAL, ALTO_BAG_ORIGINAL, ANCHO_BAG_ORIGINAL, DANNO_RUEDAS_BAG_ORIGINAL"
			.Source= .Source & ", DANNO_ASAS_BAG_ORIGINAL, DANNO_CIERRES_BAG_ORIGINAL, DANNO_CREMALLERA_BAG_ORIGINAL"
			.Source= .Source & ", DANNO_CUERPO_MALETA_BAG_ORIGINAL, DANNO_OTROS_BAG_ORIGINAL"
			.Source= .Source & ", RUTA, VUELOS, TIPO_BAG_ORIGINAL, FECHA_INICIO, IMPORTE_FACTURACION, FECHA_FACTURACION"
			.Source= .Source & ", FECHA_ENVIO, FECHA_ENTREGA_PAX, TIPO_BAG_ENTREGADA, TAMANNO_BAG_ENTREGADA, REFERENCIA_BAG_ENTREGADA"
			.Source= .Source & ", COLOR_BAG_ENTREGADA, NUM_EXPEDICION, COSTES, OBSERVACIONES_PROVEEDOR, ESTADO, PROVEEDOR"
	
			.Source= .Source & " FROM PIRS"
			.Source= .Source & " WHERE ID=" & id_seleccionado
			'response.write("<br>detalle pir: " & .source)
			.Open
		end with
	
	
	if not detalle_pir.eof then
		campo_id="" & detalle_pir("id")
		
		campo_fecha_orden = ""
		if detalle_pir("fecha_orden")<>"" then
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_orden")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_orden")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_orden")))
			campo_fecha_orden = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		end if
		
		campo_expediente="" & detalle_pir("expediente")
		campo_pir="" & detalle_pir("pir")
		
		campo_fecha_pir = "" 
		if detalle_pir("fecha_pir")<>"" then
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_pir")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_pir")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_pir")))
			campo_fecha_pir = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		end if
		
		campo_tag="" & detalle_pir("tag")
		campo_nombre="" & detalle_pir("nombre")
		campo_apellidos="" & detalle_pir("apellidos")
		campo_movil="" & detalle_pir("movil")
		campo_fijo="" & detalle_pir("fijo")
		campo_direccion_entrega="" & detalle_pir("direccion_entrega")
		campo_cp_entrega="" & detalle_pir("cp_entrega")
		campo_email="" & detalle_pir("email")
		campo_tipo_direccion_entrega="" & detalle_pir("tipo_direccion_entrega")
		campo_desde_hasta="" & detalle_pir("desde_hasta")
		
		campo_fecha_desde_hasta = ""
		if detalle_pir("fecha_desde_hasta")<>"" then
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_desde_hasta")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_desde_hasta")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_desde_hasta")))
			campo_fecha_desde_hasta = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		end if

		campo_tipo_equipaje_bag_original="" & detalle_pir("tipo_equipaje_bag_original")
		if detalle_pir("marca_bag_original")<>"" then
			campo_marca_bag_original="" & replace(detalle_pir("marca_bag_original"),"""","&quot;")
		end if
		'response.write("<br><br><br>marca bag original: " & campo_marca_bag_original)
		if detalle_pir("material_bag_original")<>"" then
			campo_material_bag_original="" & replace(detalle_pir("material_bag_original"),"""","&quot;")
		end if
		campo_color_bag_original="" & detalle_pir("color_bag_original")
		campo_largo_bag_original="" & detalle_pir("largo_bag_original")
		campo_alto_bag_original="" & detalle_pir("alto_bag_original")
		campo_ancho_bag_original="" & detalle_pir("ancho_bag_original")
		
		'RESPONSE.WRITE("<BR>4 - CAMPO_DAÑO_RUEDAS_BAG_ORIGINAL - ANTES ASIGNACION LCASE: " & campo_danno_ruedas_bag_original)
		'campo_danno_ruedas_bag_original="" & lcase(detalle_pir("danno_ruedas_bag_original"))
		if detalle_pir("danno_ruedas_bag_original") then
			campo_danno_ruedas_bag_original=1
		  else
		  	campo_danno_ruedas_bag_original=0
		end if
		if detalle_pir("danno_asas_bag_original") then
			campo_danno_asas_bag_original=1
		  else
		  	campo_danno_asas_bag_original=0
		end if
		if detalle_pir("danno_cierres_bag_original") then
			campo_danno_cierres_bag_original=1
		  else
		  	campo_danno_cierres_bag_original=0
		end if
		if detalle_pir("danno_cremallera_bag_original") then
			campo_danno_cremallera_bag_original=1
		  else
		  	campo_danno_cremallera_bag_original=0
		end if
		if detalle_pir("danno_cuerpo_maleta_bag_original") then
			campo_danno_cuerpo_maleta_bag_original=1
		  else
		  	campo_danno_cuerpo_maleta_bag_original=0
		end if
		if detalle_pir("danno_otros_bag_original") then
			campo_danno_otros_bag_original=1
		  else
		  	campo_danno_otros_bag_original=0
		end if
		'campo_danno_ruedas_bag_original=detalle_pir("danno_ruedas_bag_original")
		'campo_danno_asas_bag_original=detalle_pir("danno_asas_bag_original")
		'campo_danno_cierres_bag_original=detalle_pir("danno_cierres_bag_original")
		'campo_danno_cremallera_bag_original=detalle_pir("danno_cremallera_bag_original")
		'campo_danno_cuerpo_maleta_bag_original=detalle_pir("danno_cuerpo_maleta_bag_original")
		'campo_danno_otros_bag_original=detalle_pir("danno_otros_bag_original")
		
		
	'RESPONSE.WRITE("<BR>5 - CAMPO_DAÑO_RUEDAS_BAG_ORIGINAL - DESPUES ASIGNACION LCASE: " & campo_danno_ruedas_bag_original)
	'RESPONSE.WRITE("<BR>6 - detalle_pir('danno_ruedas_bag_original'): " & detalle_pir("danno_ruedas_bag_original"))

		
		
		campo_ruta="" & detalle_pir("ruta")
		campo_vuelos="" & detalle_pir("vuelos")
		campo_tipo_bag_original="" & detalle_pir("tipo_bag_original")
		
		campo_fecha_inicio = ""
		if detalle_pir("fecha_inicio")<>"" then
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_inicio")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_inicio")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_inicio")))
			campo_fecha_inicio = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		end if
		
		campo_importe_facturacion="" & detalle_pir("importe_facturacion")
		
		campo_fecha_facturacion = ""
		if detalle_pir("fecha_facturacion")<>"" then
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_facturacion")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_facturacion")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_facturacion")))
			campo_fecha_facturacion = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		end if
				
		campo_fecha_envio = "" 
		if detalle_pir("fecha_envio")<>"" then
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_envio")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_envio")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_envio")))
			campo_fecha_envio = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		end if
		
		campo_fecha_entrega_pax = "" 
		if detalle_pir("fecha_entrega_pax")<>"" then
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_entrega_pax")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_entrega_pax")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_entrega_pax")))
			campo_fecha_entrega_pax = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		end if
		
		campo_tipo_bag_entregada="" & detalle_pir("tipo_bag_entregada")
		campo_tamanno_bag_entregada="" & detalle_pir("tamanno_bag_entregada")
		campo_referencia_bag_entregada="" & detalle_pir("referencia_bag_entregada")
		campo_color_bag_entregada="" & detalle_pir("color_bag_entregada")
		campo_numero_expedicion="" & detalle_pir("num_expedicion")
		campo_costes="" & detalle_pir("costes")
		campo_observaciones_proveedor="" & detalle_pir("observaciones_proveedor")
		campo_estado="" & detalle_pir("estado")
		campo_proveedor="" & detalle_pir("proveedor")
		
	end if
		
	
	
	
	'response.write("<br>campo_danno_ruedas_bag_original= " & campo_danno_ruedas_bag_original)
	'response.write("<br>campo_danno_asas_bag_original= " & campo_danno_asas_bag_original)
	'response.write("<br>campo_danno_cierres_bag_original= " & campo_danno_cierres_bag_original)
	''response.write("<br>campo_danno_cremallera_bag_original= " & campo_danno_cremallera_bag_original)
	'response.write("<br>campo_danno_cuerpo_maleta_bag_original= " & campo_danno_cuerpo_maleta_bag_original)
	'response.write("<br>campo_danno_cierres_maleta_bag_original= " & campo_danno_cierres_maleta_bag_original)
	'response.write("<br>campo_danno_otros_bag_original= " & campo_danno_otros_bag_original)
	
	
	
	
		
	'response.write("<br>campo_danno_ruedas_bag_original= " & campo_danno_ruedas_bag_original)
	'response.write("<br>campo_danno_asas_bag_original= " & campo_danno_asas_bag_original)
	'response.write("<br>campo_danno_cierres_bag_original= " & campo_danno_cierres_bag_original)
	'response.write("<br>campo_danno_cremallera_bag_original= " & campo_danno_cremallera_bag_original)
	'response.write("<br>campo_danno_cuerpo_maleta_bag_original= " & campo_danno_cuerpo_maleta_bag_original)
	'response.write("<br>campo_danno_cierres_maleta_bag_original= " & campo_danno_cierres_maleta_bag_original)
	'response.write("<br>campo_danno_otros_bag_original= " & campo_danno_otros_bag_original)
	
	
	
		
	detalle_pir.close
	set detalle_pir=Nothing

end if 'cuando no es un alta

connmaletas.close
set connmaletas=Nothing

%>

<html>



<head>


	<title>PIR</title>
	

	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-switch/css/bootstrap-switch.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/media/css/dataTables.bootstrap.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/extensions/Buttons/css/buttons.dataTables.min.css">
  
	
	<link rel="stylesheet" type="text/css" href="plugins/font-awesome-4.7.0/css/font-awesome.min.css">
	
	<link rel="stylesheet" href="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min.css">

	<style>
	.clickable{
 	   cursor: pointer;   
	}

	.panel-heading span {
		margin-top: -20px;
		font-size: 15px;
	}
	
	
	
	.table th { font-size: 13px; }
	.table td { font-size: 12px; }
	
	/*
	.popover-content {
		background-color: #FCD086;
		font-size: 10px;
	}
	.popover.top .arrow:after {
      bottom: 1px;
      margin-left: -10px;
      border-top-color: #FCD086; /*<----here*/
      /*border-bottom-width: 0;
      content: " ";
    }
	*/
	
	/*para cambiar el color del fondo del popover
	.popover {background-color: coral;}
	.popover.bottom .arrow::after {border-bottom-color: coral; }
	.popover .popover-content {background-color: coral;}
	.popover.top .arrow:after {border-top-color: coral;}
	*/
	
	.dataTables_length {float:left;}
    .dataTables_filter {float:right;}
    .dataTables_info {float:left;}
    .dataTables_paginate {float:right;}
    .dataTables_scroll {clear:both;}
    .toolbar {float:left;}    
    div .dt-buttons {float:right; position:relative;}
    table.dataTable tr.selected.odd {background-color: #9FAFD1;}
    table.dataTable tr.selected.even {background-color: #B0BED9;}
    
    
    
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
    //------------------------------------------
    
    
/*	
	.project-jquerytypeahead.page-demo #form-user_v1 .typeahead__result .row {
    display: table-row;
}
 
.project-jquerytypeahead.page-demo #form-user_v1 .typeahead__result .row  > * {
    display: table-cell;
    vertical-align: middle;
}
 
.project-jquerytypeahead.page-demo #form-user_v1 .typeahead__result .username {
    padding: 0 10px;
}
 
.project-jquerytypeahead.page-demo #form-user_v1 .typeahead__result .id {
    font-size: 12px;
    color: #777;
    font-variant: small-caps;
}
 
.project-jquerytypeahead.page-demo #form-user_v1 .typeahead__result .avatar img {
    height: 26px;
    width: 26px;
}
 
.project-jquerytypeahead.page-demo #form-user_v1 .typeahead__result .project-logo {
    display: inline-block;
    height: 100px;
}
 
.project-jquerytypeahead.page-demo #form-user_v1 .typeahead__result .project-logo img {
    height: 100%;
}
 
.project-jquerytypeahead.page-demo #form-user_v1 .typeahead__result .project-information {
    display: inline-block;
    vertical-align: top;
    padding: 20px 0 0 20px;
}
 
.project-jquerytypeahead.page-demo #form-user_v1 .typeahead__result .project-information > span {
    display: block;
    margin-bottom: 5px;
}
 
.project-jquerytypeahead.page-demo #form-user_v1 .typeahead__result > ul > li > a small {
    padding-left: 0px;
    color: #999;
}
 
.project-jquerytypeahead.page-demo #form-user_v1 .typeahead__result .project-information li {
    font-size: 12px;
}
	
	*/
	</style>


	

    </head>
<body>
<div class="container-fluid">
	<form action="Guardar_Pir.asp" method="post" id="frmdatos_pir" name="frmdatos_pir">
		<input type="hidden" name="ocultoid_pir" id="ocultoid_pir" value="<%=campo_id%>" />

	<!--datos pir - indiana -->
	<div class="panel-group" id="datos_pir_indiana">
		
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title">
					<%if id_seleccionado<>"" then%>
						Datos Pir - Procedentes de Indiana
					  <%else%>
					  	Datos Pir
					<%end if%>
				</h3>
				<span class="pull-right clickable">
					<i class="glyphicon glyphicon-chevron-up"
						data-toggle="popover" 
						data-placement="left" 
						data-trigger="hover"
						data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
					></i>
				</span>
				
			</div>
			
			<div id="desplegable_datos_pir_indiana" class="panel-body">
				
					<div class="row">
						<div class="col-sm-12 col-md-12 col-lg-12">
                          <div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtpir_d" class="control-label">PIR</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtpir_d" name="txtpir_d" value="<%=campo_pir%>"/>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_pir_d" class="control-label">Fecha PIR</label>
								<input type="date" id="txtfecha_pir_d" class="form-control" required="" name="txtfecha_pir_d" value="<%=campo_fecha_pir%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_orden_d" class="control-label">Fecha Orden</label>
								<input type="date" id="txtfecha_orden_d" class="form-control" required="" name="txtfecha_orden_d" value="<%=campo_fecha_orden%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txttag_d" class="control-label">TAG</label>
								<input type="text" id="txttag_d" class="form-control" required="" name="txttag_d" value="<%=campo_tag%>"/> 
							</div>
                          </div>
						</div>
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            
							<div class="col-sm-4 col-md-4 col-lg-4">
								<label for="txtruta_d" class="control-label" style="width:100%">Ruta</label>
								<input type="text" id="txtruta_d" class="form-control" required="" name="txtruta_d" value="<%=campo_ruta%>"/> 
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtvuelos_d" class="control-label">Vuelos</label>
								<input type="text" id="txtvuelos_d" class="form-control" required="" name="txtvuelos_d" value="<%=campo_vuelos%>"/> 
							</div>
							
							
                          </div>
						</div>						  
						
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtnombre_d" class="control-label">Nombre</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtnombre_d" name="txtnombre_d" value="<%=campo_nombre%>" />
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtapellidos_d" class="control-label">Apellidos</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtapellidos_d" name="txtapellidos_d" value="<%=campo_apellidos%>" />
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtmovil_d" class="control-label">Movil</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtmovil_d" name="txtmovil_d" value="<%=campo_movil%>" />
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfijo_d" class="control-label">Fijo</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtfijo_d" name="txtfijo_d" value="<%=campo_fijo%>" />
							</div>
                          </div>
						</div>						  
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-10 col-md-10 col-lg-10">
								<label for="txtdireccion_entrega_d" class="control-label">Direcci&oacute;n Entrega</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtdireccion_entrega_d" name="txtdireccion_entrega_d" value="<%=campo_direccion_entrega%>" />
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtcp_entrega_d" class="control-label">C. P.</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcp_entrega_d" name="txtcp_entrega_d" value="<%=campo_cp_entrega%>" />
							</div>
                          </div>
						</div>						  
			
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-6 col-md-6 col-lg-6">
								<label for="txtemail_d" class="control-label">Email</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtemail_d" name="txtemail_d" value="<%=campo_email%>" />
							</div>
                          </div>
						</div>						  
			
			
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="cmbtipo_direccion_entrega_d" class="control-label">Tipo Direcci&oacute;n</label>
								<div class="clearfix visible-md-block"></div>
								<select id="cmbtipo_direccion_entrega_d" name="cmbtipo_direccion_entrega_d" data-width="100%" class="cmb_bt">
								  <option value="">&nbsp;</option>
								  <option value="P">Permanente</option>
								  <option value="T">Temporal</option>
								</select>
								
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="cmbdesde_hasta_d" class="control-label">Desde/Hasta</label>
								<div class="clearfix visible-md-block"></div>
								<select id="cmbdesde_hasta_d" name="cmbdesde_hasta_d" data-width="100%"  class="cmb_bt">
								  <option value="">&nbsp;</option>
								  <option value="DESDE">Desde</option>
								  <option value="HASTA">Hasta</option>
								</select>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_desde_hasta_d" class="control-label">Fecha Desde/Hasta</label>
								<input type="date" id="txtfecha_desde_hasta_d" class="form-control" required="" name="txtfecha_desde_hasta_d" value="<%=campo_fecha_desde_hasta%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txttipo_equipaje_bag_original_d" class="control-label">Tipo Equipaje</label>
								<input type="text" id="txttipo_equipaje_bag_original_d" class="form-control" required="" name="txttipo_equipaje_bag_original_d" value="<%=campo_tipo_equipaje_bag_original%>" /> 
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtmarca_bag_original_d" class="control-label">Marca</label>
								<input type="text" id="txtmarca_bag_original_d" class="form-control" required="" name="txtmarca_bag_original_d" value="<%=campo_marca_bag_original%>" /> 
							</div>
                          </div>
						</div>						  
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtmaterial_bag_original_d" class="control-label">Material</label>
								<input type="text" id="txtmaterial_bag_original_d" class="form-control" required="" name="txtmaterial_bag_original_d" value="<%=campo_material_bag_original%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtcolor_d" class="control-label">Color</label>
								<input type="text" id="txtcolor_bag_original_d" class="form-control" required="" name="txtcolor_bag_original_d" value="<%=campo_color_bag_original%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtlargo_bag_original_d" class="control-label">Largo</label>
								<input type="text" id="txtlargo_bag_original_d" class="form-control" required="" name="txtlargo_bag_original_d" value="<%=campo_largo_bag_original%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtalto_bag_original_d" class="control-label">Alto</label>
								<input type="text" id="txtalto_bag_original_d" class="form-control" required="" name="txtalto_bag_original_d" value="<%=campo_alto_bag_original%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtancho_bag_original_d" class="control-label">Ancho</label>
								<input type="text" id="txtancho_bag_original_d" class="form-control" required="" name="txtancho_bag_original_d" value="<%=campo_ancho_bag_original%>" /> 
							</div>
							
                          </div>
						</div>						  

						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
						  	<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_ruedas_d" class="control-label" style="width:100%">Daño Ruedas</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_ruedas_d" name="chkdanno_ruedas_d" class="form-control chk_bt" >
							</div>
							
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_asas_d" class="control-label" style="width:100%">Daño Asas</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_asas_d" name="chkdanno_asas_d"   class="form-control chk_bt" width="100%" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cierres_d" class="control-label" style="width:100%">Daño Cierres</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_cierres_d" name="chkdanno_cierres_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cremalleras_d" class="control-label" style="width:100%">Daño Cremalleras</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_cremalleras_d" name="chkdanno_cremalleras_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cuerpo_maleta_d" class="control-label" style="width:100%"
									data-toggle="popover" 
									data-placement="top" 
									data-trigger="hover"
									data-content="Daño Cuerpo Maleta"
									>D. Cu. Maleta</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_cuerpo_maleta_d" name="chkdanno_cuerpo_maleta_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_otros_dannos_d" class="control-label" style="width:100%">Otros Daños</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_otros_dannos_d" name="chkdanno_otros_dannos_d"  class="form-control chk_bt" >
							</div>
                          </div>
						</div>						  
  
  						
				
		  </div>
			<!-- panel Body-->
		</div>
		<!-- PANEL-->
	</div> 
	<!-- FIN datos pir indiana -->
	
	
	
	<div class="panel panel-primary" id="datos_pir_estado">
		<div class="panel-heading">
			<h3 class="panel-title">ESTADO Y TIPO DE MALETA</h3>
			<span class="pull-right clickable">
				<i class="glyphicon glyphicon-chevron-down"
					data-toggle="popover" 
					data-placement="left" 
					data-trigger="hover"
					data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
				></i>
			</span>
			
		</div>
		
		<div id="desplegable_datos_pir_estado" class="panel-body">
			
			<%if session("perfil_usuario")="PROVEEDOR" then%>
				<div class="form-group row">
					<div class="col-sm-12 col-md-12 col-lg-12">			
						<div class="col-sm-3 col-md-3 col-lg-3">
							<label for="cmbtipo_maleta_d" class="control-label">Tipo Maleta a Enviar</label>
							<div class="clearfix visible-md-block"></div>
							  <%if not vacio_tipos_maleta then
									for i=0 to UBound(tabla_tipos_maleta,2)
										if tabla_tipos_maleta(campo_codigo_tipos_maleta,i)=campo_tipo_bag_original then
												texto_txt=tabla_tipos_maleta(campo_descripcion_tipos_maleta,i)	
										end if
									next
								end if%>
							<input type="text" id="txttipo_maleta_d" class="form-control" required="" name="txttipo_maleta_d" value="<%=texto_txt%>" readonly /> 
						</div>
					</div>
				</div>
			<%end if%>
		
			<div class="form-group row">
				<div class="col-sm-12 col-md-12 col-lg-12">
					<div class="col-sm-3 col-md-3 col-lg-3">
						<label for="cmbestado_d" class="control-label">Estado</label>
						<div class="clearfix visible-md-block"></div>
						<select id="cmbestado_d" name="cmbestado_d" data-width="100%" class="cmb_bt">
						  <option value="">&nbsp;</option>
						  <%if not vacio_estados then%>
								<%for i=0 to UBound(tabla_estados,2)
									'los proveedores no ven la opcion de PENDIENTE DE AUTORIZACION
										'y aparecen deshabilitados AUTORIZADO, CERRADO y GESTION CIA
										if session("perfil_usuario")="PROVEEDOR" and (tabla_estados(campo_id_estados,i)=1 or tabla_estados(campo_id_estados,i)=2 or tabla_estados(campo_id_estados,i)=7 or tabla_estados(campo_id_estados,i)=8)then
											if tabla_estados(campo_id_estados,i)=2 or tabla_estados(campo_id_estados,i)=7 or tabla_estados(campo_id_estados,i)=8 then%>
												<option value="<%=tabla_estados(campo_id_estados,i)%>" disabled><%=tabla_estados(campo_descripcion_estados,i)%></option>
											<%end if
											else%>
											<option value="<%=tabla_estados(campo_id_estados,i)%>"><%=tabla_estados(campo_descripcion_estados,i)%></option>
										<%end if%>
								<%next%>
							<%end if%>
						</select>
						<div class="invisible" id="gestion_cia_explicacion">
							<div class="clearfix visible-md-block" style="height:3px"></div>
							<textarea class="form-control" rows="3" id="txtgestion_cia" name="txtgestion_cia" maxlength="243"></textarea>
						</div>
					</div>
					<div class="col-sm-1 col-md-1 col-lg-1 invisible" id="mas_incidencias">
							<label for="cmbmas_incidencias" class="control-label">&nbsp;</label>
							<div class="clearfix visible-md-block"></div>
							<button type="button" class="btn btn-primary" id="cmdmas_incidencias_pir" name="cmdmas_incidencias_pir">
							  <span class="glyphicon glyphicon-plus" aria-hidden="true" id="icocmdmas_incidencias_pir"
									data-toggle="popover_datatable"
									data-placement="right" 
									data-trigger="hover"
									data-content="A&ntilde;adir Nueva Incidencia."></span>
							</button>
					</div>
					<div class="col-sm-8 col-md-8 col-lg-8 invisible" id="mas_incidencias_cmb">
						<label for="cmbtipos_incidencia_d" class="control-label">Incidencia</label>
						<div class="clearfix visible-md-block"></div>
						<select id="cmbtipos_incidencia_d" name="cmbtipos_incidencia_d" data-width="100%" class="cmb_bt">
							<option value="">&nbsp;</option>
							<%if not vacio_tipos_incidencia then%>
								<%for i=0 to UBound(tabla_tipos_incidencia,2)%>
									<option value="<%=tabla_tipos_incidencia(campo_descripcion_tipos_incidencia,i)%>"><%=tabla_tipos_incidencia(campo_descripcion_tipos_incidencia,i)%></option>
								<%next%>
							<%end if%>
						</select>
						<div class="invisible" id="otras_incidencias">
							<div class="clearfix visible-md-block" style="height:3px"></div>
							<textarea class="form-control" rows="3" id="txtotrasincidencias" name="txtotrasincidencias" maxlength="243"></textarea>
						</div>
					</div>
				</div><!--final del col12-->
			</div><!-- final del row-->
			
			
		</div><!--final del panel body-->
		
	</div>
	<!--fin datos estado-->				

	
	
	
	
	<%if session("perfil_usuario")="ADMINISTRADOR" then%>
		<div class="panel panel-primary" id="datos_pir_ppc">
			<div class="panel-heading">
				<h3 class="panel-title">GBH</h3>
				<span class="pull-right clickable">
					<i class="glyphicon glyphicon-chevron-up"
						data-toggle="popover" 
						data-placement="left" 
						data-trigger="hover"
						data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
					></i>
				</span>
				
			</div>
			
			<div id="desplegable_datos_pir_ppc" class="panel-body">
				<div class="form-group row">
					<div class="col-sm-12 col-md-12 col-lg-12">
							  <div class="col-sm-2 col-md-2 col-lg-2">
									<label for="cmbtipo_maleta_d" class="control-label">Tipo Maleta</label>
									<div class="clearfix visible-md-block"></div>
									<select id="cmbtipo_maleta_d" name="cmbtipo_maleta_d" data-width="100%" class="cmb_bt">
									  <option value="">&nbsp;</option>
									  <%if not vacio_tipos_maleta then%>
											<%for i=0 to UBound(tabla_tipos_maleta,2)%>
												<option value="<%=tabla_tipos_maleta(campo_codigo_tipos_maleta,i)%>"><%=tabla_tipos_maleta(campo_descripcion_tipos_maleta,i)%></option>
											<%next%>
										<%end if%>
									</select>
								</div>
								
								<div class="col-sm-4 col-md-4 col-lg-4">
									<label for="cmbproveedores_d" class="control-label">Proveedores</label>
									<div class="clearfix visible-md-block"></div>
									<select id="cmbproveedores_d" name="cmbproveedores_d" data-width="100%" class="cmb_bt">
									  <option value="">&nbsp;</option>
									  <%if not vacio_proveedores then%>
											<%for i=0 to UBound(tabla_proveedores,2)%>
												<option value="<%=tabla_proveedores(campo_id_proveedores,i)%>"><%=tabla_proveedores(campo_descripcion_proveedores,i)%></option>
											<%next%>
										<%end if%>
									</select>
								</div>
								
								
								<div class="col-sm-2 col-md-2 col-lg-2">
									<label for="txtfecha_inicio_d" class="control-label">Fecha Inicio</label>
									<input type="date" id="txtfecha_inicio_d" class="form-control" required="" name="txtfecha_inicio_d" value="<%=campo_fecha_inicio%>" /> 
								</div>
								<div class="col-sm-2 col-md-2 col-lg-2">
									<label for="txtimporte_facturacion_d" class="control-label"
										data-toggle="popover" 
										data-placement="top" 
										data-trigger="hover"
										data-content="Importe Facturaci&oacute;n"
										>Imp. Facturac.</label>
									<input type="text" id="txtimporte_facturacion_d" class="form-control" required="" name="txtimporte_facturacion_d" value="<%=campo_importe_facturacion%>" /> 
								</div>
								<div class="col-sm-2 col-md-2 col-lg-2">
									<label for="txtfecha_facturacion_d" class="control-label"
										data-toggle="popover" 
										data-placement="top" 
										data-trigger="hover"
										data-content="Fecha Facturaci&oacute;n"
										>F. Facturac.</label>
									<input type="date" id="txtfecha_facturacion_d" class="form-control" required="" name="txtfecha_facturacion_d" value="<%=campo_fecha_facturacion%>" /> 
								</div>
					</div>
				</div>
			</div>
			
			<div class="form-group row">
					<div class="col-sm-12 col-md-12 col-lg-12">
							<%if campo_estado="1"then 'PTE. AUTORIZACION%>
								<div class="pull-right">
									<div class="col-sm-2 col-md-2 col-lg-2">
										<button type="button" class="btn btn-success btn-lg" id="cmdautorizar_pir" name="cmdautorizar_pir">
										  <span class="glyphicon glyphicon-ok" aria-hidden="true"></span> Autorizar Pir
										</button>
									</div>
								</div>
							<%end if%>
	
								
					</div>
				</div>
			</div>
			
		</div>
	<%end if%>		
	<!--fin datos pir ppc-->				
		
	<div class="panel panel-primary" id="datos_pir_proveedor">
		<div class="panel-heading">
			<h3 class="panel-title">PROVEEDOR</h3>
			<span class="pull-right clickable">
				<i class="glyphicon glyphicon-chevron-up"
					data-toggle="popover" 
					data-placement="left" 
					data-trigger="hover"
					data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
				></i>
			</span>
			
		</div>
		
		<div id="desplegable_datos_pir_proveedor" class="panel-body">
			
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-12">
					  
					<div class="form-group row">
					
					  	<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_envio_d" class="control-label">Fecha Envio</label>
								<input type="date" id="txtfecha_envio_d" class="form-control" required="" name="txtfecha_envio_d" value="<%=campo_fecha_envio%>" /> 
							</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="txtfecha_entrega_pax_d" class="control-label">Fecha Entrega Pax</label>
							<input type="date" id="txtfecha_entrega_pax_d" class="form-control" required="" name="txtfecha_entrega_pax_d" value="<%=campo_fecha_entrega_pax%>" /> 
						</div>
						<div class="col-sm-4 col-md-4 col-lg-4">
							<label for="cmbreferencia_maleta_entregada_d" class="control-label">Referencia</label>
							<div class="clearfix visible-md-block"></div>
							<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input class="js-typeahead-french_v1 form-control" name="cmbreferencia_maleta_entregada_d" id="cmbreferencia_maleta_entregada_d" type="search" placeholder="Search" autocomplete="off" value="<%=cliente_seleccionado%>">
										</div>
									</div>
								</div>
							<select id="cmbreferencia_maleta_entregada_d__" name="cmbreferencia_maleta_entregada_d__" data-width="100%" class="cmb_bt">
							  <option value="">&nbsp;</option>
							  <option value="CHTLJMXW3">CHTLJMXW3</option>
							  <option value="FGGHNBV">FGGHNBV</option>
							  <option value="PNOLDSJG">PNOLDSJG</option>
							  <option value="SAMOEH">SAMOEH</option>
							  <option value="VCTPZG">VCTPZG</option>
							</select>
							
							<form id="form-user_v1" name="form-user_v1">
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input class="js-typeahead-user_v1" name="user_v1[query]" id="controlcito" type="search" placeholder="Search" autocomplete="off">
										</div>
									</div>
								</div>
							</form>
							
						</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="cmbtipo_maleta_entregada_d" class="control-label"
								data-toggle="popover" 
								data-placement="top" 
								data-trigger="hover"
								data-content="Tipo Bag Entregada"
								>T. Bag Entreg.</label>
							<div class="clearfix visible-md-block"></div>
							<select id="cmbtipo_maleta_entregada_d" name="cmbtipo_maleta_entregada_d" data-width="100%" class="cmb_bt">
							  <option value="">&nbsp;</option>
							  <%if not vacio_proveedores_tipos_maleta then
											for i=0 to UBound(tabla_proveedores_tipos_maleta,2)%>
												<option value="<%=tabla_proveedores_tipos_maleta(campo_id_tipo_maleta_proveedor,i)%>"><%=tabla_proveedores_tipos_maleta(campo_descripcion_tipo_maleta_proveedor,i)%></option>
											<%next
										
							  end if%>
							</select>
						</div>
						
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="cmbtamanno_maleta_entregada_d" class="control-label">Tamaño</label>
							<div class="clearfix visible-md-block"></div>
								<select id="cmbtamanno_maleta_entregada_d" name="cmbtamanno_maleta_entregada_d" data-width="100%"  class="cmb_bt">
								  <option value="">&nbsp;</option>
								  <option value="PEQUEÑA">PEQUEÑA</option>
								  <option value="MEDIANA">MEDIANA</option>
								  <option value="GRANDE">GRANDE</option>
								</select>
						</div>
						
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="txtcolor_maleta_entregada_d" class="control-label">Color</label>
							<input type="text" id="txtcolor_maleta_entregada_d" class="form-control" required="" name="txtcolor_maleta_entregada_d" value="<%=campo_color_bag_entregada%>" /> 
						</div>
						
					  </div>
					</div>
				</div>						  
				
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-12">
					  <div class="form-group row">
					  	
				  		<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtnumero_expedicion_d" class="control-label">N&uacute;m Expecici&oacute;n</label>
								<input type="text" id="txtnumero_expedicion_d" class="form-control" required="" name="txtnumero_expedicion_d" value="<%=campo_numero_expedicion%>" /> 
						</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtcostes_d" class="control-label">Importe Coste</label>
								<input type="text" id="txtcostes_d" class="form-control" required="" name="txtcostes_d" value="<%=campo_costes%>" /> 
						</div>
					  </div>
					</div>
				</div>			
				
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-12">
						<div class="form-group row">
							<div class="col-sm-12 col-md-12 col-lg-12">
								<label for="txtobservaciones_proveedor_d" class="control-label">Observaciones</label>
    		                    <input type="text" class="form-control" style="width: 100%;"  id="txtobservaciones_proveedor_d" name="txtobservaciones_proveedor_d" value="<%=campo_observaciones_proveedor%>" maxlength="72" />
							</div>
						</div>
					</div>
				</div>
						
							
				
		
	  </div>
		<!-- panel Body-->
	</div>
	<!-- fin datos pir proveedor-->
	
	
	
	
	<div class="panel" id="botones">
		<div id="desplegable_botones" class="panel-body">
			<div class="form-group row">
				<div class="col-sm-12 col-md-12 col-lg-12">
					<div class="col-sm-2 col-md-2 col-lg-2">
						<button type="button" class="btn btn-primary btn-lg" id="cmdguardar_pir" name="cmdguardar_pir">
						  <span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Guardar Pir
						</button>
					</div>
				</div>
			</div>
		
		
		</div>
	</div>
	<!--fin datos estado-->				
	

		<%'no es un alta
		if id_seleccionado<>"" then%>
			
			<div class="panel panel-primary" id="datos_pir_historico_actividad">
				<div class="panel-heading">
					<h3 class="panel-title">HIST&Oacute;RICO EXPEDIENTE</h3>
					<span class="pull-right clickable">
						<i class="glyphicon glyphicon-chevron-down"
							data-toggle="popover" 
							data-placement="left" 
							data-trigger="hover"
							data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
						></i>
					</span>
					
				</div>
				
				<div id="desplegable_datos_pir_historico_actividad" class="panel-body">
					<div class="form-group">
						<div class="col-sm-12 col-md-12 col-lg-12">
								  <!--
								  <div width="95%">
											<div class="btn-group" role="group" id="botones_historico">
											  <button type="button" class="btn btn-default">Todo</button>
											  <button type="button" class="btn btn-default">Hist&oacute;rico</button>
											  <button type="button" class="btn btn-default active">Incidencias</button>
											</div>
									</div>
									-->
									<div width="95%">
																		
											 <table id="lista_historico_pir" name="lista_historico_pir" class="table table-bordered" cellspacing="0" width="100%">
											  <thead>
												<tr>
												  <th class="col-xs-1">Fecha</th>
												  <th class="col-xs-1">Hora</th>
												  <th class="col-xs-1">Acci&oacute;n</th>
												  <th class="col-xs-1">Campo</th>
												  <th class="col-xs-2">Valor Antiguo</th>
												  <th class="col-xs-2">Valor Nuevo</th>
												  <th class="col-xs-1"><i class="glyphicon glyphicon-user"
														data-toggle="popover_datatable"
														data-placement="top"
														data-trigger="hover"
														data-content="Usuario"></i>
												  </th>
												  <th class="col-xs-3">Descripci&oacute;n</th>
												  
						
												</tr>
											  </thead>
											</table>
										
								</div>
						</div>
					</div>
				
				
				</div>
			</div>
			<!--fin datos pir historico actividad-->				
		
			<%end if%>

	
	</form>


</DIV><!--CONTAINER-->

 <!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->

<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>

<script type="text/javascript" src="plugins/dataTable/media/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/media/js/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.flash.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/jszip.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/pdfmake.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/vfs_fonts.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.print.min.js"></script>

<script type="text/javascript" src="plugins/bootstrap-switch/js/bootstrap-switch.min.js"></script>
  
<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script>  
  

<script type="text/javascript" src="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min_unicode.js"></script>


<script language="javascript">
var j$=jQuery.noConflict();

j$(document).on('click', '.panel-heading span.clickable', function(e){
    var j$this = j$(this);
	if(!j$this.hasClass('panel-collapsed')) {
		//console.log('encuentra panel-collapsed')
		j$this.parents('.panel').find('.panel-body').slideUp();
		j$this.addClass('panel-collapsed');
		j$this.find('i').removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
	} else {
		//console.log('NOOO encuentra panel-collapsed')
		j$this.parents('.panel').find('.panel-body').slideDown();
		j$this.removeClass('panel-collapsed');
		j$this.find('i').removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up');
	}
})


j$(window).resize(function() {
   
  });  
  

j$(document).ready(function () {
	var prm=new ajaxPrm();
	
    //refresco la tabla anterior por si hay modificaciones
	//window.parent.lst_pirs.ajax.reload(); 
	
	
	//para que se reconfigure el combo como del tipo selectpicker
	j$('.cmb_bt').selectpicker()

	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true, container: 'body'});
	
	j$(".chk_bt").bootstrapSwitch();
    j$(".chk_bt").bootstrapSwitch("onText", "S&iacute;");
    j$(".chk_bt").bootstrapSwitch("offText", "No");

	j$("#chkdanno_ruedas_d").bootstrapSwitch("state", <%=lcase(campo_danno_ruedas_bag_original)%>);
	j$("#chkdanno_asas_d").bootstrapSwitch("state", <%=lcase(campo_danno_asas_bag_original)%>);
	j$("#chkdanno_cierres_d").bootstrapSwitch("state", <%=lcase(campo_danno_cierres_bag_original)%>);
	j$("#chkdanno_cremalleras_d").bootstrapSwitch("state", <%=lcase(campo_danno_cremallera_bag_original)%>);
	j$("#chkdanno_cuerpo_maleta_d").bootstrapSwitch("state", <%=lcase(campo_danno_cuerpo_maleta_bag_original)%>);
	j$("#chkdanno_otros_dannos_d").bootstrapSwitch("state", <%=lcase(campo_danno_otros_bag_original)%>);
	
	//console.log('combo estado antes asirgnarlo: ' + j$("#cmbestado_d").val()) 
	j$("#cmbestado_d").val('<%=campo_estado%>');
	//console.log('combo estado despues asignarlo: ' + j$("#cmbestado_d").val()) 
	if (j$("#cmbestado_d").val()=='9') //INCIDENCIA
		{
		j$("#mas_incidencias").removeClass('invisible')
		}
	if (j$("#cmbestado_d").val()=='8') //GESTION CIA
		{
		j$("#txtgestion_cia").val('')
		j$("#gestion_cia_explicacion").removeClass('invisible')	
		}
	
	j$("#cmbtipo_direccion_entrega_d").val('<%=campo_tipo_direccion_entrega%>');
	j$("#cmbdesde_hasta_d").val('<%=campo_desde_hasta%>');
	j$("#cmbtipo_maleta_d").val('<%=campo_tipo_bag_original%>');
	
	j$("#cmbproveedores_d").val('<%=campo_proveedor%>');
	
	j$("#cmbtipo_maleta_entregada_d").val('<%=campo_tipo_bag_entregada%>');
	j$("#cmbtamanno_maleta_entregada_d").val('<%=campo_tamanno_bag_entregada%>');
	j$("#cmbreferencia_maleta_entregada_d").val('<%=campo_referencia_bag_entregada%>');
	
	j$(".cmb_bt").selectpicker('refresh')
	
	/*
	j$.typeahead({
		input: '.js-typeahead-french_v1___',
		minLength: 0,
		maxItem: 15,
		order: "asc",
		hint: true,
		accent: true,
		searchOnFocus: true,
		backdrop: {
			"background-color": "#3879d9",
			"opacity": "0.1",
			"filter": "alpha(opacity=10)"
		},
		source: {
			ab: "/jquerytypeahead/french_v1.json"
		},
		debug: true
	});
	*/
	/*
	j$.typeahead({
		input: '.js-typeahead-french_v1',
		//input: '.typeahead_clientes',
		minLength: 0,
		maxItem: 15,
		order: "asc",
		hint: true,
		accent: true,
		cancelButton: false,
		searchOnFocus: true,
		backdrop: {
			"background-color": "#3879d9",
			"opacity": "0.1",
			"filter": "alpha(opacity=10)"
		},
		source:  "/tojson/Obtener_Referencias_Maletas.asp",
		callback: {
			onInit: function (node) {
				console.log('Typeahead Initiated on ' + node.selector);
			}
		},
		debug: true
	});
	*/
	
	j$.typeahead({
		input: '.js-typeahead-user_v1',
		minLength: 1,
		order: "asc",
		dynamic: true,
		delay: 500,
		backdrop: {
			"background-color": "#fff"
		},
		template: function (query, item) {
	 
			var color = "#777";
			/*
			if (item.status === "owner") {
				color = "#ff1493";
			}
			*/
	 
			return '<span class="row">' +
				'<span class="avatar">' +
					'<img src="{{avatar}}">' +
				"</span>" +
				'<span class="referencia">{{REFERENCIA}} <small style="color: ' + color + ';">({{TIPO_MALETA}}) ({{TAMANNO}}) ({{COLOR}})</small></span>' + 
			"</span>"
		},
		emptyTemplate: "no hay resultados para {{query}}",
		source: {
			maleta: {
				display: ["REFERENCIA", "TIPO_MALETA", "TAMANNO", "COLOR"],
				ajax: function (query) {
					return {
						type: "GET",
						url: "tojson/Obtener_Referencias_Maletas.asp",
						//{"status":true,"error":null,"data":{"user":[{"id":748137,"username":"juliocastrop","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/748137"},{"id":5741776,"username":"solevy","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/5741776"},{"id":906237,"username":"nilovna","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/906237"},{"id":612578,"username":"Thiago Talma","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/612578"},{"id":985837,"username":"ldrrp","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/985837"}],"project":[{"id":2,"project":"jQuery Validation","image":"http:\/\/www.runningcoder.org\/assets\/jqueryvalidation\/img\/jqueryvalidation-preview.jpg","version":"1.4.0","demo":11,"option":14,"callback":8}]}}
						//path: "data.user",
						path: "data",
						data: {
							q: "{{query}}"
						},
						callback: {
							
							}
						}
					}
				
	 
			}
			
		},
		callback: {
			onClick: function (node, a, item, event) {
	 
	 
				// You can do a simple window.location of the item.href
				console.log(item.COLOR)
				alert(JSON.stringify(item));
				j$("#controlcito").val(item.REFERENCIA)
				j$("#cmbtipo_maleta_entregada_d").val(item.TIPO_MALETA)
				j$("#cmbtamanno_maleta_entregada_d").val(item.TAMANNO)
				j$("#txtcolor_maleta_entregada_d").val(item.COLOR)
				console.log(item.COLOR)
				
	 
			},
			onSendRequest: function (node, query) {
				console.log('request is sent')
			},
			onReceiveRequest: function (node, query) {
				console.log('request is received')
			}
		},
		debug: true
	});
	
	
	/*
	j$.typeahead({
		input: '.js-typeahead-french_v1___',
		//input: '.typeahead_clientes',
		minLength: 0,
		maxItem: 15,
		order: "asc",
		hint: true,
		accent: true,
		cancelButton: false,
		searchOnFocus: true,
		backdrop: {
			"background-color": "#3879d9",
			"opacity": "0.1",
			"filter": "alpha(opacity=10)"
		},
		source: {
			data: [
				"* NEUMATICOS ANDRES (USAR 3248 )","*** GLOBALIA DISTRIBUCIONES GRAFICAS SA","101 ATESA MADRID - PLAZA ESPAÑA","102 ATESA ALCORCON","103 ATESA MADRID-AEROPUERTO","104 ASM PLASENCIA 2","104 ATESA MADRID-DR. ESQUERDO","105 ASM CACERES","105 ATESA MADRID-ESTACION TREN CHAMARTIN AVE","106 ASM CACERES PUEBLOS","108 ATESA ALCOBENDAS","109 ATESA VALLADOLID-ESTACION TREN","111 ATESA TALAVERA DE LA REINA","113 ASM CIUDAD REAL","113 ATESA CIUDAD REAL-ESTACION TREN","114 ATESA MADRID-PINTO","115 ATESA LA RIOJA-LOGROÑO","117 ATESA LAS ROZAS","118 ATESA PUERTOLLANO-ESTACION TREN AVE","119 ATESA TORREJON","12 GLS VITORIA","120 ASM CASTELLON           ","120 ATESA MADRID-GENERAL MOSCARDO","121 ATESA MADRID-SAN SEBASTIAN DE LOS REYES","122 ATESA TRES CANTOS","123 ATESA MOSTOLES","124 ATESA MADRID-ESTACION TREN ATOCHA AVE","125 ASM CASTELLON","125 ATESA MADRID-COLLADO MEDIANO","126 ATESA TOLEDO","127 ATESA MADRID-COSLADA","128 ATESA LEGANES","130 ASM CHILLON","132 ASM CIUDAD REAL ESTE","137 ASM SABADELL","141 ASM CORDOBA CENTRO","144 ASM LUCENA","145 ASM PUENTE GENIL","146 ASM VILLA EL RIO","147 ASM MARTORELL","148 ASM SANT MARTI","149 ASM SAGRADA FAMILIA","15 ASM VITORIA SUR","150 ASM CORUÑA CENTRO","150 CHARTER SL","151 ASM SANTIAGO NORTE","154 ASM BERTAMIRANS","159 ASM VILADECANS","161 ASM MOTA DEL CUERVO","165 ASM MONTCADA NEW","173 ASM PLT. GERONA","175 ASM GIRONA","180 ASM GRANADA","181 ASM MOTRIL","182 ASM GRANADA PARQUE","183 ASM FUENTE VAQUEROS","188 ASM LA CHANA","190 ASM GUADALAJARA","191 ASM GUADALAJARA","198 ATESA SANT BOI","199 ATESA BARCELONA-POBLE NOU","20 ASM ALBACETE","200 ASM SAN SEBASTIAN","200 ATESA BARCELONA-MUNTANER","201 ASM DONOSTI","201 ATESA BARCELONA-AEROPUERTO","205 ASM BEASAIN","205 ATESA MALLORCA-PASEO MARITIMO","206 ATESA MALLORCA-AEROPUERTO","209 GLS AZPEITIA NEW","21 GLS ALBASIT","210 ATESA IBIZA-AEROPUERTO","212 ATESA MENORCA-AEROPUERTO","214 ASM ZALAMEA","215 ASM HUELVA SIERRA","215 ATESA REUS-ESTACION TREN","216 ATESA GERONA -AEROPUERTO","217 ASM HUELVA","218 ATESA GERONA-ESTACION TREN","219 ATESA GRANOLLERS","22 ASM ALBACETE PUEBLOS","220 ATESA BADALONA","222 ATESA SABADELL","223 ATESA LERIDA-AVDA. GARRIGUES","224 ATESA MATARO","225 ATESA TERRASSA","226 ATESA BARCELONA SANTS-ESTACION AVE","227 ATESA BARCELONA-MANRESA","228 ATESA TARRAGONA-E5ER BAYCAR","229 ATESA LERIDA-ESTACION TREN AVE","23 ASM ALMANSA","230 ATESA TARRAGONA-AVE RENFE","235 ASM JAEN 2           ","240 ASM LEON","242 ASM ASTORGA","243 ASM LEON MULTICENTRO","249 ASM UBEDA NEW","260 ASM LOGROÑO","270 ASM LUGO","273 ASM RABADE","275 GLS VISTAHERMOSA","280 ASM MADRID","283 ASM ALCALA DE HENARES","290 ASM MALAGA","292 GLS MALAGA","296 ASM MALAGA 7","298 ASM MARBELLA 2","299 ASM ANTEQUERA","300 ASM MURCIA","300 ATESA BILBAO","301 ATESA SAN SEBASTIAN","302 ATESA PAMPLONA ESTACION TREN","303 ATESA SANTANDER-ESTACION TREN","304 ATESA SANTANDER-AEROPUERTO","305 ATESA ZARAGOZA-ALCALDE GOMEZ LAGUNA","306 ATESA LEON","307 ATESA BILBAO-AEROPUERTO","308 ASM BARRIO DEL PROGRESO","310 ATESA SAN SEBASTIAN-AEROPUERTO","312 ATESA SALAMANCA","313 ASM PERALTA","313 ATESA BURGOS-RENFE","314 ATESA PONFERRADA-ESTACION TREN","315 ATESA VITORIA","316 ASM ALHAURIN DE LA TORRE","317 ATESA AVILA-RENFE","318 ATESA ZARAGOZA-ESTACION TREN AVE","320 ASM O BARCO DE VALDEORRAS","321 ATESA BARAKALDO E5NO","327 ASM TORREJON","329 ASM MADRID 07","333 DEPOT ASTURIAS","334 ASM GIJON NEW","339 ASM MORATALAZ","342 ASM POZUELO NEW","343 ASM MADRID 20","349 ASM CHAMARTIN","358 ASM CAMPO DE LAS NACIONES","359 ASM MADRID 45","36 ASM BULILLA","362 ASM VAROUSA","367 DEPOT VIGO","369 ASM MADRID NORTE","379 ASM TORMES","390 ASM SANTANDER","40 ASM ALMERIA","400 ASM SEGOVIA","400 ATESA ALICANTE-AEROPUERTO","401 ASM RIBERA DEL DUERO","401 ATESA VALENCIA-MANISES","402 ATESA VALENCIA-AEROPUERTO","403 ASM PROSPERIDAD","404 ASM SAN SEBASTIAN DE LOS REYES","404 ATESA MURCIA","405 ATESA VALENCIA-MASSANASSA","406 ASM TETUAN","406 ATESA ALBACETE-RENFE","407 ATESA CASTELLON-RENFE","408 ASM MADRID 54","410 ASM SEVILLA","410 ATESA ALICANTE-ESTACION TREN AVE","411 ATESA CARTAGENA-ESTACION TREN","412 ATESA MURCIA-SAN JAVIER","413 ASM CAMAS","413 ATESA VALENCIA-ESTACION TREN AVE","414 ATESA BENIDORM","417 DEPOT SEVILLA","422 ASM BOLLULLOS DE LA MITACION","423 ASM SEVILLA TRIANA","426 ASM SVQ","43 ASM LAS NORIAS","433 ASM TORTOSA L ALDEA","436 DEPOT TARRAGONA","45 ASM EL EJIDO","453 ASM TALAVERA","455 ASM ILLESCAS","456 ASM TOLEDO","46 ASM BULEVAR","460 ASM RIBARROJA","462 ASM VALENCIA CENTRO","463 ASM ALZIRA","464 ASM BENICALAP","465 ASM REQUENA","466 ASM PATERNA","467 ASM TORRENTE","473 VALLADOLID 2","480 ASM BILBAO","481 ASM BIZKAIA","482 ASM SANTUTXU","485 ASM BARAKALDO","488 ASM ETXEBARRI","492 ASM ZAMORA","496 ASM ALBAL","497 ASM BURJASSOT","4C COMUNICACION","4DOCTORS, S.L.","500 DEPOT ZARAGOZA","5009 ASM BENIDORM","501 ATESA SEVILLA-AEROPUERTO","502 ATESA GRANADA-SERV. A/E","5027 ASM MARTORELL","503 ASM ZARAGOZA","503 ATESA GRANADA","5040 ASM TARRAGONA - EXPRESS TGN 2017, S.L.","5042 ASM VILANOVA I LA GELTRU","505 ATESA CADIZ","5053 ASM MORON","5057 ASM EL PUERTO DE SANTA MARIA","5059 ASM ETXEBERRI","506 ASM XIRIVELLA","506 ATESA MALAGA-AVDA. GARCIA MORATO","5061 ASM SANT JUAN DESPI","5063 ASM SAN VICENTE","5064 ASM CORSEGA","5065 ASM HARO","5068 ASM FOGARS","5069 ASM MATARÓ 2","5069 ASM MATARO 2 (NO USAR)","507 ATESA MALAGA OFF AIRPORT","507 GLS VALENCIA","5071 ASM MOSTOLES","5106 ASM TALAVERA NEW","5108 ASM CIUDAD REAL","511 ATESA MERIDA","5110 ASM HUELVA NEW","5112 ASM NAVALCARNERO","5121 ASM AMES","5126 ASM AGUILAS","5132 ASM PALLEJA","5134 ASM MONTSIA","5136 ASM LORCA","5137 ASM ARTURO SORIA NEW","5138 ASM LEON NEW","5139 ASM SANT BOI DE LLOBREGAT NEW","514 ATESA JEREZ-AEROPUERTO","5140 ASM AXARQUIA NEW","5141 ASM VALENCIA NEW","5143 ASM SIERRA","5145 ASM HOSPITALET SUR","5146 ASM POLIGONO SALINAS","5147 ASM XATIVA","5148 ASM SANT FELIU DEL LLOBREGAT","5149 ASM CARDEDEU","515 ATESA CORDOBA-POL.IND. LAS QUEMADAS","5150 ASM TORTOSA L ALDEA","5154 ASM BURJASSOT","5157 ASM SANTA COLOMA DE GRAMENET","5158 ASM MOTA DEL CUERVO","516 ATESA UBEDA","5163 ASM FUENTES DE ANDALUCIA","5164 ASM GUADALQUIVIR","5167 ASM LUGO SARRIA","5173 ASM MADRID CENTRO","5174 ASM ERMUA","5179 ASM GANDESA","518 ATESA ALMERIA-AEROPUERTO","5183 ASM AVILES SALINAS","5184 ASM LLIRIA","5186 ASM SEVILLA HELIOPOLIS","5187 ASM RABADE","5188 ASM  PINOSO","5189 ASM TORRECARDENAS","5192 ASM ALCALA DE GUADAIRA","5194 ASM ZAMORA CENTRO","5195 ASM TORRELODONES","5196 ASM UBRIQUE","5197 ASM SALAMANCA VILLARES","5199 ASM EJEA DE LOS CABALLEROS","5200 ASM FIGUERAS","5201 DEPOT MATARO","5203 ASM EL PARADOR","5205 ASM ALMANSA","521 ATESA MARBELLA","522 ATESA JAEN-ESTACION TREN","5220 ASM ZARAGOZA PORTAZGO","5229 ASM PATERNA","523 ATESA SEVILLA-ESTACION TREN AVE","5235 ASM SON ROSSINYOL","5239 GLS PINO MONTANO","524 ATESA MALAGA-P. IND. HUERTA DEL CORREO","5243 ASM BALAGUER","5245 ASM SAN JUAN","5249 ASM ALAQUAS","525 ATESA SEVILLA-POL. IND. LA NEGRILLA","5251 GLS PLT BCN NORTE","5254 ASM PUERTO DE SAGUNTO","526 ATESA MALAGA-ESTACION TREN AVE","5262 ASM FUENLABRADA","5263 ASM VALL D´UIXO","5267 ASM PLATAFORMA TARRAGONA","527 ATESA CACERES","5274 ASM CORIA","5275 DEPOT ASTIGARRAGA","5279 GLS PEDROSA","528 ATESA JAEN-LINARES","5283 ASM MAIRENA DEL ALJARAFE","5285 ASM CREVILLENTE","5289 GLS ALCOY SUR","5291 ASM ZONA SUR","5298 ASM PINTO","5299 ASM MATARO NEW","53 ASM ALICANTE","530 ATESA CORDOBA-ESTACION DE AUTOBUSES-E5U7","5301 ASM TORRALBA","5302 ASM LORCA NEW","5303 ASM COLMENAR VIEJO","5305 ASM CALELLA","531 ATESA ALGECIRAS-PUERTO MARITIMO","5317 ASM PALMA CENTRO","532 ATESA SEVILLA-MAIRENA DE ALJARAFE","5320 GLS HUERCAL OVERA","5321 ASM TORRELLANO","5322 GLS MANCHA REAL","5326 GLS SANT SADURNI D´ANOIA","5328 GLS LA LINEA","533 ATESA SEVILLA-DOS HERMANAS","5331 GLS HARO","5332 GLS BAZA NEW","5336  GLS LOS ANGELES","5339 GLS MEJORADA","534 ATESA ALMERIA-ESTACION TREN","5340 GLS CALAHORRA","5348 GLS VALDEPEÑAS","535 ATESA HUELVA-RENFE","5350 ASM TORRELAVEGA NEW","5356 GLS GUADIX","5359 GLS AVILA SUR","5360 GLS ARAVACA","5363 GLS LA CAÑADA","5364 GLS S.F. HENARES","5365 GLS CORDOBA ARCANGEL","5369 GLS EL ZAPILLO","537 ATESA CACERES-PLASENCIA","538 ATESA MALAGA-ANTEQUERA","539 ATESA JEREZ","540 ATESA BADAJOZ","562 ASM ANDORRA NEW","565 ASM ECIJA","581 DEPOT ALICANTE","583 ASM ATOCHA","584 ASM GETAFE 2","588 ASM MADRID 588","592 ASM UBRIQUE","595 ASM BRAVOMURILLO","600 ATESA LA CORUÑA-ESTACION TREN","6005 ASM FUENTE VAQUEROS","601 ATESA LA CORUÑA-AEROPUERTO","602 ATESA VIGO-ESTACION DE TREN GUIXAR","603 ATESA VIGO-AEROPUERTO","605 ATESA SANTIAGO-AEROPUERTO","606 ATESA OVIEDO","607 ATESA ASTURIAS-GIJON","609 ATESA LUGO-CURROS ENRIQUEZ","610 ATESA FERROL-NARON","613 ATESA SANTIAGO-ESTACION TREN","619 ATESA ORENSE-RENFE","620 ASM PAMPLONA","620 ATESA PONTEVEDRA-ESTACION TREN","621 ATESA ASTURIAS-AVILES-EST. AUTOBUSES","622 ASM BARCELONA 34","631 ASM VALENCIA PLT","634 ASM CORCEGA","639 ASM BARBERA DEL VALLES","645 ASM CADIZ SUR","647 ASM HOSPITALET","649 ASM MATARO CENTRE","650 ASM PLT. HOSPITALET","655 GLS ARAVACA","668 ASM SANTIAGO NEW","67 ASM MERIDA","673 ASM EL PRAT DE LLOBREGAT","675 ASM ERMUA","679 ASM SARRIA","682 ASM SANT JUAN DESPI","685 ASM PALMA PONIENTE","687 GLS MADRID","688 ASM SANT JUST DESVERN","691 ASM OLLONIEGO","692 ASM FUENTES DE ANDALUCIA","693 ASM FREGENAL","698 ASM MALAGA CENTRO","70 ASM PALMA MALLORCA      ","700 ASM ORENSE","703 ASM NAVALCARNERO","706 ASM COX","709 ASM VILLENA","710 ASM SAN VICENTE","713 ASM ALICANTE NEW","715 ASM ALMERIA BP","72 ASM MAO","722 ASM IGUALADA","725 ASM ZONA OLIMPICA","726 ASM HOSPITALET FIRA","728 ASM PRIVALIA","729 ASM SABADELL","734 ASM SANT FELIU","737 ASM SANT BOI CENTRO","743 ASM POLINYA","745 ASM SALINAS","746 ASM VILAFRANCA","752 ASM SANLUCAR","753 ASM MONTSIA","754 ASM POIO","759 ASM CORDOBA BP","760 ASM BERGONDO","762 ASM PUEBLA","773 ASM CABANILLAS","774 ASM FERROL","780 ASM BARCELONA 27","783 ASM TROBAJO DEL CAMINO","791 ASM ALCOBENDAS 3","796 ASM VENTAS","797 ASM RETIRO","798 ASM TORRELODONES","80 ASM BARCELONA","800 ASM COSLADA","801 ASM PRAT","802 ASM CARTAGENA","803 ASM ARGUELLES","804 ATESA MADRID - CASTELLANA","805 ASM CASTELLANA","807 ASM COLMENAR","808 ASM MOSTOLES","81 DEPOT BARCELONA","813 ASM BOADILLA DEL MONTE","815 ASM GETAFE","818 ASM LAS ROZAS","820 ASM SIERRA","821 ASM RIVAS-VACIAMADRID","823 ASM LEGANES","831 ASM BENALMADENA","835 ASM LORCA","846 ASM RIERA BLANCA","848 ASM VIGO","852 ASM SANT VICENT MOLINS (852)","855 ASM BARCELONA 12","856 ASM B. PILAR","859 ASM ANSAMO LOGISTICA","86 ASM BARBERA PLT.","861 ASM BARCELONA 903","866 ASM SEVILLA NEW","87 GLS VALLES","872 LIBRA, S.L.","876 ASM REQUENA NEW","877 ASM MASSAMAGRELL","878 ASM ALBORAYA","879 ASM VALENCIA SUR","882 ASM GANDIA","887 DEPOT  BILBAO","895 ASM MALLEN","899 ASM SOCUELLAMOS","90 ASM BURGOS","902 ASM SANT FRUITOS DE BAGES","905 ASM PILAS","913 ASM VILANOVA I LA GELTRU","914 ASM MAJADAHONDA 2","915 ASM SANSE2","920 ASM HUELVA COSTA","925 ASM SAN SEBASTIAN DE LOS REYES NEW","926 ASM EL VENDRELL NEW","933 ASM VILASECA","936 ASM EJEA DE LOS CABALLEROS","942 ASM BURGOS II","948 ASM PUERTO DE SAGUNTO","99 ASM BARCELONA 08","A. F. DISEÑO Y COMUNICACION","ABADIA DE LOS TEMPLARIOS","ABADIA DE VALVANERA","ABBA ACTEON","ABBA BALMORAL","ABBA BURGOS","ABBA CASTILLA PLAZA","ABBA CENTRUM ALICANTE","ABBA COMILLAS GOLF","ABBA FONSECA","ABBA FORMIGAL","ABBA GARDEN","ABBA GRANADA","ABBA HOTEL BERLIN GMBH","ABBA HOTELES","ABBA HUESCA","ABBA JAZZ","ABBA MADRID","ABBA PALACIO ARIZÓN","ABBA PALACIO DE SOÑANES","ABBA PARQUE","ABBA PLAYA GIJON","ABBA RAMBLA","ABBA REINO DE NAVARRA","ABBA SANTANDER","ABBA SANTS","ABBA XALET SUITES","ACEITES ELKOSAN, S.L.","ACERSAN SALAMANCA, S.L.","ACREMAR","ACTIVA MUTUA","ACYGASA AGENCIA CMCAL Y GESTION AGRARIA SALAMANCA","ADRIAN MARTIN PASCUA","ADVENTIA EUROPEAN COLLEGE OF AERONAUTICS","AENA, S.A.","AEROLINEAS ESTELAR LATINOAMERICA","AERONOVA S.L.","AESCON-CONFAES","AES-VILLARES. CONFAES","AGINCOURT 2008, S.L.","AGRO TRACCION VEHICULOS S.A","AGRUPACION SOCIALISTA DE ALBA DE TORMES","AGUSTIN DEL CASTILLO GALAN","AIMFAP (ASOCIACION DE IMPORTADORES, MAYORISTAS Y F","AIR EUROPA LINEAS AEREAS, S.A.","AIR EUROPA SOLIDARIA","AIR EUROPA SUMA MILES","AIR FRANCE","AIRSHOP SOLUTIONS","AISLAMIENTOS AINSOPER, S.L.","ALAYKA BAR HOSTAL","ALBA RODRIGUEZ","ALBERTO CAMPOS - COMPAÑIA NACIONAL DE IMPORTACION","ALBERTO GALLEGO MURIEL","ALBERTO GUTIERREZ PEREZ","ALBERTO HERNANDEZ ALBA","ALBERTO SANCHEZ FERRERAS - WINNERS OSCAR, S.L.","ALBERTO SANCHEZ MEDINA - SUMESAL","ALBERTO VAZQUEZ PERFECTO (365 ABOGADOS)","ALCAESAR TRANSPORTE URBANO, S.L.","ALEJANDRO DE LA CALLE SANTOS","ALEJANDRO FERNANDEZ ROBLES","ALEJANDRO OTERO GONZALEZ","ALEX DISEÑO GRAFICO","ALEXIS MORIÑIGO CALAIS","ALFONSO SAN CAYETANO HERRERO (PISCINAS CABRERIZOS)","ALMA CHARRA CB","ALUSAL - FLAVIANO GARCIA SANCHEZ","ALVARO BENITO CORTES","ALVARO HERRERA TABERNERO","ALVINSA, S.C.L.","AM RESORTS","AMADOR VICENTE HERNANDEZ","AMBAR TOURS","AMELIA LOPEZ GARCIA - TIJERITAS MAGICAS, S.L.L.","AMELLA HOTELS, S.L","AMIGOS DEL SILENCIO CASA DE LOS POBRES","AMILAXA SERVICIOS INTEGRALES","AMPA SANTA CRUZ","AMPARO FERNANDEZ CORDOBES","ANA BAUTISTA GONZALEZ","ANA SANPEDRO FIZ","ANGEL ANTONIO LEÓN PRIETO","ANGEL GARCIA RIVERO","ANGEL PAES MARTIN - GOLF MAIORIS","ANGEL RUFINO DE HARO","ANGELA CURTO MACHI","ANGELITOS - MONICA MARTIN SANTIAGO","ANTOLIN SANCHEZ GONZALEZ","ANTONIO GARA","ANTONIO JULIÁN PÉREZ","API EVENTOS Y PUBLICIDAD","APLIFISA","APRENDIVER SALAMANCA","APRENDIVER SALAMANCA, S.L.","AQF - AQUAFORM INSTALACION Y MANTENIMIENTO, S.L.","AQUAFORM SERVICIOS","AQUATERAPIA SPA CENTER","ARANZAZU ABOGADOS","ARATH VIAJES","ARCAL SOLUCIONES, S.L.","ARCO WINE INVESTMEN GROUP S.A.","ARMANDO, S.L. CERAMICAS Y REFORMAS","ARS EXPRESS","ARTESANIA ALIAGA","ARTESANIA PATRY, S.L.","ARTESANOS DEL ARCO HERNANDEZ","ARTURO VEGA SEOANE","ASADE. ASOCIACION SALMANTINA DE EQUINOTERAPIA","ASADOR ALMEIDA-HERNANDEZ. ALBERTO ALMEIDA MARTIN","ASADOR EL RANCHO ARGENTINO - RIGARUSSO ASOCIADOS,","ASAJA SALAMANCA","ASESORIA INTEA, S.L.","ASESORIA SIGLO 21, C.B.","ASM 180 GRANADA","ASM 183 FUENTEVAQUEROS","ASM 185 ALBOLOTE","ASM 270 LUGO","ASM 40 ALMERIA","ASM 406 TETUAN","ASM 5058 IMARCOAIN","ASM 5125 ALHAURÍN DE LA TORRE","ASM 740 BADALONA","ASM 796 VENTAS","ASM 848 VIGO","ASM 878 ALBORAYA","ASM, S.A.","ASOC. CRISTO DE SAN ESTEBAN DE LA SIERRA","ASOC. CULTURAL PEÑA VIRGEN NIEVES","ASOC. ESPAÑOLA CONTRA EL CANCER","ASOC.DE VECINOS HUERTA OTEA","ASOCIACION CULTURAL DE PEÑAS Y JUVENTUD ALBENSE","ASOCIACION CULTURAL EDUCATIVA LEXGO -MARIA HIGUERO","ASOCIACION CULTURAL PIZPIRIGAÑA","ASOCIACION DE AMAS DE CASA Y CONSUM.","ASOCIACIÓN DE ANTIGUOS ALUMNOS DE MARÍA CORREDENTO","ASOCIACION DE FUTBOL DEL TORMES.CLUB DEPORTIVO CDA","ASOCIACION DE GRUPOS Y MUSICOS DE ALCALA","ASOCIACION DE I.TENICOS SANIT. SAN ALBERTO MAGNO","ASOCIACION DE LA CUNA AL SEPULCRO. RUTA SANTA TERE","ASOCIACION DE MAYORES VIRGEN DE LA ENCINA","ASOCIACION DE MUJERES VIRGEN DE PEDRARIAS","ASOCIACION EL ROCIO","ASOCIACION IRON SKULLS CO","ASOCIACION LA FUENTECILLA DE COCA DE ALBA","ASOCIACION MUSICAL VIRGEN DE LA VEGA","ASOCIACION PEÑA DE FESTEJOS VILLANUEVA DEL CONDE","ASOCIACION RUTA DEL VINO DE LA SIERRA DE FRANCIA","ASOCIACION SALMANTINA DE KICKBOXING","ASOCIACION SALMANTINA DE PRENSA DEPORTIVA","ASPACE","ASUNCION CARMEN MULAS GOMEZ","ATENEA ASOCIACION DE APOYO A LAS ALTAS CAPACIDADES","ATISAE TRAUXIA ITV, S.L.","ATLER EFICIENCIA Y AHORRO","ATODOGAS ENERGIA LIMPIA, S.L.U.","AUDICYL AUDITORES, S.L.","AUSBANC EMPRESAS","AUTHELMAT","AUTO SALAMANCA, S.A.","AUTOESCUELA EL PILAR","AUTOPALAS SALAMANCA, S.L.","AUTOREPARACIONES HERCUMAR SALAMANCA , S.L.","AUTOS CRISMA, S.L.","AVELINA GUTIERREZ SAIZ","AVINTIA RACING, S.L.","AVORY INTERNATIONAL CELEBRITY ACCESS","AYTO. CABRERIZOS AREA CULTURAL","AYTO. DE ALDEHUELA DE LA BOVEDA","AYTO. DE SAN CRISTOBAL CUESTA","AYTO. DE SAN MARTIN DEL CASTAÑAR","AYTO. DE SARDÓN DE LOS FRAILES","AYUNTAMIENTO CALVARRASA DE ABAJO","AYUNTAMIENTO CARBAJOSA DE LA SAGRADA","AYUNTAMIENTO DE ALBA DE TORMES","AYUNTAMIENTO DE ALDEARRODRIGO","AYUNTAMIENTO DE ALDEATEJADA","AYUNTAMIENTO DE BEJAR","AYUNTAMIENTO DE CALZADA DE VALDUNCIEL","AYUNTAMIENTO DE CARRASCAL DE BARREGAS","AYUNTAMIENTO DE GARCIHERNANDEZ","AYUNTAMIENTO DE GOMECELLO","AYUNTAMIENTO DE LA ALBERCA","AYUNTAMIENTO DE SALAMANCA","AYUNTAMIENTO DE SALAMANCA BIBLIOTECA MUN. TORRENTE","AYUNTAMIENTO DE SAN CRISTOBAL CUESTA","AYUNTAMIENTO DE SANTA MARTA","AYUNTAMIENTO DE TRABANCA","AYUNTAMIENTO DE VALDELOSA","AYUNTAMIENTO DE VALVERDON","AYUNTAMIENTO DE VILLANUEVA DEL CONDE","AYUNTAMIENTO DE VILLARES DE LA REINA","AYUNTAMIENTO DE VILLASECO DE LOS GAMITOS","AYUNTAMIENTO SAN ESTEBAN DE LA SIERRA","BANCO CAJA ESPAÑA INV. CAJA DUERO","BAR ALICIO","BAR LA RUTA - MARIA GARCIA GALAPACHE","BAR REFUGIO","BAR RESTAURANTE FELIPE II - MANUEL ZARZA HERNANDEZ","BARCELÓ","BARCELÓ EL CASTILLO BEACH RESORT","BARCELO PUEBLO PARK","BARCELONA - CFV","BARLO SPORT SL","BAR-RESTAURANTE EL MESON","BASES CARTOGRÁFICAS Y MAPAS S.L.N.E","BC MAPS VECTOR, S.L.","BE GOOD","BE LIVE ADULTS ONLY MARIVENT","BE LIVE ALEA HOTEL","BE LIVE CITY AIRPORT MADRID DIANA","BE LIVE CITY CENTER MADRID SANTO DOMINGO","BE LIVE CITY CENTER TALAVERA","BE LIVE COLLECTION PALACE DE MURO","BE LIVE EXPERIENCE GRAND TEGUISE PLAYA","BE LIVE EXPERIENCE LA NIÑA","BE LIVE EXPERIENCE LANZAROTE BEACH","BE LIVE EXPERIENCE OROTAVA","BE LIVE EXPERIENCE PLAYA LA ARENA","BE LIVE EXPERIENCE TENERIFE","BE LIVE FAMILY COSTA LOS GIGANTES","BE LIVE FAMILY LANZAROTE RESORT","BE LIVE FAMILY PALMEIRAS","BE LIVE HAMACA","BE LIVE HOTELS, S.L.","BE LIVE PUNTA AMER","BE LIVE SON ANTEM","BE SMART ALEA","BE SMART NAYADE","BEATRIZ ALVARADO RODRIGUEZ","BECOOL PUBLICIDAD, S.L.","BENITO JOSE MARTIN HERNANDEZ","BEONPRICE","BERNABE CAMPAL, S.L.","BEROMAR MARMOLES Y GRANITOS, S.L.","BERONI INFORMÁTICA S.L.U.","BES CONTROL Y CALIDAD S.L.","BEST HOTELES, S.L.","BEY DELICIOUS SPAIN, S.L.U.","BIOENERGIA HUMANA, S.L.","BIOLOGICOS BIOBA, S.L.","BLANCO Y HDEZ FEDATARIOS PUBLICOS","BODA SPACE, S.L.","BT DE VIAJE OLIMPIA ZARAGOZA S.A","BUFFET SALAMANCA, S.L.","BULL DREAMS SL","BUSLOGON","BUSLOGON, S.L.","C.E.O.CONSULTORIA INTERNACIONAL DEPORTIVA MARINESC","C.F. SALMANTINO","CABALLERO Y VELAZQUEZ, S.L.","CAFE BAR RUVI - JOSE RUIZ CANTO","CAFE RECUELO","CAJA RURAL DE SALAMANCA","CALADAN IBERICA","CALAMA E HIJOS PROMOTORES, S.L.","CALEFACCIONES SIMÓN, S.L.","CALIXTO GARCIA QUEIPO DE LLANO","CALVIA BEACH THE PLAZA","CAMELOT - CHELU RESTAURACION, S.L.","CAMPAL-OIL GASOLEOS Y LUBRICANTES, S.L.","CAMPO DE GOLF DE SALAMANCA","CAMPO DE TIRO Y DEPORTES, S.A.","CAPRICHOS DE HOGAR","CARBURANTES Y SERVICIOS AREVALO, S.L.","CARLITO RECORDS SL","CARLOS CRISTINA MARTIN","CARLOS GARCIA PRIETO","CARLOS GONZALEZ REGUEIRO","CARLOS HIGUERA SERRANO","CARLOS NAVARRO","CARLOS UCAR RAMIREZ","CARMELITAS DESCALZOS","CARMEN","CARMEN BORREGO MUÑOZ  (PREIMPRESION)","CARNICA LOS PLANTIOS, S.L","CARNICAS ENTRESIERRAS, S.L.","CARNICAS IDECO S.L.","CARNICAS MULAS, S.L.","CARNICAS POLI","CARPINTERIA PABLOS, C.B.","CARRERAS DE CABALLOS DE SANLUCAR","CARTONAJES FERVI, S.A.","CASA DE LAS ASOCIACIONES (AERSCYL)","CASLESA MILAR","CASTILLO DEL BUEN AMOR-CASTILLO DE VILLANUEVA DE C","CATAI TOURS","CATEDRA INSERCION PROFESIONAL CAJA RURAL DE SALAMA","CBI TENSEI, S.L.","CEHAT","CELE MONTERO HIDALGO","CELESTINA MARTIN SOTO","CENTRAL DE COMPRAS MACERA, S.L.U.","CENTRAL DE COMPRAS TRANSINTER S.L.","CENTRO DE BELLEZA CAROLINA-CAROLINA SANCHEZ PEREZ","CENTRO DE FORMACION PERMANENTE UNIV. DE SALAMANCA","CENTRO DE RECUPERACION ESTETICA MAR NIETO","CENTRO INFANTIL PUNTITOS","CENTRO QUIROPRACTICO MATTHEWS, S.L.","CERRAJERIA HIMOSAMA, S.L.","CERRAJERIA MARTIN HERRERA","CESAR SANCHEZ GONZALEZ","CETAREA SALMANTINA, S.L.","CETRAMESA CARBURANTES, S.L.U.","CETRAMESA, S.A.","CGB INFORMATICA, S.L.","CHACITABERNA LA MONTANERA, S.L.","CHARO ALMARAZ ALMARAZ","CHCUATRO GAS COMERCIALIZADORA, S.L.","CHICBACK, S.L.","CHINA EASTERN AIRLINES","CHINA INTERNACIONAL TRAVEL","CHURRERIA CASIMIRO","CHURRERIA CASIMIRO - JOSE LUIS MORENO RODRIGUEZ","CINES VAN DYCK","CIPRIANO GARCÍA MORÁN","CIRCO HOLIDAY, S.L.","CISMASTOUR (GEOMOON)","CIVITATIS","CLINICA DENTAL ALBUCASIS (CRIADO-RIESCO)","CLINICA DENTAL ALBUCASIS (GALBAN)","CLINICA DENTAL ALBUCASIS (M. PUENTE)","CLINICA DENTAL ALBUCASIS (PALAO)","CLINICA DENTAL ALBUCASIS (TERESA GOMEZ","CLINICA DENTAL ALBUCASIS (YARTE)","CLINICA DENTAL ALBUCASIS C.O.E.","CLINICA DENTAL HERCLIDENT MONTECARMELO, S.L.","CLINICA DENTAL HERCLIDENT-ZURGUEN, S.L.","CLINICA DENTAL SALAMANCA, S.L.","CLINICA DENTAL SORIAS - VIANTO DENTAL, S.L.","CLINICA DENTAL URBINA, S.L.","CLINICA HERNADENT, S.L.","CLINICA MEDICA DR. JAVIER CORTES","CLINICA MEDICA DR. JAVIER CORTES, S","CLINICA RUVIER","CLUB ANDRAGA","CLUB BALONCESTO AVENIDA","CLUB DE AJEDREZ MALLORCA ISOLANI","CLUB DEPORTIVO BALONCESTO SANTA MARTA","CLUB DEPORTIVO BOXING ELITE SALAMANCA","CLUB DEPORTIVO CALVARRASA DE ABAJO","CLUB DEPORTIVO DANZABRERIZOS","CLUB DEPORTIVO EL TUBULAR","CLUB DEPORTIVO GUIJUELO","CLUB DEPORTIVO JESUITINAS H. DE JESUS","CLUB DEPORTIVO PIOJO","CLUB DEPORTIVO RIBERT","CLUB DEPORTIVO SALAMANCA RUGBY","CLUB DEPORTIVO VILLARES DE LA REINA","CLUB MI GOURMET, S.L.","CLUB SENDERISMO SAN CRISTOBAL CAMINA","CLUB VETERINARIO SALAMANCA-MARTA MURIEL ROMO","COFRADIA ERMITA NTRA. SRA. DEL CUETO","COLEGIO ANTONIO MACHADO","COLEGIO DE ESPAÑA Y AMBOS MUNDOS, S.L.","COLEGIO DE INGENIEROS CASTILLA DUERO","COLEGIO LOS SAUCES","COLEGIO MARISTA CHAMPAGNAT","COLEGIO MONTESSORI, S.L","COLEGIO OFICIAL DE MEDICOS DE SALAMANCA","COLEGIO PROFESIONAL DE ENFERMERIA","COLEGIO PROV ABOGADOS SALAMANCA","COLEGIO SAG.CORAZON-HIJAS DE JESUS","COLUMBUS HOTEL","COMERCIAL AINOAVANDA 2011 S.L.","COMERCIAL DE VINOS ACERA, S.L.","COMERCIAL GARCIA GONZALEZ - JAIGAL SALAMANCA, S.L.","COMERSUTEC SLU","COMISARIA DEL CUERPO NACIONAL DE POLICIA","COMISIONES OBRERAS-AYTO.SALAMANCA.  FSC CCO","COMUNIDAD DE PROPIETARIOS LA VALMUZA","CONCLAVE DE JUEGOS S.L.","CONDOMINIO DE LA PLAZA DE TOROS DE SALAMANCA","CONFAES-PREVENCION","CON-FLUIR COACHING","CONGELADOS Y MARISCOS JOSE LOPEZ","CONGRESUAL, S.L.L.","CONSTEC, S.L.U.","CONSTRUCCIONES CIVILES ALDASO, S.L.","CONSULTORIA ASOCIADOS ALONSO BLANCO, S.L.","CONTROL EXTERIOR, S.L.","COOLUMBUS BEER COMPANY, S.L.","CORPORACION FINANCIERA ARCO, S.A.","CORPORATE GOLF, C.B. - LUIS MORON SEMPRUN","COSTA CRUCEROS","COSTAS GALICIA","COTATRES EMPRESA CONSTRUCTORA, S.L.U.","COVEGA GANADERA","CREACIONES AUDIOVISUALES SALMANTINAS, S.L.","CREATIVOS DISEÑO GRAFICO, S.L.","CRISDAGO INVERSIONES, S.L.","CRISTALERIA CASTEVIDRIO","CRISTALERIAS ANTONIO TORIBIO, S.L.","CRISTINA ARIAS GARCIA","CRISTINA DIAZ DEL CERRO","CRONOSALAMANCA, S.L.","CRUCEMUNDO, S.L.","CRUZ ROJA ESPAÑOLA","D' BLANCO PRODUCCIONES, S.L.","D.C. GROUP S.A.T., S.L.","D.O.P. SIERRA DE SALAMANCA - ASOCIACION VITICULTOR","DANIEL ALONSO FERNANDEZ","DANIEL CURTO RIVAS","DANIEL JABATO HERRERO","DANIEL MARTIN ROJO","DANIEL SANCHEZ Y SANCHEZ","DANIEL VILLACORTA RAMOS","DAVID  CURTO","DAVID HERNANDEZ GARCIA","DB SCHENKER","DD GRAFICOS COMUNICACION VISUAL","DE ALBERO  BODAS & EVENTOS","DE LA FLOR PALOMERO S.L.","DE PRADO 2014, S.L. - HOSTAL GUD","DEFANIVA","DEHESA DE RODASVIEJAS ANTONIO CASTAÑO","DELEGACIÓN SALMANTINA DE BALONCESTO","DELICATESSING (SELECTION FROM SPAIN)","DELUIS CONTEMPORARY MAN","DENTISALUD - IGUALATORIO DENTAL ALBUCASIS","DESARROLLOS Y SOLUCIONES DE CATERING","DESGUACES VILLALBA, S.L.","DIALGASA, S.L.","DIAS LIBRES","DICOTEX, S.L.","DIEGO GÓMEZ MALDONADO","DIK BAXTER S.L","DIMENCOLOR","DINAMICA","DIOCESIS DE SALAMANCA","DIPE-APLICACIONES Y MARKETING ONLINE, S.L.","DIPUTACION DE AVILA","DIPUTACION PROVINCIAL SALAMANCA","DISAPEL, S.L.","DISCALSA, S.L.","DISTRIBUCIONES DE LA CALLE","DISTRITO 13 - PLANET SHIRT, S.L.","DOMINGO SANCHEZ BOYERO","DOS X DOS DISEÑO & COMUNICACION, S.L.","DOSA FOTOCOPIAS","DULCE Y SALADO","EBOLI MUEBLES DE COCINA Y BAÑO","ECO CASTILLA, S.L.","ECOMT ACTUARIOS Y AUDITORES S.L.","ECOTISA TELEMARKETING, S.L.","ECOTISA UNA TINTA DE IMPRESION, S.L.U.","EDICIONES TIERRA SANTA","EDIFICIO CANALEJAS 33-35, S.L.","EDIFICIO TORO PLAZA, S.L.","EDIPRO ( E. MARCOS 2016 S.L)","EDSA CONSTRUCCION -EURODUERO SERVICIOS AUXILIARES,","EDUCATECA","EDUCATECA  CENTRO DE ESTUDIOS","EGINA WEALTH MANAGEMENT, S.L.","EL BALCON DE MOGARRAZ","EL BAR DE CHUCHI - Mª ILUMINADA SANTOS GARCIA","EL BARATO JUGUETERIA - ENRIQUE GARCIA SAN JOSE","EL CORTE INGLES","EL HINOJAL, S. COOP.","EL MESON DE GONZALO-POETA IGLESIAS DE HOSTELERIA,","EL RINCÓN DE MI BEBÉ","EL TESO REDONDO","ELECTRICIDAD CROMALUX, S.L.","ELECTRO CLISA, S.L.","ELECTRODOMESTICOS ALBERTO, S.L.","ELECTRODOMESTICOS MORENO","ELECTROVILAR UNIPESSOAL, LDA.","ELEFFAN FORMACION & DESARROLLO","ELEMAR INVERSIONES, S.L.","ELENA GARCIA PENA","ELENA GONZALEZ PALACIOS","ELENA RUANO SANCHEZ","ELMEUVIATGE","ELO INVERSIONES, S.L.U.","E-LOG CANARIAS - E-LOG LOGISTICA INSULAR, S.L.","ELVIRA FUENTES MARTIN","EME TIENDAS","EMILIO JOSE PEREZ","ENCIERRO EXHIBITION","ENRIQUE CARILLO TEBAR","ENRIQUE LUIS MONTEJO MARIA","ENRIQUE MATEOS GASCUEÑA","ENRIQUE MUÑOZ RODRIGUEZ","ENTERPRISE ATESA","ENTERPRISE HOLDINGS FRANCE","ENVIALIA - MASENVIO, S.L.","ESCUELA ACADEMIA SPORTING ESPAÑA","ESCUELA DE JUDO SEIZA-CLUB DEPORTIVO ELEMENTAL JUD","ESCUELA INTERNACIONAL DE NEGOCIOS M-MCOACHING SL","ESLA CENTROS DE FORMACION S.L","ESPECTACULOS BENITEZ, S.L.","ESPONSORAMA S.L.U","ESTACION DE SERVICIO CABRERIZOS, S.L.","ESTACION DE SERVICIO JUCALEX, S.A.U.","ESTERRA - HIPEROCIO, S.L.","ESTETICA DENTAL SALAMANCA, S.L","ESTETICA ESTER SUAREZ PINDADO - ESTETICA PROFESION","ESTETICA NATURAL HALAWA","ESTETICA Y MASAJE LUNA","ESTHER RODRIGUEZ POBLADOR","ESTUDIO DE CREACION","ESTUDIO JURIDICO MONROY","ETNA & CHRIS SL","ETSA - EXPRESS TRUCK S.A.U","EUDOXIO RODRIGUEZ HERRERO","EUGENIO AVILA, S.A.U.","EURO CASTILLA DE RECAMBIOS S.L.","EURODIVISAS, S.A","EUROINCOMING SL","EUROLINEAS MARITIMAS, S.A.L.","EUROMONTYRES, S.L.","EUROP ASSISTANCE S. I. G., S.A.","EUROPAMUNDO VACACIONES S.L","EUROSTAR PALACIO SANTA MARTA","EUROSTARS ANGLÍ","EUROSTARS ATLANTICO","EUROSTARS BARCELONA DESIGN","EUROSTARS CASA DE LA LIRICA","EUROSTARS CASCAIS","EUROSTARS CONVENTO CAPUCHINOS","EUROSTARS DAS ARTES","EUROSTARS DAS LETRAS","EUROSTARS GRAND MARINA","EUROSTARS HEROISMO","EUROSTARS HOTEL COMPANY S.L","EUROSTARS LAS CLARAS","EUROSTARS LAS CLARAS. MISELA HOTEL, S.L.","EUROSTARS LISBOA PARQUE","EUROSTARS MONUMENTAL","EUROSTARS MUSEUM","EUROSTARS OASIS PLAZA","EUROSTARS OPORTO","EUROSTARS PORTO CENTRO","EUROSTARS TORRE SEVILLA","EUROTAXI SALAMANCA - JESUS SIERRA GOMEZ","EUROWINGS AVIATION GMBH","EVA SANTOLINO LÓPEZ","EVENTOS VACA LOCA, S.L.","EVIMCOM FACTORY, S.L.","EVOLUZIONA 24.COM","EXE LAIETANA PALACE","EXPO MUJER SL","EXPOCOACHING (DAVID CABALLERO)","EXTINTORES CASTILLA","F. HERNANDEZ JIMENEZ E HIJOS, S.L.","FABRILOR IBERICA, S.L.","FASGA CASTILLALEON","FEAFES SALAMANCA AFEMC","FEDERACION DE KICKBOXING CASTILLA Y LEON","FELIPE HERRERO SAEZ - OFFISTOCK","FELTRERO DIVISION ARTE, S.L.","FELY CAMPO, S.L.","FERCO LOGISTICA","FERNANDO BECEDAS","FERNANDO DE DIOS ARMENTEROS","FERNANDO VAZQUEZ PERFECTO","FERNANDO VICENTE JABONERO","FERREIRA OPTICOS - NAFERRE, S.L.","FEXAS-FEDERACION EXTREMEÑA ASOCIACIONES PERSONAS S","FEYCE","FHASA AGROSALAMANCA, S.A.","FINCA EL CORTINAL ECOVILLAS 22, S.A.","FISIOTERAPIA DEL TENDÓN","FISIOTORMES CLINICA DE FISIOTERAPIA Y OSTEOPATIA","FITNESS PLACE VIALIA - SERRAN CENTER, S.L.","FLAVIA Y JAVIER VALVERDE","FLORENTINO ARTÍCULOS DE PELUQUERIA","FLORENTINO MUÑOZ HERVADA","FLOYMA, SDAD. COOP.","FOREVENT - JUAN MIGUEL DELGADO FERNANDEZ","FOTOCOPIAS RUA SALAMANCA, S.L. - DEYME","FRANCISCANOS PROV. SAN GREGORIO","FRANCISCANOS. PASTORAL JUVENIL VOCACIONAL","FRANCISCO ALVAREZ VILLAMARIN","FRANCISCO ANGEL VEGAS PRIMERO","FRANCISCO GONZALEZ SANCHEZ","FRANCISCO MANSO SAYAGUES","FRE OUTSOURCING","FREE BOHEMIA, SL.","FRIO HELMANTICA 4, S.L.","FRIPESA, SLU","FRUJUSA 2013, S.L.","FRUTERIA TARDAGUILA","FUND.SALAMANCA CIUDAD DE CULTURA Y SABERES","FUNDACIO PRIVADA JOIA","FUNDACION AGATHA RUIZ  DE LA PRADA","FUNDACION ALCANDARA - PROYECTO HOMBRE SALAMANCA","FUNDACION AMPAO","FUNDACION BASES","FUNDACION GENERAL UNIV. SALAMANCA","FUNDACION GERMAN SANCHEZ RUIPEREZ - CITA","FUNDACION GRAL UNIVERSIDAD SALAMANCA","FUNDACION GRUPO SIFU","FUNDACION LA GACETA REGIONAL","FUNDACION LUNA","FUNDACION OSTEOSITE","FUTUR VIAJES (W22)  (GEOMOON)","FYVAR (ASOCIACION INTERNACIONAL DE FABRICANTES Y","G3 MOTOR","GABINO PEREZ VALIENTE","GABRIEL CATERING","GABRIEL VICENTE E HIJOS, C.B.","GALERIA ANNIA","GANADERIA LORENZO PASCUAL INRA 401","GARALMA DE INVERSIONES S.L","GARCIA DOMINGUEZ Y ASOCIADOS","GARDEN HOTELES","GASOLINERA Y CARBURANTES EL PILAR","GAT CONSULTING & INVESTMENT - GRUPO ATENTO INVERSI","GC GROUP LUXURY REAL ESTATE CONSULTING","GEMINIANO","GENERAL LOGISTICS SYSTEM SPAIN S.L","GEOMOON","GERENCIA DE SALUD DE AREA DE SALAMANCA","GERMÁN SAN MÁXIMO SANTOS (TELECOM)","GESTORA DEL PUEBLO ESPAÑOL","GESTORIA GES","GESTORIA SEGAS","GETAUTO S.L","GILLES PHILIPPE CONTE","GINEFIV SL","GLOBAL CLEANING S.A","GLOBAL CONSULTING FINANCIAL AND LEGAL SOLUTIONS","GLOBALIA ACTIVOS INMOBILIARIOS, S.L.","GLOBALIA ARTES GRÁFICAS Y DISTRIBUCIÓN","GLOBALIA AUTOCARES LEVANTE, S.L.","GLOBALIA AUTOCARES, S.A.","GLOBALIA BROKER SERVICE, S.A.U.","GLOBALIA BUSINESS TRAVEL","GLOBALIA CALL CENTER, S.A.","GLOBALIA CORPORACION EMPRESARIAL","GLOBALIA CORPORATE TRAVEL","GLOBALIA EXPLOTACIONES HOTELERAS","GLOBALIA FORMACION, S.L.","GLOBALIA GESTION SEGUROS","GLOBALIA HANDLING","GLOBALIA MANTENIMIENTO AERONAUTICO","GLOBALIA SERVICIOS CORPORATIVOS","GLOBALIA SIST. Y COMUNICACIONES, S.L.","GLOBALIA TRAVEL CLUB SPAIN, S.L.U.","GLORIA BLANCO DE CORDOVA DIAZ MADROÑERO","GOLF MAIORIS","GOYA IMPORTACIONES Y DISTRIBUCIONES S.L","GRAFI EXPRESS - ROSA MARIA SANCHEZ MARQUES","GRAFICAS JAC SALAMANCA, S.C.L.","GRAFICAS SANTA CRUZ","GRAN HOTEL SOL Y MAR","GRAN MELIA COLON","GRAN MELIA DE MAR","GRAN MELIA DON PEPE","GRAN MELIA FENIX","GRAN MELIA PALACIO DE ISORA","GRAN MELIA PALACIO DE LOS DUQUES","GRAN MELIA VICTORIA","GRAND HOTEL MONTGOMERY SPRL","GRIMALDI","GROUNDFORCE ALICANTE 2015 UTE","GROUNDFORCE BARCELONA","GROUNDFORCE BARCELONA 2015 UTE","GROUNDFORCE BILBAO","GROUNDFORCE BILBAO 2015 UTE","GROUNDFORCE CARGO SLU","GROUNDFORCE FUERTEVENTURA 2015 UTE","GROUNDFORCE IBIZA 2015 UTE","GROUNDFORCE LAS PALMAS","GROUNDFORCE LAS PALMAS 2015 UTE","GROUNDFORCE LAS PALMAS UTE","GROUNDFORCE MADRID","GROUNDFORCE MADRID 2015 UTE","GROUNDFORCE MADRID UTE","GROUNDFORCE MALAGA 2015 UTE","GROUNDFORCE MALLORCA 2015 UTE","GROUNDFORCE SEVILLA","GROUNDFORCE SEVILLA UTE","GROUNDFORCE TENERIFE NORTE","GROUNDFORCE TENERIFE NORTE 2015 UTE","GROUNDFORCE TENERIFE NORTE UTE","GROUNDFORCE TENERIFE SUR","GROUNDFORCE TENERIFE SUR UTE","GROUNDFORCE VALENCIA 2015 UTE","GROUNDFORCE ZARAGOZA 2015 UTE","GRUPO BLAZQUEZ DE INVERSIONES Y PROYECTOS, S.L.","GRUPO CARFLOR","GRUPO CHAPIN - TRANSPORTES CHAPIN, S.L.","GRUPO CRIADO","GRUPO DE ESCUELAS DE MATACAN","GRUPO HOTELES PLAYA","GUAMA, S.A","GUIJUELO GOURMET, S.L.","GUILLERMO LOBATO PASCUAL","GUILLERMO OLTRA, S.L.U.","HABITPROYECT 2012, S.L.","HACIENDA ZORITA FARM FOODS, S.L.","HACIENDA ZORITA HOTELS & VILLAS, S.L.","HALCON AREA ANDALUCIA","HALCON AREA ARAGON, SORIA, NAVARRA Y LA RIOJA","HALCON AREA ASTURIAS","HALCON AREA CANARIAS Y BALEARES","HALCON AREA CASTILLA Y LEÓN","HALCON AREA CATALUÑA","HALCON AREA GALICIA","HALCON AREA LEVANTE","HALCON AREA MADRID","HALCON AREA NORTE","HALCON DIRECCION GENERAL","HALCON PEREGRINACIONES","HALCON Q42","HALCON V40","HALCON V54","HALCON VIAGENS E TURISMO, LDA","HALCON VIAJES - EMPRESAS","HALCON VIAJES - EVENTOS","HALCON VIAJES R70","HALCON VIAJES SA","HALCON VIAJES, S.A. - C","HALL 88","HDAD DONANTES SANGRE SALAMANCA","HDAD. NTR. PADRE JESUS FLAGELADO","HELCESA","HELFRI INSTALACIONES FRIGORIFICAS","HELITY GLOBAL AERONAUTICS SOLUTIONS CORP SL","HELMANTICA, S.A.","HENRY VIII HOTELS LTD.","HEREDEROS DE GARCIA MARTIN","HERMANDAD DOMINICANA","HERMANOS HUESO MORENO, S.L.","HERMANOS JULIAN M., S.L.","HERMANOS RECIO, S.L.","HERNADENT MADRID","HERRERO Y VEGAS. C.B.  (PISCINAS CALVARRASA)","HERSANCHO S.L.","HESAN","HIAGSA","HIDALGO ANDRÉS C.B.","HIERROS DÁVILA S.L.","HIJO DE MACARIO MARCOS, S.L.","HIPERHOSTEL MAQUINARIA PARA HOSTELERIA, S.L.","HISPÁNICA DE VIALES 2011 S.L.","HNOS. GONZALEZ JAEN, C.B.","HOGAR 21 MERCADO INMOBILIARIO - CONTEJI 49, S.L.","HOGAR Y DECORACION","HOSPITAL UNIVERSITARIO DE SALAMANCA","HOSPITALIDAD DE NUESTRA SEÑORA DE LOURDES","HOSTAL SARA","HOTEL ALAMEDA PALACE","HOTEL ALEXANDER S.A.S ( MELIA LA DEFENSE)","HOTEL ARCOS","HOTEL CATALONIA SALAMANCA P. MAYOR - VALENCIANA HO","HOTEL CONDE RODRIGO","HOTEL DOMUS REAL FUERTE","HOTEL DOÑA BRIGIDA","HOTEL DOÑA TERESA","HOTEL ESTRELLA ALBATROS, S.L.","HOTEL EXE BARBERA PARC","HOTEL EXE BARCELONA GATE","HOTEL EXE CRISTAL PALACE","HOTEL EXE ISLA CARTUJA","HOTEL EXE LAS MARGAS GOLF","HOTEL EXE LIBERDADE","HOTEL EXE PLAZA CATALUNYA","HOTEL EXE PLAZA MERCADO","HOTEL EXE RAMBLAS BOQUERIA","HOTEL EXE REINA ISABEL","HOTEL EXE SALAMANCA","HOTEL EXE VILA D´OBIDOS","HOTEL HORUS SALAMANCA","HOTEL HORUS ZAMORA","HOTEL PALACIO DE SAN ESTEBAN","HOTEL PUERTA DE BURGOS","HOTEL QUINDOS","HOTEL RESIDENCIA CONDAL","HOTEL SAN POLO, S.L.","HOTEL TUDANCA","HOTEL TUDANCA-MIRANDA","HOTELBEDS ACCOMMODATION & DEST.","HOTELES SANTOS D., S.L.","HOTELES TUDANCA","HOTUSA HOTELS, S.A.","HOYCOMOBIEN.COM - SANTIAGO RODRIGUEZ ORTIZ DE ZARA","HYCA - HIGIENE Y CALIDAD ALIMENTARIA, S.L.","I.E.S.O GALISTEO","IBB ESPAÑA 2004, S.L.","IBERDASA - CARNICAS IDECO, S.L.","IBEREX - IBERCOMEX ASESORAMIENTO EXTERIOR, S.L.","IBERIA GLOBALIA CARGO BARCELONA","IBERICOS BENAVENTE 3, S.L.U.","IBERICOS DOÑA CONSUELO","IBERICOS PEFRAN","IBERICOS SANCHEZ MARCOS - JAMONEMA, S.L.","IBERICOS TORREON SALAMANCA, S.L.","IBEROMUNDO EDICIONES S.L.","IBISMA","ICP LOGÍSTICA","IDAQUA","IDIMAS GESTION","IDOIA IZAGIRRE - INMENSO CREATIVE, S.L.","IES FRANCISCO SALINAS","IGLESIAS MATEOS C.B.","ILUSTRE COLEGIO DE ABOGADOS DE SALAMANCA","IMELDA SANCHEZ GARCIA - DISEÑO BYMELDA","IMPRENTA  MIGUEL COLL","IMPRENTA GARRIDO-JOSE REVATE GOMEZ","INDUSTRIAS CARNICAS IGLESIAS, S.A.","INGENIEROS GARCÍA BAYÓN","INGESURB","INMOBILIARIA RC 4 2010, S.L.","INNOVA EDICIONES","INNSIDE MADRID SUECIA","INSOLAMIS","INSPIRACION DEL BAÑO","INSTALACIONES ELECTRICAS RIESCO SANDOVAL, C.B.","INSTALACIONES Y MONTAJES DEL OESTE, S.L.","INSTITUTO DE MISIONERAS SECULARES","INSTITUTO DE NEUROCOACHING. S.L.","INSTITUTO ESPAÑOL DE SALAMANCA","INTER RIAS - VIAJES FISTERRA, S.L.U.","INTERECONOMIA PUBLICACIONES SL GRUPO INTERECONOMIA","INTERTABESA, S.L.","INVER. HOT. LA QUINTA SL","ISABEL BARCELO MAS","ISABEL GARCIA (USAL)","ISABEL SOUSA BRASA","ISMAEL SANTANA - INTELNICS","J. DELGADO R., S.L. (ESTRUCTURA METALICAS)","J.A.C. PUBLICIDAD, S.L.","JABUBA FILMS, S.C.","JAIME GONZALEZ DE SANTIAGO","JAMONES IBERICOS BLAZQUEZ S.L.","JAVIER FERNANDEZ BLANCO","JAVIER GARCIA DE LA CRUZ","JAVIER HERRERA GOMEZ","JAVIER MARTIN AGUADO","JAVIER MENDEZ ROMERO","JESNAR 2011, S.L.","JESUS AVILA GARRIDO","JESUS CASTAÑO NIETO","JESUS VICENTE SANCHEZ","JET PRINT, S.L. ARTES GRAFICAS","JG3 ASESORIA Y GESTION, S.R.L.","JICOR IBERICA, S.L.","JIMESAN GESTION, S.LU - FRANCISCO SANCHEZ SAN JOSE","JJ SANTOS & ASOCIADOS GESTORES SL","JJH ACTIVOS INMOBILIARIOS","JM CORREDERA ASESORES DE SEGUROS, S.L.","JOCAGRI. S.L.","JOMARBE BRIEFING, S.L.","JORDI PUIG JUSTICIA","JOSE A. SAEZ RODRIGUEZ","JOSÉ ALBERTO GONZÁLEZ OLIVA","JOSE ANGEL BARBERO FOTOGRAFO","JOSE ANGEL GOMEZ SANCHEZ","JOSE ANGEL SALVADOR MARTIN","JOSE ANTONIO GARCÍA DIEZ","JOSE ANTONIO HERNANDEZ GARCIA","JOSE ANTONIO ZARZA SANTOS","JOSE CARLOS ROBLES SANCHEZ","JOSÉ COLINO ÁLVAREZ","JOSE LUIS ESGUEVA","JOSE LUIS FERNANDEZ ENCINAS","JOSE LUIS GARCIA DEL AMO","JOSE LUIS MATEOS SANCHEZ","JOSE LUIS SANCHEZ SANCHEZ (ALUMINIOS)","JOSE MANUEL MARTIN BARRAGAN","JOSE MARIA COLLADOS GRANDE- TEMAAL, C.B.","JOSE MARIA ESTEVEZ ROCA","JOSE MARIA ROZAS LORENZO","JOSE MARIA TARDAGUILA VICENTE","JOSE PABLO DE LAS HERAS","JOSE RAFAEL FRIEROS MOLANO","JOSE VICENTE FUENTES DE ANTONIO","JOSELITO","JOTAEFE DISTRIBUCION-DISTRIBUCION JF Y AISLAMIENTO","JOYERIA NEUCHATEL - DELJOYER, S.L.","JUAN ALBERTO RECIO, S.A.","JUAN CARLOS MUÑOZ MARTIN - CASA RURAL QUEVEDO","JUAN CARLOS SANTOS DURAN","JUAN JOSE BENITO LEDESMA","JUAN JOSE CARRILLO CUESTA","JUAN JOSE CHAMORRO GOMEZ","JUAN LLORENS GRUPO, S.L.","JUAN LUIS MONTES SANCHEZ","JUAN MANUEL CRIADO MIGUEL","JUAN MANUEL TIO FERNANDEZ","JUCALEX, S.A.U.","JULIAN MARTIN, S.A.","JULIÁN RODRÍGUEZ PEDRAZ (PROD AGRÍCOLAS RODRÍGUEZ)","JULIO LOPEZ RODRIGUEZ","JUMBO TOURS ESPAÑA SLU","JUNG & PROYECT S.L","JUNTA DE CASTILLA Y LEON","KANLLI PUBLICIDAD, S.A.","KARYMA VIAJES (I75)  (GEOMOON)","KEBAB SALAMANCA, S.L.","KEYTEL, S.A.","KICK OFF SPORT TEAM, S.L. - EQUIPA2 SPORT","KIOSCO Y MÁS","KIOSKO MOMA","KREOSS SPAIN, S.L.","KÜHN & PARTNER I.P.C SL","KVIAR DISCO Y CASINO","LA CASA DE LA ROPA","LA CASA ROPA DE HOGAR, C.B.","LA GACETA REGIONAL, S.A.","LA JOYA CHARRA","LA MALHABLADA, S.L.","LA POSADA DEL HIDALGO -","LA PULPERIA DE PACO","LA ROBLICITA EMBUTIDOS HR - MARIOLA SANTIAGO","LA ROSA IBERICA - HERMANOS RODRIGUEZ RAMOS, S.L.","LABORATORIO DE PROTESIS DENTAL GALLO´S","LAGO LUCAS, S.L.","LANAS EPI - LUIS PASCUAL HERNANDEZ GONZALEZ","LAS AVENTURAS DEL SEÑOR MACO, S.L.","LAS MADRAS CASCAJO, S.L.U.","LAURA CALDERON DIEZ - FISIOTERAPIA","LAUREANO POLO ESCUDERO","LEGALITAS","LEGUMBRES IGLESIAS","LEÑAS LAS ENCINAS - EXPLOTACIONES VALVERDE 2002,S.","LESLIE MARTORELL GÓMEZ","LIBER MANIPULADOS, S.L.","LIBRERIA DON LAPIZ - JOSE ANGEL MAROTO SANTAMARIA","LIGAYOMEGRO 2006, S.L.","LIMPIEZAS GRUPO NORTE","LIMPIEZAS PEDRAZ","LIMUCYL - ASOCIACION DE CRIADORES DE LIMUSIN","LIMUCYL - ASOCIACION DE CRIADORES DE LIMUSIN DE CA","LOAD COMUNICACION","LOCAFM SALAMANCA - BEY DELICIOUS SPAIN, S.L.U.","LOGISTICA CAMPAL 2005, S.L.","LOLA LOPEZ","LONGEVITAS LABS S.L","LONGEVITAS LABS, S.L.","LOPEZ ESCUDERO - QUIMICOS LOPEZ ESCUDERO, S.L.","LORENA DOMINGO","LORENA FERNANDEZ SANTIAGO","LORENA MARTIN (NIÑO)","LORETO CIBENAL","LOS CAPRICHOS DE CLARISA - CLARA MOLINA MARTINEZ","LOW COST CARBURANTES, S.A.","LUABAY COSTA ADEJE","LUABAY GALATZO HOTEL","LUABAY LANZORETE BEACH","LUCES ASPA, S.L. - LUCES ILUMINACION","LUFTHANSA LINEAS AEREA ALEMANAS","LUIS ARENALES BLANCO","LUIS LOPEZ DE PRADO - ARQUITECTO","LUIS LORO (ACUPUNTURA)","LUISO DOMINGUE -AFRODITA PRODUCCIONES-SPYRO MUSIC","LUPAGAS, S.L.","LUXOTOUR","Mª ISABEL HERRERA MAILLO","Mª JOSE HIERRO GONZALEZ","Mª SONIA BELTRAN MORENO - WIDEX ZAMORA","MADE OF SPAIN FOOD RETAIL, S.L.","MADERAS AMBROSIO","MADRID D5","MADRID PUBLICIDAD Y DISEÑOS SL","MAES HONEY INT, S.L.U.","MAKING SEM","MAKITO","MANCOMUNIDAD RUTAS DE ALBA","MANCOMUNIDAD SIERRA DE FRANCIA","MANERO&CO. - PABLOS MANERO, S.L.","MANOLO Y FILO, S.L.","MANUEL DELGADO GOMEZ","MANUEL DIAZ ALFONSO - SERVICIO TECNICO BIOMASA","MANUELA BARANDA ALVAREZ","MANUELA PABLOS PEREZ (AGUEDAS ALDEAVIEJA TORMES)","MAPATOURS","MAQUINARIA CALDERON, S.L.","MARCOS MADALENA MARTIN","MARI BRAVO MERINO","MARIA DE LOS DOLORES SANCHEZ ALMARAZ","MARIA ELENA ENRIQUEZ MORENO","MARIA JOSE LOPEZ POVEDA","MARÍA JOSÉ MUÑOZ MARTIN","MARIA MERCEDES YOLANDA HUERTAS CABEZAS","MARIA NIEVES SANZ","MARIA SEVILLANO NIETO - NEGRO ENNEGRECIDO","MARIA TERESA PAYAN CEREZO","MARIA TOBINA WITLOX - COMETE SALAMANCA","MARIANO CASTRO, S.L.","MARIANO MARCOS GARCIA, S.L.","MARINA D'OR","MARINA HIDALGO","MARIO BURGOS MOTILVA","MARIO VICENTE SANCHEZ","MARJOMAN, S.L.","MARKETING PROMOCIONAL PROMOPICKING, S.A.","MARMOLES DA SILVA, S.L.","MARQUES DE LA CONCORDIA FAMILY OF WINES, S.L.","MARTA GACIA GONZALEZ","MARTA HERNANDEZ SANTOS","MARTA RISCO PLAZA","MARTA TRISTÁN MATEOS","MARTINEZ FLAMARIQUE, S.A.","MAS MANEGUET, S.A - GOLF COSTA DAURADA","MAYORISTA DE MOVILES EN ESPAÑA SL","MAYORISTA DE VIAJES, S.A. - SPECIAL TOURS","MCI QUERCUS, S.LU","MDEMARKETING","ME LONDON","ME MILAN IL DUCA","ME SITGES TERRAMAR ME BY MELIA","MEGASOFA","MEINS CONSULTING SL","MELIA ALICANTE","MELIA ANTILLA/BARBADOS","MELIA ATLANTERRA","MELIA ATLANTICO ISLA CANELA","MELIA BARAJAS","MELIA BARCELONA","MELIA BARCELONA SARRIA","MELIA BARCELONA SKY","MELIA BENIDORM","MELIA BILBAO","MELIA BOUTIQUE ROYAL TANAU APTOS.","MELIA CALA D'OR BOUTIQUE","MELIA CALA GALDANA","MELIA CASTILLA APARTAHOTEL","MELIA COSTA DEL SOL","MELIA DE MAR HOTEL","MELIA FUERTEVENTURA","MELIA GOLF VICHY CATALAN","MELIA GRANADA","MELIA HACIENDA DEL CONDE","MELIA HOTELS INTERNATIONAL","MELIA JARDINES DEL TEIDE","MELIA LA QUINTA","MELIA LEBREROS","MELIA MADRID PRINCESA","MELIA MADRID SERRANO","MELIA MARBELLA BANUS HOTEL","MELIA MARIA PITA","MELIA ME MADRID REINA VICTORIA","MELIA ME MALLORCA","MELIA OLID MELIA","MELIA PALMA BAY","MELIA PALMA MARINA (ANT.MELIA PALAS ATENEA)","MELIA SALINAS","MELIA SANCTI PETRI HOTEL","MELIA SEVILLA HOTEL","MELIA SIERRA NEVADA","MELIA SITGES","MELIA TAMARINDOS","MELIA VILLAITANA","MELODY MAKER HOTEL S.A DE CV","MERAKI PHOTO STUDIO","MERCASALAMANCA, S.A.","MERCEDES PEDRAZ","MERCEDES RAMOS NIETO","METROMAFFESA CONSTRUCCIONES. S.L.","METSA SALAMANCA, S.L.","MH AGENCIA Y ESCUELA DE AZAFATAS","MIGUEL ALVARO, C.B.","MIGUEL ANGEL CURTO SANCHEZ","MIGUEL LOPEZ QUEVEDO","MINISTERIO DE TURISMO DE LA REPUBLICA DOMINICANA","MIRAT COMBUSTIBLES, S.L.U.","MIRAT FERTILIZANTES, S.L.U.","MIRIAM GOMEZ HOYOS","MISION CRISTIANA PUERTAS ABIERTAS","MISISIPI REPRESENTACION Y EVENTOS, S.L.","MISS YELLOW - MERCEDES SAN MAXIMO SANCHEZ","MONASTERIO DE SAN MILLAN YUSO","MONFORTE CASTROMIL GLOBALIA UTE","MONTSE LÓPEZ (UFEL CATALUÑA)","MOOD SIX, S.L.U.","MOPA LIMPIEZAS - MONICA SANCHO MARTINEZ","MORETA, S.L.","MORGAN","MOROCCO GHS","MOVILQUICK SALAMANCA","MSC CRUCEROS","MSD MERCK SHARP & DOHME ANIMAL HEALTH, S.L.","MUCHA TINTA STUDIO TATTOO - IVAN PAREDERO GARCIA","MUCHO MAS QUE NOVIOS","MUCHOSOL","MUDANZAS SALAMANCA, S.L.","MUEBLES MARCOS, S.L.","MULTIBELLE","MULTICIA CORREDURIA DE SEGUROS, S.L","MULTICOCINAS Y BAÑOS, S.L.","MULTICOMPRAS SALAMANCA, S.L. (MUNDICOR)","MULTIMEDICA CENTRO, S.L.","MULTISERVICIOS SALMANTINOS JHR-JOSE MANUEL HDEZ. R","MULTIUSOS SANCHEZ PARAISO","MUNDO ALUMINIO - JESUS GARCIA SANCHEZ","MUNDO ROTULO","MUNDOSENIOR  - MUNDOSOCIAL","MUSEO DE HISTORIA DE LA AUTOMOCION DE SALAMANCA","MYRIAM RODRIGUEZ EGIDO","NATI VICENTE GARCIA - ESTETICA","NATUR HOUSE JUDITH TEJEDOR","NAVARVILLAN SL","NAYADE TRYP","NEUMATICOS ANDRES","NEUMATICOS ANDRES, S.A.U.","NEUMATICOS COMUNEROS, S.L.","NEW FIRE ICE, S.L.","NEWREST","NEXTEL SERVICIOS DE RESERVA, S.L.","NEXUM FINANZA","NIEBLA C.B.","NIEVES RIESCO","NIVINIC, S.L.","NOELIA AVILA SALCEDO","NOEMI NIETO SANZ","NORTRAVEL","NOTARIA CANTELI  - CARLOS HERNANDEZ FERNANDEZ CANT","NOTARIO MARIA CRISTINA SILLA RINCON","NOU VENT S.L","NOVO DECOR","NTO SEGMENTO SLU","NUESTRO ESPACIO","NUTERSA","NUVENSIS - NUEVOS SISTEMAS Y DESARROLLOS TECNOLOGI","OBRAS CONTOGA, S.L.","OCEAN CLUB","OCEAN ELITE YACHT SL","OFTALMOLOGIA VALLE ANCHO, S.L.","OPTICA EUROPA - SAN PABLO OPTICOS, S.L.","OPTICA FERREIRA - OPTICAS CASTILLA Y LEON, S.L.","OPTIMA LAB","ORQUESTA PENSILVANIA","ORTIZ REED INTERNATIONAL","ORTOLUA LABORATORIO DENTAL, C.B.","OSCAR GONZALEZ RODRIGUEZ (LORIEN)","OSCAR JIMENEZ MARTIN - ELECTRICIDAD SANTA TERESA","OSCAR LUIS ESCALERA CONDE - PENNY BRUSH","OSCAR MARTIN GOMEZ","OUTSORCING RENOVATTIO,S.L.","PADEL MIROBRIGA, S.L.","PAFRESGON 2014, C.B.","PALACIO CONGRESOS Y EXP. C.Y.L. UTE","PALACIO DE CONGRESOS DICOTEX","PALLADIUM HOTEL GROUP","PANAVISION TOURS","PANDORA PRODUCCIONES, IMAGEN Y EVENTOS, S.L.U.","PARK AVENUE","PARKING EL AVION BARAJAS S.L.","PARKING GLOBALIA HOTEL TALAVERA","PARRA LOPEZ, S.L.","PARROQUIA DE SANTA TERESA","PARROQUIA SAN MARCOS","PARTIDO POPULAR AYUNTAMIENTO DE CABRERIZOS","PAS","PASARELA - RAQUEL CUADRADO CUADRADO","PASCUAL GONZALEZ, S.L.","PAULA ACEDO RODRIGUEZ","PAVIMENTOS Y AISLAMIENTOS ALONSO","PEDRO JOSE MATEOS LIMIA","PEDRO LUIS MARTIN MONTERO","PEKATHERM","PELUQUERIA ALBERTO","PELUQUERIA ELLA Y EL","PELUQUERIA HIDALGO C.B.","PELUQUERIA OLAYA PEÑA MARTIN","PELUQUERÍA PATRICIA STYLE","PELUQUERIA PEPA","PELUQUERIA Y ESTETICA ESTILO PROPIO","PEMARY, S.L.","PEÑA FOLCLORICA EL TAMBORIL","PEPEPHONE","PETALOS ARTES FLORAL","PETRA GARCIA ALVAREZ","PF CONCEPT SPAIN S.A.U","PISCINA DE VILLASECO DE LOS REYES","PIXEL ELECTRONICA","PLANET IFE","PLATOS Y PIZARRAS","PLATOS Y PIZARRAS,S.L","PLAY CLUB BY CIPRIANI","PLAZA 23 (GONZALO SENDIN)","PLUSULTRA LINEAS AEREAS","POLIGAR - TECNOLOGIA DEL POLIESTER GARCIA , S.L.","POLITOURS, S.A.","POLO MAQ, S.L.","POLTI ESPAÑA","POUSASYSTEM, S.L.","PRODUCTOS CUBERO, S.L.","PROVIDES WIN WAY SL","PROVINCIA DE LA INMACULADA CONCEPCION DE LA ORDEN","PUB LONDON","PUB QUALITY - MARIANO SANCHEZ MARTINEZ","PUBLIALBOR S.L.","PUBLIGELSA DIGITAL, S.L.","PUBLIMPRES - DANIEL ANTON PRIETO","PUBLINAT","PUBLITORMES","PUENTESAN SOC. COOPERATIVA","PULLMANTUR CRUISES, S.L.","PULSO ENERGIA SL","PUNTO URBAN TRADE S.L.","PUROBEACH MARBELLA - ATENTO BEACH CLUB, S.L.","QUINTIN SANCHEZ, S.A.","RADIO POPULAR, S.A.","RADIO SALAMANCA, S.A.","RAFAEL SAN  CECILIO PEREZ - ESIBERICO.COM","RAQUEL CASTAÑO MANSO","RAQUEL CEPERO MONTES","RAQUEL FERREIRO VÁZQUEZ","RATIO CONSULTORA DE PROBLEMATICA EMPRESARIAL, S.L.","RATPANAT LUXURY & AVENTURE","RAÚL SEVILLANO RUIZ (SEVIPAL)","RAW SUPPLIERS GPA. S.L.","RECAMBIOS AUTOMOTOR SALAMANCA, S.L.","RECAUCHUTADOS FIDEL, S.L.","RECEPTIVO CCI TRAVEL SL","RECOLETOS CONSULTORES, S.L.","REGENERSIS GMBH","REMAI","REPROFIV, S.L.","RESIDENCIA FIDALGO MORALES","RESIDENCIA NUEVO SIGLO, S.L.","RESTAURANTE ABADIA PLAZA","RESTAURANTE BAR LA CALLEJA","RESTAURANTE CAPRIZZIO","RESTAURANTE CASA CONRADO - RESBARVIL, S.L.","RESTAURANTE DE LA SANTA","RESTAURANTE DHARMA","RESTAURANTE DON BUSTOS, C.B.","RESTAURANTE DON MAURO","RESTAURANTE DOZE","RESTAURANTE EL MOLINO","RESTAURANTE GUINALDO - AGUSTIN GUINALDO GUINALDO","RESTAURANTE LA CASERNA, S.L.","RESTAURANTE LA TAHONA DE LA ABUELA","RESTAURANTE LOS ROBLES - EVELINA MATEO SANTOS","RESTAURANTE MIRASIERRA","RESTAURANTE PEDRO","RESTAURANTE PUCELA","RESTAURANTE RACHA  - CREGO MARCOS JOSE 000873101Z,","RESTAURANTE SIERRA QUILAMA 3, S.L.","RESTAURANTE ZAZU","RESTEL, S.A.","REVESTIMIENTOS DE FACHADAS DAVID E IVAN CB","RICARDO RODRIGUEZ HERNANDEZ","RICOH ESPAÑA, SLU","ROBERTO LORENZO BLANCO","ROCIO CRUZ FUENTES","ROCIO LOPEZ GARCIA","ROGELIO SANCHEZ","ROMAPE GESTION INTEGRAL, S.L.","ROSANA PEREZ","RPM POR MIL","RUBEN HERNANDEZ CARBONES Y LEÑA, S.C.","RUBEN MATAS HERNANDEZ","RUBEN SENDIN","SABELA IÑIGUEZ","SACHA ART AND BUSINESS, S.L.","SALAEVENTOS, S.L. - RESTAURANTE CASA LUCY","SALBOX SERVICIOS GLOBALES, S.L. - DAVID HERRERA","SALDUNA CATERING, S.L.","SALDUNA NATURA BEACH, S.L.","SALON DE BELLEZA JUANI","SAN ESTEBAN IBERICOS, S.L. (IBERICO AND CO","SANCHEZ - ESTEBAN ABOGADOS","SANTIFER S.L.","SARA QUEVEDO FRADES","SARA RUBIO MARTIN","SARLUC SEGUROS","SAUVIA RESIDENCIA PARA MAYORES","SCHENKER SPAIN-TIR DB","SEBASTIAN TEJEDOR MARTIN","SECRET SPOT SLU","SEGURODE.COM","SELLGRAF IMPRESION, S.L.","SEMATEQ, S.L.U.","SENDAS DE EUROPA, S.L.","SERGIO MARTIN SANCHEZ","SERVICIO INSERCIÓN PROFESIONAL PRACTICAS Y EMPLEO","SERVICIO TECNICO OFICIAL AVISAT","SERVIMAN. CAMPO CHARRO, S.L.","SEUR ALICANTE, LOGISLAND, S.A.","SEUR SALAMANCA","SEUR VALLADOLID","SEUR, S.A.","SIDDHARTA TRAVELS","SIDES PINTURA Y DECORACION - LUIS MIGUEL SIDES MAR","SILMO´S ZAPATOS - MODESTO SANCHEZ SIERRA","SILVIA AMAYA GONZALEZ GONZALEZ","SILVIA GABINETE DE ESTETICA","SIMON CASAS PRODUCTION","SIMORRA TIENDAS","SKITE S COOP","SMART OUTSOURCING, S.L.","SOCIEDAD ESPAÑOLA DE ENFERMERIA NEFROLOGICA","SOL BEACH HOUSE CALA BLANCA","SOL BEACH HOUSE IBIZA","SOL CALAS DE MALLORCA","SOL ELITE DON PABLO","SOL GAVILANES HOTEL","SOL HOUSE COSTA DEL SOL","SOL LA PALMA HOTEL","SOL LANZAROTE","SOL LOS FENICIOS","SOL PELICANOS OCAS HOTEL","SOL PINET PLAYA","SOL PUERTO PLAYA","SOL SANCTI PETRI (APARTHOTEL)","SOL TRINIDAD","SOLO SOLUCIONES, S.L.","SOLTOUR, S.A.","SOLUCIONES TECNOLOGICAS SANABRIA, S.L.","SONIA SANCHEZ - HALCON CENTRAL","SONIA VALLE RODRIGUEZ","SPAIN TIR","SPASMO TEATRO, S.L.","SPECIAL MOMENTS PHOTOGRAPHY","SPUBLICITAT - SP PRODUCTOS PACKAGING-PERSONALIZABL","STAGE ENTERTAIMENT ESPAÑA, S.L.","STARLITE - BENDEUS, S.L.","STARLITE PRODUCTIONS SLU","SUCESORES DE PANIAGUA, S.L.","SUITOPIA HOTEL","SUMATE MARKETING ONLINE","SUNION PROYECTO Y CONSTRUCCION, S.L.","SURFERGARAGE S.L.","SUSANA DELGADO GIL","SUSANA FRANCIA PEREZ","SUYSER HOSTELERIA INTEGRAL, S.L.U.","TADAMA 14 S.L.U.","TALENTTO COCINAS - EGGO DISEÑO SALAMANCA, C.B.","TALLER DE ARTESANIA LUIS M. BLANCO CURTO","TALLER DE EDITORES S.A","TALLER MECANICO DIEGO","TALLER MECANICO MARTIN PORTEROS","TALLERES CHOC, S.L.","TALLERES JERONIMO HERRERO","TAM TRAVEL CORPORATION","TAPIZADOS SAN JUAN, S.L.","TAXI CASTELLANOS","TAXI DE VILLARES","TAXI MONTERRUBIO - MANUEL FERNANDEZ SANTIAGO","TAXI VILLAMAYOR","TECNO HELCESA, S.L.","TECNOCASA","TECNOGALLERY","TECNOLOGIA HIGIENICA JVD S.L","TELESAMANCA","TELEVISION C Y L 8","TERAPIAS SECRETO","TERESA BUENO","TERMOCALOR CALEFACCIONES, S.L.","THE GRAPHIC PRODUCTION","THE HACIENDAS COMPANY LTD","THE HACIENDAS COMPANY LTD. SUCURSAL EM PORTUGAL","THE HACIENDAS COMPANY SPAIN, S.L.","THE HACIENDAS WAREHOUSE, S.L.","THE RED KIWI SL","TICKET MASTER","TIME-TO CONNECTING MARKETS","TINO RODRIGUEZ GARCIA","TÍTULO PROPIO ESPECIALISTA EN GESTIÓN LABORAL.","TODECA TOPO-PERFORACIONES, S.L.","TOLEMARTIN, S.L.","TOREO ARTE Y CULTURA","TOREO ARTE Y CULTURA BMF, S.L.","TOREO Y TOROS 2008, S.L.U.","TOROS DEL MEDITERRANEO S.L. UTE","TOROS LA GLORIETA, S.L.","TOUR EVENTS","TOURING CLUB","TRADIA HOTEL, S.L.U. (CAMPING CALPEMAR)","TRANS DIOSDADO SANCHEZ, S.L.","TRANSFORWARDING S.L","TRANSPORTES OCON","TRAPSATUR NATURALEZA Y TURISMO S.L","TRAVEL MANAGER ASSISTANT","TRAVELPLAN","TRAVELPLAN, S.A.","TRE3","TREBOL MEDIA","TRES EN RAYA. (SILVIA COLMENERO)","TRIBUNA CONTENIDOS DIGITALES, S.L.","TRYP ALAMEDA","TRYP ALAMEDA AEROPUERTO HOTEL","TRYP AMBASSADOR HOTEL","TRYP APOLO HOTEL","TRYP ATOCHA HOTEL","TRYP AZAFATA","TRYP BARCELONA AEROPUERTO HOTEL","TRYP BELLVER","TRYP BOSQUE","TRYP CEUTA","TRYP COMENDADOR","TRYP CONDAL MAR HOTEL","TRYP CORDOBA","TRYP CORUÑA","TRYP GRAN SOL","TRYP GRAN VIA","TRYP GUADALAJARA","TRYP GUADALMAR","TRYP INDALO","TRYP JEREZ","TRYP LA CALETA","TRYP LEON","TRYP MACARENA HOTEL","TRYP MADRID AIRPORT SUITES","TRYP MADRID CHAMARTIN / C. NORTE","TRYP MADRID PLAZA ESPAÑA","TRYP MEDEA","TRYP MELILLA PUERTO","TRYP MONTALVO","TRYP OCEANIC","TRYP ORLY","TRYP PORT CAMBRILS","TRYP REY PELAYO HOTEL","TRYP S. VIELHA BAQUEIRA","TRYP SANTIAGO","TRYP TENERIFE","TRYP VALENCIA FERIA","TRYP ZARAGOZA","TU BILLETE.COM","TUI SPAIN","TURISMO COMERCIO PROM E SALAMANCA","UN MUNDO DE CRUCEROS - VIAJES Y CRUCEROS CRUISELAN","UNDANET GRUPO, S.L.","UNION DEPORTIVA SANTA MARTA DE TORMES","UNITED WINERIES  LTD.","UNITED WINERIES AS","UNITED WINERIES ESPAÑA, S.A.U. (NO USAR)","UNITED WINERIES ESTATES, S.A.U.","UNITED WINERIES IBERIA, S.A.U.","UNITED WINERIES INTERNATIONAL, S.A.","UNITED WINERIES, S.A.U.","UNIVERSIDAD DE SALAMANCA","UNIVERSIDAD DE SALAMANCA. FACULTAD DE DERECHO","UNIVERSIDAD DE SALAMANCA-ESCUELA UN. MAGISTERIO DE","UNIVERSIDAD FELICIDAD VIGO - HERIKA APARECIDA MIGU","UNIVERSITY OF SHEFFIELD","UNOD, S.L.","URH & CO HOTELIERS SL","URSULA PETIT","VAIVEN GRUPO EMPRESARIAL, S.L. - GABRIEL CALVO","VALERIANO HERNANDEZ FRAILE","VARDENOD ASOCIADOS, S.L.","VEGA HERNANDEZ CASTAÑO","VERMUT FILMS S.L","VIAJES ARENETUM","VIAJES CASTRILLON, S.L. (W73)  (GEOMOON)","VIAJES ECUADOR SA","VIAJES EL CORTE INGLES, S.A.","VIAJES EN ALGUN LUGAR (I08)  (GEOMOON)","VIAJES FORMENTOR, S.L.","VIAJES GLOBOMAR (W27)  (GEOMOON)","VIAJES IBERPLAYA","VIAJES MARSOL","VIAJES PARAISO ORMESU, S.L.U. (GEOMOON)","VIAJES PRINCIPADO, S.L. (GEOMOON)","VIANDAS STORES (HACIENDA ZORITA), S.L.","VICENCI, C.B.","VICENTE GANDÍA PLÁ","VICENTE SANCHEZ E HIJOS SAT","VICTOR PAVON CRUZ","VIDAGANY LOGÍSTICA Y ALMACENAJE","VILLAMAYOR GESTION","VILLAS RESIDENCIALES, S.L.","VINTRALUBE","VIÑEDOS Y HOSTELERIA SL","VISUAL PRINT SERVICES","VUELA CAR","WAMOS AIR","WELCOME INCOMING SERVICES","WIROAFINES, S.L.","WIZINK BANK S.A","XPOLOGISTICS","Y002 GLS MARTOS","Y009 GLS EL CARMEN","Y011 GLS MISLAT","Y017 GLS LINARES PUEBLOS","Y021 GLS PUERTO REAL","Y022 GLS DOS HERMANAS","Y031 GLS CORUÑA SUR","Y034 GLS MICORED","Y039 GLS TOTANA","Y042 GLS LA UNION","Y043 GLS PUERTO LUMBRERAS","Y044 GLS CEHEGIN","Y047 GLS ALBACETE RS CRUZ","Y048 GLS BENALUA","Y049 GLS MUXAMIEL","Y055 GLS ORENSE SUR","Y060 GLS MIERES","Y071 GLS OVIEDO GRADO","Y073 GLS ORDES","Y078 LAS LAGUNAS","Y080 GLS GIJON NORTE","Y081 GLS TREBUJENA","Y086 GLS PLASENCIA PUEBLOS","Y087 GLS FUENSALIDA","Y088 GLS MORA","YU TRAVEL DESTINATION S.A","ZALDI SILLAS DE MONTAR, S.A.","ZAPA TEJARES","ZEN VITAL - MARIA JESUS SANTOS FRAGA","ZERGATIK FACTORY, S.L","ZORITA´S KITCHEN, LTD.","ZT HOTELS & RESORTS SL"
			]
		},
		callback: {
			onInit: function (node) {
				console.log('Typeahead Initiated on ' + node.selector);
			}
		},
		debug: true
	});
	*/
	
	//no es un alta al venir el pir
	//console.log("txtpir: " + j$("#txtpir_d").val())
	
	//activamos de desactivamos controles
	
	<%if session("perfil_usuario")="PROVEEDOR" then%>
		j$("#txtpir_d").prop('disabled',true);
		
		j$("#txtfecha_pir_d").prop("type", "text");
		j$("#txtfecha_pir_d").prop('disabled',true);
		
		j$("#txtfecha_orden_d").prop("type", "text");
		j$("#txtfecha_orden_d").prop('disabled',true);
		
		j$("#txttag_d").prop('disabled',true);
		j$("#txtruta_d").prop('disabled',true);
		j$("#txtvuelos_d").prop('disabled',true);
	
		j$("#txtnombre_d").prop('disabled',true);
		j$("#txtapellidos_d").prop('disabled',true);
		j$("#txtmovil_d").prop('disabled',true);
		j$("#txtfijo_d").prop('disabled',true);
		
		/*
		j$("#txtdireccion_entrega_d").prop('disabled',true);
		j$("#txtcp_entrega_d").prop('disabled',true);
		*/
		
		j$("#txtemail_d").prop('disabled',true);
		
		j$("#cmbtipo_direccion_entrega_d").prop('disabled',true);
		j$("#cmbdesde_hasta_d").prop('disabled',true);
		j$("#txtfecha_desde_hasta_d").prop("type", "text");
		j$("#txtfecha_desde_hasta_d").prop('disabled',true);
		j$("#txttipo_equipaje_bag_original_d").prop('disabled',true);
		j$("#txtmarca_bag_original_d").prop('disabled',true);
		
		j$("#txtmaterial_bag_original_d").prop('disabled',true);
		j$("#txtcolor_bag_original_d").prop('disabled',true);
		j$("#txtlargo_bag_original_d").prop('disabled',true);
		j$("#txtalto_bag_original_d").prop('disabled',true);
		j$("#txtancho_bag_original_d").prop('disabled',true);
		
		//console.log('combo estado al final: ' + j$("#cmbestado_d").val()) 
		
		 // PENDIENTE AUTORIZACION, CERRADO o GESTION CIA
		 if ('<%=campo_estado%>'=='1' || '<%=campo_estado%>'=='7' || '<%=campo_estado%>'=='8')
			{
			j$("#cmbestado_d").prop('disabled',true);
			j$("#cmdguardar_pir").prop('disabled',true);
			
			}
		
		j$(".cmb_bt").selectpicker('refresh')
		 
		//no es un alta al venir el pir
		//console.log("fin configuracion controloes")
	 





	<%end if%>
	
	
	if (j$("#ocultoid_pir").val()!='')
		{
		j$("#txtpir_d").prop('disabled',true);
		
		j$("#txtfecha_pir_d").prop("type", "text");
		j$("#txtfecha_pir_d").prop('disabled',true);
		
		j$("#txtfecha_orden_d").prop("type", "text");
		j$("#txtfecha_orden_d").prop('disabled',true);
		
		j$("#txttag_d").prop('disabled',true);
		j$("#txtruta_d").prop('disabled',true);
		j$("#txtvuelos_d").prop('disabled',true);
		
		
		}
	  else // ES UN ALTA
	  	{
		//console.log('TENEMOS UN ALTA......')
		j$("#cmbestado_d").val('').change();
		
		//console.log('texto combo estado: ' + j$("#cmbestado_d option:selected").text())
		//console.log('valor combo estado: ' + j$("#cmbestado_d option:selected").val())
		}
		
	
	
	
	
	prm.add("p_id_pir", j$('#ocultoid_pir').val());

	j$.fn.dataTable.moment("DD/MM/YYYY");
	
	if (typeof lst_historico_pir == "undefined") {
            lst_historico_pir = j$("#lista_historico_pir").DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:"tojson/obtener_historico_pir.asp?"+prm.toString(),
                                                           type:"POST",
                                                           dataSrc:"ROWSET"},
                                                     order:[],
													 columnDefs: [
                                                              {className: "dt-center", targets: [7]}                                                            
                                                            ],
                                                     /*
													 columnDefs: [
                                                              {className: "dt-right", targets: [2,3]},
                                                              {className: "dt-center", targets: [4]}                                                            
                                                            ],
													*/
													 responsive:true,
													 columns:[ 
													 			{data:"FECHA"},
																{data:"HORA"},
																{data:"ACCION"},
																{data:"CAMPO"},
																{data:"VALOR_ANTIGUO"},
																{data:"VALOR_NUEVO"},
																{data:function(row, type, val, meta) {                                                                                                                   
                                                                      	//return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                                                                  
                                                                      	
																		if (row.NOMBRE_USUARIO=='')
																			{
																			cadena=row.USUARIO
																			}
																		  else
																		  	{
																			cadena_usuario= row.NOMBRE_USUARIO + ' (' + row.USUARIO + ')' 
																			cadena='<i class="fa fa-user-o" aria-hidden="true" style="cursor:pointer"' +
						  																'data-toggle="popover_datatable"' +
																						'data-placement="top"' + 
																						'data-trigger="hover"' +
																						'data-content="<span style=\'color:blue;\'><i class=\'fa fa-user-o fa-lg\'></i>&nbsp;' + cadena_usuario + '"></i></span>'
																			}
																		
																		return cadena
                                                                    	}
                                                               		},
																{data:"DESCRIPCION"},
															  	{data:"ID", visible:false},
															  	{data:"ID_PIR", visible:false},
																{data:"PIR", visible:false},
																{data:"ESTADO", visible:false},
																{data:"NOMBRE_USUARIO", visible:false}
																
								 
		
                                                            ],
                                                     deferRender:true,
    //  Scroller
                                                     scrollY:calcDataTableHeight() - 70,
                                                     scrollCollapse:true,
                                                   // scrollX:true,
    //  Fin Scroller
    /*
                                                     tableTools:{ sRowSelect: "single",
                                                                  sSwfPath:"/v2/plugins/dataTable/extensions/TableTools/swf/copy_csv_xls_pdf.swf",
                                                                             aButtons:[{sExtends:"copy", sButtonText:"Copiar", sToolTip:"Copiar en Portapapeles", oSelectorOpts: {filter: "applied", order: "current"}, mColumns:[0,1,2,3,4,5,6,7]},
                                                                                       {sExtends:"xls", sButtonText:"Excel", sToolTip:"Exportar a Formato CSV", sFileName:"Trabajadores_Externos.xls", oSelectorOpts: {filter: "applied", order: "current"}, mColumns:[0,1,2,3,4,5,6,7]},
                                                                                       {sExtends:"pdf", sButtonText:"PDF", sPdfOrientation:"landscape", sToolTip:"Exportar a Formato PDF", sFileName:"Trabajadores_Externos.pdf", sTitle:" ", oSelectorOpts: {filter: "applied", order: "current"}, mColumns:[0,1,2,3,4,5,6,7]},
                                                                                       {sExtends:"print", sButtonText:"Imprimir", sToolTip:"Vista Preliminar", sInfo:"<h6>Vista Previa</h6><p>Por favor use la funci&oacute;n de u navegador para imprimir [CRTL + P]. Pulse Escape cuando finalice.</p>"}]},         
    */                                               
                                                   buttons:[{extend:"copy", text:'<i class="fa fa-files-o"></i>', titleAttr:"Copiar en Portapapeles", 
												   				exportOptions:{columns:[0,1,2,3,4,5,12,7],
																				format: {
																						header: function ( data, columnIdx ) {
																								if (columnIdx==12)
																									{
																									return 'Usuario';
																									}
																								 else
																									{
																									return data;
																									}
																								}
																						}
																}}, 
                                                             {extend:"excel", 
															 	text:'<i class="fa fa-file-excel-o"></i>', 
																titleAttr:"Exportar a Formato Excel", 
																title:"Historico Pir <%=campo_pir%>", 
																extension:".xls", 
																exportOptions:{columns:[0,1,2,3,4,5,12,7],
																	format: {
																			header: function ( data, columnIdx ) {
																					if (columnIdx==12)
																						{
																						return 'Usuario';
																						}
																					 else
																					 	{
																						return data;
																						}
																					}
																			}
																	}
															  }, 
															 
															 {extend:"pdf", text:'<i class="fa fa-file-pdf-o"></i>', titleAttr:"Exportar a Formato PDF", title:"Historico Pir <%=campo_pir%>", orientation:"landscape", 
															 	exportOptions:{columns:[0,1,2,3,4,5,12,7],
															 					format: {
																						header: function ( data, columnIdx ) {
																								if (columnIdx==12)
																									{
																									return 'Usuario';
																									}
																								 else
																									{
																									return data;
																									}
																								}
																						}
															 
															 }}, 
                                                             {extend:"print", text:"<i class='fa fa-print'></i>", titleAttr:"Vista Preliminar", title:"Historico Pir <%=campo_pir%>", 
															 	exportOptions:{columns:[0,1,2,3,4,5,12,7],
																				format: {
																						header: function ( data, columnIdx ) {
																								if (columnIdx==12)
																									{
																									return 'Usuario';
																									}
																								 else
																									{
																									return data;
																									}
																								}
																						}															
																	
																}}
															],
                                                 
													
													rowCallback:function (row, data, index) {
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
																  
																	if ( data.ACCION == "INCIDENCIA" ) {
																		//j$( row ).css( "background-color", "Orange" );
																		//j$( row ).addClass( "warning" );
																		j$( row ).addClass( "danger" );
																	}
                                                                },
													drawCallback: function () {
															//para que se configuren los popover-titles...
															j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
															//j$('[data-toggle="popover_datatable"]').next('.popover').addClass('popover_usuario');
															
														},
                                                    //initComplete: stf.initComplete,                                                            
                                                     language:{url:"plugins/dataTable/lang/Spanish.json"},
                                                     paging:false,
                                                     processing: true,
                                                     searching:true
                                                    });
               
			   
				 //controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_historico_pir tbody").on("click","tr", function() {  
                  if (!j$(this).hasClass("selected") ) {                  
                    lst_historico_pir.$("tr.selected").removeClass("selected");
                    j$(this).addClass("selected");
                    //var table = j$('#lista_pirs').DataTable();
                    //row_sel = table.row( this ).data();
                  } 
                  //console.log(row_sel);
				  
                });

				
				j$('#lista_historico_pir').on( 'init.dt', function () {
					cadena_html='';
					cadena_html+='<div class="btn-group" role="group" id="botones_historico">';
					cadena_html+='<button type="button" class="btn btn-default active">Incidencias</button>';
					cadena_html+='<button type="button" class="btn btn-default">Hist&oacute;rico</button>';
					cadena_html+='<button type="button" class="btn btn-default">Todo</button>';
					cadena_html+='</div>';
						  
					j$("div.toolbar").html(cadena_html);
					
					
					
					j$("#botones_historico > .btn").on('click', function() {  
						//j$("#botones_historico > .btn").click(function(){
							j$(this).addClass("active").siblings().removeClass("active");
							boton_activo=j$(this).html()
							//console.log('boton activo: ' + boton_activo)
							if (boton_activo=='Todo')
								{
								//console.log('hemos pulsado TODO')
								lst_historico_pir.column(2).search('').draw();
								}
							
							if (boton_activo=='Histórico')
								{
								//console.log('hemos pulsado HISTORICO')
								//lst_historico_pir.column(2).search("<>'INCIDENCIA'").draw();
								//^(?!badword|coco$).*$........... para cuando son 2 cosas
								// ..... /^(?:(?!PATTERN).)*$/ ... para todas
								lst_historico_pir.column(2).search('^(?!INCIDENCIA$).*$', true, true, false).draw();
								}
								
							if (boton_activo=='Incidencias')
								{
								//console.log('hemos pulsado INCIDENCIAS')
								lst_historico_pir.column(2).search('INCIDENCIA').draw();
								}
						});
					
					
				  }); 
				 
				

                /*  
          			j$("#stf\\\.lista_tra").on("init.dt", function() {
                    console.log("init.dt"); 
          			});
                
                j$("#stf\\\.lista_tra").on( 'draw.dt', function () {
                    console.log( 'Table redrawn' );
                } );
                */                                                                
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_historico_pir.ajax.url("tojson/obtener_historico_pir.asp?"+prm.toString());
              lst_historico_pir.ajax.reload();                  
            }       
      
      
    
	
	lst_historico_pir.column(2).search('INCIDENCIA').draw();
	
	

});





calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  };  


j$('#cmbestado_d').on('change', function(){
	var opcion_seleccionada = j$('#cmbestado_d option:selected').val();
	//console.log('valor antiguo en cmbestado en change: ' + j$("#cmbestado_d").prop("val_ant"))
	
	if (opcion_seleccionada=='9') //INCIDENCIA
		{
		/*ya no se muestra en una capa
		j$("#cabecera_tipos_incidencia").html('Seleccionar El Tipo de Incidencia');
		j$("#capa_tipos_incidencia").modal({backdrop: 'static',  keyboard: false});
		j$("#capa_tipos_incidencia").modal("show");
		*/
		j$("#mas_incidencias_cmb").removeClass('invisible')
		}	
	  else
	  	{
		j$("#cmbtipos_incidencia_d").val("").change()
		j$("#mas_incidencias_cmb").addClass('invisible')
		j$("#mas_incidencias").addClass('invisible');
	
		}
		
	if (opcion_seleccionada=='8') //GESTION CIA
		{
		j$("#txtgestion_cia").val('')
		j$("#gestion_cia_explicacion").removeClass('invisible')
		}	
	  else
	  	{
		j$("#txtgestion_cia").val('')
		j$("#gestion_cia_explicacion").addClass('invisible')
	
		}
	
	
	
	//console.log('valor nuevo en cmbestado en change: ' + j$("#cmbestado_d").prop("val_ant"))
	//console.log('valor actual en cmbestado en change: ' + j$("#cmbestado_d").val())
	
		 
});

j$('#cmbtipos_incidencia_d').on('change', function(){
	//console.log('cambio en combo tipos incidencia')
	//console.log('...valor de la opcion: ' + j$('#cmbtipos_incidencia_d  option:selected').val())
	var opcion_seleccionada = j$('#cmbtipos_incidencia_d  option:selected').val();
	
	if (opcion_seleccionada=='OTRAS INCIDENCIAS')
		{
		/*ya no se muestra en una capa
		j$("#cabecera_tipos_incidencia").html('Seleccionar El Tipo de Incidencia');
		j$("#capa_tipos_incidencia").modal({backdrop: 'static',  keyboard: false});
		j$("#capa_tipos_incidencia").modal("show");
		*/
		j$("#otras_incidencias").removeClass('invisible')
		j$("#txtotrasincidencias").val('')
		}	
	  else
	  	{
		j$("#otras_incidencias").addClass('invisible')
	
		}
	
	
		 
});




j$('#cmdguardar_pir').on('click', function() {
	hay_error=''
	//console.log('click en guardar')
	//console.log('valor del combo de estados: ' + j$("#cmbestado_d").val())
	
	//si es un alta, tengo que comprobar que se han introducido los datos que
	// vendrian de indiana que al ser un alta no estarán
	if (j$("#ocultoid_pir").val()=='')
		{
		if (j$("#txtpir_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Introducir el N&uacute;mero de PIR.<br>'
			}
		
		if (j$("#txtfecha_orden_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Introducir la Fecha de Orden.<br>'
			}
		
		if (j$("#txtnombre_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Introducir el Nombre.<br>'
			}
		
		if (j$("#txtapellidos_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Introducir los Apellidos.<br>'
			}
				
		if (j$("#txtmovil_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Introducir el Movil.<br>'
			}

		if (j$("#txtdireccion_entrega_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Introducir la Direcci&oacute;n de Entega.<br>'
			}

		if (j$("#txtcp_entrega_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Introducir el C&oacute;digo Postal.<br>'
			}
		
		if (j$("#txtmarca_bag_original_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Introducir la Marca de la Maleta.<br>'
			}
			
		if (j$("#txtmaterial_bag_original_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Introducir el Material de la Maleta.<br>'
			}
			
		if (j$("#cmbestado_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Seleccionar el Estado.<br>'
			}
			
		if (j$("#cmbtipo_maleta_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Seleccionar el Tipo de Maleta.<br>'
			}
		
		if (j$("#cmbproveedores_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Seleccionar el Proveedor.<br>'
			}
		
		if (j$("#txtfecha_inicio_d").val()=='')
			{
			hay_error=hay_error + '- Al Dar De Alta El PIR, Ha de Seleccionar la Fecha de Inicio.<br>'
			}
		
		}
	
	if (j$("#cmbestado_d").val()=='8')  //GESTION CIA
		{
		if (j$("#txtgestion_cia").val()=='')
			{
			hay_error=hay_error + '- Si selecciona GESTION CIA, introduzca una breve descripci&oacute;n.<br>'
			}
		
		}
	if (j$("#cmbestado_d").val()=='9')  //INCIDENCIA
		{
		//console.log('se ha seleccionado incidencia')
		if (!j$("#mas_incidencias_cmb").hasClass("invisible"))
			{
			//console.log('lo de mas incidencias esta visible')
			if (j$("#cmbtipos_incidencia_d").val()=='')
				{
					//console.log('no se ha seleccionado ningun tipo de incidencia')
					hay_error=hay_error + '- Si se reporta una Incidencia, Se ha de Seleccionar el Tipo de Incidencia.<br>'
				}
			  else
			  	{
					if ((j$("#cmbtipos_incidencia_d").val()=='OTRAS INCIDENCIAS') && (j$("#txtotrasincidencias").val()==''))
						{
							hay_error=hay_error + '- Si selecciona OTRAS INCIDENCIAS, introduzca una breve descripci&oacute;n.<br>'
						}
				}
			}
		}
		
	if (j$("#cmbestado_d").val()=='2') //AUTORIZADO
		{
		//console.log('se ha seleccionado incidencia')
		if (j$("#cmbtipo_maleta_d").val()=='')
			{
			hay_error=hay_error + '- Antes de Autorizar hay que Seleccionar el Tipo de Maleta.<br>'
			}
		
		if (j$("#cmbproveedores_d").val()=='')
			{
			hay_error=hay_error + '- Antes de Autorizar hay que Seleccionar el Proveedor.<br>'
			}

		if (j$("#txtfecha_inicio_d").val()=='')
			{
			hay_error=hay_error + '- Antes de Autorizar hay que Seleccionar la Fecha de Inicio.<br>'
			}
		
		
		
		}
		
	if (j$("#cmbestado_d").val()=='5') //ENVIADO
		{
		if (j$("#txtfecha_envio_d").val()=='')
			{
			hay_error=hay_error + '- Antes de Enviar hay que Seleccionar la Fecha de Envio de Maleta Enviada.<br>'
			}
		if (j$("#cmbtipo_maleta_entregada_d").val()=='')
			{
			hay_error=hay_error + '- Antes de Enviar hay que Seleccionar el Tipo de Maleta Enviada.<br>'
			}
		if (j$("#cmbtamanno_maleta_entregada_d").val()=='')
			{
			hay_error=hay_error + '- Antes de Enviar hay que Seleccionar el Tamaño de Maleta Enviada.<br>'
			}
		if (j$("#cmbreferencia_maleta_entregada_d").val()=='')
			{
			hay_error=hay_error + '- Antes de Enviar hay que Seleccionar La Referencia de Maleta Enviada.<br>'
			}	
		if (j$("#txtcolor_maleta_entregada_d").val()=='')
			{
			hay_error=hay_error + '- Antes de Enviar hay que Introducir el Color de Maleta Enviada.<br>'
			}
			
		}
		
		
	if (j$("#cmbestado_d").val()=='6') //ENTREGADO
		{
		if (j$("#txtfecha_envio_d").val()=='')
			{
			hay_error=hay_error + '- Para Guardar Como Entregado hay que Introducir la Fecha de Envio de la Maleta.<br>'
			}
		if (j$("#txtfecha_entrega_pax_d").val()=='')
			{
			hay_error=hay_error + '- Para Guardar Como Entragado hay que Introducir La Fecha de Entrega de La Maleta.<br>'
			}
		if (j$("#cmbtipo_maleta_entregada_d").val()=='')
			{
			hay_error=hay_error + '- Para Guardar Como Entragado hay que Seleccionar el Tipo de Maleta Entregada.<br>'
			}
		if (j$("#cmbtamanno_maleta_entregada_d").val()=='')
			{
			hay_error=hay_error + '- Para Guardar Como Entragado hay que Seleccionar el Tamaño de Maleta Entregada.<br>'
			}
		if (j$("#cmbreferencia_maleta_entregada_d").val()=='')
			{
			hay_error=hay_error + '- Para Guardar Como Entragado hay que Seleccionar La Referencia de Maleta Entregada.<br>'
			}	
		if (j$("#txtcolor_maleta_entregada_d").val()=='')
			{
			hay_error=hay_error + '- Para Guardar Como Entragado hay que Introducir el Color de Maleta Entregada.<br>'
			}
		
		if (j$("#txtnumero_expedicion_d").val()=='')
			{
			hay_error=hay_error + '- Para Guardar Como Entragado hay que Introducir el N&uacute;mero de Expedici&oacute;n.<br>'
			}
		if (j$("#txtcostes_d").val()=='')
			{
			hay_error=hay_error + '- Para Guardar Como Entragado hay que Introducir Los Costes.<br>'
			}
		
			
			
		}
		
	if (j$("#cmbestado_d").val()=='7') //CERRADO
		{
		if (j$("#txtimporte_facturacion_d").val()=='')
			{
			hay_error=hay_error + '- Para Cerrar el PIR hay que Introducir el Importe de La Facturaci&oacute;n.<br>'
			}
		if (j$("#txtfecha_facturacion_d").val()=='')
			{
			hay_error=hay_error + '- Para Cerrar el PIR hay que Seleccionar La Fecha de Facturaci&oacute;n.<br>'
			}	
		
		}
		
			
		
	if (hay_error!='')	
		{
		j$("#cabecera_pantalla_avisos").html("<h3>Errores Detectados</h3>")
		j$("#body_avisos").html('<H4><br>' + hay_error + '<br></h4>');
		j$("#pantalla_avisos").modal("show");
		}
	  else
	  	{
		j$("#frmdatos_pir").submit()
		}	


});


j$('#cmdmas_incidencias_pir').on('click', function() {

if (j$("#cmdmas_incidencias_pir").hasClass("btn-primary"))	
	{
	j$("#mas_incidencias_cmb").removeClass("invisible")
	j$("#cmdmas_incidencias_pir").removeClass("btn-primary").addClass("btn-danger")
	j$("#icocmdmas_incidencias_pir").removeClass("glyphicon-plus").addClass("glyphicon-remove")
	j$("#icocmdmas_incidencias_pir").prop('data-content','Cancelar Nueva Incidencia.');
	}
  else
  	{
	j$("#cmbtipos_incidencia_d").val("").change()
	j$("#mas_incidencias_cmb").addClass("invisible")
	j$("#cmdmas_incidencias_pir").removeClass("btn-danger").addClass("btn-primary")
	j$("#icocmdmas_incidencias_pir").removeClass("glyphicon-remove").addClass("glyphicon-plus")
	j$("#icocmdmas_incidencias_pir").prop('data-content','A&ntilde;adir Nueva Incidencia.');
	}
	
	
});

j$('#cmdautorizar_pir').on('click', function() {

	j$("#cmbestado_d").val('2') //AUTORIZADO
	j$('#cmdguardar_pir').click()

});




</script>
</body>
<%
%>
</html>