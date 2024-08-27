<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="jsonobject/jsonObject.class.inc"-->


<%
	'response.write("<br>hora entramos: " & now())	
	Response.LCID = 1034 ' REQUIRED! Set your LCID here (1046 = Brazilian). Could also be the LCID property of the page declaration or the Session.LCID property
	'Response.CharSet = "iso-8859-1"
	Response.ContentType = "application/json"
	

	
	'response.write("<br>estados: " & estado_seleccionado)
	
			
	'RESPONSE.WRITE("<BR>" & cadena_sql)
	

	cadena="SELECT DESCRIPCION"

	cadena=cadena & " FROM ARTICULOS"
	
	set articulos=connimprenta.execute(cadena)
	
	
	
	'Response.Write "{" & JSONData(hojas_ruta, "ROWSET") & "}"
	
	
	
	set JSON = New JSONobject

	
	
	JSON.defaultPropertyName = "data"
	
	JSON.LoadRecordset articulos
	
	'articulos.close
	set articulos=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
	
	JSON.Write()
	
	'response.write("<br>cadena OBJETO JSON: " & JSON.Write())
	'response.write("<br>cadena OBJETO JSONarr: " & JSONarr.Write())
	
	

	
%>



