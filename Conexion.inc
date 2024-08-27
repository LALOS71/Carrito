<!--#include file="Definicion_Entorno.inc"-->
<%
set connimprenta = server.createObject("adodb.connection")
with connimprenta
	
	if C_ENTORNO_EJECUCION = "PROD" then
		.ConnectionString="Provider=SQLOLEDB.1;" & _
			"Persist Security Info=False;"  & _
			"User ID=USUARIO_IIS;"  & _
			"Password=globalia;"  & _
			"Initial Catalog=artes_graficas;"  & _
			"Data Source=globalia-ag-pro-v2.clg0eqcx5qj9.eu-west-1.rds.amazonaws.com"

  	  else

		.ConnectionString="Provider=SQLOLEDB.1;" & _
			"Persist Security Info=False;"  & _
			"User ID=PRE__USUARIO_IIS;"  & _
			"Password=PRE__globalia;"  & _
			"Initial Catalog=PRE__artes_graficas;"  & _
			"Data Source=globalia-ag-pro-v2.clg0eqcx5qj9.eu-west-1.rds.amazonaws.com"
	end if
	.Open
end with


%>

