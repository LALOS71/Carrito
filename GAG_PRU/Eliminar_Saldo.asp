<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%

	
		saldo_a_borrar=Request.Form("id_saldo")
		
		'vemos si lo podemos borrar, no siendo que justo en el tiempo que va desde que selecciona
		' el pedido a borrar y se borra, en la imprenta hayan tramitado algun articulo
		podemos_borrarlo="NO"
		set saldo=Server.CreateObject("ADODB.Recordset")
		with saldo
			.ActiveConnection=connimprenta
			.Source="SELECT * FROM SALDOS WHERE ID=" & saldo_a_borrar & " AND TOTAL_DISFRUTADO>0"
			.Open
		end with
		
		if saldo.eof then
			podemos_borrarlo="SI"
		end if
		saldo.close
		set saldo=Nothing
		
		if podemos_borrarlo="SI" then
				'borro el saldo
				cadena_ejecucion="DELETE FROM SALDOS WHERE ID=" & saldo_a_borrar
				connimprenta.BeginTrans 'Comenzamos la Transaccion
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				connimprenta.CommitTrans ' finaliza la transaccion
				
				
				mensaje_aviso="BAJA_OK"
			  else
			  	mensaje_aviso="BAJA_ERROR"
			end if
		
		
		cadena_json = "{"
		cadena_json = cadena_json & """resultado"":""" & mensaje_aviso & """" 
		cadena_json = cadena_json & "}"
		
		
		
		response.write(cadena_json)
		
		
		

%>
