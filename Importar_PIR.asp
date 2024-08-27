<%@ language=vbscript%>

<%
Set xmlhttp = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")

'PRODUCCION
'https://mylostbag.aireuropa.com/weblf/rest/dpr/22-02-2018?key=C59ABE15811E20AA1EC304E6CDE9945B

'PREPRODUCCION
'http://pre.mylostbag.aireuropa.com/weblf/rest/dpr/18-06-2012?key=C59ABE15811E20AA1EC304E6CDE9945B

'sitio_web="http://pre.mylostbag.aireuropa.com/weblf/rest/dpr/18-06-2012?key=C59ABE15811E20AA1EC304E6CDE9945B"
sitio_web="https://mylostbag.aireuropa.com/weblf/rest/dpr/22-02-2018?key=C59ABE15811E20AA1EC304E6CDE9945B"
'sitio_web="http://www.google.es"

 lResolve = 50 * 1000  'Resolve timeout in milliseconds
  lConnect = 50 * 1000  'Connect timeout in milliseconds
  lSend    = 20 * 1000  'Send timeout in milliseconds
  lReceive = 560 * 1000 'Receive timeout in milliseconds 
  xmlhttp.setTimeouts lResolve, lConnect, lSend, lReceive
  
  'xmlhttp.setTimeouts 5000, 60000, 10000, 10000
  
xmlhttp.Open "GET", sitio_web , False
xmlhttp.Send
txt = xmlhttp.responseText
Set xmlhttp = Nothing

response.write("<br>RESULTADO: " & txt)

LineArray = Split(txt , chr(10))

'and then you can loop from lBound(LineArray) to uBound(LineArray) to take each line individually

For i = LBound(LineArray) To UBound(LineArray)

    response.write("<br><br>" & LineArray(i))
	campos=Split(LineArray(i), ";")
	
	For j = LBound(campos) To UBound(campos)
		response.write("<br><br>" & campos(j))
	Next

Next

%>