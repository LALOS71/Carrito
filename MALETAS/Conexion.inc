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
	'CONEXION DE PRODUCCION ANTIGUA
	'*************************
	'.ConnectionString="Provider=SQLOLEDB.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=usucase;"  & _
	'	"Password=MaL3tAs18;"  & _
	'	"Initial Catalog=Maletas;"  & _
	'	"Data Source=192.168.156.136"
	'.ConnectionTimeout = 300
	'.CommandTimeOut = 200 


	'*************************
	'CONEXION DE PRODUCCION PERO PARA PRUEBAS
	'*************************
	.ConnectionString="Provider=SQLOLEDB.1;" & _
		"Persist Security Info=False;"  & _
		"User ID=usucase;"  & _
		"Password=MaL3tAs18;"  & _
		"Initial Catalog=MALETAS_PRU;"  & _
		"Data Source=192.168.156.136"
	.ConnectionTimeout = 300
	.CommandTimeOut = 200 



	'*************************
	'CONEXION DE PRODUCCION YA EN EL NUEVO SERVIDOR
	'*************************
	'.ConnectionString="Provider=SQLOLEDB.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=usucase;"  & _
	'	"Password=MaL3tAs18;"  & _
	'	"Initial Catalog=Maletas;"  & _
	'	"Data Source=SQLGAGBACK\SQLGAG16"
	'.ConnectionTimeout = 300
	'.CommandTimeOut = 200 



	.Open
end with


%>

