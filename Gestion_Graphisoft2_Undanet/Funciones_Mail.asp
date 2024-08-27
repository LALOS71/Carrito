
<!--#include file="../Envio_Mails_CDO/Envio_Mail.inc"-->

<%
	ADMIN_MAIL = "malba@globalia-artesgraficas.com"

	MAIL_FROM  = "noreply@globalia-artesgraficas.com"
	MAIL_NAME  = "Graphisoft"	
	MAIL_HOST  = "192.168.150.44"
	MAIL_USER  = ""
	MAIL_PASS  = ""
	MAIL_PORT  = ""
		
	Function send_mail(mail_from, mail_from_name, mail_to, mail_subject, mail_body)

		Set Mail = Server.CreateObject("Persits.MailSender")

		Mail.Host = MAIL_HOST
		if MAIL_USER<>"" Then
			Mail.Username = MAIL_USER
			Mail.Password = MAIL_PASS
		end if
		if MAIL_PORT<>"" Then
			Mail.TLS = True
			Mail.Port = MAIL_PORT
		end if

		Mail.From = mail_from
		Mail.FromName = mail_from_name
		Mail.AddAddress mail_to
		Mail.Subject = mail_subject
		Mail.Body = mail_body
		Mail.IsHTML = True

		Mail.ContentTransferEncoding = "Quoted-Printable"

		Mail.Send

		If Err <> 0 Then
			Response.Write "<br>La descripcion del error es: " & Err.Description 
			Response.Write "<br>"
			send = false
		else
			send = true
		End If
	
		send_mail = send
	End Function
	
	
	Function get_domain_url()
		If lcase(Request.ServerVariables("HTTPS")) = "on" Then 
			protocol = "https" 
		Else
			protocol = "http" 
		End If
		domain = Request.ServerVariables("SERVER_NAME")
		
		path = Request.ServerVariables("URL")
		temp = split(path, "/")		
		path = replace(path, temp(ubound(temp)), "")
		
		get_domain_url = protocol & "://" & domain & path
		
	End Function
	
	
	Function mail_seguimiento(id_presupuesto)
		'response.write("<br>*******************<br>DENTRO DE MAIL_SEGUIMIENTO")
	
		sql = "SELECT ID_PRESUPUESTO, PRESUPUESTO, VERSION"
		sql = sql & ", A.ID_CLIENTE, D.NOMBRE AS CLIENTE_NOMBRE"
		sql = sql & ", D.TELEFONO AS CLIENTE_TELEFONO"
		sql = sql & ", PRESUPUESTISTA, FECHA_CREACION, CANTIDAD, IMPORTE, A.DESCRIPCION AS DESCRIPCION"
		sql = sql & ", TARIFA, A.OBSERVACIONES_GESTION AS OBSERVACIONES_LOCAL, A.PROXIMA_REVISION, U.EMAIL"
		sql = sql & " FROM GESTION_GRAPHISOFT_PRESUPUESTOS A"
		sql = sql & " LEFT JOIN GESTION_GRAPHISOFT_USUARIOS U ON (A.IDPRESUPUESTISTA=U.ID_PRESUPUESTISTA)"
		sql = sql & " LEFT JOIN GESTION_GRAPHISOFT_CLIENTES D ON (A.ID_CLIENTE=D.ID)"
		sql = sql & " WHERE ID_PRESUPUESTO = " & id_presupuesto
		
		'Response.Write("<br>" & sql)

		Set presupuesto = execute_sql(conn_gag, sql)
		If Not presupuesto.EOF Then
			campo_id_presupuesto	= "" & presupuesto("id_presupuesto")
			campo_presupuesto		= "" & presupuesto("presupuesto")
			campo_version			= "" & presupuesto("version")
			campo_fecha_creacion	= "" & presupuesto("fecha_creacion")
			campo_cantidad			= "" & presupuesto("cantidad")
			campo_importe			= "" & presupuesto("importe")
			campo_cliente_nombre	= "" & presupuesto("cliente_nombre")
			campo_cliente_telefono	= "" & presupuesto("cliente_telefono")
			campo_presupuestista	= "" & presupuesto("presupuestista")
			campo_descripcion		= "" & presupuesto("descripcion")
			mail_address				= "" & presupuesto("email")
			if campo_proxima_revision<>"" then
				campo_proxima_revision_formateado=(year(campo_proxima_revision) & "-" & right("0" & month(campo_proxima_revision), 2) & "-" & right("0" & day(campo_proxima_revision), 2))
			end if
			If env = "DES" Then
				mail_address = ADMIN_MAIL
			end if
		
			'ENVIAMOS EL CORREO ELECTRONICO
			de = MAIL_FROM
			para = mail_address 
			asunto = "Presupuesto #" & id_presupuesto & " en Seguimiento"
			mensaje = "<h1 style='text-align:center'>GRAPHISOFT</h1>" &_
					"<h2>DETALLE PRESUPUESTO #" & id_presupuesto & " en Seguimiento</h2>" &_
					"<table border=0>" &_
					"" &_
					"<tr><td>PRESUPUESTO:</td><td><b>" & campo_presupuesto & "/" & campo_version & "</b></td></tr>" &_
					"<tr><td>PRESUPUESTISTA:</td><td><b>" & campo_presupuestista & "</b></td></tr>" &_
					"<tr><td>CLIENTE:</td><td><b>" & campo_cliente_nombre & "</b></td></tr>" &_
					"<tr><td>FECHA CREACI&Oacute;N:</td><td><b>" & campo_fecha_creacion & "</b></td></tr>" &_
					"<tr><td>DESCRIPCI&Oacute;N:</td><td><b>" & campo_descripcion & "</b></td></tr>" &_
					"<tr><td>CANTIDAD:</td><td><b>" & campo_cantidad & "</b></td></tr>" &_
					"<tr><td>CONTACTO:</td><td><b>" & campo_cliente_telefono & "</b></td></tr>" &_
					"</table>" &_
					"<br /><br />" &_
					"<a href='"& get_domain_url &"/Detalle_Presupuesto.asp?id=" & id_presupuesto & "' " &_
					"target='_blank' style='padding:4px; border:solid 1px #337ab7; text-decoration:none'>" &_
					"Gestionar en la web</a>" &_
					""
			
			adjunto= ""
			servidor = "GLOBALIA"
			
			'RESPONSE.WRITE("<BR>DE: " & de)
			'RESPONSE.WRITE("<BR>PARA: " & para)
			'RESPONSE.WRITE("<BR>ASUNTO: " & asunto)
			'RESPONSE.WRITE("<BR>BODY: " & mensaje)
			mail_seguimiento = envio_email(de, para, asunto, mensaje, adjunto, servidor)
			'mail_seguimiento = send_mail(MAIL_FROM, MAIL_NAME, mail_address, subject, body)
			
		End If
		'response.write("<br>SALIMOS DE MAIL_SEGUIMIENTO<br>*******************")
		
	End Function
	
	
	Function mail_recordatorio(id_presupuesto)
		'response.write("<br>DENTRO DE MAIL_RECORDATORIO")
	
		sql = "SELECT ID_PRESUPUESTO, PRESUPUESTO, VERSION"
		sql = sql & ", A.ID_CLIENTE, D.NOMBRE AS CLIENTE_NOMBRE"
		sql = sql & ", D.TELEFONO AS CLIENTE_TELEFONO"
		sql = sql & ", PRESUPUESTISTA, FECHA_CREACION, CANTIDAD, IMPORTE, A.DESCRIPCION AS DESCRIPCION"
		sql = sql & ", TARIFA, A.OBSERVACIONES_GESTION AS OBSERVACIONES_LOCAL, A.PROXIMA_REVISION, U.EMAIL"
		sql = sql & " FROM GESTION_GRAPHISOFT_PRESUPUESTOS A"
		sql = sql & " LEFT JOIN GESTION_GRAPHISOFT_USUARIOS U ON (A.IDPRESUPUESTISTA=U.ID_PRESUPUESTISTA)"
		sql = sql & " LEFT JOIN GESTION_GRAPHISOFT_CLIENTES D ON (A.ID_CLIENTE=D.ID)"
		sql = sql & " WHERE ID_PRESUPUESTO = " & id_presupuesto
		
		'Response.Write("<br>" & sql)

		Set presupuesto = execute_sql(conn_gag, sql)
		If Not presupuesto.EOF Then
			campo_id_presupuesto	= "" & presupuesto("id_presupuesto")
			campo_presupuesto		= "" & presupuesto("presupuesto")
			campo_version			= "" & presupuesto("version")
			campo_fecha_creacion	= "" & presupuesto("fecha_creacion")
			campo_cantidad			= "" & presupuesto("cantidad")
			campo_importe			= "" & presupuesto("importe")
			campo_cliente_nombre	= "" & presupuesto("cliente_nombre")
			campo_cliente_telefono	= "" & presupuesto("cliente_telefono")
			campo_presupuestista	= "" & presupuesto("presupuestista")
			campo_descripcion		= "" & presupuesto("descripcion")
			mail_address			= "" & presupuesto("email")
			
			if campo_proxima_revision<>"" then
				campo_proxima_revision_formateado=(year(campo_proxima_revision) & "-" & right("0" & month(campo_proxima_revision), 2) & "-" & right("0" & day(campo_proxima_revision), 2))
			end if
			If env = "DES" Then
				mail_address = ADMIN_MAIL
			end if
			
			'ENVIAMOS EL CORREO ELECTRONICO
			de = MAIL_FROM
			para = mail_address 
			asunto = "RECORDATORIO Presupuesto #" & id_presupuesto & " en Seguimiento"
			mensaje = "<h1 style='text-align:center'>GRAPHISOFT</h1>" &_
					"<h2>DETALLE PRESUPUESTO #" & id_presupuesto & " en Seguimiento</h2>" &_
					"<table border=0>" &_
					"" &_
					"<tr><td>PRESUPUESTO:</td><td><b>" & campo_presupuesto & "/" & campo_version & "</b></td></tr>" &_
					"<tr><td>PRESUPUESTISTA:</td><td><b>" & campo_presupuestista & "</b></td></tr>" &_
					"<tr><td>CLIENTE:</td><td><b>" & campo_cliente_nombre & "</b></td></tr>" &_
					"<tr><td>FECHA CREACI&Oacute;N:</td><td><b>" & campo_fecha_creacion & "</b></td></tr>" &_
					"<tr><td>DESCRIPCI&Oacute;N:</td><td><b>" & campo_descripcion & "</b></td></tr>" &_
					"<tr><td>CANTIDAD:</td><td><b>" & campo_cantidad & "</b></td></tr>" &_
					"<tr><td>CONTACTO:</td><td><b>" & campo_cliente_telefono & "</b></td></tr>" &_
					"</table>" &_
					"<br /><br />" &_
					"<a href='"& get_domain_url &"/Detalle_Presupuesto.asp?id=" & id_presupuesto & "' " &_
					"target='_blank' style='padding:4px; border:solid 1px #337ab7; text-decoration:none'>" &_
					"Gestionar en la web</a>" &_
					""
			
			'RESPONSE.WRITE("<BR>DE: " & de)
			'RESPONSE.WRITE("<BR>PARA: " & para)
			'RESPONSE.WRITE("<BR>ASUNTO: " & asunto)
			'RESPONSE.WRITE("<BR>BODY: " & mensaje)
			adjunto= ""
			servidor = "GLOBALIA"
			mail_recordatorio = envio_email(de, para, asunto, mensaje, adjunto, servidor)
		End If
	End Function
	
%>

