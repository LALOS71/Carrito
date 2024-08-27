<%@ language=vbscript %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<%
		Response.Buffer = TRUE
		if session("usuario")="" then
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
		end if
		
		
		ver_cadena="" & Request.QueryString("p_vercadena")
		if ver_cadena="" then
			ver_cadena=Request.Form("ocultover_cadena")
		end if
		
		'aqui viene la accion junto con el pedido y la fecha "MODIFICAR--88--fecha--codigo cliente--codigo externo cliente--nombre cliente"
		acciones=Request.QueryString("acciones")
		
		
		if ver_cadena="SI" then
			response.write("<br><br>familia buscada: " & familia_buscada)
			response.write("<br><br>familias buscadas otra: " & familias_buscadas_otra)
		end if
		
		realizar_consulta="SI"
		'como se muestra el listado cuando se entra por primera vez
		
		
		
		

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="UTF-8">
<title>Carrito Imprenta</title>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
	
	


	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-select/css/bootstrap-select.min.css">

	<link rel="stylesheet" type="text/css" href="../estilos.css" />	

	<link rel="stylesheet" type="text/css" href="../plugins/datepicker/css/bootstrap-datepicker.css">

	<script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

	<link rel="stylesheet" href="../plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min.css">

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

	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-touchspin-master/src/jquery.bootstrap-touchspin.css" />




<style>
body {padding-top: 10px; margin:0px; background-color:#fff;}


/*estilos para el typeahead del articulo*/
.autocomplete_txt .typeahead__result .row {
    display: table-row;
}
 
.autocomplete_txt .typeahead__result .row  > * {
    display: table-cell;
    vertical-align: middle;
}
 
.autocomplete_txt .typeahead__result .descripcion {
    padding: 0 10px;
}
 
.autocomplete_txt .typeahead__result .id {
    font-size: 12px;
    color: #777;
    font-variant: small-caps;
}
 
.autocomplete_txt .typeahead__result .miniatura img {
    height: 100px;
    width: 100px;
}
 
.autocomplete_txt .typeahead__result .project-logo {
    display: inline-block;
    height: 100px;
}
 
.autocomplete_txt .typeahead__result .project-logo img {
    height: 100%;
}
 
.autocomplete_txt .typeahead__result .project-information {
    display: inline-block;
    vertical-align: top;
    padding: 20px 0 0 20px;
}
 
.autocomplete_txt .typeahead__result .project-information > span {
    display: block;
    margin-bottom: 5px;
}
 
.autocomplete_txt .typeahead__result > ul > li > a small {
    padding-left: 0px;
    color: #999;
}
 
.autocomplete_txt .typeahead__result .project-information li {
    font-size: 12px;
}

@media screen and (min-width: 725px){
   #columna_izquierda_fija{
       position: fixed;
   }
} 

.panel_conmargen
	{
	padding-left:5px; 
	padding-right:5px; 
	padding-bottom:5px; 
	padding-top:5px;
	}
	
.panel_sinmargen
	{
	padding-left:0px; 
	padding-right:0px; 
	padding-bottom:0px; 
	padding-top:0px;
	}
	
.panel_sinmargen_lados
	{
	padding-left:0px; 
	padding-right:0px; 
	}
	
.panel_sinmargen_arribaabajo
	{
	padding-bottom:0px; 
	padding-top:0px;
	}

.panel_connmargen_lados
	{
	padding-left:5px; 
	padding-right:5px; 
	}
	
.panel_conmargen_arribaabajo
	{
	padding-bottom:5px; 
	padding-top:5px;
	}
	
 //----------------------------------------
		.table th { font-size: 14px; }
		.table td { font-size: 12px; }
		
		.table td.celda_acciones select {font-size: 10px;}
		.table td.celda_acciones {
							  display: flex;
							  align-items: center; /* Centrar elementos verticalmente */
							  justify-content: space-between; /* Espacio entre elementos */
							}

		
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
		/*------------------------------------------*/
		
		#solicitud_impresora_nueva .modal-dialog  {width:90%;}
		
		

</style>
<script src="../funciones.js" type="text/javascript"></script>

<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-selectpicker-1.13.14/js/bootstrap-select-new.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-selectpicker-1.13.14/dist/js/i18n/defaults-es_CL.js"></script>
</head>
<body style="margin-top:0; background-color:<%=session("color_asociado_empresa")%>">

<div class="container-fluid">
	<div class="row mt-1">
		<!--columna izquiderda-->
		<div class="col-xs-12 col-sm-12 col-md-4 col-lg-2 col-xl-2" id="columna_izquierda___">
			<!--DATOS DEL CLIENTE-->
			<div class="row">
				<div class="col-12 m-0 pr-0">
					<div class="card">
						<div class="card-body">
							<div class="row mb-4">
								<%
								nombre_logo="logo_" & session("usuario_carpeta") & ".png"
								if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
									nombre_logo="Logo_GLS.png"
								end if
								%>
								<div class="col-12 text-center"><img class="img-responsive" src="Images/<%=nombre_logo%>" style="max-height:60px"/></div>
							</div>
									<%
									'el perfil de GLS CENTRAL ASM de ASM no tiene que ver los botones
									' solo hacer consultas sobre los articulos
									if session("usuario")<>7054 then%>
										<div class="row mb-3">
											<div class="col-lg-12 text-center">
												<button type="button" id="cmdarticulos" name="cmdarticulos" class="btn btn-primary btn-md w-100"
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover" 
													data-content="Consultar Art&iacute;culos" 
													data-original-title=""
													>
														<i class="far fa-list-alt"></i>
														<span>Art&iacute;culos</span>
												</button>
											</div>
											<div class="col-lg-12 text-center  mt-2">
												<button type="button" id="cmdpedidos" name="cmdpedidos" class="btn btn-primary btn-md w-100" 
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover" 
													data-content="Consultar Pedidos" 
													data-original-title=""
													>
														<i class="fas fa-clipboard"></i>
														<span>Pedidos</span>
												</button>
											</div>				
										</div>
									<%end if%>
									<%'la central de GLS, es la que lleva la gestion de las impresoras
									if session("usuario")=2784 then%>				
										<div class="row mb-3">
											<div class="col-12 text-center">
											  <button type="button" name="cmdimpresoras" id="cmdimpresoras" class="btn btn-primary btn-md w-100">
													<i class="fas fa-print"></i> Gest. Impresoras
											  </button>
											</div>
										</div>
									<%end if%>

						</div>
					</div>
				</div>
			</div>
			
			
			<%'seccion de informes solo para la central de GLS
			if session("usuario")=2784 then%>	
				<div class="row mt-2">
					<div class="col-12 m-0 pr-0">
						<div class="card">
							<div class="card-body">
								<div class="row">
									<div class="col-12 text-center">
										<button type="button" id="cmdinformes_GLS" name="cmdinformes_GLS" class="btn btn-primary btn-md w-100" 
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover" 
												data-content="Informe de Pedidos" 
												data-original-title=""
												>
												<i class="fas fa-clipboard-list"></i>
												<span>Informe Pedidos</span>
										</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			<%end if%>	
			
		</div>
		<!-- fin columna izquierda-->
		
		
		<!--columna derecha-->
		<input type="hidden" id="ocultodevolucion_a_imprimir" name="ocultodevolucion_a_imprimir" value="">
		<input type="hidden" id="ocultonombre_empleado_a_imprimir" name="ocultonombre_empleado_a_imprimir" value="">
		<input type="hidden" id="ocultoimprimir_devolucion" name="ocultoimprimir_devolucion" value="">
		<div class="col-xs-12 col-sm-12 col-md-8 col-lg-10 col-xl-10">
			<div class="row">
				<div class="col-12 mt-0">
					<div class="card">
						<div class="card-body">
								<form class="form-horizontal" role="form" name="frmbusqueda" id="frmbusqueda" method="post" action="----">
									<input type="hidden" id="ocultover_cadena" name="ocultover_cadena" value="<%=ver_cadena%>" />				
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12 col-md-8 col-lg-8">
												<div class="col-12 autocomplete_txt">
													<input type="hidden" name="ocultocliente_seleccionado" id="ocultocliente_seleccionado" value="" />
													<div class="typeahead__container">
														<div class="typeahead__field">
															<div class="typeahead__query">
																<input class="js-typeahead-cliente form-control" name="txtcliente" id="txtcliente" type="search" placeholder="Buscar por Oficina" autocomplete="off" value="">
															</div>
														</div>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-3 col-lg-3">
												<div class="col-12">
													<select id="cmbtipo" name="cmbtipo" class="form-control">
														<option value="">¿Tipo?</option>
														<option value="GLS PROPIA">GLS PROPIA</option>
														<option value="AGENCIA">AGENCIA</option>
														<option value="ARRASTRES">ARRASTRES</option>
														
													</select>			
												  </div>
											</div>
										
										</div>
										
										
									</div>
									
									<div class="form-group row form-inline">    
										  <div class="col-md-4">
											<input type="text" class="form-control" size="30" name="txtsn_impresora" id="txtsn_impresora" value="" placeholder="Número de Serie"
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover" 
													data-content="Filtrar por el Número de Serie de La Impresora" 
													data-original-title=""
													/>
										  </div>
										  
										  <div class="col-md-3">
											<select id="cmbestados" name="cmbestados" class="form-control"
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover" 
													data-content="Filtrar por el Estado en el que se encuentra la impresora" 
													data-original-title=""
													>
												<option value="">Selec. Estado</option>
												<option value="PENDIENTE">PENDIENTE</option>
												<option value="PENDIENTE_FIRMA">PENDIENTE FIRMA</option>
												<option value="ACTIVA">ACTIVA</option>
												<option value="DEFECTUOSA">DEFECTUOSA</option>
												<option value="DEVOLUCION">DEVOLUCION</option>
												<option value="BAJA">BAJA</option>
												<option value="AVERIADA">AVERIADA</option>
												<option value="EN CESION">EN CESION</option>
												<option value="EN REPARACION">EN REPARACION</option>
												<option value="SOLICITUD BAJA">SOLICITUD BAJA</option>
												<option value="EN CESION">EN CESION</option>
												<option value="RETIRADA">RETIRADA</option>
											</select>			
										  </div>
										  <div class="col-md-2">
											<select id="cmbfacturable" name="cmbfacturable" class="form-control">
												<option value="">¿Facturable?</option>
												<option value="SI">SI</option>
												<option value="NO">NO</option>
											</select>			
										  </div>
										  <div class="col-md-2">
											  <button type="button" name="cmbbuscar" id="cmbbuscar" class="btn btn-primary btn-sm">
													<i class="fas fa-search"></i>
													<span>Buscar</span>
											  </button>
											</div>
									  </div>  
								</form>
						</div>
					</div>
				</div>
			</div>
			
			
			<div class="row">
				<div class="col-12 mt-2">
					<div class="card">
						<div class="card-body">
							<div class="col-12" id="detalle" name="detalle"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- fin columna derecha-->
	</div>
</div>


<script type="text/javascript" src="../js/comun.js"></script>

<script type="text/javascript" src="../plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>
	
<script type="text/javascript" src="../plugins/popper/popper-1.14.3.js"></script>
    
<script type="text/javascript" src="../plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>



<script src="../funciones.js" type="text/javascript"></script>


<script type="text/javascript" src="../plugins/iframe_autoheight_2/iframeheight.js"></script>




<script type="text/javascript" src="../plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min_unicode.js"></script>    

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

<script type="text/javascript" src="../plugins/datetime-moment/moment-with-locales.js"></script>
<script type="text/javascript" src="../plugins/datepicker/js/bootstrap-datetimepicker.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-touchspin-master/src/jquery.bootstrap-touchspin.js"></script>

<script type="text/javascript" src="../plugins/bootbox-6.0.0/bootbox.min.js"></script>



<%'cargamos el typeahead
        
	set clientes_typeahead=Server.CreateObject("ADODB.Recordset")
		
	with clientes_typeahead
		.ActiveConnection=connimprenta
		.Source="SELECT ID, NOMBRE, TIPO, NOMBRE + ' (' + TIPO + ')' AS TODO"
		.Source= .Source & " FROM V_CLIENTES"
		.Source= .Source & " WHERE EMPRESA=4"
		.Source= .Source & " AND BORRADO='NO'"
		.Source= .Source & " ORDER BY NOMBRE"
		.Open
	end with

	Response.Write("<script type=""text/javascript"">")
	Response.Write("var searchTags = new Array;" & vbcrlf)
	
	do until clientes_typeahead.eof
		'Response.Write("searchTags.push('" & articulos_typeahead("CODIGO_SAP") & " " & articulos_typeahead("DESCRIPCION") & " (" & articulos_typeahead("ID") & ")" & "');" & vbcrlf)
		cadena_clientes=""
		cadena_clientes=cadena_clientes & "{"
		cadena_clientes=cadena_clientes & "'id': " &  clientes_typeahead("ID") 
		cadena_clientes=cadena_clientes & ", 'nombre': '" & clientes_typeahead("NOMBRE") & "'"
		cadena_clientes=cadena_clientes & ", 'tipo': '" & clientes_typeahead("TIPO") & "'"
		cadena_clientes=cadena_clientes & ", 'todo':  '" & clientes_typeahead("TODO") & "'"
		cadena_clientes=cadena_clientes & "}"
		
		Response.Write("searchTags.push(" & cadena_clientes & ");" & vbcrlf)
		
		clientes_typeahead.movenext
	loop
	Response.Write("</script>")

	clientes_typeahead.close
	set clientes_typeahead=Nothing
%>












<script>
$(document).ready(function() {
	
	//**********************************
	//este control esta en esta url: http://www.runningcoder.org/jquerytypeahead
	$.typeahead({
		input: '.js-typeahead-cliente',
		minLength: 0,
		order: "asc",
		accent: true,
		dynamic: true,
		delay: 500,
		backdrop: {
			"background-color": "#fff",
			"opacity": "0.1",
			"filter": "alpha(opacity=10)"
		},
		template: function (query, item) {
	 
			var color = "#777";
			
			
			//var color = "#ff1493";
			return '<span class="row">' +
				'<span class="descripcion">{{nombre}} <small style="color: ' + color + ';">({{tipo}})</small></span>' +
				'</span>'	
				
			
		},
		emptyTemplate: "sin resultados para {{query}}",
		source: {
			user: {
				//display: "descripcion",
				display: ["nombre", "tipo"],
				data: searchTags
	 
			}
		},
		callback: {
			onClick: function (node, a, item, event) {
	 
				// You can do a simple window.location of the item.href
				//alert(JSON.stringify(item));
				//alert(item.id)
				$("#ocultocliente_seleccionado").val(item.id)
			},
			onCancel: function (node, a, item, event) {
				$("#ocultocliente_seleccionado").val('')
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
	
	
	
	
	$('[data-toggle="popover"]').popover({html:true});
	
	
	
	
	
});



calcDataTableHeight = function(porcentaje) {
    return $(window).height()*porcentaje/100;
  };

$("#cmdarticulos").on("click", function () {
	location.href='Lista_Articulos_Gag_Central_Admin.asp'
});

$("#cmdpedidos").on("click", function () {
	location.href='Consulta_Pedidos_Gag_Central_Admin.asp'
});
$("#cmdimpresoras").on("click", function () {
	location.href='Consulta_Impresoras_GLS_Central_Admin.asp'
});

$("#cmdinformes_GLS").on("click", function () {
	location.href='Consulta_Informes_Gag_Central_Admin.asp'
});

$("#cmdinforme_avoris").on("click", function () {
	location.href='Informe_Pedidos_Avoris.asp'
});


$("#cmbbuscar").on("click", function () {

	mostrar_impresoras()
});

mostrar_impresoras = function (){
	//mostrar_mensaje_espera()
	console.log('cliente seleccionado: ' + $("#ocultocliente_seleccionado").val())
	console.log('sn seleccionada: ' + $("#txtsn_impresora").val())
	
	cliente_seleccionado = '' + $("#ocultocliente_seleccionado").val()
	tipo_seleccionado = '' + $("#cmbtipo").val()
	sn_seleccionada = '' + $("#txtsn_impresora").val()
	estado_seleccionado = '' + $("#cmbestados").val()
	facturable_seleccionado = '' + $("#cmbfacturable").val()
	$.ajax({
        url: "Marco_Impresoras_GLS.asp",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        data: { cliente: cliente_seleccionado,
				tipo: tipo_seleccionado,
				sn_imp : sn_seleccionada,
				estado : estado_seleccionado,
				facturable : facturable_seleccionado
		
		 },
        type: "POST",
        //dataType: "json",
        success: function(data) {
            // Crear las filas de la tabla con los datos de las impresoras
            /*
			var filas = "";
            $.each(data, function(index, impresora) {
                filas += "<tr><td>" + impresora.numero_serie + "</td><td>" + impresora.fecha + "</td><td>" + impresora.estado + "</td></tr>";
            });
			*/

			//rellenamos la tabla con nuevo contenido
            $("#detalle").html(data);

            // Inicializar el datatable
            configurar_datatable()
        },
        error: function(xhr, textStatus, errorThrown) {
            console.log("Error al obtener los datos de las impresoras");
        }
    });
	


}





realizar_accion = function(sn_o_pedido, accion) {
    console.log('numero de serie o pedido: ' + sn_o_pedido)
	console.log('accion: ' + accion)
	
	estado=$("#cmbacciones_" + sn_o_pedido).val()
	console.log('estado: ' + estado)
	console.log('dentro de realizar accion')
	
	cadena_mensaje=''	
	if (estado=='')
		{
		cadena_mensaje = cadena_mensaje + '<H5>Debe seleccionar una acción</H5>'
		}
	  else

		
	console.log('vamos a ver todos los combos')
	cambios_pendientes = 0
	$('.acciones').each(function (index, value) {
		console.log('div' + index + ':' + $(this).attr('id'));
		if ($(this).val()!='') {
			cambios_pendientes++
			console.log('cambios pendientes: ' + cambios_pendientes)
		}
	});

	console.log('cambios pendientes FINAL: ' + cambios_pendientes)
	if (cambios_pendientes > 1) {
		console.log('CAMBIOS PENDIENTES MAYOR QUE 1');
		cadena_mensaje = cadena_mensaje + '<h5>Hay un Cambio Pendiente de Guardar o Cancelar</h5>'
	}
	
	console.log('--------------vemos el estado y los combos cambiado');
	console.log('mensaje: ' + cadena_mensaje)
	if (cadena_mensaje == '')
		{
		
		if (accion=='BORRAR_PEDIDO')
			{
			bootbox.confirm({
					message: '<br><br><h5>¿Seguro que desea ELIMINAR el pedido de Impresoras ' + sn_o_pedido + '?</h5>',
					size: 'large',
					closeButton: false,
					buttons: {
						confirm: {
							label: ' SI ',
							className: 'btn-success'
						},
						cancel: {
							label: ' NO ',
							className: 'btn-danger'
						}
					},
					callback: function (result) {
						//console.log('respuesta a aceptar o rechazar: ' + result);
						if (result)
							{
							lanzar_accion(sn_o_pedido, estado, 'GLS ADMIN', accion)
							}
					}
				});	
			}
		  else
		  	{
			lanzar_accion(sn_o_pedido, estado, 'GLS ADMIN', accion)
			}
		}
	  else
		{
		bootbox.alert({message: cadena_mensaje, closeButton: false});
		}
		
  }; 
		
	
lanzar_accion = function(sn_o_pedido, estado, perfil, accion) {

	$.ajax({
		url: "Modificar_Impresoras_GLS.asp",
		data: { sn_imp : sn_o_pedido,
				estado : estado,
				perfil : perfil,
				accion : accion
		 },
		type: "POST",
		dataType: "json",
		success: function(data) {

			// Inicializar el datatable
			console.log('volvemos de modificar impresoras.... todo correcto')
			console.log('mensaje: ' + data.mensaje)
			console.log('contenido: ' + data.contenido)
			//template strings
			cadena_mensaje_resultado = `<h5>${data.contenido}</h5>`
			bootbox.alert({message: cadena_mensaje_resultado, closeButton: false});
			mostrar_impresoras()
		},
		error: function(xhr, textStatus, errorThrown) {
			console.log("Error al obtener los datos de las impresoras");
		}
	});
}
		

  

configurar_datatable = function() {

//	if (typeof lst_impresoras == 'undefined') {
			$.fn.dataTable.moment('DD/MM/YYYY');
            lst_impresoras = $("#lista_impresoras").DataTable({
					dom: '<"toolbar">Blfrtip',
					language: {
					  url: '../plugins/dataTable/lang/Spanish.json',
					  "decimal": ",",
					  "thousands": "."
					},
					columnDefs: [
					  {className: "dt-right", targets: [3]}
					],
					
					rowId: 'extn',
					deferRender: true,
					scrollY: calcDataTableHeight(50),
					scrollCollapse: true,
					paging: false,
					processing: true,
					searching: true,
					buttons:[{extend:"copy", text:'<i class="far fa-copy"></i>', titleAttr:"Copiar en Portapapeles", 
											exportOptions:{columns:[0,1,2,3,4,5]}}, 
								 {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Impresoras_GLS", extension:".xls", 
											exportOptions:{columns:[0,1,2,3,4,5],
															//al exportar a excel no pasa bien los decimales, le quita la coma
															format: {
																	  body: function(data, row, column, node) {
																				data = $('<p>' + data + '</p>').text();
																				return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
																			}
																	}
								  }}, 
								 {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Impresoras_GLS", //orientation:"landscape"
											exportOptions:{columns:[0,1,2,3,4,5]}}, 
								 {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Impresoras_GLS", 
											exportOptions:{columns:[0,1,2,3,4,5]}}
								]
			  })
					  
			  $('#lista_impresoras').on('draw.dt', function () {
					//la nueva impresora no la solicitan por aqui, es como un pedido normal, seleccionando la impresora
					$('div.toolbar').html('<button id="btnAgregarImpresora" class="btn btn-primary"><i class="fas fa-plus fa-lg" aria-hidden="true"></i>&nbsp;Solicitar Nueva Impresora</button>');
			
					$('#btnAgregarImpresora').click(function() {
					  // Código para agregar impresora
					  // código para crear el typeahead nuevo
					  
							bootbox.dialog({
								className: 'w-100',
								title: "Asignacion de Nueva Impresora",
								message: '<div class="autocomplete_txt" id="solicitud_impresora_nueva"></div>',
								//size: 'large',
								closeButton: false,
								onShown: function() {
									html='<input type="hidden" name="ocultocliente_seleccionado_nuevo" id="ocultocliente_seleccionado_nuevo" value="" />'
									html+='<div class="typeahead__container">'
									html+='<div class="typeahead__field">'
									html+='<div class="typeahead__query">'
									html+='<input class="js-typeahead-cliente_nuevo form-control" name="txtcliente_nuevo" id="txtcliente_nuevo" type="search" placeholder="Buscar por Oficina" autocomplete="off" value="">'
									html+='</div>'
									html+='</div>'
									html+='</div>'
									html+='<div class="col-4 mt-4">'
									html+='<label>Cantidad:</label>'
									html+='<input type="number" class="form-control" id="spin-cantidad" value="1" min="1">'
									html+='</div>'
									html+='</div>'
								
							        $("#solicitud_impresora_nueva").append(html);
									crearTypeahead()
								},
								buttons: {
									cancel: {
										label: '<i class="fa fa-times"></i> Cancelar'
									},
									ok: {
										label: '<i class="fa fa-check"></i> Guardar',
										className: "btn-primary",
										callback: function() {
											var seleccionado = $('#ocultocliente_seleccionado_nuevo').val();
											var cantidad_imp = $('#spin-cantidad').val();
											console.log('oficina: ' + seleccionado)
											console.log('cantidad: ' + cantidad_imp)
											
											if (seleccionado === '' || cantidad_imp === '') {
												console.log('comprobando si se han escrito los text')
												bootbox.alert({message: '<h5>Debe seleccionar una Oficina y especificar una cantidad.</h5>', closeButton: false});
												return false;
											}
											// código para guardar el registro
											$.ajax({
													url: "Crear_Pedido_Impresoras_GLS.asp",
													data: { oficina : seleccionado,
															cantidad : cantidad_imp
													 },
													type: "POST",
													dataType: "json",
													success: function(data) {
											
														// Inicializar el datatable
														console.log('volvemos de crear el pedido.... todo correcto')
														console.log('mensaje: ' + data.mensaje)
														console.log('contenido: ' + data.contenido)
														//template strings
														//controlar si mensaje es de error...
														cadena_mensaje_resultado = `<h5>${data.contenido}</h5>`
														bootbox.alert({message: cadena_mensaje_resultado, closeButton: false});
														mostrar_impresoras()
													},
													error: function(xhr, textStatus, errorThrown) {
														console.log("Error al cear el pedido");
														return false;
													}
												});
											//return false;
										}
									}
								}
							}); //del bootbox.dialog
						
					});
			  });
			  
			//gestiona el dobleclick sobre la fila para mostrar la pantalla del detalle del pedido
			$("#lista_impresoras").on("dblclick", "tr", function(e) {
				var row=lst_impresoras.row($(this).closest("tr")).data() 
				var sn_impresora=$(this).closest('tr').find('td:eq(2)').text();
				console.log('sn_impresora: ' + sn_impresora)
				//parametro_id=row.Id
				//parametro_nreg=row.Nreg
				
				//$(this).addClass('selected');
				//$(this).css('background-color', '#9FAFD1');
			  
				//mostrar_pedido(parametro_id , parametro_nreg)
				
				bootbox.alert({
						className: 'w-100',
						size: 'large',
						title: "Historico de la Impresora " + sn_impresora,
						message: '<div id="historico_impresora"></div>',
						//size: 'large',
						closeButton: false,
						onShown: function() {
							
							
							$.ajax({
									url: "Historico_Impresoras_GLS.asp",
									contentType: "application/x-www-form-urlencoded; charset=UTF-8",
									data: {sn_imp : sn_impresora},
									type: "POST",
									//dataType: "json",
									success: function(data) {
										// Crear las filas de la tabla con los datos de las impresoras
										/*
										var filas = "";
										$.each(data, function(index, impresora) {
											filas += "<tr><td>" + impresora.numero_serie + "</td><td>" + impresora.fecha + "</td><td>" + impresora.estado + "</td></tr>";
										});
										*/
							
										//rellenamos la tabla con nuevo contenido
										//$("#detalle").html(data);
										//html='HISTORICO DE LOS ESTADOS POR LOS QUE VA PASANDO LA IMPRESORA<BR><BR><BR>...EN CONSTRUCCION...'
						
										$("#historico_impresora").append(data);
							
									},
									error: function(xhr, textStatus, errorThrown) {
										console.log("Error al obtener los datos de las impresoras");
									}
								});
							
							
							
						}
				})

			});              
			

//			}
//		  else //ya existe el objeto datatable
//		  	{
//			lst_impresoras.draw()
//			}			
			
			
}



function crearTypeahead() {
    $.typeahead({
        input: '.js-typeahead-cliente_nuevo',

        minLength: 0,
        order: "asc",
        accent: true,
        dynamic: true,
        delay: 500,
        backdrop: {
            "background-color": "#fff",
            "opacity": "0.1",
            "filter": "alpha(opacity=10)"
        },
        template: function (query, item) {
 
            var color = "#777";
 
            return '<span class="row">' +
                '<span class="descripcion">{{nombre}} <small style="color: ' + color + ';">({{tipo}})</small></span>' +
                '</span>'
 
        },
        emptyTemplate: "sin resultados para {{query}}",
        source: {
            user: {
                display: ["nombre", "tipo"],
                data: searchTags
            }
        },
        callback: {
            onClick: function (node, a, item, event) {
                $("#ocultocliente_seleccionado_nuevo").val(item.id)
            },
            onCancel: function (node, a, item, event) {
                $("#ocultocliente_seleccionado_nuevo").val('')
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
}



</script>       


</body>
<%
	
	
	connimprenta.close
			  
	
	
	set connimprenta=Nothing
%>
</html>

