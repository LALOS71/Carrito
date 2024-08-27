<%@ language=vbscript%>
<!--#include file="Conexion.inc"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
	if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
	end if
	
'	CAMPO_ID_ESTADOS=0
'CAMPO_DESCRIPCION_ESTADOS=1
'set estados=Server.CreateObject("ADODB.Recordset")
'	with estados
'		.ActiveConnection=connmaletas
'		.Source="SELECT ID, DESCRIPCION, PERFIL, ORDEN"
'		.Source= .Source & " FROM ESTADOS"
'		.Source= .Source & " ORDER BY ORDEN"
		'response.write("<br>" & .source)
		'.Open
'		vacio_estados=false
'		if not .BOF then
'			tabla_estados=.GetRows()
'		  else
'			vacio_estados=true
'		end if
'	end with

'estados.close
'set estados=Nothing
%>

<html>



<head>


	<title>Consulta Referencias Con El Stock Minimo</title>
	

	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">

	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/autofill/2.2.2/css/autoFill.bootstrap4.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/1.5.1/css/buttons.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.4.1/css/colReorder.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/fixedcolumns/3.2.4/css/fixedColumns.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/fixedheader/3.1.3/css/fixedHeader.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/keytable/2.3.2/css/keyTable.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.2.1/css/responsive.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/rowgroup/1.0.2/css/rowGroup.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/rowreorder/1.2.3/css/rowReorder.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/scroller/1.4.4/css/scroller.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/select/1.2.5/css/select.bootstrap4.min.css"/>

<script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>
<link rel="stylesheet" href="style_menu_hamburguesa5.css">


<script language="javascript">

function crearAjax() 
{
  var Ajax
 
  if (window.XMLHttpRequest) { // Intento de crear el objeto para Mozilla, Safari,...
    Ajax = new XMLHttpRequest();
    if (Ajax.overrideMimeType) {
      //Se establece el tipo de contenido para el objeto
      //http_request.overrideMimeType('text/xml');
      //http_request.overrideMimeType('text/html; charset=iso-8859-1');
	  Ajax.overrideMimeType('text/html; charset=iso-8859-1');
     }
   } else if (window.ActiveXObject) { // IE
    try { //Primero se prueba con la mas reciente versión para IE
      Ajax = new ActiveXObject("Msxml2.XMLHTTP");
     } catch (e) {
       try { //Si el explorer no esta actualizado se prueba con la versión anterior
         Ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {}
      }
   }
 
  if (!Ajax) {
    alert('¡Por favor, actualice su navegador!');
    return false;
   }
  else
  {
    return Ajax;
  }
}

function mostrar_capa(pagina,divContenedora)
{
	//alert('entramos en mostrar capa')
	//alert('parametros.... pagina: ' + pagina + ' divcontenedora: ' + divContenedora)
    var contenedor = document.getElementById(divContenedora);
    
	
    var url_final = pagina
 
    //contenedor.innerHTML = '<img src="imagenes/loading.gif" />'

    var objAjax = crearAjax()
 
    objAjax.open("GET", url_final)
    objAjax.onreadystatechange = function(){
      if (objAjax.readyState == 4)
	  {
       //Se escribe el resultado en la capa contenedora
	   txt=unescape(objAjax.responseText);
	   txt2=txt.replace(/\+/gi," ");
	   contenedor.innerHTML = txt2;
      }
    }
    objAjax.send(null);
	
}

</script>

<style>
		
		#capa_detalle_pir .modal-dialog  {width:90%;}
		
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


</head>
<body  topmargin="0">
<div class="wrapper">
        <!--#include file="Menu_Hamburguesa.asp"-->

        <!-- Page Content Holder -->
        <div id="content">
			<button type="button" id="sidebarCollapse" class="navbar-btn active">
				<span></span>
				<span></span>
				<span></span>
			</button>

			<div class="container-fluid">
				<div class="row">
                       <h3>Informe de Referencias Con Stock M&iacute;nimo</h3>
				</div>
				<div class="row">
							 <table id="lista_refs" name="lista_refs" class="table table-striped table-bordered" cellspacing="0" width="99%">
							  <thead>
								<tr>
								  <th style="text-align:center" width="2%"></th>     
								  <th>Referencia</th>
								  <th>Descripci&oacute;n</th>
								  <th>Unidades de Pedido</th>
								  <th
								  	data-toggle="popover"
									data-placement="bottom"
									data-trigger="hover"
									data-content="Compromiso de Compra"
									data-original-title=""
									>Compromiso</th>
								  <th>Stock</th>
								  <th>Stock M&iacute;nimo</th>
								  <th
								  	data-toggle="popover"
									data-placement="bottom"
									data-trigger="hover"
									data-content="Cantidades Pertenecientes a:<br>- Pedidos Parciales Pendientes.<br>- Pedidos En Producci&oacute;n.<br>- Pedidos En Proceso.<br>- Pedidos Sin Tratar."
									data-original-title=""
									>Cantidad Pendiente</th>
								  <th>Coste</th>
								  <th>Proveedor</th>
								  <th>Empresa</th>
								  <th>Familia</th>
								</tr>
							  </thead>
							</table>
            	</div>    
            </div><!-- /container fluid -->
        </div><!-- fin del Content -->
    </div><!-- fin del wrapper -->

<form name="frmmostrar_articulo" id="frmmostrar_articulo" action="Ficha_Articulo_Admin.asp" method="post">
	<input type="hidden" value="" name="ocultoid_articulo" id="ocultoid_articulo" />
	<input type="hidden" value="" name="ocultoaccion" id="ocultoaccion" />
	<input type="hidden" value="" name="ocultoempresas" id="ocultoempresas" />
	<input type="hidden" value="" name="ocultofamilias" id="ocultofamilias" />
	<input type="hidden" value="" name="ocultoautorizacion" id="ocultoautorizacion" />
	
</form>

<form name="frmmarcar_solicitados" id="frmmarcar_solicitados" action="Marcar_Articulos_Solicitados_Proveedor.asp" method="post">
	<input type="hidden" value="" name="ocultoarticulos" id="ocultoarticulos" />
	
</form>

<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>
    

<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>

<script type="text/javascript" src="plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>



 
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/2.5.0/jszip.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/autofill/2.2.2/js/dataTables.autoFill.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/autofill/2.2.2/js/autoFill.bootstrap4.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.bootstrap4.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.colVis.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.flash.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.print.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/colreorder/1.4.1/js/dataTables.colReorder.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/fixedcolumns/3.2.4/js/dataTables.fixedColumns.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/fixedheader/3.1.3/js/dataTables.fixedHeader.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/keytable/2.3.2/js/dataTables.keyTable.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.1/js/dataTables.responsive.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.1/js/responsive.bootstrap4.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/rowgroup/1.0.2/js/dataTables.rowGroup.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/rowreorder/1.2.3/js/dataTables.rowReorder.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/scroller/1.4.4/js/dataTables.scroller.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/select/1.2.5/js/dataTables.select.min.js"></script>


  
<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script>  
  

<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>

	<script language="javascript">
var j$=jQuery.noConflict();

  

j$(document).ready(function () {

	j$("#pageInformes").addClass('show')
	j$("#pageInformes").addClass('active')
	//j$("#informe_stock_minimo").addClass('active')

	j$('#sidebarCollapse').on('click', function () {
		j$('#sidebar').toggleClass('active');
		j$(this).toggleClass('active');
	});
  
	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true});
	
	j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});

	//para que se cargue la tabla
	consultar_refs();

    
  
  
});


/*
chkAllOnClick = function(o) {
    var state=(j$(o).hasClass("fa-check-square")?"":"check-");
    j$(o).attr("class","state-icon far fa-" + state + "square");          
    
    j$("#lista_refs").find(".state-icon").each(function(i){           
      j$(this).attr("class","state-icon far fa-" + state + "square");          
    });
  };
*/


chkOnClick = function(o, art) {  
    if (j$(o).hasClass("fa-check-square")) {
      j$(o).attr("class", "state-icon far fa-square fa-lg");
	  mostrar_capa('Marcar_Articulos_Solicitados_Proveedor.asp?articulo=' + art + '&valor=NO','capa_solicitud_proveedor')          
    } else {
      j$(o).attr("class", "state-icon far fa-check-square fa-lg");
	  mostrar_capa('Marcar_Articulos_Solicitados_Proveedor.asp?articulo=' + art + '&valor=SI','capa_solicitud_proveedor')
    }
	
	var dialog = bootbox.dialog({
    	message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
	});
	
	lst_refs.ajax.reload();
	
	dialog.init(function(){
    	setTimeout(function(){
        	//dialog.find('.bootbox-body').html('I was loaded after the dialog was shown!');
			dialog.modal('hide')
	    }, 2200);
});
  };   


  

  
//para solicitar los articulos
solicitar_articulos = function() {
    var prm=new ajaxPrm(), aAux={}, str="#";
    
    j$(".fa-check-square", lst_refs.rows().nodes()).each(function(i) {
      var tr=j$(this).closest("tr"), d=lst_refs.row(tr).data(); 
      str += d.ID + "#";                              
    });

    if (str != "#") {
		
		//alert(str)
		//var retocada = str.substr(1).slice(0, -1);
		//alert(retocada)
		//var retocada2 = retocada.split('#').join(',');
		//alert(retocada2)
		
		j$("#ocultoarticulos").val(str);
		j$("#frmmarcar_solicitados").submit();
		
    } else {
      alert('se han de seleccionar articulos')
    }
  };
 

 

calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  }; 
  
  
  

mostrar_articulo = function (articulo) 
   {
   	//alert('hotel: ' + hotel + ' accion: ' + accion)
   	document.getElementById('ocultoid_articulo').value=articulo
	document.getElementById('ocultoaccion').value='MODIFICAR'
	document.getElementById('ocultoempresas').value='Sin Filtro'
	document.getElementById('ocultofamilias').value='Sin Filtro'
	document.getElementById('ocultoautorizacion').value='Sin Filtro'
	document.getElementById('frmmostrar_articulo').action='Ficha_Articulo_Admin.asp'	

   	document.getElementById('frmmostrar_articulo').submit()	
   }

  
/* Create an array with the values of all the checkboxes in a column */
j$.fn.dataTable.ext.order['dom-checkbox'] = function  ( settings, col )
{
	//console.log('ordenando checks...' + settings + ' .. ' + col)
	var salida = '';
	//console.log('estructura de settings')
	
	
    return this.api().column( col, {order:'index'} ).nodes().map( function ( td, i ) {
		
		//console.log('estructura de td')
		/*
		for (var p in td) {
			 salida = p + ': ' + td[p] + '\n';
			 console.log(salida);
		}
		*/
		return j$('svg', td).hasClass('fa-check-square') ? '1' : '0';
    } );
}   


consultar_refs = function() {  
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
        
        j$.fn.dataTable.moment("DD/MM/YYYY");
        
        //deseleccioamos el registro de la lista
        j$('#lista_refs tbody tr').removeClass('selected');
        
        if (typeof lst_refs== "undefined") {
            lst_refs = j$("#lista_refs").DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:"tojson/obtener_refs.asp?"+prm.toString(),
                                                           type:"POST",
                                                           dataSrc:"ROWSET"},
                                                     columnDefs: [
                                                              {className: "dt-right", targets: [4,5,6,7]}
                                                            ],
                                                     /*
													 columnDefs: [
                                                              {className: "dt-right", targets: [4,5,6,7]},
                                                              {className: "dt-center", targets: [4]}                                                            
                                                            ],
													*/
													 order:[[ 0, "desc" ]],
													 columns:[ 	//ejemplo de columna vacia
													 			/*
																{data: function (row, type, set) {
																	return '';
																}},
																*/
													 			{//orderable:false,
																	orderDataType: "dom-checkbox",
                                                                       data:function(row, type, val, meta) { 
																	   		if (row.SOLICITADO_AL_PROVEEDOR=='SI')
																				{
																				icono_columna='fa-check-square'
																				}
																			  else
																			  	{
																				icono_columna='fa-square'
																				}
																				
                                                                         return '<i style="cursor:pointer" onclick="chkOnClick(this, ' + row.ID + ')" class="state-icon far ' + icono_columna + ' fa-lg"'
																		 			+ ' data-toggle="popover_datatable"'
																					+ ' data-placement="right"'
																					+ ' data-trigger="hover"'
																					+ ' data-content="Activar/Desactivar Selecci&oacute;n"'
																					+ ' data-original-title=""'
																					+ '></i>';
                                                                       }
                                                                      },
																
													 			{data:"REFERENCIA"},
																{data:"DESCRIPCION"},
															  	{data:"UNIDADES_PEDIDO"},
																{data:"COMPROMISO_COMPRA"},
																{data:"STOCK"},
															  	{data:"STOCK_MINIMO"},
															  	{data:"CANTIDAD_PENDIENTE"},
																{data:"PRECIO_COSTE"},
																{data:"PROVEEDOR"},
																{data:"EMPRESA"},
																{data:"FAMILIA"},
																{data:"ID", visible:false},
																{data:"SOLICITADO_AL_PROVEEDOR", visible:false}
																
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
												   						exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9,10,11],
																					format: {
																							//PARA PONERLE NOMBRE A LA CABECERA DE LA PRIMERA COLUMNA, 
																							//   QUE SOLO TIENE UNA IMAGEN
																							header: function ( data, columnIdx ) {
																									if (columnIdx==0)
																										{
																										return 'Solicitado al Proveedor';
																										}
																									 else
																										{
																										return data;
																										}
																									},
																							//PARA QUE EL CONTENIDO DE LAS CELDAS DE LA PRIMERA COLUMNA
																							//  TENGAN LOS VALORES 'SI' o 'NO', PORQUE LO QUE HAY
																							//  ES UNA IMAGEN CON EL CHECK, SIN NINGUN DATO
																							body: function ( data, row, column, node) {
																									if (column==0)
																										{
																										//console.log('valor de la fila: ' + data + ' .. ' + row)
																										}
																									return column === 0 ?
																												(data.indexOf('fa-check-square')>0 ? 'SI' : 'NO') :
																												data;
																									}
																							}
																		
																		
																		}}, 
                                                             {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Referencias Sin Stock", extension:".xls", 
															 				exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9,10,11],
																							format: {
																								//PARA PONERLE NOMBRE A LA CABECERA DE LA PRIMERA COLUMNA, 
																								//   QUE SOLO TIENE UNA IMAGEN
																								header: function ( data, columnIdx ) {
																										if (columnIdx==0)
																											{
																											return 'Solicitado al Proveedor';
																											}
																										 else
																											{
																											return data;
																											}
																										},
																								//PARA QUE EL CONTENIDO DE LAS CELDAS DE LA PRIMERA COLUMNA
																								//  TENGAN LOS VALORES 'SI' o 'NO', PORQUE LO QUE HAY
																								//  ES UNA IMAGEN CON EL CHECK, SIN NINGUN DATO
																								body: function ( data, row, column, node) {
																									/*
																									console.log('data: ' + data)
																									console.log('row: ' + row)
																									console.log('column: ' + column)
																									console.log('node: ' + node)
																									*/
																									return column === 0 ?
																												(data.indexOf('fa-check-square')>0 ? 'SI' : 'NO') :
																												data;
																									}
																								}
																			
																				}}, 
                                                             {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Referencias Sin Stock", orientation:"landscape", 
															 			exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9,10,11],
																						format: {
																							//PARA PONERLE NOMBRE A LA CABECERA DE LA PRIMERA COLUMNA, 
																							//   QUE SOLO TIENE UNA IMAGEN
																							header: function ( data, columnIdx ) {
																									if (columnIdx==0)
																										{
																										return 'Solicitado al Proveedor';
																										}
																									 else
																										{
																										return data;
																										}
																									},
																							//PARA QUE EL CONTENIDO DE LAS CELDAS DE LA PRIMERA COLUMNA
																							//  TENGAN LOS VALORES 'SI' o 'NO', PORQUE LO QUE HAY
																							//  ES UNA IMAGEN CON EL CHECK, SIN NINGUN DATO
																							body: function ( data, columnIdx, row) {
																									if (columnIdx == 0)
																										{
																										return data.indexOf('fa-check-square')>0 ? 'SI' : 'NO';
																										}
																									  else
																										{
																										return data;
																										}
																										
																										
																									}
																							}
																		}}, 
                                                             {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Referencias Sin Stock", 
															 			exportOptions:{columns:[0,1,2,3,4,5,6,7,8,9,10,11],
																						format: {
																							//PARA PONERLE NOMBRE A LA CABECERA DE LA PRIMERA COLUMNA, 
																							//   QUE SOLO TIENE UNA IMAGEN
																							header: function ( data, columnIdx ) {
																									if (columnIdx==0)
																										{
																										return 'Solicitado al Proveedor';
																										}
																									 else
																										{
																										return data;
																										}
																									},
																							//PARA QUE EL CONTENIDO DE LAS CELDAS DE LA PRIMERA COLUMNA
																							//  TENGAN LOS VALORES 'SI' o 'NO', PORQUE LO QUE HAY
																							//  ES UNA IMAGEN CON EL CHECK, SIN NINGUN DATO
																							body: function ( data, columnIdx, row) {
																									if (columnIdx == 0)
																										{
																										return data.indexOf('fa-check-square')>0 ? 'SI' : 'NO';
																										}
																									  else
																										{
																										return data;
																										}
																										
																										
																									}
																							}
																		}}
															],
                                                 
													createdRow:function (row, data, index) {
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
															//j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
														},
                                                    //initComplete: stf.initComplete,                                                            
                                                     language:{url:"plugins/dataTable/lang/Spanish.json"},
                                                     paging:false,
                                                     processing: true,
                                                     searching:true
                                                    });
               	
				j$("#lista_refs").on("xhr.dt", function() {     
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
                j$("#lista_refs tbody").on("click","tr", function() {  
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

				//gestiona el dobleclick sobre la fila para mostrar la pantalla de detalle del pir
				j$("#lista_refs").on("dblclick", "tr", function(e) {
				  var row=lst_refs.row(j$(this).closest("tr")).data() 
				  parametro_id=row.ID
				  
				  j$(this).addClass('selected');
				  
				  mostrar_articulo(parametro_id)
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
			  lst_refs.ajax.url("tojson/obtener_refs.asp?"+prm.toString());
              lst_refs.ajax.reload();                  
            }       
      
      
    
	lst_refs.on( 'buttons-action', function ( e, buttonApi, dataTable, node, config ) {
					//console.log( 'Button '+ buttonApi.text()+' was activated' );
					
				} );

  };




</script>


<!-- NO BORRAR, es la capa que ejecuta la grabacion del articulo como solicitado al proveedor o no....-->
<div id="capa_solicitud_proveedor"></div>

<!-- FIN DE NO BORRAR -->
</body>
</html>