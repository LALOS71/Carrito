<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	id_articulo = "" & request.QueryString("p_id_articulo")
	entrada_salida = "" & request.QueryString("p_entrada_salida")
	
	ver_cadena="" & Request.QueryString("p_vercadena")
		
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		cadena_sql="SELECT TOP(100) A.ID, A.ID_ARTICULO, A.E_S"
		cadena_sql=cadena_sql & ", CONVERT(char(10), A.FECHA, 103) + ' ' + CONVERT(char(8), A.FECHA, 108) AS FECHA"
		cadena_sql=cadena_sql & ", A.CANTIDAD, A.ALBARAN, A.TIPO, A.FECHA_ALTA, A.PEDIDO"
		cadena_sql=cadena_sql & " , REPLACE(B.DESCRIPCION, '""', '____') AS DESCRIPCION_ART, B.CODIGO_SAP AS REFERENCIA"
		cadena_sql=cadena_sql & " FROM ENTRADAS_SALIDAS_ARTICULOS A INNER JOIN ARTICULOS B"
		cadena_sql=cadena_sql & " ON B.ID=A.ID_ARTICULO"
		cadena_sql=cadena_sql & " WHERE A.E_S = '" & entrada_salida & "'"
		cadena_sql=cadena_sql & " AND A.ID_ARTICULO = " & id_articulo 
		cadena_sql=cadena_sql & " ORDER BY A.FECHA DESC"




		
		
	if ver_cadena="SI" then
		response.write("<br>entradas salidas articulos: " & cadena_sql)
	end if
			
	Set rs = Server.CreateObject("ADODB.recordset")
	rs.Open cadena_sql, connimprenta
	Response.ContentType = "application/json"
	cadena=JSONData(rs, "ROWSET")
	cadena=REPLACE(cadena,"\", "\\")
	cadena=REPLACE(cadena,"____", "\""")
	cadena=REPLACE(cadena, chr(13), "\r\n")
	cadena=REPLACE(cadena, chr(10), "")
	Response.Write "{" & cadena & "}"

	
	connimprenta.close
	set connimprenta=Nothing
%>



