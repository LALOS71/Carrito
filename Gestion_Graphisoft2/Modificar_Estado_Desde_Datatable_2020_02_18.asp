<!--#include file="DB_Manager.inc"-->
<%
	
	hoja_de_ruta		= Request.Form("hoja_de_ruta")
	id_estado_antiguo	= Request.Form("id_estado_antiguo")
	id_estado_nuevo		= Request.Form("id_estado_nuevo")
	id_hoja				= Request.Form("id_hoja")
	
	'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
	' de fecha con mes-dia-año
	query_options = adCmdText + adExecuteNoRecords
	execute_sql_with_options conn_gag, "set dateformat dmy", query_options
	'conn_gag.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
			
			
	conn_gag.BeginTrans 'Comenzamos la Transaccion
	
	
	cadena_historico = "INSERT INTO GESTION_GRAPHISOFT_HISTORICO_HOJAS (ID_HOJA_RUTA, HOJA_RUTA, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
	cadena_historico = cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
	cadena_historico = cadena_historico & " SELECT " & id_hoja & ", '" & hoja_de_ruta & "',"
	cadena_historico = cadena_historico & " GETDATE(), 'CAMBIO', 'ESTADO', (SELECT DESCRIPCION FROM GESTION_GRAPHISOFT_ESTADOS WHERE ID=" & id_estado_antiguo & "),"
	cadena_historico = cadena_historico & " (SELECT DESCRIPCION FROM GESTION_GRAPHISOFT_ESTADOS WHERE ID=" & id_estado_nuevo & "), '" & session("usuario") & "', NULL, NULL"
					
	'response.write("<br>cadena historico: " & cadena_historico)				
	query_options = adCmdText + adExecuteNoRecords
	execute_sql_with_options conn_gag, cadena_historico, query_options
	'conn_gag.Execute cadena_historico,,adCmdText + adExecuteNoRecords
	
	
	cadena_ejecucion = "UPDATE GESTION_GRAPHISOFT_HOJAS_IMPORTADAS SET ID_ESTADO=" & id_estado_nuevo & " WHERE ID=" & id_hoja
	'response.write("<br>cadena hoja ruta: " & cadena_ejecucion)
	'response.write("<br>cadena actualizacion: " & cadena_ejecucion)				
	query_options = adCmdText + adExecuteNoRecords
	execute_sql_with_options conn_gag, cadena_ejecucion, query_options
	'conn_gag.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
	
	conn_gag.CommitTrans ' finaliza la transaccion
			
	
	Response.Write 1
	
	
	close_connection(conn_gag)
%>



