<!--#include file="DB_Manager.inc"-->
<%
    Dim usuarios

	usuario_seleccionado = Request.Form("txtusuario")
	'usuario_seleccionado=19316
	'usuario_seleccionado=Request.QueryString("txtusuario")		
	
	sql = "SELECT * FROM GESTION_GRAPHISOFT_USUARIOS"
	sql = sql & " WHERE USUARIO='" & usuario_seleccionado & "'"
	sql = sql & " AND BORRADO='NO'"
	
	Set usuarios = execute_sql(conn_gag, sql)

	Session("usuario") = ""
	Session("nombre_usuario") = ""
	Session("perfil_usuario") = ""
	validado=0

	If Not usuarios.eof Then
		Session("usuario") = usuarios("usuario")
		Session("nombre_usuario") = usuarios("nombre")
		Session("perfil_usuario") = usuarios("perfil")
		validado=1
	End If

	close_connection(usuarios)	
	close_connection(conn_gag)
		
	Response.Write(validado)
%>

