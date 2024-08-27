<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->

<script language="javascript" runat="server" src="json2_a.asp"></script>

<script language="JScript" runat="server">
function CheckProperty(obj, propName) {
    return (typeof obj[propName] != "undefined");
}
</script>



<%
sesion_pago=""
url_paymentresult=""
metodo_paymentresult=""
cliente=""
cliente_sap=""

resultado_picard=""
resultado_gateway=""



sesion_pago=Request.QueryString("paymentSession")

'sesion_pago=sesion_pago & "aa"



set datos_pago=Server.CreateObject("ADODB.Recordset")
with datos_pago
	.ActiveConnection=connimprenta
	.Source="SELECT PEDIDO, URL_PAYMENTRESULT, METODO_PAYMENTRESULT, CLIENTE, CODIGO_SAP"
	.Source=.Source & " FROM PAGOS_PICARD_HISTORICO_MENSAJES" 
	.Source=.Source & " WHERE SESION_PICARD='" & sesion_pago & "'"
	'response.write("<br>datos del pedido: " & .source)
	.Open
end with

if not datos_pago.eof then
	url_paymentresult=datos_pago("URL_PAYMENTRESULT")
	metodo_paymentresult=datos_pago("METODO_PAYMENTRESULT")
	cliente=datos_pago("CLIENTE")
	cliente_sap=datos_pago("CODIGO_SAP")
	pedido=datos_pago("PEDIDO")
  else
  	'controlamos error

end if

datos_pago.close
set datos_pago=Nothing

           
  
  Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")
  
connimprenta.BeginTrans 'Comenzamos la Transaccion	

if url_paymentresult<>"" then  
'response.write("<br>direccion de acceso: " & url_paymentresult)
  
  objHttp.setOption 2, 13056
  objHTTP.Open metodo_paymentresult, url_paymentresult, FALSE
  'objHTTP.setRequestHeader "User-Agent", "Mozilla/4.0"
  
  'DESARROLLO	
  'objHTTP.setRequestHeader "Authorization", "Basic QVJURVNHUkFGSUNBUzpoNkp1NFpCMg=="
  
  'PRODUCCION
  objHTTP.setRequestHeader "Authorization", "Basic QVJURVNHUkFGSUNBUzpMM3JBN1Z4NQ=="
  
  objHTTP.setRequestHeader "Content-Type", "application/json"
  'objHTTP.setRequestHeader "Accept", "text/html"
  
  objHTTP.send ()


			
	
		
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
		'response.write("<br>responseText: " & objHTTP.responseText)
		
		'response.write("<div align='center' id='aviso_picard_pago' name='aviso_picard_pago'><label><br><br><b>SE HA PRODUCIDO UN ERROR AL REALIZAR LA TRANSACCI&Oacute;N DEL PAGO DE PEDIDO " & pedido & ".</b>")
		'response.write("<br><br>Puede volver a intentar realizar el pago con tarjeta accediendo de nuevo al pedido desde la secci&oacute;n ""Consultar Pedidos"".</label></div>")
		response.write("<div align='center' class='col-12' id='aviso_picard_pago' name='aviso_picard_pago'><img class='img-rounded img-responsive' src='img/Pago_Error.jpg'  style='padding: 1em; max-height:550px'/></div>")
		control_respuesta=objHTTP.responseText
		cadena_campos="FECHA, PEDIDO, MENSAJE_OK, MENSAJE_ERROR"
		cadena_valores="getdate()," & pedido & ", NULL, '" &  replace(objHTTP.responseText,"'", "´") & "'"
		
		cadena_ejecucion="INSERT INTO PAGOS_PICARD_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"
		
		'response.write("<br>HISTORICO MENSAJES pagos tarjeta: " & cadena_ejecucion)
		
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
		
	  Else
		'stdout.WriteLine "Success : " & objHTTP.status & " - " & objHTTP.ResponseText
		'response.write("<br><br>Respuesta Success : " & objHTTP.status & " - " & objHTTP.ResponseText)
		
		control_respuesta=objHTTP.ResponseText
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		dim Info : set Info = JSON.parse(objHTTP.ResponseText)
					'{"codigo_cliente":"6214","codigo_pedido":"47917","numero_plantillas":-1,
					'	"plantillas":[{"nombre_grupo":"grupomm","expediente":"expmm","total_venta_expediente":"77,65","total_coste_expediente":"77,665","beneficio":"0,225"}]} 
					'{"firstname": "Fabio","lastname": "Nagao","alive": true,"age": 27,"nickname": "nagaozen",
					'		"fruits": ["banana","orange","apple","papaya","pineapple"],
					'       "complex": {"real": 1,"imaginary": 2}}		
					 
					'Response.write(Info.firstname & vbNewline) ' prints Fabio
					'Response.write(Info.alive & vbNewline) ' prints True
					'Response.write(Info.age & vbNewline) ' prints 27
					'Response.write(Info.fruits.get(0) & vbNewline) ' prints banana
					'Response.write(Info.fruits.get(1) & vbNewline) ' prints orange
					'Response.write(Info.complex.real & vbNewline) ' prints 1
					'Response.write(Info.complex.imaginary & vbNewline) ' prints 2	 
	
					' You can also enumerate object properties ...
					 
					'dim key : for each key in Info.keys()
					'	Response.write( key & vbNewline )
					'next
					
					'Response.write(Info.codigo_cliente & vbNewline) ' prints Fabio
					'Response.write(Info.codigo_pedido & vbNewline) ' prints True
					'Response.write(Info.plantillas.nombre_grupo & vbNewline) ' prints 27
					'Response.write(Info.plantillas.get(0).nombre_grupo & vbNewline) ' prints 27
					'Response.write(Info.plantillas.get(0).expediente & vbNewline) ' prints 27
					'Response.write(Info.plantillas.get(0).total_venta_expediente & vbNewline) ' prints 27
					'Response.write(Info.plantillas.get(0).total_coste_expediente & vbNewline) ' prints 27
					'Response.write(Info.plantillas.get(0).beneficio & vbNewline) ' prints 27
					'Response.write(Info.plantillas.nombre_grupo & vbNewline) ' prints banana
					'Response.write(Info.fruits.get(1) & vbNewline) ' prints orange
					'Response.write(Info.complex.real & vbNewline) ' prints 1
					'Response.write(Info.complex.imaginary & vbNewline) ' prints 2
					''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		
		
		
		''Set respuesta_picard = New aspJSON
		''respuesta_picard.loadJSON(objHTTP.ResponseText)
		
		
		'PAYMENT_FOUND
		'response.write("<Br>respuesta inicio de sesion: " & objHTTP.ResponseText)
		'response.write("<Br>result: " & respuesta_picard.data("result"))
		'response.write("<Br>pedido: " & respuesta_picard.data("transaction").item("reference"))
		'response.write("<Br>codigo de transaccion picard: " & respuesta_picard.data("transaction").item("picardTransactionCode"))
		'response.write("<Br>codigo de integracion picard: " & respuesta_picard.data("transaction").item("integrationTransactionCode"))
		
		
		'response.write("<Br>respuesta inicio de sesion: " & objHTTP.ResponseText)
		'response.write("<Br>result: " & Info.result)
		'response.write("<Br>pedido: " & Info.transaction.reference)
		'response.write("<Br>codigo de transaccion picard: " & Info.transaction.picardTransactionCode)
		'response.write("<Br>codigo de integracion picard: " & Info.transaction.integrationTransactionCode)
		
		
		
		'CREATE_PAYMENT_SESSION_SUCCESSFUL
		'resultado_picard=respuesta_picard.data("result")
		resultado_picard=Info.result
		
		
		if resultado_picard="PAYMENT_FOUND" then 'se ha creado el pago correctamente
		
			''importe=CDbl(respuesta_picard.data("transaction").item("amount"))
			''codigo_integracion=respuesta_picard.data("transaction").item("picardTransactionCode")
			''codigo_transaccion=respuesta_picard.data("transaction").item("integrationTransactionCode")
			''fecha_transaccion=respuesta_picard.data("transaction").item("date")
			'response.write("<br>importe: " & importe)
	
			resultado_gateway=Info.transaction.gatewayResultCode
			
			 'si el pago ha ido bien, devuelve 000, si no, devuelve otro codigo
			if resultado_gateway<>"000" then
					response.write("<div align='center' class='col-12' id='aviso_picard_pago' name='aviso_picard_pago'><img class='img-rounded img-responsive' src='img/Pago_Error.jpg'  style='padding: 1em; max-height:550px'/></div>")
		
					cadena_campos="FECHA, PEDIDO, MENSAJE_OK, MENSAJE_ERROR"
					cadena_valores="getdate()," & pedido & ", NULL, '" &  replace(objHTTP.responseText,"'","´") & "'"
					
					cadena_ejecucion="INSERT INTO PAGOS_PICARD_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"
					
					'response.write("<br>HISTORICO MENSAJES pagos tarjeta: " & cadena_ejecucion)
					
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
			
				else
					importe=replace(Info.transaction.amount, ",", ".")
					codigo_integracion=Info.transaction.picardTransactionCode
					codigo_transaccion=Info.transaction.integrationTransactionCode
					fecha_transaccion=Info.transaction.date
					'response.write("<br>importe: " & importe)
					
					cadena_campos="ID_CLIENTE, CODIGO_SAP, ID_PEDIDO, IMPORTE, CODIGO_INTEGRACION_PICARD, CODIGO_TRANSACCION_PICARD, FECHA_PICARD"
					cadena_valores= cliente & ", " & cliente_sap & ", " & pedido & ", " & importe & ", '" & codigo_integracion
					cadena_valores=cadena_valores & "', '" & codigo_transaccion & "', CONVERT(datetime, '" & fecha_transaccion & "', 120)"
					
					
					cadena_ejecucion="INSERT INTO PAGOS_TARJETA (" & cadena_campos & ") VALUES(" & cadena_valores & ")"
					
					'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
					
					cadena_ejecucion="UPDATE PAGOS_PICARD_HISTORICO_MENSAJES SET MENSAJE_OK='" & replace(objHTTP.ResponseText,"'","´") & "' WHERE SESION_PICARD='" & sesion_pago & "'" 
					'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
					
					'*****************************************************************************************************
					'despues del pago con tarjeta, el pedido hay que pasarlo a sin tratar.... no dejarlo en pediente de pago
					connimprenta.Execute "UPDATE PEDIDOS SET ESTADO='SIN TRATAR' WHERE ID=" & pedido,,adCmdText + adExecuteNoRecords     
					connimprenta.Execute "UPDATE PEDIDOS_DETALLES SET ESTADO='SIN TRATAR' WHERE ID_PEDIDO=" & pedido,,adCmdText + adExecuteNoRecords   
					
					response.write("<div align='center' id='aviso_picard_pago'  class='col-12' name='aviso_picard_pago'><img class='img-rounded img-responsive' src='img/Pago_OK.jpg' style='padding: 1em; max-height:550px' /></div>")
		  
			end if
	
		  else 'si devuelve cualquier cosa que no sea PAYMENT FOUND
	
			response.write("<div align='center' class='col-12' id='aviso_picard_pago' name='aviso_picard_pago'><img class='img-rounded img-responsive' src='img/Pago_Error.jpg'  style='padding: 1em; max-height:550px'/></div>")
		
			cadena_campos="FECHA, PEDIDO, MENSAJE_OK, MENSAJE_ERROR"
			cadena_valores="getdate()," & pedido & ", NULL, '" &  replace(objHTTP.responseText, "'", "´") & "'"
			
			cadena_ejecucion="INSERT INTO PAGOS_PICARD_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"
			
			'response.write("<br>HISTORICO MENSAJES pagos tarjeta: " & cadena_ejecucion)
			
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
						
		end if
		
	
		'response.write("<Br>result description en picard: " & respuesta_picard.data("resultDescription"))
		'response.write("<Br>picar integration tranasactio code en picard: " & respuesta_picard.data("transaction").item("integrationTransactionCode"))
		'response.write("<Br>picar transaction code en picard: " & respuesta_picard.data("transaction").item("picardTransactionCode"))
		'response.write("<Br>fecha picard: " & respuesta_picard.data("transaction").item("date"))
	
		'codigo_integracion= respuesta_picard.data("transaction").item("integrationTransactionCode")
		'codigo_transaccion= respuesta_picard.data("transaction").item("picardTransactionCode")
		'fecha_transaccion= respuesta_picard.data("transaction").item("date")
		
		
	
		
		
		'response.write("<div align='center' id='aviso_picard_pago' name='aviso_picard_pago'><label><br><br><b>El pedido " & pedido & " se ha guardado correctamente y su pago con tarjeta se ha completado con &eacute;xito.<br><br>En breve ser&aacute; tramitado por Globalia Artes Gr&aacute;ficas</b></label></div>")
		
		
		
		
		
		
	  End If
			
	

  else
  	'damos el error
	response.write("<div align='center' class='col-12' id='aviso_picard_pago' name='aviso_picard_pago'><img class='img-rounded img-responsive' src='img/Pago_Error.jpg'  style='padding: 1em; max-height:550px'/></div>")
		
	cadena_campos="FECHA, PEDIDO, MENSAJE_OK, MENSAJE_ERROR, SESION_PICARD"
	cadena_valores="getdate(), NULL , NULL, 'SE HA PRODUCIDO UN ERROR AL BUSCAR ESTA SESION DE PAGO', '" &  sesion_pago & "'"
	
	cadena_ejecucion="INSERT INTO PAGOS_PICARD_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"
	
	'response.write("<br>HISTORICO MENSAJES pagos tarjeta: " & cadena_ejecucion)
	
	connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
end if


connimprenta.CommitTrans ' finaliza la transaccion	

connimprenta.close
set connimprenta=Nothing	
%>
<HTML>
<head>
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-select/css/bootstrap-select.min.css">
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>

<script language="javascript">
window.parent.document.getElementById("ocultoaviso").value="NO"

//console.log('json devuelto: <%=control_respuesta%>'  )
</script>
</head>
<body>

</body>