<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

        	
	set articulos=Server.CreateObject("ADODB.Recordset")
		
	with articulos
		.ActiveConnection=connimprenta
		.Source="SELECT DESCRIPCION"
		'.Source="SELECT ARTICULOS.ID, ARTICULOS.CODIGO_SAP, replace(ARTICULOS.DESCRIPCION,'""', '\""') AS DESCRIPCION"
		'.Source= .Source & ", '(' + ARTICULOS.CODIGO_SAP + ') ' + replace(ARTICULOS.DESCRIPCION,'""', '\""') AS TODO"
		
		.Source= .Source & " FROM ARTICULOS"
		'.Source= .Source & " ORDER BY ARTICULOS.DESCRIPCION"
			
		.Open
	end with


	Response.ContentType = "application/json"
	
	cadena=JSONData(articulos, "data")
	cadena=REPLACE(cadena,"\", "\\")
	cadena=REPLACE(cadena, chr(13), "\r\n")
	cadena=REPLACE(cadena, chr(10), "")
	Response.Write "{" & cadena & "}"
	
	
	
	
	'articulos.close
	set articulos=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>



