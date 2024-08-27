<!--#include file="DB_Manager.inc"-->
<!--#include file="tojson/JSONData.inc"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
    Dim estados
    Dim sql
    Dim query_options
    Dim last_version
    Dim last_version_id
    Dim selected

    If Session("usuario") = "" Then
        Response.Redirect("Login.asp")
    End If

    id_presupuesto = Request.QueryString("id")

    CAMPO_ID_ESTADOS			= 0
    CAMPO_DESCRIPCION_ESTADOS	= 1
	ID_ESTADO_SEGUIMIENTO		= 3

    ' GetEstados query
    sql = "SELECT ID, DESCRIPCION FROM GESTION_GRAPHISOFT_ESTADOS_PRESUPUESTOS ORDER BY ORDEN"
    vacio_estados = false

    Set estados = execute_sql(conn_gag, sql)
    If Not estados.BOF Then
        tabla_estados = estados.GetRows()
    Else
        vacio_estados = true
    End If

    close_connection(estados)
    ' /GetEstados query
	
	

    ' sql = "SELECT USUARIO, NOMBRE FROM GESTION_GRAPHISOFT_USUARIOS WHERE GRUPO IN ('ADMINISTRACIÓN', 'PRESUPUESTACIÓN') ORDER BY NOMBRE"
    sql = "SELECT USUARIO, NOMBRE FROM GESTION_GRAPHISOFT_USUARIOS WHERE GRUPO LIKE 'ADMINISTRACI%' OR GRUPO LIKE 'PRESUPUESTACI%' ORDER BY NOMBRE"
    vacio_usuarios = false
    Set usuarios = execute_sql(conn_gag, sql)
    If Not usuarios.BOF Then
        tabla_usuarios = usuarios.GetRows()
    Else
        vacio_usuarios = true
    End If
    close_connection(usuarios)
	
	
	
    ' Empty assignments
    campo_id_estado			= ""
    campo_estado			= ""
	campo_subestado			= ""
    campo_presupuesto		= ""
    campo_version			= ""
    campo_fecha_creacion	= ""
    campo_cantidad			= ""
    campo_importe			= ""
    campo_tarifa			= ""
    campo_id_cliente		= ""
	campo_cliente_nombre	= ""
	campo_cliente_direccion	= ""
	campo_cliente_poblacion	= ""
	campo_cliente_cp		= ""
	campo_cliente_pais		= ""
	campo_cliente_telefono	= ""
    campo_presupuestista	= ""
    campo_descripcion		= ""
	campo_observaciones_local = ""
	campo_proxima_revision  = ""
	campo_proxima_revision_formateado=""
	
	
    
    ' /Empty assignments

    ' GetHojaRuta
    sql = "SELECT ID_PRESUPUESTO, A.ID_ESTADO, B.DESCRIPCION AS ESTADO, ID_SUBESTADO, C.DESCRIPCION AS SUBESTADO, PRESUPUESTO, VERSION"
	sql = sql & ", A.ID_CLIENTE, D.CATEGORIA, D.NOMBRE AS CLIENTE_NOMBRE, D.DIRECCION AS CLIENTE_DIRECCION, D.POBLACION AS CLIENTE_POBLACION"
	sql = sql & ", D.CP AS CLIENTE_CP, D.PAIS AS CLIENTE_PAIS, D.TELEFONO AS CLIENTE_TELEFONO"
	sql = sql & ", PRESUPUESTISTA, FECHA_CREACION, CANTIDAD, IMPORTE, A.DESCRIPCION AS DESCRIPCION"
	sql = sql & ", TARIFA, A.OBSERVACIONES_GESTION AS OBSERVACIONES_LOCAL, A.PROXIMA_REVISION"
	sql = sql & " FROM GESTION_GRAPHISOFT_PRESUPUESTOS A"
	sql = sql & " INNER JOIN GESTION_GRAPHISOFT_ESTADOS_PRESUPUESTOS B"
	sql = sql & " ON A.ID_ESTADO=B.ID"
	sql = sql & " LEFT JOIN GESTION_GRAPHISOFT_SUBESTADOS_PRESUPUESTOS C"
	sql = sql & " ON A.ID_SUBESTADO=C.ID"
	sql = sql & " LEFT JOIN GESTION_GRAPHISOFT_CLIENTES D"
	sql = sql & " ON A.ID_CLIENTE=D.ID"
	
	sql = sql & " WHERE ID_PRESUPUESTO = " & id_presupuesto
	
	



    'Response.Write("<br>" & sql)

    Set presupuesto = execute_sql(conn_gag, sql)
    If Not presupuesto.EOF Then
	    campo_id_presupuesto	= "" & presupuesto("id_presupuesto")
		campo_estado			= "" & presupuesto("id_estado")
		campo_subestado			= "" & presupuesto("id_subestado")
		campo_presupuesto		= "" & presupuesto("presupuesto")
		campo_version			= "" & presupuesto("version")
		campo_fecha_creacion	= "" & presupuesto("fecha_creacion")
		campo_cantidad			= "" & presupuesto("cantidad")
		campo_importe			= "" & presupuesto("importe")
		campo_tarifa			= "" & presupuesto("tarifa")
		campo_id_cliente		= "" & presupuesto("id_cliente")
		campo_cliente_nombre	= "" & presupuesto("cliente_nombre")
		campo_cliente_direccion	= "" & presupuesto("cliente_direccion")
		campo_cliente_poblacion	= "" & presupuesto("cliente_poblacion")
		campo_cliente_cp		= "" & presupuesto("cliente_cp")
		campo_cliente_pais		= "" & presupuesto("cliente_pais")
		campo_cliente_telefono	= "" & presupuesto("cliente_telefono")
		campo_presupuestista	= "" & presupuesto("presupuestista")
		campo_descripcion		= "" & presupuesto("descripcion")
		campo_observaciones_local = "" & presupuesto("observaciones_local")
		campo_proxima_revision  = "" & presupuesto("proxima_revision")
		
		if campo_proxima_revision<>"" then
			campo_proxima_revision_formateado=(year(campo_proxima_revision) & "-" & right("0" & month(campo_proxima_revision), 2) & "-" & right("0" & day(campo_proxima_revision), 2))
		end if
    End If
    ' /GetHojaRuta
	
	'RESPONSE.WRITE("<BR><BR>PROXIMA REVISION: " & campo_proxima_revision)

    ' Get the last budget version
    sql = "SELECT TOP (1) MAX(VERSION) AS ULTIMA_VERSION, ID_PRESUPUESTO FROM GESTION_GRAPHISOFT_PRESUPUESTOS WHERE PRESUPUESTO = " & campo_presupuesto & " GROUP BY ID_PRESUPUESTO ORDER BY ULTIMA_VERSION DESC"
	'RESPONSE.WRITE("<BR>" & sql)
    
	Set version_presupuesto = execute_sql(conn_gag, sql)
    If Not version_presupuesto.EOF Then
        If cint(campo_version) = cint(version_presupuesto("ultima_version")) Then
            last_version = True
        Else
            last_version = False
            last_version_id = version_presupuesto("id_presupuesto")
        End If
    End If
    ' /GetLastBudgetVersion

    close_connection(presupuesto)
    close_connection(version_presupuesto)

%>

<html lang="es">
<head>
    <!--<meta charset="utf-8">-->
    <title>Presupuesto</title>
</head>
<body>

<div class="container-fluid">
    <form action="Guardar_Presupuesto.asp" method="post" id="frmdatos_presupuesto" name="frmdatos_presupuesto">
        <input type="hidden" name="ocultoid_presupuesto" id="ocultoid_presupuesto" value="<%=campo_id_presupuesto%>" />
		<input type="hidden" name="ocultopresupuesto" id="ocultopresupuesto" value="<%=campo_presupuesto%>" />

        <% If Not last_version Then %>
            <div class="alert alert-warning" role="alert">Hay una nueva versi&oacute;n m&aacute;s actualizada del presupuesto. <a href="Detalle_Presupuesto.asp?id=<%=last_version_id%>" target="_self">Ir a la nueva versi&oacute;n del presupuesto</a></div>
        <% End If %>

    <!--datos pir - indiana -->
    <div class="panel-group" id="datos_presupuesto">
        
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title">
                          Datos del presupuesto
                </h3>
                <span class="pull-right clickable">
                    <i class="glyphicon glyphicon-chevron-up"
                        data-toggle="popover" 
                        data-placement="left" 
                        data-trigger="hover"
                        data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n del presupuesto"
                    ></i>
                </span>
                
            </div>
            
            <div id="desplegable_datos_presupuesto" class="panel-body">
                
                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-12">
                        <div class="form-group row">
                        <div class="col-sm-4 col-md-4 col-lg-4">
                            <label for="txtestado_d" class="control-label">ESTADO</label>
                            <select id="cmbestados_d" name="cmbestados_d" data-width="100%" class="cmb_bt">
                                <option value="">&nbsp;</option>
                                <%
                                    selected = ""
                                    If Not vacio_estados Then
                                        For i = 0 To UBound(tabla_estados, 2)
                                            If cint(tabla_estados(campo_id_estados,i)) = cint(campo_estado) Then
                                                selected = "selected"
                                            Else
                                                selected = ""
                                            End If
                                %>
                                            <option value="<%=tabla_estados(campo_id_estados,i)%>" <%=selected%>><%=tabla_estados(campo_descripcion_estados,i)%></option>
                                <%		Next
                                    End If                                    
                                %>
                            </select>
                        </div>
						<div class="col-sm-3 col-md-3 col-lg-3" id="capa_subestados" style="display:none"></div>
						<div class="col-sm-2 col-md-2 col-lg-2" id="capa_proxima_revision" style="display:none">
								<label for="txtfecha_creacion_desde" class="control-label">PR&Oacute;XIMA REVISI&Oacute;N</label>
								<input type="date" class="form-control" name="txtfecha_proxima_revision" id="txtfecha_proxima_revision" value="<%=campo_proxima_revision_formateado%>"/>
						</div>
						
						
                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <label for="txtestado_d" class="control-label">&nbsp;</label>
                            <div class="clearfix"></div>
                            <button type="button" class="btn btn-primary" id="cmdguardar_presupuesto" name="cmdguardar_presupuesto">
                                <span class="glyphicon glyphicon-floppy-disk mr-2" aria-hidden="true"></span> Guardar</button>
                        </div>
                        </div>
                    </div>
                    
                    <div class="clearfix visible-md-block"></div>
                    
                    <div class="col-sm-12 col-md-12 col-lg-12">
                        <div class="form-group row">
                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <label for="txtpresupuesto_d" class="control-label">PRESUPUESTO</label>
                            <input type="text" class="form-control" id="txtpresupuesto_d" name="txtpresupuesto_d" value="<%=campo_presupuesto%>" disabled/>
                        </div>
                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <label for="txtversion_d" class="control-label">VERSION</label>
                            <input type="text" id="txtversion_d" class="form-control" required="" name="txtversion_d" value="<%=campo_version%>"  disabled/> 
                        </div>
                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <label for="txtfecha_creacion_d" class="control-label"
                                data-toggle="popover" 
                                data-placement="top" 
                                data-trigger="hover"
                                data-content="Fecha de creaci&oacute;n"
                                >F. CREACI&Oacute;N</label>
                            <input type="text" id="txtfecha_creacion_d" class="form-control" required="" name="txtfecha_creacion_d" value="<%=campo_fecha_creacion%>" disabled /> 
                        </div>
                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <label for="txtcantidad_d" class="control-label"
                                data-toggle="popover" 
                                data-placement="top" 
                                data-trigger="hover"
                                data-content="Cantidad"
                                >CANTIDAD</label>
                            <input type="text" class="form-control" style="width: 100%;"  id="txtcantidad_d" name="txtcantidad_d" value="<%=campo_cantidad%>" disabled />
                        </div>
                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <label for="txtimporte_d" class="control-label">IMPORTE</label>
                            <input type="text" class="form-control" style="width: 100%;"  id="txtimporte_d" name="txtimporte" value="<%=campo_importe%>" disabled />
                        </div>
                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <label for="txttarifa_d" class="control-label">TARIFA</label>
                            <input type="text" id="txttarifa_d" class="form-control" required="" name="txttarifa_d" value="<%=campo_tarifa%>"  disabled /> 
                        </div>
                        </div>
                    </div>
                    
                    <div class="clearfix visible-md-block"></div>
					
					<div class="col-sm-12 col-md-12 col-lg-12">  
                        <div class="form-group row">
							<div class="col-sm-9 col-md-9 col-lg-9">
								<label for="txtdescripcion_d" class="control-label">DESCRIPCION</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txtdescripcion_d" name="txtdescripcion_d" value="<%=campo_descripcion%>"  disabled/>
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
									<label for="txtpresupuestista_d" class="control-label">PRESUPUESTISTA</label>
									<input type="text" id="txtpresupuestista_d" class="form-control" required="" name="txtpresupuestista_d" value="<%=campo_presupuestista%>" disabled /> 
							</div>
                        </div>
                    </div>			
                    
                    <div class="clearfix visible-md-block"></div>
					
					<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">  
							<div class="col-sm-6 col-md-6 col-lg-6">
								<label for="txtcliente_d" class="control-label" style="width:100%">CLIENTE</label>
								<input type="text" id="txtcliente_d" class="form-control" required="" name="txtcliente_d" value="<%=campo_cliente_nombre%>" disabled /> 
							</div>
							<div class="col-sm-6 col-md-6 col-lg-6">
								<label for="txtcliente_direccion_d" class="control-label">DIRECCI&Oacute;N</label>
								<input type="text" id="txtcliente_direccion_d" class="form-control" required="" name="txtcliente_direccion_d" value="<%=campo_cliente_direccion%>" disabled /> 
							</div>
                          </div>
						</div>						  
						
						<div class="clearfix visible-md-block"></div>
						
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-4 col-md-4 col-lg-4">
								<label for="txtcliente_poblacion_d" class="control-label">POBLACI&Oacute;N</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcliente_poblacion_d" name="txtcliente_poblacion_d" value="<%=campo_cliente_poblacion%>"  disabled/>
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtcliente_cp_d" class="control-label">C.P.</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcliente_cp_d" name="txtcliente_cp_d" value="<%=campo_cliente_cp%>"  disabled/>
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtcliente_pais_d" class="control-label">PA&Iacute;S</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcliente_pais_d" name="txtcliente_pais_d" value="<%=campo_cliente_pais%>"  disabled/>
							</div>
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtcliente_telefono_d" class="control-label">TEL&Eacute;FONO</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtcliente_telefono_d" name="txtcliente_telefono_d" value="<%=campo_cliente_telefono%>"  disabled/>
							</div>
                          </div>
						</div>						  
						
						<div class="clearfix visible-md-block"></div>
						
						
					
					
                    
                    
						<div class="col-sm-12 col-md-12 col-lg-12">  
						  <div class="form-group row">
                            <div class="col-sm-12 col-md-12 col-lg-12">
								<label for="txtobservaciones_local_d" class="control-label">OBSERVACIONES LOCAL</label>
    	                        <input type="text" class="form-control" style="width: 100%;"  id="txtobservaciones_local_d" name="txtobservaciones_local_d" value="<%=campo_observaciones_local%>" />
							</div>
                          </div>
						</div>						  
          </div>
            <!-- panel Body-->
        </div>
        <!-- PANEL-->
    </div> 
    <!-- FIN datos hoja de ruta -->
    <!--botones-->
    <!--fin botones-->				
<!-- historico-->
	
	
		<div class="panel panel-primary" id="datos_presupuesto_historico_actividad">
			<div class="panel-heading">
				<h3 class="panel-title">HIST&Oacute;RICO PRESUPUESTO</h3>
				<span class="pull-right clickable">
					<i class="glyphicon glyphicon-chevron-down"
						data-toggle="popover" 
						data-placement="left" 
						data-trigger="hover"
						data-content="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n del presupuesto"
					></i>
				</span>
			</div>
			<div id="desplegable_datos_presupuesto_historico_actividad" class="panel-body">
				<div class="form-group">
					<div class="col-sm-12 col-md-12 col-lg-12">
						<!--
						<div width="95%">
								<div class="btn-group" role="group" id="botones_historico">
									<button type="button" class="btn btn-default">Todo</button>
									<button type="button" class="btn btn-default">Hist&oacute;rico</button>
									<button type="button" class="btn btn-default active">Incidencias</button>
								</div>
						</div>
						-->
						<div width="95%">							
							<table id="lista_historico_presupuesto" name="lista_historico_presupuesto" class="table table-bordered" cellspacing="0" width="100%">
								<thead>
									<tr>
										<th class="col-xs-1">Fecha</th>
										<th class="col-xs-1">Hora</th>
										<th class="col-xs-1">Acci&oacute;n</th>
										<th class="col-xs-1">Campo</th>
										<th class="col-xs-2">Valor Antiguo</th>
										<th class="col-xs-2">Valor Nuevo</th>
										<th class="col-xs-1">
										<i class="glyphicon glyphicon-user"
											data-toggle="popover_datatable"
											data-placement="top"
											data-trigger="hover"
											data-content="Usuario"></i>
										</th>
										<th class="col-xs-3">Descripci&oacute;n</th>
									</tr>
								</thead>
							</table>		
						</div>
					</div>
				</div>
			</div>
		</div>
            <!--fin datos hoja ruta historico actividad-->					
    </form>
</div><!--CONTAINER-->

 <!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->

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

<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script>  
  
<script language="javascript">
var j$ = jQuery.noConflict();

j$(document).on('click', '.panel-heading span.clickable', function (e) {
    var j$this = j$(this);
    if (!j$this.hasClass('panel-collapsed')) {
        //console.log('encuentra panel-collapsed')
        j$this.parents('.panel').find('.panel-body').slideUp();
        j$this.addClass('panel-collapsed');
        j$this.find('i').removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
    } else {
        //console.log('NOOO encuentra panel-collapsed')
        j$this.parents('.panel').find('.panel-body').slideDown();
        j$this.removeClass('panel-collapsed');
        j$this.find('i').removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up');
    }
})

j$(document).ready(function () {
    var prm = new ajaxPrm();

    //refresco la tabla anterior por si hay modificaciones
    //window.parent.lst_pirs.ajax.reload(); 

    //para que se reconfigure el combo como del tipo selectpicker
    j$('.cmb_bt').selectpicker()
    //para que se configuren los popover-titles...
    j$('[data-toggle="popover"]').popover({ html: true, container: 'body' });
    j$("#cmbestados_d").val('<%=campo_estado%>');
	//Si está en estudio o rechazado tenemos que mostrar las observaciones del estado
	//console.log('valor del estado cmb: ' + j$("#cmbestados_d").val())
	if (j$("#cmbestados_d").val()=='5' || j$("#cmbestados_d").val()=='6' )
		{
		//console.log('el estado es en estudio o rechazado')
		mostrar_subestado('<%=campo_subestado%>');
		if (j$("#cmbestados_d").val()=='5'){
			j$("#capa_proxima_revision").show()
		}
		
		//j$("#cmbsubestados_d").val('<%=campo_subestado%>');
		//console.log('valor de subestado campo_subestado: <%=campo_subestado%>')
		//console.log('valor de subestado cmb: ' + j$("#cmbsubestados_d").val())
		}
	if (j$("#cmbestados_d").val()=='3' ){
		//console.log('el estado es seguimiento');
		j$("#capa_proxima_revision").show()
	}

    // Para que esté autoseleccionado
    //j$(".cmb_bt").selectpicker('refresh')

    prm.add("p_presupuesto", j$('#ocultoid_presupuesto').val());

    j$.fn.dataTable.moment("DD/MM/YYYY");

  
  
  
  
  
  	if (typeof lst_historico_presupuesto == "undefined") {
        lst_historico_presupuesto = j$("#lista_historico_presupuesto").DataTable({
            dom: '<"toolbar">Blfrtip',
            ajax: {
                url: "tojson/obtener_historico_presupuesto.asp?" + prm.toString(),
                type: "POST",
                dataSrc: "ROWSET"
            },
            order: [],
            columnDefs: [
                { className: "dt-center", targets: [7] }
            ],
            /*
            columnDefs: [
                     {className: "dt-right", targets: [2,3]},
                     {className: "dt-center", targets: [4]}                                                            
                   ],
           */
            responsive: true,
            columns: [
                { data: "FECHA" },
                { data: "HORA" },
                { data: "ACCION" },
                { data: "CAMPO" },
                { data: "VALOR_ANTIGUO" },
                { data: "VALOR_NUEVO" },
                {
                    data: function (row, type, val, meta) {
                        //return (row.numtra!="0")?'<a href="#" onclick="tve.ver_detalle_tra(\''+ row.codcat + '\');">'+row.numtra+'</a>':row.numtra;                             
                        if (row.NOMBRE_USUARIO == '') {
                            cadena = row.USUARIO;
                        }
                        else {
                            cadena_usuario = row.NOMBRE_USUARIO + ' (' + row.USUARIO + ')'
                            cadena = '<i class="fa fa-user-o" aria-hidden="true" style="cursor:pointer"' +
                                'data-toggle="popover_datatable"' +
                                'data-placement="top"' +
                                'data-trigger="hover"' +
                                'data-content="<span style=\'color:blue;\'><i class=\'fa fa-user-o fa-lg\'></i>&nbsp;' + cadena_usuario + '"></i></span>';
                        }
                        return cadena;
                    }
                },
                { data: "DESCRIPCION" },
                { data: "ID", visible: false },
                { data: "ID_PRESUPUESTO", visible: false },
                { data: "PRESUPUESTO", visible: false },
                { data: "ESTADO", visible: false },
                { data: "NOMBRE_USUARIO", visible: false }
            ],
            deferRender: true,
            //  Scroller
            scrollY: calcDataTableHeight() - 70,
            scrollCollapse: true,
            buttons: [
                {
                    extend: "copy", text: '<i class="fa fa-files-o"></i>', titleAttr: "Copiar en Portapapeles",
                    exportOptions: {
                        columns: [0, 1, 2, 3, 4, 5, 12, 7],
                        format: {
                            header: function (data, columnIdx) {
                                if (columnIdx == 12) {
                                    return 'Usuario';
                                }
                                else {
                                    return data;
                                }
                            }
                        }
                    }
                },
                {
                    extend: "excel",
                    text: '<i class="fa fa-file-excel-o"></i>',
                    titleAttr: "Exportar a Formato Excel",
                    title: "Historico Presupuesto <%=campo_presupuesto%>",
                    extension: ".xls",
                    exportOptions: {
                        columns: [0, 1, 2, 3, 4, 5, 12, 7],
                        format: {
                            header: function (data, columnIdx) {
                                if (columnIdx == 12) {
                                    return 'Usuario';
                                }
                                else {
                                    return data;
                                }
                            }
                        }
                    }
                },
                {
                    extend: "pdf", text: '<i class="fa fa-file-pdf-o"></i>', titleAttr: "Exportar a Formato PDF", title: "Historico Presupuesto <%=campo_presupuesto%>", orientation: "landscape",
                    exportOptions: {
                        columns: [0, 1, 2, 3, 4, 5, 12, 7],
                        format: {
                            header: function (data, columnIdx) {
                                if (columnIdx == 12) {
                                    return 'Usuario';
                                }
                                else {
                                    return data;
                                }
                            }
                        }

                    }
                },
                {
                    extend: "print", text: "<i class='fa fa-print'></i>", titleAttr: "Vista Preliminar", title: "Historico Presupuesto <%=campo_presupuesto%>",
                    exportOptions: {
                        columns: [0, 1, 2, 3, 4, 5, 12, 7],
                        format: {
                            header: function (data, columnIdx) {
                                if (columnIdx == 12) {
                                    return 'Usuario';
                                }
                                else {
                                    return data;
                                }
                            }
                        }

                    }
                }
            ],
            rowCallback: function (row, data, index) {
                //stf.row_sel = data;   
                //console.log(data);
                if (data.ACCION == "INCIDENCIA") {
                    //j$( row ).css( "background-color", "Orange" );
                    //j$( row ).addClass( "warning" );
                    j$(row).addClass("danger");
                }
            },
            drawCallback: function () {
                //para que se configuren los popover-titles...
                j$('[data-toggle="popover_datatable"]').popover({ html: true, container: 'body' });
                //j$('[data-toggle="popover_datatable"]').next('.popover').addClass('popover_usuario');
            },
            //initComplete: stf.initComplete,                                                            
            language: { url: "plugins/dataTable/lang/Spanish.json" },
            paging: false,
            processing: true,
            searching: true
        });

        //controlamos el click, para seleccionar o desseleccionar la fila
        j$("#lista_historico_presupuesto tbody").on("click", "tr", function () {
            if (!j$(this).hasClass("selected")) {
                lst_historico_presupuesto.$("tr.selected").removeClass("selected");
                j$(this).addClass("selected");
                //var table = j$('#lista_pirs').DataTable();
                //row_sel = table.row( this ).data();
            }
            //console.log(row_sel);
        });
    }
    else {
        //stf.lst_tra.clear().draw();
        lst_historico_presupuesto.url("tojson/obtener_historico_presupuesto.asp?" + prm.toString());
        lst_historico_presupuesto.ajax.reload();
    }
	
	
	
	
  
  
  
  
  
  
});

calcDataTableHeight = function () {
    return j$(window).height() * 55 / 100;
};

j$('#cmdguardar_presupuesto').on('click', function () {
    hay_error = '';
	//alert('dentro del click de guardar')
	//alert('estado: ' + j$("#cmbestados_d").val())
	
	if (j$("#cmbestados_d").val()=='5' || j$("#cmbestados_d").val()=='6')
		{
		//alert('rechazado o en estudio')	
		//alert('subestado: ' + j$("#cmbsubestados_d").val())
		if (j$("#cmbsubestados_d").val()=='')
			{
			//alert('subestado vacio')	
			hay_error+='<br>-Se Han de Seleccionar unas Observaciones Para El Estado del Presupuesto.'
			}
		if (j$("#cmbestados_d").val()=='5')
			{
			if (j$("#txtfecha_proxima_revision").val()=='')
				{
				hay_error+='<br>-Se Ha de Seleccionar La Fecha de la Pr&oacute;xima Revisi&oacute;n del Presupuesto.'
			
				}
				
			}
		}
	
	if (j$("#cmbestados_d").val()=='3'){		
		if (j$("#txtfecha_proxima_revision").val()==''){
			hay_error+='<br>-Se Ha de Seleccionar La Fecha de la Pr&oacute;xima Revisi&oacute;n del Presupuesto.'
		}				
	}

	//alert('despues de comprobaciones de error')	
    if (hay_error != '') {
        j$("#cabecera_pantalla_avisos").html("<h3>Errores Detectados</h3>")
        j$("#body_avisos").html('<H4><br>' + hay_error + '<br></h4>');
        j$("#pantalla_avisos").modal("show");
    }
    else {
        j$("#frmdatos_presupuesto").submit()
    }
});


mostrar_subestado = function (subestado) {
     j$.ajax({
        type: 'POST',
        //contentType: "application/json; charset=utf-8",
        //contentType: "multipart/form-data; charset=UTF-8",
        //contentType: "application/x-www-form-urlencoded",
        url: 'Obtener_Subestados.asp?codigo_estado=' + j$('#cmbestados_d').val() + '&codigo_subestado=' + subestado,
        success:
            function (data) {
                console.log('lo devuelto por data: ' + data)
				if (data!='')
					{
					j$("#capa_subestados").html(data)
					j$("#capa_subestados").show()
					}
				  else
				  	{
					j$("#capa_subestados").html()
					j$("#capa_subestados").hide()
					}
            },
        error:
            function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
    })
};

j$('#cmbestados_d').on('change', function() {
	mostrar_subestado('<%=campo_subestado%>');
	if (j$('#cmbestados_d').val()==5 || j$('#cmbestados_d').val()==3){
		j$("#capa_proxima_revision").show()
	}else{
		j$("#txtfecha_proxima_revision").val('')
		j$("#capa_proxima_revision").hide()
	}
	
});

</script>
    <link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
    <!-- <link rel="stylesheet" type="text/css" href="../plugins/bootstrap-4.0.0/css/bootstrap.min.css"> -->
    <link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
    <link rel="stylesheet" type="text/css" href="plugins/dataTable/media/css/dataTables.bootstrap.css">
    <link rel="stylesheet" type="text/css" href="plugins/dataTable/extensions/Buttons/css/buttons.dataTables.min.css">
    <!-- <script type="text/javascript" src="plugins/fontawesome-5.7.1/js/all.js" defer></script> -->
    <link rel="stylesheet" type="text/css" href="plugins/font-awesome_4_7_0/css/font-awesome.min.css">

    <link rel="stylesheet" type="text/css" href="css/Detalle_Presupuesto.css">

    <style>
        .alert {
            position: relative;
            padding: 0.75rem 1.25rem;
            margin-bottom: 1rem;
            border: 1px solid transparent;
            border-radius: 0.25rem;
        }

        .alert-warning {
            color: #856404;
            background-color: #fff3cd;
            border-color: #ffeeba;
        }
    </style>
</body>
<%
    close_connection(conn_gag)
%>
</html>