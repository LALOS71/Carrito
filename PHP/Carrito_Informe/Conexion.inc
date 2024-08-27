<%


set connimprenta = server.createObject("adodb.connection")
with connimprenta
	
	
	.ConnectionString="Provider=SQLOLEDB.1;" & _
		"Persist Security Info=False;"  & _
		"User ID=ARTESGRAFICASUSER;"  & _
		"Password=ARTESGRAFICASUSER;"  & _
		"Initial Catalog=ARTES_GRAFICAS;"  & _
		"Data Source=GAGSQLPRE\PSQLGAG16"
	.ConnectionTimeout = 300
	.CommandTimeOut = 200 

	.Open
end with


%>

