<%
'Response.CodePage = 65001
'Response.CharSet = "iso-8859-1"

'Abrimos la conexion con la BD
set conn_envios_distri = server.createObject("adodb.connection")
with conn_envios_distri
	'CONEXION ENTORNO DESARROLLO
	'.ConnectionString="Provider=MSDAORA.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=GLBDIS;"  & _
	'	"Password=glbdes;"  & _
	'	"Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.153.80)(PORT=1713))(CONNECT_DATA=(SID=DHOTELES)))"
	

	'CONEXION ENTORNO PRODUCCION
	'.ConnectionString="Provider=MSDAORA.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=GLBDIS;"  & _
	'	"Password=glbdes;"  & _
	'	"Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.156.201)(PORT=1521))(CONNECT_DATA=(SID=HOTELES)))"
		
	'.ConnectionString="Driver={Oracle in OraClient11g_home1};" & _
	'	"Server=HOTELES" & _
	'	"Uid=GLBDIS;Pwd=glbdes;" & _
	'	"DBQ=HOTELES_EMAILS;"

	'.ConnectionString="Driver={Oracle in OraClient10g_home1};" & _
	'	"Server=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.156.201)(PORT=1521))(CONNECT_DATA=(SID=HOTELES)));" & _
	'	"Uid=GLBDIS;Pwd=glbdes;" & _
	'	"DBQ=HOTELES_EMAILS;"

	'.ConnectionString="Driver={Microsoft ODBC for Oracle};" & _
	'	"DNS=EMAIL_HOTEL" & _
	'	"Uid=GLBDIS;Pwd=glbdes;"

	'.ConnectionString="Driver={Oracle en OraClient10g_home1};" & _
	'	"DNS=EMAIL_HOTEL_ORA" & _
	'	"Uid=GLBDIS;Pwd=glbdes;"

	'.ConnectionString="DNS=EMAIL_HOTEL_ORA" & _
	'	"Uid=GLBDIS;Pwd=glbdes;"

	'**********************FUNCIONA
	'.ConnectionString="Provider=MSDAORA.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=GLBDIS;"  & _
	'	"Password=glbdes;"  & _
	'	"Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.156.201)(PORT=1521))(CONNECT_DATA=(SID=HOTELES)))"
	
	''*********************FUNCIONA
	'.ConnectionString="Provider=OraOLEDB.Oracle.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=GLBDIS;"  & _
	'	"Password=glbdes;"  & _
	'	"Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.156.201)(PORT=1521))(CONNECT_DATA=(SID=HOTELES)))"
	
	'********************NO CARGA	
	'.ConnectionString="Driver={Oracle in OraClient10g_home1};" & _
	'	"DBQ=192.168.156.201:1521/HOTELES;" & _
	'	"Uid=GLBDIS;Pwd=glbdes;"
	
	'********************FALLA, NO RECONOCE EL NOMBRE DE CONEXION (FALTA TNSNAMES?)	
	'.ConnectionString="Driver={Oracle in OraClient10g_home1};" & _
	'	"DBQ=HOTELES_EMAILS;" & _
	'	"Uid=GLBDIS;Pwd=glbdes;"
	
	'*********************FUNCIONA	
	'.ConnectionString="Driver={Microsoft ODBC for Oracle};" & _
	'	"Server=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.156.201)(PORT=1521))(CONNECT_DATA=(SID=HOTELES)));" & _
	'	"Uid=GLBDIS;Pwd=glbdes;"
	
	
	'.ConnectionString="Driver={Oracle in instantclient_11_2};" & _
	'	"Server=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.156.201)(PORT=1521))(CONNECT_DATA=(SID=HOTELES)));" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=GLBDIS;"  & _
	'	"Password=glbdes;"	

	'**************************FUNCIONA
	.ConnectionString="DSN=HOTELES;" & _
		"Persist Security Info=False;"  & _
		"User ID=GLBDIS;"  & _
		"Password=glbdes;"	
	
	  
	.Open
end with
%>