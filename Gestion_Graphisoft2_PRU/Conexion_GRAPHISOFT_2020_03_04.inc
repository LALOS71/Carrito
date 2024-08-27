<%


set conngraphisoft = server.createObject("adodb.connection")
with conngraphisoft
	'.ConnectionString="Provider=SQLOLEDB.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=usuario_iis;"  & _
	'	"Password=globalia;"  & _
	'	"Initial Catalog=GAG;"  & _
	'	"Data Source=SERVERSQL\SERVERSQL"
	'.Open

	
	.ConnectionString="Provider=SQLOLEDB.1;" & _
		"Persist Security Info=False;"  & _
		"User ID=sa;"  & _
		"Password=Graphis0ft;"  & _
		"Initial Catalog=Graphiplus;"  & _
		"Data Source=MAYLLUGRAPH01\GRAPHISOFT2012"
	.ConnectionTimeout=300
	.CommandTimeout=180
	.Open
end with


%>