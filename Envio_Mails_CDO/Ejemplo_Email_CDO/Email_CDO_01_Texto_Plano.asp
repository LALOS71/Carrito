<!--#include file="Config.inc"-->
<%
   ' Primero, cree una instancia del objeto de servidor CDO
   Dim objCDO
   
response.write("<br><br>ANTES DEL CREATEOBJECT CDO.MESSAJE")
   Set objCDO = Server.CreateObject("CDO.Message")

   ' Especifique la información del correo electrónico, incluyendo remitente, destinatario y cuerpo del mensaje
   objCDO.From     = "malba@globalia-artesgraficas.com"
   objCDO.To       = "malba@globalia-artesgraficas.com;manuel.alba.gallego@gmail.com"
   objCDO.Subject  = "Ejemplo de Envio de Correo con CDO"
   objCDO.TextBody = "cuerpo del mensaje."

response.write("<br><br>ANTES DE LA CONFIGURACION DE PARAMETROS")   
   'configuracion del servidor de emails
	objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = CDO_SENDUSING
	objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = CDO_SERVER
	objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = CDO_PORT
	objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = CDO_SENDUSERNAME
	objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = CDO_SENDPASSWORD
	
	

response.write("<br><br>ANTES DE ACTUALIZAR PARAMETROS")
   objCDO.Configuration.Fields.Update


response.write("<br><br>ANTES DEL SEND")
   objCDO.Send
response.write("<br><br>...........FINALIZADO........")

%>
