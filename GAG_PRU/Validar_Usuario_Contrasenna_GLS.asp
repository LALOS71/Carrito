<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<!--#include file = "includes/crypto/Crypto.Class.asp" -->

<%

Function Genera_Clave_Aleatoria()
      Randomize
	  caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
      valor = Int(Rnd * 62) + 1
	  Genera_Clave_Aleatoria=Mid(caracteres,valor,1)
End Function

'response.write("<br><br>clave aleatoria: ")
'For i=1 to 64
'      Response.write (Genera_Clave_Aleatoria())
'Next



    dim usuarios

	origen = "" & Request.Form("origen")
	usuario_seleccionado = "" & Request.Form("usuario")
	contrasenna_seleccionada = "" & Request.Form("contrasenna")
	contrasenna_antigua_seleccionada= "" & Request.Form("contrasenna_antigua")
	contrasenna_nueva_seleccionada= "" & Request.Form("contrasenna_nueva")
	
	
	'response.write("<br>origen: " & origen)
	'response.write("<br>usuario seleccionado: " & usuario_seleccionado)
	'response.write("<br>contrase�a seleccionada: " & contrasenna_seleccionada)
	'response.write("<br>contrase�a antigua: " & contrasenna_antigua_seleccionada)
	'response.write("<br>contrase�a nueva: " & contrasenna_nueva_seleccionada)
	
	set crypt = new crypto 
	
		
	if origen="LOGIN" then

		set usuarios = Server.CreateObject("ADODB.Recordset")
			
		sql="SELECT ID, NIF, CONTRASENNA, SALT, NOMBRE, APELLIDOS, EMAIL, BORRADO, GRUPO_ROPA, CENTRO_COSTE, NUEVO, FECHA_ALTA, FECHA_NUEVO_VERANO, FECHA_NUEVO_INVIERNO"
		sql=sql & " FROM EMPLEADOS_GLS"
		sql=sql & " WHERE NIF='" & usuario_seleccionado & "'"
		sql=sql & " AND BORRADO='NO'"
			
		'response.write("<br>consulta: " & sql)
			
		with usuarios
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
	
		valido="NO"
		id_usuario_gls=""
		usuario_usuario_gls = ""
		contrasenna_usuario_gls = ""
		salt_usuario_gls = ""
		nombre_usuario_gls = ""
		apellidos_usuario_gls = ""
		email_usuario_gls = ""
		borrado_usuario_gls = ""
		grupo_ropa_usuario_gls = ""
		centro_coste_usuario_gls = ""
		nuevo_usuario_gls = ""
		fecha_alta_usuario_gls = ""
		fecha_nuevo_verano_usuario_gls = ""
		fecha_nuevo_invierno_usuario_gls = ""
		
		cambiar_contrasenna= "NO"
	
		if not usuarios.eof then
				valido="SI"
				id_usuario_gls = "" & usuarios("id")
				usuario_usuario_gls = "" & usuarios("nif")
				contrasenna_usuario_gls = "" & usuarios("contrasenna")
				salt_usuario_gls =  "" & usuarios("salt")
				cadena_resultante = salt_usuario_gls & contrasenna_seleccionada
				'LUEGO comentar cadenaresultanteencriptada
				'cadena_resultante_encriptada=crypt.hashPassword(cadena_resultante,"SHA256","b64")
				'response.write("<br>entramos a validar.... ha encontrado el usuario:")
				'response.write("<br>...id usuario: " & id_usuario_gls)
				'response.write("<br>...usuario: " & usuario_usuario_gls)
				'response.write("<br>...contrase�a usuario: " & contrasenna_usuario_gls)
				'response.write("<br>...salt usuario: " & salt_usuario_gls)
				'response.write("<br>...contrase�a seleccioanda: " & contrasenna_seleccionada)
				'response.write("<br>...cadena_resultante: " & cadena_resultante)
				'response.write("<br>...cadena resultante encriptada: " & cadena_resultante_encriptada)
				'response.write("<br>...resultado comparacion VERIFYPASSWORD: " & crypt.verifyPassword(cadena_resultante, contrasenna_usuario_gls))
				
				if crypt.verifyPassword(cadena_resultante, contrasenna_usuario_gls) then
					'response.write("<br><br>la contrase�a es correcta se ha puesto bien")
					
					'SI EL SALT esta vacio hay que cambiar la contrase�a
					if salt_usuario_gls =  "" then
						'response.write("<br><br>las contrase�as coinciden y ademas el salt est� vacio... hay que cambiar la contrase�a")
						cambiar_contrasenna="SI"
					 else
					 	'response.write("<br><br>las contrase�as coinciden pero el salt no est� vacio... NO hay que cambiar la contrase�a")
						valido="CONTRASENNA_CORRECTA"
						nombre_usuario_gls = "" & usuarios("nombre")
						apellidos_usuario_gls = "" & usuarios("apellidos")
						email_usuario_gls = "" & usuarios("email")
						borrado_usuario_gls = "" & usuarios("borrado")
						grupo_ropa_usuario_gls = "" & usuarios("grupo_ropa")
						centro_coste_usuario_gls = "" & usuarios("centro_coste")
						nuevo_usuario_gls = "" & usuarios("nuevo")
						fecha_alta_usuario_gls = "" & usuarios("fecha_alta")
						fecha_nuevo_verano_usuario_gls = "" & usuarios("fecha_nuevo_verano")
						fecha_nuevo_invierno_usuario_gls = "" & usuarios("fecha_nuevo_invierno")
					end if
				
				
				end if
		end if
		
		usuarios.close
		set usuarios = Nothing
	end if
	
	
	
	if origen="MODIFICAR" then

		set usuarios = Server.CreateObject("ADODB.Recordset")
			
		'response.write("<br>" & sql)
		sql="SELECT ID, NIF, CONTRASENNA, SALT, NOMBRE, APELLIDOS, EMAIL, BORRADO, GRUPO_ROPA, CENTRO_COSTE, NUEVO"
		sql=sql & " FROM EMPLEADOS_GLS"
		sql=sql & " WHERE NIF='" & usuario_seleccionado & "'"
			
		'response.write("<br>" & sql)
		'response.write("<br>consulta2: " & sql)
			
		with usuarios
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
	
		valido="NO_MODIFICA"
		id_usuario_gls=""
		usuario_usuario_gls = ""
		contrasenna_usuario_gls = ""
		salt_usuario_gls = ""
		nombre_usuario_gls = ""
		apellidos_usuario_gls = ""
		email_usuario_gls = ""
		borrado_usuario_gls = ""
		grupo_ropa_usuario_gls = ""
		centro_coste_usuario_gls = ""
		nuevo_usuario_gls = ""
		fecha_alta_usuario_gls = ""
		cambiar_contrasenna= ""
	
		if not usuarios.eof then
			valido="SI_MODIFICA"
			id_usuario_gls = "" & usuarios("id")
			usuario_usuario_gls = "" & usuarios("nif")
			contrasenna_usuario_gls = "" & usuarios("contrasenna")
			salt_usuario_gls =  "" & usuarios("salt")
			cadena_resultante = salt_usuario_gls & contrasenna_antigua_seleccionada
			'cadena_resultante_encriptada=crypt.hashPassword(cadena_resultante,"SHA256","b64")
			'response.write("<br>entramos a validar:")
			'response.write("<br>...id usuario: " & id_usuario_gls)
			'response.write("<br>...usuario: " & usuario_usuario_gls)
			'response.write("<br>...contrase�a usuario: " & contrasenna_usuario_gls)
			'response.write("<br>...salt usuario: " & salt_usuario_gls)
			'response.write("<br>...contrase�a seleccioanda: " & contrasenna_seleccionada)
			'response.write("<br>...cadena_resultante: " & cadena_resultante)
			'response.write("<br>...cadena resultante encriptada: " & cadena_resultante_encriptada)
			'response.write("<br>...resultado comparacion: " & crypt.verifyPassword(cadena_resultante, contrasenna_usuario_gls))
			
			if crypt.verifyPassword(cadena_resultante, contrasenna_usuario_gls) then
				valido="CONTRASENNA_CORRECTA"
			end if
		end if

		usuarios.close
		set usuarios = Nothing
		
		if valido="CONTRASENNA_CORRECTA" then
			valor_salt=""
			For i=1 to 64
			      valor_salt=valor_salt & (Genera_Clave_Aleatoria())
			Next
			cadena_resultante=valor_salt & contrasenna_nueva_seleccionada
			codificacion_cadena= crypt.hashPassword(cadena_resultante,"SHA256","b64")
			cadena_ejecucion="UPDATE EMPLEADOS_GLS SET CONTRASENNA='" & codificacion_cadena &"'"
			cadena_ejecucion=cadena_ejecucion & ", SALT='" & valor_salt & "'"
			cadena_ejecucion=cadena_ejecucion & " WHERE ID=" & id_usuario_gls
	
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

			valido="MODIFICACION_PASSWORD_OK"
		end if
		
	end if
	
	
	
	


	connimprenta.close

	
	set connimprenta=Nothing
	
	cadena_json = "{"
	
	'NO.... usuario no existe, SI... usuario existe y contrase�a incorrecta, CONTRASENNA_CORRECTA.... se valida correctamente
	'NO_MODIFICA, SI_MODIFICA, CONTRASENNA_CORRECTA, MODIFICACION_PASSWORD_OK
	cadena_json = cadena_json & """valido"":""" & valido & """" 
	cadena_json = cadena_json & ", ""id_usuario_gls"":""" & id_usuario_gls & """"
	cadena_json = cadena_json & ", ""usuario_usuario_gls"":""" & usuario_usuario_gls & """"
	cadena_json = cadena_json & ", ""nombre_usuario_gls"":""" & nombre_usuario_gls & """"
	cadena_json = cadena_json & ", ""apellidos_usuario_gls"":""" & apellidos_usuario_gls & """"
	cadena_json = cadena_json & ", ""email_usuario_gls"":""" & email_usuario_gls & """"
	cadena_json = cadena_json & ", ""borrado_usuario_gls"":""" & borrado_usuario_gls & """"
	cadena_json = cadena_json & ", ""grupo_ropa_usuario_gls"":""" & grupo_ropa_usuario_gls & """"
	cadena_json = cadena_json & ", ""centro_coste_usuario_gls"":""" & centro_coste_usuario_gls & """"
	cadena_json = cadena_json & ", ""nuevo_usuario_gls"":""" & nuevo_usuario_gls & """"
	cadena_json = cadena_json & ", ""fecha_alta_usuario_gls"":""" & fecha_alta_usuario_gls & """"
	cadena_json = cadena_json & ", ""fecha_nuevo_verano_usuario_gls"":""" & fecha_nuevo_verano_usuario_gls & """"
	cadena_json = cadena_json & ", ""fecha_nuevo_invierno_usuario_gls"":""" & fecha_nuevo_invierno_usuario_gls & """"
    cadena_json = cadena_json & ", ""cambiar_contrasenna_usuario_gls"":""" & cambiar_contrasenna & """"
	
	
	cadena_json = cadena_json & "}"
	
	set crypt = nothing
	
	Response.ContentType = "application/json"
	response.write(cadena_json)
%>

