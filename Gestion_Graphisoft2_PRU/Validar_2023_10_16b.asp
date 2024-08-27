<!--#include file="DB_Manager.inc"-->
<%
	Response.Charset = "UTF-8"
	Response.ContentType = "application/json; charset=UTF-8"
	
	

Dim cadena_json


    
	Dim usuarios

	usuario_seleccionado = Request.Form("username")
	contrasenna_seleccionada = Request.Form("password")
	'usuario_seleccionado=19316
	'usuario_seleccionado=Request.QueryString("txtusuario")		
		
		
	Session("usuario") = ""
	Session("nombre_usuario") = ""
	Session("perfil_usuario") = ""
	cadena_json = ""
	
	sql = "SELECT * FROM GESTION_GRAPHISOFT_USUARIOS"
	sql = sql & " WHERE USUARIO='" & usuario_seleccionado & "'"
	sql = sql & " AND BORRADO='NO'"
	
	Set usuarios = execute_sql(conn_gag, sql)
	
	If Not usuarios.EOF Then
		if usuarios("GRUPO") = "EXTERNOS" then
			'validacion desde aqui
			if usuarios("CONTRASENNA") = contrasenna_seleccionada then
				codigo = "0"
				mensaje = "Usuario y Contraseña Correctos"
				cadena_json = "{""codigo"": """ & codigo & """, ""mensaje"": """ & mensaje & """}"
				Session("usuario") = usuarios("usuario")
				Session("nombre_usuario") = usuarios("nombre")
				Session("perfil_usuario") = usuarios("perfil")
			else
				codigo = "1"
				mensaje = "Usuario o Contraseña Incorrectos"
				cadena_json = "{""codigo"": """ & codigo & """, ""mensaje"": """ & mensaje & """}"
				
			end if
		else
			'validacion desde el active directory
		
		end if
	else
		'el usuario no existe
		codigo = "1"
		mensaje = "Usuario o Contraseña Incorrectos"
		cadena_json = "{""codigo"": """ & codigo & """, ""mensaje"": """ & mensaje & """}"
	end if

	close_connection(usuarios)	
	close_connection(conn_gag)
		
	Response.Write(cadena_json)
%>

