<%


set conn_boletin = server.createObject("adodb.connection")
with conn_boletin
	'.ConnectionString="Provider=SQLOLEDB.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=sa;"  & _
	'	"Password=;"  & _
	'	"Initial Catalog=V5;"  & _
	'	"Data Source=SERVIDOR2"

	
	.ConnectionString="Provider=SQLOLEDB.1;" & _
		"Persist Security Info=False;"  & _
		"User ID=usuario_iis;"  & _
		"Password=globalia;"  & _
		"Initial Catalog=BOLETIN_NUEVO;"  & _
		"Data Source=SERVERSQL\SERVERSQL"
	.Open
end with


%>