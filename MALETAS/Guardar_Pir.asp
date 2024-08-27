<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<script language="javascript" runat="server" src="json2_a.asp"></script>
<script language="JScript" runat="server">
function CheckProperty(obj, propName) {
    return (typeof obj[propName] != "undefined");
}
</script>


<%
Function URLEncode_utf8(cadena)
	texto=""
	For i = 1 To Len(cadena)
        letra = Mid(cadena, i, 1)
		'response.write("<br>letra " & i & ": " & letra)
		
		Select Case letra
			Case " " codigo="%20"
			Case "!" codigo="%21"
			Case """" codigo="%22"
			Case "#" codigo="%23"
			Case "$" codigo="%24"
			Case "%" codigo="%25"
			Case "&" codigo="%26"
			Case "'" codigo="%27"
			Case "(" codigo="%28"
			Case ")" codigo="%29"
			Case "*" codigo="%2A"
			Case "+" codigo="%2B"
			Case "," codigo="%2C"
			Case "-" codigo="%2D"
			Case "." codigo="%2E"
			Case "/" codigo="%2F"
			Case ":" codigo="%3A"
			Case ";" codigo="%3B"
			Case "<" codigo="%3C"
			Case "=" codigo="%3D"
			Case ">" codigo="%3E"
			Case "?" codigo="%3F"
			Case "@" codigo="%40"
			Case "[" codigo="%5B"
			Case "\" codigo="%5C"
			Case "]" codigo="%5D"
			Case "^" codigo="%5E"
			Case "_" codigo="%5F"
			Case "`" codigo="%60"
			Case "{" codigo="%7B"
			Case "|" codigo="%7C"
			Case "}" codigo="%7D"
			Case "~" codigo="%7E"
			Case "`" codigo="%E2%82%AC"
			Case "‚" codigo="%E2%80%9A"
			Case "ƒ" codigo="%C6%92"
			Case "„" codigo="%E2%80%9E"
			Case "…" codigo="%E2%80%A6"
			Case "†" codigo="%E2%80%A0"
			Case "‡" codigo="%E2%80%A1"
			Case "ˆ" codigo="%CB%86"
			Case "‰" codigo="%E2%80%B0"
			Case "Š" codigo="%C5%A0"
			Case "‹" codigo="%E2%80%B9"
			Case "Œ" codigo="%C5%92"
			Case "" codigo="%C5%8D"
			Case "Ž" codigo="%C5%BD"
			Case "" codigo="%C2%90"
			Case "‘" codigo="%E2%80%98"
			Case "’" codigo="%E2%80%99"
			Case "“" codigo="%E2%80%9C"
			Case "”" codigo="%E2%80%9D"
			Case "•" codigo="%E2%80%A2"
			Case "–" codigo="%E2%80%93"
			Case "—" codigo="%E2%80%94"
			Case "˜" codigo="%CB%9C"
			Case "™" codigo="%E2%84"
			Case "š" codigo="%C5%A1"
			Case "›" codigo="%E2%80"
			Case "œ" codigo="%C5%93"
			Case "" codigo="%9D"
			Case "ž" codigo="%C5%BE"
			Case "Ÿ" codigo="%C5%B8"
			Case "" codigo="%C2%A0"
			Case "¡" codigo="%C2%A1"
			Case "¢" codigo="%C2%A2"
			Case "£" codigo="%C2%A3"
			Case "¤" codigo="%C2%A4"
			Case "¥" codigo="%C2%A5"
			Case "¦" codigo="%C2%A6"
			Case "§" codigo="%C2%A7"
			Case "¨" codigo="%C2%A8"
			Case "©" codigo="%C2%A9"
			Case "ª" codigo="%C2%AA"
			Case "«" codigo="%C2%AB"
			Case "¬" codigo="%C2%AC"
			Case "­" codigo="%C2%AD"
			Case "®" codigo="%C2%AE"
			Case "¯" codigo="%C2%AF"
			Case "°" codigo="%C2%B0"
			Case "±" codigo="%C2%B1"
			Case "²" codigo="%C2%B2"
			Case "³" codigo="%C2%B3"
			Case "´" codigo="%C2%B4"
			Case "µ" codigo="%C2%B5"
			Case "¶" codigo="%C2%B6"
			Case "·" codigo="%C2%B7"
			Case "¸" codigo="%C2%B8"
			Case "¹" codigo="%C2%B9"
			Case "º" codigo="%C2%BA"
			Case "»" codigo="%C2%BB"
			Case "¼" codigo="%C2%BC"
			Case "½" codigo="%C2%BD"
			Case "¾" codigo="%C2%BE"
			Case "¿" codigo="%C2%BF"
			Case "À" codigo="%C3%80"
			Case "Á" codigo="%C3%81"
			Case "Â" codigo="%C3%82"
			Case "Ã" codigo="%C3%83"
			Case "Ä" codigo="%C3%84"
			Case "Å" codigo="%C3%85"
			Case "Æ" codigo="%C3%86"
			Case "Ç" codigo="%C3%87"
			Case "È" codigo="%C3%88"
			Case "É" codigo="%C3%89"
			Case "Ê" codigo="%C3%8A"
			Case "Ë" codigo="%C3%8B"
			Case "Ì" codigo="%C3%8C"
			Case "Í" codigo="%C3%8D"
			Case "Î" codigo="%C3%8E"
			Case "Ï" codigo="%C3%8F"
			Case "Ð" codigo="%C3%90"
			Case "Ñ" codigo="%C3%91"
			Case "Ò" codigo="%C3%92"
			Case "Ó" codigo="%C3%93"
			Case "Ô" codigo="%C3%94"
			Case "Õ" codigo="%C3%95"
			Case "Ö" codigo="%C3%96"
			Case "×" codigo="%C3%97"
			Case "Ø" codigo="%C3%98"
			Case "Ù" codigo="%C3%99"
			Case "Ú" codigo="%C3%9A"
			Case "Û" codigo="%C3%9B"
			Case "Ü" codigo="%C3%9C"
			Case "Ý" codigo="%C3%9D"
			Case "Þ" codigo="%C3%9E"
			Case "ß" codigo="%C3%9F"
			Case "à" codigo="%C3%A0"
			Case "á" codigo="%C3%A1"
			Case "â" codigo="%C3%A2"
			Case "ã" codigo="%C3%A3"
			Case "ä" codigo="%C3%A4"
			Case "å" codigo="%C3%A5"
			Case "æ" codigo="%C3%A6"
			Case "ç" codigo="%C3%A7"
			Case "è" codigo="%C3%A8"
			Case "é" codigo="%C3%A9"
			Case "ê" codigo="%C3%AA"
			Case "ë" codigo="%C3%AB"
			Case "ì" codigo="%C3%AC"
			Case "í" codigo="%C3%AD"
			Case "î" codigo="%C3%AE"
			Case "ï" codigo="%C3%AF"
			Case "ð" codigo="%C3%B0"
			Case "ñ" codigo="%C3%B1"
			Case "ò" codigo="%C3%B2"
			Case "ó" codigo="%C3%B3"
			Case "ô" codigo="%C3%B4"
			Case "õ" codigo="%C3%B5"
			Case "ö" codigo="%C3%B6"
			Case "÷" codigo="%C3%B7"
			Case "ø" codigo="%C3%B8"
			Case "ù" codigo="%C3%B9"
			Case "ú" codigo="%C3%BA"
			Case "û" codigo="%C3%BB"
			Case "ü" codigo="%C3%BC"
			Case "ý" codigo="%C3%BD"
			Case "þ" codigo="%C3%BE"
			Case "ÿ" codigo="%C3%BF"
			Case Else codigo=letra
		End Select
		texto=texto & codigo
    Next
	URLEncode_utf8=texto
End Function
%>

<%
		if session("usuario")="" then
			response.Redirect("Login.asp")
		end if
		
		id_seleccionado= Request.Form("ocultoid_pir")
		estado=Request.Form("cmbestado_p")
		
		'response.write("<br<br>Proveedor: " & request.form("cmbproveedores_d"))
		
		'response.write("<br>id: " & id)
		'response.write("<br>estado: " & estado)
		
		
		campo_id=""
		campo_fecha_orden=""
		campo_expediente="" ''''''''''''''BORRAR?????
		campo_pir=""
		campo_fecha_pir=""
		campo_tag=""
		campo_nombre=""
		campo_apellidos=""
		campo_movil=""
		campo_fijo=""
		campo_direccion_entrega=""
		campo_cp_entrega=""
		campo_email=""
		campo_tipo_direccion_entrega=""
		campo_desde_hasta=""
		campo_fecha_desde_hasta=""
		campo_tipo_equipaje_bag_original="" 'EL QUE VIENE CON LA FICHA DEL ARTICULO DESDE INDIANA
		campo_marca_bag_original=""
		campo_marcawt=""
		campo_material_bag_original=""
		campo_color_bag_original=""
		campo_largo_bag_original=""
		campo_alto_bag_original=""
		campo_ancho_bag_original=""
		campo_danno_ruedas_bag_original=""
		campo_danno_asas_bag_original=""
		campo_danno_cierres_bag_original=""
		campo_danno_cremallera_bag_original=""
		campo_danno_cuerpo_maleta_bag_original=""
		campo_danno_otros_bag_original=""
		
		
		
		campo_ruta=""
		campo_vuelos=""
		campo_tipo_bag_original="" 'COMBO QUE SELECCIONA GROUNDFORCE PARA DESPUES PODER ASGINAR EL PIR A UN PROVEEDOR
		campo_fecha_inicio=""
		campo_importe_facturacion="" 
		campo_fecha_facturacion=""
		campo_fecha_envio=""
		campo_fecha_entrega_pax=""
		campo_tipo_bag_entregada=""
		campo_tamanno_bag_entregada=""
		campo_referencia_bag_entregada=""
		campo_color_bag_entregada=""
		campo_numero_expedicion=""
		campo_costes=""
		campo_observaciones_proveedor=""
		campo_fecha_fichero_importacion = ""
		campo_estado=""
		campo_proveedor=""
		campo_caseid=""
		
		
		if request.form("chkdanno_ruedas_d")="on" then
			actual_danno_ruedas=1
		 else
			actual_danno_ruedas=0
		end if
		if request.form("chkdanno_asas_d")="on" then
			actual_danno_asas=1
		 else
			actual_danno_asas=0
		end if
		if request.form("chkdanno_cierres_d")="on" then
			actual_danno_cierres=1
		 else
			actual_danno_cierres=0
		end if
		if request.form("chkdanno_cremalleras_d")="on" then
			actual_danno_cremalleras=1
		 else
			actual_danno_cremalleras=0
		end if
		if request.form("chkdanno_cuerpo_maleta_d")="on" then
			actual_danno_cuerpo_maleta=1
		 else
			actual_danno_cuerpo_maleta=0
		end if
		
		if request.form("chkdanno_otros_dannos_d")="on" then
			actual_danno_otros_dannos=1
		 else
			actual_danno_otros_dannos=0
		end if
	
	
	
		
		
		if id_seleccionado<>"" then 'ES UNA MODIFICACION
			
			
			
			
			set detalle_pir=Server.CreateObject("ADODB.Recordset")
			with detalle_pir
				.ActiveConnection=connmaletas
				.Source="SELECT ID, FECHA_ORDEN, EXPEDIENTE, PIR, FECHA_PIR, TAG, NOMBRE, APELLIDOS, MOVIL, FIJO, EMAIL"
				.Source= .Source & ", DIRECCION_ENTREGA, CP_ENTREGA, TIPO_DIRECCION_ENTREGA, DESDE_HASTA, FECHA_DESDE_HASTA"
				.Source= .Source & ", TIPO_EQUIPAJE_BAG_ORIGINAL, MARCA_BAG_ORIGINAL, MATERIAL_BAG_ORIGINAL"
				.Source= .Source & ", COLOR_BAG_ORIGINAL, LARGO_BAG_ORIGINAL, ALTO_BAG_ORIGINAL, ANCHO_BAG_ORIGINAL, DANNO_RUEDAS_BAG_ORIGINAL"
				.Source= .Source & ", DANNO_ASAS_BAG_ORIGINAL, DANNO_CIERRES_BAG_ORIGINAL, DANNO_CREMALLERA_BAG_ORIGINAL"
				.Source= .Source & ", DANNO_CUERPO_MALETA_BAG_ORIGINAL, DANNO_OTROS_BAG_ORIGINAL"
				.Source= .Source & ", RUTA, VUELOS, TIPO_BAG_ORIGINAL, PROVEEDOR, FECHA_INICIO, FECHA_ENVIO, FECHA_ENTREGA_PAX"
				.Source= .Source & ", TIPO_BAG_ENTREGADA, TAMANNO_BAG_ENTREGADA, REFERENCIA_BAG_ENTREGADA, COLOR_BAG_ENTREGADA, NUM_EXPEDICION, COSTES"
				.Source= .Source & ", ESTADO, IMPORTE_FACTURACION, FECHA_FACTURACION, FECHA_FICHERO_IMPORTACION, OBSERVACIONES_PROVEEDOR"
				.Source= .Source & ", MARCAWT, CASEID"
				.Source= .Source & " FROM PIRS"
				.Source= .Source & " WHERE ID=" & id_seleccionado
				'response.write("<br>" & .source)
				.Open
			end with
	
			
		
			
			
			if not detalle_pir.eof then
				campo_id="" & detalle_pir("id")
				
				campo_fecha_orden = ""
				if detalle_pir("fecha_orden")<>"" then
					dia = "0" & datepart("d", cdate(detalle_pir("fecha_orden")))
					mes = "0" & datepart("m", cdate(detalle_pir("fecha_orden")))
					anno = datepart("yyyy", cdate(detalle_pir("fecha_orden")))
					campo_fecha_orden = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
				end if
				
				campo_expediente="" & detalle_pir("expediente")
				campo_pir="" & detalle_pir("pir")
				
				campo_fecha_pir = "" 
				if detalle_pir("fecha_pir")<>"" then
					dia = "0" & datepart("d", cdate(detalle_pir("fecha_pir")))
					mes = "0" & datepart("m", cdate(detalle_pir("fecha_pir")))
					anno = datepart("yyyy", cdate(detalle_pir("fecha_pir")))
					campo_fecha_pir = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
				end if
				
				campo_tag="" & detalle_pir("tag")
				campo_nombre="" & detalle_pir("nombre")
				campo_apellidos="" & detalle_pir("apellidos")
				campo_movil="" & detalle_pir("movil")
				campo_fijo="" & detalle_pir("fijo")
				campo_direccion_entrega="" & detalle_pir("direccion_entrega")
				campo_cp_entrega="" & detalle_pir("cp_entrega")
				campo_email="" & detalle_pir("email")
				campo_tipo_direccion_entrega="" & detalle_pir("tipo_direccion_entrega")
				campo_desde_hasta="" & detalle_pir("desde_hasta")
				
				campo_fecha_desde_hasta = ""
				if detalle_pir("fecha_desde_hasta")<>"" then
					dia = "0" & datepart("d", cdate(detalle_pir("fecha_desde_hasta")))
					mes = "0" & datepart("m", cdate(detalle_pir("fecha_desde_hasta")))
					anno = datepart("yyyy", cdate(detalle_pir("fecha_desde_hasta")))
					campo_fecha_desde_hasta = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
				end if
		
				campo_tipo_equipaje_bag_original="" & detalle_pir("tipo_equipaje_bag_original")
				campo_marca_bag_original="" & detalle_pir("marca_bag_original")
				campo_marcawt="" & detalle_pir("marcawt")
				campo_material_bag_original="" & detalle_pir("material_bag_original")
				campo_color_bag_original="" & detalle_pir("color_bag_original")
				campo_largo_bag_original="" & detalle_pir("largo_bag_original")
				campo_alto_bag_original="" & detalle_pir("alto_bag_original")
				campo_ancho_bag_original="" & detalle_pir("ancho_bag_original")
				
				if detalle_pir("danno_ruedas_bag_original") then
					campo_danno_ruedas_bag_original=1
				  else
				  	campo_danno_ruedas_bag_original=0
				end if
				if detalle_pir("danno_asas_bag_original") then
					campo_danno_asas_bag_original=1
				  else
				  	campo_danno_asas_bag_original=0
				end if
				if detalle_pir("danno_cierres_bag_original") then
					campo_danno_cierres_bag_original=1
				  else
				  	campo_danno_cierres_bag_original=0
				end if
				if detalle_pir("danno_cremallera_bag_original") then
					campo_danno_cremallera_bag_original=1
				  else
				  	campo_danno_cremallera_bag_original=0
				end if
				if detalle_pir("danno_cuerpo_maleta_bag_original") then
					campo_danno_cuerpo_maleta_bag_original=1
				  else
				  	campo_danno_cuerpo_maleta_bag_original=0
				end if
				if detalle_pir("danno_otros_bag_original") then
					campo_danno_otros_bag_original=1
				  else
				  	campo_danno_otros_bag_original=0
				end if
						
				'pongo 0 y 1 porque con true o false, se traduce a verdadero falso y me da problemas		
				'campo_danno_ruedas_bag_original="" & lcase(detalle_pir("danno_ruedas_bag_original"))
				'campo_danno_asas_bag_original="" & lcase(detalle_pir("danno_asas_bag_original"))
				'campo_danno_cierres_bag_original="" & lcase(detalle_pir("danno_cierres_bag_original"))
				'campo_danno_cremallera_bag_original="" & lcase(detalle_pir("danno_cremallera_bag_original"))
				'campo_danno_cuerpo_maleta_bag_original="" & lcase(detalle_pir("danno_cuerpo_maleta_bag_original"))
				'campo_danno_otros_bag_original="" & lcase(detalle_pir("danno_otros_bag_original"))
				
				'response.write("<br><BR>campo daño cremallera: " & campo_danno_cremallera_bag_original)
				'response.write("<br><BR>campo daño otros: " & campo_danno_otros_bag_original)
				
			
				
				
				campo_ruta="" & detalle_pir("ruta")
				campo_vuelos="" & detalle_pir("vuelos")
				campo_tipo_bag_original="" & detalle_pir("tipo_bag_original")
				
				campo_fecha_inicio = "" 
				if detalle_pir("fecha_inicio")<>"" then
					dia = "0" & datepart("d", cdate(detalle_pir("fecha_inicio")))
					mes = "0" & datepart("m", cdate(detalle_pir("fecha_inicio")))
					anno = datepart("yyyy", cdate(detalle_pir("fecha_inicio")))
					campo_fecha_inicio = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
				end if
				
				campo_importe_facturacion="" & detalle_pir("importe_facturacion")
				
				campo_fecha_facturacion = ""
				if detalle_pir("fecha_facturacion")<>"" then
					dia = "0" & datepart("d", cdate(detalle_pir("fecha_facturacion")))
					mes = "0" & datepart("m", cdate(detalle_pir("fecha_facturacion")))
					anno = datepart("yyyy", cdate(detalle_pir("fecha_facturacion")))
					campo_fecha_facturacion = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
				end if
				
				campo_fecha_envio = "" 
				if detalle_pir("fecha_envio")<>"" then
					dia = "0" & datepart("d", cdate(detalle_pir("fecha_envio")))
					mes = "0" & datepart("m", cdate(detalle_pir("fecha_envio")))
					anno = datepart("yyyy", cdate(detalle_pir("fecha_envio")))
					campo_fecha_envio = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
				end if
				
				campo_fecha_entrega_pax = "" 
				if detalle_pir("fecha_entrega_pax")<>"" then
					dia = "0" & datepart("d", cdate(detalle_pir("fecha_entrega_pax")))
					mes = "0" & datepart("m", cdate(detalle_pir("fecha_entrega_pax")))
					anno = datepart("yyyy", cdate(detalle_pir("fecha_entrega_pax")))
					campo_fecha_entrega_pax = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
				end if
				
				campo_tipo_bag_entregada="" & detalle_pir("tipo_bag_entregada")
				campo_tamanno_bag_entregada="" & detalle_pir("tamanno_bag_entregada")
				campo_referencia_bag_entregada="" & detalle_pir("referencia_bag_entregada")
				campo_color_bag_entregada="" & detalle_pir("color_bag_entregada")
				campo_numero_expedicion="" & detalle_pir("num_expedicion")
				campo_costes="" & detalle_pir("costes")
				campo_observaciones_proveedor="" & detalle_pir("observaciones_proveedor")
				campo_fecha_fichero_importacion="" & detalle_pir("fecha_fichero_importacion")
				campo_estado="" & detalle_pir("estado")
				campo_proveedor="" & detalle_pir("proveedor")
				campo_caseid="" & detalle_pir("caseid")
			end if
			
			detalle_pir.close
			set detalle_pir=Nothing
			
			
			'RESPONSE.write("<br>campo_direccion_entrega grabado: " & campo_direccion_entrega)
			'RESPONSE.write("<br>campo_direccion_entrega nuevo: " & request.form("txtdireccion_entrega_d"))
			
			'RESPONSE.write("<br>campo_cp_entrega: " & campo_cp_entrega)
			'RESPONSE.write("<br>campo_cp_entrega nuevo: " & request.form("txtcp_entrega_d") )
			
			'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
			' de fecha con mes-dia-año
			connmaletas.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
						
			
					
			'response.write("<br><BR>campo daño cremallera: " & campo_danno_cremallera_bag_original)
			'response.write("<br><BR>campo daño otros: " & campo_danno_otros_bag_original)
						
			'response.write("<br><BR>actual daño cremallera: " & actual_danno_cremalleras)	
			'response.write("<br><BR>actual daño otros: " & actual_danno_otros_dannos)	
			
			
			cadena_pir=""
			
			
			'response.write("campo nombre... nombre antiguo: " & campo_nombre)
			'response.write("campo nombre... nombre nuevo: " & request.form("txtnombre_d"))
			
			connmaletas.BeginTrans 'Comenzamos la Transaccion

			'como estos campos vienen de indiana y no se pueden modificar, no hacemos las comprobaciones
			'if campo_fecha_orden<>request.form("txtfecha_orden_d") then		
			'	cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			'	cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			'	cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			'	cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA ORDEN', '" & campo_fecha_orden & "',"
			'	cadena_historico=cadena_historico & " '" & request.form("txtfecha_orden_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
			'	response.write("<br>cadena_historico: " & cadena_historico)
	
			'	if cadena_pir<>"" then
			'		cadena_pir=cadena_pir & ", "
			'	end if
			'	cadena_pir = cadena_pir & "FECHA_ORDEN='" & cdate(request.form("txtfecha_orden_d")) &"'"
				
			'	connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			'end if

			'''''''''el campo_expediente... BORRAR???????????????
			
			'campo_pir... no se puede modificar, luego no hacemos comprobacion
		
			'if campo_fecha_pir<>request.form("txtfecha_pir_d") then		
			'	cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			'	cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			'	cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			'	cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA PIR', '" & campo_fecha_pir & "',"
			'	cadena_historico=cadena_historico & " '" & request.form("txtfecha_pir_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
			'	response.write("<br>cadena_historico: " & cadena_historico)
	
			'	if cadena_pir<>"" then
			'		cadena_pir=cadena_pir & ", "
			'	end if
			'	cadena_pir = cadena_pir & "FECHA_PIR='" & cdate(request.form("txtfecha_pir_d")) &"'"
				
			'	connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			'end if

			'if campo_tag<>request.form("txttag_d") then		
			'	cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			'	cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			'	cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			'	cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TAG', '" & campo_tag & "',"
			'	cadena_historico=cadena_historico & " '" & request.form("txttag_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
			'	response.write("<br>cadena_historico: " & cadena_historico)
	
			'	if cadena_pir<>"" then
			'		cadena_pir=cadena_pir & ", "
			'	end if
			'	cadena_pir = cadena_pir & "TAG='" & request.form("txttag_d") &"'"
				
			'	connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			'end if

				if campo_nombre<>request.form("txtnombre_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'NOMBRE', '" & campo_nombre & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtnombre_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "NOMBRE='" & request.form("txtnombre_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
		
				if campo_apellidos<>request.form("txtapellidos_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'APELLIDOS', '" & campo_apellidos & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtapellidos_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "APELLIDOS='" & request.form("txtapellidos_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if

				if campo_movil<>request.form("txtmovil_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'MOVIL', '" & campo_movil & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtmovil_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "MOVIL='" & request.form("txtmovil_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
				
				if campo_fijo<>request.form("txtfijo_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TLF. FIJO', '" & campo_fijo & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtfijo_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "FIJO='" & request.form("txtfijo_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
				
				
				
				if campo_email<>request.form("txtemail_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'EMAIL', '" & campo_email & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtemail_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "EMAIL='" & request.form("txtemail_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
				
				
			'estos campos ya los puede modificar el PROVEEDOR y no solo los modifica el ADMINISTRADOR
			if session("perfil_usuario")="ADMINISTRADOR" then
				if campo_tipo_direccion_entrega<>request.form("cmbtipo_direccion_entrega_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TIPO DIR', '" & campo_tipo_direccion_entrega & "',"
					cadena_historico=cadena_historico & " '" & request.form("cmbtipo_direccion_entrega_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "TIPO_DIRECCION_ENTREGA='" & request.form("cmbtipo_direccion_entrega_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
				
				if campo_desde_hasta<>request.form("cmbdesde_hasta_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DESDE/HASTA', '" & campo_desde_hasta & "',"
					cadena_historico=cadena_historico & " '" & request.form("cmbdesde_hasta_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "DESDE_HASTA='" & request.form("cmbdesde_hasta_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
	
				if campo_fecha_desde_hasta<>request.form("txtfecha_desde_hasta_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FEC. DES/HAS', '" & campo_fecha_desde_hasta & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtfecha_desde_hasta_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					if request.form("txtfecha_desde_hasta_d")<>"" then
						cadena_pir = cadena_pir & "FECHA_DESDE_HASTA='" & cdate(request.form("txtfecha_desde_hasta_d")) & "'"
					  else
						cadena_pir = cadena_pir & "FECHA_DESDE_HASTA=NULL"
					end if
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
			
				if campo_tipo_equipaje_bag_original<>request.form("txttipo_equipaje_bag_original_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TIPO EQUIPAJE', '" & campo_tipo_equipaje_bag_original & "',"
					cadena_historico=cadena_historico & " '" & request.form("txttipo_equipaje_bag_original_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "TIPO_EQUIPAJE_BAG_ORIGINAL='" & request.form("txttipo_equipaje_bag_original_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
				
				
				if campo_marca_bag_original<>request.form("txtmarca_bag_original_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'MARCA', '" & campo_marca_bag_original & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtmarca_bag_original_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "MARCA_BAG_ORIGINAL='" & request.form("txtmarca_bag_original_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
				
				if campo_marcawt<>request.form("txtmarcawt_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'MARCAWT', '" & campo_marcawt & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtmarcawt_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "MARCAWT='" & request.form("txtmarcawt_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
				
				
				if campo_material_bag_original<>request.form("txtmaterial_bag_original_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'MATERIAL', '" & campo_material_bag_original & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtmaterial_bag_original_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "MATERIAL_BAG_ORIGINAL='" & request.form("txtmaterial_bag_original_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
	
				if campo_color_bag_original<>request.form("txtcolor_bag_original_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'COLOR', '" & campo_color_bag_original & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtcolor_bag_original_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "COLOR_BAG_ORIGINAL='" & request.form("txtcolor_bag_original_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
				
				if campo_largo_bag_original<>request.form("txtlargo_bag_original_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'LARGO', '" & campo_largo_bag_original & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtlargo_bag_original_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "LARGO_BAG_ORIGINAL='" & request.form("txtlargo_bag_original_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
	
				if campo_alto_bag_original<>request.form("txtalto_bag_original_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'ALTO', '" & campo_alto_bag_original & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtalto_bag_original_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "ALTO_BAG_ORIGINAL='" & request.form("txtalto_bag_original_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
				
				if campo_ancho_bag_original<>request.form("txtancho_bag_original_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'ANCHO', '" & campo_ancho_bag_original & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtancho_bag_original_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "ANCHO_BAG_ORIGINAL='" & request.form("txtancho_bag_original_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
			end if 'de lo que solo modifica el ADMINISTRADOR
			
			
			if campo_direccion_entrega<>request.form("txtdireccion_entrega_d") then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DIRECCION', '" & campo_direccion_entrega & "',"
				cadena_historico=cadena_historico & " '" & request.form("txtdireccion_entrega_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "DIRECCION_ENTREGA='" & request.form("txtdireccion_entrega_d") &"'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			
			if campo_cp_entrega<>request.form("txtcp_entrega_d") then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'CP', '" & campo_cp_entrega & "',"
				cadena_historico=cadena_historico & " '" & request.form("txtcp_entrega_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "CP_ENTREGA='" & request.form("txtcp_entrega_d") &"'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
				
			if campo_danno_ruedas_bag_original<>actual_danno_ruedas then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DAÑO RUEDAS', '" & campo_danno_ruedas_bag_original & "',"
				cadena_historico=cadena_historico & " '" & actual_danno_ruedas & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "DANNO_RUEDAS_BAG_ORIGINAL='" & actual_danno_ruedas & "'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			
			if campo_danno_asas_bag_original<>actual_danno_asas then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DAÑO ASAS', '" & campo_danno_asas_bag_original & "',"
				cadena_historico=cadena_historico & " '" & actual_danno_asas & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "DANNO_ASAS_BAG_ORIGINAL='" & actual_danno_asas & "'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			
			if campo_danno_cierres_bag_original<>actual_danno_cierres then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DAÑO CIERRES', '" & campo_danno_cierres_bag_original & "',"
				cadena_historico=cadena_historico & " '" & actual_danno_cierres & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "DANNO_CIERRES_BAG_ORIGINAL='" & actual_danno_cierres & "'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			'response.write("<br><BR>campo daño cremallera: " & campo_danno_cremallera_bag_original)
			'response.write("<br><BR>campo daño otros: " & campo_danno_otros_bag_original)
						
			'response.write("<br><BR>actual daño cremallera: " & actual_danno_cremalleras)	
			'response.write("<br><BR>actual daño otros: " & actual_danno_otros_dannos)	
			
			
			if campo_danno_cremallera_bag_original<>actual_danno_cremalleras then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DAÑO CREMALLERAS', '" & campo_danno_cremallera_bag_original & "',"
				cadena_historico=cadena_historico & " '" & actual_danno_cremalleras & "', '" & session("usuario") & "', NULL, NULL)"
				

				
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "DANNO_CREMALLERA_BAG_ORIGINAL='" & actual_danno_cremalleras & "'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			
			if campo_danno_cuerpo_maleta_bag_original<>actual_danno_cuerpo_maleta then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DAÑO CUERPO BAG', '" & campo_danno_cuerpo_maleta_bag_original & "',"
				cadena_historico=cadena_historico & " '" & actual_danno_cuerpo_maleta & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "DANNO_CUERPO_MALETA_BAG_ORIGINAL='" & actual_danno_cuerpo_maleta & "'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if

			
			'response.write("<br><BR>campo daño cremallera: " & campo_danno_cremallera_bag_original)
			'response.write("<br><BR>campo daño otros: " & campo_danno_otros_bag_original)
						
			'response.write("<br><BR>actual daño cremallera: " & actual_danno_cremalleras)	
			'response.write("<br><BR>actual daño otros: " & actual_danno_otros_dannos)	
						
			if campo_danno_otros_bag_original<>actual_danno_otros_dannos then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'OTROS DAÑOS BAG', '" & campo_danno_otros_bag_original & "',"
				cadena_historico=cadena_historico & " '" & actual_danno_otros_dannos & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "DANNO_OTROS_BAG_ORIGINAL='" & actual_danno_otros_dannos & "'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if

			
			'response.write("<br><BR>campo daño cremallera: " & campo_danno_cremallera_bag_original)
			'response.write("<br><BR>campo daño otros: " & campo_danno_otros_bag_original)
						
			'response.write("<br><BR>actual daño cremallera: " & actual_danno_cremalleras)	
			'response.write("<br><BR>actual daño otros: " & actual_danno_otros_dannos)	
			
			
			
			'como estos campos vienen de indiana y no se pueden modificar, no hacemos las comprobaciones
			'if campo_ruta<>request.form("txtruta_d") then		
			'	cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			'	cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			'	cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			'	cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'RUTA', '" & campo_ruta & "',"
			'	cadena_historico=cadena_historico & " '" & request.form("txtruta_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
			'	response.write("<br>cadena_historico: " & cadena_historico)
	
			'	if cadena_pir<>"" then
			'		cadena_pir=cadena_pir & ", "
			'	end if
			'	cadena_pir = cadena_pir & "RUTA='" & request.form("txtruta_d") &"'"
				
			'	connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			'end if

			
			'if campo_vuelos<>request.form("txtvuelos_d") then		
			'	cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			'	cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			'	cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			'	cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'VUELOS', '" & campo_vuelos & "',"
			'	cadena_historico=cadena_historico & " '" & request.form("txtvuelos_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
			'	response.write("<br>cadena_historico: " & cadena_historico)
	
			'	if cadena_pir<>"" then
			'		cadena_pir=cadena_pir & ", "
			'	end if
			'	cadena_pir = cadena_pir & "VUELOS='" & request.form("txtvuelos_d") &"'"
				
			'	connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			'end if

			'estos campos solo los modifica el ADMINISTRADOR
			if session("perfil_usuario")="ADMINISTRADOR" then
				if campo_tipo_bag_original<>request.form("cmbtipo_maleta_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TIPO BAG AUTORIZADA', '" & campo_tipo_bag_original & "',"
					cadena_historico=cadena_historico & " '" & request.form("cmbtipo_maleta_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "TIPO_BAG_ORIGINAL='" & request.form("cmbtipo_maleta_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
			
				'campo_fecha_inicio.... como se pone sola al autorizar un PIR, no se hacen comprobaciones
				if campo_fecha_inicio<>request.form("txtfecha_inicio_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA INICIO', '" & campo_fecha_inicio & "',"
					cadena_historico=cadena_historico & " '" & cdate(request.form("txtfecha_inicio_d")) & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "FECHA_INICIO='" & cdate(request.form("txtfecha_inicio_d")) &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if

				if campo_importe_facturacion<>request.form("txtimporte_facturacion_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'IMPORTE FACTURACION', '" & campo_importe_facturacion & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtimporte_facturacion_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "IMPORTE_FACTURACION=" & replace(request.form("txtimporte_facturacion_d"), ",", ".")
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if

				if campo_fecha_facturacion<>request.form("txtfecha_facturacion_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FEC. FACTURA.', '" & campo_fecha_facturacion & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtfecha_facturacion_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					IF request.form("txtfecha_facturacion_d")<>"" THEN
						cadena_pir = cadena_pir & "FECHA_FACTURACION='" & cdate(request.form("txtfecha_facturacion_d")) & "'"
					  ELSE
						cadena_pir = cadena_pir & "FECHA_FACTURACION=NULL"
					END IF
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
			end if 'de los que puede modificar el ADMINISTRADOR				
			
			'campo_fecha_envio..... al ponerse al pasar el PIR a ENVIADO, no se hace comprobaciones
			if campo_fecha_envio<>request.form("txtfecha_envio_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA ENVIO', '" & campo_fecha_envio & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtfecha_envio_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					IF request.form("txtfecha_envio_d")<>"" THEN
						cadena_pir = cadena_pir & "FECHA_ENVIO='" & cdate(request.form("txtfecha_envio_d")) & "'"
					  ELSE
						cadena_pir = cadena_pir & "FECHA_ENVIO=NULL"
					END IF
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if

			'campo_fecha_entrega_pax... al ponerse al pasa el PIR a ENTREGADO, no se hace comprobaciones
			if campo_fecha_entrega_pax<>request.form("txtfecha_entrega_pax_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA ENTREGA PAX', '" & campo_fecha_entrega_pax & "',"
					cadena_historico=cadena_historico & " '" & request.form("txtfecha_entrega_pax_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					IF request.form("txtfecha_facturacion_d")<>"" THEN
						cadena_pir = cadena_pir & "FECHA_FACTURACION='" & cdate(request.form("txtfecha_facturacion_d")) & "'"
					  ELSE
						cadena_pir = cadena_pir & "FECHA_FACTURACION=NULL"
					END IF
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
	
	
			if campo_tipo_bag_entregada<>request.form("cmbtipo_maleta_entregada_d") then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TIPO BAG ENTREGADA', '" & campo_tipo_bag_entregada & "',"
				cadena_historico=cadena_historico & " '" & request.form("cmbtipo_maleta_entregada_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "TIPO_BAG_ENTREGADA='" & request.form("cmbtipo_maleta_entregada_d") &"'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			
			
			if campo_tamanno_bag_entregada<>request.form("cmbtamanno_maleta_entregada_d") then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TAMAÑO BAG ENTREGADA', '" & campo_tamanno_bag_entregada & "',"
				cadena_historico=cadena_historico & " '" & request.form("cmbtamanno_maleta_entregada_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "TAMANNO_BAG_ENTREGADA='" & request.form("cmbtamanno_maleta_entregada_d") &"'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if

			if campo_referencia_bag_entregada<>request.form("txtreferencia_maleta_entregada_d") then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'REFERENCIA BAG ENTREGADA', '" & campo_referencia_bag_entregada & "',"
				cadena_historico=cadena_historico & " '" & request.form("txtreferencia_maleta_entregada_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "REFERENCIA_BAG_ENTREGADA='" & request.form("txtreferencia_maleta_entregada_d") &"'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			
			
			if campo_color_bag_entregada<>request.form("txtcolor_maleta_entregada_d") then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'COLOR BAG ENTREGADA', '" & campo_color_bag_entregada & "',"
				cadena_historico=cadena_historico & " '" & request.form("txtcolor_maleta_entregada_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "COLOR_BAG_ENTREGADA='" & request.form("txtcolor_maleta_entregada_d") &"'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			
			
			if campo_numero_expedicion<>request.form("txtnumero_expedicion_d") then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'NUMERO EXPEDICION', '" & campo_numero_expedicion & "',"
				cadena_historico=cadena_historico & " '" & request.form("txtnumero_expedicion_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "NUM_EXPEDICION='" & request.form("txtnumero_expedicion_d") &"'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			
				
			if campo_costes<>request.form("txtcostes_d") then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'COSTES', '" & campo_costes & "',"
				cadena_historico=cadena_historico & " '" & request.form("txtcostes_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				if request.form("txtcostes_d")<>"" then
					cadena_pir = cadena_pir & "COSTES=" & REPLACE(request.form("txtcostes_d"), ",", ".")
				  else
					cadena_pir = cadena_pir & "COSTES=NULL"
				end if
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if

			if campo_observaciones_proveedor<>request.form("txtobservaciones_proveedor_d") then		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'OBSERVACIONES PROVEEDOR', '" & campo_observaciones_proveedor & "',"
				cadena_historico=cadena_historico & " '" & request.form("txtobservaciones_proveedor_d") & "', '" & session("usuario") & "', NULL, NULL)"
				
				'response.write("<br>cadena_historico: " & cadena_historico)
	
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "OBSERVACIONES_PROVEEDOR='" & request.form("txtobservaciones_proveedor_d") &"'"
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			
				
			'este campo solo los modifica el ADMINISTRADOR
			if session("perfil_usuario")="ADMINISTRADOR" then
				if campo_proveedor<>request.form("cmbproveedores_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'PROVEEDOR', '" & campo_proveedor & "',"
					cadena_historico=cadena_historico & " '" & request.form("cmbproveedores_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "PROVEEDOR=" & request.form("cmbproveedores_d")
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if
			end if
	
			
			
			'*****************************************************************************************
			'---------------------------------------------------------------
			' SECCION DONDE INFORMAMOS DEL CAMBIO DE ESTADO A INDIANA O PEGA
			' y solo si recibimos un OK GUARDAMOS EL CAMBIO DE ESTADO Y SU CORRESPONDIENTES HISTORICOS
			' si no devuelve OK, se guardan todos los cambios menos el estado

			
			'recogemos el caseid y el tag para saber si tenemos que llamar a indiana o a pega
			case_id_seleccionado=campo_caseid
			tag_seleccionado = campo_tag
			
			control_respuesta_indiana_pega = "OK"
			texto_respuesta_indiana_pega = ""
			

			
			if campo_estado<>request.form("cmbestado_d") or (request.form("cmbtipos_incidencia_d")<>"" and  request.form("cmbestado_d")="9") then
				fecha_accion= right("0" & day(date), 2) & "/" & _
								right("0" & month(date), 2) &  "/" & _
								year(Date) & " " & _
								right("0" & hour(time), 2) &  ":" & _
								right("0" & minute(time), 2) &  ":" & _
								right("0" & second(time), 2)
				
				descripcion_estado=""
				set estado_pir=Server.CreateObject("ADODB.Recordset")
				with estado_pir
					.ActiveConnection=connmaletas
					.Source="SELECT DESCRIPCION"
					.Source= .Source & " FROM ESTADOS"
					.Source= .Source & " WHERE ID=" & request.form("cmbestado_d")
					'response.write("<br>" & .source)
					.Open
				end with
				if not estado_pir.eof then
					descripcion_estado=estado_pir("descripcion")				
				end if
				estado_pir.close
				set estado_pir=Nothing

				
				set tipo_maleta_pir=Server.CreateObject("ADODB.Recordset")
				with tipo_maleta_pir
					.ActiveConnection=connmaletas
					.Source="SELECT DESCRIPCION"
					.Source= .Source & " FROM TIPOS_MALETA"
					'para pirs enviados, entregados y cerrados, la maleta entregada para el resto la asignada por daniel y joaquin
					if request.form("cmbestado_d")=5 or request.form("cmbestado_d")=6 or request.form("cmbestado_d")=7 then
						.Source= .Source & " WHERE ID=" & request.form("cmbtipo_maleta_entregada_d")
					  else
					  	.Source= .Source & " WHERE CODIGO='" & request.form("cmbtipo_maleta_d") & "'"
					end if
					'response.write("<br>" & .source)
					.Open
				end with
				if not tipo_maleta_pir.eof then
					descripcion_tipo_maleta=tipo_maleta_pir("descripcion")				
				  else
				  	if descripcion_tipo_maleta="" then
						descripcion_tipo_maleta=request.form("txttipo_maleta_d")
					end if
				end if
				tipo_maleta_pir.close
				set tipo_maleta_pir=Nothing


				informacion_adicional=""
				'response.write("<br>estado seleccionado en el combo: " & request.form("cmbestado_d"))
				Select Case request.form("cmbestado_d")
					Case 1 'PENDIENTE DE AUTORIZACION
						informacion_adicional=""
				   	Case 2 'AUTORIZADO
						informacion_adicional=""			   		
					Case 3 'GESTION
						informacion_adicional=descripcion_tipo_maleta			   		
					Case 4 'GESTION PENDIENTE DOC
						informacion_adicional=descripcion_tipo_maleta				   		
					Case 5 'ENVIADO
						informacion_adicional=descripcion_tipo_maleta				   		
					Case 6 'ENTREGADO
						informacion_adicional=descripcion_tipo_maleta			   		
					Case 7 'CERRADO
						informacion_adicional=descripcion_tipo_maleta			   		
					Case 8 'GESTION CIA
						informacion_adicional=request.form("txtgestion_cia")			   		
					Case 9 'INCIDENCIA
						descripcion_incidencia=""
						if request.form("cmbtipos_incidencia_d")="OTRAS INCIDENCIAS" then
							descripcion_incidencia="OTRAS: " & request.form("txtotrasincidencias")
						  else
							descripcion_incidencia=request.form("cmbtipos_incidencia_d")
						end if
						informacion_adicional=descripcion_incidencia			   		
				End Select
				'response.write("<br>informacion_adicional: " & informacion_adicional)
				
				
				
				'al venir con caseid significa que es un pir de los nuevos, de PEGA no de INDIANA
				plataforma=""
				if case_id_seleccionado<>"" then
		
					access_token=""
					plataforma = "PEGA"
					Set xmlHttpLogin = Server.CreateObject("MSXML2.ServerXMLHTTP")
					'**********************************
					
					'DOCUMENTACION
					'https://apidocs.aireuropa.com//suma/suma-baggage-rest/v1.0_DRAFT.html

					'DATOS ENTORNO DESARROLLO
					'xmlHttpLogin.Open "POST", "https://desio.aireuropa.com/suma-baggage-rest/v1/oauth2/token", False
					'xmlHttpLogin.setRequestHeader "Authorization", "Basic YXJ0ZXMtZ3JhZmljYXM6WXlPRGswSWl3aWJtSm1Jam94TmpJM09UazJNakUyTENKelk="
					
					'Response.CharSet = "utf-8"
					if Request.ServerVariables("SERVER_NAME")<>"www.gestionmaletasglobalia.com" then
						'DATOS ENTORNO PREPRODUCCION
						xmlHttpLogin.Open "POST", "https://preio.aireuropa.com/suma-baggage-rest/v1/oauth2/token", False
						xmlHttpLogin.setRequestHeader "Authorization", "Basic YXJ0ZXMtZ3JhZmljYXM6WXlPRGswSWl3aWJtSm1JOHlFX1c1am94TmpJM09UazJNakUyTENKelk="
						
						'PRODUCCION
						'DATOS ENTORNO PRODUCCION***************
						'xmlHttpLogin.Open "POST", "https://io.aireuropa.com/suma-baggage-rest/v1/oauth2/token", False
						'xmlHttpLogin.setRequestHeader "Authorization", "Basic YXJ0ZXMtZ3JhZmljYXM6VG1Dc05mOGFsUmZZU192Y010TC1RTENza3Q4SHp6bHpnZWlxbEh6dDd2RkxUUkFnRlVuUg=="

					  else
						'PRODUCCION
						'DATOS ENTORNO PRODUCCION***************
						xmlHttpLogin.Open "POST", "https://io.aireuropa.com/suma-baggage-rest/v1/oauth2/token", False
						xmlHttpLogin.setRequestHeader "Authorization", "Basic YXJ0ZXMtZ3JhZmljYXM6VG1Dc05mOGFsUmZZU192Y010TC1RTENza3Q4SHp6bHpnZWlxbEh6dDd2RkxUUkFnRlVuUg=="
					
						'DATOS ENTORNO PREPRODUCCION
						'xmlHttpLogin.Open "POST", "https://preio.aireuropa.com/suma-baggage-rest/v1/oauth2/token", False
						'xmlHttpLogin.setRequestHeader "Authorization", "Basic YXJ0ZXMtZ3JhZmljYXM6WXlPRGswSWl3aWJtSm1JOHlFX1c1am94TmpJM09UazJNakUyTENKelk="
					end if
					
					'RESPONSE.WRITE("<br>antes del xmlhttplogin.send")
					xmlHttpLogin.send
					'RESPONSE.WRITE("<br>despues del xmlhttplogin.send")
					'RESPONSE.WRITE("<br>xmlhttplogin.status: " & xmlHttpLogin.Status )
					
					If xmlHttpLogin.Status = 200 Then
						responseJson = xmlHttpLogin.responseText
						'RESPONSE.WRITE("<br>contenido: " & responseJson )
						
						dim Info : set Info = JSON.parse(xmlHttpLogin.ResponseText)
							'{"codigo_cliente":"6214","codigo_pedido":"47917","numero_plantillas":-1,
							'	"plantillas":[{"nombre_grupo":"grupomm","expediente":"expmm","total_venta_expediente":"77,65","total_coste_expediente":"77,665","beneficio":"0,225"}]} 
							'{"firstname": "Fabio","lastname": "Nagao","alive": true,"age": 27,"nickname": "nagaozen",
							'		"fruits": ["banana","orange","apple","papaya","pineapple"],
							'       "complex": {"real": 1,"imaginary": 2}}		
						'por si devuelve un error o el access_token comprobamos la existencia de ese dato antes de intentar recuperarlo
						if CheckProperty(Info, "access_token") Then
							'Response.write("<br>acces token: " & Info.access_token)
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
							control_respuesta_indiana_pega = "ERROR"
							texto_respuesta_indiana_pega = descripcion_error
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
						control_respuesta_indiana_pega = "ERROR"
						texto_respuesta_indiana_pega = descripcion_error
					End If 'status 200
					
					
					if access_token <> "" then
						'response.write("<br>tenemos token: " & access_token)
						
						'recogemos el caseid y el tag a modificar junto con el estado y la informacion adicional
						'el tag y el caseid se obtienen mas arriba para ver si hay que llamar a indiana o a pega
						'case_id_seleccionado=campo_caseid
						'tag_seleccionado = campo_tag
						informacion_adicional_seleccionada= informacion_adicional
						estado_seleccionado=descripcion_estado
						
						'el estado se manda en ingles, tienen una enumeracion con descripciones en ingles
						'si se pasa en castellano da error		
						'ahora han aplicado otro cambio, no se manda la descripcion, se manda un codigo de estado			
						estado_suma = ""
						Select Case estado_seleccionado
							Case "PTE. AUTORIZACIÓN"
								estado_suma = "sdstatus01"
							Case "AUTORIZADO"
								estado_suma = "sdstatus02"
							Case "GESTIÓN"
								estado_suma = "sdstatus03"
							Case "GESTIÓN - PTE. DOCUMENTACIÓN"
								estado_suma = "sdstatus04"
							Case "ENVIADO"
								estado_suma = "sdstatus05"
							Case "ENTREGADO"
								estado_suma = "sdstatus06"
							Case "CERRADO"
								estado_suma = "sdstatus07"
							Case "GESTIÓN CIA"
								estado_suma = "sdstatus08"
							Case "INCIDENCIA"
								estado_suma = "sdstatus09"
							Case Else
								estado_suma = estado_seleccionado
						End Select
						
						body_seleccionado = "{""info"": """ & informacion_adicional_seleccionada & """ , ""status"": """ & estado_suma & """}"
						
						'DESARROLLO
						'sitio_web= "https://desio.aireuropa.com/suma-baggage-rest/v1/dpr/cases/" & case_id & "/" & tag
						
						if Request.ServerVariables("SERVER_NAME")<>"www.gestionmaletasglobalia.com" then
							'PREPRODUCCION
							sitio_web= "https://preio.aireuropa.com/suma-baggage-rest/v1/dpr/cases/" & case_id_seleccionado & "/" & tag_seleccionado
							
							'PRODUCCION************
							'sitio_web = "https://io.aireuropa.com/suma-baggage-rest/v1/dpr/cases/" & case_id_seleccionado & "/" & tag_seleccionado
						
						
						  else
							'PRODUCCION************
							sitio_web = "https://io.aireuropa.com/suma-baggage-rest/v1/dpr/cases/" & case_id_seleccionado & "/" & tag_seleccionado
						
							'PREPRODUCCION
							'sitio_web = "https://preio.aireuropa.com/suma-baggage-rest/v1/dpr/cases/" & case_id_seleccionado & "/" & tag_seleccionado
						end if
							
						
						
						xmlHttpLogin.Open "PUT", sitio_web, False
						xmlHttpLogin.setRequestHeader "Authorization", "Bearer " & access_token
						xmlHttpLogin.setRequestHeader "Content-Type", "application/json"
						
						'response.write("<br><br>url de llamada con el PUT: " & sitio_web)
						'response.write("<br><br>esto se envia en el body: " & body_seleccionado)
						xmlHttpLogin.Send body_seleccionado
						
						'response.write("<br><br>xmlHttpLogin.Status: " & xmlHttpLogin.Status)
						
						If xmlHttpLogin.Status = 200 Then
							'response.write("<br><br>xmlHttpLogin.responsetext: " & xmlHttpLogin.responseText)
							txt = xmlHttpLogin.responseText
							'response.write("<br><br><b>RESULTADO MODIFICACION: " & txt)
							
							dim Info_Indiana : set Info_Indiana = JSON.parse(xmlHttpLogin.ResponseText)
							if CheckProperty(Info_Indiana, "pyStatusMessage") Then
								codigo_respuesta=""
								if CheckProperty(Info_Indiana, "pyHTTPResponseCode") Then
									codigo_respuesta = "Codigo: " & Info_Indiana.pyHTTPResponseCode
								end if
								txt= "Mensaje: " & Info_Indiana.pyStatusMessage

								if ucase(Info_Indiana.pyStatusMessage)<>"OK" then
									'response.write("<br><br>HAY UN ERROR EN EL json DEVUELTO - 1")
									control_respuesta_indiana_pega = "ERROR"
									texto_respuesta_indiana_pega = codigo_respuesta & "\n" & txt
								end if
					  
								
							  else
								txt = "" & xmlHttpLogin.responseText
								'response.write("<br><br>HAY UN ERROR EN EL json DEVUELTO - 2")
								control_respuesta_indiana_pega = "ERROR"
								texto_respuesta_indiana_pega = txt
							end if
						
						  else 'no es un status 200
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
						end if
						
						
						resultado_indiana=txt
						'response.write("<br><br>Resultado Indiana: " & resultado_indiana)
						

						 
					end if ' IF DEL access_token
				
				else 'DEL CASEID<>""... aqui es la llamada a INDIANA para informar del estado

					'si no viene la fecha del fichero de importacion, y no tiene CASEID, eso es porque es un PIR creado
					'no importado, y por eso no se informa a indiana del cambio de estado
					if campo_fecha_fichero_importacion<>"" then
					
						'response.write("<br><br>INFORMAMOS DEL CAMBIO DE ESTADO A INDIANA")
						plataforma = "INDIANA"
						''''''''''''''''''''''''''''''''''''''''''''''''''
						'LAS URLS DE INDIANA SON LAS SIGUIENTES
						'Preproduccion..... http://pre.mylostbag.aireuropa.com/weblf/rest/dpr/order/status
						'Produccion........ https://mylostbag.aireuropa.com/weblf/rest/dpr/order/status
										
						if Request.ServerVariables("SERVER_NAME")<>"www.gestionmaletasglobalia.com" then
							'PREPRODUCCION
							url_indiana="http://pre.mylostbag.aireuropa.com/weblf/rest/dpr/order/status"
							'PRODUCCION*********OJO QUITAR
							'url_indiana="https://mylostbag.aireuropa.com/weblf/rest/dpr/order/status"
						  else
							'PRODUCCION
							url_indiana="https://mylostbag.aireuropa.com/weblf/rest/dpr/order/status"
						end if
						
						
						parametros = "key=C59ABE15811E20AA1EC304E6CDE9945B" & _
										"&codexp=" & campo_expediente & _
										"&tag=" & campo_tag & _
										"&time=" & fecha_accion & _
										"&status=" & URLEncode_utf8(descripcion_estado) & _
										"&info=" & URLEncode_utf8(informacion_adicional)
	
						set xmlhttp = server.Createobject("MSXML2.ServerXMLHTTP")
					
						'Response.Write("<br>paramtros y url de llamada: " & url_indiana & "<br>" & parametros)
						
						'url_final=url_indiana & "?" & Server.URLEncode(parametros)
						url_final=url_indiana & "?" & parametros
						'response.write("<bR>url_final: " & url_final)
						xmlhttp.Open "POST", url_final, false
						xmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
						
						'Response.ContentType = "text/xml"
						xmlhttp.send() 'Server.URLEncode(parametros)
						
						'Response.Write("<br>responsetext: " & xmlhttp.responseText)
						'Response.Write("<br>responsexml: " & xmlhttp.responseXML)
						'Response.Write("<br>responseXML.xml: " & xmlhttp.responseXML.xml)
						'Response.Write("<br>responsebody: " & xmlhttp.responseBody)
						'Response.Write("<br>responseStream: " & xmlhttp.responseStream)
						
						
						
						'Dim oXML, oXMLError, ReturnValue, x
						Set oXML = Server.CreateObject("MSXML2.DOMDocument")
						oXML.async = False
						'Response.write "<br>xmlhttp.responseText =" & xmlhttp.responseText & "<br>"
						ReturnValue = oXML.LoadXML(xmlhttp.responseText)
						'Response.write "<br>Result of load method is =" & ReturnValue & "<br>"
						If ReturnValue = False Then
							Set oXMLError = oXML.ParseError
							'Response.Write "<br>---&#xa0;&#xa0;" & oXMLError.ErrorCode & " - " & oXMLError.Reason & "  URL=" & oXMLError.URL & "<br>"
							control_respuesta_indiana_pega = "ERROR"
							texto_respuesta_indiana_pega = "<br>---&#xa0;&#xa0;" & oXMLError.ErrorCode & " - " & oXMLError.Reason & "  URL=" & oXMLError.URL & "<br>"
							Set oXMLError = Nothing
						End If
						'Response.CharSet = "iso-8859-1"
						'Response.Write("<br>Razon del error: " & oxml.parseError.reason)
						
						resultado_indiana=""
						For x = 0 to oxml.childNodes.length - 1
							'Response.Write "<br>Node " & x & ".  "
							'Response.write(" ...nodename: " & oxml.SelectSingleNode("/").firstChild.NodeName)
							'Response.write(" ...tipo: " & oxml.childNodes(x).nodeType)
							'es el tipo de nodo con contenido... no es la cabeceera
							if oxml.childNodes(x).nodeType=1 then
								'Response.write(" ...nodename: " & oxml.childNodes(x).nodeName)
								'Response.write(" ...contenido: " & oxml.childNodes(x).text)
								resultado_indiana= oxml.childNodes(x).nodeName
								if oxml.childNodes(x).nodeName="error" then
									'Response.write(" ...atributo cod: " & oxml.childNodes(x).GetAttribute("cod"))
									resultado_indiana=resultado_indiana & "(" & oxml.childNodes(x).GetAttribute("cod") & ") - " & oxml.childNodes(x).text
								end if
							end if
						Next 
						'response.write("<br><br>Resultado Indiana: " & resultado_indiana)
						if ucase(resultado_indiana)<>"OK" then
							'response.write("<br><br>HAY UN ERROR EN EL XML DEVUELTO")
							control_respuesta_indiana_pega = "ERROR"
							texto_respuesta_indiana_pega = resultado_indiana
							
						  else
							'response.write("<br><br>RESPUESTA HA SIDO OK")
						end if
					
					  else
					  	'COMO NO TENEMOS QUE INFORMAR A INDIANA, lo interpretamos como OK
					  	control_respuesta_indiana_pega = "OK"
					end if 'del campo_fecha_fichero_importacion<>""
				
				end if 'del case_id_seleccionado<>""
				
				'response.write("<br><br>Resultado Indiana: " & resultado_indiana)
				
				'FINAL DEL PASO DE INFORMACION DEL CAMBIO DE ESTADO A INDIANA
				'   Y LA RESPUESTA DE INDIANA LA GUARDAREMOS EN EL HISTORICO
				'---------------------------------------------------------------
				'*******************************************************************************************
				
				if control_respuesta_indiana_pega = "ERROR" then
					response.write("<br><br>SE HA PRODUCIDO EL SIGUIENTE ERROR AL INFORMAR A INDIANA/PEGA:")
					response.write("<br><br>" & texto_respuesta_indiana_pega)
					response.write("<br><br>Es posible que este Expediente lo Tenga Abierto el Callcenter. Inténtelo de nuevo más tarde.")
				end if
				
				'si se ha podido recibir una contestacion de indiana (no es un pir creado sino importado)
				if campo_fecha_fichero_importacion<>"" then
					'guardamos el resultado de indiana en el historico del pir	
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " CAST('" & fecha_accion & "' as datetime), '" & plataforma & "', NULL,"
					cadena_historico=cadena_historico & "'" & codigo_respuesta & "', '" & resultado_indiana & "', '" & session("usuario") & "', 'Respuesta de " & plataforma & " al Cambio', NULL)"
						
					'response.write("<br>cadena_historico: " & cadena_historico)
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if				
				
				
				
			end if ' del control del combo estado donde se ve si se ha de mandar a Indiana o Pega un aviso
			
			''''''''''''''''''''''''''''''''''''''''''
			'si el aviso a indiana o pega ha sido OK, se guardan todos los dastos en el historico y se modifica el pir
			'y si es un estado de incidencia, tambien la incidencia
			if control_respuesta_indiana_pega = "OK" then
			
				if campo_estado<>request.form("cmbestado_d") then		
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'CAMBIO', 'ESTADO', '" & campo_estado & "',"
					cadena_historico=cadena_historico & " '" & request.form("cmbestado_d") & "', '" & session("usuario") & "',"
					if request.form("cmbestado_d")="8" then
						cadena_historico=cadena_historico & " '" & request.form("txtgestion_cia") & "', NULL)"
					  else
						cadena_historico=cadena_historico & " NULL, NULL)"
					end if
					
					 
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					if cadena_pir<>"" then
						cadena_pir=cadena_pir & ", "
					end if
					cadena_pir = cadena_pir & "ESTADO='" & request.form("cmbestado_d") &"'"
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
	
			
					
					'response.write("<br>estado: " & request.form("cmbestado_d"))
					
					'SI ESTAMOS AUTORIZANDO EL PIR, TAMBIEN LE PONGO LA FECHA DE INICIO
					'if request.form("cmbestado_d")="2" then 'AUTORIZADO
					'	cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					'	cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					'	cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					'	cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA INICIO', '" & campo_fecha_inicio & "', GETDATE(),"
					'	cadena_historico=cadena_historico & " '" & session("usuario") & "', NULL, NULL)"
					
					'	if cadena_pir<>"" then
					'		cadena_pir=cadena_pir & ", "
					'	end if
					'	cadena_pir = cadena_pir & "FECHA_INICIO=GETDATE()"
						
						'response.write("<br>cadena_historico: " & cadena_historico)
						
					'	connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
					'end if
					
					
					'SI ESTAMOS ENVIANDO LA MALETA DEL PIR, TAMBIEN LE PONGO LA FECHA DE ENVIO
					if request.form("cmbestado_d")="5" then 'ENVIADO
						cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
						cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
						cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
						cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA ENVIO', '" & campo_fecha_envio & "',"
						cadena_historico=cadena_historico & " '" & request.form("txtfecha_envio_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
						
						'response.write("<br>cadena pir antes poner fecha envio: " & cadena_pir)
						'si no se ha puesto aun el valor de FECHA_ENVIO, lo añadimos al la cadena del UPDATE
						if instr(cadena_pir, "FECHA_ENVIO='")=0 then
							if cadena_pir<>"" then
								cadena_pir=cadena_pir & ", "
							end if
							cadena_pir = cadena_pir & "FECHA_ENVIO='" & cdate(request.form("txtfecha_envio_d")) & "'"
						end if
						
						'response.write("<br>cadena_historico: " & cadena_historico)
						
						connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
					end if
				
					'SI ESTAMOS ENTREGANDO LA MALETA DEL PIR, TAMBIEN LE PONGO LA FECHA ENTREGA AL PAX
					if request.form("cmbestado_d")="6" then 'ENTREGADO
						cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
						cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
						cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
						cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA ENTREGA PAX', '" & campo_fecha_entrega_pax & "',"
						cadena_historico=cadena_historico & " '" & request.form("txtfecha_entrega_pax_d") & "', '" & session("usuario") & "', NULL, NULL)"
					
					
						if cadena_pir<>"" then
							cadena_pir=cadena_pir & ", "
						end if
						cadena_pir = cadena_pir & "FECHA_ENTREGA_PAX='" & cdate(request.form("txtfecha_entrega_pax_d")) & "'"
						
						'response.write("<br>cadena_historico: " & cadena_historico)
						
						connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
					end if
					
				end if 'fin de campo estado<>combo
				
				
				'GRABAMOS EL TIPO DE INCIDENCIA SI SE HA SELECCIONADO EL ESTADO INCIDENCIA
				if request.form("cmbtipos_incidencia_d")<>"" and  request.form("cmbestado_d")="9" then	'INCIDENCIA	
					descripcion_incidencia=""
					if request.form("cmbtipos_incidencia_d")="OTRAS INCIDENCIAS" then
						descripcion_incidencia="OTRAS: " & request.form("txtotrasincidencias")
					  else
						descripcion_incidencia=request.form("cmbtipos_incidencia_d")
					end if
					cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
					cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
					cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
					cadena_historico=cadena_historico & " GETDATE(), 'INCIDENCIA', NULL, NULL, NULL,"
					cadena_historico=cadena_historico & " '" & session("usuario") & "', '" & descripcion_incidencia & "', NULL)"
					
					'response.write("<br>cadena_historico: " & cadena_historico)
		
					
					connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
				end if ' historico incidencia
			
			end if
			'FIN... si el aviso a indiana o pega ha sido OK, se guardan todos los dastos en el historico y se modifica el pir
			'''''''''''''''''''''''''''
			
			
			
			'ahora ya se hace un update del pir, cambiando todas las cosas que son distintas a lo almacenado
			if cadena_pir<>"" then
				cadena_ejecucion="UPDATE PIRS SET " & cadena_pir & " WHERE ID= " & id_seleccionado
				'response.write("<br>cadena_pir: " & cadena_ejecucion)
				connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			end if
			
			
			
			
			connmaletas.CommitTrans ' finaliza la transaccion
			
			
			if control_respuesta_indiana_pega = "ERROR" then
				mensaje_aviso = "SE HA PRODUCIDO EL SIGUIENTE ERROR AL INFORMAR A INDIANA/PEGA:"
				mensaje_aviso = mensaje_aviso & "\n\n" & texto_respuesta_indiana_pega
				mensaje_aviso = mensaje_aviso & "\n\nEs posible que este Expediente lo Tenga Abierto el Callcenter. Inténtelo de nuevo más tarde."
			  else
			  	mensaje_aviso="PIR MODIFICADO CON EXITO"
			end if
			
		ELSE '**************************LA PARTE DE LAS ALTAS DE PIR
	
			cadena_campos = "FECHA_ORDEN, EXPEDIENTE, PIR, FECHA_PIR, TAG"
			if request.form("txtfecha_orden_d")<>"" then
				cadena_valores="'" & cdate(request.form("txtfecha_orden_d")) & "'"
			  else
			 	cadena_valores="NULL"
			end if
			cadena_valores=cadena_valores & ", NULL"
			cadena_valores=cadena_valores & ", '" & TRIM(request.form("txtpir_d")) & "'"
			if request.form("txtfecha_pir_d")<>"" then
				cadena_valores=cadena_valores & ", '" & cdate(request.form("txtfecha_pir_d")) & "'"
			  else
				cadena_valores=cadena_valores & ", NULL"
			end if
			cadena_valores=cadena_valores & ", '" & request.form("txttag_d") & "'"
			
			
			cadena_campos = cadena_campos & ", NOMBRE, APELLIDOS, MOVIL, FIJO"
			cadena_valores=cadena_valores & ", '" & request.form("txtnombre_d") & "'" 
			cadena_valores=cadena_valores & ", '" & request.form("txtapellidos_d") & "'" 
			cadena_valores=cadena_valores & ", '" & request.form("txtmovil_d") & "'" 
			cadena_valores=cadena_valores & ", '" & request.form("txtfijo_d") & "'" 
			
			
			cadena_campos = cadena_campos & ", DIRECCION_ENTREGA, CP_ENTREGA, EMAIL, TIPO_DIRECCION_ENTREGA, DESDE_HASTA, FECHA_DESDE_HASTA"
			cadena_valores=cadena_valores & ", '" & request.form("txtdireccion_entrega_d") & "'" 
			cadena_valores=cadena_valores & ", '" & request.form("txtcp_entrega_d") & "'" 
			cadena_valores=cadena_valores & ", '" & request.form("txtemail_d") & "'" 
			cadena_valores=cadena_valores & ", '" & request.form("cmbtipo_direccion_entrega_d") & "'" 
			cadena_valores=cadena_valores & ", '" & request.form("cmbdesde_hasta_d") & "'" 
			IF request.form("txtfecha_desde_hasta_d")<>"" THEN
				cadena_valores=cadena_valores & ", '" & cdate(request.form("txtfecha_desde_hasta_d")) & "'" 
			  else
			  	cadena_valores=cadena_valores & ", NULL" 
			end if
			
			
			cadena_campos = cadena_campos & ", TIPO_EQUIPAJE_BAG_ORIGINAL, MARCA_BAG_ORIGINAL, MARCAWT, MATERIAL_BAG_ORIGINAL"
			cadena_valores=cadena_valores & ", '" & request.form("txttipo_equipaje_bag_original_d") & "'" 
			cadena_valores=cadena_valores & ", '" & request.form("txtmarca_bag_original_d") & "'"
			cadena_valores=cadena_valores & ", '" & request.form("txtmarcawt_d") & "'"
			cadena_valores=cadena_valores & ", '" & request.form("txtmaterial_bag_original_d") & "'"
			

			cadena_campos = cadena_campos & ", COLOR_BAG_ORIGINAL, LARGO_BAG_ORIGINAL, ALTO_BAG_ORIGINAL, ANCHO_BAG_ORIGINAL"
			cadena_valores=cadena_valores & ", '" & request.form("txtcolor_bag_original_d") & "'"
			cadena_valores=cadena_valores & ", '" & request.form("txtlargo_bag_original_d") & "'"
			cadena_valores=cadena_valores & ", '" & request.form("txtalto_bag_original_d") & "'"
			cadena_valores=cadena_valores & ", '" & request.form("txtancho_bag_original_d") & "'"
			
			
			cadena_campos = cadena_campos & ", DANNO_RUEDAS_BAG_ORIGINAL, DANNO_ASAS_BAG_ORIGINAL"
			cadena_campos = cadena_campos & ", DANNO_CIERRES_BAG_ORIGINAL, DANNO_CREMALLERA_BAG_ORIGINAL"
			cadena_campos = cadena_campos & ", DANNO_CUERPO_MALETA_BAG_ORIGINAL"
			cadena_campos = cadena_campos & ", DANNO_OTROS_BAG_ORIGINAL"
			cadena_valores=cadena_valores & ", '" & actual_danno_ruedas & "'"
			cadena_valores=cadena_valores & ", '" & actual_danno_asas & "'"
			cadena_valores=cadena_valores & ", '" & actual_danno_cierres & "'"
			cadena_valores=cadena_valores & ", '" & actual_danno_cremalleras & "'"
			cadena_valores=cadena_valores & ", '" & actual_danno_cuerpo_maleta & "'"
			cadena_valores=cadena_valores & ", '" & actual_danno_otros_dannos & "'"
			
			
			cadena_campos = cadena_campos & ", RUTA, VUELOS, TIPO_BAG_ORIGINAL, FECHA_INICIO, FECHA_ENVIO, FECHA_ENTREGA_PAX"
			cadena_valores=cadena_valores & ", '" & request.form("txtruta_d") & "'"
			cadena_valores=cadena_valores & ", '" & request.form("txtvuelos_d") & "'"
			cadena_valores=cadena_valores & ", '" & request.form("cmbtipo_maleta_d") &"'"
			if request.form("cmbestado_d")="2" then 'AUTORIZADO
				'cadena_valores=cadena_valores & ", GETDATE()"
				cadena_valores=cadena_valores & ", '" & cdate(request.form("txtfecha_inicio_d")) & "'"
			  else
			  	cadena_valores=cadena_valores & ", NULL"
			end if
			if request.form("cmbestado_d")="5" then 'ENVIADO
				'cadena_valores=cadena_valores & ", GETDATE()"
				cadena_valores=cadena_valores & ", '" & cdate(request.form("txtfecha_envio_d")) & "'"
			  else
			  	cadena_valores=cadena_valores & ", NULL"
			end if
			if request.form("cmbestado_d")="6" then 'ENTREGADO
				'cadena_valores=cadena_valores & ", GETDATE()"
				cadena_valores=cadena_valores & ", '" & cdate(request.form("txtfecha_entrega_pax_d")) & "'"
			  else
			  	cadena_valores=cadena_valores & ", NULL"
			end if
			
			
			cadena_campos = cadena_campos & ", TIPO_BAG_ENTREGADA, TAMANNO_BAG_ENTREGADA, REFERENCIA_BAG_ENTREGADA, COLOR_BAG_ENTREGADA"
			cadena_valores=cadena_valores & ", '" & request.form("cmbtipo_maleta_entregada_d") & "'"
			cadena_valores=cadena_valores & ", '" & request.form("cmbtamanno_maleta_entregada_d") & "'"
			cadena_valores=cadena_valores & ", '" & request.form("txtreferencia_maleta_entregada_d") & "'"
			cadena_valores=cadena_valores & ", '" & request.form("txtcolor_maleta_entregada_d") & "'"
			
			
			cadena_campos = cadena_campos & ", NUM_EXPEDICION, ESTADO"
			cadena_valores=cadena_valores & ", '" & request.form("txtnumero_expedicion_d")  & "'"
			cadena_valores=cadena_valores & ", '" & request.form("cmbestado_d") & "'"
			
			
			cadena_campos = cadena_campos & ", IMPORTE_FACTURACION, FECHA_FACTURACION"
			if request.form("txtimporte_facturacion_d")<>"" then
				cadena_valores=cadena_valores & ", " & replace(request.form("txtimporte_facturacion_d"), ",", ".")
			  else
			  	cadena_valores=cadena_valores & ", NULL"
			end if
			IF request.form("txtfecha_facturacion_d")<>"" THEN
				cadena_valores=cadena_valores & ", '" & cdate(request.form("txtfecha_facturacion_d")) & "'"
			  else
			  	cadena_valores=cadena_valores & ", NULL"
			end if
			
			
			cadena_campos = cadena_campos & ", COSTES, PROVEEDOR"
			if request.form("txtcostes_d")<>"" then
				cadena_valores=cadena_valores & ", " & REPLACE(request.form("txtcostes_d"), ",", ".")
			  else
			  	cadena_valores=cadena_valores & ", NULL"
			end if
			IF request.form("cmbproveedores_d")<>"" THEN
				cadena_valores=cadena_valores & ", " & request.form("cmbproveedores_d")
			  ELSE
				cadena_valores=cadena_valores & ", NULL"
			END IF	
			
			
			cadena_ejecucion="INSERT INTO PIRS (" & cadena_campos & ") VALUES (" & cadena_valores & ")"
			
			'response.write("<br>cadena_pir altas: " & cadena_ejecucion)

			'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
			' de fecha con mes-dia-año
			connmaletas.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
						
			connmaletas.BeginTrans
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

			Set valor_nuevo = connmaletas.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
			id_pir_nuevo=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
			valor_nuevo.Close
			Set valor_nuevo = Nothing
			
			
			'GRABAMOS EN EL HISTORICO EL ALTA DEL PIR
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_pir_nuevo & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'ALTA PIR', NULL, NULL, NULL,"
			cadena_historico=cadena_historico & " '" & session("usuario") & "', NULL, NULL)"
			
			'response.write("<br>cadena_historico: " & cadena_historico)

			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords


			'GRABAMOS EL TIPO DE INCIDENCIA SI SE HA SELECCIONADO EL ESTADO INCIDENCIA
			'response.WRITE("<BR>VEMOS EL ESTADO: " & request.form("cmbestado_d"))
			'response.WRITE("<BR>VEMOS EL TIPO DE INCIDENCIA: " & request.form("cmbtipos_incidencia_d"))
			if request.form("cmbtipos_incidencia_d")<>"" and  request.form("cmbestado_d")="9" then 'INCIDENCIA		
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_pir_nuevo & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'INCIDENCIA', NULL, NULL, NULL,"
				cadena_historico=cadena_historico & " '" & session("usuario") & "', '" & request.form("cmbtipos_incidencia_d") & "', NULL)"
				
				'response.write("<br>INCIDENCIA: cadena_historico: " & cadena_historico)
	
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if

			connmaletas.CommitTrans ' finaliza la transaccion
			mensaje_aviso="PIR GUARDADO CON EXITO"

	end if
		
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pir</TITLE>

	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />

</HEAD>
<script language="javascript">
function validar(mensaje, id_pir, error_ok)
{
	alert(mensaje);
	
	/*
	j$("#cabecera_pantalla_avisos").html("<h3>Aviso</h3>")
	j$("#body_avisos").html('<H4><br>' + mensaje + '<br></h4>');
	j$("#pantalla_avisos").modal("show");
	*/
	if (error_ok == 'OK')
		{
		if (id_pir=='')
			{
			j$("#frmgrabar_pir").prop("action", "Altas_Pir.asp");
			j$("#frmgrabar_pir").prop("target", "_top");
			j$('#frmgrabar_pir').submit()	
			}
		  else
			{
			//refresco la tabla de pirs de la pagina principal por si hay modificaciones
			window.parent.lst_pirs.ajax.reload(); 
			j$("#frmgrabar_pir").prop("action", "Detalle_Pir.asp?id=" + id_pir);
			j$("#frmgrabar_pir").prop("target", "_self");
			window.parent.j$("#capa_detalle_pir").modal("hide");
			}
		}
	  else
	  	{
		//refresco la tabla de pirs de la pagina principal por si hay modificaciones
		window.parent.lst_pirs.ajax.reload(); 
		j$("#frmgrabar_pir").prop("action", "Detalle_Pir.asp?id=" + id_pir);
		j$("#frmgrabar_pir").prop("target", "_self");
		window.parent.j$("#capa_detalle_pir").modal("hide");
		}
	
		
	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

   
<BODY onload="validar('<%=mensaje_aviso%>','<%=id_seleccionado%>', '<%=control_respuesta_indiana_pega%>')">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>
<form name="frmgrabar_pir" id="frmgrabar_pir" method="post" action="">
</form>

 <!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->


<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script language="javascript">
var j$=jQuery.noConflict();
</script>
</BODY>
   <%	
   		'regis.close			
		connmaletas.Close
		set connmaletas=Nothing
	%>
   </HTML>
