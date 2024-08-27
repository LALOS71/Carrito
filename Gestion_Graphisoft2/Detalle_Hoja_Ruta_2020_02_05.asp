<!--#include file="DB_Manager.inc"-->
<!--#include file="tojson/JSONData.inc"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
	Dim estados
	Dim sql
	Dim query_options

	If Session("usuario") = "" Then
        Response.Redirect("Login.asp")
	End If

	hoja_ruta_seleccionada = Request.QueryString("hoja_ruta")

	CAMPO_ID_ESTADOS			= 0
	CAMPO_DESCRIPCION_ESTADOS	= 1

	' GetEstados query
	sql = "SELECT ID, DESCRIPCION FROM GESTION_GRAPHISOFT_ESTADOS ORDER BY ORDEN"
	vacio_estados = false

	Set estados = execute_sql(conn_gag, sql)
    If Not estados.BOF Then
        tabla_estados = estados.GetRows()
	Else
		vacio_estados = true
    End If

    close_connection(estados)
	set estados = Nothing
	' /GetEstados query
	
	'primero nos traemos los datos actualizados de esa hoja que estan en Graphisoft
	'solo lo hacemos en produccion, porque en desarrollo no tenemos acceso al serversql MAYLLUGRAPH01\GRAPHISOFT2012
	If env = "prod" Then
		sql = "UPDATE GESTION_GRAPHISOFT_HOJAS_IMPORTADAS"
		sql = sql & " SET"
		sql = sql & " PRESUPUESTISTA = B.PRESUPUESTISTA"
		sql = sql & ", PRESUPUESTO = B.PRESUPUESTO"
		sql = sql & ", FECHA_EMISION = B.FECHA_EMISION"
		sql = sql & ", PRODUCTO = B.PRODUCTO"
		sql = sql & ", ID_CLIENTE = B.ID_CLIENTE"
		'sql = sql & ", CLIENTE_NOMBRE = B.CLIENTE_NOMBRE"
		'sql = sql & ", CLIENTE_DIRECCION = B.CLIENTE_DIRECCION"
		'sql = sql & ", CLIENTE_POBLACION = B.CLIENTE_POBLACION"
		'sql = sql & ", CLIENTE_CP = B.CLIENTE_CP"
		'sql = sql & ", CLIENTE_PAIS = B.CLIENTE_PAIS"
		'sql = sql & ", CLIENTE_TELEFONO = B.CLIENTE_TELEFONO"
		sql = sql & ", REFERENCIA = B.REFERENCIA"
		sql = sql & ", CANTIDAD = B.CANTIDAD"
		sql = sql & ", SUBCONTRATISTA = B.SUBCONTRATISTA"
		sql = sql & ", FECHA_RECEPCION = B.FECHA_RECEPCION"
		sql = sql & ", PRESUPUESTO_SUBCONTRATISTA = B.PRESUPUESTO_SUBCONTRATISTA"
		sql = sql & ", OBSERVACIONES_GRAPHISOFT = B.OBSERVACIONES"
		sql = sql & ", COMENTARIOS = B.COMENTARIOS"
		sql = sql & ", FECHA_ENTREGA = B.FECHA_ENTREGA"
		sql = sql & ", TERMINADA = B.TERMINADA"
		sql = sql & ", ANULADA = B.ANULADA"
		sql = sql & ", IMPORTE = B.IMPORTE"
		sql = sql & ", SALIDA = B.SALIDA"
		sql = sql & " FROM  GESTION_GRAPHISOFT_HOJAS_IMPORTADAS A"
		sql = sql & " INNER JOIN (SELECT * FROM OPENQUERY ([MAYLLUGRAPH01\GRAPHISOFT2012], 'SELECT * FROM Graphiplus.dbo.V_GESTION_HOJAS_RUTA"
		sql = sql & " WHERE HOJA_DE_RUTA=" & hoja_ruta_seleccionada & "')) B"
		sql = sql & " ON A.HOJA_DE_RUTA=B.HOJA_DE_RUTA COLLATE Modern_Spanish_CS_AS"
	
		query_options = adCmdText + adExecuteNoRecords
		execute_sql_with_options conn_gag, sql, query_options
		'conn_gag.Execute sql,,adCmdText + adExecuteNoRecords
	End If
	
	
	' Empty assignments
	campo_presupuestista				= ""
	campo_hoja_ruta						= ""
	campo_presupuesto					= ""
	campo_fecha_emision					= ""
	campo_producto						= ""
	campo_cliente_nombre				= ""
	campo_cliente_direccion				= ""
	campo_cliente_poblacion				= ""
	campo_cliente_cp					= ""
	campo_cliente_pais					= ""
	campo_cliente_telefono				= ""
	campo_referencia					= ""
	campo_cantidad						= ""
	campo_subcontratista				= ""
	campo_fecha_recepcion				= ""
	campo_presupuesto_subcontratista	= ""
	campo_observaciones					= ""
	campo_comentarios					= ""
	campo_fecha_entrega					= ""
	campo_estado						= ""
	campo_id_estado						= ""
	campo_observaciones_local			= ""
	campo_id_hoja_ruta					= ""
	' /Empty assignments

	' GetHojaRuta
	sql ="SELECT"
	sql = sql & " A.PRESUPUESTISTA"
	sql = sql & ", RTRIM(LTRIM(A.HOJA_DE_RUTA)) HOJA_DE_RUTA"
	sql = sql & ", A.PRESUPUESTO"
	sql = sql & ", A.FECHA_EMISION"
	sql = sql & ", A.PRODUCTO"
	sql = sql & ", B.NOMBRE AS CLIENTE_NOMBRE"
	sql = sql & ", B.DIRECCION AS CLIENTE_DIRECCION"
	sql = sql & ", B.POBLACION AS CLIENTE_POBLACION"
	sql = sql & ", B.CP AS CLIENTE_CP"
	sql = sql & ", B.PAIS AS CLIENTE_PAIS"
	sql = sql & ", B.TELEFONO AS CLIENTE_TELEFONO"
	sql = sql & ", REPLACE(A.REFERENCIA, '""', '\""') REFERENCIA"
	sql = sql & ", A.CANTIDAD"
	sql = sql & ", A.SUBCONTRATISTA"
	sql = sql & ", A.FECHA_RECEPCION"
	sql = sql & ", A.PRESUPUESTO_SUBCONTRATISTA"
	sql = sql & ", A.OBSERVACIONES_GRAPHISOFT"
	sql = sql & ", A.COMENTARIOS"
	sql = sql & ", A.FECHA_ENTREGA"
	sql = sql & ", A.ESTADO"
	sql = sql & ", A.ID_ESTADO"
	sql = sql & ", A.OBSERVACIONES_GESTION OBSERVACIONES_LOCAL"
	sql = sql & ", A.ID ID_HOJA_RUTA"
	sql = sql & " FROM GESTION_GRAPHISOFT_HOJAS_IMPORTADAS A"	
	sql = sql & " LEFT JOIN GESTION_GRAPHISOFT_CLIENTES B"	
	sql = sql & " ON A.ID_CLIENTE=B.ID"
	sql = sql & " WHERE HOJA_DE_RUTA=" & hoja_ruta_seleccionada

	Set hoja_ruta = execute_sql(conn_gag, sql)
	If Not hoja_ruta.EOF Then
		campo_presupuestista				= "" & hoja_ruta("presupuestista")
		campo_hoja_ruta						= "" & hoja_ruta("hoja_de_ruta")
		campo_presupuesto					= "" & hoja_ruta("presupuesto")
		campo_fecha_emision					= "" & hoja_ruta("fecha_emision")
		campo_producto						= "" & hoja_ruta("producto")
		campo_cliente_nombre				= "" & hoja_ruta("cliente_nombre")
		campo_cliente_direccion				= "" & hoja_ruta("cliente_direccion")
		campo_cliente_poblacion				= "" & hoja_ruta("cliente_poblacion")
		campo_cliente_cp					= "" & hoja_ruta("cliente_cp")
		campo_cliente_pais					= "" & hoja_ruta("cliente_pais")
		campo_cliente_telefono				= "" & hoja_ruta("cliente_telefono")
		campo_referencia					= "" & hoja_ruta("referencia")
		campo_cantidad						= "" & hoja_ruta("cantidad")
		campo_subcontratista				= "" & hoja_ruta("subcontratista")
		campo_fecha_recepcion				= "" & hoja_ruta("fecha_recepcion")
		campo_presupuesto_subcontratista 	= "" & hoja_ruta("presupuesto_subcontratista")
		campo_observaciones					= "" & hoja_ruta("observaciones_graphisoft")
		campo_comentarios					= "" & hoja_ruta("comentarios")
		campo_fecha_entrega					= "" & hoja_ruta("fecha_entrega")
		campo_estado						= "" & hoja_ruta("estado")
		campo_id_estado						= "" & hoja_ruta("id_estado")
		campo_observaciones_local			= "" & hoja_ruta("observaciones_local")
		campo_id_hoja_ruta					= "" & hoja_ruta("ID_HOJA_RUTA")
	End If

	close_connection(hoja_ruta)
	' /GetHojaRuta
%>

<html lang="es">
<head>
	<!--<meta charset="utf-8">-->
	<title>Hoja de Ruta</title>
</head>
<body>
<div class="container-fluid">
	<form action="Guardar_Hoja_Ruta.asp" method="post" id="frmdatos_hoja_ruta" name="frmdatos_hoja_ruta">
		<input type="hidden" name="ocultoid_hoja_ruta" id="ocultoid_hoja_ruta" value="<%=campo_id_hoja_ruta%>" />

	<!--datos pir - indiana -->
	<div class="panel-group" id="datos_hoja_ruta">
		
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title">
					  	Datos de La Hoja de Ruta
				</h3>
				<span class="pull-right clickable">
					<i class="glyphicon glyphicon-chevron-up"
						data-toggle="popover" 
						data-placement="left" 
						data-trigger="hover"
						data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de la hoja de ruta"
					></i>
				</span>
				
			</div>
			
			<div id="desplegable_datos_hoja_ruta" class="panel-body">
				
					<div class="row">
						<div class="col-sm-12 col-md-12 col-lg-12">
                          <div class="form-group row">
                            <div class="col-sm-4 col-md-4 col-lg-4">
								<label for="txtestado_d" class="control-label">ESTADO</label>
								<select id="cmbestados_d" name="cmbestados_d" data-width="100%" class="cmb_bt">
									<option value="">&nbsp;</option>
									<%if not vacio_estados then
										for i=0 to UBound(tabla_estados,2)
											if tabla_estados(campo_id_estados,i)<>12 then%>
												<option value="<%=tabla_estados(campo_id_estados,i)%>"><%=tabla_estados(campo_descripcion_estados,i)%></option>
											  <%else%>
											  	<option value="<%=tabla_estados(campo_id_estados,i)%>" disabled><%=tabla_estados(campo_descripcion_estados,i)%></option>
											<%end if%>
										<%next%>
									<%end if%>
								</select>
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtestado_d" class="control-label">&nbsp;</label>
								<div class="clearfix"></div>
								<button type="button" class="btn btn-primary" id="cmdguardar_hoja_ruta" name="cmdguardar_hoja_ruta">
								  <span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Guardar Hoja de Ruta
								</button>
							</div>
                          </div>
						</div>
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">
                          <div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txthoja_ruta_d" class="control-label">HOJA DE RUTA</label>
    	                        <input type="text" class="form-control" id="txthoja_ruta_d" name="txthoja_ruta_d" value="<%=campo_hoja_ruta%>" disabled/>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtpresupuesto_d" class="control-label">PRESUPUESTO</label>
								<input type="text" id="txtpresupuesto_d" class="form-control" required="" name="txtpresupuesto_d" value="<%=campo_presupuesto%>"  disabled/> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_emision_d" class="control-label"
									data-toggle="popover" 
									data-placement="top" 
									data-trigger="hover"
									data-content="Fecha de Emisi&oacute;n"
									>F. EMISI&Oacute;N</label>
								<input type="text" id="txtfecha_emision_d" class="form-control" required="" name="txtfecha_emision_d" value="<%=campo_fecha_emision%>" disabled /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_recepcion_d" class="control-label"
									data-toggle="popover" 
									data-placement="top" 
									data-trigger="hover"
									data-content="Fecha Recepci&oacute;n"
									>F. RECEPCI&Oacute;N</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtfecha_recepcion_d" name="txtfecha_recepcion_d" value="<%=campo_fecha_recepcion%>" disabled />
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_entrega_d" class="control-label">FECHA DE ENV&Iacute;O</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtfecha_entrega_d" name="txtfecha_entrega" value="<%=campo_fecha_entrega%>" disabled />
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtproducto_d" class="control-label">PRODUCTO</label>
								<input type="text" id="txtproducto_d" class="form-control" required="" name="txtproducto_d" value="<%=campo_producto%>"  disabled /> 
							</div>
                          </div>
						</div>
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">  
							<div class="col-sm-6 col-md-6 col-lg-6">
								<label for="txtcliente_nombre_d" class="control-label" style="width:100%">CLIENTE</label>
								<input type="text" id="txtcliente_nombre_d" class="form-control" required="" name="txtcliente_nombre_d" value="<%=campo_cliente_nombre%>" disabled /> 
							</div>
							<div class="col-sm-6 col-md-6 col-lg-6">
								<label for="txtcliente_direccion_d" class="control-label">DIRECCI&Oacute;N</label>
								<input type="text" id="txtcliente_direccion_d" class="form-control" required="" name="txtcliente_direccion_d" value="<%=campo_cliente_direccion%>" disabled /> 
							</div>
                          </div>
						</div>						  
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-4 col-md-4 col-lg-4">
								<label for="txtcliente_poblacion_d" class="control-label">POBLACI&Oacute;N</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcliente_poblacion_d" name="txtcliente_poblacion_d" value="<%=campo_cliente_poblacion%>"  disabled/>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtcliente_cp_d" class="control-label">C.P.</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcliente_cp_d" name="txtcliente_cp_d" value="<%=campo_cliente_cp%>"  disabled/>
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtcliente_pais_d" class="control-label">PA&Iacute;S</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcliente_pais_d" name="txtcliente_pais_d" value="<%=campo_cliente_pais%>"  disabled/>
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtcliente_telefono_d" class="control-label">TEL&Eacute;FONO</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcliente_telefono_d" name="txtcliente_telefono_d" value="<%=campo_cliente_telefono%>"  disabled/>
							</div>
                          </div>
						</div>						  
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-12 col-md-12 col-lg-12">
								<label for="txtreferencia_d" class="control-label">REFERENCIA</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtreferencia_d" name="txtreferencia_d" value="<%=campo_referencia%>"  disabled/>
							</div>
                          </div>
						</div>						  
			
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtcantidad_d" class="control-label">CANTIDAD</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcantidad_d" name="txtcantidad_d" value="<%=campo_cantidad%>"  disabled/>
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtsubcontratista_d" class="control-label">SUBCONTRATISTA</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtsubcontratista_d" name="txtsubcontratista_d" value="<%=campo_subcontratista%>"  disabled/>
							</div>
							
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtpresupuesto_subcontratista_d" class="control-label"
									data-toggle="popover" 
									data-placement="top" 
									data-trigger="hover"
									data-content="Presupuesto Subcontratista"
									>PREP. SUBC.</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtpresupuesto_subcontratista_d" name="txtpresupuesto_subcontratista_d" value="<%=campo_presupuesto_subcontratista%>"  disabled/>
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtpresupuestista_d" class="control-label">PRESUPUESTISTA</label>
								<input type="text" id="txtpresupuestista_d" class="form-control" required="" name="txtpresupuestista_d" value="<%=campo_presupuestista%>"  disabled/> 
							</div>
							
                          </div>
						</div>						  
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-12 col-md-12 col-lg-12">
								<label for="txtobservaciones_d" class="control-label">OBSERVACIONES</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtobservaciones_d" name="txtobservaciones_d" value="<%=campo_observaciones%>"  disabled/>
							</div>
                          </div>
						</div>						  
			
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-12 col-md-12 col-lg-12">
								<label for="txtcomentarios_d" class="control-label">COMENTARIOS</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcomentarios_d" name="txtcomentarios_d" value="<%=campo_comentarios%>"  disabled/>
							</div>
                          </div>
						</div>						  

						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-12 col-md-12 col-lg-12">
								<label for="txtobservaciones_local_d" class="control-label">OBSERVACIONES LOCAL</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtobservaciones_local_d" name="txtobservaciones_local_d" value="<%=campo_observaciones_local%>" />
							</div>
                          </div>
						</div>						  
		  </div>
			<!-- panel Body-->
		</div>
		<!-- PANEL-->
	</div> 
	<!-- FIN datos hoja de ruta -->
	<!--botones-->
	<!--fin botones-->				
<!-- historico-->
			
		<div class="panel panel-primary" id="datos_hoja_ruta_historico_actividad">
			<div class="panel-heading">
				<h3 class="panel-title">HIST&Oacute;RICO HOJA DE RUTA</h3>
				<span class="pull-right clickable">
					<i class="glyphicon glyphicon-chevron-down"
						data-toggle="popover" 
						data-placement="left" 
						data-trigger="hover"
						data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de la hoja de ruta"
					></i>
				</span>
			</div>
			<div id="desplegable_datos_hoja_ruta_historico_actividad" class="panel-body">
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
							<table id="lista_historico_hoja_ruta" name="lista_historico_hoja_ruta" class="table table-bordered" cellspacing="0" width="100%">
								<thead>
									<tr>
										<th class="col-xs-1">Fecha</th>
										<th class="col-xs-1">Hora</th>
										<th class="col-xs-1">Acci&oacute;n</th>
										<th class="col-xs-1">Campo</th>
										<th class="col-xs-2">Valor Antiguo</th>
										<th class="col-xs-2">Valor Nuevo</th>
										<th class="col-xs-1">
										<i class="glyphicon glyphicon-user"
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
			<!--fin datos hoja ruta historico actividad-->					
	</form>
</div><!--CONTAINER-->

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

<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script>  
  
<script language="javascript">
var j$ = jQuery.noConflict();

j$(document).on('click', '.panel-heading span.clickable', function (e) {
    var j$this = j$(this);
    if (!j$this.hasClass('panel-collapsed')) {
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

j$(document).ready(function () {
    var prm = new ajaxPrm();

    //refresco la tabla anterior por si hay modificaciones
    //window.parent.lst_pirs.ajax.reload(); 

    //para que se reconfigure el combo como del tipo selectpicker
    j$('.cmb_bt').selectpicker()
    //para que se configuren los popover-titles...
    j$('[data-toggle="popover"]').popover({ html: true, container: 'body' });
    j$("#cmbestados_d").val('<%=campo_id_estado%>');
    j$(".cmb_bt").selectpicker('refresh')

    prm.add("p_id_hoja_ruta", j$('#ocultoid_hoja_ruta').val());

    j$.fn.dataTable.moment("DD/MM/YYYY");

    if (typeof lst_historico_hoja_ruta == "undefined") {
        lst_historico_hoja_ruta = j$("#lista_historico_hoja_ruta").DataTable({
            dom: '<"toolbar">Blfrtip',
            ajax: {
                url: "tojson/obtener_historico_hoja_ruta.asp?" + prm.toString(),
                type: "POST",
                dataSrc: "ROWSET"
            },
            order: [],
            columnDefs: [
                { className: "dt-center", targets: [7] }
            ],
            /*
            columnDefs: [
                     {className: "dt-right", targets: [2,3]},
                     {className: "dt-center", targets: [4]}                                                            
                   ],
           */
            responsive: true,
            columns: [
                { data: "FECHA" },
                { data: "HORA" },
                { data: "ACCION" },
                { data: "CAMPO" },
                { data: "VALOR_ANTIGUO" },
                { data: "VALOR_NUEVO" },
                {
                    data: function (row, type, val, meta) {
                        //return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                             
                        if (row.NOMBRE_USUARIO == '') {
                            cadena = row.USUARIO;
                        }
                        else {
                            cadena_usuario = row.NOMBRE_USUARIO + ' (' + row.USUARIO + ')'
                            cadena = '<i class="fa fa-user-o" aria-hidden="true" style="cursor:pointer"' +
                                'data-toggle="popover_datatable"' +
                                'data-placement="top"' +
                                'data-trigger="hover"' +
                                'data-content="<span style=\'color:blue;\'><i class=\'fa fa-user-o fa-lg\'></i>&nbsp;' + cadena_usuario + '"></i></span>';
                        }
                        return cadena;
                    }
                },
                { data: "DESCRIPCION" },
                { data: "ID", visible: false },
                { data: "ID_HOJA_RUTA", visible: false },
                { data: "HOJA_RUTA", visible: false },
                { data: "ESTADO", visible: false },
                { data: "NOMBRE_USUARIO", visible: false }
            ],
            deferRender: true,
            //  Scroller
            scrollY: calcDataTableHeight() - 70,
            scrollCollapse: true,
            buttons: [
                {
                    extend: "copy", text: '<i class="fa fa-files-o"></i>', titleAttr: "Copiar en Portapapeles",
                    exportOptions: {
                        columns: [0, 1, 2, 3, 4, 5, 12, 7],
                        format: {
                            header: function (data, columnIdx) {
                                if (columnIdx == 12) {
                                    return 'Usuario';
                                }
                                else {
                                    return data;
                                }
                            }
                        }
                    }
                },
                {
                    extend: "excel",
                    text: '<i class="fa fa-file-excel-o"></i>',
                    titleAttr: "Exportar a Formato Excel",
                    title: "Historico Hoja Ruta <%=campo_hoja_ruta%>",
                    extension: ".xls",
                    exportOptions: {
                        columns: [0, 1, 2, 3, 4, 5, 12, 7],
                        format: {
                            header: function (data, columnIdx) {
                                if (columnIdx == 12) {
                                    return 'Usuario';
                                }
                                else {
                                    return data;
                                }
                            }
                        }
                    }
                },
                {
                    extend: "pdf", text: '<i class="fa fa-file-pdf-o"></i>', titleAttr: "Exportar a Formato PDF", title: "Historico Hoja Ruta <%=campo_hoja_ruta%>", orientation: "landscape",
                    exportOptions: {
                        columns: [0, 1, 2, 3, 4, 5, 12, 7],
                        format: {
                            header: function (data, columnIdx) {
                                if (columnIdx == 12) {
                                    return 'Usuario';
                                }
                                else {
                                    return data;
                                }
                            }
                        }

                    }
                },
                {
                    extend: "print", text: "<i class='fa fa-print'></i>", titleAttr: "Vista Preliminar", title: "Historico Hoja Ruta <%=campo_hoja_ruta%>",
                    exportOptions: {
                        columns: [0, 1, 2, 3, 4, 5, 12, 7],
                        format: {
                            header: function (data, columnIdx) {
                                if (columnIdx == 12) {
                                    return 'Usuario';
                                }
                                else {
                                    return data;
                                }
                            }
                        }

                    }
                }
            ],
            rowCallback: function (row, data, index) {
                //stf.row_sel = data;   
                //console.log(data);
                if (data.ACCION == "INCIDENCIA") {
                    //j$( row ).css( "background-color", "Orange" );
                    //j$( row ).addClass( "warning" );
                    j$(row).addClass("danger");
                }
            },
            drawCallback: function () {
                //para que se configuren los popover-titles...
                j$('[data-toggle="popover_datatable"]').popover({ html: true, container: 'body' });
                //j$('[data-toggle="popover_datatable"]').next('.popover').addClass('popover_usuario');
            },
            //initComplete: stf.initComplete,                                                            
            language: { url: "plugins/dataTable/lang/Spanish.json" },
            paging: false,
            processing: true,
            searching: true
        });

        //controlamos el click, para seleccionar o desseleccionar la fila
        j$("#lista_historico_hoja_ruta tbody").on("click", "tr", function () {
            if (!j$(this).hasClass("selected")) {
                lst_historico_hoja_ruta.$("tr.selected").removeClass("selected");
                j$(this).addClass("selected");
                //var table = j$('#lista_pirs').DataTable();
                //row_sel = table.row( this ).data();
            }
            //console.log(row_sel);
        });
    }
    else {
        //stf.lst_tra.clear().draw();
        lst_historico_hoja_ruta.ajax.url("tojson/obtener_historico_hoja_ruta.asp?" + prm.toString());
        lst_historico_hoja_ruta.ajax.reload();
    }
});

calcDataTableHeight = function () {
    return j$(window).height() * 55 / 100;
};

j$('#cmdguardar_hoja_ruta').on('click', function () {
    hay_error = '';

    if (hay_error != '') {
        j$("#cabecera_pantalla_avisos").html("<h3>Errores Detectados</h3>")
        j$("#body_avisos").html('<H4><br>' + hay_error + '<br></h4>');
        j$("#pantalla_avisos").modal("show");
    }
    else {
        j$("#frmdatos_hoja_ruta").submit()
    }
});

</script>
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<!-- <link rel="stylesheet" type="text/css" href="../plugins/bootstrap-4.0.0/css/bootstrap.min.css"> -->
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/media/css/dataTables.bootstrap.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/extensions/Buttons/css/buttons.dataTables.min.css">
	<!-- <script type="text/javascript" src="plugins/fontawesome-5.7.1/js/all.js" defer></script> -->
	<link rel="stylesheet" type="text/css" href="plugins/font-awesome_4_7_0/css/font-awesome.min.css">

	<link rel="stylesheet" type="text/css" href="css/Detalle_Hoja_Ruta.css">
</body>
<%
	close_connection(conn_gag)
%>
</html>