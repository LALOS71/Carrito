<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	
	set referencias=Server.CreateObject("ADODB.Recordset")
		
	with referencias
		.ActiveConnection=connimprenta
		
		.Source="SELECT ID, CODIGO_EXTERNO, NOMBRE, DIRECCION, POBLACION, PROVINCIA, CP, PAIS, TELEFONO FROM V_CLIENTES"
		.Source=.Source & " WHERE EMPRESA=4"
		.Source=.Source & " AND TIPO='GLS PROPIA'"
		.Source=.Source & " AND BORRADO='NO'"
		.Source=.Source & " ORDER BY NOMBRE"
		'RESPONSE.WRITE("<BR>" & .Source)
		.Open
	end with

	Response.ContentType = "application/json"
	
	'cadena=JSONData(referencias, "data")
	'cadena=REPLACE(cadena,"\", "\\")
	'cadena=REPLACE(cadena,"ñ", "nn")
	'adena=REPLACE(cadena,"Ñ", "NN")
	'cadena=REPLACE(cadena, chr(13), "\r\n")
	'cadena=REPLACE(cadena, chr(10), "")
	'Response.Write "{" & cadena & "}"
	
	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(referencias, "data") & "}"
	
	
	'articulos.close
	set referencias=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>



