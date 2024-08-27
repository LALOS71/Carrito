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
	numero_pedido_seleccionado = "" & request.QueryString("p_numero_pedido")
	fecha_i_seleccionada = "" & request.QueryString("p_fecha_i")
	fecha_f_seleccionada = "" & request.QueryString("p_fecha_f")
	pedido_automatico_seleccionado = "" & request.QueryString("p_pedido_automatico")
	articulo_seleccionado= "" & request.QueryString("p_articulo")
	hoja_ruta_seleccionada= "" & request.QueryString("p_hoja_ruta")
	
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
		
	
		
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		
		
		
		
		cadena_sql="SELECT PEDIDOS.ID Id, PEDIDOS.CODCLI, V_EMPRESAS.EMPRESA, V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO, PEDIDOS.PEDIDO,"
		cadena_sql= cadena_sql & " CONVERT(VARCHAR(10), PEDIDOS.FECHA, 103) FECHA, PEDIDOS.ESTADO, V_EMPRESAS.ID AS EMPRESA_ID, V_CLIENTES.TIPO as TIPO_CLIENTE, V_CLIENTES.REQUIERE_AUTORIZACION," 
		cadena_sql= cadena_sql & " PEDIDOS.PEDIDO_AUTOMATICO, isnull(PEDIDOS.GASTOS_ENVIO, 0) GASTOS_ENVIO"
		'cadena_sql= cadena_sql & ", Total * 0.21 TotIva_ANT, Total+(Total * 0.21) TotalEnvio_ANT, isnull(Nreg,0) Nreg_aNT"
       	'cadena_sql= cadena_sql & ", ((Total + isnull(PEDIDOS.GASTOS_ENVIO, 0)) * 0.21) TotIva, (Total + isnull(PEDIDOS.GASTOS_ENVIO, 0) + ((Total + isnull(PEDIDOS.GASTOS_ENVIO, 0)) * 0.21)) TotalEnvio"
		cadena_sql= cadena_sql & ", isnull(Nreg,0) Nreg"
		'cadena_sql= cadena_sql & ", round(isnull(total,0 ) ,2) as newtotal"
		'cadena_sql= cadena_sql & ", round(isnull(gastos_envio,0), 2) as newgastosenvio"
		cadena_sql= cadena_sql & ", round(isnull(total_devoluciones,0), 2)  as TotalDevoluciones"
		cadena_sql= cadena_sql & ", round(isnull(TOTAL_SALDOS,0), 2)  as TotalSaldos"
		cadena_sql= cadena_sql & ", CASE WHEN CARGOABONO1=CARGOABONO2 THEN CARGOABONO1 WHEN CARGOABONO1<>CARGOABONO2 THEN 'CARGOABONO' ELSE NULL END AS CONTROL_CARGOABONO"

		cadena_sql= cadena_sql & ", round( (isnull(PEDIDOS_DETALLES.total,0 ) + isnull(gastos_envio,0)  - isnull(total_devoluciones,0)) * 0.21, 2)  as TotIva"
		'cadena_sql= cadena_sql & ", round( (isnull(total,0 ) + isnull(gastos_envio,0) - isnull(total_devoluciones,0)), 2)  as newtotalfinal"
		cadena_sql= cadena_sql & ", round( ((isnull(PEDIDOS_DETALLES.total,0 ) + isnull(gastos_envio,0) - isnull(TOTAL_SALDOS,0) - isnull(total_devoluciones,0)) + ((isnull(PEDIDOS_DETALLES.total,0 ) + isnull(gastos_envio,0) - isnull(total_devoluciones,0)) * 0.21)), 2)  as TotalEnvio"
		if session("usuario_admin")="CARLOS" then
			cadena_sql= cadena_sql & ",PEDIDOS_DETALLES.total as TotalSinIVA"
			cadena_sql= cadena_sql & ",(isnull(PEDIDOS_DETALLES.CANTIDAD,0)*isnull(PEDIDOS_DETALLES.PRECIO_COSTE,0)) as TotalCoste"
		end if	

        cadena_sql= cadena_sql & " , (select count(*) from pedidos_detalles INNER JOIN ARTICULOS ON PEDIDOS_DETALLES.ARTICULO=ARTICULOS.ID where id_pedido=PEDIDOS.ID AND ARTICULOS.COMPROMISO_COMPRA='NO') AS COMPROMISO_COMPRA_NO"
		cadena_sql= cadena_sql & " , (select count(*) from pedidos_detalles INNER JOIN ARTICULOS ON PEDIDOS_DETALLES.ARTICULO=ARTICULOS.ID where id_pedido=PEDIDOS.ID AND ARTICULOS.REQUIERE_HOJA_RUTA='SI') AS HOJA_RUTA_SI"
		cadena_sql= cadena_sql & " , (SELECT TOP 1 OBSERVACIONES FROM PEDIDOS_OBSERVACIONES WHERE PEDIDO=PEDIDOS.ID ORDER BY FECHA DESC) AS OBSERVACIONES"	

		cadena_sql= cadena_sql & " FROM PEDIDOS INNER JOIN V_CLIENTES ON PEDIDOS.CODCLI = V_CLIENTES.Id"
		cadena_sql= cadena_sql & " INNER JOIN V_EMPRESAS ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
		cadena_sql= cadena_sql & " INNER JOIN PEDIDOS_DETALLES ON PEDIDOS.ID = PEDIDOS_DETALLES.ID_PEDIDO"
        cadena_sql= cadena_sql & " LEFT JOIN (SELECT ID_Pedido, sum(PEDIDOS_DETALLES.total) Total, Sum(1) NReg FROM  Pedidos_Detalles"
		cadena_sql= cadena_sql & " where estado<>'ANULADO'"
		cadena_sql= cadena_sql & " GROUP BY ID_Pedido ) Tot ON PEDIDOS.ID = Tot.ID_Pedido "
		cadena_sql= cadena_sql & " LEFT JOIN (SELECT ID_PEDIDO, SUM(IMPORTE) AS TOTAL_DEVOLUCIONES FROM DEVOLUCIONES_PEDIDOS GROUP BY ID_PEDIDO) Dev"
		cadena_sql= cadena_sql & " ON Dev.ID_PEDIDO=PEDIDOS.ID"
		cadena_sql= cadena_sql & " LEFT JOIN (SELECT ID_PEDIDO"
		cadena_sql= cadena_sql & ", SUM(CASE"
		cadena_sql= cadena_sql & " WHEN CARGO_ABONO='CARGO' THEN IMPORTE * (-1)"
		cadena_sql= cadena_sql & " WHEN CARGO_ABONO='ABONO' THEN IMPORTE"
		cadena_sql= cadena_sql & " ELSE IMPORTE"
		cadena_sql= cadena_sql & " END) AS TOTAL_SALDOS"
		cadena_sql= cadena_sql & " , MAX(CARGO_ABONO) AS CARGOABONO1, MIN(CARGO_ABONO) AS CARGOABONO2"
		cadena_sql= cadena_sql & " FROM SALDOS_PEDIDOS GROUP BY ID_PEDIDO) Saldos ON SALDOS.ID_PEDIDO=PEDIDOS.ID"

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
				cadena_sql= cadena_sql & " AND PEDIDOS.ESTADO IN ('" & estado_seleccionado & "')"
			end if
		end if
		if cliente_seleccionado<>"" then
			cadena_sql= cadena_sql & " AND (PEDIDOS.CODCLI=" & cliente_seleccionado
			cadena_sql= cadena_sql & " OR CLIENTE_ORIGINAL=" & cliente_seleccionado & ")"
		end if
		if numero_pedido_seleccionado<>"" then
			cadena_sql= cadena_sql & " AND PEDIDOS.ID=" & numero_pedido_seleccionado
		end if
	
		if fecha_i_seleccionada<>"" then
			cadena_sql= cadena_sql & " AND (PEDIDOS.FECHA >= '" & cdate(fecha_i_seleccionada) & "')" 
		end if
		if fecha_f_seleccionada<>"" then
			cadena_sql= cadena_sql & " AND (PEDIDOS.FECHA <= '" & cdate(fecha_f_seleccionada) & "')"
		end if
		
		if pedido_automatico_seleccionado<>"" then
			if pedido_automatico_seleccionado="TODOS" then
				cadena_sql= cadena_sql & " AND (PEDIDOS.PEDIDO_AUTOMATICO<>'')"
			  else
			  	cadena_sql= cadena_sql & " AND (PEDIDOS.PEDIDO_AUTOMATICO='" & pedido_automatico_seleccionado & "')"
			
			end if
		end if
		
		if articulo_seleccionado<>"" then
			cadena_sql= cadena_sql & " AND (SELECT TOP(1) ARTICULO FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=PEDIDOS.ID AND ARTICULO=" & articulo_seleccionado
			if estado_seleccionado<>"" then
				'cadena_sql= cadena_sql & " AND PEDIDOS.ESTADO='" & estado_seleccionado & "'"
				cadena_sql= cadena_sql & " AND PEDIDOS_DETALLES.ESTADO IN ('" & estado_seleccionado & "')"
			end if
			cadena_sql= cadena_sql & ")=" & articulo_seleccionado
		end if
		
		if hoja_ruta_seleccionada<>"" then
			cadena_sql= cadena_sql & " AND (SELECT TOP(1) ID_PEDIDO FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=PEDIDOS.ID AND HOJA_RUTA='" & hoja_ruta_seleccionada & "')=PEDIDOS.ID"
		end if
		
		if estado_seleccionado="" and cliente_seleccionado="" and empresa_seleccionada="" and numero_pedido_seleccionado="" and articulo_seleccionado="" and hoja_ruta_seleccionada="" and fecha_i_seleccionada="" and fecha_f_seleccionada="" and pedido_automatico_seleccionado="" then
			cadena_sql= cadena_sql & " AND PEDIDOS.ESTADO='SIN TRATAR'"
		end if
		
			
		cadena_sql= cadena_sql & " ORDER BY PEDIDOS.FECHA DESC, PEDIDOS.CODCLI, PEDIDOS.ID"
		
			
	if ver_cadena="SI" then
		response.write("<br>empresa: " & empresa_seleccionada)
		response.write("<br>cliente: " & cliente_seleccionado)
		response.write("<br>estado: " & estado_seleccionado)
		response.write("<br>numero pedido: " & numero_pedido_seleccionado)
		response.write("<br>fecha_inicio: " & fecha_i_seleccionada)
		response.write("<br>fecha fin: " & fecha_f_seleccionada)
		response.write("<br>pedido automatico: " & pedido_automatico_seleccionado)
	
		response.write("<br>consulta pedidos: " & cadena_sql)
	end if
	
	Set rs = Server.CreateObject("ADODB.recordset")
	
	'porque el sql de produccion es un sql expres que debe tener el formato de
	' de fecha con mes-dia-a�o, y al lanzar consultas con fechas da error o
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



