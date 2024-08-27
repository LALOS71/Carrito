<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	'pir = "" & request.QueryString("p_pir")
	
	cadena_pedidos = "" & Request.Form("p_pedidos")
	
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
	
		
		
		
		connimprenta.BeginTrans 'Comenzamos la Transaccion
		
			'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
			' de fecha con mes-dia-año
			connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
			
			
			cadena_sql="UPDATE PEDIDOS SET ESTADO='SIN TRATAR' WHERE ID IN (" & cadena_pedidos & ")"
			cadena_sql_detalles="UPDATE PEDIDOS_DETALLES SET ESTADO='SIN TRATAR' WHERE ID_PEDIDO IN (" & cadena_pedidos & ")"
			
			if ver_cadena="SI" then
				response.write("<br>" & cadena_sql & "<br><br>")
			end if
		
			'response.write("------CADENA DEVOLUCION: " & cadena_sql)
			connimprenta.Execute cadena_sql,,adCmdText + adExecuteNoRecords
			connimprenta.Execute cadena_sql_detalles,,adCmdText + adExecuteNoRecords
			
			
					
		
		connimprenta.CommitTrans ' finaliza la transaccion
		
			
	


	
	connimprenta.close
	set connimprenta=Nothing
	
	response.write("MODIFICACION_PEDIDOS_OK" & nueva_devolucion)
%>



