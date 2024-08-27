<%@ language=vbscript %>
<%
Dim env 
Dim conn_gag
env = "DES"
'env = "prod"

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
			.ConnectionTimeout=300
			.CommandTimeout=180
			.Open
		End With
	Else
		Set conn_gag = server.createObject("ADODB.connection")
		With conn_gag	
			'.ConnectionString="Provider=SQLOLEDB.1;" & _
			'	"Persist Security Info=False;"  & _
			'	"User ID=sa;"  & _
			'	"Password=Globalia2023.*;"  & _
			'	"Initial Catalog=GPH;"  & _
			'	"Data Source=172.19.200.2"


			'base de datos para probar pero OJO DESDE PRODUCCION.....
			.ConnectionString="Provider=SQLOLEDB.1;" & _
				"Persist Security Info=False;"  & _
				"User ID=usuario_iis;"  & _
				"Password=globalia;"  & _
				"Initial Catalog=GAG_PRU;"  & _
				"Data Source=SERVERSQL\SERVERSQL"	

			.ConnectionTimeout=300
			.CommandTimeout=180
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