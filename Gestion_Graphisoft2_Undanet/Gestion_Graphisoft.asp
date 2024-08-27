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
		
	'response.write("procedencia: " & request.servervariables("http_referer"))
	hoja_ruta_seleccionada      = Request.Form("txthoja_ruta")
	estado_seleccionado         = Request.Form("cmbestados")
	cliente_seleccionado        = Request.Form("txtcliente")
	referencia_seleccionada     = Request.Form("txtreferencia")
	subcontratista_seleccionada = Request.Form("txtsubcontratista")
	fecha_entrega_seleccionada  = Request.Form("txtfecha_entrega")
	ejecutar_consulta           = Request.Form("ocultoejecutar")
		
	'response.write("<br>origen : " & Request.ServerVariables("HTTP_REFERER"))
	'response.write("<br>encontrado: " & instr(ucase(Request.ServerVariables("HTTP_REFERER")), "CONSULTA_ARTICULOS_ADMIN"))

	'si venimos de otra pagina que no sea la propia consulta de articulos que aparezca por defecto 
	' en eliminado la opcion de no
	If Instr(Ucase(Request.ServerVariables("HTTP_REFERER")), "CONSULTA_ARTICULOS_ADMIN") = 0 Then
		campo_eliminado = "NO"
	End If
		
    sql = "SELECT * FROM GESTION_GRAPHISOFT_ESTADOS ORDER BY GRUPO, ORDEN"
    vacio_estados = false
    
    Set estados = execute_sql(conn_gag, sql)
    If Not estados.BOF Then
        mitabla_estados = estados.GetRows()
	Else
		vacio_estados = true
    End If

    close_connection(estados)

    cadena_select_estados=""
	For i=0 to UBound(mitabla_estados,2)
		If mitabla_estados(CAMPO_ID_ESTADO,i)<>12 Then 'no se puede pasar al estado CANCELADO, ese estado solo se pone desde graphisoft
			cadena_select_estados=cadena_select_estados & "<option value=""" & mitabla_estados(CAMPO_ID_ESTADO,i) & """>" & mitabla_estados(CAMPO_DESCRIPCION_ESTADO,i) & "</option>"
		 Else
		 	cadena_select_estados=cadena_select_estados & "<option value=""" & mitabla_estados(CAMPO_ID_ESTADO,i) & """ disabled>" & mitabla_estados(CAMPO_DESCRIPCION_ESTADO,i) & "</option>"
		End If
	next
%>
<html lang="es">
<head>
	<!--<meta charset="utf-8">-->
	
</head>
<body>
<input type="hidden" id="ocultousuario" name="ocultousuario" value="<%=Session("usuario")%>" />
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
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txthoja_ruta" class="control-label">Hoja de Ruta</label>
								<input type="text" class="form-control" name="txthoja_ruta" id="txthoja_ruta" value="<%=hoja_ruta_seleccionada%>"/>
							</div>
							<div class="col-sm-4 col-md-4 col-lg-4">
								<label for="txtsubcontratista" class="control-label">Subcontratista</label>
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input class="js-typeahead-subcontratista form-control" name="txtsubcontratista" id="txtsubcontratista" type="search" placeholder="Buscar Subcontratista" autocomplete="off" value="<%=subcontratista_seleccionado%>">
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
								
							</div>
						</div>
						<div class="form-group row mx-2">
							<div class="col-sm-4 col-md-4 col-lg-4">
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
							<div class="col-sm-3 col-md-4 col-lg-4">
								<label for="txtreferencia" class="control-label">Referencia</label>
								<input type="text" class="form-control" name="txtreferencia" id="txtreferencia" value="<%=referencia_seleccionada%>"/>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtfecha_entrega" class="control-label">Fecha de Env&iacute;o</label>
								<input type="date" class="form-control" name="txtfecha_entrega" id="txtfecha_entrega" value="<%=fecha_entrega_seleccionada%>"/>
							</div>
							
							<div class="col-sm-3 col-md-2 col-lg-2">
								<label for="cmdconsultar" class="control-label">&nbsp;</label>
								<button type="button" class="btn btn-primary btn-block" id="cmdconsultar" name="cmdconsultar"
									data-toggle="popover"
									data-placement="top"
									data-trigger="hover"
									data-content="Consultar Art&iacute;culos"
									data-original-title=""
									>
									<i class="fas fa-search"></i>&nbsp;&nbsp;&nbsp;Buscar
								</button>
							</div>
							
						</div>		
						<div class="form-group row mx-2">
							<div class="col-sm-2 col-md-2 col-lg-2">
								<button type="button" class="btn btn-primary btn-block" id="cmdrefrescar_nuevos" name="cmdrefrescar_nuevos"
									data-toggle="popover"
									data-placement="top"
									data-trigger="hover"
									data-content="Obtener Las Hojas de Ruta Nuevas de Graphisoft"
									data-original-title=""
									>
									Importar Hojas
								</button>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<button type="button" class="btn btn-primary btn-block" id="cmdrefrescar_modificaciones" name="cmdrefrescar_modificaciones"
									data-toggle="popover"
									data-placement="top"
									data-trigger="hover"
									data-content="Obtener Datos Actualizados de Graphisoft"
									data-original-title=""
									>
									Actualizar Datos
								</button>
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="cmbsalidas">Salida</label>
								<select class="form-control" id="cmbsalidas" name="cmbsalidas">
								  <option value="">Seleccionar...</option>
								  <option value="ENTRADA DE ALMACEN">ENTRADA DE ALMACEN</option>
								  <option value="SALIDA DE ALMACEN">SALIDA DE ALMACEN</option>
								  <option value="VALIJA">VALIJA</option>
								  <option value="PATROCINIO">PATROCINIO</option>
								  <option value="AUTOCONSUMO">AUTOCONSUMO</option>
								  <option value="CAJA">CAJA</option>
								</select>
							</div>
						</div>
					</form>
						<div class="row  mx-2">
							 <table id="lista_hojas_ruta" name="lista_hojas_ruta" class="table table-striped table-bordered" cellspacing="0" width="99%">
							  <thead>
								<tr>
									<th style="width:5%">Hoja Ruta</th>
									<th style="width:14%">Estado</th>
								 	<th style="width:18%">Cliente</th>
									<th style="width:27%">Referencia</th>
									<th style="width:14%">Subcontratista</th>		
									<th style="width:4%">Fecha Emision</th>
									<th style="width:4%">Fecha Envio</th>
									<th style="width:10%">Salida</th>
									<th style="width:4%">Albar&aacute;n</th>
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
                        url: "tojson/obtener_clientes_graphisoft_hojas.asp",
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

    j$.typeahead({
        input: '.js-typeahead-subcontratista',
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
                display: "SUBCONTRATISTA",
                ajax: function (query) {
                    return {
                        type: "POST",
                        url: "tojson/obtener_subcontratistas_graphisoft.asp",
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
    cadena = cadena + '<br><label class="control-label">pulsar sobre la imagen para verla a tama�o real</label>'
    cadena = cadena + '</div>'
    cadena = cadena + '</div>'
    cadena = cadena + '</div>'

    bootbox.alert({
        //size: 'large',
        message: cadena
        //callback: function () {return false;}
    })

};


j$("#txthoja_ruta").click(function () {
	if (j$("#txthoja_ruta").val()=='')
		{
		var f = new Date();
		anno=f.getFullYear().toString()
		mes='0' + (f.getMonth() +1).toString()
		mes=mes.substr(mes.length - 2, 2)
		j$("#txthoja_ruta").val(anno + mes + '0')
		}

});

j$("#txthoja_ruta").blur(function() {
	var f = new Date();
	anno=f.getFullYear().toString()
	mes='0' + (f.getMonth() +1).toString()
	mes=mes.substr(mes.length - 2, 2)
	fechatotal=anno + mes + '0'
	//console.log('fechatotal: ' + fechatotal)
	//console.log('fecha txt: ' + j$("#txthoja_ruta").val())
	if (fechatotal==j$("#txthoja_ruta").val())
		{
		j$("#txthoja_ruta").val('')
		}

});

j$("#cmdconsultar").click(function () {
    //j$("#frmbuscar_articulos").submit()
    //para que se cargue la tabla
    if ((j$("#txthoja_ruta").val() == "") && 
        (j$("#cmbestados").val() == "") && 
        (j$("#txtcliente").val() == "") && 
        (j$("#txtreferencia").val() == "") && 
        (j$("#txtsubcontratista").val() == "") && 
        (j$("#txtfecha_entrega").val() == "") && 
		(j$("#cmbsalidas").val() == "")){
	
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


j$("#cmdrefrescar_nuevos").click(function () {
    //j$("#pantalla_avisos .modal-dialog").css({'width': '90%'}); 
    j$("#cabecera_pantalla_avisos_actualizar_graphisoft").html("<h3>OBTENIENDO LAS HOJAS DE RUTA NUEVAS DE GRAPHISOFT</h3>")
    j$("#body_avisos_actualizar_graphisoft").html('Este proceso de traerse las nuevas hojas de ruta desde Graphisoft hasta nuestro sistema tarda unos 20 segundos.<br><br>Cuando finalice la Importaci&oacute;n, recibir� un aviso');
    j$("#pie_pantalla_avisos_actualizar_graphisoft").hide()
    j$("#pantalla_avisos_actualizar_graphisoft").modal("show");

    j$.ajax({
        type: 'POST',
        //contentType: "application/json; charset=utf-8",
        //contentType: "multipart/form-data; charset=UTF-8",
        //contentType: "application/x-www-form-urlencoded",
        url: 'Actualizar_Datos_Desde_Graphisoft_Nuevos.asp',
        success:
            function (data) {
                //console.log('lo devuelto por data: ' + data)
                switch (data) {
                    case '1':  //se encuentra dado de alta en la gestion de maletas  
                        cadena = 'Actualizaci&oacute;n realizada con exito.'
                        if ((j$("#txthoja_ruta").val() == "") && 
                            (j$("#cmbestados").val() == "") && 
                            (j$("#txtcliente").val() == "") && 
                            (j$("#txtreferencia").val() == "") && 
                            (j$("#txtsubcontratista").val() == "") && 
                            (j$("#txtfecha_entrega").val() == "")) {
                        }
                        else {
                            consultar_hojas_ruta();
                        }
                        break;
                    

                    default: 
                        cadena = 'Se Ha Producido un error...'
                        cadena = cadena + '<br><br>' + data
                        break;
                    
                }
                j$("#body_avisos_actualizar_graphisoft").html(cadena);
                j$("#pie_pantalla_avisos_actualizar_graphisoft").show()
                j$("#pantalla_avisos_actualizar_graphisoft").modal("show");
            },
        error:
            function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
    })
});

j$("#cmdrefrescar_modificaciones").click(function () {
    j$("#cabecera_pantalla_avisos_actualizar_graphisoft").html("<h3>OBTENIENDO LAS MODIFICACIONES DE LAS HOJAS DE RUTA DE GRAPHISOFT</h3>")
    j$("#body_avisos_actualizar_graphisoft").html('Este proceso de traerse las modificaciones de las hojas de ruta desde Graphisoft hasta nuestro sistema tarda unos 25 segundos.<br><br>Cuando finalice la Actualizacion, recibir� un aviso');
    j$("#pie_pantalla_avisos_actualizar_graphisoft").hide()
    j$("#pantalla_avisos_actualizar_graphisoft").modal("show");

    j$.ajax({
        type: 'POST',
        //contentType: "application/json; charset=utf-8",
        //contentType: "multipart/form-data; charset=UTF-8",
        //contentType: "application/x-www-form-urlencoded",
        url: 'Actualizar_Datos_Desde_Graphisoft_Modificaciones.asp',
        success:
            function (data) {
                //console.log('lo devuelto por data: ' + data)
                switch (data) {
                    case '1':  //se encuentra dado de alta en la gestion de maletas  
                        cadena = 'Actualizaci&oacute;n realizada con exito.';
                        if ((j$("#txthoja_ruta").val() == "") && 
                            (j$("#cmbestados").val() == "") && 
                            (j$("#txtcliente").val() == "") && 
                            (j$("#txtreferencia").val() == "") && 
                            (j$("#txtsubcontratista").val() == "") && 
                            (j$("#txtfecha_entrega").val() == "")) {
                        }
                        else {
                            consultar_hojas_ruta();
                        }
                        break;

                    default: 
                        cadena = 'Se Ha Producido un error...';
                        cadena = cadena + '<br><br>' + data;
                        break;
                }
                j$("#body_avisos_actualizar_graphisoft").html(cadena);
                j$("#pie_pantalla_avisos_actualizar_graphisoft").show()
                j$("#pantalla_avisos_actualizar_graphisoft").modal("show");
            },
        error:
            function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
    })
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

    prm.add("p_hoja_ruta", j$('#txthoja_ruta').val());
    prm.add("p_estado", j$('#cmbestados').val());
    //prm.add("p_cliente", j$('#txtcliente').val());
	prm.add("p_cliente", j$('#ocultocliente_seleccionado').val());
    prm.add("p_referencia", j$('#txtreferencia').val());
    prm.add("p_subcontratista", j$('#txtsubcontratista').val());
    prm.add("p_fecha_entrega", j$('#txtfecha_entrega').val());
	prm.add("p_salida", j$('#cmbsalidas').val());
    prm.add("p_ejecutar", j$('#ocultoejecutar').val());

    j$.fn.dataTable.moment("DD/MM/YYYY");

    //deseleccioamos el registro de la lista
    j$('#lista_hojas_ruta tbody tr').removeClass('selected');

    if (typeof lst_hojas_ruta == "undefined") {
        lst_hojas_ruta = j$("#lista_hojas_ruta").DataTable({
            dom: '<"toolbar">Blfrtip',
            ajax: {
                url: "tojson/obtener_hojas_ruta.asp?" + prm.toString(),
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
										cadena='<select class="custom-select-sm form-control-sm form-control cmbestados_datatable" id="cmbestados_datatable_' + row.HOJA_DE_RUTA + '" estado_anterior="' + row.ID_ESTADO + '" style="font-size: 11px;">'
					
										j$("#cmbestados_plantilla option").each(function(){
											//console.log('desde el datatable:  opcion ' + j$(this).text()+' valor '+ j$(this).attr('value'))
											
											//console.log('id_estado: ' + row.ID_ESTADO + ' .. combo: ' + j$(this).attr('value'))
											
											if (j$(this).attr('value')==12) //inhabilitamos el estado de cancelado
												{
												prohibimos=' disabled'
												}
											  else
												{
												prohibimos=''
												}

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
                exportOptions:{columns:[0,1,13,2,3,4,5,6,7,8],
								format: {
									//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
									header: function ( data, columnIdx ) {
											switch(columnIdx) {
												case 13:
													return 'Presupuestista';
													break;
												default:
													return data;
												}
										},
									body: function ( data, row, column, node ) {
											switch(column) {
												case 1: //ESTADO
													seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
													return seleccionado
													
													/*antes lo hacia asi, pero no funciona si se ordena o filta 
													la lista de resultados
													return lst_hojas_ruta
																  .cell( {row: row, column: column} )
																  .nodes()
																  .to$()
																  .find(':selected')
																  .text()
													*/
													break;
													
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
						exportOptions:{columns:[0,1,13,2,3,4,5,6,7,8],
												format: {
													//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
													header: function ( data, columnIdx ) {
																switch(columnIdx) {
																	case 13:
																		return 'Presupuestista';
																		break;
																	default:
																		return data;
																	}
															},
													body: function ( data, row, column, node ) {
															switch(column) {
																case 1: //ESTADO
																	seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
																	return seleccionado
																	
																	/*antes lo hacia asi, pero no funciona si se ordena o filta 
																	la lista de resultados
																	return lst_hojas_ruta
																				  .cell( {row: row, column: column} )
																				  .nodes()
																				  .to$()
																				  .find(':selected')
																				  .text()
																	*/
																	break;
																	
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
						exportOptions:{columns:[0,1,13,2,3,4,5,6,7,8],
											format: {
													//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
													header: function ( data, columnIdx ) {
																switch(columnIdx) {
																	case 13:
																		return 'Presupuestista';
																		break;
																	default:
																		return data;
																	}
															},
													body: function ( data, row, column, node ) {
															switch(column) {
																case 1: //ESTADO
																	seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
																	return seleccionado
																	
																	/*antes lo hacia asi, pero no funciona si se ordena o filta 
																	la lista de resultados
																	return lst_hojas_ruta
																				  .cell( {row: row, column: column} )
																				  .nodes()
																				  .to$()
																				  .find(':selected')
																				  .text()
																	*/
																	break;
																	
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
						exportOptions:{columns:[0,1,13,2,3,4,5,6,7,8],
											format: {
													//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
													header: function ( data, columnIdx ) {
																switch(columnIdx) {
																	case 13:
																		return 'Presupuestista';
																		break;
																	default:
																		return data;
																	}
															},
													body: function ( data, row, column, node ) {
															switch(column) {
																case 1: //ESTADO
																	seleccionado = j$(j$.parseHTML(data)).find('option:selected').text()
																	return seleccionado
																	
																	/*antes lo hacia asi, pero no funciona si se ordena o filta 
																	la lista de resultados
																	return lst_hojas_ruta
																				  .cell( {row: row, column: column} )
																				  .nodes()
																				  .to$()
																				  .find(':selected')
																				  .text()
																	*/
																	break;
																	
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

        j$('#lista_hojas_ruta').on('change', '.cmbestados_datatable', function () {
            //console.log('cambiando el valor a: ' + this.value);
            //j$(this).css('background-color', '#9FAFD1');
            //j$(this).parent().css({"color": "green", "border": "2px solid green"});
            var tbl_row = j$(this).closest('tr');
            tbl_row.find('.boton_guardar_estado').show();
            tbl_row.find('.boton_cancelar_guardar_estado').show();
            //j$(this).closest("boton_guardar_estado").show()

        });

        j$('#lista_hojas_ruta').on('click', '.boton_guardar_estado', function () {
            //console.log('cambiando el valor a: ' + this.value);
            //j$(this).css('background-color', '#9FAFD1');
            //j$(this).parent().css({"color": "green", "border": "2px solid green"});

            var tbl_row = j$(this).closest('tr');
            var row = lst_hojas_ruta.row(tbl_row).data()
            parametro_hoja_ruta = row.HOJA_DE_RUTA.replace(' ', '')
            parametro_id_estado_nuevo = tbl_row.find('.cmbestados_datatable').val()
            parametro_id_estado_antiguo = row.ID_ESTADO
            parametro_id_hoja = row.ID

            //console.log('LOS VALORES A GUARDAR SON: HOJA DE RUTA.... ' + parametro_hoja_ruta + ' ... ESTADO... ' + parametro_id_estado_nuevo)

            controles_visibles = 0
            j$('.boton_guardar_estado').each(function (index, value) {
                //console.log('div' + index + ':' + $(this).attr('id'));
                if (j$(this).is(":visible")) {
                    controles_visibles++
                }
            });

            if (controles_visibles > 1) {
                bootbox.alert({
                    //size: 'large',
                    message: '<h5>Hay un Cambio Pendiente de Guardar o Cancelar</h5>'
                    //callback: function () {return false;}
                })
            }
            else {
				sesion_bien=''
				console.log('valor del campo oculto: ' + j$("#ocultousuario").val())
				if (j$("#ocultousuario").val()!='')
					{
					sesion_bien='SI'
					}
			
			
				if (sesion_bien=='SI')
					{
					j$.ajax({
						type: 'POST',
						url: 'Modificar_Estado_Desde_Datatable.asp',
						data: {
							hoja_de_ruta: parametro_hoja_ruta,
							id_estado_antiguo: parametro_id_estado_antiguo,
							id_estado_nuevo: parametro_id_estado_nuevo,
							id_hoja: parametro_id_hoja,
							usuario: j$("#ocultousuario").val()
						},
						success:
							function (data) {
								//console.log('lo devuelto por data: ' + data)
								switch (data) {
									case '1':  //se encuentra dado de alta en la gestion de maletas  
										cadena = 'Estado Modificado Correctamente.';
										row.ID_ESTADO = parametro_id_estado_nuevo;
										tbl_row.find('.cmbestados_datatable').attr('estado_anterior', row.ID_ESTADO);
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
					})
	
					tbl_row.find('.boton_guardar_estado').hide();
					tbl_row.find('.boton_cancelar_guardar_estado').hide();
				}
			  else
			  	{
				location.href='Login.asp'
				}
            }
            //j$(this).closest("boton_guardar_estado").show()

        });

        j$('#lista_hojas_ruta').on('click', '.boton_cancelar_guardar_estado', function () {
            //console.log('cambiando el valor a: ' + this.value);
            //j$(this).css('background-color', '#9FAFD1');
            //j$(this).parent().css({"color": "green", "border": "2px solid green"});

            var tbl_row = j$(this).closest('tr');
            //console.log('estado actual del combo: ' + tbl_row.find('.cmbestados_datatable').val())
            //console.log('estado anterior del combo: ' + tbl_row.find('.cmbestados_datatable').attr('estado_anterior'))

            tbl_row.find('.cmbestados_datatable').val(tbl_row.find('.cmbestados_datatable').attr('estado_anterior'));

            tbl_row.find('.boton_guardar_estado').hide();
            tbl_row.find('.boton_cancelar_guardar_estado').hide();

        });

        /*
        j$('#lista_hojas_ruta').on('click', '.cmbestados_datatable', function() {
          console.log('cambiando el valor a: ' + this.value);
        });
        */
    }
    else {
        //stf.lst_tra.clear().draw();
        lst_hojas_ruta.ajax.url("tojson/obtener_hojas_ruta.asp?" + prm.toString());
        lst_hojas_ruta.ajax.reload();
    }

    lst_hojas_ruta.on('buttons-action', function (e, buttonApi, dataTable, node, config) {
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