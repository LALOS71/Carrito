<%@ language=vbscript%>
<%
	id_pir=Request.QueryString("id")
	campo_pir=Request.QueryString("pir")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>


	<title>Hist&oacute;rico PIR</title>

	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-switch/css/bootstrap-switch.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/media/css/dataTables.bootstrap.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/extensions/Buttons/css/buttons.dataTables.min.css">
  
	
	<link rel="stylesheet" type="text/css" href="plugins/font-awesome-4.7.0/css/font-awesome.min.css">
	
	<style>
	.clickable{
 	   cursor: pointer;   
	}

	.panel-heading span {
		margin-top: -20px;
		font-size: 15px;
	}
	
	.table th { font-size: 13px; }
	.table td { font-size: 12px; }
	
	/*
	.popover-content {
		background-color: #FCD086;
		font-size: 10px;
	}
	.popover.top .arrow:after {
      bottom: 1px;
      margin-left: -10px;
      border-top-color: #FCD086; /*<----here*/
      /*border-bottom-width: 0;
      content: " ";
    }
	*/
	
	/*para cambiar el color del fondo del popover
	.popover {background-color: coral;}
	.popover.bottom .arrow::after {border-bottom-color: coral; }
	.popover .popover-content {background-color: coral;}
	.popover.top .arrow:after {border-top-color: coral;}
	*/
	
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
    //------------------------------------------
    
    
	
	</style>
</head>

<body>
<div class="container-fluid">
	<div width="95%">
							
		 <table id="lista_historico_pir" name="lista_historico_pir" class="table table-bordered" cellspacing="0" width="100%">
		  <thead>
			<tr>
			  <th>Fecha</th>
			  <th>Hora</th>
			  <th>Acci&oacute;n</th>
			  <th>Campo</th>
			  <th>Valor Antiguo</th>
			  <th>Valor Nuevo</th>
			  <th><i class="glyphicon glyphicon-user"
					data-toggle="popover_datatable"
					data-placement="top"
					data-trigger="hover"
					data-content="Usuario"></i>
			  </th>
			  <th>Descripci&oacute;n</th>
			  

			</tr>
		  </thead>
		</table>
	</div>
</div>
</body>						
						
						
<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>

<script type="text/javascript" src="plugins/dataTable/media/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/media/js/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.flash.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/jszip.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/pdfmake.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/vfs_fonts.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.print.min.js"></script>

<script type="text/javascript" src="plugins/bootstrap-switch/js/bootstrap-switch.min.js"></script>
  
<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script>  
						
<script language="javascript">
var j$=jQuery.noConflict();

j$(document).ready(function () {		
	var prm=new ajaxPrm();
	
	prm.add("p_id_pir", <%=id_pir%>);				

	j$.fn.dataTable.moment("DD/MM/YYYY");
	
	if (typeof lst_historico_pir == "undefined") {
            lst_historico_pir = j$("#lista_historico_pir").DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:"tojson/obtener_historico_pir.asp?"+prm.toString(),
                                                           type:"POST",
                                                           dataSrc:"ROWSET"},
                                                     order:[],
													 columnDefs: [
                                                              {className: "dt-center", targets: [7]}                                                            
                                                            ],
                                                     /*
													 columnDefs: [
                                                              {className: "dt-right", targets: [2,3]},
                                                              {className: "dt-center", targets: [4]}                                                            
                                                            ],
													*/
													 responsive:true,
                                                     columns:[ 
													 			{data:"FECHA"},
																{data:"HORA"},
																{data:"ACCION"},
																{data:"CAMPO"},
																{data:"VALOR_ANTIGUO"},
																{data:"VALOR_NUEVO"},
																{data:function(row, type, val, meta) {                                                                                                                   
                                                                      	//return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                                                                  
                                                                      	
																		if (row.NOMBRE_USUARIO=='')
																			{
																			cadena=row.USUARIO
																			}
																		  else
																		  	{
																			cadena_usuario= row.NOMBRE_USUARIO + ' (' + row.USUARIO + ')' 
																			cadena='<i class="fa fa-user-o" aria-hidden="true" style="cursor:pointer"' +
						  																'data-toggle="popover_datatable"' +
																						'data-placement="top"' + 
																						'data-trigger="hover"' +
																						'data-content="<span style=\'color:blue;\'><i class=\'fa fa-user-o fa-lg\'></i>&nbsp;' + cadena_usuario + '"></i></span>'
																			}
																		
																		return cadena
                                                                    	}
                                                               		},
																{data:"DESCRIPCION"},
															  	{data:"ID", visible:false},
															  	{data:"ID_PIR", visible:false},
																{data:"PIR", visible:false},
																{data:"ESTADO", visible:false},
																{data:"NOMBRE_USUARIO", visible:false}
																
								 
		
                                                            ],
                                                     deferRender:true,
    //  Scroller
                                                     scrollY:calcDataTableHeight() - 70,
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
                                                   buttons:[{extend:"copy", text:'<i class="fa fa-files-o"></i>', titleAttr:"Copiar en Portapapeles", 
												   				exportOptions:{columns:[0,1,2,3,4,5,12,7],
																				format: {
																						header: function ( data, columnIdx ) {
																								if (columnIdx==12)
																									{
																									return 'Usuario';
																									}
																								 else
																									{
																									return data;
																									}
																								}
																						}
																}}, 
                                                             {extend:"excel", 
															 	text:'<i class="fa fa-file-excel-o"></i>', 
																titleAttr:"Exportar a Formato Excel", 
																title:"Historico Pir <%=campo_pir%>", 
																extension:".xls", 
																exportOptions:{columns:[0,1,2,3,4,5,12,7],
																	format: {
																			header: function ( data, columnIdx ) {
																					if (columnIdx==12)
																						{
																						return 'Usuario';
																						}
																					 else
																					 	{
																						return data;
																						}
																					}
																			}
																	}
															  }, 
															 
															 {extend:"pdf", text:'<i class="fa fa-file-pdf-o"></i>', titleAttr:"Exportar a Formato PDF", title:"Historico Pir <%=campo_pir%>", orientation:"landscape", 
															 	exportOptions:{columns:[0,1,2,3,4,5,12,7],
															 					format: {
																						header: function ( data, columnIdx ) {
																								if (columnIdx==12)
																									{
																									return 'Usuario';
																									}
																								 else
																									{
																									return data;
																									}
																								}
																						}
															 
															 }}, 
                                                             {extend:"print", text:"<i class='fa fa-print'></i>", titleAttr:"Vista Preliminar", title:"Historico Pir <%=campo_pir%>", 
															 	exportOptions:{columns:[0,1,2,3,4,5,12,7],
																				format: {
																						header: function ( data, columnIdx ) {
																								if (columnIdx==12)
																									{
																									return 'Usuario';
																									}
																								 else
																									{
																									return data;
																									}
																								}
																						}															
																	
																}}
															],
                                                 
													
													rowCallback:function (row, data, index) {
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
																  
																	if ( data.ACCION == "INCIDENCIA" ) {
																		//j$( row ).css( "background-color", "Orange" );
																		//j$( row ).addClass( "warning" );
																		j$( row ).addClass( "danger" );
																	}
                                                                },
													drawCallback: function () {
															//para que se configuren los popover-titles...
															j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
															//j$('[data-toggle="popover_datatable"]').next('.popover').addClass('popover_usuario');
															
														},
                                                    //initComplete: stf.initComplete,                                                            
                                                     language:{url:"plugins/dataTable/lang/Spanish.json"},
                                                     paging:false,
                                                     processing: true,
                                                     searching:true
                                                    });
               
			   
				 //controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_historico_pir tbody").on("click","tr", function() {  
                  if (!j$(this).hasClass("selected") ) {                  
                    lst_historico_pir.$("tr.selected").removeClass("selected");
                    j$(this).addClass("selected");
                    //var table = j$('#lista_pirs').DataTable();
                    //row_sel = table.row( this ).data();
                  } 
                  //console.log(row_sel);
				  
                });

				
				j$('#lista_historico_pir').on( 'init.dt', function () {
					cadena_html='';
					cadena_html+='<div class="btn-group" role="group" id="botones_historico">';
					cadena_html+='<button type="button" class="btn btn-default active">Incidencias</button>';
					cadena_html+='<button type="button" class="btn btn-default">Hist&oacute;rico</button>';
					cadena_html+='<button type="button" class="btn btn-default">Todo</button>';
					cadena_html+='</div>';
						  
					j$("div.toolbar").html(cadena_html);
					
					
					
					j$("#botones_historico > .btn").on('click', function() {  
						//j$("#botones_historico > .btn").click(function(){
							j$(this).addClass("active").siblings().removeClass("active");
							boton_activo=j$(this).html()
							console.log('boton activo: ' + boton_activo)
							if (boton_activo=='Todo')
								{
								console.log('hemos pulsado TODO')
								lst_historico_pir.column(2).search('').draw();
								}
							
							if (boton_activo=='Histórico')
								{
								console.log('hemos pulsado HISTORICO')
								//lst_historico_pir.column(2).search("<>'INCIDENCIA'").draw();
								//^(?!badword|coco$).*$........... para cuando son 2 cosas
								// ..... /^(?:(?!PATTERN).)*$/ ... para todas
								lst_historico_pir.column(2).search('^(?!INCIDENCIA$).*$', true, true, false).draw();
								}
								
							if (boton_activo=='Incidencias')
								{
								console.log('hemos pulsado INCIDENCIAS')
								lst_historico_pir.column(2).search('INCIDENCIA').draw();
								}
						});
					
					
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
			  lst_historico_pir.ajax.url("tojson/obtener_historico_pir.asp?"+prm.toString());
              lst_historico_pir.ajax.reload();                  
            }       
      
      
    
	
	lst_historico_pir.column(2).search('INCIDENCIA').draw();
	
	
});



calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  };  
</script>						


</htmil>