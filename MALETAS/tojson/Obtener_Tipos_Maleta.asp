<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	
			cadena_sql="SELECT ID, CODIGO, DESCRIPCION, ORDEN, BORRADO"
			cadena_sql=cadena_sql & " FROM TIPOS_MALETA"
			cadena_sql=cadena_sql & " ORDER BY ORDEN"


			Set rs = Server.CreateObject("ADODB.recordset")
			rs.Open cadena_sql, connmaletas
			Response.ContentType = "application/json"
			Response.Write "{" & REPLACE(JSONData(rs, "ROWSET"), "\", "\\") & "}"

			
			connmaletas.close
			set connmaletas=Nothing
		
%>
