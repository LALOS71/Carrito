<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	pedido_seleccionado=Request.Form("pedido")
	
	'response.write("<br>pedido: " & pedido_seleccionado & "...")
	peso=0
	bultos=0
	palets=0
	albaran=""
	
	set palets_bultos_peso_pedido=Server.CreateObject("ADODB.Recordset")
	with palets_bultos_peso_pedido
		.ActiveConnection=connimprenta
		.Source="SELECT ID, PEDIDO, PESO, BULTOS, PALETS, ALBARAN"
		.Source=.Source & " FROM PALETS_BULTOS_PESO_ENVIOS"
		.Source=.Source & " WHERE PEDIDO=" & pedido_seleccionado
		.Source=.Source & " AND (ALBARAN IS NULL OR ALBARAN='')"
		.Source=.Source & " ORDER BY ID DESC"
		'response.write(.source)
		.Open
	end with
	if not palets_bultos_peso_pedido.EOF then
		peso = palets_bultos_peso_pedido("PESO")
		bultos = palets_bultos_peso_pedido("BULTOS")
		palets = palets_bultos_peso_pedido("PALETS")
		albaran = palets_bultos_peso_pedido("ALBARAN")
	end if
	
	'cadena=JSONData(referencias, "data")
	'cadena=REPLACE(cadena,"\", "\\")
	'cadena=REPLACE(cadena,"ñ", "nn")
	'adena=REPLACE(cadena,"Ñ", "NN")
	'cadena=REPLACE(cadena, chr(13), "\r\n")
	'cadena=REPLACE(cadena, chr(10), "")
	'Response.Write "{" & cadena & "}"
	
	Response.ContentType = "application/json"
	Response.Write "{""PESO"": """ & peso & """, ""BULTOS"": """ & bultos & """, ""PALETS"": """ & palets & """, ""ALBARAN"": """ & albaran & """}"
	'articulos.close
	set  palets_bultos_peso_pedido=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>



