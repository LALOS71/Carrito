<%@ language=vbscript%>
<script language="javascript" runat="server" src="json2_a.asp"></script>
<script language="JScript" runat="server">
function CheckProperty(obj, propName) {
    return (typeof obj[propName] != "undefined");
}
</script>

<%
access_token=""
		Set xmlHttpLogin = Server.CreateObject("MSXML2.ServerXMLHTTP")
		'objHttp.setOption 2, 13056
		
		
		
		'***********************************
		'DOCUMENTACION
		'https://apidocs.aireuropa.com//suma/suma-baggage-rest/v1.0_DRAFT.html
		
		'**********************************
		'DATOS ENTORNO DESARROLLO
		'xmlHttpLogin.Open "POST", "https://desio.aireuropa.com/suma-baggage-rest/v1/oauth2/token", False
		'xmlHttpLogin.setRequestHeader "Authorization", "Basic YXJ0ZXMtZ3JhZmljYXM6WXlPRGswSWl3aWJtSm1Jam94TmpJM09UazJNakUyTENKelk="
		
		'DATOS ENTORNO PREPRODUCCION
		xmlHttpLogin.Open "POST", "https://preio.aireuropa.com/suma-baggage-rest/v1/oauth2/token", False
		xmlHttpLogin.setRequestHeader "Authorization", "Basic YXJ0ZXMtZ3JhZmljYXM6WXlPRGswSWl3aWJtSm1JOHlFX1c1am94TmpJM09UazJNakUyTENKelk="
															  
		'xmlHttpLogin.setRequestHeader "Authorization", "YXJ0ZXMtZ3JhZmljYXM6WXlPRGswSWl3aWJtSm1Jam94TmpJM09UazJNakUyTENKelk="
		'xmlHttpLogin.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		'xmlHttpLogin.setRequestHeader "User-Agent", "Mozilla/4.0"
  		'xmlHttpLogin.setRequestHeader "Content-Type", "application/json; charset=UTF-8"
		'xmlHttpLogin.setRequestHeader "CharSet", "charset=UTF-8"
		'xmlHttpLogin.setRequestHeader "Accept", "application/json"
  	
  		RESPONSE.WRITE("<br>antes del xmlhttplogin.send")
		xmlHttpLogin.send
		RESPONSE.WRITE("<br>despues del xmlhttplogin.send")
		RESPONSE.WRITE("<br>xmlhttplogin.status: " & xmlHttpLogin.Status )
		
		If xmlHttpLogin.Status = 200 Then
			responseJson = xmlHttpLogin.responseText
			RESPONSE.WRITE("<br>contenido: " & responseJson )
			
			dim Info : set Info = JSON.parse(xmlHttpLogin.ResponseText)
				'{"codigo_cliente":"6214","codigo_pedido":"47917","numero_plantillas":-1,
				'	"plantillas":[{"nombre_grupo":"grupomm","expediente":"expmm","total_venta_expediente":"77,65","total_coste_expediente":"77,665","beneficio":"0,225"}]} 
				'{"firstname": "Fabio","lastname": "Nagao","alive": true,"age": 27,"nickname": "nagaozen",
				'		"fruits": ["banana","orange","apple","papaya","pineapple"],
				'       "complex": {"real": 1,"imaginary": 2}}		
			'por si devuelve un error o el access_token comprobamos la existencia de ese dato antes de intentar recuperarlo
			if CheckProperty(Info, "access_token") Then
				Response.write("<br>acces token: " & Info.access_token)
				access_token= "" & Info.access_token
			  else
			  	descripcion_error="<p class=""h4"">No se ha podido obtener el Token de Acceso. Vuelva a intentarlo.</p>"
			  	if CheckProperty(Info, "errorCode") Then
					descripcion_error=descripcion_error & "<p class=""h4"">Código de Error: " & Info.errorCode & "</p>"
					if CheckProperty(Info, "errorDescription") Then
						descripcion_error=descripcion_error & "<p class=""h4"">Descripción del Error: " & Info.errorDescription & "</p>"
					end if
				end if
			  	Response.write("<div class=""panel panel-danger"">")
				Response.write("<div class=""panel-heading"">")
				Response.write("<h3 class=""panel-title"">Error...</h3>")
				Response.write("</div>")
				Response.write("<div class=""panel-body panel-collapse"">")
				Response.write("<div width=""95%"">")
				Response.write(descripcion_error)
				Response.write("</div>")
				Response.write("</div>")
				Response.write("</div>")
			end if
	 
		
		  else 'no es status 200	
		  	descripcion_error="<p class=""h4"">Error en la Llamada al Servicio.</p>"
			descripcion_error=descripcion_error & "<p class=""h4"">Status: " & xmlHttpLogin.Status & "</p>"
			descripcion_error=descripcion_error & "<p class=""h4"">StatusText: " & xmlHttpLogin.StatusText & "</p>"
			descripcion_error=descripcion_error & "<p class=""h4"">ReadyState: " & xmlHttpLogin.ReadyState & "</p>"
			Response.write("<div class=""panel panel-danger"">")
			Response.write("<div class=""panel-heading"">")
			Response.write("<h3 class=""panel-title"">Error...</h3>")
			Response.write("</div>")
			Response.write("<div class=""panel-body panel-collapse"">")
			Response.write("<div width=""95%"">")
			Response.write(descripcion_error)
			Response.write("</div>")
			Response.write("</div>")
			Response.write("</div>")
			


		End If 'status 200
		
		
		if access_token <> "" then
			response.write("<br>tenemos token: " & access_token)
			
			
			
			
			
			
			'ejemplo de case id con varios TAGs, una incidencia convarias maletas
			case_id_seleccionado="BAG-39004"
			tag_seleccionado = "UX486911"
			
			
			'dependiendo del estado, se manda informacion adicional o no			
			informacion_adicional=""
			'Select Case request.form("cmbestado_d")
			'	Case 1 'PENDIENTE DE AUTORIZACION
			'		informacion_adicional=""
			'	Case 2 'AUTORIZADO
			'		informacion_adicional=""			   		
			'	Case 3 'GESTION
			'		informacion_adicional=descripcion_tipo_maleta			   		
			'	Case 4 'GESTION PENDIENTE DOC
			'		informacion_adicional=descripcion_tipo_maleta				   		
			'	Case 5 'ENVIADO
			'		informacion_adicional=descripcion_tipo_maleta				   		
			'	Case 6 'ENTREGADO
			'		informacion_adicional=descripcion_tipo_maleta			   		
			'	Case 7 'CERRADO
			'		informacion_adicional=descripcion_tipo_maleta			   		
			'	Case 8 'GESTION CIA
			'		informacion_adicional=request.form("txtgestion_cia")			   		
			'	Case 9 'INCIDENCIA
			'		descripcion_incidencia=""
			'		if request.form("cmbtipos_incidencia_d")="OTRAS INCIDENCIAS" then
			'			descripcion_incidencia="OTRAS: " & request.form("txtotrasincidencias")
			'		  else
			'			descripcion_incidencia=request.form("cmbtipos_incidencia_d")
			'		end if
			'		informacion_adicional=descripcion_incidencia			   		
			'End Select
			informacion_adicional="probando"
			
			
			'el estado es una enumeracion con estos valores
			'"enum": [
			'		"Closed",
			'		"AuthorizationPending",
			'		"Authorized",
			'		"Management",
			'		"ManagementWaitingDOCS",
			'		"Sent",
			'		"Delivered",
			'		"ManagementCIA",
			'		"Incidence"
			'	  ]
			'estados en la gestion de maletas
			'PTE. AUTORIZACIÓN
			'AUTORIZADO
			'GESTIÓN
			'GESTIÓN - PTE. DOCUMENTACIÓN
			'ENVIADO
			'ENTREGADO
			'CERRADO
			'GESTIÓN CIA
			'INCIDENCIA
			'
			
			
			estado_suma = ""
			estado_seleccionado = "AUTORIZADO"
			
			Select Case estado_seleccionado
				Case "PTE. AUTORIZACIÓN"
					estado_suma = "AuthorizationPending"
				Case "AUTORIZADO"
					estado_suma = "Authorized"
				Case "GESTIÓN"
					estado_suma = "Management"
				Case "GESTIÓN - PTE. DOCUMENTACIÓN"
					estado_suma = "ManagementWaitingDOCS"
				Case "ENVIADO"
					estado_suma = "Sent"
				Case "ENTREGADO"
					estado_suma = "Delivered"
				Case "CERRADO"
					estado_suma = "Closed"
				Case "GESTIÓN CIA"
					estado_suma = "ManagementCIA"
				Case "INCIDENCIA"
					estado_suma = "Incidence"
				Case Else
					estado_suma = estado_seleccionado
			End Select
			
			body_seleccionado = "{""info"": """ & informacion_adicional & """ , ""status"": """ & estado_suma & """}"
			
			'DESARROLLO
			'sitio_web= "https://desio.aireuropa.com/suma-baggage-rest/v1/dpr/cases/" & case_id & "/" & tag
				
			'PREPRODUCCION
			sitio_web= "https://preio.aireuropa.com/suma-baggage-rest/v1/dpr/cases/" & case_id_seleccionado & "/" & tag_seleccionado
			
			
			xmlHttpLogin.Open "PUT", sitio_web, False
			xmlHttpLogin.setRequestHeader "Authorization", "Bearer " & access_token
			xmlHttpLogin.setRequestHeader "Content-Type", "application/json"
			
			response.write("<br><br>url de llamada con el PUT: " & sitio_web)
			response.write("<br><br>esto se envia en el body: " & body_seleccionado)
			xmlHttpLogin.Send body_seleccionado
			txt = xmlHttpLogin.responseText
			
			response.write("<br><br><b>RESULTADO MODIFICACION: " & txt)
			 
		end if
%>