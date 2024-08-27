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
		
		
		
		cadena_sql="SELECT A.ID, A.ID_DEVOLUCION, A.ID_PEDIDO, B.CODIGO_SAP, B.DESCRIPCION"
		cadena_sql= cadena_sql & ", A.CANTIDAD, A.TOTAL, A.ALBARAN, A.IDALBARANDETALLES"
		cadena_sql= cadena_sql & ", ISNULL(A.UNIDADES_ACEPTADAS,0) AS UNIDADES_ACEPTADAS"
		cadena_sql= cadena_sql & ", ISNULL(A.UNIDADES_RECHAZADAS,0) AS UNIDADES_RECHAZADAS"
		cadena_sql= cadena_sql & ", (A.CANTIDAD - ISNULL(A.UNIDADES_ACEPTADAS ,0) - ISNULL(A.UNIDADES_RECHAZADAS,0)) AS UNIDADES_PENDIENTES"
		cadena_sql= cadena_sql & ", ROUND((A.TOTAL/A.CANTIDAD) * ISNULL(A.UNIDADES_ACEPTADAS,0),2) AS IMPORTE_ACEPTADO"

		cadena_sql= cadena_sql & " FROM DEVOLUCIONES_DETALLES A"
		cadena_sql= cadena_sql & " INNER JOIN ARTICULOS B"
		cadena_sql= cadena_sql & " ON A.ID_ARTICULO=B.ID"
		cadena_sql= cadena_sql & " WHERE A.ID_DEVOLUCION=" & devolucion_seleccionada

			
	if ver_cadena="SI" then
		'response.write("<br>empresa: " & empresa_seleccionada)
		'response.write("<br>cliente: " & cliente_seleccionado)
		'response.write("<br>estado: " & estado_seleccionado)
		'response.write("<br>numero pedido: " & numero_pedido_seleccionado)
		'response.write("<br>fecha_inicio: " & fecha_i_seleccionada)
		'response.write("<br>fecha fin: " & fecha_f_seleccionada)
		'response.write("<br>pedido automatico: " & pedido_automatico_seleccionado)
	
		response.write("<br>consulta pedidos: " & cadena_sql)
	end if
	
	Set rs = Server.CreateObject("ADODB.recordset")
	
	'porque el sql de produccion es un sql expres que debe tener el formato de
	' de fecha con mes-dia-año, y al lanzar consultas con fechas da error o
	' da resultados raros
	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	
	rs.Open cadena_sql, connimprenta
	Response.ContentType = "application/json"
	cadena_detalles_devolucion=JSONData(rs, "ROWSET")
	cadena_detalles_devolucion=REPLACE(cadena_detalles_devolucion,"\", "\\")
	cadena_detalles_devolucion=REPLACE(cadena_detalles_devolucion, chr(13), "\r\n")
	cadena_detalles_devolucion=REPLACE(cadena_detalles_devolucion, chr(10), "")
	Response.Write "{" & cadena_detalles_devolucion & "}"



	
	connimprenta.close
	set connimprenta=Nothing
%>



