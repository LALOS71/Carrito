<%


set connimprenta = server.createObject("adodb.connection")
with connimprenta
	'.ConnectionString="Provider=SQLOLEDB.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=sa;"  & _
	'	"Password=;"  & _
	'	"Initial Catalog=V5;"  & _
	'	"Data Source=SERVIDOR2"


	
	'*************************
	'CONEXION DE PRODUCCION... PERO PARA PRUEBAS
	'*************************
	
	.ConnectionString="Provider=SQLOLEDB.1;" & _
		"Persist Security Info=False;"  & _
		"User ID=backhalconuser;"  & _
		"Password=imprenta;"  & _
		"Initial Catalog=GAG_PRU1;"  & _
		"Data Source=192.168.156.136"
	.ConnectionTimeout = 300
	.CommandTimeOut = 200 

	.Open
end with


%>

