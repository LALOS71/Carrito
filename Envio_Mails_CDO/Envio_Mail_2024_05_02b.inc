<%
Function envio_email(de, para, asunto, mensaje, adjunto, servidor)
	'response.write("<br>dentro de la funcion envio_email")
	'response.write("<br>de: " & de)
	'response.write("<br>para: " & para)
	'response.write("<br>asunto: " & asunto)
	'response.write("<br>mensaje: " & mensaje)
	
	servidor_smtp=""
	
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
   	objCDO.Subject  = cadena_asunto
	
	
	
   'objCDO.TextBody = "cuerpo del mensaje."
   'objCDO.CreateMHTMLBody "http://www.w3schools.com/asp/" 
   
   objCDO.HtmlBody = ConvertirAcentos(mensaje)
   

   if servidor = "AMAZON" then
	   'configuracion del servidor de emails de Amazon
	   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "email-smtp.eu-west-1.amazonaws.com"
	   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465 ' puerto 25 o 587 o 465
	   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
	   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
	   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "AKIAY7674MHZ2YVMG4FB"
	   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "BMh0vesbacnJDQqRGaJMn3WwPPwzxgdMMpz7yfq4/Tlj"
	   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True

	else
	   'configuracion del servidor de emails de Globalia
	   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "192.168.150.44"
   end if
   

   objCDO.Configuration.Fields.Update



   if adjunto <> "" then
	objCDO.AddAttachment adjunto
   end if

   'response.write("<br>ERROR - NUMBER: " & err.number)
   'response.write("<br>ERROR - Descripcion: " & err.description)
   ' Enviar el correo electrónico
	On Error Resume Next
	objCDO.Send
	
	If Err.Number = 0 Then
		respuesta = "{""type"" : ""ok"", ""msg"" : ""Correo electrónico enviado con exito""}"
	Else
		respuesta = "{""type"" : ""error"", ""msg"" : """ & Err.number & " - " & Err.Description & """}"
	End If

	
	set objCDO = Nothing
    envio_email = respuesta

   
End Function

Function ConvertirAcentos(mensaje)
    Dim i
    Dim dicAcentos

    Set dicAcentos = CreateObject("Scripting.Dictionary")
	
    dicAcentos.Add "á", "&aacute;"
    dicAcentos.Add "é", "&eacute;"
    dicAcentos.Add "í", "&iacute;"
    dicAcentos.Add "ó", "&oacute;"
    dicAcentos.Add "ú", "&uacute;"
    dicAcentos.Add "Á", "&Aacute;"
    dicAcentos.Add "É", "&Eacute;"
    dicAcentos.Add "Í", "&Iacute;"
    dicAcentos.Add "Ó", "&Oacute;"
    dicAcentos.Add "Ú", "&Uacute;"
    dicAcentos.Add "ñ", "&ntilde;"
    dicAcentos.Add "Ñ", "&Ntilde;"
    dicAcentos.Add "ü", "&uuml;"
    dicAcentos.Add "Ü", "&Uuml;"
    dicAcentos.Add "ç", "&ccedil;"
    dicAcentos.Add "Ç", "&Ccedil;"

    For Each i In dicAcentos.Keys
        mensaje = Replace(mensaje, i, dicAcentos(i))
    Next
    ConvertirAcentos = mensaje
End Function

%>

