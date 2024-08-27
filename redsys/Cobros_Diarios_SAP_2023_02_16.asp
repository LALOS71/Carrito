<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include file="../Conexion_ORACLE_Envios_Distri_PRODUCCION.inc"-->
<%

response.write("<br>PROCESO DE ENVIO A SAP DE LOS PAGOS CON TARJETA")

  Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")
  
  CAMPO_ID=0
  CAMPO_ID_CLIENTE=1
  CAMPO_CODIGO_SAP=2
  CAMPO_ID_PEDIDO=3
  CAMPO_IMPORTE=4
  CAMPO_CODIGO_INTEGRACION_PICARD=5
  CAMPO_CODIGO_TRANSACCION_PICARD=6
  CAMPO_FECHA_PICARD=7
  CAMPO_ENVIADO_A_SAP=8
  set pagos_pendientes=Server.CreateObject("ADODB.Recordset")
	with pagos_pendientes
		.ActiveConnection=connimprenta
		.Source="SELECT ID, ID_CLIENTE, CODIGO_SAP, ID_PEDIDO, IMPORTE, CODIGO_INTEGRACION_PICARD, CODIGO_TRANSACCION_PICARD"
		.Source=.Source & ", FECHA_PICARD, ENVIADO_A_SAP"
		.Source=.Source & " FROM PAGOS_TARJETA"
		.Source=.Source & " WHERE ENVIADO_A_SAP IS NULL"
				
		'response.write("<br>" & .source)
		.Open
		vacio_pagos_pendientes=false
		if not .BOF then
			tabla_pagos_pendientes=.GetRows()
		  else
			vacio_pagos_pendientes=true
		end if
	end with
pagos_pendientes.close
set pagos_pendientes=Nothing	

  
  cuerpo_mensaje_ok=""
  cuerpo_mensaje_error=""
  
  'PRODUCCION
  URL = "http://p11-prd.globalia.com:8000/sap/bc/zws_rest/zws_rest_cobros"

  
  'PREPRODUCCION
  'URL = "http://p11-pre.globalia.com:8000/sap/bc/zws_rest/zws_rest_cobros"
  
  
'	{
'	"TAB":[
'			{
'				"SOCIEDAD": "HGA",
'				"CLIENTE": "5079260",
'				"TIPO": "COBRO",
'				"FECHA": "20180928",
'				"REFERENCIA": "1234567890",
'				"MONEDA": "EUR",
'				"IMPORTE": "123.45"
'			}
'		]
'	}

	
	connimprenta.BeginTrans 'Comenzamos la Transaccion
	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	enviados=0
	if not vacio_pagos_pendientes then
		for i=0 to UBound(tabla_pagos_pendientes,2)
			
			objHTTP.Open "POST", URL, FALSE
  
  			  'DESARROLLO 
			  'objHTTP.setRequestHeader "Authorization", "Basic UE9SVEFMOmVtb3Jlbm8=" 'PORTAL:emoreno
			  
								
			  'PREPRODUCCION
			  'objHTTP.setRequestHeader "Authorization", "Basic SS1HQUc6ZW1vcmVubwoK"
			  'objHTTP.setRequestHeader "Authorization", "Basic UE9SVEFMOmVtb3Jlbm8KCg=="
			  'objHTTP.setRequestHeader "Authorization", "Basic UDBSVEFMOmVtb3Jlbm8="
			  'objHTTP.setRequestHeader "Authorization", "Basic SS1HQUc6ZW1vcmVubwo="
			  objHTTP.setRequestHeader "Authorization", "Basic SS1HQUc6ZW1vcmVubw==" 'I-GAG:emoreno
			  
																
			  
			  'objHTTP.setRequestHeader "Authorization", "I-GAG:emoreno"
			  
			  
			  
			  
			  
			  objHTTP.setRequestHeader "Content-Type", "application/json; charset=UTF-8"
			  'objHTTP.setRequestHeader "Content-Type", "application/xml; charset=UTF-8"
			  'objHTTP.setRequestHeader "CharSet", "charset=UTF-8"
			  'objHTTP.setRequestHeader "Accept", "application/json"

			
			fecha_formateada=year(tabla_pagos_pendientes(campo_fecha_picard,i)) & right("0" & month(tabla_pagos_pendientes(campo_fecha_picard,i)),2) & right("0" & day(tabla_pagos_pendientes(campo_fecha_picard,i)),2) 
			cadena_json="{" & _
							"""TAB"":[" & _
										"{" & _
											"""SOCIEDAD"": ""HGA""," & _
											"""CLIENTE"": """ & tabla_pagos_pendientes(campo_codigo_sap,i) & """," & _
											"""TIPO"": ""COBRO""," & _
											"""FECHA"": """ & fecha_formateada & """," & _
											"""REFERENCIA"": """ & tabla_pagos_pendientes(campo_id_pedido,i) & """," & _
											"""MONEDA"": ""EUR""," & _
											"""IMPORTE"": """ & replace(tabla_pagos_pendientes(campo_importe,i), ",", ".") & """" & _
										"}" & _
									"]" & _
						"}"
			
			
			
			'response.write("<br><br>json creado: " & cadena_json)   
				
				'para generar adrede un error y ver como llega en el correo
				'if i=1 then
				'	 objHTTP.send ()
				'  else
				'  	 objHTTP.send (cadena_json)
				'end if
				
				objHTTP.send (cadena_json)
				
			  ' Output error message to std-error and happy message to std-out. Should
			  ' simplify error checking
			  If objHTTP.Status >= 400 And objHTTP.Status <= 599 Then
				'stderr.WriteLine "Error Occurred : " & objHTTP.status & " - " & objHTTP.statusText
				'response.write("<br><br>Error Occurred : - status " & objHTTP.status)
				'response.write("<br>statusText: " & objHTTP.statusText)
				
				'response.write("<br>allErrors: " & objHTTP.allErrors)
				'response.write("<br>parseerror: " & objHTTP.parseError)
				'response.write("<br>xml: " & objHTTP.xml)
				'response.write("<br>text: " & objHTTP.text)
				cuerpo_mensaje_error=cuerpo_mensaje_error & "<br><BR>ERROR... Estado: " & objHTTP.status & " - " & objHTTP.statusText
				cuerpo_mensaje_error=cuerpo_mensaje_error & "<br>para el json generado: " & cadena_json
			  Else
				'stdout.WriteLine "Success : " & objHTTP.status & " - " & objHTTP.ResponseText
				response.write("<br><br>Respuesta Success : " & objHTTP.status & " - " & objHTTP.ResponseText)
				
				cuerpo_mensaje_ok=cuerpo_mensaje_ok & "<br><BR>JSON Generado: " & cadena_json
				
				connimprenta.Execute "UPDATE PAGOS_TARJETA SET ENVIADO_A_SAP=GETDATE() WHERE ID=" & tabla_pagos_pendientes(campo_id,i),,adCmdText + adExecuteNoRecords
				
				enviados=enviados + 1
				
			  End If

		next
	end if
	
	connimprenta.CommitTrans ' finaliza la transaccion	
	
'Response.write("<br><br>resultado: " & HTTP.responseText )
'Response.end 

'objeto WinHttpRequest
'https://docs.microsoft.com/es-es/windows/desktop/WinHttp/using-the-winhttprequest-com-object
	cuerpo_mensaje=""
	if cuerpo_mensaje_ok<>"" then
		cuerpo_mensaje="<br><B>Se Han Enviado a SAP las siguientes Transaccones de Pago:</B>"
		cuerpo_mensaje=cuerpo_mensaje & cuerpo_mensaje_ok
	end if
	if cuerpo_mensaje_error<>"" then
		cuerpo_mensaje=cuerpo_mensaje & "<br><br><B>SE HAN PRODUCIDO ERRORES, Y NO SE HAN PODIDO ENVIAR A SAP LAS SIGUIENTES TRANSACCIONES:</B> "
		cuerpo_mensaje=cuerpo_mensaje & cuerpo_mensaje_error
	end if

	if cuerpo_mensaje="" then
		cuerpo_mensaje="....Para el Dia de hoy no se ha enviado ningun pago a SAP"
	end if
	
	if cuerpo_mensaje<>"" then
		cuerpo_mensaje="Para la Fecha " & date() & "<br>" & cuerpo_mensaje
	

		response.write("<br><br>CUERPO MENSAJE: <BR>" & cuerpo_mensaje)
		
		
		adCmdStoredProc=4
		adVarChar=200
		adLongVarChar=201
		adParamInput=1
		set cmd = Server.CreateObject("ADODB.Command")
		'set cmd2 = Server.CreateObject("ADODB.Command")
		set cmd.ActiveConnection = conn_envios_distri
		'set cmd2.ActiveConnection = conndistribuidora
	
		cmd.CommandText = "PAQUETE_ENVIOS_DISTRI.ENVIAR_MAIL"
		cmd.CommandType = adCmdStoredProc
		
		cmd.parameters.append cmd.createparameter("P_ENVIA",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_RECIBE",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_ASUNTO",adVarChar,adParamInput,255)
		'cmd.parameters.append cmd.createparameter("P_MENSAJE",adVarChar,adParamInput,2000)
		cmd.parameters.append cmd.createparameter("P_MENSAJE",adLongVarChar,adParamInput,-1)
		
		cmd.parameters.append cmd.createparameter("P_HOST",adVarChar,adParamInput,255)
		'cmd.parameters.append cmd.createparameter("C_ALTO_GENERICO",adInteger,adParamInput,2)
		'cmd.parameters.append cmd.createparameter("C_PESO_GENERICO",adDouble,adParamInput)
		
		'cmd.parameters.append cmd.createparameter("texto_explicacion",adVarChar,adParamOutPut,255)
		
		cmd.parameters("P_ENVIA")="carlos.gonzalez@globalia-artesgraficas.com"
		
		
		'para diferenciar los correos a los que se envia cuando estamos en pruebas o en real
		' y no tener que andar comentando y descomentando lineas		
		cadena_asunto=""
		correos_recibe=""
		
			
		if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" and Request.ServerVariables("SERVER_NAME")<>"localhost" then
			'ENTRONO PRUEBAS
			'carlos.gonzalez@globalia-artesgraficas.com
			'correos_recibe="malba@halconviajes.com;carlos.gonzalez@globalia-artesgraficas.com"
			correos_recibe="malba@globalia-artesgraficas.com"
			cadena_asunto="PRUEBAS..."
		  else
			'ENTORNO REAL
			correos_recibe="malba@globalia-artesgraficas.com;carlos.calvo@avoristravel.com"
			cadena_asunto=""
		end if
		'response.write("<br>" & Request.ServerVariables("SERVER_NAME"))
		cmd.parameters("P_RECIBE")=correos_recibe
		
		cadena_asunto= cadena_asunto & "Transacciones de Pago Enviadas a SAP (" & enviados & ") (" & date() & ")"
		if cuerpo_mensaje_error<>"" then
			cadena_asunto= cadena_asunto & " -- CON ERRORES"
		end if
		cmd.parameters("P_ASUNTO")= cadena_asunto
		
		cmd.parameters("P_MENSAJE")=cuerpo_mensaje
		'cmd.parameters("P_HOST")="195.76.0.183"
		cmd.parameters("P_HOST")="192.168.150.44"
		   
		cmd.execute()
		
		set cmd=Nothing
			
	
	end if

connimprenta.close
set connimprenta=Nothing		

response.write("<br>PROCESO DE ENVIO A SAP DE LOS PAGOS CON TARJETA FINALIZADO")

Response.Write ("<script>window.close();</script>")
Response.End
		
%>
