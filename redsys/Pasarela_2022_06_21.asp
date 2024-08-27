<%@ language=vbscript  codepage="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion_PRU.inc"-->
<!-- #include file="./include/dvim_apiRedsys_VB.asp" -->
<%

detalles_tarjeta=Request.Form("ocultokey")
'importe=replace(Request.Form("ocultoimporte"), ",", ".")
importe=replace(Request.Form("ocultoimporte"), ".", ",")

pedido=Request.Form("ocultopedido")
cliente_sap=Request.Form("ocultocliente_sap")
cliente=Request.Form("ocultocliente")

'response.write("<br>pedido:" & pedido)
'response.write("<br>ocultoimporte:" & Request.Form("ocultoimporte"))
'response.write("<br>importe:" & importe)
'response.write("<br>cliente_sap:" & cliente_sap)
'response.write("<br>cliente:" & cliente)

%>
<HTML>
<head>
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-select/css/bootstrap-select.min.css">

<script type="text/javascript" src="../js/comun.js"></script>

<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>

<script language="javascript">
//window.parent.document.getElementById("ocultoaviso").value="NO"

movernos=function() {
	$("#frmredsys").submit()
}

</script>
</head>
<body onload="movernos()">
<% 
	Response.CharSet = "utf-8"

	' Se crea Objeto
	Dim miObj 
	Set miObj = new RedsysAPI
		
	' Valores de entrada
	Dim fuc,terminal,moneda,trans,url,urlOKKO,id,amount
	fuc="349957449"
	terminal="1"
	moneda="978"
	trans="0"
	amount=Cdbl(importe) * 100    '(multiplicar por 100... va sin punto decimal, representando los 2 ultimos nuevos los decimales)
	id=pedido & "_" & time() 'no acepta +,&,€,"
	url="" 'Colocar la URL completa de ejemploSOAP.asp (debe ser accesible desde RedSys, por tanto no puede ser localhost)
	'urlOK="http://carrito.globalia-artesgraficas.com/redsys/RecepcionOK.asp" 'Colocar la URL completa de ejemploRecepcionaPet.asp (puede ser localhost para pruebas)
	'urlKO="http://carrito.globalia-artesgraficas.com/redsys/RecepcionKO.asp" 'Colocar la URL completa de ejemploRecepcionaPet.asp (puede ser localhost para pruebas)
	urlOK="http://carrito.globalia-artesgraficas.com/redsys/RecepcionOK.asp" 'Colocar la URL completa de ejemploRecepcionaPet.asp (puede ser localhost para pruebas)
	urlKO="http://carrito.globalia-artesgraficas.com/redsys/RecepcionKO.asp" 'Colocar la URL completa de ejemploRecepcionaPet.asp (puede ser localhost para pruebas)
	
	
	
	'response.write("<br>amount: " & amount)
	
	' Se Rellenan los campos
	call miObj.setParameter("DS_MERCHANT_AMOUNT",amount)
	call miObj.setParameter("DS_MERCHANT_ORDER",CStr(id))
	call miObj.setParameter("DS_MERCHANT_MERCHANTCODE",fuc)
	call miObj.setParameter("DS_MERCHANT_CURRENCY",moneda)
	call miObj.setParameter("DS_MERCHANT_TRANSACTIONTYPE",trans)
	call miObj.setParameter("DS_MERCHANT_TERMINAL",terminal)
	call miObj.setParameter("DS_MERCHANT_MERCHANTURL",url)
	call miObj.setParameter("DS_MERCHANT_URLOK",urlOK)	
	call miObj.setParameter("DS_MERCHANT_URLKO",urlKO)

	' Datos de configuración
	Dim version
	version="HMAC_SHA256_V1"
	'kc = "Mk9m98IfEblmPfrpsawt7BmxObt98Jev" 'Clave recuperada de CANALES
	kc = "sq7HjrUOBfKmC576ILgskD5srU870gJ7"
	
	
	' Se generan los parámetros de la petición
	Dim params,signature
	params = miObj.createMerchantParameters()
	signature = miObj.createMerchantSignature(kc)

	Dim postURL
	'postURL = "https://sis-d.redsys.es/sis/realizarPago"  'URL DE DESARROLLO CON HTTPS
	'postURL = "http://sis-d.redsys.es/sis/realizarPago" 'URL DE DESARROLLO
	postURL = "https://sis-t.redsys.es:25443/sis/realizarPago"  'URL DE PRUEBAS, USAR CON LOS DATOS DE VUESTRO COMERCIO
	'postURL = "https://sis.redsys.es/sis/realizarPago"  'URL DE PRODUCCION, USAR CON LOS DATOS DE VUESTRO COMERCIO

	 
	 cadena_campos="FECHA, PEDIDO, PEDIDO_REDSYS, CLIENTE, CODIGO_SAP, SIGNATUREVERSION, SIGNATURE, MERCHANTPARAMETERS"
		cadena_valores="getdate()," & pedido & ", '" & id & "', " & cliente & ", " & cliente_sap & ", '" & version & "'"
		cadena_valores=cadena_valores & ", '" & signature & "', '" & params & "'"
		'cadena_valores=cadena_valores & ", '" & signature & "', '" & amount & "'"
		cadena_ejecucion="INSERT INTO PAGOS_REDSYS_HISTORICO_MENSAJES(" & cadena_campos & ") VALUES(" & cadena_valores & ")"
		
		'response.write("<br>HISTORICO MENSAJES pagos tarjeta: " & cadena_ejecucion)
		
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords 
		
		connimprenta.close
		set conimprenta=nothing
	 
	 
%>



<div id="mensaje" name="mensaje" align="center"><br /><br />...Accediendo a La Pasarela de Pago...</div>

<form name="frmredsys" id="frmredsys" action="<%=postURL%>" method="POST">
<input type="hidden" name="Ds_SignatureVersion" value="<%=version%>"/><br/>
<input type="hidden" name="Ds_MerchantParameters" value="<%=params%>"/><br/>
<input type="hidden" name="Ds_Signature" value="<%=signature%>"/><br/>

</form>







</body>