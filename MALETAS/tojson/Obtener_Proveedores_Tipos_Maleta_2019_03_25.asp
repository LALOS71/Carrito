<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	id_proveedor=Request.Form("id_proveedor")
	'id_proveedor=1
	
			cadena_sql="SELECT A.ID, A.CODIGO, A.DESCRIPCION"
			cadena_sql=cadena_sql & ", DESCRIPCION + ' (' + CODIGO + ')' AS DESCRIPCION_MALETA"
			cadena_sql=cadena_sql & ", B.ID_PROVEEDOR"
			cadena_sql=cadena_sql & " FROM TIPOS_MALETA A"
			cadena_sql=cadena_sql & " LEFT JOIN"
			cadena_sql=cadena_sql & " (SELECT * FROM PROVEEDORES_TIPOS_MALETA"
			cadena_sql=cadena_sql & " WHERE ID_PROVEEDOR=" & id_proveedor & ") B"
			cadena_sql=cadena_sql & " ON A.ID=B.ID_TIPO_MALETA"
			cadena_sql=cadena_sql & " ORDER BY DESCRIPCION_MALETA"
			
			'response.write(cadena_sql)

			Set rs = Server.CreateObject("ADODB.recordset")
			rs.Open cadena_sql, connmaletas
			Response.ContentType = "application/json"
			Response.Write "{" & JSONData(rs, "ROWSET") & "}"

			
			connmaletas.close
			set connmaletas=Nothing
		
%>
