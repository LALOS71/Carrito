<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	usuario=Request.Form("usuario")
	contrasenna=Request.Form("contrasenna")
	
	
	session("usuario")=""
	session("nombre_usuario")=""
	session("perfil_usuario")=""
	session("proveedor_usuario")=""
	
	'response.write("<br>usuario: " & usuario)
	'response.write("<br>contrasenna: " & contrasenna)
		
	set usuarios=Server.CreateObject("ADODB.Recordset")
		with usuarios
			.ActiveConnection=connmaletas
			.Source="SELECT * FROM USUARIOS"
			.Source= .Source & " WHERE BORRADO='NO'"
			.Source= .Source & " AND USUARIO='" & usuario & "'"
			'response.write("<br>consulta:" & .source)
			.Open
		end with

		cadena_devuelta=""
		if not usuarios.eof then
			if usuarios("TIPO_USUARIO")="INTERNO" then
				cadena_devuelta="INTERNO" 'para que se valide en el active directory
			  else 'es un usuario externo y no se valida en el active directory sino en la aplicacion de maletas
			  	if usuarios("contrasenna")=contrasenna then
					cadena_devuelta="1" 'el usuario externo ha puesto la contraseña correcta
					session("usuario")=usuarios("usuario")
					session("nombre_usuario")=usuarios("nombre")
					session("perfil_usuario")=usuarios("perfil")
					if session("perfil_usuario")="PROVEEDOR" then
						session("proveedor_usuario")=usuarios("id_proveedor")
					end if
				  else
				  	cadena_devuelta="2" 'el usuario externo no ha puesto la contraseña correcta
				end if
			  	
			end if
			
		  else
		  	cadena_devuelta="0" 'el usuario no está dado de alta en el sistema de maletas
		end if
		
		response.write(cadena_devuelta)

		usuarios.close
		set usuarios=Nothing

	
	connmaletas.close
	set connmaletas=Nothing
%>
