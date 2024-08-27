<%@ language=vbscript%>
<!--#include file="Conexion.inc"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%

id_seleccionado=Request.QueryString("id")
set detalle_pir=Server.CreateObject("ADODB.Recordset")
	with detalle_pir
		.ActiveConnection=connmaletas
		.Source="SELECT ID, FECHA_ORDEN, ORDEN, AGENTE, EXPEDIENTE, PIR, FECHA_PIR, TAG, NOMBRE, APELLIDOS, DNI, MOVIL, FIJO"
		.Source= .Source & ", DIRECCION_ENTREGA, CP_ENTREGA, TIPO_DIRECCION_ENTREGA, DESDE_HASTA, FECHA_DESDE_HASTA, OBSERVACIONES"
		.Source= .Source & ", TIPO_EQUIPAJE_BAG_ORIGINAL, MARCA_BAG_ORIGINAL, MODELO_BAG_ORIGINAL, MATERIAL_BAG_ORIGINAL"
		.Source= .Source & ", COLOR_BAG_ORIGINAL, LARGO_BAG_ORIGINAL, ALTO_BAG_ORIGINAL, ANCHO_BAG_ORIGINAL, RUEDAS_BAG_ORIGINAL"
		.Source= .Source & ", ASAS_BAG_ORIGINAL, CIERRES_BAG_ORIGINAL, CREMALLERA_BAG_ORIGINAL, DANNO, EQUIPAJE, RUTA, VUELOS"
		.Source= .Source & ", TIPO_BAG_ORIGINAL, FECHA_INICIO, FECHA_ENVIO, FECHA_ENTREGA_PAX, PLAZO_ENTREGA_EN_DIAS"
		.Source= .Source & ", INCIDENCIA_TRANSPORTE, INCIDENCIA_MALETA, OTRAS_INCIDENCIAS, TIPO_BAG_ENTREGADA, TAMANNO_BAG_ENTREGADA"
		.Source= .Source & ", REFERENCIA_BAG_ENTREGADA, COLOR_BAG_ENTREGADA, NUM_EXPEDICION, ESTADO"

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
	campo_ruedas_bag_original=""
	campo_asas_bag_original=""
	campo_cierres_bag_original=""
	campo_cremallera_bab_original=""
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
		campo_ruedas_bag_original="" & detalle_pir("ruedas_bag_original")
		campo_asas_bag_original="" & detalle_pir("asas_bag_original")
		campo_cierres_bag_original="" & detalle_pir("cierres_bag_original")
		campo_cremallera_bag_original="" & detalle_pir("cremallera_bag_original")
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
		
		
detalle_pir.close
set deetalle_pir=Nothing

connmaletas.close
set connmaletas=Nothing

%>

<html>



<head>


	<title>PIR</title>
	

	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-switch/css/bootstrap-switch.min.css">
	
	<link rel="stylesheet" type="text/css" href="plugins/font-awesome-4.7.0/css/font-awesome.min.css">

	<style>
	.clickable{
 	   cursor: pointer;   
	}

	.panel-heading span {
		margin-top: -20px;
		font-size: 15px;
	}
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
								<label for="txttipo_equipaje_d" class="control-label">Tipo Equipaje</label>
								<input type="text" id="txttipo_equipaje_d" class="form-control" required="" name="txttipo_equipaje_d" value="<%=campo_tipo_equipaje_bag_original%>" /> 
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtmarca_d" class="control-label">Marca</label>
								<input type="text" id="txtmarca_d" class="form-control" required="" name="txtmarca_d" value="<%=campo_marca_bag_original%>" /> 
							</div>
                          </div>
						</div>						  
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtmaterial_d" class="control-label">Material</label>
								<input type="text" id="txtmaterial_d" class="form-control" required="" name="txtmaterial_d" value="<%=campo_material_bag_original%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtcolor_d" class="control-label">Color</label>
								<input type="text" id="txtcolor_d" class="form-control" required="" name="txtcolor_d" value="<%=campo_color_bag_original%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtlargo_d" class="control-label">Largo</label>
								<input type="text" id="txtlargo_d" class="form-control" required="" name="txtlargo_d" value="<%=campo_largo_bag_original%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtalto_d" class="control-label">Alto</label>
								<input type="text" id="txtalto_d" class="form-control" required="" name="txtalto_d" value="<%=campo_alto_bag_original%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtancho_d" class="control-label">Ancho</label>
								<input type="text" id="txtancho_d" class="form-control" required="" name="txtancho_d" value="<%=campo_ancho_bag_original%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_ruedas_d" class="control-label">Daño Ruedas</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_ruedas_d" name="chkdanno_ruedas_d" class="form-control chk_bt" >
							</div>
							
                          </div>
						</div>						  

						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
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
								<label for="chkdanno_cuerpo_maleta_d" class="control-label" style="width:100%">Daño Cuerpo Maleta</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_cuerpo_maleta_d" name="chkdanno_cuerpo_maleta_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cierres_maleta_d" class="control-label"  style="width:100%">Daño Cierres Maleta</label>
								<div class="clearfix visible-md-block"></div>
								<input type="checkbox" id="chkdanno_cierres_maleta_d" name="chkdanno_cierres_maleta_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_otros_dannos_d" class="control-label" style="width:100%">Otros Daños</label>
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
			<h3 class="panel-title">Datos PIR - PPC</h3>
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
			<h3 class="panel-title">Datos Pir - Proveedor</h3>
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
							  <option value="SIN TRATAR">SIN TRATAR</option>
							  <option value="AUTORIZADO">AUTORIZADO</option>
							  <option value="EN PROCESO">EN PROCESO</option>
							  <option value="ENVIADO">ENVIADO</option>
							  <option value="CERRADO">CERRADO</option>
							  <option value="CON INCIDENCIA">CON INCIDENCIA</option>
							  
							  
							  
							</select>
						</div>
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
							<label for="txttamanno_maleta_entregada_d" class="control-label">Tamaño</label>
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
			<h3 class="panel-title">Datos Pir - Hist&oacute;rico Actividad - Incidencias</h3>
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
						  <div width="98%">
						  			<div class="btn-group" role="group" id="botones_historico">
									  <button type="button" class="btn btn-default">Todo</button>
									  <button type="button" class="btn btn-default">Hist&oacute;rico</button>
									  <button type="button" class="btn btn-default active">Incidencias</button>
									</div>
							 <table id="lista_historico_pir" name="lista_historico_pir" class="table table-striped table-bordered" cellspacing="0" width="100%">
							  <thead>
								<tr>
								  <th>Fecha</th>
								  <th>Usuario</th>
								  <th>Tipo</th>
								  <th>Descripci&oacute;n</th>
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
	
	//para que se reconfigure el combo como del tipo selectpicker
	j$('.cmb_bt').selectpicker()

	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true, container: 'body'});
	
	j$(".chk_bt").bootstrapSwitch();
    j$(".chk_bt").bootstrapSwitch("onText", "S&iacute;");
    j$(".chk_bt").bootstrapSwitch("offText", "No");

	j$("#chkdanno_ruedas_d").bootstrapSwitch("state", true);
	j$("#chkdanno_asas_d").bootstrapSwitch("state", false);

	j$("#cmbtipo_direccion_entrega_d").val('<%=campo_tipo_direccion_entrega%>');
	j$("#cmbdesde_hasta_d").val('<%=campo_desde_hasta%>');
	j$("#cmbtipo_bag_entregada_d").val('<%=campo_tipo_bag_entregada%>');
	
	j$(".cmb_bt").selectpicker('refresh')

});





calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  };  


j$('#cmdguardar_pir').on('click', function() {

	j$("#frmdatos_pir").submit()

});
  
j$("#botones_historico > .btn").on('click', function() {  
//j$("#botones_historico > .btn").click(function(){
    j$(this).addClass("active").siblings().removeClass("active");
	boton_activo=j$(this).html()
	console.log('boton activo: ' + boton_activo)
	if (boton_activo=='Todo')
		{
		console.log('hemos pulsado TODO')
		}
	
	if (boton_activo=='Histórico')
		{
		console.log('hemos pulsado HISTORICO')
		}
		
	if (boton_activo=='Incidencias')
		{
		console.log('hemos pulsado INCIDENCIAS')
		}
});

</script>
</body>
<%
%>
</html>