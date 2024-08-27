<%


set conn_gag = server.createObject("adodb.connection")
with conn_gag
	.ConnectionString="Provider=SQLOLEDB.1;" & _
		"Persist Security Info=False;"  & _
		"User ID=usuario_iis;"  & _
		"Password=globalia;"  & _
		"Initial Catalog=GAG_PRU;"  & _
		"Data Source=SERVERSQL\SERVERSQL"
	.Open

	
	'.ConnectionString="Provider=SQLOLEDB.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=backhalconuser;"  & _
	'	"Password=backhalconuser;"  & _
	'	"Initial Catalog=GAG;"  & _
	'	"Data Source=192.168.153.237\PINTRAHALCON"
	'.Open
end with


%>