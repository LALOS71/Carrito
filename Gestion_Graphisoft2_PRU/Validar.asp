<!--#include file="DB_Manager.inc"-->
<!--#include file="Conexion_ORACLE_Active_Directory.inc"-->
<%
	Response.Charset = "UTF-8"
	Response.ContentType = "application/json; charset=UTF-8"
	
	




    
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
			'validacion desde el active directory en ORACLE
			
			
			'por si escribe el usuario como "DOMINIO\usuario"
			usuario_solo=usuario_seleccionado
			if instr(usuario_solo, "\") then
				MiCadena = Split(usuario_solo, "\")
				dominio=MiCadena(0)
				usuario_solo=MiCadena(1)
			end if
			
			
			adCmdStoredProc=4
			adVarChar=200
			adParamInput=1
		
				
			set cmd = Server.CreateObject("ADODB.Command")
			set cmd.ActiveConnection = conn_actdir
		
			conn_actdir.BeginTrans 'Comenzamos la Transaccion
			
			
			cmd.CommandText = "ACTDIR.pkg_dbms_usr.login"
			cmd.CommandType = adCmdStoredProc
				
			cmd.parameters.append cmd.createparameter("C_USUARIO",adVarChar,adParamInput,255)
			cmd.parameters.append cmd.createparameter("C_PASSWORD",adVarChar,adParamInput,255)
			cmd.parameters.append cmd.createparameter("C_TIPO",adVarChar,adParamInput,255)
			
			
			
			cmd.parameters("C_USUARIO") = "" & usuario_solo
			cmd.parameters("C_PASSWORD") = "" & contrasenna_seleccionada
			
			'La T indica que busque el usuario en alguno de los dominios (MINORISTA, NO MINORISTA, EXTERNOS) 
			' y después que lo valide.
			cmd.parameters("C_TIPO") = "T"
		
			   
			valor_devuelto=0
			texto_devuelto="Usuario y Contraseña Correctos"
			'response.write("<br>antes de ejecutar el comand")
			on error resume next
			cmd.execute()
			on error goto 0
			'response.write("<br>despues de ejecutar el comand")
			
			'response.write("<br>numero de errores: " & conn_actdir.errors.count)
			if conn_actdir.errors.count>0 then
				'errores conocidos que devuelve oracle en funcion del usuario del active directory y contraseña introducidos
				select case mid(conn_actdir.errors(0).Description,20,9)
				
					case "ORA-20106":
								valor_devuelto=20106
								texto_devuelto="La Cuenta De Usuario del Dominio Está Cadudada, no puede acceder a la aplicación."
									
					case "ORA-01017":
								valor_devuelto=1017
								texto_devuelto="Usuario/Contraseña Incorrectos, vuelva a introducirlos."	
							
					case "ORA-20101":
								valor_devuelto=20101
								texto_devuelto="La Cuenta de Usuario del Active Directory está Bloqueada."
					
					case "ORA-20102":
								valor_devuelto=20102
								texto_devuelto="La Contraseña del Usuario del Dominio Está Caducada, no puede acceder a la aplicación."	
									
					case else
								valor_devuelto=conn_actdir.errors(0).Number
								texto_devuelto=conn_actdir.errors(0).Description
				end select
			
			else
				'la validacion en el active directory ha sido correcta
				'establecemos las variables de sesion
				Session("usuario") = usuarios("usuario")
				Session("nombre_usuario") = usuarios("nombre")
				Session("perfil_usuario") = usuarios("perfil")
			end if
		
			'response.write("<br>final<br><br>")
			cadena_json = "{""codigo"": """ & valor_devuelto & """, ""mensaje"": """ & texto_devuelto & """}"
		
			conn_actdir.CommitTrans ' finaliza la transaccion
		
			set cmd=Nothing
			
			conn_actdir.close
			set conn_actdir=Nothing

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

