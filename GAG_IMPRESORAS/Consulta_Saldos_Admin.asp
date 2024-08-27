<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->

<%
	response.Buffer=true
	numero_registros=0

	if session("usuario_admin")="" then
		Response.Redirect("Login_Admin.asp")
	end if
		
	

		
'funcion para formatear:' - a 2 decimales,' - con separadores de miles,' - con el 0 delante de valores entre 0 y 1...
Function formatear_importe(importe)
	   if importe<>"" then				
		importe_formateado=FORMATNUMBER(importe,2,-1,,-1)
        
	      else
		importe_formateado=""
	   end if		
		'response.write("<br><br>" & importe_formateado)
		formatear_importe=importe_formateado
End Function

set tipos_saldo=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_TIPO=0
		CAMPO_DESCRIPCION_TIPO=1
		CAMPO_ORDEN_TIPO=2
		with tipos_saldo
			.ActiveConnection=connimprenta
			.Source="SELECT ID, DESCRIPCION, ORDEN"
			.Source= .Source & " FROM SALDOS_TIPOS"
			.Source= .Source & " ORDER BY ORDEN"
			'response.write("<br>FAMILIAS: " & .source)
			.Open
			vacio_tipos_saldo=false
			if not .BOF then
				tabla_tipos_saldo=.GetRows()
			  else
				vacio_tipos_saldo=true
			end if
		end with

		tipos_saldo.close
		set tipos_saldo=Nothing
		
		
	set ordenantes_saldo=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_ORDENANTE=0
		CAMPO_NOMBRE_ORDENANTE=1
		CAMPO_ORDEN_ORDENANTE=2
		with ordenantes_saldo
			.ActiveConnection=connimprenta
			.Source="SELECT ID, NOMBRE, ORDEN"
			.Source= .Source & " FROM SALDOS_ORDENANTES"
			.Source= .Source & " ORDER BY ORDEN"
			'response.write("<br>FAMILIAS: " & .source)
			.Open
			vacio_ordenantes_saldo=false
			if not .BOF then
				tabla_ordenantes_saldo=.GetRows()
			  else
				vacio_ordenantes_saldo=true
			end if
		end with

		ordenantes_saldo.close
		set ordenantes_saldo=Nothing		

'response.write("<br>cadena consulta: " & cadena_consulta)
%>


<html>
<head>


	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-5.1.3/css/bootstrap.min.css">
	
	<link rel="stylesheet" type="text/css" href="plugins/datatables/1.10.16/css/dataTables.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/datatables/autofill/2.2.2/css/autoFill.bootstrap4.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/datatables/buttons/1.5.1/css/buttons.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/datatables/colreorder/1.4.1/css/colReorder.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/datatables/fixedcolumns/3.2.4/css/fixedColumns.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/datatables/fixedheader/3.1.3/css/fixedHeader.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/datatables/keytable/2.3.2/css/keyTable.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/datatables/responsive/2.2.1/css/responsive.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/datatables/rowgroup/1.0.2/css/rowGroup.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/datatables/rowreorder/1.2.3/css/rowReorder.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/datatables/scroller/1.4.4/css/scroller.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="plugins/datatables/select/1.2.5/css/select.bootstrap4.min.css"/>
	
	
	
	
	
	<link rel="stylesheet" href="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min.css">
	

   
    <!-- Font Awesome JS -->
    <!--
	<script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
	-->
    <script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

	
	 <!-- Our Custom CSS -->
    <link rel="stylesheet" href="style_menu_hamburguesa5.css">



<script language="javascript" src="Funciones_Ajax.js"></script>

<style>

#dialog_detalles_devolucion .modal-dialog  {width:98%;}



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
		
		
		
//estilos del tipeahead
.typeahead__list {
    max-height: 400px;
    overflow-y: auto;
    overflow-x: hidden;
}

.typeahead__list li a {
    position: relative;
}
 
.result-container {
    position: absolute;
    color: #777;
    top: -1.5em;
}	
	
.typeahead__result .row {
    display: table-row;
}
 
.typeahead__result .row  > * {
    display: table-cell;
    vertical-align: middle;
}
 
.typeahead__result .empleado {
    padding: 0 10px;
	font-size: 13px;
}

 
 
.typeahead__field {
    padding: 0 10px;
	font-size: 13px;
}

.typeahead__empty {
    padding: 0 10px;
	font-size: 13px;
}
 
.typeahead__result > ul > li > a small {
    padding-left: 0px;
    color: #999;
}
//-----------------------------

.popover {
  max-width: 700px !important;
}
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
			<div class="row">
				<div class="card col-12">
					<div class="card-body">
						<form name="frmconsulta_devoluciones" action="Consulta_Devoluciones_Admin.asp" method="post">
						<h5 class="card-title">Opciones de B&uacute;squeda de Saldos</h5>
						<!--primera linea-->
						<div class="form-group row mt-3 align-items-end">
							<div class="col-sm-12 col-md-8 col-lg-6">
								<label for="cmbclientes" class="control-label">Cliente</label>
								<input type="hidden" id="ocultoid_cliente" name="ocultoid_cliente" value="" />
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input class="js-typeahead-cliente form-control" name="txtbuscar_cliente" id="txtbuscar_cliente" type="search" placeholder="Buscar Cliente (Por Código o Descripción)" autocomplete="off">
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-2 col-lg-2">
								<label for="txtsaldo" class="control-label">Num. Saldo</label>
								<input type="text" class="form-control" name="txtsaldo" id="txtsaldo"  value="<%=numero_devolucion_seleccionada%>" /> 
							</div>
							<div class="col-sm-4 col-md-2 col-lg-2">
								<button type="button" class="btn btn-primary btn-block" id="cmdconsultar" name="cmdconsultar"
									data-bs-toggle="popover"
									data-bs-placement="top"
									data-bs-trigger="hover"
									data-bs-content="Consultar Saldos"
									title=""
									>
									<i class="fas fa-search"></i>&nbsp;&nbsp;&nbsp;Buscar
								</button>
							</div>
							<div class="col-sm-4 col-md-2 col-lg-2">
							
								<button type="button" class="btn btn-primary btn-block" id="cmdannadir_saldo" name="cmdannadir_saldo"
									data-bs-toggle="popover"
									data-bs-placement="top"
									data-bs-trigger="hover"
									data-bs-content="Añadir un Nuevo Saldo"
									title=""
									>
									<i class="fas fa-plus"></i>&nbsp;&nbsp;&nbsp;Añadir
								</button>
							</div>
						</div>
						
						<!--segunda linea-->
						<div class="form-group row mt-3 align-items-end">
							<div class="col-sm-12 col-md-3 col-lg-3">
								<label for="cmbordenante" class="control-label">Realizado Por</label>
								<select class="form-select" name="cmbordenante" id="cmbordenante">
										<option value="" selected>* Seleccione *</option>
										<%if not vacio_ordenantes_saldo then
											For i = 0 to UBound(tabla_ordenantes_saldo, 2)%>
												<option value="<%=tabla_ordenantes_saldo(CAMPO_ID_ORDENANTE, i)%>"><%=tabla_ordenantes_saldo(CAMPO_NOMBRE_ORDENANTE, i)%></option>
											<%next
										end if%>
								</select>
							</div>
							<div class="col-sm-12 col-md-3 col-lg-3">
								<label for="cmbtipo_saldo" class="control-label">Tipo Saldo</label>
								<select class="form-select" name="cmbtipo_saldo" id="cmbtipo_saldo">
										<option value="" selected>* Seleccione *</option>
										<%if not vacio_tipos_saldo then
											For i = 0 to UBound(tabla_tipos_saldo, 2)%>
												<option value="<%=tabla_tipos_saldo(CAMPO_ID_TIPO, i)%>"><%=tabla_tipos_saldo(CAMPO_DESCRIPCION_TIPO, i)%></option>
											<%next
										end if%>
								</select>
							</div>
							<div class="col-sm-12 col-md-3 col-lg-2">
								<label for="cmbcargo_abono" class="control-label">Cargo o Abono</label>
								<select class="form-select" name="cmbcargo_abono" id="cmbcargo_abono">
										<option value="" selected>* Seleccione *</option>
										<option value="ABONO">ABONO</option>
										<option value="CARGO">CARGO</option>
								</select>
							</div>
							<div class="col-sm-12 col-md-3 col-lg-2">
								<label for="txtfecha_inicio" class="control-label">Fecha de Inicio</label>
								<input type="date" class="form-control" name="txtfecha_inicio" id="txtfecha_inicio"  value="<%=fecha_i%>" /> 
							</div>
							<div class="col-sm-123 col-md-3 col-lg-2">
								<label for="txtfecha_fin" class="control-label">Fecha Fin</label>
								<input type="date" class="form-control" name="txtfecha_fin" id="txtfecha_fin"  value="<%=fecha_f%>" /> 
							</div>
							
						</div>
						
						
						
						<!--tercera linea-->						
						<div class="form-group row mx-2">
							
						</div>
						
						</form>
					</div><!--del card-body-->
				</div><!--del card-->
			</div><!--del row-->
			
			<div class="row mt-2"><!--nueva linea con la tabla de resultados-->
				<div class="card col-12">
					<div class="card-body">
						<table id="lista_saldos" name="lista_saldos" class="table table-striped table-bordered" cellspacing="0" width="100%">
							<thead>
								<tr>
									<th>Cod. Saldo</th>
									<th>Cliente</th>
									<th>Fecha</th>
									<th>Importe</th>
									<th>Ordenante</th>
									<th>Tipo</th>
									<th>Cargo / Abono</th>
									<th>Observaciones</th>
									<th>Importe Disfrutado</th>
								</tr>
					  		</thead>
						</table>
					</div>
				</div>				
				
				

			</div><!-- row de resultados-->
						
		</div><!--del content-fluid-->
	</div><!--fin de content-->
</div><!--fin de wrapper-->








<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>


<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>
<script type="text/javascript" src="plugins/bootstrap-5.1.3/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript" src="plugins/cloudflare/ajax/libs/jszip/2.5.0/jszip.min.js"></script>
<script type="text/javascript" src="plugins/cloudflare/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script type="text/javascript" src="plugins/cloudflare/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script type="text/javascript" src="plugins/datatables/1.10.16/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="plugins/datatables/1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script type="text/javascript" src="plugins/datatables/autofill/2.2.2/js/dataTables.autoFill.min.js"></script>
<script type="text/javascript" src="plugins/datatables/autofill/2.2.2/js/autoFill.bootstrap4.min.js"></script>
<script type="text/javascript" src="plugins/datatables/buttons/1.5.1/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="plugins/datatables/buttons/1.5.1/js/buttons.bootstrap4.min.js"></script>
<script type="text/javascript" src="plugins/datatables/buttons/1.5.1/js/buttons.colVis.min.js"></script>
<script type="text/javascript" src="plugins/datatables/buttons/1.5.1/js/buttons.flash.min.js"></script>
<script type="text/javascript" src="plugins/datatables/buttons/1.5.1/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="plugins/datatables/buttons/1.5.1/js/buttons.print.min.js"></script>
<script type="text/javascript" src="plugins/datatables/colreorder/1.4.1/js/dataTables.colReorder.min.js"></script>
<script type="text/javascript" src="plugins/datatables/fixedcolumns/3.2.4/js/dataTables.fixedColumns.min.js"></script>
<script type="text/javascript" src="plugins/datatables/fixedheader/3.1.3/js/dataTables.fixedHeader.min.js"></script>
<script type="text/javascript" src="plugins/datatables/keytable/2.3.2/js/dataTables.keyTable.min.js"></script>
<script type="text/javascript" src="plugins/datatables/responsive/2.2.1/js/dataTables.responsive.min.js"></script>
<script type="text/javascript" src="plugins/datatables/responsive/2.2.1/js/responsive.bootstrap4.min.js"></script>
<script type="text/javascript" src="plugins/datatables/rowgroup/1.0.2/js/dataTables.rowGroup.min.js"></script>
<script type="text/javascript" src="plugins/datatables/rowreorder/1.2.3/js/dataTables.rowReorder.min.js"></script>
<script type="text/javascript" src="plugins/datatables/scroller/1.4.4/js/dataTables.scroller.min.js"></script>
<script type="text/javascript" src="plugins/datatables/select/1.2.5/js/dataTables.select.min.js"></script>

<script type="text/javascript" src="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min_unicode.js"></script>
<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script> 
<script type="text/javascript" src="plugins/bootbox-5.5.2/bootbox.min.js"></script>



<script>
<%
	set clientes_typeahead=Server.CreateObject("ADODB.Recordset")
		
	with clientes_typeahead
		.ActiveConnection=connimprenta
		.Source="SELECT CAST(V_CLIENTES.ID AS NVARCHAR(10)) + ' - ' + V_CLIENTES.NOMBRE TODO,"
		.Source=.Source & " V_CLIENTES.ID, V_CLIENTES.NOMBRE"
		.Source=.Source & " FROM V_CLIENTES"
		.Source=.Source & " WHERE V_CLIENTES.EMPRESA=4"
		.Source=.Source & " AND V_CLIENTES.TIPO<> 'GLS PROPIA'"
		.Source=.Source & " ORDER BY V_CLIENTES.NOMBRE"
		.Open
	end with

	Response.Write("var searchTags = new Array;" & vbcrlf)
	
	do until clientes_typeahead.eof
		'Response.Write("searchTags.push('" & articulos_typeahead("CODIGO_SAP") & " " & articulos_typeahead("DESCRIPCION") & " (" & articulos_typeahead("ID") & ")" & "');" & vbcrlf)
		cadena_clientes=""
		cadena_clientes=cadena_clientes & "{"
		cadena_clientes=cadena_clientes & "'ID': " &  clientes_typeahead("ID") 
		cadena_clientes=cadena_clientes & ", 'NOMBRE': '" & clientes_typeahead("NOMBRE") & "'"
		cadena_clientes=cadena_clientes & ", 'TODO':  '" & clientes_typeahead("TODO") & "'"
		cadena_clientes=cadena_clientes & "}"
		
		Response.Write("searchTags.push(" & cadena_clientes & ");" & vbcrlf)
		
		clientes_typeahead.movenext
	loop
	
	clientes_typeahead.close
	set clientes_typeahead=Nothing
%>
</script>

<script type="text/javascript">
var j$=jQuery.noConflict();
		
j$(document).ready(function () {

	j$("#menu_saldos").addClass('active')
	
	j$('#sidebarCollapse').on('click', function () {
		j$('#sidebar').toggleClass('active');
		j$(this).toggleClass('active');
	});
	
	//para que se configuren los popover-titles...
	//j$('[data-toggle="popover"]').popover({html:true});
	//var popover = new bootstrap.Popover(document.querySelector('.popover'), {html:true})
	var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
	var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
	  return new bootstrap.Popover(popoverTriggerEl, {html:true})
	})
	
	cargar_typeahead('txtbuscar_cliente')
	
	

	
			
	
});





		
cargar_typeahead = function(elemento) {
//**********************************
	//este control esta en esta url: http://www.runningcoder.org/jquerytypeahead
	j$.typeahead({
	
		
		//input: '.js-typeahead-cliente',
		input: '#' + elemento,

		minLength: 1,
		maxItem: 0,
		order: "asc",
		dynamic: true,
		hint: true,
		accent: true,
		delay: 500,
		backdrop: {
			"background-color": "#fff",
			"opacity": "0.1",
			"filter": "alpha(opacity=10)"
		},
	
		template: function (query, item) {
	 
			var color = "#777";
	 
			return '<span class="row">' +
				'<span class="cliente">{{ID}} <small style="color: ' + color + ';"> - {{NOMBRE}}</small></span>' + 
			"</span>"
		},
		emptyTemplate: "no hay resultados para {{query}}",
		source: {
			user: {
				display: ["TODO"],
				//display: "TODO",
				data: searchTags
				
	 
			}
			
		},
		
		
		callback: {
			onClick: function (node, a, item, event) {
				// You can do a simple window.location of the item.href
				//console.log(JSON.stringify(item))
				//alert(JSON.stringify(item));
				if (elemento=='txtnuevo_saldo_buscar_cliente')
					{
					j$("#ocultonuevo_saldo_id_cliente").val(item.ID)
					}
				  else
				  	{
					j$("#ocultoid_cliente").val(item.ID)
					}
				
			},
			onCancel: function (node, event) {
				//j$("#ocultoid_cliente").val('')
				if (elemento=='txtnuevo_saldo_buscar_cliente')
					{
					j$("#ocultonuevo_saldo_id_cliente").val('')
					}
				  else
				  	{
					j$("#ocultoid_cliente").val('')
					}

				
			},
			onSendRequest: function (node, query) {
				//console.log('request is sent')
			},
			onReceiveRequest: function (node, query) {
				//console.log('request is received')
			}
		},
		debug: true
	});
	//-------------fin del typeahead

}


j$("#cmdconsultar").click(function () {
	consultar_saldos();
});
		
j$("#txtsaldo").keypress(function(e) {
        var code = (e.keyCode ? e.keyCode : e.which);
        if(code==13){
            consultar_devoluciones();
        }
    });
		
		
	

			
j$("#cmdannadir_saldo").click(function () {
	cadena_mensaje=''
	cadena_mensaje='<div class="container">'
	cadena_mensaje+='<div class="row">'
	cadena_mensaje+='<h5 class="text-center">Nuevo Saldo</h5>'
	cadena_mensaje+='</div>'
	
	cadena_mensaje+='<div class="row mt-3">'
	cadena_mensaje+='<div class="col-sm-12 col-md-10 col-lg-6">'
	cadena_mensaje+='<input type="hidden" id="ocultonuevo_saldo_id_cliente" name="ocultonuevo_saldo_id_cliente" value="" />'
	cadena_mensaje+='<label for="txtnuevo_saldo_buscar_cliente" class="control-label">Cliente</label>'
	cadena_mensaje+='<div class="typeahead__container">'
	cadena_mensaje+='<div class="typeahead__field">'
	cadena_mensaje+='<div class="typeahead__query">'
	cadena_mensaje+='<input class="js-typeahead-cliente form-control" name="txtnuevo_saldo_buscar_cliente" id="txtnuevo_saldo_buscar_cliente" type="search" placeholder="Buscar Cliente (Por Código o Descripción)" autocomplete="off">'
	cadena_mensaje+='</div>'
	cadena_mensaje+='</div>'
	cadena_mensaje+='</div>'
	cadena_mensaje+='</div>'
	cadena_mensaje+='<div class="col-sm-12 col-md-6 col-lg-2">'
	cadena_mensaje+='<label for="txtnuevo_saldo_fecha" class="control-label">Fecha</label>'
	cadena_mensaje+='<input type="date" class="form-control" name="txtnuevo_saldo_fecha" id="txtnuevo_saldo_fecha" />'
	cadena_mensaje+='</div>'
	cadena_mensaje+='<div class="col-sm-12 col-md-4 col-lg-2 popo">'
	cadena_mensaje+='<label for="txtnuevo_saldo_importe" class="control-label">Importe</label>'
	cadena_mensaje+='<input type="text" class="form-control" name="txtnuevo_saldo_importe" id="txtnuevo_saldo_importe"  value=""'
	cadena_mensaje+=' data-bs-toggle="popover_saldo" data-bs-placement="bottom" data-bs-trigger="hover"'
	cadena_mensaje+=' data-bs-content="Introducir el Valor sin Signo, Indicar si es \'Cargo\' o \'Abono\' utilizando el Campo Correspondiente" title="" />'
	cadena_mensaje+='</div>'
	cadena_mensaje+='</div>'
	
	cadena_mensaje+='<div class="row mt-3">'
	cadena_mensaje+='<div class="col-sm-12 col-md-3 col-lg-3">'
	cadena_mensaje+='<label for="cmbnuevo_saldo_ordenante" class="control-label">Realizado Por</label>'
	cadena_mensaje+='<select class="form-select" name="cmbnuevo_saldo_ordenante" id="cmbnuevo_saldo_ordenante">'
	cadena_mensaje+='<option value="" selected>* Seleccione *</option>'
	cadena_mensaje+='</select>'
	cadena_mensaje+='</div>'
	cadena_mensaje+='<div class="col-sm-12 col-md-3 col-lg-3">'
	cadena_mensaje+='<label for="cmbnuevo_saldo_tipo_saldo" class="control-label">Tipo Saldo</label>'
	cadena_mensaje+='<select class="form-select" name="cmbnuevo_saldo_tipo_saldo" id="cmbnuevo_saldo_tipo_saldo">'
	cadena_mensaje+='</select>'
	cadena_mensaje+='</div>'
	cadena_mensaje+='<div class="col-sm-12 col-md-3 col-lg-3">'
	cadena_mensaje+='<label for="cmbnuevo_saldo_cargo_abono" class="control-label">Cargo o Abono</label>'
	cadena_mensaje+='<select class="form-select" name="cmbnuevo_saldo_cargo_abono" id="cmbnuevo_saldo_cargo_abono"'
	cadena_mensaje+=' data-bs-toggle="popover_saldo" data-bs-placement="bottom" data-bs-trigger="hover"'
	cadena_mensaje+=' data-bs-content="(ABONO)... Saldo a Favor del Cliente.<br>(CARGO)... Saldo a Favor de GAG." title="">'
	cadena_mensaje+='<option value="" selected>* Seleccione *</option>'
	cadena_mensaje+='<option value="ABONO">ABONO</option>'
	cadena_mensaje+='<option value="CARGO">CARGO</option>'
	cadena_mensaje+='</select>'
	cadena_mensaje+='</div>'
	cadena_mensaje+='</div>'
	
	cadena_mensaje+='<div class="row mt-3">'
	cadena_mensaje+='<div class="col-12">'
	cadena_mensaje+='<label for="txtnuevo_saldo_observaciones" class="control-label">Observaciones</label>'
	cadena_mensaje+='<input type="text" class="form-control" name="txtnuevo_saldo_observaciones" id="txtnuevo_saldo_observaciones"  value="" />'
	cadena_mensaje+='</div>'
	cadena_mensaje+='</div>'
	
	
	cadena_mensaje+='</div>'
	
	
	bootbox.confirm({
		size: 'xl',
		message: cadena_mensaje,
		closeButton: false,
		//centerVertical: true,
		onShow: function(e) {
        	/* e is the show.bs.modal event */
			//no se ve bien el boton de cerrar la venta bootbox con bootstrap 5
			//j$(".bootbox-close-button").hide()
			//j$("#txtbuscar_cliente").val('')
			cargar_typeahead('txtnuevo_saldo_buscar_cliente')
			j$('#cmbnuevo_saldo_ordenante').html(j$('#cmbordenante').html());
			j$('#cmbnuevo_saldo_tipo_saldo').html(j$('#cmbtipo_saldo').html());
			//inicializamos el popover de la pantalla de saldos
			var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover_saldo"]'))
			var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
			  return new bootstrap.Popover(popoverTriggerEl, {html:true, container:'body'})
			})
			
			var myPopoverTrigger = document.getElementById('txtnuevo_saldo_importe')
			myPopoverTrigger.addEventListener('shown.bs.popover', function () {
			  //console.log('holaaaa')
			  //return j$(this).data("bs.popover").tip().css({maxWidth: "700px"});
			})
			
			
    	}, 
		buttons: {
			confirm: {
				label: '<i class="fas fa-save"></i> GUARDAR',
				className: 'btn-success'
			},
			cancel: {
				label: '<i class="fas fa-times"></i> CANCELAR',
				className: 'btn-danger',
			}
		},
		callback: function (result) {
			//console.log('This was logged in the callback: ' + result);
			if (result)
				{
				//console.log('entro en guardar saldo');
				var cadena_error=comprobar_datos_saldo()
						
				if (cadena_error!='')
					{
					bootbox.alert({
							size: 'large',
							closeButton: false,
							centerVertical: true,
							message: '<h3>Se Han Encontrado Los Siguientes Errores</h3><br><br><h5>' + cadena_error + '</h5><br>'
							//callback: function () {return false;}
						});
					return false
					
					}
				  else
					{
					cadena_texto='<br><b>Cliente:</b> ' + j$("#txtnuevo_saldo_buscar_cliente").val()
					cadena_texto += '<br><b>Fecha:</b> ' + j$("#txtnuevo_saldo_fecha").val()
					cadena_texto += '<br><b>Importe:</b> ' + j$("#txtnuevo_saldo_importe").val()
					cadena_texto += '<br><b>Realizado por:</b> ' + j$("#cmbnuevo_saldo_ordenante option:selected").text()
					cadena_texto += '<br><b>Tipo:</b> ' + j$("#cmbnuevo_saldo_tipo_saldo option:selected").text()
					cadena_texto += '<br><b>Cargo o Abono:</b> ' + j$("#cmbnuevo_saldo_cargo_abono").val()
					cadena_texto += '<br><b>Observaciones:</b> ' + j$("#txtnuevo_saldo_observaciones").val()
					bootbox.confirm({
						size: 'large',
						title: "Confirmación",
						closeButton: false,
						centerVertical: true,
						message: "<h5>¿Está seguro que desea guardar el saldo con la siguiente información?</h5>" + cadena_texto + "<br><br>",
						buttons: {
							cancel: {
								label: '<i class="fa fa-times"></i> Cancelar'
							},
							confirm: {
								label: '<i class="fa fa-check"></i> Confirmar'
							}
						},
						callback: function (result) {
							//console.log('This was logged in the callback: ' + result);
							if (result)
								{
								guardar_saldo()
								//return false //con return false no ocultaria la pregunta de si desea guardar el saldo 
								}
						}
					});
					
					return false
					
					}
			

				
				}
		}
	});
							
							
							
							
});


comprobar_datos_saldo = function(){
	cadena_error=''
	if (j$("#txtnuevo_saldo_buscar_cliente").val()=='')
		{
		cadena_error=cadena_error + '- Debe Seleccionar el Cliente de Saldo.<br>'
		}
		
	if (j$("#txtnuevo_saldo_fecha").val()=='')
		{
		cadena_error=cadena_error + '- Debe Indicar una Fecha.<br>'
		}

	if (j$("#txtnuevo_saldo_importe").val()=='')
		{
		cadena_error=cadena_error + '- Debe Introducir el Importe del Saldo.<br>'
		}
	  else
	  	{
		if (!j$.isNumeric(j$("#txtnuevo_saldo_importe").val().replace(',', '.'))) 
			{
    		cadena_error=cadena_error + '- El Importe del Saldo Ha De Ser Numérico.<br>'
			}	
		  else
		  	{
			if (parseFloat(j$("#txtnuevo_saldo_importe").val().replace(',', '.')) <= 0) 
				{
				cadena_error=cadena_error + '- El Importe del Saldo Ha De Ser Numérico Positivo.<br>'
				}
			}	
		}

	if (j$("#cmbnuevo_saldo_ordenante").val()=='')
		{
		cadena_error=cadena_error + '- Debe Seleccionar Quien Realiza el Saldo.<br>'
		}
		
	if (j$("#cmbnuevo_saldo_tipo_saldo").val()=='')
		{
		cadena_error=cadena_error + '- Debe Seleccionar El Tipo de Saldo.<br>'
		}
		
	if (j$("#cmbnuevo_saldo_cargo_abono").val()=='')
		{
		cadena_error=cadena_error + '- Debe Seleccionar Si es Un Cargo o Un Abono.<br>'
		}
		
	if (j$("#txtnuevo_saldo_observaciones").val()=='')
		{
		cadena_error=cadena_error + '- Debe Introducir unas Observaciones.<br>'
		}

	return cadena_error;

}

guardar_saldo = function(codigo) {
	//console.log('dentro de guardar saldo')

	j$.ajax({
		type: 'POST',
		url: 'Guardar_Saldo.asp',
		data: {
			codigo_cliente: j$("#ocultonuevo_saldo_id_cliente").val(),
			fecha: j$("#txtnuevo_saldo_fecha").val(),
			importe: j$("#txtnuevo_saldo_importe").val(),
			ordenante: j$("#cmbnuevo_saldo_ordenante").val(),
			tipo: j$("#cmbnuevo_saldo_tipo_saldo").val(),
			cargo_abono: j$("#cmbnuevo_saldo_cargo_abono").val(),
			observaciones: j$("#txtnuevo_saldo_observaciones").val()
		},
		dataType: 'json',
		success:
			function (data) {
				//console.log('lo devuelto por data: ' + data)
				//console.log('resultado: ' + data.resultado)
				
				switch (data.resultado) {
					case 'ALTA_OK':  
						bootbox.alert({
								//size: 'large',
								 closeButton: false
								, centerVertical: true
								, message: '<h3>Saldo Creado Con Exito...</h3><br><br>'
								, callback: function () {
											j$("#ocultonuevo_saldo_id_cliente").val('')
											j$("#txtnuevo_saldo_buscar_cliente").val('')
											j$("#txtnuevo_saldo_fecha").val('')
											j$("#txtnuevo_saldo_importe").val('')
											j$("#cmbnuevo_saldo_ordenante").val('')
											j$("#cmbnuevo_saldo_tipo_saldo").val('')
											j$("#cmbnuevo_saldo_cargo_abono").val('')
											j$("#txtnuevo_saldo_observaciones").val('')
											consultar_saldos()
											//location.href='Gestionar_Empleados_GLS_Central.asp'
											bootbox.hideAll()
											}
							});  
						
						break;
						
					default: 
						cadena = '<h3>Se Ha Producido un error...</h3>';
						cadena = cadena + '<br><br>' + data;
						bootbox.alert({
								//size: 'large',
								message: cadena
								, centerVertical: true
								//callback: function () {return false;}
							}); 
						
						break;
				}
		
			},
		error:
			function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
		});
	
}; 		


eliminar_saldo = function(codigo) {
	//console.log('dentro de eliminar saldo')

	j$.ajax({
		type: 'POST',
		url: 'Eliminar_Saldo.asp',
		data: {
			id_saldo: codigo
		},
		dataType: 'json',
		success:
			function (data) {
				//console.log('contenido de data: ' + data)
				switch (data.resultado) {
					case 'BAJA_OK':  
						//console.log('dentro de opcion baja ok')
						bootbox.alert({
								//size: 'large',
								 closeButton: false
								, centerVertical: true
								, message: '<h3>Saldo Borrado Con Exito...</h3><br><br>'
								, callback: function () {
											consultar_saldos()
											}
							});  
						break;
						
					default: 
						cadena = '<h3>Se Ha Producido un error...</h3>';
						cadena = cadena + '<br><br>' + data;
						bootbox.alert({
								//size: 'large',
								message: cadena
								, centerVertical: true
								//callback: function () {return false;}
							}); 
						
						break;
				}
		
			},
		error:
			function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
		});
	
}; 		




calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  }; 


consultar_saldos = function() {  
      var err ="";
		
		//no hay control de errores por filtros no rellenados
		var prm=new ajaxPrm();
		
		prm.add("p_cliente", j$('#ocultoid_cliente').val());
        prm.add("p_saldo", j$('#txtsaldo').val());
		prm.add("p_ordenante", j$('#cmbordenante').val());
		prm.add("p_tipo", j$('#cmbtipo_saldo').val());
		prm.add("p_cargo_abono", j$('#cmbcargo_abono').val());
		prm.add("p_fecha_ini", j$('#txtfecha_inicio').val());
		prm.add("p_fecha_fin", j$('#txtfecha_fin').val());
        
        j$.fn.dataTable.moment("DD/MM/YYYY");
        
        //deseleccioamos el registro de la lista
        j$('#lista_saldos tbody tr').removeClass('selected');
        
        if (typeof lst_saldos== "undefined") {
            lst_saldos = j$("#lista_saldos").DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:"tojson/Consulta_Saldos_Admin_Obtener_Saldos.asp?"+prm.toString(),
                                                           type:"POST",
                                                           dataSrc:"ROWSET"},
                                                     columnDefs: [
                                                              {className: "dt-right", targets: [0,2,3,8]}
                                                            ],
                                                     /*
													 columnDefs: [
                                                              {className: "dt-right", targets: [4,5,6,7]},
                                                              {className: "dt-center", targets: [4]}                                                            
                                                            ],
													*/
													 order:[[ 0, "desc" ]],
													 columns:[ 	
													 			{data:"ID"},
																{data:"NOMBRE_CLIENTE"},
																{data:"FECHA"},
															  	//{data:"IMPORTE"},
																{data:"IMPORTE"
																	,render: function (data, type, row, meta) 
																			{
																			if ( type === "display" ) //si se visualiza se formatea
																				{
																				valor=j$.fn.dataTable.render.number( '.', ',', 2).display(data.replace(',', '.'))
																				return valor + ' €'
																				}
																			  else
																			  	{
																				return data //si no es para visualizar, va sin formatear
																				}	
																			}
																},
																{data:"ORDENANTE"},
															  	{data:"TIPO"},
																{data:"CARGO_ABONO"},
															  	{data:"OBSERVACIONES"},
																{data:"TOTAL_DISFRUTADO",
																			render: function(data, type, row){
																					cadena_total=''
																					//console.log('estado: ' + row.ESTADO)
																					//console.log('type: ' + type)
																					switch(type) {
																							case 'export':
																								//console.log('ES UN EXPORT estado: ' + row.ESTADO)
																								cadena_total=row.TOTAL_DISFRUTADO
																								break;
																								
																							case 'sort':
																								cadena_total=row.TOTAL_DISFRUTADO
																								break;		
																								
																							default:
																								//si no se han tramitado todas las unidades
																								cadena=''
																								if (row.TOTAL_DISFRUTADO=='')
																									{
																									cadena+='<div class="row">'
																									cadena+='<div class="col-md-12">'
																									cadena+='<button type="button" class="btn btn-danger boton_eliminar_saldo"'
																									cadena+=' data-bs-toggle="popover_datatable"'
																									cadena+=' data-bs-placement="bottom"'
																									cadena+=' data-bs-trigger="hover"'
																									cadena+=' data-bs-content="Eliminar Saldo"'
																									cadena+=' data-bs-original-title="">'
																									//cadena+=' style="display:none; margin-top:5px">'
																									cadena+='<i class="fas fa-times"></i>&nbsp;Eliminar'
																									cadena+='</button>'
																									cadena+='</div>'
																									cadena+='</div>'
																									}
																								  else
																								  	{
																									cadena=row.TOTAL_DISFRUTADO
																									}
																								
																								cadena_total=cadena
																							}
																						return cadena_total
																			}} 
																
																
                                                            ],
													 rowId: 'extn', //para que se refresque sin perder filtros ni ordenacion
                                                     deferRender:true,
    //  Scroller
                                                     scrollY:calcDataTableHeight(),
                                                     scrollCollapse:true,
                                                   // scrollX:true,
    //  Fin Scroller
                                                   buttons:[{extend:"copy", text:'<i class="far fa-copy"></i>', titleAttr:"Copiar en Portapapeles", 
												   						exportOptions:{columns:[0,1,2,3,4,5,6,7,8]}}, 
                                                             {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Saldos", extension:".xls", 
														 				exportOptions:{columns:[0,1,2,3,4,5,6,7,8]}}, 
                                                             {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Saldos", orientation:"landscape", 
															 			exportOptions:{columns:[0,1,2,3,4,5,6,7,8]}}, 
                                                             {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Saldos", 
															 			exportOptions:{columns:[0,1,2,3,4,5,6,7,8]}}
															],
                                                 
													createdRow:function (row, data, index) {
																	
																	/*
																	color_fila='#f8f8f8'
																	if( (parseFloat(data.STOCK) <= parseFloat(data.STOCK_MINIMO)) && (parseFloat(data.STOCK_MINIMO)>0) ){
																		color_fila='#FF6633'
																	}
																	else if( parseFloat(data.STOCK) > parseFloat(data.STOCK_MINIMO)  ){
																		color_fila='#3399CC';
																	}
																	j$(row).css('background-color', color_fila);
																	*/
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
																  //j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
                                                                },
													rowCallback:function (row, data, index) {
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
																  //j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
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
               	
				j$("#lista_saldos").on("xhr.dt", function() {     
					//j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
			   	})
				
				 //controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_saldos tbody").on("click","tr", function() {  
                  if (!j$(this).hasClass("selected") ) {                  
                    //lst_refs.$("tr.selected").removeClass("selected");
                    //j$(this).addClass("selected");
                    
					
                  } 
                  //console.log(row_sel);
					
				  
                });

				//gestiona el dobleclick sobre la fila para mostrar la pantalla de detalle del pir
				j$("#lista_saldos").on("dblclick", "tr", function(e) {
				  /*
				  var row=lst_articulos.row(j$(this).closest("tr")).data() 
				  parametro_id=row.ID
				  
				  j$(this).addClass('selected');
				  j$(this).css('background-color', '#9FAFD1');
				  
				  
				  mostrar_articulo(parametro_id, 'MODIFICAR')
				  */
				});              
				
				
				j$('#lista_saldos').on('click', '.boton_eliminar_saldo', function () {
						//console.log('cambiando el valor a: ' + this.value);
						//j$(this).css('background-color', '#9FAFD1');
						//j$(this).parent().css({"color": "green", "border": "2px solid green"});
			
						var tbl_row = j$(this).closest('tr');
						var row = lst_saldos.row(tbl_row).data()
						
						parametro_id_saldo=row.ID
						parametro_nombre_cliente=row.NOMBRE_CLIENTE
						parametro_fecha= row.FECHA
						parametro_importe=row.IMPORTE
						parametro_ordenante=row.ORDENANTE
						parametro_tipo=row.TIPO
						parametro_cargo_abono=row.CARGO_ABONO
						parametro_observaciones= row.OBSERVACIONES

						
						//console.log('LOS VALORES A GUARDAR SON: detalle_devlucionA.... ' + parametro_id_detalle_devolucion + ' ... ESTADO... ' + parametro_estado_nuevo + ' ..... cantidad: ' + parametro_cantidad)
						
						cadena_saldo='<br>ID SALDO: ' + parametro_id_saldo
						cadena_saldo+='<br>CLIENTE: ' + parametro_nombre_cliente
						cadena_saldo+='<br>FECHA: ' + parametro_fecha
						cadena_saldo+='<br>IMPORTE: ' + parametro_importe
						cadena_saldo+='<br>ORDENANTE: ' + parametro_ordenante
						cadena_saldo+='<br>TIPO: ' + parametro_tipo
						cadena_saldo+='<br>CARGO O ABONO: ' + parametro_cargo_abono
						cadena_saldo+='<br>OBSERVACIONES: ' + parametro_observaciones
						cadena_saldo+='<br>'
						bootbox.confirm({
								size: 'large',
								title: 'Confirmación',
								closeButton: false,
								centerVertical: true,
								message: '<h5>¿Seguro que Desea Eliminar Este Saldo?</h5>' + cadena_saldo,
								buttons: {
									confirm: {
										label: '<i class="fas fa-check"></i> SI',
										className: 'btn-success'
									},
									cancel: {
										label: '<i class="fas fa-times"></i> NO',
										className: 'btn-danger',
									}
								},
								callback: function (result) {
									if (result)
										{
										eliminar_saldo(parametro_id_saldo)
										}
								}

												
							})
						
						/*						
						}
						else {
							sesion_bien=''
						
								j$.ajax({
									type: 'POST',
									url: 'Modificar_Detalle_Devolucion_Desde_Datatable.asp',
									data: {
										id_devolucion: parametro_id_devolucion, 
										id_detalle_devolucion: parametro_id_detalle_devolucion,
										estado_nuevo: parametro_estado_nuevo,
										cantidad: parametro_cantidad,
										id_articulo: parametro_id_articulo
									},
									success:
										function (data) {
											//console.log('lo devuelto por data: ' + data)
											switch (data) {
												case '1':  //todo ha ido bien 
													cadena = 'Modificacion Realizada Correctamente.';
													j$('[data-toggle="popover_datatable_detalle"]').popover('hide');
													consultar_detalles_devolucion(parametro_id_devolucion)
													consultar_devoluciones()
													break;
												
				
												default: 
													cadena = 'Se Ha Producido un error...';
													cadena = cadena + '<br><br>' + data;
													break;
											}
				
											bootbox.alert({
												//size: 'large',
												message: cadena
												//callback: function () {return false;}
											})
				
										},
									error:
										function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
								})
				
								//tbl_row.find('.boton_guardar_detalle').hide();
						}
						//j$(this).closest("boton_guardar_estado").show()
						*/
						
						
						
					});

				
				
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_saldos.ajax.url("tojson/Consulta_Saldos_Admin_Obtener_Saldos.asp?"+prm.toString());
              lst_saldos.ajax.reload();                  
            }       
      
      
    
	lst_saldos.on( 'buttons-action', function ( e, buttonApi, dataTable, node, config ) {
					//console.log( 'Button '+ buttonApi.text()+' was activated' );
					
				} );

  };





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
