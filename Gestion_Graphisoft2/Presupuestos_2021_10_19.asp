<!--#include file="DB_Manager.inc"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    ' ToDo:
    ' =====
    ' - Eliminar aquellos modales que no sean necesarios
    ' - Refactorizar y minimizar el código

%>
<%
    Dim estados
    Dim sql 

	If Session("usuario") = "" Then
        Response.Redirect("Login.asp")
	End If
	Response.Buffer  = true
	numero_registros = 0

    CAMPO_ID_ESTADO                 = 0
	CAMPO_DESCRIPCION_ESTADO        = 1
    CAMPO_ID_ESTADO_PRESUPUESTO     = 0
    CAMPO_NOMBRE_ESTADO_PRESUPUESTO = 1
	CAMPO_GRUPO_ESTADO_PRESUPUESTO  = 3
	
		
	'response.write("procedencia: " & request.servervariables("http_referer"))
	presupuesto_seleccionado           = Request.Form("txtpresupuesto")
	estado_seleccionado                = Request.Form("cmbestados")
	cliente_seleccionado               = Request.Form("txtcliente")
	version_seleccionada               = Request.Form("txtversiones")
	presupuestista_seleccionada        = Request.Form("txtpresupuestista")
	fecha_creacion_desde_seleccionada  = Request.Form("txtfecha_creacion_desde")
	fecha_creacion_hasta_seleccionada  = Request.Form("txtfecha_creacion_hasta")
	ejecutar_consulta                  = Request.Form("ocultoejecutar")
		
	'response.write("<br>origen : " & Request.ServerVariables("HTTP_REFERER"))
	'response.write("<br>encontrado: " & instr(ucase(Request.ServerVariables("HTTP_REFERER")), "CONSULTA_ARTICULOS_ADMIN"))

	'si venimos de otra pagina que no sea la propia consulta de articulos que aparezca por defecto 
	' en eliminado la opcion de no
	If Instr(Ucase(Request.ServerVariables("HTTP_REFERER")), "CONSULTA_ARTICULOS_ADMIN") = 0 Then
		campo_eliminado = "NO"
	End If

    ' Get all budget estates	
    sql = "SELECT * FROM GESTION_GRAPHISOFT_ESTADOS_PRESUPUESTOS ORDER BY GRUPO, ORDEN ASC"
    vacio_estados = false
    
    Set estados = execute_sql(conn_gag, sql)
    If Not estados.BOF Then
        mitabla_estados = estados.GetRows()
        cadena_select_estados = ""
        For i = 0 To UBound(mitabla_estados, 2)
            cadena_select_estados = cadena_select_estados & "<option value=""" & mitabla_estados(CAMPO_ID_ESTADO, i) & """>" & mitabla_estados(CAMPO_DESCRIPCION_ESTADO, i) & "</option>"
        Next
	Else
		vacio_estados = true
    End If


	CAMPO_ID_SUBESTADOS = 0
	CAMPO_ID_ESTADO_SUB = 1
	CAMPO_DESCRIPCION_SUBESTADOS = 2
	' Get all budget estates	
    sql_subestados = "SELECT ID, ID_ESTADO, DESCRIPCION FROM GESTION_GRAPHISOFT_SUBESTADOS_PRESUPUESTOS WHERE ID_ESTADO=5 OR ID_ESTADO=6 ORDER BY ID_ESTADO, ORDEN"
    vacio_subestados = false
    
    Set subestados = execute_sql(conn_gag, sql_subestados)
    If Not subestados.BOF Then
        mitabla_subestados = subestados.GetRows()
        cadena_select_subestados_estudio = ""
		cadena_select_subestados_rechazado = ""
        For i = 0 To UBound(mitabla_subestados, 2)
			if mitabla_subestados(CAMPO_ID_ESTADO_SUB, i) = 5 THEN ' ES DEL ESTADO EN ESTUDIO
				cadena_select_subestados_estudio = cadena_select_subestados_estudio & "<option value=""" & mitabla_subestados(CAMPO_ID_SUBESTADOS, i) & """>" & mitabla_subestados(CAMPO_DESCRIPCION_SUBESTADOS, i) & "</option>"
			end if
			if mitabla_subestados(CAMPO_ID_ESTADO_SUB, i) = 6 THEN ' ES DEL ESTADO RECHAZADO
				cadena_select_subestados_rechazado = cadena_select_subestados_rechazado & "<option value=""" & mitabla_subestados(CAMPO_ID_SUBESTADOS, i) & """>" & mitabla_subestados(CAMPO_DESCRIPCION_SUBESTADOS, i) & "</option>"
			end if
        Next
	Else
		vacio_subestados = true
    End If





    ' Get all available budget versions
    sql = "SELECT DISTINCT VERSION FROM GESTION_GRAPHISOFT_PRESUPUESTOS ORDER BY VERSION ASC"
    vacio_versiones_presupuestos = false

    Set versiones_presupuestos = execute_sql(conn_gag, sql)
    If Not versiones_presupuestos.BOF Then
        mitabla_versiones_presupuestos = versiones_presupuestos.GetRows()
        cadena_select_versiones_presupuestos = ""
        For i = 0 To UBound(mitabla_versiones_presupuestos, 2)
            cadena_select_versiones_presupuestos = cadena_select_versiones_presupuestos & "<option value=""" & mitabla_versiones_presupuestos(CAMPO_ID_ESTADO_PRESUPUESTO, i) & """>" & mitabla_versiones_presupuestos(CAMPO_ID_ESTADO_PRESUPUESTO, i) & "</option>"
        Next
	Else
		vacio_versiones_presupuestos = true
    End If

    close_connection(estados)    
    close_connection(versiones_presupuestos)    
%>
<html lang="es">
<head>
	<!--<meta charset="utf-8">-->
    <!-- Font Awesome JS -->
    <!--
	<script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
	-->
<style>
/* Removes the clear button from date inputs */
.proxima_revision::-webkit-clear-button {
    display: none;
}

/* Removes the spin button */
.proxima_revision::-webkit-inner-spin-button { 
    display: none;
}

/* Always display the drop down caret */
.proxima_revision::-webkit-calendar-picker-indicator {
    /*color: #2c3e50;*/
}

/* A few custom styles for date inputs */
.proxima_revision {
    appearance: none;
    -webkit-appearance: none;
    /*color: #95a5a6;*/
    font-family: "Helvetica", arial, sans-serif;
    font-size: 18px;
    border:1px solid #ecf0f1;
    /*background:#ecf0f1;*/
    padding:5px;
    display: inline-block !important;
    visibility: visible !important;
}

.proxima_revision, focus {
    color: #95a5a6;
    box-shadow: none;
    -webkit-box-shadow: none;
    -moz-box-shadow: none;
}

</style>    
</head>
<body>

<select id="cmbestados_plantilla" name="cmbestados_plantilla" style="display:none">
<%=cadena_select_estados%>
</select>

<select id="cmbsubestados_estudio_plantilla" name="cmbsubestados_estudio_plantilla" style="display:none">
	<option value=""></option>
	<%=cadena_select_subestados_estudio%>
</select>

<select id="cmbsubestados_rechazado_plantilla" name="cmbsubestados_rechazado_plantilla" style="display:none">
	<option value=""></option>
	<%=cadena_select_subestados_rechazado%>
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
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtpresupuesto" class="control-label">Presupuesto</label>
								<input type="text" class="form-control" name="txtpresupuesto" id="txtpresupuesto" value="<%=presupuesto_seleccionado%>" placeholder="12345">
							</div>
							<div class="col-sm-4 col-md-4 col-lg-4">
								<label for="txtpresupuestista" class="control-label">Presupuestista</label>
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input class="js-typeahead-presupuestista form-control" name="txtpresupuestista" id="txtpresupuestista" type="search" placeholder="Buscar Presupuestista" autocomplete="off" value="<%=presupuestista_seleccionado%>">
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-6 col-md-6 col-lg-6">
								<label for="txtcliente" class="control-label">Cliente</label>
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input class="js-typeahead-cliente form-control" name="txtcliente" id="txtcliente" type="search" placeholder="Buscar Cliente" autocomplete="off" value="<%=cliente_seleccionado%>">
										</div>
									</div>
								</div>
								<div class="form-check">
									<label class="radio-inline">
									  <input type="radio" name="chkdel_grupo" value="TODOS" checked> Todos&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</label>
									<label class="radio-inline">
									  <input type="radio" name="chkdel_grupo" value="GRUPO"> Del Grupo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</label>
									<label class="radio-inline">
									  <input type="radio" name="chkdel_grupo" value="EXTERNO"> No Grupo
									</label>
								</div>
								
							</div>
						</div>
						<div class="form-group row mx-2">
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="cmbestados" class="control-label">Estado</label>
								<select id="cmbestados" name="cmbestados" multiple="multiple">
									
									<%
									grupo=""
									For i = 0 to UBound(mitabla_estados, 2)
										if mitabla_estados(CAMPO_GRUPO_ESTADO_PRESUPUESTO, i)=" SIN GRUPO" then%>
												<option value="<%=mitabla_estados(CAMPO_ID_ESTADO, i)%>"><%=mitabla_estados(CAMPO_DESCRIPCION_ESTADO, i)%></option>
										<%else
											if grupo <> mitabla_estados(CAMPO_GRUPO_ESTADO_PRESUPUESTO, i) Then%>
												<optgroup label="<%=mitabla_estados(CAMPO_GRUPO_ESTADO_PRESUPUESTO, i)%>">
											<%end if%>
											<option value="<%=mitabla_estados(CAMPO_ID_ESTADO, i)%>"><%=mitabla_estados(CAMPO_DESCRIPCION_ESTADO, i)%></option>
											<%if grupo <> mitabla_estados(CAMPO_GRUPO_ESTADO_PRESUPUESTO, i) Then
												grupo = mitabla_estados(CAMPO_GRUPO_ESTADO_PRESUPUESTO, i)%>
												</optgroup>
											<%end If
										end if
									Next%>
									
									
									
								</select>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
                                <label for="txtversiones" class="control-label">Versi&oacute;n</label>
								<select id="txtversiones" name="txtversiones" class="form-control">
                                    <option value="ultima">&Uacuteltima</option>
									<option value="">Todos</option>
                                    <%=cadena_select_versiones_presupuestos%>
								</select>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_creacion_desde" class="control-label">F. Creac. Desde</label>
								<input type="date" class="form-control" name="txtfecha_creacion_desde" id="txtfecha_creacion_desde" value="<%=fecha_creacion_desde_seleccionada%>"/>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_creacion_hasta" class="control-label">F. Creac. Hasta</label>
								<input type="date" class="form-control" name="txtfecha_creacion_hasta" id="txtfecha_creacion_hasta" value="<%=fecha_creacion_hasta_seleccionada%>"/>
							</div>
							
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="cmdconsultar" class="control-label">&nbsp;</label>
								<button type="button" class="btn btn-primary btn-block" id="cmdconsultar" name="cmdconsultar"
									data-toggle="popover"
									data-placement="top"
									data-trigger="hover"
									data-content="Consultar Presupuestos"
									data-original-title=""
									>
									<i class="fas fa-search mr-2"></i>Buscar
								</button>
							</div>
							
						</div>		
					</form>
						<div class="row  mx-2">
							 <table id="lista_presupuestos" name="lista_presupuestos" class="table table-striped table-bordered" cellspacing="0" width="99%">
							  <thead>
								<tr>
								  <th class="w-2">Presup.</th>
								  <th class="w-22">Estado</th>
								  <th class="w-20">Cliente</th>
								  <th class="w-15">Presupuestista</th>
								  <th class="w-25">Descripci&oacute;n</th>
								  <th class="w-2">Fecha de creaci&oacute;n</th>		
								  <th class="w-4">Cantidad</th>
								  <th class="w-4">Importe</th>
								  <th class="w-5">Subestado</th>
								  <th class="w-2">Pr&oacute;xima Revisi&oacute;n</th>
								</tr>
							  </thead>
							</table>
            			</div>    
					
					</div><!--del panel body-->
				</div><!--del panel default-->
			</div><!--del content-fluid-->
        </div><!--fin de content-->
    </div><!--fin de wrapper-->

<!-- capa detalle Presupuesto -->
  <div class="modal fade" id="capa_detalle_presupuesto_">	
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
              
              <iframe id='iframe_detalle_presupuesto__' src="" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe> 	
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
  <!-- FIN capa detalle Presupuesto -->    

<div class="modal fade" id="capa_detalle_presupuesto">
  <div class="modal-dialog">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title" id="cabecera_iframe"></h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>

      <!-- Modal body -->
      <div class="modal-body">
        <iframe id='iframe_detalle_presupuesto' src="" width="99%" height="99%" frameborder="0" transparency="transparency"></iframe> 
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
    j$('#cmbestados').multiselect({ enableClickableOptGroups: true, buttonWidth: '100%', nonSelectedText: 'Seleccionar' });
    //para que se configuren los popover-titles...
    j$('[data-toggle="popover"]').popover({ html: true });
    j$('[data-toggle="popover_datatable"]').popover({ html: true, container: 'body' });
	
	//para refrescar las variables de sesion cada cierto tiempo y que no caduquen
	//se hace llamando a un iframe oculto
	setInterval('mantener_sesion()', <%= (int) (0.9 * (Session.Timeout * 60000)) %>)
	
	//alert('valor del chk: ' + j$("input[name='chkdel_grupo']:checked").val())
	

    /**
 * @private
 * Default options
 
var _options = {
    input: null,                // *RECOMMENDED*, jQuery selector to reach Typeahead's input for initialization
    minLength: 2,               // Accepts 0 to search on focus, minimum character length to perform a search
    maxLength: false,           // False as "Infinity" will not put character length restriction for searching results
    maxItem: 8,                 // Accepts 0 / false as "Infinity" meaning all the results will be displayed
    dynamic: false,             // When true, Typeahead will get a new dataset from the source option on every key press
    delay: 300,                 // delay in ms when dynamic option is set to true
    order: null,                // "asc" or "desc" to sort results
    offset: false,              // Set to true to match items starting from their first character
    hint: false,                // Added support for excessive "space" characters
    accent: false,              // Will allow to type accent and give letter equivalent results, also can define a custom replacement object
    highlight: true,            // Added "any" to highlight any word in the template, by default true will only highlight display keys
    multiselect: null,          // Multiselect configuration object, see documentation for all options
    group: false,               // Improved feature, Boolean,string,object(key, template (string, function))
    groupOrder: null,           // New feature, order groups "asc", "desc", Array, Function
    maxItemPerGroup: null,      // Maximum number of result per Group
    dropdownFilter: false,      // Take group options string and create a dropdown filter
    dynamicFilter: null,        // Filter the typeahead results based on dynamic value, Ex: Players based on TeamID
    backdrop: false,            // Add a backdrop behind Typeahead results
    backdropOnFocus: false,     // Display the backdrop option as the Typeahead input is :focused
    cache: false,               // Improved option, true OR 'localStorage' OR 'sessionStorage'
    ttl: 3600000,               // Cache time to live in ms
    compression: false,         // Requires LZString library
    searchOnFocus: false,       // Display search results on input focus
    blurOnTab: true,            // Blur Typeahead when Tab key is pressed, if false Tab will go though search results
    resultContainer: null,      // List the results inside any container string or jQuery object
    generateOnLoad: null,       // Forces the source to be generated on page load even if the input is not focused!
    mustSelectItem: false,      // The submit function only gets called if an item is selected
    href: null,                 // String or Function to format the url for right-click & open in new tab on link results
    display: ["display"],       // Allows search in multiple item keys ["display1", "display2"]
    template: null,             // Display template of each of the result list
    templateValue: null,        // Set the input value template when an item is clicked
    groupTemplate: null,        // Set a custom template for the groups
    correlativeTemplate: false, // Compile display keys, enables multiple key search from the template string
    emptyTemplate: false,       // Display an empty template if no result
    cancelButton: true,         // If text is detected in the input, a cancel button will be available to reset the input (pressing ESC also cancels)
    loadingAnimation: true,     // Display a loading animation when typeahead is doing request / searching for results
    filter: true,               // Set to false or function to bypass Typeahead filtering. WARNING: accent, correlativeTemplate, offset & matcher will not be interpreted
    matcher: null,              // Add an extra filtering function after the typeahead functions
    source: null,               // Source of data for Typeahead to filter
    callback: {
        onInit: null,               // When Typeahead is first initialized (happens only once)
        onReady: null,              // When the Typeahead initial preparation is completed
        onShowLayout: null,         // Called when the layout is shown
        onHideLayout: null,         // Called when the layout is hidden
        onSearch: null,             // When data is being fetched & analyzed to give search results
        onResult: null,             // When the result container is displayed
        onLayoutBuiltBefore: null,  // When the result HTML is build, modify it before it get showed
        onLayoutBuiltAfter: null,   // Modify the dom right after the results gets inserted in the result container
        onNavigateBefore: null,     // When a key is pressed to navigate the results, before the navigation happens
        onNavigateAfter: null,      // When a key is pressed to navigate the results
        onEnter: null,              // When an item in the result list is focused
        onLeave: null,              // When an item in the result list is blurred
        onClickBefore: null,        // Possibility to e.preventDefault() to prevent the Typeahead behaviors
        onClickAfter: null,         // Happens after the default clicked behaviors has been executed
        onDropdownFilter: null,     // When the dropdownFilter is changed, trigger this callback
        onSendRequest: null,        // Gets called when the Ajax request(s) are sent
        onReceiveRequest: null,     // Gets called when the Ajax request(s) are all received
        onPopulateSource: null,     // Perform operation on the source data before it gets in Typeahead data
        onCacheSave: null,          // Perform operation on the source data before it gets in Typeahead cache
        onSubmit: null,             // When Typeahead form is submitted
        onCancel: null              // Triggered if the typeahead had text inside and is cleared
    },
    selector: {
        container: "typeahead__container",
        result: "typeahead__result",
        list: "typeahead__list",
        group: "typeahead__group",
        item: "typeahead__item",
        empty: "typeahead__empty",
        display: "typeahead__display",
        query: "typeahead__query",
        filter: "typeahead__filter",
        filterButton: "typeahead__filter-button",
        dropdown: "typeahead__dropdown",
        dropdownItem: "typeahead__dropdown-item",
        labelContainer: "typeahead__label-container",
        label: "typeahead__label",
        button: "typeahead__button",
        backdrop: "typeahead__backdrop",
        hint: "typeahead__hint",
        cancelButton: "typeahead__cancel-button"
    },
    debug: false // Display debug information (RECOMMENDED for dev environment)
};//_options
*/

    //**********************************
    //este control esta en esta url: http://www.runningcoder.org/jquerytypeahead
    
	cargar_combo_clientes()

    j$.typeahead({
        input: '.js-typeahead-presupuestista',
        //input: '.typeahead_clientes',
        minLength: 0,
        maxItem: 15,
        order: "asc",
        hint: true,
        accent: true,
        cancelButton: false,
        //searchOnFocus: true,
        backdrop: {
            "background-color": "#3879d9",
            //"background-color": "#fff",
            "opacity": "0.1",
            "filter": "alpha(opacity=10)"
        },
        source: {
            cliente: {
                //display: ["REFERENCIA", "TIPO_MALETA", "TAMANNO", "COLOR"],
                display: "PRESUPUESTISTA",
                ajax: function (query) {
                    return {
                        type: "POST",
                        url: "tojson/obtener_presupuestistas_graphisoft.asp",
                        //{"status":true,"error":null,"data":{"user":[{"id":748137,"username":"juliocastrop","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/748137"},{"id":5741776,"username":"solevy","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/5741776"},{"id":906237,"username":"nilovna","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/906237"},{"id":612578,"username":"Thiago Talma","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/612578"},{"id":985837,"username":"ldrrp","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/985837"}],"project":[{"id":2,"project":"jQuery Validation","image":"http:\/\/www.runningcoder.org\/assets\/jqueryvalidation\/img\/jqueryvalidation-preview.jpg","version":"1.4.0","demo":11,"option":14,"callback":8}]}}
                        //path: "data.user",
                        path: "data",
                        //data: {proveedor: "<%=proveedor%>"},
                        callback: {

                        }
                    }
                }
            }

        },
        callback: {
            onInit: function (node) {
                //console.log('Typeahead Initiated on ' + node.selector);
            }
        },
        debug: true
    });
});





cargar_combo_clientes = function() {
j$.typeahead({
        input: '.js-typeahead-cliente',
        //input: '.typeahead_clientes',
        minLength: 0,
        maxItem: 15,
        order: "asc",
        hint: true,
        accent: true,
        cancelButton: false,
        //searchOnFocus: true,
        backdrop: {
            "background-color": "#3879d9",
            //"background-color": "#fff",
            "opacity": "0.1",
            "filter": "alpha(opacity=10)"
        },
        source: {
            cliente: {
                //display: ["REFERENCIA", "TIPO_MALETA", "TAMANNO", "COLOR"],
                display: "NOMBRE",
                ajax: function (query) {
                    return {
                        type: "POST",
                        url: "tojson/obtener_clientes_graphisoft_presupuestos.asp",
                        //{"status":true,"error":null,"data":{"user":[{"id":748137,"username":"juliocastrop","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/748137"},{"id":5741776,"username":"solevy","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/5741776"},{"id":906237,"username":"nilovna","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/906237"},{"id":612578,"username":"Thiago Talma","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/612578"},{"id":985837,"username":"ldrrp","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/985837"}],"project":[{"id":2,"project":"jQuery Validation","image":"http:\/\/www.runningcoder.org\/assets\/jqueryvalidation\/img\/jqueryvalidation-preview.jpg","version":"1.4.0","demo":11,"option":14,"callback":8}]}}
                        //path: "data.user",
                        path: "data",
                        //data: {p_tipo: j$("input[name='chkdel_grupo']:checked").val()},
						callback: {

                        }
                    }
                }
            }
        },
        callback: {
            onInit: function (node) {
                //console.log('Typeahead Initiated on ' + node.selector);
            },
			onClick: function (node, a, item, event) {
	 
				// You can do a simple window.location of the item.href
				//alert(JSON.stringify(item));
				//alert(item.ID)
				j$("#ocultocliente_seleccionado").val(item.ID)
			},
			onCancel: function (node, a, item, event) {
				j$("#ocultocliente_seleccionado").val('')
			}			
			
        },
        debug: true
    });
	
	
}


/*
j$('input[type=radio][name=chkdel_grupo]').on('change', function () {
	console.log('change en el optionbutton')
	j$('.js-typeahead-cliente').typeahead('destroy');
	cargar_combo_clientes()


})
*/

mantener_sesion = function() {
	var fecha = new Date();
	//console.log('sesion en el momento ' + Date());
	j$('#iframe_sesion').attr("src", 'mantener_sesion.asp');
  };	

calcDataTableHeight = function () {
    return j$(window).height() * 55 / 100;
};

mostrar_imagen_articulo = function (codigo) {
    cadena = '<div align="center"><div class="row my-auto">'
    cadena = cadena + '<div class="mx-auto text-center">'
    cadena = cadena + '<span>'
    cadena = cadena + '<a href="Imagenes_Articulos/' + codigo + '.jpg" target="_blank" id="imagen_enlace">'
    cadena = cadena + '<img class="img-responsive" src="Imagenes_Articulos/Miniaturas/i_' + codigo + '.jpg" border="0" id="imagen_articulo"></a>'
    cadena = cadena + '</span>'
    cadena = cadena + '<br><label class="control-label">pulsar sobre la imagen para verla a tama&ntilde;o real</label>'
    cadena = cadena + '</div>'
    cadena = cadena + '</div>'
    cadena = cadena + '</div>'

    bootbox.alert({
        //size: 'large',
        message: cadena
        //callback: function () {return false;}
    })

};

j$("#cmdconsultar").click(function () {
    //j$("#frmbuscar_articulos").submit()
    //para que se cargue la tabla
    if ((j$("#txtpresupuesto").val()    == "") && 
        (j$("#cmbestados").val()        == "") && 
        (j$("#txtcliente").val()        == "") && 
        (j$("#txtversiones").val()      == "") && 
        (j$("#txtpresupuestista").val() == "") &&
		(j$("#txtfecha_creacion_desde").val() == "") && 
        (j$("#txtfecha_creacion_hasta").val() == "")) {
        bootbox.alert({
            //size: 'large',
            message: '<h5>Has de Utilizar Alg&uacute;n Criterio de B&uacute;squeda</h5>'
            //callback: function () {return false;}
        })
    }
    else {
        consultar_hojas_ruta();
    }
});

consultar_hojas_ruta = function () {
    var err = "";

    //no hay control de errores por filtros no rellenados
    var prm = new ajaxPrm();

    prm.add("p_presupuesto", j$('#txtpresupuesto').val());
    prm.add("p_estado", j$('#cmbestados').val());
    //prm.add("p_cliente", j$('#txtcliente').val());
	prm.add("p_cliente", j$('#ocultocliente_seleccionado').val());
    prm.add("p_version", j$('#txtversiones').val());
    prm.add("p_presupuestista", j$('#txtpresupuestista').val());
    prm.add("p_fecha_creacion_desde", j$('#txtfecha_creacion_desde').val());
	prm.add("p_fecha_creacion_hasta", j$('#txtfecha_creacion_hasta').val());
    prm.add("p_ejecutar", j$('#ocultoejecutar').val());
	prm.add("p_tipo_cliente", j$("input[name='chkdel_grupo']:checked").val());

    j$.fn.dataTable.moment("DD/MM/YYYY");

    //deseleccioamos el registro de la lista
    j$('#lista_presupuestos tbody tr').removeClass('selected');

    if (typeof lst_presupuesto == "undefined") {
        lst_presupuesto = j$("#lista_presupuestos").DataTable({
            dom: '<"toolbar">Blfrtip',
            ajax: {
                url: "tojson/obtener_presupuestos.asp?" + prm.toString(),
                type: "POST",
                dataSrc: "ROWSET"
            },
            
            columnDefs: [
                     {className: "dt-right", targets: [0,5,6,7]}
					 //,{className: "dt-center", targets: [4]}                                                            
                   ],
           
            order: [[0, "desc"]],
            columns: [
                { data: "PRESUPUESTO_VERSION" },
                //{ data: "ESTADO" },
				{ data: "ESTADO",
					render: function(data, type, row){
							cadena_total=''
							//console.log('estado: ' + row.ESTADO)
							//console.log('type: ' + type)
							switch(type) {
									case 'export':
										//console.log('ES UN EXPORT estado: ' + row.ESTADO)
										cadena_total=row.ESTADO
										break;
										
									case 'sort':
										cadena_total=row.ESTADO
										break;		
										
									default:
										cadena='<select class="custom-select-sm form-control-sm form-control cmbestados_datatable" id="cmbestados_datatable_' + row.ID_PRESUPUESTO + '" estado_anterior="' + row.ID_ESTADO + '" style="font-size: 11px;">'
					
										j$("#cmbestados_plantilla option").each(function(){
											//console.log('desde el datatable:  opcion ' + j$(this).text()+' valor '+ j$(this).attr('value'))
											
											//console.log('id_estado: ' + row.ID_ESTADO + ' .. combo: ' + j$(this).attr('value'))
											
											prohibimos=''
											/*NO SABEMOS SI TENEMOS QUE DESHABILITAR ALGUN ESTADO
											if (j$(this).attr('value')==12) //inhabilitamos el estado de cancelado
												{
												prohibimos=' disabled'
												}
											  else
												{
												prohibimos=''
												}
											*/
											if (j$(this).attr('value')==row.ID_ESTADO)
												{
												cadena+='<option value="' + j$(this).attr('value') + '" selected style="font-size: 11px;"' + prohibimos + '>' + j$(this).text() + '</option>'
												}
											  else
												{
												cadena+='<option value="' + j$(this).attr('value') + '" style="font-size: 11px;"' + prohibimos + '>' + j$(this).text() + '</option>'
												}
												
										});
										cadena+='</select>'
										cadena+='<button type="button" class="btn btn-primary boton_guardar_estado"'
										cadena+=' data-toggle="popover_datatable"'
										cadena+=' data-placement="bottom"'
										cadena+=' data-trigger="hover"'
										cadena+=' data-content="Guardar Estado"'
										cadena+=' data-original-title=""'
										cadena+=' style="display:none; margin-top:5px">'
										cadena+='<i class="far fa-save"></i>'
										cadena+='</button>'
										cadena+='<button type="button" class="btn btn-primary boton_cancelar_guardar_estado"'
										cadena+=' data-toggle="popover_datatable"'
										cadena+=' data-placement="bottom"'
										cadena+=' data-trigger="hover"'
										cadena+=' data-content="Cancelar Cambio"'
										cadena+=' data-original-title=""'
										cadena+=' style="display:none; margin-left:3px; margin-top:5px">'
										cadena+='<i class="fas fa-window-close"></i>'
										cadena+='</button>'
										
										cadena_total=cadena
									}
								return cadena_total
					}}, 
                { data: "CLIENTE" },
                { data: "PRESUPUESTISTA" },
				//{ data: "DESCRIPCION" },
				{ data: "DESCRIPCION",
					render: function(data, type, row){
						cadena_total=''
						switch(type) {
								case 'export':
									cadena_total=row.DESCRIPCION
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
									
									cadena_total='<span class="eltexto">' + row.DESCRIPCION + '</span>' + cadena_referencia
								}
						
						return cadena_total;
					}},
				
				
                {
                    data: "FECHA_CREACION",
                    render: function (data, type, row) {
                        if (type === "sort" || type === "type") {
                            return data;
                        }
                        return moment(data).format("DD/MM/YYYY");
                    }
                },
                { data: "CANTIDAD" },
                { data: "IMPORTE" 
					,render: function(data, type, row){
						return parseFloat(row.IMPORTE).toFixed(2).toString().replace('.',',')
						}
				},
				//{ data: "SUBESTADO" },
				{ data: "SUBESTADO",
					render: function(data, type, row){
							cadena_total=''
							//console.log('estado: ' + row.ESTADO)
							//console.log('type: ' + type)
							switch(type) {
									case 'export':
										//console.log('ES UN EXPORT estado: ' + row.ESTADO)
										cadena_total=row.SUBESTADO
										break;
										
									case 'sort':
										cadena_total=row.SUBESTADO
										break;		
										
									default:
										if (row.ID_ESTADO==5 || row.ID_ESTADO==6) // solo es es rechazado o en estudio, tiene subestados
											{
											cadena='<select class="custom-select-sm form-control-sm form-control cmbsubestados_datatable" id="cmbsubestados_datatable_' + row.ID_PRESUPUESTO + '" estado_anterior="' + row.ID_SUBESTADO + '" style="font-size: 11px;">'
											combo_correcto=''
											if (row.ID_ESTADO==5)
												{
												combo_correcto='estudio'
												}
											if (row.ID_ESTADO==6)
												{
												combo_correcto='rechazado'
												}
											j$("#cmbsubestados_" + combo_correcto + "_plantilla option").each(function(){
												//console.log('desde el datatable:  opcion ' + j$(this).text()+' valor '+ j$(this).attr('value'))
												//console.log('id_estado: ' + row.ID_ESTADO + ' .. combo: ' + j$(this).attr('value'))
												if (j$(this).attr('value')==row.ID_SUBESTADO)
													{
													cadena+='<option value="' + j$(this).attr('value') + '" selected style="font-size: 11px;">' + j$(this).text() + '</option>'
													}
												  else
													{
													cadena+='<option value="' + j$(this).attr('value') + '" style="font-size: 11px;">' + j$(this).text() + '</option>'
													}
													
											});
											cadena+='</select>'
											cadena+='<button type="button" class="btn btn-primary boton_guardar_subestado"'
											cadena+=' data-toggle="popover_datatable"'
											cadena+=' data-placement="bottom"'
											cadena+=' data-trigger="hover"'
											cadena+=' data-content="Guardar Subestado"'
											cadena+=' data-original-title=""'
											cadena+=' style="display:none; margin-top:5px">'
											cadena+='<i class="far fa-save"></i>'
											cadena+='</button>'
											cadena+='<button type="button" class="btn btn-primary boton_cancelar_guardar_subestado"'
											cadena+=' data-toggle="popover_datatable"'
											cadena+=' data-placement="bottom"'
											cadena+=' data-trigger="hover"'
											cadena+=' data-content="Cancelar Cambio"'
											cadena+=' data-original-title=""'
											cadena+=' style="display:none; margin-left:3px; margin-top:5px">'
											cadena+='<i class="fas fa-window-close"></i>'
											cadena+='</button>'
											
											cadena_total=cadena
											}
										  else
										  	{
											cadena_total=row.SUBESTADO
											}
									}
								if (cadena_total==null)
									{
									cadena_total=''
									}
								return '<div id="capa_subestado_' + row.ID_PRESUPUESTO + '">' + cadena_total + '</div>'
					}}, 
				
				/*
				{
                    data: "PROXIMA_REVISION",
                    render: function (data, type, row) {
                        if (type === "sort" || type === "type") {
                            return data;
                        }
                        if ((data=='') || (data==null))
							{
							return '';
							}
						  else
						  	{
							return moment(data).format("DD/MM/YYYY");
							}
                    }
                },
				*/
				
				{ data: "PROXIMA_REVISION",
					render: function(data, type, row){
							cadena_total=''
							//console.log('estado: ' + row.ESTADO)
							//console.log('type: ' + type)
							switch(type) {
									case 'export':
										//console.log('ES UN EXPORT estado: ' + row.ESTADO)
										//cadena_total=row.SUBESTADO
										cadena_total=data
										break;
										
									case 'sort':
										//cadena_total=row.SUBESTADO
										cadena_total=data
										break;	
										
									case 'type':
										//cadena_total=row.SUBESTADO
										cadena_total=data
										break;		
										
									default:
											console.log('campo data: ' + data)
											console.log('campo PROXIMA_REVISION: ' + row.PROXIMA_REVISION)
											
											if ((data=='') || (data==null))
												{
												cadena_total=''
												}
											  else
												{
												//var d = new Date(row.PROXIMA_REVISION);
												//var campo_proxima_revision_formateado = d.getFullYear() + '-' + d.getMonth() + '-' + d.getDate()
												
												campo_proxima_revision_formateado=fecha_formateada(row.PROXIMA_REVISION)
												console.log('proxima_revision formateada: ' + campo_proxima_revision_formateado)
												//campo_proxima_revision_formateado=(year(campo_proxima_revision) & "-" & right("0" & month(campo_proxima_revision), 2) & "-" & right("0" & day(campo_proxima_revision), 2))
												cadena='<input type="date" class="form-control form-control-sm proxima_revision" id="txtfecha_proxima_revision_' + row.ID_PRESUPUESTO + '" value="' + campo_proxima_revision_formateado + '" fecha_anterior="' + campo_proxima_revision_formateado + '" style="font-size: 11px;"/>'
												//cadena='<select class="custom-select-sm form-control-sm form-control cmbsubestados_datatable" id="cmbsubestados_datatable_' + row.ID_PRESUPUESTO + '" estado_anterior="' + row.ID_SUBESTADO + '" style="font-size: 11px;">'
											
												cadena+='<button type="button" class="btn btn-primary boton_guardar_proxima_revision"'
												cadena+=' data-toggle="popover_datatable"'
												cadena+=' data-placement="bottom"'
												cadena+=' data-trigger="hover"'
												cadena+=' data-content="Guardar Pr&oacute;xima Revisi&oacute;n"'
												cadena+=' data-original-title=""'
												cadena+=' style="display:none; margin-top:5px">'
												cadena+='<i class="far fa-save"></i>'
												cadena+='</button>'
												cadena+='<button type="button" class="btn btn-primary boton_cancelar_guardar_proxima_revision"'
												cadena+=' data-toggle="popover_datatable"'
												cadena+=' data-placement="bottom"'
												cadena+=' data-trigger="hover"'
												cadena+=' data-content="Cancelar Cambio"'
												cadena+=' data-original-title=""'
												cadena+=' style="display:none; margin-left:3px; margin-top:5px">'
												cadena+='<i class="fas fa-window-close"></i>'
												cadena+='</button>'
												
												cadena_total=cadena
												}
									}
								if (cadena_total==null)
									{
									cadena_total=''
									}
								return '<div id="capa_proxima_revision_' + row.ID_PRESUPUESTO + '">' + cadena_total + '</div>'
					}}, 
				
				
				
                { data: "DESCRIPCION", visible: false },
                { data: "ID_ESTADO", visible: false },
				{ data: "ID_SUBESTADO", visible: false },
                { data: "ID_PRESUPUESTO", visible: false },
				{ data: "PRESUPUESTO", visible: false },
				{ data: "VERSION", visible: false },
				{ data: "OBSERVACIONES_GESTION", visible: false }
			],
			createdRow: function(row, data, dataIndex){
					if (data.PROXIMA_REVISION!=null)
						{
						console.log('fecha proxima revision: ' + data.PROXIMA_REVISION)
						console.log('fecha proxima revision formateada: ' + Date(data.PROXIMA_REVISION))
						console.log('fecha de hoy: ' + Date())
						var fecha_actual = new Date();
						var fecha_proxima = new Date(data.PROXIMA_REVISION);
						if (fecha_proxima<=fecha_actual)
							{
							j$(row).css('background-color', '#F5FC64');
							}
						}
			},
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
                exportOptions: {
                    columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                    format: {
                        body: function (data, row, column, node) {
                            switch (column) {
                                case 1:
									seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
									return seleccionado
                                    break;
									/*return lst_presupuesto
                                        .cell({ row: row, column: column })
                                        .nodes()
                                        .to$()
                                        .find(':selected')
                                        .text()
                                    break;
									*/
								case 4: //DESCRIPCION
									seleccionado = j$.parseHTML(data)
									mostrar=j$(seleccionado, '.eltexto').text()
									return mostrar																											
									break;
								case 8:
                                    seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
									return seleccionado
									break;
                                default:
                                    return data;
                            }
                        }
                    }
                }
            },
            {
                extend: "excelHtml5", text: '<i class="far fa-file-excel"></i>', titleAttr: "Exportar a Formato Excel", title: "Presupuestos", extension: ".xls"
                /*con esto aplicamos formatos especificos de escelHtml5 a las celdas
				, customize: function( xlsx ) {
						var sheet = xlsx.xl.worksheets['sheet1.xml'];
						//j$('row:first c', sheet).attr( 's', '42' );
						var thousandSepCols = ['H'];           
						for ( i=0; i < thousandSepCols.length; i++ ) {
							j$('row c[r^='+thousandSepCols[i]+']', sheet).attr( 's', '64' );
						}
						
					}
				*/
				,exportOptions: {
                    columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                    format: {
                        body: function (data, row, column, node) {
                            switch (column) {
                                case 1: //estado
                                    seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
									return seleccionado
									break;
								case 4: //DESCRIPCION
									seleccionado = j$.parseHTML(data)
									mostrar=j$(seleccionado, '.eltexto').text()
									return mostrar																											
									break;
								case 7: //numerico con 2 decimales
									data = j$('<p>' + data + '</p>').text();
                  					return j$.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
									break;								
								case 8: //subestado
                                    seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
									return seleccionado
									break;
                                default:
                                    return data;
                            }
                        }
                    }
                }
            },
            {
                extend: "pdf", text: '<i class="far fa-file-pdf"></i>', titleAttr: "Exportar a Formato PDF", title: "Presupuestos", orientation: "landscape",
                exportOptions: {
                    columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                    format: {
                        body: function (data, row, column, node) {
                            switch (column) {
                                case 1:
                                    seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
									return seleccionado
									break;
								case 4: //DESCRIPCION
									seleccionado = j$.parseHTML(data)
									mostrar=j$(seleccionado, '.eltexto').text()
									return mostrar																											
									break;
								case 8:
                                    seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
									return seleccionado
									break;
                                default:
                                    return data;
                            }
                        }
                    }
                }
            },
            {
                extend: "print", text: "<i class='fas fa-print'></i>", titleAttr: "Vista Preliminar", title: "Presupuestos",
                exportOptions: {
                    columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                    format: {
                        body: function (data, row, column, node) {
                            switch (column) {
                                case 1:
                                    seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
									return seleccionado
									break;
								case 4: //DESCRIPCION
									seleccionado = j$.parseHTML(data)
									mostrar=j$(seleccionado, '.eltexto').text()
									return mostrar																											
									break;
								case 8:
                                    seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
									return seleccionado
									break;
                                default:
                                    return data;
                            }
                        }
                    }
                }
            }
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
        j$("#lista_presupuestos").on("xhr.dt", function () {
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
        j$("#lista_presupuestos tbody").on("click", "tr", function () {
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

        //gestiona el dobleclick sobre la fila para mostrar la pantalla de detalle del presupuesto
        j$("#lista_presupuestos").on("dblclick", "tr", function (e) {
            var row = lst_presupuesto.row(j$(this).closest("tr")).data()
            parametro_presupuesto = row.ID_PRESUPUESTO;

            lst_presupuesto.$("tr.selected").css("background-color", '');;
            lst_presupuesto.$("tr.selected").removeClass("selected");

            j$(this).addClass('selected');
            j$(this).css('background-color', '#9FAFD1');


            mostrar_detalle_presupuesto(parametro_presupuesto)
        });

        j$('#lista_presupuestos').on('change', '.cmbestados_datatable', function () {
            //console.log('cambiando el valor a: ' + this.value);
            //j$(this).css('background-color', '#9FAFD1');
            //j$(this).parent().css({"color": "green", "border": "2px solid green"});
            var tbl_row = j$(this).closest('tr');
			
            var row = lst_presupuesto.row(tbl_row).data()
            parametro_id_presupuesto = row.ID_PRESUPUESTO
			
			//vacio la celda del subestado
			j$("#capa_subestado_" + parametro_id_presupuesto).empty()
			
			tbl_row.find('.boton_guardar_estado').show();
            tbl_row.find('.boton_cancelar_guardar_estado').show();
			
			//vaciamos la proxima revision
			j$("#capa_proxima_revision_" + parametro_id_presupuesto).empty()
			
			//si el estado es en estudio o rechazado, tengo que rellenar sus subestados
			if (j$(this).val()==5 || j$(this).val()==6)
				{
				cadena='<select class="custom-select-sm form-control-sm form-control cmbsubestados_datatable" id="cmbsubestados_datatable_' + parametro_id_presupuesto + '" estado_anterior="" style="font-size: 11px;">'
				combo_correcto=''
				if (j$(this).val()==5)
					{
					combo_correcto='estudio'
					}
				if (j$(this).val()==6)
					{
					combo_correcto='rechazado'
					}
				j$("#cmbsubestados_" + combo_correcto + "_plantilla option").each(function(){
					//console.log('desde el datatable:  opcion ' + j$(this).text()+' valor '+ j$(this).attr('value'))
					//console.log('id_estado: ' + row.ID_ESTADO + ' .. combo: ' + j$(this).attr('value'))
					cadena+='<option value="' + j$(this).attr('value') + '" style="font-size: 11px;">' + j$(this).text() + '</option>'
						
				});
				cadena+='</select>'
				cadena+='<button type="button" class="btn btn-primary boton_guardar_subestado"'
				cadena+=' data-toggle="popover_datatable"'
				cadena+=' data-placement="bottom"'
				cadena+=' data-trigger="hover"'
				cadena+=' data-content="Guardar Subestado"'
				cadena+=' data-original-title=""'
				cadena+=' style="display:none; margin-top:5px">'
				cadena+='<i class="far fa-save"></i>'
				cadena+='</button>'
				cadena+='<button type="button" class="btn btn-primary boton_cancelar_guardar_subestado"'
				cadena+=' data-toggle="popover_datatable"'
				cadena+=' data-placement="bottom"'
				cadena+=' data-trigger="hover"'
				cadena+=' data-content="Cancelar Cambio"'
				cadena+=' data-original-title=""'
				cadena+=' style="display:none; margin-left:3px; margin-top:5px">'
				cadena+='<i class="fas fa-window-close"></i>'
				cadena+='</button>'
				
				j$("#capa_subestado_" + parametro_id_presupuesto).html(cadena)
				
				//si es en estudio, hay que poner la proxima revision
				if (j$(this).val()==5)
					{
					cadena='<input type="date" class="form-control form-control-sm proxima_revision" id="txtfecha_proxima_revision_' + parametro_id_presupuesto + '" value="" fecha_anterior="" style="font-size: 11px;"/>'
			
					cadena+='<button type="button" class="btn btn-primary boton_guardar_proxima_revision"'
					cadena+=' data-toggle="popover_datatable"'
					cadena+=' data-placement="bottom"'
					cadena+=' data-trigger="hover"'
					cadena+=' data-content="Guardar Pr&oacute;xima Revisi&oacute;n"'
					cadena+=' data-original-title=""'
					cadena+=' style="display:none; margin-top:5px">'
					cadena+='<i class="far fa-save"></i>'
					cadena+='</button>'
					cadena+='<button type="button" class="btn btn-primary boton_cancelar_guardar_proxima_revision"'
					cadena+=' data-toggle="popover_datatable"'
					cadena+=' data-placement="bottom"'
					cadena+=' data-trigger="hover"'
					cadena+=' data-content="Cancelar Cambio"'
					cadena+=' data-original-title=""'
					cadena+=' style="display:none; margin-left:3px; margin-top:5px">'
					cadena+='<i class="fas fa-window-close"></i>'
					cadena+='</button>'
					j$("#capa_proxima_revision_" + parametro_id_presupuesto).html(cadena)
					}
				
				}				
            //j$(this).closest("boton_guardar_estado").show()

        });

        j$('#lista_presupuestos').on('click', '.boton_guardar_estado', function () {
            //console.log('cambiando el valor a: ' + this.value);
            //j$(this).css('background-color', '#9FAFD1');
            //j$(this).parent().css({"color": "green", "border": "2px solid green"});

            var tbl_row = j$(this).closest('tr');
            var row = lst_presupuesto.row(tbl_row).data()
            parametro_id_estado_nuevo = tbl_row.find('.cmbestados_datatable').val()
            parametro_id_estado_antiguo = row.ID_ESTADO
			parametro_id_subestado_nuevo = ''
			if (parametro_id_estado_nuevo==5 || parametro_id_estado_nuevo==6)
				{
				parametro_id_subestado_nuevo = tbl_row.find('.cmbsubestados_datatable').val()
				}
			parametro_id_subestado_antiguo = row.ID_SUBESTADO
			parametro_id_presupuesto = row.ID_PRESUPUESTO
			parametro_presupuesto=row.PRESUPUESTO
			parametro_proxima_revision_antiguo=row.PROXIMA_REVISION
			parametro_proxima_revision_nuevo=''
			//si es en estudio hay que recoger la proxima revision
			if (parametro_id_estado_nuevo==5)
				{
				parametro_proxima_revision_nuevo = tbl_row.find('.proxima_revision').val()
				}

			guardamos='SI'
			
            console.log('LOS VALORES A GUARDAR SON: PRESUPUESTO.... ' + parametro_id_presupuesto + ' ... ESTADO... ' + parametro_id_estado_nuevo)

            controles_visibles = 0
            j$('.boton_guardar_estado').each(function (index, value) {
                //console.log('div' + index + ':' + $(this).attr('id'));
                if (j$(this).is(":visible")) {
                    controles_visibles++
                }
            });

            if (controles_visibles > 1) {
				guardamos='NO'
                bootbox.alert({
                    //size: 'large',
                    message: '<h5>Hay un Cambio Pendiente de Guardar o Cancelar</h5>'
                    //callback: function () {return false;}
                })
            }
            else {
				console.log('valor del estado origen: ' + row.ID_ESTADO)
				cadena_mensaje=''
				if (parametro_id_estado_nuevo=='5' || parametro_id_estado_nuevo=='6') // SI ES EN EN ESTUDIO O RECHAZADO HAY QUE PONER EL SUBESTADO
					{
  					console.log('es estado 5 o 6')
					console.log('combo j$("#cmbsubestados_datatable_' + parametro_id_presupuesto + ')')
					console.log('valor del combo: ' + j$("#cmbsubestados_datatable_" + parametro_id_presupuesto).val())
					
					if (j$("#cmbsubestados_datatable_" + parametro_id_presupuesto).val()=='')
						{
						console.log('el combo esta vacio')
						guardamos='NO'
						cadena_mensaje+='- Se ha de Seleccionar un Subestado.<br>'
						}
						

					} //fin del if del parametro_id_estado_nuevo
					
				if (parametro_id_estado_nuevo=='5') // SI ES EN EN ESTUDIO HAY QUE PONER LA PROXIMA REVISION
					{
					if (j$("#txtfecha_proxima_revision_" + parametro_id_presupuesto).val()=='')
						{
						console.log('LA PROXIMA REVISION ESTA VACIA')
						guardamos='NO'
						cadena_mensaje+='- Se ha de Seleccionar La Fecha de la Pr&oacute;xima Revisi&oacute;n.<br>'
						}
						

					} //fin del if del parametro_id_estado_nuevo
					
					
			
			
			  if (guardamos=='SI')
				{
				console.log('antes de llamar al ajax... con los siguientes parametros')
				console.log('id_estado_antiguo: ' + parametro_id_estado_antiguo)
				console.log('id_estado_nuevo: ' + parametro_id_estado_nuevo)
				console.log('id_subestado_antiguo: ' + parametro_id_subestado_antiguo)
				console.log('id_subestado_nuevo: ' + parametro_id_subestado_nuevo)
				console.log('id_presupuesto: ' + parametro_id_presupuesto)
				console.log('presupuesto: ' + parametro_presupuesto)
				console.log('proxima_revision_antiguo: ' + parametro_proxima_revision_antiguo)
				console.log('proxima_revision_nuevo: ' + parametro_proxima_revision_nuevo)
				j$.ajax({
					type: 'POST',
					url: 'Modificar_Estado_Presupuesto_Desde_Datatable.asp',
					data: {
						id_estado_antiguo: parametro_id_estado_antiguo,
						id_estado_nuevo: parametro_id_estado_nuevo,
						id_subestado_antiguo: parametro_id_subestado_antiguo,
						id_subestado_nuevo: parametro_id_subestado_nuevo,
						id_presupuesto: parametro_id_presupuesto,
						presupuesto: parametro_presupuesto,
						proxima_revision_antiguo: parametro_proxima_revision_antiguo,
						proxima_revision_nuevo: parametro_proxima_revision_nuevo
						
					},
					success:
						function (data) {
							//console.log('lo devuelto por data: ' + data)
							switch (data) {
								case '1':  //se encuentra dado de alta en la gestion de maletas  
									cadena = 'Estado Modificado Correctamente.';
									row.ID_ESTADO = parametro_id_estado_nuevo;
									tbl_row.find('.cmbestados_datatable').attr('estado_anterior', row.ID_ESTADO);
									////////////////////poner subestado y proxima revion anteriores....
									tbl_row.find('.boton_guardar_estado').hide();
									tbl_row.find('.boton_cancelar_guardar_estado').hide();
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
					})//fin del ajax
					
				tbl_row.find('.boton_guardar_estado').hide();
				tbl_row.find('.boton_cancelar_guardar_estado').hide();
			
				//para que se vean los cambios
				lst_presupuesto.ajax.reload()
				
				
				} // fin del if guardamos
			  else
			  	{
				
				 bootbox.alert({
								//size: 'large',
								message: '<h5>' + cadena_mensaje + '</h5>'
								//callback: function () {return false;}
							})

				} // fin del if guardamos
						
			} //fin del if controles_visibles
						

			/* ya no hace falta, se ha puesto en otro if mas arriba
			if (guardamos=='SI')
				{
				tbl_row.find('.boton_guardar_estado').hide();
				tbl_row.find('.boton_cancelar_guardar_estado').hide();
			
				//para que se vean los cambios
				lst_presupuesto.ajax.reload()
				}
			*/
			
            //j$(this).closest("boton_guardar_estado").show()

        });

        j$('#lista_presupuestos').on('click', '.boton_cancelar_guardar_estado', function () {
            //console.log('cambiando el valor a: ' + this.value);
            //j$(this).css('background-color', '#9FAFD1');
            //j$(this).parent().css({"color": "green", "border": "2px solid green"});

            var tbl_row = j$(this).closest('tr');
			
			
            var row = lst_presupuesto.row(tbl_row).data()
            
			
			valor_id_presupuesto = row.ID_PRESUPUESTO
			valor_id_estado_anterior=row.ID_ESTADO
			valor_id_subestado_anterior=row.ID_SUBESTADO
			valor_proxima_revision_anterior=row.PROXIMA_REVISION
			valor_proxima_revision_anterior_f=fecha_formateada(row.PROXIMA_REVISION)
			
			console.log('cancelamos el presupuesto: ' + valor_id_presupuesto + ' con estado anterior: ' + valor_id_estado_anterior +' y subestado anterior: ' + valor_id_subestado_anterior +' y Proxima revision anterior: ' + valor_proxima_revision_anterior_f)
			
			
            console.log('estado actual del combo: ' + tbl_row.find('.cmbestados_datatable').val())
            console.log('estado anterior del combo: ' + tbl_row.find('.cmbestados_datatable').attr('estado_anterior'))

            tbl_row.find('.cmbestados_datatable').val(tbl_row.find('.cmbestados_datatable').attr('estado_anterior'));
			
			//vacio la celda del subestado y la del proximo contacto
			j$("#capa_subestado_" + valor_id_presupuesto).empty()
			j$("#capa_proxima_revision_" + valor_id_presupuesto).empty()
			
			//si el estado es en estudio o rechazado, tengo que rellenar sus subestados
			if (valor_id_estado_anterior==5 || valor_id_estado_anterior==6)
				{
				console.log('el antiguo estado es 5 o 6')
				cadena='<select class="custom-select-sm form-control-sm form-control cmbsubestados_datatable" id="cmbsubestados_datatable_' + valor_id_presupuesto + '" estado_anterior="" style="font-size: 11px;">'
				combo_correcto=''
				if (valor_id_estado_anterior==5)
					{
					combo_correcto='estudio'
					}
				if (valor_id_estado_anterior==6)
					{
					combo_correcto='rechazado'
					}
					
				console.log('combo correcto: ' + combo_correcto)
				j$("#cmbsubestados_" + combo_correcto + "_plantilla option").each(function(){
					//console.log('desde el datatable:  opcion ' + j$(this).text()+' valor '+ j$(this).attr('value'))
					//console.log('id_estado: ' + row.ID_ESTADO + ' .. combo: ' + j$(this).attr('value'))
					cadena+='<option value="' + j$(this).attr('value') + '" style="font-size: 11px;">' + j$(this).text() + '</option>'
					console.log('volcamos los valores de combo plantilla')	
				});
				cadena+='</select>'
				cadena+='<button type="button" class="btn btn-primary boton_guardar_subestado"'
				cadena+=' data-toggle="popover_datatable"'
				cadena+=' data-placement="bottom"'
				cadena+=' data-trigger="hover"'
				cadena+=' data-content="Guardar Subestado"'
				cadena+=' data-original-title=""'
				cadena+=' style="display:none; margin-top:5px">'
				cadena+='<i class="far fa-save"></i>'
				cadena+='</button>'
				cadena+='<button type="button" class="btn btn-primary boton_cancelar_guardar_subestado"'
				cadena+=' data-toggle="popover_datatable"'
				cadena+=' data-placement="bottom"'
				cadena+=' data-trigger="hover"'
				cadena+=' data-content="Cancelar Cambio"'
				cadena+=' data-original-title=""'
				cadena+=' style="display:none; margin-left:3px; margin-top:5px">'
				cadena+='<i class="fas fa-window-close"></i>'
				cadena+='</button>'
				
				console.log('')
				console.log('cadena que se va a añadir al div: ' + cadena)
				j$("#capa_subestado_" + valor_id_presupuesto).html(cadena)
				
				if (valor_id_subestado_anterior!='')
					{
					console.log('cofiguramos el valor del combo subestado')
					j$("#cmbsubestados_datatable_" + valor_id_presupuesto).val(valor_id_subestado_anterior)
					}
				
				//tambien tenemos que dejar la proxima revision como estaba
				console.log('repontamos el date')
				if (valor_proxima_revision_anterior!='')
					{
					console.log('el date va con el valor de fecha: ' + valor_proxima_revision_anterior_f)
					cadena='<input type="date" class="form-control form-control-sm proxima_revision" id="txtfecha_proxima_revision_' + valor_id_presupuesto + '" value="' + valor_proxima_revision_anterior_f + '" fecha_anterior="' + valor_proxima_revision_anterior_f + '" style="font-size: 11px;"/>'
			
					cadena+='<button type="button" class="btn btn-primary boton_guardar_proxima_revision"'
					cadena+=' data-toggle="popover_datatable"'
					cadena+=' data-placement="bottom"'
					cadena+=' data-trigger="hover"'
					cadena+=' data-content="Guardar Pr&oacute;xima Revisi&oacute;n"'
					cadena+=' data-original-title=""'
					cadena+=' style="display:none; margin-top:5px">'
					cadena+='<i class="far fa-save"></i>'
					cadena+='</button>'
					cadena+='<button type="button" class="btn btn-primary boton_cancelar_guardar_proxima_revision"'
					cadena+=' data-toggle="popover_datatable"'
					cadena+=' data-placement="bottom"'
					cadena+=' data-trigger="hover"'
					cadena+=' data-content="Cancelar Cambio"'
					cadena+=' data-original-title=""'
					cadena+=' style="display:none; margin-left:3px; margin-top:5px">'
					cadena+='<i class="fas fa-window-close"></i>'
					cadena+='</button>'
					}
				  else
				  	{
					cadena=''
					}
				
				j$("#capa_proxima_revision_" + valor_id_presupuesto).html(cadena)					
				
				
				}				

            tbl_row.find('.boton_guardar_estado').hide();
            tbl_row.find('.boton_cancelar_guardar_estado').hide();

        });
		
		
		j$('#lista_presupuestos').on('change', '.cmbsubestados_datatable', function () {
			var tbl_row = j$(this).closest('tr');
			
			
			tbl_row.find('.boton_guardar_subestado').show();
            tbl_row.find('.boton_cancelar_guardar_subestado').show();
            //j$(this).closest("boton_guardar_estado").show()

        });

		j$('#lista_presupuestos').on('click', '.boton_guardar_subestado', function () {
            //console.log('cambiando el valor a: ' + this.value);
            //j$(this).css('background-color', '#9FAFD1');
            //j$(this).parent().css({"color": "green", "border": "2px solid green"});

            var tbl_row = j$(this).closest('tr');
            var row = lst_presupuesto.row(tbl_row).data()
            parametro_id_estado_nuevo = tbl_row.find('.cmbestados_datatable').val()
            parametro_id_estado_antiguo = row.ID_ESTADO
			parametro_id_subestado_nuevo = tbl_row.find('.cmbsubestados_datatable').val()
            parametro_id_subestado_antiguo = row.ID_SUBESTADO
			parametro_id_presupuesto = row.ID_PRESUPUESTO
			parametro_presupuesto=row.PRESUPUESTO
			parametro_proxima_revision_antiguo=row.PROXIMA_REVISION
			parametro_proxima_revision_nuevo=''
			//si es en estudio hay que recoger la proxima revision
			if (parametro_id_estado_nuevo==5)
				{
				parametro_proxima_revision_nuevo = tbl_row.find('.proxima_revision').val()
				}


			guardamos='SI'
			
            console.log('LOS VALORES A GUARDAR SON: PRESUPUESTO.... ' + parametro_id_presupuesto + ' ... subESTADO... ' + parametro_id_subestado_nuevo)

            controles_visibles = 0
            j$('.boton_guardar_subestado').each(function (index, value) {
                //console.log('div' + index + ':' + $(this).attr('id'));
                if (j$(this).is(":visible")) {
                    controles_visibles++
                }
            });

			/////////////aqui tambien hay que cotroloar si hay botones de estados visibles de diferente presupueseto
			
			
            if (controles_visibles > 1) {
				guardamos='NO'
                bootbox.alert({
                    //size: 'large',
                    message: '<h5>Hay un Cambio Pendiente de Guardar o Cancelar</h5>'
                    //callback: function () {return false;}
                })
            }
            else {
				console.log('valor del estado origen: ' + row.ID_ESTADO)
				cadena_mensaje=''
				if (parametro_id_estado_nuevo=='5' || parametro_id_estado_nuevo=='6') // SI ES EN EN ESTUDIO O RECHAZADO HAY QUE PONER EL SUBESTADO
					{
  					console.log('es estado 5 o 6')
					console.log('combo j$("#cmbsubestados_datatable_' + parametro_id_presupuesto + ')')
					console.log('valor del combo: ' + j$("#cmbsubestados_datatable_" + parametro_id_presupuesto).val())
					
					if (j$("#cmbsubestados_datatable_" + parametro_id_presupuesto).val()=='')
						{
						console.log('el combo esta vacio')
						guardamos='NO'
						cadena_mensaje+='- Se ha de Seleccionar un Subestado.<br>'
						}
						

					} //fin del if del parametro_id_estado_nuevo
					
				if (parametro_id_estado_nuevo=='5') // SI ES EN EN ESTUDIO HAY QUE PONER LA PROXIMA REVISION
					{
					if (j$("#txtfecha_proxima_revision_" + parametro_id_presupuesto).val()=='')
						{
						console.log('LA PROXIMA REVISION ESTA VACIA')
						guardamos='NO'
						cadena_mensaje+='- Se ha de Seleccionar La Fecha de la Pr&oacute;xima Revisi&oacute;n.<br>'
						}
						

					} //fin del if del parametro_id_estado_nuevo
					
					
			
			
			  if (guardamos=='SI')
				{
				console.log('antes de llamar al ajax... con los siguientes parametros')
				console.log('id_estado_antiguo: ' + parametro_id_estado_antiguo)
				console.log('id_estado_nuevo: ' + parametro_id_estado_nuevo)
				console.log('id_subestado_antiguo: ' + parametro_id_subestado_antiguo)
				console.log('id_subestado_nuevo: ' + parametro_id_subestado_nuevo)
				console.log('id_presupuesto: ' + parametro_id_presupuesto)
				console.log('presupuesto: ' + parametro_presupuesto)
				console.log('proxima_revision_antiguo: ' + parametro_proxima_revision_antiguo)
				console.log('proxima_revision_nuevo: ' + parametro_proxima_revision_nuevo)
				j$.ajax({
					type: 'POST',
					url: 'Modificar_Estado_Presupuesto_Desde_Datatable.asp',
					data: {
						id_estado_antiguo: parametro_id_estado_antiguo,
						id_estado_nuevo: parametro_id_estado_nuevo,
						id_subestado_antiguo: parametro_id_subestado_antiguo,
						id_subestado_nuevo: parametro_id_subestado_nuevo,
						id_presupuesto: parametro_id_presupuesto,
						presupuesto: parametro_presupuesto,
						proxima_revision_antiguo: parametro_proxima_revision_antiguo,
						proxima_revision_nuevo: parametro_proxima_revision_nuevo
						
					},
					success:
						function (data) {
							//console.log('lo devuelto por data: ' + data)
							switch (data) {
								case '1':  //se encuentra dado de alta en la gestion de maletas  
									cadena = 'Estado Modificado Correctamente.';
									row.ID_SUBESTADO = parametro_id_subestado_nuevo;
									tbl_row.find('.cmbsubestados_datatable').attr('estado_anterior', row.ID_SUBESTADO);
									row.PROXIMA_REVISION = parametro_proxima_revision_nuevo;
									tbl_row.find('.proxima_revision').attr('fecha_anterior', row.PROXIMA_REVISION);
									////////////////////poner subestado y proxima revion anteriores....
									tbl_row.find('.boton_guardar_estado').hide();
									tbl_row.find('.boton_cancelar_guardar_estado').hide();
									tbl_row.find('.boton_guardar_subestado').hide();
									tbl_row.find('.boton_cancelar_guardar_subestado').hide();
									tbl_row.find('.boton_guardar_proxima_revision').hide();
									tbl_row.find('.boton_cancelar_guardar_proxima_revision').hide();
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
					})//fin del ajax
					
				//tbl_row.find('.boton_guardar_estado').hide();
				//tbl_row.find('.boton_cancelar_guardar_estado').hide();
			
				//para que se vean los cambios
				lst_presupuesto.ajax.reload()
				
				
				} // fin del if guardamos
			  else
			  	{
				
				 bootbox.alert({
								//size: 'large',
								message: '<h5>' + cadena_mensaje + '</h5>'
								//callback: function () {return false;}
							})

				} // fin del if guardamos
						
			} //fin del if controles_visibles
						

        });

		
		j$('#lista_presupuestos').on('click', '.boton_cancelar_guardar_subestado', function () {
            //console.log('cambiando el valor a: ' + this.value);
            //j$(this).css('background-color', '#9FAFD1');
            //j$(this).parent().css({"color": "green", "border": "2px solid green"});

            var tbl_row = j$(this).closest('tr');
            console.log('estado actual del combo: ' + tbl_row.find('.cmbsubestados_datatable').val())
            console.log('estado anterior del combo: ' + tbl_row.find('.cmbsubestados_datatable').attr('estado_anterior'))

            tbl_row.find('.cmbsubestados_datatable').val(tbl_row.find('.cmbsubestados_datatable').attr('estado_anterior'));

            tbl_row.find('.boton_guardar_subestado').hide();
            tbl_row.find('.boton_cancelar_guardar_subestado').hide();

        });
		
		
		j$('#lista_presupuestos').on('change', '.proxima_revision', function () {
			var tbl_row = j$(this).closest('tr');
			
			
			tbl_row.find('.boton_guardar_proxima_revision').show();
            tbl_row.find('.boton_cancelar_guardar_proxima_revision').show();
            //j$(this).closest("boton_guardar_estado").show()

        });
		
		
		j$('#lista_presupuestos').on('click', '.boton_guardar_proxima_revision', function () {
			
			
			var tbl_row = j$(this).closest('tr');
            var row = lst_presupuesto.row(tbl_row).data()
            parametro_id_estado_nuevo = tbl_row.find('.cmbestados_datatable').val()
            parametro_id_estado_antiguo = row.ID_ESTADO
			parametro_id_subestado_nuevo = ''
			if (parametro_id_estado_nuevo==5 || parametro_id_estado_nuevo==6)
				{
				parametro_id_subestado_nuevo = tbl_row.find('.cmbsubestados_datatable').val()
				}
			parametro_id_subestado_antiguo = row.ID_SUBESTADO
			parametro_id_presupuesto = row.ID_PRESUPUESTO
			parametro_presupuesto=row.PRESUPUESTO
			parametro_proxima_revision_antiguo=row.PROXIMA_REVISION
			parametro_proxima_revision_nuevo=''
			//si es en estudio hay que recoger la proxima revision
			if (parametro_id_estado_nuevo==5)
				{
				parametro_proxima_revision_nuevo = tbl_row.find('.proxima_revision').val()
				}

			guardamos='SI'
			
			
			console.log('LOS VALORES A GUARDAR SON: PRESUPUESTO.... ' + parametro_id_presupuesto + ' ... ESTADO... ' + parametro_id_estado_nuevo)

            controles_visibles = 0
            j$('.boton_guardar_proxima_revision').each(function (index, value) {
                //console.log('div' + index + ':' + $(this).attr('id'));
                if (j$(this).is(":visible")) {
                    controles_visibles++
                }
            });

            if (controles_visibles > 1) {
				guardamos='NO'
                bootbox.alert({
                    //size: 'large',
                    message: '<h5>Hay un Cambio Pendiente de Guardar o Cancelar</h5>'
                    //callback: function () {return false;}
                })
            }
            else {
				console.log('valor del estado origen: ' + row.ID_ESTADO)
				cadena_mensaje=''
				if (parametro_id_estado_nuevo=='5' || parametro_id_estado_nuevo=='6') // SI ES EN EN ESTUDIO O RECHAZADO HAY QUE PONER EL SUBESTADO
					{
  					console.log('es estado 5 o 6')
					console.log('combo j$("#cmbsubestados_datatable_' + parametro_id_presupuesto + ')')
					console.log('valor del combo: ' + j$("#cmbsubestados_datatable_" + parametro_id_presupuesto).val())
					
					if (j$("#cmbsubestados_datatable_" + parametro_id_presupuesto).val()=='')
						{
						console.log('el combo esta vacio')
						guardamos='NO'
						cadena_mensaje+='- Se ha de Seleccionar un Subestado.<br>'
						}
						

					} //fin del if del parametro_id_estado_nuevo
					
				if (parametro_id_estado_nuevo=='5') // SI ES EN EN ESTUDIO HAY QUE PONER LA PROXIMA REVISION
					{
					if (j$("#txtfecha_proxima_revision_" + parametro_id_presupuesto).val()=='')
						{
						console.log('LA PROXIMA REVISION ESTA VACIA')
						guardamos='NO'
						cadena_mensaje+='- Se ha de Seleccionar La Fecha de la Pr&oacute;xima Revisi&oacute;n.<br>'
						}
						

					} //fin del if del parametro_id_estado_nuevo
					
					
			
			
			  if (guardamos=='SI')
				{
				console.log('antes de llamar al ajax... con los siguientes parametros')
				console.log('id_estado_antiguo: ' + parametro_id_estado_antiguo)
				console.log('id_estado_nuevo: ' + parametro_id_estado_nuevo)
				console.log('id_subestado_antiguo: ' + parametro_id_subestado_antiguo)
				console.log('id_subestado_nuevo: ' + parametro_id_subestado_nuevo)
				console.log('id_presupuesto: ' + parametro_id_presupuesto)
				console.log('presupuesto: ' + parametro_presupuesto)
				console.log('proxima_revision_antiguo: ' + parametro_proxima_revision_antiguo)
				console.log('proxima_revision_nuevo: ' + parametro_proxima_revision_nuevo)
				j$.ajax({
					type: 'POST',
					url: 'Modificar_Estado_Presupuesto_Desde_Datatable.asp',
					data: {
						id_estado_antiguo: parametro_id_estado_antiguo,
						id_estado_nuevo: parametro_id_estado_nuevo,
						id_subestado_antiguo: parametro_id_subestado_antiguo,
						id_subestado_nuevo: parametro_id_subestado_nuevo,
						id_presupuesto: parametro_id_presupuesto,
						presupuesto: parametro_presupuesto,
						proxima_revision_antiguo: parametro_proxima_revision_antiguo,
						proxima_revision_nuevo: parametro_proxima_revision_nuevo
						
					},
					success:
						function (data) {
							//console.log('lo devuelto por data: ' + data)
							switch (data) {
								case '1':  //se encuentra dado de alta en la gestion de maletas  
									cadena = 'Estado Modificado Correctamente.';
									row.ID_SUBESTADO = parametro_id_subestado_nuevo;
									tbl_row.find('.cmbsubestados_datatable').attr('estado_anterior', row.ID_SUBESTADO);
									row.PROXIMA_REVISION = parametro_proxima_revision_nuevo;
									tbl_row.find('.proxima_revision').attr('fecha_anterior', row.PROXIMA_REVISION);
									////////////////////poner subestado y proxima revion anteriores....
									tbl_row.find('.boton_guardar_estado').hide();
									tbl_row.find('.boton_cancelar_guardar_estado').hide();
									tbl_row.find('.boton_guardar_subestado').hide();
									tbl_row.find('.boton_cancelar_guardar_subestado').hide();
									tbl_row.find('.boton_guardar_proxima_revision').hide();
									tbl_row.find('.boton_cancelar_guardar_proxima_revision').hide();
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
					})//fin del ajax
					
				//tbl_row.find('.boton_guardar_estado').hide();
				//tbl_row.find('.boton_cancelar_guardar_estado').hide();
			
				//para que se vean los cambios
				lst_presupuesto.ajax.reload()
				
				
				} // fin del if guardamos
			  else
			  	{
				
				 bootbox.alert({
								//size: 'large',
								message: '<h5>' + cadena_mensaje + '</h5>'
								//callback: function () {return false;}
							})

				} // fin del if guardamos
						
			} //fin del if controles_visibles
						

			/* ya no hace falta, se ha puesto en otro if mas arriba
			if (guardamos=='SI')
				{
				tbl_row.find('.boton_guardar_estado').hide();
				tbl_row.find('.boton_cancelar_guardar_estado').hide();
			
				//para que se vean los cambios
				lst_presupuesto.ajax.reload()
				}
			*/
			
            //j$(this).closest("boton_guardar_estado").show()
			
			
			
		});
		
		
		j$('#lista_presupuestos').on('click', '.boton_cancelar_guardar_proxima_revision', function () {
            //console.log('cambiando el valor a: ' + this.value);
            //j$(this).css('background-color', '#9FAFD1');
            //j$(this).parent().css({"color": "green", "border": "2px solid green"});

            var tbl_row = j$(this).closest('tr');
            console.log('estado actual del proxima revision: ' + tbl_row.find('.proxima_revision').val())
            console.log('estado anterior del proxima revision: ' + tbl_row.find('.proxima_revision').attr('fecha_anterior'))

            tbl_row.find('.proxima_revision').val(tbl_row.find('.proxima_revision').attr('fecha_anterior'));

            tbl_row.find('.boton_guardar_proxima_revision').hide();
            tbl_row.find('.boton_cancelar_guardar_proxima_revision').hide();

        });

        /*
        j$('#lista_presupuestos').on('click', '.cmbestados_datatable', function() {
          console.log('cambiando el valor a: ' + this.value);
        });
        */
    }
    else {
        //stf.lst_tra.clear().draw();
        lst_presupuesto.ajax.url("tojson/obtener_presupuestos.asp?" + prm.toString());
        lst_presupuesto.ajax.reload();
    }

    lst_presupuesto.on('buttons-action', function (e, buttonApi, dataTable, node, config) {
        //console.log( 'Button '+ buttonApi.text()+' was activated' );

    });
};

function cambiacomaapunto(s) {
    var saux = "";
    for (j = 0; j < s.length; j++) {
        if (s.charAt(j) == ",")
            saux = saux + ".";
        else
            saux = saux + s.charAt(j);
    }
    return saux;
}

// una vez calculado el resultado tenemos que volver a dejarlo como es devido, con la coma
//    representando los decimales y no el punto
function cambiapuntoacoma(s) {
    var saux = "";
    //alert("pongo coma")
    //alert("tama�o: " + s.legth)
    for (j = 0; j < s.length; j++) {
        if (s.charAt(j) == ".")
            saux = saux + ",";
        else
            saux = saux + s.charAt(j);
        //alert("total: " + saux)
    }
    return saux;
}

// ademas redondeamos a 2 decimales el resultado
function redondear(v) {
    var vaux;
    vaux = Math.round(v * 100);
    vaux = vaux / 100;
    return vaux;
}

mostrar_detalle_presupuesto = function (parametro_presupuesto) {
    //alert('entro dentro de mostrar_capa_movilidad')
    //cargaSelectsNew("p_combo=EMPORG", "gmv.lov_usr_codemp", "S");  
    url_iframe = 'Detalle_Presupuesto.asp?id=' + parametro_presupuesto

    cadena_cabecera = 'Detalle Presupuesto #' + parametro_presupuesto

    j$("#cabecera_iframe").html(cadena_cabecera);
    j$('#iframe_detalle_presupuesto').attr('src', url_iframe)
    j$("#capa_detalle_presupuesto").modal("show");
}

j$('#capa_detalle_presupuesto').on('show.bs.modal', function () {
    //j$('#capa_detalle_presupuesto .modal-body').css('overflow-y', 'auto'); 
    j$('#capa_detalle_presupuesto .modal-body').css('height', j$(window).height() * 0.85);
    j$('#capa_detalle_presupuesto .modal-body').css('max-height', j$(window).height() * 0.85);
    //console.log(j$('#capa_detalle_presupuesto .modal-body').height())
});

j$('#capa_detalle_presupuesto').on('hide.bs.modal', function (e) {
    // recargo el datatable por si ha habido modificacion desde graphisoft y que se refresque
    lst_presupuesto.ajax.reload()
})

fecha_formateada = function (fecha) {
	var d = new Date(fecha);
	mes= '0' + (d.getMonth()+1)
	mes= mes.slice(-2)
	dia= '0' + d.getDate()
	dia= dia.slice(-2)
	var f_formateada = d.getFullYear() + '-' + mes + '-' + dia
	return f_formateada														
}

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

    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="css/style_menu_hamburguesa5.css">
	<script type="text/javascript" src="plugins/fontawesome-5.7.1/js/all.js" defer></script>
	<style>
		/* si pongo esto dentro de un fichero css para que se cargue, no se porque pero no funciona, asique lo pongo aqui */
		#capa_detalle_presupuesto .modal-dialog  {width:95% !important; max-width: 1350px !important;}
		#pantalla_avisos_actualizar_graphisoft .modal-dialog  {width:80% !important; max-width: 1350px !important;}
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