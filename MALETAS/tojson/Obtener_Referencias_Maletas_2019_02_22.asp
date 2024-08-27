<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

        	
	set referencias=Server.CreateObject("ADODB.Recordset")
		
	with referencias
		.ActiveConnection=connmaletas
		
		.Source="SELECT REFERENCIA + ' (' + TIPO_MALETA + ') (' + TAMANNO + ') (' + COLOR + ')' TODO,"
		.Source=.Source & " REFERENCIA, TIPO_MALETA, TAMANNO, COLOR FROM REFERENCIAS_MALETAS"
			
		'RESPONSE.WRITE("<BR>" & .Source)
		.Open
	end with

	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(referencias, "data") & "}"
	'articulos.close
	set referencias=Nothing
	
	connmaletas.close
	set connmaletas=Nothing
%>



