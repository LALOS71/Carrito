<!--#include file="../DB_Manager.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Dim sql
	sql = "SELECT DISTINCT RTRIM(LTRIM(PRESUPUESTISTA)) AS PRESUPUESTISTA"
	sql = sql & " FROM GESTION_GRAPHISOFT_PRESUPUESTOS"
	sql = sql & " ORDER BY PRESUPUESTISTA"

	'Response.CharSet = "utf-8"
	Response.CharSet = "iso-8859-15"

	Set presupuestistas = execute_sql(conn_gag, sql)

	Response.ContentType = "application/json"
	
	cadena = JSONData(presupuestistas, "data")
	cadena = REPLACE(cadena,"\", "\\")
	cadena = REPLACE(cadena, chr(13), "\r\n")
	cadena = REPLACE(cadena, chr(10), "")

	Response.Write "{" & cadena & "}"
	
	close_connection(conn_gag)
%>



