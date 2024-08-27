<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	borrados= "" & request.querystring("borrados")
	
	empresa_seleccionada="" & request.QueryString("usuario")
	ver_cadena="" & request.QueryString("pver_cadena")
	
	dim clientes
		set clientes=Server.CreateObject("ADODB.Recordset")
		
		'sql="Select id, nombre  from hoteles"
		'sql=sql & " order by nombre"
		
		sql="SELECT  V_CLIENTES.Id,"
		sql=sql & " CASE WHEN V_CLIENTES.CODIGO_EXTERNO IS NULL"
		sql=sql & " THEN V_CLIENTES.NOMBRE"
		sql=sql & " ELSE V_CLIENTES.NOMBRE + ' (' + V_CLIENTES.CODIGO_EXTERNO + ')'"
		sql=sql & " END AS NOMBRE"
		sql=sql & " FROM V_CLIENTES"
		sql=sql & " WHERE V_CLIENTES.EMPRESA='" & empresa_seleccionada & "'"
		'sql=sql & " WHERE V_CLIENTES.EMPRESA='4'"
		if borrados="" or borrados="NO" or borrados=false then
			sql=sql & " AND V_CLIENTES.BORRADO='NO'"
		end if
		'para el administrador de gls portugal, que solo salgan las oficinas de portugal
		if usuario_seleccionado="7637" then
			sql=sql & " AND PAIS='PORTUGAL'"
		end if
		sql=sql & " ORDER BY V_CLIENTES.NOMBRE"
		

		
		if ver_cadena="SI" then
			response.write("<br>consulta clientes: " & sql)
		end if
		
		with clientes
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
		


	
		
		
		
	Response.ContentType = "application/json"
	'Response.Write JSONData(clientes,null,"NO")
	Response.Write "{" & JSONData(clientes,"CLIENTES","SI") & "}"



	'clientes.close
	set clientes=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>

