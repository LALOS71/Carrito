<%
'Response.CodePage = 65001
'Response.CharSet = "iso-8859-1"

'Abrimos la conexion con la BD
set conn_actdir = server.createObject("adodb.connection")
with conn_actdir

	'CONEXION ENTORNO PRODUCCION
	.ConnectionString="Provider=OraOLEDB.Oracle;" & _
		"Persist Security Info=False;"  & _
		"User ID=GLBDIS;"  & _
		"Password=glbdes;"  & _
		"Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.156.201)(PORT=1521))(CONNECT_DATA=(SID=HOTELES)))"
	.Open
end with
%>