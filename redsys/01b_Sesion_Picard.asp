<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="aspJSON1.17.asp"-->
<%

importe=replace(Request.Form("ocultoimporte"), ",", ".")
pedido=Request.Form("ocultopedido")
cliente_sap=Request.Form("ocultocliente_sap")
cliente=Request.Form("ocultocliente")


'response.write("<br>pedido:" & pedido)
'response.write("<br>importe:" & importe)
'response.write("<br>cliente_sap:" & cliente_sap)
'response.write("<br>cliente:" & cliente)


'response.write("<div id='cabecera'><br><br><br><br><br><div align='center'><h1><font face='Arial, Helvetica, sans-serif'>Generando sesion</font></h1></div></div>")
'response.Flush()




'importe="24.93"
'pedido="33333"
'cliente_sap="6789"
'cliente="4321"

if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
	direccion_ip=Request.ServerVariables("HTTP_X_FORWARDED_FOR")
	'texto="nos quedamos con http_x_forwarded_for"
  else
  	direccion_ip=Request.ServerVariables("REMOTE_ADDR")
	'texto="nos quedamos con remote_addr"
end if		
                      
max=1000
min=1
Randomize

codigo_transaccion=(Int((max-min+1)*Rnd+min))		
'codigo_transaccion=""		
		
 
  
  Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")
  
  'DESARROLLO
  'URL = "https://testpicard.globalia.com/kepler/v1/embedded/createpaymentsession"
  'url_tarjeta="https://testpicard.globalia.com/kepler/v1/embedded/checkout"
  
  'PRODUCCION
  'URL = "https://picard.globalia.com/api/v1/payment"
  URL = "https://picard.globalia.com/kepler/v1/embedded/createpaymentsession"
  
  
  'URL = "https://testpicard.globalia.com/api/v1/payment"
  'URL = "https://en.wikipedia.org/wiki/HTTPS"
  objHttp.setOption 2, 13056
  objHTTP.Open "POST", URL, FALSE
  'objHTTP.setRequestHeader "User-Agent", "Mozilla/4.0"
  
  'DESARROLLO	
  'objHTTP.setRequestHeader "Authorization", "Basic QVJURVNHUkFGSUNBUzpoNkp1NFpCMg=="
  
  'PRODUCCION
  objHTTP.setRequestHeader "Authorization", "Basic QVJURVNHUkFGSUNBUzpMM3JBN1Z4NQ=="
  
  objHTTP.setRequestHeader "Content-Type", "application/json; charset=UTF-8"
  'objHTTP.setRequestHeader "CharSet", "charset=UTF-8"
  'objHTTP.setRequestHeader "Accept", "application/json"

  ' Send the json in correct format
  'en desarrollo el CENTERCODE es 9999
  'codigo_centro="9999"
  
  'en real el CENTERCODE es 0000 para entorno presencial y 0001 para paypal
  codigo_centro="0001"
  
  

  cadena_json = "{ ""integrationCode"": ""091""," &_
    		"""integrationTransactionCode"": """ & pedido & codigo_transaccion & """," &_
			"""customerIpAddress"": """ & direccion_ip & """," &_
			"""centerCode"": """ & codigo_centro & """," &_   
			"""agentCode"": """ & cliente & """," &_
			"""amount"": " & importe & "," &_
			"""countryCode"": ""ES""," &_
			"""currency"": ""EUR""," &_
			"""reference"": """ & pedido & """," &_
			"""customerLanguageCode"": ""ES""," &_
			"""expireSessionDay"": 1," &_
			"""restrictedToStoredCards"":false," &_
			"""redirectOnFinalizeURL"": ""http://carrito.globalia-artesgraficas.com/picard/02_Pago_Finalizado.asp""}"
			
'{
'"integrationCode": "091",
'"integrationTransactionCode": "3456722222",
'"customerIpAddress": "192.168.69.74",
'"centerCode": "9999",
'"agentCode": "2333",
'"amount": 1.2,
'"countryCode": "ES",
'"currency": "EUR",
'"reference": "PEDIDO21345",
'"customerLanguageCode": "ES",
'"expireSessionDay": 1,
'"restrictedToStoredCards":false,
'"redirectOnFinalizeURL": "http://192.168.153.132/asp/carrito_imprenta_gag_boot/picard/02_Pago_Finalizado.asp"}
			
'control_json=cadena_json	   					
'response.write("<br><br>json creado: " & json)   
  objHTTP.send (cadena_json)

sesion_picard=""
resultado_picard=""
url_checkout_nuevo=""
metodo_checkout_nuevo=""
enlace_paymentresult=""
metodo_paymentresult=""
error_encontrado=0
descripcion_error=""
descripcion_error_sp=""
url_checkout_anterior=""
metodo_checkout_anterior=""
	
connimprenta.BeginTrans 'Comenzamos la Transaccion	
	
	
	
  ' Output error message to std-error and happy message to std-out. Should
  ' simplify error checking
  If objHTTP.Status >= 400 And objHTTP.Status <= 599 Then
    'stderr.WriteLine "Error Occurred : " & objHTTP.status & " - " & objHTTP.statusText
	
  
	'response.write("<br><br>Error Occurred : - status " & objHTTP.status)
	'response.write("<br>statusText: " & objHTTP.statusText)
	'response.write("<br>responsetextt: " & objHTTP.responseText)
	
	'response.write("<br>allErrors: " & objHTTP.allErrors)
	'response.write("<br>parseerror: " & objHTTP.parseError)
	'response.write("<br>xml: " & objHTTP.xml)
	'response.write("<br>text: " & objHTTP.text)
	'response.write("<br>responseText: " & objHTTP.responseText)
	
	'response.write("<div align='center' id='aviso_picard_pago' name='aviso_picard_pago'><label><br><br><b>SE HA PRODUCIDO UN ERROR AL REALIZAR LA TRANSACCI&Oacute;N DEL PAGO DE PEDIDO " & pedido & ".</b>")
	'response.write("<br><br>Puede volver a intentar realizar el pago con tarjeta accediendo de nuevo al pedido desde la secci&oacute;n ""Consultar Pedidos"".</label></div>")
	
	'control_respuesta=objHTTP.responseText
	cadena_campos="FECHA, PEDIDO, MENSAJE_OK, MENSAJE_ERROR, LLAMADA_INICIAL"
	cadena_valores="getdate()," & pedido & ", NULL, '" &  objHTTP.responseText & "', '" & cadena_json & "'"
	
	cadena_ejecucion="INSERT INTO PAGOS_PICARD_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"
	
	'response.write("<br>HISTORICO MENSAJES pagos tarjeta: " & cadena_ejecucion)
	
	connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
	
	error_encontrado=1 'se produce un error al hacer la llamada de crear la variable de sesion en picard
	
	Set control_error = New aspJSON
	control_error.loadJSON(objHTTP.ResponseText)
	
	response.write("texto: " & objHTTP.ResponseText)

	'descripcion_error= control_error.data("result") & " -- " & control_error.data("resultDescription")
	descripcion_error = control_error.data("result")
	descripcion_error_sp = control_error.data("resultDescription")
	
	Set control_error=Nothing
	
	' busco si se ha creado la session y se ha salido sin pagar
	' para recuperar el enlace
	if descripcion_error="PAYMENT_DUPLICATED" then 
		set datos_sesion=Server.CreateObject("ADODB.Recordset")
		with datos_sesion
			.ActiveConnection=connimprenta
			.Source="SELECT URL_CHECKOUT, METODO_CHECKOUT"
			.Source=.Source & " FROM PAGOS_PICARD_HISTORICO_MENSAJES" 
			.Source=.Source & " WHERE PEDIDO=" & PEDIDO
			.Source=.Source & " AND MENSAJE_OK IS NULL"
			.Source=.Source & " AND MENSAJE_ERROR IS NULL"
			'response.write("<br>datos del pedido: " & .source)
			.Open
		end with
		
		if not datos_sesion.eof then
			url_checkout_anterior=datos_sesion("URL_CHECKOUT")
			metodo_checkout_anterior=datos_sesion("METODO_CHECKOUT")
			error_encontrado=3 'error concreto....tiene creada una sesion en picard pero no ha pagado.... hay que reutilizarla
		end if
		
		datos_sesion.close
		set datos_sesion=Nothing
	end if
	
  Else 'no tiene un status de error del sistema.... recibimos la informacion de la operacion
  
    'stdout.WriteLine "Success : " & objHTTP.status & " - " & objHTTP.ResponseText
	'response.write("<br><br>Respuesta Success : " & objHTTP.status & " - " & objHTTP.ResponseText)
	'control_respuesta=objHTTP.responseText
	
	
	'Set respuesta_picard = JSON.parse(objHTTP.ResponseText)
	'Set respuesta_picard = JSON.parse("HOLA")
	Set respuesta_picard = New aspJSON
	respuesta_picard.loadJSON(objHTTP.ResponseText)
	
	
	
	'response.write("<Br>respuesta inicio de sesion: " & objHTTP.ResponseText)
	'response.write("<Br>result: " & respuesta_picard.data("result"))
	'response.write("<Br>sesionpìcard: " & respuesta_picard.data("paymentSession"))
	'response.write("<Br>sesionpìcard: " & respuesta_picard.data("paymentSessionn"))
	'{"links":[{"rel":"paymentresult","href":"https://testpicard.globalia.com/kepler/v1/embedded/paymentresult/4CA1B4D8E46E8DEABBCDC14E336A705A","method":"GET"}
	'		,{"rel":"checkout","href":"https://testpicard.globalia.com/kepler/v1/embedded/checkout/4CA1B4D8E46E8DEABBCDC14E336A705A","method":"GET"}]
	',"paymentSession":"4CA1B4D8E46E8DEABBCDC14E336A705A"
	',"result":"CREATE_PAYMENT_SESSION_SUCCESSFUL"}


	
	'CREATE_PAYMENT_SESSION_SUCCESSFUL
	resultado_picard=respuesta_picard.data("result")
	
	
	if resultado_picard="CREATE_PAYMENT_SESSION_SUCCESSFUL" then 'se ha creado bien la variable de sesion
		sesion_picard=respuesta_picard.data("paymentSession")
		
		'si se ha creado bien la variable de sesion, vamos rellenando las variables con sus valores
		For Each enlace In respuesta_picard.data("links")
		    Set this = respuesta_picard.data("links").item(enlace)
		    'Response.Write("<br>operacion: " & this.item("rel") & " enlace: " & this.item("href") & "metodo: " & this.item("method"))
			if this.item("rel")="checkout" then
				url_checkout_nuevo=this.item("href")
				metodo_checkout_nuevo=this.item("method")
			end if
			if this.item("rel")="paymentresult" then
				enlace_paymentresult=this.item("href")
				metodo_paymentresult=this.item("method")
			end if
		Next
		
		cadena_campos="FECHA, PEDIDO, SESION_PICARD, URL_CHECKOUT, METODO_CHECKOUT, URL_PAYMENTRESULT, METODO_PAYMENTRESULT, CLIENTE, CODIGO_SAP, LLAMADA_INICIAL"
		cadena_valores="getdate()," & pedido & ", '" & sesion_picard & "', '" & url_checkout_nuevo & "', '" & metodo_checkout_nuevo & "'"
		cadena_valores=cadena_valores & ", '" & enlace_paymentresult & "', '" & metodo_paymentresult & "'"
		cadena_valores=cadena_valores & ", " & cliente & ", " & cliente_sap & ", '" & cadena_json & "'"
		cadena_ejecucion="INSERT INTO PAGOS_PICARD_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"
		
		'response.write("<br>HISTORICO MENSAJES pagos tarjeta: " & cadena_ejecucion)
		
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
		
		'response.write("<br>url destino: " & enlace_checkout)
	
		'response.write("<Br>result description en picard: " & respuesta_picard.data("resultDescription"))
		'response.write("<Br>picar integration tranasactio code en picard: " & respuesta_picard.data("transaction").item("integrationTransactionCode"))
		'response.write("<Br>picar transaction code en picard: " & respuesta_picard.data("transaction").item("picardTransactionCode"))
		'response.write("<Br>fecha picard: " & respuesta_picard.data("transaction").item("date"))
	
		'codigo_integracion= respuesta_picard.data("transaction").item("integrationTransactionCode")
		'codigo_transaccion= respuesta_picard.data("transaction").item("picardTransactionCode")
		'fecha_transaccion= respuesta_picard.data("transaction").item("date")
		
		

		
	  else 'si es otro resultado diferente de CREATE_PAYMENT_SESSION_SUCCESSFUL lo tratamos como error
			cadena_campos="FECHA, PEDIDO, MENSAJE_OK, MENSAJE_ERROR, LLAMADA_INICIAL"
			cadena_valores="getdate()," & pedido & ", NULL, '" &  objHTTP.responseText & "', '" & cadena_json & "'"
			
			cadena_ejecucion="INSERT INTO PAGOS_PICARD_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"
			
			'response.write("<br>HISTORICO MENSAJES pagos tarjeta: " & cadena_ejecucion)
			
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
			
			error_encontrado=2 'error al intentar
			
			Set control_error = New aspJSON
			control_error.loadJSON(objHTTP.ResponseText)
		
			'descripcion_error= control_error.data("result") & " -- " & control_error.data("resultDescription")
			descripcion_error= control_error.data("result") 
			descripcion_error_sp= control_error.data("resultDescription")
			
			Set control_error=Nothing

	end if
	
	
	
	
	
    
  End If
		
connimprenta.CommitTrans ' finaliza la transaccion	

response.write("{""url_checkout_nuevo"":""" & url_checkout_nuevo & """, ""metodo_checkout_nuevo"":""" & metodo_checkout_nuevo & """, ""error"":" & error_encontrado & ", ""descripcion_error"":""" & descripcion_error & """, ""url_checkout_anterior"":""" & url_checkout_anterior & """, ""metodo_checkout_anterior"":""" & metodo_checkout_anterior & """}")

connimprenta.close
set connimprenta=Nothing	
%>
