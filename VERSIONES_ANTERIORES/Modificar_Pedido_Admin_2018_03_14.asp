<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->


<%


sub comprobar_envio_email_stock(codigo_sap_articulo, descripcion_articulo, stock_articulo, stock_minimo_articulo, marca_articulo)%>
	<!--#include file="Conexion_ORACLE_Envios_Distri_PRODUCCION.inc"-->


<%
	adCmdStoredProc=4
	adVarChar=200
	adParamInput=1

		
	set cmd = Server.CreateObject("ADODB.Command")
	'set cmd2 = Server.CreateObject("ADODB.Command")
	set cmd.ActiveConnection = conn_envios_distri
	'set cmd2.ActiveConnection = conndistribuidora
	
	
	if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
		'ENTORNO PRUEBAS
		entorno="PRUEBAS"
	  else
		'ENTORNO REAL
		entorno="REAL"
	end if
	
	cmd.CommandText = "PAQUETE_ENVIOS_DISTRI.ENVIAR_MAIL"
	cmd.CommandType = adCmdStoredProc
		
	cmd.parameters.append cmd.createparameter("P_ENVIA",adVarChar,adParamInput,255)
	cmd.parameters.append cmd.createparameter("P_RECIBE",adVarChar,adParamInput,255)
	cmd.parameters.append cmd.createparameter("P_ASUNTO",adVarChar,adParamInput,255)
	cmd.parameters.append cmd.createparameter("P_MENSAJE",adVarChar,adParamInput,255)
	cmd.parameters.append cmd.createparameter("P_HOST",adVarChar,adParamInput,255)
	'cmd.parameters.append cmd.createparameter("C_ALTO_GENERICO",adInteger,adParamInput,2)
	'cmd.parameters.append cmd.createparameter("C_PESO_GENERICO",adDouble,adParamInput)
		
	'cmd.parameters.append cmd.createparameter("texto_explicacion",adVarChar,adParamOutPut,255)
		
	cmd.parameters("P_ENVIA")="carlos.gonzalez@globalia-artesgraficas.com"
	'cmd.parameters("P_RECIBE")="carlos.gonzalez@globalia-artesgraficas.com;malba@halconviajes.com;silvia.rodriguez@halconviajes.com"
	'cmd.parameters("P_RECIBE")="plopez@halconviajes.com;carlos.gonzalez@globalia-artesgraficas.com"
    emails_reciben="carlos.gonzalez@globalia-artesgraficas.com"
	if entorno="PRUEBAS" then
		emails_reciben=emails_reciben & ";malba@halconviajes.com"
	end if
	cmd.parameters("P_RECIBE")=emails_reciben
	
	texto_asunto="ROTURA DE STOCK ARTICULO " & codigo_sap_articulo
	if entorno="PRUEBAS" then
		texto_asunto="PRUEBAS... " & texto_asunto
	end if
	cmd.parameters("P_ASUNTO")=texto_asunto
			
	mensaje="ROTURA DE STOCK DEL ARTICULO:<BR>"
	mensaje=mensaje & "<BR>Codigo Sap: " & codigo_sap_articulo
	mensaje=mensaje & "<BR>Descripción Articulo: " & descripcion_articulo
	mensaje=mensaje & "<BR>Stock Actual (" & marca_articulo & "): " & stock_articulo
	mensaje=mensaje & "<BR>Stock Minimo Establecido (" & marca_articulo & "): " & stock_minimo_articulo
		
	cmd.parameters("P_MENSAJE")=mensaje
	'cmd.parameters("P_HOST")="195.76.0.183"
	cmd.parameters("P_HOST")="192.168.150.44"
		   
	cmd.execute()
		
		
		
	set cmd=Nothing
			
	
	conn_envios_distri.close
	set conn_envios_distri=Nothing

end sub

	
    if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
	end if
		
	
		
		
	pedido_seleccionado=Request.Form("ocultopedido")
	articulos_cantidades_pedido=Request.Form("ocultoarticulos_cantidades_pedido")
	marca_articulos=Request.Form("ocultomarca")
	acciones=Request.Form("ocultoacciones")
	codcli=Request.Form("ocultocodcli")
	'response.write("<br>articulos: " & articulos_pedido)
	'response.write("<br>CANTIDADES: " & articulos_cantidades_pedido)
	
	'response.write("<br>pedido..." & pedido_seleccionado)
	'response.write("<br>cadena articulos..." & articulos_pedido)
	'response.write("<br>cadena articulos..." & Request.Form("ocultoarticulos_pedido"))
   	tabla_articulos_cantidades=Split(articulos_cantidades_pedido,"--")
	

	
	
	
	'response.write("<br>hola...")
	'como hay que tocar varias cosas de la base de datos, ponemos una transaccion
	connimprenta.BeginTrans 'Comenzamos la Transaccion
	For i = 0 to UBound(tabla_articulos_cantidades)
   		'response.write("<br>articulo numero " & i & ": " & tabla_articulos_cantidades(i))
		'campo="cmbestados_" & tabla_articulos_cantidades(i)
		'RESPONSE.WRITE("<BR>campo: " & campo) 
		'ahora separo cada articulo, de su cantidad, y si se ha restado ya del stock o no...
		articulo_cantidad=Split(tabla_articulos_cantidades(i),"::")
		'RESPONSE.WRITE("<BR>COMBO ESTADO: " & Request.Form("cmbestados_" & articulo_cantidad(0))) 

		cadena_ejecucion="UPDATE PEDIDOS_DETALLES SET ESTADO='" & Request.Form("cmbestados_" & articulo_cantidad(0)) & "', HOJA_RUTA='"
		cadena_ejecucion=cadena_ejecucion & Request.Form("txthoja_ruta_" & articulo_cantidad(0)) & "'"
		cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado & " AND ARTICULO=" & articulo_cantidad(0)
		'RESPONSE.WRITE("<BR><br>-1- actualizacion detalle pedido: " & CADENA_EJECUCION)
		
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
		
		'response.write("<br>CAantidad almacenada en ocultocantidad_enviada_total_" & articulo_cantidad(0) & ": " & request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0)))
		'response.write("<br>y tendriamos que enviar: " & articulo_cantidad(1))
		
		oculto_cantidad_enviada=request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))
		cantidad_pedido=articulo_cantidad(1)
		'response.write("<br>articulo-cantidad-restado stoch: " & tabla_articulos_cantidades(i))
		'si ya esta restado el stock previamente no lo tengo que volver a restar
		' Y SOLO TENGO EN CUENTA LOS MARCADOS COMO ENVIADOS o ENVIO PARCIAL a los que les falte enviar algo
		if ((articulo_cantidad(2)<>"SI" AND Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO") _
			OR (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" AND Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0))<>"") _
			OR (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
								AND cantidad_pedido<>oculto_cantidad_enviada) _
			) then
			
			'response.write("<br><br>hacemos gestiones con el articulo: " & articulo_cantidad(0))
			'vemos si el articulo, en realidad es un kit de varios articulos juntos
			set control_kit=Server.CreateObject("ADODB.Recordset")
					
			sql="SELECT * FROM CONFIGURACION_KITS"
			sql=sql & " WHERE CODIGO_KIT=" & articulo_cantidad(0)
			'response.write("<br>consulta configuracion kits" & sql)
																	
			with control_kit
				.ActiveConnection=connimprenta
				.CursorType=3 'adOpenStatic
				.Source=sql
				.Open
			end with
			
			if not control_kit.eof then
					'si el articulo es un kit de ariticulos, recorremos cada uno
					' de los articulos que componen el kit y restamos el stock
					while not control_kit.eof
						cadena_ejecucion="UPDATE ARTICULOS_MARCAS SET STOCK = "
						cadena_ejecucion=cadena_ejecucion & " CASE "
						'si es un envio parcial, resto solo la cantidad concreta que se envia, no todas las unidades pedidas
						IF (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL") _
						 THEN
							cantidad_parcial=Request.Form("txtcantidad_a_enviar_" & articulo_cantidad(0))
							cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & (cantidad_parcial * control_kit("cantidad"))
						 ELSE
						 	IF (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
								AND cantidad_pedido<>oculto_cantidad_enviada) THEN
							 	cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & ((cantidad_pedido-oculto_cantidad_enviada) * control_kit("cantidad"))
							  ELSE
							  	cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & (articulo_cantidad(1) * control_kit("cantidad"))
							END IF
						END IF
						cadena_ejecucion=cadena_ejecucion & " ELSE null"
						cadena_ejecucion=cadena_ejecucion & " END"
						cadena_ejecucion=cadena_ejecucion & " WHERE ID_ARTICULO=" & control_kit("CODIGO_ARTICULO")
						cadena_ejecucion=cadena_ejecucion & " AND MARCA='STANDARD'"
						'RESPONSE.WRITE("<BR> actualizacion del stock de articulos (KIT): " & CADENA_EJECUCION)
						
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
						
						
						control_kit.movenext
					wend
					
					'si es un envio parcial, meto los datos que se envian en la tabla correspondiente						
						'***********OJO AQUI QUE ES UN KIT... A VER DE DONDE SE RESTA... CADA ARTICULO O EL KIT EN SI
						'********************
						IF Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" THEN
							cadena_parcial="INSERT INTO PEDIDOS_ENVIOS_PARCIALES (ID_PEDIDO, ID_ARTICULO, CANTIDAD_ENVIADA, FECHA)"
							cadena_parcial=cadena_parcial & " VALUES(" & pedido_seleccionado
							cadena_parcial=cadena_parcial & ", " & articulo_cantidad(0)
							cadena_parcial=cadena_parcial & ", " & cantidad_parcial
							cadena_parcial=cadena_parcial & ", '" & date() & "'"
							cadena_parcial=cadena_parcial & ")"
						
							'RESPONSE.WRITE("<BR> es un envio parcial DE KIT: " & CADENA_PARCIAL)
							connimprenta.Execute cadena_parcial,,adCmdText + adExecuteNoRecords
						  ELSE
							IF (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
								AND cantidad_pedido<>oculto_cantidad_enviada) THEN
				
								cadena_parcial="INSERT INTO PEDIDOS_ENVIOS_PARCIALES (ID_PEDIDO, ID_ARTICULO, CANTIDAD_ENVIADA, FECHA)"
								cadena_parcial=cadena_parcial & " VALUES(" & pedido_seleccionado
								cadena_parcial=cadena_parcial & ", " & articulo_cantidad(0)
								cadena_parcial=cadena_parcial & ", " & (cantidad_pedido-oculto_cantidad_enviada)
								cadena_parcial=cadena_parcial & ", '" & date() & "'"
								cadena_parcial=cadena_parcial & ")"
							
								'RESPONSE.WRITE("<BR> es un envio total de unos envios parciales DE KIT: " & CADENA_PARCIAL)
								connimprenta.Execute cadena_parcial,,adCmdText + adExecuteNoRecords
							END IF
						END IF
						
					
				else
					'si no es un kit, simplemente resta el stock del articulo				
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
					 ELSE
					 	IF (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
								AND cantidad_pedido<>oculto_cantidad_enviada) THEN
									cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & (cantidad_pedido-oculto_cantidad_enviada)
						  ELSE
						  	cadena_ejecucion=cadena_ejecucion & " WHEN (NOT STOCK IS NULL) THEN STOCK - " & articulo_cantidad(1)
						END IF
					END IF
					cadena_ejecucion=cadena_ejecucion & " ELSE null"
					cadena_ejecucion=cadena_ejecucion & " END"
					
					'EN ACCESS NO FUNCIONA EL CASE... END, SINO EL IFF
					'cadena_ejecucion=cadena_ejecucion & " IIF(STOCK<>null, STOCK-" & articulo_cantidad(1) & ", null)"
					
					cadena_ejecucion=cadena_ejecucion & " WHERE ID_ARTICULO=" & articulo_cantidad(0)
					cadena_ejecucion=cadena_ejecucion & " AND MARCA='" & marca_articulos & "'"
					'y restaod estock si?
					'RESPONSE.WRITE("<BR><br>-2- actualizacion del stock de articulos: " & CADENA_EJECUCION)
					
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					'si es un envio parcial, meto los datos que se envian en la tabla correspondiente						
					'***********OJO AQUI QUE ES UN KIT... A VER DE DONDE SE RESTA... CADA ARTICULO O EL KIT EN SI
					'********************
					IF Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIO PARCIAL" THEN
						cadena_parcial="INSERT INTO PEDIDOS_ENVIOS_PARCIALES (ID_PEDIDO, ID_ARTICULO, CANTIDAD_ENVIADA, FECHA)"
						cadena_parcial=cadena_parcial & " VALUES(" & pedido_seleccionado
						cadena_parcial=cadena_parcial & ", " & articulo_cantidad(0)
						cadena_parcial=cadena_parcial & ", " & cantidad_parcial
						cadena_parcial=cadena_parcial & ", '" & date() & "'"
						cadena_parcial=cadena_parcial & ")"
					
						'RESPONSE.WRITE("<BR> es un envio parcial: " & CADENA_PARCIAL)
						
						'porque el sql de produccion es un sql expres que debe tener el formato de
						' de fecha con mes-dia-año
						connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
						connimprenta.Execute cadena_parcial,,adCmdText + adExecuteNoRecords
					  ELSE
							IF (Request.Form("cmbestados_" & articulo_cantidad(0))="ENVIADO" AND Request.form("ocultocantidad_enviada_total_" & articulo_cantidad(0))<>"" _
								AND cantidad_pedido<>oculto_cantidad_enviada) THEN
				
								cadena_parcial="INSERT INTO PEDIDOS_ENVIOS_PARCIALES (ID_PEDIDO, ID_ARTICULO, CANTIDAD_ENVIADA, FECHA)"
								cadena_parcial=cadena_parcial & " VALUES(" & pedido_seleccionado
								cadena_parcial=cadena_parcial & ", " & articulo_cantidad(0)
								cadena_parcial=cadena_parcial & ", " & (cantidad_pedido-oculto_cantidad_enviada)
								cadena_parcial=cadena_parcial & ", '" & date() & "'"
								cadena_parcial=cadena_parcial & ")"
							
								'RESPONSE.WRITE("<BR> es un envio total de unos envios parciales: " & CADENA_PARCIAL)
								
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
			'response.write("<br><br>COMPROBAMOS SI LOS ENVIOS PARCIALES LLEGAN AL TOTAL A ENVIAR")	
				set suma_envios_parciales=Server.CreateObject("ADODB.Recordset")
		
				with suma_envios_parciales
					.ActiveConnection=connimprenta
					cadena_ejecucion="SELECT SUM(CANTIDAD_ENVIADA) AS CANTIDAD_ENVIADA"
					cadena_ejecucion=cadena_ejecucion & " FROM PEDIDOS_ENVIOS_PARCIALES"
					cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado
					cadena_ejecucion=cadena_ejecucion & " AND ID_ARTICULO=" & articulo_cantidad(0)
					.Source=cadena_ejecucion
					'response.write("<br>- CONSULTA PARA SUMA DE ENVIOS PARCIALES: " & .source)
					.Open
				end with
				
				sumado=0
				IF not suma_envios_parciales.eof THEN
					sumado=suma_envios_parciales("cantidad_enviada")
				END IF
				suma_envios_parciales.close
				set suma_envios_parciales = Nothing
					
			'response.write("<br>- SUMA TOTAL DE ENVIOS PARCIALES: " & SUMADO)
			'response.write("<br>- CANTIDAD PEDIDA: " & articulo_cantidad(1))
			
			'esto ya no hace falta, PERO POR SI ACASO solo se resta cuando el pedido se pone enviado
			' en el estado de enviado no se puede modificar
			'para que solo se reste del stock una vez
			cadena_ejecucion="UPDATE PEDIDOS_DETALLES SET RESTADO_STOCK='SI'"
			'vemos si los envios parciales han completado la cantidad total a enviar
			' para poner el detalle en estado de enviado, y no dejarlo en envio parcial
			IF articulo_cantidad(1)<>"" AND sumado<>"" THEN
				if CINT(articulo_cantidad(1))=CINT(sumado) then
					cadena_ejecucion=cadena_ejecucion & ", ESTADO='ENVIADO'"
				end if
			END IF

			cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado & " AND ARTICULO=" & articulo_cantidad(0)
			'RESPONSE.WRITE("<BR><br>- CONSUTLA DE ACTUALIZACION: " & CADENA_EJECUCION)
			
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			
			
			'RESPONSE.WRITE("<BR><br>-- CONTROLAMOS SI HAY QUE MANDAR EMAIL DE ROTURA DE STOCK")
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
					'response.write("<br>- CONSULTA REALIZADA: " & .source)
					.Open
				end with
				
				
				while not control_email.eof
					'RESPONSE.WRITE("<BR>- HAY REGISTRO EN ARTICULOS_MARCAS")
					'RESPONSE.WRITE("<BR>- STOCK ACTUAL: " & control_email("stock") & " -- STOCK MINIMO: " & control_email("stock_minimo"))
					'si llegamos al stock mimino, enviamos el email
					IF control_email("stock")<=control_email("stock_minimo") then
						'response.write("<br><br>envio email stock------" & control_email("codigo_sap") & " - " & control_email("descripcion") & " - " & control_email("stock") & " - " & control_email("stock_minimo") & " - " & marca_articulos)

						comprobar_envio_email_stock control_email("codigo_sap"), control_email("descripcion"), control_email("stock"), control_email("stock_minimo"), marca_articulos
					end if
					control_email.movenext
				wend

				control_email.close
				set control_email = Nothing
				
				
				
				
			
		end if
	
	Next
	
	
	
	
	
	
	
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
			'response.write("<br>-4- se ve a que estado se ha de poner el pedido: " & .source)
			.Open
		end with

		if not estado_pedido.eof then
			estado_a_grabar=""
			estado_a_grabar=estado_pedido("estado")
			'si algunos de los articulos está en enviado, el estado del pedido a de ser ENVIO PARCIAL
			if estado_pedido("ESTADO")<>"ENVIADO" then
				set si_hay_enviados=Server.CreateObject("ADODB.Recordset")
		
				with si_hay_enviados
					.ActiveConnection=connimprenta
					cadena_ejecucion="SELECT * FROM PEDIDOS_DETALLES"
					cadena_ejecucion=cadena_ejecucion & " WHERE ID_PEDIDO=" & pedido_seleccionado
					cadena_ejecucion=cadena_ejecucion & " AND (ESTADO='ENVIADO' OR ESTADO='ENVIO PARCIAL')"
					.Source=cadena_ejecucion
					'response.write("<br>-5- se ve los detalle de pedido enviados: " & .source)
					.Open
				end with
				
				if not si_hay_enviados.eof then
					estado_a_grabar="ENVIO PARCIAL"
				end if

				si_hay_enviados.close
				set si_hay_enviados = Nothing
			end if
			cadena_ejecucion="UPDATE PEDIDOS SET ESTADO='" & estado_a_grabar & "'"
			IF estado_pedido("ESTADO")="ENVIADO" THEN
				cadena_ejecucion=cadena_ejecucion & ", FECHA_ENVIADO='" & date() & "'" 
			END IF
			cadena_ejecucion=cadena_ejecucion & " WHERE PEDIDOS.ID=" & pedido_seleccionado
			'RESPONSE.WRITE("<BR>-6- actualizacion del estado del pedido: " & CADENA_EJECUCION)
			
			'porque el sql de produccion es un sql expres que debe tener el formato de
			' de fecha con mes-dia-año
			connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
				
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
		end if
		
		
	
	
	
	
		estado_pedido.close
		set estado_pedido=Nothing
	
		'RESPONSE.WRITE("<BR>-7- comprobacion del campo acciones: " & acciones)
			
		'si le hemos dado a crear el albaran, despues de guardarlo todo, creamos el albaran
		if acciones="ALBARAN" then
			'RESPONSE.WRITE("<BR>-8- entramos en los albaranaes")
			
			'comprobamos si hay que crear albaranes
			set si_creamos_albaran=Server.CreateObject("ADODB.Recordset")
		
				with si_creamos_albaran
					.ActiveConnection=connimprenta
					cadena_ejecucion_comprobar="SELECT * FROM PEDIDOS_DETALLES LEFT OUTER JOIN PEDIDOS_ENVIOS_PARCIALES"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " ON PEDIDOS_DETALLES.ID_PEDIDO = PEDIDOS_ENVIOS_PARCIALES.ID_PEDIDO"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & "  AND PEDIDOS_DETALLES.ARTICULO = PEDIDOS_ENVIOS_PARCIALES.ID_ARTICULO"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " WHERE (PEDIDOS_DETALLES.ID_PEDIDO = " & pedido_seleccionado & ")"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " AND ("
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " ((PEDIDOS_DETALLES.ESTADO = 'ENVIADO') AND (PEDIDOS_DETALLES.ALBARAN IS NULL))"
					cadena_ejecucion_comprobar=cadena_ejecucion_comprobar & " OR ((PEDIDOS_DETALLES.ESTADO = 'ENVIO PARCIAL') and (pedidos_envios_parciales.albaran IS NULL))"
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
					'response.write("<br>-8b- vemos si hay detalles de pedido a los que crear albaran: " & .source)
					
					.Open
				end with
			
			creamos_albaran="SI"
			if si_creamos_albaran.eof then
				creamos_albaran="NO"
			end if
			
			si_creamos_albaran.close
			set si_creamos_albaran=Nothing
			
			'response.write("<br>creamos el albaran?S/N:")
					
			if creamos_albaran="SI" then
					
					'response.write("<br>creamos el albaran..... SI")

					numero_albaran=0 ' lo paso a 0 para que cree el albaran
					direccion_ip="" ' capturamos la ip para posibles controles posteriores
					if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
						direccion_ip=Request.ServerVariables("HTTP_X_FORWARDED_FOR")
					  else
						direccion_ip=Request.ServerVariables("REMOTE_ADDR")
					end if
					
					'con la unificacion con gag ya puedo poner el codigo del cliente
					' en el albaran y no pasar el 9999 para que despues lo asignen ellos
					cliente_albaran=codcli 
					forma_de_envio=1
					
					direccion_entrega=""
					set datos_direccion=Server.CreateObject("ADODB.Recordset")
					with datos_direccion
						.ActiveConnection=connimprenta
						cadena_ejecucion="SELECT direccion, poblacion, provincia, cp FROM V_CLIENTES WHERE ID=" & CODCLI
						.Source=cadena_ejecucion
						'response.write("<br>-4- obtengo la direccion de envio para el cliente: " & .source)
						.Open
					end with
					
					if not datos_direccion.eof then
						direccion_entrega= datos_direccion("direccion")
						direccion_entrega=direccion_entrega & chr(13) & datos_direccion("cp")
						direccion_entrega=direccion_entrega & " " & datos_direccion("poblacion")
						direccion_entrega=direccion_entrega & chr(13)& datos_direccion("provincia")
					end if					
					
					datos_direccion.close
					set datos_direccion=nothing
					
					anulado_albaran=0
					estado_albaran=0
					pedido_albaran=pedido_seleccionado
					fecha_albaran=now()
					'observaciones="Correspondiente al Pedido del Carrito Num. " & pedido_seleccionado
					observaciones=""
					nofacturable=0 '0 para cuando el albaran es facturable y 1 para cuando no es facturable
					albaran_nuevo=0
					


					'vemos que articulos del albaran son facturables	
					set ver_facturables=Server.CreateObject("ADODB.Recordset")
					with ver_facturables
						.ActiveConnection=connimprenta
						cadena_ejecucion_facturables="SELECT pedidos_detalles.id_pedido, articulos.id, articulos.facturable"
						cadena_ejecucion_facturables=cadena_ejecucion_facturables & " FROM PEDIDOS_DETALLES INNER JOIN ARTICULOS"
						cadena_ejecucion_facturables=cadena_ejecucion_facturables & " ON ARTICULOS.ID = PEDIDOS_DETALLES.ARTICULO"
						cadena_ejecucion_facturables=cadena_ejecucion_facturables & " WHERE PEDIDOS_DETALLES.ID_PEDIDO=" & pedido_seleccionado
						cadena_ejecucion_facturables=cadena_ejecucion_facturables & " AND PEDIDOS_DETALLES.ESTADO='ENVIADO'"
						cadena_ejecucion_facturables=cadena_ejecucion_facturables & " AND PEDIDOS_DETALLES.ALBARAN IS NULL"
						cadena_ejecucion_facturables=cadena_ejecucion_facturables & " AND ARTICULOS.FACTURABLE = 'SI'"
						.Source=cadena_ejecucion_facturables
						'response.write("<br>- veo si hay articulos facturables en el albaran: " & .source)
						.Open
					end with

					'si no hay articulos facturables en el albaran, se crea como no facturable
					if ver_facturables.eof then
						nofacturable=1
					' else
					'	while not ver_facturables.eof 
					'		response.write("<br>pedido: " & ver_facturables("id_pedido") & " articulo: " & ver_facturables("id") & " facturable: " & ver_facturables("facturable"))
					'		ver_facturables.movenext
					'	wend
					end if		

					ver_facturables.close
					set ver_facturables=Nothing
					
					'RESPONSE.WRITE("<BR>no facturable: " & nofacturable)

					'RESPONSE.WRITE("<BR>-9- antes de la conexion con gag")
					
					%>			
					<!--#include file="Conexion_GAG.inc"-->
					
					<%
					'RESPONSE.WRITE("<BR>-10- creo el comand")
					set cmd = Server.CreateObject("ADODB.Command")
					'set cmd2 = Server.CreateObject("ADODB.Command")
					set cmd.ActiveConnection = conn_gag
					'set cmd2.ActiveConnection = conndistribuidora
				
					
				   ' Ejecuto el Primer Procedimiento Almacenado, el de la Cabecera del Pedido
				   'GRABAR_CABECERA_PEDIDO codsucursal, fecha, 'INTRANET';
				   
				   conn_gag.BeginTrans 'Comenzamos la Transaccion
				   cmd.CommandText = "SP_ACTUALIZA_ALBARAN"
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
					
					
					'RESPONSE.WRITE("<BR>-11- empiezo a asignar parametros")
					
					'Paso los parametros para que se ejecute el comando
					cmd.parameters(1)=numero_albaran
					'RESPONSE.WRITE("<BR>-- asignado el 1")
					cmd.parameters(2)=direccion_ip
					'RESPONSE.WRITE("<BR>-- asignado el 2")
					cmd.parameters(3)=cliente_albaran
					'RESPONSE.WRITE("<BR>-- asignado el 3")
					cmd.parameters(4)=forma_de_envio
					'RESPONSE.WRITE("<BR>-- asignado el 4")
					cmd.parameters(5)=direccion_entrega
					'RESPONSE.WRITE("<BR>-- asignado el 5")
					cmd.parameters(6)=anulado_albaran
					'RESPONSE.WRITE("<BR>-- asignado el 6")
					cmd.parameters(7)=estado_albaran
					'RESPONSE.WRITE("<BR>-- asignado el 7")
					cmd.parameters(8)=pedido_albaran
					'RESPONSE.WRITE("<BR>-- asignado el 8")
					cmd.parameters(9)=fecha_albaran
					'RESPONSE.WRITE("<BR>-- asignado el 9")
					cmd.parameters(10)=observaciones
					'RESPONSE.WRITE("<BR>-- asignado el 10")
					cmd.parameters(11)=nofacturable
					'RESPONSE.WRITE("<BR>-- asignado el 10")
					   
					cmd.execute()
					
					'RESPONSE.WRITE("<BR>-12- recojo el nuevo valor del albaran")
					'recojo el valor que devuelve el primer procedimiento
					albaran_nuevo="" & cmd.parameters(12).value
					'response.write numeropedido
					
		
					'RESPONSE.WRITE("<BR>-13- nuevo codigo de albaran: " & albaran_nuevo)
		
					'ponemos el numero de albaran en los detalles del pedido que forman ese albaran
					cadena_ejecucion_albaran=""
					cadena_ejecucion_albaran="UPDATE PEDIDOS_DETALLES SET ALBARAN=" & albaran_nuevo
					cadena_ejecucion_albaran= cadena_ejecucion_albaran & " WHERE ID_PEDIDO=" & pedido_albaran
					cadena_ejecucion_albaran= cadena_ejecucion_albaran & " AND ALBARAN IS NULL"
					cadena_ejecucion_albaran= cadena_ejecucion_albaran & " AND ESTADO='ENVIADO'"
					'RESPONSE.WRITE("<BR>-14- sql que ejecutamos para poner el albaran a los detalles del pedido: " & cadena_ejecucion_albaran)
					connimprenta.Execute cadena_ejecucion_albaran,,adCmdText + adExecuteNoRecords
		
					'ponemos el numero de albaran en los detalles de envios parciales del pedido que forman ese albaran
					cadena_ejecucion_albaran=""
					cadena_ejecucion_albaran="UPDATE PEDIDOS_ENVIOS_PARCIALES SET ALBARAN=" & albaran_nuevo
					cadena_ejecucion_albaran= cadena_ejecucion_albaran & " WHERE ID_PEDIDO=" & pedido_albaran
					cadena_ejecucion_albaran= cadena_ejecucion_albaran & " AND ALBARAN IS NULL"
					'RESPONSE.WRITE("<BR>-14- sql que ejecutamos para poner el albaran a los ENVIOS PARCIALES DEL pedido: " & cadena_ejecucion_albaran)
					connimprenta.Execute cadena_ejecucion_albaran,,adCmdText + adExecuteNoRecords
		
		
					'ahora creamos los detalles del albaran
					set  detalles_pedido_albaran=Server.CreateObject("ADODB.Recordset")
					with detalles_pedido_albaran
							.ActiveConnection=connimprenta
							'.Source="SELECT * FROM PEDIDOS_DETALLES INNER JOIN ARTICULOS"
							'.Source= .Source & " ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID"
							'.Source= .Source & " WHERE ID_PEDIDO=" & pedido_albaran
							
							.Source="SELECT a.id, a.id_pedido, a.estado, a.cantidad, b.codigo_sap, b.descripcion, a.albaran,"
							.Source= .Source & " a.hoja_ruta, a.precio_unidad, a.total, c.cantidad_enviada, c.albaran as albaran_parcial,"
							.Source= .Source & " (select sum(cantidad_enviada) from pedidos_envios_parciales"
							.Source= .Source & " where pedidos_envios_parciales.id_pedido=a.id_pedido"
							.Source= .Source & " and pedidos_envios_parciales.id_articulo=a.articulo) as cantidad_enviada_total"
							.Source= .Source & " FROM PEDIDOS_DETALLES a INNER JOIN ARTICULOS b" 
							.Source= .Source & " ON a.ARTICULO = b.ID"
							.Source= .Source & " LEFT JOIN PEDIDOS_ENVIOS_PARCIALES c"
							.Source= .Source & " ON c.ID_PEDIDO=a.ID_PEDIDO"
							.Source= .Source & " AND c.ID_ARTICULO=a.ARTICULO"
							.Source= .Source & " WHERE a.ID_PEDIDO=" & pedido_albaran
							
							'RESPONSE.WRITE("<BR>-recogemos los detalles del pedido con el albaran guardado para crear sus detalles: " & .source)
					
							.Open
					end with
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
						albaran_maestro="" & detalles_pedido_albaran("albaran")
						albaran_parcial_detalle="" & detalles_pedido_albaran("albaran_parcial")
						albaran_detalle="" & detalles_pedido_albaran("albaran")
						if estado_detalle="ENVIO PARCIAL" then
							albaran_detalle="" & albaran_parcial_detalle
						end if
						trabajo_detalle="" & detalles_pedido_albaran("hoja_ruta")
						total_detalle="" & detalles_pedido_albaran("total")
						if estado_detalle="ENVIO PARCIAL" then
							total_detalle="" & (cantidad_detalle * detalles_pedido_albaran("precio_unidad"))
						end if		
						if estado_detalle="ENVIADO" and detalles_pedido_albaran("cantidad_enviada")<>"" then
							total_detalle="" & (cantidad_detalle * detalles_pedido_albaran("precio_unidad"))
						end if
						cantidad_enviada_total_detalle="" & detalles_pedido_albaran("cantidad_enviada_total")
						if cantidad_enviada_total_detalle="" then
							cantidad_enviada_total_detalle=0
						end if
						
						'al final solo se ponen en el albaran los enviados
						'if (estado_detalle="ENVIADO") or (estado_detalle="ENVIO PARCIAL") then
						'RESPONSE.WRITE("<BR>-14b- estado_detalle: " & estado_detalle & " ... PARA EL ARTICULO: " & descripcion_detalle)
					
						'if (estado_detalle="ENVIADO") then
						if (estado_detalle="ENVIADO") or (estado_detalle="ENVIO PARCIAL") then
						
							'hay que generar el detalle del albaran
							'RESPONSE.WRITE("<BR>-14c- albaran_detalle: " & albaran_detalle & "...")
							'RESPONSE.WRITE("<BR>-14d- albaran_nuevo: " & albaran_nuevo & "...")
							
							if estado_detalle="ENVIADO" then
								if albaran_detalle=albaran_nuevo then
									if albaran_nuevo=albaran_parcial_detalle or albaran_parcial_detalle="" then
										'RESPONSE.WRITE("<BR>-14e- son iguales los albaranes..")
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
										
										
										'RESPONSE.WRITE("<BR>-15- sql que ejecutamos para crear los detalles del albaran: " & cadena_ejecucion_detalles_albaran)
									
										conn_gag.Execute cadena_ejecucion_detalles_albaran,,adCmdText + adExecuteNoRecords
										
										'RESPONSE.WRITE("<BR>-15b- tenemos una cantidad pedida de: " & cantidad_pedida_detalle & " y se han enviado: " & cantidad_envidad_total_detalle)
									end if
								end if
							end if
							
							if estado_detalle="ENVIO PARCIAL" then	
								if albaran_detalle=albaran_nuevo then
										'RESPONSE.WRITE("<BR>-14e- son iguales los albaranes..")
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
										
										
										'RESPONSE.WRITE("<BR>-15- sql que ejecutamos para crear los detalles del albaran: " & cadena_ejecucion_detalles_albaran)
									
										conn_gag.Execute cadena_ejecucion_detalles_albaran,,adCmdText + adExecuteNoRecords
										
										'RESPONSE.WRITE("<BR>-15b- tenemos una cantidad pedida de: " & cantidad_pedida_detalle & " y se han enviado: " & cantidad_envidad_total_detalle)
									
										'ahora vemos si es necesario meter observaciones en el albaran
										' cuando mandamos una cantidad y todavia faltan por enviar mas unidades								
										'if (estado_detalle="ENVIO PARCIAL") and cantidad_pedida_detalle>cantidad_enviada_total_detalle then
										'	if primera_vuelta=0 then
											'	primera_vuelta=1
												'cadena_articulos_pendientes=cadena_articulos_pendientes & chr(13) & "Quedarían Pendientes de Enviar los Siguientes Articulos:" & chr(13)
											'end if
											'cadena_articulos_pendientes=cadena_articulos_pendientes & chr(13) & "- " & (cantidad_pedida_detalle - cantidad_enviada_total_detalle) & "        " & descripcion_detalle
										'end if
								end if
							end if

						end if
						
						detalles_pedido_albaran.movenext
					wend
					detalles_pedido_albaran.close
					set detalles_pedido_albaran=Nothing
					

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
							
							'RESPONSE.WRITE("<BR>-recogemos los detalles del pedido y las cantidades enviadas para ver si hay que poner observaciones: " & .source)
					
							.Open
					end with
					
					cadena_articulos_pendientes=""
					while not observaciones_albaran.eof
						if ((observaciones_albaran("estado")<>"ENVIADO") AND (observaciones_albaran("estado")<>"ANULADO")) THEN
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
					
					if cadena_articulos_pendientes<>"" then
						cadena_actualizacion_albaran="UPDATE ALBARANES"
						cadena_actualizacion_albaran=cadena_actualizacion_albaran & " SET OBSERVACIONES=cast(OBSERVACIONES as nvarchar(max)) + '" & cadena_articulos_pendientes & "'"
						cadena_actualizacion_albaran=cadena_actualizacion_albaran & " WHERE IDALBARAN=" & albaran_nuevo
						
						
						'RESPONSE.WRITE("<BR>-16- actualizo el albaran con las observaciones: " & cadena_actualizacion_albaran)
					
						conn_gag.Execute cadena_actualizacion_albaran,,adCmdText + adExecuteNoRecords
								
					end if
					
					
					
					
					
					
					
		
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
function validar(creamos_albaran,numero_albaran)
{
	cadena='El Pedido Ha sido Modificado con Exito...'
	
	if (creamos_albaran=='SI')
		{
		cadena= cadena + '\n\nse ha creado el albarán número ' + numero_albaran + ' referente a los artículos enviados de este pedido.'
		}
	if (creamos_albaran=='NO')
		{
		cadena= cadena + '\n\nno se ha creado el albarán ya que no hay nuevos articulos enviados sobre los que crear albarán.'
		}
			
	alert(cadena)
		
	//document.getElementById('frmmodificar_pedido').submit()	
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
	document.getElementById('frmmodificar_pedido').submit()	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

   
<BODY onload="validar('<%=creamos_albaran%>','<%=albaran_nuevo%>')">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>
<form name="frmmodificar_pedido" id="frmmodificar_pedido" method="post" action="Consulta_Pedidos_Admin.asp">
</form>





</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
