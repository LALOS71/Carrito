<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
	if session("usuario_admin")="" then
		Response.Redirect("Login_GAGAD.asp")
	end if
		
	pedido_seleccionado=Request.Form("ocultopedido")
	origen_seleccionado="" & Request.Form("ocultoorigen")
	
	if Request.QueryString("ped")<>"" then
		pedido_seleccionado= Request.QueryString("ped")
	end if
		
	'recordsets
	dim pedidos
		
		
	'variables
	dim sql
			    
	set pedidos=Server.CreateObject("ADODB.Recordset")
		
	with pedidos
		.ActiveConnection=connimprenta
		.Source="set dateformat dmy; SELECT USUARIO_DIRECTORIO_ACTIVO, NombreUsuario, PEDIDOS.ID, PEDIDOS.CODCLI, V_CLIENTES.CODIGO_RUC, V_CLIENTES.OBSERVACIONES_ENTREGA,"
		.Source= .Source & " V_CLIENTES.EMAIL, V_CLIENTES.CODIGO_EXTERNO, V_CLIENTES.NOMBRE, PEDIDOS.PEDIDO,"
		.Source= .Source & " V_CLIENTES.DIRECCION, V_CLIENTES.POBLACION, V_CLIENTES.CP, V_CLIENTES.PROVINCIA, V_CLIENTES.TELEFONO, V_CLIENTES.FAX,"
		.Source= .Source & " PEDIDOS.FECHA, PEDIDOS.ESTADO as ESTADO_PEDIDO, PEDIDOS_DETALLES.ARTICULO, ARTICULOS.ID AS ID_ARTICULO, ARTICULOS.CODIGO_SAP,"
		.Source= .Source & " ARTICULOS.DESCRIPCION, PEDIDOS_DETALLES.CANTIDAD,"
		.Source= .Source & " (SELECT SUM(CANTIDAD_ENVIADA) FROM PEDIDOS_ENVIOS_PARCIALES"
		.Source= .Source & " WHERE ID_PEDIDO=PEDIDOS.ID AND ID_ARTICULO=ARTICULOS.ID AND ALBARAN IS NOT NULL) AS CANTIDAD_ENVIADA,"
		.Source= .Source & " (SELECT SUM(CANTIDAD_ENVIADA) FROM PEDIDOS_ENVIOS_PARCIALES"
		.Source= .Source & " WHERE ID_PEDIDO=PEDIDOS.ID AND ID_ARTICULO=ARTICULOS.ID AND ALBARAN IS NULL) AS CANTIDAD_LISTA,"
		.Source= .Source & " PEDIDOS_DETALLES.PRECIO_UNIDAD,"
		.Source= .Source & " PEDIDOS_DETALLES.TOTAL, PEDIDOS_DETALLES.ESTADO as ESTADO_ARTICULO, PEDIDOS_DETALLES.FICHERO_PERSONALIZACION,"
		.Source= .Source & " PEDIDOS_DETALLES.HOJA_RUTA, PEDIDOS_DETALLES.RESTADO_STOCK,"
		.Source= .Source & " V_EMPRESAS.EMPRESA, V_EMPRESAS.CARPETA, V_EMPRESAS.ID as ID_EMPRESA, V_CLIENTES.MARCA,"
		.Source= .Source & " ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.PESO, PEDIDOS.FECHA_ENVIADO, PEDIDOS_DETALLES.ALBARAN,"
		.Source= .Source & " ARTICULOS_PERSONALIZADOS.PLANTILLA_PERSONALIZACION, PEDIDOS.PEDIDO_AUTOMATICO,"
		.Source= .Source & " CASE WHEN PEDIDOS_DETALLES.ALBARAN IS NULL THEN NULL ELSE" 
		.Source= .Source & " (SELECT FECHAVALIJA FROM V_DATOS_ALBARANES WHERE IDALBARAN=PEDIDOS_DETALLES.ALBARAN)"
		.Source= .Source & " END AS ENVIO_PROGRAMADO, AIR.PREFIX, AIR.SERIAL"
		.Source= .Source & ", DESTINATARIO, DESTINATARIO_DIRECCION, DESTINATARIO_POBLACION, DESTINATARIO_CP"
		.Source= .Source & ", DESTINATARIO_PROVINCIA, DESTINATARIO_PAIS, DESTINATARIO_TELEFONO, PEDIDOS.GASTOS_ENVIO, PEDIDOS.HORARIO_ENTREGA"
		.Source= .Source & ", DESTINATARIO_PERSONA_CONTACTO, DESTINATARIO_COMENTARIOS_ENTREGA"
		
		.Source= .Source & " FROM PEDIDOS INNER JOIN PEDIDOS_DETALLES ON PEDIDOS.ID = PEDIDOS_DETALLES.ID_PEDIDO "
		.Source= .Source & " LEFT JOIN ARTICULOS ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID"
		.Source= .Source & " LEFT JOIN V_CLIENTES ON PEDIDOS.CODCLI = V_CLIENTES.Id"
		.Source= .Source & " LEFT JOIN V_EMPRESAS ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
    	.Source= .Source & " LEFT JOIN (SELECT  Usuario, max(NombreUsuario) NombreUsuario FROM V_Usuarios GROUP BY Usuario ) Us ON PEDIDOS.USUARIO_DIRECTORIO_ACTIVO = Us.Usuario"
		.Source= .Source & " LEFT JOIN ARTICULOS_PERSONALIZADOS ON PEDIDOS_DETALLES.ARTICULO=ARTICULOS_PERSONALIZADOS.ID_ARTICULO"
		.Source= .Source & " LEFT JOIN ALBARANES_AIRWILLBILL AIR ON AIR.ALBARAN = PEDIDOS_DETALLES.ALBARAN"	

		.Source= .Source & " WHERE PEDIDOS.ID = " & pedido_seleccionado
		'response.write("<br>" & .source)
		.Open

	end with

	gastos_envio=0
	datos_para_envio=""
	if not pedidos.eof then
		gastos_envio=pedidos("GASTOS_ENVIO")
		if pedidos("DESTINATARIO")<>"" then
			datos_para_envio= pedidos("DESTINATARIO") & chr(13)
			datos_para_envio= datos_para_envio & pedidos("DESTINATARIO_DIRECCION") & chr(13)
			datos_para_envio= datos_para_envio & pedidos("DESTINATARIO_CP") & " " & pedidos("DESTINATARIO_POBLACION") & chr(13)
			datos_para_envio= datos_para_envio & pedidos("DESTINATARIO_PROVINCIA")
			if pedidos("DESTINATARIO_PERSONA_CONTACTO")<>"" then
				datos_para_envio= datos_para_envio & chr(13) & "Contacto: " & pedidos("DESTINATARIO_PERSONA_CONTACTO")
			end if
			if pedidos("DESTINATARIO_COMENTARIOS_ENTREGA")<>"" then
				datos_para_envio= datos_para_envio & chr(13) & "Comentarios Entrega: " & pedidos("DESTINATARIO_COMENTARIOS_ENTREGA")
			end if
			
		end if
	end if

	set estados=Server.CreateObject("ADODB.Recordset")
	CAMPO_ESTADO=0
	with estados
		.ActiveConnection=connimprenta
		.Source="SELECT ESTADO"
		.Source= .Source & " FROM ESTADOS"
		'porque con los envios parciales actuales no tiene sentido a no ser que se manden las misas cantidades de todos los articulos
		'.Source= .Source & " WHERE ESTADO<> 'ENVIO PARCIAL'" 
		.Source= .Source & " ORDER BY ORDEN"
		.Open
		vacio_estados=false
		if not .BOF then
			mitabla_estados=.GetRows()
			else
			vacio_estados=true
		end if
	end with

	set observaciones_pedidos=Server.CreateObject("ADODB.Recordset")
	CAMPO_FECHA_OBSERVACIONES=0
	CAMPO_HORA_OBSERVACIONES=1	
	CAMPO_OBSERVACIONES_OBSERVACIONES=2
	with observaciones_pedidos
		.ActiveConnection=connimprenta
		.Source="SELECT CONVERT(nvarchar(10), FECHA, 103) AS FECHA"
		.Source=.Source & ", CONVERT(nvarchar(8), FECHA, 108) AS HORA"
		.Source=.Source & ", OBSERVACIONES" 
		.Source=.Source & " FROM PEDIDOS_OBSERVACIONES"
		.Source=.Source & " WHERE PEDIDO=" & pedido_seleccionado
		.Source=.Source & " ORDER BY ID DESC"
		.Open
		vacio_observaciones=false
		if not .BOF then
			mitabla_observaciones=.GetRows()
			else
			vacio_observaciones=true
		end if
	end with

	set saldos=Server.CreateObject("ADODB.Recordset")
		
		'response.write("<br>" & sql)

		with saldos
			.ActiveConnection=connimprenta
			.Source="SELECT ID, ID_PEDIDO, ID_SALDO, IMPORTE, CARGO_ABONO FROM SALDOS_PEDIDOS WHERE ID_PEDIDO=" & pedido_seleccionado
			.Source= .Source & " ORDER BY CARGO_ABONO DESC, ID"
			'RESPONSE.WRITE(.SOURCE)
			.Open
		end with




	set devoluciones=Server.CreateObject("ADODB.Recordset")
		
		'response.write("<br>" & sql)

		with devoluciones
			.ActiveConnection=connimprenta
			.Source="SELECT ID, ID_PEDIDO, ID_DEVOLUCION, IMPORTE FROM DEVOLUCIONES_PEDIDOS WHERE ID_PEDIDO=" & pedido_seleccionado
			'RESPONSE.WRITE(.SOURCE)
			.Open
		end with

	

	
	'if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
	if ENTORNO="PROD" then
		'ENTORNO REAL
		entorno="REAL"
	  else
  		'ENTORNO PRUEBAS
	  	entorno="PRUEBAS"
	end if
		



	total_pedido=0
		
    'funcion para formatear:
    ' - a 2 decimales
    ' - con separadores de miles		
    ' - con el 0 delante de valores entre 0 y 1...

    Function formatear_importe(importe)
	       if importe<>"" then				
		    importe_formateado=FORMATNUMBER(importe,2,-1,,-1)
	          else
		    importe_formateado=""
	       end if
		
		    'response.write("<br><br>" & importe_formateado)

		    formatear_importe=importe_formateado
    End Function

%>


<html>
<head>
<meta charset="UTF-8">

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
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-touchspin-master/src/jquery.bootstrap-touchspin.css" />

	<script language="javascript" src="Funciones_Ajax.js"></script>
	
	<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script language="javascript">
var j$=jQuery.noConflict();
</script>

<style>

/*para que no se repita en cada pagina la cabecera de la tabla a la hora de imprimir
thead {
    display: table-header-group;
  }
*/
  
.solo_imprimible
{
display: none;
}

/*para controloar lo que se imprime y lo que no*/
@media print
{


body * { visibility: hidden; !important;  }
.contenido_imprimible * { visibility: visible; font-size:20px; !important; }
.contenido_imprimible { position: absolute; top: 40px; left: 5px; font-size:20px; !important; }
.no_imprimir, .no_imprimir * { display:none; !important;  }
.solo_imprimible, .solo_imprimible * { display:block;  }



/*.no_imprimir, .no_imprimir * { visibility: hidden; !important;  }*/
/*.no_imprimir_img, .no_imprimir_img * { display: none; !important;  }*/


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
		

.my-custom-dialog > .modal-dialog {
     width: 99% !important;
 }		
 
 
 /*para hacer que parpadee*/
 @keyframes blink {
  0% {
    opacity: 1;
  }
  50% {
    opacity: 0;
  }
  100% {
    opacity: 1;
  }
}

.blinking-badge {
  animation: blink 2s infinite; 
}

</style>

</head>
<body onload="ver_si_imprimir('<%=origen_seleccionado%>')">
<!--capa bultos y palets -->


  <div class="modal fade" id="pantalla_bultos_palets" data-backdrop="static" data-keyboard="false">	
    <div class="modal-dialog modal-dialog-centered">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <h4 class="modal-title" id="cabecera_pantalla_bultos_paletes">Palets, Bultos y Peso</h4>	    
        </div>	    
        <div class="container-fluid" id="body_bultos_palets">
			<br />
			<div class="row mt-2">
				<div class="col-12">
					<label class="control-label">Indique el N&uacute;mero de Bultos, el N&uacute;mero de Palets y el peso que tendr&aacute; la expedici&oacute;n...</label>
				</div>
			</div>
			<div class="row mt-4">
				<label class="col-6 control-label text-right">N&uacute;mero de Bultos:</label>
				<div class="col-4">
					<input id="spin_bultos" type="text" value="1" name="spin_bultos">
				</div>
			</div>
			<div class="row mt-4">
				<label class="col-6 control-label text-right">N&uacute;mero de Palets:</label>
				<div class="col-4">
					<input id="spin_palets" type="text" value="0" name="spin_palets">
				</div>
			</div>
			<div class="row mt-4">
				<label class="col-6 control-label text-right">Peso (en gramos):</label>
				<div class="col-4">
					<input id="spin_peso" type="text" value="0" name="spin_peso">
				</div>
			</div>
			<br />
		
		</div>	
        <div class="modal-footer">                  
		  <button type="button" class="btn btn-primary" id="cmdcontinuar_bultos_palets">Continuar</button>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa bultos y palets -->


<!-- capa nuevas plantillas -->
  <div class="modal fade" id="capa_nueva_plantilla">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	  
			<h4 class="modal-title" id="cabecera_nueva_plantilla"></h4>	    
			<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
        </div>	    
        <div class="modal-body">
          <form class="form-horizontal row-border">
            <div class="form-group">
              <!--
              <iframe id='gmv.iframe_movilidad' src="" width="100%" height="0" frameborder="0" transparency="transparency" onload="gmv.redimensionar_iframe(this);"></iframe>
              -->
              
              <iframe id='iframe_nueva_plantilla' src="" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe> 	
             </div>                  
          </form>
        </div> <!-- del modal-body-->     
        
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa nuevas plantillas -->    




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
			<div  class="contenido_imprimible">

			<div class="row mt-2"><!--datos del pedido-->
				<div class="card col-12">
					<div class="card-body">
						<div class="row">
							<div class="col-9">
								<h5 class="card-title">Datos del Pedido <%=pedido_seleccionado%></h5>
							</div>
							
							<div class="input-group mb-3 col-3">
								<select class="form-control input-sm" name="cmbestados_general" id="cmbestados_general" onchange="j$('#boton_cambiar_todos_los_combos').show()">
										<option value=""  selected="selected">Seleccionar Estado</option>
											<%if vacio_estados=false then %>
												<%for i=0 to UBound(mitabla_estados,2)
													if pedidos("PEDIDO_AUTOMATICO")="ROTULACION" AND mitabla_estados(CAMPO_ESTADO_ESTADO,i)="ENVIADO" then
												
														else
															if pedidos("PEDIDO_AUTOMATICO")<>"ROTULACION" AND mitabla_estados(CAMPO_ESTADO_ESTADO,i)="ENVIADO AL PROVEEDOR" then
															  else
																if mitabla_estados(CAMPO_ESTADO_ESTADO,i)<>"LISTO PARCIAL" AND mitabla_estados(CAMPO_ESTADO_ESTADO,i)<>"ENVIO PARCIAL" THEN%>
																	<option value="<%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%>"><%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%></option>
																  <%else%>
																	<option value="<%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%>" disabled><%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%></option>
																<%end if
															end if
													end if%>
												<%next%>
											<%end if%>
								</select>
								<script language="javascript">
									document.getElementById('cmbestados_general').value='<%=pedidos("estado_pedido")%>'
									if ('<%=pedidos("estado_pedido")%>'=='ENVIADO')
										{
										document.getElementById("cmbestados_general").disabled=true;
										}
								</script>
								<div class="input-group-append no_imprimir" id="boton_cambiar_todos_los_combos" style="display:none">
									<% if pedidos("estado_pedido")<>"ENVIADO" then%>
										<span class="input-group-text " id="basic-addon2" onclick="cambiar_todos_los_combos()"
											data-toggle="popover"
											data-placement="top"
											data-trigger="hover"
											data-content="actualizar los combos de estado de cada detalle"
											data-original-title="">
											<i class="fas fa-sync-alt"></i>
										</span>
									<%end if%>
								</div>
							</div>
							<%
							estado_general_pedido=pedidos("estado_pedido")
							'response.write("<br>" & estado_general_pedido)
							%>
						</div>
						

						<div class="card-deck">
							<div class="card col-6">
								<div class="card-body">
									Empresa:<strong>&nbsp;<%=pedidos("empresa")%></strong>
									<br/>Cliente:<strong>&nbsp;<%=pedidos("nombre")%></strong>
									<%if pedidos("codigo_externo")<>"" then%>
										&nbsp;(<%=pedidos("codigo_externo")%>)
									<%end if%>
									<br />Direcci&oacute;n:<strong>&nbsp;<%=pedidos("direccion")%></strong>
									<br />Poblaci&oacute;n:<strong>&nbsp;<%=pedidos("poblacion")%></strong>
									<br />C. P.:<strong>&nbsp;<%=pedidos("cp")%></strong>
									<br />Provincia:<strong>&nbsp;<%=pedidos("provincia")%></strong>
									<br />Tel.:<strong>&nbsp;<%=pedidos("telefono")%></strong>
									<br />Fax:<strong>&nbsp;<%=pedidos("fax")%></strong>
									<%if pedidos("ID_EMPRESA")=4 and pedidos("USUARIO_DIRECTORIO_ACTIVO")<>"" then
										nombre_empleado_gls=""
										set empleado_gls=Server.CreateObject("ADODB.Recordset")
										with empleado_gls
											.ActiveConnection=connimprenta
											.Source="SELECT NOMBRE, APELLIDOS FROM EMPLEADOS_GLS"
											.Source= .Source & " WHERE ID = " & pedidos("USUARIO_DIRECTORIO_ACTIVO") 
											.Open
										end with
										if not empleado_gls.EOF then
											nombre_empleado_gls= empleado_gls("NOMBRE") & " " & empleado_gls("APELLIDOS")
										end if
										%>
										<br />Usuario/Empleado: <%=nombre_empleado_gls%>
									  <%else%>
										<br />Usuario/Empleado: ( <%=pedidos("USUARIO_DIRECTORIO_ACTIVO")%>) <%=pedidos("NombreUsuario")%>
									<%end if%>
									
									<%IF pedidos("HORARIO_ENTREGA")<>"" and ("" & pedidos("DESTINATARIO")="") THEN%>
										<br />Horario de Entrega:&nbsp;<%=ucase(pedidos("HORARIO_ENTREGA"))%>
									<%END IF%>
								</div><!--del card-body-->
							</div><!--del card-->
							
							<%'si se ha puesto otra direccion de envio, muestro esta seccion
							if  pedidos("DESTINATARIO")<>"" then%>
								<div class="card col-6">
									<div class="card-body">
											<h4 class="card-title">Dirección de Envío</h4>
											Destinatario: <strong><%=ucase(pedidos("DESTINATARIO"))%></strong>

											<input type="hidden" name="ocultoemail" id="ocultoemail" value="<%=pedidos("email")%>" />
											<input type="hidden" name="ocultodestinatario" id="ocultodestinatario" value="<%=pedidos("DESTINATARIO_PERSONA_CONTACTO")%>" />
	
											<%if nombre_empleado_gls <> "" then%>
												<br />Att: <strong><%=ucase(nombre_empleado_gls)%></strong>
											<%end if%>
											<br />Dirección: <strong><%=ucase(pedidos("DESTINATARIO_DIRECCION"))%></strong>
											<br />Localidad: <strong><%=ucase(pedidos("DESTINATARIO_POBLACION"))%></strong>
											<br />C.P.: <strong><%=ucase(pedidos("DESTINATARIO_CP"))%></strong>
											<br />Provincia: <strong><%=ucase(pedidos("DESTINATARIO_PROVINCIA"))%></strong>
											<br />País: <strong><%=ucase(pedidos("DESTINATARIO_PAIS"))%></strong>
											<br />Teléfono: <strong><%=ucase(pedidos("DESTINATARIO_TELEFONO"))%></strong>
											<%IF pedidos("HORARIO_ENTREGA")<>"" THEN%>
												<br />Horario de Entrega: <strong><%=ucase(pedidos("HORARIO_ENTREGA"))%></strong>
											<%END IF%>
											<%IF pedidos("DESTINATARIO_PERSONA_CONTACTO")<>"" THEN%>
												<br />Persona de Contacto: <strong><%=ucase(pedidos("DESTINATARIO_PERSONA_CONTACTO"))%></strong>
											<%END IF%>
											<%IF pedidos("DESTINATARIO_COMENTARIOS_ENTREGA")<>"" THEN%>
												<br />Comentarios Entrega: <strong><%=ucase(pedidos("DESTINATARIO_COMENTARIOS_ENTREGA"))%></strong>
											<%END IF%>
									</div><!--del card-body-->
								</div><!--del card-->
							<%end if%>
						</div><!--del row-->								
					</div>
				</div>				

			</div><!-- row datos del pedido-->

			
			<div class="row mt-2"> <!--detalle del pedido-->
				<div class="card col-12">
					<div class="card-body">
						
						<div class="row no_imprimir">
							<div class="col-3">
								<table height="20" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td width="20"  style="border:1px solid #CCCCCC;background-color:#f8f8f8"></td>
										<td>&nbsp;Artículo Sin Control de Stock</td>
									</tr>
							  	</table>
							</div>
							<div class="col-3">
								<table height="20" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td width="20"  style="border:1px solid #CCCCCC;background-color:#3399CC"></td>
										<td>&nbsp;Artículo Con Control de Stock</td>
									</tr>
								</table>
							</div>
							<div class="col-4">
								<table height="20" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td width="20"  style="border:1px solid #CCCCCC;background-color:#FF6633"></td>
										<td>&nbsp;Artículo Por Debajo del Stock Mínimo</td>
									</tr>
								</table>
							</div>
							<div class="col-2">
								<table height="20" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td width="20"  style="border:1px solid #CCCCCC;background-color:#CCCCCC"></td>
										<td>&nbsp;Anulado</td>
									</tr>
							  	</table>
							</div>
						</div><!--del row de leyendas-->
						
						<form name="frmmodificar_pedido" id="frmmodificar_pedido" method="post" action="Modificar_Pedido_GAGAD.asp">
						<div>
							
								<input type="hidden" name="ocultopedido" id="ocultopedido" value="<%=pedido_seleccionado%>" />
								<input type="hidden" name="ocultoarticulos_cantidades_pedido" id="ocultoarticulos_cantidades_pedido"  value="" />
								<input type="hidden" name="ocultomarca" id="ocultomarca" value="<%=pedidos("marca")%>" />
								<input type="hidden" name="ocultoacciones" id="ocultoacciones" value="" />
								<input type="hidden" name="ocultocodcli" id="ocultocodcli" value="<%=pedidos("codcli")%>" />
	
								<!--7/15 a�adida direccion + POblacion + `CP-->
								<input type="hidden" name="ocultoDireccion" id="ocultoDireccion" value="<%=datos_para_envio%>" />
								<input type="hidden" name="ocultogastos_envio" id="ocultogastos_envio" value="<%=gastos_envio%>" />
								
								
								<input type="hidden" name="ocultobultos" id="ocultobultos" value="" />
								<input type="hidden" name="ocultopalets" id="ocultopalets" value="" />
								<input type="hidden" name="ocultopeso" id="ocultopeso" value="" />

								
								
								
								<div class="row mt-2">
									<div class="col-2">Pedido Num.: <strong><%=pedido_seleccionado%></strong></div>
									<div class="col-3">Fecha Petición: <strong><%=pedidos("fecha")%></strong></div>
									<%if ucase(estado_general_pedido)="ENVIADO" then%>
										<div class="col-3">Fecha Envío: <strong><%=pedidos("fecha_enviado")%></strong></div>
									<%end if%>
									<%if pedidos("PEDIDO_AUTOMATICO")<>"" then%>
										<%tipo_pedido_auto=pedidos("PEDIDO_AUTOMATICO")%>
										<div class="col-4">Pedido Automatico: <font color="#880000"><b><%=tipo_pedido_auto%></b></font></div>
									<%end if%>
								</div>
								
	
								<table id="lista_pedidos" name="lista_pedidos" class="table table-striped table-bordered" cellspacing="0" width="100%">
									<thead>
										<tr>
											<th>Cod. Sap</th>
											<th>Artículo</th>
											<th>Cant.</th>
											<th>Precio</th>
											<th>Total</th>
											<th>Estado</th>
											<th class="no_imprimir" >Hoja Ruta</th>
											<th class="no_imprimir" style="text-align:center"><i class="fas fa-paperclip"></i></th>
											<th class="no_imprimir">Alb.</th>
											<th class="no_imprimir" title="Fecha del Envio Programado">Envio Prog.</th>
										</tr>
									</thead>
									<%if pedidos.eof then%>
										<tr> 
											<td bgcolor="#999966" align="center" colspan="10"><br /><strong>El 
												Pedido No Tiene Articulos...</strong><br>
											</td>
										</tr>
									<%end if%>
												
									<%cadena_articulos_cantidades_pedido=""%>
									<%fila=1%>
									
									<%while not pedidos.eof%>
										<%albaran_asociado="" & pedidos("ALBARAN")%>
										<%'los meto con formato "articulo1::cantidad1::--articulo2::cantidad2::SI"
										if cadena_articulos_cantidades_pedido="" then
											cadena_articulos_cantidades_pedido=pedidos("articulo") & "::" & pedidos("cantidad") & "::" & pedidos("restado_stock")
											else
											cadena_articulos_cantidades_pedido=cadena_articulos_cantidades_pedido & "--" & pedidos("articulo") & "::" & pedidos("cantidad") & "::" & pedidos("restado_stock")
										end if
													
										'response.write("br>" & cadena_articulos_pedido)						
										'RESPONSE.WRITE("<BR> Articulo"+ CStr(pedidos("ID_ARTICULO")))
										if IsNull(pedidos("ID_ARTICULO")) then
											idArticulo = "0"
										else
											idArticulo = pedidos("ID_ARTICULO")
																						   
										 end if
										 %>
	
										<%'controlamos los stocks para mostrarlos y colorear las filas
										set articulos_marcas=Server.CreateObject("ADODB.Recordset")
										sql="SELECT V_CLIENTES_MARCA.MARCA, a.ID_ARTICULO, a.STOCK, a.STOCK_MINIMO"
										sql=sql & " FROM V_CLIENTES_MARCA LEFT JOIN"
										sql=sql & " (SELECT ARTICULOS_MARCAS.ID_ARTICULO, ARTICULOS_MARCAS.MARCA, ARTICULOS_MARCAS.STOCK, ARTICULOS_MARCAS.STOCK_MINIMO"
										sql=sql & " FROM ARTICULOS_MARCAS"
										'sql=sql & " WHERE ARTICULOS_MARCAS.ID_ARTICULO=" & pedidos("ID_ARTICULO") & ") as a"
											sql=sql & " WHERE ARTICULOS_MARCAS.ID_ARTICULO=" & idArticulo & ") as a"
										sql=sql & " ON V_CLIENTES_MARCA.MARCA = a.MARCA"
										sql=sql & " WHERE V_CLIENTES_MARCA.EMPRESA=" & pedidos("ID_EMPRESA")
										sql=sql & " ORDER BY V_CLIENTES_MARCA.MARCA"
																
										CAMPO_MARCA_ARTICULOS_MARCAS=0
										CAMPO_ID_ARTICULO_ARTICULOS_MARCAS=1
										CAMPO_STOCK_ARTICULOS_MARCAS=2
										CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS=3
										with articulos_marcas
											.ActiveConnection=connimprenta
											.Source=sql
											'RESPONSE.WRITE("<BR>" & .SOURCE)
											.Open
											vacio_articulos_marca=false
											if not .BOF then
												mitabla_articulos_marca=.GetRows()
												else
												vacio_articulos_marca=true
											end if
										end with
																
										articulos_marcas.close
										set articulos_marcas=Nothing
																
										if vacio_articulos_marca=false then 
											articulo_con_control_stock="NO"
											alerta_articulo_stock="NO"
											cadena_stocks=""
											cadena_stocks_minimos=""
											cadena_marcas=""
											for j=0 to UBound(mitabla_articulos_marca,2)
																
												if cadena_stocks="" then
													cadena_stocks=cadena_stocks & mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)
													else
													cadena_stocks=cadena_stocks & "--" & mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)
												end if
												if cadena_stocks_minimos="" then
													cadena_stocks_minimos=cadena_stocks_minimos & mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)
													else
													cadena_stocks_minimos=cadena_stocks_minimos & "--" & mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)
												end if
												if cadena_marcas="" then
													cadena_marcas=cadena_marcas & mitabla_articulos_marca(CAMPO_MARCA_ARTICULOS_MARCAS,j)
													else
													cadena_marcas=cadena_marcas & "--" & mitabla_articulos_marca(CAMPO_MARCA_ARTICULOS_MARCAS,j)
												end if
																		
												'ahora controlo de que color sale la fila
												if mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)<>"" or mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)<>"" then
													articulo_con_control_stock="SI"
													if mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)<>"" and mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)<>"" then
														if mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)<= mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j) then
															alerta_articulo_stock="SI"
														end if
													end if
																			
												end if
											next
										end if
										%>
																
									<tr style="background-color:#FCFCFC" valign="top">
										<%
										cadena_stock=""
										'response.write("<br>cadena stocks..." & cadena_stocks & "...")
										if cadena_stocks<>"" then
											a=Split(cadena_stocks,"--")
											cadena_stock="Stock: <strong>" & a(0) & "</strong><br>"
										end if
										if cadena_stocks_minimos<>"" then
											b=Split(cadena_stocks_minimos,"--")
											'response.write("<br>cadena stocks minimmos..." & cadena_stocks_minimos & "...")
											cadena_stock=cadena_stock & "Stock M&iacute;nimo: <strong>" & b(0) & "</strong><br>"
										end if
										%>
										<td id="fila_pedido_<%=fila%>_codigo_sap" align="right"
											<%if cadena_stock<>"" then%>
												data-toggle="popover"
												data-placement="top"
												data-trigger="hover"
												data-content="<%=cadena_stock%>"
												data-original-title=""
											<%end if%>
											>
											<%if pedidos("ID_EMPRESA")=1 then 'BARCEL� 
												carpeta_marca=pedidos("marca")&"/"
												else
												carpeta_marca=""
												end if
											%>
											<a href="Imagenes_Articulos/<%=carpeta_marca%><%=pedidos("ID_ARTICULO")%>.jpg" target="_blank">
												<font size="2" color="#000000"><%=pedidos("CODIGO_SAP")%></font>
											</a>
											<input type="hidden" class="id_articulo" id="oculto_id_articulo_<%=fila%>" name="oculto_id_articulo_<%=fila%>" value="<%=pedidos("articulo")%>" />
											<input type="hidden" class="pesos" id="ocultopeso_<%=pedidos("articulo")%>" name="ocultopeso_<%=pedidos("articulo")%>" value="<%=pedidos("PESO")%>" />
											
										</td>
										<td id="fila_pedido_<%=fila%>_descripcion" style="text-align:left">
											<span onclick="mostrar_articulo(<%=pedidos("ID_ARTICULO")%>, 'MODIFICAR')" style="cursor:pointer">
											<font size="2" color="#000000"
												data-toggle="popover"
												data-placement="top"
												data-trigger="hover"
												data-content="Acceso a la Ficha del Art&iacute;culo"
												data-original-title=""
												><%=pedidos("DESCRIPCION")%></font>
											<%
												unidades_pedido="" & pedidos("unidades_de_pedido")
												if unidades_pedido<>"" then%>
													<br /><font color="#000000">(en <%=unidades_pedido%>)</font>
												<%end if%>
											</span>
											<%
												'para los MULTISOBRE PREMIUM, muestro un aviso parpadeante junto a la descripcion
												Select Case pedidos("ID_ARTICULO")
													Case 4557, 4555, 4554, 4556
														Response.Write "<span class=""badge badge-warning blinking-badge"">PREMIUM</span>"
												End Select
											%>
											
											<%'29-06-2016...  comprobamos si ha de ser un articulo personalizable
												'y luego a�adimos a los campos ocultos el valor de la plantilla y si es personalizable o no
												articulo_personalizado="NO"
												plantilla_personalizacion= "" & pedidos("PLANTILLA_PERSONALIZACION")
												if plantilla_personalizacion<>"" THEN
													articulo_personalizado="SI"
												end if
												'response.write("<br>articulo_personalizado: " & articulo_personalizado)	
											
												if articulo_personalizado="SI" then
													carpeta_anno=""
													if pedidos("fecha")<>"" then
														carpeta_anno=year(pedidos("fecha"))
													end if
													pedido_modificar=pedidos("id")
													id=pedidos("articulo")
													cantidad=pedidos("cantidad")
													
													carpeta=""
													if pedidos("empresa")="ABBA HOTELES" OR pedidos("empresa")="BARCELO" then
														carpeta=""
													end if
													if pedidos("empresa")="BE LIVE" _ 
															OR pedidos("empresa")="HALCON" _  
															OR pedidos("empresa")="ECUADOR" _ 
															OR pedidos("empresa")="GROUNDFORCE" _
															OR pedidos("empresa")="AIR EUROPA" _
															OR pedidos("empresa")="CALDERON" _
															OR pedidos("empresa")="HALCON VIAGENS" _
															OR pedidos("empresa")="TRAVELPLAN" _
															OR pedidos("empresa")="TUBILLETE" _
															then
														carpeta="GAG/"
													end if
													
													if pedidos("empresa")="ATESA" then
														carpeta="ATESA/"
													end if
													if pedidos("empresa")="ASM" or pedidos("empresa")="GLS" then
														carpeta="GAG/"
													end if
													'-----9/6/16 ---
													if pedidos("empresa")="GEOMOON" then
														carpeta="GEO/"
													end if

													'para los kits parcelshop pueden venir personalizados o no segun el check
													if instr("-3765-3766-3767-3768-3769-3770-3771-3772-3773-3774-3775-3776-3777-3778-3779-3780-3781-3782-3783-3784-3785-3786-3787-3788-", _
																					"-" & pedidos("ID_ARTICULO") & "-")>0 then
															
														dim fs
														ruta_fichero_json=Request.ServerVariables("PATH_TRANSLATED")
														posicion=InStrRev(ruta_fichero_json,"\")
														ruta_fichero_json=left(ruta_fichero_json,posicion)
														ruta_fichero_json = ruta_fichero_json & carpeta & "pedidos\" & year(pedidos("fecha")) & "\" & pedidos("codcli") & "__" & pedido_modificar & "\json_" & pedidos("id_articulo") & ".json"
														'response.write("<br>fichero: " &ruta_fichero_json)
														set fs=Server.CreateObject("Scripting.FileSystemObject")
														'response.write("<br>existe el fichero: " & fs.FileExists(ruta_fichero_json))
														if fs.FileExists(ruta_fichero_json) then%>
															<span class="no_imprimir"
																data-toggle="popover"
																data-placement="top"
																data-trigger="hover"
																data-content="Plantilla Para Personalizar El Articulo"
																data-original-title=""
																>
																<i class="far fa-file-alt" style="cursor:pointer; color:green"
																onclick="mostrar_capas_new('capa_informacion', '<%=plantilla_personalizacion%>','<%=pedidos("codcli")%>', '<%=carpeta_anno%>', '<%=pedido_modificar%>', '<%=id%>', '<%=cantidad%>')" 
																></i>
															</span>
														<%end if%>
													  <%else%>
														<span class="no_imprimir"
															data-toggle="popover"
															data-placement="top"
															data-trigger="hover"
															data-content="Plantilla Para Personalizar El Articulo"
															data-original-title=""
															>
															<i class="far fa-file-alt" style="cursor:pointer; color:green"
															onclick="mostrar_capas_new('capa_informacion', '<%=plantilla_personalizacion%>','<%=pedidos("codcli")%>', '<%=carpeta_anno%>', '<%=pedido_modificar%>', '<%=id%>', '<%=cantidad%>')" 
															></i>
														</span>
													<%end if%>	
												
												
												<%end if 'de articulo_personalizado%>
											
											<%if pedidos("articulo") = "4583" then%>
												<div id="btnnumeros_serie_<%=pedidos("articulo")%>" name="btnnumeros_serie_<%=pedidos("articulo")%>" style="display:none">
													<span onclick="mostrar_sn_impresoras(<%=pedidos("cantidad")%>, '<%=pedidos("estado_articulo")%>')"
														data-toggle="popover"
														data-placement="top"
														data-trigger="hover"
														data-content="N�meros de Serie de La Impresora"
														data-original-title="">
															<i class="fas fa-barcode" style="color:#33FF00"></i>
													</span>
												</div>
												
												<%
												cadena_numeros_de_serie=""
												if pedidos("estado_articulo")="ENVIADO" then
													set impresoras_oficina=Server.CreateObject("ADODB.Recordset")
													with impresoras_oficina
														.ActiveConnection=connimprenta
														.Source="SELECT * FROM GLS_IMPRESORAS"
														.Source = .Source & " WHERE ID_PEDIDO =" & pedido_seleccionado
														'RESPONSE.WRITE(.SOURCE)
														.Open
													end with
													while not impresoras_oficina.eof
														if cadena_numeros_de_serie="" then
															cadena_insercion = impresoras_oficina("SN_IMPRESORA")
														  else
														 	cadena_insercion = "###" & impresoras_oficina("SN_IMPRESORA")
														end if
														cadena_numeros_de_serie = cadena_numeros_de_serie & cadena_insercion 
														impresoras_oficina.movenext
													wend
													impresoras_oficina.close
													set impresoras_oficina = Nothing
												%>
												
														<script language="javascript">
															j$("#btnnumeros_serie_4583").show()
														</script>
													
												<%end if%>
												
												<input type="hidden" id="ocultosn_impresoras" name="ocultosn_impresoras" value="<%=cadena_numeros_de_serie%>" />
											<%end if 'DEL ARTICULO 4583%>
										</td>
										<td class="cantidades" id="fila_pedido_<%=fila%>_cantidad" style="text-align:right;"><font size="2" color="#000000"><%=pedidos("cantidad")%></font></td>
										<td id="fila_pedido_<%=fila%>_precio_unidad" style="text-align:right" width="75"><font size="2" color="#000000"><%=pedidos("precio_unidad")%> &euro;/u</font>&nbsp;</td>
										<td id="fila_pedido_<%=fila%>_total" style="text-align:right">
											<font size="2" color="#000000">
														
												<%
												response.write(formatear_importe(pedidos("total")))
												'los detalles de pedido anulados no acumulan importe en el total del pedido
												if pedidos("estado_articulo")<>"ANULADO" then
													total_pedido=total_pedido + pedidos("total")
												end if
												%>
															
													€</font>&nbsp;
										</td>
										<td id="fila_pedido_<%=fila%>_estado">
											<div id="tabla_estado_<%=fila%>" style="width:100%">
														<select class="form-control form-control-sm cmbestado_detalle" name="cmbestados_<%=pedidos("articulo")%>" id="cmbestados_<%=pedidos("articulo")%>"  onchange="ver_estado('<%=pedidos("articulo")%>','<%=fila%>', 'COMBO')" oldvalue="<%=pedidos("estado_articulo")%>" >
														<%if vacio_estados=false then %>
															<%for i=0 to UBound(mitabla_estados,2)%>
																<%'fozamos a que la impresora de gls (4583) no se puedan envios parciales
																if pedidos("articulo")=4583 then
																	if mitabla_estados(CAMPO_ESTADO,i)<>"ENVIO PARCIAL" then%>
																		<option value="<%=mitabla_estados(CAMPO_ESTADO,i)%>"><%=mitabla_estados(CAMPO_ESTADO,i)%></option>
																	<%end if
																else
																	if pedidos("PEDIDO_AUTOMATICO")="ROTULACION" AND mitabla_estados(CAMPO_ESTADO_ESTADO,i)="ENVIADO" then
																		else
																			if pedidos("PEDIDO_AUTOMATICO")<>"ROTULACION" AND mitabla_estados(CAMPO_ESTADO_ESTADO,i)="ENVIADO AL PROVEEDOR" then
															  					else
																					%>
																					<option value="<%=mitabla_estados(CAMPO_ESTADO,i)%>"><%=mitabla_estados(CAMPO_ESTADO,i)%></option>
																			<%end if
																	end if
																end if%>
															<%next%>
															<!--A�ADO ESTE AL FINAL MANUALMENTE PORQUE ES UN ESTADO QUE SOLO PUEDE PONER LA IMPRENTA
															Y SOLO EN LOS DETALLES-->
															<option value="ANULADO">ANULADO</option>
														<%end if%>
														</select>
														<script language="javascript">
															document.getElementById("cmbestados_<%=pedidos("articulo")%>").value='<%=pedidos("estado_articulo")%>'
															//if ((document.getElementById("cmbestados_<%=pedidos("articulo")%>").value=='ENVIADO') && ('<%=pedidos("ALBARAN")%>'!=''))
															if (document.getElementById("cmbestados_<%=pedidos("articulo")%>").value=='ENVIADO')
																{
																document.getElementById("cmbestados_<%=pedidos("articulo")%>").disabled=true;
																}
															//j$("#cmbestados_<%=pedidos("articulo")%>").prop('oldvalue', '<%=pedidos("estado_articulo")%>');
														</script>
											</div>
											<%
											cantidad_enviada_total=""
											'si hay cantidad enviada previamente qu ela muestre, sea cual sea el estado
											'IF pedidos("estado_articulo")="ENVIO PARCIAL" THEN
											IF pedidos("CANTIDAD_ENVIADA")<>"" or pedidos("CANTIDAD_LISTA")<>"" THEN
												cantidad_envida_cartel="" & pedidos("CANTIDAD_ENVIADA")
												if cantidad_envida_cartel<>"" then
													cantidad_enviada_total=cdbl(cantidad_envida_cartel)
												end if
												'response.write("<br>primer cdbl")
												cantidad_lista_cartel= "" & pedidos("CANTIDAD_LISTA")
												if cantidad_lista_cartel <> "" then
													if cantidad_enviada_total="" then
														cantidad_enviada_total=cdbl(cantidad_lista_cartel)
													  else
													  	cantidad_enviada_total=cdbl(cantidad_enviada_total) + cdbl(cantidad_lista_cartel)
													end if
												end if
												'response.write("<br>segundo cdbl")
												%>
												<div id="fila_cantidad_enviada_parcial_<%=fila%>" align="center" style="width:100%">
													<font color="#000000">Cantidad ya Enviada:</font>
													<font color="#000000" size="3" style="cursor:pointer" onclick="mostrar_tabla_envios_parciales('<%=pedidos("articulo")%>')" title="Pulsar para mostrar/ocultar el detalle de envios"><b><%=pedidos("CANTIDAD_ENVIADA")%></b></font>
													
													<%if pedidos("CANTIDAD_LISTA")<>"" then%>
														<br />
														<font color="#000000">Cantidad Lista: </font>
														<font color="#000000" size="3" style="cursor:pointer" onclick="mostrar_tabla_envios_parciales('<%=pedidos("articulo")%>')" title="Pulsar para mostrar/ocultar el detalle de envios"><b><%=pedidos("CANTIDAD_LISTA")%></b></font>
													<%end if%>
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<img src="images/Eliminar.png" width="15" height="15" 
															class="no_imprimir"
															id="imagen_cancelar_<%=pedidos("articulo")%>"
															border=0 style="cursor:pointer;float:right;display:none"
															title="Cancelar"
															onclick="document.getElementById('txtcantidad_a_enviar_<%=pedidos("articulo")%>').value='';
	
																	document.getElementById('fila_envio_parcial_<%=pedidos("articulo")%>').style.display='none';
																	this.style.display='none';
																	document.getElementById('imagen_annadir_<%=pedidos("articulo")%>').style.display='block'"
															/>
														<img src="images/Annadir.png" width="15" height="15" 
															class="no_imprimir"
															id="imagen_annadir_<%=pedidos("articulo")%>"
															border=0 style="cursor:pointer;float:right;display:none"
															title="enviar mas cantidad de producto"
															onclick="ver_estado('<%=pedidos("articulo")%>','<%=fila%>', 'IMAGEN');
																	document.getElementById('imagen_annadir_<%=pedidos("articulo")%>').style.display='none'"
															/>
														<%IF pedidos("estado_articulo")="LISTO PARCIAL" OR pedidos("estado_articulo")="ENVIO PARCIAL" then%>
															<script language="javascript">
																document.getElementById('imagen_annadir_<%=pedidos("articulo")%>').style.display='block'
															</script>
														<%end if%>
												</div>
												
											
											<%
												set envios_parciales=Server.CreateObject("ADODB.Recordset")
		
												with envios_parciales
													.ActiveConnection=connimprenta
													.Source="SELECT CANTIDAD_ENVIADA, FECHA, PD.ALBARAN, AIR.* FROM PEDIDOS_ENVIOS_PARCIALES PD"
													.Source= .Source & " LEFT JOIN ALBARANES_AIRWILLBILL AIR ON AIR.ALBARAN = PD.ALBARAN"
													.Source= .Source & " WHERE ID_PEDIDO=" & PEDIDO_SELECCIONADO
													
													.Source= .Source & " AND ID_ARTICULO=" & pedidos("articulo")
													.Source= .Source & " ORDER BY PD.FECHA"
													'response.write("<br>" & .source)
													.Open
												end with
											
												IF not envios_parciales.eof then%>
													<table class="table table-sm no_imprimir"  border="0" cellspacing="0" cellpadding="0" id="tabla_envios_parciales_<%=pedidos("articulo")%>" style="display:none"  bgcolor="#FFFFFF">
														<tbody style="display:table; width:100%">
															<tr>
																<th>Fecha</th>
																<th>Cantidad</th>
																
															</tr>
															<%parciales_anteriores=0
															
																' Crear un array multidimensional
															Dim envioParcial()
															Dim i, numFields
															i = 0
															numFields = envios_parciales.Fields.Count 
															
															While not envios_parciales.eof
																
																ReDim Preserve envioParcial(numFields-1, i)
																' Guardar todos los campos del recordset en el array
																For j = 0 To numFields - 1
																	envioParcial(j, i) = envios_parciales(j) 
																Next																	
																i = i + 1
																%>
															
																<tr>
																	<td><%=envios_parciales("fecha")%></td>
																	<td align="center">
																		<%=envios_parciales("cantidad_enviada")%>
																		<%if envios_parciales("albaran")<>"" then%>
																			<img src="images/paper_16x16.png" 
																				border=0
																				title="Albar&aacute;n <%=envios_parciales("albaran")%>"
																				onclick="ver_albaran('<%=envios_parciales("albaran")%>', '<%=entorno%>')"
																				style="cursor:pointer"
																				/>
																		<%else
																			parciales_anteriores=cdbl(parciales_anteriores) + cdbl(envios_parciales("cantidad_enviada"))
																		end if%>
																	</td>
																	
																</tr>
															<%
																envios_parciales.movenext
															wend
															' Almacenar el valor en la sesión para usarlo en otras partes del código
																Session("envioParcial") = envioParcial%>

														</tbody>
													</table>
												<%end if
												'response.write("llegue a la 1191")
												'response.write("Esto es un Pedido parcial " & pedidos("estado_articulo"))
												envios_parciales.close
												set envios_parciales=Nothing
												%>
											<%end if%>
											<input type="hidden" class="ocultocantidad_enviada_total" id="ocultocantidad_enviada_total_<%=pedidos("articulo")%>" name="ocultocantidad_enviada_total_<%=pedidos("articulo")%>" value="<%=cantidad_enviada_total%>" />
											<div id="fila_envio_parcial_<%=pedidos("articulo")%>" name="fila_envio_parcial_<%=pedidos("articulo")%>" style="display:none;">
												<font color="#000000">Cantidad a Enviar:</font>
												<br />
												<input class="form-control form-control-sm cantidad_parcial" size="5" type="text" name="txtcantidad_a_enviar_<%=pedidos("articulo")%>" id="txtcantidad_a_enviar_<%=pedidos("articulo")%>" value="" anteriores="<%=parciales_anteriores%>"/>
												<input class="procedencia"  type="hidden" name="ocultoprocedencia_<%=pedidos("articulo")%>" id="ocultoprocedencia_<%=pedidos("articulo")%>" value=""/>
											</div>
											<div class="solo_imprimible hoja_ruta_print" id="fila_pedido_<%=pedidos("articulo")%>_hoja_ruta_print" style="padding-top:2px"></div>
											<div class="solo_imprimible albaran_print" id="fila_pedido_<%=pedidos("articulo")%>_albaran_print"></div>
										</td>
										<td class="no_imprimir" id="fila_pedido_<%=fila%>_hoja_ruta" style="text-align:right">
											<input class="form-control form-control-sm hoja_de_ruta" size="10" type="text" name="txthoja_ruta_<%=pedidos("articulo")%>" id="txthoja_ruta_<%=pedidos("articulo")%>" onkeypress="prueba()" value="" />
											<script language="javascript">
												document.getElementById("txthoja_ruta_<%=pedidos("articulo")%>").value='<%=pedidos("hoja_ruta")%>'
											</script>
										</td>
										<td class="no_imprimir" id="fila_pedido_<%=fila%>_fichero_personalizacion" >

											<% 'response.write(" llegue 1233  <br />") 

											cadena_airwaybill=cadena_airwaybille & "GAG/pedidos/" & year(pedidos("FECHA")) & "/" & pedidos("CODCLI") & "__" & pedido_seleccionado
											cadena_airwaybill=cadena_airwaybill & "/" & "Air_WayBill_" & pedidos("albaran") & "_" & pedidos("prefix") & "-" & pedidos("serial") & ".pdf" // nombre del Airwaybill
											'response.write(cadena_airwaybill)
											
											%>													

											<%if pedidos("serial") <> "" then%>
												
												<a href="<%=cadena_airwaybill%>" target="_blank" title="AirWayBill PDF"><i class="far fa-file-pdf"></i></a> 
									<% response.write("dinamilinkair  1245 ") %>			
												<a class='ml-2' id="dynamicLinkair_<%=pedidos("articulo")%>" onclick="mostrar_seguimiento('<%=pedidos("prefix")%>','<%=pedidos("serial")%>')">
												<img src="../images/Avion.png" title="AirWayBill" class="img-responsive"/></a> 
											
											
											<%ElseIf pedidos("estado_articulo")="ENVIO PARCIAL" Then%>
												<%if pedidos("serial") <> "" then%>
													<% response.write("ingrese al primer else 1247") %>	
													
													<a href="<%=cadena_airwaybill%>" target="_blank" title="AirWayBill PDF"><i class="far fa-file-pdf"></i></a> 
																				<% response.write("dinamilinkair  1255 ") %>						
													<a class='ml-2' id="dynamicLinkair_<%=pedidos("articulo")%>" onclick="mostrar_seguimiento('<%=pedidos("prefix")%>','<%=pedidos("serial")%>')">
													<img src="../images/Avion.png" title="AirWayBill" class="img-responsive"/></a> 

												<%else%>
													<% response.write("ingrese al else Envio Parcial 1260") %>
												<!--	<a id="fileLinkContainer_<%=pedidos("articulo")%>" target="_blank" href="#" title="AirWayBill PDF"></a> -->
													<a href="<%=cadena_airwaybill%>" target="_blank" title="AirWayBill PDF"><i class="far fa-file-pdf"></i></a>  
													<!-- <a class='ml-2' id="dynamicLink" href="#" style="display: none;"> -->
									<% response.write("dinamilink  1263") %>	
													<a class='ml-2' id="dynamicLink" href="#" style="display: none;">
													<img src="../images/Avion.png" title="AirWayBill" class="img-responsive"/></a> 	

												<%end if%>

												<!-- <a id="fileLinkContainer" target="_blank" href="<%=cadena_airwaybill%>" title="AirWayBill PDF"><i class="far fa-file-pdf"></i></a> -->
												<a id="fileLinkContainer_<%=pedidos("articulo")%>" target="_blank" href="#" title="AirWayBill PDF"></a> 
												<% response.write("PDF ")%>
											<!--<a href="<%=cadena_airwaybill%>" target="_blank" title="AirWayBill PDF"><i class="far fa-file-pdf"></i></a> -->
												<!-- <a class='ml-2' id="dynamicLink" href="#" style="display: none;"> -->
									<% response.write("dinamilink  1274") %>	
												<a class='ml-2' id="dynamicLink_<%=pedidos("articulo")%>" href="#" style="display: none;">
												<img src="../images/Avion.png" title="AirWayBill" class="img-responsive"/></a> 											

											<%else%>
												<% response.write("ingrese al ultimo else 1279") %>												
												<!--<a id="fileLinkContainer_<%=pedidos("articulo")%>" target="_blank" href="#" title="AirWayBill PDF"></a> -->
												<a id="fileLinkContainer" target="_blank" href="<%=cadena_airwaybill%>" title="AirWayBill PDF"><i id="pdf" class="far fa-file-pdf" style="display: none;"></i></a>
												<!-- <a class='ml-2' id="dynamicLink" href="#" style="display: none;"> -->
									<% response.write("dinamilink  1282") %>	
												<a class='ml-2' id="dynamicLink" href="#" style="display: none;">
												<img src="../images/Avion.png" title="AirWayBill" class="img-responsive"/></a> 
											<%end if%>

										
											<%
											if pedidos("fichero_personalizacion")<>"" then
												
												
												cadena_enlace=""
												if pedidos("empresa")="ABBA HOTELES" OR pedidos("empresa")="BARCELO" then
													cadena_enlace=""
												end if
												
												if pedidos("empresa")="BE LIVE" _ 
														OR pedidos("empresa")="HALCON" _  
														OR pedidos("empresa")="ECUADOR" _ 
														OR pedidos("empresa")="GROUNDFORCE" _
														OR pedidos("empresa")="AIR EUROPA" _
														OR pedidos("empresa")="CALDERON" _
														OR pedidos("empresa")="HALCON VIAGENS" _
														OR pedidos("empresa")="TRAVELPLAN" _
														OR pedidos("empresa")="TUBILLETE" _
														OR pedidos("empresa")="GEOMOON" _
														then
													cadena_enlace="GAG/"
												end if
												
												if pedidos("empresa")="ATESA" then
													cadena_enlace="ATESA/"
												end if
												if pedidos("empresa")="ASM" then
													cadena_enlace="GAG/"
												end if
												
												'if pedidos("empresa")="GEOMOON" then
												'	cadena_enlace="GEO/"
												'end if
															
												
												cadena_enlace=cadena_enlace & "pedidos/" & year(pedidos("FECHA")) & "/" & pedidos("CODCLI") & "__" & pedido_seleccionado
												cadena_enlace=cadena_enlace & "/" & pedidos("fichero_personalizacion")
												%>
												<a href="<%=cadena_enlace%>" target="_blank"><img src="images/clip-16.png" border=0/></a>
															
											<%end if%>
										</td>
										<td class="albaranes no_imprimir" id="fila_pedido_<%=fila%>_albaran" style="text-align:right;font-size:1;color:#000000">

										<input type="hidden" name="ocultoalbaran" id="ocultoalbaran" value="<%=pedidos("albaran")%>" />									
										
										<%if pedidos("albaran")<>"" then%>
											<div id="celda_albaran_<%=pedidos("articulo")%>" onclick="ver_albaran('<%=pedidos("albaran")%>', '<%=entorno%>')" style="text-decoration:none;color:#000000;cursor:pointer;cursor:hand">
												<%=pedidos("albaran")%>
											</div>
											<%	
																				
											If pedidos("codigo_ruc") <> "" Then											

												'response.write("RUC: " & pedidos("codigo_ruc") & "<br />")
												
												' If pedidos("estado_articulo")="ENVIO PARCIAL" Then
												' 	response.write("ingrese aca 1301")
												' end if
												
												Dim serialValue
												serialValue = pedidos("serial")											
												' Validar si serialValue es nulo o vacío
												If IsNull(serialValue) Or serialValue = "" Or serialValue = 0 Then
													if fila = 1 then %>												
														<a class='link link-info' id='openModal_<%=pedidos("albaran")%>' onclick="ver_modal('<%=serialValue%>')" title='Cargar Información Air WayBill'>
														<img src='../images/upload.png' alt='Cargar Información Air WayBill' class='img-responsive' />
														</a>
												<%	end if											
												End If
												'Else
												' Si codigo_ruc está vacío, no mostrar el enlace
												'response.write("RUC vacío. No se muestra el link. <br />")
											End If%>

											<%'response.write("Esto es un Pedido parcial " & pedidos("estado_articulo"))
											
											Dim numAlbaran
											numAlbaran = CStr(pedidos("albaran"))
											'response.write("Numero de Albaran " & numAlbaran & "<br>") %>

											<%'ElseIf pedidos("estado_articulo")="ENVIO PARCIAL" or  pedidos("estado_articulo")="ENVIADO" Then%>
										<%ElseIf pedidos("estado_articulo")="ENVIO PARCIAL" Then %>
										
												<%
													' Recuperar el array previamente almacenado
													Dim envio_Parcial
													envio_Parcial = Session("envioParcial") ' O usa remitos si no quieres usar la sesión

													
														Dim serialValues
															serialValues = pedidos("serial")		
													'response.write("Esto es un Pedido parcial " & pedidos("serial"))%>

											<%
												' Recorrer el array de albaranes parciales
												For i = 0 To UBound(envio_Parcial, 2)
													'response.write("Esto es un Pedido parcial " & envio_Parcial(i) & "<br>")
													'response.write("Esto es un albaran " & numAlbaran)
													Dim envioParcialAlbaran
													envioParcialAlbaran = CStr(envio_Parcial(2, i)) ' Convertir a cadena para asegurar compatibilidad

													' Comparar el albarán parcial con el albarán del pedido
													'If envioParcialAlbaran <> numAlbaran Then
														' Verificar si el serial está vacío o es nulo
														If IsNull(pedidos("serial")) Or pedidos("serial") = "" Or pedidos("serial") = 0 Then
											
															' Mostrar el albarán %>
															<div id="celda_albaran_parcial<%=envioParcialAlbaran%>" 
																onclick="ver_albaran('<%=envioParcialAlbaran%>', '<%=entorno%>')" 
																style="text-decoration:none;color:#000000;cursor:pointer;">
																<%=envioParcialAlbaran%>
															</div>
												<%		If envioParcialAlbaran <> numAlbaran Then %>
														<!-- Mostrar el ícono de upload solo si no hay serial -->
															<a class='link link-info' id='openModal_<%=envioParcialAlbaran%>' onclick="ver_modal(<%=serialValues%>)" title='Cargar Información Air WayBill'>
																<img src='../images/upload.png' alt='Cargar Información Air WayBill' class='img-responsive' />
															</a>
												<%		end if

														Else
															' El serial existe, por lo tanto no mostrar el ícono de upload
												%>
															<div id="celda_albaran_parcial<%=envioParcialAlbaran%>" 
																onclick="ver_albaran('<%=envioParcialAlbaran%>', '<%=entorno%>')" 
																style="text-decoration:none;color:#000000;cursor:pointer;">
																<%=envioParcialAlbaran%> (Con Serial)
															</div>
												<%
														End If
													'End If
												Next
												%>					



										<%end if%>
										</td>
										<td class="no_imprimir" id="fila_pedido_<%=fila%>_envio_programado" style="text-align:right"><font size="1" color="#000000">
											<%=pedidos("envio_programado")%>
										</font>&nbsp;</td>			
									</tr>
									
									<%'coloreo la fila si tiene control de stock o esta el detalle anulado
									color_fila=""
									
									if articulo_con_control_stock="SI" then
										if alerta_articulo_stock="NO" then
											color_fila="#3399CC"	'"#99CC99"   '"#66CC99"
										else
											color_fila="#FF6633"
										end if
									end if
									if pedidos("estado_articulo")="ANULADO" then
											color_fila="#CCCCCC"
									end if
									if color_fila<>"" then
									%>
										<script language="javascript">
											document.getElementById('fila_pedido_<%=fila%>_codigo_sap').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_descripcion').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_cantidad').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_precio_unidad').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_total').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_estado').style.backgroundColor='<%=color_fila%>'
											document.getElementById('tabla_estado_<%=fila%>').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_hoja_ruta').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_fichero_personalizacion').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_albaran').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_envio_programado').style.backgroundColor='<%=color_fila%>'
																	
										</script>
													
									<%end if%>
												
									<%
										pedidos.movenext
										fila=fila+1
									Wend
												
									%>
									
									<!--lineas de totales-->
									<tr>
										<th style="text-align:right" colspan="4">Total... </th>
										<th style="text-align:right"><%=formatear_importe(round(total_pedido,2))%> &euro;</th>
										<td colspan="5"></td>
									</tr>
									
									
									
									
									
									
									
									
									<%
									descuento_total_devoluciones=0
									datos_devoluciones=""
									if not devoluciones.eof then
										while not devoluciones.eof%>
											<tr>
												<th style="text-align:right" colspan="4"><font color="#880000">Devoluci&oacute;n <%=devoluciones("ID_DEVOLUCION")%> </font></th>
												<th style="text-align:right"><font color="#880000">-<%=FORMATNUMBER(devoluciones("IMPORTE"),2,-1,0,-1)%> �</font></th>
												<td colspan="5"></td>
											</tr>
											<%
											datos_devoluciones= datos_devoluciones & "@@@" & devoluciones("ID_DEVOLUCION") & "###" & devoluciones("IMPORTE")
											descuento_total_devoluciones=descuento_total_devoluciones + devoluciones("IMPORTE")
											devoluciones.movenext
										wend%>
										<tr>
											<th style="text-align:right" colspan="4">Total Descontando Devoluciones </th>
											<th style="text-align:right"><%=FORMATNUMBER((total_pedido - descuento_total_devoluciones),2,-1,0,-1)%> �</th>
											<td colspan="5"><input type="hidden" name="ocultodatos_devoluciones" id="ocultodatos_devoluciones" value="<%=datos_devoluciones%>" /></td>
										</tr>
									<%end if%>
									
									
									
									
										<%resultado_descuento=0%>
										<%if tipo_pedido_auto="PRIMER_PEDIDO_REDYSER" then%>
											<tr>
												<th style="text-align:right" colspan="4"><font color="#880000">Descuento Primer Pedido 50% (Max. 800�) </font></th>
												<th style="text-align:right"><font color="#880000">
													<%
													
													resultado_descuento = (total_pedido - descuento_total_devoluciones) * 0.50
													if resultado_descuento>800 then
														resultado_descuento=800
													end if
													resultado_descuento = round(resultado_descuento, 2)
													response.write(formatear_importe(resultado_descuento))
													%>
													�
													
													</font></th>
												<td colspan="5"></td>
											</tr>
											<tr>
												<th style="text-align:right" colspan="4">Total Precio Final</th>
												<th style="text-align:right">
													<%
													resultado_total_descuento = round((total_pedido - descuento_total_devoluciones - resultado_descuento), 2)
													response.write(formatear_importe(resultado_total_descuento))
													%>
													�
													</th>
												<td colspan="5"></td>
											</tr>
										<%end if%>										
										<%if tipo_pedido_auto="PRIMER_PEDIDO_GENERAL" then%>
											<tr>
												<th style="text-align:right" colspan="4"><font color="#880000">Descuento Primer Pedido 15% </font></th>
												<th style="text-align:right"><font color="#880000">
													<%
													
													resultado_descuento = (total_pedido - descuento_total_devoluciones) * 0.15
													resultado_descuento = round(resultado_descuento, 2)
													response.write(formatear_importe(resultado_descuento))
													%>
													�
													
													</font></th>
												<td colspan="5"><input type="hidden" name="ocultodescuento_pedido" id="ocultodescuento_pedido" value="<%=formatear_importe(resultado_descuento)%>" /></td>
											</tr>
											<tr>
												<th style="text-align:right" colspan="4">Total Precio Final</th>
												<th style="text-align:right">
													<%
													resultado_total_descuento = round((total_pedido - descuento_total_devoluciones - resultado_descuento), 2)
													response.write(formatear_importe(resultado_total_descuento))
													%>
													�
													</th>
												<td colspan="5"></td>
											</tr>
										<%end if%>										
										
									
										<%if  gastos_envio<>"" AND gastos_envio<>"0" then%>
											<tr>
												<th style="text-align:right" colspan="4"><font color="#880000">Gastos de Env&iacute;o</font></th>
												<th style="text-align:right"><font color="#880000"><%=FORMATNUMBER(gastos_envio,2,-1,0,-1)%> �</font></th>
												<td colspan="5"></td>
											</tr>
										  <%else
											gastos_envio=0
											%>
										<%end if%>	
																			
	
									<tr>
										<th style="text-align:right" colspan="4">IVA del 21% (<%=round(((total_pedido - descuento_total_devoluciones - resultado_descuento + gastos_envio) * 0.21),2)%>)</th>
										<th style="text-align:right">
											<%
											resultado_iva=((total_pedido - descuento_total_devoluciones - resultado_descuento + gastos_envio) * 0.21)
											iva_21= round(resultado_iva,2)
											response.write(formatear_importe(iva_21))
											%> 
											&euro;
										</th>
										<td colspan="5"></td>
													
									</tr>
									<tr>
										<th style="text-align:right" colspan="4">Total Importe a Pagar</th>
										<th style="text-align:right">
											<%
												total_pago_iva=(total_pedido - descuento_total_devoluciones - resultado_descuento + gastos_envio) + iva_21
															
												response.write(formatear_importe(round(total_pago_iva,2)))
											%> 
											&euro;
										</th>
										<td colspan="5"></td>
													
									</tr>
									
									<%
									descuento_total_saldos=0
									datos_saldos=""
									if not saldos.eof then
										while not saldos.eof
											if saldos("CARGO_ABONO")="CARGO" then
												color_saldo="red"
											  else
											  	color_saldo="green"
											end if%>
											<tr>
												<th style="text-align:right" colspan="4"><font color="<%=color_saldo%>">Saldo <%=saldos("ID_SALDO")%>&nbsp;-&nbsp;<%=UCASE(saldos("CARGO_ABONO"))%> </font></th>
												<th style="text-align:right"><font color="<%=color_saldo%>">
													<%if saldos("CARGO_ABONO")="CARGO" then
														response.write("+" & FORMATNUMBER(saldos("IMPORTE"),2,-1,0,-1) & " �")
													  else
													  	response.write("-" & FORMATNUMBER(saldos("IMPORTE"),2,-1,0,-1) & " �")
													  end if
													  %>
													
													</font></th>
												<td colspan="5"></td>
											</tr>
											<%
											'aqui metemos los datos de los saldos
											'formato entre saldos: @@@saldo1@@@saldo2@@@saldo3
											'formato dentro de cada saldo: saldo###importe###CARGO O ABONO
											datos_saldos= datos_saldos & "@@@" & saldos("ID_SALDO") & "###" & saldos("IMPORTE") & "###" & saldos("CARGO_ABONO")
											if saldos("CARGO_ABONO")="CARGO" then
												descuento_total_saldos=descuento_total_saldos - saldos("IMPORTE")
											  else
												descuento_total_saldos=descuento_total_saldos + saldos("IMPORTE")
											end if
											saldos.movenext
										wend%>
										<tr>
											<th style="text-align:right" colspan="4">Total Aplicado Saldos </th>
											<th style="text-align:right"><%=FORMATNUMBER((total_pago_iva - descuento_total_saldos),2,-1,0,-1)%> �</th>
											<td colspan="5"><input type="hidden" name="ocultodatos_saldos" id="ocultodatos_saldos" value="<%=datos_saldos%>" /></td>
										</tr>
									<%end if%>
									
									
																			


								</table>
									
							
						</div>
						
						
						<div class="row mt-2 no_imprimir">
							<div class="col-2 text-right">Observaciones:</div>
							<div class="col-10"><input type="text" class="form-control" style="width: 100%;"  id="txtobservaciones" name="txtobservaciones"/></div>
						</div>
						</form>
								
						<!-- botonera-->		
						<div class="row mt-2 no_imprimir">	
							<%if estado_general_pedido<>"ENVIADO" THEN%>
								<div class="col-4">
									<button type="button" class="btn btn-primary btn-block" id="cmdguardar_pedido" name="cmdguardar_pedido"
											onclick="guardar_pedido('<%=cadena_articulos_cantidades_pedido%>', 'GUARDAR')">
											<i class="far fa-save fa-2x"></i>&nbsp;&nbsp;&nbsp;Guardar
									</button>
								</div>
							<%end if%>
							<div class="col-4">
								<button type="button" class="btn btn-primary btn-block" id="cmdcrear_albaran" name="cmdcrear_albaran"
										onclick="guardar_pedido('<%=cadena_articulos_cantidades_pedido%>', 'ALBARAN')">
										<i class="far fa-clipboard fa-2x"></i>&nbsp;&nbsp;&nbsp;Crear Albar&aacute;n
								</button>
							</div>
							<div class="col-4">
								<button type="button" class="btn btn-primary btn-block" id="cmdimprimir" name="cmdimprimir"
										onclick="guardar_pedido('<%=cadena_articulos_cantidades_pedido%>', 'IMPRIMIR')">
										<i class="fas fa-print fa-2x"></i>&nbsp;&nbsp;&nbsp;Guardar e Imprimir
								</button>
							</div>
						</div>
								
					</div><!--del card-body-->
				</div><!--del card-->
			</div><!--del row de detalles del pedido-->
			
			</div><!--del row de contenido imprimible-->



			<!--historico de las observaciones del Pedido-->
			<div class="row mt-2 no_imprimir">
				<div class="card col-12">
					<div class="card-body">
						
						<h5 class="card-title">Hist&oacute;rico de Observaciones del Pedido</h5>
						<div class="row mt-2">							
							<table id="lista_historico_pedido" name="lista_historico_pedido" class="table table-bordered" cellspacing="0" width="100%">
								<thead>
									<tr>
										<th>Fecha</th>
										<th>Hora</th>
										<th>Observaciones</th>
									</tr>
									<%if vacio_observaciones=false then %>
										<%for i=0 to UBound(mitabla_observaciones,2)%>
											<tr>
												<td><%=mitabla_observaciones(CAMPO_FECHA_OBSERVACIONES,i)%></td>
												<td><%=mitabla_observaciones(CAMPO_HORA_OBSERVACIONES,i)%></td>
												<td><%=mitabla_observaciones(CAMPO_OBSERVACIONES_OBSERVACIONES,i)%></td>
											</tr>
										<%next%>
									<%end if%>
								</thead>
							</table>		
						</div>						
						
						
					</div><!--del card-body-->
				</div><!--del card-->
			</div><!--del row-->
			<!--fin historico de las Observaciones del Pedido-->
						
		</div><!--del content-fluid-->
	</div><!--fin de content-->
</div><!--fin de wrapper-->


<form name="frmalbaran" id="frmalbaran" method="post" action="" target="_blank">
</form>

<form name="frmmostrar_articulo" id="frmmostrar_articulo" action="Ficha_Articulo_GAGAD.asp" method="post" target="_blank">
	<input type="hidden" value="" name="ocultoid_articulo" id="ocultoid_articulo" />
	<input type="hidden" value="" name="ocultoaccion" id="ocultoaccion" />
	<input type="hidden" value="<%=cadena_consulta_excel%>" name="ocultocadena_consulta" id="ocultocadena_consulta" />
	<input type="hidden" value="" name="ocultoempresas" id="ocultoempresas" />
	<input type="hidden" value="" name="ocultofamilias" id="ocultofamilias" />
	<input type="hidden" value="" name="ocultoautorizacion" id="ocultoautorizacion" />
	
</form>

 <!-- Modal Air WAYBILL-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="myModalLabel">Cargar Información AIR WAYBILL</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form id="uploadForm" enctype="multipart/form-data">
					 	<div class="form-group">
                            <label for="prefix">Nº Prefix</label>
                            <input type="text" class="form-control" id="prefix" name="prefix" required
                                   pattern="\d*" maxlength="5" oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                        </div>
                        <div class="form-group">
                            <label for="serial">Nº Serial</label>
                            <input type="text" class="form-control" id="serial" name="serial" required
                                   pattern="\d*" maxlength="9" oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                        </div>						
							<label for="archivo">Adjuntar Air WayBill</label>
						<!-- <input type="file" class="form-control" id="archivo" name="archivo" required accept=".pdf, .txt, .docx"> -->
							<input type="file" class="form-control" id="archivo" name="archivo" required accept=".pdf">
						</div>
						<button type="submit" class="btn btn-primary">Cargar</button>
					</form>
				</div>
			</div>
		</div>
	</div>	
	

<script type="text/javascript" src="js/comun.js"></script>

	
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

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

<script type="text/javascript">

		
j$(document).ready(function () {
	j$("#menu_pedidos").addClass('active')
	
	j$('#sidebarCollapse').on('click', function () {
		j$('#sidebar').toggleClass('active');
		j$(this).toggleClass('active');
	});
	
	
	//j$('[data-toggle="popover"]').popover({html:true});
	j$('[data-toggle="popover"]').popover({html:true, container: 'body'});
	
	
	j$("#spin_bultos").TouchSpin({
		min: 1,
		max: 500,
		verticalbuttons: true
	});

	j$("#spin_palets").TouchSpin({
		min: 0,
		max: 500,
		verticalbuttons: true
	});
	j$("#spin_peso").TouchSpin({
		min: 0,
		max: 5000000,
		verticalbuttons: true
	});
   


    j$('#uploadForm').submit(function(e) {
        e.preventDefault();
		// Obtener los valores del modal al cargar la página
		var prefix = j$('#prefix').val();
		var serial = j$('#serial').val();		
		  
        var codcli = j$('#ocultocodcli').val();
        var pedido = j$('#ocultopedido').val();
        var albaran = j$('#ocultoalbaran').val();

		let email = j$('#ocultoemail').val();
		let nombre_apellido = j$('#ocultodestinatario').val();
		
		console.log(email);
		//console.log(ocultodestinatario);

        var formData = new FormData(this);
		formData.append('cod_cli', codcli);
        formData.append('num_pedido', pedido);
        formData.append('num_albaran', albaran);	
        formData.append('email', email);	
        formData.append('nombre_apellido', nombre_apellido);	

        j$.ajax({
            url: '/PHP/Air_waybill/upload_airwaybill.php', // HA DESARROLLAR
            type: 'POST',
            data: formData, 
            processData: false,
            contentType: false,
            success: function(response) {
                var result = JSON.parse(response);
                console.log(result);
                j$('#myModal').modal('hide');
                if (result.status === 'exists') {
                    if (confirm(result.message)) {
                        formData.append('overwrite', true);
                        j$.ajax({
                            url: '/PHP/Air_waybill/upload_airwaybill.php', // HA DESARROLLAR
                            type: 'POST',
                            data: formData,
                            processData: false,
                            contentType: false,
                            success: function(response) {
								console.log(' response 2º ',response);
                                handleUploadResponse(response);
                            }
                        });
                    }
                } else {
                    handleUploadResponse(response);
                }
            },
            error: function() {
                alert('Error al enviar los datos');
            }
        });

		// Construir la URL dinámica		
		var url = 'http://www.aireuropacargo.com/index.asp?prefix=' + prefix + '&serial=' + serial;

		// Asignar la URL al enlace y mostrarlo
		j$('#dynamicLink').attr('href', url);		
		j$('#dynamicLink').show();
		
		j$('#pdf').show();

		j$('#dynamicLink').click(function(event) {
		event.preventDefault();		
			if (confirm("¿Estás seguro de querer ir a esta página?")) {
				//window.location.href = j$(this).attr('href');
				window.open(url, '_blank');
			} 
		});
    });
});

// Crear link físico del archivo Air Waybill
function handleUploadResponse(response) {
	
    var result = JSON.parse(response);
    if (result.status === 'success') {
       // alert('Datos enviados correctamente');		
        j$('#myModal').modal('hide');
       // var fileLink = '<a href="' + result.fileUrl + '" target="_blank"><img src="../images/Paper_Verde_16x16.png" alt="AirWayBill" class="img-responsive"/></a>'; <i class="far fa-file-pdf"></i>
        var fileLink = '<a href="' + result.fileUrl + '" target="_blank"><i class="far fa-file-pdf"></i></a>'; 
        j$('#fileLinkContainer').html(fileLink);
		j$('#openModal').hide(); // Ocultar el botón de subir archivo	
    } else {
        alert('Error: ' + result.message);
    }
}

		
function ver_si_imprimir(origen)
{
		//ponemos la hoja de ruta y el albaran debajo del estado cuando se imprime
		j$('.hoja_ruta_print').each(function(){
				//fila_pedido_<%=fila%>_hoja_ruta_print
				nombre_control=j$(this).attr('id')
				nombre_control=nombre_control.replace('fila_pedido_', '')
				nombre_control=nombre_control.replace('_hoja_ruta_print', '')
                j$(this).html('H.R.: ' + j$('#txthoja_ruta_' + nombre_control).val())
				if (j$('#txthoja_ruta_' + nombre_control).val()=='')
					{
					j$(this).hide()
					}
            });
		j$('.albaran_print').each(function(){
				//fila_pedido_<%=fila%>_hoja_ruta_print
				nombre_control=j$(this).attr('id')
				//console.log('nombre_control: ' + nombre_control)
				nombre_control=nombre_control.replace('fila_pedido_', '')
				//console.log('nombre_control: ' + nombre_control)
				nombre_control=nombre_control.replace('_albaran_print', '')
                //console.log('nombre_control: ' + nombre_control)
				//console.log('html albaran: ' + j$('#celda_albaran_' + nombre_control).html())
				j$(this).html('Albar&aacute;n: ' + j$('#celda_albaran_' + nombre_control).html())
				objeto_comprobar = document.getElementById('celda_albaran_' + nombre_control)
				if (typeof objeto_comprobar !== "undefined" && objeto_comprobar !== null)
					{
					j$(this).html('Albar&aacute;n: ' + j$('#celda_albaran_' + nombre_control).html())
					}
				  else
				  	{
				  	j$(this).hide()
					}
            });
		if (origen=='MODIFICAR_IMPRIMIR')
		{
		window.print()
		window.onafterprint = function(event) {
	    	window.location.href = 'Consulta_Pedidos_GAGAD.asp'
			}
		}
	
}
	

function mostrar_capas_new(capa, plantilla, cliente, anno_pedido, pedido, articulo, cantidad)
{
	texto_campos=''
	if (plantilla=='plantilla_a01')
		{
		fichero_plantilla='Plantilla_Personalizacion_con_adjunto.asp'
		plantilla_personalizacion=plantilla
		}
	  else
	  	{
		if (plantilla.indexOf('plantilla_rotulacion_1')>=0)
			{
			parametros_rotulacion=plantilla.split('##')
			fichero_plantilla='Plantilla_Personalizacion_Rotulacion.asp'
			plantilla_personalizacion=parametros_rotulacion[0]
			texto_campos='&campos=' + parametros_rotulacion[1]
			}
		  else
		  	{
			if (plantilla.indexOf('plantilla_rotulacion_3')>=0)
				{
				parametros_rotulacion=plantilla.split('##')
				fichero_plantilla='Plantilla_Personalizacion_Rotulacion_3.asp'
				plantilla_personalizacion=parametros_rotulacion[0]
				texto_campos='&campos=' + parametros_rotulacion[1]
				}
			  else			  
			  	{
				if (plantilla.indexOf('plantilla_rotulacion_4')>=0)
					{
					parametros_rotulacion=plantilla.split('##')
					fichero_plantilla='Plantilla_Personalizacion_Rotulacion_4.asp'
					plantilla_personalizacion=parametros_rotulacion[0]
					texto_campos='&campos=' + parametros_rotulacion[1]
					}
				  else
				  	{
					fichero_plantilla='Plantilla_Personalizacion.asp'
					plantilla_personalizacion=plantilla
					}
				}
			}
		}
	
	texto_querystring='?plant=' + plantilla_personalizacion + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad + '&modo=CONSULTAR&carpeta=GAG' + texto_campos
		
	url_iframe='Plantillas_Personalizacion/' + fichero_plantilla + texto_querystring
	
	
	
	j$("#cabecera_nueva_plantilla").html('Plantilla a Rellenar');
    
    j$('#iframe_nueva_plantilla').attr('src', url_iframe)
    j$("#capa_nueva_plantilla").modal("show");
}


function guardar_pedido(cadena_articulos_cantidades, accion){
    //console.log('dentro de guardar pedido...')
	//console.log('cadena articulos cantidades: ' + cadena_articulos_cantidades)
	//alert('cadena articulos: ' + cadena_articulos)
    //alert('cadena articulos: ' + document.getElementById('ocultito').value)
    //document.getElementById('ocultopedido').value=document.getElementById('ocultito').value
    //alert('cadena a tratar: ' + cadena_articulos_cantidades)
	
	if (accion == 'ALBARAN')
		{
		j$('#cmdcrear_albaran').prop('disabled', true);
		}
    tabla_articulos_cantidades=cadena_articulos_cantidades.split('--')
    //alert('tama�o de elementos: ' + tabla_articulos_cantidades.length)
	texto_error=''
    permitir_guardar_pedido='SI'
	pendientes_articulos_listos='NO'
	articulos_para_enviar='NO'
	
    for (i=0;i<tabla_articulos_cantidades.length;i++)    {
	    //alert('segunda cadena a tratar: ' + tabla_articulos_cantidades[i])
	    articulo_cantidad=tabla_articulos_cantidades[i].split('::')
	
	    //alert('valor de txthoja_ruta_' + articulo_cantidad[0] + ': ' + document.getElementById('txthoja_ruta_' + articulo_cantidad[0]).value)
	    //alert('valor de cmbestados_' + articulo_cantidad[0] + ': ' + document.getElementById('cmbestados_' + articulo_cantidad[0]).value)	
	    //pongo esto porque si no se pierde el estado en la siguiente pagina
	    document.getElementById('cmbestados_' + articulo_cantidad[0]).disabled=false;
	    /*    ya no es obligatorio poner la hoja de ruta en cada articulo del pedido
	    if ((document.getElementById('cmbestados_' + articulo_cantidad[0]).value!='SIN TRATAR') && (document.getElementById('cmbestados_' + articulo_cantidad[0]).value!='RECHAZADO'))
		    {
			    if (document.getElementById('txthoja_ruta_' + articulo_cantidad[0]).value=='')
				    {
					    permitir_guardar_pedido='NO'
				    }
		    }
	    */
		//controlamos que si se selecciona el envio parcial se haya introducido la cantidad a enviar
		//console.log('articulo: ' + articulo_cantidad[0])
		//console.log('fila_envio_parcial_' + articulo_cantidad[0] + ': ' + document.getElementById('fila_envio_parcial_' + articulo_cantidad[0]).value)
		//console.log('cmbestados_' + articulo_cantidad[0] + ': ' + document.getElementById('cmbestados_' + articulo_cantidad[0]).value)
		//console.log('txtcantidd_a_enviar_' + articulo_cantidad[0] + ': ' + document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value)
		//console.log('contenido de txtcantidad_a_enviar_' + articulo_cantidad[0] + ': ' + document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value)
		//console.log('display de txtcantidad_a_enviar_' + articulo_cantidad[0] + ': ' + document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).style.display)
		//console.log('display de fila_envio_parcial_' + articulo_cantidad[0] + ': ' + document.getElementById('fila_envio_parcial_' + articulo_cantidad[0]).style.display)
		
		
		if ( ((document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='LISTO PARCIAL') ||(document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='ENVIO PARCIAL')) && (document.getElementById('fila_envio_parcial_' + articulo_cantidad[0]).style.display=='block') && (document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value==''))
			{
			permitir_guardar_pedido='NO'
			texto_error=texto_error + '\n     - En Los Envios Parciales de Articulos, se ha de indicar la cantidad enviada.'
			}

		//console.log('vemos si es un envio parcial y si tiene cantidad enviada para:')
		//console.log('cmbestados_' + articulo_cantidad[0] + ': ' + document.getElementById('cmbestados_' + articulo_cantidad[0]).value)
		//console.log('txtcantidad_a_enviar_' + articulo_cantidad[0] + ': ' + document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value)

		if ( ((document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='LISTO PARCIAL')||(document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='ENVIO PARCIAL')) && (document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value!=''))
		    {
				//console.log('comprobamos si nos pasamos de la cantidad enviada')
				total_a_enviar=articulo_cantidad[1]
				cantidad_ya_enviada=document.getElementById('ocultocantidad_enviada_total_' + articulo_cantidad[0]).value
				if (cantidad_ya_enviada=='')
					{
					cantidad_ya_enviada=0
					}
				cantidad_a_enviar=document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value
				if (cantidad_a_enviar=='')
					{
					cantidad_a_enviar=0
					}
				//console.log('total_a_enviar: ' + total_a_enviar)
				//console.log('cantidad_ya_enviada: ' + cantidad_ya_enviada)
				//console.log('cantidad_a_enviar: ' + cantidad_a_enviar)
				//console.log('suma cantidad ya enviada + cantidad a enviar: ' + (parseInt(cantidad_ya_enviada) + parseInt(cantidad_a_enviar)))
				
				if (parseInt(total_a_enviar) < (parseInt(cantidad_ya_enviada) + parseInt(cantidad_a_enviar)))
					{
					//console.log('la cantidad a enviar supera lo que falta por enviar de ese producto')
					permitir_guardar_pedido='NO'
					texto_error=texto_error + '\n     - Falta Por Enviar Menos Cantidad de La Que Se Indica.'
					}
			    
		    }

		//console.log('valor antiguo del comobo del articulo ' + articulo_cantidad[0] + ': ' + j$('#cmbestados_' + articulo_cantidad[0]).attr('oldvalue'))
		//compruebo que lo que se quiere enviar no supere el stock existente	
		if ((document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='LISTO PARCIAL') || (document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='LISTO')
					||(document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='ENVIO PARCIAL') || (document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='ENVIADO'))
			{
			
			//console.log('*************************')
			//console.log('controlamos el stock es un listo, listo parcial, enviado o enviado parcial')
			stock_buscado=''
			valor_combo_nuevo=''
			valor_combo_antiguo=''
			valor_combo_nuevo=document.getElementById('cmbestados_' + articulo_cantidad[0]).value
			valor_combo_antiguo=j$('#cmbestados_' + articulo_cantidad[0]).attr('oldvalue')
			//console.log('....valor combo nuevo: ' + valor_combo_nuevo)
			//console.log('....valor combo antiguo: ' + valor_combo_antiguo)
			
			
			j$.ajax({
				type: "post",        
				async:false,    
				cache:false, 
				url: 'Obtener_Stock_Ficha_Articulo.asp?q=' + articulo_cantidad[0],
				success: function(respuesta) {
							  //console.log('el stock es de: ' + respuesta)
							//console.log('....STOCK DEL ARTICULO ' + articulo_cantidad[0] + ': ' + respuesta)  
							stock_buscado=respuesta
							},
				error: function() {
							//console.log('error al ver el stock del articulo ' + articulo_cantidad[0])
							alert('error al ver el stock del articulo ' + articulo_cantidad[0])
					}
			});
				
			cantidad_control=''
			if ((valor_combo_nuevo=='LISTO PARCIAL') || (valor_combo_nuevo=='ENVIO PARCIAL'))
				{
				cantidad_control=document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value
				}
			  else
				{
				if ( ((valor_combo_nuevo=='LISTO')||(valor_combo_nuevo=='ENVIADO')) && ((valor_combo_antiguo=='LISTO PARCIAL')||(valor_combo_antiguo=='ENVIO PARCIAL')) )
					{
					cantidad_ya_enviada=document.getElementById('ocultocantidad_enviada_total_' + articulo_cantidad[0]).value
					//cantidad_a_enviar=document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value
					//console.log('....CANTIDAD ya enviada DEL ARTICULO ' + articulo_cantidad[0] + ': ' + cantidad_ya_enviada) 
					//console.log('....CANTIDAD solicitada DEL ARTICULO ' + articulo_cantidad[0] + ': ' + articulo_cantidad[1]) 
					cantidad_control=articulo_cantidad[1] - cantidad_ya_enviada
					}
				  else
				  	{
					cantidad_control=articulo_cantidad[1]
					}
				}
				
			//console.log('....CANTIDAD A ENVIAR DEL ARTICULO ' + articulo_cantidad[0] + ': ' + cantidad_control) 
			//console.log('....propiedad olvalue de cmbestados_' + articulo_cantidad[0] + ': ' + valor_combo_antiguo)
			//console.log('....valor combo nuevo cmbestados_' + articulo_cantidad[0] + ': ' + valor_combo_nuevo)
			
			codigo_referencia=''
			j$('#cmbestados_' + articulo_cantidad[0]).closest("tr").find("td:first-child a:first-child font:first-child").each(function(){
                codigo_referencia+=j$(this).html();
            });
 
            //console.log('....codigo de referencia: ' + codigo_referencia);
			
			//console.log('VALOR COMBO ANTOIGUO DEL ARTICULO a comparar ' + articulo_cantidad[0] + ': ' + valor_combo_antiguo)  
			//console.log('VALOR COMBO NUEVO DEL ARTICULO a comparar ' + articulo_cantidad[0] + ': ' + valor_combo_nuevo)  
			//console.log('STOCK DEL ARTICULO a comparar ' + articulo_cantidad[0] + ': ' + stock_buscado)  
			//console.log('CANTIDAD DEL ARTICULO a comparar ' + articulo_cantidad[0] + ': ' + cantidad_control) 
			
			//si lo ponemos en enviado desde otro estado, comprobamos que haya stock disponible
			if ((valor_combo_nuevo!=valor_combo_antiguo) || (valor_combo_nuevo=='LISTO PARCIAL') || (valor_combo_nuevo=='ENVIO PARCIAL'))
				{
					//console.log('...........entramos en el if')  
					
						if (parseFloat(stock_buscado)<parseFloat(cantidad_control))
							{
								permitir_guardar_pedido='NO'
								texto_error=texto_error + '\n     - Para el Artículo (' + codigo_referencia + ') Solo se Puede Enviar Como M�ximo ' + stock_buscado + ' Unidades, que es Su Stock Actual...'
								//console.log('::::::::::::::::::::::CADENA ERROR DEL ARTICULO a comparar ' + articulo_cantidad[0] + ': ' + texto_error)  
							}
				}
			} //FIN if ENVIO PARCIAL o ENVIADO
		
		if ((accion=='ALBARAN') && ((document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='LISTO') || (document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='LISTO PARCIAL')) )
			{
			pendientes_articulos_listos='SI'
			} 
			
		if ((accion=='GUARDAR' || accion=='IMPRIMIR') && ((document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='ENVIADO') || (document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='ENVIO PARCIAL')) )
			{
			//console.log('*********************')
			//console.log('guardamos porque el combo esta ENVIADO O EN ENVIO PARCIAL')
			//console.log('*********************')
			//console.log('el combo cmbestados_' + articulo_cantidad[0] + ' tiene el estaddo de: ' + document.getElementById('cmbestados_' + articulo_cantidad[0]).value + ' y su anterior valor era: ' + j$('#cmbestados_' + articulo_cantidad[0]).attr('oldvalue'))
			if ( (j$('#cmbestados_' + articulo_cantidad[0]).attr('oldvalue')!='ENVIADO') && (j$('#cmbestados_' + articulo_cantidad[0]).attr('oldvalue')!='ENVIO PARCIAL') )
			  	{
				//console.log('----no dejamos guardar... tiene que crear albaran')
				articulos_para_enviar='SI'
				}
			  else
				if ((j$('#cmbestados_' + articulo_cantidad[0]).attr('oldvalue')=='ENVIO PARCIAL') && (document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value!=''))
					{
					//console.log('----no dejamos guardar... esta haciendo otro envio parcial, tiene que crear albaran')
					articulos_para_enviar='SI'
					}	
					
				if ((j$('#cmbestados_' + articulo_cantidad[0]).attr('oldvalue')=='ENVIO PARCIAL') && (document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='ENVIADO'))
					{
					//console.log('----no dejamos guardar... esta haciendo un envio, tiene que crear albaran')
					articulos_para_enviar='SI'
					}				  
			  
			} 	
		//console.log('EL VALOR DE ARTICULOS PARA ENVIAR AHORA ES: ' + articulos_para_enviar)
				
    }
	
	if (pendientes_articulos_listos=='SI')
		{
			permitir_guardar_pedido='NO'
			texto_error=texto_error + '\n     - No se Puede Generar el Albar&aacute;n, todavia siguen en Listo o Listo Parcial algunos art&iacute;culos.'
		}
	if (articulos_para_enviar=='SI')
		{
			permitir_guardar_pedido='NO'
			texto_error=texto_error + '\n     - Para Pasar los Articulos a Enviado o Envio Parcial, se ha de hacer desde el bot&oacute;n que Genera el Albar&aacute;n.'
		}
	
	//si se envia alguna impresora, que compruebe si se han introducido los numeros de serie primero
	if (j$('.id_articulo[value="4583"]').length && (j$('select#cmbestados_4583').val() === 'ENVIADO' || j$('select#cmbestados_4583').val() === 'ENVIO PARCIAL')) {
  		if (j$("#ocultosn_impresoras").val()=='')
			{
			permitir_guardar_pedido='NO'
			texto_error=texto_error + '\n     - Si se Envian Impresoras de GLS ha de introducir sus N&uacute;mero de Serie.'
			}
	
	}
	
	
	if (permitir_guardar_pedido=='SI')
	{
	    document.getElementById('ocultoarticulos_cantidades_pedido').value=cadena_articulos_cantidades
	    //alert('hola')
	    document.getElementById('ocultoacciones').value=accion
		// ahora se muestra la ventana de bultos palets y peso tanto al guardar como al crear albaran
		if (accion=='ALBARAN')
			{
			controlar_bultos_palets(<%=pedido_seleccionado%>)
			}
		  else
		  	{ //en este caso, solo si hay detalles en listo o listo parcial, tiene que mostrar lo de los bultos, palets y peso
			si_listo='NO'
			j$('.cmbestado_detalle').each(function(index, obj){
				if (j$(obj).val()=='LISTO' || j$(obj).val()=='LISTO PARCIAL')
					{
					si_listo='SI'
					}
			});
			
			if (si_listo=='SI')
				{
				controlar_bultos_palets(<%=pedido_seleccionado%>)	
				}
			  else
			  	{
			    document.getElementById('frmmodificar_pedido').submit()
				}
			}
		
		
		
	}
  else
  	{
	    //alert('Para gestionar el Pedido, Han de indicarse las Hojas de Ruta de los Articulos Tratados')
		alert(texto_error)
		
		//dejo los combombos de enviados inhabilitados
		j$('.cmbestado_detalle').each(function(){
                if ( (j$(this).val()=='ENVIADO') && (j$(this).attr('oldvalue')=='ENVIADO') )
					{
					j$(this).attr('disabled', true)
					}
            });
			
		j$('#cmdcrear_albaran').prop('disabled', false);
	}
}// guardar_pedido --


function ver_estado(articulo, fila, origen)
{
//console.log('ha cambiado el combo del articulo: ' + articulo)
//console.log('valores del combo... Valor: ' + j$('#cmbestados_' + articulo).val() + ' valor antiguo: ' + j$('#cmbestados_' + articulo).attr('oldvalue'))

document.getElementById('txtcantidad_a_enviar_' + articulo).value=''
j$("#ocultoprocedencia_" + articulo).val('')

//si estamos cambiando el combo de la impresora gls
if (articulo==4583)
	{
	if ((document.getElementById('cmbestados_' + articulo).value=='ENVIADO')|| (document.getElementById('cmbestados_' + articulo).value=='ENVIO PARCIAL'))
		{
		j$("#btnnumeros_serie_" + articulo).show()
		}
	  else
	  	{
		j$("#btnnumeros_serie_" + articulo).hide()
		}
	}
	
	
if ((document.getElementById('cmbestados_' + articulo).value=='LISTO PARCIAL')|| (document.getElementById('cmbestados_' + articulo).value=='ENVIO PARCIAL'))
	{
	//como muchos objetos se crean o no en funcion de lo que se cargue, compruebo primero
	// que el objeto existe
	//document.getElementById('fila_cantidad_enviada_parcial_' + fila).style.display='none'
	if (document.getElementById('fila_envio_parcial_' + articulo))
		{
		if ((j$('#cmbestados_' + articulo).val()=='ENVIO PARCIAL') && (j$('#cmbestados_' + articulo).attr('oldvalue')=='LISTO PARCIAL') )
			{
			document.getElementById('fila_envio_parcial_' + articulo).style.display='none'
			document.getElementById('txtcantidad_a_enviar_' + articulo).value=''
			j$("#ocultoprocedencia_" + articulo).val('LISTO')
			//console.log('volcamos oculto las unidades que se envian: ' + j$("#txtcantidad_a_enviar_" + articulo).attr('anteriores'))
			}
		  else
		  	{
			document.getElementById('fila_envio_parcial_' + articulo).style.display='block'
			}
		}
	
	if (document.getElementById('imagen_cancelar_' + articulo))	
		{
		if ((j$('#cmbestados_' + articulo).val()=='ENVIO PARCIAL') && (j$('#cmbestados_' + articulo).attr('oldvalue')=='LISTO PARCIAL') )
			{
			document.getElementById('imagen_cancelar_' + articulo).style.display='none'
			}
		  else
		  	{
			document.getElementById('imagen_cancelar_' + articulo).style.display='block'
			}
		}
	if (origen!='COMBO')
		{
		if (document.getElementById('imagen_annadir_' + articulo))	
			{
			document.getElementById('imagen_annadir_' + articulo).style.display='block'
			}
		}
	}
  else
  	{
	if (document.getElementById('fila_envio_parcial_' + articulo))
		{
		document.getElementById('fila_envio_parcial_' + articulo).style.display='none'
		}
	if (document.getElementById('imagen_cancelar_' + articulo))
		{
		document.getElementById('imagen_cancelar_' + articulo).style.display='none'
		}
	if (document.getElementById('imagen_annadir_' + articulo))	
		{
		document.getElementById('imagen_annadir_' + articulo).style.display='none'
		}
	}

}


function mostrar_tabla_envios_parciales(articulo)
{
	if (document.getElementById('tabla_envios_parciales_' + articulo).style.display=='none')
		{
		document.getElementById('tabla_envios_parciales_' + articulo).style.display='block'
		}
	  else
	  	{
		document.getElementById('tabla_envios_parciales_' + articulo).style.display='none'
		}
}


function mostrar_seguimiento(prefixair, serialair) {
//alert('esta llegando ' + serialair +'  ' + prefixair);
//alert(prefixair + ' - ' + serialair )
// 	// Construir la URL dinámica
	var urlair = 'http://www.aireuropacargo.com/index.asp?prefix=' + prefixair + '&serial=' + serialair;

// 	// Asignar la URL al enlace y mostrarlo
//$('#dynamicLinkair').attr('href', urlair); // Cambié j$ por $
//$('#dynamicLinkair').show();

// 	$('#dynamicLinkair').click(function(event) {
// 		event.preventDefault();
// 		if (confirm("¿Estás seguro de querer ir a esta página?")) {
// 			// Abrir la URL en una nueva ventana/pestaña
	window.open(urlair, '_blank');
// 		}
// 	});
}


  /* -- Modal Air WAYBILL -- */
function ver_modal(num_albaran) {
     //  e.preventDefault();
        j$('#myModal').modal('show');
    //});
}
	

function ver_albaran(numero, entorno)
{

	//document.getElementById('frmalbaran').action='http://192.168.153.132/Albagrafic/default.aspx?codigo_albaran=' + numero
	//document.getElementById('frmalbaran').action='http://192.168.150.97/Albagrafic/default.aspx?codigo_albaran=' + numero+'&act=0';
	
	//nueva aplicacion de Albaranes
	if (entorno=='REAL')
		{//entorno real
		//document.getElementById('frmalbaran').action='http://intranet.halconviajes.com/GlAlbaran/Glalbaran.aspx?codigo_albaran=' + numero;
		document.getElementById('frmalbaran').action='GlAlbaran/Glalbaran.aspx?codigo_albaran=' + numero;
		
		}
	  else
		{//entorno de pruebas
		document.getElementById('frmalbaran').action='GlAlbaran/Glalbaran.aspx?codigo_albaran=' + numero;
		}
	//alert(document.getElementById('frmalbaran').action)
	document.getElementById('frmalbaran').submit()
	//alert('EN CONSTRUCCION...')
}

function controlar_bultos_palets(num_pedido)
{
	j$.ajax({
			type: "POST",         
			async:false,    
			cache:false, 
			dataType: 'json',
			url: "tojson/Obtener_Palets_Bultos_Peso_Envio.asp",
			data: {pedido: num_pedido},
			success:
				function (data) {
					//console.log('valor devuelto: ' + data)
					//console.log('valor devuelto: ' + data[0])
					//console.log('valor devuelto palet: ' + data.PALETS)
					//console.log('valor devuelto BULTOS: ' + data.BULTOS)
					//console.log('valor devuelto PESO: ' + data.PESO)
					//console.log('valor devuelto ALBARAN: ' + data.ALBARAN)
					poner_bultos=data.BULTOS
					if (data.BULTOS=='0')
						{
						poner_bultos='1'
						}
					j$("#spin_peso").val(data.PESO)
					j$("#spin_bultos").val(poner_bultos)
					j$("#spin_palets").val(data.PALETS)

				},
			error:
				function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
	}); // $.ajax({

	//tenga informacion o no el campo peso importado, calculo siempre el peso
	//if ( (j$("#spin_peso").val()=='') || (j$("#spin_peso").val()=='0') )
		{	
			suma_pesos=0
			j$('.pesos').each(function(index, obj){
				
				//hoja_de_ruta=j$(obj).closest("tr").find(".hoja_de_ruta").val()
				//console.log('pesos...' + j$(obj).val() + '...')
				if (j$(obj).val()!='')
					{
					estado_comprobacion=j$(obj).closest("tr").find(".cmbestado_detalle").val()
					if ( (estado_comprobacion=='LISTO') || (estado_comprobacion=='LISTO PARCIAL') || (estado_comprobacion=='ENVIADO') || (estado_comprobacion=='ENVIO PARCIAL') )
						{
						hay_albaran=j$(obj).closest("tr").find(".albaranes").text().replace(/\s+/g,' ' ).replace(/^\s/,'').replace(/\s$/,'')
						//console.log('albaranes: +++' + hay_albaran + '+++')
						
						cantidades_enviadas=0
						//si no tiene albaran todavia, se tiene que sumar los pesos
						if (hay_albaran=='')
							{
							//esto habra que tenerlo en cuenta
							if ( (estado_comprobacion=='LISTO PARCIAL') || (estado_comprobacion=='ENVIO PARCIAL') )
								{
								valor_cant=0
								valor_cant_acumulado=0
								if (j$(obj).closest("tr").find(".cantidad_parcial").val()!='')
									{
									valor_cant=parseFloat(j$(obj).closest("tr").find(".cantidad_parcial").val())
									}
								if (j$(obj).closest("tr").find(".cantidad_parcial").attr('anteriores')!='')
									{
									valor_cant_acumulado=parseFloat(j$(obj).closest("tr").find(".cantidad_parcial").attr('anteriores'))
									}
								
								
								//console.log('cantidades acumuladas...' + j$(obj).closest("tr").find(".cantidad_parcial").attr('anteriores') + '...')
								cantidades_enviadas=parseFloat(valor_cant) + parseFloat(valor_cant_acumulado)
								}
							  else
							  	{
								if ( (estado_comprobacion=='LISTO') || (estado_comprobacion=='ENVIADO') )
									{
									//console.log('el estado es: ' + estado_comprobacion)
									if (j$(obj).closest("tr").find(".ocultocantidad_enviada_total").val()=='')
										{
										//console.log('NO hay oculto cantidad enviada PREVIA...')
										cantidades_enviadas=j$(obj).closest("tr").find(".cantidades").html()
										}
									  else
									  	{
										//hay que calcular las cantidades sin que tengan albaran
										acumulado_anterior=0
										//console.log('hay oculto cantidad enviada previa: ' + j$(obj).closest("tr").find(".ocultocantidad_enviada_total").val())
										//console.log('parametro del txt cantidad a enviar con los envios anteriroes: ' + j$(obj).closest("tr").find(".cantidad_parcial").attr('anteriores'))
										if (j$(obj).closest("tr").find(".ocultocantidad_enviada_total").val()!='')
											{
											acumulado_anterior=parseFloat(j$(obj).closest("tr").find(".ocultocantidad_enviada_total").val()) - parseFloat(j$(obj).closest("tr").find(".cantidad_parcial").attr('anteriores'))
											}
										//console.log('y se lo restamos del valor total de la cantidad: ' + j$(obj).closest("tr").find(".cantidades").html())
										cantidades_enviadas=parseFloat(j$(obj).closest("tr").find(".cantidades").html()) - parseFloat(acumulado_anterior)
										
										/*
										if (parseFloat(j$(obj).closest("tr").find(".cantidad_parcial").attr('anteriores'))>0)
											{
											cantidades_enviadas=parseFloat(j$(obj).closest("tr").find(".cantidad_parcial").attr('anteriores'))
											}
										  else
										  	{
											cantidades_enviadas=parseFloat(j$(obj).closest("tr").find(".cantidades").html()) - parseFloat(acumulado_anterior)
											}
										*/
										
										
										//console.log('nos queda una cantidad a enviar: ' + cantidades_enviadas)
										}
									}
								
								}	
							
							
							//console.log('cantidades listas...' + cantidades_enviadas + '...')
							suma_pesos+=parseFloat(j$(obj).val()) * parseFloat(cantidades_enviadas)
							}
						}
					}
				//console.log('total pesos...' + suma_pesos + '...')

			});
			j$("#spin_peso").val(suma_pesos)
		
		} //fin del if del peso a 0 o '' que ahora esta quitado

	//de momneto que no salga
	//ya se a�adir�n
	//j$("#pantalla_bultos_palets").modal("show");
	j$("#ocultobultos").val('');
	j$("#ocultopalets").val('');
	j$("#ocultopeso").val('');
		
	j$("#frmmodificar_pedido").submit()
}

j$('#cmdcontinuar_bultos_palets').on('click', function () {
		j$("#pantalla_bultos_palets").modal("hide");
		
		//console.log('bultos: ' + j$("#spin_bultos").val())
		//console.log('palets: ' + j$("#spin_palets").val())
		//console.log('peso: ' + j$("#spin_peso").val())
		
		j$("#ocultobultos").val(j$("#spin_bultos").val());
		j$("#ocultopalets").val(j$("#spin_palets").val());
		j$("#ocultopeso").val(j$("#spin_peso").val());
		
		j$("#frmmodificar_pedido").submit()
	});
	

cambiar_todos_los_combos = function(){
	j$('.cmbestado_detalle').each(function(index, obj){
		puedo_cambiar='SI'
		hoja_de_ruta=j$(obj).closest("tr").find(".hoja_de_ruta").val()
		//console.log('hoja ruta: ...' + hoja_de_ruta + '...')
		if (hoja_de_ruta!='')
			{
			puedo_cambiar='NO'
			}
		if (j$(obj).val()=='ANULADO')
			{
			puedo_cambiar='NO'
			}
		if (j$(obj).val()=='ENVIADO')
			{
			puedo_cambiar='NO'
			}
		if (j$(obj).val()=='ENVIO PARCIAL')
			{
			puedo_cambiar='NO'
			}
			
		//console.log('puedo_cambiar: ' + puedo_cambiar )	
		if (puedo_cambiar=='SI')
			{
			j$(obj).val(j$('#cmbestados_general').val())
			}
	});
};

/*NO SE IMPRIME DIRECTAMENTE SE HACE DES LA FUNCION DE GUARDAR PEDIDO
j$('#cmdimprimir').click(function(){
     //j$("#contenido_imprimible").print();
	 window.print()
});
*/

mostrar_articulo = function (articulo, accion) 
   {
   	//alert('hotel: ' + hotel + ' accion: ' + accion)
   	document.getElementById('ocultoid_articulo').value=articulo
	document.getElementById('ocultoaccion').value=accion
	document.getElementById('ocultoempresas').value='Sin Filtro'
	document.getElementById('ocultofamilias').value='Sin Filtro'
	document.getElementById('ocultoautorizacion').value='Sin Filtro'
	document.getElementById('frmmostrar_articulo').action='Ficha_Articulo_GAGAD.asp'	

   	document.getElementById('frmmostrar_articulo').submit()	
   }
   
prueba = function() {
  console.log( "Handler for .keypress() called." );
  ver_si_imprimir()
};


mostrar_sn_impresoras = function (cantidad, estado)
{
	var botones = {}
	
	if (estado== 'ENVIADO')
		{
			botones = {
			  cancel: {
				label: "Cerrar",
				className: "btn-secondary",
				callback: function() {
				  j$(".sn_impresoras").val("");
				  bootbox.hideAll();
				}
			  }
			}
		}
	  else
	  	{
		botones = {
			  cancel: {
				label: "Cancelar",
				className: "btn-secondary",
				callback: function() {
				  j$(".sn_impresoras").val("");
				  bootbox.hideAll();
				}
			  },
			  borrar: {
				label: "Borrar",
				className: "btn-danger",
				callback: function() {
				  j$(".sn_impresoras").val("");
				  return false;
				}
			  },
			  ok: {
				label: "Aceptar",
				className: "btn-primary",
				callback: function() {
				  var valid = true;
				  var size14 = true;
				  var valores_sin_repetir = []
				  var valor_repetido = ''
				  var impresoras_activas = false
				  j$(".sn_impresoras").each(function() {
					if (j$(this).val().trim() == "") {
					  valid = false;
					  return false;
					  }
					else
						{
						//la longitud del numero de serie por lo que parece es de 14 caracteres
						if (j$(this).val().trim().length != 14)
							{
							size14=false;
							return false;
							}
						  else
						  	{
							valor_a_comprobar=j$(this).val().trim()
							if (valores_sin_repetir.includes(valor_a_comprobar))
								{
								valor_repetido=valor_a_comprobar
								return false
								}
							valores_sin_repetir.push(valor_a_comprobar)
							}
						}
				  });

				  if (valor_repetido !='')
				  	{
					bootbox.alert({message: "<h5>El N�mero de Serie " + valor_repetido + " est� repetido.</h5>", centerVertical: true, size: "large"});
					return false;
					}
				  if (!size14) {
					bootbox.alert({message: "<h5>La Longitud del Numero de Serie no es de 14 caracteres.</h5>", centerVertical: true, size: "large"});
					return false;
				  }
				  
				  if (!valid) {
					bootbox.alert({message: "<h5>Introduzca valores en todas las cajas de texto.</h5>", centerVertical: true, size: "large"});
					return false;
				  }
				  var serials = [];
				  j$(".sn_impresoras").each(function() {
					serials.push(j$(this).val().trim());
				  });
				  if (serials.length > 0) 
					{
					cadena_sn_impresoras = serials.join("###")
					}
					
				  //veo si las impresoras ya est�n previamente dadas de alta y asociadas a alguna otra oficina
				  j$.ajax({
						type: "POST",         
						async:false,    
						cache:false, 
						dataType: 'json',
						url: "tojson/Obtener_Impresoras_GLS_sn-estado.asp",
						data: {sn_impresoras: cadena_sn_impresoras},
						success:
							function (data) {
								impresoras_consultadas=data.REGISTROS
								cadena_mensaje_impresoras=''
								impresoras_consultadas.forEach(function(registro) {
								  var numero_serie = registro.sn_impresora;
								  var estado = registro.estado;
								  if (estado!= 'BAJA')
								  	{
									cadena_mensaje_impresoras += 'La Impresora ' + numero_serie + ' no se puede enviar porque todavia est� Activa.<br>'
									}
								});
								
								if (cadena_mensaje_impresoras!='')
									{
									impresoras_activas=true
									}
								
			
							},
						error:
							function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
					}); // $.ajax({				
				  
				  if (impresoras_activas) {
					bootbox.alert({message: '<h5>' + cadena_mensaje_impresoras + '</h5>', centerVertical: true, size: "large", className: "my-custom-dialog"});
					return false;
				  }
				  
				  
				  j$("#ocultosn_impresoras").val(cadena_sn_impresoras)
				  
				  //console.log(serials);
				  //console.log('numeros de serie del oculto impresoras: ' + j$("#ocultosn_impresoras").val())
				}
			  }
			}
		}
	
	
	cadena_sn_impresoras = ''
	impresoras_previas = 0
	if (j$("#ocultosn_impresoras").val()!='')
		{
		array_impresoras_previas = j$("#ocultosn_impresoras").val().split('###')
		impresoras_previas = array_impresoras_previas.length
		}
	
	console.log('impresoras_previas: ' + impresoras_previas)
	
	if (typeof array_impresoras_previas !== "undefined") {
		console.log('contenido array de serials')
		for (var i = 0; i < array_impresoras_previas.length; i++) {
 			 console.log('elemento ' + i + ': ' + array_impresoras_previas[i]);
		}	
	}

      if (isNaN(cantidad) || cantidad <= 0) {
		bootbox.alert({message: "<h5>Introduzca una cantidad v�lida.</h5>", centerVertical: true, size: "large"});
        return;
      }
      var html = '<div id="divSerials">';
      for (var i = 1; i <= cantidad; i++) {
        html += '<div class="form-group">';
        html += '<label for="txtserial' + i + '">Numero de Serie Impresora ' + i + ':</label>';
        html += '<input type="text" id="txtserial' + i + '" class="form-control sn_impresoras"'
		if ((impresoras_previas > 0) && (impresoras_previas >= i))
			{
			html += ' value="' + array_impresoras_previas[i - 1] + '"'
			}
		if (estado=='ENVIADO')	
			{
			html += ' readonly';
			}
		html += ' />';
        html += '</div>';
      }
      html += '</div>';
      bootbox.dialog({
        title: "N&uacute;meros de Serie de las Impresoras",
        message: html,
        closeButton: false,
        buttons: botones //en funcion de si los carga o hay que insertarlos muestra unos botones u otros
      });
    
}

</script>

</body>
<%
	'articulos.close
	saldos.close
	devoluciones.close
	connimprenta.close
	
	
	set articulos=Nothing
	set clientes=Nothing
	set saldos=Nothing
	set devoluciones=Nothing
	set connimprenta=Nothing

%>
</html>
