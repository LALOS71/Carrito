<!--#include file="Definicion_Entorno.inc"-->
<%
Dim env 
Dim conn_gag
'env = "DES"
env = C_ENTORNO_EJECUCION

Sub connect_with_gag(env)
	Set conn_gag = server.createObject("adodb.connection")
	If env = "PROD" Then
		
		With conn_gag	
			.ConnectionString="Provider=SQLOLEDB.1;" & _
				"Persist Security Info=False;"  & _
				"User ID=USUARIO_IIS;"  & _
				"Password=globalia;"  & _
				"Initial Catalog=GAG;"  & _
				"Data Source=globalia-ag-pro-v2.clg0eqcx5qj9.eu-west-1.rds.amazonaws.com"
			.ConnectionTimeout=300
			.CommandTimeout=180
			.Open
		End With
	Else
		
		With conn_gag	
			.ConnectionString="Provider=SQLOLEDB.1;" & _
				"Persist Security Info=False;"  & _
				"User ID=PRE__USUARIO_IIS;"  & _
				"Password=PRE__globalia;"  & _
				"Initial Catalog=PRE__GAG;"  & _
				"Data Source=globalia-ag-pro-v2.clg0eqcx5qj9.eu-west-1.rds.amazonaws.com"
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