<%@ language=vbscript%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
	if session("usuario")="" then
		response.Redirect("Login.asp")
	end if
	

%>

<html>



<head>


	<title>Consulta Incidencias</title>
	

	
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-switch/css/bootstrap-switch.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/media/css/dataTables.bootstrap.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/extensions/Buttons/css/buttons.dataTables.min.css">
	
	
	<link rel="stylesheet" type="text/css" href="plugins/font-awesome-4.7.0/css/font-awesome.min.css">

	<style>
		body { padding-top: 70px; }
		
		
		/*#capa_detalle_tipo_maleta .modal-dialog {width:90%;}*/
		#capa_detalle_usuario {width:90%;}
		.table th { font-size: 14px; }
		.table td { font-size: 13px; }
		
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
		
		table.dataTable tbody tr { cursor:pointer}
		//------------------------------------------
		
		
		
		
 
	</style>

<style>
/*para los radiobutons animados*/

.checkbox label:after, 
.radio label:after {
    content: '';
    display: table;
    clear: both;
}

.checkbox .cr,
.radio .cr {
    position: relative;
    display: inline-block;
    border: 1px solid #a9a9a9;
    border-radius: .25em;
    width: 1.3em;
    height: 1.3em;
    float: left;
    margin-right: .5em;
}

.radio .cr {
    border-radius: 50%;
}

.checkbox .cr .cr-icon,
.radio .cr .cr-icon {
    position: absolute;
    font-size: .8em;
    line-height: 0;
    top: 50%;
    left: 20%;
}

.radio .cr .cr-icon {
    margin-left: 0.04em;
}

.checkbox label input[type="checkbox"],
.radio label input[type="radio"] {
    display: none;
}

.checkbox label input[type="checkbox"] + .cr > .cr-icon,
.radio label input[type="radio"] + .cr > .cr-icon {
    transform: scale(3) rotateZ(-20deg);
    opacity: 0;
    transition: all .3s ease-in;
}

.checkbox label input[type="checkbox"]:checked + .cr > .cr-icon,
.radio label input[type="radio"]:checked + .cr > .cr-icon {
    transform: scale(1) rotateZ(0deg);
    opacity: 1;
}

.checkbox label input[type="checkbox"]:disabled + .cr,
.radio label input[type="radio"]:disabled + .cr {
    opacity: .5;
}

</style>
	

</head>
<body>


<!--#include file="menu.asp"-->


<div class="container-fluid">


	 <!-- Acordion -->
	<div class="panel-group" id="accordion_usuarios" role="tablist" aria-multiselectable="true">
		<div class="panel panel-info">
			<div class="panel-heading" role="tab" id="heading03" data-toggle="collapse" data-target="#desplegable_usuarios" style="cursor:pointer">
				<h3 class="panel-title">

					<span
						data-toggle="popover" 
						data-placement="bottom" 
						data-trigger="hover"
						data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de mantenimiento de Usuarios"
						
						>
						Gesti&oacute;n Usuarios
					</span>
				</h3>
				
			</div>
			
			<div id="desplegable_usuarios" class=" panel-body panel-collapse collapse " role="tabpanel" aria-labelledby="heading03">
				<div width="95%">
					<table id="lista_usuarios" name="lista_usuarios" class="table table-striped table-bordered" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th>Nombre</th>
								<th>Perfil</th>
								<th>Proveedor</th>
								<th>Tipo Usuario</th>
								<th>Usuario</th>
								<th>Borrado</th>
								<th>
										<div class="btn_add_usuarios" style="text-align:center">
											<i class="fa fa-plus fa-2x" aria-hidden="true"
												style="color: green;cursor: pointer;" 
												data-toggle="popover_datatable" 
												data-placement="right" 
												data-trigger="hover" 
												data-content="Añadir un Usuario"
												></i>
										</div>
								</th>
							</tr>
						</thead>
					</table>
				</div>
		  	</div>
			<!-- panel Body-->
		</div>
		<!-- PANEL-->
	</div> <!-- Acordion -->



	 <!-- Acordion -->
	<div class="panel-group" id="accordion_proveedores" role="tablist" aria-multiselectable="true">
		<div class="panel panel-info">
			<div class="panel-heading" role="tab" id="heading01" data-toggle="collapse" data-target="#desplegable_proveedores" style="cursor:pointer">
				<h3 class="panel-title">

					<span
						data-toggle="popover" 
						data-placement="bottom" 
						data-trigger="hover"
						data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de mantenimiento de Proveedores"
						
						>
						Gesti&oacute;n Proveedores
					</span>
				</h3>
				
			</div>
			
			<div id="desplegable_proveedores" class=" panel-body panel-collapse collapse " role="tabpanel" aria-labelledby="heading01">
				<div width="95%">
					<table id="lista_proveedores" name="lista_proveedores" class="table table-striped table-bordered" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th>Descripción</th>
								<th>Orden</th>
								<th>Borrado</th>
								<th>Tipos Maleta</th>
								<th>
										<div class="btn_add_proveedores" style="text-align:center">
											<i class="fa fa-plus fa-2x" aria-hidden="true"
												style="color: green;cursor: pointer;" 
												data-toggle="popover_datatable" 
												data-placement="right" 
												data-trigger="hover" 
												data-content="Añadir un Proveedor"
												></i>
										</div>
								</th>
							</tr>
						</thead>
					</table>
				</div>
		  	</div>
			<!-- panel Body-->
		</div>
		<!-- PANEL-->
	</div> <!-- Acordion -->


<div class="panel-group" id="accordion_tipos_maleta" role="tablist" aria-multiselectable="true">
		<div class="panel panel-info">
			<div class="panel-heading" role="tab" id="heading02" data-toggle="collapse" data-target="#desplegable_tipos_maleta" style="cursor:pointer">
				<h3 class="panel-title">

					<span
						data-toggle="popover" 
						data-placement="bottom" 
						data-trigger="hover"
						data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de mantenimiento de Tipos de Maleta"
						
						>
						Gesti&oacute;n Tipos de Maleta
					</span>
				</h3>
				
			</div>
			
			<div id="desplegable_tipos_maleta" class=" panel-body panel-collapse collapse " role="tabpanel" aria-labelledby="heading02">
				<div width="95%">
					<table id="lista_tipos_maleta" name="lista_tipos_maleta" class="table table-striped table-bordered" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th>Código</th>
								<th>Descripción</th>
								<th>Orden</th>
								<th>Borrado</th>
								<th>
										<div class="btn_add_tipos_maleta" style="text-align:center">
											<i class="fa fa-plus fa-2x" aria-hidden="true"
												style="color: green;cursor: pointer;" 
												data-toggle="popover_datatable" 
												data-placement="right" 
												data-trigger="hover" 
												data-content="Añadir un Tipo de Maleta"
												></i>
										</div>
								</th>
							</tr>
						</thead>
					</table>
				</div>
		  	</div>
			<!-- panel Body-->
		</div>
		<!-- PANEL-->
	</div> <!-- Acordion -->







</DIV><!--CONTAINER-->

<!-- capa detalle usuarios -->
  <div class="modal fade" id="capa_detalle_usuario">	
    <div class="modal-dialog center-block">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title">Datos Usuario</h4>	    
        </div>	    
        <div class="modal-body">
				<input type="hidden" id="ocultousuarios_id" name="ocultousuarios_id" value=""/>
				<div class="container-fluid">							
					<div class="row">
						<div class="col-12">
							<label for="txtusuarios_nombre" class="control-label">Nombre</label>
							<input type="text" id="txtusuarios_nombre" class="form-control" required="" name="txtusuarios_nombre" value="" /> 
						</div>
					</div>
					<div class="row"><div class="clearfix visible-md-block">&nbsp;</div></div>
					<div class="row">
						<div class="col-12">
							<div class="col-sm-12 col-md-6 col-lg-6">
								<label for="cmbusuarios_perfil" class="control-label">Perfil</label>
								<select id="cmbusuarios_perfil" name="cmbusuarios_perfil" data-width="100%" class="form-control">
								  <option value="PROVEEDOR">PROVEEDOR</option>
								  <option value="ADMINISTRADOR">ADMINISTRADOR</option>
								</select>	
							</div>						
							<div class="col-sm-12 col-md-6 col-lg-6" id="capa_proveedor" style="display:none">
								<label for="cmbusuarios_proveedor" class="control-label">Proveedor</label>
								<select id="cmbusuarios_proveedor" name="cmbusuarios_proveedor" data-width="100%" class="form-control">
								  <option value="" selected></option>
								</select>	

							</div>
						</div>
					</div>
					<div class="row"><div class="clearfix visible-md-block">&nbsp;</div></div>
					<div class="row">
						<div class="col-12">
							<div class="col-sm-12 col-md-4 col-lg-4">
								<label for="cmbusuarios_tipo_usuario" class="control-label">Tipo Usuario</label>
								<select id="cmbusuarios_tipo_usuario" name="cmbusuarios_tipo_usuario" data-width="100%" class="form-control">
								  <option value="INTERNO">INTERNO</option>
								  <option value="EXTERNO">EXTERNO</option>
								</select>	
							</div>						
							<div class="col-sm-12 col-md-4 col-lg-4">
								<label for="cmbusuarios_usuario" class="control-label">Cod. Usuario</label>
								<input type="text" id="txtusuarios_usuario" class="form-control" required="" name="txtusuarios_usuario" value="" /> 
							</div>
							<div class="col-sm-12 col-md-4 col-lg-4" id="capa_contrasenna" style="display:none">
								<label for="cmbusuarios_contrasenna" class="control-label">Contraseña</label>
								<input type="text" id="txtusuarios_contrasenna" class="form-control" required="" name="txtusuarios_contraseña" value="" /> 
							</div>
						</div>
					</div>
					<div class="row"><div class="clearfix visible-md-block">&nbsp;</div></div>
					<div class="row">
							<div class="col-sm-12 col-md-4 col-lg-4">
								<label for="cmbusuarios_borrado" class="control-label">Borrado</label>
								<select id="cmbusuarios_borrado" name="cmbusuarios_borrado" data-width="100%" class="form-control">
								  <option value="NO">NO</option>
								  <option value="SI">SI</option>
								</select>	
							</div>
					</div>
					
				</div>          
        </div> <!-- del modal-body-->     
        
        <div class="modal-footer">                  
          <p>                    
            <button type="button" class="btn btn-primary" id="cmdguardar_usuario">Guardar</button>		    
            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>                  
          </p>                
        </div>
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa detalle usuarios -->    



<!-- capa detalle PROVEEDORES -->
  <div class="modal fade" id="capa_detalle_proveedor">	
    <div class="modal-dialog center-block">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title">Datos Proveedor</h4>	    
        </div>	    
        <div class="modal-body">
				<input type="hidden" id="ocultoproveedores_id" name="ocultoproveedores_id" value=""/>
				<div class="container-fluid">							
					<div class="row">
						<div class="col-12">
							<label for="txtproveedores_descripcion" class="control-label">Descripci&oacute;n</label>
							<input type="text" id="txtproveedores_descripcion" class="form-control" required="" name="txtproveedores_descripcion" value="" /> 
						</div>
					</div>
					<div class="row"><div class="clearfix visible-md-block">&nbsp;</div></div>
					<div class="row">
						<div class="col-12">
							<label for="txtproveedores_orden" class="control-label">Orden</label>
							<input type="text" class="form-control" style="width: 100%;"  id="txtproveedores_orden" name="txtproveedores_orden" value=""/>
						</div>
					</div>
					<div class="row"><div class="clearfix visible-md-block">&nbsp;</div></div>
					<div class="row">
						<div class="col-12">
							<table class="table table-striped table-bordered">
									<thead>
										<tr>
											<th scope="col">Tipos Maleta Asignadas</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												<div id="capa_proveedores_tipos_maleta"></div> 
											</td>
										</tr>
									</tbody>
							</table>
						</div>
					</div>

					<div class="row">
							<label for="cmbproveedores_borrado" class="control-label">Borrado</label>
							<select id="cmbproveedores_borrado" name="cmbproveedores_borrado" data-width="100%" class="form-control">
							  <option value="NO">NO</option>
							  <option value="SI">SI</option>
							</select>	
					</div>
					
				</div>          
        </div> <!-- del modal-body-->     
        
        <div class="modal-footer">                  
          <p>                    
            <button type="button" class="btn btn-primary" id="cmdguardar_proveedor">Guardar</button>		    
            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>                  
          </p>                
        </div>
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa detalle PROVEEDORES -->    



<!-- capa detalle TIPOS MALETA -->
  <div class="modal fade" id="capa_detalle_tipo_maleta">	
    <div class="modal-dialog center-block">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title">Datos Tipo Maleta</h4>	    
        </div>	    
        <div class="modal-body">
				<input type="hidden" id="ocultotipos_maleta_id" name="ocultotipos_maleta_id" value=""/>
							
           		<div class="col-12">
						<div class="col-12">
							<label for="txttipos_maleta_codigo" class="control-label">C&oacute;digo</label>
							<input type="text" class="form-control" style="width: 100%;"  id="txttipos_maleta_codigo" name="txttipos_maleta_codigo" value=""/>
						</div>
						<div class="clearfix visible-md-block"></div>
						<div class="col-12">
							<label for="txttipos_maleta_descripcion" class="control-label">Descripci&oacute;n</label>
							<input type="text" id="txttipos_maleta_descripcion" class="form-control" required="" name="txttipos_maleta_descripcion" value="" /> 
						</div>
						<div class="clearfix visible-md-block"></div>
						<div class="col-12">
							<label for="txttipos_maleta_orden" class="control-label">Orden</label>
							<input type="text" class="form-control" style="width: 100%;"  id="txttipos_maleta_orden" name="txttipos_maleta_orden" value=""/>
						</div>
						<div class="clearfix visible-md-block"></div>
						<div class="col-12">
							<label for="cmbtipos_maleta_borrado" class="control-label">Borrado</label>
							<select id="cmbtipos_maleta_borrado" name="cmbtipos_maleta_borrado" data-width="100%" class="form-control">
							  <option value="NO">NO</option>
							  <option value="SI">SI</option>
							</select>	
						</div>
						<div class="clearfix visible-md-block"></div>
				</div>
							                  
        </div> <!-- del modal-body-->     
        
        <div class="modal-footer">                  
          <p>                    
            <button type="button" class="btn btn-primary" id="cmdguardar_tipo_maleta">Guardar</button>		    
            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>                  
          </p>                
        </div>
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa detalle TIPOS MALETA -->    


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
  
<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>





<script language="javascript">
var j$=jQuery.noConflict();

j$(window).resize(function() {
  });  
  

j$(document).ready(function () {
	var pathname = window.location.pathname;
	
	//console.log('url: ' + pathname)
	posicion=pathname.lastIndexOf('/')
	pathname=pathname.substring(posicion + 1,pathname.length)
	//console.log('url truncada: ' + pathname)
	
	//para que se seleccione la opcion de menu correcta
	j$('.nav > li > a[href="'+pathname+'"]').parent().addClass('active');
	
	//para que se reconfigure el combo como del tipo selectpicker
	j$('.cmb_bt').selectpicker()
	
	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true});

});


calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  };  






j$('#accordion_tipos_maleta').on('hide.bs.collapse', function (e) {  

	
});

j$('#accordion_tipos_maleta').on('shown.bs.collapse', function (e) { 
    //j$("#capa_mantenimiento_tipos_maleta").html('<iframe id="iframe_mantenimiento_tipos_maleta" src="Obtener_Tipos_Maleta.asp" width="100%" height="100%" frameborder="0" transparency="transparency" scrolling="NO" onload="redimensionar_iframe()"></iframe>');
	mostrar_tipos_maleta()			        
});

j$('#accordion_proveedores').on('shown.bs.collapse', function (e) { 
    //j$("#capa_mantenimiento_tipos_maleta").html('<iframe id="iframe_mantenimiento_tipos_maleta" src="Obtener_Tipos_Maleta.asp" width="100%" height="100%" frameborder="0" transparency="transparency" scrolling="NO" onload="redimensionar_iframe()"></iframe>');
	mostrar_proveedores()			        
});

j$('#accordion_usuarios').on('shown.bs.collapse', function (e) { 
    //j$("#capa_mantenimiento_tipos_maleta").html('<iframe id="iframe_mantenimiento_tipos_maleta" src="Obtener_Tipos_Maleta.asp" width="100%" height="100%" frameborder="0" transparency="transparency" scrolling="NO" onload="redimensionar_iframe()"></iframe>');
	mostrar_usuarios()			        
});


redimensionar_iframe = function() {
//console.log('dentro de redimensionar iframe')
 var cont = j$('#iframe_mantenimiento_tipos_maleta').contents().find("body").height() 
 j$('#iframe_mantenimiento_tipos_maleta').css('height', (cont + 55)  + "px");
 
 //console.log('tamaño iframe: ' + cont)
 
  }; 





/////////////////////////////////////////////////

mostrar_usuarios = function(perfil) {  
      var err ="";
		
		//no hay control de errores por filtros no rellenados
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
        
        j$.fn.dataTable.moment("DD/MM/YYYY");
        
        //deseleccioamos el registro de la lista
        j$('#lista_usuarios tbody tr').removeClass('selected');
        
        if (typeof lst_usuarios == "undefined") {
            lst_usuarios = j$("#lista_usuarios").DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:"tojson/obtener_usuarios.asp",
                                                           type:"POST",
                                                           dataSrc:"ROWSET"},
                                                     order:[1, 'asc', 0, 'asc'],
                                                     
													 columnDefs: [
                                                              //{className: "dt-right", targets: [2,3]},
                                                              {className: "dt-center", targets: [3,4]}                                                            
                                                            ],
													
                                                     columns:[ 
																{data:"NOMBRE"},
															  	{data:"PERFIL"},
																{data:"PROVEEDOR"},
																{data:"TIPO_USUARIO"},
																{data:"USUARIO"},
																{data:"BORRADO"},
																{data:function(row, type, val, meta) {                                                                                                                   
                                                                      	//return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                                                                  
                                                                      	cadena='<i class="fa fa-trash fa-2x btn_delete_usuario"' +
																						' aria-hidden="true"' +
																						' style="color:darkred;cursor:hand;cursor:pointer"' + 
																						' data-toggle="popover_datatable"' +
																						' data-placement="right"' +
																						' data-trigger="hover"' +
																						' data-content="Borrar El Usuario"' +
																						' onclick="borrar_usuario(' + row.ID + ')"></i>'
																		if (row.BORRADO=='NO')
																			{
																			cadena_a_mostrar=cadena
																			}
																		  else
																		  	{
																			cadena_a_mostrar=''
																			}
																		return cadena_a_mostrar
                                                                    	}
                                                               		},
																{data:"ID", visible:false},
																{data:"CONTRASENNA", visible:false}
                                                            ],
                                                     deferRender:true,
    //  Scroller
                                                     scrollY:calcDataTableHeight() - 90,
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
                                                   buttons:[{extend:"copy", text:'<i class="fa fa-files-o"></i>', titleAttr:"Copiar en Portapapeles", exportOptions:{columns:[0,1,2,3,4,5]}}, 
                                                             {extend:"excel", text:'<i class="fa fa-file-excel-o"></i>', titleAttr:"Exportar a Formato Excel", title:"Usuarios", extension:".xls", exportOptions:{columns:[0,1,2,3,4,5]}}, 
                                                             {extend:"pdf", text:'<i class="fa fa-file-pdf-o"></i>', titleAttr:"Exportar a Formato PDF", title:"Usuarios", orientation:"landscape", exportOptions:{columns:[0,1,2,3,4,5]}}, 
                                                             {extend:"print", text:"<i class='fa fa-print'></i>", titleAttr:"Vista Preliminar", title:"Usuarios", exportOptions:{columns:[0,1,2,3,4,5]}}
															], //cierra el buttons
                                                 
													
													rowCallback:function (row, data, index) {
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
                                                                },
													drawCallback: function () {
															//para que se configuren los popover-titles...
															j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
														},
                                                    //initComplete: stf.initComplete,                                                            
                                                     language:{url:"plugins/dataTable/lang/Spanish.json"},
                                                     paging:false,
                                                     processing: true,
                                                     searching:true
                                                    });
               	
				
				 //controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_usuarios tbody").on("click","tr", function() {  
                  if (!j$(this).hasClass("selected") ) {                  
                    lst_usuarios.$("tr.selected").removeClass("selected");
                    j$(this).addClass("selected");
                    /* mostramos el historico en el click del icono de la maleta
					var table = j$('#lista_pirs').DataTable();
                    row_sel = table.row( this ).data();
					
					j$("#cabecera_pantalla_avisos").html("<h3>Hist&oacute;rico del PIR " + row_sel.PIR + "</h3>")
					j$("#body_avisos").html('<iframe id="iframe_historico_pir" src="Detalle_Historico_Pir.asp?id_pir=' + row_sel.ID + '&pir=' + row_sel.PIR + '" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe>');
					j$("#pantalla_avisos").modal("show");
					*/
                  } 
                  //console.log(row_sel);
					
				  
                });

				//gestiona el dobleclick sobre la fila para mostrar la pantalla de detalle del pir
				j$("#lista_usuarios").on("dblclick", "tr", function(e) {
				  var row=lst_usuarios.row(j$(this).closest("tr")).data() 
																
				  parametro_id=row.ID
				  parametro_nombre=row.NOMBRE
				  parametro_perfil=row.PERFIL
				  parametro_proveedor=row.PROVEEDOR
				  parametro_tipo_usuario=row.TIPO_USUARIO
				  parametro_usuario=row.USUARIO
				  parametro_contrasenna=row.CONTRASENNA
				  parametro_borrado=row.BORRADO

				  j$(this).addClass('selected');
				  mostrar_detalle_usuario(parametro_id, parametro_nombre, parametro_perfil, parametro_proveedor, parametro_tipo_usuario, parametro_usuario, parametro_contrasenna, parametro_borrado);
				  
				});
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_usuarios.ajax.url("tojson/obtener_usuarios.asp");
              lst_usuarios.ajax.reload();                  
            }       
      
      
    
  };





mostrar_proveedores = function(perfil) {  
      var err ="";
		
		//no hay control de errores por filtros no rellenados
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
        
        j$.fn.dataTable.moment("DD/MM/YYYY");
        
        //deseleccioamos el registro de la lista
        j$('#lista_proveedores tbody tr').removeClass('selected');
        
        if (typeof lst_proveedores == "undefined") {
            lst_proveedores = j$("#lista_proveedores").DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:"tojson/obtener_proveedores.asp",
                                                           type:"POST",
                                                           dataSrc:"ROWSET"},
                                                     order:[1, 'asc', 0, 'asc'],
                                                     
													 columnDefs: [
                                                              //{className: "dt-right", targets: [2,3]},
                                                              {className: "dt-center", targets: [3,4]}                                                            
                                                            ],
													
                                                     columns:[ 
																{data:"DESCRIPCION"},
															  	{data:"ORDEN"},
																{data:"BORRADO"},
																{data:function(row, type, val, meta) {
																	tip_mal=''
																	j$.ajax({
																	  type: 'POST',
																	  url: 'tojson/Obtener_Proveedores_Tipos_Maleta.asp',
																	  data: {id_proveedor: row.ID},
																	  success: function(data){
																					j$.each(data.ROWSET, function(index) {
																						if (data.ROWSET[index].ID_PROVEEDOR!='')
																							{
																							//console.log('tenemos en cuenta tipo maleta: ' + data.ROWSET[index].DESCRIPCION_MALETA )
																							tip_mal+=data.ROWSET[index].DESCRIPCION + '<br>'
																							}
																					});
																	  			},
																	  dataType: 'json',
																	  async:false
																	});
																	//console.log('cadena tip_mal para proveedor ' + row.ID + ': ' + tip_mal)
																
																	cadena=''
																	if (tip_mal!='')
																		{
																	 	cadena+='&nbsp;<i class="fa fa-suitcase"' + 
																				' aria-hidden="true"' + 
																				' style="color:blue;"' + 
																				' data-toggle="popover_datatable"' +
																				' data-placement="right"' +
																				' data-trigger="hover"' +
																				' data-title="Tipo de Maletas"' +
																				' data-content="' + tip_mal + '"' +
																				'></i>'
																		}
																	return cadena
																	}
																},
																{data:function(row, type, val, meta) {                                                                                                                   
                                                                      	//return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                                                                  
                                                                      	cadena='<i class="fa fa-trash fa-2x btn_delete_proveedores"' +
																						' aria-hidden="true"' +
																						' style="color:darkred;cursor:hand;cursor:pointer"' + 
																						' data-toggle="popover_datatable"' +
																						' data-placement="right"' +
																						' data-trigger="hover"' +
																						' data-content="Borrar El Proveedor"' +
																						' onclick="borrar_proveedor(' + row.ID + ')"></i>'
																		if (row.BORRADO=='NO')
																			{
																			cadena_a_mostrar=cadena
																			}
																		  else
																		  	{
																			cadena_a_mostrar=''
																			}
																		return cadena_a_mostrar
                                                                    	}
                                                               		},
																{data:"ID", visible:false}
                                                            ],
                                                     deferRender:true,
    //  Scroller
                                                     scrollY:calcDataTableHeight() - 90,
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
                                                   buttons:[{extend:"copy", text:'<i class="fa fa-files-o"></i>', titleAttr:"Copiar en Portapapeles", exportOptions:{columns:[0,1,2]}}, 
                                                             {extend:"excel", text:'<i class="fa fa-file-excel-o"></i>', titleAttr:"Exportar a Formato Excel", title:"Proveedores", extension:".xls", exportOptions:{columns:[0,1,2]}}, 
                                                             {extend:"pdf", text:'<i class="fa fa-file-pdf-o"></i>', titleAttr:"Exportar a Formato PDF", title:"Proveedores", orientation:"landscape", exportOptions:{columns:[0,1,2]}}, 
                                                             {extend:"print", text:"<i class='fa fa-print'></i>", titleAttr:"Vista Preliminar", title:"Proveedores", exportOptions:{columns:[0,1,2]}}
															], //cierra el buttons
                                                 
													
													rowCallback:function (row, data, index) {
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
                                                                },
													drawCallback: function () {
															//para que se configuren los popover-titles...
															j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
														},
                                                    //initComplete: stf.initComplete,                                                            
                                                     language:{url:"plugins/dataTable/lang/Spanish.json"},
                                                     paging:false,
                                                     processing: true,
                                                     searching:true
                                                    });
               	
				
				 //controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_proveedores tbody").on("click","tr", function() {  
                  if (!j$(this).hasClass("selected") ) {                  
                    lst_proveedores.$("tr.selected").removeClass("selected");
                    j$(this).addClass("selected");
                    /* mostramos el historico en el click del icono de la maleta
					var table = j$('#lista_pirs').DataTable();
                    row_sel = table.row( this ).data();
					
					j$("#cabecera_pantalla_avisos").html("<h3>Hist&oacute;rico del PIR " + row_sel.PIR + "</h3>")
					j$("#body_avisos").html('<iframe id="iframe_historico_pir" src="Detalle_Historico_Pir.asp?id_pir=' + row_sel.ID + '&pir=' + row_sel.PIR + '" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe>');
					j$("#pantalla_avisos").modal("show");
					*/
                  } 
                  //console.log(row_sel);
					
				  
                });

				//gestiona el dobleclick sobre la fila para mostrar la pantalla de detalle del pir
				j$("#lista_proveedores").on("dblclick", "tr", function(e) {
				  var row=lst_proveedores.row(j$(this).closest("tr")).data() 
				  parametro_id=row.ID
				  parametro_descripcion=row.DESCRIPCION
				  parametro_orden=row.ORDEN
				  parametro_borrado=row.BORRADO
				  j$(this).addClass('selected');
				  mostrar_detalle_proveedor(parametro_id, parametro_descripcion, parametro_orden, parametro_borrado );
				  
				  j$.post("tojson/Obtener_Proveedores_Tipos_Maleta.asp"
				  	, {id_proveedor: parametro_id}
					, function(data){
							//console.log('texto devuelto:' + JSON.stringify(data))
							cadena=''
							j$.each(data.ROWSET, function(index) {
					            //console.log(data.ROWSET[index].ID);
								//console.log(data.ROWSET[index].CODIGO);
								//console.log(data.ROWSET[index].DESCRIPCION);
								//console.log(data.ROWSET[index].DESCRIPCION_MALETA);
								//console.log(data.ROWSET[index].ID_PROVEEDOR);
								cadena+='<div class="col-sm-6 col-md-4 col-lg-3 mx-auto">'
								cadena+='<div class="checkbox">'
								cadena+='<label>'
								cadena+='<input class="chktipos_maletas" type="checkbox" value="" id_tip_mal="' + data.ROWSET[index].ID + '"'
								if (data.ROWSET[index].ID_PROVEEDOR!='')
									{
									cadena+=' checked'
									}
								cadena+=' name="chktipos_maleta_' + data.ROWSET[index].ID + '"'
								cadena+=' id="chktipos_maleta_' + data.ROWSET[index].ID + '">'
								cadena+='<span class="cr"><i class="cr-icon glyphicon glyphicon-ok"></i></span>'
								cadena+=data.ROWSET[index].DESCRIPCION_MALETA
								cadena+='</label>'
								cadena+='</div>'
								cadena+='</div>'
        					});
							
							j$("#capa_proveedores_tipos_maleta").html(cadena);
							
						
					}, "json");


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
			  lst_proveedores.ajax.url("tojson/obtener_proveedores.asp");
              lst_proveedores.ajax.reload();                  
            }       
      
      
    
  };



mostrar_tipos_maleta = function(perfil) {  
      var err ="";
		
		//no hay control de errores por filtros no rellenados
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
        
        j$.fn.dataTable.moment("DD/MM/YYYY");
        
        //deseleccioamos el registro de la lista
        j$('#lista_tipos_maleta tbody tr').removeClass('selected');
        
        if (typeof lst_tipos_maleta == "undefined") {
            lst_tipos_maleta = j$("#lista_tipos_maleta").DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:"tojson/obtener_tipos_maleta.asp",
                                                           type:"POST",
                                                           dataSrc:"ROWSET"},
                                                     order:[2, 'asc', 1, 'asc'],
                                                     
													 columnDefs: [
                                                              //{className: "dt-right", targets: [2,3]},
                                                              {className: "dt-center", targets: [4]}                                                            
                                                            ],
													
                                                     columns:[ 
													 			{data:"CODIGO"},
																{data:"DESCRIPCION"},
															  	{data:"ORDEN"},
																{data:"BORRADO"},
																{data:function(row, type, val, meta) {                                                                                                                   
                                                                      	//return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                                                                  
                                                                      	cadena='<i class="fa fa-trash fa-2x btn_delete_tipos_maleta"' +
																						' aria-hidden="true"' +
																						' style="color:darkred;cursor:hand;cursor:pointer"' + 
																						' data-toggle="popover_datatable"' +
																						' data-placement="right"' +
																						' data-trigger="hover"' +
																						' data-content="Borrar El Tipo de Maleta"' +
																						' onclick="borrar_tipo_maleta(' + row.ID + ')"></i>'
																		if (row.BORRADO=='NO')
																			{
																			cadena_a_mostrar=cadena
																			}
																		  else
																		  	{
																			cadena_a_mostrar=''
																			}
																		return cadena_a_mostrar
                                                                    	}
                                                               		},
																{data:"ID", visible:false}
                                                            ],
                                                     deferRender:true,
    //  Scroller
                                                     scrollY:calcDataTableHeight() - 90,
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
                                                   buttons:[{extend:"copy", text:'<i class="fa fa-files-o"></i>', titleAttr:"Copiar en Portapapeles", exportOptions:{columns:[0,1,2,3]}}, 
                                                             {extend:"excel", text:'<i class="fa fa-file-excel-o"></i>', titleAttr:"Exportar a Formato Excel", title:"Tipos_Maleta", extension:".xls", exportOptions:{columns:[0,1,2,3]}}, 
                                                             {extend:"pdf", text:'<i class="fa fa-file-pdf-o"></i>', titleAttr:"Exportar a Formato PDF", title:"Tipos_Maleta", orientation:"landscape", exportOptions:{columns:[0,1,2,3]}}, 
                                                             {extend:"print", text:"<i class='fa fa-print'></i>", titleAttr:"Vista Preliminar", title:"Tipos_Maleta", exportOptions:{columns:[0,1,2,3]}}
															], //cierra el buttons
                                                 
													
													rowCallback:function (row, data, index) {
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
                                                                },
													drawCallback: function () {
															//para que se configuren los popover-titles...
															j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
														},
                                                    //initComplete: stf.initComplete,                                                            
                                                     language:{url:"plugins/dataTable/lang/Spanish.json"},
                                                     paging:false,
                                                     processing: true,
                                                     searching:true
                                                    });
               	
				
				 //controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_tipos_maleta tbody").on("click","tr", function() {  
                  if (!j$(this).hasClass("selected") ) {                  
                    lst_tipos_maleta.$("tr.selected").removeClass("selected");
                    j$(this).addClass("selected");
                    /* mostramos el historico en el click del icono de la maleta
					var table = j$('#lista_pirs').DataTable();
                    row_sel = table.row( this ).data();
					
					j$("#cabecera_pantalla_avisos").html("<h3>Hist&oacute;rico del PIR " + row_sel.PIR + "</h3>")
					j$("#body_avisos").html('<iframe id="iframe_historico_pir" src="Detalle_Historico_Pir.asp?id_pir=' + row_sel.ID + '&pir=' + row_sel.PIR + '" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe>');
					j$("#pantalla_avisos").modal("show");
					*/
                  } 
                  //console.log(row_sel);
					
				  
                });

				//gestiona el dobleclick sobre la fila para mostrar la pantalla de detalle del pir
				j$("#lista_tipos_maleta").on("dblclick", "tr", function(e) {
				  var row=lst_tipos_maleta.row(j$(this).closest("tr")).data() 
				  parametro_id=row.ID
				  parametro_codigo=row.CODIGO
				  parametro_descripcion=row.DESCRIPCION
				  parametro_orden=row.ORDEN
				  parametro_borrado=row.BORRADO
					//console.log('en el doble click')
				  j$(this).addClass('selected');
				  mostrar_detalle_tipo_maleta(parametro_id, parametro_codigo, parametro_descripcion, parametro_orden, parametro_borrado );
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
			  lst_tipos_maleta.ajax.url("tojson/obtener_tipos_maleta.asp");
              lst_tipos_maleta.ajax.reload();                  
            }       
      
      
    
  };




/////////////////////////////////////////////////////////////////////////

mantenimiento_usuarios = function(valor_accion, valor_id, valor_nombre_usuario, valor_perfil_usuario, valor_proveedor_usuario, valor_usuario_usuario, valor_tipo_usuario, valor_contrasenna_usuario, valor_borrado_usuario) {
	/*
	j$.ajax({
		type: "post",        
    	url: 'Mantenimiento_Cantidades_Precios.asp',
		data: '{accion:"' + valor_accion + '", id:' + valor_id + '}',
	    success: function(respuesta) {
					  console.log('el stock es de: ' + respuesta)
					  //j$("#txtstock_STANDARD").val(respuesta)
					},
    	error: function() {
    			bootbox.alert({
					message: "Se ha producido un error al intentar actualizar las Cantidades precios del Articulo",
					//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
					//callback: refrescar_stock()
				})
    		}
  	});	
	*/
	//$(selector).post(URL,data,function(data,status,xhr),dataType)
	texto_error=""
	if (valor_accion=='BORRAR')
		{
		texto_error='Se ha Producido un Error al Eliminar El Usuario'
		}
	if (valor_accion=='ALTA')
		{
		texto_error='Se ha Producido un Error al dar de Alta El Usuario'
		}
	if (valor_accion=='MODIFICACION')
		{
		texto_error='Se ha Producido un Error al Modificar El Usuario'
		}
	
	//console.log('id: ' + valor_id)
	//console.log('codigo_articulo: ' + valor_codigo_articulo)
	//console.log('cantridad: ' + valor_cantidad)
	//console.log('precio unid: ' + valor_precio_unidad) 
	//console.log('precio pac: ' + valor_precio_pack) 
	//console.log('tipo sucur: ' + valor_tipo_sucursal) 
	//console.log('empresa: ' + valor_codigo_empresa)
	
	j$.post('Mantenimiento_Usuarios.asp',
					//'{accion:"' + valor_accion + '", id:' + valor_id + '}',
					{accion:valor_accion,
							id:valor_id,
							nombre_usuario:valor_nombre_usuario,
							perfil_usuario:valor_perfil_usuario, 
							proveedor_usuario:valor_proveedor_usuario, 
							usuario_usuario:valor_usuario_usuario, 
							tipo_usuario:valor_tipo_usuario, 
							contrasenna_usuario:valor_contrasenna_usuario, 
							borrado_usuario:valor_borrado_usuario
					},
					function(data, status, xhr)
						{
						//console.log('datos devueltos: ' + data)
						//console.log('estatus: ' + status)
						if (status!='success')
							{
							bootbox.alert({
									size: 'large',
									message: '<h4><p><i class="fas fa-exclamation-circle" style="color:red"></i> ' 
													+ texto_error 
													+ '</p></h4>'
													+ '<div class="alert alert-danger" role="alert">'
													+ data
													+ '</div>'
									//callback: mostrar_tipos_maleta()
								})
							}
						
						}
	
	
	
	) // fin post
	
};



//funcion para crear, modificar y borrar los proveedores	
mantenimiento_proveedores = function(valor_accion, valor_id, valor_descripcion_proveedor, valor_orden_proveedor, valor_borrado_proveedor, tipos_maletas_seleccionadas) {
	/*
	j$.ajax({
		type: "post",        
    	url: 'Mantenimiento_Cantidades_Precios.asp',
		data: '{accion:"' + valor_accion + '", id:' + valor_id + '}',
	    success: function(respuesta) {
					  console.log('el stock es de: ' + respuesta)
					  //j$("#txtstock_STANDARD").val(respuesta)
					},
    	error: function() {
    			bootbox.alert({
					message: "Se ha producido un error al intentar actualizar las Cantidades precios del Articulo",
					//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
					//callback: refrescar_stock()
				})
    		}
  	});	
	*/
	//$(selector).post(URL,data,function(data,status,xhr),dataType)
	texto_error=""
	if (valor_accion=='BORRAR')
		{
		texto_error='Se ha Producido un Error al Eliminar El Proveedor'
		}
	if (valor_accion=='ALTA')
		{
		texto_error='Se ha Producido un Error al dar de Alta El Proveedor'
		}
	if (valor_accion=='MODIFICACION')
		{
		texto_error='Se ha Producido un Error al Modificar El Proveedor'
		}
	
	//console.log('id: ' + valor_id)
	//console.log('codigo_articulo: ' + valor_codigo_articulo)
	//console.log('cantridad: ' + valor_cantidad)
	//console.log('precio unid: ' + valor_precio_unidad) 
	//console.log('precio pac: ' + valor_precio_pack) 
	//console.log('tipo sucur: ' + valor_tipo_sucursal) 
	//console.log('empresa: ' + valor_codigo_empresa)
	
	j$.post('Mantenimiento_Proveedores.asp',
					//'{accion:"' + valor_accion + '", id:' + valor_id + '}',
					{accion:valor_accion,
							id:valor_id,
							descripcion_proveedor:valor_descripcion_proveedor, 
							orden_proveedor:valor_orden_proveedor, 
							borrado_proveedor:valor_borrado_proveedor,
							tipos_maletas_seleccionadas:tipos_maletas_seleccionadas 
					},
					function(data, status, xhr)
						{
						//console.log('datos devueltos: ' + data)
						//console.log('estatus: ' + status)
						if (status!='success')
							{
							bootbox.alert({
									size: 'large',
									message: '<h4><p><i class="fas fa-exclamation-circle" style="color:red"></i> ' 
													+ texto_error 
													+ '</p></h4>'
													+ '<div class="alert alert-danger" role="alert">'
													+ data
													+ '</div>'
									//callback: mostrar_tipos_maleta()
								})
							}
						
						}
	
	
	
	) // fin post
	
};

//funcion para crear, modificar y borrar los tipos de maleta	
mantenimiento_tipos_maleta = function(valor_accion, valor_id, valor_codigo_maleta, valor_descripcion_maleta, valor_orden_maleta, valor_borrado_maleta) {
	/*
	j$.ajax({
		type: "post",        
    	url: 'Mantenimiento_Cantidades_Precios.asp',
		data: '{accion:"' + valor_accion + '", id:' + valor_id + '}',
	    success: function(respuesta) {
					  console.log('el stock es de: ' + respuesta)
					  //j$("#txtstock_STANDARD").val(respuesta)
					},
    	error: function() {
    			bootbox.alert({
					message: "Se ha producido un error al intentar actualizar las Cantidades precios del Articulo",
					//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
					//callback: refrescar_stock()
				})
    		}
  	});	
	*/
	//$(selector).post(URL,data,function(data,status,xhr),dataType)
	texto_error=""
	if (valor_accion=='BORRAR')
		{
		texto_error='Se ha Producido un Error al Eliminar El Tipo de Maleta'
		}
	if (valor_accion=='ALTA')
		{
		texto_error='Se ha Producido un Error al dar de Alta El Tipo de Maleta'
		}
	if (valor_accion=='MODIFICACION')
		{
		texto_error='Se ha Producido un Error al Modificar El Tipo de Maleta'
		}
	
	//console.log('id: ' + valor_id)
	//console.log('codigo_articulo: ' + valor_codigo_articulo)
	//console.log('cantridad: ' + valor_cantidad)
	//console.log('precio unid: ' + valor_precio_unidad) 
	//console.log('precio pac: ' + valor_precio_pack) 
	//console.log('tipo sucur: ' + valor_tipo_sucursal) 
	//console.log('empresa: ' + valor_codigo_empresa)
	
	j$.post('Mantenimiento_Tipos_Maleta.asp',
					//'{accion:"' + valor_accion + '", id:' + valor_id + '}',
					{accion:valor_accion,
							id:valor_id,
							codigo_maleta:valor_codigo_maleta, 
							descripcion_maleta:valor_descripcion_maleta, 
							orden_maleta:valor_orden_maleta, 
							borrado_maleta:valor_borrado_maleta 
					},
					function(data, status, xhr)
						{
						//console.log('datos devueltos: ' + data)
						//console.log('estatus: ' + status)
						if (status!='success')
							{
							bootbox.alert({
									size: 'large',
									message: '<h4><p><i class="fas fa-exclamation-circle" style="color:red"></i> ' 
													+ texto_error 
													+ '</p></h4>'
													+ '<div class="alert alert-danger" role="alert">'
													+ data
													+ '</div>'
									//callback: mostrar_tipos_maleta()
								})
							}
						
						}
	
	
	
	) // fin post
	
};

borrar_usuario = function(id_seleccionado) {

	bootbox.confirm({
			message: "<h4>¿Está seguro que desea borrar este Usuario?</H4>",
			buttons: {
				confirm: {
					label: 'Si',
					className: 'btn-success'
				},
				cancel: {
					label: 'No',
					className: 'btn-danger'
				}
			},
			callback: function (result) {
				if (result)
					{
					//console.log('valor del id de cantidades precios: ' + j$(tabla).find('input[type=hidden]').val())
					valor_accion='BORRAR'
					valor_id = id_seleccionado
					valor_nombre_usuario=''
					valor_perfil_usuario=''
					valor_proveedor_usuario=''
					valor_usuario_usuario=''
					valor_tipo_usuario=''
					valor_contrasenna_usuario=''
					valor_borrado_usuario=''
			
					if (valor_id!='')
						{
						mantenimiento_usuarios(valor_accion, valor_id, valor_nombre_usuario, valor_perfil_usuario, valor_proveedor_usuario, valor_usuario_usuario, valor_tipo_usuario, valor_contrasenna_usuario, valor_borrado_usuario)
						mostrar_usuarios()
						}
					}
			}
		});
}		


borrar_proveedor = function(id_seleccionado) {

	bootbox.confirm({
			message: "<h4>¿Está seguro que desea borrar este Proveedor?</H4>",
			buttons: {
				confirm: {
					label: 'Si',
					className: 'btn-success'
				},
				cancel: {
					label: 'No',
					className: 'btn-danger'
				}
			},
			callback: function (result) {
				if (result)
					{
					//console.log('valor del id de cantidades precios: ' + j$(tabla).find('input[type=hidden]').val())
					valor_accion='BORRAR'
					valor_id = id_seleccionado
					valor_descripcion_proveedor=''
					valor_orden_proveedor=''
					valor_borrado_proveedor=''
					if (valor_id!='')
						{
						mantenimiento_proveedores(valor_accion, valor_id, valor_descripcion_proveedor, valor_orden_proveedor, valor_borrado_proveedor)
						mostrar_proveedores()
						}
					
					}
			}
		});
}		

borrar_tipo_maleta = function(id_seleccionado) {

	bootbox.confirm({
			message: "<h4>¿Está seguro que desea borrar este Tipo de Maleta?</H4>",
			buttons: {
				confirm: {
					label: 'Si',
					className: 'btn-success'
				},
				cancel: {
					label: 'No',
					className: 'btn-danger'
				}
			},
			callback: function (result) {
				if (result)
					{
					//console.log('valor del id de cantidades precios: ' + j$(tabla).find('input[type=hidden]').val())
					valor_accion='BORRAR'
					valor_id = id_seleccionado
					valor_codigo_maleta=''
					valor_descripcion_maleta=''
					valor_orden_maleta=''
					valor_borrado_maleta=''
					if (valor_id!='')
						{
						mantenimiento_tipos_maleta(valor_accion, valor_id, valor_codigo_maleta, valor_descripcion_maleta, valor_orden_maleta, valor_borrado_maleta)
						mostrar_tipos_maleta()
						}
					
					}
			}
		});
}		

mostrar_detalle_usuario = function(parametro_id, parametro_nombre, parametro_perfil, parametro_proveedor, parametro_tipo_usuario, parametro_usuario, parametro_contrasenna, parametro_borrado){
	j$("#ocultousuarios_id").val(parametro_id)
	j$("#txtusuarios_nombre").val(parametro_nombre)
	j$("#cmbusuarios_perfil").val(parametro_perfil)
	j$("#txtusuarios_usuario").val(parametro_usuario)
	j$("#cmbusuarios_tipo_usuario").val(parametro_tipo_usuario)
	j$("#txtusuarios_contrasenna").val(parametro_contrasenna)
	j$("#cmbusuarios_borrado").val(parametro_borrado)
	
	//console.log('usuario id: ' + j$("#ocultousuarios_id").val())
	//console.log('nombre: ' + j$("#txtusuarios_nombre").val())
	//console.log('perfil: ' + j$("#cmbusuarios_perfil").val())
	//console.log('proveedor: ' + parametro_proveedor)
	//console.log('usuario: ' + j$("#txtusuarios_usuario").val())
	//console.log('tipo usuario: ' + j$("#cmbusuarios_tipo_usuario").val())
	//console.log('contrasena: ' + j$("#txtusuarios_contrasenna").val())
	//console.log('borrado: ' + j$("#cmbusuarios_borrado").val())
	
	
	cadena_combo='<option value=""></option>'
	j$.ajax({
	  type: 'POST',
	  url: 'tojson/Obtener_Proveedores_Usuarios.asp',
	  success: function(data){
					j$.each(data.ROWSET, function(index) {
							cadena_combo+='<option value="' + data.ROWSET[index].ID + '">' + data.ROWSET[index].DESCRIPCION + '</option>'
					});
				},
	  dataType: 'json',
	  async:false
	});
	
	j$("#cmbusuarios_proveedor").html(cadena_combo)	
    
	
	if (j$("#cmbusuarios_perfil").val()=='PROVEEDOR')
		{
		j$("#capa_proveedor").show()
		//j$("#cmbusuarios_proveedor").val(parametro_proveedor)
		//porque selecciono por el texto no por el codigo
		j$("#cmbusuarios_proveedor").find('option:contains("' + parametro_proveedor + '")').attr('selected', true);
		}
	  else
	  	{
		j$("#capa_proveedor").hide()
		j$("#cmbusuarios_proveedor").val('')
		}
	
	if (j$("#cmbusuarios_tipo_usuario").val()=='EXTERNO')
		{
		j$("#capa_contrasenna").show()
		}
	  else
	  	{
		j$("#capa_contrasenna").hide()
		j$("#txtusuarios_contrasenna").val('')
		}
	
    j$("#capa_detalle_usuario").modal("show");
  }

mostrar_detalle_proveedor = function(parametro_id, parametro_descripcion, parametro_orden, parametro_borrado){
	//j$("#cabecera_iframe").html(cadena_cabecera);
	j$("#ocultoproveedores_id").val(parametro_id)
	j$("#txtproveedores_descripcion").val(parametro_descripcion)
    j$("#txtproveedores_orden").val(parametro_orden)
	j$("#cmbproveedores_borrado").val(parametro_borrado)
    //j$('#iframe_detalle_pir').attr('src', url_iframe)
    j$("#capa_detalle_proveedor").modal("show");
  }

mostrar_detalle_tipo_maleta = function(parametro_id, parametro_codigo, parametro_descripcion, parametro_orden, parametro_borrado){
    //console.log('dentro de mostrar el tipo maleta')
	//j$("#cabecera_iframe").html(cadena_cabecera);
	j$("#ocultotipos_maleta_id").val(parametro_id)
	j$("#txttipos_maleta_codigo").val(parametro_codigo)
	j$("#txttipos_maleta_descripcion").val(parametro_descripcion)
    j$("#txttipos_maleta_orden").val(parametro_orden)
	j$("#cmbtipos_maleta_borrado").val(parametro_borrado)
    //j$('#iframe_detalle_pir').attr('src', url_iframe)
    j$("#capa_detalle_tipo_maleta").modal("show");
  }


j$('#cmdguardar_usuario').on('click', function() {
	hay_error=''
	
	
	if (j$("#txtusuarios_nombre").val()=='')
		{
		hay_error=hay_error + '- Ha de Introducir El Nombre del Usuario.<br>'
		}
	if (j$("#cmbusuarios_perfil").val()=='')
		{
		hay_error=hay_error + '- Ha de Seleccionar El Perfil del Usuario.<br>'
		}
	  else
	  	if (j$("#cmbusuarios_perfil").val()=='PROVEEDOR')
			{
			if (j$("#cmbusuario_proveedor").val()=='')
				{
				hay_error=hay_error + '- Ha de Seleccionar El Proveedor del Usuario.<br>'
				}
			}
		
	
	if (j$("#txtusuarios_usuario").val()=='')
		{
		hay_error=hay_error + '- Ha de Introducir El C&oacute;odigo del Usuario.<br>'
		}
	if (j$("#cmbusuarios_tipo_usuario").val()=='')
		{
		hay_error=hay_error + '- Ha de Seleccionar El Tipo de Usuario.<br>'
		}
	  else
	  	if (j$("#cmbusuarios_tipo_usuario").val()=='EXTERNO')
			{
			if (j$("#txtusuarios_contrasenna").val()=='')
				{
				hay_error=hay_error + '- Ha de Introducir La Constraseña del Usuario.<br>'
				}
			}
	
	
		
	
	
	if (hay_error!='')	
		{
		bootbox.alert({
					message: "<H4>Se han encontrado los siguientes errores:</H4><br><br>" + hay_error,
					//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
					//callback: refrescar_stock()
				})
		}
	  else
	  	{
		//j$("#frmdatos_pir").submit()
		//enviamos
		if (j$("#ocultousuarios_id").val()=='')
			{
			valor_accion='ALTA'
			}
		  else
		  	{
			valor_accion='MODIFICACION'
			}
			
		valor_id = j$("#ocultousuarios_id").val()
		valor_nombre_usuario=j$("#txtusuarios_nombre").val()
		valor_perfil_usuario=j$("#cmbusuarios_perfil").val()
		valor_proveedor_usuario=j$("#cmbusuarios_proveedor").val()
		valor_usuario_usuario=j$("#txtusuarios_usuario").val()
		valor_tipo_usuario=j$("#cmbusuarios_tipo_usuario").val()
		valor_contrasenna_usuario=j$("#txtusuarios_contrasenna").val()
		valor_borrado_usuario=j$("#cmbusuarios_borrado").val()

		mantenimiento_usuarios(valor_accion, valor_id, valor_nombre_usuario, valor_perfil_usuario, valor_proveedor_usuario, valor_usuario_usuario, valor_tipo_usuario, valor_contrasenna_usuario, valor_borrado_usuario)
		
		mostrar_usuarios()
		
		
		
		j$("#ocultousuarios_id").val('')
		j$("#txtusuarios_nombre").val('')
		j$("#cmbusuarios_perfil").val('')
		j$("#cmbusuarios_proveedor").val('')
		j$("#txtusuarios_usuario").val('')
		j$("#cmbusuarios_tipo_usuario").val('')
		j$("#txtusuarios_contrasenna").val('')
		j$("#cmbusuarios_borrado").val('NO')
		
		j$("#capa_detalle_usuario").modal("hide");

		}		


});


j$('#cmdguardar_proveedor').on('click', function() {
	hay_error=''
	if (j$("#txtproveedores_descripcion").val()=='')
		{
		hay_error=hay_error + '- Ha de Introducir la Descripci&oacute;n del Proveedor.<br>'
		}
	if (j$("#txtproveedores_orden").val()=='')
		{
		hay_error=hay_error + '- Ha de Introducir el Orden del Proveedor.<br>'
		}
	if (j$("#cmbproveedores_borrado").val()=='')
		{
		hay_error=hay_error + '- Ha de Seleccionar si est&aacute; Borrado o No el Proveedor.<br>'
		}
		
	tipos_maletas_seleccionadas=''
	j$(".chktipos_maletas").each(function() {
 		 //console.log('valor checked del checkbox ' + j$(this).prop('id') + ': ' + j$(this).prop('checked') + ' --- valor id_tip_mal: ' + j$(this).attr('id_tip_mal'))
		 if (j$(this).prop('checked'))
		 	{
			tipos_maletas_seleccionadas+= j$(this).attr('id_tip_mal') + '#'
			}
		 //j$(this).prop('checked')
	});
											
	//console.log('tipos_maletas_seleccionadas: ' + tipos_maletas_seleccionadas)
	if (tipos_maletas_seleccionadas=='')
		{
		hay_error=hay_error + '- Ha de Seleccionar los Tipos de Maleta que Gestionar&aacute; el Proveedor.<br>'
		}
	 

	
	if (hay_error!='')	
		{
		bootbox.alert({
					message: "<H4>Se han encontrado los siguientes errores:</H4><br><br>" + hay_error,
					//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
					//callback: refrescar_stock()
				})
		}
	  else
	  	{
		//j$("#frmdatos_pir").submit()
		//enviamos
		if (j$("#ocultoproveedores_id").val()=='')
			{
			valor_accion='ALTA'
			}
		  else
		  	{
			valor_accion='MODIFICACION'
			}
			
		valor_id = j$("#ocultoproveedores_id").val()
		valor_descripcion_proveedor=j$("#txtproveedores_descripcion").val()
		valor_orden_proveedor=j$("#txtproveedores_orden").val()
		valor_borrado_proveedor=j$("#cmbproveedores_borrado").val()

		mantenimiento_proveedores(valor_accion, valor_id, valor_descripcion_proveedor, valor_orden_proveedor, valor_borrado_proveedor, tipos_maletas_seleccionadas)
		mostrar_proveedores()
		
		j$("#ocultoproveedores_id").val('')
		j$("#txtproveedores_descripcion").val('')
		j$("#txtproveedores_orden").val('')
		j$("#cmbproveedores_borrado").val('NO')
		j$(".chktipos_maletas").prop('checked', false)
		j$("#capa_detalle_proveedor").modal("hide");

		}		


});


j$('#cmdguardar_tipo_maleta').on('click', function() {
	hay_error=''
	if (j$("#txttipos_maleta_codigo").val()=='')
		{
		hay_error=hay_error + '- Ha de Introducir el C&oacute;digo del Tipo de Maleta.<br>'
		}
	if (j$("#txttipos_maleta_descripcion").val()=='')
		{
		hay_error=hay_error + '- Ha de Introducir la Descripci&oacute;n del Tipo de Maleta.<br>'
		}
	if (j$("#txttipos_maleta_orden").val()=='')
		{
		hay_error=hay_error + '- Ha de Introducir el Orden del Tipo de Maleta.<br>'
		}
	if (j$("#cmbtipos_maleta_borrado").val()=='')
		{
		hay_error=hay_error + '- Ha de Seleccionar si est&aacute; Borrado o No el Tipo de Maleta.<br>'
		}
	
	if (hay_error!='')	
		{
		bootbox.alert({
					message: "<H4>Se han encontrado los siguientes errores:</H4><br><br>" + hay_error,
					//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
					//callback: refrescar_stock()
				})
		}
	  else
	  	{
		//j$("#frmdatos_pir").submit()
		//enviamos
		if (j$("#ocultotipos_maleta_id").val()=='')
			{
			valor_accion='ALTA'
			}
		  else
		  	{
			valor_accion='MODIFICACION'
			}
			
		valor_id = j$("#ocultotipos_maleta_id").val()
		valor_codigo_maleta=j$("#txttipos_maleta_codigo").val()
		valor_descripcion_maleta=j$("#txttipos_maleta_descripcion").val()
		valor_orden_maleta=j$("#txttipos_maleta_orden").val()
		valor_borrado_maleta=j$("#cmbtipos_maleta_borrado").val()

		mantenimiento_tipos_maleta(valor_accion, valor_id, valor_codigo_maleta, valor_descripcion_maleta, valor_orden_maleta, valor_borrado_maleta)
		mostrar_tipos_maleta()
		
		j$("#ocultotipos_maleta_id").val('')
		j$("#txttipos_maleta_codigo").val('')
		j$("#txttipos_maleta_descripcion").val('')
		j$("#txttipos_maleta_orden").val('')
		j$("#cmbtipos_maleta_borrado").val('NO')
		j$("#capa_detalle_tipo_maleta").modal("hide");

		}		


});

j$('.btn_add_usuarios').on('click', function() {
	j$("#ocultousuarios_id").val('')
	j$("#txtusuarios_nombre").val('')
	j$("#cmbusuarios_perfil").val('PROVEEDOR')
	j$("#txtusuarios_proveedor").val('')
	j$("#cmbusuarios_tipo_usuario").val('INTERNO')
	j$("#txtusuarios_usuario").val('')
	j$("#txtusuarios_contrasenna").val('')
	j$("#cmbusuarios_borrado").val('NO')
	
	//mostrar_detalle_usuario(parametro_id, parametro_nombre, parametro_perfil, parametro_proveedor, parametro_tipo_usuario, parametro_usuario, parametro_contrasenna, parametro_borrado);
	mostrar_detalle_usuario('', '', 'PROVEEDOR', '', 'INTERNO', '', '', 'NO');
	
				  
	
	
});


j$('.btn_add_proveedores').on('click', function() {
	j$("#ocultoproveedores_id").val('')
	j$("#txtproveedores_descripcion").val('')
	j$("#txtproveedores_orden").val('')
	j$("#txtproveedores_borrado").val('NO')
	
	mostrar_detalle_proveedor('', '', '', 'NO');
	j$.post("tojson/Obtener_Proveedores_Tipos_Maleta.asp"
				  	, {id_proveedor: 0}
					, function(data){
							//console.log('texto devuelto:' + JSON.stringify(data))
							cadena=''
							j$.each(data.ROWSET, function(index) {
					            //console.log(data.ROWSET[index].ID);
								//console.log(data.ROWSET[index].CODIGO);
								//console.log(data.ROWSET[index].DESCRIPCION);
								//console.log(data.ROWSET[index].DESCRIPCION_MALETA);
								//console.log(data.ROWSET[index].ID_PROVEEDOR);
								cadena+='<div class="col-sm-6 col-md-4 col-lg-3 mx-auto">'
								cadena+='<div class="checkbox">'
								cadena+='<label>'
								cadena+='<input class="chktipos_maletas" type="checkbox" value="" id_tip_mal="' + data.ROWSET[index].ID + '"'
								if (data.ROWSET[index].ID_PROVEEDOR!='')
									{
									cadena+=' checked'
									}
								cadena+=' name="chktipos_maleta_' + data.ROWSET[index].ID + '"'
								cadena+=' id="chktipos_maleta_' + data.ROWSET[index].ID + '">'
								cadena+='<span class="cr"><i class="cr-icon glyphicon glyphicon-ok"></i></span>'
								cadena+=data.ROWSET[index].DESCRIPCION_MALETA
								cadena+='</label>'
								cadena+='</div>'
								cadena+='</div>'
        					});
							
							j$("#capa_proveedores_tipos_maleta").html(cadena);
							
						
					}, "json");

	
});


j$('.btn_add_tipos_maleta').on('click', function() {
	j$("#ocultotipos_maleta_id").val('')
	j$("#txttipos_maleta_codigo").val('')
	j$("#txttipos_maleta_descripcion").val('')
	j$("#txttipos_maleta_orden").val('')
	j$("#txttipos_maleta_borrado").val('NO')
	
	mostrar_detalle_tipo_maleta('', '', '', '', 'NO');
	
});

j$('#cmbusuarios_perfil').on('change', function() {
    if (j$(this).find(":selected").val()=='PROVEEDOR')
		{
		j$('#capa_proveedor').show()
		}
	  else
	  	{
		j$('#cmbusuarios_proveedor').val('')
		j$('#capa_proveedor').hide()
		}
});


j$('#cmbusuarios_tipo_usuario').on('change', function() {
    if (j$(this).find(":selected").val()=='EXTERNO')
		{
		j$('#capa_contrasenna').show()
		}
	  else
	  	{
		j$('#txtusuarios_contrasenna').val('')
		j$('#capa_contrasenna').hide()
		}
});
</script>

</body>
<%
%>
</html>