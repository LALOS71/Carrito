<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	'pir = "" & request.QueryString("p_pir")
	
	id_devolucion = "" & Request.Form("p_devolucion")
	
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
	
	'response.write("<br>pirs: " & codigos_pir)
	'response.write("<br>importe facturacion: " & importe_facturacion)
	'response.write("<br>fecha_facturacion: " & fecha_facturacion)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		
		
		
		if ver_cadena="SI" then
			response.write("<br>" & cadena_sql & "<br><br>")
		end if
		
		
		
		
		
		
		connimprenta.BeginTrans 'Comenzamos la Transaccion
		
			'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
			' de fecha con mes-dia-año
			connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
			
			
			cadena_sql="DELETE DEVOLUCIONES WHERE ID=" & id_devolucion
			
			'response.write("CADENA: " & cadena_sql)
			connimprenta.Execute cadena_sql,,adCmdText + adExecuteNoRecords
			
			cadena_sql="DELETE DEVOLUCIONES_DETALLES WHERE ID_DEVOLUCION=" & id_devolucion
			
			'response.write("CADENA: " & cadena_sql)
			connimprenta.Execute cadena_sql,,adCmdText + adExecuteNoRecords
			
					
		
		connimprenta.CommitTrans ' finaliza la transaccion
		
			'end if
			'.Source= .Source & " ORDER BY DESCRIPCION"
			'response.write("<br>" & cadena_sql)
			
	


	
	connimprenta.close
	set connimprenta=Nothing
	
	response.write("0")
%>



