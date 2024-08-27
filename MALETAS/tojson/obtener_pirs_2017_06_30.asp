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
		cadena_sql="SELECT ID, FECHA_ORDEN, PIR, FECHA_PIR, TAG, TIPO_BAG_ENTREGADA, FECHA_INICIO, FECHA_ENVIO, FECHA_ENTREGA_PAX," 
		cadena_sql=cadena_sql & " INCIDENCIA_TRANSPORTE, INCIDENCIA_MALETA, OTRAS_INCIDENCIAS, REFERENCIA_BAG_ENTREGADA, NUM_EXPEDICION,"
		cadena_sql=cadena_sql & " ESTADO"
		cadena_sql=cadena_sql & " "
		cadena_sql=cadena_sql & " FROM PIRS"
		cadena_sql=cadena_sql & " WHERE 1=1"
		
			
		if pir<>"" then
			cadena_sql=cadena_sql & " AND PIR='" & pir & "'"
		end if
		if estado<>"" then
			cadena_sql=cadena_sql & " AND ESTADO='" & estado & "'"
		end if
		if compannia<>"" then
			cadena_sql=cadena_sql & " AND PIR LIKE '%" & compannia & "%'"
		end if
		
		if expedicion<>"" then
			cadena_sql=cadena_sql & " AND NUM_EXPEDICION='" & expedicion & "'"
		end if
		if fecha_inicio_orden<>"" then
			cadena_sql=cadena_sql & " AND FECHA_ORDEN>='" & cdate(fecha_inicio_orden) & "'"
		end if
		if fecha_fin_orden<>"" then
			cadena_sql=cadena_sql & " AND FECHA_ORDEN<='" & cdate(fecha_fin_orden) & "'"
		end if
		if fecha_inicio_envio<>"" then
			cadena_sql=cadena_sql & " AND FECHA_ENVIO>='" & cdate(fecha_inicio_envio) & "'"
		end if
		if fecha_fin_envio<>"" then
			cadena_sql=cadena_sql & " AND FECHA_ENVIO<='" & cdate(fecha_fin_envio) & "'"
		end if
		if fecha_inicio_entrega<>"" then
			cadena_sql=cadena_sql & " AND FECHA_ENTREGA_PAX>='" & cdate(fecha_inicio_entrega) & "'"
		end if
		if fecha_fin_entrega<>"" then
			cadena_sql=cadena_sql & " AND FECHA_ENTREGA_PAX<='" & cdate(fecha_fin_entrega) & "'"
		end if
		
		if ver_cadena="SI" then
			response.write("<br>" & cadena_sql & "<br><br>")
		end if
		
		
		
		
			'end if
			'.Source= .Source & " ORDER BY DESCRIPCION"
			'response.write("<br>" & cadena_sql)
			
	Set rs = Server.CreateObject("ADODB.recordset")
	rs.Open cadena_sql, connmaletas
	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(rs, "ROWSET") & "}"



	
	connmaletas.close
	set connmaletas=Nothing
%>



