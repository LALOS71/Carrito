<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	'pir = "" & request.QueryString("p_pir")
	
	codigos_pir=Request.Form("p_codigos_pir")
	importe_facturacion=Request.Form("p_importe_facturacion_bloque")
	fecha_facturacion=Request.Form("p_fecha_facturacion_bloque")
	
	dia = "0" & datepart("d", cdate(fecha_facturacion))
	mes = "0" & datepart("m", cdate(fecha_facturacion))
	anno = datepart("yyyy", cdate(fecha_facturacion))
	fecha_facturacion = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
	
	
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
	
	'response.write("<br>pirs: " & codigos_pir)
	'response.write("<br>importe facturacion: " & importe_facturacion)
	'response.write("<br>fecha_facturacion: " & fecha_facturacion)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		
		
		
		if ver_cadena="SI" then
			response.write("<br>" & cadena_sql & "<br><br>")
		end if
		
		
		codigos=Split(codigos_pir, "#")
		
		connmaletas.BeginTrans 'Comenzamos la Transaccion
		
		'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
		' de fecha con mes-dia-año
		connmaletas.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
			
		for each x in codigos
			if x<>"" then
				cadena_sql= "UPDATE PIRS SET FECHA_FACTURACION='" & cdate(fecha_facturacion) & "'"
				cadena_sql=cadena_sql & ", IMPORTE_FACTURACION=" & REPLACE(importe_facturacion, ",", ".")
				cadena_sql=cadena_sql & ", ESTADO=7"
				cadena_sql=cadena_sql & " WHERE ID=" & x
				
				'response.write("<br>cadena sql: " & cadena_sql)
				connmaletas.Execute cadena_sql,,adCmdText + adExecuteNoRecords
				
				'tambien hay que metar en el historico para que quede reflejado el cambio
				
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & x & ", '',"
				cadena_historico=cadena_historico & " GETDATE(), 'CAMBIO', 'ESTADO', '6',"
				cadena_historico=cadena_historico & " '7', '" & session("usuario") & "', 'FACTURACION EN BLOQUE', NULL)"

				'response.write("<br>cadena_historico: " & cadena_historico)
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & x & ", '',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'IMPORTE FACTURACION', '',"
				cadena_historico=cadena_historico & " '" & importe_facturacion & "', '" & session("usuario") & "', 'FACTURACION EN BLOQUE', NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & x & ", '',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FEC. FACTURA.', '',"
				cadena_historico=cadena_historico & " '" & fecha_facturacion & "', '" & session("usuario") & "', 'FACTURACION EN BLOQUE', NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
		next
		
		connmaletas.CommitTrans ' finaliza la transaccion
		
			'end if
			'.Source= .Source & " ORDER BY DESCRIPCION"
			'response.write("<br>" & cadena_sql)
			
	


	
	connmaletas.close
	set connmaletas=Nothing
	
	response.write("0")
%>



