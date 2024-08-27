﻿<%@ language=vbscript%>

<!--#include file="Conexion.inc"-->
<!--#include file="Envio_Mails_CDO/Envio_Mail.inc"-->

<%
Response.CharSet = "UTF-8"
Response.CodePage = 65001

sub mail_aviso_saldo(saldo)

	adCmdStoredProc=4
	adVarChar=200
	adLongVarChar=201
	adParamInput=1

	set datos_saldo=Server.CreateObject("ADODB.Recordset")
	with datos_saldo
		.ActiveConnection=connimprenta
		.Source="SELECT A.ID, A.CODCLI, B.NOMBRE AS NOMBRE_CLIENTE, B.EMAIL, A.FECHA, A.IMPORTE"
		.Source=.Source & ", A.TOTAL_DISFRUTADO, A.OBSERVACIONES, A.ORDENANTE, C.NOMBRE AS NOMBRE_ORDENANTE"
		.Source=.Source & ", A.TIPO, D.DESCRIPCION AS DESCRIPCION_TIPO, A.CARGO_ABONO"
		.Source=.Source & " FROM SALDOS A INNER JOIN V_CLIENTES B ON A.CODCLI=B.ID"
		.Source=.Source & " INNER JOIN SALDOS_ORDENANTES C ON A.ORDENANTE=C.ID"
		.Source=.Source & " INNER JOIN SALDOS_TIPOS D ON A.TIPO=D.ID"
		.Source=.Source & " WHERE A.ID=" & saldo
		
		'response.write("<br>datos mail: " & .source)
		.Open
	end with
		
	if not datos_saldo.eof then
		
		enviar_a="" & datos_saldo("EMAIL") 	
		
		if enviar_a="" then
			correos_recibe_real="ccalvo@globalia-corp.com"
		  else
		  	correos_recibe_real= enviar_a
		end if
			
		correos_recibe_real=correos_recibe_real & ";malba@globalia-artesgraficas.com"
		
		
		
		if enviar_a="" then
			texto_asunto = "Aviso Automatico NO enviado al cliente porque le falta el EMAIL"
		  else
			texto_asunto = "Generado nuevo """ & datos_saldo("CARGO_ABONO") & """ con numero """ & datos_saldo("ID") & """ en su perfil de Globalia."
		end if
			
	
		de = "carlos.gonzalez@globalia-artesgraficas.com"
		para = correos_recibe_real
		asunto = texto_asunto
   
		mensaje = "<div style='background-color:#fff;width:650px;font-family:Open-sans,sans-serif;color:#555454;font-size:13px;line-height:18px;margin:auto'>"
		mensaje = mensaje & "<table style='width:100%' bgcolor='#ffffff'>"
		mensaje = mensaje & "<tbody>"
		mensaje = mensaje & "<tr><td style='border-bottom:4px solid #333333;padding:7px 0'>&nbsp;</td></tr>"
		if enviar_a="" then
			mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
			mensaje = mensaje & "<tr>"
			mensaje = mensaje & "<td style='padding:7px 0'>"
			mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
			mensaje = mensaje & "<span><strong>NO SE HA ENVIADO ESTE AVISO POR EMAIL AL CLIENTE, PORQUE EN SU FICHA NO TIENE ASIGNADO NINGUNO.</strong></span>"
			mensaje = mensaje & "</font>"
			mensaje = mensaje & "</td>"
			mensaje = mensaje & "</tr>"
		end if		
		mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='padding:7px 0'>"
		mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
		mensaje = mensaje & "<span>Se ha procedido a generar un """ & datos_saldo("CARGO_ABONO") & """ con numero """ & datos_saldo("ID") & """ con el siguiente detalle.</span>"
		mensaje = mensaje & "</font>"
		mensaje = mensaje & "</td>"
		mensaje = mensaje & "</tr>"
		mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='border:1px solid #d6d4d4;background-color:#f8f8f8;padding:7px 0'>"
		mensaje = mensaje & "<table style='width:100%'>"
		mensaje = mensaje & "<tbody>"
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='padding:7px 0' width='10'>&nbsp;</td>"
		mensaje = mensaje & "<td style='padding:7px 0'>"
		mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
		mensaje = mensaje & "<p style='border-bottom:1px solid #d6d4d4;margin:3px 0 7px;text-transform:uppercase;font-weight:500;font-size:18px;padding-bottom:10px'>"
		mensaje = mensaje & "Saldo " & datos_saldo("ID") & "</p>"
		mensaje = mensaje & "<span style='color:#777'>"
		mensaje = mensaje & "Cliente: <strong><span style='color:#333'>" & UCASE(datos_saldo("NOMBRE_CLIENTE")) & " (" & UCASE(datos_saldo("CODCLI")) & ")</span></strong>."
		mensaje = mensaje & "<br>Fecha: <strong><span style='color:#333'>" & UCASE(datos_saldo("FECHA")) & "</span></strong>."
		mensaje = mensaje & "<br>Importe: <strong><span style='color:#333'>" & UCASE(datos_saldo("IMPORTE")) & "&euro;</span></strong>."
		mensaje = mensaje & "<br>Realizado Por: <strong><span style='color:#333'>" & UCASE(datos_saldo("NOMBRE_ORDENANTE")) & "</span></strong>."
		mensaje = mensaje & "<br>Tipo: <strong><span style='color:#333'>" & UCASE(datos_saldo("DESCRIPCION_TIPO")) & "</span></strong>."
		mensaje = mensaje & "<br>Cargo o Abono: <strong><span style='color:#333'>" & UCASE(datos_saldo("CARGO_ABONO")) & "</span></strong>."
		mensaje = mensaje & "<br>Observaciones: <strong><span style='color:#333'>" & UCASE(datos_saldo("OBSERVACIONES")) & "</span></strong>."
		
		
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
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='padding:7px 0'>"
		mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
		mensaje = mensaje & "<span>Este saldo, se compensará en el importe a pagar del próximo pedido que realice.</span>"
		mensaje = mensaje & "</font>"
		mensaje = mensaje & "</td>"
		mensaje = mensaje & "</tr>"
		mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='padding:7px 0'>"
		mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
		mensaje = mensaje & "<span>Saludos y gracias.</span>"
		mensaje = mensaje & "</font>"
		mensaje = mensaje & "</td>"
		mensaje = mensaje & "</tr>"
		mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='border-top:4px solid #333333;padding:7px 0'>"
		mensaje = mensaje & "<span></span>"
		mensaje = mensaje & "</td>"
		mensaje = mensaje & "</tr>"
		mensaje = mensaje & "</tbody>"
		mensaje = mensaje & "</table>"
		mensaje = mensaje & "</div>"
		
		
		if C_ENTORNO_EJECUCION <> "PROD" then
			'ENTORNO PRUEBAS		
			mensaje=mensaje & "<BR><BR>este correo se deberia mandar al administrador: " & correos_recibe_real
		end if
		
		adjunto= ""
		servidor = "GLOBALIA"
		'servidor = "AMAZON"
		'response.write("<br>DE: " & de)
		'response.write("<br>PARA: " & para)
		'response.write("<br>ASUNTO: " & ASUNTO)
		'response.write("<br>MENSAJE: " & MENSAJE)
		'response.write("<br>ADJUNTO: " & ADJUNTO)
		'response.write("<br>SERVIDOR: " & SERVIDOR)
		respuesta_envio = envio_email(de, para, asunto, mensaje, adjunto, servidor)
			
	end if
	
	datos_saldo.close
	set datos_saldo=Nothing
		

end sub

'Response.Write("<b>el charset despues: " & Response.Charset)
'Response.Write("<br>el codepage despues: " & Response.CodePage)



	caso=""	
	

    dim usuarios
	
	codigo_cliente = "" & Request.Form("codigo_cliente")
	fecha = "" & Request.Form("fecha")
	importe = "" & Request.Form("importe")
	ordenante = "" & Request.Form("ordenante")
	tipo = "" & Request.Form("tipo")
	cargo_abono = "" & Request.Form("cargo_abono")
	observaciones = "" & Request.Form("observaciones")

	
	
	'response.write("<br>origen: " & origen)
	'response.write("<br>usuario seleccionado: " & usuario_seleccionado)
	'response.write("<br>contraseña seleccionada: " & contrasenna_seleccionada)
	'response.write("<br>contraseña antigua: " & contrasenna_antigua_seleccionada)
	'response.write("<br>contraseña nueva: " & contrasenna_nueva_seleccionada)
	'response.write("<br>nombre: " & nombre)
	
	
	caso="ALTA_OK"	
	observaciones = REPLACE(observaciones, "'","´")
	observaciones = REPLACE(observaciones, """","´")
	
	sql="INSERT INTO SALDOS (CODCLI, FECHA, IMPORTE, ORDENANTE, TIPO, OBSERVACIONES, CARGO_ABONO)"
	sql = sql & " VALUES (" & codigo_cliente & ", '" & cdate(fecha) & "', " & replace(importe,",",".") & ", '" & ordenante & "', '" & tipo & "', '" & observaciones &"', '" & cargo_abono & "')"
	'response.write("<br><br>sql: " & sql)

	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
	Set valor_nuevo = connimprenta.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
	numero_saldo=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
	valor_nuevo.Close
	Set valor_nuevo = Nothing
	
	mail_aviso_saldo(numero_saldo)
	
	connimprenta.close
	set connimprenta=Nothing
		
		
	
	cadena_json = "{"
	cadena_json = cadena_json & """resultado"":""" & caso & """" 
	'cadena_json = cadena_json & ", ""id_usuario_gls"":""" & id_usuario_gls & """"
	'cadena_json = cadena_json & ", ""usuario_usuario_gls"":""" & usuario_usuario_gls & """"
	'cadena_json = cadena_json & ", ""nombre_usuario_gls"":""" & nombre_usuario_gls & """"
	'cadena_json = cadena_json & ", ""apellidos_usuario_gls"":""" & apellidos_usuario_gls & """"
	'cadena_json = cadena_json & ", ""email_usuario_gls"":""" & email_usuario_gls & """"
	'cadena_json = cadena_json & ", ""borrado_usuario_gls"":""" & borrado_usuario_gls & """"
	'cadena_json = cadena_json & ", ""grupo_ropa_usuario_gls"":""" & grupo_ropa_usuario_gls & """"
	'cadena_json = cadena_json & ", ""centro_coste_usuario_gls"":""" & centro_coste_usuario_gls & """"
	'cadena_json = cadena_json & ", ""nuevo_usuario_usuario_gls"":""" & nuevo_usuario_usuario_gls & """"
    'cadena_json = cadena_json & ", ""cambiar_contrasenna_usuario_gls"":""" & cambiar_contrasenna & """"
	cadena_json = cadena_json & "}"
	
	
	
	response.write(cadena_json)
%>

