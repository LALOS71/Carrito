<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	fecha_inicio = "" & request.QueryString("p_fecha_inicio")
	fecha_fin = "" & request.QueryString("p_fecha_fin")
        	
	set articulos=Server.CreateObject("ADODB.Recordset")
		
	with articulos
		.ActiveConnection=connimprenta
		.Source="select A.ID_PEDIDO, B.CODCLI AS CODIGO_CLIENTE, E.NOMBRE as CLIENTE"
		.Source= .Source & ", F.ID AS CODIGO_OFICINA_ORIGEN, F.NOMBRE as OFICINA_ORIGEN"
		.Source= .Source & ", A.ARTICULO, D.CODIGO_SAP AS REFERENCIA, REPLACE(D.DESCRIPCION, '""', '____') AS DESCRIPCION, A.ALBARAN, B.FECHA_ENVIADO"
		.Source= .Source & ", A.CANTIDAD, A.PRECIO_UNIDAD, A.TOTAL, B.NUMERO_EMPLEADO"
		
		.Source= .Source & " FROM PEDIDOS_DETALLES A"
		.Source= .Source & " LEFT JOIN PEDIDOS B"
		.Source= .Source & " ON A.ID_PEDIDO=B.ID"
		.Source= .Source & " LEFT JOIN ARTICULOS_EMPRESAS C"
		.Source= .Source & " ON C.ID_ARTICULO=A.ARTICULO"
		.Source= .Source & " LEFT JOIN ARTICULOS D"
		.Source= .Source & " ON A.ARTICULO=D.ID"
		.Source= .Source & " LEFT JOIN V_CLIENTES E"
		.Source= .Source & " ON B.CODCLI=E.ID"
		.Source= .Source & " LEFT JOIN V_CLIENTES F"
		.Source= .Source & " ON B.CLIENTE_ORIGINAL=F.ID"

		.Source= .Source & " WHERE B.PEDIDO_AUTOMATICO='GLOBALBAG'"
		.Source= .Source & " AND (A.ESTADO='ENVIADO' OR A.ESTADO='ENVIO PARCIAL')"
		if fecha_inicio<>"" then
			.Source= .Source & " AND B.FECHA_ENVIADO>='" & cdate(fecha_inicio) & "'"
		end if
		if fecha_fin<>"" then
			.Source= .Source & " AND B.FECHA_ENVIADO<='" & cdate(fecha_fin) & "'"
		end if
			
			
		.Source= .Source & " GROUP BY A.ID_PEDIDO, B.CODCLI, E.NOMBRE"
		.Source= .Source & ", F.ID, F.NOMBRE"
		.Source= .Source & ", A.ARTICULO, D.CODIGO_SAP, D.DESCRIPCION, A.ALBARAN, B.FECHA_ENVIADO"
		.Source= .Source & ", A.CANTIDAD, A.PRECIO_UNIDAD, A.TOTAL, B.NUMERO_EMPLEADO"

		connimprenta.Execute "set dateformat dmy",,adCmdTex
			
		.Open
	end with

	Response.ContentType = "application/json"
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



