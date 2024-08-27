<%@ language=vbscript %>
<!--#include file="Conexion_ORACLE_Active_Directory.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	
	
	
	usuario=Request.Form("username")
	contrasenna=Request.Form("password")

	'si no viene por formulario, lo cogemos por querystring
	if usuario="" then
		usuario=Request.Querystring("username")
		contrasenna=Request.Querystring("password")
	end if
	
	'por si escribe el usuario como "DOMINIO\usuario"
	usuario_solo=usuario
	if instr(usuario_solo, "\") then
		MiCadena = Split(usuario_solo, "\")
		dominio=MiCadena(0)
		usuario_solo=MiCadena(1)
	end if

	'response.write("<br>Usuario: " & usuario)
	'response.write("<br>Usuario Solo: " & usuario_solo)
	'response.write("<br>contraseña: " & contrasenna)
	


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
	cmd.parameters("C_PASSWORD") = "" & contrasenna
	
	'La T indica que busque el usuario en alguno de los dominios (MINORISTA, NO MINORISTA, EXTERNOS) 
	' y después que lo valide.
	cmd.parameters("C_TIPO") = "T"

	   
	valor_devuelto=0
	texto_devuelto=""
	'response.write("<br>antes de ejecutar el comand")
	on error resume next
	cmd.execute()
	on error goto 0
	'response.write("<br>despues de ejecutar el comand")
	
	'response.write("<br>numero de errores: " & conn_actdir.errors.count)
	if conn_actdir.errors.count>0 then
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
	
	end if

	'response.write("<br>final<br><br>")


	response.write(valor_devuelto & "||" & texto_devuelto)


	conn_actdir.CommitTrans ' finaliza la transaccion




















		
		
		
	set cmd=Nothing
			
	
	conn_actdir.close
	set conn_actdir=Nothing




' Valores de retorno  -- 
'case "ORA-01017":des_error="USUARIO/CONTRASEÑA INCORRECTOS" 
'case "ORA-20106":des_error="LA CUENTA DE USUARIO ESTA CADUCADA"            
'case "ORA-20102":des_error="CONTRASEÑA CADUCADA"          
'case "ORA-20101":des_error="CUENTA BLOQUEADA"    












%>

