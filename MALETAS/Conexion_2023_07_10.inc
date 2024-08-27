<%


set connmaletas = server.createObject("adodb.connection")
with connmaletas
	'.ConnectionString="Provider=SQLOLEDB.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=sa;"  & _
	'	"Password=;"  & _
	'	"Initial Catalog=V5;"  & _
	'	"Data Source=SERVIDOR2"

	'*************************
	'CONEXION DE PREPRODUCCION
	'*************************
	.ConnectionString="Provider=SQLOLEDB.1;" & _
		"Persist Security Info=False;"  & _
		"User ID=backhalconuser;"  & _
		"Password=backhalconuser;"  & _
		"Initial Catalog=MALETAS;"  & _
		"Data Source=PBACKHALCON\PINTRAHALCON"
	.ConnectionTimeout = 300
	.CommandTimeOut = 200 

	.Open
end with


%>

