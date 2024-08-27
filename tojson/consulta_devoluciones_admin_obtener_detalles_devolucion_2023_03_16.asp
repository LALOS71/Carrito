<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	devolucion_seleccionada = "" & request.QueryString("p_id_devolucion")
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
		
	
		
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		

		
		
		cadena_sql="SELECT B.CODIGO_SAP AS REFERENCIA, B.DESCRIPCION, A.CANTIDAD, A.TOTAL, A.ID_PEDIDO AS PEDIDO, A.ALBARAN, A.ID AS ID_DETALLE_DEVOLUCION, A.ID_DEVOLUCION"
		cadena_sql= cadena_sql & ", IsNull(A.UNIDADES_ACEPTADAS,0) as UNIDADES_ACEPTADAS"
		cadena_sql= cadena_sql & ", IsNull(A.UNIDADES_RECHAZADAS,0) as UNIDADES_RECHAZADAS"
		cadena_sql= cadena_sql & ", (A.CANTIDAD - IsNull(A.UNIDADES_ACEPTADAS,0) - IsNull(A.UNIDADES_RECHAZADAS,0)) AS UNIDADES_PENDIENTES"
		cadena_sql= cadena_sql & ", A.ID_ARTICULO"
		cadena_sql= cadena_sql & " FROM DEVOLUCIONES_DETALLES A"
		cadena_sql= cadena_sql & " INNER JOIN ARTICULOS B"
		cadena_sql= cadena_sql & " ON A.ID_ARTICULO=B.ID"

		cadena_sql= cadena_sql & " WHERE A.ID_DEVOLUCION = " & devolucion_seleccionada
		
 
	if ver_cadena="SI" then
	
		response.write("<br>consulta pedidos: " & cadena_sql)
	end if
	
	Set rs = Server.CreateObject("ADODB.recordset")
	
	'porque el sql de produccion es un sql expres que debe tener el formato de
	' de fecha con mes-dia-año, y al lanzar consultas con fechas da error o
	' da resultados raros
	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	
	rs.Open cadena_sql, connimprenta
	Response.ContentType = "application/json"
	cadena_resultado=JSONData(rs, "ROWSET")
	cadena_resultado=REPLACE(cadena_resultado,"\", "\\")
	cadena_resultado=REPLACE(cadena_resultado, chr(13), "\r\n")
	cadena_resultado=REPLACE(cadena_resultado, chr(10), "")
	Response.Write "{" & cadena_resultado & "}"



	
	connimprenta.close
	set connimprenta=Nothing
%>



