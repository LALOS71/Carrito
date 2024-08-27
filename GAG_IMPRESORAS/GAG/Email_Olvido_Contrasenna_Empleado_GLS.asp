<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include file = "includes/crypto/Crypto.Class.asp" -->

<%

	'Response.CharSet = "iso-8859-1"
	'Response.CodePage = 28591 

sub envio_email(email, contrasenna)%>
	<!--#include file="Conexion_ORACLE_Envios_Distri_PRODUCCION.inc"-->


<%
	adCmdStoredProc=4
	adVarChar=200
	adParamInput=1

		
	set cmd = Server.CreateObject("ADODB.Command")
	'set cmd2 = Server.CreateObject("ADODB.Command")
	set cmd.ActiveConnection = conn_envios_distri
	'set cmd2.ActiveConnection = conndistribuidora
	
	
	if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
		'ENTORNO PRUEBAS
		entorno="PRUEBAS"
	  else
		'ENTORNO REAL
		entorno="REAL"
	end if
	
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
		
	cmd.parameters("P_ENVIA")="mireia.caballero@gls-spain.es"
	cmd.parameters("P_RECIBE")=email
	
	texto_asunto="RESTABLECIMIENTO DE CONTRASEÑA"
	cmd.parameters("P_ASUNTO")=texto_asunto
			
	mensaje="Se ha modificado la contraseña de acceso a Globalia Artes Gráficas para su usuario.<BR><br>"
	mensaje=mensaje & "<BR>Su nueva contraseña de acceso es: " & contrasenna
	mensaje=mensaje & "<BR><br><br>Por seguridad, nada mas validarse, el sistema le pedirá que cambie la contraseña."
	mensaje=mensaje & "<BR><br><br>Un saludo."
	
	mensaje=mensaje & "<BR><br><br>mandado al email: " & email
	
	'mensaje=contrasenna
	
	response.write("<br><br>mensaje del email: " & mensaje)
		
	cmd.parameters("P_MENSAJE")=mensaje
	'cmd.parameters("P_HOST")="195.76.0.183"
	cmd.parameters("P_HOST")="192.168.150.44"
		   
	'para que no llegue el aviso de rotura de stock
	'cmd.execute()
		
		
		
	set cmd=Nothing
			
	
	conn_envios_distri.close
	set conn_envios_distri=Nothing

end sub


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
	email=""
	
   
	
	usuario = "" & Request.Form("usuario")

	
	
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
		
		envio_email email, clave_aleatoria
		
		sql= "UPDATE EMPLEADOS_GLS SET CONTRASENNA='" & crypt.hashPassword(nif,"SHA256","b64") & "'"
		sql = sql & ", SALT=NULL"
		sql = sql & " WHERE NIF='" & usuario & "'"

		response.write("<br><br>consulta: " & sql)
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
		connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
		caso="OK"
	
	end if
	
	
		
		
	connimprenta.close
	set connimprenta=Nothing
		
	cadena_json = "{"
	cadena_json = cadena_json & """resultado"":""" & caso & """" 
	cadena_json = cadena_json & "}"
	
	
	
	response.write(cadena_json)
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE></TITLE>
</HEAD>
<BODY>
<b><%=mensaje%></b>	
</BODY>
   <%
	
	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>

