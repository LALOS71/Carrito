<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	
		
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		cadena_sql="select"
		cadena_sql=cadena_sql & " b.id AS ID"
		cadena_sql=cadena_sql & " , b.codigo_sap AS REFERENCIA"
		cadena_sql=cadena_sql & " , b.descripcion AS DESCRIPCION"
		cadena_sql=cadena_sql & " , a.marca AS MARCA"
		cadena_sql=cadena_sql & " , b.unidades_de_pedido AS UNIDADES_PEDIDO"
		cadena_sql=cadena_sql & " , b.compromiso_compra AS COMPROMISO_COMPRA"
		cadena_sql=cadena_sql & " , a.stock AS STOCK"
		cadena_sql=cadena_sql & " , a.stock_minimo AS STOCK_MINIMO"
		cadena_sql=cadena_sql & " , consultita.cantidad_pendiente AS CANTIDAD_PENDIENTE"
		cadena_sql=cadena_sql & " , consultita.cantidad AS CANTIDAD_PEDIDA"
		cadena_sql=cadena_sql & " , b.precio_coste AS PRECIO_COSTE"
		cadena_sql=cadena_sql & " , proveedores.descripcion as PROVEEDOR"
		cadena_sql=cadena_sql & " , TABLA2.EMPRE AS EMPRESA"
		cadena_sql=cadena_sql & " , TABLA2.DESCRIPCION AS FAMILIA"
		cadena_sql=cadena_sql & " , b.SOLICITADO_AL_PROVEEDOR AS SOLICITADO_AL_PROVEEDOR"
		'cadena_sql=cadena_sql & " , b.EXENTO_CONTROL_STOCK AS EXENTO_CONTROL_STOCK"
		cadena_sql=cadena_sql & " from articulos_marcas a"
		cadena_sql=cadena_sql & " left join articulos b"
		cadena_sql=cadena_sql & " on b.id=a.id_articulo"
		cadena_sql=cadena_sql & " left join"
		cadena_sql=cadena_sql & " (select"
		cadena_sql=cadena_sql & " final.articulo"
		cadena_sql=cadena_sql & " , sum(final.cantidad) as cantidad"
		cadena_sql=cadena_sql & " , sum(final.cantidad_pendiente) as cantidad_pendiente"
		cadena_sql=cadena_sql & " from"
		cadena_sql=cadena_sql & " ("
		cadena_sql=cadena_sql & " select articulo as articulo, sum(cantidad) as cantidad, sum(cantidad) as cantidad_pendiente"
		cadena_sql=cadena_sql & " from pedidos_detalles"
		cadena_sql=cadena_sql & " where estado in ('SIN TRATAR', 'EN PROCESO', 'EN PRODUCCION')"
		cadena_sql=cadena_sql & " GROUP BY articulo"
		cadena_sql=cadena_sql & " union"
		cadena_sql=cadena_sql & " select"
		cadena_sql=cadena_sql & " tabla.articulo"
		cadena_sql=cadena_sql & " , sum(tabla.cantidad) as cantidad"
		cadena_sql=cadena_sql & " , sum(tabla.cantidad_pendiente) as cantidad_pendiente"
		cadena_sql=cadena_sql & " from"
		cadena_sql=cadena_sql & " (select"
		cadena_sql=cadena_sql & " a.articulo"
		cadena_sql=cadena_sql & " , a.cantidad"
		cadena_sql=cadena_sql & " ,(a.cantidad - (select sum(cantidad_enviada)"
		cadena_sql=cadena_sql & "  from pedidos_envios_parciales"
		cadena_sql=cadena_sql & " where id_pedido=a.id_pedido and id_articulo=a.articulo)) as cantidad_pendiente"
		cadena_sql=cadena_sql & " from pedidos_detalles a"
		cadena_sql=cadena_sql & " where estado ='ENVIO PARCIAL') as tabla"
		cadena_sql=cadena_sql & " group by articulo"
		cadena_sql=cadena_sql & " )as final"
		cadena_sql=cadena_sql & " group by final.articulo"
		cadena_sql=cadena_sql & " ) consultita"
		cadena_sql=cadena_sql & " on consultita.articulo=b.id"
		cadena_sql=cadena_sql & " left join proveedores"
		cadena_sql=cadena_sql & " on b.proveedor=proveedores.id"
		cadena_sql=cadena_sql & " LEFT JOIN"
		cadena_sql=cadena_sql & " ("
		cadena_sql=cadena_sql & " SELECT FAMILII.*, FAMILIAS.DESCRIPCION"
		cadena_sql=cadena_sql & " FROM"
		cadena_sql=cadena_sql & " (SELECT ARTICULOS_EMPRESAS.ID_ARTICULO, COUNT(*) AS CUENTA"
		cadena_sql=cadena_sql & " , MIN(ARTICULOS_EMPRESAS.CODIGO_EMPRESA) AS CODIGO_EMPRESA"
		cadena_sql=cadena_sql & " , MIN(V_EMPRESAS.EMPRESA) AS EMPRESA"
		cadena_sql=cadena_sql & " , CASE WHEN COUNT(*)>1 THEN 'Varias...' ELSE MIN(V_EMPRESAS.EMPRESA) END AS EMPRE"
		cadena_sql=cadena_sql & " , MIN(ARTICULOS_EMPRESAS.FAMILIA) AS CODIGO_FAMILIA"
		cadena_sql=cadena_sql & " FROM ARTICULOS_EMPRESAS LEFT JOIN V_EMPRESAS"
		cadena_sql=cadena_sql & " ON V_EMPRESAS.ID = ARTICULOS_EMPRESAS.CODIGO_EMPRESA"
		cadena_sql=cadena_sql & " GROUP BY ARTICULOS_EMPRESAS.ID_ARTICULO) AS FAMILII"
		cadena_sql=cadena_sql & " LEFT JOIN FAMILIAS"
		cadena_sql=cadena_sql & " ON FAMILIAS.ID=FAMILII.CODIGO_FAMILIA"
		cadena_sql=cadena_sql & " ) AS TABLA2"
		cadena_sql=cadena_sql & " ON b.id=TABLA2.ID_ARTICULO"
		cadena_sql=cadena_sql & " where ((stock_minimo>0) and ((stock_minimo>=stock) or (stock<=cantidad_pendiente)))"
		cadena_sql=cadena_sql & " or ((stock_minimo=0) and (stock=0) and (cantidad_pendiente>=1))"
		
		'cadena_sql=cadena_sql & " or ((exento_control_stock='SI') and (stock_minimo is null) and (stock=0) and (cantidad_pendiente>=1))"


		
		
		
			'end if
			'.Source= .Source & " ORDER BY DESCRIPCION"
			'response.write("<br>" & cadena_sql)
			
	Set rs = Server.CreateObject("ADODB.recordset")
	rs.Open cadena_sql, connimprenta
	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(rs, "ROWSET") & "}"



	
	connimprenta.close
	set connimprenta=Nothing
%>



