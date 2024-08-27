<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<%

'con esto, conseguimos que al pasar el texto al objeto xml
'  se trate como xml y no como texto a la hora de pasarlo como
'  el request del web service
'Set xmlObj = Server.CreateObject( "MSXML2.DOMDocument" )
'Set xmlObj_respuesta = Server.CreateObject( "MSXML2.DOMDocument" )




'response.write("<br/>Cargamos el xml de los pedidos")
'paso el texto xml a un objeto xml
'xmlobj.loadXML XML_RECOGIDA

Set xmldoc = Server.CreateObject("Microsoft.XMLDOM")
Set objLst = Server.CreateObject("Microsoft.XMLDOM")

xmldoc.load(Request) 


'response.write("<br/><br/>contenido del xml...:<BR><TEXTAREA cols='90' rows='10'>" & xmldoc.XML & "</TEXTAREA>" )

'por si se da error al cargar el xml
If xmldoc.parseError.errorCode <> 0 Then
	Response.Write "Error al Cargar el Documento XML :" & "<BR>"
 	Response.Write "----------------------------" & "<BR>"
	Response.Write "Codigo de Error: " & xmldoc.parseerror.errorcode & "<BR>"
	Response.Write "Linea En La Que Esta El Error: " & xmldoc.parseerror.line & "<BR>"
	Response.Write "Posicion Dentro de La Linea Donde Esta El Error: " & xmldoc.parseerror.linePos & "<BR>"
	Response.Write "Texto de la Linea Del Error: " & xmldoc.parseerror.srcText & "<BR>"
	Response.Write "Razon : " & xmldoc.parseerror.reason & "<BR>"
	
End If


response.write(xmldoc.xml)





connimprenta.close
set connimprenta=Nothing

set xmldoc=Nothing
set objList=Nothing

%>

