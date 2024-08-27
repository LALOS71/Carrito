<!--#include file="../DB_Manager.inc"-->
<!--#include file="jsonobject/jsonObject.class.inc"-->
<%
	Dim sql
	Dim query_options

	Set JSON = New JSONobject

	'response.write("<br>hora entramos: " & now())	
	Response.LCID = 1034 ' REQUIRED! Set your LCID here (1046 = Brazilian). Could also be the LCID property of the page declaration or the Session.LCID property
	'Response.CharSet = "iso-8859-1"
	Response.ContentType = "application/json"
	
	hoja_ruta_seleccionada 		= "" & request.QueryString("p_hoja_ruta")
	estado_seleccionado 		= "" & request.QueryString("p_estado")
	cliente_seleccionado 		= "" & request.QueryString("p_cliente")
	referencia_seleccionada 	= "" & request.QueryString("p_referencia")
	subcontratista_seleccionado = "" & request.QueryString("p_subcontratista")
	fecha_entrega_seleccionada 	= "" & request.QueryString("p_fecha_entrega")
	salida_seleccionada			= "" & request.QueryString("p_salida")
	ejecutar_consulta 			= "" & request.QueryString("p_ejecutar")
	
	ver_cadena 					= "" & request.QueryString("p_vercadena")

	'response.write("<br>estados: " & estado_seleccionado)
	
	'no paso la descripcion, paso el codigo
	'estados_seleccionados=replace(estado_seleccionado, ",", "','")
	estados_seleccionados = estado_seleccionado
	
	'NO LO HAGO EN CADA CONSULTA... PARA ESO HEMOS PUESTO LOS BOTONES Y LOS PROCEDIMIENTOS PROGRAMADOS CADA X TIEMPO
	'conn_gag.execute("EXEC sp_GESTION_GRAPHISOFT_INSERTAR_HOJAS_NUEVAS")
	'conn_gag.execute("EXEC sp_GESTION_GRAPHISOFT_MODIFICAR_HOJAS_EXISTENTES")

	sql ="SELECT"
	'sq l= sql & " PRESUPUESTISTA"
	sql = sql & " A.HOJA_DE_RUTA"
	sql = sql & ", B.DESCRIPCION ESTADO"
	sql = sql & ", A.FECHA_EMISION"
	'sq l= sql & ", PRODUCTO"
	sql = sql & ", A.ID_CLIENTE"
	sql = sql & ", C.NOMBRE AS CLIENTE_NOMBRE"
	sql = sql & ", REPLACE(A.REFERENCIA, '""', '\""') REFERENCIA"
	'sq l= sql & ", CANTIDAD"
	sql = sql & ", A.SUBCONTRATISTA"
	sql = sql & ", A.FECHA_ENTREGA"
	'sq l= sql & ", 'lalala' CADENA_ALBARANES"
 	sql = sql & ", A.SALIDA"
	sql = sql & ", STUFF("
	sql = sql & "		(SELECT ';' + CONVERT(nvarchar(50), IdAlbaran, 103)"
	sql = sql & "			FROM Albaranes_Detalles"
	sql = sql & "			WHERE IdNTrabajo=A.HOJA_DE_RUTA COLLATE Modern_Spanish_CS_AS"
	sql = sql & "			FOR XML PATH (''))"
	sql = sql & "		, 1, 1, '') CADENA_ALBARANES"
	sql = sql & ", A.ID_ESTADO"
	sql = sql & ", A.ID"
	sql = sql & ", A.OBSERVACIONES_GESTION"
	sql = sql & ", A.PRESUPUESTISTA"
	

	sql = sql & " FROM GESTION_GRAPHISOFT_HOJAS_IMPORTADAS A"	
	sql = sql & " LEFT JOIN GESTION_GRAPHISOFT_ESTADOS B"	
	sql = sql & " ON A.ID_ESTADO=B.ID"
	sql = sql & " LEFT JOIN GESTION_GRAPHISOFT_CLIENTES C"
	sql = sql & " ON A.ID_CLIENTE=C.ID"	
			
	sql= sql & " WHERE A.HOJA_DE_RUTA>2019010000"

	If hoja_ruta_seleccionada <> "" Then
		sql = sql & " AND UPPER(A.HOJA_DE_RUTA)=" & hoja_ruta_seleccionada 
	End If
	If estados_seleccionados <> "" Then
		'sql = sql & " AND UPPER(A.ESTADO) IN ('" & UCASE(estados_seleccionados) & "')"
		sql = sql & " AND A.ID_ESTADO IN (" & estados_seleccionados & ")"
	End If
	If cliente_seleccionado <> "" Then
        sql = sql & " AND A.ID_CLIENTE=" & cliente_seleccionado
    End If
	If referencia_seleccionada <> "" Then
		sql = sql & " AND UPPER(A.REFERENCIA) LIKE '%" & UCASE(referencia_seleccionada) & "%'"
	End If
	If subcontratista_seleccionado <> "" Then
		sql = sql & " AND UPPER(A.SUBCONTRATISTA) LIKE '%" & UCASE(subcontratista_seleccionado) & "%'"
	End If
	If fecha_entrega_seleccionada <> "" Then
		sql = sql & " AND CONVERT(VARCHAR, A.FECHA_ENTREGA, 103)=CONVERT(VARCHAR, '" & cdate(fecha_entrega_seleccionada) & "', 103)"
	End If
	If salida_seleccionada <> "" Then
		sql= sql & " AND UPPER(A.SALIDA)='" & UCASE(salida_seleccionada) & "'"
	End If	
	
	'para que no muestre toda la lista de articulos si no se selecciona nada
	'if empresa_seleccionada="" and codigo_sap_seleccionado="" and descripcion_seleccionada="" and campo_eliminado="NO" and campo_autorizacion="" then
	If ejecutar_consulta <> "SI" Then
		sql = sql & " AND A.HOJA_DE_RUTA=0"
	End If
		
	sql = sql & " ORDER BY A.HOJA_DE_RUTA DESC"
		
	'RESPONSE.WRITE("<BR>" & sql)
	
	If ver_cadena="SI" 	Then
		RESPONSE.WRITE("<BR>" & cadena_sql)
	End If

	Set hojas_ruta = execute_sql(conn_gag, sql)	
	
	'Response.Write "{" & JSONData(hojas_ruta, "ROWSET") & "}"
	
	JSON.defaultPropertyName = "ROWSET"	
	JSON.LoadRecordset hojas_ruta
	
	'articulos.close
	close_connection(hojas_ruta)
	close_connection(conn_gag)
	
	JSON.Write()
	
	'response.write("<br>cadena OBJETO JSON: " & JSON.Write())
	'response.write("<br>cadena OBJETO JSONarr: " & JSONarr.Write())
	
%>