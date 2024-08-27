<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	empresa_seleccionada = "" & request.QueryString("p_empresa")
	fecha_ini = "" & request.QueryString("p_fecha_ini")
	fecha_fin = "" & request.QueryString("p_fecha_fin")
	ver_cadena= "" & request.QueryString("p_vercadena")
        	
		

	
	set pedidos=Server.CreateObject("ADODB.Recordset")

	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
			
	with pedidos
		.ActiveConnection=connimprenta
		
		
		.Source="SELECT A.CODCLI, B.NOMBRE, A.ID AS PEDIDO, A.FECHA"
		.Source= .Source & ", D.CODIGO_SAP AS REFERENCIA, D.DESCRIPCION AS ARTICULO, C.CANTIDAD"
		.Source= .Source & ", C.PRECIO_UNIDAD, C.TOTAL, C.ALBARAN, E.FACTURA"
		.Source= .Source & ", E.EJERCICIOFACTURA"
		.Source= .Source & ", C.ESTADO AS ESTADO_DETALLE, A.ESTADO AS ESTADO_PEDIDO"
		'.Source= .Source & ",*"
		.Source= .Source & " FROM PEDIDOS A INNER JOIN V_CLIENTES B ON A.CODCLI=B.ID"
		.Source= .Source & " INNER JOIN PEDIDOS_DETALLES C ON A.ID=C.ID_PEDIDO"
		.Source= .Source & " INNER JOIN ARTICULOS D ON C.ARTICULO=D.ID"
		.Source= .Source & " LEFT JOIN V_DATOS_ALBARANES E ON E.IDALBARAN=C.ALBARAN"
		.Source= .Source & " WHERE B.EMPRESA=" & empresa_seleccionada
		.Source= .Source & " AND A.CODCLI<>5410" ' -- GLOBALIA DISTRIBUCION
		.Source= .Source & " AND C.ESTADO='ENVIADO'"
		.Source= .Source & " AND (CONVERT(VARCHAR(8), A.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & cdate(fecha_ini) & "', 103) , 112))"
		.Source= .Source & " AND (CONVERT(VARCHAR(8), A.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & cdate(fecha_fin) & "', 103) , 112))"
		.Source= .Source & " ORDER BY B.NOMBRE, A.ID"
		
		'RESPONSE.WRITE("<BR>" & .Source)
		if ver_cadena="SI" then
			response.write("<br>cadena sql: " & .source)
		end if
		.Open
	end with

	Response.ContentType = "application/json"
	
	'cadena=JSONData(referencias, "data")
	'cadena=REPLACE(cadena,"\", "\\")
	'cadena=REPLACE(cadena,"ñ", "nn")
	'adena=REPLACE(cadena,"Ñ", "NN")
	'cadena=REPLACE(cadena, chr(13), "\r\n")
	'cadena=REPLACE(cadena, chr(10), "")
	'Response.Write "{" & cadena & "}"
	
	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(pedidos, "ROWSET") & "}"
	
	
	'articulos.close
	set pedidos=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>



