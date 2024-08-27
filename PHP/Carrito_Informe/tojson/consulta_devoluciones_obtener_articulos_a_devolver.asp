<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	usuario = "" & request.QueryString("p_usuario")
	usuario_directorio_activo = "" & request.QueryString("p_usuario_directorio_activo")
	
	
	ver_cadena= "" & request.QueryString("p_vercadena")
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		
		cadena_sql= "SELECT TABLA_1.CLIENTE, TABLA_1.ID_ARTICULO, TABLA_1.CODIGO_SAP, TABLA_1.DESCRIPCION"
		cadena_sql= cadena_sql & ", TABLA_1.PEDIDO, TABLA_1.CANTIDAD, TABLA_1.IMPORTE, TABLA_1.ALBARAN, TABLA_2.ALBARAN AS ALBARAN_YA_PEDIDO"
		cadena_sql= cadena_sql & ", TABLA_1.FECHA_PEDIDO, TABLA_1.FECHA_ALBARAN, TABLA_1.PRECIO_UNIDAD, TABLA_1.IDALBARANDETALLES"
		cadena_sql= cadena_sql & ", TABLA_2.YA_DEVUELTOS, TABLA_1.CANTIDAD - ISNULL(TABLA_2.YA_DEVUELTOS,0) AS CANTIDAD_DISPONIBLE"
		cadena_sql= cadena_sql & ", TABLA_1.USUARIO_DIRECTORIO_ACTIVO"

		cadena_sql= cadena_sql & " FROM ("

		cadena_sql= cadena_sql & "SELECT B.CODCLI AS CLIENTE, A.ID_ARTICULO, C.CODIGO_SAP, REPLACE(C.DESCRIPCION, '""', '____') as DESCRIPCION"
		cadena_sql= cadena_sql & ", A.ID_PEDIDO AS PEDIDO"
		cadena_sql= cadena_sql & ", E.CANTIDAD, E.IMPORTE"
		cadena_sql= cadena_sql & ", A.ALBARAN"
		cadena_sql= cadena_sql & ", B.FECHA AS FECHA_PEDIDO"
		cadena_sql= cadena_sql & ", D.FECHA AS FECHA_ALBARAN"
		cadena_sql= cadena_sql & ", ROUND(E.IMPORTE/E.CANTIDAD,2) AS PRECIO_UNIDAD"
		cadena_sql= cadena_sql & ", E.IDALBARANDETALLES, B.USUARIO_DIRECTORIO_ACTIVO"

		cadena_sql= cadena_sql & " FROM PEDIDOS_ENVIOS_PARCIALES A"
		cadena_sql= cadena_sql & " INNER JOIN PEDIDOS B"
		cadena_sql= cadena_sql & " ON A.ID_PEDIDO=B.ID"
		cadena_sql= cadena_sql & " INNER JOIN ARTICULOS C"
		cadena_sql= cadena_sql & " ON A.ID_ARTICULO=C.ID"
		cadena_sql= cadena_sql & " INNER JOIN V_DATOS_ALBARANES D"
		cadena_sql= cadena_sql & " ON A.ALBARAN=D.IDALBARAN"
		cadena_sql= cadena_sql & " INNER JOIN V_DATOS_ALBARANES_DETALLES E"
		'cadena_sql= cadena_sql & " ON E.IDALBARAN=A.ALBARAN AND E.CONCEPTO= (C.CODIGO_SAP + '    ' + C.DESCRIPCION)"
		cadena_sql= cadena_sql & " ON E.IDALBARAN=A.ALBARAN AND RTRIM(LEFT(E.CONCEPTO, CHARINDEX('    ', E.CONCEPTO)))= C.CODIGO_SAP"
		
		
		cadena_sql= cadena_sql & " WHERE B.CODCLI="  & usuario
		cadena_sql= cadena_sql & " AND C.PERMITE_DEVOLUCION='SI'"
		cadena_sql= cadena_sql & " AND CONVERT(VARCHAR(8), GETDATE(), 112) <= CONVERT(VARCHAR(8), DATEADD(day, 30, D.FECHA), 112)" 'convierte las fechas a formato yyyymmdd

		cadena_sql= cadena_sql & " UNION"
		
		cadena_sql= cadena_sql & " SELECT C.CODCLI AS CLIENTE, A.ARTICULO AS ID_ARTICULO, D.CODIGO_SAP, REPLACE(D.DESCRIPCION, '""', '____') AS DESCRIPCION"
		cadena_sql= cadena_sql & ", A.ID_PEDIDO AS PEDIDO, A.CANTIDAD, A.TOTAL AS IMPORTE, A.ALBARAN"
		cadena_sql= cadena_sql & ", C.FECHA AS FECHA_PEDIDO"
		cadena_sql= cadena_sql & ", E.FECHA AS FECHA_ALBARAN"
		cadena_sql= cadena_sql & ", ROUND(A.TOTAL/A.CANTIDAD,2) AS PRECIO_UNIDAD"
		cadena_sql= cadena_sql & ", F.IDALBARANDETALLES, C.USUARIO_DIRECTORIO_ACTIVO"
		

		cadena_sql= cadena_sql & " FROM PEDIDOS_DETALLES A"
		cadena_sql= cadena_sql & " LEFT JOIN PEDIDOS_ENVIOS_PARCIALES B"
		cadena_sql= cadena_sql & " ON A.ID_PEDIDO=B.ID_PEDIDO AND A.ARTICULO=B.ID_ARTICULO"
		cadena_sql= cadena_sql & " INNER JOIN PEDIDOS C"
		cadena_sql= cadena_sql & " ON A.ID_PEDIDO=C.ID"
		cadena_sql= cadena_sql & " INNER JOIN ARTICULOS D"
		cadena_sql= cadena_sql & " ON A.ARTICULO=D.ID"
		cadena_sql= cadena_sql & " INNER JOIN V_DATOS_ALBARANES E"
		cadena_sql= cadena_sql & " ON A.ALBARAN=E.IDALBARAN"
		cadena_sql= cadena_sql & " INNER JOIN V_DATOS_ALBARANES_DETALLES F"
		'cadena_sql= cadena_sql & " ON F.IDALBARAN=A.ALBARAN AND F.CONCEPTO= (D.CODIGO_SAP + '    ' + D.DESCRIPCION)"
		cadena_sql= cadena_sql & " ON F.IDALBARAN=A.ALBARAN AND RTRIM(LEFT(F.CONCEPTO, CHARINDEX('    ', F.CONCEPTO))) = D.CODIGO_SAP"
 
		cadena_sql= cadena_sql & " WHERE C.CODCLI="  & usuario
		cadena_sql= cadena_sql & " AND B.ID_PEDIDO IS NULL"
		cadena_sql= cadena_sql & " AND A.ESTADO='ENVIADO'"
		cadena_sql= cadena_sql & " AND D.PERMITE_DEVOLUCION='SI'"
		cadena_sql= cadena_sql & " AND CONVERT(VARCHAR(8), GETDATE(), 112) <= CONVERT(VARCHAR(8), DATEADD(day, 30, E.FECHA), 112)" 'convierte las fechas a formato yyyymmdd
		cadena_sql= cadena_sql & ") TABLA_1"

		cadena_sql= cadena_sql & " LEFT JOIN ("

		cadena_sql= cadena_sql & "SELECT ID_PEDIDO, ID_ARTICULO, SUM(CANTIDAD) AS YA_DEVUELTOS, ALBARAN FROM DEVOLUCIONES_DETALLES"
		cadena_sql= cadena_sql & " GROUP BY ID_PEDIDO, ALBARAN, ID_ARTICULO) TABLA_2"
		
		cadena_sql= cadena_sql & " ON TABLA_1.PEDIDO=TABLA_2.ID_PEDIDO AND TABLA_1.ALBARAN=TABLA_2.ALBARAN AND TABLA_1.ID_ARTICULO=TABLA_2.ID_ARTICULO"

		cadena_sql= cadena_sql & " WHERE (TABLA_1.CANTIDAD - ISNULL(TABLA_2.YA_DEVUELTOS,0))>0"
		if usuario_directorio_activo="" then
				cadena_sql= cadena_sql & " AND TABLA_1.USUARIO_DIRECTORIO_ACTIVO IS NULL"
			else
				cadena_sql= cadena_sql & " AND TABLA_1.USUARIO_DIRECTORIO_ACTIVO=" & usuario_directorio_activo
		end if
		
		cadena_sql= cadena_sql & " ORDER BY TABLA_1.FECHA_ALBARAN, TABLA_1.ALBARAN, TABLA_1.PEDIDO"


		
			
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
	cadena_articulos_devoluciones=JSONData(rs, "ROWSET")
	cadena_articulos_devoluciones=REPLACE(cadena_articulos_devoluciones,"\", "\\")
	cadena_articulos_devoluciones=REPLACE(cadena_articulos_devoluciones,"____", "\""")
	cadena_articulos_devoluciones=REPLACE(cadena_articulos_devoluciones, chr(13), "\r\n")
	cadena_articulos_devoluciones=REPLACE(cadena_articulos_devoluciones, chr(10), "")
	Response.Write "{" & cadena_articulos_devoluciones & "}"



	
	connimprenta.close
	set connimprenta=Nothing
%>



