<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	id_articulo = "" & request.QueryString("p_id_articulo")
	entrada_salida = "" & request.QueryString("p_entrada_salida")
	
		
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		cadena_sql="SELECT ID, ID_ARTICULO, E_S, FECHA, CANTIDAD, ALBARAN, TIPO, FECHA_ALTA"
		cadena_sql=cadena_sql & " , (SELECT DESCRIPCION FROM ARTICULOS"
		cadena_sql=cadena_sql & " WHERE (ID = a.ID_ARTICULO)) AS Descripcion_art"
		cadena_sql=cadena_sql & " , (SELECT CODIGO_SAP FROM ARTICULOS"
		cadena_sql=cadena_sql & " WHERE (ID = a.ID_ARTICULO)) AS Referencia"
		cadena_sql=cadena_sql & " FROM ENTRADAS_SALIDAS_ARTICULOS AS a"
		cadena_sql=cadena_sql & " WHERE E_S = '" & entrada_salida & "'"
		cadena_sql=cadena_sql & " AND ID_ARTICULO = " & id_articulo 
		cadena_sql=cadena_sql & " ORDER BY FECHA DESC"


		
		
			'response.write("<br>" & cadena_sql)
			
	Set rs = Server.CreateObject("ADODB.recordset")
	rs.Open cadena_sql, connimprenta
	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(rs, "ROWSET") & "}"



	
	connimprenta.close
	set connimprenta=Nothing
%>



