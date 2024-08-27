<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
	
	response.Buffer=true
	numero_registros=0
		
	if session("usuario_admin")="" then
		Response.Redirect("Login_Admin.asp")
	end if
	'response.write("procedencia: " & request.servervariables("http_referer"))
	descripcion_seleccionada=Request.Form("txtdescripcion")
	campo_autorizacion=Request.Form("cmbautorizacion")
	campo_eliminado=Request.Form("cmbeliminado")
	ejecutar_consulta=Request.Form("ocultoejecutar")
		
	'response.write("<br>origen : " & Request.ServerVariables("HTTP_REFERER"))
	'response.write("<br>encontrado: " & instr(ucase(Request.ServerVariables("HTTP_REFERER")), "CONSULTA_ARTICULOS_ADMIN"))

	'si venimos de otra pagina que no sea la propia consulta de articulos que aparezca por defecto 
	' en eliminado la opcion de no
	if	instr(ucase(Request.ServerVariables("HTTP_REFERER")), "CONSULTA_ARTICULOS_ADMIN")=0 then
		campo_eliminado="NO"
	end if
		
	'recordsets
	dim empresas
		
		
	'variables
	dim sql
		
	set centros_coste=Server.CreateObject("ADODB.Recordset")
	CAMPO_CENTRO_COSTE=0
	CAMPO_NOMBRE_CENTRO_COSTE=1
	with centros_coste
		.ActiveConnection=connimprenta
		.Source="SELECT A.CENTRO_COSTE, B.NOMBRE"
		.Source= .Source & " FROM CENTROS_COSTE_GLS A"
		.Source= .Source & " INNER JOIN V_CLIENTES B"
		.Source= .Source & " ON A.CENTRO_COSTE=B.ID"
		.Source= .Source & " ORDER BY NOMBRE"
		.Open
		vacio_centros_coste=false
		if not .BOF then
			mitabla_centros_coste=.GetRows()
			else
			vacio_centros_coste=true
		end if
	end with

	centros_coste.close
	set centros_coste=Nothing





			

%>
<html>
<head>


<!-- Bootstrap CSS CDN -->
    <link rel="stylesheet" type="text/css" href="plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	
	<link rel="stylesheet" href="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min.css">
	
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

    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="style_menu_hamburguesa5.css">

    <!-- Font Awesome JS -->
    <!--
	<script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
	-->
    <script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

<style>
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
 
</style>


<script language="javascript" src="Funciones_Ajax.js"></script>
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
					<div class="col-10"><h1 align="center">Gesti&oacute;n Empleados GLS</h1></div>
				
				</div>
				<div class="panel panel-default">
					<div class="panel-body">
					<form name="frmbuscar_articulos" id="frmbuscar_articulos" method="post" action="Consulta_Articulos_Admin.asp">	
						<input type="hidden" id="ocultoid_empleado" name="ocultoid_empleado" value="" />
						<div class="form-group row mx-2">
							<div class="col-sm-9 col-md-9 col-lg-9">
								<label for="txtbuscar_empleado" class="control-label">Busqueda de Empleado</label>
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input class="js-typeahead-empleado form-control" name="txtbuscar_empleado" id="txtbuscar_empleado" type="search" placeholder="Buscar Empleado (por DNI, Nombre o Apellido)" autocomplete="off">
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-3 col-lg-2">
								<label for="txtfecha_alta" class="control-label">Fecha de Alta</label>
								<input type="date" class="form-control" name="txtfecha_alta" id="txtfecha_alta"  value="<%=fecha_alta%>" /> 
							</div>
						</div>					
					
						<div class="form-group row mx-2">
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtnif" class="control-label">NIF</label>
								<input type="text" class="form-control" name="txtnif" id="txtnif" value=""/>
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtnombre" class="control-label">Nombre</label>
								<input type="text" class="form-control" name="txtnombre" id="txtnombre" value=""/>
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtapellidos" class="control-label">Apellidos</label>
								<input type="text" class="form-control" name="txtapellidos" id="txtapellidos" value=""/>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="cmbsexo" class="control-label">Sexo</label>
								<select class="form-control" name="cmbsexo" id="cmbsexo">
									<option value="">* Selec. *</option>
									<option value="H">HOMBRE</option>
									<option value="M">MUJER</option>
								</select>
							</div>
						</div>	
						
						<div class="form-group row mx-2">
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtemail" class="control-label">Email</label>
								<input type="text" class="form-control" name="txtemail" id="txtemail" value=""/>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="cmbgrupo_ropa" class="control-label">Grupo Ropa</label>
								<select class="form-control" name="cmbgrupo_ropa" id="cmbgrupo_ropa">
									<option value="">* Selec. *</option>
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
								</select>
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="cmbcentro_coste" class="control-label">Centro de Coste</label>
								<select class="form-control" name="cmbcentro_coste" id="cmbcentro_coste">
									<option value="">* Selec. *</option>
									<%if vacio_centros_coste=false then %>
												<%for i=0 to UBound(mitabla_centros_coste,2)%>
													<option value="<%=mitabla_centros_coste(CAMPO_CENTRO_COSTE,i)%>"><%=mitabla_centros_coste(CAMPO_NOMBRE_CENTRO_COSTE,i)%></option>
												<%next%>
										<%end if%>
								</select>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="cmbempleado_nuevo" class="control-label">Empleado Nuevo</label>
								<select class="form-control" name="cmbempleado_nuevo" id="cmbempleado_nuevo">
									<option value="SI">SI</option>
									<option value="NO">NO</option>
								</select>
							</div>
						</div>		
						
						<div class="form-group row mx-2">
							<div class="col-sm-3 col-md-3 col-lg-3">
							</div>
							<div class="col-sm-4 col-md-2 col-lg-2">
								<button type="button" class="btn btn-primary btn-block" id="cmdeditar" name="cmdeditar" disabled>
									<i class="fas fa-pencil-alt"></i>&nbsp;&nbsp;&nbsp;Editar
								</button>
							</div>
							<div class="col-sm-4 col-md-2 col-lg-2">
								<button type="button" class="btn btn-primary btn-block" id="cmdguardar" name="cmdguardar"
									data-toggle="popover"
									data-placement="top"
									data-trigger="hover"
									data-content="Guardar Empleado"
									data-original-title=""
									>
									<i class="far fa-save"></i>&nbsp;&nbsp;&nbsp;Guardar
								</button>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
							</div>
							
							<div class="col-sm-3 col-md-3 col-lg-3">
								<button type="button" class="btn btn-primary btn-block" id="cmdresetear" name="cmdresetear"
									data-toggle="popover"
									data-placement="top"
									data-trigger="hover"
									data-content="Resetear Contraseña del Empleado"
									data-original-title=""
									disabled>
									<i class="fas fa-sync-alt"></i>&nbsp;&nbsp;&nbsp;Resetear Contraseña
								</button>
							</div>
							
						</div>		
					</form>
						
					
					</div><!--del panel body-->
				</div><!--del panel default-->
			</div><!--del content-fluid-->
        </div><!--fin de content-->
    </div><!--fin de wrapper-->










<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
	
<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>
    
<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>

<script type="text/javascript" src="plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>

<script type="text/javascript" src="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min_unicode.js"></script>

 
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


  
<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script>  
  

<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>




<script>
<%
	set empleados_typeahead=Server.CreateObject("ADODB.Recordset")
		
	with empleados_typeahead
		.ActiveConnection=connimprenta
		
		.Source="SELECT NIF + ' - ' + NOMBRE + ' ' + APELLIDOS TODO,"
		.Source=.Source & " ID, NIF, NOMBRE, APELLIDOS, EMAIL, SEXO, GRUPO_ROPA, CENTRO_COSTE, NUEVO, FECHA_ALTA"
		.Source=.Source & " FROM EMPLEADOS_GLS"
		.Source=.Source & " ORDER BY NIF"
		.Open
	end with

	Response.Write("var searchTags = new Array;" & vbcrlf)
	
	do until empleados_typeahead.eof
		'Response.Write("searchTags.push('" & articulos_typeahead("CODIGO_SAP") & " " & articulos_typeahead("DESCRIPCION") & " (" & articulos_typeahead("ID") & ")" & "');" & vbcrlf)
		cadena_empleados=""
		cadena_empleados=cadena_empleados & "{"
		cadena_empleados=cadena_empleados & "'ID': " &  empleados_typeahead("ID") 
		cadena_empleados=cadena_empleados & ", 'NIF': '" & empleados_typeahead("NIF") & "'"
		cadena_empleados=cadena_empleados & ", 'NOMBRE': '" & empleados_typeahead("NOMBRE") & "'"
		cadena_empleados=cadena_empleados & ", 'APELLIDOS':  '" & empleados_typeahead("APELLIDOS") & "'"
		cadena_empleados=cadena_empleados & ", 'EMAIL':  '" & empleados_typeahead("EMAIL") & "'"
		cadena_empleados=cadena_empleados & ", 'SEXO':  '" & empleados_typeahead("SEXO") & "'"
		cadena_empleados=cadena_empleados & ", 'GRUPO_ROPA':  '" & empleados_typeahead("GRUPO_ROPA") & "'"
		cadena_empleados=cadena_empleados & ", 'CENTRO_COSTE':  '" & empleados_typeahead("CENTRO_COSTE") & "'"
		cadena_empleados=cadena_empleados & ", 'NUEVO':  '" & empleados_typeahead("NUEVO") & "'"
		cadena_empleados=cadena_empleados & ", 'FECHA_ALTA':  '" & year(empleados_typeahead("FECHA_ALTA")) & "-" & right("0" & month(empleados_typeahead("FECHA_ALTA")), 2) & "-" & right("0" & day(empleados_typeahead("FECHA_ALTA")), 2)	& "'"
		cadena_empleados=cadena_empleados & ", 'TODO':  '" & empleados_typeahead("TODO") & "'"
		cadena_empleados=cadena_empleados & "}"
		
		Response.Write("searchTags.push(" & cadena_empleados & ");" & vbcrlf)
		
		empleados_typeahead.movenext
	loop
	
	empleados_typeahead.close
	set empleados_typeahead=Nothing
%>
</script>





<script type="text/javascript">
var j$=jQuery.noConflict();

function EsEmail(w_email) 
{
	var test = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/; 
	var emailReg = new RegExp(test);   
	return emailReg.test(w_email); 
} 
		
j$(document).ready(function () {
	j$("#mantenimientos_empleados_gls").addClass('active')
	
	j$('#sidebarCollapse').on('click', function () {
		j$('#sidebar').toggleClass('active');
		j$(this).toggleClass('active');
	});
	
	
	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true});
	
	j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
	
	
	
	var fecha_inicial = new Date();
	console.log('valor fecha:' + fecha_inicial)
	var dia_fecha = ("0" + fecha_inicial.getDate()).slice(-2);
	var mes_fecha = ("0" + (fecha_inicial.getMonth() + 1)).slice(-2);
	var fecha_alta_inicial = fecha_inicial.getFullYear()+"-"+(mes_fecha)+"-"+(dia_fecha) ;
	console.log('valor final fecha alta: ' + fecha_alta_inicial)
	j$("#txtfecha_alta").val(fecha_alta_inicial)
	
	
		//**********************************
	//este control esta en esta url: http://www.runningcoder.org/jquerytypeahead
	j$.typeahead({
	
		
		input: '.js-typeahead-empleado',

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
				'<span class="empleado">{{NIF}} <small style="color: ' + color + ';"> - {{NOMBRE}} {{APELLIDOS}}</small></span>' + 
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
				
				j$("#ocultoid_empleado").val(item.ID)
				
				//var today = moment().format('YYYY-MM-DD');
				//var valor_fecha = new Date(item.FECHA_ALTA).toISOString().split('T')[0];
				console.log('fecha de alta:' + item.FECHA_ALTA)
				//var valor_fecha = new Date(item.FECHA_ALTA);
				//console.log('valor fecha:' + valor_fecha)
				//var dia_fecha = ("0" + valor_fecha.getDate()).slice(-2);
				//var mes_fecha = ("0" + (valor_fecha.getMonth() + 1)).slice(-2);
				//var valor_fecha_alta = valor_fecha.getFullYear()+"-"+(mes_fecha)+"-"+(dia_fecha) ;
				//console.log('valor final fecha alta: ' + valor_fecha_alta)
				//j$("#txtfecha_alta").val(valor_fecha_alta)
				
				j$("#txtfecha_alta").val(item.FECHA_ALTA)
				j$("#txtnif").val(item.NIF)
				j$("#txtnombre").val(item.NOMBRE)
				j$("#txtapellidos").val(item.APELLIDOS)
				j$("#txtemail").val(item.EMAIL)
				j$("#cmbsexo").val(item.SEXO)
				j$("#cmbgrupo_ropa").val(item.GRUPO_ROPA)
				j$("#cmbcentro_coste").val(item.CENTRO_COSTE)
				if (item.NUEVO=='True')
					{
					j$("#cmbempleado_nuevo").val('SI')
					}
				  else
				  	{
					j$("#cmbempleado_nuevo").val('NO')
					}
		
				j$("#txtfecha_alta").prop('disabled', true);
				j$("#txtnif").prop('disabled', true);
				j$("#txtnombre").prop('disabled', true);
				j$("#txtapellidos").prop('disabled', true);
				j$("#txtemail").prop('disabled', true);
				j$("#cmbsexo").prop('disabled', true);
				j$("#cmbgrupo_ropa").prop('disabled', true);
				j$("#cmbcentro_coste").prop('disabled', true);
				j$("#cmbempleado_nuevo").prop('disabled', true);
				
		
				j$("#cmdresetear").prop('disabled', false);
				j$("#cmdeditar").prop('disabled', false);
				j$("#cmdguardar").prop('disabled', true);
				//console.log(item.COLOR)
				
				
				
	 
			},
			onCancel: function (node, event) {
				j$("#ocultoid_empleado").val('')
				//j$("#txtfecha_alta").val('')
				
				var valor_fecha = new Date();
				console.log('valor fecha:' + valor_fecha)
				var dia_fecha = ("0" + valor_fecha.getDate()).slice(-2);
				var mes_fecha = ("0" + (valor_fecha.getMonth() + 1)).slice(-2);
				var valor_fecha_alta = valor_fecha.getFullYear()+"-"+(mes_fecha)+"-"+(dia_fecha) ;
				console.log('valor final fecha alta: ' + valor_fecha_alta)
				j$("#txtfecha_alta").val(valor_fecha_alta)
				
				j$("#txtnif").val('')
				j$("#txtnombre").val('')
				j$("#txtapellidos").val('')
				j$("#txtemail").val('')
				j$("#cmbsexo").val('')
				j$("#cmbgrupo_ropa").val('')
				j$("#cmbcentro_coste").val('')
				j$("#cmbempleado_nuevo").val('SI')
				
				j$("#txtfecha_alta").prop('disabled', false);
				j$("#txtnif").prop('disabled', false);
				j$("#txtnombre").prop('disabled', false);
				j$("#txtapellidos").prop('disabled', false);
				j$("#txtemail").prop('disabled', false);
				j$("#cmbsexo").prop('disabled', false);
				j$("#cmbgrupo_ropa").prop('disabled', false);
				j$("#cmbcentro_coste").prop('disabled', false);
				j$("#cmbempleado_nuevo").prop('disabled', false);
				
					
				j$("#cmdresetear").prop('disabled', true);
				j$("#cmdeditar").prop('disabled', true);
				j$("#cmdguardar").prop('disabled', false);
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

	
});
		
calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  }; 		
		
		
j$("#cmdeditar").click(function () {
	j$("#txtfecha_alta").prop('disabled', false);
	j$("#txtnif").prop('disabled', false);
	j$("#txtnombre").prop('disabled', false);
	j$("#txtapellidos").prop('disabled', false);
	j$("#txtemail").prop('disabled', false);
	j$("#cmbsexo").prop('disabled', false);
	j$("#cmbgrupo_ropa").prop('disabled', false);
	j$("#cmbcentro_coste").prop('disabled', false);
	j$("#cmbempleado_nuevo").prop('disabled', false);
	
	j$("#cmdeditar").prop('disabled', true);
	j$("#cmdresetear").prop('disabled', true);
	j$("#cmdguardar").prop('disabled', false);
	
});


j$("#cmdguardar").click(function () {

	cadena_error=''
	if (j$("#txtfecha_alta").val()=='')
		{
		cadena_error=cadena_error + '- Falta el Dato de la FECHA DE ALTA.<br>'
		}
		
	if (j$("#txtnif").val()=='')
		{
		cadena_error=cadena_error + '- Falta el Dato del NIF.<br>'
		}

	if (j$("#txtnombre").val()=='')
		{
		cadena_error=cadena_error + '- Falta el Dato del NOMBRE.<br>'
		}

	if (j$("#txtapellidos").val()=='')
		{
		cadena_error=cadena_error + '- Falta el Dato de los APELLIDOS.<br>'
		}

	if (j$("#cmbsexo").val()=='')
		{
		cadena_error=cadena_error + '- No se ha seleccionado el SEXO.<br>'
		}
	if (j$("#txtemail").val()=='')
		{
		cadena_error=cadena_error + '- Falta el Dato del EMAIL.<br>'
		}
	   else
		{
		if (!EsEmail(j$("#txtemail").val()))
			{
			cadena_error=cadena_error + '- El EMAIL introducido es incorrecto'
			}
		
		}
	if (j$("#cmbgrupo_ropa").val()=='')
		{
		cadena_error=cadena_error + '- No se ha seleccionado el GRUPO DE ROPA.<br>'
		}
	if (j$("#cmbcentro_coste").val()=='')
		{
		cadena_error=cadena_error + '- No se ha seleccionado el CENTRO DE COSTE.<br>'
		}
		
		
	if (cadena_error!='')
		{
		bootbox.alert({
				//size: 'large',
				message: '<h3>Se Han Encontrado Los Siguientes Errores</h3><br><br><h5>' + cadena_error + '</h5>'
				//callback: function () {return false;}
			});
		
		}
	  else
	  	{
			accion=''
			if (j$("#ocultoid_empleado").val()=='')
				{
				accion='ALTA'
				cadena_mensaje='¿Confirma que desea <B>dar de alta un nuevo empleado GLS</B> con los siguientes datos?<br>'
				}
			  else
			  	{
				accion='MODIFICACION'
				cadena_mensaje='¿Confirma que desea <B>modificar los datos de un empleado GLS ya existente</B> utilizando los siguientes datos?<br><br>'
				}

			cadena_mensaje+= '<BR>FECHA DE ALTA: <B>' + j$("#txtfecha_alta").val() + '</B><br>'
			cadena_mensaje+= 'NIF: <B>' + j$("#txtnif").val() + '</B><br>'
			cadena_mensaje+= 'NOMBRE: <B>' + j$("#txtnombre").val() + '</B><br>'
			cadena_mensaje+= 'APELLIDOS: <B>' + j$("#txtapellidos").val() + '</B><br>'
			cadena_mensaje+= 'SEXO: <B>' + j$("#cmbsexo option:selected").text() + '</B><br>'
			cadena_mensaje+= 'EMAIL: <B>' + j$("#txtemail").val() + '</B><br>'
			cadena_mensaje+= 'GRUPO ROPA: <B>' + j$("#cmbgrupo_ropa option:selected").text() + '</B><br>'
			cadena_mensaje+= 'CENTRO DE COSTE: <B>' + j$("#cmbcentro_coste option:selected").text() + '</B><br>'
			cadena_mensaje+= 'EMPLEADO NUEVO: <B>' + j$("#cmbempleado_nuevo option:selected").text() + '</B><br>'

			bootbox.confirm({
				size: 'large',
				message: '<H5>' + cadena_mensaje +'</h5>',
				buttons: {
					confirm: {
						label: '&nbsp;SI&nbsp;',
						className: 'btn-success'
					},
					cancel: {
						label: 'NO',
						className: 'btn-danger'
					}
				},
				callback: function (result) {
					console.log('This was logged in the callback: ' + result);
					if (result)
						{
						resultado = validarNIF(j$("#txtnif").val());
						if (resultado == false) 
							{
							cadena_error= '<br>- DNI / CIF / NIF / NIE no v&aacute;lido.'
							cadena_mensaje='Parece que el DNI / CIF / NIF / NIE <b>' + j$("#txtnif").val() + '</b> NO es correcto.<br>'
							cadena_mensaje+='<br>Pulse <b>"GUARDAR"</b> si está seguro que el documento (DNI/CIF/NIF/NIE) está correctamente escrito, y se guardarán los datos.<br>'
							cadena_mensaje+='<br>Pulse <b>"CANCELAR"</b> para corregir el documento (DNI/CIF/NIF/NIE)'
							
							bootbox.confirm({
								size: 'large',
								message: '<H5>' + cadena_mensaje +'</h5>',
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
									console.log('This was logged in the callback: ' + result);
									if (result)
										{
										console.log('entro en gardar');
										guardar_empleado()
										}
								}
							});
							
							}
						  else
						  	{
							console.log('lo puedo guardar porque no esta repetido el dni')
							guardar_empleado()
							}

						}
				}
			});
			
		}


});


j$("#cmdresetear").click(function () {
	
	j$.ajax({
		type: 'POST',
		url: 'Resetear_Contrasenna_Empleado_GLS.asp',
		data: {
			id_empleado: j$("#ocultoid_empleado").val(),
			nif: j$("#txtnif").val()
		},
		dataType: 'json',
		success:
			function (data) {
				switch (data.resultado) {
					case 'OK':  
						bootbox.alert({
								size: 'large'
								, message: '<h3>Contraseña del Empleado Reseteada...</h3><br><br><h5>Su usuario será su DNI, y su contraseña, para el primer acceso será su DNI y al acceder el sistema le obligará a cambiar la contraseña por otra de su eleccion a la que no tendremos acceso.</h5>'
								, callback: function () {
											location.href='Gestion_Empleados_GLS_Admin.asp'
											}
							});  
						break;
						
					case 'VOLVER_LOGIN':  
						location.href='Login_Admin.asp'
						break;
						
					default: 
						cadena = '<h3>Se Ha Producido un error...</h3>';
						cadena = cadena + '<br><br>' + data;
						bootbox.alert({
								//size: 'large',
								message: cadena
								//callback: function () {return false;}
							}); 
						
						break;
				}
		
			},
		error:
			function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
		});
	
});



guardar_empleado = function(codigo) {
	console.log('dentro de guardar empleado')

	j$.ajax({
		type: 'POST',
		url: 'Guardar_Empleado_GLS.asp',
		data: {
			id_empleado: j$("#ocultoid_empleado").val(),
			fecha_alta: j$("#txtfecha_alta").val(),
			nif: j$("#txtnif").val(),
			nombre: j$("#txtnombre").val(),
			apellidos: j$("#txtapellidos").val(),
			sexo: j$("#cmbsexo").val(),
			email: j$("#txtemail").val(),
			grupo_ropa: j$("#cmbgrupo_ropa").val(),
			centro_coste: j$("#cmbcentro_coste").val(),
			nuevo: j$("#cmbempleado_nuevo").val()
		},
		dataType: 'json',
		success:
			function (data) {
				console.log('lo devuelto por data: ' + data)
				console.log('resultado: ' + data.resultado)
				
				switch (data.resultado) {
					case 'ALTA_OK':  
						bootbox.alert({
								size: 'large'
								, message: '<h3>Empleado Creado con Exito...</h3><br><br><h5>Su usuario será su DNI, y su contraseña, para el primer acceso será su DNI y al acceder el sistema le obligará a cambiar la contraseña por otra de su eleccion a la que no tendremos acceso.</h5>'
								, callback: function () {
											/*
											j$("#ocultoid_empleado").val('')
											j$("#txtnif").val('')
											j$("#txtnombre").val('')
											j$("#txtapellidos").val('')
											j$("#txtemail").val('')
											j$("#cmbsexo").val('')
											j$("#cmbgrupo_ropa").val('')
											j$("#cmbcentro_coste").val('')
											j$("#cmbempleado_nuevo").val('SI')
											*/
											location.href='Gestion_Empleados_GLS_Admin.asp'
											}
							});  
						break;
						
					case 'ALTA_DNI_REPETIDO':  
						bootbox.alert({
								size: 'large',
								message: '<h3 style="color:red">DNI Repetido...</h3><br><br><h5 style="color:red">El DNI introducido ya está dado de alta en el sistema, asegúrese que es correcto, y si es asi, busque al empleado desde La Busqueda de Empleado y modifique sus datos existentes en vez de crear un empleado nuevo.</h5>'
							});  
						break;
					
					case 'MODIFICACION_OK':  
						bootbox.alert({
								size: 'large'
								, message: '<h3>Empleado Modificado con Exito...</h3><br><br>'
								, callback: function () {
											/*
											j$("#ocultoid_empleado").val('')
											j$("#txtnif").val('')
											j$("#txtnombre").val('')
											j$("#txtapellidos").val('')
											j$("#txtemail").val('')
											j$("#cmbsexo").val('')
											j$("#cmbgrupo_ropa").val('')
											j$("#cmbcentro_coste").val('')
											j$("#cmbempleado_nuevo").val('SI')
											*/
											location.href='Gestion_Empleados_GLS_Admin.asp'
											}
							});  
						break;
						
					case 'MODIFICACION_DNI_REPETIDO':  
						bootbox.alert({
								size: 'large',
								message: '<h3 style="color:red">DNI Repetido...</h3><br><br><h5 style="color:red">El DNI introducido ya está dado de alta en el sistema para otro Empleado, asegúrese que es correcto, y si es asi, busque al empleado desde La Busqueda de Empleado y modifique sus datos existentes.</h5>'
							});  
						break;
					
					case 'VOLVER_LOGIN':  
						location.href='Login_Admin.asp'
						break;

					default: 
						cadena = '<h3>Se Ha Producido un error...</h3>';
						cadena = cadena + '<br><br>' + data;
						bootbox.alert({
								//size: 'large',
								message: cadena
								//callback: function () {return false;}
							}); 
						
						break;
				}
		
			},
		error:
			function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
		});
	
}; 		



function validarNIF(nif) {
 
    /*        
        Retorna: 
            False: Documento invalido.
            DNI: Correcto, se trata de un CIF/DNI
            NIE: Correcto, se trata de un NIE (extranjero)
            CIF: Correcto, se trata de un NIF (Empresa)
 
        Los DNI españoles pueden ser:
        NIF (Numero de Identificación Fiscal) - 8 numeros y una letra1
        NIE (Numero de Identificación de Extranjeros) - 1 letra2, 7 numeros y 1 letra1
        
		letra1 - Una de las siguientes: TRWAGMYFPDXBNJZSQVHLCKE
        letra2 - Una de las siguientes: XYZ           
 
        ref: https://github.com/TORR3S/Check-NIF/blob/master/checkNIF.js  
     */
    
    nif = nif.toUpperCase().replace(/[\s\-]+/g, '');
    if (/^(\d|[XYZ])\d{7}[A-Z]$/.test(nif)) {
        var num = nif.match(/\d+/);
        num = (nif[0] != 'Z' ? nif[0] != 'Y' ? 0 : 1 : 2) + num;
        if (nif[8] == 'TRWAGMYFPDXBNJZSQVHLCKE'[num % 23]) {
            return /^\d/.test(nif) ? 'DNI' : 'NIE';
        }
    }
    else if (/^[ABCDEFGHJKLMNPQRSUVW]\d{7}[\dA-J]$/.test(nif)) {
        for (var sum = 0, i = 1; i < 8; ++i) {
            var num = nif[i] << i % 2;
            var uni = num % 10;
            sum += (num - uni) / 10 + uni;
        }
        var c = (10 - sum % 10) % 10;
        if (nif[8] == c || nif[8] == 'JABCDEFGHI'[c]) {
            return /^[KLM]/.test(nif) ? 'ESP' : 'CIF';
        }
    }
    return false;
};// validarNIF




/**
 * ValidateSpanishID. Returns the type of document and checks its validity.
 * 
 * Usage:
 *     ValidateSpanishID( str );
 * 
 *     > ValidateSpanishID( '12345678Z' );
 *     // { type: 'dni', valid: true }
 *     
 *     > ValidateSpanishID( 'B83375575' );
 *     // { type: 'cif', valid: false }
 * 
 * The algorithm is adapted from other solutions found at:
 * - http://www.compartecodigo.com/javascript/validar-nif-cif-nie-segun-ley-vigente-31.html
 * - http://es.wikipedia.org/wiki/C%C3%B3digo_de_identificaci%C3%B3n_fiscal
 */

ValidateSpanishID = (function() {
  'use strict';
  
  var DNI_REGEX = /^(\d{8})([A-Z])$/;
  var CIF_REGEX = /^([ABCDEFGHJKLMNPQRSUVW])(\d{7})([0-9A-J])$/;
  var NIE_REGEX = /^[XYZ]\d{7,8}[A-Z]$/;

  var ValidateSpanishID = function( str ) {

    // Ensure upcase and remove whitespace
    str = str.toUpperCase().replace(/\s/, '');

    var valid = false;
    var type = spainIdType( str );

    switch (type) {
      case 'dni':
        valid = validDNI( str );
        break;
      case 'nie':
        valid = validNIE( str );
        break;
      case 'cif':
        valid = validCIF( str );
        break;
    }

    return {
      type: type,
      valid: valid
    };

  };

  var spainIdType = function( str ) {
    if ( str.match( DNI_REGEX ) ) {
      return 'dni';
    }
    if ( str.match( CIF_REGEX ) ) {
      return 'cif';
    }
    if ( str.match( NIE_REGEX ) ) {
      return 'nie';
    }
  };

  var validDNI = function( dni ) {
    var dni_letters = "TRWAGMYFPDXBNJZSQVHLCKE";
    var letter = dni_letters.charAt( parseInt( dni, 10 ) % 23 );
    
    return letter == dni.charAt(8);
  };

  var validNIE = function( nie ) {

    // Change the initial letter for the corresponding number and validate as DNI
    var nie_prefix = nie.charAt( 0 );

    switch (nie_prefix) {
      case 'X': nie_prefix = 0; break;
      case 'Y': nie_prefix = 1; break;
      case 'Z': nie_prefix = 2; break;
    }

    return validDNI( nie_prefix + nie.substr(1) );

  };

  var validCIF = function( cif ) {

    var match = cif.match( CIF_REGEX );
    var letter  = match[1],
        number  = match[2],
        control = match[3];

    var even_sum = 0;
    var odd_sum = 0;
    var n;

    for ( var i = 0; i < number.length; i++) {
      n = parseInt( number[i], 10 );

      // Odd positions (Even index equals to odd position. i=0 equals first position)
      if ( i % 2 === 0 ) {
        // Odd positions are multiplied first.
        n *= 2;

        // If the multiplication is bigger than 10 we need to adjust
        odd_sum += n < 10 ? n : n - 9;

      // Even positions
      // Just sum them
      } else {
        even_sum += n;
      }

    }

    var control_digit = (10 - (even_sum + odd_sum).toString().substr(-1) );
    var control_letter = 'JABCDEFGHI'.substr( control_digit, 1 );

    // Control must be a digit
    if ( letter.match( /[ABEH]/ ) ) {
      return control == control_digit;

    // Control must be a letter
    } else if ( letter.match( /[KPQS]/ ) ) {
      return control == control_letter;

    // Can be either
    } else {
      return control == control_digit || control == control_letter;
    }

  };

  return ValidateSpanishID;
})();



/******************************
console.log('---------------------------------------------------')
console.log(' COMPROBAR DNIS')
console.log('---------------------------------------------------')

//FORMULA PARA EL EXCEL...
//="console.log('" & A1 & ": ' + validarNIF('" & A1 &"'))"
//="valor_dni=ValidateSpanishID('" & A2 & "');console.log('" & A2 & ": ' + validarNIF('" & A2 &"') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)"

console.log('-----------------------------------');console.log('---- cifs correctos -----------');console.log('-----------------------------------');
valor_dni=ValidateSpanishID('A79082244');console.log('A79082244: ' + validarNIF('A79082244') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('A60917978');console.log('A60917978: ' + validarNIF('A60917978') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('A39000013');console.log('A39000013: ' + validarNIF('A39000013') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('B43522192');console.log('B43522192: ' + validarNIF('B43522192') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('B38624334');console.log('B38624334: ' + validarNIF('B38624334') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('G72102064');console.log('G72102064: ' + validarNIF('G72102064') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('F41190612');console.log('F41190612: ' + validarNIF('F41190612') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('J85081081');console.log('J85081081: ' + validarNIF('J85081081') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('S98038813');console.log('S98038813: ' + validarNIF('S98038813') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('G32937757');console.log('G32937757: ' + validarNIF('G32937757') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('B46125746');console.log('B46125746: ' + validarNIF('B46125746') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('C27827559');console.log('C27827559: ' + validarNIF('C27827559') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('E48911572');console.log('E48911572: ' + validarNIF('E48911572') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('s98038813');console.log('s98038813: ' + validarNIF('s98038813') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
console.log('-----------------------------------');console.log('---- cifs erroneos -----------');console.log('-----------------------------------');
valor_dni=ValidateSpanishID('cifs erroneos');console.log('cifs erroneos: ' + validarNIF('cifs erroneos') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('K48911572');console.log('K48911572: ' + validarNIF('K48911572') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('L48911572');console.log('L48911572: ' + validarNIF('L48911572') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('M48911572');console.log('M48911572: ' + validarNIF('M48911572') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('X48911572');console.log('X48911572: ' + validarNIF('X48911572') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('Y48911572');console.log('Y48911572: ' + validarNIF('Y48911572') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('Z48911572');console.log('Z48911572: ' + validarNIF('Z48911572') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('M15661515');console.log('M15661515: ' + validarNIF('M15661515') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('Z98038813');console.log('Z98038813: ' + validarNIF('Z98038813') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('B 43522192');console.log('B 43522192: ' + validarNIF('B 43522192') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('43522192');console.log('43522192: ' + validarNIF('43522192') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('BB43522192');console.log('BB43522192: ' + validarNIF('BB43522192') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('B53522192');console.log('B53522192: ' + validarNIF('B53522192') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('B433522192');console.log('B433522192: ' + validarNIF('B433522192') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('B3522192');console.log('B3522192: ' + validarNIF('B3522192') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('B-43522192');console.log('B-43522192: ' + validarNIF('B-43522192') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('Basdasdas');console.log('Basdasdas: ' + validarNIF('Basdasdas') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('B43.522.192');console.log('B43.522.192: ' + validarNIF('B43.522.192') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('B-43.522.192');console.log('B-43.522.192: ' + validarNIF('B-43.522.192') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)



console.log('-----------------------------------');console.log('---- nies corectos -----------');console.log('-----------------------------------');
valor_dni=ValidateSpanishID('X0093999K');console.log('X0093999K: ' + validarNIF('X0093999K') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('X1923000Q');console.log('X1923000Q: ' + validarNIF('X1923000Q') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('Z9669587R');console.log('Z9669587R: ' + validarNIF('Z9669587R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('Z8945005B');console.log('Z8945005B: ' + validarNIF('Z8945005B') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('Z6663465W');console.log('Z6663465W: ' + validarNIF('Z6663465W') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('Y7875935J');console.log('Y7875935J: ' + validarNIF('Y7875935J') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('X3390130E');console.log('X3390130E: ' + validarNIF('X3390130E') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('Y7699182S');console.log('Y7699182S: ' + validarNIF('Y7699182S') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('Y1524243R');console.log('Y1524243R: ' + validarNIF('Y1524243R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('X3744072V');console.log('X3744072V: ' + validarNIF('X3744072V') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('X7436800A');console.log('X7436800A: ' + validarNIF('X7436800A') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('y7875935j');console.log('y7875935j: ' + validarNIF('y7875935j') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)

console.log('-----------------------------------');console.log('---- nies erroneos -----------');console.log('-----------------------------------');
valor_dni=ValidateSpanishID('X0093999 K');console.log('X0093999 K: ' + validarNIF('X0093999 K') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('X 0093999 K');console.log('X 0093999 K: ' + validarNIF('X 0093999 K') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11441059');console.log('11441059: ' + validarNIF('11441059') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11441059PR');console.log('11441059PR: ' + validarNIF('11441059PR') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11440059R');console.log('11440059R: ' + validarNIF('11440059R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11441059S');console.log('11441059S: ' + validarNIF('11441059S') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('114410598R');console.log('114410598R: ' + validarNIF('114410598R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11441059-R');console.log('11441059-R: ' + validarNIF('11441059-R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('asdasdasd');console.log('asdasdasd: ' + validarNIF('asdasdasd') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11.144.059R');console.log('11.144.059R: ' + validarNIF('11.144.059R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('05.122.654R');console.log('05.122.654R: ' + validarNIF('05.122.654R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('5.122.654-R');console.log('5.122.654-R: ' + validarNIF('5.122.654-R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('05.122.654-R');console.log('05.122.654-R: ' + validarNIF('05.122.654-R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)


console.log('-----------------------------------');console.log('---- nifs correctos -----------');console.log('-----------------------------------');
valor_dni=ValidateSpanishID('11441059P');console.log('11441059P: ' + validarNIF('11441059P') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('80054306T');console.log('80054306T: ' + validarNIF('80054306T') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('76048581R');console.log('76048581R: ' + validarNIF('76048581R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('28950849J');console.log('28950849J: ' + validarNIF('28950849J') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('34048598L');console.log('34048598L: ' + validarNIF('34048598L') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('28311529R');console.log('28311529R: ' + validarNIF('28311529R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('34673804Q');console.log('34673804Q: ' + validarNIF('34673804Q') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('92133247P');console.log('92133247P: ' + validarNIF('92133247P') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('77149717N');console.log('77149717N: ' + validarNIF('77149717N') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('15762034L');console.log('15762034L: ' + validarNIF('15762034L') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('05122654W');console.log('05122654W: ' + validarNIF('05122654W') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('05122654w');console.log('05122654w: ' + validarNIF('05122654w') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)

console.log('-----------------------------------');console.log('---- nifs erroneos -----------');console.log('-----------------------------------');
valor_dni=ValidateSpanishID('1144105R');console.log('1144105R: ' + validarNIF('1144105R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11441059 R');console.log('11441059 R: ' + validarNIF('11441059 R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11441059');console.log('11441059: ' + validarNIF('11441059') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11441059PR');console.log('11441059PR: ' + validarNIF('11441059PR') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11440059R');console.log('11440059R: ' + validarNIF('11440059R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11441059S');console.log('11441059S: ' + validarNIF('11441059S') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('114410598R');console.log('114410598R: ' + validarNIF('114410598R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11441059-R');console.log('11441059-R: ' + validarNIF('11441059-R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('asdasdasd');console.log('asdasdasd: ' + validarNIF('asdasdasd') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('11.144.059R');console.log('11.144.059R: ' + validarNIF('11.144.059R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('05.122.654R');console.log('05.122.654R: ' + validarNIF('05.122.654R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('5.122.654-R');console.log('5.122.654-R: ' + validarNIF('5.122.654-R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)
valor_dni=ValidateSpanishID('05.122.654-R');console.log('05.122.654-R: ' + validarNIF('05.122.654-R') + ' -- ' + valor_dni.type + ' -- ' + valor_dni.valid)


console.log('---------------------------------------------------')
console.log(' FIN DE COMPROBAR DNIS')
console.log('---------------------------------------------------')

********************/

    </script>


</body>
<%
	
	connimprenta.close
	
	set connimprenta=Nothing

%>


</html>
