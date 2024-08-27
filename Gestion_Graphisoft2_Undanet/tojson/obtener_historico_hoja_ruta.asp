<!--#include file="../DB_Manager.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Dim sql
	
	id_hoja_ruta = "" & request.QueryString("p_id_hoja_ruta")
	ver_cadena	 = "" & request.QueryString("p_vercadena")
	
	sql = "SELECT GESTION_GRAPHISOFT_HISTORICO_HOJAS.ID, GESTION_GRAPHISOFT_HISTORICO_HOJAS.ID_HOJA_RUTA, GESTION_GRAPHISOFT_HISTORICO_HOJAS.HOJA_RUTA"
	sql = sql & ", CONVERT(char(10), GESTION_GRAPHISOFT_HISTORICO_HOJAS.FECHA, 103) AS FECHA" 
	sql = sql & ", CONVERT(char(8), GESTION_GRAPHISOFT_HISTORICO_HOJAS.FECHA, 108) AS HORA"
	sql = sql & ", GESTION_GRAPHISOFT_HISTORICO_HOJAS.ESTADO, GESTION_GRAPHISOFT_HISTORICO_HOJAS.ACCION"
	sql = sql & ", GESTION_GRAPHISOFT_HISTORICO_HOJAS.CAMPO"
	sql = sql & ", REPLACE(GESTION_GRAPHISOFT_HISTORICO_HOJAS.VALOR_ANTIGUO, '""','\""') AS VALOR_ANTIGUO"
	sql = sql & ", REPLACE(GESTION_GRAPHISOFT_HISTORICO_HOJAS.VALOR_NUEVO, '""', '\""') AS VALOR_NUEVO"
	sql = sql & ", GESTION_GRAPHISOFT_HISTORICO_HOJAS.USUARIO, GESTION_GRAPHISOFT_HISTORICO_HOJAS.DESCRIPCION"
	sql = sql & ", (SELECT GESTION_GRAPHISOFT_USUARIOS.NOMBRE FROM GESTION_GRAPHISOFT_USUARIOS WHERE GESTION_GRAPHISOFT_HISTORICO_HOJAS.USUARIO = GESTION_GRAPHISOFT_USUARIOS.USUARIO) AS NOMBRE_USUARIO"
	sql = sql & " FROM GESTION_GRAPHISOFT_HISTORICO_HOJAS"
	sql = sql & " WHERE GESTION_GRAPHISOFT_HISTORICO_HOJAS.ID_HOJA_RUTA=" & id_hoja_ruta
	sql = sql & " ORDER BY GESTION_GRAPHISOFT_HISTORICO_HOJAS.FECHA DESC"	

	Response.CharSet = "iso-8859-15"
		
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		
	if ver_cadena="SI" then
		response.write("<br>" & sql & "<br><br>")
	end if
		
	'response.write("<br>" & sql & "<br><br>")	
		
	Set rs = execute_sql(conn_gag, sql)		
	
	Response.ContentType = "application/json"
	'Response.Write "{" & REPLACE(JSONData(rs, "ROWSET"), "\", "\\") & "}"

	cadena_pirs = JSONData(rs, "ROWSET")
	cadena_pirs = REPLACE(cadena_pirs,"\", "\\")
	cadena_pirs = REPLACE(cadena_pirs, chr(13), "\r\n")
	cadena_pirs = REPLACE(cadena_pirs, chr(10), "")
	Response.Write "{" & cadena_pirs & "}"

	close_connection(conn_gag)
%>



