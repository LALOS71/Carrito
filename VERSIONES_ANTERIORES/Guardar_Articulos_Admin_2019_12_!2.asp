<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->


<%

		if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
		end if
		
		
		accion=Request.Form("ocultoaccion")
		articulo_seleccionado=Request.Form("ocultoarticulo")
		cambio_compromiso_compra=Request.Form("oculto_cambio_compromiso_compra")
		pestanna_vuelta=Request.Form("oculto_pestanna_vuelta")
		                              
		
		'response.write("<br>cambio_compromiso_compra: " & cambio_compromiso_compra)
		'response.write("<br>hotel: " & hotel_seleccionado)
		'response.write("<br>poblacion: " & Request.Form("txtpoblacion"))
		'response.write("<br>pestanna vuelta al guardar: " & pestanna_vuelta)

		if accion="MODIFICAR" then 'aqui modificamos articulos
					
					cadena_ejecucion="UPDATE ARTICULOS SET"
					'cadena_ejecucion=cadena_ejecucion & " CODIGO_EMPRESA='" & Request.Form("cmbempresas") & "'"
					if Request.Form("txtcodigo_sap")<>"" then
						cadena_ejecucion=cadena_ejecucion & " CODIGO_SAP = '" & Request.Form("txtcodigo_sap") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " CODIGO_SAP = NULL"
					end if
					if Request.Form("txtdescripcion")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , DESCRIPCION = '" & Request.Form("txtdescripcion") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , DESCRIPCION = NULL"
					end if
					if Request.Form("txttamanno")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , TAMANNO = '" & Request.Form("txttamanno") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , TAMANNO = NULL"
					end if
					if Request.Form("txttamanno_abierto")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , TAMANNO_ABIERTO = '" & Request.Form("txttamanno_abierto") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , TAMANNO_ABIERTO = NULL"
					end if
					if Request.Form("txttamanno_cerrado")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , TAMANNO_CERRADO = '" & Request.Form("txttamanno_cerrado") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , TAMANNO_CERRADO = NULL"
					end if
					if Request.Form("txtpapel")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , PAPEL = '" & Request.Form("txtpapel") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , PAPEL = NULL"
					end if
					if Request.Form("txttintas")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , TINTAS = '" & Request.Form("txttintas") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , TINTAS = NULL"
					end if
					if Request.Form("txtmaterial")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , MATERIAL = '" & Request.Form("txtmaterial") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , MATERIAL = NULL"
					end if
					if Request.Form("txtacabado")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , ACABADO = '" & Request.Form("txtacabado") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , ACABADO = NULL"
					end if
					if Request.Form("txtunidades_pedido")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , UNIDADES_DE_PEDIDO = '" & Request.Form("txtunidades_pedido") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , UNIDADES_DE_PEDIDO = NULL"
					end if
					if Request.Form("txtpacking")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , PACKING = '" & Request.Form("txtpacking") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , PACKING = NULL"
					end if
					if Request.Form("txtfecha")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , FECHA = '" & Request.Form("txtfecha") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , FECHA = NULL"
					end if
					if Request.Form("cmbcompromiso_de_compra")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , COMPROMISO_COMPRA = '" & Request.Form("cmbcompromiso_de_compra") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , COMPROMISO_COMPRA = NULL"
					end if
					if Request.Form("cmbmostrar")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , MOSTRAR = '" & Request.Form("cmbmostrar") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , MOSTRAR = NULL"
					end if
					if Request.Form("cmbfacturable")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , FACTURABLE = '" & Request.Form("cmbfacturable") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , FACTURABLE = NULL"
					end if
					if Request.Form("cmbeliminado")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , BORRADO = '" & Request.Form("cmbeliminado") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , BORRADO = NULL"
					end if
					if Request.Form("cmbautorizacion")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , REQUIERE_AUTORIZACION = '" & Request.Form("cmbautorizacion") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , REQUIERE_AUTORIZACION = NULL"
					end if
					if Request.Form("cmbrappel")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , RAPPEL = '" & Request.Form("cmbrappel") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , RAPPEL = NULL"
					end if
					if Request.Form("txtprecio_coste")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , PRECIO_COSTE = REPLACE('" & Request.Form("txtprecio_coste") & "', ',', '.')"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , PRECIO_COSTE = NULL"
					end if
					if Request.Form("cmbproveedores")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , PROVEEDOR = " & Request.Form("cmbproveedores")
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , PROVEEDOR = NULL"
					end if
					if Request.Form("txtreferencia_del_proveedor")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , REFERENCIA_DEL_PROVEEDOR = '" & Request.Form("txtreferencia_del_proveedor") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , REFERENCIA_DEL_PROVEEDOR = NULL"
					end if
					
					cadena_ejecucion=cadena_ejecucion & " WHERE ARTICULOS.ID=" & articulo_seleccionado
					'response.write("<br>" & cadena_ejecucion)
					connimprenta.BeginTrans 'Comenzamos la Transaccion
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					
					'Ahora modificamos las empresas asociadas al artículo...
					'borramos lo que habia previamente y grabamos lo que venga de la ficha del articulo
					cadena_ejecucion="DELETE FROM ARTICULOS_EMPRESAS WHERE ID_ARTICULO=" & articulo_seleccionado
					'response.write("<br>" & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

					'ahora añadimos las empresas y familias asociadas al articulo
					For Each elemento In Request.Form
						If InStr(1, elemento, "cmbfamilias_") > 0 Then 
							fieldname = elemento
							fieldvalue = Request.Form(elemento)
							if fieldvalue<>"" then
								parte_empresa=""
								cadena_partida=split(fieldname, "_")
								nombre_control=cadena_partida(0)
								parte_empresa=cadena_partida(1)
								'Response.Write fieldname & " = " & fieldvalue & " empresa: " &  parte_empresa & "<br>" 
								
								cadena_campos=""
								cadena_campos="ID_ARTICULO, CODIGO_EMPRESA, FAMILIA"
									
								cadena_valores=""
								cadena_valores=articulo_seleccionado & ", " & parte_empresa & ", " & fieldvalue
								cadena_ejecucion="Insert into ARTICULOS_EMPRESAS (" & cadena_campos & ") values(" & cadena_valores & ")"
								connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords     
							end if
							'Response.Write fieldname & " = " & fieldvalue & " empresa: " &  parte_empresa & "<br>"  
						end if
						     
					Next 
					
					
					
					'Si se ha cambiado el Compromiso de Compra del artíulo, eliminamos los precios que se hayan 
					'dado de alta hasta ahora para no tener duplicados...
					if cambio_compromiso_compra&""="S" then
						cadena_ejecucion="DELETE FROM CANTIDADES_PRECIOS WHERE CODIGO_ARTICULO=" & articulo_seleccionado
						'response.write("<br>" & cadena_ejecucion)
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					end if					
					
					
						
	
	
					
					'ponemos un control, primero vemos que stock hay
						set comprobar_stock_actual=Server.CreateObject("ADODB.Recordset")
						historico_stock_actual=0
						with comprobar_stock_actual
							.ActiveConnection=connimprenta
							.Source="SELECT STOCK FROM ARTICULOS_MARCAS"
							.Source= .Source & " WHERE ID_ARTICULO=" & articulo_seleccionado
							.Source= .Source & " AND MARCA='STANDARD'"
							'response.write("<br>" & .source)
							.Open
						end with
						if not comprobar_stock_actual.eof then
							historico_stock_actual="" & comprobar_stock_actual("stock")
						end if
						comprobar_stock_actual.close
						set comprobar_stock_actual=nothing
						


					'ahora vamos con el control de stocks
					'borramos lo que habia previamente y grabamos lo que venga de la ficha del articulo
					'cadena_ejecucion="DELETE FROM ARTICULOS_MARCAS WHERE ID_ARTICULO=" & articulo_seleccionado
					'response.write("<br>" & cadena_ejecucion)
					'connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					
					'CONTROLAMOS EL STOCK MINIMO
					
						stock_minimo_marca=Request.Form("txtstock_minimo")
						if stock_minimo_marca="" then
							stock_minimo_marca="NULL"
						end if

						
					set control_stock_minimo=Server.CreateObject("ADODB.Recordset")
					with control_stock_minimo
							.ActiveConnection=connimprenta
							.Source="SELECT * FROM ARTICULOS_MARCAS"
							.Source= .Source & " WHERE ID_ARTICULO=" & articulo_seleccionado
							.Source= .Source & " AND MARCA='STANDARD'"
							'response.write("<br>" & .source)
							.Open
					end with
					if not control_stock_minimo.eof then ' es una modificacion
						cadena_ejecucion="UPDATE ARTICULOS_MARCAS"
						cadena_ejecucion=cadena_ejecucion & " SET STOCK_MINIMO=" & stock_minimo_marca
						cadena_ejecucion=cadena_ejecucion & " WHERE ID_ARTICULO=" & articulo_seleccionado
						cadena_ejecucion=cadena_ejecucion & " AND MARCA='STANDARD'"
					  else
						
						
						cadena_campos="ID_ARTICULO, MARCA, STOCK_MINIMO"
						cadena_valores=articulo_seleccionado & ", 'STANDARD'"
						if stock_minimo_marca="" then
							cadena_valores=cadena_valores & ", NULL"
						else
							cadena_valores=cadena_valores & ", " & stock_minimo_marca
						end if
						cadena_ejecucion="INSERT INTO ARTICULOS_MARCAS (" & cadena_campos & ") VALUES(" & cadena_valores & ")"		
								
					end if
					'response.write("<br>" & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

					control_stock_minimo.close
					set control_stock_minimo=Nothing
						
						if historico_stock_actual<>stock_marca then
							'metemos la linea de control de stock en el historico
							if  historico_stock_actual="" then
								 historico_stock_actual="NULL"
							end if
							if stock_marca="" THEN
								stock_marca="NULL"
							END IF
							cadena_historico="INSERT INTO HISTORICO_STOCKS (FECHA, PEDIDO, ARTICULO, CANTIDAD, STOCK_ACTUAL, STOCK_NUEVO, PROCEDENCIA)"
							cadena_historico=cadena_historico & " VALUES (GETDATE(), NULL, " & articulo_seleccionado
							cadena_historico=cadena_historico & ", NULL, " & historico_stock_actual 
							cadena_historico=cadena_historico & ", " & stock_marca & ", 'Guardar_Articulos_Admin - Mod. STOCK')"
							'response.write("<br>" & cadena_historico)
							connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
							connimprenta.Execute cadena_historico,,adCmdText + adExecuteNoRecords
						END IF						
					
					set marcas_articulo=Nothing
					
					
					
					connimprenta.CommitTrans ' finaliza la transaccion
					
			
					mensaje_aviso="El Articulo Ha Sido Modificado Con Exito..."			
					articulo_vuelta=articulo_seleccionado
					
			else
				if accion="ALTA" then
					'cadena_campos="CODIGO_EMPRESA, CODIGO_SAP, DESCRIPCION, TAMANNO, TAMANNO_ABIERTO, TAMANNO_CERRADO, PAPEL, "
					cadena_campos="CODIGO_SAP, DESCRIPCION, TAMANNO, TAMANNO_ABIERTO, TAMANNO_CERRADO, PAPEL, "
					cadena_campos=cadena_campos & " TINTAS, MATERIAL, ACABADO, UNIDADES_DE_PEDIDO, PACKING, FECHA, COMPROMISO_COMPRA,"
					cadena_campos=cadena_campos & " MOSTRAR, FACTURABLE, BORRADO, REQUIERE_AUTORIZACION,"
					cadena_campos=cadena_campos & " RAPPEL, PRECIO_COSTE, PROVEEDOR, REFERENCIA_DEL_PROVEEDOR"  
					
					cadena_valores=""
					if Request.Form("txtcodigo_sap")<>"" then
						cadena_valores=cadena_valores & "'" & Request.Form("txtcodigo_sap") & "'"
					  else
					  	cadena_valores=cadena_valores & "NULL"
					end if
					if Request.Form("txtdescripcion")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txtdescripcion") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txttamanno")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txttamanno") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txttamanno_abierto")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txttamanno_abierto") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txttamanno_cerrado")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txttamanno_cerrado") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txtpapel")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txtpapel") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txttintas")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txttintas") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txtmaterial")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txtmaterial") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txtacabado")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txtacabado") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txtunidades_pedido")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txtunidades_pedido") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txtpacking")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txtpacking") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txtfecha")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txtfecha") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("cmbcompromiso_de_compra")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("cmbcompromiso_de_compra") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("cmbmostrar")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("cmbmostrar") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("cmbfacturable")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("cmbfacturable") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("cmbeliminado")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("cmbeliminado") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("cmbautorizacion")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("cmbautorizacion") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("cmbrappel")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("cmbrappel") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txtprecio_coste")<>"" then
						cadena_valores=cadena_valores & ", REPLACE('" & Request.Form("txtprecio_coste") & "', ',', '.')"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("cmbproveedores")<>"" then
						cadena_valores=cadena_valores & ", " & Request.Form("cmbproveedores")
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					if Request.Form("txtreferencia_del_proveedor")<>"" then
						cadena_valores=cadena_valores & ", '" & Request.Form("txtreferencia_del_proveedor") & "'"
					  else
					  	cadena_valores=cadena_valores & ", NULL"
					end if
					
					
					connimprenta.BeginTrans 'Comenzamos la Transaccion
					cadena_ejecucion="INSERT INTO ARTICULOS (" & cadena_campos & ") values(" & cadena_valores & ")"
					'response.write("<br>" & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					'me quedo con el nuevo numero introducido
					Set valor_nuevo = connimprenta.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
					numero_articulo_nuevo=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
					valor_nuevo.Close
					Set valor_nuevo = Nothing
				
					'ahora añadimos las empresas y familias asociadas al articulo
					For Each elemento In Request.Form
						If InStr(1, elemento, "cmbfamilias_") > 0 Then 
							fieldname = elemento
							fieldvalue = Request.Form(elemento)
							if fieldvalue<>"" then
								parte_empresa=""
								cadena_partida=split(fieldname, "_")
								nombre_control=cadena_partida(0)
								parte_empresa=cadena_partida(1)
								'Response.Write fieldname & " = " & fieldvalue & " empresa: " &  parte_empresa & "<br>" 
								
								cadena_campos=""
								cadena_campos="ID_ARTICULO, CODIGO_EMPRESA, FAMILIA"
									
								cadena_valores=""
								cadena_valores=numero_articulo_nuevo & ", " & parte_empresa & ", " & fieldvalue
								cadena_ejecucion="Insert into ARTICULOS_EMPRESAS (" & cadena_campos & ") values(" & cadena_valores & ")"
								connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords     
							end if
							'Response.Write fieldname & " = " & fieldvalue & " empresa: " &  parte_empresa & "<br>"  
						end if
						     
					Next 
					
					
					
					'CONTROLAMOS EL STOCK MINIMO
					stock_minimo_marca=Request.Form("txtstock_minimo")
					
					cadena_campos="ID_ARTICULO, MARCA, STOCK_MINIMO"
					cadena_valores=numero_articulo_nuevo & ", 'STANDARD'"
					if stock_minimo_marca="" then
						cadena_valores=cadena_valores & ", NULL"
					else
						cadena_valores=cadena_valores & ", " & stock_minimo_marca
					end if
					cadena_ejecucion="INSERT INTO ARTICULOS_MARCAS (" & cadena_campos & ") VALUES(" & cadena_valores & ")"		
								
					'response.write("<br>" & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

					
					connimprenta.CommitTrans ' finaliza la transaccion
			
					mensaje_aviso="El Articulo Ha Sido Dado de Alta Con Exito..."			
					articulo_vuelta=numero_articulo_nuevo	
				end if
		end if
		
		
		
		
		
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pedido</TITLE>


<link rel="stylesheet" type="text/css" href="plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	
<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>

<script language="javascript">
function validar(mensaje,articulo)
{
	//alert(mensaje);
	bootbox.alert({
				//size: 'large',
				message: mensaje,
				callback: function () {
					mostrar_articulo(articulo)
					}
			})
	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}


mostrar_articulo = function (articulo) 
   {
   	//alert('hotel: ' + hotel + ' accion: ' + accion)
   	document.getElementById('ocultoid_articulo').value=articulo
	document.getElementById('ocultoaccion').value='MODIFICAR'
	document.getElementById('ocultoempresas').value='Sin Filtro'
	document.getElementById('ocultofamilias').value='Sin Filtro'
	document.getElementById('ocultoautorizacion').value='Sin Filtro'
	document.getElementById('ocultopestanna_vuelta').value='<%=pestanna_vuelta%>'
	document.getElementById('frmmostrar_articulo').action='Ficha_Articulo_Admin.asp'	

   	document.getElementById('frmmostrar_articulo').submit()	
   }

</script>
</HEAD>
   
<BODY onload="validar('<%=mensaje_aviso%>',<%=articulo_vuelta%>)">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>
<form name="frmmostrar_articulo" id="frmmostrar_articulo" action="Ficha_Articulo_Admin.asp" method="post">
	<input type="hidden" value="" name="ocultoid_articulo" id="ocultoid_articulo" />
	<input type="hidden" value="" name="ocultoaccion" id="ocultoaccion" />
	<input type="hidden" value="" name="ocultoempresas" id="ocultoempresas" />
	<input type="hidden" value="" name="ocultofamilias" id="ocultofamilias" />
	<input type="hidden" value="" name="ocultoautorizacion" id="ocultoautorizacion" />
	<input type="hidden" value="" name="ocultopestanna_vuelta" id="ocultopestanna_vuelta" />
	
</form>

</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
