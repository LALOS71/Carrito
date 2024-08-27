<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

	<title>Consulta Incidencias</title>
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />

	<style>
		body { padding-top: 70px; }
	</style>


	
<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

    </head>
<body>


<!--#include file="menu.asp"-->


<div class="container-fluid">

	<div class="well well-sm">
				<form name="frmconsulta_pedidos" action="Consulta_Pedidos_Gag.asp" method="post">
						<div class="form-group row">    
							<label class="col-md-1 control-label">PIR</label>	                
							<div class="col-md-2">
								<input type="text" class="form-control" size="8" name="txtpir" id="txtpir" value="" />
							</div>
							
							<div class="col-md-2">
								<div class="input-group date" id="fecha_orden_inicio">
								  <input type="Text" class="form-control" name="txtfecha_orden_inicio" id="txtfecha_orden_inicio" value="" size=7>
								  <span class="input-group-addon"><i class="glyphicon glyphicon-calendar text-primary" title="Pulsa Aqu&iacute; Para Seleccionar Una Fecha Inicial para Fecha Orden"></i></span>
								</div>
								<script type="text/javascript">
									/*
									$(function () {
										$('#fecha_inicio').datetimepicker({
											format: 'DD/MM/YYYY'
											});
									});
									*/
								</script>
							</div>
							<div class="col-md-2">
								<div class="input-group date" id="fecha_orden_fin">
								  <input type="Text" class="form-control" name="txtfecha_orden_fin" id="txtfecha_orden_fin" value="" size=7>
								  <span class="input-group-addon"><i class="glyphicon glyphicon-calendar text-primary" title="Pulsa Aqu&iacute; Para Seleccionar Una Fecha Final para Fecha Orden"></i></span>
								</div>
								<script type="text/javascript">
									/*
									$(function () {
										$('#fecha_inicio').datetimepicker({
											format: 'DD/MM/YYYY'
											});
									});
									*/
								</script>
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
									/*
									$(function () {
										$('#fecha_inicio').datetimepicker({
											format: 'DD/MM/YYYY'
											});
									});
									*/
								</script>
							</div>
							
							<label class="col-md-2 control-label" title="<%=consulta_pedidos_gag_panel_lista_pedidos_filtro_fecha_fin_alter%>"><%=consulta_pedidos_gag_panel_lista_pedidos_filtro_fecha_fin%></label>	                
						  	<div class="col-md-4">
								<div class="input-group date" id="fecha_fin">
								  <input type="Text" class="form-control" name="txtfecha_fin" id="txtfecha_fin" value="<%=fecha_f%>" size=7>
								  <span class="input-group-addon"><i class="glyphicon glyphicon-calendar text-primary" title="<%=consulta_pedidos_gag_panel_lista_pedidos_filtro_fecha_fin_calendar_alter%>"></i></span>
								</div>
								<script type="text/javascript">
									/*$(function () {
										$('#fecha_fin').datetimepicker({
											format: 'DD/MM/YYYY'
											});
									});
									*/
								</script>
							</div>
							  
						  
						  
						  	<label class="col-md-2 control-label"><%=consulta_pedidos_gag_panel_lista_pedidos_filtro_estado%></label>	                
							<div class="col-md-6">
								<select class="form-control" name="cmbestados" id="cmbestados" size="1">
									<option value=""  selected="selected"><%=consulta_pedidos_gag_panel_lista_pedidos_filtro_estado_combo_seleccionar%></option>
									<%if session("usuario_codigo_empresa")=4 then
											IF session("usuario_tipo")="OFICINA" THEN%>
													<option value="PENDIENTE PAGO">PENDIENTE PAGO</option>
												<%else%>
													<option value="PENDIENTE AUTORIZACION">PENDIENTE AUTORIZACION</option>
											<%end if%>
											<option value="RESERVADO">RESERVADO</option>
										<%else
											'UVE no tiene este estado, directamente van a sin tratar los pedidos
											if session("usuario_codigo_empresa")<>150 then%>
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
							<div class="col-md-2">
							  <button type="submit" name="Action" id="Action" class="btn btn-primary btn-sm">
									<i class="glyphicon glyphicon-search"></i>
									<span><%=consulta_pedidos_gag_panel_lista_pedidos_boton_buscar%></span>
							  </button>
							</div>

						
						
						
						</div>
						
					</form>
				</div>


</div>

ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />
ñlkasjdfñlkasjd
<br />

ñlkasjdfñlkasjd
<br />

asdfasd
<br /><br />

asdfasd
<br /><br />
asdfasd
<br /><br />

asdfasd
<br /><br />

asdfasd
<br /><br />

asdfasd
<br /><br />

asdfasd
<br /><br />
asdfasd
<br /><br />


<script language="javascript">
var j$=jQuery.noConflict();

j$(document).ready(function () {
	var pathname = window.location.pathname;
	console.log('url: ' + pathname)
	posicion=pathname.lastIndexOf('/')
	pathname=pathname.substring(posicion + 1,pathname.length)
	console.log('url truncada: ' + pathname)
	j$('.nav > li > a[href="'+pathname+'"]').parent().addClass('active');


});


</script>
</body>
<%
%>
</html>