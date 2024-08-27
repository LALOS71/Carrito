<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%

Response.CharSet = "UTF-8"

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
	usuario_seleccionado = ucase("" & Request.Form("usuario"))
	contrasenna_seleccionada = "" & Request.Form("contrasenna")
	contrasenna_antigua_seleccionada= "" & Request.Form("contrasenna_antigua")
	contrasenna_nueva_seleccionada= "" & Request.Form("contrasenna_nueva")
	
	
	'response.write("<br>origen: " & origen)
	'response.write("<br>usuario seleccionado: " & usuario_seleccionado)
	'response.write("<br>contraseña seleccionada: " & contrasenna_seleccionada)
	'response.write("<br>contraseña antigua: " & contrasenna_antigua_seleccionada)
	'response.write("<br>contraseña nueva: " & contrasenna_nueva_seleccionada)
	
	
		
	if origen="LOGIN" then

		set usuarios = Server.CreateObject("ADODB.Recordset")
			
		sql="SELECT IDCLIENTE, NIF, CONTRASENA, SALT"
		sql=sql & " FROM GAG.dbo.CLIENTES"
		sql=sql & " WHERE NIF='" & usuario_seleccionado & "'"
		sql=sql & " AND BORRADO=0"
		sql=sql & " AND IDCADENA=260"
			
		'response.write("<br>" & sql)
			
		with usuarios
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
	
		valido="NO"
		id_usuario=""
		contrasenna_usuario = ""
		salt_usuario = ""
		
		cambiar_contrasenna= "NO"
	
		if not usuarios.eof then
				valido="SI"
				id_usuario = "" & usuarios("idcliente")
				contrasenna_usuario = "" & usuarios("contrasena")
				salt_usuario =  "" & usuarios("salt")
				
				if contrasenna_usuario=contrasenna_seleccionada then
					'response.write("<br><br>la contraseña es correcta se ha puesto bien")
					
					'SI EL SALT esta vacio hay que cambiar la contraseña
					if salt_usuario =  "" then
						'response.write("<br><br>las contraseñas coinciden y ademas el salt está vacio... hay que cambiar la contraseña")
						cambiar_contrasenna="SI"
					 else
					 	'response.write("<br><br>las contraseñas coinciden pero el salt no está vacio... NO hay que cambiar la contraseña")
						valido="CONTRASENNA_CORRECTA"
					end if
				
				
				end if
		end if
		
		usuarios.close
		set usuarios = Nothing
	end if
	
	
	
	if origen="MODIFICAR" then

		set usuarios = Server.CreateObject("ADODB.Recordset")
			
		'response.write("<br>" & sql)
		sql="SELECT IDCLIENTE, NIF, CONTRASENA, SALT"
		sql=sql & " FROM GAG.dbo.CLIENTES"
		sql=sql & " WHERE NIF='" & usuario_seleccionado & "'"
		sql=sql & " AND BORRADO=0"
		sql=sql & " AND IDCADENA=260"
			
		'response.write("<br>" & sql)
			
		with usuarios
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
	
		valido="NO_MODIFICA"
		id_usuario=""
		contrasenna_usuario = ""
		salt_usuario = ""
		cambiar_contrasenna= ""
	
		if not usuarios.eof then
			valido="SI_MODIFICA"
			id_usuario = "" & usuarios("idcliente")
			contrasenna_usuario = "" & usuarios("contrasena")
			salt_usuario =  "" & usuarios("salt")
			if contrasenna_usuario=contrasenna_antigua_seleccionada then
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
			cadena_ejecucion="UPDATE GAG.dbo.CLIENTES SET CONTRASENA='" & contrasenna_nueva_seleccionada &"'"
			cadena_ejecucion=cadena_ejecucion & ", SALT='" & valor_salt & "'"
			cadena_ejecucion=cadena_ejecucion & " WHERE IDCLIENTE=" & id_usuario
			cadena_ejecucion=cadena_ejecucion & " AND BORRADO=0"
			cadena_ejecucion=cadena_ejecucion & " AND IDCADENA=260"
	
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

			valido="MODIFICACION_PASSWORD_OK"
		end if
		
	end if
	
	
	
	


	connimprenta.close

	
	set connimprenta=Nothing
	
	cadena_json = "{"
	
	'NO.... usuario no existe, SI... usuario existe y contraseña incorrecta, CONTRASENNA_CORRECTA.... se valida correctamente
	'NO_MODIFICA, SI_MODIFICA, CONTRASENNA_CORRECTA, MODIFICACION_PASSWORD_OK
	cadena_json = cadena_json & """valido"":""" & valido & """" 
	cadena_json = cadena_json & ", ""id_usuario_general"":""" & id_usuario & """"
    cadena_json = cadena_json & ", ""cambiar_contrasenna_usuario_general"":""" & cambiar_contrasenna & """"
	
	
	cadena_json = cadena_json & "}"
	
	response.write(cadena_json)
%>

