<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	'empresa_seleccionada=Request.QueryString("empresa")
	empresa_seleccionada= "" & Request.Form("empresa")
	tipo_oficina= "" & Request.Form("tipo")
	consulta= "" & Request.Form("nombre")
	
	
	set referencias=Server.CreateObject("ADODB.Recordset")
		
	with referencias
		.ActiveConnection=connimprenta
		
		.Source="SELECT ID, CODIGO_EXTERNO, NOMBRE, DIRECCION, POBLACION, PROVINCIA, CP, PAIS, TELEFONO FROM V_CLIENTES"
		.Source=.Source & " WHERE EMPRESA=" & empresa_seleccionada
		if empresa_seleccionada=4 then
			if tipo_oficina<>"" then
				if tipo_oficina="PROPIA" then
					.Source=.Source & " AND TIPO='GLS PROPIA'"
				  else
				  	.Source=.Source & " AND TIPO<>'GLS PROPIA'"
				end if
			end if
		end if
		if consulta<>"" then
			.Source=.Source & " AND NOMBRE LIKE '%" & consulta & "%'"
		end if
		.Source=.Source & " AND BORRADO='NO'"
		
		'para Air Europa se añaden unas direcciones adicionales que no son oficinas de Air Europa o clientes nuestros ya creados
		if empresa_seleccionada=40 then
			.Source=.Source & " UNION"
			.Source=.Source & " SELECT NULL, NULL, NOMBRE_DESTINATARIO, DIRECCION, POBLACION, PROVINCIA, CP, PAIS, TELEFONO"
			.Source=.Source & " FROM DIRECCIONES_ENVIO_ADICIONALES"
			.Source=.Source & " WHERE CODIGO_EMPRESA=" & empresa_seleccionada
			if consulta<>"" then
				.Source=.Source & " AND NOMBRE_DESTINATARIO LIKE '%" & consulta & "%'"
			end if
		
		end if
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



