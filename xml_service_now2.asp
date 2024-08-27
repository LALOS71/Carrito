<%@ language=vbscript %>
<%
 'Set objXML = Server.CreateObject("Microsoft.XMLDOM")
 'Set objLst = Server.CreateObject("Microsoft.XMLDOM")
 'Set objHdl = Server.CreateObject("Microsoft.XMLDOM")
 'set objHTTP = Server.CreateObject("Microsoft.XMLHTTP")
 'objHTTP.Open "POST", "https://globaliapre.service-now.com/api/now/table/alm_asset?sysparm_query=retiredISEMPTY%5Elocation.u_codigo%3D001&sysparm_display_value=true&sysparm_exclude_reference_link=true&sysparm_fields=asset_tag%2Cu_tipo%2Cserial_number%2Cmodel%2Cpurchase_date%2Cu_ownership%2Cu_tipo_mantenimiento%2Cu_empresa_de_mantenimiento%2Cowned_by%2Cu_end_of_renting_date%2Cretired%2Ccompany%2Cdepartment%2Cu_section%2Cu_monthly_renting%2Ccomments%2Cu_acreditacion%2C", False, "GLOBALIA\19326", "rgsilvia"
 'objHTTP.open "GET", "http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml", false
 'objHTTP.send
 'Response.Write ("<textarea>" & objHTTP.responseXML.XML & "</textarea>")
 'set objXML = objHTTP.responseXML

 'Set objLst = objXML.getElementsByTagName("alm_hardware")

 'numero_elementos = objLst.length
 'Response.Write("NODOS: "&numero_elementos)

 'veces=numero_elementos-1	
 'recorro cada nodo del xml (cada oferta)
' For i = 0 To veces
  'Set objHdl = objLst.item(i)
  'Response.Write("<b>Codigo: </b>" & objHdl.childNodes(0).childNodes(0).text & "<br>")
 'next 

								Set xmlObj = CreateObject("MSXML2.DOMDocument")
								'xmlObj.loadXML (strSoap)  'este objeto no es necesario, pero nos servirá para validar la estructura del XML a pasar.
 
								'Set xmlHTTP = New MSXML2.ServerXMLHTTP
								Set xmlHTTP = CreateObject("MSXML2.ServerXMLHTTP")
								'LA PRIMERA EN PROD Y FUNCIONA: xmlHTTP.Open "POST", "https://globalia.service-now.com/alm_asset.do?XML&sysparm_query=location.u_codigo%3D474", False, "19326", "rgsilvia"
								'ORIGINAL: xmlHTTP.Open "POST", "https://globaliapre.service-now.com/api/now/table/alm_asset?sysparm_query=retiredISEMPTY%5Elocation.u_codigo%3D001&sysparm_display_value=true&sysparm_exclude_reference_link=true&sysparm_fields=asset_tag%2Cu_tipo%2Cserial_number%2Cmodel%2Cpurchase_date%2Cu_ownership%2Cu_tipo_mantenimiento%2Cu_empresa_de_mantenimiento%2Cowned_by%2Cu_end_of_renting_date%2Cretired%2Ccompany%2Cdepartment%2Cu_section%2Cu_monthly_renting%2Ccomments%2Cu_acreditacion%2C", False, "19326", "rgsilvia"
								'xmlHTTP.Open "POST", "https://globaliapre.service-now.com/alm_asset.do?XML&sysparm_query=retiredISEMPTY%5Elocation.u_codigo%3D001&sysparm_display_value=true&sysparm_exclude_reference_link=true&sysparm_fields=asset_tag%2Cu_tipo%2Cserial_number%2Cmodel%2Cpurchase_date%2Cu_ownership%2Cu_tipo_mantenimiento%2Cu_empresa_de_mantenimiento%2Cowned_by%2Cu_end_of_renting_date%2Cretired%2Ccompany%2Cdepartment%2Cu_section%2Cu_monthly_renting%2Ccomments%2Cu_acreditacion%2C", False, "19326", "rgsilvia"
								xmlHTTP.Open "POST", "https://globaliapre.service-now.com/api/now/table/alm_asset.do?sysparm_query=retiredISEMPTY%5Elocation.u_codigo%3D001&sysparm_display_value=true&sysparm_exclude_reference_link=true&sysparm_fields=asset_tag%2Cu_tipo%2Cserial_number%2Cmodel%2Cpurchase_date%2Cu_ownership%2Cu_tipo_mantenimiento%2Cu_empresa_de_mantenimiento%2Cowned_by%2Cu_end_of_renting_date%2Cretired%2Ccompany%2Cdepartment%2Cu_section%2Cu_monthly_renting%2Ccomments%2Cu_acreditacion%2C", False, "apirest", "apirest"
								
								'xmlHTTP.Open "POST", "https://globaliapre.service-now.com/api/now/table/alm_asset", False, "apirest", "apirest"
								
								'xmlHTTP.setRequestHeader "Content-Type", "text/xml;charset=utf-8"
								'xmlHTTP.setRequestHeader "SOAPAction", SOAP_ACTION
								'xmlHTTP.setRequestHeader "Content-Length", Len(xmlObj.XML)
								
								'Debug.Print xmlObj.XML
								xmlHTTP.send xmlObj.XML
								If xmlHTTP.status <> 200 Then
									Response.Write ("<br><br>error with server. HTTP status code: " & xmlHTTP.status & " Text: " & xmlHTTP.statusText)
									'Debug.Print "Status: " & xmlHTTP.status & vbNewLine & "Text: " & xmlHTTP.statusText
								End If
								Response.Write ("<textarea>" & xmlHTTP.responseXML.XML & "</textarea>")
								Set objLst = xmlHTTP.responseXML.getElementsByTagName("alm_hardware")
								num_lineas =  objLst.length
								Response.Write ("<br>N LINEAS" & num_lineas & "<br>")
 								for i=0 to num_lineas-1
									Set objHdl = objLst.item(i)
									response.Write("<b>GSC "&i&": </b>" & objHdl.childNodes(1).text & "<br>")
									response.Write("<b>GSC "&i&": </b>" & objHdl.childNodes(16).text & "<br>")
								next
								
								
								
								
								
								
								archivo= request.serverVariables("APPL_PHYSICAL_PATH") & "\Informatica\Accesos_Informatica\Mantenimiento\Sucpc\pruebas.txt" 
								set fso = createObject("scripting.filesystemobject") 
								Set salida = fso.CreateTextFile (archivo)
								salida.Write (replace(xmlHTTP.responseXML.XML,"Ñ","NN"))
								Set fso = Nothing
								Set salida = Nothing
								
 Set objXML = Server.CreateObject("Microsoft.XMLDOM")
 Set objLst = Server.CreateObject("Microsoft.XMLDOM")
 Set objHdl = Server.CreateObject("Microsoft.XMLDOM")
								
 objXML.async = False
 response.write(archivo)
 objXML.Load (archivo)

  Response.Write(Request.Form("ocultonombre_fichero") & "<br>")

 
 If objXML.parseError.errorCode <> 0 Then
	Response.Write "Error al Cargar el Documento XML :" & "<BR>"
 	Response.Write "----------------------------" & "<BR>"
	Response.Write "Codigo de Error: " & objXML.parseerror.errorcode & "<BR>"
	Response.Write "Linea En La Que Esta El Error: " & objXML.parseerror.line & "<BR>"
	Response.Write "Posicion Dentro de La Linea Donde Esta El Error: " & objXML.parseerror.linePos & "<BR>"
	Response.Write "Texto de la Linea Del Error: " & objXML.parseerror.srcText & "<BR>"
	Response.Write "Razon : " & objXML.parseerror.reason & "<BR>"
	Response.End
 End If

 Set objLst = objXML.getElementsByTagName("alm_hardware")

 numero_elementos = objLst.length
 
								Response.Write ("<br>N LINEAS" & numero_elementos & "<br>")
 								for i=0 to numero_elementos-1
								  Set objHdl = objLst.item(i)
								  Response.Write("<b>Codigo: </b>" & objHdl.childNodes(0).text & "<br>")
								  Response.Write("<b>Codigo: </b>" & objHdl.childNodes(1).text & "<br>")
								next
								
								
							    Set responseXML = Nothing
							    Set xmlHTTP = Nothing
%>

 </BODY>
 
 <%	
	%>
	
</HTML>
