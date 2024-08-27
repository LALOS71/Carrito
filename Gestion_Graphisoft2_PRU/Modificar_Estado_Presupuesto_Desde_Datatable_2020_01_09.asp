<!--#include file="DB_Manager.inc"-->
<%
	
	id_estado_antiguo	= "" & Request.Form("id_estado_antiguo")
	id_estado_nuevo		= "" & Request.Form("id_estado_nuevo")
	id_subestado_antiguo= "" & Request.Form("id_subestado_antiguo")
	id_subestado_nuevo	= "" & Request.Form("id_subestado_nuevo")
	id_presupuesto		= "" & Request.Form("id_presupuesto")
	presupuesto			= "" & Request.Form("presupuesto")
	
	
	'response.write("<br>estado antiguo: " & id_estado_antiguo)
	'response.write("<br>estado nuevo: " & id_estado_nuevo)
	'response.write("<br>subestado antiguo: " & id_subestado_antiguo)
	'response.write("<br>subestado nuevo: " & id_subestado_nuevo)
	'response.write("<br>id presupuesto: " & id_presupuesto)
	'response.write("<br>presupuesto: " & presupuesto)
	
	
	'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
	' de fecha con mes-dia-año
	query_options = adCmdText + adExecuteNoRecords
	execute_sql_with_options conn_gag, "set dateformat dmy", query_options
	'conn_gag.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
			
			
	CAMPO_ID_PRESUPUESTO = 0
	
	' GetEstados query
	sql_grupo_presupuestos="SELECT ID_PRESUPUESTO FROM GESTION_GRAPHISOFT_PRESUPUESTOS WHERE PRESUPUESTO=" & presupuesto
	
	vacio_presupuestos = false

	Set grupo_presupuestos = execute_sql(conn_gag, sql_grupo_presupuestos)
    If Not grupo_presupuestos.BOF Then
        tabla_presupuestos = grupo_presupuestos.GetRows()
	Else
		vacio_presupuestos = true
    End If

    close_connection(grupo_presupuestos)
	set grupo_presupuestos = Nothing
	' /GetEstados query
	
	conn_gag.BeginTrans 'Comenzamos la Transaccion
	
	cadena_explicacion=""
	if not vacio_presupuestos then
		for i=0 to UBound(tabla_presupuestos,2)
			'cadena_explicacion = "Cambiado Automaticamente Desde Otra Version " & id_presupuesto & "--" & tabla_presupuestos(campo_id_presupuesto,i)
			if cstr(tabla_presupuestos(campo_id_presupuesto,i))= cstr(id_presupuesto) then
				cadena_explicacion = "Cambiado Directamente Desde Esta Version"
			  else
			  	cadena_explicacion = "Cambiado Directamente Desde Otra Version"
			end if
			cadena_historico = "INSERT INTO GESTION_GRAPHISOFT_HISTORICO_PRESUPUESTOS (ID_PRESUPUESTO, PRESUPUESTO, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico = cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico = cadena_historico & " SELECT " & tabla_presupuestos(campo_id_presupuesto,i) & ", " & presupuesto & ","
			cadena_historico = cadena_historico & " GETDATE(), 'CAMBIO', 'ESTADO', (SELECT DESCRIPCION FROM GESTION_GRAPHISOFT_ESTADOS_PRESUPUESTOS WHERE ID=" & id_estado_antiguo & "),"
			cadena_historico = cadena_historico & " (SELECT DESCRIPCION FROM GESTION_GRAPHISOFT_ESTADOS_PRESUPUESTOS WHERE ID=" & id_estado_nuevo & "), '" & session("usuario") & "', '" & cadena_explicacion & "', NULL"
								
			'response.write("<br>cadena historico PARA EL ESTADO: " & cadena_historico)				
			if id_estado_antiguo<>id_estado_nuevo then
				query_options = adCmdText + adExecuteNoRecords
				execute_sql_with_options conn_gag, cadena_historico, query_options
			end if
			
			
			if id_estado_nuevo=5 or id_estado_nuevo=6 then
				cadena_historico = "INSERT INTO GESTION_GRAPHISOFT_HISTORICO_PRESUPUESTOS (ID_PRESUPUESTO, PRESUPUESTO, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico = cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico = cadena_historico & " SELECT " & tabla_presupuestos(campo_id_presupuesto,i) & ", " & presupuesto & ","
				cadena_historico = cadena_historico & " GETDATE(), 'CAMBIO', 'SUBESTADO'"
				if id_subestado_antiguo="" or id_subestado_antiguo=null then
					cadena_historico = cadena_historico & ", NULL"
				  else
				  	cadena_historico = cadena_historico & ", (SELECT DESCRIPCION FROM GESTION_GRAPHISOFT_SUBESTADOS_PRESUPUESTOS WHERE ID=" & id_subestado_antiguo & ")"
				end if
				if id_subestado_nuevo="" or id_subestado_nuevo=null then
					cadena_historico = cadena_historico & ", NULL"
				  else
				  	cadena_historico = cadena_historico & ", (SELECT DESCRIPCION FROM GESTION_GRAPHISOFT_SUBESTADOS_PRESUPUESTOS WHERE ID=" & id_subestado_nuevo & ")"
				end if
				cadena_historico = cadena_historico & ", '" & session("usuario") & "', '" & cadena_explicacion & "', NULL"
									
				'response.write("<br>cadena historico PARA EL SUBESTADO: " & cadena_historico)		
				if id_subestado_antiguo<>id_subestado_nuevo then		
					query_options = adCmdText + adExecuteNoRecords
					execute_sql_with_options conn_gag, cadena_historico, query_options
				end if
			end if
			
			
		next
	end if
	
	
	
	
	
	cadena_ejecucion = "UPDATE GESTION_GRAPHISOFT_PRESUPUESTOS SET ID_ESTADO=" & id_estado_nuevo
	if id_estado_nuevo<>5 and id_estado_nuevo<>6 then
		cadena_ejecucion = cadena_ejecucion & ", ID_SUBESTADO=NULL" 
	  else
	  	if id_subestado_nuevo="" or id_subestado_nuevo=null then
		  	cadena_ejecucion = cadena_ejecucion & ", ID_SUBESTADO=NULL" 
		  else
			cadena_ejecucion = cadena_ejecucion & ", ID_SUBESTADO=" & id_subestado_nuevo 
		end if
	end if
	
	cadena_ejecucion = cadena_ejecucion & " WHERE ID_PRESUPUESTO=" & id_presupuesto & " OR PRESUPUESTO=" & presupuesto

	'response.write("<br>cadena hoja ruta: " & cadena_ejecucion)
	'response.write("<br>cadena actualizacion: " & cadena_ejecucion)				
	query_options = adCmdText + adExecuteNoRecords
	execute_sql_with_options conn_gag, cadena_ejecucion, query_options
	'conn_gag.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
	
	conn_gag.CommitTrans ' finaliza la transaccion
			
	
	Response.Write 1
	
	
	close_connection(conn_gag)
%>



