<%@ language=vbscript %>
<!--#include file="Conexion_Gldistri.inc"-->

<%

	direccion_ip=""
	'texto=""
	if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
		direccion_ip=Request.ServerVariables("HTTP_X_FORWARDED_FOR")
		'texto="nos quedamos con http_x_forwarded_for"
	  else
  		direccion_ip=Request.ServerVariables("REMOTE_ADDR")
		'texto="nos quedamos con remote_addr"
	end if

	'response.write("<br>HTTP_X_FORWARDED_FOR: " & Request.ServerVariables("HTTP_X_FORWARDED_FOR"))
	'response.write("<br>REMOTE_ADDR: " & Request.ServerVariables("REMOTE_ADDR"))

	codigo_empresa=""
	codigo_empresa=Request.Querystring("empresa")

	'response.write(empresa)
	set  logo_empresa=Server.CreateObject("ADODB.Recordset")

	set ip_permitida=Server.CreateObject("ADODB.Recordset")

	with logo_empresa
		.ActiveConnection=conndistribuidora
		.Source="Select logotipo from empresas where codigo=" & codigo_empresa
		'response.write(.Source)	
		.Open
	end with


	'response.write("<br><br>ip seleccionada: " & direccion_ip)
	'direccion_ip=Request.ServerVariables("REMOTE_ADDR") 
	with ip_permitida
		.ActiveConnection=conndistribuidora
		.Source="Select ip from ips_permitidas where empresa=" & codigo_empresa & " and ip='" & direccion_ip & "'"
		'response.write(.Source)	
		.Open

	end with

	permitir_acceso="si"
	'cuando no son ni halcon ni ecuador hay
	'  que restringir el acceso para que solo
	'  puedan entrar ciertas ips que nos pasaron
	'  en su dia
	if codigo_empresa<>1 and codigo_empresa<>11 then
		if ip_permitida.eof then
			permitir_acceso="no"
		end if
	end if
		
	
	logotipo_empresa=""
	if not logo_empresa.eof then
		if logo_empresa("logotipo")<>"" then
			logo= logo_empresa("logotipo") 
			logotipo_empresa="logos_empresas/" & logo
			
		end if
		
	end if
	'response.write("<br>Logo: " & logotipo_empresa)
	
%>
<html>
<head>
<title>PETICIONES A LA DISTRIBUIDORA</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<%if permitir_acceso="si" then%>
	<frameset cols="177,*" frameborder="NO" border="1" framespacing="0" rows="*"> 
  		<frame name="izquierda" scrolling="NO" noresize src="opciones.asp?logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>">
		<frame name="right" src="sucursales.asp?logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>">
	</frameset>
	<noframes> 
	<body bgcolor="#FFFFFF" text="#000000">
	</body>
	</noframes>
<%else%>
	<body bgcolor="#FFFFFF" text="#000000">
		<br><br><br>
		<font color=red>ESTE EQUIPO NO TIENE PERMITIDO EL ACCESO A LAS PETICIONES A LA DISTRIBUIDORA</font>
	</body>
<%end if%>

<% 
	logo_empresa.close
	ip_permitida.close
	conndistribuidora.close
		
	set logo_empresa=Nothing
	set ip_permitida=Nothing
	set conndistribuidora=Nothing
		

%> 
</html>
