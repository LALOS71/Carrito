<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	
			cadena_sql="SELECT ID, USUARIO, NOMBRE, PERFIL"
			cadena_sql=cadena_sql & ", (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=USUARIOS.ID_PROVEEDOR) AS PROVEEDOR"
			cadena_sql=cadena_sql & ", TIPO_USUARIO, CONTRASENNA, BORRADO"
			cadena_sql=cadena_sql & " FROM USUARIOS"
			cadena_sql=cadena_sql & " ORDER BY NOMBRE"


			Set rs = Server.CreateObject("ADODB.recordset")
			rs.Open cadena_sql, connmaletas
			Response.ContentType = "application/json"
			Response.Write "{" & JSONData(rs, "ROWSET") & "}"

			
			connmaletas.close
			set connmaletas=Nothing
		
%>
