<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->

<%
	response.Buffer=true
	numero_registros=0

	if session("usuario_admin")="" then
		Response.Redirect("Login_Admin.asp")
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
		
	if orden_clientes="" then
		orden_clientes="POR_NOMBRE"
	end if
	'mostrar_borrados=Request.Form("chkmostrar_borrados")
	
	if mostrar_borrados<>"SI" then
		mostrar_borrados="NO"
	end if
	
		
	
	'variables
	dim sql
		
		
	
		
	set empresas=Server.CreateObject("ADODB.Recordset")
	CAMPO_ID_EMPRESA=0
	CAMPO_EMPRESA_EMPRESA=1
	CAMPO_CARPETA_EMPRESA=2
	with empresas
		.ActiveConnection=connimprenta
		.Source="SELECT V_EMPRESAS.ID, V_EMPRESAS.EMPRESA, V_EMPRESAS.CARPETA"
		.Source= .Source & " FROM V_EMPRESAS"
		.Source= .Source & " ORDER BY EMPRESA"
		.Open
		vacio_empresas=false
		if not .BOF then
			mitabla_empresas=.GetRows()
			else
			vacio_empresas=true
		end if
	end with

	empresas.close
	set empresas=Nothing

	set estados=Server.CreateObject("ADODB.Recordset")
	CAMPO_ID_ESTADO=0
	CAMPO_ESTADO_ESTADO=1
	CAMPO_ORDEN_ESTADO=2
	with estados
		.ActiveConnection=connimprenta
		.Source="SELECT *"
		.Source= .Source & " FROM ESTADOS"
		.Source= .Source & " ORDER BY ORDEN"
		.Open
		vacio_estados=false
		if not .BOF then
			mitabla_estados=.GetRows()
			else
			vacio_estados=true
		end if
	end with

	estados.close
	set estados=Nothing

	
	set pedidos_automaticos=Server.CreateObject("ADODB.Recordset")
	CAMPO_PEDIDO_AUTOMATICO=0
	with pedidos_automaticos
		.ActiveConnection=connimprenta
		.Source="SELECT DISTINCT PEDIDO_AUTOMATICO FROM PEDIDOS WHERE PEDIDO_AUTOMATICO<>'' ORDER BY PEDIDO_AUTOMATICO"
		.Open
		vacio_pedidos_automaticos=false
		if not .BOF then
			mitabla_pedidos_automaticos=.GetRows()
			else
			vacio_pedidos_automaticos=true
		end if
	end with

	pedidos_automaticos.close
	set pedidos_automaticos=Nothing

		
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
	
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css"/>
	
	<!--
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css"/>
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

<script language="javascript">
function mostrar_pedido(pedido, nreg) {
    if (nreg == 0) {
        alert('El pedido ' + pedido + ' No contiene detalles');
        return;
    }    
   	document.getElementById('ocultopedido').value=pedido
   	document.getElementById('frmmostrar_pedido').submit()		    
}// mostrar_pedido --

  
function modificar_pedido(numero_pedido, empresa){
	//alert('ha modificar el pedido')
	document.getElementById("ocultopedido_a_modificar").value=numero_pedido
	document.getElementById("ocultoempresa_pedido").value=empresa
	document.getElementById("frmmodificar_pedido").submit()	
}	  
  
 	
function quitar_seleccion(){
	document.getElementById('cmbclientes').value=''
	document.getElementById("ocultocliente_seleccionado").value=''
	//document.getElementById('cmbclientes').focus()
}


function refrescar_pagina(orden,borrados){
	//alert(document.getElementById("cmbempresas").value)
	//console.log('borrados en refrescar pagina: ' + borrados)
	Actualizar_Combos('Obtener_Clientes.asp', document.getElementById("cmbempresas").value, document.getElementById("ocultocliente_seleccionado").value,'capa_clientes', orden, borrados)
	//cerrar_capas('capa_informacion')
	
}

function control_borrados()
	{
	//console.log('checkbox: ' + document.getElementById('chkmostrar_borrados').checked)
	if (document.getElementById('chkmostrar_borrados').checked)
		{
		refrescar_pagina(document.getElementById('ocultoorden_clientes').value, 'SI')
		}
	  else
	  	{
		refrescar_pagina(document.getElementById('ocultoorden_clientes').value, 'NO')
		}
		
	}
	
function cambiar_orden(){
	//alert('refrescar: ' + orden)
	if (document.getElementById('ocultoorden_clientes').value=='POR_ID')
		{
		ordenacion='POR_NOMBRE'
		document.getElementById('ocultoorden_clientes').value='POR_NOMBRE'
		j$("#icono_reordenar").removeClass("fa-sort-alpha-up");
		j$("#icono_reordenar").addClass("fa-sort-numeric-up");
		j$("#cmdcambiar_orden").attr('data-content' , 'Reordenar Clientes Por C&oacute;digo')
		j$("#cmdcambiar_orden").popover("show");
		}
	  else
		if (document.getElementById('ocultoorden_clientes').value=='POR_NOMBRE')
			{
			ordenacion='POR_ID'
			document.getElementById('ocultoorden_clientes').value='POR_ID'
			j$("#icono_reordenar").removeClass("fa-sort-numeric-up");
			j$("#icono_reordenar").addClass("fa-sort-alpha-up");
			j$("#cmdcambiar_orden").attr('data-content' , 'Reordenar Clientes Por Nombre')
			j$("#cmdcambiar_orden").popover("show");
			}
		  else
		  	{
			ordenacion='POR_NOMBRE'
			document.getElementById('ocultoorden_clientes').value='POR_NOMBRE'
			j$("#icono_reordenar").removeClass("fa-sort-alpha-up");
			j$("#icono_reordenar").addClass("fa-sort-numeric-up");
			j$("#cmdcambiar_orden").attr('data-content' , 'Reordenar Clientes Por C&oacute;digo')
			j$("#cmdcambiar_orden").popover("show");
			}
	  
	  	

	refrescar_pagina(ordenacion, document.getElementById('chkmostrar_borrados').checked)
}
</script>
<script language="javascript" src="Funciones_Ajax.js"></script>

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
		.toolbar {float:left;}    
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
			<div class="row">
				<div class="card col-12">
					<div class="card-body">
						<form name="frmconsulta_pedidos" action="Consulta_Pedidos_Admin_new.asp" method="post">
						<h5 class="card-title">Opciones de B&uacute;squeda de Pedidos</h5>
						<!--primera linea-->
						<div class="form-group row mx-2">
							<div class="col-sm-12 col-md-4 col-lg-4">
								<label for="cmbempresas" class="control-label">Empresa</label>
								<select class="form-control" name="cmbempresas" id="cmbempresas" onchange="refrescar_pagina(document.getElementById('ocultoorden_clientes').value, document.getElementById('chkmostrar_borrados').checked)">
										<option value="" selected>* Seleccione *</option>
										<%if vacio_empresas=false then %>
												<%for i=0 to UBound(mitabla_empresas,2)%>
													<option value="<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>"><%=mitabla_empresas(CAMPO_EMPRESA_EMPRESA,i)%></option>
												<%next%>
										<%end if%>
								</select>
								<script language="javascript">
									document.getElementById("cmbempresas").value='<%=empresa_seleccionada%>'
								</script>
							</div>
							<div class="col-sm-12 col-md-3 col-lg-2">
								<label for="txtfecha_inicio" class="control-label">Fecha de Inicio</label>
								<input type="date" class="form-control" name="txtfecha_inicio" id="txtfecha_inicio"  value="<%=fecha_i%>" /> 
							</div>
							<div class="col-sm-123 col-md-3 col-lg-2">
								<label for="txtfecha_fin" class="control-label">Fecha Fin</label>
								<input type="date" class="form-control" name="txtfecha_fin" id="txtfecha_fin"  value="<%=fecha_f%>" /> 
							</div>
							<div class="col-sm-12 col-md-3 col-lg-3">
								<label for="cmbestados" class="control-label">Estado</label>
								<select name="cmbestados" id="cmbestados" multiple="multiple">
								
										<option value="">* Seleccione *</option>
										<option value="RESERVADO">RESERVADO</option>
										<%if vacio_estados=false then %>
												<%for i=0 to UBound(mitabla_estados,2)%>
													<option value="<%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%>"><%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%></option>
												<%next%>
										<%end if%>
								</select>
								<%if estado_seleccionado<>"" then%>
									<script language="javascript">
										document.getElementById("cmbestados").value='<%=estado_seleccionado%>'
									</script>
								<%end if%>
							</div>
						</div>
						
						<!--segunda linea-->
						<div class="form-group row mx-2">
							<input type="hidden" name="ocultoorden_clientes" id="ocultoorden_clientes" value="<%=orden_clientes%>" />
							<input type="hidden" name="ocultocliente_seleccionado" id="ocultocliente_seleccionado" value="<%=cliente_seleccionado%>" />
							<div class="col-sm-12 col-md-8 col-lg-8">
								<label for="cmbclientes" class="control-label">Cliente</label>
								<div class="row">
									<div id="capa_clientes" class="col-sm-12 col-md-10 col-lg-10">
										<select  class="form-control" name="cmbclientes" id="cmbclientes">
											<option value="" selected>* Seleccione *</option>
										</select>
									</div>
									<div class="col-sm-12 col-md-2 col-lg-2">
										<button type="button" class="btn btn-primary" id="cmdquitar_seleccion" name="cmdquitar_seleccion"
											data-toggle="popover"
											data-placement="top"
											data-trigger="hover"
											data-content="Quitar Selecci&oacute;n de La Lista de Clientes"
											data-original-title=""
											onclick="quitar_seleccion()">
											<i class="fas fa-times"></i>
										</button>
										<button type="button" class="btn btn-primary" id="cmdcambiar_orden" name="cmdcambiar_orden"
											data-toggle="popover"
											data-placement="top"
											data-trigger="hover"
											data-content="Reordenar Clientes Por C&oacute;digo"
											data-original-title=""
											onclick="cambiar_orden()">
											<i class="fas fa-sort-numeric-up" id="icono_reordenar"></i>
										</button>
									</div>
								</div>
								<div class="col-12">
									<input  class="form-check-input" name="chkmostrar_borrados" id="chkmostrar_borrados" type="checkbox" value="SI" onclick="control_borrados()" />
										<label class="form-check-label" for="chkmostrar_borrados">Mostrar Borrados</label>
										<%if mostrar_borrados="SI" then%>
											<script language="javascript">
												document.getElementById("chkmostrar_borrados").checked=true
											</script>
										<%end if%>
									
								</div>
							</div>
							<div class="col-sm-12 col-md-2 col-lg-2">
								<label for="txtpedido" class="control-label">Num. Pedido</label>
								<input type="text" class="form-control" name="txtpedido" id="txtpedido"  value="<%=numero_pedido_seleccionado%>" /> 
							</div>
							<div class="col-sm-12 col-md-2 col-lg-2">
								<label for="txthojaruta" class="control-label">Hoja de Ruta</label>
								<input type="text" class="form-control" name="txthoja_ruta" id="txthoja_ruta"  value="<%=hoja_ruta_seleccionada%>" /> 
							</div>
						</div>
						
						<!--tercera linea-->						
						<div class="form-group row mx-2">
							<div class="col-sm-12 col-md-7 col-lg-7" id="autocomplete_articulo">
								<label for="txtarticulo" class="control-label">Art&iacute;culo</label>
								<input type="hidden" name="ocultoarticulo_seleccionado" id="ocultoarticulo_seleccionado" value="" />
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input class="js-typeahead-articulo form-control" name="txtarticulo" id="txtarticulo" type="search" placeholder="Buscar por Descripci&oacute;n o Referencia" autocomplete="off" value="">
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-3 col-lg-3">
								<label for="cmbpedidos_automaticos" class="control-label">Pedidos Autom&aacute;ticos</label>
								<select class="form-control" name="cmbpedidos_automaticos" id="cmbpedidos_automaticos">
										<option value="" selected>* Seleccione *</option>
										<option value="TODOS">TODOS</option>
										<%if vacio_pedidos_automaticos=false then %>
												<%for i=0 to UBound(mitabla_pedidos_automaticos,2)%>
													<option value="<%=mitabla_pedidos_automaticos(CAMPO_pedido_automatico,i)%>"><%=mitabla_pedidos_automaticos(CAMPO_pedido_automatico,i)%></option>
												<%next%>
										<%end if%>
								</select>
								<%if pedido_automatico_seleccionado<>"" then%>
									<script language="javascript">
										document.getElementById("cmbpedidos_automaticos").value='<%=pedido_automatico_seleccionado%>'
									</script>
								<%end if%>
							</div>
							<div class="col-sm-12 col-md-2 col-lg-2">
								<label for="cmdconsultar" class="control-label">&nbsp;</label>
								<button type="button" class="btn btn-primary btn-block" id="cmdconsultar" name="cmdconsultar"
									data-toggle="popover"
									data-placement="top"
									data-trigger="hover"
									data-content="Consultar Pedidos"
									data-original-title=""
									>
									<i class="fas fa-search"></i>&nbsp;&nbsp;&nbsp;Buscar
								</button>
							</div>
						</div>
						
						</form>
					</div><!--del card-body-->
				</div><!--del card-->
			</div><!--del row-->
			
			<div class="row mt-2"><!--nueva linea con la tabla de resultados-->
				<div class="card col-12">
					<div class="card-body">
						<table id="lista_pedidos" name="lista_pedidos" class="table table-striped table-bordered" cellspacing="0" width="100%">
							<thead>
								<tr>
									<th>Cliente</th>
									<th>Pedido</th>
									<th>Fecha</th>
									<th>Importe</th>
									<th>Estado</th>
									<th>Acción</th>
								</tr>
					  		</thead>
						</table>
					</div>
				</div>				

			</div><!-- row de resultados-->
						
		</div><!--del content-fluid-->
	</div><!--fin de content-->
</div><!--fin de wrapper-->


<form name="frmmostrar_pedido" id="frmmostrar_pedido" action="Pedido_Admin.asp" method="post">
	<input type="hidden" value="" name="ocultopedido" id="ocultopedido" />
</form>


<form action="Modificar_Pedido_Imprenta_Admin.asp" method="post" name="frmmodificar_pedido" id="frmmodificar_pedido">
	<input type="hidden" id="ocultopedido_a_modificar" name="ocultopedido_a_modificar" value="" />
	<input type="hidden" id="ocultoempresa_pedido" name="ocultoempresa_pedido" value="" />
	<input type="hidden" id="ocultoaccion" name="ocultoaccion" value="MODIFICAR" />
</form>



<form name="frmcambiar_todo_pedido" id="frmcambiar_todo_pedido" method="post" action="Cambiar_Estado_Todo_Pedido.asp">
	<input type="hidden" id="ocultonumero_pedido_cambiar" name="ocultonumero_pedido_cambiar" value="" />
	<input type="hidden" id="ocultonuevo_estado_pedido" name="ocultonuevo_estado_pedido" value="" />
</form>

<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
	
<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>
    
<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>

<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>

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

<script>
<%
        
	set articulos_typeahead=Server.CreateObject("ADODB.Recordset")
		
	with articulos_typeahead
		.ActiveConnection=connimprenta
		.Source="SELECT ID, CODIGO_SAP, DESCRIPCION, COMPROMISO_COMPRA"
		.Source= .Source & " , DESCRIPCION + ' (' + CODIGO_SAP + '9' AS TODO"
		.Source= .Source & " FROM ARTICULOS"
		.Source= .Source & " ORDER BY DESCRIPCION"
		.Open
	end with

	Response.Write("var searchTags = new Array;" & vbcrlf)
	
	do until articulos_typeahead.eof
		'Response.Write("searchTags.push('" & articulos_typeahead("CODIGO_SAP") & " " & articulos_typeahead("DESCRIPCION") & " (" & articulos_typeahead("ID") & ")" & "');" & vbcrlf)
		cadena_articulos=""
		cadena_articulos=cadena_articulos & "{"
		cadena_articulos=cadena_articulos & "'id': " &  articulos_typeahead("ID") 
		cadena_articulos=cadena_articulos & ", 'descripcion': '" & articulos_typeahead("DESCRIPCION") & "'"
		cadena_articulos=cadena_articulos & ", 'miniatura': '" & articulos_typeahead("ID") & "'"
		cadena_articulos=cadena_articulos & ", 'referencia':  '" & articulos_typeahead("CODIGO_SAP") & "'"
		cadena_articulos=cadena_articulos & ", 'compromiso_compra':  '" & articulos_typeahead("COMPROMISO_COMPRA") & "'"
		cadena_articulos=cadena_articulos & ", 'todo':  '" & articulos_typeahead("TODO") & "'"
		cadena_articulos=cadena_articulos & "}"
		
		Response.Write("searchTags.push(" & cadena_articulos & ");" & vbcrlf)
		
		articulos_typeahead.movenext
	loop
	
	articulos_typeahead.close
	set articulos_typeahead=Nothing
%>
</script>

<script type="text/javascript">
var j$=jQuery.noConflict();
		
j$(document).ready(function () {
	j$("#menu_pedidos").addClass('active')
	
	j$('#sidebarCollapse').on('click', function () {
		j$('#sidebar').toggleClass('active');
		j$(this).toggleClass('active');
	});
	
	
	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true});
	
	j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
	
	j$('#cmbestados').multiselect({enableClickableOptGroups: true, buttonWidth: '100%', nonSelectedText: 'Seleccionar'});
	
	//**********************************
	//este control esta en esta url: http://www.runningcoder.org/jquerytypeahead
	j$.typeahead({
		input: '.js-typeahead-articulo',
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
				'<span class="miniatura">' +
					'<img src="Imagenes_Articulos/Miniaturas/i_{{miniatura}}.jpg">' +
				'</span>' +
				'<span class="descripcion">{{descripcion}}<br><small style="color: ' + color + ';">({{referencia}})</small></span>' +
				'</span>'	
				
			
		},
		emptyTemplate: "sin resultados para {{query}}",
		source: {
			user: {
				//display: "descripcion",
				display: ["descripcion", "referencia"],
				data: searchTags
	 
			}
		},
		callback: {
			onClick: function (node, a, item, event) {
	 
				// You can do a simple window.location of the item.href
				//alert(JSON.stringify(item));
				//alert(item.id)
				j$("#ocultoarticulo_seleccionado").val(item.id)
			},
			onCancel: function (node, a, item, event) {
				j$("#ocultoarticulo_seleccionado").val('')
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
	
	
	
});
		
j$("#cmdconsultar").click(function () {
	consultar_pedidos();
});
		
j$("#txtpedido").keypress(function(e) {
        var code = (e.keyCode ? e.keyCode : e.which);
        if(code==13){
            consultar_pedidos();
        }
    });
		
		
consultar_pedidos = function(perfil) {  
	//console.log('DENTRO DE CONSULTAR_PIRS')
	//console.log('PERFIL: ' + perfil)
	
		
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
		
		
		
		
		prm.add('p_empresa', j$('#cmbempresas').val());
        prm.add('p_cliente', j$('#cmbclientes').val());
		prm.add('p_estado', j$('#cmbestados').val());
		prm.add('p_numero_pedido', j$('#txtpedido').val());
		prm.add('p_fecha_i', j$('#txtfecha_inicio').val());
		prm.add('p_fecha_f', j$('#txtfecha_fin').val())
		prm.add('p_pedido_automatico', j$('#cmbpedidos_automaticos').val());
		prm.add('p_articulo', j$('#ocultoarticulo_seleccionado').val());
		prm.add('p_hoja_ruta', j$('#txthoja_ruta').val());
					
        
        j$.fn.dataTable.moment('DD/MM/YYYY');
        
        //deseleccioamos el registro de la lista
        j$('#lista_pedidos tbody tr').removeClass('selected');
        
        if (typeof lst_pedidos == 'undefined') {
			//console.log('Dentro de la creacion del datatable lst_pirs')
            lst_pedidos = j$('#lista_pedidos').DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:'tojson/consulta_pedidos_obtener_pedidos.asp?'+prm.toString(),
                                                           type:'POST',
                                                           dataSrc:'ROWSET'},
                                                     order:[],
													 columnDefs: [
                                                              {className: "dt-right", targets: [1,2,3]}
															  //,{type: "date-eu", targets: [2]}
                                                            ],
													 columns:[ 
																
																{data:function(row, type, val, meta)
																		{                                                                                                                   
                                                                      	cadena = row.EMPRESA    	
																		if (row.CODIGO_EXTERNO!='')
																			{
																			cadena+='&nbsp;(<b>' + row.CODIGO_EXTERNO + '</b>)';
																			}
																		cadena+='&nbsp;' + row.NOMBRE
																		return cadena
																		}
																},
													 			{data:'Id'},
																{data:'FECHA'
																	/*
																	, type: 'date'
																	, format: 'dd/mm/yyyy'
																	*/
																   	},
															  	{data:'TotalEnvio'
																	,render: function (data, type, row, meta) 
																			{
																			if ( type === "display" ) //si se visualiza se formatea
																				{
																				valor=j$.fn.dataTable.render.number( '.', ',', 2).display(data.replace(',', '.'))
																				return valor + ' €'
																				}
																			  else
																			  	{
																				return data //si no se para visualizar, va sin formatear
																				}	
																			}
																},
																{data:'ESTADO'},
																//{data:'PEDIDO_AUTOMATICO'}
																{data:function(row, type, val, meta)
																		{
																		cadena=''
																		if (row.PEDIDO_AUTOMATICO!='')
																			{
																			cadena+=row.PEDIDO_AUTOMATICO + '<BR/>'
																			}
																		
																		if ((row.ESTADO!='ENVIADO') && (row.EMPRESA_ID!=4) && (row.Nreg!=0))
																			{
																			cadena+='<button type="button" class="btn btn-primary btn-block"  onclick="modificar_pedido(' + row.Id + ', ' + row.EMPRESA_ID + ')">'
																			cadena+='<i class="fas fa-edit"></i>&nbsp;&nbsp;&nbsp;Modificar'
																			cadena+='</button>'
																			
																			}
																		return cadena
																		}
																},
																{data:'PEDIDO_AUTOMATICO', visible: false},
																{data:'EMPRESA_ID', visible: false},
																{data:'Nreg', visible: false},
																{data:'COMPROMISO_COMPRA_NO', visible: false},
																{data:'HOJA_RUTA_SI', visible: false}
                                                            ],
															
													createdRow: function(row, data, dataIndex){
															if (parseFloat(data.HOJA_RUTA_SI)>0)
																{
																j$(row).css('background-color', '#F5FC64');
																}
													},
																
													rowId: 'extn', //para que se refresque sin perder filtros ni ordenacion
                                                    deferRender:true,
    												
													language:{url:'plugins/dataTable/lang/Spanish.json',
																"decimal": ",",
																"thousands": "."
														},
													paging:false,
                                                    processing: true,
                                                    searching:true,
													buttons:[{extend:"copy", text:'<i class="far fa-copy"></i>', titleAttr:"Copiar en Portapapeles", 
																		exportOptions:{columns:[0,1,2,3,4,6]}}, 
															 {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Pedidos", extension:".xls", 
																		exportOptions:{columns:[0,1,2,3,4,6]}}, 
															 {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Pedidos", //orientation:"landscape"
															 			exportOptions:{columns:[0,1,2,3,4,6]}}, 
															 {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Pedidos", 
																		exportOptions:{columns:[0,1,2,3,4,6]}}
															],
                                                    });
													
				//controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_pedidos tbody").on("click","tr", function()
					{  
                  	if (!j$(this).hasClass("selected") ) 
				  		{                  
	                    lst_pedidos.$("tr.selected").removeClass("selected");
    	                j$(this).addClass("selected");
        				}            
                });
				
				//gestiona el dobleclick sobre la fila para mostrar la pantalla del detalle del pedido
				j$("#lista_pedidos").on("dblclick", "tr", function(e) {
				  	var row=lst_pedidos.row(j$(this).closest("tr")).data() 
					parametro_id=row.Id
					parametro_nreg=row.Nreg
				  	
					j$(this).addClass('selected');
				  	j$(this).css('background-color', '#9FAFD1');
				  
				  	mostrar_pedido(parametro_id , parametro_nreg)

				});              
				
				
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_pedidos.ajax.url('tojson/consulta_pedidos_obtener_pedidos.asp?' + prm.toString());
              lst_pedidos.ajax.reload();                  
            }       
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
