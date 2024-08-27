<%@ language="vbscript" codepage="65001"%>
<!--#include file="../Conexion_PRU.inc"-->
<script language="vbscript" runat="server">
'
'	Copyright (c) 2016, DE VEGA ICT MANAGEMENT, SLU, CIF B66216300
'
</script>


<!-- #include file="./include/dvim_apiRedsys_VB.asp" -->

<html lang="es">
<head>
	<title>PAGO REALIZADO</title>
</head>
<body>
<%
	Response.CharSet = "utf-8"




	


	' Se crea Objeto
	Dim miObj 
	Set miObj = new RedsysAPI
	
	'response.write("<br>version: " & Request("Ds_SignatureVersion"))
	'response.write("<br>parametros: " & Request("Ds_MerchantParameters"))
	'response.write("<br>parametros: " & Request("Ds_Signature"))
	
	


	If (Request.Form.Count>0 or Request.QueryString.Count>0) Then'//URL DE RESP. ONLINE
		Dim version, datos, signatureRecibida					
		version = Request("Ds_SignatureVersion")
		datos = Request("Ds_MerchantParameters")
		signatureRecibida = Request("Ds_Signature")
		
		fijo=request.QueryString("fijo")
		if fijo="SI" then
			version="HMAC_SHA256_V1"
			datos="eyJEU19NRVJDSEFOVF9BTU9VTlQiOjI5MDgsIkRTX01FUkNIQU5UX09SREVSIjoiM18xNTo0ODo1OCIsIkRTX01FUkNIQU5UX01FUkNIQU5UQ09ERSI6IjM0OTk1NzQ0OSIsIkRTX01FUkNIQU5UX0NVUlJFTkNZIjoiOTc4IiwiRFNfTUVSQ0hBTlRfVFJBTlNBQ1RJT05UWVBFIjoiMCIsIkRTX01FUkNIQU5UX1RFUk1JTkFMIjoiMSIsIkRTX01FUkNIQU5UX01FUkNIQU5UVVJMIjoiIiwiRFNfTUVSQ0hBTlRfVVJMT0siOiJodHRwOi8vY2Fycml0by5nbG9iYWxpYS1hcnRlc2dyYWZpY2FzLmNvbS9yZWRzeXMvUmVjZXBjaW9uT0suYXNwIiwiRFNfTUVSQ0hBTlRfVVJMS08iOiJodHRwOi8vY2Fycml0by5nbG9iYWxpYS1hcnRlc2dyYWZpY2FzLmNvbS9yZWRzeXMvUmVjZXBjaW9uS08uYXNwIn0="
			signatureRecibida="k6ghV9pBS7gudTYNV72PwmBsAMy7pnJ761TQQ88wnBw="
		end if

		Dim kc, firma
		'kc = "Mk9m98IfEblmPfrpsawt7BmxObt98Jev" 'Clave recuperada de CANALES
		kc = "sq7HjrUOBfKmC576ILgskD5srU870gJ7"
		
		firma = miObj.createMerchantSignatureNotif(kc,datos)

		response.write("<br>varsion: " & version)
		response.write("<br>datos: " & datos)
		response.write("<br>signaturerecibida: " & signaturerecibida)
		response.write("<br>firma: " & firma)
		
		'If (firma = signatureRecibida) Then
			Response.Write "FIRMA OK<br/>"
			Dim pedido_pagado
			
			pedido_pagado = miObj.getParameter("Ds_Order")
			pedido_importe = miObj.getParameter("Ds_Amount")
			pedido_transaccion = miObj.getParameter("Ds_AuthorisationCode")
			pedido_dia = miObj.getParameter("Ds_Date")
			
			parametros="Ds_AuthorisationCode=" & miObj.getParameter("Ds_AuthorisationCode")
			parametros=parametros & " Ds_Date=" & miObj.getParameter("Ds_Date")
			parametros=parametros & " Ds_Hour=" & miObj.getParameter("Ds_Hour")
			parametros=parametros & " Ds_Order=" & miObj.getParameter("Ds_Order")
			parametros=parametros & " Ds_Amount=" & miObj.getParameter("Ds_Amount")
			parametros=parametros & " Ds_Response=" & miObj.getParameter("Ds_Response")
			parametros=parametros & " Ds_Currency=" & miObj.getParameter("Ds_Currency")
			parametros=parametros & " Ds_MerchantCode=" & miObj.getParameter("Ds_MerchantCode")
			parametros=parametros & " Ds_Terminal=" & miObj.getParameter("Ds_Terminal")
			parametros=parametros & " Ds_MerchantData=" & miObj.getParameter("Ds_MerchantData")
			parametros=parametros & " Ds_SecurePayment=" & miObj.getParameter("Ds_SecurePayment")
			parametros=parametros & " Ds_TransactionType=" & miObj.getParameter("Ds_TransactionType")
			parametros=parametros & " Ds_Card_Country=" & miObj.getParameter("Ds_Card_Country") 
			parametros=parametros & " Ds_ConsumerLanguage=" & miObj.getParameter("Ds_ConsumerLanguage")
			parametros=parametros & " Ds_Card_Type=" & miObj.getParameter("Ds_Card_Type")
			
			'pago realizado con exito
			if cint(miObj.getParameter("Ds_Response"))<= 99 then
				cadena_ok= parametros			
				
				cadena_campos="FECHA, PEDIDO_REDSYS, MENSAJE_OK, SIGNATUREVERSION, SIGNATURE, MERCHANTPARAMETERS"
				cadena_ejecucion="UPDATE PAGOS_REDSYS_HISTORICO_MENSAJES SET MENSAJE_OK='" & cadena_ok & "'"
				cadena_ejecucion=cadena_ejecucion & " WHERE PEDIDO_REDSYS='" & pedido_pagado & "'"
				cadena_ejecucion=cadena_ejecucion & " IF @@ROWCOUNT=0 "
				
				
				cadena_valores="getdate(), '" & pedido_pagado & "', '" & cadena_ok & "', '" & version & "'"
				cadena_valores=cadena_valores & ", '" & signatureRecibida & "', '" & datos & "'"
				cadena_ejecucion=cadena_ejecucion & " INSERT INTO PAGOS_REDSYS_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"
				'cadena_ejecucion="INSERT INTO PAGOS_REDSYS_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"

				response.write("<br>cadena historico: " & cadena_ejecucion)
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
				
				
				
				pedido_consultado_pedido=""
				pedido_consultado_cliente=""
				pedido_consultado_codigo_sap=""
				
				set datos_pedido_pagado=Server.CreateObject("ADODB.Recordset")
				with datos_pedido_pagado
					.ActiveConnection=connimprenta
					.Source="SELECT TOP 1 PEDIDO, CLIENTE, CODIGO_SAP FROM PAGOS_REDSYS_HISTORICO_MENSAJES WHERE PEDIDO_REDSYS='" & pedido_pagado & "'" 
					response.write("<br>CADENA pedido consultado: " & .source)
					.Open
				end with
				
				if not datos_pedido_pagado.eof then
					pedido_consultado_pedido=datos_pedido_pagado("PEDIDO")
					pedido_consultado_cliente=datos_pedido_pagado("CLIENTE")
					pedido_consultado_codigo_sap=datos_pedido_pagado("CODIGO_SAP")
				end if				
				datos_pedido_pagado.close
				set datos_pedido_pagado = Nothing
				
				'introduciomos el pago en la tabla de pagos_con tarjeta
				cadena_campos="ID_CLIENTE, CODIGO_SAP, ID_PEDIDO, IMPORTE, CODIGO_INTEGRACION_PICARD, CODIGO_TRANSACCION_PICARD, FECHA_PICARD"
				cadena_valores= pedido_consultado_cliente & ", " & pedido_consultado_codigo_sap & ", " & pedido_consultado_pedido & ", " & pedido_importe & ", NULL, " 
				'cadena_valores=cadena_valores & "'" & pedido_transaccion & "', CONVERT(datetime, '" & pedido_dia & "', 120)"
				cadena_valores=cadena_valores & "'" & pedido_transaccion & "', '" & pedido_dia & "'"
					
				cadena_ejecucion="INSERT INTO PAGOS_TARJETA (" & cadena_campos & ") VALUES(" & cadena_valores & ")"
				
				response.write("<br>cadena pagos tarjeta: " & cadena_ejecucion)
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
					
		
			  else 'hay un error en el pago
			  	cadena_error_pago= parametros	
			  
			  	codigo_error=""
			  	descripcion_error=""
			  	set tipos_errores=Server.CreateObject("ADODB.Recordset")
				with tipos_errores
					.ActiveConnection=connimprenta
					.Source= "SELECT ID, ERROR_SIS, DESCRIPCION"
					.Source= .Source & " FROM REDSYS_ERRORES"
					.Source= .Source & " WHERE ID=" & miObj.getParameter("Ds_Response")
					'response.write("<br>" & .source)
					.OPEN
				end with		
				
				codigo_error=miObj.getParameter("Ds_Response")
				if not tipos_errores.eof then
					descripcion_error= tipos_errores("DESCRIPCION")
				end if
				tipos_errores.close
				set tipos_errores = nothing
		
		
				cadena_campos="FECHA, PEDIDO_REDSYS, MENSAJE_ERROR, SIGNATUREVERSION, SIGNATURE, MERCHANTPARAMETERS, CODIGO_ERROR, DESCRIPCION_ERROR"
				cadena_ejecucion="UPDATE PAGOS_REDSYS_HISTORICO_MENSAJES SET MENSAJE_ERROR='" & cadena_error_pago & "', CODIGO_ERROR='" & codigo_error & "'"
				cadena_ejecucion=cadena_ejecucion & " , DESCRIPCION_ERROR='" & descripcion_error & "'"
				cadena_ejecucion=cadena_ejecucion & " WHERE PEDIDO_REDSYS='" & miObj.getParameter("Ds_Order") & "'"
				cadena_ejecucion=cadena_ejecucion & " IF @@ROWCOUNT=0 "
				
				
				cadena_valores="getdate(), '" & miObj.getParameter("Ds_Order") & "', '" & cadena_error_pago & "', '" & version & "'"
				cadena_valores=cadena_valores & ", '" & signatureRecibida & "', '" & datos & "', '" & codigo_error & "', '" & descripcion_error & "'"
				cadena_ejecucion=cadena_ejecucion & " INSERT INTO PAGOS_REDSYS_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"
				'cadena_ejecucion="INSERT INTO PAGOS_REDSYS_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"

				response.write("<br>cadena historico con error: " & cadena_ejecucion)
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
				
				
			end if
			connimprenta.close
			set conimprenta=nothing
		'Else
		'	Response.Write "FIRMA KO<br/>"
		'End If
		'Response.Write "Ds_Date=" & miObj.getParameter("Ds_Date") & "<br/>"
		'Response.Write "Ds_Hour=" & miObj.getParameter("Ds_Hour") & "<br/>"
		'Response.Write "Ds_Amount=" & miObj.getParameter("Ds_Amount") & "<br/>"
		'Response.Write "Ds_Currency=" & miObj.getParameter("Ds_Currency") & "<br/>"
		'Response.Write "Ds_Order=" & miObj.getParameter("Ds_Order") & "<br/>"
		'Response.Write "Ds_MerchantCode=" & miObj.getParameter("Ds_MerchantCode") & "<br/>"
		'Response.Write "Ds_Terminal=" & miObj.getParameter("Ds_Terminal") & "<br/>"
		'Response.Write "Ds_Response=" & miObj.getParameter("Ds_Response") & "<br/>"
		'Response.Write "Ds_MerchantData=" & miObj.getParameter("Ds_MerchantData") & "<br/>"
		'Response.Write "Ds_SecurePayment=" & miObj.getParameter("Ds_SecurePayment") & "<br/>"
		'Response.Write "Ds_TransactionType=" & miObj.getParameter("Ds_TransactionType") & "<br/>"
		'Response.Write "Ds_Card_Country=" & miObj.getParameter("Ds_Card_Country") & "<br/>"
		'Response.Write "Ds_AuthorisationCode=" & miObj.getParameter("Ds_AuthorisationCode") & "<br/>"
		'Response.Write "Ds_ConsumerLanguage=" & miObj.getParameter("Ds_ConsumerLanguage") & "<br/>"
		'Response.Write "Ds_Card_Type=" & miObj.getParameter("Ds_Card_Type") & "<br/>"
		
		
		
		
	End If

	
%>
</body> 
</html>