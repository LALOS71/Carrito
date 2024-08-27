<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include virtual="/includes/Idiomas.asp"-->

<%
		if session("usuario_codigo_empresa")<>230 then
			Response.Redirect("../Login_AVORIS_Admin.asp")
		end if
%>
<html>
<head>
<title></title>

	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-select/css/bootstrap-select.min.css">
    <script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>
	<link rel="stylesheet" type="text/css" href="../plugins/datatables/1.10.16/css/dataTables.bootstrap4.min.css"/>
	
	
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
	
	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-multiselect/bootstrap-multiselect.css">



	
	<%'aplicamos un tipo de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	

	
<style>


  
	
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



</head>
<body style="background-color:<%=session("color_asociado_empresa")%>">
<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->
  
  

<!-- contenido pricipal -->
<div class="container-fluid">
	<div class="row mt-1">
		<!--columna izquiderda-->
		<div class="col-xs-12 col-sm-12 col-md-3 col-lg-2 col-xl-2" id="columna_izquierda___">
			<!--DATOS DEL CLIENTE-->
			<div class="row">
				<div class="col-12 m-0 pr-0">
					<div class="card">
						<div class="card-body">
							<div class="card-text">
								<%
								nombre_logo="logo_" & session("usuario_carpeta") & ".png"
								if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
									nombre_logo="Logo_GLS.png"
								end if
								%>
								<div align="center"><img class="img-responsive" src="Images/<%=nombre_logo%>" style="max-height:90px"/></div>
								<br />
								<div align="center">	
								
									<button type="button" id="cmdarticulos" name="cmdarticulos" class="btn btn-primary btn-md"
										data-toggle="popover_datatable"
										data-placement="top"
										data-trigger="hover"
										data-content="Consultar los Artículos Disponibles"										
										data-original-title=""
										><i class="fas fa-th-list fa-lg" aria-hidden="true"></i>&nbsp;&nbsp;Artículos
									</button>
									<button type="button" id="cmdpedidos" name="cmdpedidos" class="btn btn-primary btn-md"
										data-toggle="popover_datatable"
										data-placement="top"
										data-trigger="hover"
										data-content="Consultar los Pedidos Realizados"										
										data-original-title=""
										><i class="fas fa-list-alt fa-lg" aria-hidden="true"></i>&nbsp;&nbsp;Pedidos
									</button>
									
									
								</div>
								<br />
								<div align="center">	
										<button type="button" id="cmdinforme_avoris" name="cmdinforme_avoris" class="btn btn-primary btn-md" 
											data-toggle="popover" 
											data-placement="bottom" 
											data-trigger="hover" 
											data-content="Informe Detallado de Pedidos" 
											data-original-title=""
											><i class="fas fa-clipboard-list fa-lg" aria-hidden="true"></i>&nbsp;&nbsp;Informe Pedidos
										</button>
								</div>
								
								
								
								
							</div>
						
						</div>
					</div>
				</div>
			</div>
			
			
		</div>
		<!-- fin columna izquierda-->
		
		
		<!--columna derecha-->
		<input type="hidden" id="ocultodevolucion_a_imprimir" name="ocultodevolucion_a_imprimir" value="" />
		<input type="hidden" id="ocultonombre_empleado_a_imprimir" name="ocultonombre_empleado_a_imprimir" value="" />
		<input type="hidden" id="ocultoimprimir_devolucion" name="ocultoimprimir_devolucion" value="" />
		<div class="col-xs-12 col-sm-12 col-md-9 col-lg-10 col-xl-10" id="columna_izquierda__">
			<!--articulos con posibilidad de devolucion-->
			<div class="row">
				<div class="col-12 pt-1">
					<div class="card">
						<div class="card-body">
							<h4 class="card-title">Filtros de Búsqueda</h4>
							
							<form class="form-horizontal">
								<div class="container">
									<div class="row">
										<div class="form-group form-group-sm col-sm-6">
											<div class="row">
												<label for="cmbempresas" class="col-sm-3 col-form-label text-right">Empresas:</label>
												<div class="col-sm-9">
													<div id="capa_cadenas">
														<select class="form-control" name="cmbempresas" id="cmbempresas" size="1">
															<option value=""  selected>Seleccionar Empresa</option>
															<option value="10">HALCÓN VIAJES</option>
															<option value="20">VIAJES ECUADOR</option>
															<option value="90">TRAVELPLAN</option>
															<option value="210">MARSOL</option>
															<option value="170">GLOBALIA CORPORATE TRAVEL</option>
															<option value="130">GEOMOON</option>
															<option value="230">AVORIS</option>
															<option value="240">FRANQUICIAS HALCON</option>
															<option value="250">FRANQUICIAS ECUADOR</option>
														</select>
													</div>
												</div>
											</div>
										</div>
										<div class="form-group form-group-sm col-sm-6">
											<div class="row">
												<label for="txtfecha_inicio" class="col-sm-3 col-form-label text-right">Fecha Inicio:</label>
												<div class="col-sm-9">
													<input type="date" class="form-control" name="txtfecha_inicio" id="txtfecha_inicio" value=""> 
												</div>
											</div>
										</div>
										<div class="form-group form-group-sm col-sm-6">
											<div class="row">
												<label for="txtfecha_fin" class="col-sm-3 col-form-label text-right">Fecha Fin:</label>	
												<div class="col-sm-9">
													<input type="date" class="form-control" name="txtfecha_fin" id="txtfecha_fin" value="">
												</div>
											</div>
										</div>
										
										<div class="form-group form-group-sm col-sm-6">
											<div class="row">
												<div class="col-sm-12">	
														<button type="button" id="cmdconsultar_pedidos_detallados" name="cmdconsultar_pedidos_detallados" class="btn btn-primary btn-md float-right">
															<i class="fas fa-search fa-lg" aria-hidden="true"></i>&nbsp;&nbsp;Consultar
														</button>
												</div>
											</div>
										</div>
							
									</div>
							
								</div>
							</form>
							
							
						</div><!--del card body-->
					</div>
				</div>
			</div>
			
			
			<!--detalles de pedidos-->
			<div class="row"> 
				<div class="col-12 pt-3">
					<div class="card col-12">
						<div class="card-body">
							<h4 class="card-title">Pedidos Detallados</h4>
							<table id="lista_pedidos" name="lista_pedidos" class="table table-striped table-bordered" cellspacing="0" width="100%">
							<thead>
								<tr>
									<th>Sucursal</th>
									<th>Pedido</th>
									<th>Fecha</th>
									<th>Ref. Art.</th>
									<th>Artículo</th>
									<th>Cantidad</th>
									<th>Precio</th>
									<th>Total</th>
									<th>Albarán</th>
									<th>Factura</th>
								</tr>
							</thead>
							</table>
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

<script type="text/javascript" src="../plugins/bootbox-4.4.0/bootbox.min.js"></script>

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

<script type="text/javascript" src="../plugins/bootstrap-multiselect/bootstrap-multiselect.js"></script>









<script language="javascript">

$(document).ready(function () {


    $('[data-toggle="popover"]').popover({html:true});   
	
	
	
	//$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'})

});


calcDataTableHeight = function(porcentaje) {
    return $(window).height()*porcentaje/100;
  }; 		


crear_solicitud_devolucion = function() {
	
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
		

	
  };





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




															
																


consultar_pedidos = function() {  
      var err ="";
		
		var prm=new ajaxPrm();
        
		/*
		console.log('pir: ' + $('#txtpir').val())
		console.log('estado: ' + $('#cmbestados').val())
		console.log('expedicion: ' + $('#txtexpedicion').val())
		console.log('fecha inicio orden: ' + $('#txtfecha_inicio_orden').val())
		console.log('fecha fin orden: ' + $('#txtfecha_fin_orden').val())
		console.log('fecha inicio envio: ' + $('#txtfecha_inicio_envio').val())
		console.log('fecha fin envio: ' + $('#txtfecha_fin_envio').val())
		console.log('fecha inicio entrega: ' + $('#txtfecha_inicio_entrega').val())
		console.log('fecha fin entrega: ' + $('#txtfecha_fin_entrega').val())
		*/
		
		
		
		
		
        
		prm.add('p_empresa', $('#cmbempresas').val())
		prm.add('p_fecha_ini', $('#txtfecha_inicio').val())
		prm.add('p_fecha_fin', $('#txtfecha_fin').val())
		
		
		
        $.fn.dataTable.moment('DD/MM/YYYY');
        
        //deseleccioamos el registro de la lista
        $('#lista_pedidos tbody tr').removeClass('selected');
        
        if (typeof lst_pedidos == 'undefined') {
			//console.log('Dentro de la creacion del datatable lst_pirs')
            lst_pedidos = $('#lista_pedidos').DataTable({dom:'Blfrtip',
                                                          ajax:{url:'../tojson/informe_pedidos_avoris_obtener_pedidos.asp?' + prm.toString(),
                                                           type:'POST',
                                                           dataSrc:'ROWSET'},
                                                     order:[],
													 columnDefs: [
                                                              {className: "dt-right", targets: [1,2,5,6,7,8,9]}
															  //,{type: "date-eu", targets: [2]}
                                                            ],
													 columns:[ 
																{data: 'NOMBRE'},
																{data: 'PEDIDO'},
																{data: 'FECHA'},
																{data: 'REFERENCIA'},
																{data: 'ARTICULO'},
																{data: 'CANTIDAD'},
																{data: 'PRECIO_UNIDAD'
																		,render: function (data, type, row, meta) 
																				{
																				if ( type === "display" ) //si se visualiza se formatea
																					{
																					valor=$.fn.dataTable.render.number( '.', ',', 2).display(data.replace(',', '.'))
																					return valor
																					}
																				  else
																					{
																					return data //si no es para visualizar, va sin formatear
																					}	
																				}
																},
																{data: 'TOTAL'
																		,render: function (data, type, row, meta) 
																				{
																				if ( type === "display" ) //si se visualiza se formatea
																					{
																					valor=$.fn.dataTable.render.number( '.', ',', 2).display(data.replace(',', '.'))
																					return valor
																					}
																				  else
																					{
																					return data //si no es para visualizar, va sin formatear
																					}	
																				}
																},
																{data: 'ALBARAN'
																		,render: function (data, type, row, meta) 
																				{
																				if ( type === "display" ) //si se visualiza se formatea
																					{
																					valor='<span onclick="ver_albaran(' + data + ')" style="cursor:pointer"'
																					valor += ' data-toggle="popover_datatable"'
																					valor += ' title="" '
																					valor += ' data-placement="top"'
																					valor += ' data-trigger="hover"'
																					valor += ' data-content="Pulsar Para Ver El Albar&aacute;n">' + data + '</span>'
																					return valor
																					}
																				  else
																					{
																					return data //si no es para visualizar, va sin formatear
																					}	
																				}
																
																},
																
																
																{data: 'FACTURA'
																		,render: function (data, type, row, meta) 
																				{
																				if ( type === "display" ) //si se visualiza se formatea
																					{
																					valor='<span onclick="ver_factura(' + data + ', ' + row.EJERCICIOFACTURA + ')" style="cursor:pointer"'
																					valor += ' data-toggle="popover_datatable"'
																					valor += ' title="" '
																					valor += ' data-placement="top"'
																					valor += ' data-trigger="hover"'
																					valor += ' data-content="Pulsar Para Ver La Factura">' + data + '</span>'
																					return valor
																					}
																				  else
																					{
																					return data //si no es para visualizar, va sin formatear
																					}	
																				}
																},
																{data: 'CODCLI', visible: false},
																{data: 'ESTADO_DETALLE', visible: false},
																{data: 'ESTADO_PEDIDO', visible: false},
																{data: 'EJERCICIOFACTURA', visible: false}
                                                            ],
															
													createdRow: function(row, data, dataIndex){
															
															/*if (parseFloat(data.HOJA_RUTA_SI)>0)
																{
																$(row).css('background-color', '#F5FC64');
																}
															*/
													},
																
													rowId: 'extn', //para que se refresque sin perder filtros ni ordenacion
                                                    deferRender:true,
													scrollY:calcDataTableHeight(32),
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
																		exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9]}}, 
															 {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Pedidos_Detallados", extension:".xls", 
																		exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9],
																						//al exportar a excel no pasa bien los decimales, le quita la coma
																						format: {
																								  body: function(data, row, column, node) {
																									  		data = $('<p>' + data + '</p>').text();
																									  		return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
																								  		}
																								}
															  }}, 
															 {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Pedidos_Detallados", orientation:"landscape",
															 			exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9]}}, 
															 {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Pedidos Detallados", 
																		exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9]}}
															],
															
													drawCallback: function () {
															//para que se configuren los popover-titles...
															$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
															//console.log( 'en el drawCallback del datatable' );
															setTimeout(function() {
																	$("#pantalla_avisos").modal("hide");
															}, (1000));
															/*
															if ($(this).find('tbody tr').length<=1) 
																{
																}
															*/
															
															
														}
                                                    });
													
				//controlamos el click, para seleccionar o desseleccionar la fila
                $("#lista_pedidos tbody").on("click","tr", function()
					{  
                  	if (!$(this).hasClass("selected") ) 
				  		{                  
	                    lst_pedidos.$("tr.selected").removeClass("selected");
    	                $(this).addClass("selected");
        				}            
                });
				
				/*
				$("#lista_pedidos").on("init.dt", function(e, settings, json, xhr) {
					//console.log( 'en el evento init del datatable' );
				});
				  
				$("#lista_pedidos").on("xhr.dt", function(e, settings, json, xhr) {
					//console.log( 'en el evento xhr del datatable' );
				}); 
				  
				$("#lista_pedidos").on("predraw.dt", function(e, settings, json, xhr) {
					//console.log( 'en el evento predraw del datatable' );
				}); 
				  
				$('#lista_pedidos').on( 'draw.dt', function () {
					//console.log( 'en el evento draw del datatable' );
				});
				*/
				
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_pedidos.ajax.url('../tojson/informe_pedidos_avoris_obtener_pedidos.asp?' + prm.toString());
              lst_pedidos.ajax.reload();    
			  //console.log( 'hecho el reload del datatable' );              
            }       
  };		

function monthDiff(d1, d2)
{
	 var months; 
	 months = (d2.getFullYear() - d1.getFullYear()) * 12; 
	 months -= d1.getMonth(); 
	 months += d2.getMonth(); 
	 return months <= 0 ? 0 : months;
 }

Fuente: https://www.iteramos.com/pregunta/52411/diferencia-de-meses-entre-dos-fechas-en-javascript

$("#cmdarticulos").on("click", function () {
	location.href='Lista_Articulos_Gag_Central_Admin.asp'
});

$("#cmdpedidos").on("click", function () {
	location.href='Consulta_Pedidos_Gag_Central_Admin.asp'
});
$("#cmdinforme_avoris").on("click", function () {
	location.href='Informe_Pedidos_Avoris.asp'
});
$("#cmdconsultar_pedidos_detallados").on("click", function () {
	hay_error='NO'
	cadena_error=''
	if ($("#cmbempresas").val()=='')
		{
		cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Seleccionar una Empresa.<br>'
		hay_error='SI'
		}
	if ($("#txtfecha_inicio").val()=='')
		{
		cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Seleccionar una Fecha de Inicio.<br>'
		hay_error='SI'
		}
	if ($("#txtfecha_fin").val()=='')
		{
		cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Seleccionar una Fecha de Fin.<br>'
		hay_error='SI'
		}
		
	if ( ($("#txtfecha_inicio").val()!='') && ($("#txtfecha_fin").val()!='') )
		{
		var date_1 = new Date($("#txtfecha_inicio").val());
		var date_2 = new Date($("#txtfecha_fin").val());
		
		var diff_days = date_2 - date_1;
		//console.log('diferencia dias (milisegundos): ' +  diff_days );
		//console.log('diferencia dias: ' + (diff_days/(1000*60*60*24)) );
		if (diff_days<0)
			{
			cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- La Fecha de Inicio Ha de Ser Anterior a La Fecha de Fin.<br>'
			hay_error='SI'
			}
		  else
		  	{
			/*
			var diff_meses = monthDiff(date_1, date_2);
			//console.log('diferencia meses: ' + diff_meses)
			dias=(diff_days/(1000*60*60*24))
			if (diff_meses>=1)
				{
				if (dias>=31)
					{
					cadena_error=cadena_error + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- La Diferencia de Fechas No Pueden Superar un Mes (31 días).<br>'
					hay_error='SI'
					}
				}
			*/
			}
		}
		
		
	if (hay_error=='SI')
		{
		cadena='<BR><H3>Se Han Encontrado Los Siguientes Errores</H3><BR><H5>' + cadena_error + '</H5>'
		
		bootbox.alert({
				message: cadena,
				size: 'large'
			});
		}
	  else
	  	{
		cadena_aviso='<div align="center"><br><br><img src="../images/loading4.gif"/><br /><br /><h4>Este informe puede tardar en cargarse...<br><br>Espere mientras se carga la página...</h4><br></div>'
		$("#cabecera_pantalla_avisos").html("Avisos")
		$("#pantalla_avisos .modal-header").show()
		$("#body_avisos").html(cadena_aviso + "<br><br>");
		//console.log( 'mostramos pantalla al consultar' );
		$("#pantalla_avisos").modal("show");

		consultar_pedidos()
		}



});





ver_factura = function(factura, ejercicio) {
	//console.log('factura: ' + factura)
	//console.log('ejercicio: ' + ejercicio)
	
	
	$.ajax({
            type: "POST",
            contentType: "application/json; charset=UTF-8",
            async: false,
            url: "../Genfactura/wsGag_1.asmx/ImprimeFactura",
            data: '{idFactura: '+ factura +   
                ', Ejercicio: ' + ejercicio +
            '}',
            dataType: "json",
            success:
                function (data) {
					//alert('Se ha generdo la factura ' + factura);
					var win = window.open('', '_blank');
				    win.location.href = '../GenFactura/informes/Fact_' + factura + '_' + ejercicio + '.pdf';	
					//console.log('antes de elimiar factura')
					
					setTimeout(function() {
							//console.log('eliminamos despues del paron')
						    eliminar_factura(factura, ejercicio)
					}, (3 * 1000));
					
				 },
            error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            },
        });

	
	
}; 

ver_albaran = function(albaran) {
	//console.log('factura: ' + factura)
	//console.log('ejercicio: ' + ejercicio)
	
	
	$.ajax({
            type: "POST",
            contentType: "application/json; charset=UTF-8",
            async: false,
            url: "../Genfactura/wsGag_1.asmx/imprimeAlbaran",
            data: '{idAlbaran: '+ albaran + '}',
            dataType: "json",
            success:
                function (data) {
					//alert('Se ha generdo la factura ' + factura);
					var win = window.open('', '_blank');
				    win.location.href = '../GenFactura/informes/Alb_' + albaran + '.pdf';	
					//console.log('antes de elimiar factura')
					
					setTimeout(function() {
							//console.log('eliminamos despues del paron')
						    eliminar_albaran(albaran)
					}, (3 * 1000));
					
				 },
            error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            },
        });

	
	
}; 


eliminar_albaran = function(albaran) {
	//console.log('factura a borrar: ' + factura)
	//console.log('ejercicio a borrar: ' + ejercicio)
	
	parametros='tipo_fichero=ALBARAN&albaran=' + albaran
		
	  $.ajax({
	  	type: "POST",
		contentType: "application/json; charset=UTF-8",
		async: false,
		url: "../GenFactura/Borrar_Albaran_Factura.asp?" + parametros,
		//data: parametros,
		dataType: "json",
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		
		
		/*
		async: false,
		url:'../GenFactura/Borrar_Factura.asp', //Url a donde la enviaremos
		type:'POST', //Metodo que usaremos
		contentType:false, //Debe estar en false para que pase el objeto sin procesar
		//data:data, //Le pasamos el objeto que creamos con los archivos
		data: '{factura: '+ factura +   
                ', ejercicio: ' + ejercicio +
            '}',
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		cache:false, //Para que el formulario no guarde cache
		*/
        error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            }

	  })
	
	
	
}; 


eliminar_factura = function(factura, ejercicio) {
	//console.log('factura a borrar: ' + factura)
	//console.log('ejercicio a borrar: ' + ejercicio)
	
	parametros='tipo_fichero=FACTURA&factura=' + factura + '&ejercicio=' + ejercicio
		
	  $.ajax({
	  	type: "POST",
		contentType: "application/json; charset=UTF-8",
		async: false,
		url: "../GenFactura/Borrar_Albaran_Factura.asp?" + parametros,
		//data: parametros,
		dataType: "json",
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		
		
		/*
		async: false,
		url:'../GenFactura/Borrar_Factura.asp', //Url a donde la enviaremos
		type:'POST', //Metodo que usaremos
		contentType:false, //Debe estar en false para que pase el objeto sin procesar
		//data:data, //Le pasamos el objeto que creamos con los archivos
		data: '{factura: '+ factura +   
                ', ejercicio: ' + ejercicio +
            '}',
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		cache:false, //Para que el formulario no guarde cache
		*/
        error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            }

	  })
	
	
	
}; 




</script>


</body>
</html>
