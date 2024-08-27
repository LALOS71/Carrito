<%
'response.write("<br>entro en el ini de capturar_ip")
direccion_ip=""
'texto=""
if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
	direccion_ip=Request.ServerVariables("HTTP_X_FORWARDED_FOR")
	'texto="nos quedamos con http_x_forwarded_for"
  else
  	direccion_ip=Request.ServerVariables("REMOTE_ADDR")
	'texto="nos quedamos con remote_addr"
end if

'response.write(texto & "... ip: " & direccion_ip)
'response.write("<br><br>Salgo del Ini de Capturar_ip")
%>