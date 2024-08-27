<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	id_articulo = "" & request.QueryString("p_id_articulo")
	id_cliente = "" & request.QueryString("p_id_cliente")
	fecha_i = "" & request.QueryString("p_fecha_i")
	fecha_f = "" & request.QueryString("p_fecha_f")
	
	diferenciar_articulos = "" & request.QueryString("p_diferenciar_articulos")
	diferenciar_sucursales = "" & request.QueryString("p_diferenciar_sucursales")
	diferenciar_tipo = "" & request.QueryString("p_diferenciar_tipo")
	
	
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
		
	
		
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		
		
		
		'cadena_sql="SELECT ARTICULOS.ID, ARTICULOS.CODIGO_SAP, REPLACE(ARTICULOS.DESCRIPCION, '""', '\""') AS DESCRIPCION"
		cadena_sql="SELECT ARTICULOS.NOMBRE_EMPRESA"
		if diferenciar_articulos = "SI" then
			cadena_sql = cadena_sql & ", ARTICULOS.ID_ARTICULO, ARTICULOS.CODIGO_SAP, ARTICULOS.ARTICULO, ARTICULOS.UNIDADES_DE_PEDIDO"
		  else
		  	cadena_sql = cadena_sql & ", NULL AS ID_ARTICULO, NULL AS CODIGO_SAP, NULL AS ARTICULO, NULL AS UNIDADES_DE_PEDIDO"
		end if
		
		if diferenciar_sucursales ="SI" then
			cadena_sql = cadena_sql & ", ARTICULOS.CODCLIENTE, ARTICULOS.NOMBRE, ARTICULOS.CODIGO_EXTERNO"
		  else
		  	cadena_sql = cadena_sql & ", NULL AS CODCLIENTE, NULL AS NOMBRE, NULL AS CODIGO_EXTERNO"
		end if
		
		if diferenciar_tipo = "SI" then
			cadena_sql = cadena_sql & ", ARTICULOS.TIPO"
		  else
		  	cadena_sql = cadena_sql & ", NULL AS TIPO"
		end if
		
		cadena_sql = cadena_sql & ", ARTICULOS.CANTIDAD_TOTAL, ARTICULOS.TOTAL_IMPORTE" 
		  
		cadena_sql = cadena_sql & ", DEVOLUCIONES.UNIDADES_DEVUELTAS, DEVOLUCIONES.TOTAL_DEVOLUCIONES AS TOTAL_IMPORTE_DEVOLUCIONES"
		'cadena_sql = cadena_sql & ", ROUND(CASE WHEN ARTICULOS.TOTAL_IMPORTE=0 THEN 0 ELSE (DEVOLUCIONES.UNIDADES_DEVUELTAS * (ARTICULOS.TOTAL_IMPORTE/ARTICULOS.CANTIDAD_TOTAL)) END, 2)"
		'cadena_sql = cadena_sql & " AS TOTAL_IMPORTE_DEVOLUCIONES"

		cadena_sql = cadena_sql & " FROM (SELECT F.EMPRESA AS NOMBRE_EMPRESA"
		if diferenciar_articulos = "SI" then
			cadena_sql = cadena_sql & ", A.ID AS ID_ARTICULO , A.CODIGO_SAP as CODIGO_SAP, REPLACE(A.DESCRIPCION, '""', '\""') as ARTICULO, A.UNIDADES_DE_PEDIDO"
		end if
		', A.RAPPEL, A.VALOR_RAPPEL, A.PRECIO_COSTE, (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=A.PROVEEDOR) AS PROVEEDOR, A.REFERENCIA_DEL_PROVEEDOR"
		
		if diferenciar_sucursales ="SI" then
			cadena_sql = cadena_sql & ", E.ID AS CODCLIENTE, E.NOMBRE, E.CODIGO_EXTERNO"
		end if
		if diferenciar_tipo = "SI" then
			cadena_sql = cadena_sql & ", E.TIPO"
		end if
		
		cadena_sql = cadena_sql & ", SUM(B.CANTIDAD) as CANTIDAD_TOTAL"
		cadena_sql = cadena_sql & ", ROUND(SUM(CASE WHEN D.TOTAL=0 THEN 0 ELSE (B.CANTIDAD * (D.TOTAL/D.CANTIDAD)) END), 2) AS TOTAL_IMPORTE"
		cadena_sql = cadena_sql & " FROM ARTICULOS A INNER JOIN ENTRADAS_SALIDAS_ARTICULOS B ON A.ID=B.ID_ARTICULO AND B.E_S='SALIDA' AND B.TIPO='PEDIDO'"
		cadena_sql = cadena_sql & " INNER JOIN PEDIDOS C ON C.ID = B.PEDIDO"
		cadena_sql = cadena_sql & " INNER JOIN PEDIDOS_DETALLES D ON C.ID=D.ID_PEDIDO AND A.ID=D.ARTICULO"
		cadena_sql = cadena_sql & " INNER JOIN V_CLIENTES E ON C.CODCLI = E.Id"
		cadena_sql = cadena_sql & " INNER JOIN V_EMPRESAS F ON E.EMPRESA = F.Id"
		cadena_sql = cadena_sql & " WHERE 1=1"
		cadena_sql = cadena_sql & " AND F.ID=4" 'SOLO PARA GLS
		if id_articulo<>"" then
			cadena_sql = cadena_sql & " AND (A.ID = " & id_articulo & ")"
		end if
		if id_cliente<>"" then
			cadena_sql = cadena_sql & " AND (E.ID = " & id_cliente & ")"
		end if
		if fecha_i<>"" then
			cadena_sql = cadena_sql & " AND (CONVERT(VARCHAR(8), B.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & cdate(fecha_i) & "', 103) , 112))"
		end if
		if fecha_f<>"" then
			cadena_sql = cadena_sql & " AND (CONVERT(VARCHAR(8), B.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & cdate(fecha_f) & "', 103) , 112))"
		end if
		
		cadena_sql = cadena_sql & " GROUP BY F.EMPRESA"
		if diferenciar_articulos = "SI" then
			cadena_sql = cadena_sql & ", A.ID, A.CODIGO_SAP, A.DESCRIPCION, A.UNIDADES_DE_PEDIDO"
		end if
		
		if diferenciar_sucursales = "SI" then
			cadena_sql = cadena_sql & ", E.ID, E.NOMBRE, E.CODIGO_EXTERNO"
		end if
		if diferenciar_tipo = "SI" then
			cadena_sql = cadena_sql & ", E.TIPO"
		end if
		
		cadena_sql = cadena_sql & ") ARTICULOS"
		
		cadena_sql = cadena_sql & " LEFT JOIN (SELECT V.EMPRESA"

		if diferenciar_articulos = "SI" then
			cadena_sql = cadena_sql & ", Z.ID_ARTICULO"
		end if

		if diferenciar_sucursales ="SI" then
			cadena_sql = cadena_sql & ", W.ID AS CODCLIENTE"
		end if
		if diferenciar_tipo = "SI" then
			cadena_sql = cadena_sql & ", W.TIPO"
		end if
		
		cadena_sql = cadena_sql & ", SUM(UNIDADES_ACEPTADAS) AS UNIDADES_DEVUELTAS"
		cadena_sql = cadena_sql & ", SUM(ROUND((UNIDADES_ACEPTADAS * (T.TOTAL/T.CANTIDAD)),2)) AS TOTAL_DEVOLUCIONES"
		cadena_sql = cadena_sql & " FROM DEVOLUCIONES_DETALLES Z"
		cadena_sql = cadena_sql & " INNER JOIN (SELECT ID_ARTICULO, PEDIDO, E_S, TIPO, MIN(FECHA) AS FECHA"
		cadena_sql = cadena_sql & " FROM ENTRADAS_SALIDAS_ARTICULOS GROUP BY PEDIDO, ID_ARTICULO, E_S, TIPO) Y"
		cadena_sql = cadena_sql & " ON Z.ID_ARTICULO=Y.ID_ARTICULO AND Z.ID_PEDIDO=Y.PEDIDO AND Z.UNIDADES_ACEPTADAS>=1 AND Y.E_S='SALIDA' AND Y.TIPO='PEDIDO'"
		cadena_sql = cadena_sql & " LEFT JOIN PEDIDOS X ON X.ID=Z.ID_PEDIDO"
		cadena_sql = cadena_sql & " LEFT JOIN V_CLIENTES W ON W.ID=X.CODCLI"
		cadena_sql = cadena_sql & " LEFT JOIN V_EMPRESAS V ON V.ID=W.EMPRESA"
		cadena_sql = cadena_sql & " LEFT JOIN PEDIDOS_DETALLES T ON Z.ID_PEDIDO=T.ID_PEDIDO AND Z.ID_ARTICULO=T.ARTICULO"
		
		cadena_sql = cadena_sql & " WHERE Z.UNIDADES_ACEPTADAS>=1"
		cadena_sql = cadena_sql & " AND W.EMPRESA=4"
		if id_articulo<>"" then
			cadena_sql = cadena_sql & " AND Z.ID_ARTICULO=" & id_articulo
		end if
		if id_cliente<>"" then
			cadena_sql = cadena_sql & " AND W.ID = " & id_cliente 
		end if
		if fecha_i<>"" then
			cadena_sql = cadena_sql & " AND (CONVERT(VARCHAR(8), Y.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & cdate(fecha_i) & "', 103) , 112))"
		end if
		if fecha_f<>"" then
			cadena_sql = cadena_sql & " AND (CONVERT(VARCHAR(8), Y.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & cdate(fecha_f) & "', 103) , 112))"
		end if
		cadena_sql = cadena_sql & " GROUP BY V.EMPRESA"
		
		if diferenciar_articulos= "SI" then
			cadena_sql = cadena_sql & ", Z.ID_ARTICULO"
		end if 
		
		if diferenciar_sucursales = "SI" then
			cadena_sql = cadena_sql & ", W.ID"
		end if
		if diferenciar_tipo = "SI" then
			cadena_sql = cadena_sql & ", W.TIPO"
		end if
		
		cadena_sql = cadena_sql & " ) DEVOLUCIONES ON ARTICULOS.NOMBRE_EMPRESA=DEVOLUCIONES.EMPRESA"
		if diferenciar_articulos = "SI" then
			cadena_sql = cadena_sql & " AND ARTICULOS.ID_ARTICULO=DEVOLUCIONES.ID_ARTICULO"
		end if

		if diferenciar_sucursales = "SI" then
			cadena_sql = cadena_sql & " AND ARTICULOS.CODCLIENTE=DEVOLUCIONES.CODCLIENTE"
		end if
		if diferenciar_tipo = "SI" then
			cadena_sql = cadena_sql & " AND ARTICULOS.TIPO=DEVOLUCIONES.TIPO"
		end if


		cadena_sql = cadena_sql & " ORDER BY ARTICULOS.NOMBRE_EMPRESA"
		if diferenciar_articulos = "SI" then
			cadena_sql = cadena_sql & ", ARTICULOS.ARTICULO"
		end if 
		
		
		if diferenciar_sucursales = "SI" then
			cadena_sql = cadena_sql & ", ARTICULOS.NOMBRE"
		end if
		if diferenciar_tipo = "SI" then
			cadena_sql = cadena_sql & ", ARTICULOS.TIPO"
		end if	

		
			
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
	cadena_devoluciones=JSONData(rs, "ROWSET")
	cadena_devoluciones=REPLACE(cadena_devoluciones,"\", "\\")
	cadena_devoluciones=REPLACE(cadena_devoluciones, chr(13), "\r\n")
	cadena_devoluciones=REPLACE(cadena_devoluciones, chr(10), "")
	Response.Write "{" & cadena_devoluciones & "}"



	
	connimprenta.close
	set connimprenta=Nothing
%>



