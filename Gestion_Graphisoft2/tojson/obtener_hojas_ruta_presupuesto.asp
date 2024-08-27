<!--#include file="../DB_Manager.inc"-->
<!--#include file="jsonobject/jsonObject.class.inc"-->
<%
	Dim sql
	Set JSON = New JSONobject

	'response.write("<br>hora entramos: " & now())	
	Response.LCID = 1034 ' REQUIRED! Set your LCID here (1046 = Brazilian). Could also be the LCID property of the page declaration or the Session.LCID property
	'Response.CharSet = "iso-8859-1"
	Response.ContentType = "application/json"
	
	presupuesto_seleccionado 		= "" & request.QueryString("p_presupuesto")

	sql = "SELECT HOJA_DE_RUTA, ESTADO, CLIENTE_NOMBRE, REFERENCIA, SUBCONTRATISTA, FECHA_EMISION FROM GESTION_GRAPHISOFT_HOJAS_IMPORTADAS WHERE PRESUPUESTO = " & presupuesto_seleccionado & " ORDER BY HOJA_DE_RUTA"
		
	'RESPONSE.WRITE("<BR>" & sql)

	Set hojas_ruta = execute_sql(conn_gag, sql)	
	
	'Response.Write "{" & JSONData(hojas_ruta, "ROWSET") & "}"
	
	JSON.defaultPropertyName = "ROWSET"	
	JSON.LoadRecordset hojas_ruta
	
	'articulos.close
	close_connection(hojas_ruta)
	close_connection(conn_gag)
	
	JSON.Write()
	
%>