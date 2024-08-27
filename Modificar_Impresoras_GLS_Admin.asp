<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
	sesion_caducada="NO"

	if session("usuario_admin")="" then
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
			
			'se envia a revision una impresora de la que solicitan la baja y la han aprobado
			if estado_seleccionado = "EN REVISION" then
				sql = "UPDATE GLS_IMPRESORAS SET ESTADO='EN REVISION'"
				sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
				'response.write("<br>sql en revision: " & sql)
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				
				sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
				sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), 'EN REVISION', '" & oficina_destino & "', '" & direccion_ip & "',"
				sql = sql & " '" & perfil_seleccionado & "')"
				'response.write("<br>sql en revision: " & sql)
				
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
			end if
			
			'se da de baja una impresora, se desvincula de la oficina que la tenia asignada y pasa a nuestro almacen, id cliente = 0
			if estado_seleccionado = "BAJA" then
				'NO SE SI HAY QUE MOVER LA IMPRESORA A NUESTRO ALMACEN ¿UTILIZAR UN ID_CLIENTE = 0? Y DESVINCULARLA DE LA OFICINA
				sql = "UPDATE GLS_IMPRESORAS SET ESTADO='BAJA', ID_CLIENTE=0"
				sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
				'response.write("<br>sql baja: " & sql)
				
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				
				sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
				sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), 'BAJA', '0', '" & direccion_ip & "',"
				sql = sql & " '" & perfil_seleccionado & "')"
				'response.write("<br>sql baja: " & sql)
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				
				'incrementamos el stock
				sql = "UPDATE ARTICULOS_MARCAS SET STOCK = "
				sql = sql & " CASE WHEN (NOT STOCK IS NULL) THEN STOCK + 1 ELSE NULL END"
				sql = sql & " WHERE ID_ARTICULO = 4583"
				sql = sql & " AND MARCA='STANDARD'"
				'response.write("<br>sql stock: " & sql)
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				
				'metemos la linea de entrada/salida de la impresora
				sql = "INSERT INTO ENTRADAS_SALIDAS_ARTICULOS (ID_ARTICULO, E_S, FECHA, CANTIDAD, ALBARAN, TIPO, FECHA_ALTA)"
				sql = sql & " VALUES (4583, 'ENTRADA', GETDATE(), 1, 'BAJA: " & sn_seleccionada & "', 'DEVOLUCION', GETDATE())"
				'response.write("<br>sql ENTRADAS/SALIDAS: " & sql)
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
			end if
			
			'una impresora defectuosa se pasa a defectuosa-reemplazo para indicar que se ha generado un pedido para enviar una impresora nueva
			' y hemos de esperar a que nos devuelva la impresora esta impresora etiquedada ahora como DEFECTUOSA-REEMPLAZO
			if estado_seleccionado = "DEFECTUOSA" then
				if accion_seleccionada="DEFECTUOSA-REEMPLAZO" then
					sql = "UPDATE GLS_IMPRESORAS SET ESTADO='DEFECTUOSA-REEMPLAZO'"
					sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
					'response.write("<br>sql en revision: " & sql)
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				
				
					'CREAMOS UN PEDIDO DE IMPRESORAS y LO PONEMOS EN SIN TRATAR, NO SE NECESITA LA FIRMA DE LA OFICINA
					sql = "INSERT INTO PEDIDOS (CODCLI, FECHA, ESTADO, PEDIDO_AUTOMATICO, RENTING_IMPRESORA_GLS)"
					sql = sql & " VALUES (" & oficina_destino  & ", GETDATE(), 'SIN TRATAR', 'IMPRESORA_GLS_GAG', 8)"
	
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
			
					Set valor_nuevo = connimprenta.Execute("SELECT @@IDENTITY") 
					numero_pedido=valor_nuevo(0) 
					valor_nuevo.Close
					Set valor_nuevo = Nothing
					
					sql = "INSERT INTO PEDIDOS_DETALLES (ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, PRECIO_COSTE)"
					sql = sql & " VALUES (" & numero_pedido & ", 4583, 1, 0, 0, 'SIN TRATAR', 0)"
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
					
					
					sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
					sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), 'DEFECTUOSA-REEMPLAZO', '" & oficina_destino & "', '" & direccion_ip & "',"
					sql = sql & " '" & perfil_seleccionado & "')"
					'response.write("<br>sql en revision: " & sql)
					
					connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				end if
			end if
			
			if estado_seleccionado = "EN CESION" then
				'NO SE SI HAY QUE MOVER LA IMPRESORA A NUESTRO ALMACEN ¿UTILIZAR UN ID_CLIENTE = 0? Y DESVINCULARLA DE LA OFICINA
				sql = "UPDATE GLS_IMPRESORAS SET ESTADO='EN CESION'"
				sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
				'response.write("<br>sql en revision: " & sql)
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				
				'CREAMOS UN PEDIDO DE IMPRESORAS
				'LO PONEMOS EN SIN TRATAR... NO SE SI VA EN PENDIENTE DE FIRMA
				sql = "INSERT INTO PEDIDOS (CODCLI, FECHA, ESTADO, PEDIDO_AUTOMATICO)"
				sql = sql & " VALUES (" & oficina_destino  & ", GETDATE(), 'SIN TRATAR', 'IMPRESORA_GLS_GAG')"

				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
		
				Set valor_nuevo = connimprenta.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
				numero_pedido=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
				valor_nuevo.Close
				Set valor_nuevo = Nothing
				
				sql = "INSERT INTO PEDIDOS_DETALLES (ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, PRECIO_COSTE)"
				sql = sql & " VALUES (" & numero_pedido & ", 4583, 1, 0, 0, 'SIN TRATAR', 0)"
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				
				
				sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
				sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), 'EN REPARACION', '0', '" & direccion_ip & "',"
				sql = sql & " '" & perfil_seleccionado & "')"
				'response.write("<br>sql en revision: " & sql)
				
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
			end if
			
			'una retirada es una eliminacion fisica de la impresora, es como una baja pero no se puede reutilizar la impresora
			' y tampoco se impremente el stockse da de baja una impresora, se desvincula de la oficina que la tenia asignada y pasa a nuestro almacen, id cliente = 0
			if estado_seleccionado = "RETIRADA" then
				sql = "UPDATE GLS_IMPRESORAS SET ESTADO='RETIRADA', ID_CLIENTE=0"
				sql = sql & " WHERE SN_IMPRESORA = '" & sn_seleccionada & "'"
				'response.write("<br>sql baja: " & sql)
				
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
				
				sql = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL)"
				sql = sql & " VALUES ('" & sn_seleccionada & "', GETDATE(), 'RETIRADA', '0', '" & direccion_ip & "',"
				sql = sql & " '" & perfil_seleccionado & "')"
				'response.write("<br>sql baja: " & sql)
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
			end if
			
			
			cadena_respuesta = "{""mensaje"": ""mensaje"", ""contenido"": ""Impresora Modificada Con Éxito""}"
			connimprenta.CommitTrans
		  
		  else
			'error
			cadena_respuesta = "{""mensaje"": ""error"", ""contenido"": ""Se ha producido un error al tramitar la solicitud, salga de la aplicación y vuelva a intentarlo""}"
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