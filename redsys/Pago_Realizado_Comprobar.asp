<%@ language="vbscript" codepage="65001"%>
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



	response.write("<br>entrando en pago_realizado_comprobar.asp")
	


	' Se crea Objeto
	Dim miObj 
	Set miObj = new RedsysAPI
	
	'response.write("<br>version: " & Request("Ds_SignatureVersion"))
	'response.write("<br>parametros: " & Request("Ds_MerchantParameters"))
	'response.write("<br>parametros: " & Request("Ds_Signature"))

	'*************************************
	'escribir un fichero	
	Const Writing=2
	Dim OpenFileobj, FSOobj,FilePath
	FilePath=Server.MapPath("text_comprobar.txt") ' located in the same directory
	
	Set FSOobj = Server.CreateObject("Scripting.FileSystemObject")
	Set OpenFileobj = FSOobj.CreateTextFile(FilePath, True)
    	
	OpenFileobj.WriteBlankLines(4)
	OpenFileobj.WriteLine("DENTRO DE PAGO_REALIZADO_COMPROBAR.ASP")

	Dim version, datos, signatureRecibida					
	version = "HMAC_SHA256_V1"
	datos = "eyJEU19NRVJDSEFOVF9BTU9VTlQiOjI5ODI0LCJEU19NRVJDSEFOVF9PUkRFUiI6IjEyMzI5M185ODAiLCJEU19NRVJDSEFOVF9NRVJDSEFOVENPREUiOiIzNDk5NTc0NDkiLCJEU19NRVJDSEFOVF9DVVJSRU5DWSI6Ijk3OCIsIkRTX01FUkNIQU5UX1RSQU5TQUNUSU9OVFlQRSI6IjAiLCJEU19NRVJDSEFOVF9URVJNSU5BTCI6IjMiLCJEU19NRVJDSEFOVF9NRVJDSEFOVFVSTCI6Imh0dHA6Ly9jYXJyaXRvLmdsb2JhbGlhLWFydGVzZ3JhZmljYXMuY29tL3JlZHN5cy9QYWdvX1JlYWxpemFkby5hc3AiLCJEU19NRVJDSEFOVF9VUkxPSyI6Imh0dHA6Ly9jYXJyaXRvLmdsb2JhbGlhLWFydGVzZ3JhZmljYXMuY29tL3JlZHN5cy9SZWNlcGNpb25PSy5hc3AiLCJEU19NRVJDSEFOVF9VUkxLTyI6Imh0dHA6Ly9jYXJyaXRvLmdsb2JhbGlhLWFydGVzZ3JhZmljYXMuY29tL3JlZHN5cy9SZWNlcGNpb25LTy5hc3AifQ=="
	signatureRecibida = "ahABJWdfRe3P7wlpq9Gj/FJGMvD56/83InCmI6NVcXw="
	
	Dim kc, firma
	'kc = "Mk9m98IfEblmPfrpsawt7BmxObt98Jev" 'Clave recuperada de CANALES
	'clave de firma, entorno test
	'kc = "sq7HjrUOBfKmC576ILgskD5srU870gJ7"
	'clave de firma, entorno real
	kc = "FyQYwEfD1i72i2RudLhseMzzQzD5ze1Y"
	firma = miObj.createMerchantSignatureNotif(kc,datos)
	
	
	OpenFileobj.WriteBlankLines(4)
	OpenFileobj.WriteLine("varsion: " & version)
	OpenFileobj.WriteLine("datos: " & datos)
	OpenFileobj.WriteLine("signaturerecibida: " & signaturerecibida)
	OpenFileobj.WriteLine("firma: " & firma)
	
	
	If (firma = signatureRecibida) Then
		'Response.Write "FIRMA OK<br/>"
		OpenFileobj.WriteBlankLines(4)
		OpenFileobj.WriteLine("FIRMA 0K......")
		Dim pedido_pagado
		
		pedido_pagado = miObj.getParameter("Ds_Order")
		pedido_importe = miObj.getParameter("Ds_Amount")
		pedido_importe = cdbl(pedido_importe) / 100
		pedido_importe = replace(pedido_importe, ",", ".")
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
		
		OpenFileobj.WriteBlankLines(4)
		OpenFileobj.WriteLine("PARAMETROS: " & parametros)
	Else
			'Response.Write "FIRMA KO<br/>"
			OpenFileobj.WriteBlankLines(4)
			OpenFileobj.WriteLine("FIRMA KO-----")
	end if
		
	
	
	OpenFileobj.WriteBlankLines(4)
	OpenFileobj.WriteLine("-----------------FIN")
	
	
	OpenFileobj.Close
	Set OpenFileobj = Nothing
	Set FSOobj = Nothing
	
	response.write("<br>FINNNN.....")
%>
</body> 
</html>