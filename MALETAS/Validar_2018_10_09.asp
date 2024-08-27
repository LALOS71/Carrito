<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%

    dim usuarios

	
	'usuario_seleccionado=Request.Form("txtusuario")

	usuario_seleccionado=Request.QueryString("txtusuario")		
		
	set usuarios=Server.CreateObject("ADODB.Recordset")
		
	sql="SELECT * FROM USUARIOS"
	sql=sql & " WHERE USUARIO='" & usuario_seleccionado & "'"
	
		
	'response.write("<br>" & sql)
		
	with usuarios
		.ActiveConnection=connmaletas
		.Source=sql
		.Open
	end with

	session("usuario")=""
	session("nombre_usuario")=""
	session("perfil_usuario")=""
	session("proveedor_usuario")=""
	validado=0
	if not usuarios.eof then
		session("usuario")=usuarios("usuario")
		session("nombre_usuario")=usuarios("nombre")
		session("perfil_usuario")=usuarios("perfil")
		if session("perfil_usuario")="PROVEEDOR" then
			session("proveedor_usuario")=usuarios("id_proveedor")
		end if
		validado=1
	end if
		
		
	usuarios.close
	connmaletas.close
	set usuarios = Nothing
	set connmaletas=Nothing
		
	response.write(validado)

%>

