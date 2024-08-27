<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	'Response.CharSet = "iso-8859-1"
	Response.ContentType = "application/json;charset=UTF-8"

	empresa_seleccionada = "" & request.QueryString("p_empresa")
	familia_seleccionada = "" & request.QueryString("p_familia")
	referencia_seleccionada = "" & request.QueryString("p_referencia")
	descripcion_seleccionada = "" & request.QueryString("p_descripcion")
	campo_autorizacion = "" & request.QueryString("p_autorizacion")
	campo_eliminado = "" & request.QueryString("p_eliminado")
	ejecutar_consulta = "" & request.QueryString("p_ejecutar")

	ver_cadena= "" & request.QueryString("p_vercadena")
        	
	set articulos=Server.CreateObject("ADODB.Recordset")
		
	with articulos
		.ActiveConnection=connimprenta
		.Source="SELECT ARTICULOS.ID, ARTICULOS.CODIGO_SAP, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, V_EMPRESAS.EMPRESA, "
		.Source= .Source & " REPLACE(ARTICULOS.DESCRIPCION, '""', '____') AS DESCRIPCION, ARTICULOS.MOSTRAR, ARTICULOS.REQUIERE_AUTORIZACION, "
		.Source= .Source & " (SELECT STOCK FROM ARTICULOS_MARCAS WHERE ID_ARTICULO = ARTICULOS.ID AND MARCA = 'STANDARD') AS STOCK,"
		.Source= .Source & " (SELECT STOCK_MINIMO FROM ARTICULOS_MARCAS WHERE ID_ARTICULO = ARTICULOS.ID AND MARCA = 'STANDARD') AS STOCK_MINIMO,"

		.Source= .Source & " (select sum(final.cantidad_pendiente) as cantidad_pendiente"
		.Source= .Source & " from"
		.Source= .Source & " ("
		.Source= .Source & " select articulo as articulo, sum(cantidad) as cantidad, sum(cantidad) as cantidad_pendiente"
		.Source= .Source & " from pedidos_detalles"
		.Source= .Source & " where estado in ('SIN TRATAR', 'EN PROCESO', 'EN PRODUCCION')"
		.Source= .Source & " GROUP BY articulo"
		.Source= .Source & " union"
		.Source= .Source & " select tabla.articulo, sum(tabla.cantidad) as cantidad, sum(tabla.cantidad_pendiente) as cantidad_pendiente"
		.Source= .Source & " from"
		.Source= .Source & " (select a.articulo, a.cantidad,(a.cantidad - ("
		.Source= .Source & " select sum(cantidad_enviada) from pedidos_envios_parciales"
		.Source= .Source & " where id_pedido=a.id_pedido and id_articulo=a.articulo)) as cantidad_pendiente"
		.Source= .Source & " from pedidos_detalles a"
		.Source= .Source & " where estado ='ENVIO PARCIAL') as tabla"
		.Source= .Source & " group by articulo"
		.Source= .Source & " )as final"
		.Source= .Source & " WHERE FINAL.ARTICULO=ARTICULOS.ID"
		.Source= .Source & " group by final.articulo) AS CANTIDAD_PENDIENTE"

		.Source= .Source & " FROM ARTICULOS INNER JOIN ARTICULOS_EMPRESAS"
		.Source= .Source & " ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO"
		.Source= .Source & " INNER JOIN V_EMPRESAS"
		.Source= .Source & " ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA=V_EMPRESAS.ID"
		
		
		'HABRIA QUE PONER LEFTS JOINS PARA QUE SALGAN LOS ARTICULOS SIN EMPRESAS....
		'.Source= .Source & " FROM ARTICULOS LEFT JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO "
		'.Source= .Source & " LEFT JOIN V_EMPRESAS ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA=V_EMPRESAS.ID "
		
		.Source= .Source & " WHERE 1=1"
		if empresa_seleccionada<>"" then
			.Source= .Source & " AND ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & empresa_seleccionada
		end if
		if familia_seleccionada<>"" then
			.Source= .Source & " AND ARTICULOS.ID IN (SELECT ID_ARTICULO FROM ARTICULOS_EMPRESAS WHERE CODIGO_EMPRESA = " & empresa_seleccionada
			.Source= .Source & " AND FAMILIA = " & familia_seleccionada & ")"
		end if
		if referencia_seleccionada<>"" then
			.Source= .Source & " AND ARTICULOS.CODIGO_SAP LIKE '%" & referencia_seleccionada & "%'"
		end if
		if descripcion_seleccionada<>"" then
			.Source= .Source & " AND ARTICULOS.DESCRIPCION LIKE '%" & descripcion_seleccionada & "%'"
		end if
		if campo_autorizacion<>"" then
			.Source= .Source & " AND ARTICULOS.REQUIERE_AUTORIZACION='" & campo_autorizacion & "'"
		end if
		if campo_eliminado<>"" then
			.Source= .Source & " AND BORRADO='" & campo_eliminado & "' "
		end if
			
			
		'para que no muestre toda la lista de articulos si no se selecciona nada
		'if empresa_seleccionada="" and codigo_sap_seleccionado="" and descripcion_seleccionada="" and campo_eliminado="NO" and campo_autorizacion="" then
		if ejecutar_consulta<>"SI" then
			.Source= .Source & " AND ARTICULOS.ID=0"
		end if
			
			
		.Source= .Source & " ORDER BY ARTICULOS.DESCRIPCION"
			
		if ver_cadena="SI" then
			response.write("<br>cadena sql: " & .source)
		end if
		.Open
	end with

	
	cadena=JSONData(articulos, "ROWSET")
	cadena=REPLACE(cadena,"\", "\\")
	cadena=REPLACE(cadena,"____", "\""")
	cadena=REPLACE(cadena, chr(13), "\r\n")
	cadena=REPLACE(cadena, chr(10), "")
	Response.Write "{" & cadena & "}"

	'articulos.close
	set articulos=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>



