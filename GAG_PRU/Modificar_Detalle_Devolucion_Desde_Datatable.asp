<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	id_devolucion			= Request.Form("id_devolucion")
	id_detalle_devolucion	= Request.Form("id_detalle_devolucion")
	estado_nuevo			= Request.Form("estado_nuevo")
	cantidad				= Request.Form("cantidad")
	id_articulo				= Request.Form("id_articulo")
	
	connimprenta.BeginTrans 'Comenzamos la Transaccion
	
	IF estado_nuevo="ACEPTADO" THEN
		campo="UNIDADES_ACEPTADAS"
	END IF
	
	IF estado_nuevo="RECHAZADO" THEN
		campo="UNIDADES_RECHAZADAS"
	END IF
	
	'''''''''''''''''''''''''''''''''
	'OJO... SI SE ACEPTA HAY QUE SUMAR EL STOCK DEL ARTICULO
	''''¿Y CREAR ALGUNA DEVOLUCION EN LA FICHA.... COMO EMNTRADA EN ALMANCEN?
	
	
	
	
	
	cadena = "UPDATE DEVOLUCIONES_DETALLES SET " & campo & " = ISNULL(" & campo & ",0) + " & cantidad
	IF estado_nuevo="ACEPTADO" THEN
		cadena = cadena & ", FECHA_ACEPTACION= getdate()"
	end if
	cadena = cadena & " WHERE ID = " & id_detalle_devolucion
	
	'response.write("cadnea: " & cadena)
	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	connimprenta.Execute cadena,,adCmdText + adExecuteNoRecords
	
	set totales_devolucion=Server.CreateObject("ADODB.Recordset")
	CAMPO_ID_DEVOLUCION=0
	CAMPO_CANTIDAD=1
	CAMPO_ACEPTADAS=2
	CAMPO_RECHAZADAS=3
	CAMPO_TOTALES=4
	
	with totales_devolucion
		.ActiveConnection=connimprenta
		.Source="SELECT ID_DEVOLUCION, ISNULL(SUM(CANTIDAD), 0) AS CANTIDAD, ISNULL(SUM(UNIDADES_ACEPTADAS), 0) AS ACEPTADAS"
		.Source= .Source & ", ISNULL(SUM(UNIDADES_RECHAZADAS), 0) AS RECHAZADAS"
		.Source= .Source & ", (ISNULL(SUM(UNIDADES_ACEPTADAS), 0) + ISNULL(SUM(UNIDADES_RECHAZADAS), 0)) AS TOTALES"
		.Source= .Source & " FROM DEVOLUCIONES_DETALLES"
		.Source= .Source & " WHERE ID_DEVOLUCION=" & id_devolucion
		.Source= .Source & " GROUP BY ID_DEVOLUCION"
		.Open
		vacio_totales=false
		if not .BOF then
			mitabla_totales=.GetRows()
			else
			vacio_totales=true
		end if
	end with
	totales_devolucion.close
	set totales_devolucion=Nothing
	
	if not vacio_totales then
		if mitabla_totales(CAMPO_TOTALES,0) = mitabla_totales(CAMPO_CANTIDAD, 0) then
			cadena = "UPDATE DEVOLUCIONES SET ESTADO='CERRADA'"
			cadena = cadena & ", TOTAL_ACEPTADO=ISNULL((SELECT ROUND(SUM(TOTAL/CANTIDAD * UNIDADES_ACEPTADAS),2) FROM DEVOLUCIONES_DETALLES WHERE ID_DEVOLUCION=DEVOLUCIONES.ID), 0)"
			cadena = cadena & " WHERE ID=" & id_devolucion
			connimprenta.Execute cadena,,adCmdText + adExecuteNoRecords
		  else
		  	cadena = "UPDATE DEVOLUCIONES SET ESTADO='PENDIENTE' WHERE ID=" & id_devolucion
			connimprenta.Execute cadena,,adCmdText + adExecuteNoRecords
		end if
	end if
	
	'actualizamos el stock incrementando lo devuelto
	IF estado_nuevo="ACEPTADO" THEN
	
		'metemos la linea de entrada/salida de material de articulo en concreto, una DEVOLUCION
		cadena_ejecucion="INSERT INTO ENTRADAS_SALIDAS_ARTICULOS (ID_ARTICULO, E_S, FECHA, CANTIDAD, ALBARAN, TIPO, FECHA_ALTA)"
		cadena_ejecucion=cadena_ejecucion & " VALUES (" & id_articulo
		cadena_ejecucion=cadena_ejecucion & " , 'ENTRADA'"
		cadena_ejecucion=cadena_ejecucion & " , GETDATE()"
		cadena_ejecucion=cadena_ejecucion & " , ISNULL(" & cantidad & ", 0)"
		cadena_ejecucion=cadena_ejecucion & " , '" & id_devolucion & "'"
		cadena_ejecucion=cadena_ejecucion & " , 'DEVOLUCION'"
		cadena_ejecucion=cadena_ejecucion & " , getdate())"
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
		
	
		'METEMOS LA LINEA EN EL CONTROL DE HISTORICO DE STOCK PARA VER LOS MOVIMIENTOS	
		cadena_historico="INSERT INTO HISTORICO_STOCKS (FECHA, PEDIDO, ARTICULO, CANTIDAD, STOCK_ACTUAL, STOCK_NUEVO, PROCEDENCIA)"
		cadena_historico=cadena_historico & " (SELECT GETDATE(), NULL, ID_ARTICULO, ISNULL(" & cantidad & ", 0), STOCK, STOCK + ISNULL(" & cantidad & ", 0)"
		cadena_historico=cadena_historico & ", 'Modificar_Detalle_Devolucion_Desde_Datatable'"
		cadena_historico=cadena_historico & " FROM ARTICULOS_MARCAS"
		cadena_historico=cadena_historico & " WHERE ID_ARTICULO=" & id_articulo 
		cadena_historico=cadena_historico & " AND MARCA='STANDARD')"	
	
		'response.write("<br>" & cadena_historico)
		connimprenta.Execute cadena_historico,,adCmdText + adExecuteNoRecords
	
	
		cadena = "UPDATE ARTICULOS_MARCAS SET STOCK = STOCK + ISNULL(" & cantidad & ", 0)"
		cadena = cadena & " WHERE ID_ARTICULO=" & id_articulo
		cadena = cadena & " AND MARCA='STANDARD'"
		
		connimprenta.Execute cadena,,adCmdText + adExecuteNoRecords
		
		'falta la linea de entrada de la ficha del articulo
	end if
	
	

	
			
	
	
	connimprenta.CommitTrans ' finaliza la transaccion
			
	
	Response.Write 1
	
	
	connimprenta.close
	set connimprenta=Nothing
	
	
%>



