<%@ language=vbscript %>
<%
Dim env 
Dim conn_gag
'env = "DES"
env = "prod"

Sub connect_with_gag(env)
	If env = "prod" Then
		Set conn_gag = server.createObject("adodb.connection")
		With conn_gag	
			.ConnectionString="Provider=SQLOLEDB.1;" & _
				"Persist Security Info=False;"  & _
				"User ID=usuario_iis;"  & _
				"Password=globalia;"  & _
				"Initial Catalog=GAG;"  & _
				"Data Source=SERVERSQL\SERVERSQL"
			.Open
		End With
	Else
		Set conn_gag = server.createObject("ADODB.connection")
		With conn_gag	
			.ConnectionString="Provider=SQLOLEDB.1;" & _
				"Persist Security Info=False;"  & _
				"User ID=backhalconuser;"  & _
				"Password=backhalconuser;"  & _
				"Initial Catalog=GAG;"  & _
				"Data Source=192.168.153.237\PINTRAHALCON"
			.Open
		End With
	End If
End Sub

Sub close_connection(connection)
	connection.close
	Set connection = Nothing
End Sub

connect_with_gag(env)

%>