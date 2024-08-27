<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	empresa_seleccionada = "" & request.QueryString("p_empresa")
	cliente_seleccionado="" & request.QueryString("p_cliente")
	estado_seleccionado = "" & request.QueryString("p_estado")
	if estado_seleccionado<>"" then
		estado_seleccionado=replace(estado_seleccionado, ",", "', '")
	end if
	numero_devolucion_seleccionada = "" & request.QueryString("p_numero_devolucion")
	fecha_i_seleccionada = "" & request.QueryString("p_fecha_i")
	fecha_f_seleccionada = "" & request.QueryString("p_fecha_f")
	articulo_seleccionado= "" & request.QueryString("p_articulo")
	
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
		
	
		
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		
		
		cadena_sql="SELECT DEVOLUCIONES.ID, DEVOLUCIONES.CODCLI, V_EMPRESAS.EMPRESA, V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
		cadena_sql= cadena_sql & ", CONVERT(VARCHAR(10), DEVOLUCIONES.FECHA, 103) FECHA, DEVOLUCIONES.ESTADO"
		cadena_sql= cadena_sql & ", (SELECT ROUND(SUM(TOTAL),2)  FROM DEVOLUCIONES_DETALLES WHERE ID_DEVOLUCION=DEVOLUCIONES.ID) AS TOTAL"
		cadena_sql= cadena_sql & ", (SELECT ROUND(SUM(TOTAL/CANTIDAD * UNIDADES_ACEPTADAS),2) FROM DEVOLUCIONES_DETALLES WHERE ID_DEVOLUCION=DEVOLUCIONES.ID) AS TOTAL_ACEPTADO"
		cadena_sql= cadena_sql & ", V_EMPRESAS.ID AS EMPRESA_ID"
		cadena_sql= cadena_sql & ", DEVOLUCIONES.USUARIO_DIRECTORIO_ACTIVO"
		cadena_sql= cadena_sql & ", ISNULL(EMPLEADOS_GLS.NOMBRE,'') + ' ' + ISNULL(EMPLEADOS_GLS.APELLIDOS,'') AS NOMBRE_EMPLEADO"

		cadena_sql= cadena_sql & " FROM DEVOLUCIONES"
		cadena_sql= cadena_sql & " INNER JOIN V_CLIENTES"
		cadena_sql= cadena_sql & " ON DEVOLUCIONES.CODCLI = V_CLIENTES.ID"
		cadena_sql= cadena_sql & " INNER JOIN V_EMPRESAS"
		cadena_sql= cadena_sql & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.ID"
		cadena_sql= cadena_sql & " LEFT JOIN EMPLEADOS_GLS"
		cadena_sql= cadena_sql & " ON DEVOLUCIONES.USUARIO_DIRECTORIO_ACTIVO=EMPLEADOS_GLS.ID"
		
				
		'cadena_sql="SELECT PEDIDOS.ID Id, PEDIDOS.CODCLI, V_EMPRESAS.EMPRESA, V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO, PEDIDOS.PEDIDO,"
		'cadena_sql= cadena_sql & " CONVERT(VARCHAR(10), PEDIDOS.FECHA, 103) FECHA, PEDIDOS.ESTADO, V_EMPRESAS.ID AS EMPRESA_ID, V_CLIENTES.TIPO as TIPO_CLIENTE, V_CLIENTES.REQUIERE_AUTORIZACION," 
		'cadena_sql= cadena_sql & " PEDIDOS.PEDIDO_AUTOMATICO, isnull(PEDIDOS.GASTOS_ENVIO, 0) GASTOS_ENVIO,"
		'cadena_sql= cadena_sql & " Total * 0.21 TotIva_ANT, Total+(Total * 0.21) TotalEnvio_ANT, isnull(Nreg,0) Nreg_aNT,"
       
		'cadena_sql= cadena_sql & " ((Total + isnull(PEDIDOS.GASTOS_ENVIO, 0)) * 0.21) TotIva, (Total + isnull(PEDIDOS.GASTOS_ENVIO, 0) + ((Total + isnull(PEDIDOS.GASTOS_ENVIO, 0)) * 0.21)) TotalEnvio, isnull(Nreg,0) Nreg"
        'cadena_sql= cadena_sql & " , (select count(*) from pedidos_detalles INNER JOIN ARTICULOS ON PEDIDOS_DETALLES.ARTICULO=ARTICULOS.ID where id_pedido=PEDIDOS.ID AND ARTICULOS.COMPROMISO_COMPRA='NO') AS COMPROMISO_COMPRA_NO"
		'cadena_sql= cadena_sql & " , (select count(*) from pedidos_detalles INNER JOIN ARTICULOS ON PEDIDOS_DETALLES.ARTICULO=ARTICULOS.ID where id_pedido=PEDIDOS.ID AND ARTICULOS.REQUIERE_HOJA_RUTA='SI') AS HOJA_RUTA_SI"
		'cadena_sql= cadena_sql & " , (SELECT TOP 1 OBSERVACIONES FROM PEDIDOS_OBSERVACIONES WHERE PEDIDO=PEDIDOS.ID ORDER BY FECHA DESC) AS OBSERVACIONES"	

		'cadena_sql= cadena_sql & " FROM PEDIDOS INNER JOIN V_CLIENTES"
		'cadena_sql= cadena_sql & " ON PEDIDOS.CODCLI = V_CLIENTES.Id"
		'cadena_sql= cadena_sql & " INNER JOIN V_EMPRESAS"
		'cadena_sql= cadena_sql & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
        'cadena_sql= cadena_sql & " LEFT JOIN (SELECT ID_Pedido, sum(total) Total, Sum(1) NReg FROM  Pedidos_Detalles where estado<>'ANULADO'  GROUP BY ID_Pedido ) Tot 	ON PEDIDOS.ID = Tot.ID_Pedido "
		
		cadena_sql= cadena_sql & " WHERE 1=1"
		
		
		'solo filtra por empresa cuando se pone solo la empresa, 
		'si se selecciona el cliente, ya no filtra por empresa para
		'que puedan salir tambien los pedidos asociados a este cliente que son de otro cliente y de diferente empresa
		' por ejemplo las oficinas de halcon que generan pedidos para otros clientes no de halcon, sino de la empresa/cadena MALETAS GLOBALBAG
		if empresa_seleccionada<>"" and cliente_seleccionado=""  then
			cadena_sql= cadena_sql & " AND V_EMPRESAS.ID=" & empresa_seleccionada 
		end if
		if estado_seleccionado<>"" then
			'cadena_sql= cadena_sql & " AND PEDIDOS.ESTADO='" & estado_seleccionado & "'"
			if articulo_seleccionado="" then
				cadena_sql= cadena_sql & " AND DEVOLUCIONES.ESTADO IN ('" & estado_seleccionado & "')"
			end if
		end if
		if cliente_seleccionado<>"" then
			cadena_sql= cadena_sql & " AND DEVOLUCIONES.CODCLI=" & cliente_seleccionado
		end if
		if numero_devolucion_seleccionada<>"" then
			cadena_sql= cadena_sql & " AND DEVOLUCIONES.ID=" & numero_devolucion_seleccionada
		end if
	
		if fecha_i_seleccionada<>"" then
			cadena_sql= cadena_sql & " AND (CONVERT(VARCHAR(10), DEVOLUCIONES.FECHA, 103) >= CONVERT(VARCHAR(10), '" & cdate(fecha_i_seleccionada) & "', 103))" 
		end if
		if fecha_f_seleccionada<>"" then
			cadena_sql= cadena_sql & " AND (CONVERT(VARCHAR(10), DEVOLUCIONES.FECHA, 103) <= CONVERT(VARCHAR(10), '" & cdate(fecha_f_seleccionada) & "', 103))" 
		end if
		
		
		if articulo_seleccionado<>"" then
			cadena_sql= cadena_sql & " AND (SELECT TOP(1) ID_ARTICULO FROM DEVOLUCIONES_DETALLES WHERE ID_DEVOLUCION=DEVOLUCIONES.ID AND ID_ARTICULO=" & articulo_seleccionado
			if estado_seleccionado<>"" then
				'cadena_sql= cadena_sql & " AND PEDIDOS.ESTADO='" & estado_seleccionado & "'"
				cadena_sql= cadena_sql & " AND DEVOLUCIONES_DETALLES.ESTADO IN ('" & estado_seleccionado & "')"
			end if
			cadena_sql= cadena_sql & ")=" & articulo_seleccionado
		end if
		
		
		if estado_seleccionado="" and cliente_seleccionado="" and empresa_seleccionada="" and numero_devolucion_seleccionada="" and articulo_seleccionado="" and fecha_i_seleccionada="" and fecha_f_seleccionada="" then
			cadena_sql= cadena_sql & " AND DEVOLUCIONES.ESTADO='SIN TRATAR'"
		end if
		
			
		cadena_sql= cadena_sql & " ORDER BY DEVOLUCIONES.FECHA DESC, DEVOLUCIONES.CODCLI, DEVOLUCIONES.ID"
		
			
	if ver_cadena="SI" then
		response.write("<br>empresa: " & empresa_seleccionada)
		response.write("<br>cliente: " & cliente_seleccionado)
		response.write("<br>estado: " & estado_seleccionado)
		response.write("<br>numero devolucion: " & numero_devolucion_seleccionado)
		response.write("<br>fecha_inicio: " & fecha_i_seleccionada)
		response.write("<br>fecha fin: " & fecha_f_seleccionada)
	
		response.write("<br>consulta pedidos: " & cadena_sql)
	end if
	
	Set rs = Server.CreateObject("ADODB.recordset")
	
	'porque el sql de produccion es un sql expres que debe tener el formato de
	' de fecha con mes-dia-año, y al lanzar consultas con fechas da error o
	' da resultados raros
	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	
	rs.Open cadena_sql, connimprenta
	Response.ContentType = "application/json"
	cadena_pirs=JSONData(rs, "ROWSET")
	cadena_pirs=REPLACE(cadena_pirs,"\", "\\")
	cadena_pirs=REPLACE(cadena_pirs, chr(13), "\r\n")
	cadena_pirs=REPLACE(cadena_pirs, chr(10), "")
	Response.Write "{" & cadena_pirs & "}"



	
	connimprenta.close
	set connimprenta=Nothing
%>



