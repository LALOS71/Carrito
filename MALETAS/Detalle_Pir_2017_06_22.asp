<%@ language=vbscript%>
<!--#include file="Conexion.inc"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%

pir_seleccionado=Request.QueryString("pir")
set detalle_pir=Server.CreateObject("ADODB.Recordset")
	with detalle_pir
		.ActiveConnection=connmaletas
		.Source="SELECT * "
		.Source= .Source & " FROM PIRS"
		.Source= .Source & " WHERE PIR='" & pir_seleccionado & "'"
		.Open
	end with


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


	 <!-- Acordion -->
	<div class="panel-group" id="acordeon_indiana">
		
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title">Datos Pir - Procedentes de Indiana</h3>
				<span class="pull-right clickable panel-collapsed">
					<i class="glyphicon glyphicon-chevron-down"
						data-toggle="popover" 
						data-placement="left" 
						data-trigger="hover"
						data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
					></i>
				</span>
				
			</div>
			
			<div id="desplegable_indiana" class="panel-body collapse">
				<form action="" method="post" novalidate="novalidate">
					<div class="row">
						<div class="col-sm-12 col-md-12 col-lg-12">
                          <div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtpir_d" class="control-label">PIR</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtpir_d" name="txtpir_d" value="" />
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_pir_d" class="control-label">Fecha PIR</label><span id="fecmask_d" style="display:none"> (dd/mm/aaaa)</span>
								<input type="date" id="txtfecha_pir_d" class="form-control" required="" name="txtfecha_pir_d" value="" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_orden_d" class="control-label">Fecha Orden</label><span id="fecmask_d" style="display:none"> (dd/mm/aaaa)</span>
								<input type="date" id="txtfecha_orden_d" class="form-control" required="" name="txtfecha_orden_d" value="" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txttag_d" class="control-label">TAG</label>
								<input type="text" id="txttag_d" class="form-control" required="" name="txttag_d" value="" /> 
							</div>
                          </div>
						</div>
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtnombre_d" class="control-label">Nombre</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtnombre_d" name="txtnombre_d" value="" />
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtapellidos_d" class="control-label">Apellidos</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtapellidos_d" name="txtapellidos_d" value="" />
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtmovil_d" class="control-label">Movil</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtmovil_d" name="txtmovil_d" value="" />
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfijo_d" class="control-label">Fijo</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtfijo_d" name="txtfijo_d" value="" />
							</div>
                          </div>
						</div>						  
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-10 col-md-10 col-lg-10">
								<label for="txtdireccion_entrega_d" class="control-label">Direcci&oacute;n Entrega</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtdireccion_entrega_d" name="txtdireccion_entrega_d" value="" />
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtcp_d" class="control-label">C. P.</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcp_d" name="txtcp_d" value="" />
							</div>
                          </div>
						</div>						  
			
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="cmbtipo_direccion_d" class="control-label">Tipo Direcci&oacute;n</label>
								<div class="clearfix visible-md-block"></div>
								<select id="cmbtipo_direccion_d" name="cmbtipo_direccion_d" data-width="100%" class="cmb_bt">
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
								  <option value="HASTA">Hastal</option>
								</select>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_desde_hasta_d" class="control-label">Fecha Desde/Hasta</label>
								<input type="date" id="txtfecha_desde_hasta_d" class="form-control" required="" name="txtfecha_desde_hasta_d" value="" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txttipo_equipaje_d" class="control-label">Tipo Equipaje</label>
								<input type="text" id="txttipo_equipaje_d" class="form-control" required="" name="txttipo_equipaje_d" value="" /> 
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtmarca_d" class="control-label">Marca</label>
								<input type="text" id="txtmarca_d" class="form-control" required="" name="txtmarca_d" value="" /> 
							</div>
                          </div>
						</div>						  
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtmaterial_d" class="control-label">Material</label>
								<input type="text" id="txtmaterial_d" class="form-control" required="" name="txtmaterial_d" value="" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtcolor_d" class="control-label">Color</label>
								<input type="text" id="txtcolor_d" class="form-control" required="" name="txtcolor_d" value="" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtlargo_d" class="control-label">Largo</label>
								<input type="text" id="txtlargo_d" class="form-control" required="" name="txtlargo_d" value="" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtalto_d" class="control-label">Alto</label>
								<input type="text" id="txtalto_d" class="form-control" required="" name="txtalto_d" value="" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtancho_d" class="control-label">Ancho</label>
								<input type="text" id="txtancho_d" class="form-control" required="" name="txtancho_d" value="" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_ruedas_d" class="control-label">Daño Ruedas</label>
								<input type="checkbox" id="chkdanno_ruedas_d" name="chkdanno_ruedas_d" class="form-control chk_bt" >
							</div>
							
                          </div>
						</div>						  

						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_asas_d" class="control-label" style="width:100%">Daño Asas</label>
								<input type="checkbox" id="chkdanno_asas_d" name="chkdanno_asas_d"   class="form-control chk_bt" width="100%" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cierres_d" class="control-label" style="width:100%">Daño Cierres</label>
								<input type="checkbox" id="chkdanno_cierres_d" name="chkdanno_cierres_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cremalleras_d" class="control-label" style="width:100%">Daño Cremalleras</label>
								<input type="checkbox" id="chkdanno_cremalleras_d" name="chkdanno_cremalleras_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cuerpo_maleta_d" class="control-label" style="width:100%">Daño Cuerpo Maleta</label>
								<input type="checkbox" id="chkdanno_cuerpo_maleta_d" name="chkdanno_cuerpo_maleta_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_cierres_maleta_d" class="control-label"  style="width:100%">Daño Cierres Maleta</label>
								<input type="checkbox" id="chkdanno_cierres_maleta_d" name="chkdanno_cierres_maleta_d"   class="form-control chk_bt" >
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="chkdanno_otros_dannos_d" class="control-label" style="width:100%">Otros Daños</label>
								<input type="checkbox" id="chkdanno_otros_dannos_d" name="chkdanno_otros_dannos_d"  class="form-control chk_bt" >
							</div>
                          </div>
						</div>						  
  
  						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtruta_d" class="control-label" style="width:100%">Ruta</label>
								<input type="text" id="txtruta_d" class="form-control" required="" name="txtruta_d" value="" /> 
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtvuelos_d" class="control-label">Vuelos</label>
								<input type="text" id="txtvuelos_d" class="form-control" required="" name="txtvuelos_d" value="" /> 
							</div>
							
							
                          </div>
						</div>						  
				</form>
		  </div>
			<!-- panel Body-->
		</div>
		<!-- PANEL-->
	</div> <!-- Acordion -->
	
	
	<div class="panel panel-primary">
		<div class="panel-heading">
			<h3 class="panel-title">Datos PIR - PPC</h3>
			<span class="pull-right clickable panel-collapsed">
				<i class="glyphicon glyphicon-chevron-down"
					data-toggle="popover" 
					data-placement="left" 
					data-trigger="hover"
					data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
				></i>
			</span>
			
		</div>
		
		<div id="desplegable_datos_pir_ppc" class="panel-body collapse">
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
								<input type="date" id="txtfecha_inicio_d" class="form-control" required="" name="txtfecha_inicio_d" value="" /> 
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtimporte_facturacion_d" class="control-label">Importe Facturaci&oacute;n</label>
								<input type="text" id="txtimporte_facturacion_d" class="form-control" required="" name="txtvuelos_d" value="" /> 
							</div>
				</div>
			</div>
		</div>
	</div><!--fin datos ppc-->				
		
	<div class="panel panel-primary">
		<div class="panel-heading">
			<h3 class="panel-title">Otras Incidencias</h3>
			<span class="pull-right clickable panel-collapsed">
				<i class="glyphicon glyphicon-chevron-down"
					data-toggle="popover" 
					data-placement="left" 
					data-trigger="hover"
					data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
				></i>
			</span>
			
		</div>
		
		<div id="desplegable_incidencia_otras" class="panel-body collapse">
			<div class="form-group">
				<div class="col-sm-12 col-md-12 col-lg-12">
						  <textarea class="form-control" rows="5" id="txtotras_incidencias_p"></textarea> 
				</div>
			</div>
		
		</div>
	</div><!--fin otras incidencias-->				
	
		
		

	

	<div class="panel panel-primary">
		<div class="panel-heading">
			<h3 class="panel-title">Datos Pir - Proveedor</h3>
			<span class="pull-right clickable panel-collapsed">
				<i class="glyphicon glyphicon-chevron-down"
					data-toggle="popover" 
					data-placement="left" 
					data-trigger="hover"
					data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
				></i>
			</span>
			
		</div>
		
		<div id="desplegable_datos_pir_proveedor" class="panel-body collapse">
			
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-12">
					  <div class="form-group row">
					  	<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_envio_d" class="control-label">Fecha Envio</label>
								<input type="date" id="txtfecha_envio_d" class="form-control" required="" name="txtfecha_envio_d" value="" /> 
							</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="txtfecha_entrega_pax_d" class="control-label">Fecha Entrega Pax</label>
							<input type="date" id="txtfecha_entrega_pax_d" class="form-control" required="" name="txtfecha_entrega_pax_d" value="" /> 
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
							<input type="text" id="txttamanno_maleta_entregada_d" class="form-control" required="" name="txttamanno_maleta_entregada_d" value="" /> 
						</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="txtreferencia_malenta_entregada_d" class="control-label">Referencia</label>
							<input type="text" id="txtreferencia_maleta_entregada_d" class="form-control" required="" name="txtreferencia_maleta_entregada_d" value="" /> 
						</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
							<label for="txtcolor_malenta_entregada_d" class="control-label">Color</label>
							<input type="text" id="txtcolor_maleta_entregada_d" class="form-control" required="" name="txtcolor_maleta_entregada_d" value="" /> 
						</div>
						
					  </div>
					</div>
				</div>						  
				
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-12">
					  <div class="form-group row">
				  		<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtnumero_expedicion_d" class="control-label">N&uacute;m Expecici&oacute;n</label>
								<input type="text" id="txtnumero_expedicion_d" class="form-control" required="" name="txtnumero_expedicion_d" value="" /> 
						</div>
						<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtimporte_coste_d" class="control-label">Importe Coste</label>
								<input type="text" id="txtimporte_coste_d" class="form-control" required="" name="txtimporte_coste_d" value="" /> 
						</div>
					  </div>
					</div>
				</div>						  
	  </div>
		<!-- panel Body-->
	</div>
	<!-- PANEL-->


		<div class="panel panel-primary">
		<div class="panel-heading">
			<h3 class="panel-title">Incidencia Transporte</h3>
			<span class="pull-right clickable panel-collapsed">
				<i class="glyphicon glyphicon-chevron-down"
					data-toggle="popover" 
					data-placement="left" 
					data-trigger="hover"
					data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
				></i>
			</span>
			
		</div>
		
		<div id="desplegable_incidencia_transporte" class="panel-body collapse">
			<div class="form-group">
				<div class="col-sm-12 col-md-12 col-lg-12">
						  <textarea class="form-control" rows="5" id="txtincidencia_transporte_p"></textarea> 
				</div>
			</div>
		</div>
	</div><!--fin incidencia transporte-->				

	<div class="panel panel-primary">
		<div class="panel-heading">
			<h3 class="panel-title">Incidencia Maleta</h3>
			<span class="pull-right clickable panel-collapsed">
				<i class="glyphicon glyphicon-chevron-down"
					data-toggle="popover" 
					data-placement="left" 
					data-trigger="hover"
					data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
				></i>
			</span>
			
		</div>
		
		<div id="desplegable_incidencia_maleta" class="panel-body collapse">
			<div class="form-group">
				<div class="col-sm-12 col-md-12 col-lg-12">
						  <textarea class="form-control" rows="5" id="txtincidencia_manleta_p"></textarea> 
				</div>
			</div>
		
		</div>
	</div><!--fin incidencia maleta-->				
	

</DIV><!--CONTAINER-->



<!-- capa detalle PIR -->
  <div class="modal fade" id="capa_detalle_pir">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="gmv.cabecera_iframe"></h4>	    
        </div>	    
        <div class="modal-body">
          <form class="form-horizontal row-border">
            <div class="form-group">
              <!--
              <iframe id='gmv.iframe_movilidad' src="" width="100%" height="0" frameborder="0" transparency="transparency" onload="gmv.redimensionar_iframe(this);"></iframe>
              -->
              
              <iframe id='iframe_detalle_pir' src="" width="100%" height="650px" frameborder="0" transparency="transparency"></iframe> 	
             </div>                  
          </form>
        </div> <!-- del modal-body-->     
        
        <!--
        <div class="modal-footer">                  
          <p>                    
            <button type="button" onclick="alert('en construccion')" class="btn btn-primary" id="gmv.add_usr_btn">Aceptar</button>		    
            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>                  
          </p>                
        </div>
        -->  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa detalle PIR -->    
  








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

});





calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  };  


/*
redimensionar = function() { 
	console.log('vamos a redimensionar')
	console.log('desplegable .height(): ' + j$("#desplegable").height())
	console.log('desplegable .innerHeight(): ' + j$("#desplegable").innerHeight())
	console.log('desplegable .outerHeight(): ' + j$("#desplegable").outerHeight())
	console.log('desplegable .outerHeight(true): ' + j$("#desplegable").outerHeight(true))
};
*/

mostrar_detalle_pir = function(pagina, parametro){
    //alert('entro dentro de mostrar_capa_movilidad')
    //cargaSelectsNew("p_combo=EMPORG", "gmv.lov_usr_codemp", "S");  
    url_iframe=pagina + '?pir=' + parametro

    //console.log('url del iframe: ' + url_iframe)
    cadena_cabecera='Detalle Pir ' + parametro
      
    j$("#cabecera_iframe").html(cadena_cabecera);
    
    j$('#iframe_detalle_pir').attr('src', url_iframe)
    j$("#capa_detalle_pir").modal("show");
  }
  

</script>
</body>
<%
detalle_pir.close
set deetalle_pir=Nothing

connmaletas.close
set connmaletas=Nothing
%>
</html>