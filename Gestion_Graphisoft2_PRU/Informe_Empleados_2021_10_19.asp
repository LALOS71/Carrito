<!--#include file="DB_Manager.inc"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    Dim estados
    Dim sql 

	If Session("usuario") = "" Then
        Response.Redirect("Login.asp")
	End If
	Response.Buffer  = true
	numero_registros = 0

    CAMPO_ID_ESTADO          = 0
	CAMPO_DESCRIPCION_ESTADO = 1
	CAMPO_ORDEN_ESTADO       = 2
	CAMPO_GRUPO_ESTADO       = 3
	
    sql = "SELECT * FROM GESTION_GRAPHISOFT_ESTADOS ORDER BY GRUPO, ORDEN"
    vacio_estados = false
    
    Set estados = execute_sql(conn_gag, sql)
    If Not estados.BOF Then
        mitabla_estados = estados.GetRows()
	Else
		vacio_estados = true
    End If

    close_connection(estados)
	
	campo_usuario_usuarios=0
	campo_nombre_usuarios=1
	campo_grupo_usuarios=2
	
	sql = "SELECT USUARIO, NOMBRE, GRUPO FROM GESTION_GRAPHISOFT_USUARIOS WHERE GRUPO<>'EXTERNOS' ORDER BY GRUPO, NOMBRE"
    vacio_empleados = false
    
    Set usuarios = execute_sql(conn_gag, sql)
    If Not usuarios.BOF Then
        mitabla_usuarios = usuarios.GetRows()
	Else
		vacio_usuarios = true
    End If

    close_connection(usuarios)

%>
<html lang="es">
<head>
	<!--<meta charset="utf-8">-->
	
</head>
<body>

<select id="cmbestados_plantilla" name="cmbestados_plantilla" style="display:none">
<%=cadena_select_estados%>
</select>
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
				
				<div class="panel panel-default">
					<div class="panel-body">
						
					<form name="frmbuscar_hojas_ruta" id="frmbuscar_hojas_ruta" method="post" action="">	
						<input type="hidden" id="ocultoejecutar" name="ocultoejecutar" value="SI" />
						<input type="hidden" id="ocultocliente_seleccionado" name="ocultocliente_seleccionado" value="" />
						<div class="form-group row mx-2">
							<div class="col-sm-4 col-md-4 col-lg-4">
								<label for="cmbempleados" class="control-label">Empleados</label>
								<select id="cmbempleados" name="cmbempleados" multiple="multiple">
									<%
										grupo=""
										For i = 0 to UBound(mitabla_usuarios, 2)
											If grupo <> mitabla_usuarios(campo_grupo_usuarios, i) Then
									%>
												<optgroup label="<%=mitabla_usuarios(campo_grupo_usuarios, i)%>">
									<%		
											End If
									%>
											<option value="<%=mitabla_usuarios(campo_usuario_usuarios, i)%>"><%=(mitabla_usuarios(campo_nombre_usuarios, i) & " (" & mitabla_usuarios(campo_usuario_usuarios, i) & ")")%></option>
									<%		
											If grupo <> mitabla_usuarios(campo_grupo_usuarios, i) Then
												grupo = mitabla_usuarios(campo_grupo_usuarios, i)
									%>
												</optgroup>
									<%
											End If
										Next
									%>
								</select>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_inicio" class="control-label">Fecha de Inicio</label>
								<input type="date" class="form-control" name="txtfecha_inicio" id="txtfecha_inicio" value="<%=fecha_inicio_seleccionada%>"/>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_fin" class="control-label">Fecha de Fin</label>
								<input type="date" class="form-control" name="txtfecha_fin" id="txtfecha_fin" value="<%=fecha_fin_seleccionada%>"/>
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="cmbestados" class="control-label">Estado</label>
								<select id="cmbestados" name="cmbestados" multiple="multiple">
									<%
										grupo=""
										For i = 0 to UBound(mitabla_estados, 2)
											If grupo <> mitabla_estados(CAMPO_GRUPO_ESTADO, i) Then
									%>
												<optgroup label="<%=mitabla_estados(CAMPO_GRUPO_ESTADO, i)%>">
									<%		
											End If
									%>
											<option value="<%=mitabla_estados(CAMPO_ID_ESTADO, i)%>"><%=mitabla_estados(CAMPO_DESCRIPCION_ESTADO, i)%></option>
									<%		
											If grupo <> mitabla_estados(CAMPO_GRUPO_ESTADO, i) Then
												grupo = mitabla_estados(CAMPO_GRUPO_ESTADO, i)
									%>
												</optgroup>
									<%
											End If
										Next
									%>
								</select>
							</div>
						</div>
						
						<div class="form-group row mx-2">
							<div class="col-sm-5 col-md-5 col-lg-5"></div>
							<div class="col-sm-3 col-md-2 col-lg-2">
								<button type="button" class="btn btn-primary btn-block" id="cmdconsultar" name="cmdconsultar"
									data-toggle="popover"
									data-placement="top"
									data-trigger="hover"
									data-content="Consultar Hojas de Ruta"
									data-original-title=""
									>
									<i class="fas fa-search"></i>&nbsp;&nbsp;&nbsp;Buscar
								</button>
							</div>

						</div>

					</form>

						<div class="row  mx-2">
							 <table id="lista_hojas_ruta" name="lista_hojas_ruta" class="table table-striped table-bordered" cellspacing="0" width="99%">
							  <thead>
								<tr>
									<th style="width:5%">Hoja Ruta</th>
									<th style="width:13%">Estado</th>
								 	<th style="width:17%">Cliente</th>
									<th style="width:26%">Referencia</th>
									<th style="width:13%">Subcontratista</th>		
									<th style="width:4%">Fecha Emision</th>
									<th style="width:4%">Fecha Envio</th>
									<th style="width:9%">Salida</th>
									<th style="width:4%">Albar&aacute;n</th>
									<th style="width:4%">N. Golpes</th>
									
								</tr>
							  </thead>
							</table>
            			</div>    
					
					</div><!--del panel body-->
				</div><!--del panel default-->
			</div><!--del content-fluid-->
        </div><!--fin de content-->
    </div><!--fin de wrapper-->

<!-- capa detalle HOJA RUTA -->
  <div class="modal fade" id="capa_detalle_hoja_ruta_">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_iframe_"></h4>	    
        </div>	    
        <div class="modal-body">
          <form class="form-horizontal row-border">
            <div class="form-group">
              <!--
              <iframe id='gmv.iframe_movilidad' src="" width="100%" height="0" frameborder="0" transparency="transparency" onload="gmv.redimensionar_iframe(this);"></iframe>
              -->
              
              <iframe id='iframe_detalle_hoja_ruta__' src="" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe> 	
             </div>                  
          </form>
        </div> <!-- del modal-body-->     
        
        <!--
        <div class="modal-footer">                  
          <p>                    
            <button type="button" onclick="alert('en construccion')" class="btn btn-primary" id="gmv.add_usr_btn">Aceptar</button>		    
            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>                  
          </p>                
        </div>
        -->  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa detalle HOJA RUTA -->    

<div class="modal fade" id="capa_detalle_hoja_ruta">
  <div class="modal-dialog">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title" id="cabecera_iframe"></h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>

      <!-- Modal body -->
      <div class="modal-body">
        <iframe id='iframe_detalle_hoja_ruta' src="" width="99%" height="99%" frameborder="0" transparency="transparency"></iframe> 
      </div>
    </div>
  </div>
</div>

<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos_">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
        </div>	    
        <div class="container-fluid" id="body_avisos_"></div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>  
  
  <!-- Modal -->
<div class="modal fade" id="pantalla_avisos" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="cabecera_pantalla_avisos">Aviso</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="body_avisos"></div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="pantalla_avisos_actualizar_graphisoft" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true"  data-backdrop="static" data-keyboard="false">
  <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="cabecera_pantalla_avisos_actualizar_graphisoft">Aviso</h5>
      </div>
      <div class="modal-body" id="body_avisos_actualizar_graphisoft"></div>
      <div class="modal-footer" style="display:none" id="pie_pantalla_avisos_actualizar_graphisoft">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>
    
  <!-- FIN capa mensajes -->

<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
	
<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>
    
<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>

<script type="text/javascript" src="plugins/bootstrap-multiselect/bootstrap-multiselect.js"></script>
 
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

<!--http://www.runningcoder.org/jquerytypeahead/documentation/-->
<script type="text/javascript" src="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min.js"></script>
<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script>  
<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>

<script type="text/javascript">
var j$ = jQuery.noConflict();

j$(document).ready(function () {
    j$("#menu_hojas_ruta").addClass('active')

    j$('#sidebarCollapse').on('click', function () {
        j$('#sidebar').toggleClass('active');
        j$(this).toggleClass('active');
    });
    j$('#cmbempleados').multiselect({ enableClickableOptGroups: true, buttonWidth: '100%', nonSelectedText: 'Seleccionar' });
	j$('#cmbestados').multiselect({ enableClickableOptGroups: true, buttonWidth: '100%', nonSelectedText: 'Seleccionar' });
    //para que se configuren los popover-titles...
    j$('[data-toggle="popover"]').popover({ html: true });
    j$('[data-toggle="popover_datatable"]').popover({ html: true, container: 'body' });

	//para refrescar las variables de sesion cada cierto tiempo y que no caduquen
	//se hace llamando a un iframe oculto
	setInterval('mantener_sesion()', <%= (int) (0.9 * (Session.Timeout * 60000)) %>)


});

mantener_sesion = function() {
	var fecha = new Date();
	//console.log('sesion en el momento ' + Date());
	j$('#iframe_sesion').attr("src", 'mantener_sesion.asp');
  };	

calcDataTableHeight = function () {
    return j$(window).height() * 55 / 100;
};





j$("#cmdconsultar").click(function () {
    //j$("#frmbuscar_articulos").submit()
    //para que se cargue la tabla
    if ((j$("#cmbempleados").val() == "") && 
        (j$("#txtfecha_inicio").val() == "") && 
		(j$("#txtfecha_fin").val() == "") && 
		(j$("#cmbestados").val() == "")){
	
        bootbox.alert({
            //size: 'large',
            message: '<h5>Has de Utilizar Alg&uacute;n Criterio de B&uacute;squeda</h5>'
            //callback: function () {return false;}
        });
    }
    else {
        consultar_hojas_ruta();
    }
});




consultar_hojas_ruta = function () {
    var err = "";

    //no hay control de errores por filtros no rellenados
    var prm = new ajaxPrm();
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

	prm.add("p_empleado", j$('#cmbempleados').val());
    prm.add("p_estado", j$('#cmbestados').val());
    prm.add("p_fecha_inicio", j$('#txtfecha_inicio').val());
	prm.add("p_fecha_fin", j$('#txtfecha_fin').val());
    prm.add("p_ejecutar", j$('#ocultoejecutar').val());
	
	

    j$.fn.dataTable.moment("DD/MM/YYYY");

    //deseleccioamos el registro de la lista
    j$('#lista_hojas_ruta tbody tr').removeClass('selected');

    if (typeof lst_hojas_ruta == "undefined") {
        lst_hojas_ruta = j$("#lista_hojas_ruta").DataTable({
            dom: '<"toolbar">Blfrtip',
            ajax: {
                url: "tojson/obtener_informe_empleados.asp?" + prm.toString(),
                type: "POST",
                dataSrc: "ROWSET"
            },
            /*
            columnDefs: [
                     {className: "dt-right", targets: [4,5,6,7]},
                     {className: "dt-center", targets: [4]}                                                            
                   ],
           */
            order: [[0, "desc"]],
            columns: [
                { data: "HOJA_DE_RUTA" },
				{ data: "ESTADO" },
				{ data: "CLIENTE_NOMBRE" },
                { data: "REFERENCIA",
					render: function(data, type, row){
						cadena_total=''
						switch(type) {
								case 'export':
									cadena_total=row.REFERENCIA
									break;

								default:
									cadena_referencia=''
									if ((row.OBSERVACIONES_GESTION!='') && (row.OBSERVACIONES_GESTION!=null))
										{
										cadena_referencia='&nbsp;<span style="font-size: 13px; color: Dodgerblue;"'
										cadena_referencia+=' data-toggle="popover_datatable"'
										cadena_referencia+=' data-placement="right"'
										cadena_referencia+=' data-trigger="hover"'
										cadena_referencia+=' data-content="' + row.OBSERVACIONES_GESTION + '"'
										cadena_referencia+=' data-original-title="OBSERVACIONES LOCALES"'
										cadena_referencia+='><i class="fas fa-info-circle"></i>'
										cadena_referencia+='</span>'
										}
									
									cadena_total='<span class="eltexto">' + row.REFERENCIA + '</span>' + cadena_referencia
								}
						
						return cadena_total;
					}},
                { data: "SUBCONTRATISTA" },
                {
                    data: "FECHA_EMISION",
                    render: function (data, type, row) {
                        if (type === "sort" || type === "type") {
                            return data;
                        }
                        return moment(data).format("DD/MM/YYYY");
                    }
                },
                {
                    data: "FECHA_ENTREGA",
                    render: function (data, type, row) {
                        if (data == null) {
                            return '';
                        }
                        else {
                            if (type === "sort" || type === "type") {
                                return data;
                            }
                            return moment(data).format("DD/MM/YYYY");
                        }
                    }
                },
				{ data: "SALIDA" },
                {
                    data: function (row, type, val, meta) {
                        //return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                                                                  
                        enlace_albaranes = ''
                        //console.log('cadena albaranes: ' + row.CADENA_ALBARANES)
                        if ((row.CADENA_ALBARANES != '') && (row.CADENA_ALBARANES != null)) {
                            albaranes = row.CADENA_ALBARANES.split(';')
                            j$.each(albaranes, function (i, obj) {
                                if (enlace_albaranes != '') {
                                    enlace_albaranes = enlace_albaranes + '<br/>'
                                }
                                //ruta_url = 'http://intranet.halconviajes.com/GlAlbaran/Glalbaran.aspx?codigo_albaran=' + albaranes[i]
				ruta_url = 'http://carrito.globalia-artesgraficas.com/GlAlbaran/Glalbaran.aspx?codigo_albaran=' + albaranes[i]
                                cadena = '<a href="' + ruta_url + '" target="_blank">' + albaranes[i] + '</a>'
                                enlace_albaranes = enlace_albaranes + cadena
                            })
                        }
                        else {
                            enlace_albaranes = ''
                        }

                        return enlace_albaranes
                    }
                },
				{ data: "NUMERO_GOLPES" },
                { data: "CADENA_ALBARANES", visible: false },
                { data: "ID_ESTADO", visible: false },
                { data: "ID", visible:false },
				{ data: "OBSERVACIONES_GESTION", visible:false },
				{ data: "PRESUPUESTISTA", visible:false }


            ],
            rowId: 'extn', //para que se refresque sin perder filtros ni ordenacion
            deferRender: true,
            //  Scroller
            scrollY: calcDataTableHeight(),
            scrollCollapse: true,
            //scroller: true,
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
            buttons: [{
                extend: "copy", text: '<i class="far fa-copy"></i>', titleAttr: "Copiar en Portapapeles",
                exportOptions:{columns:[0,1,14,2,3,4,5,6,7,8,9],
								format: {
									//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
									header: function ( data, columnIdx ) {
											switch(columnIdx) {
												case 14:
													return 'Presupuestista';
													break;
												default:
													return data;
												}
										},
									body: function ( data, row, column, node ) {
											switch(column) {
												case 4: //REFERENCIA
													seleccionado = j$.parseHTML(data)
													mostrar=j$(seleccionado, '.eltexto').text()
													return mostrar																											
													break;
													
												default:
													return data;
												}
										}
									}

						}}, 
				{extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Hojas_de_Ruta", extension:".xls", 
						exportOptions:{columns:[0,1,14,2,3,4,5,6,7,8,9],
												format: {
													//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
													header: function ( data, columnIdx ) {
																switch(columnIdx) {
																	case 14:
																		return 'Presupuestista';
																		break;
																	default:
																		return data;
																	}
															},
													body: function ( data, row, column, node ) {
															switch(column) {
																case 4: //REFERENCIA
																	seleccionado = j$.parseHTML(data)
																	mostrar=j$(seleccionado, '.eltexto').text()
																	return mostrar																											
																	break;
																	
																default:
																	return data;
																}
														}
													}
						
						}}, 
				{extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Hojas_de_Ruta", orientation:"landscape", 
						exportOptions:{columns:[0,1,14,2,3,4,5,6,7,8,9],
											format: {
													//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
													header: function ( data, columnIdx ) {
																switch(columnIdx) {
																	case 14:
																		return 'Presupuestista';
																		break;
																	default:
																		return data;
																	}
															},
													body: function ( data, row, column, node ) {
															switch(column) {
																case 4: //REFERENCIA
																	seleccionado = j$.parseHTML(data)
																	mostrar=j$(seleccionado, '.eltexto').text()
																	return mostrar																											
																	break;
																	
																default:
																	return data;
																}
														}
													}
				
						}}, 
				{extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Hojas_de_Ruta", 
						exportOptions:{columns:[0,1,14,2,3,4,5,6,7,8,9],
											format: {
													//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
													header: function ( data, columnIdx ) {
																switch(columnIdx) {
																	case 14:
																		return 'Presupuestista';
																		break;
																	default:
																		return data;
																	}
															},
													body: function ( data, row, column, node ) {
															switch(column) {
																case 4: //REFERENCIA
																	seleccionado = j$.parseHTML(data)
																	mostrar=j$(seleccionado, '.eltexto').text()
																	return mostrar																											
																	break;
																	
																default:
																	return data;
																}
														}
													}

					}}
				],


            rowCallback: function (row, data, index) {
                //stf.row_sel = data;   
                //console.log('dentro de rowcallback: ' + data);
                //j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});

                /* PODEMOS DEFINIR LOS EVENTOS DE LOS OBJETOS DEL DATATABLE AQUI
                var cmbestados_datatable = j$(row).find('.cmbestados_datatable');
                cmbestados_datatable.on("change", function () {
                    console.log('dentro del change');
                });
            	
                cmbestados_datatable.on("click", function () {
                    console.log('dentro del click');
                });
                */
            },
            drawCallback: function () {
                //para que se configuren los popover-titles...
                j$('[data-toggle="popover_datatable"]').popover({ html: true, container: 'body' });
            },
            //initComplete: stf.initComplete,                                                            
            language: { url: "plugins/dataTable/lang/Spanish.json" },
            paging: false,
            processing: true,
            searching: true
        });

        //A PARTIR DE AQUI DEFINIMOS LOS DIFERENTES EVENTOS QUE TENDRA EL DATATABLE Y SUS OBJETOS
        j$("#lista_hojas_ruta").on("xhr.dt", function () {
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
            j$('[data-toggle="popover_datatable"]').popover({ html: true, container: 'body' });
        })

        //controlamos el click, para seleccionar o desseleccionar la fila
        j$("#lista_hojas_ruta tbody").on("click", "tr", function () {
            if (!j$(this).hasClass("selected")) {
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
        j$("#lista_hojas_ruta").on("dblclick", "tr", function (e) {
            var row = lst_hojas_ruta.row(j$(this).closest("tr")).data()
            parametro_hoja_ruta = row.HOJA_DE_RUTA.replace(' ', '')

            lst_hojas_ruta.$("tr.selected").css("background-color", '');;
            lst_hojas_ruta.$("tr.selected").removeClass("selected");

            j$(this).addClass('selected');
            j$(this).css('background-color', '#9FAFD1');


            mostrar_detalle_hoja_ruta(parametro_hoja_ruta)
        });

        
        

        
        /*
        j$('#lista_hojas_ruta').on('click', '.cmbestados_datatable', function() {
          console.log('cambiando el valor a: ' + this.value);
        });
        */
    }
    else {
        //stf.lst_tra.clear().draw();
        lst_hojas_ruta.ajax.url("tojson/obtener_informe_empleados.asp?" + prm.toString());
        lst_hojas_ruta.ajax.reload();
    }

    lst_hojas_ruta.on('buttons-action', function (e, buttonApi, dataTable, node, config) {
        //console.log( 'Button '+ buttonApi.text()+' was activated' );

    });
};




mostrar_detalle_hoja_ruta = function (parametro_hoja_ruta) {
    //alert('entro dentro de mostrar_capa_movilidad')
    //cargaSelectsNew("p_combo=EMPORG", "gmv.lov_usr_codemp", "S");  
    url_iframe = 'Detalle_Hoja_Ruta.asp?hoja_ruta=' + parametro_hoja_ruta

    //console.log('url del iframe: ' + url_iframe)
    cadena_cabecera = 'Detalle Hoja de Ruta ' + parametro_hoja_ruta

    j$("#cabecera_iframe").html(cadena_cabecera);
    j$('#iframe_detalle_hoja_ruta').attr('src', url_iframe)
    j$("#capa_detalle_hoja_ruta").modal("show");
}

j$('#capa_detalle_hoja_ruta').on('show.bs.modal', function () {
    //j$('#capa_detalle_hoja_ruta .modal-body').css('overflow-y', 'auto'); 
    j$('#capa_detalle_hoja_ruta .modal-body').css('height', j$(window).height() * 0.85);
    j$('#capa_detalle_hoja_ruta .modal-body').css('max-height', j$(window).height() * 0.85);
    //console.log(j$('#capa_detalle_hoja_ruta .modal-body').height())
});

j$('#capa_detalle_hoja_ruta').on('hide.bs.modal', function (e) {
    // recargo el datatable por si ha habido modificacion desde graphisoft y que se refresque
    lst_hojas_ruta.ajax.reload()
})


    </script>


<!-- Bootstrap CSS CDN -->
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
	
	<link rel="stylesheet" href="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min.css">
	
	<link rel="stylesheet"  type="text/css" href="plugins/bootstrap-multiselect/bootstrap-multiselect.css">

	<link rel="stylesheet" href="css/style_menu_hamburguesa5.css">
	
	<script type="text/javascript" src="plugins/fontawesome-5.7.1/js/all.js" defer></script>
    
   	<style>
		/* si pongo esto dentro de un fichero css para que se cargue, no se porque pero no funciona, asique lo pongo aqui */
		#capa_detalle_hoja_ruta .modal-dialog  {width:95% !important; max-width: 1350px !important;}
		#pantalla_avisos_actualizar_graphisoft .modal-dialog  {width:80% !important; max-width: 1350px !important;}
		.combo_datatable {
 		   font-size: 22px;
		}
	</style>
	<link rel="stylesheet" href="css/custom_datatables.css">

	<script language="javascript" src="js/Funciones_Ajax.js"></script>

    
<!--IFRAME QUE LLAMA CADA 20 MINUTOS A UNA PAGINA PARA MANTENER LA SESION ACTIVA SIEMPRE Y QUE NO CADUQUE-->
<iframe id="iframe_sesion" src="mantener_sesion.asp" style="display:none ">
</iframe>
</body>
<%
	close_connection(conn_gag)
%>
</html>