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

set detalle_pir=Server.CreateObject("ADODB.Recordset")
	with detalle_pir
		.ActiveConnection=connmaletas
		.Source="SELECT ID, FECHA_ORDEN, ORDEN, AGENTE, EXPEDIENTE, PIR, FECHA_PIR, TAG, NOMBRE, APELLIDOS, DNI, MOVIL, FIJO"
		.Source= .Source & ", DIRECCION_ENTREGA, CP_ENTREGA, TIPO_DIRECCION_ENTREGA, DESDE_HASTA, FECHA_DESDE_HASTA, OBSERVACIONES"
		.Source= .Source & ", TIPO_EQUIPAJE_BAG_ORIGINAL, MARCA_BAG_ORIGINAL, MODELO_BAG_ORIGINAL, MATERIAL_BAG_ORIGINAL"
		.Source= .Source & ", COLOR_BAG_ORIGINAL, LARGO_BAG_ORIGINAL, ALTO_BAG_ORIGINAL, ANCHO_BAG_ORIGINAL, DANNO_RUEDAS_BAG_ORIGINAL"
		.Source= .Source & ", DANNO_ASAS_BAG_ORIGINAL, DANNO_CIERRES_BAG_ORIGINAL, DANNO_CREMALLERA_BAG_ORIGINAL"
		.Source= .Source & ", DANNO_CUERPO_MALETA_BAG_ORIGINAL, DANNO_CIERRES_MALETA_BAG_ORIGINAL, DANNO_OTROS_BAG_ORIGINAL"
		.Source= .Source & ", DANNO, EQUIPAJE, RUTA, VUELOS, TIPO_BAG_ORIGINAL, FECHA_INICIO, FECHA_ENVIO, FECHA_ENTREGA_PAX"
		.Source= .Source & ", PLAZO_ENTREGA_EN_DIAS, INCIDENCIA_TRANSPORTE, INCIDENCIA_MALETA, OTRAS_INCIDENCIAS, TIPO_BAG_ENTREGADA"
		.Source= .Source & ", TAMANNO_BAG_ENTREGADA, REFERENCIA_BAG_ENTREGADA, COLOR_BAG_ENTREGADA, NUM_EXPEDICION, ESTADO"

		.Source= .Source & " FROM PIRS"
		.Source= .Source & " WHERE id=" & id_seleccionado
		'response.write("<br>" & .source)
		.Open
	end with
	
	campo_id=""
	campo_fecha_orden=""
	campo_orden=""
	campo_agente=""
	campo_expediente=""
	campo_pir=""
	campo_fecha_pir=""
	campo_tag=""
	campo_nombre=""
	campo_apellidos=""
	campo_dni=""
	campo_movil=""
	campo_fijo=""
	campo_direccion_entrega=""
	campo_cp_entrega=""
	campo_tipo_direccion_entrega=""
	campo_desde_hasta=""
	campo_fecha_desde_hasta=""
	campo_observaciones=""
	campo_tipo_equipaje_bag_original=""
	campo_marca_bag_original=""
	campo_modelo_bag_original=""
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
	campo_danno_cierres_maleta_bag_original=""
	campo_danno_otros_bag_original=""
	
	
	
	campo_danno=""
	campo_equipaje=""
	campo_ruta=""
	campo_vuelos=""
	campo_tipo_bag_original=""
	campo_fecha_inicio=""
	campo_fecha_envio=""
	campo_fecha_entrega_pax=""
	campo_plazo_entrega_en_dias=""
	campo_incidencia_transporte=""
	campo_incidencia_maleta=""
	campo_otras_incidencias=""
	campo_tipo_bag_entregada=""
	campo_tamanno_bag_entregada=""
	campo_referencia_bag_entregada=""
	campo_color_bag_entregada=""
	campo_numero_expedicion=""
	campo_estado=""
	
	if not detalle_pir.eof then
		campo_id="" & detalle_pir("id")
		
		dia = "0" & datepart("d", cdate(detalle_pir("fecha_orden")))
		mes = "0" & datepart("m", cdate(detalle_pir("fecha_orden")))
		anno = datepart("yyyy", cdate(detalle_pir("fecha_orden")))
		campo_fecha_orden = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		
		campo_orden="" & detalle_pir("orden")
		campo_agente="" & detalle_pir("agente")
		campo_expediente="" & detalle_pir("expediente")
		campo_pir="" & detalle_pir("pir")
		
		dia = "0" & datepart("d", cdate(detalle_pir("fecha_pir")))
		mes = "0" & datepart("m", cdate(detalle_pir("fecha_pir")))
		anno = datepart("yyyy", cdate(detalle_pir("fecha_pir")))
		campo_fecha_pir = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		
		campo_tag="" & detalle_pir("tag")
		campo_nombre="" & detalle_pir("nombre")
		campo_apellidos="" & detalle_pir("apellidos")
		campo_dni="" & detalle_pir("dni")
		campo_movil="" & detalle_pir("movil")
		campo_fijo="" & detalle_pir("fijo")
		campo_direccion_entrega="" & detalle_pir("direccion_entrega")
		campo_cp_entrega="" & detalle_pir("cp_entrega")
		campo_tipo_direccion_entrega="" & detalle_pir("tipo_direccion_entrega")
		campo_desde_hasta="" & detalle_pir("desde_hasta")
		
		dia = "0" & datepart("d", cdate(detalle_pir("fecha_desde_hasta")))
		mes = "0" & datepart("m", cdate(detalle_pir("fecha_desde_hasta")))
		anno = datepart("yyyy", cdate(detalle_pir("fecha_desde_hasta")))
		campo_fecha_desde_hasta = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 

		campo_observaciones="" & detalle_pir("observaciones")
		campo_tipo_equipaje_bag_original="" & detalle_pir("tipo_equipaje_bag_original")
		campo_marca_bag_original="" & detalle_pir("marca_bag_original")
		campo_modelo_bag_original="" & detalle_pir("modelo_bag_original")
		campo_material_bag_original="" & detalle_pir("material_bag_original")
		campo_color_bag_original="" & detalle_pir("color_bag_original")
		campo_largo_bag_original="" & detalle_pir("largo_bag_original")
		campo_alto_bag_original="" & detalle_pir("alto_bag_original")
		campo_ancho_bag_original="" & detalle_pir("ancho_bag_original")
		campo_danno_ruedas_bag_original="" & detalle_pir("danno_ruedas_bag_original")
		campo_danno_asas_bag_original="" & detalle_pir("danno_asas_bag_original")
		campo_danno_cierres_bag_original="" & detalle_pir("danno_cierres_bag_original")
		campo_danno_cremallera_bag_original="" & detalle_pir("danno_cremallera_bag_original")
		campo_danno_cuerpo_maleta_bag_original="" & detalle_pir("danno_cuerpo_maleta_bag_original")
		campo_danno_cierres_maleta_bag_original="" & detalle_pir("danno_cierres_maleta_bag_original")
		campo_danno_otros_bag_original="" & detalle_pir("danno_otros_bag_original")
		
		
	

		
		
		campo_danno="" & detalle_pir("danno")
		campo_equipaje="" & detalle_pir("equipaje")
		campo_ruta="" & detalle_pir("ruta")
		campo_vuelos="" & detalle_pir("vuelos")
		campo_tipo_bag_original="" & detalle_pir("tipo_bag_original")
		
		dia = "0" & datepart("d", cdate(detalle_pir("fecha_inicio")))
		mes = "0" & datepart("m", cdate(detalle_pir("fecha_inicio")))
		anno = datepart("yyyy", cdate(detalle_pir("fecha_inicio")))
		campo_fecha_inicio = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		
		dia = "0" & datepart("d", cdate(detalle_pir("fecha_envio")))
		mes = "0" & datepart("m", cdate(detalle_pir("fecha_envio")))
		anno = datepart("yyyy", cdate(detalle_pir("fecha_envio")))
		campo_fecha_envio = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		
		dia = "0" & datepart("d", cdate(detalle_pir("fecha_entrega_pax")))
		mes = "0" & datepart("m", cdate(detalle_pir("fecha_entrega_pax")))
		anno = datepart("yyyy", cdate(detalle_pir("fecha_entrega_pax")))
		campo_fecha_entrega_pax = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
		
		campo_plazo_entrega_en_dias="" & detalle_pir("plazo_entrega_en_dias")
		campo_incidencia_transporte="" & detalle_pir("incidencia_transporte")
		campo_incidencia_maleta="" & detalle_pir("incidencia_maleta")
		campo_otras_incidencias="" & detalle_pir("otras_incidencias")
		campo_tipo_bag_entregada="" & detalle_pir("tipo_bag_entregada")
		campo_tamanno_bag_entregada="" & detalle_pir("tamanno_bag_entregada")
		campo_referencia_bag_entregada="" & detalle_pir("referencia_bag_entregada")
		campo_color_bag_entregada="" & detalle_pir("color_bag_entregada")
		campo_numero_expedicion="" & detalle_pir("num_expedicion")
		campo_estado="" & detalle_pir("estado")
		
	end if
		
	
	
	'response.write("<br>campo_danno_ruedas_bag_original= " & campo_danno_ruedas_bag_original)
	'response.write("<br>campo_danno_asas_bag_original= " & campo_danno_asas_bag_original)
	'response.write("<br>campo_danno_cierres_bag_original= " & campo_danno_cierres_bag_original)
	'response.write("<br>campo_danno_cremallera_bag_original= " & campo_danno_cremallera_bag_original)
	'response.write("<br>campo_danno_cuerpo_maleta_bag_original= " & campo_danno_cuerpo_maleta_bag_original)
	'response.write("<br>campo_danno_cierres_maleta_bag_original= " & campo_danno_cierres_maleta_bag_original)
	'response.write("<br>campo_danno_otros_bag_original= " & campo_danno_otros_bag_original)
	
	
	
	if ucase(campo_danno_ruedas_bag_original)="SI" then
		campo_danno_ruedas_bag_original="1"
	  else
	  	campo_danno_ruedas_bag_original="0"
	end if
	
	if ucase(campo_danno_asas_bag_original)="SI" then
		campo_danno_asas_bag_original="1"
	  else
	  	campo_danno_asas_bag_original="0"
	end if
	
	if ucase(campo_danno_cierres_bag_original)="SI" then
		campo_danno_cierres_bag_original="1"
	  else
	  	campo_danno_cierres_bag_original="0"
	end if
	
	if ucase(campo_danno_cremallera_bag_original)="SI" then
		campo_danno_cremallera_bag_original="1"
	  else
	  	campo_danno_cremallera_bag_original="0"
	end if
	if ucase(campo_danno_cuerpo_maleta_bag_original)="SI" then
		campo_danno_cuerpo_maleta_bag_original="1"
	  else
	  	campo_danno_cuerpo_maleta_bag_original="0"
	end if
	if ucase(campo_danno_cierres_maleta_bag_original)="SI" then
		campo_danno_cierres_maleta_bag_original="1"
	  else
	  	campo_danno_cierres_maleta_bag_original="0"
	end if
	
	if ucase(campo_danno_otros_bag_original)="SI" then
		campo_danno_otros_bag_original="1"
	  else
	  	campo_danno_otros_bag_original="0"
	end if
	
		
	'response.write("<br>campo_danno_ruedas_bag_original= " & campo_danno_ruedas_bag_original)
	'response.write("<br>campo_danno_asas_bag_original= " & campo_danno_asas_bag_original)
	'response.write("<br>campo_danno_cierres_bag_original= " & campo_danno_cierres_bag_original)
	'response.write("<br>campo_danno_cremallera_bag_original= " & campo_danno_cremallera_bag_original)
	'response.write("<br>campo_danno_cuerpo_maleta_bag_original= " & campo_danno_cuerpo_maleta_bag_original)
	'response.write("<br>campo_danno_cierres_maleta_bag_original= " & campo_danno_cierres_maleta_bag_original)
	'response.write("<br>campo_danno_otros_bag_original= " & campo_danno_otros_bag_original)
	
	
	
		
detalle_pir.close
set detalle_pir=Nothing

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
				<h3 class="panel-title">Datos Pir - Procedentes de Indiana</h3>
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
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtpir_d" name="txtpir_d" value="<%=campo_pir%>" />
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
								<input type="text" id="txttag_d" class="form-control" required="" name="txttag_d" value="<%=campo_tag%>" /> 
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
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_ruedas_d" class="control-label" style="width:100%">Da�o Ruedas</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_ruedas_d" name="chkdanno_ruedas_d" class="form-control chk_bt" >
							</div>
							
                          </div>
						</div>						  

						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_asas_d" class="control-label" style="width:100%">Da�o Asas</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_asas_d" name="chkdanno_asas_d"   class="form-control chk_bt" width="100%" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cierres_d" class="control-label" style="width:100%">Da�o Cierres</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_cierres_d" name="chkdanno_cierres_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cremalleras_d" class="control-label" style="width:100%">Da�o Cremalleras</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_cremalleras_d" name="chkdanno_cremalleras_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cuerpo_maleta_d" class="control-label" style="width:100%">Da�o Cuerpo Maleta</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_cuerpo_maleta_d" name="chkdanno_cuerpo_maleta_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cierres_maleta_d" class="control-label"  style="width:100%">Da�o Cierres Maleta</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_cierres_maleta_d" name="chkdanno_cierres_maleta_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_otros_dannos_d" class="control-label" style="width:100%">Otros Da�os</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_otros_dannos_d" name="chkdanno_otros_dannos_d"  class="form-control chk_bt" >
							</div>
                          </div>
						</div>						  
  
  						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtruta_d" class="control-label" style="width:100%">Ruta</label>
								<input type="text" id="txtruta_d" class="form-control" required="" name="txtruta_d" value="<%=campo_ruta%>" /> 
							</div>
							<div class="col-sm-4 col-md-4 col-lg-4">
								<label for="txtvuelos_d" class="control-label">Vuelos</label>
								<input type="text" id="txtvuelos_d" class="form-control" required="" name="txtvuelos_d" value="<%=campo_vuelos%>" /> 
							</div>
							
							
                          </div>
						</div>						  
				
		  </div>
			<!-- panel Body-->
		</div>
		<!-- PANEL-->
	</div> 
	<!-- FIN datos pir indiana -->
	
	
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
			<div class="form-group">
				<div class="col-sm-12 col-md-12 col-lg-12">
						  <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="cmbtipo_maleta_d" class="control-label">Tipo Maleta</label>
								<div class="clearfix visible-md-block"></div>
								<select id="cmbtipo_maleta_d" name="cmbtipo_maleta_d" data-width="100%" class="cmb_bt">
								  <option value="">&nbsp;</option>
								  <option value="4A">TIPO 4A</option>
								  <option value="4B">TIPO 4B</option>
								</select>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_inicio_d" class="control-label">Fecha Inicio</label>
								<input type="date" id="txtfecha_inicio_d" class="form-control" required="" name="txtfecha_inicio_d" value="<%=campo_fecha_inicio%>" /> 
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtimporte_facturacion_d" class="control-label">Importe Facturaci&oacute;n</label>
								<input type="text" id="txtimporte_facturacion_d" class="form-control" required="" name="txtimporte_facturacion_d" value="" /> 
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<div class="pull-right">
									<div class="col-sm-2 col-md-2 col-lg-2">
										<button type="button" class="btn btn-success btn-lg" id="autorizar_pir" name="autorizar_pir">
										  <span class="glyphicon glyphicon-ok" aria-hidden="true"></span> Autorizar Pir
										</button>
									</div>
								</div>
							</div>

							
				</div>
			</div>
		</div>
	</div>
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
							<label for="cmbestado_d" class="control-label">Estado</label>
							<div class="clearfix visible-md-block"></div>
							<select id="cmbestado_d" name="cmbestado_d" data-width="100%" class="cmb_bt">
							  <option value="">&nbsp;</option>
							  <option value="PTE AUTORIZACION">PTE. AUTORIZACI&Oacute;N</option>
							  <option value="AUTORIZADO">AUTORIZADO</option>
							  <option value="EN GESTION">EN GESTI&Oacute;N</option>
							  <option value="ENVIADO">ENVIADO</option>
							  <option value="ENTREGADO">ENTREGADO</option>
							  <option value="CERRADO">CERRADO</option>
							  <option value="GESTION CIA">GESTI&Oacute;N CIA</option>
							  <option value="INCIDENCIA">INCIDENCIA</option>
							</select>
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
						</div>
					</div>
					
					<div class="form-group row">
					
						
						
						
						
						
						
						
						
						
						
						
						
						
						
					  	<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_envio_d" class="control-label">Fecha Envio</label>
								<input type="date" id="txtfecha_envio_d" class="form-control" required="" name="txtfecha_envio_d" value="<%=campo_fecha_envio%>" /> 
							</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="txtfecha_entrega_pax_d" class="control-label">Fecha Entrega Pax</label>
							<input type="date" id="txtfecha_entrega_pax_d" class="form-control" required="" name="txtfecha_entrega_pax_d" value="<%=campo_fecha_entrega_pax%>" /> 
						</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="cmbtipo_maleta_entregada_d" class="control-label">Tipo Bag Entregada</label>
							<div class="clearfix visible-md-block"></div>
							<select id="cmbtipo_maleta_entregada_d" name="cmbtipo_maleta_entregada_d" data-width="100%" class="cmb_bt">
							  <option value="">&nbsp;</option>
							  <option value="4A">TIPO 4A</option>
							  <option value="4B">TIPO 4B</option>
							</select>
						</div>
						
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="txttamanno_maleta_entregada_d" class="control-label">Tama�o</label>
							<input type="text" id="txttamanno_maleta_entregada_d" class="form-control" required="" name="txttamanno_maleta_entregada_d" value="<%=campo_tamanno_maleta_entregada%>" /> 
						</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="cmdreferencia_malenta_entregada_d" class="control-label">Referencia</label>
							<div class="clearfix visible-md-block"></div>
							<select id="cmbreferencia_maleta_entregada_d" name="cmbreferencia_maleta_entregada_d" data-width="100%" class="cmb_bt">
							  <option value="">&nbsp;</option>
							  <option value="4A">CHTLJMXW3</option>
							  <option value="4B">FGGHNBV</option>
							  <option value="4C">PNOLDSJG</option>
							  <option value="4D">SAMOEH</option>
							  <option value="4E">VCTPZG</option>
							</select>
						</div>
						
						
					  </div>
					</div>
				</div>						  
				
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-12">
					  <div class="form-group row">
					  	<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="txtcolor_malenta_entregada_d" class="control-label">Color</label>
							<input type="text" id="txtcolor_maleta_entregada_d" class="form-control" required="" name="txtcolor_maleta_entregada_d" value="<%=campo_color_maleta_entregada%>" /> 
						</div>
				  		<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtnumero_expedicion_d" class="control-label">N&uacute;m Expecici&oacute;n</label>
								<input type="text" id="txtnumero_expedicion_d" class="form-control" required="" name="txtnumero_expedicion_d" value="<%=campo_numero_expedicion%>" /> 
						</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtimporte_coste_d" class="control-label">Importe Coste</label>
								<input type="text" id="txtimporte_coste_d" class="form-control" required="" name="txtimporte_coste_d" value="" /> 
						</div>
					  </div>
					</div>
				</div>			
				
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-12">
					  <div class="form-group row">
					  	<div class="col-sm-2 col-md-2 col-lg-2">
							<button type="button" class="btn btn-primary btn-lg" id="cmdguardar_pir" name="cmdguardar_pir">
							  <span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Guardar Pir
							</button>
						</div>
					  </div>
					</div>
				</div>			
				
				
		
	  </div>
		<!-- panel Body-->
	</div>
	<!-- fin datos pir proveedor-->


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
  




<script language="javascript">
var j$=jQuery.noConflict();

j$(document).on('click', '.panel-heading span.clickable', function(e){
    var j$this = j$(this);
	if(!j$this.hasClass('panel-collapsed')) {
		console.log('encuentra panel-collapsed')
		j$this.parents('.panel').find('.panel-body').slideUp();
		j$this.addClass('panel-collapsed');
		j$this.find('i').removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
	} else {
		console.log('NOOO encuentra panel-collapsed')
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

	j$("#chkdanno_ruedas_d").bootstrapSwitch("state", <%=campo_danno_ruedas_bag_original%>);
	j$("#chkdanno_asas_d").bootstrapSwitch("state", <%=campo_danno_asas_bag_original%>);
	j$("#chkdanno_cierres_d").bootstrapSwitch("state", <%=campo_danno_cierres_bag_original%>);
	j$("#chkdanno_cremalleras_d").bootstrapSwitch("state", <%=campo_danno_cremallera_bag_original%>);
	j$("#chkdanno_cuerpo_maleta_d").bootstrapSwitch("state", <%=campo_danno_cuerpo_maleta_bag_original%>);
	j$("#chkdanno_cierres_maleta_d").bootstrapSwitch("state", <%=campo_danno_cierres_maleta_bag_original%>);
	j$("#chkdanno_otros_dannos_d").bootstrapSwitch("state", <%=campo_danno_otros_bag_original%>);
	
	
	j$("#cmbestado_d").val('<%=campo_estado%>');
	if (j$("#cmbestado_d").val()=='INCIDENCIA')
		{
		j$("#mas_incidencias").removeClass('invisible')
		}	
	
	j$("#cmbtipo_direccion_entrega_d").val('<%=campo_tipo_direccion_entrega%>');
	j$("#cmbdesde_hasta_d").val('<%=campo_desde_hasta%>');
	j$("#cmbtipo_bag_entregada_d").val('<%=campo_tipo_bag_entregada%>');
	
	j$(".cmb_bt").selectpicker('refresh')
	
	
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
													 fixedHeader: true,
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
							console.log('boton activo: ' + boton_activo)
							if (boton_activo=='Todo')
								{
								console.log('hemos pulsado TODO')
								lst_historico_pir.column(2).search('').draw();
								}
							
							if (boton_activo=='Hist�rico')
								{
								console.log('hemos pulsado HISTORICO')
								//lst_historico_pir.column(2).search("<>'INCIDENCIA'").draw();
								//^(?!badword|coco$).*$........... para cuando son 2 cosas
								// ..... /^(?:(?!PATTERN).)*$/ ... para todas
								lst_historico_pir.column(2).search('^(?!INCIDENCIA$).*$', true, true, false).draw();
								}
								
							if (boton_activo=='Incidencias')
								{
								console.log('hemos pulsado INCIDENCIAS')
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
	
	j$("#cmbestado_d").attr("val_ant", j$("#cmbestado_d").val());
	console.log('valor actual en cmbestado en el ready: ' + j$("#cmbestado_d").val())

});





calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  };  


j$('#cmbestado_d').on('change', function(){
	var opcion_seleccionada = j$('#cmbestado_d option:selected').val();
	console.log('valor antiguo en cmbestado en change: ' + j$("#cmbestado_d").attr("val_ant"))
	
	if (opcion_seleccionada=='INCIDENCIA')
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
	
	console.log('valor nuevo en cmbestado en change: ' + j$("#cmbestado_d").attr("val_ant"))
	console.log('valor actual en cmbestado en change: ' + j$("#cmbestado_d").val())
	
		 
});


j$('#cmdguardar_pir').on('click', function() {
	hay_error=''
	console.log('click en guardar')
	console.log('valor del combo de estados: ' + j$("#cmbestado_d").val())
	if (j$("#cmbestado_d").val()=='INCIDENCIA')
		{
		console.log('se ha seleccionado incidencia')
		if (!j$("#mas_incidencias_cmb").hasClass("invisible"))
			{
			console.log('lo de mas incidencias esta visible')
			if (j$("#cmbtipos_incidencia_d").val()=='')
				{
					console.log('no se ha seleccionado ningun tipo de incidencia')
				hay_error=hay_error + '- Si se reporta una Incidencia, Se ha de Seleccionar el Tipo de Incidencia.<br>'
				}
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
	j$("#icocmdmas_incidencias_pir").attr('data-content','Cancelar Nueva Incidencia.');
	}
  else
  	{
	j$("#cmbtipos_incidencia_d").val("").change()
	j$("#mas_incidencias_cmb").addClass("invisible")
	j$("#cmdmas_incidencias_pir").removeClass("btn-danger").addClass("btn-primary")
	j$("#icocmdmas_incidencias_pir").removeClass("glyphicon-remove").addClass("glyphicon-plus")
	j$("#icocmdmas_incidencias_pir").attr('data-content','A&ntilde;adir Nueva Incidencia.');
	}
	
	
});





</script>
</body>
<%
%>
</html>