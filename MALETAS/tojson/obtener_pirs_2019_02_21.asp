<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	
	pir = "" & request.QueryString("p_pir")
	estado = "" & request.QueryString("p_estado")
	compannia = "" & request.QueryString("p_compannia")
	proveedor = "" & request.QueryString("p_proveedor")
	expedicion = "" & request.QueryString("p_expedicion")
	fecha_inicio_orden = "" & request.QueryString("p_fecha_inicio_orden")
	fecha_fin_orden = "" & request.QueryString("p_fecha_fin_orden")
	fecha_inicio_envio = "" & request.QueryString("p_fecha_inicio_envio")
	fecha_fin_envio = "" & request.QueryString("p_fecha_fin_envio")
	fecha_inicio_entrega = "" & request.QueryString("p_fecha_inicio_entrega")
	fecha_fin_entregra = "" & request.QueryString("p_fecha_fin_entrega")
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		cadena_sql="SELECT PIRS.ID, PIRS.FECHA_ORDEN, PIRS.FECHA_INICIO, PIRS.PIR,"
		cadena_sql=cadena_sql & " (SELECT DESCRIPCION FROM TIPOS_MALETA WHERE ID=PIRS.TIPO_BAG_ENTREGADA) TIPO_BAG_ENTREGADA, PIRS.FECHA_ENVIO," 
		cadena_sql=cadena_sql & " PIRS.FECHA_ENTREGA_PAX, PIRS.ESTADO, PIRS.NUM_EXPEDICION, PIRS.IMPORTE_FACTURACION,"
		cadena_sql=cadena_sql & " PIRS.COSTES,"
		cadena_sql=cadena_sql & " (SELECT TOP 1 CONVERT(nvarchar(10), HISTORICO_PIRS.FECHA, 103) + '#||#' + "
		cadena_sql=cadena_sql & " CONVERT(nvarchar(8), HISTORICO_PIRS.FECHA, 108) + '#||#' + CONVERT(nvarchar(250),DESCRIPCION)"
		cadena_sql=cadena_sql & " FROM HISTORICO_PIRS WHERE ID_PIR=PIRS.ID AND ACCION='INCIDENCIA' ORDER BY FECHA DESC)"
		cadena_sql=cadena_sql & " AS ULTIMA_INCIDENCIA, ESTADOS.DESCRIPCION AS ESTADO_DESCRIPCION,"
		cadena_sql=cadena_sql & " PIRS.FECHA_PIR, PIRS.TAG, REPLACE(PIRS.TIPO_EQUIPAJE_BAG_ORIGINAL, '""','\""') AS TIPO_EQUIPAJE_BAG_ORIGINAL,"
		cadena_sql=cadena_sql & " REPLACE(PIRS.MARCA_BAG_ORIGINAL,'""', '\""') AS MARCA_BAG_ORIGINAL,"
		cadena_sql=cadena_sql & " PIRS.RUTA, PIRS.VUELOS, REPLACE(PIRS.TAMANNO_BAG_ENTREGADA,'""','\""') AS TAMANNO_BAG_ENTREGADA,"
		cadena_sql=cadena_sql & " PIRS.COLOR_BAG_ENTREGADA"
		cadena_sql=cadena_sql & " FROM PIRS LEFT JOIN ESTADOS"
		cadena_sql=cadena_sql & " ON PIRS.ESTADO = ESTADOS.ID"
		cadena_sql=cadena_sql & " WHERE 1=1"
		
		
		if session("perfil_usuario")="PROVEEDOR" then
			cadena_sql=cadena_sql & " AND PIRS.PROVEEDOR=" & session("proveedor_usuario")
		end if
		if pir<>"" then
			cadena_sql=cadena_sql & " AND PIRS.PIR='" & pir & "'"
		end if
		if estado<>"" then
			cadena_sql=cadena_sql & " AND PIRS.ESTADO=" & estado 
		end if
		if compannia<>"" then
			cadena_sql=cadena_sql & " AND PIRS.PIR LIKE '%" & compannia & "%'"
		end if
		if proveedor<>"" then
			cadena_sql=cadena_sql & " AND PIRS.PROVEEDOR=" & proveedor
		end if
		if expedicion<>"" then
			cadena_sql=cadena_sql & " AND PIRS.NUM_EXPEDICION='" & expedicion & "'"
		end if
		if fecha_inicio_orden<>"" then
			cadena_sql=cadena_sql & " AND PIRS.FECHA_ORDEN>='" & cdate(fecha_inicio_orden) & "'"
		end if
		if fecha_fin_orden<>"" then
			cadena_sql=cadena_sql & " AND FECHA_ORDEN<='" & cdate(fecha_fin_orden) & "'"
		end if
		if fecha_inicio_envio<>"" then
			cadena_sql=cadena_sql & " AND PIRS.FECHA_ENVIO>='" & cdate(fecha_inicio_envio) & "'"
		end if
		if fecha_fin_envio<>"" then
			cadena_sql=cadena_sql & " AND PIRS.FECHA_ENVIO<='" & cdate(fecha_fin_envio) & "'"
		end if
		if fecha_inicio_entrega<>"" then
			cadena_sql=cadena_sql & " AND PIRS.FECHA_ENTREGA_PAX>='" & cdate(fecha_inicio_entrega) & "'"
		end if
		if fecha_fin_entrega<>"" then
			cadena_sql=cadena_sql & " AND PIRS.FECHA_ENTREGA_PAX<='" & cdate(fecha_fin_entrega) & "'"
		end if
		
		if ver_cadena="SI" then
			response.write("<br>" & cadena_sql & "<br><br>")
		end if
		
		
		
		
			'end if
			'.Source= .Source & " ORDER BY DESCRIPCION"
			'response.write("<br>" & cadena_sql)
			
	Set rs = Server.CreateObject("ADODB.recordset")
	connmaletas.Execute "set dateformat dmy",,adCmdTex

	rs.Open cadena_sql, connmaletas
	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(rs, "ROWSET") & "}"



	
	connmaletas.close
	set connmaletas=Nothing
%>



