<!--#include file="../DB_Manager.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Dim sql

	ver_cadena=""
	
	Response.CharSet = "iso-8859-15"
	
	'tipo=Request.Form("p_tipo")		
	ver_cadena=Request.QueryString("p_vercadena")

	

	sql = "SELECT A.ID, MAX(A.NOMBRE) AS NOMBRE"
	sql = sql & " FROM GESTION_GRAPHISOFT_CLIENTES A"
	sql = sql & " INNER JOIN GESTION_GRAPHISOFT_HOJAS_IMPORTADAS B"
	sql = sql & " ON A.ID = B.ID_CLIENTE"
	

	sql = sql & " GROUP BY A.ID"
	sql = sql & " ORDER BY NOMBRE"
	
	if ver_cadena="SI" then
		RESPONSE.WRITE("<BR>" & SQL)
	end if

	Set clientes = execute_sql(conn_gag, sql)

	Response.ContentType = "application/json"
	cadena=JSONData(clientes, "data")
	cadena=REPLACE(cadena,"\", "\\")
	cadena=REPLACE(cadena, chr(13), "\r\n")
	cadena=REPLACE(cadena, chr(10), "")
	Response.Write "{" & cadena & "}"
	
	'articulos.close
	'close_connection(clientes)
	close_connection(conn_gag)
%>