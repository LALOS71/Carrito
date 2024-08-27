<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	sn_impresoras= "" & Request.Form("sn_impresoras")
	cadena_json = ""
	if sn_impresoras<>"" then
		sn_impresoras = Replace(sn_impresoras, "###", "', '")
	
		set impresoras=Server.CreateObject("ADODB.Recordset")
		with impresoras
			.ActiveConnection=connimprenta
			.Source="SELECT SN_IMPRESORA, ESTADO"
			.Source=.Source & " FROM GLS_IMPRESORAS"
			.Source=.Source & " WHERE SN_IMPRESORA IN ('" & sn_impresoras & "')"
			'response.write(.source)
			.Open
		end with
		cadena_json=""
		if not impresoras.EOF then
			while not impresoras.EOF
				cadena_json = cadena_json & "{ ""sn_impresora"": """ & impresoras("SN_IMPRESORA") & """, ""estado"": """ & impresoras("ESTADO") & """ },"
				impresoras.movenext
			wend
			cadena_json = Left(cadena_json, Len(cadena_json) - 1)
		end if
		impresoras.close
		set impresoras=Nothing
	end if
	
	cadena_json = "{""REGISTROS"": [" & cadena_json & "]}"	
	
	Response.ContentType = "application/json"
	Response.Write cadena_json

	connimprenta.close
	set connimprenta=Nothing
%>



