<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	nif=Request.Form("nif") 
	
	set referencias=Server.CreateObject("ADODB.Recordset")
		
	with referencias
		.ActiveConnection=connimprenta
		
		.Source="SELECT ID, NIF_FACTURAR,NOMBRE_FISCAL_FACTURAR"
		.Source=.Source & ",DIRECCION_FACTURAR, CIUDAD_FACTURAR, PROVINCIA_FACTURAR, CP_FACTURAR, IDPAIS"
		.Source=.Source & ",DIRECCION, POBLACION, PROVINCIA, CP"
		.Source=.Source & ",TELEFONO, EMAIL, EMPRESA"
		.Source=.Source & " FROM V_CLIENTES"
		.Source=.Source & " WHERE NIF_FACTURAR LIKE '%" & nif & "%'"
		'RESPONSE.WRITE("<BR>" & .Source)
		.Open
	end with

	Response.ContentType = "application/json"
	Response.Write "{" & REPLACE(JSONData(referencias, "data"), "\", "\\") & "}"
	'articulos.close
	set referencias=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>



