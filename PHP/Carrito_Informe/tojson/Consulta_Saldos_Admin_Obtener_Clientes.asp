<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->
<%
	Response.CharSet = "iso-8859-1"
	
	
	empresa_seleccionada = "" & request.form("empresa")
	if empresa_seleccionada="" then
		empresa_seleccionada="" & request.querystring("p_empresa")
	end if
	ver_cadena="" & request.querystring("p_vercadena")
	
	
	CAMPO_ID_CLIENTES=0
	CAMPO_EMPRESA_CLIENTES=1
	CAMPO_NOMBRE_CLIENTES=2
	CAMPO_CODIGO_EXTERNO_CLIENTES=3
	sql="SELECT  V_CLIENTES.ID, V_EMPRESAS.EMPRESA, V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
	sql=sql & " FROM V_CLIENTES INNER JOIN V_EMPRESAS"
	sql=sql & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
	sql=sql & " WHERE 1=1"
	if empresa_seleccionada<>"" then
		sql=sql & " AND V_CLIENTES.EMPRESA=" & empresa_seleccionada
	end if
	sql=sql & " ORDER BY V_EMPRESAS.EMPRESA, V_CLIENTES.NOMBRE"

	'response.write("<br><br>CLIENTES: " & sql)
	if ver_cadena="SI" then
			response.write("<br><br>CLIENTES: " & sql)
	end if

	set clientes=Server.CreateObject("ADODB.Recordset")
	with clientes
		.ActiveConnection=connimprenta
		.Source=sql
		.Open
	end with
		
	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(clientes, "data") & "}"

	set clientes=Nothing
	
	
	connimprenta.close
	set connimprenta=Nothing
%>
