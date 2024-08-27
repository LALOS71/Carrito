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
	
	<link rel="stylesheet" type="text/css" href="plugins/font-awesome-4.7.0/css/font-awesome.min.css">

	<style>
	</style>


	

    </head>
<body>
<div class="container-fluid">

	 <!-- Acordion -->
	<div class="panel-group" id="acordeon_indiana">
		<div class="panel panel-primary">
			<div class="panel-heading" role="tab" id="heading01" data-toggle="collapse" data-target="#desplegable_indiana" style="cursor:pointer" 
				onclick="redimensionar()"
			>
				<h3 class="panel-title">

					<span
						data-toggle="popover" 
						data-placement="bottom" 
						data-trigger="hover"
						data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de datos del Pir"
						
						>
						Datos Pir - Procedentes de Indiana
					</span>
				</h3>
				
			</div>
			
			<div id="desplegable_indiana" class=" panel-body panel-collapse collapse " role="tabpanel" aria-labelledby="heading01">
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
								<select id="cmbtipo_direccion_d" name="cmbtipo_direccion_d" data-width="100%">
								  <option value="">&nbsp;</option>
								  <option value="P">Permanente</option>
								  <option value="T">Temporal</option>
								</select>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="cmbdesde_hasta_d" class="control-label">Desde/Hasta</label>
								<div class="clearfix visible-md-block"></div>
								<select id="cmbdesde_hasta_d" name="cmbdesde_hasta_d" data-width="100%">
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
												  
						  
						  
                          <div class="form-group">
                            <label for="cmbestados" class="control-label">Estado</label>
                            <div class="clearfix visible-md-block"></div>
                            <select id="cmbestados" name="cmbestados" data-width="100%">
                              <option value="">&nbsp;</option>
                              <option value="01">Estado 1</option>
                              <option value="02">Estado 2</option>
                              <option value="03">Enviado</option>
                            </select>
                          </div>
                          <div class="form-group">
                            <label for="txtpir" class="control-label">Expedici&oacute;n</label>
                            <div class="clearfix visible-md-block"></div>
                            <input type="" class="form-control" style="width: 100%;"  id="txtexpedicion" name="txtexpedicion" value="" />
                          </div>
					  </div>
						<!--columna izquierda-->
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
												onclick="consultar_pirs();" 
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
			
				<div width="98%">
					 <table id="lista_pirs" name="lista_pirs" class="table table-striped table-bordered" cellspacing="0" width="100%">
					  <thead>
						<tr>
						  <th>Fecha Orden</th>
						  <th>Fecha Entrada</th>
						  <th>Pir</th>
						  <th>Fecha Pir</th>
						  <th>Tag</th>
						  <th>Tipo</th>
						  <th>Referencia</th>
						  <th>Fecha Envio</th>
						  <th>Fecha Entrega</th>
						  <th>Estado</th>
						  <th>Expedici&oacute;n</th>
						  <th><i class="fa fa-truck" aria-hidden="true"
						  			data-toggle="popover_datatable" 
									data-placement="left" 
									data-trigger="hover"
									data-content="Incidencia de Transporte"
								></i></th>
						  <th><i class="fa fa-suitcase" aria-hidden="true"
						  			data-toggle="popover_datatable" 
									data-placement="left" 
									data-trigger="hover"
									data-content="Incidencia de Maleta"
								></i></th>	
						  <th><i class="fa fa-question" aria-hidden="true"
						  			data-toggle="popover_datatable" 
									data-placement="left" 
									data-trigger="hover"
									data-content="Otras Incidencias"
								></i></th>	
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
	//console.log('url: ' + pathname)
	posicion=pathname.lastIndexOf('/')
	pathname=pathname.substring(posicion + 1,pathname.length)
	//console.log('url truncada: ' + pathname)
	
	//para que se seleccione la opcion de menu correcta
	j$('.nav > li > a[href="'+pathname+'"]').parent().addClass('active');
	
	//para que se reconfigure el combo como del tiepo selectpicker
	j$('#cmbestados').selectpicker()

	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true});

});


calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  };  


consultar_pirs = function() {  
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
																{data:"FECHA_PIR"},
																{data:"TAG"},
																{data:"TIPO_BAG_ENTREGADA"},
																{data:"REFERENCIA_BAG_ENTREGADA"},
																{data:"FECHA_ENVIO"},
															  	{data:"FECHA_ENTREGA_PAX"},
															  	{data:"ESTADO"},
															  	{data:"NUM_EXPEDICION"},
																{data:function(row, type, val, meta) {                                                                                                                   
                                                                      	//return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                                                                  
                                                                      	
																		if (row.INCIDENCIA_TRANSPORTE=='')
																			{
																			cadena=''
																			}
																		  else
																		  	{
																			cadena='<i class="fa fa-truck" aria-hidden="true"  style="color:red"' +
						  																'data-toggle="popover_datatable"' +
																						'data-placement="left"' + 
																						'data-trigger="hover"' +
																						'data-title="Incidencia de Transporte"' + 
																						'data-content="' + row.INCIDENCIA_TRANSPORTE + '"></i>'
																			}
																		
																		return cadena
                                                                    	}
                                                               		},
																
																{data:function(row, type, val, meta) {                                                                                                                   
                                                                      	//return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                                                                  
                                                                      	
																		if (row.INCIDENCIA_MALETA=='')
																			{
																			cadena=''
																			}
																		  else
																		  	{
																			cadena='<i class="fa fa-suitcase" aria-hidden="true"  style="color:red"' +
						  																'data-toggle="popover_datatable"' +
																						'data-placement="left"' + 
																						'data-trigger="hover"' +
																						'data-title="Incidencia Maleta"' + 
																						'data-content="' + row.INCIDENCIA_MALETA + '"></i>'
																			}
																		
																		return cadena
                                                                    	}
                                                               		},
																{data:function(row, type, val, meta) {                                                                                                                   
                                                                      	//return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                                                                  
                                                                      	
																		if (row.OTRAS_INCIDENCIAS=='')
																			{
																			cadena=''
																			}
																		  else
																		  	{
																			cadena='<i class="fa fa-question" aria-hidden="true"  style="color:red"' +
						  																'data-toggle="popover_datatable"' +
																						'data-placement="left"' + 
																						'data-trigger="hover"' +
																						'data-title="Otras Incidencias"' + 
																						'data-content="' + row.OTRAS_INCIDENCIAS + '"></i>'
																			}
																		
																		return cadena
                                                                    	}
                                                               		},
																{data:"ID", visible:false}
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
                                                   buttons:[{extend:"copy", text:'<i class="fa fa-files-o"></i>', titleAttr:"Copiar en Portapapeles", exportOptions:{columns:[0,1,2,3,4,5,6,7,8]}}, 
                                                             {extend:"excel", text:'<i class="fa fa-file-excel-o"></i>', titleAttr:"Exportar a Formato Excel", title:"Pirs", extension:".xls", exportOptions:{columns:[0,1,2,3,4,5,6,7,8]}}, 
                                                             {extend:"pdf", text:'<i class="fa fa-file-pdf-o"></i>', titleAttr:"Exportar a Formato PDF", title:"Pirs", orientation:"landscape", exportOptions:{columns:[0,1,2,3,4,5,6,7,8]}}, 
                                                             {extend:"print", text:"<i class='fa fa-print'></i>", titleAttr:"Vista Preliminar", title:"Pirs", exportOptions:{columns:[0,1,2,3,4,5,6,7,8]}}
															],
                                                 
													
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
                j$("#lista_pirs tbody").on("click","tr", function() {  
                  if (!j$(this).hasClass("selected") ) {                  
                    lst_pirs.$("tr.selected").removeClass("selected");
                    j$(this).addClass("selected");
                    //var table = j$('#lista_pirs').DataTable();
                    //row_sel = table.row( this ).data();
                  } 
                  //console.log(row_sel);                                                                                                                                                                       
                });

				//gestiona el dobleclick sobre la fila para mostrar la pantalla de detalle del pir
				j$("#lista_pirs").on("dblclick", "tr", function(e) {
				  var row=lst_pirs.row(j$(this).closest("tr")).data(), 
				  regshow = j$(this).index();
				  j$(this).addClass('selected');
				  
				  pagina='detalle_pir.asp'
				  parametro=row.id
				  mostrar_detalle_pir(pagina, parametro);
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