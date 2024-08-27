<%@ language=vbscript %>
<!--#include file="../Conexion_GAG_PRO.inc"-->
<!--#include file="JSONData2.inc"-->

<%
	Response.CharSet = "iso-8859-1"

        	
	set clientes=Server.CreateObject("ADODB.Recordset")
		
	with clientes
		.ActiveConnection=conn_gag
		
		.Source="SELECT CLIENTE FROM GESTION_GRAPHISOFT_CLIENTES ORDER BY CLIENTE"
			
		'RESPONSE.WRITE("<BR>" & .Source)
		.Open
	end with

	Response.ContentType = "application/json"
	'Response.Write "{" & JSONData(clientes, "ROWSET") & "}"
	Response.Write JSONData_cmb(clientes)
	'articulos.close
	set clientes=Nothing
	
	conn_gag.close
	set conn_gag=Nothing
%>



