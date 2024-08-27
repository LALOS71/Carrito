<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->

<%

'sub comprobar_envio_email_stock(codigo_sap_articulo, descripcion_articulo, stock_articulo, stock_minimo_articulo, marca_articulo)

'end sub


	if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
	end if
		
	
	pedido_seleccionado=Request.Form("ocultonumero_pedido_cambiar")
	nuevo_estado=Request.Form("ocultonuevo_estado_pedido")
	marca_articulos=Request.Form("ocultomarca_cambio")
	
					
	'response.write("<br>articulos: " & articulos_pedido)
	'response.write("<br>marca: " & Request.Form("ocultomarca_cambio"))
	
	'response.write("<br>pedido..." & pedido_seleccionado)
	'response.write("<br>cadena articulos..." & articulos_pedido)
	'response.write("<br>cadena articulos..." & Request.Form("ocultoarticulos_pedido"))
   	
	
	
	'response.write("<br>hola...")
	'como hay que tocar varias cosas de la base de datos, ponemos una transaccion
	connimprenta.BeginTrans 'Comenzamos la Transaccion
	
	set datos_estado_antiguo=Server.CreateObject("ADODB.Recordset")

	estado_antiguo=""
	with datos_estado_antiguo
		.ActiveConnection=connimprenta
		cadena_ejecucion="SELECT * FROM PEDIDOS"
		cadena_ejecucion=cadena_ejecucion & " WHERE ID=" & pedido_seleccionado
		.Source=cadena_ejecucion
		'response.write("<br>se ve a que estado se ha de poner el pedido: " & .source)
		.Open
	end with
	
	if not datos_estado_antiguo.eof then
		estado_antiguo=datos_estado_Antiguo("estado")
	
	end if
	
	datos_estado_antiguo.close
	set datos_estado_antiguo=Nothing
	
	'si hay diferencia entre el estado antiguo y el nuevo
	if estado_antiguo<>nuevo_estado then
		cadena_ejecucion="UPDATE PEDIDOS SET ESTADO='" & nuevo_estado & "'"
		IF nuevo_estado="ENVIADO" THEN
			cadena_ejecucion=cadena_ejecucion & ", FECHA_ENVIADO='" & date() & "'" 
		END IF
		cadena_ejecucion=cadena_ejecucion & " WHERE PEDIDOS.ID=" & pedido_seleccionado
		'RESPONSE.WRITE("<br><BR>actualizacion del estado del pedido: " & CADENA_EJECUCION)
		
		'porque el sql de produccion es un sql expres que debe tener el formato de
		' de fecha con mes-dia-año
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
			
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
		
		'Actualizamos los detalles del pedido
		cadena_ejecucion="UPDATE PEDIDOS_DETALLES SET ESTADO='" & nuevo_estado & "'"
		cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado
		cadena_ejecucion=cadena_ejecucion & " AND ESTADO<>'" & nuevo_estado & "'"
		'RESPONSE.WRITE("<BR><br>actualizacion detalle pedido: " & CADENA_EJECUCION)
			
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
	
		
		'restamos el stock si procede
		'primero los articulos normales del pedido
		'y depues los kits, restando el stock no del kit (que no tiene)
		' sino de los stocks de cada uno de los articulos que componen el kit
		
		cadena_ejecucion="UPDATE ARTICULOS_MARCAS SET STOCK = "
		cadena_ejecucion=cadena_ejecucion & " CASE "
		cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - A.CANTIDAD"
		cadena_ejecucion=cadena_ejecucion & " ELSE null"
		cadena_ejecucion=cadena_ejecucion & " END"
		
		cadena_ejecucion=cadena_ejecucion & " FROM ARTICULOS_MARCAS INNER JOIN"
		cadena_ejecucion=cadena_ejecucion & " (SELECT * FROM PEDIDOS_DETALLES"
		cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado
		cadena_ejecucion=cadena_ejecucion & " AND ESTADO='ENVIADO'"
		cadena_ejecucion=cadena_ejecucion & " AND (RESTADO_STOCK IS NULL OR RESTADO_STOCK = '' OR RESTADO_STOCK = 'NO')) AS A"
		cadena_ejecucion=cadena_ejecucion & " ON ARTICULOS_MARCAS.ID_ARTICULO=A.ARTICULO"
		cadena_ejecucion=cadena_ejecucion & " WHERE ARTICULOS_MARCAS.MARCA='" & marca_articulos & "'"
		cadena_ejecucion=cadena_ejecucion & " AND ARTICULOS_MARCAS.STOCK IS NOT NULL"
		
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
		
		
		'AHORA RESTAMOS LOS STOCKS DE LOS KITS
		cadena_ejecucion="UPDATE ARTICULOS_MARCAS SET STOCK = "
		cadena_ejecucion=cadena_ejecucion & " CASE "
		cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - (A.CANTIDAD * A.CANTIDAD_RESTAR)"
		cadena_ejecucion=cadena_ejecucion & " ELSE null"
		cadena_ejecucion=cadena_ejecucion & " END"
		
		cadena_ejecucion=cadena_ejecucion & " FROM ARTICULOS_MARCAS INNER JOIN"
		cadena_ejecucion=cadena_ejecucion & " (SELECT PEDIDOS_DETALLES.*, CONFIGURACION_KITS.CODIGO_ARTICULO,"
		cadena_ejecucion=cadena_ejecucion & " CONFIGURACION_KITS.CANTIDAD AS CANTIDAD_RESTAR"
		cadena_ejecucion=cadena_ejecucion & " FROM PEDIDOS_DETALLES"
		cadena_ejecucion=cadena_ejecucion & " INNER JOIN CONFIGURACION_KITS"
		cadena_ejecucion=cadena_ejecucion & " ON ARTICULO = CONFIGURACION_KITS.CODIGO_KIT"

		cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado
		cadena_ejecucion=cadena_ejecucion & " AND ESTADO='ENVIADO'"
		cadena_ejecucion=cadena_ejecucion & " AND (RESTADO_STOCK IS NULL OR RESTADO_STOCK = '' OR RESTADO_STOCK = 'NO')) AS A"
		cadena_ejecucion=cadena_ejecucion & " ON ARTICULOS_MARCAS.ID_ARTICULO=A.CODIGO_ARTICULO"
		cadena_ejecucion=cadena_ejecucion & " WHERE ARTICULOS_MARCAS.MARCA='" & marca_articulos & "'"
		cadena_ejecucion=cadena_ejecucion & " AND ARTICULOS_MARCAS.STOCK IS NOT NULL"
		
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
		



		'esto ya no hace falta, PERO POR SI ACASO solo se resta cuando el pedido se pone enviado
		' en el estado de enviado no se puede modificar
		'para que solo se reste del stock una vez
		cadena_ejecucion="UPDATE PEDIDOS_DETALLES SET RESTADO_STOCK='SI'"
		cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado
		cadena_ejecucion=cadena_ejecucion & " AND ESTADO='ENVIADO'"
		cadena_ejecucion=cadena_ejecucion & " AND (RESTADO_STOCK IS NULL OR RESTADO_STOCK = '' OR RESTADO_STOCK = 'NO')"
		'RESPONSE.WRITE("<BR>marcamos restado stock a si: " & CADENA_EJECUCION)
		
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
			
			
		'aqui controlamos si tenemos que mandar el emial de stock roto....
		IF nuevo_estado="ENVIADO" THEN
			set control_email=Server.CreateObject("ADODB.Recordset")
		
				with control_email
					.ActiveConnection=connimprenta
	
	
	
	
					'como ahora podemos tener kits de articulos, buscamos el stock del articulo normal
					'y tambien el stock de todos los articulos que componen el posible kit
					cadena_ejecucion="SELECT ARTICULOS_MARCAS.*, ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION"
					cadena_ejecucion=cadena_ejecucion & " FROM ARTICULOS_MARCAS INNER JOIN ARTICULOS"
					cadena_ejecucion=cadena_ejecucion & " ON ARTICULOS_MARCAS.ID_ARTICULO = ARTICULOS.ID"
					cadena_ejecucion=cadena_ejecucion & " WHERE ARTICULOS_MARCAS.ID_ARTICULO IN"
					cadena_ejecucion=cadena_ejecucion & " (SELECT ARTICULO FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_seleccionado & ")"
					
					cadena_ejecucion=cadena_ejecucion & " AND ARTICULOS_MARCAS.MARCA='" & marca_articulos & "'"
					cadena_ejecucion=cadena_ejecucion & " AND ARTICULOS_MARCAS.STOCK IS NOT NULL"
					
					cadena_ejecucion=cadena_ejecucion & " UNION"
					
					'ahora buscamos el stock de los articulos que comprodrian el supuesto kit
					cadena_ejecucion=cadena_ejecucion & " SELECT ARTICULOS_MARCAS.*, ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION"
					cadena_ejecucion=cadena_ejecucion & " FROM ARTICULOS_MARCAS INNER JOIN ARTICULOS"
					cadena_ejecucion=cadena_ejecucion & " ON ARTICULOS_MARCAS.ID_ARTICULO = ARTICULOS.ID"
					cadena_ejecucion=cadena_ejecucion & " WHERE ARTICULOS_MARCAS.ID_ARTICULO IN"
					cadena_ejecucion=cadena_ejecucion & " (SELECT CODIGO_ARTICULO FROM CONFIGURACION_KITS"
					cadena_ejecucion=cadena_ejecucion & " WHERE CODIGO_KIT IN"
					cadena_ejecucion=cadena_ejecucion & " (SELECT ARTICULO FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_seleccionado & "))"
					cadena_ejecucion=cadena_ejecucion & " AND ARTICULOS_MARCAS.MARCA='" & marca_articulos & "'"
					cadena_ejecucion=cadena_ejecucion & " AND ARTICULOS_MARCAS.STOCK IS NOT NULL"
					
					
					.Source=cadena_ejecucion
					'response.write("<br>- CONSULTA REALIZADA: " & .source)
					.Open
				end with
				
				
				while not control_email.eof
					'RESPONSE.WRITE("<BR>- HAY REGISTRO EN ARTICULOS_MARCAS")
					'RESPONSE.WRITE("<BR>- STOCK ACTUAL: " & control_email("stock") & " -- STOCK MINIMO: " & control_email("stock_minimo"))
					'si llegamos al stock mimino, enviamos el email
					IF control_email("stock")<=control_email("stock_minimo") then
						'response.write("<br><br>envio email stock------" & control_email("codigo_sap") & " - " & control_email("descripcion") & " - " & control_email("stock") & " - " & control_email("stock_minimo") & " - " & marca_articulos)
	
						'no se mandan emails con la rotura de stock
						'comprobar_envio_email_stock control_email("codigo_sap"), control_email("descripcion"), (control_email("stock")), control_email("stock_minimo"), marca_articulos
						'response.write("<br>seguimos")
					end if
					control_email.movenext
				wend
	
				control_email.close
				set control_email = Nothing	
				
		end if 'nuevo_estado="ENVIADO"
		
		
	end if
	
	
	
		
		
	
		
	
	
	connimprenta.CommitTrans ' finaliza la transaccion






   	
			   
   	'connimprenta.BeginTrans 'Comenzamos la Transaccion
	'connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
	
	'connimprenta.CommitTrans ' finaliza la transaccion
	
	
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pedido</TITLE>
</HEAD>
<script language="javascript">
function validar(sucursal)
{
	alert('El Pedido Ha sido Modificado con Exito...');
	document.getElementById('ocultopedido').value=<%=pedido_seleccionado%>
	document.getElementById('frmmostrar_pedido').submit()	
	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

   
<BODY onload="validar()">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>
<form name="frmmostrar_pedido" id="frmmostrar_pedido" action="Pedido_Admin.asp" method="post">
	<input type="hidden" value="" name="ocultopedido" id="ocultopedido" />
</form>
</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
