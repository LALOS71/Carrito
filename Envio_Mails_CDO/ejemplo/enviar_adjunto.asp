<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Envio_Mail.inc"-->


<%




'ENVIAMOS EL CORREO ELECTRONICO


	de = "malba@globalia-artesgraficas.com"
	para = "carlos.gonzalez@globalia-artesgraficas.com; malba@globalia-artesgraficas.com" 		  	
	asunto = "PRUEBA DE ENVIO DE EMAIL CON CDO Y UN ADJUNTO"
	
	mensaje = "<div style='background-color:#fff;width:650px;font-family:Open-sans,sans-serif;color:#555454;font-size:13px;line-height:18px;margin:auto'>"
	mensaje = mensaje & "<table style='width:100%' bgcolor='#ffffff'>"
	mensaje = mensaje & "<tbody>"
	mensaje = mensaje & "<tr>"
	mensaje = mensaje & "<td style='border:1px solid #d6d4d4;background-color:#f8f8f8;padding:7px 0'>"
	mensaje = mensaje & "<table style='width:100%'>"
	mensaje = mensaje & "<tbody>"
	mensaje = mensaje & "<tr>"
	mensaje = mensaje & "<td style='padding:7px 0' width='10'>&nbsp;</td>"
	mensaje = mensaje & "<td style='padding:7px 0'>"
	mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
	mensaje = mensaje & "<span style='color:#777'>"
	mensaje = mensaje & "Con fecha " & date() & " se ha generado de forma autom&aacute;tica este correo."
	mensaje = mensaje & "<br><br>Un Saludo."
	mensaje = mensaje & "</span>"
	mensaje = mensaje & "</font>"
	mensaje = mensaje & "</td>"
	mensaje = mensaje & "<td style='padding:7px 0' width='10'>&nbsp;</td>"
	mensaje = mensaje & "</tr>"
	mensaje = mensaje & "</tbody>"
	mensaje = mensaje & "</table>"
	mensaje = mensaje & "</td>"
	mensaje = mensaje & "</tr>"
	mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
	mensaje = mensaje & "</tbody>"
	mensaje = mensaje & "</table>"
	mensaje = mensaje & "</div>"
	
	mensaje = replace(mensaje, "á", "&aacute;")
	mensaje = replace(mensaje, "é", "&eacute;")
	mensaje = replace(mensaje, "í", "&iacute;")
	mensaje = replace(mensaje, "ó", "&oacute;")
	mensaje = replace(mensaje, "ú", "&uacute;")
	mensaje = replace(mensaje, "Á", "&Aacute;")
	mensaje = replace(mensaje, "É", "&Eacute;")
	mensaje = replace(mensaje, "Í", "&Iacute;")
	mensaje = replace(mensaje, "Ó", "&Oacute;")
	mensaje = replace(mensaje, "Ú", "&Uacute;")
	mensaje = replace(mensaje, "ñ", "&ntilde;")
	mensaje = replace(mensaje, "Ñ", "&Ntilde;")
	mensaje = replace(mensaje, "ü", "&uuml;")
	mensaje = replace(mensaje, "Ü", "&Uuml;")
	mensaje = replace(mensaje, "ç", "&ccedil;")
	mensaje = replace(mensaje, "Ç", "&Ccedil;")
   

	adjunto = "D:\Intranets\Ventas\asp\Carrito_Imprenta\Envio_Mails_CDO\ejemplo\3991.pdf"
	'response.write("<br><br>ruta: " & ruta)
	servidor = "GLOBALIA"
	'servidor = "AMAZON"
   
	respuesta_envio = envio_email(de, para, asunto, mensaje, adjunto, servidor)
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pedido AUTOMATICO GLS 280-2 MIFARMA</TITLE>
</HEAD>

   
<BODY>
<b><%=mensaje%></b>	
<br /><br />
<b>Respuesta Envio email: <%=respuesta_envio%></b>	
</BODY>
</HTML>

