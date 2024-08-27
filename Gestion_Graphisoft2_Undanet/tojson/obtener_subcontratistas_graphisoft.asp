<!--#include file="../DB_Manager.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Dim sql
	sql = "SELECT SUBCONTRATISTA"
	sql = sql & " FROM GESTION_GRAPHISOFT_SUBCONTRATISTAS"
	sql = sql & " ORDER BY SUBCONTRATISTA"

	Response.CharSet = "iso-8859-15"

	Set subcontratistas = execute_sql(conn_gag, sql)

	Response.ContentType = "application/json"
	
	cadena = JSONData(subcontratistas, "data")
	cadena = REPLACE(cadena,"\", "\\")
	cadena = REPLACE(cadena, chr(13), "\r\n")
	cadena = REPLACE(cadena, chr(10), "")

	Response.Write "{" & cadena & "}"
	
	close_connection(conn_gag)
%>



