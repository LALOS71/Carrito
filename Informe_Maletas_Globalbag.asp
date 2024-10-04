<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
	
	response.Buffer=true
	numero_registros=0
		
	if session("usuario_admin")="" then
		Response.Redirect("Login_GAGAD.asp")
	end if
	'response.write("procedencia: " & request.servervariables("http_referer"))
	empresa_seleccionada=Request.Form("cmbempresas")
	familia_seleccionada=Request.Form("cmbfamilias")
	codigo_sap_seleccionado=Request.Form("txtcodigo_sap")
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


			

%>
<html>
<head>
<link href="estilos___.css" rel="stylesheet" type="text/css" />

<!-- Bootstrap CSS CDN -->
    <link rel="stylesheet" type="text/css" href="plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	
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
		

</style>

<script language="javascript">
function cambiacomaapunto (s)
{
	var saux = "";
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ",")
			saux = saux + ".";
		else
			saux = saux + s.charAt (j);
	}
	return saux;
}

// una vez calculado el resultado tenemos que volver a dejarlo como es devido, con la coma
//    representando los decimales y no el punto
function cambiapuntoacoma(s)
{
	var saux = "";
	//alert("pongo coma")
	//alert("tama�o: " + s.legth)
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ".")
			saux = saux + ",";
		else
			saux = saux + s.charAt (j);
		//alert("total: " + saux)
	}
	return saux;
}

// ademas redondeamos a 2 decimales el resultado
function redondear (v){
	var vaux;
	vaux = Math.round (v * 100);
	vaux =  vaux / 100;
	return  vaux;
}


	
	
   function mover_formulario(objetivo)
   {
   	if (objetivo=='volver')
   		accion='Lista_Articulos.asp'
	  else
	  	accion='Grabar_Pedido.asp';
	document.getElementById('frmpedido').action=accion
	document.getElementById('frmpedido').submit()	
	

   }
   	
mostrar_articulo = function (articulo, accion) 
   {
   	//alert('hotel: ' + hotel + ' accion: ' + accion)
   	document.getElementById('ocultoid_articulo').value=articulo
	document.getElementById('ocultoaccion').value=accion
	document.getElementById('ocultoempresas').value='Sin Filtro'
	document.getElementById('ocultofamilias').value='Sin Filtro'
	document.getElementById('ocultoautorizacion').value='Sin Filtro'
	document.getElementById('frmmostrar_articulo').action='Ficha_Articulo_Admin.asp'	

   	document.getElementById('frmmostrar_articulo').submit()	
   }

</script>

<script language="javascript" src="Funciones_Ajax.js"></script>

<script src="DD_roundies_0_0_2a.js"></script>
<script language="javascript">
function mostrar_capas(capa)
{
	//redondear capa para el internet explorer
	DD_roundies.addRule('#contenedorr3', '20px');
	document.getElementById('capa_opaca').style.display=''
	document.getElementById(capa).style.display='';
}

function cerrar_capas(capa)
{	
	document.getElementById('capa_opaca').style.display='none';
	document.getElementById(capa).style.display='none';
}
</script>


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
					<div class="col-12"><h1 align="center">Maletas Globalbag</h1></div>
					
				
				</div>
				<div class="panel panel-default">
					<div class="panel-body">
					<form name="frmbuscar" id="frmbuscar" method="post" action="">	
						<div class="form-group row mx-2">
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_inicio" class="control-label">Fecha Inicio</label>
								<input type="date" id="txtfecha_inicio" class="form-control" required="" name="txtfecha_inicio" value="<%=campo_fecha_inicio%>" /> 
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_fin" class="control-label">Fecha Fin</label>
								<input type="date" id="txtfecha_fin" class="form-control" required="" name="txtfecha_fin" value="<%=campo_fecha_fin%>" /> 
							</div>
							<div class="col-sm-4 col-md-2 col-lg-2">
								<label for="cmdconsultar" class="control-label">&nbsp;</label>
								<button type="button" class="btn btn-primary btn-block" id="cmdconsultar" name="cmdconsultar"
									data-toggle="popover"
									data-placement="top"
									data-trigger="hover"
									data-content="Buscar Pedidos Maletas Globalbag"
									data-original-title=""
									>
									<i class="fas fa-search"></i>&nbsp;&nbsp;&nbsp;Buscar
								</button>
							</div>
							
						</div>					
					
							
					</form>
						
					
						<div class="row  mx-2">
							 <table id="lista_articulos" name="lista_articulos" class="table table-striped table-bordered" cellspacing="0" width="99%">
							  <thead>
								<tr>
								  <th>PEDIDO</th>
								  <th
								  	data-toggle="popover"
									data-placement="bottom"
									data-trigger="hover"
									data-content="Codigo del Cliente"
									data-original-title=""
									>COD. CLI</th>
								  <th>NOMBRE</th>
								  <th
								  	data-toggle="popover"
									data-placement="bottom"
									data-trigger="hover"
									data-content="C&iacute;digo de La Oficina de Origen"
									data-original-title=""
									>COD. OFI.</th>
								  <th>OFICINA ORIGEN</th>
								  <th
								  	data-toggle="popover"
									data-placement="bottom"
									data-trigger="hover"
									data-content="C&oacutedigo del Art&iacute;culo"
									data-original-title=""
									>COD. ART.</th>
								  <th>REFERENCIA</th>
								  <th>DESCRIPCI�N</th>
								  <th>ALBAR�N</th>
								  <th
								  	data-toggle="popover"
									data-placement="bottom"
									data-trigger="hover"
									data-content="Fecha Enviado"
									data-original-title=""
									>F. ENVIADO</th>
								  <th
								  	data-toggle="popover"
									data-placement="bottom"
									data-trigger="hover"
									data-content="Cantidad"
									data-original-title=""
									>CANT.</th>
								  <th>�/unidad</th>
								  <th>TOTAL</th>
								  <th
								  	data-toggle="popover"
									data-placement="bottom"
									data-trigger="hover"
									data-content="N&uacute;mero de Empleado"
									data-original-title=""
									>NUM. EMPL.</th>
								</tr>
							  </thead>
							</table>
            			</div>    
					
					</div><!--del panel body-->
				</div><!--del panel default-->
			</div><!--del content-fluid-->
        </div><!--fin de content-->
    </div><!--fin de wrapper-->





<form name="frmmostrar_articulo" id="frmmostrar_articulo" action="Ficha_Articulo_Admin.asp" method="post">
	<input type="hidden" value="" name="ocultoid_articulo" id="ocultoid_articulo" />
	<input type="hidden" value="" name="ocultoaccion" id="ocultoaccion" />
	<input type="hidden" value="<%=cadena_consulta_excel%>" name="ocultocadena_consulta" id="ocultocadena_consulta" />
	<input type="hidden" value="" name="ocultoempresas" id="ocultoempresas" />
	<input type="hidden" value="" name="ocultofamilias" id="ocultofamilias" />
	<input type="hidden" value="" name="ocultoautorizacion" id="ocultoautorizacion" />
	
</form>





<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
	
<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>
    
<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>

<script type="text/javascript" src="plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>



 
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



<script type="text/javascript">
var j$=jQuery.noConflict();
		
j$(document).ready(function () {
	j$("#menu_articulos").addClass('active')
	
	j$('#sidebarCollapse').on('click', function () {
		j$('#sidebar').toggleClass('active');
		j$(this).toggleClass('active');
	});
	
	
	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true});
	
	j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
	
});
		
calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  }; 		
		
mostrar_imagen_articulo = function(codigo) {
	cadena='<div align="center"><div class="row my-auto">'
	cadena=cadena + '<div class="mx-auto text-center">'
	cadena=cadena + '<span>'
	cadena=cadena + '<a href="Imagenes_Articulos/' + codigo + '.jpg" target="_blank" id="imagen_enlace">'
	cadena=cadena + '<img class="img-responsive" src="Imagenes_Articulos/Miniaturas/i_' + codigo + '.jpg" border="0" id="imagen_articulo"></a>'
	cadena=cadena + '</span>'
	cadena=cadena + '<br><label class="control-label">pulsar sobre la imagen para verla a tama�o real</label>'
	cadena=cadena + '</div>'	
	cadena=cadena + '</div>'
	cadena=cadena + '</div>'
	
	
	
	
	bootbox.alert({
				//size: 'large',
				message: cadena
				//callback: function () {return false;}
			})		

}; 		
		
		
j$("#cmdannadir_articulo").click(function () {
	mostrar_articulo(0,'ALTA');
});


j$("#cmdconsultar").click(function () {
	//j$("#frmbuscar_articulos").submit()
	//para que se cargue la tabla
	consultar_articulos();
});




consultar_articulos = function() {  
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
		
		
		
		
		/*
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
		*/
		
		prm.add("p_fecha_inicio", j$('#txtfecha_inicio').val());
        prm.add("p_fecha_fin", j$('#txtfecha_fin').val());
        
        j$.fn.dataTable.moment("DD/MM/YYYY");
        
        //deseleccioamos el registro de la lista
        j$('#lista_articulos tbody tr').removeClass('selected');
        
        if (typeof lst_articulos== "undefined") {
            lst_articulos = j$("#lista_articulos").DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:"tojson/obtener_ventas_maletas_globalbag.asp?"+prm.toString(),
                                                           type:"POST",
                                                           dataSrc:"ROWSET"},
                                                     columnDefs: [
                                                              {className: "dt-right", targets: [0,1,3,5,8,10,11,12,13]}
                                                            ],
                                                     /*
													 columnDefs: [
                                                              {className: "dt-right", targets: [4,5,6,7]},
                                                              {className: "dt-center", targets: [4]}                                                            
                                                            ],
													*/
													 order:[[ 0, "desc" ]],
													 columns:[ 	
													 			{data:"ID_PEDIDO"},
																{data:"CODIGO_CLIENTE"},
															  	{data:"CLIENTE"},
																{data:"CODIGO_OFICINA_ORIGEN"},
															  	{data:"OFICINA_ORIGEN"},
															  	{data:"ARTICULO"},
																{data:"REFERENCIA"},
																{data:"DESCRIPCION"},
																{data:"ALBARAN"},
																{data:"FECHA_ENVIADO"},
																{data:"CANTIDAD"},
																{data:"PRECIO_UNIDAD"},
																{data:"TOTAL"},
																{data:"NUMERO_EMPLEADO"}
																
                                                            ],
													 rowId: 'extn', //para que se refresque sin perder filtros ni ordenacion
                                                     deferRender:true,
    //  Scroller
                                                     scrollY:calcDataTableHeight(),
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
                                                   buttons:[{extend:"copy", text:'<i class="far fa-copy"></i>', titleAttr:"Copiar en Portapapeles", 
												   						exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9,10,11,12,13]}}, 
                                                             {extend:"excel", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Maletas Globalbag", extension:".xls", 
														 				exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9,10,11,12,13],
																		format: {
																				  body: function(data, row, column, node) {
																				  		if (column>=10 && column<=12)
																							{
																							//console.log('data: ' + data + ' row: ' + row + ' column: ' + column + ' node: ' + node)
																							
																							//data = $('<p>' + data + '</p>').text();
																							return j$.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
																							}
																						  else
																						  	{
																						  	return data;
																							}
																				  		}
																				  }
																		
																		}}, 
																		
                                                             {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Maletas Globalbag", orientation:"landscape", 
															 			exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9,10,11,12,13]}}, 
                                                             {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Maletas Globalbag", 
															 			exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9,10,11,12,13]}}
															],
                                                 
													rowCallback:function (row, data, index) {
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
																  //j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
                                                                },
													drawCallback: function () {
															//para que se configuren los popover-titles...
															//j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
														},
                                                    //initComplete: stf.initComplete,                                                            
                                                     language:{url:"plugins/dataTable/lang/Spanish.json"},
                                                     paging:false,
                                                     processing: true,
                                                     searching:true
                                                    });
               	
				j$("#lista_articulos").on("xhr.dt", function() {     
					/*
					var str='<div><a href="#" class="btn btn-primary" onclick="solicitar_articulos()"'
									+ ' data-toggle="popover_datatable"'
									+ ' data-placement="right"'
									+ ' data-trigger="hover"'
									+ ' data-content="Solicitar Art&iacute;culos a Los Proveedores"'
									+ ' data-original-title=""'
									+ '><i class="far fa-list-alt fa-lg"></i>&nbsp;&nbsp;Solicitar Art&iacute;culos</a></div>';
					j$("div.toolbar").html(str);
					*/
					
					/*
					j$("#tb_servicios_ele .dataTables_scrollBody").scroll(function() {
					  j$("#tb_servicios_ele .dataTables_scrollHead").scrollLeft(j$("#tb_servicios_ele .dataTables_scrollBody").scrollLeft());
					});    
					*/
					j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
			   	})
				
				 //controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_articulos tbody").on("click","tr", function() {  
                  if (!j$(this).hasClass("selected") ) {                  
                    //lst_refs.$("tr.selected").removeClass("selected");
                    //j$(this).addClass("selected");
                    
					
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

				
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_articulos.ajax.url("tojson/obtener_ventas_maletas_globalbag.asp?"+prm.toString());
              lst_articulos.ajax.reload();                  
            }       
      
      
    
	lst_articulos.on( 'buttons-action', function ( e, buttonApi, dataTable, node, config ) {
					//console.log( 'Button '+ buttonApi.text()+' was activated' );
					
				} );

  };


    </script>


</body>
<%
	
	connimprenta.close
	
	set connimprenta=Nothing

%>
</html>
