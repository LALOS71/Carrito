<%@ language=vbscript %>
<!--#include file="Conexion_GAG.inc"-->
<!--#include file="Conexion_ORACLE_Active_Directory.inc"-->
<!--#include file = "includes/crypto/Crypto.Class.asp" -->

<%
	Response.CharSet = "iso-8859-1"
	
	usuario="" & Request.Form("usuario")
	contrasenna= "" & Request.Form("contrasenna")
	contrasenna_antigua = "" & Request.Form("contrasenna_antigua")
	contrasenna_nueva = "" & Request.Form("contrasenna_nueva")
	origen = "" & Request.Form("origen")
	
	tipo_respuesta=""
	codigo_respuesta=""
	descripcion_respuesta=""
	
	'response.write("<br>usuario: " & usuario)
	'response.write("<br>contrasenna: " & contrasenna)
		
	set crypt = new crypto 
		
	if origen="LOGIN" then	
		set resultado_login = validar_usuario(usuario, contrasenna)
		
		if resultado_login("tipo_respuesta") = "ok" then 'se ha validado correctamente, recogemos sus oficinas
			set usuarios=Server.CreateObject("ADODB.Recordset")
			with usuarios
				.ActiveConnection=conn_gag
				.Source="SELECT A.IDUSUARIO, A.USUARIO, A.IDCLIENTE, A.NOMBREUSUARIO, A.EMAIL, A.ACTIVO, A.PERFIL, A.EXTERNO, A.CONTRASENNA, A.SALT"
				.Source= .Source & ", B.COD, B.CODEXTERNO, B.TITULOL"
				.Source= .Source & ", CAST(A.IDCLIENTE AS VARCHAR) + ' - ' + B.TITULOL AS OFICINA"
				.Source= .Source & " FROM USUARIOS AS A LEFT JOIN CLIENTES AS B ON A.IDCLIENTE = B.IDCLIENTE"
				.Source= .Source & " WHERE A.ACTIVO=1"
				.Source= .Source & " AND A.USUARIO='" & usuario & "'"
				.Source= .Source & " ORDER BY B.TITULOL"
				
				'response.write("<br>consulta:" & .source)
				.Open
			end with
			
			cadena_oficinas= """oficinas"": ["
			cadena_oficinas_interior=""
			while not usuarios.eof
				cadena_oficinas_interior = cadena_oficinas_interior & "{""codigo"": """ & usuarios("IDCLIENTE") & """, ""nombre"": """ & usuarios("OFICINA") & """},"
				usuarios.movenext
			wend
			usuarios.close
			set usuarios=Nothing
			
			if cadena_oficinas_interior <> "" then
				cadena_oficinas_interior = left(cadena_oficinas_interior, len(cadena_oficinas_interior)-1)
			end if 
			cadena_oficinas = cadena_oficinas & cadena_oficinas_interior &  "]"
				
			respuesta_json = "{""respuesta"": """ & resultado_login("tipo_respuesta") & """, ""codigo"":""" & resultado_login("codigo_respuesta") & """, ""descripcion"":""" & resultado_login("descripcion_respuesta") & """, " & cadena_oficinas & "}"
		  else
		  	respuesta_json = "{""respuesta"": """ & tipo_respuesta & """, ""codigo"":""" & codigo_respuesta & """, ""descripcion"":""" & descripcion_respuesta & """}"
		end if	
	end if 'del login
	
	if origen = "COMPROBAR_EXTERNO" then
		set usuarios=Server.CreateObject("ADODB.Recordset")
		with usuarios
			.ActiveConnection=conn_gag
			.Source="SELECT A.USUARIO, A.ACTIVO, A.PERFIL, A.EXTERNO"
			.Source= .Source & " FROM USUARIOS A"
			.Source= .Source & " WHERE A.ACTIVO=1"
			.Source= .Source & " AND A.USUARIO='" & usuario & "'"
			.Source= .Source & " AND A.EXTERNO=1"
			
			'response.write("<br>consulta:" & .source)
			.Open
		end with
		if not usuarios.eof then	
			respuesta_json = "{""respuesta"": ""ok"", ""codigo"":""1"", ""descripcion"":""Usuario Externo""}"
		 else
		 	respuesta_json = "{""respuesta"": ""error"", ""codigo"":""1"", ""descripcion"":""El Usuario NO Es Externo""}"
		end if
		usuarios.close
		set usuarios = nothing
	
	end if
		
	if origen = "MODIFICAR" then
	
		set usuarios=Server.CreateObject("ADODB.Recordset")
		with usuarios
			.ActiveConnection=conn_gag
			.Source="SELECT A.IDUSUARIO, A.USUARIO"
			.Source= .Source & " FROM USUARIOS AS A"
			.Source= .Source & " WHERE A.ACTIVO=1"
			.Source= .Source & " AND A.USUARIO='" & usuario & "'"
			.Source= .Source & " AND A.CONTRASENNA='" & contrasenna_antigua & "'"
			'response.write("<br>consulta:" & .source)
			.Open
		end with
		
		if not usuarios.eof then
			sql="UPDATE USUARIOS SET CONTRASENNA='" & contrasenna_nueva & "' WHERE USUARIO=" & usuario
			'response.write("<br><br>" & sql)
			conn_gag.Execute sql,,adCmdText + adExecuteNoRecords
			respuesta_json = "{""respuesta"": ""ok"", ""codigo"":""1"", ""descripcion"":""Constraseña modificada correctamente""}"
		  else
		  	respuesta_json = "{""respuesta"": ""error"", ""codigo"":""1"", ""descripcion"":""No se ha podido modificar la contraseña""}"
		end if
		usuarios.close
		set usuarios = nothing
		
	end if

	
	response.write(respuesta_json)

		

	
	conn_gag.close
	set conn_gag=Nothing
	
	conn_actdir.close
	set conn_actdir=Nothing
	
	
function validar_usuario(usuario, contrasenna)
	Set resultado = Server.CreateObject("Scripting.Dictionary")

	'Response.write("<br>usuario: " & usuario & " contraseña: " & contrasenna)
	set usuarios=Server.CreateObject("ADODB.Recordset")
	with usuarios
		.ActiveConnection=conn_gag
		.Source="SELECT A.IDUSUARIO, A.USUARIO, A.IDCLIENTE, A.NOMBREUSUARIO, A.EMAIL, A.ACTIVO, A.PERFIL, A.EXTERNO, A.CONTRASENNA, A.SALT"
		.Source= .Source & ", B.COD, B.CODEXTERNO, B.TITULOL"
		.Source= .Source & ", CAST(A.IDCLIENTE AS VARCHAR) + ' - ' + B.TITULOL AS OFICINA"
		.Source= .Source & " FROM USUARIOS AS A LEFT JOIN CLIENTES AS B ON A.IDCLIENTE = B.IDCLIENTE"
		.Source= .Source & " WHERE A.ACTIVO=1"
		.Source= .Source & " AND A.USUARIO='" & usuario & "'"
		.Source= .Source & " ORDER BY B.TITULOL"
		
		'response.write("<br>consulta:" & .source)
		.Open
	end with

	cadena_devuelta=""
	usuario_externo=""
	contrasenna_bd=""
	if not usuarios.eof then
		usuario_externo = usuarios("EXTERNO")
		contrasenna_bd = usuarios("CONTRASENNA")
		salt_usuario =  "" & usuarios("salt")
		cadena_resultante = salt_usuario & contrasenna
		
		'response.write("<br>contraseña_bd: " & contrasenna_bd & " salt: " & salt_usuario)
		'response.write("<br>cadena resultante: " & cadena_resultante)
				
		if usuario_externo=true then 'si el usuario es externo, valida desde la aplicacion, sino, en el active directory
			'RESPONSE.WRITE("<BR>VERIFIPASSWORD: " & crypt.verifyPassword(cadena_resultante, contrasenna_bd))
			'if crypt.verifyPassword(cadena_resultante, contrasenna_bd) then
			if contrasenna_bd = contrasenna then
				tipo_respuesta="ok"
				codigo_respuesta="1"
				descripcion_respuesta="Usuario y Contraseña Correctos."
			  else
				tipo_respuesta="error"
				codigo_respuesta="2"
				descripcion_respuesta="Usuario o Contraseña Incorrectos."
			end if
		  else 'es un usuario interno, se valida en el active directory
			set resultado = validar_en_ad(usuario,contrasenna)
			if resultado("codigo")= "0" then 'validacion correcta
				tipo_respuesta="ok"
				codigo_respuesta="2"
				descripcion_respuesta="Usuario Interno."
			 else 'error en la validacion
				tipo_respuesta="error"
				codigo_respuesta = "3"
				descripcion_respuesta = resultado("descripcion")
			end if
		end if
		
	  else 'el usuario no está dado de alta en el sistema de maletas
		tipo_respuesta="error"
		codigo_respuesta="1"
		descripcion_respuesta="El Usuario no Está dado de Alta en El Sistema."
	end if
	usuarios.close
	set usuarios=Nothing

	resultado("tipo_respuesta") = tipo_respuesta
	resultado("codigo_respuesta") = codigo_respuesta
	resultado("descripcion_respuesta") = descripcion_respuesta

	set validar_usuario = resultado
end function
	
function validar_en_ad(usuario, contrasenna)

	'response.write("<br><br>dentro de validar_en_ad")
	Dim resultado
    Set resultado = Server.CreateObject("Scripting.Dictionary")
	
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
	
	
	
	cmd.parameters("C_USUARIO") = usuario_solo
	cmd.parameters("C_PASSWORD") = contrasenna
	
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
	resultado("codigo") = valor_devuelto
	resultado("descripcion") = texto_devuelto
	conn_actdir.CommitTrans ' finaliza la transaccion

	'response.write("<br>Resultado codigo: " & resultado("codigo"))
	'response.write("<br>resultad descripcion: " & resultado("descripcion"))
		
	set cmd=Nothing
			
	
	set validar_en_ad = resultado


end function
	


%>
