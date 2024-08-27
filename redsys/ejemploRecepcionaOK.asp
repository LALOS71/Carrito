<%@ language="vbscript" codepage="65001"%>
<script language="vbscript" runat="server">
'
'	Copyright (c) 2016, DE VEGA ICT MANAGEMENT, SLU, CIF B66216300
'
</script>


<!-- #include file="./include/dvim_apiRedsys_VB.asp" -->

<html lang="es">
<head>
	<title>Pago Realizado Con Exito</title>
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
	
%>

<div style="background-color:#fff;width:650px;font-family:Open-sans,sans-serif;color:#555454;font-size:13px;line-height:18px;margin:auto">
	<table style="width:100%" bgcolor="#ffffff">
		<tbody>
			<tr><td style="border-bottom:4px solid #333333;padding:7px 0">&nbsp;</td></tr>
		<tr><td style="padding:0!important">&nbsp;</td></tr>
		<tr>
		<td style="padding:7px 0">
		<font size="2" face="Open-sans, sans-serif" color="#555454">
		<span>El pedido se ha guardado correctamente y su pago con tarjeta se ha completado con éxito.</span>
		<br/>
		<span>En breve será tramitado por Globalia Artes Gráficas.</span>
		</font>
		</td>
		<tr><td style="padding:0!important">&nbsp;</td></tr>
		<tr>
		<td style="border-top:4px solid #333333;padding:7px 0">
		<span></span>
		</td>
		</tr>
		</tbody>
		</table>
		</div>
</body> 
</html> 