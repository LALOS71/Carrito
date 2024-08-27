<%@ language=vbscript  codepage="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- #include file="./include/dvim_apiRedsys_VB.asp" -->
<%

'importe=replace(Request.Form("ocultoimporte"), ",", ".")
importe=replace("310,29", ".", ",")
pedido=111111
cliente_sap=5084116
cliente=8253

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
	
	max=1000
	min=1
	Randomize

	codigo_transaccion=(Int((max-min+1)*Rnd+min))		
	
	
	
	'entorno test
	'terminal="1"
	'entorno real
	terminal="3"
	
	moneda="978"
	trans="0"
	amount=int(Cdbl(importe) * 100)    '(multiplicar por 100... va sin punto decimal, representando los 2 ultimos nuevos los decimales)
	'amount=int(319231029.000000000004)
	id=pedido & "_" & codigo_transaccion 'no acepta +,&,€,"
	'id="123293_736"
	'id=left(id,10)
	'entorno de test
	'url="" 'Colocar la URL completa de ejemploSOAP.asp (debe ser accesible desde RedSys, por tanto no puede ser localhost)
	'entorno real
	url="http://carrito.globalia-artesgraficas.com/redsys/Pago_Realizado.asp"
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
	'clave de firma, entorno test
	'kc = "sq7HjrUOBfKmC576ILgskD5srU870gJ7"
	'clave de firma, entorno real
	kc = "FyQYwEfD1i72i2RudLhseMzzQzD5ze1Y"
	
	
	' Se generan los parámetros de la petición
	Dim params,signature
	params = miObj.createMerchantParameters()
	signature = miObj.createMerchantSignature(kc)

	Dim postURL
	'postURL = "https://sis-d.redsys.es/sis/realizarPago"  'URL DE DESARROLLO CON HTTPS
	'postURL = "http://sis-d.redsys.es/sis/realizarPago" 'URL DE DESARROLLO
	'postURL = "https://sis-t.redsys.es:25443/sis/realizarPago"  'URL DE PRUEBAS, USAR CON LOS DATOS DE VUESTRO COMERCIO
	postURL = "https://sis.redsys.es/sis/realizarPago"  'URL DE PRODUCCION, USAR CON LOS DATOS DE VUESTRO COMERCIO

	 
	 
	 
	 
	'*************************************
	'escribir un fichero	
	Const Writing=2
	Dim OpenFileobj, FSOobj,FilePath
	FilePath=Server.MapPath("text_PASARELA.txt") ' located in the same directory
	
	Set FSOobj = Server.CreateObject("Scripting.FileSystemObject")
	Set OpenFileobj = FSOobj.CreateTextFile(FilePath, True)
    	
	OpenFileobj.WriteBlankLines(4)
	OpenFileobj.WriteLine("DENTRO DE PASARELA_COMPROBAR.ASP")
	
	OpenFileobj.WriteBlankLines(4)
	OpenFileobj.WriteLine("IMPORTE: " & importe)
	OpenFileobj.WriteLine("PEDIDO: " & pedido)
	OpenFileobj.WriteLine("CLIENTE SAP: " & cliente_sap)
	OpenFileobj.WriteLine("CLIENTE: " & cliente)

	OpenFileobj.WriteBlankLines(4)
	OpenFileobj.WriteLine("DS_MERCHANT_AMOUNT: " & amount)
	OpenFileobj.WriteLine("DS_MERCHANT_ORDER: " & CStr(id))
	OpenFileobj.WriteLine("DS_MERCHANT_MERCHANTCODE: " & fuc)
	OpenFileobj.WriteLine("DS_MERCHANT_CURRENCY: " & moneda)
	OpenFileobj.WriteLine("DS_MERCHANT_TRANSACTIONTYPE: " & trans)
	OpenFileobj.WriteLine("DS_MERCHANT_TERMINAL: " & terminal)
	OpenFileobj.WriteLine("DS_MERCHANT_MERCHANTURL: " & url)
	OpenFileobj.WriteLine("DS_MERCHANT_URLOK: " & urlOK)	
	OpenFileobj.WriteLine("DS_MERCHANT_URLKO: " & urlKO) 
	
	OpenFileobj.WriteBlankLines(4)
	OpenFileobj.WriteLine("version: " & version)
	OpenFileobj.WriteLine("kc: " & kc)
	OpenFileobj.WriteLine("params: " & params)
	OpenFileobj.WriteLine("signature: " & signature)
	OpenFileobj.WriteLine("posturl: " & posturl)

	
	OpenFileobj.WriteBlankLines(4)
	OpenFileobj.WriteLine("-----------------FIN")


	OpenFileobj.Close
	Set OpenFileobj = Nothing
	Set FSOobj = Nothing
%>



<div id="mensaje" name="mensaje" align="center"><br /><br />...Accediendo a La Pasarela de Pago...</div>

<form name="frmredsys" id="frmredsys" action="<%=postURL%>" method="POST">
<input type="hidden" name="Ds_SignatureVersion" value="<%=version%>"/><br/>
<input type="hidden" name="Ds_MerchantParameters" value="<%=params%>"/><br/>
<input type="hidden" name="Ds_Signature" value="<%=signature%>"/><br/>

</form>







</body>