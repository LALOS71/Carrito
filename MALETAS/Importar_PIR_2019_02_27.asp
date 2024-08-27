<%@ language=vbscript%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->

<%
	if session("usuario")="" then
		response.Redirect("Login.asp")
	end if
%>
<html>



<head>


	<title>Importar PIRs</title>
	

	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/media/css/dataTables.bootstrap.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/extensions/Buttons/css/buttons.dataTables.min.css">
  
	<link rel="stylesheet" type="text/css" href="plugins/font-awesome-4.7.0/css/font-awesome.min.css">

	<style>
		body { padding-top: 70px; }
		
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
  




	

    </head>
<body 
<%if session("perfil_usuario")<>"ADMINISTRADOR" then%>
		onload="location.href='Consulta_Incidencias.asp'"
<%end if%>

>

<!--#include file="menu.asp"-->

<script language="javascript">
var j$=jQuery.noConflict();

j$(document).ready(function () {
	var pathname = window.location.pathname;
	
	posicion=pathname.lastIndexOf('/')
	pathname=pathname.substring(posicion + 1,pathname.length)
	
	//para que se seleccione la opcion de menu correcta
	j$('.nav > li > a[href="'+pathname+'"]').parent().addClass('active');
});
</script>

<%

Response.Buffer = TRUE

Set xmlhttp = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")

lResolve = 50 * 1000  'Resolve timeout in milliseconds
lConnect = 50 * 1000  'Connect timeout in milliseconds
lSend    = 20 * 1000  'Send timeout in milliseconds
lReceive = 560 * 1000 'Receive timeout in milliseconds 
xmlhttp.setTimeouts lResolve, lConnect, lSend, lReceive
'xmlhttp.setTimeouts 5000, 60000, 10000, 10000

%>

<div class="container-fluid">
	<div class="col-sm-8 col-md-8 col-lg-8">
		<div class="panel-group"  role="tablist" aria-multiselectable="true">
			<div class="panel panel-primary">
				<div class="panel-heading" role="tab" >
					<h3 class="panel-title">Proceso de Importaci&oacute;n</h3>
					
				</div>
				
				<div class=" panel-body panel-collapse" role="tabpanel">
				
					<div width="95%">
						<%
						fecha_inicial=""
						fecha_actual=""
						
						'se recojen los pirs como mucho de hasta el dia de ayer... los de hoy se recogen mañana....
						'fecha_actual=date()
						fecha_actual=DateAdd("d", -1, date())
						
						'response.write("<br><br>fecha actual ORIGINAL: " & fecha_actual)
						
						
						
						set ultima_fecha=Server.CreateObject("ADODB.Recordset")
						with ultima_fecha
							.ActiveConnection=connmaletas
							.Source="SELECT DISTINCT TOP 1 FECHA_FICHERO_IMPORTACION FROM PIRS ORDER BY 1 DESC"
							.Open
							'response.write("<br>tipos precios: " & sql)
							if not .eof then
								fecha_inicial="" & ultima_fecha("FECHA_FICHERO_IMPORTACION")
							end if
						end with
						ultima_fecha.close
						set ultima_fecha=Nothing
						
						'response.write("<br><br>fecha inicial ORIGINAL: " & fecha_inicial)
						%>
						
						<p class="h4">&Uacute;ltima Fecha Importada: <%=fecha_inicial%></p>
						<%
						if fecha_inicial="" then
							fecha_inicial=cdate("01-01-2019")
						  'else
							'fecha_inicial=DateAdd("d", 1, fecha_inicial)
							
						end if
						
						'response.write("<br><br>fecha inicial CAMBIADA: " & fecha_inicial & " ...... fecha final CAMBIADA: " & fecha_actual)
						
						'fecha_inicial=cdate("27-06-2012")
						'fecha_inicial=cdate("01-01-2013")
						'fecha_actual=cdate("31-12-2014")
						'fecha_inicial=cdate("01-02-2019")
						
						fecha_ciclo=fecha_inicial
						dias=datediff("d", fecha_inicial, fecha_actual)
						'response.write("<br><br>fecha inicial DEFINITIVA: " & fecha_inicial & " ...... fecha final DEFINITIVA: " & fecha_actual & " ---- intervalo dias: " & dias)
						%>
						
						<p class="h4">Intervalo de Fechas a Importar: Del <%=fecha_inicial%> al <%=fecha_actual%> (<%=dias%> d&iacute;as)</p>
					</div>
					
				</div>
			</div>
		</div><!--el panel-->
	</div>

	<div class="col-sm-12 col-md-12 col-lg-12">

		<%
		'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
		' de fecha con mes-dia-año
		connmaletas.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
		
		
		for fechas=0 to dias
			'PRODUCCION
			'https://mylostbag.aireuropa.com/weblf/rest/dpr/22-02-2018?key=C59ABE15811E20AA1EC304E6CDE9945B
			
			'PREPRODUCCION
			'http://pre.mylostbag.aireuropa.com/weblf/rest/dpr/18-06-2012?key=C59ABE15811E20AA1EC304E6CDE9945B
			'response.write("<br><br>--------------------------------------------------<br>OBTENIENDO DATOS PARA LA FECHA: " & fecha_ciclo & "<br>--------------------------------------------------")
			
			'sitio_web="https://mylostbag.aireuropa.com/weblf/rest/dpr/22-02-2018?key=C59ABE15811E20AA1EC304E6CDE9945B"
			'sitio_web="http://pre.mylostbag.aireuropa.com/weblf/rest/dpr/" & replace(fecha_ciclo, "/", "-") & "?key=C59ABE15811E20AA1EC304E6CDE9945B"
			sitio_web="http://mylostbag.aireuropa.com/weblf/rest/dpr/" & replace(fecha_ciclo, "/", "-") & "?key=C59ABE15811E20AA1EC304E6CDE9945B"
			'sitio_web="http://www.google.es"
			
			'response.write("<br><br>sitio web: " & sitio_web)
			%>
			<div class="panel-group"  role="tablist" aria-multiselectable="true"
				<%if session("perfil_usuario")<>"ADMINISTRADOR" then%>
					style="display:none"
				<%end if%>
				>
				<div class="panel panel-info" id="panel_<%=fechas%>">
					<div class="panel-heading" role="tab" >
						<h3 class="panel-title">DATOS DE LOS PIRs PARA LA FECHA: <%=fecha_ciclo%></h3>
					</div>
					<div class=" panel-body panel-collapse" role="tabpanel">
						<div width="95%">
							<a href="<%=sitio_web%>">Enlace Al Fichero Con Los Datos</a>
							
							<%
							xmlhttp.Open "GET", sitio_web , False
							xmlhttp.Send
							txt = xmlhttp.responseText
							
							'response.write("<br>RESULTADO: " & txt)

							'comprobaciones caracter a caracter cuando da error
							'for i=1 to len(txt)
							'   response.write("Caracter: " & mid(txt,i,1) & " Asci: " & Asc(mid(txt,i,1)) & "<br />")
							'next
							'txt = Replace(txt,"&#13;&#10;", "")
							
							'sustituimos cosas raras
							txt = Replace(txt,chr(13) & chr(10), "") 'retornos de carro y saltos de linea en medio de campos.... donde no debe
							txt = Replace(txt,"'", "´") 'las comillas simples que dan error al importar
							
							'response.write("<br>RESULTADO despues de formatear: " & txt)
							
							'comprobaciones caracter a caracter cuando da error
							'for i=1 to len(txt)
							'   response.write("Caracter: " & mid(txt,i,1) & " Asci: " & Asc(mid(txt,i,1)) & "<br />")
							'next
							
							LineArray = Split(txt , chr(10))
							
							'and then you can loop from lBound(LineArray) to uBound(LineArray) to take each line individually
							
							
							CEXPEDIENTE=0
							CPIR=1
							CFECCREACION=2
							CNOMBRE=3
							CAPELLIDOS=4
							CMOVIL=5
							CFIJO=6
							CDIRENTREGA=7
							CCPOSTAL=8
							CTIPODIRECCION=9
							CDESDEHASTA=10
							CFECHADESDEHASTA=11
							CTAG=12
							CMARCA=13
							CMATERIAL=14
							CCOLOR=15
							CLARGO=16
							CANCHO=17
							CALTO=18
							CRUTA=19
							CVUELO=20
							CTIPOEQUIPAJE=21
							CEMAIL=22
							
							cabecera=1
							
							
							'response.write("<br><br>lbound: " & LBound(LineArray) & " ubound: " & UBound(LineArray))
							
							
							%>
							
							<br /><br />
							<div>
								<p class="h4">Datos Obtenidos: <b><%=(UBound(LineArray) - 1)%></b> Registros</p>
								<%if UBound(LineArray)>1 then%>
									<script>
										j$('#panel_<%=fechas%>').removeClass('panel-info').addClass('panel-primary')
									</script>
									
									
								<%end if%>
							</div>
							<%if UBound(LineArray)>1 then%>
								<div  class="table-responsive" id="tabla_datos_<%=fechas%>">
									<table class="table table-bordered table-striped table-sm">
											<%
											connmaletas.BeginTrans 'Comenzamos la Transaccion
											
											For i = LBound(LineArray) To UBound(LineArray) - 1
							
												response.flush()
												
												'response.write("<br><br>" & LineArray(i))
												campos=Split(LineArray(i), ";")
												cadena_campos=""
												cadena_valores=""
												if cabecera=0 then
													%>
													<TR>
													<%
													For j = LBound(campos) To UBound(campos)
														%>
														<TD><%=campos(j)%></TD>
														<%
													Next
													%>
													</TR>
													<%
													cadena_campos="PIR"
													cadena_valores="'" & left(campos(CPIR), 15) & "'"
													
													
													if campos(CEXPEDIENTE)<>"" then
														cadena_campos=cadena_campos & ", EXPEDIENTE"
														cadena_valores=cadena_valores & ", '" & left(campos(CEXPEDIENTE), 25) & "'"
													end if
											CFECCREACION=3 'este campo del fichero csv, no se vuelca a ningun sitio
													if campos(CNOMBRE)<>"" then
														cadena_campos=cadena_campos & ", NOMBRE"
														cadena_valores=cadena_valores & ", '" & left(campos(CNOMBRE), 50) & "'"
													end if
													if campos(CAPELLIDOS)<>"" then
														cadena_campos=cadena_campos & ", APELLIDOS"
														cadena_valores=cadena_valores & ", '" & left(campos(CAPELLIDOS), 100) & "'"
													end if
													if campos(CMOVIL)<>"" then
														cadena_campos=cadena_campos & ", MOVIL"
														cadena_valores=cadena_valores & ", '" & left(campos(CMOVIL), 80) & "'"
													end if
													if campos(CFIJO)<>"" then
														cadena_campos=cadena_campos & ", FIJO"
														cadena_valores=cadena_valores & ", '" & left(campos(CFIJO), 80) & "'"
													end if
													if campos(CDIRENTREGA)<>"" then
														cadena_campos=cadena_campos & ", DIRECCION_ENTREGA"
														cadena_valores=cadena_valores & ", '" & left(campos(CDIRENTREGA), 255) & "'"
													end if
													if campos(CCPOSTAL)<>"" then
														cadena_campos=cadena_campos & ", CP_ENTREGA"
														cadena_valores=cadena_valores & ", '" & left(campos(CCPOSTAL), 12) & "'"
													end if
													if campos(CTIPODIRECCION)<>"" then
														cadena_campos=cadena_campos & ", TIPO_DIRECCION_ENTREGA"
														cadena_valores=cadena_valores & ", '" & left(campos(CTIPODIRECCION), 3) & "'"
													end if
													if campos(CDESDEHASTA)<>"" then
														cadena_campos=cadena_campos & ", DESDE_HASTA"
														cadena_valores=cadena_valores & ", '" & left(campos(CDESDEHASTA), 5) & "'"
													end if
													if campos(CFECHADESDEHASTA)<>"" then
														cadena_campos=cadena_campos & ", FECHA_DESDE_HASTA"
														cadena_valores=cadena_valores & ", '" & campos(CFECHADESDEHASTA) & "'"
													end if
													if campos(CTAG)<>"" then
														cadena_campos=cadena_campos & ", TAG"
														cadena_valores=cadena_valores & ", '" & left(campos(CTAG), 15) & "'"
													end if
													if campos(CMARCA)<>"" then
														cadena_campos=cadena_campos & ", MARCA_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CMARCA), 100) & "'"
													end if
													if campos(CMATERIAL)<>"" then
														cadena_campos=cadena_campos & ", MATERIAL_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CMATERIAL),20) & "'"
													end if
													if campos(CCOLOR)<>"" then
														cadena_campos=cadena_campos & ", COLOR_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CCOLOR),25) & "'"
													end if
													if campos(CLARGO)<>"" then
														cadena_campos=cadena_campos & ", LARGO_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CLARGO), 25) & "'"
													end if
													if campos(CANCHO)<>"" then
														cadena_campos=cadena_campos & ", ANCHO_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CANCHO), 25) & "'"
													end if
													if campos(CALTO)<>"" then
														cadena_campos=cadena_campos & ", ALTO_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CALTO), 25) & "'"
													end if
													if campos(CRUTA)<>"" then
														cadena_campos=cadena_campos & ", RUTA"
														cadena_valores=cadena_valores & ", '" & left(campos(CRUTA), 25) & "'"
													end if
													if campos(CVUELO)<>"" then
														cadena_campos=cadena_campos & ", VUELOS"
														cadena_valores=cadena_valores & ", '" & left(campos(CVUELO), 50) & "'"
													end if
													if campos(CTIPOEQUIPAJE)<>"" then
														cadena_campos=cadena_campos & ", TIPO_EQUIPAJE_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CTIPOEQUIPAJE),15) & "'"
													end if
													if campos(CEMAIL)<>"" then
														cadena_campos=cadena_campos & ", EMAIL"
														cadena_valores=cadena_valores & ", '" & left(campos(CEMAIL), 255) & "'"
													end if
													
													'los importamos en PENDIENTE AUTORIZACION
													cadena_campos=cadena_campos & ", ESTADO"
													cadena_valores=cadena_valores & ", 1"
													
													'no se si es esta, o el campo que no hemos tratado de FECCREACION
													'cadena_campos=cadena_campos & ", FECHA_PIR"
													'cadena_valores=cadena_valores & ", '" & fecha_ciclo & "'"
													
													'tomamos como fecha de orden del pir la fecha que se pasa como parametro a la url
													cadena_campos=cadena_campos & ", FECHA_ORDEN"
													cadena_valores=cadena_valores & ", '" & fecha_ciclo & "'"
													
													
													'guardo la fecha del fichero en el que viene este PIR a importar
													cadena_campos=cadena_campos & ", FECHA_FICHERO_IMPORTACION"
													cadena_valores=cadena_valores & ", '" & FECHA_CICLO & "'"
													
													'no viene informacion de daños al importar
													cadena_campos=cadena_campos & ", DANNO_RUEDAS_BAG_ORIGINAL, DANNO_ASAS_BAG_ORIGINAL, DANNO_CIERRES_BAG_ORIGINAL, DANNO_CREMALLERA_BAG_ORIGINAL, DANNO_CUERPO_MALETA_BAG_ORIGINAL, DANNO_OTROS_BAG_ORIGINAL"
													cadena_valores=cadena_valores & ", 'false', 'false', 'false', 'false', 'false', 'false'"
													
													'ID, FECHA_ORDEN, ORDEN, AGENTE, EXPEDIENTE, PIR, FECHA_PIR, TAG, NOMBRE, APELLIDOS, DNI, MOVIL, FIJO, DIRECCION_ENTREGA, CP_ENTREGA, TIPO_DIRECCION_ENTREGA, 
													'              DESDE_HASTA, FECHA_DESDE_HASTA, OBSERVACIONES, TIPO_EQUIPAJE_BAG_ORIGINAL, MARCA_BAG_ORIGINAL, MODELO_BAG_ORIGINAL, MATERIAL_BAG_ORIGINAL, 
													'              COLOR_BAG_ORIGINAL, LARGO_BAG_ORIGINAL, ALTO_BAG_ORIGINAL, ANCHO_BAG_ORIGINAL, DANNO_RUEDAS_BAG_ORIGINAL, DANNO_ASAS_BAG_ORIGINAL, 
													'              DANNO_CIERRES_BAG_ORIGINAL, DANNO_CREMALLERA_BAG_ORIGINAL, DANNO, EQUIPAJE, RUTA, VUELOS, TIPO_BAG_ORIGINAL, FECHA_INICIO, FECHA_ENVIO, FECHA_ENTREGA_PAX, 
													'              PLAZO_ENTREGA_EN_DIAS, INCIDENCIA_TRANSPORTE, INCIDENCIA_MALETA, OTRAS_INCIDENCIAS, TIPO_BAG_ENTREGADA, TAMANNO_BAG_ENTREGADA, REFERENCIA_BAG_ENTREGADA, 
													'              COLOR_BAG_ENTREGADA, NUM_EXPEDICION, ESTADO, DANNO_OTROS_BAG_ORIGINAL, DANNO_CUERPO_MALETA_BAG_ORIGINAL, DANNO_CIERRES_MALETA_BAG_ORIGINAL, 
													'              IMPORTE_FACTURACION, FECHA_FACTURACION, COSTES, PROVEEDOR, EMAIL
											
													'cadena_ejecucion="INSERT INTO PIRS (" & cadena_campos & ") values (" & cadena_valores & ")"
													
													'cadeja de ejecucion para solo insertar nuevos, los duplicados se los salta
													cadena_ejecucion="INSERT INTO PIRS (" & cadena_campos & ") SELECT " & cadena_valores 
													cadena_ejecucion=cadena_ejecucion & " WHERE NOT EXISTS (Select PIR From PIRS WHERE PIRS.PIR='" & left(campos(CPIR), 15) & "'"
													cadena_ejecucion=cadena_ejecucion & " AND PIRS.TAG='" & left(campos(CTAG), 15) & "')"
													
													
													'INSERT INTO confio SET estado = 0, user_id = 1, user_id_1 = 14
													'ON DUPLICATE KEY UPDATE estado = 0
													
													'INSERT INTO #table1 (Id, guidd, TimeAdded, ExtraData)
													'SELECT Id, guidd, TimeAdded, ExtraData
													'FROM #table2
													'WHERE NOT EXISTS (Select Id, guidd From #table1 WHERE #table1.id = #table2.id)
													
													'response.write("<br><br>cadena ejecuacion: " & cadena_ejecucion)
													
													connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
													
													
													Set valor_nuevo = connmaletas.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
													id_pir_nuevo=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
													valor_nuevo.Close
													Set valor_nuevo = Nothing
													
													IF id_pir_nuevo<>"" then
														'GRABAMOS EN EL HISTORICO EL ALTA DEL PIR
														cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
														cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
														cadena_historico=cadena_historico & " VALUES (" & id_pir_nuevo & ", '" & campos(CPIR) & "',"
														cadena_historico=cadena_historico & " GETDATE(), 'IMPORT PIR', NULL, NULL, NULL,"
														cadena_historico=cadena_historico & " '" & session("usuario") & "', 'Fichero CSV de la Fecha " & fecha_ciclo & "', NULL)"
														
														'response.write("<br>cadena_historico: " & cadena_historico)
														connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
													end if
												  else
													%>
													<TR>
													<%
													For j = LBound(campos) To UBound(campos)
														%>
														<TH><%=campos(j)%></TH>
														<%
													Next
													%>
													</TR>
													<%
												end if
												cabecera=0
											Next
											connmaletas.CommitTrans ' finaliza la transaccion
											%>
									</table>
								</div>
							<%end if%>
							
						</div>
					</div>
				</div>
			</div><!--el panel--> 
			 
			<%  
			
			
		
		
			fecha_ciclo=DateAdd("d", 1, fecha_ciclo)
		next
		
		Set xmlhttp = Nothing
		
		'regis.close			
		connmaletas.Close
		set connmaletas=Nothing
		
		%>
		
		<div class="alert alert-success" role="alert">
			  <p class="h4"><b>Proceso de Importacion Finalizado</b></p>
		</div>
		
	</div>
	
	
</div> <!-- el container-->


</body>

</html>

				
