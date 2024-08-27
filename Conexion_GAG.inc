<!--#include file="Definicion_Entorno.inc"-->
<%
set conn_gag = server.createObject("adodb.connection")
with conn_gag
	if C_ENTORNO_EJECUCION = "PROD" then
		.ConnectionString="Provider=SQLOLEDB.1;" & _
			"Persist Security Info=False;"  & _
			"User ID=USUARIO_IIS;"  & _
			"Password=globalia;"  & _
			"Initial Catalog=GAG;"  & _
			"Data Source=globalia-ag-pro-v2.clg0eqcx5qj9.eu-west-1.rds.amazonaws.com"

  	  else

		.ConnectionString="Provider=SQLOLEDB.1;" & _
			"Persist Security Info=False;"  & _
			"User ID=PRE__USUARIO_IIS;"  & _
			"Password=PRE__globalia;"  & _
			"Initial Catalog=PRE__GAG;"  & _
			"Data Source=globalia-ag-pro-v2.clg0eqcx5qj9.eu-west-1.rds.amazonaws.com"
	end if
	.open
end with


%>