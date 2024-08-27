﻿<%@ language=vbscript %>
<!DOCTYPE html>
<!--#include file="Conexion.inc"-->
<!--#include file="Envio_Mails_CDO/Envio_Mail.inc"-->


<%

Response.CharSet = "UTF-8"

sub comprobar_envio_email_stock(codigo_sap_articulo, descripcion_articulo, stock_articulo, stock_minimo_articulo, marca_articulo)


	'ENVIAMOS EL CORREO ELECTRONICO
	de = "carlos.gonzalez@globalia-artesgraficas.com"
	para = "malba@globalia-artesgraficas.com" 		  	
	asunto = "ROTURA DE STOCK ARTICULO " & codigo_sap_articulo
   
	mensaje="ROTURA DE STOCK DEL ARTICULO:<BR>"
	mensaje=mensaje & "<BR>Codigo Sap: " & codigo_sap_articulo
	mensaje=mensaje & "<BR>Descripción Articulo: " & descripcion_articulo
	mensaje=mensaje & "<BR>Stock Actual (" & marca_articulo & "): " & stock_articulo
	mensaje=mensaje & "<BR>Stock Minimo Establecido (" & marca_articulo & "): " & stock_minimo_articulo
		
	adjunto= ""
	servidor = "GLOBALIA"
	
	'para que no llegue el aviso de rotura de stock
	'respuesta_envio = envio_email(de, para, asunto, mensaje, adjunto, servidor)

end sub






	
    if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
	end if
		
	
		
		
	pedido_seleccionado=Request.Form("ocultopedido")
	articulos_cantidades_pedido=Request.Form("ocultoarticulos_cantidades_pedido")
	marca_articulos=Request.Form("ocultomarca")
	acciones=Request.Form("ocultoacciones")
	codcli=Request.Form("ocultocodcli")
	direccion_envio=Request.Form("ocultoDireccion")
	descuento_pedido="" & Request.Form("ocultodescuento_pedido")
	gastos_envio=Request.Form("ocultogastos_envio")
	datos_saldos=Request.Form("ocultodatos_saldos")
	datos_devoluciones=Request.Form("ocultodatos_devoluciones")
	observaciones=Request.Form("txtobservaciones")
	
	bultos="" & Request.Form("ocultobultos")
	palets="" & Request.Form("ocultopalets")
	peso="" & Request.Form("ocultopeso")
	sn_impresoras ="" & Request.Form("ocultosn_impresoras")
	'''response.write("<br>numeros de serie de las impresoras: " & sn_impresoras)
	'''response.write("<br>articulos: " & articulos_pedido)
	'''response.write("<br>CANTIDADES: " & articulos_cantidades_pedido)
	
	'''response.write("<br>pedido..." & pedido_seleccionado)
	'''response.write("<br>cadena articulos..." & articulos_pedido)
	'''response.write("<br>cadena articulos..." & Request.Form("ocultoarticulos_pedido"))
   	tabla_articulos_cantidades=Split(articulos_cantidades_pedido,"--")
	
	'para controlar si hay que mandarle un email al proveedor por ser un pedido de rotulacion
	enviar_email_al_proveedor="NO"
	
	
	observaciones_sn_impresoras=""
	
	hay_impresora_activa= "NO"
	sn_impresora_activa = ""
	
	''response.write("<BR>---------------------------------------------------<br>1 -------------------- COMENTAMOS LA TRANSACCION CONNIMPRENTA...")
	'como hay que tocar varias cosas de la base de datos, ponemos una transaccion
	connimprenta.BeginTrans 'Comenzamos la Transaccion
	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	
	if observaciones<>"" then	
		
		cadena_historico = "INSERT INTO PEDIDOS_OBSERVACIONES (PEDIDO, FECHA, OBSERVACIONES)"
		cadena_historico = cadena_historico & " SELECT " & pedido_seleccionado & ", GETDATE(), '"
		cadena_historico = cadena_historico & observaciones & "'" 
						
		''response.write("<br>2 - insertamos observaciones al pedido: '" & cadena_historico)
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
		connimprenta.Execute cadena_historico,,adCmdText + adExecuteNoRecords
	end if
	
	For i = 0 to UBound(tabla_articulos_cantidades)
   		''response.write("<BR>--------------------------------------<br>3 ------ DANDO VUELTAS EN EL FOR ... articulo numero " & i & ": " & tabla_articulos_cantidades(i))
		'campo="cmbestados_" & tabla_articulos_cantidades(i)
		
		'ahora separo cada articulo, de su cantidad, y si se ha restado ya del stock o no...
		articulo_cantidad=Split(tabla_articulos_cantidades(i),"::")
		''response.write("<BR>COMBO ESTADO: " & Request.Form("cmbestados_" & articulo_cantidad(0))) 

		cadena_ejecucion="UPDATE PEDIDOS_DETALLES SET ESTADO='" & Request.Form("cmbestados_" & articulo_cantidad(0)) & "', HOJA_RUTA='"
		cadena_ejecucion=cadena_ejecucion & Request.Form("txthoja_ruta_" & articulo_cantidad(0)) & "'"
		cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado & " AND ARTICULO=" & articulo_cantidad(0)
		'response.write("<BR><br>-4- actualizacion detalle pedido: " & CADENA_EJECUCION)
		
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
		
		''response.write("<br>CAantidad almacenada en ocultocantidad_enviada_total_" & articulo_cantidad(0) & ": " & request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0)))
		''response.write("<br>y tendriamos que enviar: " & articulo_cantidad(1))
		
		oculto_cantidad_enviada=request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))
		cantidad_pedido=articulo_cantidad(1)
		
		'metemos la linea de control de los detalles de pedidos
		cadena_historico="INSERT INTO HISTORICO_PEDIDOS (FECHA, PEDIDO, ARTICULO, CANTIDAD_ENVIADA, CANTIDAD_PEDIDA, ESTADO, PROCEDENCIA)"
		cadena_historico=cadena_historico & " VALUES (GETDATE()," & pedido_seleccionado & ", " & articulo_cantidad(0)
		loqueseenvia="NULL"
		''response.write("<br>ESTADO: " & Request.Form("cmbestados_" & articulo_cantidad(0)))
		''response.write("<br>OCULTO CANTIDAD ENVIADA: " & oculto_cantidad_enviada)
		''response.write("<br>CANTIDAD PEDIDO: " & cantidad_pedido)
		''response.write("<br>ARTICULO CANTIDAD(1): " & articulo_cantidad(1))

		if Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" THEN
			if oculto_cantidad_enviada<>"" then
				loqueseenvia=cantidad_pedido-oculto_cantidad_enviada
			  else
			  	loqueseenvia=articulo_cantidad(1)
			end if
		end if
		if Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" THEN
			''response.write("<br>LO QUE SE ENVIA EN ENVIO PARCIAL: " & Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0)))
			loqueseenvia=Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0))
		end if
		''response.write("<br>lo que se envia: " & loqueseenvia)
		
		IF loqueseenvia="" then
			loqueseenvia="NULL"
		END IF
		cadena_historico=cadena_historico & ", " & loqueseenvia & ", " & cantidad_pedido 
		cadena_historico=cadena_historico & ", '" & Request.Form("cmbestados_" & articulo_cantidad(0)) & "', 'Modificar_Pedido_Admin')"
		if Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" or Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" or Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO AL PROVEEDOR" THEN
			'response.write("<br>5 - insertamos en el historico de pedidos: " & cadena_historico)
			connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
			connimprenta.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		
		''response.write("<br>articulo-cantidad-restado stoch: " & tabla_articulos_cantidades(i))
		'si ya esta restado el stock previamente no lo tengo que volver a restar
		' Y SOLO TENGO EN CUENTA LOS MARCADOS COMO ENVIADOS o ENVIO PARCIAL a los que les falte enviar algo
		
		''response.write("<BR>ESTADO: " & Request.Form("cmbestados_" & articulo_cantidad(0)))
		''response.write("<BR>OCULTO CANTIDAD ENVIADA: " & Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0)))
		''response.write("<BR>OCULTO_CANTIDAD_ENVIADA: " & oculto_cantidad_enviada)
		''response.write("<BR>CANTIDAD PEDIDO: " & cantidad_pedido)
		''response.write("<BR>TXTCANTIDAD CANTIDAD A ENVIAR: " & Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0)))
		
		
		if ((articulo_cantidad(2)<>"SI" AND Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO") _
			OR (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" AND Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0))<>"") _
			OR (Request.Form("cmbestados_" & articulo_cantidad(0))="LISTO PARCIAL" AND Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0))<>"") _
			OR (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO AL PROVEEDOR") _
			OR (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
								AND cantidad_pedido<>oculto_cantidad_enviada) _
			OR (Request.Form("cmbestados_" & articulo_cantidad(0))="LISTO" AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
								AND cantidad_pedido<>oculto_cantidad_enviada) _
			) then
			
			''response.write("<br><br>hacemos gestiones con el articulo: " & articulo_cantidad(0))
			'vemos si el articulo, en realidad es un kit de varios articulos juntos
			set control_kit=Server.CreateObject("ADODB.Recordset")
					
			sql="SELECT * FROM CONFIGURACION_KITS"
			sql=sql & " WHERE CODIGO_KIT=" & articulo_cantidad(0)
			'response.write("<br>6 - consulta configuracion kits: " & sql)
																	
			with control_kit
				.ActiveConnection=connimprenta
				.CursorType=3 'adOpenStatic
				.Source=sql
				.Open
			end with
			
			if not control_kit.eof then
					'si el articulo es un kit de ariticulos, recorremos cada uno
					' de los articulos que componen el kit y restamos el stock
					
				'solo se resta stock si es un envio parcial o un enviado... el listo parcial no resta	
				IF Request.Form("cmbestados_" & articulo_cantidad(0))<>"LISTO PARCIAL" THEN
					
					while not control_kit.eof
						'ponemos un control, primero vemos que stock hay
						set comprobar_stock_actual=Server.CreateObject("ADODB.Recordset")
						historico_stock_actual=0
						with comprobar_stock_actual
							.ActiveConnection=connimprenta
							.Source="SELECT STOCK FROM ARTICULOS_MARCAS"
							.Source= .Source & " WHERE ID_ARTICULO=" & control_kit("CODIGO_ARTICULO")
							.Source= .Source & " AND MARCA='STANDARD'"
							'response.write("<br>7 - consulta stock de cada articulo del kit: " & .source)
							.Open
						end with
						if not comprobar_stock_actual.eof then
							historico_stock_actual=comprobar_stock_actual("stock")
						end if
						comprobar_stock_actual.close
						set comprobar_stock_actual=nothing
						
						historico_cantidad=0
					
					
					
						cadena_ejecucion="UPDATE ARTICULOS_MARCAS SET STOCK = "
						cadena_ejecucion=cadena_ejecucion & " CASE "
						'si es un envio parcial, resto solo la cantidad concreta que se envia, no todas las unidades pedidas
						IF (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL") _
						 THEN
							cantidad_parcial=Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0))
							cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & (cantidad_parcial * control_kit("cantidad"))
							historico_cantidad=cantidad_parcial * control_kit("cantidad")
						 ELSE
						 	IF (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
								AND cantidad_pedido<>oculto_cantidad_enviada) THEN
							 	cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & ((cantidad_pedido-oculto_cantidad_enviada) * control_kit("cantidad"))
								historico_cantidad=(cantidad_pedido-oculto_cantidad_enviada) * control_kit("cantidad")
							  ELSE
							  	cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & (articulo_cantidad(1) * control_kit("cantidad"))
								historico_cantidad=articulo_cantidad(1) * control_kit("cantidad")
							END IF
						END IF
						cadena_ejecucion=cadena_ejecucion & " ELSE null"
						cadena_ejecucion=cadena_ejecucion & " END"
						cadena_ejecucion=cadena_ejecucion & " WHERE ID_ARTICULO=" & control_kit("CODIGO_ARTICULO")
						cadena_ejecucion=cadena_ejecucion & " AND MARCA='STANDARD'"
						'response.write("<BR>8 - actualizacion del stock de articulos (KIT): " & CADENA_EJECUCION)
						
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
						
						'metemos la linea de control de stock en el historico
						cadena_historico="INSERT INTO HISTORICO_STOCKS (FECHA, PEDIDO, ARTICULO, CANTIDAD, STOCK_ACTUAL, STOCK_NUEVO, PROCEDENCIA)"
						cadena_historico=cadena_historico & " VALUES (GETDATE()," & pedido_seleccionado & ", " & control_kit("CODIGO_ARTICULO")
						if historico_cantidad<>"" then
							cadena_historico=cadena_historico & ", " & historico_cantidad 
						  else
						  	cadena_historico=cadena_historico & ", NULL" 
						end if
						
						if historico_stock_actual <>"" then
							cadena_historico=cadena_historico & ", " & historico_stock_actual 
						  else
						  	cadena_historico=cadena_historico & ", NULL" 
						end if
						if historico_cantidad<>"" and historico_stock_actual <>"" then
							cadena_historico=cadena_historico & ", " & (historico_stock_actual - historico_cantidad) & ", 'Modificar_Pedido_Admin - KIT')"
						  else
						  	cadena_historico=cadena_historico & ", NULL, 'Modificar_Pedido_Admin - KIT')"
						end if
						
						if Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" or Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO"  or Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO AL PROVEEDOR" THEN
							'response.write("<br>9 - insertamos en historico stocks: " & cadena_historico)
							connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
							connimprenta.Execute cadena_historico,,adCmdText + adExecuteNoRecords
							
							'mentemos la correspondiente salida de mercancia de la ficha del producto
							cadena_ejecucion_salida="INSERT INTO ENTRADAS_SALIDAS_ARTICULOS (ID_ARTICULO, E_S, FECHA, PEDIDO, CANTIDAD, ALBARAN, TIPO, FECHA_ALTA, IP)"
							cadena_ejecucion_salida=cadena_ejecucion_salida & " VALUES (" & control_kit("CODIGO_ARTICULO")
							cadena_ejecucion_salida=cadena_ejecucion_salida & " , 'SALIDA'"
							cadena_ejecucion_salida=cadena_ejecucion_salida & " , GETDATE()"
							cadena_ejecucion_salida=cadena_ejecucion_salida & " , " & pedido_seleccionado
							cadena_ejecucion_salida=cadena_ejecucion_salida & " , " & historico_cantidad
							cadena_ejecucion_salida=cadena_ejecucion_salida & " , NULL"
							cadena_ejecucion_salida=cadena_ejecucion_salida & " , 'PEDIDO'"
							cadena_ejecucion_salida=cadena_ejecucion_salida & " , getdate()"
							direccion_ip="" ' capturamos la ip para posibles controles posteriores
							if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
								direccion_ip=Request.ServerVariables("HTTP_X_FORWARDED_FOR")
							  else
								direccion_ip=Request.ServerVariables("REMOTE_ADDR")
							end if
							direccion_ip=Request.ServerVariables("REMOTE_ADDR")
							cadena_ejecucion_salida=cadena_ejecucion_salida & " , '" & direccion_ip & "')"
					
							'response.write("<br><br>10 - cadena entradas salidas del articulo: " & cadena_ejecucion)
							connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
							connimprenta.Execute cadena_ejecucion_salida,,adCmdText + adExecuteNoRecords
							
							
							
						end if
						
						control_kit.movenext
					wend
				end if ' de comprobar si esl estado es diferente de LISTO PARCIAL
				
					'si es un envio parcial, meto los datos que se envian en la tabla correspondiente						
						'***********OJO AQUI QUE ES UN KIT... A VER DE DONDE SE RESTA... CADA ARTICULO O EL KIT EN SI
						'********************
						IF Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" OR Request.Form("cmbestados_" & articulo_cantidad(0))="LISTO PARCIAL" THEN

							cadena_parcial="UPDATE PEDIDOS_ENVIOS_PARCIALES"
							cadena_parcial=cadena_parcial & " SET CANTIDAD_ENVIADA=CANTIDAD_ENVIADA + " & Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0)) 'cantidad_parcial
							cadena_parcial=cadena_parcial & ", FECHA='" & date() & "'"
							if Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL"  then
								cadena_parcial=cadena_parcial & ", ESTADO='ENVIO PARCIAL'"
							end if
							cadena_parcial=cadena_parcial & " WHERE ID_PEDIDO=" & pedido_seleccionado
							cadena_parcial=cadena_parcial & " AND ID_ARTICULO=" & articulo_cantidad(0)
							cadena_parcial=cadena_parcial & " AND ESTADO='LISTO PARCIAL'"
							cadena_parcial=cadena_parcial & " AND ALBARAN IS NULL"
 							cadena_parcial=cadena_parcial & " IF (@@ROWCOUNT = 0 )"
							cadena_parcial=cadena_parcial & " BEGIN"
							cadena_parcial=cadena_parcial & " INSERT INTO PEDIDOS_ENVIOS_PARCIALES (ID_PEDIDO, ID_ARTICULO, CANTIDAD_ENVIADA, FECHA, ESTADO)"
							cadena_parcial=cadena_parcial & " VALUES(" & pedido_seleccionado
							cadena_parcial=cadena_parcial & ", " & articulo_cantidad(0)
							cadena_parcial=cadena_parcial & ", " & Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0)) 'cantidad_parcial
							cadena_parcial=cadena_parcial & ", '" & date() & "'"
							cadena_parcial=cadena_parcial & ", '" & Request.Form("cmbestados_" & articulo_cantidad(0)) & "'"
							cadena_parcial=cadena_parcial & ")"
							cadena_parcial=cadena_parcial & " END"

						
							'porque el sql de produccion es un sql expres que debe tener el formato de
							' de fecha con mes-dia-año
							connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
						
							'response.write("<BR>11 - es un envio parcial DE KIT: " & CADENA_PARCIAL)
							connimprenta.Execute cadena_parcial,,adCmdText + adExecuteNoRecords
						  ELSE
							IF (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
								AND cantidad_pedido<>oculto_cantidad_enviada) THEN
				
								
								cadena_parcial="UPDATE PEDIDOS_ENVIOS_PARCIALES"
								cadena_parcial=cadena_parcial & " SET CANTIDAD_ENVIADA=CANTIDAD_ENVIADA + " & (cantidad_pedido-oculto_cantidad_enviada) 'cantidad_parcial QUE QUEDA
								cadena_parcial=cadena_parcial & ", FECHA='" & date() & "'"
								cadena_parcial=cadena_parcial & ", ESTADO='ENVIO PARCIAL'"
								cadena_parcial=cadena_parcial & " WHERE ID_PEDIDO=" & pedido_seleccionado
								cadena_parcial=cadena_parcial & " AND ID_ARTICULO=" & articulo_cantidad(0)
								cadena_parcial=cadena_parcial & " AND ESTADO='LISTO PARCIAL'"
								cadena_parcial=cadena_parcial & " AND ALBARAN IS NULL"
								cadena_parcial=cadena_parcial & " IF (@@ROWCOUNT = 0 )"
								cadena_parcial=cadena_parcial & " BEGIN"
								cadena_parcial=cadena_parcial & " INSERT INTO PEDIDOS_ENVIOS_PARCIALES (ID_PEDIDO, ID_ARTICULO, CANTIDAD_ENVIADA, FECHA, ESTADO)"
								cadena_parcial=cadena_parcial & " VALUES(" & pedido_seleccionado
								cadena_parcial=cadena_parcial & ", " & articulo_cantidad(0)
								cadena_parcial=cadena_parcial & ", " & (cantidad_pedido-oculto_cantidad_enviada) 'cantidad_parcial QUE QUEDA
								cadena_parcial=cadena_parcial & ", '" & date() & "'"
								cadena_parcial=cadena_parcial & ", 'ENVIO PARCIAL'"
								cadena_parcial=cadena_parcial & ")"
								cadena_parcial=cadena_parcial & " END"
							
								'porque el sql de produccion es un sql expres que debe tener el formato de
								' de fecha con mes-dia-año
								connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
						
								'response.write("<BR>12 - es un envio total de unos envios parciales DE KIT: " & CADENA_PARCIAL)
								connimprenta.Execute cadena_parcial,,adCmdText + adExecuteNoRecords
							END IF
						END IF
						
					
				else
					'si no es un kit, simplemente resta el stock del articulo		
					'ponemos un control, primero vemos que stock hay
					' y solo restamos el stock para los estados de enviado y envio parcial, para listo parcial no
					
					'response.write("<BR>13 - NO ES UN KIT")
					''response.write("<BR>VALOR DEL COMBO: " & Request.Form("cmbestados_" & articulo_cantidad(0)))
					pedido_con_rollo_impresora="NO"
					IF Request.Form("cmbestados_" & articulo_cantidad(0))<>"LISTO PARCIAL" THEN
						set comprobar_stock_actual=Server.CreateObject("ADODB.Recordset")
						historico_stock_actual=0
						with comprobar_stock_actual
							.ActiveConnection=connimprenta
							.Source="SELECT A.STOCK, B.ID, B.PEDIDO_AUTOMATICO"
							.Source= .Source & " FROM ARTICULOS_MARCAS A LEFT JOIN PEDIDOS B ON B.ID=" & pedido_seleccionado
							.Source= .Source & " WHERE A.ID_ARTICULO=" & articulo_cantidad(0)
							.Source= .Source & " AND A.MARCA='" & marca_articulos & "'"
							'response.write("<br>14 - VER STOCK: " & .source)
							.Open
						end with
						if not comprobar_stock_actual.eof then
							historico_stock_actual="" & comprobar_stock_actual("stock")
							'si piden una impresora de gls, tengo que controlarlo para ver si adicionalmente tengo que restar o no un rollo de etiquetas
							if articulo_cantidad(0)="4583" then
								if comprobar_stock_actual("PEDIDO_AUTOMATICO")= "IMPRESORA_GLS" or comprobar_stock_actual("PEDIDO_AUTOMATICO")= "IMPRESORA_GLS_ADMIN" then
									pedido_con_rollo_impresora="SI"
								end if
							end if
						end if
						comprobar_stock_actual.close
						set comprobar_stock_actual=nothing
						
						historico_cantidad=0
						
								
						cadena_ejecucion="UPDATE ARTICULOS_MARCAS SET STOCK = "
						'EN SQL SE PONE CASE....END, NO IFF
						'UPDATE ARTICULOS_MARCAS
						'       SET STOCK = CASE WHEN (STOCK >=0) THEN STOCK + 10 ELSE NULL END
						'WHERE ID_ARTICULO=4 AND MARCA='BARCELO'
						cadena_ejecucion=cadena_ejecucion & " CASE "
						'si es un envio parcial, resto solo la cantidad concreta que se envia, no todas las unidades pedidas
						IF Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" THEN
							cantidad_parcial=Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0))
							cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & cantidad_parcial
							historico_cantidad=cantidad_parcial
						 ELSE
							IF (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
									AND cantidad_pedido<>oculto_cantidad_enviada) THEN
										cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & (cantidad_pedido-oculto_cantidad_enviada)
										historico_cantidad=cantidad_pedido-oculto_cantidad_enviada
							  ELSE
								cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & articulo_cantidad(1)
								historico_cantidad=articulo_cantidad(1)
							END IF
						END IF
						cadena_ejecucion=cadena_ejecucion & " ELSE null"
						cadena_ejecucion=cadena_ejecucion & " END"
						
						'EN ACCESS NO FUNCIONA EL CASE... END, SINO EL IFF
						'cadena_ejecucion=cadena_ejecucion & " IIF(STOCK<>null, STOCK-" & articulo_cantidad(1) & ", null)"
						
						cadena_ejecucion=cadena_ejecucion & " WHERE ID_ARTICULO=" & articulo_cantidad(0)
						cadena_ejecucion=cadena_ejecucion & " AND MARCA='" & marca_articulos & "'"
						'y restaod estock si?
						'response.write("<BR><br>-15- actualizacion del stock de articulos: " & CADENA_EJECUCION)
						
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
						
						'metemos la linea de control de stock en el historico
						if historico_stock_actual="" then
							historico_stock_actual="NULL"
							resta_calculo="NULL"
						  else
							resta_calculo=(historico_stock_actual - historico_cantidad)
						END IF
						
						cadena_historico="INSERT INTO HISTORICO_STOCKS (FECHA, PEDIDO, ARTICULO, CANTIDAD, STOCK_ACTUAL, STOCK_NUEVO, PROCEDENCIA)"
						cadena_historico=cadena_historico & " VALUES (GETDATE()," & pedido_seleccionado & ", " & articulo_cantidad(0)
						cadena_historico=cadena_historico & ", " & historico_cantidad & ", " & historico_stock_actual 
						cadena_historico=cadena_historico & ", " & resta_calculo & ", 'Modificar_Pedido_Admin - UNICO')"
						
						if Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" or Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" or Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO AL PROVEEDOR" THEN
							'response.write("<br>16 - insertamos el historico del stock: " & cadena_historico)
							connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
							connimprenta.Execute cadena_historico,,adCmdText + adExecuteNoRecords
							
							
							'mentemos la correspondiente salida de mercancia de la ficha del producto
								cadena_ejecucion_salida="INSERT INTO ENTRADAS_SALIDAS_ARTICULOS (ID_ARTICULO, E_S, FECHA, PEDIDO, CANTIDAD, ALBARAN, TIPO, FECHA_ALTA, IP)"
								cadena_ejecucion_salida=cadena_ejecucion_salida & " VALUES (" & articulo_cantidad(0)
								cadena_ejecucion_salida=cadena_ejecucion_salida & " , 'SALIDA'"
								cadena_ejecucion_salida=cadena_ejecucion_salida & " , GETDATE()"
								cadena_ejecucion_salida=cadena_ejecucion_salida & " , " & pedido_seleccionado
								cadena_ejecucion_salida=cadena_ejecucion_salida & " , " & historico_cantidad
								cadena_ejecucion_salida=cadena_ejecucion_salida & " , NULL"
								cadena_ejecucion_salida=cadena_ejecucion_salida & " , 'PEDIDO'"
								cadena_ejecucion_salida=cadena_ejecucion_salida & " , getdate()"
								direccion_ip="" ' capturamos la ip para posibles controles posteriores
								
								'response.write("<br>HTTP_X_FORWARDED_FOR: " & Request.ServerVariables("HTTP_X_FORWARDED_FOR"))
								'response.write("<br>REMOTE_ADDR: " & Request.ServerVariables("REMOTE_ADDR"))
								if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
									direccion_ip=Request.ServerVariables("HTTP_X_FORWARDED_FOR")
								  else
									direccion_ip=Request.ServerVariables("REMOTE_ADDR")
								end if
								direccion_ip=Request.ServerVariables("REMOTE_ADDR")
								cadena_ejecucion_salida=cadena_ejecucion_salida & " , '" & direccion_ip & "')"
						
								'response.write("<br><br>17 - cadena entradas salidas articulos: " & cadena_ejecucion_salida)
								connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
								connimprenta.Execute cadena_ejecucion_salida,,adCmdText + adExecuteNoRecords
						end if
						
						'si es el caso concreto del articulo IMPRESORA PORTATIL ZQ521 DT
						'4583 - NLINF003 - IMPRESORA PORTATIL ZQ521 DT
						'si el pedido es de una impresora nueva ya sea porque la pide la oficina o porque la manda forzosamente la central de GLS
						'pedido automatico IMPRESORA_GLS o IMPRESORA_GLS_ADMIN
						'se manda tambien un rollo de etiquetas de las que hay que restar 1 del stock
						'4566 - NLOPE0704 - ETIQUETA PARA IMPRESORA PORTATIL
						if pedido_con_rollo_impresora="SI"then
							set comprobar_stock_actual=Server.CreateObject("ADODB.Recordset")
							historico_stock_actual=0
							with comprobar_stock_actual
								.ActiveConnection=connimprenta
								.Source="SELECT STOCK FROM ARTICULOS_MARCAS"
								.Source= .Source & " WHERE ID_ARTICULO=4566"
								.Source= .Source & " AND MARCA='STANDARD'"
								'response.write("<br>18 - consulta stock de cada articulo del kit: " & .source)
								.Open
							end with
							if not comprobar_stock_actual.eof then
								historico_stock_actual="" & comprobar_stock_actual("stock")
							end if
							comprobar_stock_actual.close
							set comprobar_stock_actual=nothing
							
							historico_cantidad=0
							
									
							cadena_ejecucion="UPDATE ARTICULOS_MARCAS SET STOCK = "
							'EN SQL SE PONE CASE....END, NO IFF
							'UPDATE ARTICULOS_MARCAS
							'       SET STOCK = CASE WHEN (STOCK >=0) THEN STOCK + 10 ELSE NULL END
							'WHERE ID_ARTICULO=4 AND MARCA='BARCELO'
							cadena_ejecucion=cadena_ejecucion & " CASE "
							'si es un envio parcial, resto solo la cantidad concreta que se envia, no todas las unidades pedidas
							IF Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" THEN
								cantidad_parcial=Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0))
								cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & cantidad_parcial
								historico_cantidad=cantidad_parcial
							 ELSE
								IF (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
										AND cantidad_pedido<>oculto_cantidad_enviada) THEN
											cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & (cantidad_pedido-oculto_cantidad_enviada)
											historico_cantidad=cantidad_pedido-oculto_cantidad_enviada
								  ELSE
									cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & articulo_cantidad(1)
									historico_cantidad=articulo_cantidad(1)
								END IF
							END IF
							cadena_ejecucion=cadena_ejecucion & " ELSE null"
							cadena_ejecucion=cadena_ejecucion & " END"
							
							'EN ACCESS NO FUNCIONA EL CASE... END, SINO EL IFF
							'cadena_ejecucion=cadena_ejecucion & " IIF(STOCK<>null, STOCK-" & articulo_cantidad(1) & ", null)"
							
							cadena_ejecucion=cadena_ejecucion & " WHERE ID_ARTICULO=4566"
							cadena_ejecucion=cadena_ejecucion & " AND MARCA='STANDARD'"
							'y restaod estock si?
							'response.write("<BR><br>-19 - actualizacion del stock de articulos: " & CADENA_EJECUCION)
							
							connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
							
							'metemos la linea de control de stock en el historico
							if historico_stock_actual="" then
								historico_stock_actual="NULL"
								resta_calculo="NULL"
							  else
								resta_calculo=(historico_stock_actual - historico_cantidad)
							END IF
							
							cadena_historico="INSERT INTO HISTORICO_STOCKS (FECHA, PEDIDO, ARTICULO, CANTIDAD, STOCK_ACTUAL, STOCK_NUEVO, PROCEDENCIA)"
							cadena_historico=cadena_historico & " VALUES (GETDATE()," & pedido_seleccionado & ", 4566"
							cadena_historico=cadena_historico & ", " & historico_cantidad & ", " & historico_stock_actual 
							cadena_historico=cadena_historico & ", " & resta_calculo & ", 'Modificar_Pedido_Admin - UNICO')"
							
							if Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" or Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" or Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO AL PROVEEDOR" THEN
								'response.write("<br>20 - INSERTAMOS EN EL HISTORICO DE STOCKS: " & cadena_historico)
								connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
								connimprenta.Execute cadena_historico,,adCmdText + adExecuteNoRecords
								
								
								'mentemos la correspondiente salida de mercancia de la ficha del producto
									cadena_ejecucion_salida="INSERT INTO ENTRADAS_SALIDAS_ARTICULOS (ID_ARTICULO, E_S, FECHA, PEDIDO, CANTIDAD, ALBARAN, TIPO, FECHA_ALTA, IP)"
									cadena_ejecucion_salida=cadena_ejecucion_salida & " VALUES (4566"
									cadena_ejecucion_salida=cadena_ejecucion_salida & " , 'SALIDA'"
									cadena_ejecucion_salida=cadena_ejecucion_salida & " , GETDATE()"
									cadena_ejecucion_salida=cadena_ejecucion_salida & " , " & pedido_seleccionado
									cadena_ejecucion_salida=cadena_ejecucion_salida & " , " & historico_cantidad
									cadena_ejecucion_salida=cadena_ejecucion_salida & " , NULL"
									cadena_ejecucion_salida=cadena_ejecucion_salida & " , 'PEDIDO'"
									cadena_ejecucion_salida=cadena_ejecucion_salida & " , getdate()"
									direccion_ip="" ' capturamos la ip para posibles controles posteriores
									if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
										direccion_ip=Request.ServerVariables("HTTP_X_FORWARDED_FOR")
									  else
										direccion_ip=Request.ServerVariables("REMOTE_ADDR")
									end if
									direccion_ip=Request.ServerVariables("REMOTE_ADDR")
									cadena_ejecucion_salida=cadena_ejecucion_salida & " , '" & direccion_ip & "')"
							
									'response.write("<br><br>21 - INSERTAMOS EN entradas salidas articulos: " & cadena_ejecucion_salida)
									connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
									connimprenta.Execute cadena_ejecucion_salida,,adCmdText + adExecuteNoRecords
							end if
						
						end if 'del if pedido_con_rollo_impresora=SI
						
						

					end if 'de comprobar que el estado no sea LISTO PARCIAL para que no reste el stock
						
					'si es un envio parcial, meto los datos que se envian en la tabla correspondiente						
					'***********OJO AQUI QUE ES UN KIT... A VER DE DONDE SE RESTA... CADA ARTICULO O EL KIT EN SI
					'********************
					IF Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" or Request.Form("cmbestados_" & articulo_cantidad(0))="LISTO PARCIAL" THEN
					
						'response.write("<BR>22 -  es un envio parcial O LISTO PARCIAL")
						
						cadena_parcial="UPDATE PEDIDOS_ENVIOS_PARCIALES"
						cadena_parcial=cadena_parcial & " SET CANTIDAD_ENVIADA=CANTIDAD_ENVIADA + " & Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0)) 'cantidad_parcial
						cadena_parcial=cadena_parcial & ", FECHA='" & date() & "'"
						if Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL"  then
							cadena_parcial=cadena_parcial & ", ESTADO='ENVIO PARCIAL'"
						end if
						cadena_parcial=cadena_parcial & " WHERE ID_PEDIDO=" & pedido_seleccionado
						cadena_parcial=cadena_parcial & " AND ID_ARTICULO=" & articulo_cantidad(0)
						cadena_parcial=cadena_parcial & " AND ESTADO='LISTO PARCIAL'"
						cadena_parcial=cadena_parcial & " AND ALBARAN IS NULL"
						cadena_parcial=cadena_parcial & " IF (@@ROWCOUNT = 0 )"
						cadena_parcial=cadena_parcial & " BEGIN"
						cadena_parcial=cadena_parcial & " INSERT INTO PEDIDOS_ENVIOS_PARCIALES (ID_PEDIDO, ID_ARTICULO, CANTIDAD_ENVIADA, FECHA, ESTADO)"
						cadena_parcial=cadena_parcial & " VALUES(" & pedido_seleccionado
						cadena_parcial=cadena_parcial & ", " & articulo_cantidad(0)
						cadena_parcial=cadena_parcial & ", " & Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0)) 'cantidad_parcial
						cadena_parcial=cadena_parcial & ", '" & date() & "'"
						cadena_parcial=cadena_parcial & ", '" & Request.Form("cmbestados_" & articulo_cantidad(0)) & "'"
						cadena_parcial=cadena_parcial & ")"
						cadena_parcial=cadena_parcial & " END"
					
						
						'response.write("<BR>23 -  es un envio parcial, ACTUALIZAMOS PEDIDOS ENVIOS PARCIALES: " & CADENA_PARCIAL)
						
						'porque el sql de produccion es un sql expres que debe tener el formato de
						' de fecha con mes-dia-año
						connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
						connimprenta.Execute cadena_parcial,,adCmdText + adExecuteNoRecords
					  ELSE
					  		''response.write("<BR>ES UN LISTO O ENVIADO: " & Request.Form("cmbestados_" & articulo_cantidad(0)))
							''response.write("<BR>OCULTO CANTIDAD ENVIADA: " & Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0)))
							''response.write("<BR>CANTIDAD PEDIDO: " & cantidad_pedido)
							'response.write("<BR>23 -  ES UN LISTO O ENVIADO")
							IF ((Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" OR Request.Form("cmbestados_" & articulo_cantidad(0))="LISTO") AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
								AND cantidad_pedido<>oculto_cantidad_enviada) THEN
				
								cadena_parcial="UPDATE PEDIDOS_ENVIOS_PARCIALES"
								cadena_parcial=cadena_parcial & " SET CANTIDAD_ENVIADA=CANTIDAD_ENVIADA + " & (cantidad_pedido-oculto_cantidad_enviada) 'cantidad_parcial QUE QUEDA
								cadena_parcial=cadena_parcial & ", FECHA='" & date() & "'"
								cadena_parcial=cadena_parcial & ", ESTADO='ENVIO PARCIAL'"
								cadena_parcial=cadena_parcial & " WHERE ID_PEDIDO=" & pedido_seleccionado
								cadena_parcial=cadena_parcial & " AND ID_ARTICULO=" & articulo_cantidad(0)
								cadena_parcial=cadena_parcial & " AND ESTADO='LISTO PARCIAL'"
								cadena_parcial=cadena_parcial & " AND ALBARAN IS NULL"
								cadena_parcial=cadena_parcial & " IF (@@ROWCOUNT = 0 )"
								cadena_parcial=cadena_parcial & " BEGIN"
								cadena_parcial=cadena_parcial & " INSERT INTO PEDIDOS_ENVIOS_PARCIALES (ID_PEDIDO, ID_ARTICULO, CANTIDAD_ENVIADA, FECHA, ESTADO)"
								cadena_parcial=cadena_parcial & " VALUES(" & pedido_seleccionado
								cadena_parcial=cadena_parcial & ", " & articulo_cantidad(0)
								cadena_parcial=cadena_parcial & ", " & (cantidad_pedido-oculto_cantidad_enviada) 'cantidad_parcial QUE QUEDA
								cadena_parcial=cadena_parcial & ", '" & date() & "'"
								cadena_parcial=cadena_parcial & ", 'ENVIO PARCIAL'"
								cadena_parcial=cadena_parcial & ")"
								cadena_parcial=cadena_parcial & " END"
				
							
								'response.write("<BR>24 - es un envio total de unos envios parciales: " & CADENA_PARCIAL)
								
								'porque el sql de produccion es un sql expres que debe tener el formato de
								' de fecha con mes-dia-año
								connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
								connimprenta.Execute cadena_parcial,,adCmdText + adExecuteNoRecords
							END IF
					END IF
						
					
					
			end if
			control_kit.close
			set control_kit=Nothing

		
			
			'''''''''''''''''''''''''''
			'aqui vamos a poner un envio parcial completo a enviado
			''response.write("<br><br>COMPROBAMOS SI LOS ENVIOS PARCIALES LLEGAN AL TOTAL A ENVIAR")	
				set suma_envios_parciales=Server.CreateObject("ADODB.Recordset")
		
				with suma_envios_parciales
					.ActiveConnection=connimprenta
					cadena_ejecucion="SELECT SUM(CANTIDAD_ENVIADA) AS CANTIDAD_ENVIADA"
					cadena_ejecucion=cadena_ejecucion & " FROM PEDIDOS_ENVIOS_PARCIALES"
					cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado
					cadena_ejecucion=cadena_ejecucion & " AND ID_ARTICULO=" & articulo_cantidad(0)
					.Source=cadena_ejecucion
					'response.write("<br>-25 -  CONSULTA PARA SUMA DE ENVIOS PARCIALES: " & .source)
					.Open
				end with
				
				sumado=0
				IF not suma_envios_parciales.eof THEN
					sumado=suma_envios_parciales("cantidad_enviada")
				END IF
				suma_envios_parciales.close
				set suma_envios_parciales = Nothing
					
			''response.write("<br>- SUMA TOTAL DE ENVIOS PARCIALES: " & SUMADO)
			''response.write("<br>- CANTIDAD PEDIDA: " & articulo_cantidad(1))
			
			'esto ya no hace falta, PERO POR SI ACASO solo se resta cuando el pedido se pone enviado
			' en el estado de enviado no se puede modificar
			'para que solo se reste del stock una vez
			cadena_ejecucion="UPDATE PEDIDOS_DETALLES SET RESTADO_STOCK='SI'"
			'vemos si los envios parciales han completado la cantidad total a enviar
			' para poner el detalle en estado de enviado, y no dejarlo en envio parcial
			IF articulo_cantidad(1)<>"" AND sumado<>"" THEN
				''response.write("<BR>AQUI CONTROLAMOS SI TENEMOS TODO EL STOCK PARCIAL YA ENVIADO O LISTO")
				if CINT(articulo_cantidad(1))=CINT(sumado) then
					''response.write("<BR>...... HEMOS LLEGADO AL TOTAL, TODOS LOS ENVIOS PARCIALES SON IGUALES AL TOTAL")
					
					if Request.Form("cmbestados_" & articulo_cantidad(0))="LISTO PARCIAL" or Request.Form("cmbestados_" & articulo_cantidad(0))="LISTO" then
						cadena_ejecucion=cadena_ejecucion & ", ESTADO='LISTO'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & ", ESTADO='ENVIADO'"
					end if
					

					'metemos la linea de control de los detalles de pedidos
					cadena_historico="INSERT INTO HISTORICO_PEDIDOS (FECHA, PEDIDO, ARTICULO, CANTIDAD_ENVIADA, CANTIDAD_PEDIDA, ESTADO, PROCEDENCIA)"
					cadena_historico=cadena_historico & " VALUES (GETDATE()," & pedido_seleccionado & ", " & articulo_cantidad(0)
					cadena_historico=cadena_historico & ", NULL, NULL, 'ENVIADO', 'Modificar_Pedido_Admin - COMPLETAR ENVIO PARCIAL')"
					'response.write("<br>26 - INSERTAMOS EN HISTORICO PEDIDOS: " & cadena_historico)
					connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
					connimprenta.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
			END IF

			cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado & " AND ARTICULO=" & articulo_cantidad(0)
			'response.write("<BR><br>-27 -  CONSUTLA DE ACTUALIZACION DE PEDIDOS DETALLES: " & CADENA_EJECUCION)
			
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			
			
			''response.write("<BR><br>-- CONTROLAMOS SI HAY QUE MANDAR EMAIL DE ROTURA DE STOCK")
			'**********************
			'aqui controlamos si tenemos que mandar el emial de stock roto....
			set control_email=Server.CreateObject("ADODB.Recordset")
		
				with control_email
					.ActiveConnection=connimprenta
					
					

					'como ahora podemos tener kits de articulos, buscamos el stock del articulo normal
					'y tambien el stock de todos los articulos que componen el posible kit
					cadena_ejecucion="SELECT ARTICULOS_MARCAS.*, ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION"
					cadena_ejecucion=cadena_ejecucion & " FROM ARTICULOS_MARCAS INNER JOIN ARTICULOS"
					cadena_ejecucion=cadena_ejecucion & " ON ARTICULOS_MARCAS.ID_ARTICULO = ARTICULOS.ID"
					cadena_ejecucion=cadena_ejecucion & " WHERE ARTICULOS_MARCAS.ID_ARTICULO=" & articulo_cantidad(0)
					cadena_ejecucion=cadena_ejecucion & " AND ARTICULOS_MARCAS.MARCA='" & marca_articulos & "'"
					cadena_ejecucion=cadena_ejecucion & " AND ARTICULOS_MARCAS.STOCK IS NOT NULL"
					
					cadena_ejecucion=cadena_ejecucion & " UNION"
					
					'ahora buscamos el stock de los articulos que comprodrian el supuesto kit
					cadena_ejecucion=cadena_ejecucion & " SELECT ARTICULOS_MARCAS.*, ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION"
					cadena_ejecucion=cadena_ejecucion & " FROM ARTICULOS_MARCAS INNER JOIN ARTICULOS"
					cadena_ejecucion=cadena_ejecucion & " ON ARTICULOS_MARCAS.ID_ARTICULO = ARTICULOS.ID"
					cadena_ejecucion=cadena_ejecucion & " WHERE ARTICULOS_MARCAS.ID_ARTICULO IN"
					cadena_ejecucion=cadena_ejecucion & " (SELECT CODIGO_ARTICULO FROM CONFIGURACION_KITS"
					cadena_ejecucion=cadena_ejecucion & " WHERE CODIGO_KIT=" & articulo_cantidad(0) & ")"
					cadena_ejecucion=cadena_ejecucion & " AND ARTICULOS_MARCAS.MARCA='" & marca_articulos & "'"
					cadena_ejecucion=cadena_ejecucion & " AND ARTICULOS_MARCAS.STOCK IS NOT NULL"
					
					
					.Source=cadena_ejecucion
					'response.write("<br>28- STOCK DEL ARTICULO O KITS: " & .source)
					.Open
				end with
				
				
				while not control_email.eof
					''response.write("<BR>- HAY REGISTRO EN ARTICULOS_MARCAS")
					''response.write("<BR>- STOCK ACTUAL: " & control_email("stock") & " -- STOCK MINIMO: " & control_email("stock_minimo"))
					'si llegamos al stock mimino, enviamos el email
					IF control_email("stock")<=control_email("stock_minimo") then
						''response.write("<br><br>envio email stock------" & control_email("codigo_sap") & " - " & control_email("descripcion") & " - " & control_email("stock") & " - " & control_email("stock_minimo") & " - " & marca_articulos)

						comprobar_envio_email_stock control_email("codigo_sap"), control_email("descripcion"), control_email("stock"), control_email("stock_minimo"), marca_articulos
					end if
					control_email.movenext
				wend

				control_email.close
				set control_email = Nothing
				
				
				
				
			
		end if
	
	Next
	
	'response.write("<BR>--------------------------------<br>3B ------------------------ ACABAMOS DEL FOR<br>")
	
	
	
	
	
	
		'AHORA ACTUALIZAMOS EL ESTADO GENERAL DEL PEDIDO EN FUNCION DEL ESTADO DE LOS ARTICULOS
		set estado_pedido=Server.CreateObject("ADODB.Recordset")
		
		with estado_pedido
			.ActiveConnection=connimprenta
			cadena_ejecucion="SELECT TOP 1 ESTADOS.ESTADO FROM ESTADOS"
			cadena_ejecucion=cadena_ejecucion & " INNER JOIN (SELECT MIN(ESTADOS.ORDEN) AS ORDEN_ESTADO"
			cadena_ejecucion=cadena_ejecucion & " FROM PEDIDOS_DETALLES INNER JOIN ESTADOS"
			cadena_ejecucion=cadena_ejecucion & " ON PEDIDOS_DETALLES.ESTADO = ESTADOS.ESTADO"
			cadena_ejecucion=cadena_ejecucion & " WHERE PEDIDOS_DETALLES.ID_PEDIDO=" & pedido_seleccionado & ") AS A"
			cadena_ejecucion=cadena_ejecucion & " ON ESTADOS.ORDEN=A.ORDEN_ESTADO"
			.Source=cadena_ejecucion
			'response.write("<br>29- se ve a que estado se ha de poner el pedido: " & .source)
			.Open
		end with

		if not estado_pedido.eof then
			''response.write("<br>DECIDIMOS EL ESTADO DEL PEDIDO.........")
			estado_a_grabar=""
			estado_a_grabar=estado_pedido("estado")

			'si algunos de los articulos está en enviado, el estado del pedido a de ser ENVIO PARCIAL
			'compruebo los estados especiales que hacen que el pedido se ponga en otro estado
			if estado_pedido("ESTADO")="ENVIADO" or estado_pedido("ESTADO")="LISTO" THEN
				''response.write("<br>....EL ESTADO DEL DETALLE ES ENVIADO O LISTO....")
				if estado_pedido("ESTADO")="ENVIADO" then
					set si_hay_enviados_parciales=Server.CreateObject("ADODB.Recordset")
			
					with si_hay_enviados_parciales
						.ActiveConnection=connimprenta
						cadena_ejecucion="SELECT * FROM PEDIDOS_DETALLES"
						cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado
						cadena_ejecucion=cadena_ejecucion & " AND ESTADO<>'ENVIADO' AND ESTADO<>'ANULADO'"
						.Source=cadena_ejecucion
						'response.write("<br>-30- ESTADO DEL DETALLE... ENVIADO.... se ve si hay detalles de pedido diferentes de enviados: " & .source)
						.Open
					end with
					
					if not si_hay_enviados_parciales.eof then
						estado_a_grabar="ENVIO PARCIAL"
					end if
	
					si_hay_enviados_parciales.close
					set si_hay_enviados_parciales = Nothing
	
				end if
				
				'si algunos de los articulos está en LISTO  o LISTO PARCIAL enviado, el estado del pedido a de ser LISTO PARCIAL
				if estado_pedido("ESTADO")="LISTO" then
					set si_hay_listos_parciales=Server.CreateObject("ADODB.Recordset")
			
					with si_hay_listos_parciales
						.ActiveConnection=connimprenta
						cadena_ejecucion="SELECT * FROM PEDIDOS_DETALLES"
						cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado
						cadena_ejecucion=cadena_ejecucion & " AND ESTADO<>'LISTO' AND ESTADO<>'ANULADO'"
						.Source=cadena_ejecucion
						'response.write("<br>-31- ESTADO DEL DETALLE LISTO.... se ve si hay detalles de pedido diferentes de LISTO y ANULADO: " & .source)
						.Open
					end with
					
					if not si_hay_listos_parciales.eof then
						estado_a_grabar="LISTO PARCIAL"
					end if
	
					si_hay_listos_parciales.close
					set si_hay_listos_parciales = Nothing
	
				end if
			  else 'el de los estados especiales, aqui van los "normales"
			  	''response.write("<br>....EL ESTADO DEL DETALLE NO ES NI ENVIADO NI LISTO.........")
			  	set si_hay_enviados_parciales=Server.CreateObject("ADODB.Recordset")
			
				with si_hay_enviados_parciales
					.ActiveConnection=connimprenta
					cadena_ejecucion="SELECT * FROM PEDIDOS_DETALLES"
					cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado
					cadena_ejecucion=cadena_ejecucion & " AND (ESTADO='ENVIADO' OR ESTADO='ENVIO PARCIAL')"
					.Source=cadena_ejecucion
					'response.write("<br>-32- se ve los detalle de pedido enviados O EN ENVIO PARCIAL: " & .source)
					.Open
				end with
				
				if not si_hay_enviados_parciales.eof then
					estado_a_grabar="ENVIO PARCIAL"
				end if

				si_hay_enviados_parciales.close
				set si_hay_enviados_parciales = Nothing
				
				set si_hay_listos_parciales=Server.CreateObject("ADODB.Recordset")
			
				with si_hay_listos_parciales
					.ActiveConnection=connimprenta
					cadena_ejecucion="SELECT * FROM PEDIDOS_DETALLES"
					cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado
					cadena_ejecucion=cadena_ejecucion & " AND (ESTADO='LISTO' OR ESTADO='LISTO PARCIAL')"
					.Source=cadena_ejecucion
					'response.write("<br>33 - se ve los detalle de pedido LISTO O LISTO PARCIAL: " & .source)
					.Open
				end with
				
				if not si_hay_listos_parciales.eof then
					estado_a_grabar="LISTO PARCIAL"
				end if

				si_hay_listos_parciales.close
				set si_hay_listos_parciales = Nothing
			  
			end if
	
			
			
			
			cadena_ejecucion="UPDATE PEDIDOS SET ESTADO='" & estado_a_grabar & "'"
			IF estado_pedido("ESTADO")="ENVIADO" OR estado_pedido("ESTADO")="ENVIADO AL PROVEEDOR" THEN
				cadena_ejecucion=cadena_ejecucion & ", FECHA_ENVIADO='" & date() & "'" 
			END IF
			cadena_ejecucion=cadena_ejecucion & " WHERE PEDIDOS.ID=" & pedido_seleccionado
			'response.write("<BR>34 - actualizacion del estado del pedido: " & CADENA_EJECUCION)
			
			
			'porque el sql de produccion es un sql expres que debe tener el formato de
			' de fecha con mes-dia-año
			connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
				
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			
			'si son pedidos en estado de listo o listo parcial, guardo la informacion del peso, bultos y palets
			''response.write("<br>llegamos al estado a grabar: " & estado_a_grabar)
			
			if (estado_a_grabar="LISTO" or estado_a_grabar="LISTO PARCIAL" or estado_a_grabar="ENVIADO" or estado_a_grabar="ENVIO PARCIAL" ) AND (palets<>"" and bultos<>"" and peso<>"") then
				'hasta el sql 2008 la funcion merge no funciona
				'poner_pesos="DROP TABLE IF EXISTS #Origen_palets;"
				'poner_pesos="IF OBJECT_ID('tempdb.dbo.#Origen_palets', 'U') IS NOT NULL DROP TABLE #Origen_palets;"
				''response.write("<br>poner pesos: " & poner_pesos)
				'connimprenta.Execute poner_pesos,,adCmdText + adExecuteNoRecords
				
				
				'poner_pesos="SELECT PEDIDO=" & pedido_seleccionado & ", PESO=" & peso & ", BULTOS=" & bultos & ", PALETS=" & palets & " INTO #Origen_palets"
				''response.write("<br>poner pesos: " & poner_pesos)
				'connimprenta.Execute poner_pesos,,adCmdText + adExecuteNoRecords
				
				'poner_pesos="MERGE PALETS_BULTOS_PESO_ENVIOS AS TARGET"
				'poner_pesos=poner_pesos & " USING (SELECT * FROM #Origen_palets) AS SOURCE"
				'poner_pesos=poner_pesos & " ON TARGET.PEDIDO = SOURCE.PEDIDO"
				'poner_pesos=poner_pesos & " WHEN MATCHED AND TARGET.ALBARAN = NULL THEN"
				'poner_pesos=poner_pesos & " UPDATE SET PESO = SOURCE.PESO, BULTOS = SOURCE.BULTOS, PALETS = SOURCE.PALETS"
				'poner_pesos=poner_pesos & " WHEN NOT MATCHED THEN"
				'poner_pesos=poner_pesos & " INSERT (PEDIDO, PESO, BULTOS, PALETS) VALUES (" & pedido_seleccionado & ", SOURCE.PESO, SOURCE.BULTOS, SOURCE.PALETS);"
				''response.write("<br>poner pesos: " & poner_pesos)
				'-------------------------------------------------
				
				poner_pesos="UPDATE PALETS_BULTOS_PESO_ENVIOS"
				poner_pesos=poner_pesos & "  SET PESO=" & peso & ", BULTOS=" & bultos & ", PALETS=" & palets
				poner_pesos=poner_pesos & "  WHERE PEDIDO=" & pedido_seleccionado
				poner_pesos=poner_pesos & "  AND (ALBARAN IS NULL OR ALBARAN='')"
				poner_pesos=poner_pesos & "  IF (@@ROWCOUNT = 0 )"
				poner_pesos=poner_pesos & "  BEGIN"
				poner_pesos=poner_pesos & " INSERT INTO PALETS_BULTOS_PESO_ENVIOS(PEDIDO, PESO, BULTOS, PALETS)"
				poner_pesos=poner_pesos & " VALUES (" & pedido_seleccionado & ", " & peso & ", " & bultos & ", " & palets & ")"
				poner_pesos=poner_pesos & " END"
				'response.write("<br>35 - ACTUALIZADOS LOS PESOS Y BULTOS: " & poner_pesos)
				connimprenta.Execute poner_pesos,,adCmdText + adExecuteNoRecords
				
			end if
			
			'si se rechaza el pedido, se tienen que eliminar las devoluciones y los saldos que pudiera tener asociados
			if estado_a_grabar="RECHAZADO" then
				'cadena_ejecucion3="UPDATE DEVOLUCIONES SET TOTAL_DISFRUTADO=A.TOTAL_DISFRUTADO - ISNULL(B.IMPORTES,0)"
				cadena_ejecucion3="UPDATE DEVOLUCIONES SET TOTAL_DISFRUTADO=ROUND((ISNULL(A.TOTAL_DISFRUTADO,0) - ISNULL(B.IMPORTES,0)),2)"
				cadena_ejecucion3=cadena_ejecucion3 & " FROM DEVOLUCIONES A"
				cadena_ejecucion3=cadena_ejecucion3 & " INNER JOIN"
				cadena_ejecucion3=cadena_ejecucion3 & " (SELECT ID_DEVOLUCION, SUM(IMPORTE) AS IMPORTES"
				cadena_ejecucion3=cadena_ejecucion3 & "  FROM DEVOLUCIONES_PEDIDOS"
				cadena_ejecucion3=cadena_ejecucion3 & "  WHERE ID_PEDIDO=" & pedido_seleccionado
				cadena_ejecucion3=cadena_ejecucion3 & "  GROUP BY ID_DEVOLUCION) B"
				cadena_ejecucion3=cadena_ejecucion3 & "  ON A.ID=B.ID_DEVOLUCION"
				
				cadena_ejecucion4="DELETE FROM DEVOLUCIONES_PEDIDOS WHERE ID_PEDIDO=" & pedido_seleccionado
				
				'cadena_ejecucion5="UPDATE SALDOS SET TOTAL_DISFRUTADO=A.TOTAL_DISFRUTADO - ISNULL(B.IMPORTES,0)"
				cadena_ejecucion5="UPDATE SALDOS SET TOTAL_DISFRUTADO=ROUND((ISNULL(A.TOTAL_DISFRUTADO,0) - ISNULL(B.IMPORTES,0)),2)"
				cadena_ejecucion5=cadena_ejecucion5 & " FROM SALDOS A"
				cadena_ejecucion5=cadena_ejecucion5 & " INNER JOIN"
				cadena_ejecucion5=cadena_ejecucion5 & " (SELECT ID_SALDO, SUM(IMPORTE) AS IMPORTES"
				cadena_ejecucion5=cadena_ejecucion5 & "  FROM SALDOS_PEDIDOS"
				cadena_ejecucion5=cadena_ejecucion5 & "  WHERE ID_PEDIDO=" & pedido_seleccionado
				cadena_ejecucion5=cadena_ejecucion5 & "  GROUP BY ID_SALDO) B"
				cadena_ejecucion5=cadena_ejecucion5 & "  ON A.ID=B.ID_SALDO"
				
				cadena_ejecucion6="DELETE FROM SALDOS_PEDIDOS WHERE ID_PEDIDO=" & pedido_seleccionado
				
				'response.write("<BR>36 - ACTUALIZADOS DEVOLUCIONES: " & cadena_ejecucion3)
				'response.write("<BR>37 - borramos DEVOLUCIONES pedidos: " & cadena_ejecucion4)
				'response.write("<BR>38 - ACTUALIZADOS saldos: " & cadena_ejecucion5)
				'response.write("<BR>39 - borramos SALDOS PEDIDOS: " & cadena_ejecucion6)
				connimprenta.Execute cadena_ejecucion3,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion4,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion5,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion6,,adCmdText + adExecuteNoRecords
			end if
			
			
		end if
		
		
	
	
	
	
		estado_pedido.close
		set estado_pedido=Nothing
		
		
		
		
		
	
		''response.write("<BR>-7- comprobacion del campo acciones: " & acciones)
			
		'si le hemos dado a crear el albaran, despues de guardarlo todo, creamos el albaran
		if acciones="ALBARAN" then
			''response.write("<BR>-8- entramos en los albaranaes")
			
			''''''''''''''''''''''''''''''''''''
			'COMPROBAMOS SI ES UN PEDIDO QUE HEMOS DE ENVIAR A UN PROVEEDOR (LOS PEDIDOS DE ROTULACION)
			' PORQUE SE HA DE CREAR UN PDF CON EL PEDIDO Y ENVIARSE POR EMAIL
			set pedido_al_proveedor=Server.CreateObject("ADODB.Recordset")
			
			cadena_pedido_proveedor="SELECT A.PEDIDO_AUTOMATICO, A.ID AS PEDIDO, A.CODCLI, A.ESTADO, A.FECHA"
			cadena_pedido_proveedor=cadena_pedido_proveedor & ", B.NOMBRE AS DESTINATARIO, B.DIRECCION, B.CP, B.POBLACION, B.CP, B.PROVINCIA, B.TELEFONO, B.EMAIL"
			'cadena_pedido_proveedor=cadena_pedido_proveedor & ", '---',*"
			cadena_pedido_proveedor=cadena_pedido_proveedor & " FROM PEDIDOS A LEFT JOIN V_CLIENTES B ON A.CODCLI=B.ID"
			cadena_pedido_proveedor=cadena_pedido_proveedor & " WHERE A.ID=" & pedido_seleccionado
			'cadena_pedido_proveedor=cadena_pedido_proveedor & " AND A.ESTADO='ENVIADO'"
			cadena_pedido_proveedor=cadena_pedido_proveedor & " AND A.ESTADO='ENVIADO AL PROVEEDOR'"
			cadena_pedido_proveedor=cadena_pedido_proveedor & " AND A.PEDIDO_AUTOMATICO='ROTULACION'"
			
			with pedido_al_proveedor
				.ActiveConnection=connimprenta
				.Source= cadena_pedido_proveedor
				'response.write("<br>40 - consulta generar pedido al proveedor: " & .source)
				.Open
			end with
					
			if not pedido_al_proveedor.eof then
				'response.write("<BR>41 - ES UN PEDIDO DE ROTULACION, PARA EL PROVEEDOR")
				'obtenemos los detalles del pedido
				set detalles_pedido_proveedor=Server.CreateObject("ADODB.Recordset")
				cadena_detalles_pedido_proveedor = "SELECT B.CODIGO_SAP, B.REFERENCIA_DEL_PROVEEDOR, B.DESCRIPCION, A.CANTIDAD, B.PRECIO_COSTE"
				cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & ", CAST(ROUND((A.CANTIDAD * B.PRECIO_COSTE),2) AS NUMERIC(36,2)) AS TOTAL"
				cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & " FROM PEDIDOS_DETALLES A LEFT JOIN ARTICULOS B ON A.ARTICULO=B.ID"
				cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & " WHERE ID_PEDIDO=" & pedido_seleccionado
				cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & " AND A.ESTADO='ENVIADO AL PROVEEDOR'"
				cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & " AND A.ALBARAN IS NULL"
				''''''''tambien habra que añadir las condiciones de que el estado sea ENVIADO y con el albaran a NULL
				
				with detalles_pedido_proveedor
					.ActiveConnection=connimprenta
					.CursorType = 0 ' adOpenForwardOnly
					.LockType = 1 ' adLockReadOnly
					.Source= cadena_detalles_pedido_proveedor
					'response.write("<br>42 - consulta generar pedido al proveedor -- detalles PEDIDO: " & .source)
					.Open
				end with	
				if not detalles_pedido_proveedor.eof then
					enviar_email_al_proveedor="SI"
				end if
				detalles_pedido_proveedor.close
				set detalles_pedido_proveedor=Nothing
			end if
			
			pedido_al_proveedor.close
			set pedido_al_proveedor=Nothing
			'''''''''''''''''
			'FINAL COMPROBACION DE ENVIO DEL PEDIDO AL PROVEEDOR

			
			
			
			'comprobamos si hay que crear albaranes
			set si_creamos_albaran=Server.CreateObject("ADODB.Recordset")
		
				with si_creamos_albaran
					.ActiveConnection=connimprenta
					'.CursorType=0 'adOpenForwardOnly
					'.CursorType=1 'adOpenKeyset
					'.CursorType=2 'adOpenDynamic
					'.CursorType=3 'adOpenStatic
					.CursorType = 0 ' adOpenForwardOnly
					.LockType = 1 ' adLockReadOnly
					
					
					
					
					'cadena_ejecucion_comprobar="SELECT * FROM PEDIDOS_ENVIOS_PARCIALES where pedidos_envios_parciales.id_pedido=111123"
					cadena_ejecucion_comprobar="SELECT * FROM PEDIDOS_DETALLES LEFT OUTER JOIN PEDIDOS_ENVIOS_PARCIALES"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " ON PEDIDOS_DETALLES.ID_PEDIDO = PEDIDOS_ENVIOS_PARCIALES.ID_PEDIDO"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & "  AND PEDIDOS_DETALLES.ARTICULO = PEDIDOS_ENVIOS_PARCIALES.ID_ARTICULO"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " WHERE (PEDIDOS_DETALLES.ID_PEDIDO = " & pedido_seleccionado & ")"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " AND ("
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " ((PEDIDOS_DETALLES.ESTADO = 'ENVIADO') AND (PEDIDOS_DETALLES.ALBARAN IS NULL))"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " OR ((PEDIDOS_DETALLES.ESTADO = 'ENVIO PARCIAL') and (pedidos_envios_parciales.albaran IS NULL))"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " OR ((PEDIDOS_DETALLES.ESTADO = 'ENVIADO AL PROVEEDOR') AND (PEDIDOS_DETALLES.ALBARAN IS NULL))"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " )"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " ORDER BY PEDIDOS_DETALLES.ARTICULO, PEDIDOS_ENVIOS_PARCIALES.FECHA"
					
					'***********************
					'NUEVA CONSULTA
					'SELECT     PEDIDOS_DETALLES.ID, PEDIDOS_DETALLES.ID_PEDIDO, 
					'PEDIDOS_DETALLES.ARTICULO, PEDIDOS_DETALLES.CANTIDAD, 
					'PEDIDOS_ENVIOS_PARCIALES.CANTIDAD_ENVIADA, 
					'PEDIDOS_ENVIOS_PARCIALES.FECHA, PEDIDOS_DETALLES.PRECIO_UNIDAD, 
					'PEDIDOS_DETALLES.TOTAL, PEDIDOS_DETALLES.FICHERO_PERSONALIZACION, 
					'PEDIDOS_DETALLES.ESTADO, PEDIDOS_DETALLES.HOJA_RUTA, 
					'PEDIDOS_DETALLES.RESTADO_STOCK, PEDIDOS_DETALLES.ALBARAN
					'FROM         PEDIDOS_DETALLES LEFT OUTER JOIN
					'					  PEDIDOS_ENVIOS_PARCIALES ON PEDIDOS_DETALLES.ID_PEDIDO = PEDIDOS_ENVIOS_PARCIALES.ID_PEDIDO AND 
					'					  PEDIDOS_DETALLES.ARTICULO = PEDIDOS_ENVIOS_PARCIALES.ID_ARTICULO
					'WHERE     (PEDIDOS_DETALLES.ID_PEDIDO = 47486) 
					
					'AND (
					'((PEDIDOS_DETALLES.ESTADO = 'ENVIADO') AND (PEDIDOS_DETALLES.ALBARAN IS NULL))
					'OR ((PEDIDOS_DETALLES.ESTADO = 'ENVIO PARCIAL') and (pedidos_envios_parciales.albaran IS NULL))
					')
					'ORDER BY PEDIDOS_DETALLES.ARTICULO, PEDIDOS_ENVIOS_PARCIALES.FECHA
					
					.Source=cadena_ejecucion_comprobar
					'response.write("<br>43 -  vemos si hay detalles de pedido a los que crear albaran: " & .source)
					
					.Open
					
					'if not .BOF then
					'	mitabla_totales=.GetRows()
					'	else
					'	vacio_totales=true
					'end if
				end with
			
			creamos_albaran="SI"
			if si_creamos_albaran.eof then
				creamos_albaran="NO"
			end if
			
			si_creamos_albaran.close
			set si_creamos_albaran=Nothing
			
			''response.write("<br>creamos el albaran?S/N:" & CREAMOS_ALBARAN)
					
			if creamos_albaran="SI" then
					
					'response.write("<br>44 - creamos el albaran..... SI")

					numero_albaran=0 ' lo paso a 0 para que cree el albaran
					direccion_ip="" ' capturamos la ip para posibles controles posteriores
					if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
						direccion_ip=Request.ServerVariables("HTTP_X_FORWARDED_FOR")
					  else
						direccion_ip=Request.ServerVariables("REMOTE_ADDR")
					end if
					direccion_ip=Request.ServerVariables("REMOTE_ADDR")
					'con la unificacion con gag ya puedo poner el codigo del cliente
					' en el albaran y no pasar el 9999 para que despues lo asignen ellos
					cliente_albaran=codcli 
					forma_de_envio=1
					
					''response.write("<br>-- obtenddremos la direccion de entrega")
					direccion_entrega=""
					set datos_direccion=Server.CreateObject("ADODB.Recordset")
					with datos_direccion
						.ActiveConnection=connimprenta
						cadena_ejecucion="SELECT direccion, poblacion, provincia, cp FROM V_CLIENTES WHERE ID=" & CODCLI
						.Source=cadena_ejecucion
						'response.write("<br>45 - obtengo la direccion de envio para el cliente: " & .source)
						.Open
					end with
					
					if not datos_direccion.eof then
						direccion_entrega= datos_direccion("direccion")
						direccion_entrega=direccion_entrega & chr(13) & datos_direccion("cp")
						direccion_entrega=direccion_entrega & " " & datos_direccion("poblacion")
						direccion_entrega=direccion_entrega & chr(13)& datos_direccion("provincia")
					end if					
					''response.write("<br>---- direccion de entrega obtenida: " & direccion_entrega)
					''response.write("<br>---- direccion de envio previa: " & direccion_envio)
					'si nos han indicado una direccion diferente a la la que tiene el cliente dada de alta
					if direccion_envio<>"" then
						direccion_entrega=direccion_envio
					end if
					'response.write("<br>46 ------- direccion de entrega DEFINITIVA: " & direccion_entrega)
					
					datos_direccion.close
					set datos_direccion=nothing
					
					'vemos si va a la atencion de algun empleado de GLS
					set att_empleado=Server.CreateObject("ADODB.Recordset")
					with att_empleado
						.ActiveConnection=connimprenta
						cadena_ejecucion="SELECT A.USUARIO_DIRECTORIO_ACTIVO, A.CODCLI, B.EMPRESA, C.NOMBRE, C.APELLIDOS"
						cadena_ejecucion = cadena_ejecucion & " FROM PEDIDOS A"
						cadena_ejecucion = cadena_ejecucion & " INNER JOIN V_CLIENTES B"
						cadena_ejecucion = cadena_ejecucion & " ON A.CODCLI=B.ID"
						cadena_ejecucion = cadena_ejecucion & " INNER JOIN EMPLEADOS_GLS C"
						cadena_ejecucion = cadena_ejecucion & " ON A.USUARIO_DIRECTORIO_ACTIVO=C.ID"
						cadena_ejecucion = cadena_ejecucion & " WHERE A.ID=" & pedido_seleccionado

						.Source=cadena_ejecucion
						'response.write("<br>47 - obtengo la direccion de envio para el cliente: " & .source)
						.Open
					end with
					
					cadena_att_empleado=""
					if not att_empleado.eof then
						if att_empleado("empresa")=4 then
							cadena_att_empleado= att_empleado("nombre") & " " & att_empleado("apellidos") & " (Ropa Empleado)"
						end if
					end if					
					
					'si nos han indicado una direccion diferente a la la que tiene el cliente dada de alta
					if cadena_att_empleado<>"" then
						direccion_entrega = "Att: " & cadena_att_empleado & chr(13) &  direccion_entrega
					end if
					'response.write("<br>48 ---- CADENA ATT EMPLEADO: " & cadena_att_empleado)
					'response.write("<br>49 ---- direccion de entrega att: " & direccion_entrega)
					'response.write("<br>50 ----.... direccion de entrega truncada a 250: " & left(direccion_entrega,250))
					att_empleado.close
					set att_empleado=nothing
					
					
					
					anulado_albaran=0
					estado_albaran=0
					pedido_albaran=pedido_seleccionado
					fecha_albaran=now()
					'observaciones="Correspondiente al Pedido del Carrito Num. " & pedido_seleccionado
					observaciones=""
					nofacturable=0 '0 para cuando el albaran es facturable y 1 para cuando no es facturable
					albaran_nuevo=0
					


					'vemos que articulos del albaran son facturables	
					'desde el 19/04/2021 nos dicen que todos son facturables
					'set ver_facturables=Server.CreateObject("ADODB.Recordset")
					'with ver_facturables
					'	.ActiveConnection=connimprenta
					'	cadena_ejecucion_facturables="SELECT pedidos_detalles.id_pedido, articulos.id, articulos.facturable"
					'	cadena_ejecucion_facturables=cadena_ejecucion_facturables & " FROM PEDIDOS_DETALLES INNER JOIN ARTICULOS"
					'	cadena_ejecucion_facturables=cadena_ejecucion_facturables & " ON ARTICULOS.ID = PEDIDOS_DETALLES.ARTICULO"
					'	cadena_ejecucion_facturables=cadena_ejecucion_facturables & " WHERE PEDIDOS_DETALLES.ID_PEDIDO=" & pedido_seleccionado
					'	cadena_ejecucion_facturables=cadena_ejecucion_facturables & " AND PEDIDOS_DETALLES.ESTADO='ENVIADO'"
					'	cadena_ejecucion_facturables=cadena_ejecucion_facturables & " AND PEDIDOS_DETALLES.ALBARAN IS NULL"
					'	cadena_ejecucion_facturables=cadena_ejecucion_facturables & " AND ARTICULOS.FACTURABLE = 'SI'"
					'	.Source=cadena_ejecucion_facturables
					'	''response.write("<br>- veo si hay articulos facturables en el albaran: " & .source)
					'	.Open
					'end with

					''si no hay articulos facturables en el albaran, se crea como no facturable
					'if ver_facturables.eof then
					'	nofacturable=1
					'' else
					''	while not ver_facturables.eof 
					''		'response.write("<br>pedido: " & ver_facturables("id_pedido") & " articulo: " & ver_facturables("id") & " facturable: " & ver_facturables("facturable"))
					''		ver_facturables.movenext
					''	wend
					'end if		

					'ver_facturables.close
					'set ver_facturables=Nothing
					
					''response.write("<BR>no facturable: " & nofacturable)

					'response.write("<BR>51 - antes de la conexion_gag PARA CREAR EL ALBARAN")
					
					%>			
					<!--#include file="Conexion_GAG.inc"-->
					
					<%
					'response.write("<BR>52- creo el comand")
					set cmd = Server.CreateObject("ADODB.Command")
					'set cmd2 = Server.CreateObject("ADODB.Command")
					'''set cmd.ActiveConnection = conn_gag
					
					set cmd.ActiveConnection = connimprenta
					
					'set cmd2.ActiveConnection = conndistribuidora
					
					'''conn_gag.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
					connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
					
				   ' Ejecuto el Primer Procedimiento Almacenado, el de la Cabecera del Pedido
				   'GRABAR_CABECERA_PEDIDO codsucursal, fecha, 'INTRANET';
				   
				   'response.write("<BR>-------------------------------------<BR>53 ---------------- COMENZAMOS LA TRANSACCION DE CONN_GAG")
				   '''conn_gag.BeginTrans 'Comenzamos la Transaccion
				   '''cmd.CommandText = "SP_ACTUALIZA_ALBARAN"
				   cmd.CommandText = "PRE__GAG.dbo.SP_ACTUALIZA_ALBARAN"
				   cmd.CommandType = 4 'adCmdStoredProc
				
					' Query the server for what the parameters are
					'cmd.parameters.append cmd.createparameter("SUCURSAL",adInteger,adParamInput,4,cint(codsucursal))
					'cmd.parameters.append cmd.createparameter("FECHA",adDate,adParamInput,4,fecha)
					'cmd.parameters.append cmd.createparameter("ARTICULO",adInteger,adParamInput,4,cint(codarticulo))
					'cmd.parameters.append cmd.createparameter("CANTIDAD",adInteger,adParamInput,4,cint(cantidad))
					'cmd.parameters.append cmd.createparameter("EXPEDIENTE",adVarChar,adParamInput,12,expediente)
					'cmd.parameters.append cmd.createparameter("PEDIDO_POR",adVarChar,adParamInput,10,pedido_por)
					
					'Estructura del procedimiento almacenado			
					'ALTER  PROCEDURE  [dbo].[sp_Actualiza_Albaran] 			
					'    @Albaran int,
					'	@IP VarChar(20),	
					'	@Cliente int,
					'	@FormaEnvio int,
					'	@DirEntrega nvarchar (250),
					'	@Anulado Int, 
					'	@Estado int,
					'    @Pedido int,
					'	@Fecha DateTime, 
					'	@Observaciones ntext,
					'    @idAlbaranNuevo INT OUTPUT
					
					
					''response.write("<BR>-11- empiezo a asignar parametros")
					
					'Paso los parametros para que se ejecute el comando
					cmd.parameters(1)=numero_albaran
					''response.write("<BR>-- asignado el 1")
					'response.write("<br>direccion ip: " & direccion_ip)
					cmd.parameters(2)=direccion_ip
					''response.write("<BR>-- asignado el 2")
					cmd.parameters(3)=cliente_albaran
					''response.write("<BR>-- asignado el 3")
					cmd.parameters(4)=forma_de_envio
					''response.write("<BR>-- asignado el 4")
					cmd.parameters(5)=left(direccion_entrega,250)
					''response.write("<BR>-- asignado el 5")
					cmd.parameters(6)=anulado_albaran
					''response.write("<BR>-- asignado el 6")
					cmd.parameters(7)=estado_albaran
					''response.write("<BR>-- asignado el 7")
					cmd.parameters(8)=pedido_albaran
					''response.write("<BR>-- asignado el 8")
					cmd.parameters(9)=fecha_albaran
					''response.write("<BR>-- asignado el 9")
					cmd.parameters(10)=observaciones
					''response.write("<BR>-- asignado el 10")
					cmd.parameters(11)=nofacturable
					''response.write("<BR>-- asignado el 10")
					   
					cmd.execute()
					
					'response.write("<BR>54 - recojo el nuevo valor del albaran")
					'recojo el valor que devuelve el primer procedimiento
					albaran_nuevo="" & cmd.parameters(12).value
					''response.write numeropedido
					
		
					''response.write("<BR>-13- nuevo codigo de albaran: " & albaran_nuevo)
		
					'ponemos el numero de albaran en los detalles del pedido que forman ese albaran
					cadena_ejecucion_albaran=""
					cadena_ejecucion_albaran="UPDATE PEDIDOS_DETALLES SET ALBARAN=" & albaran_nuevo
					cadena_ejecucion_albaran= cadena_ejecucion_albaran & " WHERE ID_PEDIDO=" & pedido_albaran
					cadena_ejecucion_albaran= cadena_ejecucion_albaran & " AND ALBARAN IS NULL"
					cadena_ejecucion_albaran= cadena_ejecucion_albaran & " AND (ESTADO='ENVIADO' OR ESTADO='ENVIADO AL PROVEEDOR')"
					'response.write("<BR>55 - sql que ejecutamos para poner el albaran a los detalles del pedido: " & cadena_ejecucion_albaran)
					connimprenta.Execute cadena_ejecucion_albaran,,adCmdText + adExecuteNoRecords
		
					'ponemos el numero de albaran en los detalles de envios parciales del pedido que forman ese albaran
					cadena_ejecucion_albaran=""
					cadena_ejecucion_albaran="UPDATE PEDIDOS_ENVIOS_PARCIALES SET ALBARAN=" & albaran_nuevo
					cadena_ejecucion_albaran= cadena_ejecucion_albaran & " WHERE ID_PEDIDO=" & pedido_albaran
					cadena_ejecucion_albaran= cadena_ejecucion_albaran & " AND ALBARAN IS NULL"
					'response.write("<BR>56 - sql que ejecutamos para poner el albaran a los ENVIOS PARCIALES DEL pedido: " & cadena_ejecucion_albaran)
					connimprenta.Execute cadena_ejecucion_albaran,,adCmdText + adExecuteNoRecords
		
					'le ponemos el albaran a los datos de los pesos bultos palets del pedido
					cadena_actualizacion_bultos="UPDATE PALETS_BULTOS_PESO_ENVIOS"
					cadena_actualizacion_bultos=cadena_actualizacion_bultos & "  SET ALBARAN=" & albaran_nuevo
					cadena_actualizacion_bultos=cadena_actualizacion_bultos & "  WHERE PEDIDO=" & pedido_seleccionado
					cadena_actualizacion_bultos=cadena_actualizacion_bultos & "  AND (ALBARAN IS NULL OR ALBARAN='')"
					'response.write("<BR>57 - ACTUALIZADOS LOS PALEST BULTOS PARA PONERLES EL ALBARAN: " & CADENA_ACTUALIZACION_BULTOS)

					connimprenta.Execute cadena_actualizacion_bultos,,adCmdText + adExecuteNoRecords
					
					'ahora creamos los detalles del albaran
					set  detalles_pedido_albaran=Server.CreateObject("ADODB.Recordset")
					with detalles_pedido_albaran
							.ActiveConnection=connimprenta
							'.Source="SELECT * FROM PEDIDOS_DETALLES INNER JOIN ARTICULOS"
							'.Source= .Source & " ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID"
							'.Source= .Source & " WHERE ID_PEDIDO=" & pedido_albaran
							
							'.Source="SELECT a.id, a.id_pedido, a.estado, a.cantidad, b.codigo_sap, b.descripcion, a.albaran,"
							'.Source= .Source & " a.hoja_ruta, a.precio_unidad, a.total, c.cantidad_enviada, c.albaran as albaran_parcial,"
							'.Source= .Source & " (select sum(cantidad_enviada) from pedidos_envios_parciales"
							'.Source= .Source & " where pedidos_envios_parciales.id_pedido=a.id_pedido"
							'.Source= .Source & " and pedidos_envios_parciales.id_articulo=a.articulo) as cantidad_enviada_total"
							'.Source= .Source & " FROM PEDIDOS_DETALLES a INNER JOIN ARTICULOS b" 
							'.Source= .Source & " ON a.ARTICULO = b.ID"
							'.Source= .Source & " LEFT JOIN PEDIDOS_ENVIOS_PARCIALES c"
							'.Source= .Source & " ON c.ID_PEDIDO=a.ID_PEDIDO"
							'.Source= .Source & " AND c.ID_ARTICULO=a.ARTICULO"
							'.Source= .Source & " WHERE a.ID_PEDIDO=" & pedido_albaran
							
							
							.Source="SELECT a.id, a.id_pedido, a.estado, a.articulo, a.cantidad, b.codigo_sap, b.descripcion, a.albaran,"
							.Source= .Source & " a.hoja_ruta, a.precio_unidad, a.total, c.cantidad_enviada, c.albaran as albaran_parcial,"
							.Source= .Source & " (select sum(cantidad_enviada) from pedidos_envios_parciales"
							.Source= .Source & " where pedidos_envios_parciales.id_pedido=a.id_pedido"
							.Source= .Source & " and pedidos_envios_parciales.id_articulo=a.articulo) as cantidad_enviada_total,"
							.Source= .Source & " (select familia from articulos_empresas" 
							.Source= .Source & " where id_articulo=a.articulo" 
							.Source= .Source & " and codigo_empresa= (select empresa" 
							.Source= .Source & " from v_clientes where id =" 
							.Source= .Source & " (select codcli from pedidos where id=" & pedido_albaran & "))) as familia,"
							.Source= .Source & " (select fecha from pedidos where id=" & pedido_albaran & ") as fecha,"
							.Source= .Source & " (select codcli from pedidos where id=" & pedido_albaran & ") as usuario,"
							.Source= .Source & " a.articulo, b.FACTURABLE"
							
							.Source= .Source & " FROM PEDIDOS_DETALLES a INNER JOIN ARTICULOS b" 
							.Source= .Source & " ON a.ARTICULO = b.ID"
							.Source= .Source & " LEFT JOIN PEDIDOS_ENVIOS_PARCIALES c"
							.Source= .Source & " ON c.ID_PEDIDO=a.ID_PEDIDO"
							.Source= .Source & " AND c.ID_ARTICULO=a.ARTICULO"
							
							.Source= .Source & " WHERE a.ID_PEDIDO=" & pedido_albaran
							
							'response.write("<BR>58 - recogemos los detalles del pedido con el albaran guardado para crear sus detalles: " & .source)
					
							.Open
					end with
					
					cadena_detalles_merchan=""
					while not detalles_pedido_albaran.eof
						cadena_detalles_albaran=""
						
						estado_detalle="" & detalles_pedido_albaran("estado")
						cantidad_pedida_detalle="" & detalles_pedido_albaran("cantidad")
						cantidad_detalle="" & detalles_pedido_albaran("cantidad")
						if estado_detalle="ENVIO PARCIAL" then
							cantidad_detalle="" & detalles_pedido_albaran("cantidad_enviada")
						end if
						if estado_detalle="ENVIADO" and detalles_pedido_albaran("cantidad_enviada")<>"" then
							cantidad_detalle="" & detalles_pedido_albaran("cantidad_enviada")
						end if
						descripcion_detalle= "" & detalles_pedido_albaran("codigo_sap") & "    " & detalles_pedido_albaran("descripcion")
						id_articulo_detalle= "" & detalles_pedido_albaran("articulo")
						'si son articulos de las familias de merchandising (222,223,224,225,298,299,314,315)
						expediente_albaran="xxxxxxxxx"
						if detalles_pedido_albaran("familia")="222" or detalles_pedido_albaran("familia")="223" or detalles_pedido_albaran("familia")="224" or detalles_pedido_albaran("familia")="225"_
							 or detalles_pedido_albaran("familia")="298" or detalles_pedido_albaran("familia")="299" or detalles_pedido_albaran("familia")="314" or detalles_pedido_albaran("familia")="315" then
							cadena_texto_json=""
							set fso_json=Server.CreateObject("Scripting.FileSystemObject")
							ruta_fichero_json= Server.MapPath("./GAG/pedidos/" & year(detalles_pedido_albaran("fecha")) & "/" & detalles_pedido_albaran("usuario") & "__" & pedido_albaran)
							ruta_fichero_json= ruta_fichero_json & "/json_" & detalles_pedido_albaran("articulo") & ".json"
							'response.write("<br>59 - fichero json a comprobar si existe: " & ruta_fichero_json)
							if fso_json.FileExists(ruta_fichero_json) then
								Set contenido_fichero_json = fso_json.OpenTextFile(ruta_fichero_json, 1) 
								'Escribimos su contenido 
								cadena_texto_json=contenido_fichero_json.ReadAll
								'response.write("<br>60 - El contenido es:<br>" & cadena_texto_json)
								Dim plantillas: Set plantillas = JSON.parse(cadena_texto_json)
								'For i=0 to plantillas.numero_plantillas - 1
									If CheckProperty(plantillas.plantillas.get(0), "expediente") Then
											'response.write("<br>61 - El expediente leido es: " & plantillas.plantillas.get(0).expediente)
											expediente_albaran=plantillas.plantillas.get(0).expediente
									end if
								'next								
							end if
							set fso_json=nothing
							
							
							descripcion_detalle=descripcion_detalle & " // Expediente: " & expediente_albaran
						end if 
						albaran_maestro="" & detalles_pedido_albaran("albaran")
						albaran_parcial_detalle="" & detalles_pedido_albaran("albaran_parcial")
						albaran_detalle="" & detalles_pedido_albaran("albaran")
						if estado_detalle="ENVIO PARCIAL" then
							albaran_detalle="" & albaran_parcial_detalle
						end if
						trabajo_detalle="" & detalles_pedido_albaran("hoja_ruta")
						total_detalle="" & detalles_pedido_albaran("total")
						
						''response.write("<br>cantidad detalle: " & cantidad_detalle & "....precio unidad: " & detalles_pedido_albaran("precio_unidad"))
						if estado_detalle="ENVIO PARCIAL" then
							if ("" & detalles_pedido_albaran("precio_unidad"))<>"" then
								total_detalle="" & (cantidad_detalle * detalles_pedido_albaran("precio_unidad"))
							  else
							  	total_detalle="" & (cantidad_detalle * (detalles_pedido_albaran("total")/detalles_pedido_albaran("cantidad")))
							end if
							'total_detalle="" & (cantidad_detalle * detalles_pedido_albaran("precio_unidad"))
						end if		
						
						
						if estado_detalle="ENVIADO" and detalles_pedido_albaran("cantidad_enviada")<>"" then
							if ("" & detalles_pedido_albaran("precio_unidad"))<>"" then
								total_detalle="" & (cantidad_detalle * detalles_pedido_albaran("precio_unidad"))
							  else
							  	total_detalle="" & (cantidad_detalle * (detalles_pedido_albaran("total")/detalles_pedido_albaran("cantidad")))
							end if
							'total_detalle="" & (cantidad_detalle * detalles_pedido_albaran("precio_unidad"))
						end if
						cantidad_enviada_total_detalle="" & detalles_pedido_albaran("cantidad_enviada_total")
						if cantidad_enviada_total_detalle="" then
							cantidad_enviada_total_detalle=0
						end if
						
						'si el articulo es no facturable, el detalle del albaran va a coste 0
						if detalles_pedido_albaran("facturable")="NO" then
							total_detalle="0"
						end if
						
						'al final solo se ponen en el albaran los enviados
						'if (estado_detalle="ENVIADO") or (estado_detalle="ENVIO PARCIAL") then
						''response.write("<BR>-14b- estado_detalle: " & estado_detalle & " ... PARA EL ARTICULO: " & descripcion_detalle)
					
						'if (estado_detalle="ENVIADO") then
						if (estado_detalle="ENVIADO") or (estado_detalle="ENVIO PARCIAL") OR  (estado_detalle="ENVIADO AL PROVEEDOR") then
						
							'hay que generar el detalle del albaran
							'response.write("<BR>62 - HAY QUE GENERAR EL DETALLE DEL ALBARAN")
							''response.write("<BR>-14c- albaran_detalle: " & albaran_detalle & "...")
							''response.write("<BR>-14d- albaran_nuevo: " & albaran_nuevo & "...")
							
							if estado_detalle="ENVIADO" OR estado_detalle="ENVIADO AL PROVEEDOR" then
								if albaran_detalle=albaran_nuevo then
									if albaran_nuevo=albaran_parcial_detalle or albaran_parcial_detalle="" then
										''response.write("<BR>-14e- son iguales los albaranes..")
										'Campos de los detalles de albaran
										'IdAlbaranDetalles, IdEmpresa, IdAlbaran, IdHojaRuta, idNTrabajo, Cantidad, Concepto, Importe, Documento, Ip_Mod, Fecha_Mod
										campos_albaranes="IdEmpresa, IdAlbaran, Cantidad, idNTrabajo, Concepto, Importe, Ip_Mod, Fecha_Mod"
										
										cadena_detalles_albaran="1, " & albaran_nuevo & ", " & cantidad_detalle & ", '" 
										cadena_detalles_albaran=cadena_detalles_albaran & trabajo_detalle & "', '" 
										cadena_detalles_albaran=cadena_detalles_albaran & descripcion_detalle
										cadena_detalles_albaran=cadena_detalles_albaran & "', " & REPLACE(ROUND(total_detalle,2),",",".") & ", '"
										cadena_detalles_albaran=cadena_detalles_albaran & direccion_ip & "', '" & fecha_albaran & "'"
										
										cadena_ejecucion_detalles_albaran="INSERT INTO ALBARANES_DETALLES (" & campos_albaranes & ")"
										cadena_ejecucion_detalles_albaran=cadena_ejecucion_detalles_albaran & " VALUES (" & cadena_detalles_albaran & ")"
										
										
										'response.write("<BR>63- sql que ejecutamos para crear los detalles del albaran: " & cadena_ejecucion_detalles_albaran)
									
										conn_gag.Execute cadena_ejecucion_detalles_albaran,,adCmdText + adExecuteNoRecords
										
										''response.write("<BR>-15b- tenemos una cantidad pedida de: " & cantidad_pedida_detalle & " y se han enviado: " & cantidad_envidad_total_detalle)
										
										''response.write("<BR>DESCRIPCION DEL ARTICULO AL ALBARAN: " & descripcion_detalle)
										''response.write("<BR>ID DEL ARTICULO: " & ID_ARTICULO_DETALLE)
										
										'si es una impresora de gls, hay que añadir los numeros de serie de dichas impresoras para su gestion posterior
										
										if id_articulo_detalle="4583" then
											'response.write("<BR>64 - ES UN ARTICULO 4583 - IMPRESORA GLS...")
											numeros_de_serie = Split(sn_impresoras, "###")
											resultado = ""
											For i = LBound(numeros_de_serie) To UBound(numeros_de_serie)
												resultado = resultado & numeros_de_serie(i) & ","
												' para que añada un retorno de carrocada 4 numeros de serie porque se sale del ancho
												If (i + 1) Mod 4 = 0 Then
													resultado = resultado & vbCrLf
												End If
											Next
											
											' Eliminar la coma final y devolver el resultado
											resultado = Left(resultado, Len(resultado) - 1)
											
											observaciones_sn_impresoras = "Las Impresoras Enviadas Tienen Los Siguientes Numeros de Serie:"
											observaciones_sn_impresoras = observaciones_sn_impresoras & chr(13) & resultado
											direccion_ip=""
											if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
												direccion_ip = "" & Request.ServerVariables("HTTP_X_FORWARDED_FOR")
											  else
												direccion_ip = "" & Request.ServerVariables("REMOTE_ADDR")
											end if
											direccion_ip = "" & Request.ServerVariables("REMOTE_ADDR")
											tipo_renting=""
											set rs_renting=Server.CreateObject("ADODB.Recordset")
											with rs_renting
												.ActiveConnection=connimprenta
												.Source="SELECT RENTING_IMPRESORA_GLS FROM PEDIDOS"
												.Source= .Source & " WHERE ID = " & pedido_albaran
												'response.write("<br>65 - OBTENEMOS EL TIPO RENTING DE LA IMPRESORA GLS: " & .source)
												.OPEN
											end with
											if not rs_renting.eof then
												tipo_renting = "" & rs_renting("RENTING_IMPRESORA_GLS")
											  else
											  	tipo_renting = "NULL"
											end if
											rs_renting.close
											set rs_renting = Nothing
											
											'set impresora_activa=Server.CreateObject("ADODB.Recordset")
											For i = LBound(numeros_de_serie) To UBound(numeros_de_serie)
												
												
												'with impresora_activa
												'	.ActiveConnection=connimprenta
												'	.Source="SELECT sn_impresora FROM GLS_IMPRESORAS WHERE SN_IMPRESORA='" & numeros_de_serie(i) & "' AND ESTADO <> 'BAJA'"
												'	'response.write("<br>buscar impresora aun activa: " & .source)
												'	.OPEN
												'end with
												'if not impresora_activa.eof then
													'error, no se puede utilizar una impresora activa
													''''''''''''''''''''''''''''''''''''
												'	hay_impresora_activa = "SI"
												'	sn_impresora_activa = numeros_de_serie(i)
												'	'response.write("<br>impresora aun activa: " & sn_impresora_activa)
												'	'nos salimos de la ejecucion porque la impresora está activa
												'	connimprenta.RollBackTrans
												'	Response.End
												'  else
												  	'si no está activa, o se actualiza o se da de alta
													''response.write("<br>impresora NO activa: " & numeros_de_serie(i))
													cadena_insercion_imp = ""
													cadena_insercion_imp = "UPDATE GLS_IMPRESORAS"
													cadena_insercion_imp = cadena_insercion_imp & " SET ID_CLIENTE = " & cliente_albaran
													cadena_insercion_imp = cadena_insercion_imp & ", FECHA_ALTA =  GETDATE()"
													cadena_insercion_imp = cadena_insercion_imp & ", ESTADO = 'ACTIVA'"
													cadena_insercion_imp = cadena_insercion_imp & ", ID_PEDIDO = " & pedido_albaran
													cadena_insercion_imp = cadena_insercion_imp & ", RENTING = " & tipo_renting
													cadena_insercion_imp = cadena_insercion_imp & " WHERE SN_IMPRESORA = '" & numeros_de_serie(i) & "'"
													cadena_insercion_imp = cadena_insercion_imp & " IF (@@ROWCOUNT=0)" 
													cadena_insercion_imp = cadena_insercion_imp & " BEGIN"
													cadena_insercion_imp = cadena_insercion_imp & " INSERT INTO GLS_IMPRESORAS (ID_CLIENTE, SN_IMPRESORA, FECHA_ALTA, ESTADO, ID_PEDIDO, RENTING)"
													cadena_insercion_imp = cadena_insercion_imp & " VALUES (" & cliente_albaran & ", '" & numeros_de_serie(i) & "'"
													cadena_insercion_imp = cadena_insercion_imp & ", GETDATE(), 'ACTIVA', " & pedido_albaran & ", " & tipo_renting & ")"
													cadena_insercion_imp = cadena_insercion_imp & " END"
													'response.write("<br>66 - ACTUALIZAMOS O INSERTAMOS IMPRESORAS GLS: " & cadena_insercion_imp)
	
													'connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
													connimprenta.Execute cadena_insercion_imp,,adCmdText + adExecuteNoRecords
													
													'metemos los datos tambien en el historico
													historico_imp = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL, ID_PEDIDO, RENTING)"
													historico_imp = historico_imp & " VALUES ('" & numeros_de_serie(i) & "', GETDATE(), 'ACTIVA', " & cliente_albaran
													historico_imp = historico_imp & ", '" & direccion_ip & "', 'GAG ADMIN', " & pedido_albaran & ", " & tipo_renting & ")"
													'response.write("<BR>67 - INSERTAMOS EN EL HISTORICO DE IMPRESORAS: " & HISTORICO_IMP)
													connimprenta.Execute historico_imp,,adCmdText + adExecuteNoRecords
													

												'end if
												'impresora_activa.close
												
												
												
											Next
											'set impresora_activa = Nothing
										end if
									end if
								end if
							end if
							
							if estado_detalle="ENVIO PARCIAL" then	
								if albaran_detalle=albaran_nuevo then
										''response.write("<BR>-14e- son iguales los albaranes..")
										'Campos de los detalles de albaran
										'IdAlbaranDetalles, IdEmpresa, IdAlbaran, IdHojaRuta, idNTrabajo, Cantidad, Concepto, Importe, Documento, Ip_Mod, Fecha_Mod
										campos_albaranes="IdEmpresa, IdAlbaran, Cantidad, idNTrabajo, Concepto, Importe, Ip_Mod, Fecha_Mod"
										
										cadena_detalles_albaran="1, " & albaran_nuevo & ", " & cantidad_detalle & ", '" 
										cadena_detalles_albaran=cadena_detalles_albaran & trabajo_detalle & "', '" 
										cadena_detalles_albaran=cadena_detalles_albaran & descripcion_detalle
										cadena_detalles_albaran=cadena_detalles_albaran & "', " & REPLACE(ROUND(total_detalle,2),",",".") & ", '"
										cadena_detalles_albaran=cadena_detalles_albaran & direccion_ip & "', '" & fecha_albaran & "'"
										
										cadena_ejecucion_detalles_albaran="INSERT INTO ALBARANES_DETALLES (" & campos_albaranes & ")"
										cadena_ejecucion_detalles_albaran=cadena_ejecucion_detalles_albaran & " VALUES (" & cadena_detalles_albaran & ")"
										
										
										'response.write("<BR>68 - sql que ejecutamos para crear los detalles del albaran: " & cadena_ejecucion_detalles_albaran)
									
										conn_gag.Execute cadena_ejecucion_detalles_albaran,,adCmdText + adExecuteNoRecords
										
										''response.write("<BR>-15b- tenemos una cantidad pedida de: " & cantidad_pedida_detalle & " y se han enviado: " & cantidad_envidad_total_detalle)
									
										''response.write("<BR>DESCRIPCION DEL ARTICULO AL ALBARAN: " & descripcion_detalle)
										''response.write("<BR>ID DEL ARTICULO: " & ID_ARTICULO_DETALLE)
										'si es una impresora de gls, hay que añadir los numeros de serie de dichas impresoras para su gestion posterior
										if id_articulo_detalle="4583" then
											numeros_de_serie = Split(sn_impresoras, "###")

											direccion_ip=""
											if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
												direccion_ip = "" & Request.ServerVariables("HTTP_X_FORWARDED_FOR")
											  else
												direccion_ip = "" & Request.ServerVariables("REMOTE_ADDR")
											end if
											direccion_ip = "" & Request.ServerVariables("REMOTE_ADDR")
											tipo_renting=""
											set rs_renting=Server.CreateObject("ADODB.Recordset")
											with rs_renting
												.ActiveConnection=connimprenta
												.Source="SELECT RENTING_IMPRESORA_GLS FROM PEDIDOS"
												.Source= .Source & " WHERE ID = " & pedido_albaran
												'response.write("<br>69 - VEMOS EL TIPO DE RENTING DE LA IMPRESORA: " & .source)
												.OPEN
											end with
											if not rs_renting.eof then
												tipo_renting = "" & rs_renting("RENTING_IMPRESORA_GLS")
											  else
											  	tipo_renting = "NULL"
											end if
											rs_renting.close
											set rs_renting = Nothing
											
											For i = LBound(numeros_de_serie) To UBound(numeros_de_serie)
												cadena_insercion_imp = ""
												cadena_insercion_imp = "INSERT INTO GLS_IMPRESORAS (ID_CLIENTE, SN_IMPRESORA, FECHA_ALTA, ESTADO, ID_PEDIDO, RENTING)"
												cadena_insercion_imp = cadena_insercion_imp & " VALUES (" & cliente_albaran & ", '" & numeros_de_serie(i) & "'"
												cadena_insercion_imp = cadena_insercion_imp & ", GETDATE(), 'ACTIVA', " & pedido_albaran & ", " & tipo_renting & ")"
												'response.write("<br>70 - cadena insercion GLS IMPRESORAS, ENVIO PARCIAL: " & cadena_insercion_imp)

												connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
												connimprenta.Execute cadena_insercion_imp,,adCmdText + adExecuteNoRecords
												
												'metemos los datos tambien en el historico
												historico_imp = "INSERT INTO GLS_IMPRESORAS_HISTORICO (SN_IMPRESORA, FECHA, ESTADO, ASOCIADA_A, IP_USUARIO, PERFIL, ID_PEDIDO, RENTING)"
												historico_imp = historico_imp & " VALUES ('" & numeros_de_serie(i) & "', GETDATE(), 'ACTIVA', " & cliente_albaran
												historico_imp = historico_imp & ", '" & direccion_ip & "', 'GAG ADMIN', " & pedido_albaran & ", " & tipo_renting & ")"
												'response.write("<BR>71 - INSERTAMOS EN EL HISTORICO DE IMPRESORAS: " & HISTORICO_IMP)
												connimprenta.Execute historico_imp,,adCmdText + adExecuteNoRecords
												
												
											Next
										end if
									
								end if
							end if

							'si son articulos de las familias de merchandising (222,223,224,225)
							'no lo meto en observaciones, lo meto en la descripcion
							'if detalles_pedido_albaran("familia")="222" or detalles_pedido_albaran("familia")="223" or detalles_pedido_albaran("familia")="224" or detalles_pedido_albaran("familia")="225" then
							'	cadena_detalles_merchan=cadena_detalles_merchan & chr(13) & detalles_pedido_albaran("codigo_sap") & "  " & detalles_pedido_albaran("descripcion") & " (Exp.: " & "xxxxxxx)"
							'end if 

						end if
						
						detalles_pedido_albaran.movenext
					wend
					detalles_pedido_albaran.close
					set detalles_pedido_albaran=Nothing
					
					
					
					'si el pedido tiene un descuento (por ser primer pedido), genero un detalle con ese descuento
					' pero miro a ver si ya hay albaran previo (por envio parcial), ya que se aplicará el descuento en el primero
					if  descuento_pedido<>"" AND descuento_pedido<>"0" then
						hay_albaran_previo="NO"
						set albaran_previo=Server.CreateObject("ADODB.Recordset")
						with albaran_previo
							.ActiveConnection=conn_gag
							.Source="SELECT * FROM ALBARANES a"
							.Source= .Source & " INNER JOIN Albaranes_Detalles b"
							.Source= .Source & " on a.IdAlbaran=b.IdAlbaran"
							'hay que cambiarlo para lo de globaliagifts que el numero de pedido será alfanumerico
							'.Source= .Source & " WHERE NPedido = '" & pedido_albaran & "'"
							.Source= .Source & " WHERE NPedido = " & pedido_albaran
							.Source= .Source & " and b.concepto='Descuento 15% Primer Pedido'"
							'response.write("<br>72 - VEMOS SI HAY ALGUN ALBARAN PREVIO SOBRE ESE PEDIDO: " & .source)
							.OPEN
						end with
						
						if not albaran_previo.eof then
							''response.write("<br>ha encontrado albaran previo para el mismo pedido")
							hay_albaran_previo="SI"
						end if
						
						albaran_previo.close
						set albaran_previo=Nothing
						
						''response.write("<br>el valor de hay albaran previo: " & hay_albaran_previo)
						'si no hay albaran previo entonces tengo que generar la linea de los gastos de envio
						if hay_albaran_previo="NO" then
												
							campos_albaranes="IdEmpresa, IdAlbaran, Cantidad, idNTrabajo, Concepto, Importe, Ip_Mod, Fecha_Mod"
							
							cadena_detalles_albaran="1, " & albaran_nuevo & ", 1, NULL, 'Descuento 15% Primer Pedido'"
							cadena_detalles_albaran=cadena_detalles_albaran & ", (-1) * " & REPLACE(descuento_pedido, "," ,".") & ", '"
							cadena_detalles_albaran=cadena_detalles_albaran & direccion_ip & "', '" & fecha_albaran & "'"

							cadena_ejecucion_detalles_albaran="INSERT INTO ALBARANES_DETALLES (" & campos_albaranes & ")"
							cadena_ejecucion_detalles_albaran=cadena_ejecucion_detalles_albaran & " VALUES (" & cadena_detalles_albaran & ")"
							
							
							'response.write("<BR>73 - NO HAY ALBARAN PREVIO, sql que ejecutamos para crear los detalles del albaran PARA EL 15% DE DESCUENTO EN EL PRIMER PEDIDO: " & cadena_ejecucion_detalles_albaran)
						
							conn_gag.Execute cadena_ejecucion_detalles_albaran,,adCmdText + adExecuteNoRecords
						end if
												
					end if
					
					
					
					
					
					'lo mismo hay que hacer como los gastos de envio, que solo se refleje en el primer albaran
					'al final en los albaranos no van detalles de saldos, ni de cargos ni de abonos
					'if datos_saldos<>"" then
					'	hay_albaran_previo="NO"
					'		set albaran_previo=Server.CreateObject("ADODB.Recordset")
					'		with albaran_previo
					'			.ActiveConnection=conn_gag
					'			.Source="SELECT * FROM ALBARANES a"
					'			.Source= .Source & " INNER JOIN Albaranes_Detalles b"
					'			.Source= .Source & " on a.IdAlbaran=b.IdAlbaran"
					'			.Source= .Source & " WHERE NPedido=" & pedido_albaran
					'			.Source= .Source & " and b.concepto like 'Saldo %'"
								''response.write("<br>" & .source)
					'			.OPEN
					'		end with
							
					'		if not albaran_previo.eof then
								''response.write("<br>ha encontrado albaran previo para el mismo pedido")
					'			hay_albaran_previo="SI"
					'		end if
							
					'		albaran_previo.close
					'		set albaran_previo=Nothing
							
							''response.write("<br>el valor de hay albaran previo: " & hay_albaran_previo)
							'si no hay albaran previo entonces tengo que generar la linea de los saldos
					'		if hay_albaran_previo="NO" then
					'			tabla_saldos=Split(datos_saldos,"@@@")
					'			for each x in tabla_saldos
					'				if x <>"" then
					'					saldo=Split(x, "###")
										''response.write("<br>dentro de cada saldo: " & x)
					'					id_saldo=saldo(0)
					'					importe_saldo=saldo(1)
					'					cargo_abono=saldo(2)
										
					'						campos_albaranes="IdEmpresa, IdAlbaran, Cantidad, idNTrabajo, Concepto, Importe, Ip_Mod, Fecha_Mod"
											
					'						cadena_detalles_albaran="1, " & albaran_nuevo & ", 1, NULL"
					'						if cargo_abono="CARGO" then
					'							cadena_detalles_albaran=cadena_detalles_albaran & ", 'Saldo " & id_saldo & " - CARGO', " & REPLACE(importe_saldo, "," ,".") & ", '"
					'						  else
					'						  	cadena_detalles_albaran=cadena_detalles_albaran & ", 'Saldo " & id_saldo & " - ABONO', (-1) * " & REPLACE(importe_saldo, "," ,".") & ", '"
					'						end if
					'						cadena_detalles_albaran=cadena_detalles_albaran & direccion_ip & "', '" & fecha_albaran & "'"
											
					'						cadena_ejecucion_detalles_albaran="INSERT INTO ALBARANES_DETALLES (" & campos_albaranes & ")"
					'						cadena_ejecucion_detalles_albaran=cadena_ejecucion_detalles_albaran & " VALUES (" & cadena_detalles_albaran & ")"
											
											
											''response.write("<BR>-15- sql que ejecutamos para crear los detalles del albaran: " & cadena_ejecucion_detalles_albaran)
										
					'						conn_gag.Execute cadena_ejecucion_detalles_albaran,,adCmdText + adExecuteNoRecords
										
					'				end if	
					'			next
					'		end if
					'end if
					
					
					
					
					
					'lo mismo hay que hacer como los gastos de envio, que solo se refleje en el primer albaran
					if datos_devoluciones<>"" then
						hay_albaran_previo="NO"
							set albaran_previo=Server.CreateObject("ADODB.Recordset")
							with albaran_previo
								.ActiveConnection=conn_gag
								.Source="SELECT * FROM ALBARANES a"
								.Source= .Source & " INNER JOIN Albaranes_Detalles b"
								.Source= .Source & " on a.IdAlbaran=b.IdAlbaran"
								'hay que cambiarlo para lo de globaliagifts que el numero de pedido será alfanumerico
								'.Source= .Source & " WHERE NPedido = '" & pedido_albaran & "'"
								.Source= .Source & " WHERE NPedido = " & pedido_albaran
								.Source= .Source & " and b.concepto like 'Devolución %'"
								'response.write("<br>74 - VEMOS SI HAY ALBARAN PREVIO PARA AÑADIR DETALLE DE DEVOLUCIONES: " & .source)
								.OPEN
							end with
							
							if not albaran_previo.eof then
								''response.write("<br>ha encontrado albaran previo para el mismo pedido")
								hay_albaran_previo="SI"
							end if
							
							albaran_previo.close
							set albaran_previo=Nothing
							
							''response.write("<br>el valor de hay albaran previo: " & hay_albaran_previo)
							'si no hay albaran previo entonces tengo que generar la linea de las devoluciones
							if hay_albaran_previo="NO" then
								tabla_devoluciones=Split(datos_devoluciones,"@@@")
								for each x in tabla_devoluciones
									if x <>"" then
										devolucion=Split(x, "###")
										''response.write("<br>dentro de cada devolucion: " & x)
										id_devolucion=devolucion(0)
										importe_devolucion=devolucion(1)
										
											campos_albaranes="IdEmpresa, IdAlbaran, Cantidad, idNTrabajo, Concepto, Importe, Ip_Mod, Fecha_Mod"
											
											cadena_detalles_albaran="1, " & albaran_nuevo & ", 1, NULL, 'Devolución " & id_devolucion & "'"
											cadena_detalles_albaran=cadena_detalles_albaran & ", (-1) * " & REPLACE(importe_devolucion, "," ,".") & ", '"
											cadena_detalles_albaran=cadena_detalles_albaran & direccion_ip & "', '" & fecha_albaran & "'"
											
											cadena_ejecucion_detalles_albaran="INSERT INTO ALBARANES_DETALLES (" & campos_albaranes & ")"
											cadena_ejecucion_detalles_albaran=cadena_ejecucion_detalles_albaran & " VALUES (" & cadena_detalles_albaran & ")"
											
											
											'response.write("<BR>75- NO HAY ALBARAN PREVIO, sql que ejecutamos para crear los detalles del albaran CON LA DEVOLUCIONES ASOCIADAS: " & cadena_ejecucion_detalles_albaran)
										
											conn_gag.Execute cadena_ejecucion_detalles_albaran,,adCmdText + adExecuteNoRecords
										
									end if	
								next
							end if
					end if
					
					
					'si el pedido tiene gastos de envio (MALETAS GLOBALGAB), genero un detalle con esos gastos de envio
					' pero miro a ver si ya hay albaran previo (por envio parcial), ya que se cargará en el primero los gastos de envio
					if  gastos_envio<>"" AND gastos_envio<>"0" then
						hay_albaran_previo="NO"
						set albaran_previo=Server.CreateObject("ADODB.Recordset")
						with albaran_previo
							.ActiveConnection=conn_gag
							.Source="SELECT * FROM ALBARANES a"
							.Source= .Source & " INNER JOIN Albaranes_Detalles b"
							.Source= .Source & " on a.IdAlbaran=b.IdAlbaran"
							'hay que cambiarlo para lo de globaliagifts que el numero de pedido será alfanumerico
							'.Source= .Source & " WHERE NPedido = '" & pedido_albaran & "'"
							.Source= .Source & " WHERE NPedido = " & pedido_albaran
							.Source= .Source & " and b.concepto='Gastos de Envio'"
							'response.write("<br>76 - VEMOS SI HAY ALBARAN PREVIO PARA LOS GASTOS DE ENVIO DE LAS MALETAS GLOBAL BAG: " & .source)
							.OPEN
						end with
						
						if not albaran_previo.eof then
							''response.write("<br>ha encontrado albaran previo para el mismo pedido")
							hay_albaran_previo="SI"
						end if
						
						albaran_previo.close
						set albaran_previo=Nothing
						
						''response.write("<br>el valor de hay albaran previo: " & hay_albaran_previo)
						'si no hay albaran previo entonces tengo que generar la linea de los gastos de envio
						if hay_albaran_previo="NO" then
												
							campos_albaranes="IdEmpresa, IdAlbaran, Cantidad, idNTrabajo, Concepto, Importe, Ip_Mod, Fecha_Mod"
							
							cadena_detalles_albaran="1, " & albaran_nuevo & ", 1, NULL, 'Gastos de Envio',"
							cadena_detalles_albaran=cadena_detalles_albaran & REPLACE(gastos_envio, "," ,".") & ", '"
							cadena_detalles_albaran=cadena_detalles_albaran & direccion_ip & "', '" & fecha_albaran & "'"
							
							cadena_ejecucion_detalles_albaran="INSERT INTO ALBARANES_DETALLES (" & campos_albaranes & ")"
							cadena_ejecucion_detalles_albaran=cadena_ejecucion_detalles_albaran & " VALUES (" & cadena_detalles_albaran & ")"
							
							
							'response.write("<BR>77 - NO HAY ALBARAN PREVIO, sql que ejecutamos para crear los detalles del albaran CON LOS GASTOS DE ENVIO DE LAS MALETAS GLOBALBAG: " & cadena_ejecucion_detalles_albaran)
						
							conn_gag.Execute cadena_ejecucion_detalles_albaran,,adCmdText + adExecuteNoRecords
						end if
												
					end if
					

					'ahora vemos si tenemos que escribir observaciones con los articulos que pudieran quedar por enviar
					set  observaciones_albaran=Server.CreateObject("ADODB.Recordset")
					with observaciones_albaran
							.ActiveConnection=connimprenta
							'.Source="SELECT * FROM PEDIDOS_DETALLES INNER JOIN ARTICULOS"
							'.Source= .Source & " ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID"
							'.Source= .Source & " WHERE ID_PEDIDO=" & pedido_albaran
							
							.Source="SELECT a.id, a.id_pedido, a.estado, a.cantidad, b.codigo_sap, b.descripcion,"
							.Source= .Source & " (select sum(cantidad_enviada) from pedidos_envios_parciales"
							.Source= .Source & " where pedidos_envios_parciales.id_pedido=a.id_pedido"
							.Source= .Source & " and pedidos_envios_parciales.id_articulo=a.articulo) as cantidad_enviada_total"
							.Source= .Source & " FROM PEDIDOS_DETALLES a INNER JOIN ARTICULOS b" 
							.Source= .Source & " ON a.ARTICULO = b.ID"
							.Source= .Source & " WHERE a.ID_PEDIDO=" & pedido_albaran
							
							'response.write("<BR>78 - recogemos los detalles del pedido y las cantidades enviadas para ver si hay que poner observaciones DE LOS ARTICULOS QUE QUEDAN POR ENVIAR: " & .source)
					
							.Open
					end with
					
					cadena_articulos_pendientes=""
					while not observaciones_albaran.eof
						if ((observaciones_albaran("estado")<>"ENVIADO") AND (observaciones_albaran("estado")<>"ENVIADO AL PROVEEDOR") AND (observaciones_albaran("estado")<>"ANULADO")) THEN
							if cadena_articulos_pendientes="" then
								cadena_articulos_pendientes="Quedarían Pendientes de Enviar los Siguientes Articulos:" & chr(13)
							end if
							resta_1="" & observaciones_albaran("cantidad_enviada_total")
							if resta_1="" then
								resta_1=0
							end if
							resultado_resta=observaciones_albaran("cantidad") - resta_1
							cadena_articulos_pendientes=cadena_articulos_pendientes & chr(13) & "- " & resultado_resta & "        " & observaciones_albaran("descripcion")
						end if
						observaciones_albaran.movenext
					wend
					
					observaciones_albaran.close
					set observaciones_albaran=Nothing
					
					'pongo el expiente en la descripcion de cada detalle no en las observaciones del albaran
					'if cadena_detalles_merchan<>"" then
					'	cadena_articulos_pendientes=cadena_articulos_pendientes & chr(13) & chr(13) & "Articulos de Merchandising:" & chr(13) & cadena_detalles_merchan
					'end if
					
					if bultos<>"" then
						cadena_primera="Bultos: " & bultos & chr(13)
					end if
					if palets<>"" and palets<>"0" then
						cadena_primera=cadena_primera & "Palets: " & palets & chr(13)
					end if
					if peso<>"" then
						cadena_primera=cadena_primera & "Peso: " & peso & " gramos" & chr(13) & chr(13)
					end if
					
					cadena_articulos_pendientes = cadena_primera & cadena_articulos_pendientes
					
					if observaciones_sn_impresoras <> "" then
						cadena_articulos_pendientes = cadena_articulos_pendientes & chr(13) & chr(13) & observaciones_sn_impresoras
					end if
					
					'solo lo ponemos en la direccion de entrega
					'si es un envio de ropa de empleado de globalia, ha de ir a su atencion
					'if cadena_att_empleado<>"" then
					'	cadena_articulos_pendientes= "Att: " & cadena_att_empleado & chr(13) &  chr(13) & cadena_articulos_pendientes
					'end if
					
					if cadena_articulos_pendientes<>"" then
						cadena_actualizacion_albaran="UPDATE ALBARANES"
						cadena_actualizacion_albaran=cadena_actualizacion_albaran & " SET OBSERVACIONES=cast(OBSERVACIONES as nvarchar(max)) + '" & cadena_articulos_pendientes & "'"
						cadena_actualizacion_albaran=cadena_actualizacion_albaran & " WHERE IDALBARAN=" & albaran_nuevo
						
						
						'response.write("<BR>79 - actualizo el albaran con las observaciones PORQUE HAY ARTICULOS SIN ENVIAR: " & cadena_actualizacion_albaran)
					
						conn_gag.Execute cadena_actualizacion_albaran,,adCmdText + adExecuteNoRecords
								
					end if
					
					
					
					
					
					'response.write("<BR>----------------------------------------------<BR>80 ------------------------ FIN TRANSACCION CONN GAG")
					conn_gag.CommitTrans
		
					
					set cmd=Nothing
		
					conn_gag.close
					set conn_gag=Nothing
		
		
					'set  sucursales=Server.CreateObject("ADODB.Recordset")
					'with sucursales
						'	.ActiveConnection=conndistribuidora
						'	.Source="SELECT COD"
						'	.Source= .Source & " FROM SUCURSALES"
						'	.Source= .Source & " WHERE (Empresa =" & codigo_empresa & ")"
						'	.Source= .Source & " and codigo='" & codsucursal & "'"
						'	.Source= .Source & " AND (Activa = 1)"
						'	.Open
					'end with
					'codigo_sucursal_bueno=sucursales("cod")
					'sucursales.close
					'set sucursales=Nothing
				
		
		
		
		

			end if 'comprobacion para crear el albaran


		
		
		end if 'albaran
	
	'response.write("<BR>----------------------<BR>81 --------------------------- FINAL TRANSACCION CONNIMPRENTA")
	connimprenta.CommitTrans ' finaliza la transaccion






   	
			   
   	'connimprenta.BeginTrans 'Comenzamos la Transaccion
	'connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
	
	'connimprenta.CommitTrans ' finaliza la transaccion
	
	
%>

<HTML>
<HEAD>
<TITLE>Grabar Pedido</TITLE>
<meta charset="UTF-8">
</HEAD>
<script language="javascript" runat="server" src="json2_a.asp"></script>
<script language="JScript" runat="server">
function CheckProperty(obj, propName) {
    return (typeof obj[propName] != "undefined");
}
</script>
<script language="javascript">
function validar(creamos_albaran,numero_albaran, accion, enviar_email_al_proveedor, sn_impresora_activa)
{
	cadena='El Pedido Ha sido Modificado con Exito...'
	
	//cadena+='\naccion: ' +  accion
	//cadena+='\ncreamos albaran: ' +  creamos_albaran
	
	if (creamos_albaran=='SI')
		{
		cadena= cadena + '\n\nse ha creado el albarán número ' + numero_albaran + ' referente a los artículos enviados de este pedido.'
		}
	if (creamos_albaran=='NO')
		{
		cadena= cadena + '\n\nno se ha creado el albarán ya que no hay nuevos articulos enviados sobre los que crear albarán.'
		}
		
	
	if (enviar_email_al_proveedor=='SI')
		{
		cadena= cadena + '\n\nAl ser un pedido de ROTULACIÓN se enviará tambien un correo con este pedido al Proveedor para que lo Gestione Directamente.'
		}
			
	if (sn_impresora_activa != '')
		{
		cadena = 'NO SE HA GUARDADO EL PEDIDO PORQUE LA IMPRESORA ' + sn_impresora_activa + ' ASOCIADA A EL SIGUE ACTIVA Y NO ESTABA DADA DE BAJA.'
		}
	
	alert(cadena)
	
	if (sn_impresora_activa != '')
		{
		//volver al pedido
		document.getElementById('ocultoorigen').value='MODIFICAR'	
		document.getElementById('frmmodificar_pedido').submit()
		}
	  else
	  	{
		//todavia no esta redirigido a la pagina que envia los mails si es un pedido de rotulacion
		if (creamos_albaran=='SI')
			{
			if (enviar_email_al_proveedor=='SI')
				{
				document.getElementById('ocultodestino_proveedor').value='VOLVER'	
				document.getElementById('frmenviar_email_proveedor').submit()
				}
			 else
				{
				document.getElementById('frmvolver').submit()	
				}
			}
		  else
			{
			if (accion=='IMPRIMIR')
				{
				document.getElementById('ocultoorigen').value='MODIFICAR_IMPRIMIR'	
				document.getElementById('frmmodificar_pedido').submit()	
				}
			  else
				{
				
				if (enviar_email_al_proveedor=='SI')
					{
					//alert('email rotulacion')
					document.getElementById('ocultodestino_proveedor').value='VOLVER'	
					document.getElementById('frmenviar_email_proveedor').submit()
					}
				 else
					{
					//alert('regresamos')
					document.getElementById('frmvolver').submit()	
					}
				}
	
			} //accion imprimir
		}//creamos albaran
	
	/**********************************************
	2016_09_28, ya no quieren que se muestre el programqa de albarantes despues de generarse desde el carrito
	if (creamos_albaran=='SI')
		{
		if ('<%Request.ServerVariables("server_name")%>'!='192.168.150.97')
			{
			direccion='http://192.168.153.132/Albagrafic/default.aspx'
			}
	  	  else
			{
			direccion='http://192.168.150.97/Albagrafic/default.aspx'
			}
		//document.getElementById('frmalbaran').action='http://192.168.153.132/Albagrafic/default.aspx?codigo_albaran=' + numero
		direccion=direccion + '?codigo_albaran=' + numero_albaran + '&act=t'
		//alert('nos movemos a la direccion ' + direccion)
		window.open(direccion, '_blank')
   		}
	
	****************************************/
	
	
	
	
	
	//regreso a la lista de pedidos a gestionar
	////////////document.getElementById('frmmodificar_pedido').submit()	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>




   
<BODY onload="validar('<%=creamos_albaran%>','<%=albaran_nuevo%>', '<%=acciones%>', '<%=enviar_email_al_proveedor%>', '<%=sn_impresora_activa%>')">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>

<form name="frmvolver" id="frmvolver" method="post" action="Consulta_Pedidos_GAGAD.asp">
</form>

<form name="frmmodificar_pedido" id="frmmodificar_pedido" action="Pedido_GAGAD.asp" method="post">
	<input type="hidden" value="<%=pedido_seleccionado%>" name="ocultopedido" id="ocultopedido" />
	<input type="hidden" value="MODIFICAR" name="ocultoorigen" id="ocultoorigen" />
</form>

<form name="frmenviar_email_proveedor" id="frmenviar_email_proveedor" action="Enviar_Email_Al_Proveedor.asp" method="post">
	<input type="hidden" value="<%=pedido_seleccionado%>" name="ocultopedido_proveedor" id="ocultopedido_proveedor" />
	<input type="hidden" value="" name="ocultodestino_proveedor" id="ocultodestino_proveedor" />
</form>



</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
	

   </HTML>
