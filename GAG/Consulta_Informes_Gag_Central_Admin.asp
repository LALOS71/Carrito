<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->
<%
		response.Buffer=true
		numero_registros=0
		
		if session("usuario")="" then
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
		end if
		
		empresa_seleccionada="" & Request.Form("cmbempresas")
		cadena_empresas=""
		cliente_seleccionado="" & Request.Form("cmbclientes")
		estado_seleccionado=Request.Form("cmbestados")
		numero_pedido_seleccionado=Request.Form("txtpedido")
		fecha_i=Request.Form("txtfecha_inicio")
		fecha_f=Request.Form("txtfecha_fin")
		tipo_cliente_seleccionado=Request.Form("cmbtipos_cliente")
		filtro_pedidos=Request.Form("cmbfiltros")
		'response.write("<br>empresa seleccionada: " & empresa_seleccionada)
		
		'response.write("<br>filtros: " & filtro_pedidos)
		
		'para las cadenas de avoris, tengo que controlar si se muestran juntos pedidos de varias empresas en funcion
		' de la seleccion del combo de emrpesas
		if session("usuario_codigo_empresa")<>230 then
			cadena_empresas=session("usuario_codigo_empresa")
		 else
		 	if empresa_seleccionada="" then
				'si no seleccina empreas en concreto, se muestran los pedidos de HALCON, ECUADOR, PORTUGAL, TRAVELPLAN, GEOMOON
				'   GLOBALIA CORPORATE TRAVEL, MARSOL y AVORIS, FRANQUICIAS HALCON Y FRANQUICIAS ECUADOR
				cadena_empresas="10, 20,30, 80, 90, 130, 170, 210, 230, 240, 250"
			  else
			  	cadena_empresas=empresa_seleccionada
			end if
		end if
		
		
		if filtro_pedidos="" then
			filtro_pedidos="TODOS"
		end if
		
		if cliente_seleccionado="" and estado_seleccionado="" and numero_pedido_seleccionado="" and fecha_i="" and fecha_f="" then
				estado_seleccionado="PENDIENTE AUTORIZACION"
		end if
		
		mostrar_borrados=Request.Form("chkmostrar_borrados")
		if mostrar_borrados<>"SI" then
			mostrar_borrados="NO"
		end if
		
		'recordsets
		dim pedidos
		
		
		'variables
		dim sql
		
		

	    'porque el sql de produccion es un sql expres que debe tener el formato de
		' de fecha con mes-dia-a�o, y al lanzar consultas con fechas da error o
		' da resultados raros
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
		
	    set pedidos=Server.CreateObject("ADODB.Recordset")
		
		with pedidos
			.ActiveConnection=connimprenta
			.Source="SELECT  V_EMPRESAS.EMPRESA AS DESCRIPCION_EMPRESA, V_CLIENTES.EMPRESA, V_CLIENTES.CODIGO_EXTERNO, V_CLIENTES.NOMBRE, V_CLIENTES.TIPO,"
			.Source= .Source & " PEDIDOS.ID, PEDIDOS.CODCLI, PEDIDOS.PEDIDO,"
			.Source= .Source & " PEDIDOS.FECHA, PEDIDOS.ESTADO, PEDIDOS.FECHA_ENVIADO, V_CLIENTES.PAIS, PEDIDOS.PEDIDO_AUTOMATICO"
			.Source= .Source & " FROM  PEDIDOS INNER JOIN V_CLIENTES ON PEDIDOS.CODCLI = V_CLIENTES.Id"
			.Source= .Source & " INNER JOIN V_EMPRESAS ON V_CLIENTES.EMPRESA=V_EMPRESAS.ID"
			.Source= .Source & " WHERE V_CLIENTES.EMPRESA IN (" & cadena_empresas & ")"
			'para gls portugal que solo se muestren los pedidos de las agencias de portugal
			if session("usuario_codigo_empresa")=4 and session("usuario")=7637 then
				.Source= .Source & " AND PAIS='PORTUGAL'"
			end if
			if estado_seleccionado<>"" then
				.Source= .Source & " AND PEDIDOS.ESTADO='" & estado_seleccionado & "'"
			end if
			if cliente_seleccionado<>"" then
				.Source= .Source & " AND PEDIDOS.CODCLI=" & cliente_seleccionado
			end if
			if numero_pedido_seleccionado<>"" then
				.Source= .Source & " AND PEDIDOS.ID=" & numero_pedido_seleccionado
			end if
			
			if fecha_i<>"" then
				.Source= .Source & " AND (PEDIDOS.FECHA >= '" & fecha_i & "')" 
			end if
			if fecha_f<>"" then
				.Source= .Source & " AND (PEDIDOS.FECHA <= '" & fecha_f & "')"
			end if
			
			if tipo_cliente_seleccionado<>"" then
				.Source= .Source & " AND (V_CLIENTES.TIPO='" & tipo_cliente_seleccionado & "')"
			end if
			
			if filtro_pedidos="MERCHAN" then
				.Source= .Source & " AND PEDIDOS.PEDIDO_AUTOMATICO='PEDIDO_MERCHAN'"
			end if
			
			if filtro_pedidos="MATERIAL_OFICINA" then
				.Source= .Source & " AND PEDIDOS.PEDIDO_AUTOMATICO IS NULL"
			end if
			
			if filtro_pedidos="HIGIENICOS" then
				.Source= .Source & " AND PEDIDOS.PEDIDO_AUTOMATICO='HIGIENE_Y_SEGURIDAD'"
			end if
			
			.Source= .Source & " ORDER BY PEDIDOS.FECHA desc, V_CLIENTES.NOMBRE desc"
			'response.write("<br>consulta pedidos: " & .Source)
			.Open
		end with

		
		




		dim tipos_cliente
		set tipos_cliente=Server.CreateObject("ADODB.Recordset")
		
		
		sql="SELECT ID, EMPRESA, TIPO, ORDEN FROM V_CLIENTES_TIPO"
		sql=sql & " WHERE EMPRESA=" & session("usuario_codigo_empresa") 
		sql=sql & " ORDER BY ORDEN"
		
		'response.write("<br>" & sql)
		
		with tipos_cliente
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
		

%>
<html>
<head>
<title>Informes</title>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-4.0.0/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-select/css/bootstrap-select.min.css">
		

<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />


<script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

	<!--
	<link rel="stylesheet" type="text/css" href="../plugins/Datatable_1_13_2/jquery.dataTables.css"/>
	-->
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

	
	<%'aplicamos un tipo de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>

<link rel="stylesheet" type="text/css" href="../plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min.css">	

  
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
		

.aviso {
	font-family: Verdana, Arial, Helvetica, sans-serif;
  	font-size: 18px;
  	color: #000000;
  	text-align: center;
	background-color:#33FF33
}  	


.girado {
        -moz-transform: scaleX(-1);
        -o-transform: scaleX(-1);
        -webkit-transform: scaleX(-1);
        transform: scaleX(-1);
        filter: FlipH;
        -ms-filter: "FlipH";
}

.merchan
{
	color:blue;
}



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

<div class="container-fluid">
   <!--PANTALLA-->
  <div class="row mt-1">
    <!--COLUMNA IZQUIERDA -->
    <div class="col-xs-12 col-sm-12 col-md-4 col-lg-3 col-xl-3" id="columna_izquierda">
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
								<button type="button" id="cmdarticulos" name="cmdarticulos" class="btn btn-primary btn-md" title="Consultar Art�culos">
										<i class="fas fa-list-ul"></i>
										<span>Artículos</span>
								</button>
								<button type="button" id="cmdpedidos" name="cmdpedidos" class="btn btn-primary btn-md" title="Consultar Pedidos">
										<i class="fas fa-file-alt"></i>
										<span>Pedidos</span>
								</button>
							</div>
							<%'la central de GLS, es la que lleva la gestion de las impresoras
							if session("usuario")=2784 then%>				
								<div class="row"  style="margin-top:5px">
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
		</div>

	  <%'seccion de informes solo para la central de GLS
		if session("usuario")=2784 OR session("usuario")=846 then%>	
		<div class="row mt-2">
			<div class="col-12 m-0 pr-0">
				<div class="card">
					<div class="card-header"><b>Informes</b></div>
					<div class="card-body">  
						<div class="card-text" align="center">
							<button type="button" id="cmdinformes_GLS" name="cmdinformes_GLS" class="btn btn-primary btn-md" 
									data-toggle="popover" 
									data-placement="bottom" 
									data-trigger="hover" 
									data-content="Informe de Pedidos" 
									data-original-title=""
									>
										<i class="far fa-list-alt"></i>
										<span>Informe Pedidos</span>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%end if%>
	
			
	  
    </div>
    <!--FINAL COLUMNA DE LA IZQUIERDA-->
    
		
    <!--COLUMNA DE LA DERECHA-->
	<%'solo lo tiene que ver la central de GLS - 2784
	if session("usuario")=2784 OR session("usuario")=846 then%>
    <div class="col-xs-12 col-sm-12 col-md-8 col-lg-9 col-xl-9">
		<!--FILTROS-->
		<div class="row">
			<div class="col-12 m-0 pr-0">
				<div class="card">
					<div class="card-header"><b>Opciones de Filtro</b></div>
					<div class="card-body">  
						<div class="card-text">
							<div class="row">
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
								<div class="col-sm-12 col-md-3 col-lg-2">
									<label for="txtfecha_inicio" class="control-label">Fecha de Inicio</label>
									<input type="date" class="form-control" name="txtfecha_inicio" id="txtfecha_inicio"  value="<%=fecha_i%>" /> 
								</div>
								<div class="col-sm-12 col-md-3 col-lg-2">
									<label for="txtfecha_fin" class="control-label">Fecha Fin</label>
									<input type="date" class="form-control" name="txtfecha_fin" id="txtfecha_fin"  value="<%=fecha_f%>" /> 
								</div>
								<div class="col-md-1">
									<span class="align-text-bottom">
									<button type="button" id="cmdconsultar_consumos" name="cmdconsultar_consumos" class="btn btn-primary btn-block">
										<i class="fas fa-search"></i>
									</button>
									</span>
								</div>
							</div>	
							<div class="row">&nbsp;</div>
							<div class="row h-100">
								<div class="col-7 my-auto">
									<label for="cmbclientes" class="control-label">Clientes</label>
									<div id="capa_clientes">
										<input type="hidden" id="oculto_valor_cmbclientes" name="oculto_valor_cmbclientes" value="" />
										<select class="form-control" name="cmbclientes" id="cmbclientes" size="1">
											<option value="">Seleccionar Cliente</option>
										</select>
									</div>
									
									<input name="chkmostrar_borrados" id="chkmostrar_borrados" type="checkbox" value="SI" onclick="control_borrados()" />&nbsp;Mostrar Borrados
									<%if mostrar_borrados="SI" then%>
										<script language="javascript">
											document.getElementById("chkmostrar_borrados").checked=true
										</script>
									<%end if%>
								</div>
								<div class="col-4 my-auto">
									<div class="form-inline form-check">
										<input  type="checkbox" class="form-check-input" name="chkdiferenciar_articulos" id="chkdiferenciar_articulos" value="" />
										<label class="form-check-label" for="chkdiferenciar_articulos">
										Diferenciar Articulos
										</label>
									</div>
									<div class="form-inline form-check">
										<input  type="checkbox" class="form-check-input" name="chkdiferenciar_sucursales" id="chkdiferenciar_sucursales" value="" />
										<label class="form-check-label" for="chkdiferenciar_sucursales">
										Diferenciar Sucursales
										</label>
									</div>
									<div class="form-inline form-check">
										<input  type="checkbox" class="form-check-input" name="chkdiferenciar_tipo" id="chkdiferenciar_tipo" value="" />
										<label class="form-check-label" for="chkdiferenciar_tipo">
										Diferenciar Tipo
										</label>
									</div>
								</div>
							</div>
												
						</div>
					</div>
				</div>
			</div>
		</div>
	
	
	
		<!--PEDIDOS REALIZADOS-->
		<div class="row">&nbsp;</div>
		<div class="row">
			<div class="col-12 pr-0">
				<div class="card m-0">
					<div class="card-body">
						<table id="lista_consumos" name="lista_consumos" class="table table-striped table-bordered" cellspacing="0" width="98%">
						<thead>
							<tr>
								<th>Cod. Sap</th>
								<th>Descripción</th>
								<th>Unidades Pedido</th>
								<th>Cliente</th>
								<th>Tipo</th>
								<th>Cantidad Total</th>
								<th>Total Importe</th>
								<th>Unidades Devueltas</th>
								<th>Total Importe Dev.</th>
								<th>Cantidad Neta</th>
								<th>Total Importe Neto</th>
							</tr>
						</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
	
    </div>
	<%end if%>
    <!--FINAL COLUMNA DE LA DERECHA-->
  </div>    
  <!-- FINAL DE LA PANTALLA -->
</div>
<!--FINAL CONTAINER-->








			
			
			
<script type="text/javascript" src="../js/comun.js"></script>

<script type="text/javascript" src="../plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>
	
<script type="text/javascript" src="../plugins/popper/popper-1.14.3.js"></script>
    
<script type="text/javascript" src="../plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>

<script src="../funciones.js" type="text/javascript"></script>

<script type="text/javascript" src="../plugins/Datatable_1_13_2/jquery.dataTables.js"></script>

<script type="text/javascript" src="../plugins/Datatables_4/JSZip-2.5.0/jszip.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/pdfmake-0.1.36/pdfmake.js"></script>
<script type="text/javascript" src="../plugins/Datatables_4/pdfmake-0.1.36/vfs_fonts.js"></script>
<!--
<script type="text/javascript" src="../plugins/Datatables_4/DataTables-1.10.18/js/jquery.dataTables.js"></script>
-->
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
<script type="text/javascript" src="../plugins/Datatables_4/Plugins/ellipsis.js"></script>



<script type="text/javascript" src="../plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="../plugins/datetime-moment/datetime-moment.js"></script>  

<script type="text/javascript" src="../plugins/datetime-moment/moment-with-locales.js"></script>
<script type="text/javascript" src="../plugins/datepicker/js/bootstrap-datetimepicker.js"></script>

<script type="text/javascript" src="../plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min_unicode.js"></script>

<script type="text/javascript" src="../plugins/bootbox-4.4.0/bootbox.min.js"></script>



<script language="javascript">
	let codigo_empresa= '<%= session("usuario_codigo_empresa") %>';
	console.log(codigo_empresa);
	console.log(typeof(codigo_empresa));

	/* console.log(codigo_empresa); */
function control_borrados()
	{
	//console.log('checkbox: ' + document.getElementById('chkmostrar_borrados').checked)
	$("#oculto_valor_cmbclientes").val($("#cmbclientes").val())
	if (document.getElementById('chkmostrar_borrados').checked)
		{
		cargar_clientes('SI')
		}
	  else
	  	{
		cargar_clientes('NO')
		//$("#cmbclientes").val('').change()
		}
	$("#cmbclientes").val($("#oculto_valor_cmbclientes").val()).change()
		
	}




$("#cmdconsultar_consumos").on("click", function () {
	validar()
});


function validar()
{
	//console.log('...dentro de validar...')
	hay_error='NO'
	cadena_error=''
	
	//console.log('fecha inicio: ' + $('#txtfecha_inicio').val())
	//console.log('fecha fin: ' + $('#txtfecha_fin').val())
	if (($('#txtfecha_inicio').val!='') && ($('#txtfecha_fin').val()!=''))
		{
		if ($('#txtfecha_inicio').val() > $('#txtfecha_fin').val())
			{
			hay_error='SI'
			cadena_error+='<br>- La Fecha de Inicio ha de ser anterior a la Fecha de fin.'
			}
		}		
		
	if (hay_error=='SI')
		{
		cadena='<br><BR><H3>Se han encontrado los siguientes errores:</H3><BR><br><H5>' + cadena_error + '</H5>'
		bootbox.alert({
					size: 'large',
					message: cadena
					//callback: function () {return false;}
				}); 
		}
	  else
	  	{
		consultar_consumos()
		}
}

calcDataTableHeight = function(porcentaje) {
    return $(window).height()*porcentaje/100;
  };

consultar_consumos = function() {  
      var err ="";
		
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
		
		
		
		
		/*
		prm.add('p_empresa', j$('#cmbempresas').val());
        prm.add('p_cliente', j$('#cmbclientes').val());
		prm.add('p_estado', j$('#cmbestados').val());
		prm.add('p_numero_pedido', j$('#txtpedido').val());
		prm.add('p_fecha_i', j$('#txtfecha_inicio').val());
		prm.add('p_fecha_f', j$('#txtfecha_fin').val())
		prm.add('p_pedido_automatico', j$('#cmbpedidos_automaticos').val());
		prm.add('p_articulo', j$('#ocultoarticulo_seleccionado').val());
		prm.add('p_hoja_ruta', j$('#txthoja_ruta').val());
		*/			
		//console.log('cliente seleccionado: ' +  $('#cmbclientes').val())
		prm.add('codigo_empresa', codigo_empresa);
		/* prm.add('p_vercadena', "SI"); */
		prm.add('p_id_articulo', $('#ocultoarticulo_seleccionado').val());
		prm.add('p_id_cliente', $('#cmbclientes').val());
		prm.add('p_fecha_i', $('#txtfecha_inicio').val());
		prm.add('p_fecha_f', $('#txtfecha_fin').val())
		valor='NO'
		if ($("#chkdiferenciar_articulos").prop('checked'))
			{
			valor='SI'
			}
		prm.add('p_diferenciar_articulos', valor)

		valor='NO'
		if ($("#chkdiferenciar_sucursales").prop('checked'))
			{
			valor='SI'
			}
		prm.add('p_diferenciar_sucursales', valor)
			
		valor='NO'
		if ($("#chkdiferenciar_tipo").prop('checked'))
			{
			valor='SI'
			}
		prm.add('p_diferenciar_tipo', valor)
			
		
        $.fn.dataTable.moment('DD/MM/YYYY');
        
        //deseleccioamos el registro de la lista
        $('#lista_consumos tbody tr').removeClass('selected');
        /* console.log(prm.toString()); */
        if (typeof lst_consumos == 'undefined') {
			//console.log('Dentro de la creacion del datatable lst_pirs')
            lst_consumos = $('#lista_consumos').DataTable({dom:'Blfrtip',
                                                          ajax:{url:'../tojson/consulta_informes_gag_central_admin_obtener_consumos.asp?' + prm.toString(),
                                                           type:'POST',
                                                           dataSrc:'ROWSET'},
                                                     order:[],
													 //colReorder: true,
													 columnDefs: [
                                                              {className: "dt-right", targets: [5,6,7,8,9,10]},
															  {targets: [5, 7, 9], render: $.fn.dataTable.render.number('.', ',', 0, '')},
															  //{targets: 1, render: $.fn.dataTable.render.ellipsis( 10 )},
															  //{targets: [6, 8, 10], render: $.fn.dataTable.render.number('.', ',', 2, '', ' �')}
															  
															  //,{type: "date-eu", targets: [2]}
                                                            ],
													 columns:[ 
																{data: 'CODIGO_SAP'},
													 			{data: 'ARTICULO'},
																{data: 'UNIDADES_DE_PEDIDO'},
																{data: 'NOMBRE'},
																{data: 'TIPO'},
																{data: 'CANTIDAD_TOTAL'},
																{data: 'TOTAL_IMPORTE'
																	,render: function (data, type, row, meta) 
																			{
																			valor=$.fn.dataTable.render.number( '.', ',', 2, '', '€').display(data.toString().replace(',', '.'))
																			//return valor + ' �'
																			return valor
																			}
																
																},
																{data: 'UNIDADES_DEVUELTAS'},
																{data: 'TOTAL_IMPORTE_DEVOLUCIONES'
																	,render: function (data, type, row, meta) 
																			{
																			valor=$.fn.dataTable.render.number( '.', ',', 2, '', '�').display(data.toString().replace(',', '.'))
																			//return valor + ' �'
																			return valor
																			}
																	},
																{orderable:false,
																	//orderDataType: "dom-checkbox",
                                                                       data:function(row, type, val, meta) { 
																	   		cadena=''
																			if (row.UNIDADES_DEVUELTAS)
																				{
																				cadena = row.CANTIDAD_TOTAL - row.UNIDADES_DEVUELTAS
																				}
																			  else
																			  	{
																				cadena = row.CANTIDAD_TOTAL
																				}
																			return cadena;
																					
                                                                       }
																	   
                                                                      }, 
																{orderable:false,
																	//orderDataType: "dom-checkbox",
                                                                       data:function(row, type, val, meta) { 
																	   		cadena=''
																			//console.log('total importe: ' + row.TOTAL_IMPORTE)
																			//console.log('total importe devolcuiones: ' + row.TOTAL_IMPORTE_DEVOLUCIONES)
																			//console.log('resta: ' + (parseFloat(row.TOTAL_IMPORTE.replace(',','.')) - parseFloat(row.TOTAL_IMPORTE_DEVOLUCIONES.replace(',', '.'))))
																			//console.log('-----------------------------------------')
																			if (row.TOTAL_IMPORTE_DEVOLUCIONES)
																				{
																				//cadena = row.TOTAL_IMPORTE - row.TOTAL_IMPORTE_DEVOLUCIONES
																				cadena = parseFloat(row.TOTAL_IMPORTE.replace(',','.')) - parseFloat(row.TOTAL_IMPORTE_DEVOLUCIONES.replace(',', '.'))
																				}
																			  else
																			  	{
																				cadena = row.TOTAL_IMPORTE
																				}
																			return cadena;
																					
                                                                       }
																	   
																	   ,render: function (data, type, row, meta) 
																			{
																			valor=$.fn.dataTable.render.number( '.', ',', 2, '', '€').display(data.toString().replace(',', '.'))
																			//return valor + ' �'
																			return valor
																			}
																		
                                                                      }, 
																/* {data: 'cadena_sql', visible: true,
																	render: function (data, type, row, meta) 
																			{
																			valor=$.fn.dataTable.render.number( '.', ',', 2, '', '�').display(data.toString().replace(',', '.'))
																			//return valor + ' �'
																			return valor
																			}}, */
																{data: 'ID_ARTICULO', visible: false},
																{data: 'NOMBRE_EMPRESA', visible: false},
																{data: 'CODCLIENTE', visible:false},
                                                            ],
															
													createdRow: function(row, data, dataIndex){
															
															/*if (parseFloat(data.HOJA_RUTA_SI)>0)
																{
																j$(row).css('background-color', '#F5FC64');
																}
															*/
													},
																
													rowId: 'extn', //para que se refresque sin perder filtros ni ordenacion
                                                    deferRender:true,
													scrollY:calcDataTableHeight(40),
													sScrollX: "100%",
													scrollCollapse: true,
													//scrollY:'10vh',
                                                    scrollCollapse:true,
    												
													language:{url:'../plugins/dataTable/lang/Spanish.json',
																"decimal": ",",
																"thousands": "."
														},
													paging:false,
                                                    processing: true,
													//search: {return: true},
													//serverSide:true,
                                                    searching:true,
													
													buttons:[{extend:"copy", text:'<i class="far fa-copy"></i>', titleAttr:"Copiar en Portapapeles", 
																		exportOptions:{columns: ":visible"}}, 
															 {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Consumos", extension:".xls", 
																		exportOptions:{columns: ":visible",
																						//al exportar a excel no pasa bien los decimales, le quita la coma
																						format: {
																								  body: function(data, row, column, node) {
																									  		data = $('<p>' + data + '</p>').text();
																									  		return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
																								  		}
																								}
															  }}, 
															 {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Consumos", orientation:"landscape",
															 			exportOptions:{columns: ":visible"}}, 
															 {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Consumos", 
																		exportOptions:{columns: ":visible"}}

															],
															
													drawCallback: function () {
															//para que se configuren los popover-titles...
															$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
														}
													
                                                    });
													
				//controlamos el click, para seleccionar o desseleccionar la fila
                $("#lista_consumos tbody").on("click","tr", function()
					{  
                  	if (!$(this).hasClass("selected") ) 
				  		{                  
	                    lst_consumos.$("tr.selected").removeClass("selected");
    	                $(this).addClass("selected");
        				}            
                });
				
				//gestiona el dobleclick sobre la fila para mostrar la pantalla del detalle del pedido
				$("#lista_consumos tbody").on("dblclick", "tr", function(e) {
				});              
				
				
				//la barra de botones encima de la cabecera
				$("#lista_consumos").on("xhr.dt", function(e, settings, json, xhr) {
					var api = new $.fn.dataTable.Api( settings );
					if ($("#chkdiferenciar_articulos").prop('checked'))
						{
						api.column(0).visible( true );
						api.column(1).visible( true );
						api.column(2).visible( true );
						}
					  else
						{
						api.column(0).visible( false );
						api.column(1).visible( false );
						api.column(2).visible( false );
						}
					
					if ($("#chkdiferenciar_sucursales").prop('checked'))
						{
						api.columns(3).visible(true)    
						}
					  else
						{
						api.columns(3).visible(false)    
						}
					
					if ($("#chkdiferenciar_tipo").prop('checked'))
						{
						api.column(4).visible(true)    
						}
					  else
						{
						api.column(4).visible(false)    
						}
						
				  }); 
				
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_consumos.ajax.url('../tojson/consulta_informes_gag_central_admin_obtener_consumos.asp?' + prm.toString());
              lst_consumos.ajax.reload();                  
            }   
			
		//lst_consumos.columns([0, 1, 2, 3, 4]).visible(false)    
		//dt.column(0).visible(false);
		//dt.columns([1,2]).visible(false)
		
		//console.log('ocultamos columnas')
		//console.log('diferenciar articulos: ' + $("#chkdiferenciar_articulos").prop('checked'))
		//console.log('diferenciar sucursales: ' + $("#chkdiferenciar_sucursales").prop('checked'))
		//console.log('diferenciar tipo: ' + $("#chkdiferenciar_tipo").prop('checked'))
		
		//console.log('antes de ocultar columna 4')
		//'lst_consumos.column(4).visible(true)    
		
		//console.log('antes de ocultar columnas 1 y 2')
		//lst_consumos.columns([1, 2]).visible(true)    
		/*
		if ($("#chkdiferenciar_articulos").prop('checked'))
			{
			lst_consumos.columns([3]).visible(true)    
			}
		  else
		  	{
			lst_consumos.columns([3]).visible(false)    
			}
		*/
		if ($("#chkdiferenciar_sucursales").prop('checked'))
			{
			//lst_consumos.columns(3).visible(true)    
			}
		  else
		  	{
			//lst_consumos.columns(3).visible(false)    
			}
			
		if ($("#chkdiferenciar_tipo").prop('checked'))
			{
			//lst_consumos.column(4).visible(true)    
			}
		  else
		  	{
			//lst_consumos.column(4).visible(false)    
			}
		
		
  //console.log('despues de ocultar columnas')
  
  
};

</script>			
			
			
<script language="javascript">
<%
        
	set articulos_typeahead=Server.CreateObject("ADODB.Recordset")
	
	with articulos_typeahead
		.ActiveConnection=connimprenta
		.Source="SELECT A.ID, A.CODIGO_SAP, A.DESCRIPCION, A.COMPROMISO_COMPRA"
		.Source= .Source & " , A.DESCRIPCION + ' (' + A.CODIGO_SAP + ')' AS TODO"
		.Source= .Source & " FROM ARTICULOS A"
		.Source= .Source & " INNER JOIN ARTICULOS_EMPRESAS B ON A.ID=B.ID_ARTICULO"
		.Source= .Source & " WHERE CODIGO_EMPRESA = " & session("usuario_codigo_empresa") 
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


<script language="javascript">
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

/*SI DEJAMOS QUE PUEDAN AGRUPAR A LA VEZ POR SUCURSALES Y ARTICULOS
$("#chkdiferenciar_articulos").on("change", function () {
	if ($("#chkdiferenciar_articulos").prop('checked'))
		{
		$("#chkdiferenciar_sucursales").prop('checked', false)
		}
});

$("#chkdiferenciar_sucursales").on("change", function () {
	if ($("#chkdiferenciar_sucursales").prop('checked'))
		{
		$("#chkdiferenciar_articulos").prop('checked', false)
		}
});
*/
$('#cmbclientes').change(function () {
     /*
	 var optionSelected = $(this).find("option:selected");
     var valueSelected  = optionSelected.val();
     var textSelected   = optionSelected.text();
	 //console.log('valor seleccionado: ' + valueSelected)
	 //console.log('texto seleccionado: ' + textSelected)
	 */
	 
 });
$('#cmbempresas').change(function () {
     /*
	 var optionSelected = $(this).find("option:selected");
     var valueSelected  = optionSelected.val();
     var textSelected   = optionSelected.text();
	 //console.log('valor seleccionado: ' + valueSelected)
	 //console.log('texto seleccionado: ' + textSelected)
	 */
	 //alert('entramos en cambio de cmbempresas')
	 control_borrados()
 });
 
$(document).ready(function () {
	//**********************************
	//este control esta en esta url: http://www.runningcoder.org/jquerytypeahead
	$.typeahead({
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
					'<img src="../Imagenes_Articulos/Miniaturas/i_{{miniatura}}.jpg">' +
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
				$("#ocultoarticulo_seleccionado").val(item.id)
			},
			onCancel: function (node, a, item, event) {
				$("#ocultoarticulo_seleccionado").val('')
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


	cargar_clientes('<%=mostrar_borrados%>')
});



cargar_clientes = function(borrados) {
	url=''
	empresa='<%=session("usuario_codigo_empresa")%>'
	//si es avoris, tengo que coger como empresa, la que venga seleccionada del combo de empresas
	//  no la de la variable de sesion
	if (empresa=='230')
		{
		empresa=$("#cmbempresas").val()
		}
	if (borrados=='SI')
		{
		url='Obtener_Clientes_Gag_Central_Admin.asp?borrados=SI&usuario=' + empresa
		}
	  else
	  	{
	  	url='Obtener_Clientes_Gag_Central_Admin.asp?usuario=' + empresa
		}
	
	$.getJSON(url, function(json){
				//console.log('borramos el cmbclientes')
				
				clientes = json.CLIENTES; 
				
				//borramos el contenido del combo de clientes
				$('#cmbclientes').empty();
				
				//a�adimos la primera opcion
				$('#cmbclientes').append($('<option>').text("Seleccionar Cliente").attr('value', ''));
				
				//rellenamos el combo
				$.each(clientes, function(i, obj){
					$('#cmbclientes').append($('<option>').text(obj.NOMBRE).attr('value', obj.Id));
				});
				//$("#cmbclientes").val('33').change()
				$("#cmbclientes").val('<%=cliente_seleccionado%>').change()
				
		})
		.fail(function( jqxhr, textStatus, error ) {
			var err = textStatus + ", " + error;
			//console.log( "Request Failed: " + err );
			});

};





</script>


</body>
<%
	'articulos.close
	
	pedidos.close
	
	
	
	
	connimprenta.close
	
	set articulos=Nothing
	
	
	set pedidos=Nothing
	
	
	set connimprenta=Nothing

%>
</html>
