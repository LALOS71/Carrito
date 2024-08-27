<%@ language=vbscript%>
<!--#include file="Conexion.inc"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
	if session("usuario")="" then
		response.Redirect("Login.asp")
	end if
	
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

CAMPO_ID_COMPANNIAS=0
CAMPO_CODIGO_COMP_COMPANNIAS=1
CAMPO_DESCRIPCION_COMPANNIAS=2
set compannias=Server.CreateObject("ADODB.Recordset")
	with compannias
		.ActiveConnection=connmaletas
		.Source="SELECT ID, CODIGO_COMP, DESCRIPCION"
		.Source= .Source & " FROM COMPANNIAS"
		.Source= .Source & " ORDER BY ORDEN"
		'response.write("<br>" & .source)
		.Open
		vacio_compannnias=false
		if not .BOF then
			tabla_compannias=.GetRows()
		  else
			vacio_compannias=true
		end if
	end with

compannias.close
set compannias=Nothing

%>

<html>



<head>


	<title>Consulta Incidencias</title>
	

	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/media/css/dataTables.bootstrap.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/extensions/Buttons/css/buttons.dataTables.min.css">
  
	<link rel="stylesheet" type="text/css" href="plugins/font-awesome-4.7.0/css/font-awesome.min.css">

	<style>
		body { padding-top: 70px; }
		
		#capa_detalle_pir .modal-dialog  {width:90%;}
		
		.table th { font-size: 13px; }
		.table td { font-size: 12px; }
		
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


	

    </head>
<body>


<!--#include file="menu.asp"-->


<div class="container-fluid">

	 <!-- Acordion -->
	<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
		<div class="panel panel-info">
			<div class="panel-heading" role="tab" id="heading01" data-toggle="collapse" data-target="#desplegable" style="cursor:pointer">
				<h3 class="panel-title">

					<span
						data-toggle="popover" 
						data-placement="bottom" 
						data-trigger="hover"
						data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de filtros de b&uacute;squeda"
						
						>
						Filtros de B&uacute;squeda
					</span>
				</h3>
				
			</div>
			
			<div id="desplegable" class=" panel-body panel-collapse collapse " role="tabpanel" aria-labelledby="heading01">
				<form action="" method="post" novalidate="novalidate">
					<div class="row">
						<div class="col-sm-6 col-md-2 col-lg-2">
							<div class="form-group">
								<label for="txtpir" class="control-label">PIR</label>
								<div class="clearfix visible-md-block"></div>
								<input type="" class="form-control" style="width: 100%;"  id="txtpir" name="txtpir" value="" />
							</div>
							<div class="form-group">
								<label for="cmbestados" class="control-label">Estado</label>
								<div class="clearfix visible-md-block"></div>
								<select id="cmbestados" name="cmbestados" data-width="100%" class="cmb_bt">
								  <option value="">&nbsp;</option>
								  <%if not vacio_estados then
										for i=0 to UBound(tabla_estados,2)
											'los proveedores no ven la opcion de PENDIENTE DE AUTORIZACION
											if session("perfil_usuario")="PROVEEDOR" and tabla_estados(campo_id_estados,i)=1 then
												else%>
													<option value="<%=tabla_estados(campo_id_estados,i)%>"><%=tabla_estados(campo_descripcion_estados,i)%></option>
											<%end if
										next
									end if%>
								</select>
							</div>
							<div class="form-group">
								<label for="cmbcompannia" class="control-label">Compañias</label>
								<div class="clearfix visible-md-block"></div>
								<select id="cmbcompannias" name="cmbcompannias" data-width="100%" class="cmb_bt">
								  <option value="">&nbsp;</option>
								  <%if not vacio_compannias then%>
										<%for i=0 to UBound(tabla_compannias,2)%>
											<option value="<%=tabla_compannias(campo_codigo_comp_compannias,i)%>"><%=tabla_compannias(campo_codigo_comp_compannias,i)%> - <%=tabla_compannias(campo_descripcion_compannias,i)%></option>
										<%next%>
									<%end if%>
								</select>
							</div>
							<%if session("perfil_usuario")="ADMINISTRADOR" then%>
								<div class="form-group">
									<label for="cmbproveedores" class="control-label">Proveedores</label>
									<div class="clearfix visible-md-block"></div>
									<select id="cmbproveedores" name="cmbproveedores" data-width="100%" class="cmb_bt">
									  <option value="">&nbsp;</option>
									  <%if not vacio_proveedores then%>
											<%for i=0 to UBound(tabla_proveedores,2)%>
												<option value="<%=tabla_proveedores(campo_id_proveedores,i)%>"><%=tabla_proveedores(campo_descripcion_proveedores,i)%></option>
											<%next%>
										<%end if%>
									</select>
								</div>
							<%end if%>
							
							<div class="form-group">
								<label for="txtpir" class="control-label">Expedici&oacute;n</label>
								<div class="clearfix visible-md-block"></div>
								<input type="" class="form-control" style="width: 100%;"  id="txtexpedicion" name="txtexpedicion" value="" />
							</div>
						</div><!--columna izquierda-->
	
	
						<div class="col-sm-6 col-md-10 col-lg-10">
							<div class="row">
							<div class="col-sm-6 col-md-6 col-lg-6">
								<div class="panel panel-success">
									<div class="panel-heading" role="tab" id="heading01">
										Fecha Orden <span id="fecmask" style="display:none"> (dd/mm/aaaa)</span>
									</div>
									<div id="p01" class=" panel-body panel-collapse " role="tabpanel" aria-labelledby="heading01">
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_inicio_orden" class="form-control" required="" name="txtfecha_inicio_orden" value=""
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover"
												data-content="Fecha Orden Desde...">
										</div>
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_fin_orden" class="form-control" required="" name="txtfecha_fin_orden" value="" 
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover"
												data-content="Fecha Orden Hasta...">
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-6 col-md-6 col-lg-6">
								<div class="panel panel-success">
									<div class="panel-heading" role="tab" id="heading01">
										Fecha Envío <span id="fecmask" style="display:none"> (dd/mm/aaaa)</span>
									</div>
									<div id="p01" class=" panel-body panel-collapse " role="tabpanel" aria-labelledby="heading01">
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_inicio_envio" class="form-control" required="" name="txtfecha_inicio_envio" value="" 
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover"
												data-content="Fecha Envio Desde...">
										</div>
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_fin_envio" class="form-control" required="" name="txtfecha_fin_envio" value="" 
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover"
												data-content="Fecha Envio Hasta...">
										</div>
									</div>
								</div>
							</div>
							</div>
							
							<div class="row">&nbsp;</div>
							
							<div class="row">
							<div class="col-sm-6 col-md-6 col-lg-6">
								<div class="panel panel-success">
									<div class="panel-heading" role="tab">
										Fecha Entrega <span id="fecmask" style="display:none"> (dd/mm/aaaa)</span>
									</div>
									<div class=" panel-body panel-collapse " role="tabpanel">
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_inicio_entrega" class="form-control" required="" name="txtfecha_inicio_entrega" value="" 
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover"
												data-content="Fecha Entrega Desde...">
										</div>
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_fin_entrega" class="form-control" required="" name="txtfecha_fin_entrega" value="" 
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover"
												data-content="Fecha Entrega Hasta...">
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-6 col-md-6 col-lg-6">
								<div class="col-sm-6 col-md-6 col-lg-6 col-sm-offset-3 col-md-offset-3 col-lg-offset-3">
									<span class="btn btn-lg btn-primary btnbag" style="width:100%" 
												onclick="consultar_pirs('<%=session("perfil_usuario")%>');" 
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover"
												data-content="Realizar Busqueda">
										<i class="fa fa-search fa-lg"></i><span>&nbsp;Buscar</span>
									</span>
									
								</div>
							</div>
							</div>
						</div><!--columna derecha-->
	
				  </div>
					<!-- row -->
				</form>
		  </div>
			<!-- panel Body-->
		</div>
		<!-- PANEL-->
	</div> <!-- Acordion -->


<div class="panel-group"  role="tablist" aria-multiselectable="true">
		<div class="panel panel-primary">
			<div class="panel-heading" role="tab" >
				<h3 class="panel-title">Resultado de La B&uacute;squeda</h3>
				
			</div>
			
			<div class=" panel-body panel-collapse" role="tabpanel">
			
				<div width="95%">
					 <table id="lista_pirs" name="lista_pirs" class="table table-striped table-bordered" cellspacing="0" width="100%">
					  <thead>
						<tr>
						  <th>Fecha Orden</th>
						  <th>Fecha Autorizaci&oacute;n</th>
						  <th>Pir</th>
						  <th>Tipo Maleta Entregada</th>
						  <th>Fecha Envio</th>
						  <th>Fecha Entrega</th>
						  <th>Estado</th>
						  <th>Expedici&oacute;n</th>
						  <%if session("perfil_usuario")="ADMINISTRADOR" then%>
							  <th>Facturaci&oacute;n</th>
							<%else%>
							  <th style="display:none">Facturaci&oacute;n</th>		
						  <%end if%>
						  <th>Costes</th>
						  <th>Inf.</th>
						</tr>
					  </thead>
					</table>
				</div>
				
			</div>
		</div>
</div>



<!-- capa detalle PIR -->
  <div class="modal fade" id="capa_detalle_pir">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_iframe"></h4>	    
        </div>	    
        <div class="modal-body">
          <form class="form-horizontal row-border">
            <div class="form-group">
              <!--
              <iframe id='gmv.iframe_movilidad' src="" width="100%" height="0" frameborder="0" transparency="transparency" onload="gmv.redimensionar_iframe(this);"></iframe>
              -->
              
              <iframe id='iframe_detalle_pir' src="" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe> 	
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
  

</DIV><!--CONTAINER-->


<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content" id="contenido_pantalla_avisos">	    
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
var j$=jQuery.noConflict();

j$(window).resize(function() {
    if (lst_pirs)
      {
      var oSettings = lst_pirs.settings();
      oSettings[0].oScroll.sY = calcDataTableHeight() - 70; 
      lst_pirs.draw();
      }
  });  
  

j$(document).ready(function () {
	var pathname = window.location.pathname;
	
	redimensionar()
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


consultar_pirs = function(perfil) {  
	//console.log('DENTRO DE CONSULTAR_PIRS')
	if (perfil=='PROVEEDOR')
		{
		//console.log('ocultando columna')
		ver_columna=false
		}
	  else
	  	{
		ver_columna=true
		}
	columnas_a_exportar_cia='0,1,2,3,4,5,6,7,8,9,13,14,15,16,17,18,19,20'
	columnas_a_exportar_proveedor='0,1,2,3,4,5,6,7,9,21,22,23,24,25,26,27,28'
		
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
		
		
		
		
		prm.add("p_pir", j$('#txtpir').val());
        prm.add("p_estado", j$('#cmbestados').val());
		prm.add("p_compannia", j$('#cmbcompannias').val());
		prm.add("p_proveedor", j$('#cmbproveedores').val());
		prm.add("p_expedicion", j$('#txtexpedicion').val());
		prm.add("p_fecha_inicio_orden", j$('#txtfecha_inicio_orden').val());
		prm.add("p_fecha_fin_orden", j$('#txtfecha_fin_orden').val());
		prm.add("p_fecha_inicio_envio", j$('#txtfecha_inicio_envio').val());
		prm.add("p_fecha_fin_envio", j$('#txtfecha_fin_envio').val());
		prm.add("p_fecha_inicio_entrega", j$('#txtfecha_inicio_entrega').val());
		prm.add("p_fecha_fin_entrega", j$('#txtfecha_fin_entrega').val());
		
        
        j$.fn.dataTable.moment("DD/MM/YYYY");
        
        //deseleccioamos el registro de la lista
        j$('#lista_pirs tbody tr').removeClass('selected');
        
        if (typeof lst_pirs == "undefined") {
			//console.log('Dentro de la creacion del datatable lst_pirs')
            lst_pirs = j$("#lista_pirs").DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:"tojson/obtener_pirs.asp?"+prm.toString(),
                                                           type:"POST",
                                                           dataSrc:"ROWSET"},
                                                     order:[],
                                                     /*
													 columnDefs: [
                                                              {className: "dt-right", targets: [2,3]},
                                                              {className: "dt-center", targets: [4]}                                                            
                                                            ],
													*/
                                                     columns:[ 
													 			{data:"FECHA_ORDEN"},
																{data:"FECHA_INICIO"},
															  	{data:"PIR"},
																{data:"TIPO_BAG_ENTREGADA"},
																{data:"FECHA_ENVIO"},
															  	{data:"FECHA_ENTREGA_PAX"},
															  	{data:"ESTADO_DESCRIPCION"},
															  	{data:"NUM_EXPEDICION"},
																{data:"IMPORTE_FACTURACION", visible:ver_columna},
																{data:"COSTES"},
																{data:function(row, type, val, meta) {                                                                                                                   
                                                                      	//return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                                                                  
                                                                      	switch(row.ESTADO) {
																				case '1': //PTE. AUTORIZACION
																										colorcillo='black'
																										valor_estado='PTE. AUTORIZACIÓN'
																										break;
																				
																				case '2': //AUTORIZADO
																										colorcillo='#DDDDDD'
																										valor_estado='AUTORIZADO'
																										break;
																										
																				case '3': //EN GESTION
																										colorcillo='green'
																										valor_estado='EN GESTIÓN'
																										break;
																				
																				case '4': //EN GESTION - DOCUMENTACION
																										colorcillo='green'
																										valor_estado='EN GESTIÓN - PTE. DOCUMENTACIÓN'
																										break;
																									
																				case '5': //ENVIADO
																										colorcillo='green'
																										valor_estado='ENVIADO'
																										break;
																																								
																				case '6': //ENTREGADO
																										colorcillo='#FF9900'
																										valor_estado='ENTREGADO'
																										break;	
																				
																				case '7': //CERRADO
																										colorcillo='blue'
																										valor_estado='CERRADO'
																										break;	
																				
																				case '8': //GESTION CIA
																										colorcillo='#DDDDDD'
																										valor_estado='GESTIÓN CIA'
																										break;	
																										
																				case '9': //INCIDENCIA
																										colorcillo='red'
																										break;
																																																																													
																				default:
																										colorcillo='#DDDDDD'
																			}
																		
																			if (row.ESTADO==9)	//INCIDENCIA
																				{
																				valores_incidencia=row.ULTIMA_INCIDENCIA.split('#||#')
																				contenido_incidencia= 'Incidencia ' + valores_incidencia[0] + '&nbsp;' + valores_incidencia[1]
																				cadena='<i class="fa fa-suitcase" aria-hidden="true"  style="color:red"' +
																						' data-toggle="popover_datatable"' +
																						' data-placement="left"' + 
																						' data-trigger="hover"' +
																						' data-title="' +  contenido_incidencia + '"' +
																						' data-content="' + valores_incidencia[2] + '"' + 
																						' onclick="mostrar_detalle_pir(\'Detalle_Historico_Pir.asp\', ' + row.ID + ',\'' + row.PIR + '\')"></i>'
																						
																				
																				/*
																				cadena='<i class="fa fa-suitcase fa-x3" aria-hidden="true"  style="color:' + colorcillo + '"' +
						  																'data-toggle="popover_datatable"' +
																						'data-placement="left"' + 
																						'data-trigger="hover"' +
																						'data-title="holaaaa"'  // + contenido_incidencia + '"' 
																						//'data-content="' + valores_incidencia[2] + '"></i>'
																						'data-content="holitaaaaa"></i>'
																						
																				*/
																				}
																			  else
																			  	{
																				cadena='<i class="fa fa-suitcase fa-x2" aria-hidden="true"  style="color:' + colorcillo + '"' + 
																							' data-toggle="popover_datatable"' +
																							' data-placement="left"' + 
																							' data-trigger="hover"' +
																							' data-title=""' +
																							' data-content="' + valor_estado + '"' + 
																							' onclick="mostrar_detalle_pir(\'Detalle_Historico_Pir.asp\', ' + row.ID + ',\'' + row.PIR + '\')"></i>'


																				
																				
																				}
																			
																		return cadena
                                                                    	}
                                                               		},
																
																
																{data:"ID", visible:false},
																{data:"ESTADO", visible:false},
																{data:"FECHA_PIR", visible:false},
																{data:"TAG", visible:false},
																{data:"TIPO_EQUIPAJE_BAG_ORIGINAL", visible:false},
																{data:"MARCA_BAG_ORIGINAL", visible:false},
																{data:"RUTA", visible:false},
																{data:"VUELOS", visible:false},
																{data:"TAMANNO_BAG_ENTREGADA", visible:false},
																{data:"COLOR_BAG_ENTREGADA", visible:false},
																{data:"OBSERVACIONES_PROVEEDOR", visible:false},
																{data:"NOMBRE", visible:false},
																{data:"APELLIDOS", visible:false},
																{data:"DIRECCION_ENTREGA", visible:false},
																{data:"CP_ENTREGA", visible:false},
																{data:"MOVIL", visible:false},
																{data:"FIJO", visible:false},
																{data:"REFERENCIA_BAG_ENTREGADA", visible:false}
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
												   					exportOptions:{columns:[columnas_a_exportar_proveedor],
																					format: {
																							//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS, 
																							//   QUE SOLO TIENE UNA IMAGEN
																							header: function ( data, columnIdx ) {
																									if (perfil=='ADMINISTRADOR')
																										{
																										cabecera=''
																										switch(columnIdx) 
																											{
																											case 13: 
																													cabecera='FECHA PIR'
																													break;
																											case 14: 
																													cabecera='TAG'
																													break;
																											case 15: 
																													cabecera='TIPO MALETA ORIGINAL'
																													break;
																											case 16: 
																													cabecera='MARCA MALETA ORIGINAL'
																													break;
																											case 17: 
																													cabecera='RUTA'
																													break;
																											case 18: 
																													cabecera='VUELOS'
																													break;
																											case 19: 
																													cabecera='TAMAÑO MALETA ENTREGADA'
																													break;
																											case 20: 
																													cabecera='COLOR MALETA ENTREGADA'
																													break;
																											case 21: 
																													cabecera='OBSERVACIONES PROVEEDOR'
																													break;
																											case 22: 
																													cabecera='NOMBRE'
																													break;		
																											case 23: 
																													cabecera='APELLIDOS'
																													break;
																											case 24: 
																													cabecera='DIRECCION ENTREGA'
																													break;
																											case 25: 
																													cabecera='CODIGO POSTAL'
																													break;
																											case 26: 
																													cabecera='Tfl. MOVIL'
																													break;
																											case 27: 
																													cabecera='Tlf. FIJO'
																													break;
																											case 28: 
																													cabecera='Ref. MALETA ENTREGADA'
																													break;
																											default:
																													cabecera=data
																											}
																										
																										return cabecera

																										}
																									  else
																									  	{
																										return data;
																										}
																									} //cierra el header
																							} //cierra el format
																	
																	
																	}}, 
															<%if session("perfil_usuario")="ADMINISTRADOR" then%>
																 {extend:"excel", text:'<i class="fa fa-table"></i>', titleAttr:"Excel CIA", title:"Pirs_CIA", extension:".xls", 
																		exportOptions:{columns:[columnas_a_exportar_cia],
																						format: {
																								//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS, 
																								//   QUE SOLO TIENE UNA IMAGEN
																								header: function ( data, columnIdx ) {
																										if (perfil=='ADMINISTRADOR')
																											{
																											cabecera=''
																											switch(columnIdx) 
																												{
																												case 13: 
																														cabecera='FECHA PIR'
																														break;
																												case 14: 
																														cabecera='TAG'
																														break;
																												case 15: 
																														cabecera='TIPO MALETA ORIGINAL'
																														break;
																												case 16: 
																														cabecera='MARCA MALETA ORIGINAL'
																														break;
																												case 17: 
																														cabecera='RUTA'
																														break;
																												case 18: 
																														cabecera='VUELOS'
																														break;
																												case 19: 
																														cabecera='TAMAÑO MALETA ENTREGADA'
																														break;
																												case 20: 
																														cabecera='COLOR MALETA ENTREGADA'
																														break;
																												case 21: 
																														cabecera='OBSERVACIONES PROVEEDOR'
																														break;
																												case 22: 
																														cabecera='NOMBRE'
																														break;		
																												case 23: 
																														cabecera='APELLIDOS'
																														break;
																												case 24: 
																														cabecera='DIRECCION ENTREGA'
																														break;
																												case 25: 
																														cabecera='CODIGO POSTAL'
																														break;
																												case 26: 
																														cabecera='Tfl. MOVIL'
																														break;
																												case 27: 
																														cabecera='Tlf. FIJO'
																														break;
																												case 28: 
																														cabecera='Ref. MALETA ENTREGADA'
																														break;
																												default:
																														cabecera=data
																												}
																											
																											return cabecera
	
																											}
																										  else
																											{
																											return data;
																											}
																										} //cierra el header
																								} //cierra el format
																		}}, 
															<%end if%>
															 {extend:"excel", text:'<i class="fa fa-file-excel-o"></i>', titleAttr:"Excel PROVEEDOR", title:"Pirs_Proveedor", extension:".xls", 
															 		exportOptions:{columns:[columnas_a_exportar_proveedor],
																					format: {
																							//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS, 
																							//   QUE SOLO TIENE UNA IMAGEN
																							header: function ( data, columnIdx ) {
																									if (perfil=='ADMINISTRADOR')
																										{
																										cabecera=''
																										switch(columnIdx) 
																											{
																											case 13: 
																													cabecera='FECHA PIR'
																													break;
																											case 14: 
																													cabecera='TAG'
																													break;
																											case 15: 
																													cabecera='TIPO MALETA ORIGINAL'
																													break;
																											case 16: 
																													cabecera='MARCA MALETA ORIGINAL'
																													break;
																											case 17: 
																													cabecera='RUTA'
																													break;
																											case 18: 
																													cabecera='VUELOS'
																													break;
																											case 19: 
																													cabecera='TAMAÑO MALETA ENTREGADA'
																													break;
																											case 20: 
																													cabecera='COLOR MALETA ENTREGADA'
																													break;
																											case 21: 
																													cabecera='OBSERVACIONES PROVEEDOR'
																													break;
																											case 22: 
																													cabecera='NOMBRE'
																													break;		
																											case 23: 
																													cabecera='APELLIDOS'
																													break;
																											case 24: 
																													cabecera='DIRECCION ENTREGA'
																													break;
																											case 25: 
																													cabecera='CODIGO POSTAL'
																													break;
																											case 26: 
																													cabecera='Tfl. MOVIL'
																													break;
																											case 27: 
																													cabecera='Tlf. FIJO'
																													break;
																											case 28: 
																													cabecera='Ref. MALETA ENTREGADA'
																													break;
																											default:
																													cabecera=data
																											}
																										
																										return cabecera

																										}
																									  else
																									  	{
																										cabecera=''
																										switch(columnIdx) 
																											{
																											
																											case 21: 
																													cabecera='Observaciones Proveedor'
																													break;
																											default:
																													cabecera=data
																											}
																										
																										return cabecera

																										//return data;
																										}
																									} //cierra el header
																							} //cierra el format
																	}},  
                                                             {extend:"pdf", text:'<i class="fa fa-file-pdf-o"></i>', titleAttr:"Exportar a Formato PDF", title:"Pirs", orientation:"landscape", 
															 		exportOptions:{columns:[columnas_a_exportar_proveedor],
																					format: {
																							//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS, 
																							//   QUE SOLO TIENE UNA IMAGEN
																							header: function ( data, columnIdx ) {
																									if (perfil=='ADMINISTRADOR')
																										{
																										cabecera=''
																										switch(columnIdx) 
																											{
																											case 13: 
																													cabecera='FECHA PIR'
																													break;
																											case 14: 
																													cabecera='TAG'
																													break;
																											case 15: 
																													cabecera='TIPO MALETA ORIGINAL'
																													break;
																											case 16: 
																													cabecera='MARCA MALETA ORIGINAL'
																													break;
																											case 17: 
																													cabecera='RUTA'
																													break;
																											case 18: 
																													cabecera='VUELOS'
																													break;
																											case 19: 
																													cabecera='TAMAÑO MALETA ENTREGADA'
																													break;
																											case 20: 
																													cabecera='COLOR MALETA ENTREGADA'
																													break;
																											case 21: 
																													cabecera='OBSERVACIONES PROVEEDOR'
																													break;
																											case 22: 
																													cabecera='NOMBRE'
																													break;		
																											case 23: 
																													cabecera='APELLIDOS'
																													break;
																											case 24: 
																													cabecera='DIRECCION ENTREGA'
																													break;
																											case 25: 
																													cabecera='CODIGO POSTAL'
																													break;
																											case 26: 
																													cabecera='Tfl. MOVIL'
																													break;
																											case 27: 
																													cabecera='Tlf. FIJO'
																													break;
																											case 28: 
																													cabecera='Ref. MALETA ENTREGADA'
																													break;
																											
																											
																											default:
																													cabecera=data
																											}
																										
																										return cabecera

																										}
																									  else
																									  	{
																										return data;
																										}
																									} //cierra el header
																							} //cierra el format
																	}}, 
                                                             {extend:"print", text:"<i class='fa fa-print'></i>", titleAttr:"Vista Preliminar", title:"Pirs", 
															 		exportOptions:{columns:[columnas_a_exportar_proveedor],
																					format: {
																							//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS, 
																							//   QUE SOLO TIENE UNA IMAGEN
																							header: function ( data, columnIdx ) {
																									if (perfil=='ADMINISTRADOR')
																										{
																										cabecera=''
																										switch(columnIdx) 
																											{
																											case 13: 
																													cabecera='FECHA PIR'
																													break;
																											case 14: 
																													cabecera='TAG'
																													break;
																											case 15: 
																													cabecera='TIPO MALETA ORIGINAL'
																													break;
																											case 16: 
																													cabecera='MARCA MALETA ORIGINAL'
																													break;
																											case 17: 
																													cabecera='RUTA'
																													break;
																											case 18: 
																													cabecera='VUELOS'
																													break;
																											case 19: 
																													cabecera='TAMAÑO MALETA ENTREGADA'
																													break;
																											case 20: 
																													cabecera='COLOR MALETA ENTREGADA'
																													break;
																											case 21: 
																													cabecera='OBSERVACIONES PROVEEDOR'
																													break;
																											case 22: 
																													cabecera='NOMBRE'
																													break;		
																											case 23: 
																													cabecera='APELLIDOS'
																													break;
																											case 24: 
																													cabecera='DIRECCION ENTREGA'
																													break;
																											case 25: 
																													cabecera='CODIGO POSTAL'
																													break;
																											case 26: 
																													cabecera='Tfl. MOVIL'
																													break;
																											case 27: 
																													cabecera='Tlf. FIJO'
																													break;
																											case 28: 
																													cabecera='Ref. MALETA ENTREGADA'
																													break;
																											
																											default:
																													cabecera=data
																											}
																										
																										return cabecera

																										}
																									  else
																									  	{
																										return data;
																										}
																									} //cierra el header
																							} //cierra el format
																	
																	
																	}}
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
               	//los proveedorres no pueden ver la columna FACTURACION
				//console.log('antes de ocultar columna')
			   	if (perfil=='PROVEEDOR')
					{
					//console.log('ocultando columna')
					lst_pirs.columns(8).visible(false)
					}
			   //console.log('despues de ocultar columna')
			   	
				 //controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_pirs tbody").on("click","tr", function() {  
                  if (!j$(this).hasClass("selected") ) {                  
                    lst_pirs.$("tr.selected").removeClass("selected");
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
				j$("#lista_pirs").on("dblclick", "tr", function(e) {
				  var row=lst_pirs.row(j$(this).closest("tr")).data() 
				  parametro_id=row.ID
				  parametro_pir=row.PIR

				  j$(this).addClass('selected');
				  pagina='detalle_pir.asp'
				  mostrar_detalle_pir(pagina, parametro_id, parametro_pir);
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
			  lst_pirs.ajax.url("tojson/obtener_pirs.asp?"+prm.toString());
              lst_pirs.ajax.reload();                  
            }       
      
      
    
  };


redimensionar = function() { 
	/*
	console.log('vamos a redimensionar')
	console.log('desplegable .height(): ' + j$("#desplegable").height())
	console.log('desplegable .innerHeight(): ' + j$("#desplegable").innerHeight())
	console.log('desplegable .outerHeight(): ' + j$("#desplegable").outerHeight())
	console.log('desplegable .outerHeight(true): ' + j$("#desplegable").outerHeight(true))
	*/
	//alert('alto pantalla: ' + j$(window).height())
	valor=j$(window).height() - 165
	//console.log('alto capa_detalle_pir: ' + j$("#capa_detalle_pir").height())
	//console.log('top capa_detalle_pir: ' + j$("#capa_detalle_pir").position().top)
	
	j$("#iframe_detalle_pir").css('height', valor + 'px');
		
	//console.log('alto capa_detalle_pir: ' + j$("#capa_detalle_pir").height())
	//console.log('top capa_detalle_pir: ' + j$("#capa_detalle_pir").position().top)
		
	
	
};


mostrar_detalle_pir = function(pagina, parametro_id, parametro_pir){
    //alert('entro dentro de mostrar_capa_movilidad')
    //cargaSelectsNew("p_combo=EMPORG", "gmv.lov_usr_codemp", "S");  
    url_iframe=pagina + '?id=' + parametro_id + '&pir=' + parametro_pir

    //console.log('url del iframe: ' + url_iframe)
	if (pagina=='Detalle_Historico_Pir.asp')
		{
		cadena_cabecera='Hist&oacute;rico Pir ' + parametro_pir
	    }
	  else
	  	{
	    cadena_cabecera='Detalle Pir ' + parametro_pir
		}
      
    j$("#cabecera_iframe").html(cadena_cabecera);
    
    j$('#iframe_detalle_pir').attr('src', url_iframe)
    j$("#capa_detalle_pir").modal("show");
  }
  

j$('#accordion').on('hide.bs.collapse', function (e) {  

	
	if (typeof lst_pirs != "undefined")
      {
      var oSettings = lst_pirs.settings();
      oSettings[0].oScroll.sY = calcDataTableHeight() + j$("#desplegable").outerHeight(true) - 70; 
      lst_pirs.draw();
      }
            
});

j$('#accordion').on('shown.bs.collapse', function (e) { 

	if (typeof lst_pirs != "undefined")
      {
      var oSettings = lst_pirs.settings();
      oSettings[0].oScroll.sY = calcDataTableHeight() - j$("#desplegable").outerHeight(true) - 70; 
      lst_pirs.draw();
      }
            
});

j$('#capa_detalle_pir').on('show.bs.modal', function (e) {  
	
	//redimensionamos la pantalla de detalle del pir para que ocupe toda la pantalla de alto
	valor=j$(window).height() - 165
	j$("#iframe_detalle_pir").css('height', valor + 'px');

});
</script>

</body>
<%
%>
</html>