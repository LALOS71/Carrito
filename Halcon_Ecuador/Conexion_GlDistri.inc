<%
'Abrimos la conexion con la BD
set conndistribuidora = server.createObject("adodb.connection")
with conndistribuidora

	'*************************
	'CONEXION DE PRODUCCION
	'*************************	
	.ConnectionString="Provider=SQLOLEDB.1;" & _
		"Persist Security Info=False;"  & _
		"User ID=usuario_iis;"  & _
		"Password=globalia;"  & _
		"Initial Catalog=GLDISTRI;"  & _
		"Data Source=SQLGAGBACK\SQLGAG16"

	'*************************
	'CONEXION DE PREPRODUCCION
	'*************************
	'.ConnectionString="Provider=SQLOLEDB.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=backhalconuser;"  & _
	'	"Password=backhalconuser;"  & _
	'	"Initial Catalog=GLDISTRI;"  & _
	'	"Data Source=PBACKHALCON\PINTRAHALCON"

	.ConnectionTimeout = 300
	.CommandTimeOut = 200 


	.Open
end with
%>
