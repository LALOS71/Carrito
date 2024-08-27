<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
	sesion_caducada="NO"
	
	if session("usuario")="" then
		sesion_caducada="SI"
	end if
	
	if sesion_caducada= "NO" then
		sn_seleccionada = "" & Request.Form("sn_imp")
		estado_seleccionado = "" & Request.Form("estado")
		perfil_seleccionado = "" & Request.Form("perfil")
		accion_seleccionada = "" & Request.Form("accion")
		
		'sn_seleccionada= "49552"
		
		'response.write("<br>entramos")
		'response.write("<br>sn: " & sn_seleccionada)
		'response.write("<br>estado: " & estado_seleccionado)
		'response.write("<br>perfil: " & perfil_seleccionado)
		'response.write("<br>accion: " & accion_seleccionada)
		
		
		'LA OFICINA INFORMA DE UNA BAJA, O DE UNA AVERIA EN LA IMPRESORA, O DETECTA QUE ESTÁ DEFECTUOSA
		if accion_seleccionada = "DEFECTUOSA-AVERIADA-BAJA" then
				
			'obtenemos la oficina a la que está asignada la impresora
			oficina_destino = "" 
			set rs_impresora=Server.CreateObject("ADODB.Recordset")
			sql = "SELECT ID_CLIENTE FROM GLS_IMPRESORAS WHERE SN_IMPRESORA='" & sn_seleccionada & "'"
			with rs_impresora
				.ActiveConnection=connimprenta
				.Source=sql
				.Open
			end with
			if not rs_impresora.eof then
				oficina_destino= rs_impresora("ID_CLIENTE")
			end if
			rs_impresora.close
			set rs_impresora = Nothing
			
			direccion_ip=""
			if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
				direccion_ip = "" & Request.ServerVariables("HTTP_X_FORWARDED_FOR")
			  else
				direccion_ip = "" & Request.ServerVariables("REMOTE_ADDR")
			end if
			'response.write("<br>ip: " & direccion_ip)
			'response.write("<br>estado: " & estado_seleccionado)
			'response.write("<br>oficina_destino: " & oficina_destino)
			'response.write("<br>sn: " & sn_seleccionada)
			if sn_seleccionada <> "" and estado_seleccionado <> "" and oficina_destino <> "" & direccion_ip <> "" then
				connimprenta.BeginTrans
				
				sql = "UPDATE GLS_IMPRESORAS SET ESTADO='" & estado_seleccionado & "'"
				sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				
				sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
				sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), '" & estado_seleccionado & "', '" & oficina_destino & "', '" & direccion_ip & "',"
				sql = sql & " '" & perfil_seleccionado & "')"
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				
				cadena_respuesta = "{""mensaje"": ""mensaje"", ""contenido"": ""Solicitud realizada con éxito""}"
				connimprenta.CommitTrans
			  else
				'error
				cadena_respuesta = "{""mensaje"": ""error"", ""contenido"": ""Se ha producucido un error al tramitar la solicitud, salga de la aplicación y vuelva a intentarlo""}"
			end if
		end if
		
		
		'LA DIRECCION CENTRAL DE GLS APRUEBA O RECHAZA UNA BAJA
		if accion_seleccionada = "APROBAR-RECHAZAR_BAJA" then
				
			'obtenemos la oficina a la que está asignada la impresora
			oficina_destino = "" 
			set rs_impresora=Server.CreateObject("ADODB.Recordset")
			sql = "SELECT ID_CLIENTE FROM GLS_IMPRESORAS WHERE SN_IMPRESORA='" & sn_seleccionada & "'"
			with rs_impresora
				.ActiveConnection=connimprenta
				.Source=sql
				.Open
			end with
			if not rs_impresora.eof then
				oficina_destino= rs_impresora("ID_CLIENTE")
			end if
			rs_impresora.close
			set rs_impresora = Nothing
			
			direccion_ip=""
			if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
				direccion_ip = "" & Request.ServerVariables("HTTP_X_FORWARDED_FOR")
			  else
				direccion_ip = "" & Request.ServerVariables("REMOTE_ADDR")
			end if
			'response.write("<br>ip: " & direccion_ip)
			'response.write("<br>estado: " & estado_seleccionado)
			'response.write("<br>oficina_destino: " & oficina_destino)
			'response.write("<br>sn: " & sn_seleccionada)
			if sn_seleccionada <> "" and estado_seleccionado <> "" and oficina_destino <> "" & direccion_ip <> "" then
				connimprenta.BeginTrans
				
				if estado_seleccionado = "BAJA RECHAZADA" then
					sql = "UPDATE GLS_IMPRESORAS SET ESTADO='ACTIVA'"
					sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
					
					sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
					sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), 'BAJA RECHAZADA', '" & oficina_destino & "', '" & direccion_ip & "',"
					sql = sql & " '" & perfil_seleccionado & "')"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
	
					sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
					sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), 'ACTIVA', '" & oficina_destino & "', '" & direccion_ip & "',"
					sql = sql & " '" & perfil_seleccionado & "')"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				  else
					sql = "UPDATE GLS_IMPRESORAS SET ESTADO='" & estado_seleccionado & "'"
					sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
					
					sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
					sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), '" & estado_seleccionado & "', '" & oficina_destino & "', '" & direccion_ip & "',"
					sql = sql & " '" & perfil_seleccionado & "')"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				end if
				cadena_respuesta = "{""mensaje"": ""mensaje"", ""contenido"": ""Solicitud realizada con éxito""}"
				connimprenta.CommitTrans
			  else
				'error
				cadena_respuesta = "{""mensaje"": ""error"", ""contenido"": ""Se ha producucido un error al tramitar la solicitud, salga de la aplicación y vuelva a intentarlo""}"
			end if
		end if
		
		
		'LA DIRECCION DE GLS APRUEBA O RECHAZA UNA DEFECTUOSA
		if accion_seleccionada = "APROBAR-RECHAZAR_DEFECTUOSA" then
				
			'obtenemos la oficina a la que está asignada la impresora
			oficina_destino = "" 
			set rs_impresora=Server.CreateObject("ADODB.Recordset")
			sql = "SELECT ID_CLIENTE FROM GLS_IMPRESORAS WHERE SN_IMPRESORA='" & sn_seleccionada & "'"
			with rs_impresora
				.ActiveConnection=connimprenta
				.Source=sql
				.Open
			end with
			if not rs_impresora.eof then
				oficina_destino= rs_impresora("ID_CLIENTE")
			end if
			rs_impresora.close
			set rs_impresora = Nothing
			
			direccion_ip=""
			if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
				direccion_ip = "" & Request.ServerVariables("HTTP_X_FORWARDED_FOR")
			  else
				direccion_ip = "" & Request.ServerVariables("REMOTE_ADDR")
			end if
			'response.write("<br>ip: " & direccion_ip)
			'response.write("<br>estado: " & estado_seleccionado)
			'response.write("<br>oficina_destino: " & oficina_destino)
			'response.write("<br>sn: " & sn_seleccionada)
			if sn_seleccionada <> "" and estado_seleccionado <> "" and oficina_destino <> "" & direccion_ip <> "" then
				connimprenta.BeginTrans
				
				if estado_seleccionado = "DEFECTUOSA RECHAZADA" then
					sql = "UPDATE GLS_IMPRESORAS SET ESTADO='ACTIVA'"
					sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
					
					sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
					sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), 'DEFECTUOSA RECHAZADA', '" & oficina_destino & "', '" & direccion_ip & "',"
					sql = sql & " '" & perfil_seleccionado & "')"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
	
					sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
					sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), 'ACTIVA', '" & oficina_destino & "', '" & direccion_ip & "',"
					sql = sql & " '" & perfil_seleccionado & "')"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				  else
					sql = "UPDATE GLS_IMPRESORAS SET ESTADO='" & estado_seleccionado & "'"
					sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
					
					sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
					sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), '" & estado_seleccionado & "', '" & oficina_destino & "', '" & direccion_ip & "',"
					sql = sql & " '" & perfil_seleccionado & "')"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				end if
				cadena_respuesta = "{""mensaje"": ""mensaje"", ""contenido"": ""Solicitud realizada con éxito""}"
				connimprenta.CommitTrans
			  else
				'error
				cadena_respuesta = "{""mensaje"": ""error"", ""contenido"": ""Se ha producucido un error al tramitar la solicitud, salga de la aplicación y vuelva a intentarlo""}"
			end if
		end if
		
		
		'LA DIRECCION DE GLS APRUEBA O RECHAZA UNA AVERIA
		if accion_seleccionada = "APROBAR-RECHAZAR_AVERIADA" then
				
			'obtenemos la oficina a la que está asignada la impresora
			oficina_destino = "" 
			set rs_impresora=Server.CreateObject("ADODB.Recordset")
			sql = "SELECT ID_CLIENTE FROM GLS_IMPRESORAS WHERE SN_IMPRESORA='" & sn_seleccionada & "'"
			with rs_impresora
				.ActiveConnection=connimprenta
				.Source=sql
				.Open
			end with
			if not rs_impresora.eof then
				oficina_destino= rs_impresora("ID_CLIENTE")
			end if
			rs_impresora.close
			set rs_impresora = Nothing
			
			direccion_ip=""
			if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
				direccion_ip = "" & Request.ServerVariables("HTTP_X_FORWARDED_FOR")
			  else
				direccion_ip = "" & Request.ServerVariables("REMOTE_ADDR")
			end if
			'response.write("<br>ip: " & direccion_ip)
			'response.write("<br>estado: " & estado_seleccionado)
			'response.write("<br>oficina_destino: " & oficina_destino)
			'response.write("<br>sn: " & sn_seleccionada)
			if sn_seleccionada <> "" and estado_seleccionado <> "" and oficina_destino <> "" & direccion_ip <> "" then
				connimprenta.BeginTrans
				
				if estado_seleccionado = "AVERIADA RECHAZADA" then
					sql = "UPDATE GLS_IMPRESORAS SET ESTADO='ACTIVA'"
					sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
					
					sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
					sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), 'AVERIADA RECHAZADA', '" & oficina_destino & "', '" & direccion_ip & "',"
					sql = sql & " '" & perfil_seleccionado & "')"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
	
					sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
					sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), 'ACTIVA', '" & oficina_destino & "', '" & direccion_ip & "',"
					sql = sql & " '" & perfil_seleccionado & "')"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				  else
					sql = "UPDATE GLS_IMPRESORAS SET ESTADO='" & estado_seleccionado & "'"
					sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
					
					sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
					sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), '" & estado_seleccionado & "', '" & oficina_destino & "', '" & direccion_ip & "',"
					sql = sql & " '" & perfil_seleccionado & "')"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				end if
				cadena_respuesta = "{""mensaje"": ""mensaje"", ""contenido"": ""Solicitud realizada con éxito""}"
				connimprenta.CommitTrans
			  else
				'error
				cadena_respuesta = "{""mensaje"": ""error"", ""contenido"": ""Se ha producucido un error al tramitar la solicitud, salga de la aplicación y vuelva a intentarlo""}"
			end if
		end if
			
		'LA DIRECCION DE GLS BORRA EL PEDIDO CON IMPRESORAS CREADO A UNA OFICINA
		if accion_seleccionada = "BORRAR_PEDIDO" then
				sql = "DELETE FROM PEDIDOS"
				sql = sql & " WHERE PEDIDOS.ESTADO='PENDIENTE FIRMA'"
				sql = sql & " AND PEDIDOS.PEDIDO_AUTOMATICO='IMPRESORA_GLS_ADMIN'"
				sql = sql & " AND PEDIDOS.ID=" & sn_seleccionada
				
				'response.write("<br>consulta cabecera: " & sql)
				
				connimprenta.BeginTrans
				rows_affected=0
				'Set rs_impresoras_borrar = Server.CreateObject("ADODB.Recordset")
				'with rs_impresoras_borrar
				'	.ActiveConnection=connimprenta
				'	.Source=sql
				'	.Open
				'end with
				'if not rs_impresoras_borrar.eof then
				'	rows_affected = rs_impresoras_borrar.RowCount
				'end if
				'rs_impresoras_borrar.Close
				'set rs_impresoras_borrar = Nothing
				
				
				'Set cmd = Server.CreateObject("ADODB.Command")
				'cmd.ActiveConnection = connimprenta
				'cmd.CommandText = sql
				'cmd.Execute , , adExecuteNoRecords
				'rows_affected = cmd.Properties("RecordsAffected").Value
				
				'connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				connimprenta.Execute sql, rows_affected
				
				'response.write("<br>registros borrados: " & rows_affected)
				
				If rows_affected > 0 Then
					sql = "DELETE FROM PEDIDOS_DETALLES"
					sql = sql & " WHERE ID_PEDIDO=" & sn_seleccionada
					'response.write("<br>borrar detalles: " & sql)
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
					
					connimprenta.CommitTrans
					cadena_respuesta = "{""mensaje"": ""mensaje"", ""contenido"": ""Pedido Eliminado Correctamente""}"
					
				  else
				  	'error
					connimprenta.RollbackTrans
					cadena_respuesta = "{""mensaje"": ""error"", ""contenido"": ""Se ha producucido un error al tratar de eliminar el pedido, vuelva a intentarlo""}"
				end if
				
				
				
		end if
		
		Response.ContentType = "application/json; charset=UTF-8"
		Response.Write(cadena_respuesta)
	  else
		Response.ContentType = "application/json; charset=UTF-8"
		cadena_respuesta = "{""mensaje"": ""error"", ""contenido"": ""Se ha caducado la sesión, Vuelva a iniciar sesión en la aplicación.""}"
		response.write(cadena_respuesta) 
	 end if
		
		
	connimprenta.close
	set connimprenta=Nothing

%>