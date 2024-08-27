<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include file="../xelupload.asp"-->

<%

sub mail_confirmacion_autorizacion_pedido(pedido)%>
	<!--#include file="../Conexion_ORACLE_Envios_Distri_PRODUCCION.inc"-->


<%

'SELECT     PEDIDOS.ID, PEDIDOS.CODCLI, V_CLIENTES.CODIGO_EXTERNO, V_CLIENTES.NOMBRE, V_CLIENTES.DIRECCION, V_CLIENTES.POBLACION, V_CLIENTES.PROVINCIA, V_CLIENTES.CP, 
'                      V_CLIENTES.EMAIL, V_CLIENTES.TELEFONO, V_CLIENTES.JEFE_ECONOMATO, V_CLIENTES.FAX, V_EMPRESAS.EMPRESA, V_EMPRESAS.CARPETA, V_EMPRESAS_CENTRAL.EMPRESA AS Expr1, 
'                      V_EMPRESAS_CENTRAL.CODIGO_AD,A.EMAIL
'FROM         PEDIDOS INNER JOIN
'                      V_CLIENTES ON PEDIDOS.CODCLI = V_CLIENTES.ID INNER JOIN
'                      V_EMPRESAS ON V_CLIENTES.EMPRESA = V_EMPRESAS.ID INNER JOIN
'                      V_EMPRESAS_CENTRAL ON V_EMPRESAS.ID = V_EMPRESAS_CENTRAL.ID
'                      INNER JOIN V_CLIENTES A ON A.ID=V_EMPRESAS_CENTRAL.CODIGO_AD
'WHERE     (PEDIDOS.ID = 15616)   

	adCmdStoredProc=4
	adVarChar=200
	adParamInput=1

'select EMAIL from v_clientes
'where id=(SELECT top 1    V_EMPRESAS_CENTRAL.CODIGO_AD
'FROM         V_CLIENTES INNER JOIN
'                      V_EMPRESAS_CENTRAL ON V_CLIENTES.EMPRESA = V_EMPRESAS_CENTRAL.EMPRESA
'                      where v_clientes.id=6215)

	set datos_mail=Server.CreateObject("ADODB.Recordset")
	with datos_mail
		.ActiveConnection=connimprenta
		.Source="SELECT PEDIDOS.ID, PEDIDOS.CODCLI, V_CLIENTES.CODIGO_EXTERNO, V_CLIENTES.NOMBRE,"
		.Source=.Source & " V_CLIENTES.DIRECCION, V_CLIENTES.POBLACION, V_CLIENTES.PROVINCIA, V_CLIENTES.CP," 
		.Source=.Source & " V_CLIENTES.EMAIL, V_CLIENTES.TELEFONO, V_CLIENTES.JEFE_ECONOMATO, V_CLIENTES.FAX, V_EMPRESAS.EMPRESA," 
		.Source=.Source & " V_EMPRESAS.CARPETA, V_EMPRESAS_CENTRAL.CODIGO_AD, A.EMAIL AS MAIL_ADMIN,"
		.Source=.Source & " A.ID as CODIGO_ADMIN_UNICO"
		.Source=.Source & " FROM PEDIDOS INNER JOIN V_CLIENTES" 
		.Source=.Source & " ON PEDIDOS.CODCLI = V_CLIENTES.ID"
		.Source=.Source & " INNER JOIN V_EMPRESAS"
		.Source=.Source & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.ID"
		.Source=.Source & " INNER JOIN V_EMPRESAS_CENTRAL"
		.Source=.Source & " ON V_EMPRESAS.ID = V_EMPRESAS_CENTRAL.ID"
		.Source=.Source & " INNER JOIN V_CLIENTES A"
		'.Source=.Source & " ON A.ID=V_EMPRESAS_CENTRAL.CODIGO_AD"
		'PARA QUE BUSQUE EL ID EN CADENAS "#XXXX#YYYY#ZZZZ#"
		.Source=.Source & " ON CHARINDEX('#' + CONVERT(VARCHAR, A.ID) + '#', V_EMPRESAS_CENTRAL.CODIGO_AD)>0"
		.Source=.Source & " WHERE (PEDIDOS.ID = " & pedido & ")"
		.Source=.Source & " AND A.ID=" & session("usuario")
		'response.write("<br>" & .source)
		.Open
	end with
		
	if not datos_mail.eof then
		set cmd = Server.CreateObject("ADODB.Command")
		'set cmd2 = Server.CreateObject("ADODB.Command")
		set cmd.ActiveConnection = conn_envios_distri
		'set cmd2.ActiveConnection = conndistribuidora
	
		cmd.CommandText = "PAQUETE_ENVIOS_DISTRI.ENVIAR_MAIL"
		cmd.CommandType = adCmdStoredProc
		
		cmd.parameters.append cmd.createparameter("P_ENVIA",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_RECIBE",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_ASUNTO",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_MENSAJE",adVarChar,adParamInput,2000)
		cmd.parameters.append cmd.createparameter("P_HOST",adVarChar,adParamInput,255)
		'cmd.parameters.append cmd.createparameter("C_ALTO_GENERICO",adInteger,adParamInput,2)
		'cmd.parameters.append cmd.createparameter("C_PESO_GENERICO",adDouble,adParamInput)
		
		'cmd.parameters.append cmd.createparameter("texto_explicacion",adVarChar,adParamOutPut,255)
		
		cmd.parameters("P_ENVIA")=datos_mail("mail_admin")
			
		'para diferenciar los correos a los que se envia cuando estamos en pruebas o en real
		' y no tener que andar comentando y descomentando lineas		
		cadena_asunto=""
		correos_recibe=""
		if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
			'ENTORNO PRUEBAS
			'carlos.gonzalez@globalia-artesgraficas.com
		  	'correos_recibe="malba@halconviajes.com; carlos.gonzalez@globalia-artesgraficas.com"
			correos_recibe="malba@globalia-artesgraficas.com"
			cadena_asunto="PRUEBAS..."
		  else
			'ENTORNO REAL
			correos_recibe= datos_mail("email") 
			cadena_asunto=""
		end if
		'response.write("<br>" & Request.ServerVariables("SERVER_NAME"))
		cmd.parameters("P_RECIBE")=correos_recibe
		cmd.parameters("P_ASUNTO")=cadena_asunto & "Pedido Num. " & datos_mail("id") & " - MODIFICADO Y AUTORIZADO"
		

		mensaje= "<br>SU PEDIDO CON N&Uacute;MERO " & pedido & " HA SIDO MODIFICADO Y DADO DE PASO POR"
		mensaje=mensaje & " LOS RESPONSABLES DE COMPRAS."
		mensaje=mensaje & " <BR><BR>EL PEDIDO SER&Aacute; TRAMITADO EN BREVE."
		'mensaje=mensaje & "<BR><BR><BR><BR><BR>&nbsp;&nbsp;&nbsp;Esto se Deber&iacute;a Enviar a: " & datos_mail("email")
		
		
		
		cmd.parameters("P_MENSAJE")=mensaje
		'cmd.parameters("P_HOST")="195.76.0.183"
		cmd.parameters("P_HOST")="192.168.150.44"
		   
		cmd.execute()
		
		
		
		
		
		set cmd=Nothing
			
	end if
	
	datos_mail.close
	set datos_mail=Nothing
		
	conn_envios_distri.close
	set conn_envios_distri=Nothing

end sub
%>


<%

	if session("usuario")="" then
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
	end if
		
		Dim up, fich
		set up = new xelUpload
		up.Upload()
		
		set  fso=Server.CreateObject("Scripting.FileSystemObject")
		
		accion=""
		acciones=up.Form("ocultoacciones")
		if acciones<>"" then
			tabla_acciones=Split(acciones,"--")
			accion=tabla_acciones(0)
			pedido_modificar=tabla_acciones(1)
			fecha_pedido=tabla_acciones(2)
			hotel_admin=tabla_acciones(3)
			codigo_externo_modificacion=tabla_acciones(4)
			nombre_modificacion=tabla_acciones(5)
		end if
		
		
		
		'por si aplican un descuento en el pedido, lo guardamos en la cabecera del pedido
		descuento_pedido=0
		If up.Form("ocultodescuento_pedido")<>"" Then
			descuento_pedido=up.Form("ocultodescuento_pedido")
		end if
		
		if accion="MODIFICAR" then 'aqui modificamos pedidos
				'vemos si lo podemos modificar, no siendo que justo en el tiempo que va desde que selecciona
				' el pedido a modificar y se modifica, en la imprenta hayan tramitado algun articulo o simplemente
				' la central de la empresa lo confirma para la imprenta
				podemos_modificarlo="NO"
				set detalles_pedido=Server.CreateObject("ADODB.Recordset")
				with detalles_pedido
					.ActiveConnection=connimprenta
					.Source="SELECT * FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_modificar & " AND ESTADO<>'PENDIENTE AUTORIZACION' AND ESTADO<>'SIN TRATAR' AND ESTADO<>'AUTORIZACION NUEVA APERTURA'"
					.Open
				end with
				
				if detalles_pedido.eof then
					podemos_modificarlo="SI"
				end if
				detalles_pedido.close
				set detalles_pedido=Nothing
				
				
				if podemos_modificarlo="SI" then
					'modifico los articulos del pedido
					' para ello, borro los articulos y añado lo que tenga en el carrito
					cadena_ejecucion="DELETE FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_modificar
					connimprenta.BeginTrans 'Comenzamos la Transaccion
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					'borramos los ficheros json de la carpeta y se vuelven a generar
					fichero_borrar= Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & hotel_admin & "__" & pedido_modificar)
					fichero_borrar= fichero_borrar & "/*.json"
					
					if fso.FileExists(fichero_borrar) then
						fso.DeleteFile(fichero_borrar)	
					end if
					
					
					for i=1 to Session("numero_articulos")
						id=session(i)
						IF up.Form("ocultocantidad_" & id)<>"" THEN
							cantidad=up.Form("ocultocantidad_" & id)
						  else
							cantidad="null"
						end if
						if up.Form("ocultoprecio_" & id)<>"" then
							precio=up.Form("ocultoprecio_" & id)
						  else
							precio="null"
						end if
						if up.Form("ocultototal_" & id)<>"" then
							total=up.Form("ocultototal_" & id)
						  else
							total="null"
						end if
						
						'veo si existe porque si se deja vacio no se envia con el formulario y si pregunto por su valor, daria error
						If up.Ficheros.Exists("txtfichero_" & id) Then
							fichero_asociado=up.Ficheros("txtfichero_" & id).Nombre
							'veo si hay que borrar el fichero que habia antes
							if session(i & "_fichero_asociado")<>"" then
								'RESPONSE.WRITE(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado")))
								if fso.FileExists(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & hotel_admin & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado"))) then
									fso.DeleteFile(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & hotel_admin & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado")))
								end if
							end if
						  else
						  	'si no sube ningun fichero, puede que quiera mantener el fichero que habia antes, que se encuentra
							'  en la varible de sesion, y si no hay nada, se queda vacio
							fichero_asociado=session(i & "_fichero_asociado")
						end if
						'response.write("<br>fichero asociado variable: " & up.Ficheros("txtfichero_" & id).Nombre)
						'response.write("<br>fichero asociado variable: " & fichero_asociado)
						'response.write("<br>fichero asociado objeto file: up.Form(""txtfichero_" & id & """) " & up.Form("txtfichero_" & id))
						
						'guardo el fichero de texto json con la configuracion personalizada del articulo
						creo_json="NO"
						datos_json=""
						'IF up.Form("ocultodatos_personalizacion_json_" & id)<>"" THEN
						'	datos_json=up.Form("ocultodatos_personalizacion_json_" & id)
						'	if datos_json<>"" then
							'	creo_json="SI"
							'end if
						'end if
						
						'como dan problemas las comillas dobles del json al pasarlo al oculto, lo hago con la variable de sesion
						datos_json=session("json_" & id)
						if datos_json<>"" then
							creo_json="SI"
						end if
						
						'vacio la variable de sesion con los datos json
						session("json_" & id)=""
						
						if creo_json="SI" then
							ruta_fichero_json= Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & hotel_admin & "__" & pedido_modificar)
							ruta_fichero_json= ruta_fichero_json & "/json_" & id & ".json"
							
							'if fso.FileExists(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado"))) then
							'		fso.DeleteFile(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado")))
							'end if
							
							'--response.write("<br>nombre del fichero a guardar: " & ruta_fichero_json)
							'--response.write("<br>contenido fichero: " & datos_json)
	
							'veo si hay que crear la ruta donde dejar el fichero json						
							ruta=Request.ServerVariables("PATH_TRANSLATED")
							'--response.write("<br>ruta a comprobar para crear: " & ruta)
							longitud_ruta=len(ruta)
							posicion=longitud_ruta
							'response.write("<br>Ruta: " & ruta)
							lugar_encontrado=0
							while posicion>0 and lugar_encontrado=0
								letra_ruta=mid(ruta,posicion,1)
								if letra_ruta="\" then
									lugar_encontrado=posicion
								end if
								'response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
								posicion=posicion-1
							wend
						
							carpeta=left(ruta,lugar_encontrado)
							'--response.write("<br>carpeta a comprobar si hay que crear: " & carpeta)
							carpeta=carpeta & "pedidos"
							
							if not fso.folderexists(carpeta) then
								existe_carpeta="no"
								fso.CreateFolder(carpeta)
							end if
								
							carpeta=carpeta & "\" & year(fecha_pedido)
							if not fso.folderexists(carpeta) then
								existe_carpeta="no"
								fso.CreateFolder(carpeta)
							end if
							
							carpeta=carpeta & "\" & hotel_admin & "__" & pedido_modificar
							if not fso.folderexists(carpeta) then
								existe_carpeta="no"
								fso.CreateFolder(carpeta)
							end if
							
							'--response.write("<br>ruta a comprobar si existe y crearla: " & carpeta)
							
							
							Set fichero_json_crear = fso.CreateTextFile (ruta_fichero_json)
							
							'fichero_json_crear.WriteLine(datos_json)
							fichero_json_crear.Write(datos_json)
							fichero_json_crear.Close()
							'fso.Close()
							
							set fichero_json_crear=Nothing
							'set fso=nothing
	
	
						end if ' aqui acabo de subir los ficheros json
						
						
						cadena_estado_mod="SIN TRATAR"
						If session("usuario_codigo_empresa")=4 and descuento_pedido<>"0" Then
							cadena_estado_mod="PENDIENTE PAGO"
						end if
						
						
						cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION"
						cadena_valores=pedido_modificar & ", " & id & ", " & cantidad & ", " & REPLACE(precio,",",".") & ", " & REPLACE(total,",",".") & ", '" & cadena_estado_mod & "', '" & fichero_asociado & "'"
						cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				
					next
					
					
					'AQUI A LO MEJOR HAY QUE VER SI LAS PROPIAS DE ASM PUEDEN TENER DESCUENTO, PORQUE SI NO QUE
					' QUE PONER ESTAS CON EL ESTADO DE SIN TRATAR Y NO PENDIENTE DE PAGO
					If session("usuario_codigo_empresa")=4 and descuento_pedido<>"0" Then
						cadena_modificacion_pedido= "UPDATE PEDIDOS SET ESTADO='PENDIENTE PAGO', DESCUENTO_TOTAL=" & replace(descuento_pedido,",", ".")
					  else
					  	cadena_modificacion_pedido= "UPDATE PEDIDOS SET ESTADO='SIN TRATAR'"					
					end if
					cadena_modificacion_pedido=cadena_modificacion_pedido & " WHERE ID=" & pedido_modificar
					
					'RESPONSE.WRITE("<BR>" & CADENA_MODIFICACION_PEDIDO)
					connimprenta.Execute cadena_modificacion_pedido,,adCmdText + adExecuteNoRecords
					
					if session("usuario_codigo_empresa")<>4 then
						mail_confirmacion_autorizacion_pedido(pedido_modificar)
					end if
					connimprenta.CommitTrans ' finaliza la transaccion
					
					'si no suben ficheros, no tengo porque crear la carpeta
					if up.Ficheros.Count>0 then
					
						ruta=Request.ServerVariables("PATH_TRANSLATED")
						longitud_ruta=len(ruta)
						posicion=longitud_ruta
						'response.write("<br>Ruta: " & ruta)
						lugar_encontrado=0
						while posicion>0 and lugar_encontrado=0
							letra_ruta=mid(ruta,posicion,1)
							if letra_ruta="\" then
								lugar_encontrado=posicion
							end if
							'response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
							posicion=posicion-1
						wend
					
						carpeta=left(ruta,lugar_encontrado)
						'response.write("<br>" & carpeta)
						carpeta=carpeta & "pedidos"
						
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
							
						carpeta=carpeta & "\" & year(fecha_pedido)
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
						
						carpeta=carpeta & "\" & hotel_admin & "__" & pedido_modificar
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
					end if
					'response.write("<br>" & carpeta)
					For each fich in up.Ficheros.Items	
						'subo el fichero al servidor
						'response.write("<br>" & fich.Nombre)
						'fich.GuardarComo fich.Nombre, ruta
						fich.GuardarComo fich.Nombre, Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & hotel_admin & "__" & pedido_modificar)
						'guardo el nombre del documento en la base de datos
					Next
					
					
					mensaje_aviso="El Pedido Ha sido Modificado con Exito..."
				  else
					mensaje_aviso="NO SE HA PODIDO MODIFICAR El Pedido Porque Ya Está Siendo Tramitado por Globalia Artes Gráficas..."
				end if
			

		
		
			else 'aqui damos de alta pedidos(me parece que desde la central de atesa, esto no ocurrira)
				'lo guardamos con el estado de AUTORIZANDO CENTRAL, porque en atesa
				' primero tiene que autorizar el pedido su central para que lo pueda llegar a
				' tramitar la imprenta
				cadena_campos="CODCLI, FECHA, ESTADO, USUARIO_DIRECTORIO_ACTIVO"
				cadena_valores=hotel_admin & ", '" & DATE() & "', 'SIN TRATAR', "
				if session("usuario_directorio_activo")<>"" then
					cadena_valores=cadena_valores & session("usuario_directorio_activo")
				  else
				  	cadena_valores=cadena_valores & "NULL"
				end if
				
				cadena_ejecucion="Insert into PEDIDOS (" & cadena_campos & ") values(" & cadena_valores & ")"
				'response.write("<br>cadena ejecucion: " & cadena_ejecucion)		   
				connimprenta.BeginTrans 'Comenzamos la Transaccion
				
				'porque el sql de produccion es un sql expres que debe tener el formato de
				' de fecha con mes-dia-año
				connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				Set valor_nuevo = connimprenta.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
				numero_pedido=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
				valor_nuevo.Close
				Set valor_nuevo = Nothing
				
				'si no suben ficheros, no tengo porque crear la carpeta
				if up.Ficheros.Count>0 then
				
					ruta=Request.ServerVariables("PATH_TRANSLATED")
					longitud_ruta=len(ruta)
					posicion=longitud_ruta
					'response.write("<br>Ruta: " & ruta)
					lugar_encontrado=0
					while posicion>0 and lugar_encontrado=0
						letra_ruta=mid(ruta,posicion,1)
						if letra_ruta="\" then
							lugar_encontrado=posicion
						end if
						'response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
						posicion=posicion-1
					wend
				
					carpeta=left(ruta,lugar_encontrado)
					'response.write("<br>" & carpeta)
					carpeta=carpeta & "pedidos"
					
					if not fso.folderexists(carpeta) then
						existe_carpeta="no"
						fso.CreateFolder(carpeta)
					end if
						
					carpeta=carpeta & "\" & year(date())
					if not fso.folderexists(carpeta) then
						existe_carpeta="no"
						fso.CreateFolder(carpeta)
					end if
					
					carpeta=carpeta & "\" & hotel_admin & "__" & numero_pedido
					if not fso.folderexists(carpeta) then
						existe_carpeta="no"
						fso.CreateFolder(carpeta)
					end if
				end if
				
				'response.write("<br>" & carpeta)
				For each fich in up.Ficheros.Items	
					'subo el fichero al servidor
					'response.write("<br>" & fich.Nombre)
					'fich.GuardarComo fich.Nombre, ruta
					fich.GuardarComo fich.Nombre, Server.MapPath("./pedidos/" & year(date()) & "/" & hotel_Admin & "__" & numero_pedido)
					'guardo el nombre del documento en la base de datos
				Next
				
				for i=1 to Session("numero_articulos")
					id=session(i)
					IF up.Form("ocultocantidad_" & id)<>"" THEN
						cantidad=up.Form("ocultocantidad_" & id)
					  else
						cantidad="null"
					end if
					if up.Form("ocultoprecio_" & id)<>"" then
						precio=up.Form("ocultoprecio_" & id)
					  else
						precio="null"
					end if
					if up.Form("ocultototal_" & id)<>"" then
						total=up.Form("ocultototal_" & id)
					  else
						total="null"
					end if
					'veo si existe porque si se deja vacio no se envia con el formulario y si pregunto por su valor, daria error
					If up.Ficheros.Exists("txtfichero_" & id) Then
						fichero_asociado=up.Ficheros("txtfichero_" & id).Nombre
					  else
						fichero_asociado=""
					end if
					'response.write("<br>fichero asociado variable: " & up.Ficheros("txtfichero_" & id).Nombre)
					'response.write("<br>fichero asociado variable: " & fichero_asociado)
					'response.write("<br>fichero asociado objeto file: up.Form(""txtfichero_" & id & """) " & up.Form("txtfichero_" & id))
					
					
					'guardo el fichero de texto json con la configuracion personalizada del articulo
					creo_json="NO"
					datos_json=""
					'IF up.Form("ocultodatos_personalizacion_json_" & id)<>"" THEN
					'	datos_json=up.Form("ocultodatos_personalizacion_json_" & id)
					'	if datos_json<>"" then
						'	creo_json="SI"
						'end if
					'end if
					
					'como dan problemas las comillas dobles del json al pasarlo al oculto, lo hago con la variable de sesion
						datos_json=session("json_" & id)
						if datos_json<>"" then
							creo_json="SI"
						end if
					
					'vacio la variable de sesion con los datos json
					session("json_" & id)=""
						
					if creo_json="SI" then
						ruta_fichero_json= Server.MapPath("./pedidos/" & year(date()) & "/" & hotel_admin & "__" & numero_pedido)
						ruta_fichero_json= ruta_fichero_json & "/json_" & id & ".json"
						
						'--response.write("<br>nombre del fichero a guardar: " & ruta_fichero_json)
						'--response.write("<br>contenido fichero: " & datos_json)

						'veo si hay que crear la ruta donde dejar el fichero json						
						ruta=Request.ServerVariables("PATH_TRANSLATED")
						'--response.write("<br>ruta a comprobar para crear: " & ruta)
						longitud_ruta=len(ruta)
						posicion=longitud_ruta
						'response.write("<br>Ruta: " & ruta)
						lugar_encontrado=0
						while posicion>0 and lugar_encontrado=0
							letra_ruta=mid(ruta,posicion,1)
							if letra_ruta="\" then
								lugar_encontrado=posicion
							end if
							'response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
							posicion=posicion-1
						wend
					
						carpeta=left(ruta,lugar_encontrado)
						'--response.write("<br>carpeta a comprobar si hay que crear: " & carpeta)
						carpeta=carpeta & "pedidos"
						
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
							
						carpeta=carpeta & "\" & year(date())
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
						
						carpeta=carpeta & "\" & hotel_admin & "__" & numero_pedido
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
						
						'--response.write("<br>ruta a comprobar si existe y crearla: " & carpeta)
						
						
						Set fichero_json_crear = fso.CreateTextFile (ruta_fichero_json)
						'salida.Write ("Texto Normal")
						'si el json no tiene el codigo del pedido, se lo ponemos
						if instr(datos_json, chr(34) & "codigo_pedido" & chr(34) & ":" & chr(34) & chr(34)) then
							'--response.write("<bR>cambio el codigo depedido a: " & numero_pedido)
							cadena_a_cambiar= chr(34) & "codigo_pedido" & chr(34) & ":" & chr(34) & chr(34)
							cadena_sustituta= chr(34) & "codigo_pedido" & chr(34) & ":" & chr(34) & numero_pedido & chr(34)
							'cadena_a_cambiar= "codigo_pedido"
							'cadena_sustituta= "codigo_pedidorrr"
							
							'--response.write("<br>cadena a cambiar: " & cadena_a_cambiar)
							'--response.write("<br>cadena sustituta: " & cadena_sustituta)
							datos_json=replace(datos_json, cadena_a_cambiar , cadena_sustituta)
							'--response.write("<br>datos json: " & datos_json)
						end if
						
						'fichero_json_crear.WriteLine(datos_json)
						fichero_json_crear.Write(datos_json)
						fichero_json_crear.Close()
						'fso.Close()
						
						set fichero_json_crear=Nothing
						'set fso=nothing


					end if
					
					
					
					'tambien ponemos los detalles del pedido en el estado de AUTORIZANDO CENTRAL para Atesa
					cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION"
					cadena_valores=numero_pedido & ", " & id & ", " & cantidad & ", " & REPLACE(precio,",",".") & ", " & REPLACE(total,",",".") & ", 'SIN TRATAR', '" & fichero_asociado & "'"
					cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
					'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			
			next
				
			connimprenta.CommitTrans ' finaliza la transaccion
				
			mensaje_aviso="El Pedido Ha sido Creado con Exito..."			
		end if
		
		
		
		
   
   	
	
	
		
		
	
	
	
	
		
		

	
	
	
	'para elimiar las variables de sesion
	Session("numero_articulos")=0
	
	set fso=Nothing
	set up = nothing
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />

<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
</head>
<TITLE>Grabar Pedido</TITLE>

<script language="javascript">
function validar(mensaje)
{
	//alert(mensaje);
	$("#cabecera_pantalla_avisos").html("Avisos")
	$("#body_avisos").html("<br><br><h4>" + mensaje + ".</h4><br><br>");
	$("#pantalla_avisos").modal("show");
	
	//document.getElementById('frmgrabar_pedido').submit()	
	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

   
<BODY onload="validar('<%=mensaje_aviso%>')" style="background-color:<%=session("color_asociado_empresa")%>">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>

<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer" id="botones_avisos">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->


<script language="javascript">
$('#pantalla_avisos').on('hidden.bs.modal', function (e) {
  location.href = 'Consulta_Pedidos_Gag_Central_Admin.asp'
})
</script>

</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
