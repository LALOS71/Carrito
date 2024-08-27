<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
		if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
		end if
		
		cliente_seleccionado= "" & Request.Form("cliente")
		tipo_seleccionado = "" & Request.Form("tipo")
		sn_seleccionada = "" & Request.Form("sn_imp")
		estado_seleccionado = "" & Request.Form("estado")
		pedido_seleccionado = "" & Request.Form("pedido")
		facturable_seleccionado = "" & Request.Form("facturable")
		
		ver_cadena="" & Request.QueryString("p_vercadena")
		
		if ver_cadena="SI" then
			response.write("cliente: " & cliente_seleccionado)
			response.write("sn: " & sn_seleccionada)
			response.write("estado: " & estado_seleccionado)
			response.write("pedido: " & pedido_seleccionado)
			response.write("facturable: " & facturable_seleccionado)
		end if
		'response.write("<br>cliente: " & cliente_seleccionado)
		'response.write("<br>sn: " & sn_seleccionada)
		'response.write("<br>estado: " & estado_seleccionado)
		'response.write("<br>facturable: " & facturable_seleccionado)
		
		set rs_impresoras=Server.CreateObject("ADODB.Recordset")
		
		sql = "SELECT C.ID AS ID_CLIENTE, C.NOMBRE, C.TIPO"
		sql = sql & ", 'PENDIENTE DE FIRMA ' + CAST(B.CANTIDAD AS VARCHAR(10)) + ' IMP.' AS SN_IMPRESORA_PEDIDOS"
		sql = sql & ", B.ID_PEDIDO , CONVERT(varchar, A.FECHA, 103) as FECHA_ALTA"
		sql = sql & ", A.ESTADO"
		sql = sql & " FROM PEDIDOS A"
		sql = sql & " INNER JOIN PEDIDOS_DETALLES B ON A.ID=B.ID_PEDIDO"
		sql = sql & " INNER JOIN V_CLIENTES C ON C.ID=A.CODCLI"
		sql = sql & " WHERE PEDIDO_AUTOMATICO='IMPRESORA_GLS_ADMIN'"
		sql = sql & " AND B.ARTICULO=4583"
		sql = sql & " AND B.ESTADO = 'PENDIENTE_FIRMA'"
		if cliente_seleccionado <> "" then
			sql = sql & " AND C.ID = " & cliente_seleccionado
		end if
		if tipo_seleccionado <> "" then
			sql = sql & " AND C.TIPO = '" & tipo_seleccionado & "'"
		end if
		if sn_seleccionada <> "" then
			'NO PUEDO BUSCAR POR EL NUMERO DE SERIE PORQUE NO EXISTE EN ESTA TABLA
			sql = sql & " AND A.ID=0"
		end if
		if estado_seleccionado <> "" then
			sql = sql & " AND B.ESTADO = '" & estado_seleccionado & "'"
		end if
		if pedido_seleccionado <> "" then
			sql = sql & " AND A.ID = " & pedido_seleccionado
		end if
		if facturable_seleccionado="SI" then
			sql = sql & " AND B.ESTADO = 'aaa'"
		end if		
			

		sql = sql & " UNION "
		
		
		sql = sql & "SELECT C.ID AS ID_CLIENTE, C.NOMBRE, C.TIPO"
		sql = sql & ", 'PENDIENTE ENVIAR ' + CAST(B.CANTIDAD AS VARCHAR(10)) + ' IMP.' AS SN_IMPRESORA_PEDIDOS"
		sql = sql & ", B.ID_PEDIDO , CONVERT(varchar, A.FECHA, 103) as FECHA_ALTA"
		sql = sql & ", 'PENDIENTE' AS ESTADO"
		sql = sql & " FROM PEDIDOS A"
		sql = sql & " INNER JOIN PEDIDOS_DETALLES B ON A.ID=B.ID_PEDIDO"
		sql = sql & " INNER JOIN V_CLIENTES C ON C.ID=A.CODCLI"
		sql = sql & " WHERE (PEDIDO_AUTOMATICO='IMPRESORA_GLS' OR PEDIDO_AUTOMATICO='IMPRESORA_GLS_ADMIN')"
		sql = sql & " AND B.ARTICULO=4583"
		if cliente_seleccionado <> "" then
			sql = sql & " AND C.ID = " & cliente_seleccionado
		end if
		if tipo_seleccionado <> "" then
			sql = sql & " AND C.TIPO = '" & tipo_seleccionado & "'"
		end if
		if sn_seleccionada <> "" then
			'NO PUEDO BUSCAR POR EL NUMERO DE SERIE PORQUE NO EXISTE EN ESTA TABLA
			sql = sql & " AND A.ID=0"
		end if
		
		'como este caso solo es para mostrar las lineas de pendientes, para cualquiera de los otros estados no tiene
		' que mostrar nada, y para el estado pendiente ese para aquellos pedidos que no se han enviado no se han rechazado
		' no estan anulados y no estan pendientes de firma
		if estado_seleccionado <> "" then
			if  estado_seleccionado = "PENDIENTE" then
				sql = sql & " AND B.ESTADO NOT IN ('ENVIADO','RECHAZADO', 'ENVIO PARCIAL', 'ANULADO', 'PENDIENTE_FIRMA')"
			  else
			  	sql = sql & " AND B.ESTADO = 'xxxxx'"
			end if
		  else
		  	sql = sql & " AND B.ESTADO NOT IN ('ENVIADO','RECHAZADO', 'ENVIO PARCIAL', 'ANULADO', 'PENDIENTE_FIRMA')"
		end if
		if pedido_seleccionado <> "" then
			sql = sql & " AND A.ID = " & pedido_seleccionado
		end if
		if facturable_seleccionado="SI" then
			sql = sql & " AND B.ESTADO = 'aaa'"
		end if		
			

		sql = sql & " UNION"

		sql = sql & " SELECT A.ID_CLIENTE, B.NOMBRE, B.TIPO, A.SN_IMPRESORA, A.ID_PEDIDO, CONVERT(varchar, A.FECHA_ALTA, 103) AS FECHA_ALTA, A.ESTADO"
		sql = sql & " FROM GLS_IMPRESORAS A"
		sql = sql & " INNER JOIN V_CLIENTES B ON A.ID_CLIENTE=B.ID"
		sql = sql & " WHERE 1=1"
		if cliente_seleccionado <> "" then
			sql = sql & " AND A.ID_CLIENTE = " & cliente_seleccionado
		end if
		if tipo_seleccionado <> "" then
			sql = sql & " AND B.TIPO = '" & tipo_seleccionado & "'"
		end if
		if sn_seleccionada <> "" then
			sql = sql & " AND A.SN_IMPRESORA = '" & sn_seleccionada & "'"
		end if
		if estado_seleccionado <> "" then
			sql = sql & " AND A.ESTADO = '" & estado_seleccionado & "'"
		end if
		if pedido_seleccionado <> "" then
			sql = sql & " AND A.ID_PEDIDO = " & pedido_seleccionado
		end if
		'ESTADOS DISPONIBLES Y SI ESE ESTADO ES FACTURABLE A LA OFICINA O NO (ALTA O BAJA)
		'ACTIVA - ALTA
		'DEFECTUOSA - ALTA
		'DEVOLUCION - BAJA
		'BAJA - BAJA
		'AVERIADA - ALTA
		'EN CESION - ALTA
		'EN REPARACION - BAJA
		'SOLICITUD BAJA - ALTA
		'BAJA APROBADA - ALTA
		'BAJA RECHAZADA - ALTA
		'RETIRADA - BAJA
		if facturable_seleccionado <> "" then
			if facturable_seleccionado="SI" then
				sql = sql & " AND (A.ESTADO = 'ACTIVA' OR A.ESTADO = 'DEFECTUOSA' OR A.ESTADO = 'AVERIADA' OR A.ESTADO = 'EN CESION'"
				sql = sql & " OR A.ESTADO = 'SOLICITUD BAJA' OR A.ESTADO = 'BAJA APROBADA' OR A.ESTADO = 'BAJA RECHAZADA')"
			end if		
			if facturable_seleccionado="NO" then
				sql = sql & " AND (A.ESTADO = 'PENDIENTE' OR A.ESTADO = 'DEVOLUCION' OR A.ESTADO = 'BAJA' OR A.ESTADO = 'EN REPARACION' OR A.ESTADO = 'RETIRADA')"
			end if		
		end if

		
		sql = sql & " ORDER BY 2, 3"


		if ver_cadena="SI" then
			response.write("<br>impresoras gls: " & sql)
		end if
			
		'response.write("<br>impresoras gls: " & sql)
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
		with rs_impresoras
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with


		
response.ContentType = "text/html; charset=UTF-8"		
response.write("<table id=""lista_impresoras"" name=""lista_impresoras"" class=""table table-striped table-bordered"" cellspacing=""0"" width=""98%"">")
response.write("<thead>")
response.write("<tr>")
response.write("<th>Oficina</th>")
response.write("<th>Tipo</th>")
response.write("<th>Núm. Serie</th>")
response.write("<th>Pedido</th>")
response.write("<th>Fecha</th>")
response.write("<th>Estado</th>")
response.write("<th>Facturable</th>")
response.write("<th>Acciones</th>")
response.write("</tr>")
response.write("</thead>")
response.write("<tbody>")
						
						while not rs_impresoras.eof
							response.write("<tr>")
							response.write("<td>" & rs_impresoras("NOMBRE") & "</td>")
							response.write("<td>" & rs_impresoras("TIPO") & "</td>")
							response.write("<td>" & rs_impresoras("SN_IMPRESORA_PEDIDOS") & "</td>")
							response.write("<td>" & rs_impresoras("ID_PEDIDO") & "</td>")
							response.write("<td>" & rs_impresoras("FECHA_ALTA") & "</td>")
							response.write("<td>" & rs_impresoras("ESTADO") & "</td>")
							
							'ESTADOS DISPONIBLES Y SI ESE ESTADO ES FACTURABLE A LA OFICINA O NO (ALTA O BAJA)
							'ACTIVA - ALTA
							'DEFECTUOSA - ALTA
							'DEVOLUCION - BAJA
							'BAJA - BAJA
							'AVERIADA - ALTA
							'EN CESION - ALTA
							'EN REPARACION - BAJA
							'SOLICITUD BAJA - ALTA
							'BAJA APROBADA - ALTA
							'BAJA RECHAZADA - ALTA
							'RETIRADA - BAJA
							'hay que comprobar todos los estados para decir si es facturable o no
							if rs_impresoras("ESTADO")="ACTIVA" OR rs_impresoras("ESTADO")="DEFECTUOSA" OR rs_impresoras("ESTADO")="AVERIADA" OR rs_impresoras("ESTADO")="EN CESION" _
									OR rs_impresoras("ESTADO")="SOLICITUD BAJA" OR rs_impresoras("ESTADO")="BAJA APROBADA" OR rs_impresoras("ESTADO")="BAJA RECHAZADA" then
								response.write("<td>SI</td>")
							 else
							 	response.write("<td>NO</td>")
							end if
							response.write("<td class='celda_acciones'>")
							'if rs_impresoras("ESTADO")="SOLICITUD BAJA" then
							'	response.write("<div class='container'>")
							'	response.write("<div class='form-inline'>")
							'	response.write("<div class='form-group'>")
							'	response.write("<select class='form-control mr-2 acciones' name='cmbacciones_" & rs_impresoras("SN_IMPRESORA_PEDIDOS") & "' id='cmbacciones_" & rs_impresoras("SN_IMPRESORA_PEDIDOS") & "'>")
							'	response.write("<option value='' selected>Seleccionar Accion</option>")
							'	response.write("<option value='BAJA APROBADA'>APROBAR BAJA</option>")
							'	response.write("<option value='BAJA RECHAZADA'>RECHAZAR BAJA</option>")
							'	response.write("</select>")
							'	response.write("</div>") 
								
							'	impresora=rs_impresoras("SN_IMPRESORA_PEDIDOS")
							'	response.write("<button class='btn btn-primary btn-sm' onclick=""realizar_accion('" & impresora & "', 'APROBAR-REZAZAR_BAJA')""")
							'	response.write(" data-toggle='popover'")
							'	response.write(" data-placement='top'")
							'	response.write(" data-trigger='hover'")
							'	response.write(" data-content='Guardar Accion'")
							'	response.write(" data-original-title=''>")
							'	response.write("<i class='fas fa-save'></i></button>")
							'	'response.write("</div>")
							'	response.write("</div>")
							'end if
							'if rs_impresoras("ESTADO")="PENDIENTE FIRMA" then
							'	response.write("<div class='container'>")
							'	response.write("<div class='form-inline'>")
							'	response.write("<button class='btn btn-primary btn-sm' onclick=""realizar_accion('" & rs_impresoras("ID_PEDIDO")& "', 'BORRAR_PEDIDO')""")
							'	response.write(" data-toggle='popover'")
							'	response.write(" data-placement='top'")
							'	'response.write(" data-trigger='hover'")
							'	response.write(" data-content='Borrar Pedido'")
							'	response.write(" data-original-title=''>")
							'	response.write("<i class=""fas fa-trash-alt""></i>")
							'	response.write("<span>&nbsp;Borrar</span>")
							'	response.write("</button>")
							'	response.write("</div>")
							'	response.write("</div>")
							'end if
							
							response.write("</td>")
							response.write("</tr>")
							rs_impresoras.movenext
						wend
						rs_impresoras.close
						set rs_impresoras=Nothing

response.write("</tbody>")
response.write("</table>")
					
					
	connimprenta.close
	set connimprenta=Nothing

%>