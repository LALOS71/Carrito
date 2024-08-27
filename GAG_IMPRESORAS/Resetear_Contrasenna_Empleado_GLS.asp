<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<!--#include file = "includes\crypto\Crypto.Class.asp" -->

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

	caso=""	
	
	if session("usuario_admin")="" then
			caso="VOLVER_LOGIN"
	end if

    dim usuarios
	
	id_empleado = "" & Request.Form("id_empleado")
	nif = "" & Request.Form("nif")

	
	
	'response.write("<br>origen: " & origen)
	'response.write("<br>usuario seleccionado: " & usuario_seleccionado)
	'response.write("<br>contraseña seleccionada: " & contrasenna_seleccionada)
	'response.write("<br>contraseña antigua: " & contrasenna_antigua_seleccionada)
	'response.write("<br>contraseña nueva: " & contrasenna_nueva_seleccionada)
	
	
	if caso<>"VOLVER_LOGIN" then
		set crypt = new crypto 
					
		sql= "UPDATE EMPLEADOS_GLS SET CONTRASENNA='" & crypt.hashPassword(nif,"SHA256","b64") & "'"
		sql = sql & ", SALT=NULL"
		sql = sql & " WHERE ID=" & id_empleado

		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
		connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
			
		
		
		connimprenta.close
		set connimprenta=Nothing
		
		set crypt = nothing
		
		caso="OK"
		
	end if 'del caso<> volver login
	
	cadena_json = "{"
	cadena_json = cadena_json & """resultado"":""" & caso & """" 
	cadena_json = cadena_json & "}"
	
	
	
	response.write(cadena_json)
%>

