<%
'Response.CodePage = 65001
'Response.CharSet = "iso-8859-1"

'Abrimos la conexion con la BD
set conn_envios_distri = server.createObject("adodb.connection")
with conn_envios_distri
	'.ConnectionString="Provider=SQLOLEDB.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=sa;"  & _
	'	"Password=;"  & _
	'	"Initial Catalog=DISTRIBUIDORA;"  & _
	'	"Data Source=SERVIDOR2"

	
	'.ConnectionString="Provider=SQLOLEDB.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=sa;"  & _
	'	"Password=PPMCS;"  & _
	'	"Initial Catalog=GLDISTRI;"  & _
	'	"Data Source=SERVERSQL"

	'.ConnectionString="Provider=OraOLEDB.Oracle;" & _
	'	"Data Source=(DESCRIPTION=(CID=GTU_APP)" & _
	'	"(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)" & _
	'	"(HOST=192.168.153.80)(PORT=1713)))" & _
	'	"(CONNECT_DATA=(SID=DHOTELES)(SERVER=DEDICATED)));" & _
	'	"User Id=GLBDIS;Password=glbdes;"


	'CONEXION ENTORNO DESARROLLO
	'.ConnectionString="Provider=MSDAORA.1;" & _
	'	"Persist Security Info=False;"  & _
	'	"User ID=GLBDIS;"  & _
	'	"Password=glbdes;"  & _
	'	"Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.153.80)(PORT=1713))(CONNECT_DATA=(SID=DHOTELES)))"
	

	'CONEXION ENTORNO PRODUCCION
	.ConnectionString="Provider=MSDAORA.1;" & _
		"Persist Security Info=False;"  & _
		"User ID=GLBDIS;"  & _
		"Password=glbdes;"  & _
		"Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.156.201)(PORT=1521))(CONNECT_DATA=(SID=HOTELES)))"
	
	.Open
end with
%>