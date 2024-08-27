<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->

<%



	if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
	end if
		
	
	id_seleccionado=Request.QueryString("q")
	cantidad_seleccionada=Request.QueryString("cantidad")
	entrada_salida_seleccionada=Request.QueryString("entrada_salida")
	fecha_seleccionada=Request.QueryString("fecha")
	albaran_seleccionado=Request.QueryString("albaran")
	tipo_seleccionado=Request.QueryString("tipo")
	id_articulo_seleccionado=Request.QueryString("id_articulo")
	
	
	'response.write("<br>hola...")
	'como hay que tocar varias cosas de la base de datos, ponemos una transaccion
	connimprenta.BeginTrans 'Comenzamos la Transaccion
	
		cadena_ejecucion="DELETE ENTRADAS_SALIDAS_ARTICULOS"
		cadena_ejecucion=cadena_ejecucion & " WHERE ID=" & id_seleccionado
		
		response.write("<br><br>cadena: " & cadena_ejecucion)
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
		'ponemos un control, primero vemos que stock hay
		set comprobar_stock_actual=Server.CreateObject("ADODB.Recordset")
		historico_stock_actual=0
		with comprobar_stock_actual
			.ActiveConnection=connimprenta
			.Source="SELECT STOCK FROM ARTICULOS_MARCAS"
			.Source= .Source & " WHERE ID_ARTICULO=" & id_articulo_seleccionado
			.Source= .Source & " AND MARCA='STANDARD'"
			'response.write("<br>" & .source)
			.Open
		end with
		if not comprobar_stock_actual.eof then
			historico_stock_actual="" & comprobar_stock_actual("stock")
		end if
		comprobar_stock_actual.close
		set comprobar_stock_actual=nothing	
		
		if  historico_stock_actual="" then
			historico_stock_actual="NULL"
		end if
		
		'METEMOS LA LINEA EN EL CONTROL DE HISTORICO DE STOCK PARA VER LOS MOVIMIENTOS	
		cadena_historico="INSERT INTO HISTORICO_STOCKS (FECHA, PEDIDO, ARTICULO, CANTIDAD, STOCK_ACTUAL, STOCK_NUEVO, PROCEDENCIA)"
		cadena_historico=cadena_historico & " VALUES (GETDATE(), NULL, " & id_articulo_seleccionado
		cadena_historico=cadena_historico & ", " & cantidad_seleccionada & ", " & historico_stock_actual 
		
		'ES LA ACCION CONTRARIA A LO NORMAL... al borrar una entrada, hay que restar las cantidades introducidas, y si es una 
		'  salida... hay que sumar las cantidades sacadas
		if entrada_salida_seleccionada="ENTRADA" then
			stock_nuevo=cdbl(historico_stock_actual) - cdbl(cantidad_seleccionada)
			cadena_historico=cadena_historico & ", " & stock_nuevo & ", 'Borrar_Entradas_Salidas_Articulos - BORRAR ENTRADA')"
		  else
		  	stock_nuevo=cdbl(historico_stock_actual) + cdbl(cantidad_seleccionada)
			cadena_historico=cadena_historico & ", " & stock_nuevo & ", 'Borrar_Entradas_Salidas_Articulos - BORRAR SALIDA')"
		end if
		response.write("<br>" & cadena_historico)
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
		connimprenta.Execute cadena_historico,,adCmdText + adExecuteNoRecords
	
		cadena_articulos="UPDATE ARTICULOS_MARCAS"
		cadena_articulos=cadena_articulos & " SET STOCK=" & stock_nuevo
		cadena_articulos=cadena_articulos & " WHERE ID_ARTICULO = " & id_articulo_seleccionado
		cadena_articulos=cadena_articulos & " AND (MARCA = 'STANDARD')"

		connimprenta.Execute cadena_articulos,,adCmdText + adExecuteNoRecords
		
		connimprenta.CommitTrans ' finaliza la transaccion






   	
			   
   	'connimprenta.BeginTrans 'Comenzamos la Transaccion
	'connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
	
	'connimprenta.CommitTrans ' finaliza la transaccion
	
	
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Borrar Entradas Salidas de Articulos</TITLE>
</HEAD>

   
<BODY>
</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
