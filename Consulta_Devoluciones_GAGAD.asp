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
	CAMPO_GRUPO_ESTADO=3
	with estados
		.ActiveConnection=connimprenta
		.Source="SELECT *"
		.Source= .Source & " FROM ESTADOS"
		.Source= .Source & " ORDER BY GRUPO, ORDEN"
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
	
	<link rel="stylesheet" type="text/css" href="/plugins/bootstrap-touchspin-master/src/jquery.bootstrap-touchspin.css" />

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

#dialog_detalles_devolucion .modal-dialog  {width:98%;}


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





<div class="modal fade" id="dialog_detalles_devolucion" name="dialog_detalles_devolucion" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-lg" style="max-width: 98%;">
        <div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="cabecera_dialog_detalles_devolucion">Modal title</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				  <span aria-hidden="true">&times;</span>
				</button>
  		    </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-12">
                        <table id="lista_detalles_devolucion" name="lista_detalles_devolucion" class="table table-striped table-bordered" cellspacing="0" width="100%">
							<thead>
								<tr>
									<th>Referencia</th>
									<th>Descripci&oacute;n</th>
									<th>Cantidad</th>
									<th>Total</th>
									<th>Pedido</th>
									<th>Albar&aacute;n</th>
									<th>Aceptadas</th>
									<th>Rechazadas</th>
									<th>Pendientes</th>
								</tr>
					  		</thead>
						</table>
						<br /><br />
                    </div>
                </div>
            </div>
            
             
        </div>
    </div>
</div>




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
						<form name="frmconsulta_devoluciones" action="Consulta_Devoluciones_GAGAD.asp" method="post">
						<h5 class="card-title">Opciones de B&uacute;squeda de Devoluciones</h5>
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
								<select name="cmbestados" id="cmbestados" class="form-control">
									<option value="">Seleccionar Opcion</option>
									<option value="SIN TRATAR">SIN TRATAR</option>
									<option value="PENDIENTE">PENDIENTE</option>
									<option value="CERRADA">CERRADA</option>
								</select>
								<!--
								<select name="cmbestados" id="cmbestados" multiple="multiple">
										
										<%
										grupo=""
										if vacio_estados=false then
											for i=0 to UBound(mitabla_estados,2)
												If grupo <> mitabla_estados(CAMPO_GRUPO_ESTADO, i) Then%>
													<optgroup label="<%=mitabla_estados(CAMPO_GRUPO_ESTADO, i)%>">
												<%End If%>
												<option value="<%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%>"><%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%></option>
												
												<%		
												If grupo <> mitabla_estados(CAMPO_GRUPO_ESTADO, i) Then
													grupo = mitabla_estados(CAMPO_GRUPO_ESTADO, i)
													%>
													</optgroup>
													<%
												End If
											Next
										end if
										%>
									
								</select>
								-->
								
								
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
								<label for="txtdevolucion" class="control-label">Num. Devoluci&oacute;n</label>
								<input type="text" class="form-control" name="txtdevolucion" id="txtdevolucion"  value="<%=numero_devolucion_seleccionada%>" /> 
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
							<div class="col-sm-12 col-md-2 col-lg-2">
								<label for="cmdconsultar" class="control-label">&nbsp;</label>
								<button type="button" class="btn btn-primary btn-block" id="cmdconsultar" name="cmdconsultar"
									data-toggle="popover"
									data-placement="top"
									data-trigger="hover"
									data-content="Consultar devoluciones"
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
						<table id="lista_devoluciones" name="lista_devoluciones" class="table table-striped table-bordered" cellspacing="0" width="100%">
							<thead>
								<tr>
									<th>Cliente</th>
									<th>Devoluci&oacute;n</th>
									<th>Fecha</th>
									<th>Estado</th>
									<th>Total</th>
									<th>Total Aceptado</th>
								</tr>
					  		</thead>
						</table>
					</div>
				</div>				
				
				

			</div><!-- row de resultados-->
						
		</div><!--del content-fluid-->
	</div><!--fin de content-->
</div><!--fin de wrapper-->


<form name="frmmostrar_pedido" id="frmmostrar_pedido" action="Pedido_GAGAD.asp" method="post">
	<input type="hidden" value="" name="ocultopedido" id="ocultopedido" />
</form>


<form action="Modificar_Pedido_Imprenta_GAGAD.asp" method="post" name="frmmodificar_pedido" id="frmmodificar_pedido">
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

<script type="text/javascript" src="plugins/bootstrap-touchspin-master/src/jquery.bootstrap-touchspin.js"></script>

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
	j$("#menu_devoluciones").addClass('active')
	
	j$('#sidebarCollapse').on('click', function () {
		j$('#sidebar').toggleClass('active');
		j$(this).toggleClass('active');
	});
	
	
	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true});
	
	//j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
	
	//j$('#cmbestados').multiselect({enableClickableOptGroups: true, buttonWidth: '100%', nonSelectedText: 'Seleccionar'});
	
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
				//console.log('request is sent')
			},
			onReceiveRequest: function (node, query) {
				//console.log('request is received')
			}
		},
		debug: true
	});
	
	
	j$(".spin_cantidades_p").TouchSpin({
		min: 1,
		max: 2000,
		verticalbuttons: true,
		verticalup: '<i class="fas fa-angle-up fa-sm"></i>',
		verticaldown: '<i class="fas fa-angle-down fa-sm"></i>'
	});
				
	
	//para que muestre los devoluciones sin tratar directamente al entrar en la pagina sin tener que consultar
   consultar_devoluciones()
});
		
j$("#cmdconsultar").click(function () {
	consultar_devoluciones();
});
		
j$("#txtdevolucion").keypress(function(e) {
        var code = (e.keyCode ? e.keyCode : e.which);
        if(code==13){
            consultar_devoluciones();
        }
    });
		
		
consultar_devoluciones = function() {  
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
		prm.add('p_numero_devolucion', j$('#txtdevolucion').val());
		prm.add('p_fecha_i', j$('#txtfecha_inicio').val());
		prm.add('p_fecha_f', j$('#txtfecha_fin').val())
		prm.add('p_articulo', j$('#ocultoarticulo_seleccionado').val());
		
        
        j$.fn.dataTable.moment('DD/MM/YYYY');
        
        //deseleccioamos el registro de la lista
        j$('#lista_devoluciones tbody tr').removeClass('selected');
        
        if (typeof lst_devoluciones == 'undefined') {
			//console.log('Dentro de la creacion del datatable lst_pirs')
            lst_devoluciones = j$('#lista_devoluciones').DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:'tojson/consulta_devoluciones_GAGAD_obtener_devoluciones.asp?'+prm.toString(),
                                                           type:'POST',
                                                           dataSrc:'ROWSET'},
                                                     order:[],
													 columnDefs: [
                                                              {className: "dt-right", targets: [1,2,3,4,5]}
															  //,{type: "date-eu", targets: [2]},
                                                            ],
													 columns:[ 
																  
																{ data: "NOMBRE",
																	render: function(data, type, row){
																		cadena_total=''
																		switch(type) {
																				case 'export':
																				
																					cadena_total = row.EMPRESA    	
																					if (row.CODIGO_EXTERNO!='')
																						{
																						cadena_total+='&nbsp;(<b>' + row.CODIGO_EXTERNO + '</b>)';
																						}
																					cadena_total+='&nbsp;' + row.NOMBRE
																					if (row.USUARIO_DIRECTORIO_ACTIVO!='')
																						{
																						cadena_total+='&nbsp;(' + row.NOMBRE_EMPLEADO + ')';
																						}
																					break;
												
																				default:
																					cadena_total = row.EMPRESA    	
																					if (row.CODIGO_EXTERNO!='')
																						{
																						cadena_total+='&nbsp;(<b>' + row.CODIGO_EXTERNO + '</b>)';
																						}
																					cadena_total+='&nbsp;' + row.NOMBRE
																					if (row.USUARIO_DIRECTORIO_ACTIVO!='')
																						{
																						cadena_total+='&nbsp;(' + row.NOMBRE_EMPLEADO + ')';
																						}

																					
																				}
																		
																		return cadena_total;
																	}},	  
													 			{data:'ID'},
																{data:'FECHA'
																	/*
																	, type: 'date'
																	, format: 'dd/mm/yyyy'
																	*/
																   	},
																{data:'ESTADO'},
																{data:'TOTAL'},
																{data:'TOTAL_ACEPTADO'},
																{data:'EMPRESA_ID', visible: false},
																{data:'USUARIO_DIRECTORIO_ACTIVO', visible: false},
																{data:'NOMBRE_EMPLEADO', visible: false},
                                                            ],
															
													createdRow: function(row, data, dataIndex){
															/*
															if (parseFloat(data.HOJA_RUTA_SI)>0)
																{
																j$(row).css('background-color', '#F5FC64');
																}
																*/
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
																		exportOptions:{columns:[0,1,2,3,4,5]}}, 
															 {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"devoluciones", extension:".xls", 
																		exportOptions:{columns:[0,1,2,3,4,5],
																						//al exportar a excel no pasa bien los decimales, le quita la coma
																						format: {
																								  body: function(data, row, column, node) {
																									  		data = j$('<p>' + data + '</p>').text();
																									  		return j$.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
																								  		}
																								}
																		}}, 
															 {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"devoluciones", //orientation:"landscape"
															 			exportOptions:{columns:[0,1,2,3,4,5]}}, 
															 {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"devoluciones", 
																		exportOptions:{columns:[0,1,2,3,4,5]}}
															],
															
													drawCallback: function () {
															//para que se configuren los popover-titles...
															j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
														}
                                                    });
													
				//controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_devoluciones tbody").on("click","tr", function()
					{  
                  	if (!j$(this).hasClass("selected") ) 
				  		{                  
	                    lst_devoluciones.$("tr.selected").removeClass("selected");
    	                j$(this).addClass("selected");
        				}            
                });
				
				//gestiona el dobleclick sobre la fila para mostrar la pantalla del detalle del devolucion
				j$("#lista_devoluciones").on("dblclick", "tr", function(e) {
				  	var row=lst_devoluciones.row(j$(this).closest("tr")).data() 
					parametro_id=row.ID
				  	
					//j$(this).addClass('selected');
				  	//j$(this).css('background-color', '#9FAFD1');
				  
				  	consultar_detalles_devolucion(parametro_id)
					j$("#cabecera_dialog_detalles_devolucion").html('Detalles de La Devoluci&oacute;n ' + parametro_id)
					j$("#dialog_detalles_devolucion").modal("show")

				});              
				
				//la barra de botones encima de la cabecera
				j$("#lista_devoluciones").on("xhr.dt", function(e, settings, json, xhr) {
					/*
					j$("#tb_servicios .dataTables_scrollBody").scroll(function() {
					  j$("#tb_servicios .dataTables_scrollHead").scrollLeft(j$("#tb_servicios .dataTables_scrollBody").scrollLeft());
					});
					*/
				  }); 
				
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_devoluciones.ajax.url('tojson/consulta_devoluciones_GAGAD_obtener_devoluciones.asp?' + prm.toString());
              lst_devoluciones.ajax.reload();                  
            }       
  };		
	
	
consultar_detalles_devolucion = function(id_devolucion) {  
	
		
      var err ="";
		
		 
        j$.fn.dataTable.moment('DD/MM/YYYY');
		
		
        //deseleccioamos el registro de la lista
        j$('#lista_detalles_devolucion tbody tr').removeClass('selected');
		
		
        if (typeof lst_detalles_devolucion == 'undefined') {
			//alert('vamos a crear el datatable')
			//console.log('Dentro de la creacion del datatable lst_pirs')
			//console.log('creamos el datatable... con id devolucion... ' + id_devolucion)
            lst_detalles_devolucion = j$('#lista_detalles_devolucion').DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:'tojson/consulta_devoluciones_GAGAD_obtener_detalles_devolucion.asp?p_id_devolucion=' + id_devolucion,
                                                           type:'POST',
                                                           dataSrc:'ROWSET'},
                                                     order:[],
													 columnDefs: [
                                                              {className: "dt-right", targets: [2,3,4,5,6,7,8]}
															  , { "orderable": false, "targets": 6 }
															  //,{type: "date-eu", targets: [2]}
                                                            ],
													 columns:[ 
																  
																
													 			{data:'REFERENCIA'},
																{data:'DESCRIPCION'},
																{data:'CANTIDAD'},
																{data:'TOTAL'},
																{data:'PEDIDO'},
																{data:'ALBARAN'},
																{data:'UNIDADES_ACEPTADAS'},
																{data:'UNIDADES_RECHAZADAS'},
																{data:'UNIDADES_PENDIENTES',
																			render: function(data, type, row){
																					cadena_total=''
																					//console.log('estado: ' + row.ESTADO)
																					//console.log('type: ' + type)
																					switch(type) {
																							case 'export':
																								//console.log('ES UN EXPORT estado: ' + row.ESTADO)
																								cadena_total=''
																								break;
																								
																							case 'sort':
																								cadena_total=''
																								break;		
																								
																							default:
																								//si no se han tramitado todas las unidades
																								cadena=''
																								aceptadas=parseFloat(row.UNIDADES_ACEPTADAS)
																								rechazadas=parseFloat(row.UNIDADES_RECHAZADAS)
																								totales=parseFloat(aceptadas + rechazadas)
																								cantidades=parseFloat(row.CANTIDAD)
																								//console.log('vemos si hay que poner el combo para rechazar aceptar devoluciones')
																								//console.log('aceptadas: ' + aceptadas)
																								//console.log('rechazadas: ' + rechazadas)
																								//console.log('TOTALES: ' + totales)
																								//console.log('CANTIDADS: ' + cantidades)
																								if ( totales != cantidades )
																									{
																									//console.log('desde dentro de hacer el combo')
																								
																									//console.log('TOTALES: ' + totales)
																									//console.log('CANTIDADS: ' + cantidades)
																									
																									cadena+='<div class="row">'
																									cadena+='<div class="col-md-5">'
																									cadena+='<input class="form-control-sm form-control spin_cantidades" id="spin_cantidad_' + row.ID_DETALLE_DEVOLUCION + '" type="text" value="' + row.UNIDADES_PENDIENTES + '" name="spin_cantidad_' + row.ID_DETALLE_DEVOLUCION + '" style="padding:2; font-size:12px">'
																									cadena+='</div>'
																									cadena+='<div class="col-md-5">'
																									cadena+='<select class="form-control form-control-sm  custom-select-sm cmbestados_detalle_datatable" id="cmbestados_detalle_datatable_' + row.ID_DETALLE_DEVOLUCION + '" style="font-size: 11px;">'
																									cadena+='<option value="SIN TRATAR" style="font-size: 11px;">SIN TRATAR</option>'
																									cadena+='<option value="ACEPTADO" style="font-size: 11px;">ACEPTADO</option>'
																									cadena+='<option value="RECHAZADO" style="font-size: 11px;">RECHAZADO</option>'
																									cadena+='</select>'
																									cadena+='</div>'
																									cadena+='<div class="col-md-2">'
																									cadena+='<button type="button" class="btn btn-primary boton_guardar_detalle_devolucion"'
																									cadena+=' data-toggle="popover_datatable_detalle"'
																									cadena+=' data-placement="bottom"'
																									cadena+=' data-trigger="hover"'
																									cadena+=' data-content="Guardar Estado"'
																									cadena+=' data-original-title=""'
																									cadena+=' style="display:none; margin-top:5px">'
																									cadena+='<i class="far fa-save"></i>'
																									cadena+='</button>'
																									cadena+='</div>'
																									cadena+='</div>'
																									}
																								
																								//console.log('desde fuera de hacer el combo')
																								/*
																								cadena+='<div class="row">'
																								cadena+='<div class="col-md-12">'
																								cadena+='Aceptadas: ' + row.UNIDADES_ACEPTADAS
																								cadena+='<BR>Rechazadas: ' + row.UNIDADES_RECHAZADAS
																			                    cadena+='</div>'
																								cadena+='</div>'
																			                    */
																								cadena_total=cadena
																							}
																						return cadena_total
																			}}, 
																
																{data:'ID_DETALLE_DEVOLUCION', visible: false},
																{data:'ID_DEVOLUCION', visible: false},
																{data:'ID_ARTICULO', visible: false}
                                                            ],
															
													createdRow: function(row, data, dataIndex){

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
																		exportOptions:{columns:[0,1,2,3,4,5]}}, 
															 {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Detalles Devolucion " + id_devolucion, extension:".xls", 
																		exportOptions:{columns:[0,1,2,3,4,5],
																						//al exportar a excel no pasa bien los decimales, le quita la coma
																						format: {
																								  body: function(data, row, column, node) {
																									  		data = j$('<p>' + data + '</p>').text();
																									  		return j$.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
																								  		}
																								}
																		
																		}}, 
																		
																		
															 {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Detalles Devolucion " + id_devolucion, //orientation:"landscape"
															 			exportOptions:{columns:[0,1,2,3,4,5]}}, 
															 {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Detalles Devolucion" + id_devolucion, 
																		exportOptions:{columns:[0,1,2,3,4,5]}}
															],
															
													rowCallback: function (row, data, index) {
														
														var spin_cantidad = j$(row).find('.spin_cantidades');
														//console.log('dentro de rowcallback para albaranDETALLES: ' +  data.IDALBARANDETALLES)
															j$(spin_cantidad).TouchSpin({
																	min: 1,
																	max: data.UNIDADES_PENDIENTES,
																	verticalbuttons: true,
																	verticalup: '<i class="fas fa-angle-up fa-sm"></i>',
																	verticaldown: '<i class="fas fa-angle-down fa-sm"></i>'
																});
															
															j$(spin_cantidad).on("touchspin.on.stopspin", function() {
																//console.log("touchspin.on.stopspin");
															  });
															  
															j$(spin_cantidad).on("change", function() {
																//console.log("change");
																/*
																var row=lst_articulos_a_devolver.row($(this).closest("tr")).data()
																cantidad_nueva=$(this).val()
																precio = row.PRECIO_UNIDAD
																total_nuevo= cantidad_nueva * precio
																//console.log('cantidad nueva: ' + cantidad_nueva)
																//console.log('precio: ' + precio)
																//console.log('total_nuevo: ' + total_nuevo)
																row.IMPORTE= total_nuevo
																*/ 
															  });
													},
															
													drawCallback: function () {
															//para que se configuren los popover-titles...
															j$('[data-toggle="popover_datatable_detalle"]').popover({html:true, container: 'body'});
														}
                                                    });
													
				//controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_detalles_devolucion tbody").on("click","tr", function()
					{  
                  	/*
					if (!j$(this).hasClass("selected") ) 
				  		{                  
	                    lst_detalles_devolucion.$("tr.selected").removeClass("selected");
    	                j$(this).addClass("selected");
        				}            
					*/
                });
				
				//gestiona el dobleclick sobre la fila para mostrar la pantalla del detalle del devolucion
				j$("#lista_devoluciones").on("dblclick", "tr", function(e) {
				  	/*
					var row=lst_detalles_devolucion.row(j$(this).closest("tr")).data() 
					parametro_id=row.ID
				  	
					//j$(this).addClass('selected');
				  	//j$(this).css('background-color', '#9FAFD1');
				  
				  	mostrar_detalles_devolucion(parametro_id)
					j$("#dialog_detalles_devolucion").modal("show")
					*/
				});              
				
				//la barra de botones encima de la cabecera
				j$("#lista_detalles_devolucion").on("xhr.dt", function(e, settings, json, xhr) {
					/*
					j$("#tb_servicios .dataTables_scrollBody").scroll(function() {
					  j$("#tb_servicios .dataTables_scrollHead").scrollLeft(j$("#tb_servicios .dataTables_scrollBody").scrollLeft());
					});
					*/
				  }); 
				
				j$('#lista_detalles_devolucion').on('change', '.cmbestados_detalle_datatable', function () {
					//console.log('cambiando el valor a: ' + this.value);
					//j$(this).css('background-color', '#9FAFD1');
					//j$(this).parent().css({"color": "green", "border": "2px solid green"});
					var tbl_row = j$(this).closest('tr');
					if (j$(this).val()=='SIN TRATAR')
						{
						tbl_row.find('.boton_guardar_detalle_devolucion').hide();
						}
					  else
					  	{
						tbl_row.find('.boton_guardar_detalle_devolucion').show();
						}
					//tbl_row.find('.boton_cancelar_guardar_estado').show();
					//j$(this).closest("boton_guardar_estado").show()
		
				});
				
				
				j$('#lista_detalles_devolucion').on('click', '.boton_guardar_detalle_devolucion', function () {
						//console.log('cambiando el valor a: ' + this.value);
						//j$(this).css('background-color', '#9FAFD1');
						//j$(this).parent().css({"color": "green", "border": "2px solid green"});
			
						var tbl_row = j$(this).closest('tr');
						var row = lst_detalles_devolucion.row(tbl_row).data()
						parametro_id_devolucion=row.ID_DEVOLUCION
						parametro_id_detalle_devolucion = row.ID_DETALLE_DEVOLUCION
						parametro_estado_nuevo = tbl_row.find('.cmbestados_detalle_datatable').val()
						parametro_cantidad = tbl_row.find('.spin_cantidades').val()
						parametro_id_articulo=row.ID_ARTICULO
			
						//console.log('LOS VALORES A GUARDAR SON: detalle_devlucionA.... ' + parametro_id_detalle_devolucion + ' ... ESTADO... ' + parametro_estado_nuevo + ' ..... cantidad: ' + parametro_cantidad)
						
			
						controles_visibles = 0
						j$('.boton_guardar_detalle_devolucion').each(function (index, value) {
							//console.log('div' + index + ':' + $(this).attr('id'));
							if (j$(this).is(":visible")) {
								controles_visibles++
							}
						});
			
						if (controles_visibles > 1) {
							bootbox.alert({
								//size: 'large',
								message: '<h5>Hay un Cambio Pendiente de Guardar</h5>'
								//callback: function () {return false;}
							})
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
			
					});

				
              }
            else{     
              //stf.lst_tra.clear().draw();
			  //console.log('refrescamos el datatable... con id devolucion... ' + id_devolucion)
			  lst_detalles_devolucion.ajax.url('tojson/consulta_devoluciones_GAGAD_obtener_detalles_devolucion.asp?p_id_devolucion=' + id_devolucion);
			  lst_detalles_devolucion.ajax.reload();                  
			  
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
