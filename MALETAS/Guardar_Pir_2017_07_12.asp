<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->


<%
		if session("usuario")="" then
			response.Redirect("Login.asp")
		end if
		
		id_seleccionado= Request.Form("ocultoid_pir")
		estado=Request.Form("cmbestado_p")
		
		response.write("<br>id: " & id)
		response.write("<br>estado: " & estado)
		
		
		set detalle_pir=Server.CreateObject("ADODB.Recordset")
		with detalle_pir
			.ActiveConnection=connmaletas
			.Source="SELECT ID, FECHA_ORDEN, ORDEN, AGENTE, EXPEDIENTE, PIR, FECHA_PIR, TAG, NOMBRE, APELLIDOS, DNI, MOVIL, FIJO"
			.Source= .Source & ", DIRECCION_ENTREGA, CP_ENTREGA, TIPO_DIRECCION_ENTREGA, DESDE_HASTA, FECHA_DESDE_HASTA, OBSERVACIONES"
			.Source= .Source & ", TIPO_EQUIPAJE_BAG_ORIGINAL, MARCA_BAG_ORIGINAL, MODELO_BAG_ORIGINAL, MATERIAL_BAG_ORIGINAL"
			.Source= .Source & ", COLOR_BAG_ORIGINAL, LARGO_BAG_ORIGINAL, ALTO_BAG_ORIGINAL, ANCHO_BAG_ORIGINAL, DANNO_RUEDAS_BAG_ORIGINAL"
			.Source= .Source & ", DANNO_ASAS_BAG_ORIGINAL, DANNO_CIERRES_BAG_ORIGINAL, DANNO_CREMALLERA_BAG_ORIGINAL"
			.Source= .Source & ", DANNO_CUERPO_MALETA_BAG_ORIGINAL, DANNO_CIERRES_MALETA_BAG_ORIGINAL, DANNO_OTROS_BAG_ORIGINAL"
			.Source= .Source & ", DANNO, EQUIPAJE, RUTA, VUELOS, TIPO_BAG_ORIGINAL, FECHA_INICIO, IMPORTE_FACTURACION"
			.Source= .Source & ", FECHA_FACTURACION, FECHA_ENVIO, FECHA_ENTREGA_PAX, PLAZO_ENTREGA_EN_DIAS, INCIDENCIA_TRANSPORTE"
			.Source= .Source & ", INCIDENCIA_MALETA, OTRAS_INCIDENCIAS, TIPO_BAG_ENTREGADA, TAMANNO_BAG_ENTREGADA"
			.Source= .Source & ", REFERENCIA_BAG_ENTREGADA, COLOR_BAG_ENTREGADA, NUM_EXPEDICION, COSTES, ESTADO"
	
			.Source= .Source & " FROM PIRS"
			.Source= .Source & " WHERE id=" & id_seleccionado
			'response.write("<br>" & .source)
			.Open
		end with

		
		
		campo_id=""
		campo_fecha_orden=""
		campo_orden=""
		campo_agente=""
		campo_expediente=""
		campo_pir=""
		campo_fecha_pir=""
		campo_tag=""
		campo_nombre=""
		campo_apellidos=""
		campo_dni=""
		campo_movil=""
		campo_fijo=""
		campo_direccion_entrega=""
		campo_cp_entrega=""
		campo_tipo_direccion_entrega=""
		campo_desde_hasta=""
		campo_fecha_desde_hasta=""
		campo_observaciones=""
		campo_tipo_equipaje_bag_original=""
		campo_marca_bag_original=""
		campo_modelo_bag_original=""
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
		campo_danno_cierres_maleta_bag_original=""
		campo_danno_otros_bag_original=""
		
		
		
		campo_danno=""
		campo_equipaje=""
		campo_ruta=""
		campo_vuelos=""
		campo_tipo_bag_original=""
		campo_fecha_inicio=""
		campo_importe_facturacion=""
		campo_fecha_envio=""
		campo_fecha_entrega_pax=""
		campo_plazo_entrega_en_dias=""
		campo_incidencia_transporte=""
		campo_incidencia_maleta=""
		campo_otras_incidencias=""
		campo_tipo_bag_entregada=""
		campo_tamanno_bag_entregada=""
		campo_referencia_bag_entregada=""
		campo_color_bag_entregada=""
		campo_numero_expedicion=""
		campo_coste=""
		campo_estado=""
		
		if not detalle_pir.eof then
			campo_id="" & detalle_pir("id")
			
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_orden")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_orden")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_orden")))
			campo_fecha_orden = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
			
			campo_orden="" & detalle_pir("orden")
			campo_agente="" & detalle_pir("agente")
			campo_expediente="" & detalle_pir("expediente")
			campo_pir="" & detalle_pir("pir")
			
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_pir")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_pir")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_pir")))
			campo_fecha_pir = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
			
			campo_tag="" & detalle_pir("tag")
			campo_nombre="" & detalle_pir("nombre")
			campo_apellidos="" & detalle_pir("apellidos")
			campo_dni="" & detalle_pir("dni")
			campo_movil="" & detalle_pir("movil")
			campo_fijo="" & detalle_pir("fijo")
			campo_direccion_entrega="" & detalle_pir("direccion_entrega")
			campo_cp_entrega="" & detalle_pir("cp_entrega")
			campo_tipo_direccion_entrega="" & detalle_pir("tipo_direccion_entrega")
			campo_desde_hasta="" & detalle_pir("desde_hasta")
			
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_desde_hasta")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_desde_hasta")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_desde_hasta")))
			campo_fecha_desde_hasta = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
	
			campo_observaciones="" & detalle_pir("observaciones")
			campo_tipo_equipaje_bag_original="" & detalle_pir("tipo_equipaje_bag_original")
			campo_marca_bag_original="" & detalle_pir("marca_bag_original")
			campo_modelo_bag_original="" & detalle_pir("modelo_bag_original")
			campo_material_bag_original="" & detalle_pir("material_bag_original")
			campo_color_bag_original="" & detalle_pir("color_bag_original")
			campo_largo_bag_original="" & detalle_pir("largo_bag_original")
			campo_alto_bag_original="" & detalle_pir("alto_bag_original")
			campo_ancho_bag_original="" & detalle_pir("ancho_bag_original")
			campo_danno_ruedas_bag_original="" & lcase(detalle_pir("danno_ruedas_bag_original"))
			campo_danno_asas_bag_original="" & lcase(detalle_pir("danno_asas_bag_original"))
			campo_danno_cierres_bag_original="" & lcase(detalle_pir("danno_cierres_bag_original"))
			campo_danno_cremallera_bag_original="" & lcase(detalle_pir("danno_cremallera_bag_original"))
			campo_danno_cuerpo_maleta_bag_original="" & lcase(detalle_pir("danno_cuerpo_maleta_bag_original"))
			campo_danno_cierres_maleta_bag_original="" & lcase(detalle_pir("danno_cierres_maleta_bag_original"))
			campo_danno_otros_bag_original="" & lcase(detalle_pir("danno_otros_bag_original"))
			
			
		
	
			
			
			campo_danno="" & detalle_pir("danno")
			campo_equipaje="" & detalle_pir("equipaje")
			campo_ruta="" & detalle_pir("ruta")
			campo_vuelos="" & detalle_pir("vuelos")
			campo_tipo_bag_original="" & detalle_pir("tipo_bag_original")
			
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_inicio")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_inicio")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_inicio")))
			campo_fecha_inicio = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
			
			campo_importe_facturacion="" & detalle_pir("importe_facturacion")
			
			if detalle_pir("fecha_facturacion")<>"" then
				dia = "0" & datepart("d", cdate(detalle_pir("fecha_facturacion")))
				mes = "0" & datepart("m", cdate(detalle_pir("fecha_facturacion")))
				anno = datepart("yyyy", cdate(detalle_pir("fecha_facturacion")))
				campo_fecha_facturacion = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
			end if
			
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_envio")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_envio")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_envio")))
			campo_fecha_envio = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
			
			dia = "0" & datepart("d", cdate(detalle_pir("fecha_entrega_pax")))
			mes = "0" & datepart("m", cdate(detalle_pir("fecha_entrega_pax")))
			anno = datepart("yyyy", cdate(detalle_pir("fecha_entrega_pax")))
			campo_fecha_entrega_pax = "" & anno & "-" & right(mes,2) & "-" & right(dia,2) 
			
			campo_plazo_entrega_en_dias="" & detalle_pir("plazo_entrega_en_dias")
			campo_incidencia_transporte="" & detalle_pir("incidencia_transporte")
			campo_incidencia_maleta="" & detalle_pir("incidencia_maleta")
			campo_otras_incidencias="" & detalle_pir("otras_incidencias")
			campo_tipo_bag_entregada="" & detalle_pir("tipo_bag_entregada")
			campo_tamanno_bag_entregada="" & detalle_pir("tamanno_bag_entregada")
			campo_referencia_bag_entregada="" & detalle_pir("referencia_bag_entregada")
			campo_color_bag_entregada="" & detalle_pir("color_bag_entregada")
			campo_numero_expedicion="" & detalle_pir("num_expedicion")
			campo_costes="" & detalle_pir("costes")
			campo_estado="" & detalle_pir("estado")
			
		end if
		
		detalle_pir.close
		set detalle_pir=Nothing
		
		
		
		if request.form("chkdanno_ruedas_d")="on" then
			actual_danno_ruedas="true"
		 else
		 	actual_danno_ruedas="false"
		end if
		if request.form("chkdanno_asas_d")="on" then
			actual_danno_asas="true"
		 else
		 	actual_danno_asas="false"
		end if
		if request.form("chkdanno_cierres_d")="on" then
			actual_danno_cierres="true"
		 else
		 	actual_danno_cierres="false"
		end if
		if request.form("chkdanno_cremalleras_d")="on" then
			actual_danno_cremalleras="true"
		 else
		 	actual_danno_cremalleras="false"
		end if
		if request.form("chkdanno_cuerpo_maleta_d")="on" then
			actual_danno_cuerpo_maleta="true"
		 else
		 	actual_danno_cuerpo_maleta="false"
		end if
		if request.form("chkdanno_cierres_maleta_d")="on" then
			actual_danno_cierres_maleta="true"
		 else
		 	actual_danno_cierres_maleta="false"
		end if
		if request.form("chkdanno_otros_dannos_d")="on" then
			actual_danno_otros_dannos="true"
		 else
		 	actual_danno_otros_dannos="false"
		end if
				
			
		
		
		cadena_pir=""
		
		connmaletas.BeginTrans 'Comenzamos la Transaccion

		if campo_fecha_pir<>request.form("txtfecha_pir_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA PIR', '" & campo_fecha_pir & "',"
			cadena_historico=cadena_historico & " '" & request.form("txtfecha_pir_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "FECHA_PIR='" & cdate(request.form("txtfecha_pir_d")) &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if

		if campo_fecha_orden<>request.form("txtfecha_orden_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA ORDEN', '" & campo_fecha_orden & "',"
			cadena_historico=cadena_historico & " '" & request.form("txtfecha_orden_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "FECHA_ORDEN='" & cdate(request.form("txtfecha_orden_d")) &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if

		if campo_tag<>request.form("txttag_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TAG', '" & campo_tag & "',"
			cadena_historico=cadena_historico & " '" & request.form("txttag_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "TAG='" & request.form("txtag_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if


		if campo_nombre<>request.form("txtnombre_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'NOMBRE', '" & campo_nombre & "',"
			cadena_historico=cadena_historico & " '" & request.form("txtnombre_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "FIJO='" & request.form("txtfijo_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_direccion_entrega<>request.form("txtdireccion_entrega_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DIRECCION', '" & campo_direccion_entrega & "',"
			cadena_historico=cadena_historico & " '" & request.form("txtdireccion_entrega_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "CP_ENTREGA='" & request.form("txtcp_entrega_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_tipo_direccion_entrega<>request.form("cmbtipo_direccion_entrega_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TIPO DIR', '" & campo_tipo_direccion_entrega & "',"
			cadena_historico=cadena_historico & " '" & request.form("cmbtipo_direccion_entrega_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "FECHA_DESDE_HASTA='" & cdate(request.form("txtfecha_desde_hasta_d")) & "'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_tipo_equipaje_bag_original<>request.form("txttipo_equipaje_bag_original_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TIPO EQUIPAJE', '" & campo_tipo_equipaje_bag_original & "',"
			cadena_historico=cadena_historico & " '" & request.form("txttipo_equipaje_bag_original_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "MARCA_BAG_ORIGINAL='" & request.form("txtmarca_bag_original_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_material_bag_original<>request.form("txtmaterial_bag_original_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'MATERIAL', '" & campo_material_bag_original & "',"
			cadena_historico=cadena_historico & " '" & request.form("txtmaterial_bag_original_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "ANCHO_BAG_ORIGINAL='" & request.form("txtancho_bag_original_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_danno_ruedas_bag_original<>actual_danno_ruedas then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DA�O RUEDAS', '" & campo_danno_ruedas_bag_original & "',"
			cadena_historico=cadena_historico & " '" & actual_danno_ruedas & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DA�O ASAS', '" & campo_danno_asas_bag_original & "',"
			cadena_historico=cadena_historico & " '" & actual_danno_asas & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DA�O CIERRES', '" & campo_danno_cierres_bag_original & "',"
			cadena_historico=cadena_historico & " '" & actual_danno_cierres & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "DANNO_CIERRES_BAG_ORIGINAL='" & actual_danno_cierres & "'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_danno_cremalleras_bag_original<>actual_danno_cremalleras then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DA�O CREMALLERAS', '" & campo_danno_cremalleras_bag_original & "',"
			cadena_historico=cadena_historico & " '" & actual_danno_cremalleras & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DA�O CUERPO BAG', '" & campo_danno_cuerpo_maleta_bag_original & "',"
			cadena_historico=cadena_historico & " '" & actual_danno_cuerpo_maleta & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "DANNO_CUERPO_MALETA_BAG_ORIGINAL='" & actual_danno_cuerpo_maleta & "'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_danno_cierres_maleta_bag_original<>actual_danno_cierres_maleta then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'DA�O CIERRE BAG', '" & campo_danno_cierres_maleta_bag_original & "',"
			cadena_historico=cadena_historico & " '" & actual_danno_cierres_maleta & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "DANNO_CIERRES_MALETA_BAG_ORIGINAL='" & actual_danno_cierres_maleta & "'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_danno_otros_dannos_bag_original<>actual_danno_otros_dannos then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'OTROS DA�OS BAG', '" & campo_danno_otros_dannos_bag_original & "',"
			cadena_historico=cadena_historico & " '" & actual_danno_otros_dannos & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "DANNO_OTROS_BAG_ORIGINAL='" & actual_danno_otros_dannos & "'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_ruta<>request.form("txtruta_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'RUTA', '" & campo_ruta & "',"
			cadena_historico=cadena_historico & " '" & request.form("txtruta_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "RUTA='" & request.form("txtruta_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_vuelos<>request.form("txtvuelos_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'VUELOS', '" & campo_vuelos & "',"
			cadena_historico=cadena_historico & " '" & request.form("txtvuelos_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "VUELOS='" & request.form("txtvuelos_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_estado<>request.form("cmbestado_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'CAMBIO', 'ESTADO', '" & campo_estado & "',"
			cadena_historico=cadena_historico & " '" & request.form("cmbestado_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "ESTADO='" & request.form("cmbestado_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			
			response.write("<br>estado: " & request.form("cmbestado_d"))
			
			'SI ESTAMOS AUTORIZANDO EL PIR, TAMBIEN LE PONGO LA FECHA DE INICIO
			if request.form("cmbestado_d")="AUTORIZADO" then
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA INICIO', '" & campo_fecha_inicio & "', GETDATE(),"
				cadena_historico=cadena_historico & " '" & session("usuario") & "', NULL, NULL)"
			
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "FECHA_INICIO=GETDATE()"
				
				response.write("<br>cadena_historico: " & cadena_historico)
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			
			'SI ESTAMOS ENVIANDO LA MALETA DEL PIR, TAMBIEN LE PONGO LA FECHA DE ENVIO
			if request.form("cmbestado_d")="ENVIADO" then
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA ENVIO', '" & campo_fecha_envio & "', GETDATE(),"
				cadena_historico=cadena_historico & " '" & session("usuario") & "', NULL, NULL)"
			
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "FECHA_ENVIO=GETDATE()"
				
				response.write("<br>cadena_historico: " & cadena_historico)
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if
			
			'SI ESTAMOS ENTREGANDO LA MALETA DEL PIR, TAMBIEN LE PONGO LA FECHA ENTREGA AL PAX
			if request.form("cmbestado_d")="ENTREGADO" then
				cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
				cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
				cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
				cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'FECHA ENTREGA PAX', '" & campo_fecha_entrega_pax & "', GETDATE(),"
				cadena_historico=cadena_historico & " '" & session("usuario") & "', NULL, NULL)"
			
				if cadena_pir<>"" then
					cadena_pir=cadena_pir & ", "
				end if
				cadena_pir = cadena_pir & "FECHA_ENTREGA_PAX=GETDATE()"
				
				response.write("<br>cadena_historico: " & cadena_historico)
				
				connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
			end if

			
		end if
		
		
		if campo_tipo_bag_original<>request.form("cmbtipo_maleta_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TIPO BAG AUTORIZADA', '" & campo_tipo_bag_original & "',"
			cadena_historico=cadena_historico & " '" & request.form("cmbtipo_maleta_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "TIPO_BAG_ORIGINAL='" & request.form("cmbtipo_maleta_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_importe_facturacion<>request.form("txtimporte_facturacion_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'IMPORTE FACTURACION', '" & campo_importe_facturacion & "',"
			cadena_historico=cadena_historico & " '" & request.form("txtimporte_facturacion_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "FECHA_FACTURACION='" & cdate(request.form("txtfecha_facturacion_d")) & "'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		
		if campo_tipo_bag_entregada<>request.form("cmbtipo_maleta_entregada_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TIPO BAG ENTREGADA', '" & campo_tipo_bag_entregada & "',"
			cadena_historico=cadena_historico & " '" & request.form("cmbtipo_maleta_entregada_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "TIPO_BAG_ENTREGADA='" & request.form("cmbtipo_maleta_entregada_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_tamanno_bag_entregada<>request.form("txttamanno_maleta_entregada_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'TAMA�O BAG ENTREGADA', '" & campo_tamanno_bag_entregada & "',"
			cadena_historico=cadena_historico & " '" & request.form("txttamanno_maleta_entregada_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "TAMANNO_BAG_ENTREGADA='" & request.form("txttamanno_maleta_entregada_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_referencia_bag_entregada<>request.form("cmbreferencia_maleta_entregada_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'REFERENCIA BAG ENTREGADA', '" & campo_referencia_bag_entregada & "',"
			cadena_historico=cadena_historico & " '" & request.form("cmbreferencia_maleta_entregada_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "REFERENCIA_BAG_ENTREGADA='" & request.form("cmbreferencia_maleta_entregada_d") &"'"
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		if campo_color_bag_entregada<>request.form("txtcolor_maleta_entregada_d") then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'MODIFICA', 'COLOR BAG ENTREGADA', '" & campo_color_bag_entregada & "',"
			cadena_historico=cadena_historico & " '" & request.form("txtcolor_maleta_entregada_d") & "', '" & session("usuario") & "', NULL, NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

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
			
			response.write("<br>cadena_historico: " & cadena_historico)

			if cadena_pir<>"" then
				cadena_pir=cadena_pir & ", "
			end if
			cadena_pir = cadena_pir & "COSTES=" & REPLACE(request.form("txtcostes_d"), ",", ".")
			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if


		'GRABAMOS EL TIPO DE INCIDENCIA SI SE HA SELECCIONADO EL ESTADO INCIDENCIA
		if request.form("cmbtipos_incidencia_d")<>"" and  request.form("cmbestado_d")="INCIDENCIA" then		
			cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			cadena_historico=cadena_historico & " VALUES (" & id_seleccionado & ", '" & request.form("txtpir_d") & "',"
			cadena_historico=cadena_historico & " GETDATE(), 'INCIDENCIA', NULL, NULL, NULL,"
			cadena_historico=cadena_historico & " '" & session("usuario") & "', '" & request.form("cmbtipos_incidencia_d") & "', NULL)"
			
			response.write("<br>cadena_historico: " & cadena_historico)

			
			connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
		end if
		
		
		
		if cadena_pir<>"" then
			cadena_ejecucion="UPDATE PIRS SET " & cadena_pir & " WHERE ID= " & id_seleccionado
			response.write("<br>cadena_pir: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
		end if
		
		connmaletas.CommitTrans ' finaliza la transaccion
		
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pir</TITLE>
</HEAD>
<script language="javascript">
function validar(mensaje)
{
	alert('PIR GUARDADO CORRECTAMENTE');
	
	//refresco la tabla de pirs de la pagina principal por si hay modificaciones
	window.parent.lst_pirs.ajax.reload(); 
	document.getElementById('frmgrabar_pir').submit()	
	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

   
<BODY onload="validar('<%=mensaje_aviso%>')">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>
<form name="frmgrabar_pir" id="frmgrabar_pir" method="post" action="Detalle_Pir.asp?id=<%=id_seleccionado%>">
</form>
</BODY>
   <%	
   		'regis.close			
		connmaletas.Close
		set connmaletas=Nothing
	%>
   </HTML>
