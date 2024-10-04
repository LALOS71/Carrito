<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->

<%
	response.Buffer=true
	numero_registros=0

	if session("usuario_admin")="" then
		Response.Redirect("Login_GAGAD.asp")
	end if
		
	'cliente_seleccionado=Request.Form("cmbclientes")
	'estado_seleccionado=Request.Form("cmbestados")
	'empresa_seleccionada=Request.Form("cmbempresas")    
	'numero_pedido_seleccionado=Request.Form("txtpedido")
	'fecha_i=Request.Form("txtfecha_inicio")
	'fecha_f=Request.Form("txtfecha_fin")
	'pedido_automatico_seleccionado=Request.Form("cmbpedidos_automaticos")
	'hoja_ruta_seleccionada=Request.Form("txthoja_ruta")
		
	'orden_clientes=Request.Form("ocultoorden_clientes")
		
		
	
		

'response.write("<br>cadena consulta: " & cadena_consulta)
%>


<html>
<head>


	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	

   
    <!-- Font Awesome JS -->
    <!--
	<script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
	-->
    <script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

	<link rel="stylesheet" href="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min.css">
	
	<link rel="stylesheet" type="text/css" href="plugins/datatables/1.10.16/css/dataTables.bootstrap4.min.css"/>
	
	<!--
	<link rel="stylesheet" type="text/css" href="plugins/datatables/1.10.16/css/dataTables.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/DataTables-1.10.18/css/jquery.dataTables.css"/>
	-->
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/AutoFill-2.3.3/css/autoFill.dataTables.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/Buttons-1.5.6/css/buttons.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/ColReorder-1.5.0/css/colReorder.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/FixedColumns-3.2.5/css/fixedColumns.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/FixedHeader-3.1.4/css/fixedHeader.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/KeyTable-2.5.0/css/keyTable.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/Responsive-2.2.2/css/responsive.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/RowGroup-1.1.0/css/rowGroup.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/RowReorder-1.2.4/css/rowReorder.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/Scroller-2.0.0/css/scroller.dataTables.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/Datatables_4/Select-1.3.0/css/select.dataTables.css"/>
	
	
	 <!-- Our Custom CSS -->
    <link rel="stylesheet" href="style_menu_hamburguesa5.css">


	<link rel="stylesheet"  type="text/css" href="plugins/bootstrap-multiselect/bootstrap-multiselect.css">


<style>
/*estilos para el typeahead del articulo*/
#autocomplete_articulo .typeahead__result .row {
    display: table-row;
}
 
#autocomplete_articulo .typeahead__result .row  > * {
    display: table-cell;
    vertical-align: middle;
}
 
#autocomplete_articulo .typeahead__result .descripcion {
    padding: 0 10px;
}
 
#autocomplete_articulo .typeahead__result .id {
    font-size: 12px;
    color: #777;
    font-variant: small-caps;
}
 
#autocomplete_articulo .typeahead__result .miniatura img {
    height: 100px;
    width: 100px;
}
 
#autocomplete_articulo .typeahead__result .project-logo {
    display: inline-block;
    height: 100px;
}
 
#autocomplete_articulo .typeahead__result .project-logo img {
    height: 100%;
}
 
#autocomplete_articulo .typeahead__result .project-information {
    display: inline-block;
    vertical-align: top;
    padding: 20px 0 0 20px;
}
 
#autocomplete_articulo .typeahead__result .project-information > span {
    display: block;
    margin-bottom: 5px;
}
 
#autocomplete_articulo .typeahead__result > ul > li > a small {
    padding-left: 0px;
    color: #999;
}
 
#autocomplete_articulo .typeahead__result .project-information li {
    font-size: 12px;
}

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
<body>



<div class="wrapper">
	<!--#include file="Menu_Hamburguesa.asp"-->
	
	<!-- Page Content Holder -->
	<div id="content">
		<button type="button" id="sidebarCollapse" class="navbar-btn active">
			<span></span>
			<span></span>
			<span></span>
		</button>
	
	
		<!--********************************************
		contenido de la pagina
		****************************-->
		<div class="container-fluid">
	<div class="row mt-1">
		<!--columna derecha-->
		<input type="hidden" id="ocultodevolucion_a_imprimir" name="ocultodevolucion_a_imprimir" value="">
		<input type="hidden" id="ocultonombre_empleado_a_imprimir" name="ocultonombre_empleado_a_imprimir" value="">
		<input type="hidden" id="ocultoimprimir_devolucion" name="ocultoimprimir_devolucion" value="">
		<div class="col-12">
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
														<option value="">�Tipo?</option>
														<option value="GLS PROPIA">GLS PROPIA</option>
														<option value="AGENCIA">AGENCIA</option>
														<option value="ARRASTRES">ARRASTRES</option>
														
													</select>			
												  </div>
											</div>
										
										</div>
										
										
									</div>
									
									<div class="form-group row">    
										  <div class="col-md-3">
											<input type="text" class="form-control" size="30" name="txtsn_impresora" id="txtsn_impresora" value="" placeholder="N�mero de Serie"
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover" 
													data-content="Filtrar por el N�mero de Serie de La Impresora" 
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
												<option value="PENDIENTE">PENDIENTE ENVIAR</option>
												<option value="PENDIENTE_FIRMA">PENDIENTE FIRMA</option>
												<option value="ACTIVA">ACTIVA</option>
												<option value="DEFECTUOSA">DEFECTUOSA</option>
												<option value="SOLICITUD DEFECTUOSA">SOLICITUD DEFECTUOSA</option>
												<option value="DEVOLUCION">DEVOLUCION</option>
												<option value="BAJA">BAJA</option>
												<option value="AVERIADA">AVERIADA</option>
												<option value="SOLICITUD AVERIADA">SOLICITUD AVERIADA</option>
												<option value="EN REVISION">EN REVISION</option>
												<option value="EN CESION">EN CESION</option>
												<option value="EN REPARACION">EN REPARACION</option>
												<option value="SOLICITUD BAJA">SOLICITUD BAJA</option>
												<option value="BAJA APROBADA">BAJA APROBADA</option>
												<option value="RETIRADA">RETIRADA</option>
											</select>			
										  </div>
										  <div class="col-md-2">
											<input type="text" class="form-control" name="txtpedido" id="txtpedido" value="" placeholder="Pedido"
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover" 
													data-content="Filtrar por el N�mero de Pedido" 
													data-original-title=""
													/>
										  </div>
										  <div class="col-md-2">
											<select id="cmbfacturable" name="cmbfacturable" class="form-control">
												<option value="">�Facturable?</option>
												<option value="SI">SI</option>
												<option value="NO">NO</option>
											</select>			
										  </div>
										  <div class="col-md-1">
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
</div><!--del content-fluid-->
	</div><!--fin de content-->
</div><!--fin de wrapper-->



<form name="frmmostrar_pedido" id="frmmostrar_pedido" action="Pedido_Admin.asp" method="post">
	<input type="hidden" value="" name="ocultopedido" id="ocultopedido" />
</form>





<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
	
<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>
    
<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>



<script type="text/javascript" src="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min_unicode.js"></script>

<script type="text/javascript" src="plugins/Datatables_4/JSZip-2.5.0/jszip.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/pdfmake-0.1.36/pdfmake.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/pdfmake-0.1.36/vfs_fonts.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/DataTables-1.10.18/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/AutoFill-2.3.3/js/dataTables.autoFill.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/Buttons-1.5.6/js/dataTables.buttons.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/Buttons-1.5.6/js/buttons.colVis.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/Buttons-1.5.6/js/buttons.flash.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/Buttons-1.5.6/js/buttons.html5.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/Buttons-1.5.6/js/buttons.print.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/ColReorder-1.5.0/js/dataTables.colReorder.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/FixedColumns-3.2.5/js/dataTables.fixedColumns.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/FixedHeader-3.1.4/js/dataTables.fixedHeader.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/KeyTable-2.5.0/js/dataTables.keyTable.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/Responsive-2.2.2/js/dataTables.responsive.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/RowGroup-1.1.0/js/dataTables.rowGroup.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/RowReorder-1.2.4/js/dataTables.rowReorder.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/Scroller-2.0.0/js/dataTables.scroller.js"></script>
<script type="text/javascript" src="plugins/Datatables_4/Select-1.3.0/js/dataTables.select.js"></script>

<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script>  

<script type="text/javascript" src="plugins/bootstrap-multiselect/bootstrap-multiselect.js"></script>

<script type="text/javascript" src="plugins/bootbox-6.0.0/bootbox.min.js"></script>



<%'cargamos el typeahead
        
	set clientes_typeahead=Server.CreateObject("ADODB.Recordset")
		
	with clientes_typeahead
		.ActiveConnection=connimprenta
		.Source="SELECT ID, NOMBRE, TIPO, NOMBRE + ' (' + TIPO + ')' AS TODO"
		.Source= .Source & " FROM V_CLIENTES"
		.Source= .Source & " WHERE EMPRESA=4"
		.Source= .Source & " AND BORRADO='NO'"
		.Source= .Source & " UNION"
		.Source= .Source & " SELECT 0, 'ALMACEN GAG', NULL, 'ALMACEN GAG'"
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






<script type="text/javascript">

		
$(document).ready(function () {
	$("#menu_pedidos").addClass('active')
	
	$('#sidebarCollapse').on('click', function () {
		$('#sidebar').toggleClass('active');
		$(this).toggleClass('active');
	});
	
	
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
	
	
	
	//para que se configuren los popover-titles...
	$('[data-toggle="popover"]').popover({html:true});
	
	
	
});
		
  
calcDataTableHeight = function(porcentaje) {
    return $(window).height()*porcentaje/100;
  };
	
	
$("#cmbbuscar").on("click", function () {

	mostrar_impresoras()
});

mostrar_impresoras = function (){
	//mostrar_mensaje_espera()
	console.log('cliente seleccionado: ' + $("#ocultocliente_seleccionado").val())
	console.log('sn seleccionada: ' + $("#txtsn_impresora").val())
	
	var dialog = bootbox.dialog({
      message: '<div class="d-flex align-items-center justify-content-center" style="height: 200px;"><h4><i class="fas fa-spinner fa-spin"></i> Cargando datos...</h4></div>',
	  centerVertical: true,
      closeButton: false
    });
	
	datatableReady = false;
	
	cliente_seleccionado = '' + $("#ocultocliente_seleccionado").val()
	tipo_seleccionado = '' + $("#cmbtipo").val()
	sn_seleccionada = '' + $("#txtsn_impresora").val()
	estado_seleccionado = '' + $("#cmbestados").val()
	pedido_seleccionado = '' + $("#txtpedido").val()
	facturable_seleccionado = '' + $("#cmbfacturable").val()
	$.ajax({
        url: "Tabla_Impresoras_GLS_Admin.asp",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        data: { cliente: cliente_seleccionado,
				tipo: tipo_seleccionado,
				sn_imp : sn_seleccionada,
				estado : estado_seleccionado,
				pedido : pedido_seleccionado,
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
			console.log('antes de ocultar')
			
			
			// Verificar si el datatable est� completamente cargado antes de cerrar el bootbox
			  if (datatableReady) {
				dialog.modal('hide');
			  } else {
				// Esperar un momento y verificar nuevamente si el datatable est� listo
				setTimeout(function() {
				  if (datatableReady) {
					dialog.modal('hide');
				  } else {
					// Opcional: Mostrar un mensaje de error o realizar otra acci�n en caso de que el datatable no est� listo despu�s de esperar un tiempo adicional.
				  }
				}, 1000); // Tiempo de espera adicional en milisegundos (ajusta seg�n sea necesario)
			  }
			console.log('despues de olcultar')
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
	if (estado=='BAJA' || estado=='EN REVISION')
		{
		accion=estado
		}
	
	if (accion=='DEFECTUOSA-REEMPLAZO')
		{
		estado='DEFECTUOSA'
		}
	console.log('estado: ' + estado)
	console.log('dentro de realizar accion')
	
	cadena_mensaje=''	
	if (estado=='')
		{
		cadena_mensaje = cadena_mensaje + '<H5>Debe seleccionar una acci�n</H5>'
		}

		
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
		
		if (accion=='EN REVISION')
			{
			mensaje_box = '<br><br><h5>�Seguro que desea ENVIAR A REVISION la Impresora ' + sn_o_pedido + '?</h5>'
			}
			
		if (accion=='BAJA')
			{
			mensaje_box = '<br><br><h5>�Seguro que desea DAR DE BAJA la Impresora ' + sn_o_pedido + '?</h5>'
			}
		
		if (accion=='EN REPARACION')
			{
			mensaje_box = '<br><br><h5>�Seguro que desea ENVIAR A REPARACION la Impresora ' + sn_o_pedido + '?</h5>'
			}
		if (accion=='EN CESION')
			{
			mensaje_box = '<br><br><h5>�Seguro que desea ENVIAR EN CESION la Impresora ' + sn_o_pedido + '?</h5>'
			}
		
		if (accion=='DEFECTUOSA-REEMPLAZO')
			{
			mensaje_box = '<br><br><h5>Se Crear� automaticamente un Pedido con una Impresora Nueva para Reemplazar a la Impresora Defectuosa ' + sn_o_pedido + '</h5>'
			}
			
		bootbox.confirm({
				message: mensaje_box,
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
						lanzar_accion(sn_o_pedido, estado, 'GAG ADMIN', accion)
						}
				}
			});	
		}
	  else
		{
		bootbox.alert({message: cadena_mensaje, closeButton: false});
		}
		
  }; 
		
	
lanzar_accion = function(sn_o_pedido, estado, perfil, accion) {

	$.ajax({
		url: "Modificar_Impresoras_GLS_Admin.asp",
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
					  url: 'plugins/dataTable/lang/Spanish.json',
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
								],
					drawCallback: function () {
									//para que se configuren los popover-titles...
									$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
								}
								
			  })
					  
			  $('#lista_impresoras').on('draw.dt', function () {
					//la nueva impresora no la solicitan por aqui, es como un pedido normal, seleccionando la impresora
				 datatableReady = true;
			  });
			  
			//gestiona el dobleclick sobre el numero de serie de la impresora para mostrar el historico
			$("#lista_impresoras").on("dblclick", "tbody td:nth-child(3)", function(e) {
				
				//var row=lst_impresoras.row($(this).closest("tr")).data() 
				//var sn_impresora=$(this).closest('tr').find('td:eq(2)').text();
				var sn_impresora = lst_impresoras.cell(this).data();
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
									url: "Historico_Impresoras_GLS_Admin.asp",
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
			
			//gestiona el dobleclick sobre el numero de pedido de la impresora para acceder a sus detalles
			$("#lista_impresoras").on("dblclick", "tbody td:nth-child(4)", function(e) {
				var pedido = lst_impresoras.cell(this).data();
				document.getElementById('ocultopedido').value=pedido
			   	document.getElementById('frmmostrar_pedido').submit()
			})
//			}
//		  else //ya existe el objeto datatable
//		  	{
//			lst_impresoras.draw()
//			}			
			
			
}







</script>

</body>
<%
	'articulos.close
	
	connimprenta.close
	
	set articulos=Nothing
	set clientes=Nothing
	set connimprenta=Nothing

%>
</html>
