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
		"User ID=usucase;"  & _
		"Password=MaL3tAs18;"  & _
		"Initial Catalog=Maletas;"  & _
		"Data Source=192.168.156.136"
	.ConnectionTimeout = 300
	.CommandTimeOut = 200 

	.Open
end with


%>

