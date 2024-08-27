<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	'pir = "" & request.QueryString("p_pir")
	
	codigos_pir=Request.Form("p_codigos_pir")
	importe_facturacion=Request.Form("p_importe_facturacion_bloque")
	fecha_facturacion=Request.Form("p_fecha_facturacion_bloque")
	
	
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
	
	response.write("<br>pirs: " & codigos_pir)
	response.write("<br>importe facturacion: " & importe_facturacion)
	response.write("<br>fecha_facturacion: " & fecha_facturacion)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		
		cadena_sql="SELECT PIRS.ID, PIRS.FECHA_ORDEN, PIRS.FECHA_INICIO, PIRS.PIR,"
		
		if ver_cadena="SI" then
			response.write("<br>" & cadena_sql & "<br><br>")
		end if
		
		
		codigos=Split(codigos_pir, "#")
		for each x in codigos
			if x<>"" then
				cadena_sql= "UPDATE PIRS SET FECHA_FACTURACION='" & fecha_facturacion & "'"
				cadena_sql=cadena_sql & ", IMPORTE_FACTURACION=" & REPLACE(importe_facturacion, ",", ".") 
				cadena_sql=cadena_sql & " WHERE ID=" & x
				response.write("<br>cadena sql: " & cadena_sql)
			end if
		next
		
			'end if
			'.Source= .Source & " ORDER BY DESCRIPCION"
			'response.write("<br>" & cadena_sql)
			
	


	
	connmaletas.close
	set connmaletas=Nothing
%>



