<%@ language=vbscript %>


<%
'ON ERROR RESUME NEXT



Function envio_email(de, para, asunto, mensaje)
	'On Error GoTo gestion_error
	
	response.write("<br>de: " & de)
	response.write("<br>para: " & para)
	response.write("<br>asunto: " & asunto)
	response.write("<br>mensaje: " & mensaje)
	
	' Primero, cree una instancia del objeto de servidor CDO
	Dim objCDO
	Set objCDO = Server.CreateObject("CDO.Message")
	
	
	
	' Especifique la información del correo electrónico, incluyendo remitente, destinatario y cuerpo del mensaje
  	'objCDO.From     = "malba@globalia-artesgraficas.com"
	objCDO.From     = de
	
	
   
	'para diferenciar los correos a los que se envia cuando estamos en pruebas o en real
	' y no tener que andar comentando y descomentando lineas		
	cadena_asunto = ""
	correo_recibe = ""
	if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" and Request.ServerVariables("SERVER_NAME")<>"10.150.3.20" then
		'ENTRONO PRUEBAS
		correos_recibe = "malba@globalia-artesgraficas.com"
		'correos_recibe="malba@halconviajes.com"
		cadena_asunto = "PRUEBAS... " & asunto
	  else
		'ENTORNO REAL
		'correos_recibe = "carlos.gonzalez@globalia-artesgraficas.com; malba@globalia-artesgraficas.com" 		  	
		correos_recibe = para 		  	
		'correos_recibe="malba@halconviajes.com"
		cadena_asunto = asunto
	end if
	
	
	
	objCDO.To       = correos_recibe
   	'objCDO.Subject  = cadena_asunto & "(2800) PEDIDO AUTOMATICO " & numero_pedido & " GLS Suc. 280-7 (" & date() & ")"
	objCDO.Subject  = cadena_asunto
	
	
	
   'objCDO.TextBody = "cuerpo del mensaje."
   'objCDO.CreateMHTMLBody "http://www.w3schools.com/asp/" 
   
   objCDO.HtmlBody = mensaje
   
   'configuracion del servidor de emails
   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "192.168.150.44"
   'objMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
   objCDO.Configuration.Fields.Update

   objCDO.Send
	
   
   	objCDO = Nothing
	
	resultado = 0
    envio_email = resultado
End Function

'gestion_error: 
'If Err.Number <> 0 Then
'    Response.Write "Ha ocurrido un error: " Err.Number & " - " & Err.Description
'    Err.Clear 
'End If
%>
