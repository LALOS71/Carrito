<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<!--#include file="Conexion_ORACLE_Envios_Distri_PRODUCCION.inc"-->
<!--#include file = "includes/crypto/Crypto.Class.asp" -->

<%

Function Genera_Clave_Aleatoria()
      Randomize
	  caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
      valor = Int(Rnd * 62) + 1
	  Genera_Clave_Aleatoria=Mid(caracteres,valor,1)
End Function



	caso=""	
	email=""
	
   
	
	usuario = "" & Request.Form("usuario")

	usuario="1R"
	
	
	'response.write("<br>origen: " & origen)
	'response.write("<br>usuario seleccionado: " & usuario_seleccionado)
	'response.write("<br>contraseña seleccionada: " & contrasenna_seleccionada)
	'response.write("<br>contraseña antigua: " & contrasenna_antigua_seleccionada)
	'response.write("<br>contraseña nueva: " & contrasenna_nueva_seleccionada)
	
	
	set usuarios=Server.CreateObject("ADODB.Recordset")
	with usuarios
		.ActiveConnection=connimprenta
		'.Source="SELECT A.CENTRO_COSTE, B.NOMBRE"
		'.Source= .Source & " FROM CENTROS_COSTE_GLS A"
		'.Source= .Source & " INNER JOIN V_CLIENTES B"
		'.Source= .Source & " ON A.CENTRO_COSTE=B.ID"
		'.Source= .Source & " ORDER BY NOMBRE"
		.Source="SELECT NIF, EMAIL"
		.Source= .Source & " FROM EMPLEADOS_GLS"
		.Source= .Source & " WHERE NIF='" & usuario & "'"
		.Source= .Source & " AND BORRADO='NO'"
		response.write("<br><br>consulta: " & .source)
		.Open
	end with

	if not usuarios.eof then
		email="" & usuarios("EMAIL")
		if email="" then
			caso="NO_TIENE_EMAIL"
		end if
	
	  else
	  	caso="USUARIO_NO_EXISTE"
	end if

	
	usuarios.close
	set usuarios=Nothing
	
	
	response.write("<br><br>caso: ..." & caso & "...")
	
if caso="" then
		clave_aleatoria=""
		For i=1 to 12
			clave_aleatoria=clave_aleatoria & Genera_Clave_Aleatoria()
			Response.write ("<br>" & clave_aleatoria)
		Next
		
		set crypt = new crypto 
		clave_encriptada=crypt.hashPassword(clave_aleatoria,"SHA256","b64")		
	
		Response.write server.HTMLEncode("<br><br>Para el usuario: " & usuario & " hay que mandar un email al correo: " & email & " mandandole la contraseña: " & clave_aleatoria & " que queda encriptada como: " & clave_encriptada)
		

'----------------------------------------------

		
adCmdStoredProc=4
adVarChar=200
adParamInput=1
		
		set cmd = Server.CreateObject("ADODB.Command")
		set cmd.ActiveConnection = conn_envios_distri
		
		if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
			'ENTORNO PRUEBAS
			entorno="PRUEBAS"
		  else
			'ENTORNO REAL
			entorno="REAL"
		end if

		conn_envios_distri.BeginTrans 'Comenzamos la Transaccion
		cmd.CommandText = "PAQUETE_ENVIOS_DISTRI.ENVIAR_MAIL"
		cmd.CommandType = adCmdStoredProc
		
		cmd.parameters.append cmd.createparameter("P_ENVIA",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_RECIBE",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_ASUNTO",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_MENSAJE",adVarChar,adParamInput,2000)
		cmd.parameters.append cmd.createparameter("P_HOST",adVarChar,adParamInput,255)
		'cmd.parameters.append cmd.createparameter("C_ALTO_GENERICO",adInteger,adParamInput,2)
		'cmd.parameters.append cmd.createparameter("C_PESO_GENERICO",adDouble,adParamInput)
		
		'cmd.parameters.append cmd.createparameter("texto_explicacion",adVarChar,adParamOutPut,255)
		
		cmd.parameters("P_ENVIA")="malba@halconviajes.com"		

		'para diferenciar los correos a los que se envia cuando estamos en pruebas o en real
		' y no tener que andar comentando y descomentando lineas		
		
		cadena_asunto=""
		if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" and Request.ServerVariables("SERVER_NAME")<>"10.150.3.20" then
		
			'ENTRONO PRUEBAS
		  	correos_recibe="malba@globalia.com"
			cadena_asunto="PRUEBAS..."
		  else
			'ENTORNO REAL
			correos_recibe=email
			cadena_asunto=""
		end if
		'response.write("<br>" & Request.ServerVariables("SERVER_NAME"))
		cmd.parameters("P_RECIBE")=correos_recibe
		cmd.parameters("P_ASUNTO")=cadena_asunto & " 'RESTABLECIMIENTO DE CONTRASEÑA"
		
		
		mensaje="Se ha modificado la contrase&ntilde;a de acceso a Globalia Artes Gr&aacute;ficas para su usuario."
		mensaje=mensaje & "<br><br>Su nueva contrase&ntilde;a de acceso es: " & clave_aleatoria
		mensaje=mensaje & "<br><br>Por seguridad, nada mas validarse, el sistema le pedir&aacute; que cambie la contrase&ntilde;a."
		mensaje=mensaje & "<br><br>Un saludo."
		
		mensaje=mensaje & "<BR><br><br>se ha generado ESTE EMAIL Ñ á é í ó ú ü .... mandado al email: " & email
		cmd.parameters("P_MENSAJE")=mensaje
		'cmd.parameters("P_HOST")="195.76.0.183"
		cmd.parameters("P_HOST")="192.168.150.44"
		   
		cmd.execute()
		
	
		conn_envios_distri.CommitTrans ' finaliza la transaccion
		
		
		set cmd=Nothing
			
'-----------------------------------------------------	
		sql= "UPDATE EMPLEADOS_GLS SET CONTRASENNA='" & crypt.hashPassword(nif,"SHA256","b64") & "'"
		sql = sql & ", SALT=NULL"
		sql = sql & " WHERE NIF='" & usuario & "'"

		response.write("<br><br>consulta: " & sql)
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
		connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
		caso="OK"
	
end if		
	
	
conn_envios_distri.close
set conn_envios_distri=Nothing


'regis.close			
connimprenta.Close
set connimprenta=Nothing	

cadena_json = "{"
cadena_json = cadena_json & """resultado"":""" & caso & """" 
cadena_json = cadena_json & "}"
	
response.write(cadena_json)	

%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>prueba email</TITLE>
</HEAD>
<BODY>
<b><%=mensaje%></b>	
</BODY>
   <%
   		
	%>
   </HTML>

