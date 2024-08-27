<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
		if session("usuario")="" then
			if empleado_gls="SI" then
				Response.Redirect("../Login_GLS_Empleados.asp")
			  else
			  	Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
			end if
		end if
		
		cliente_seleccionado=0
		
		cliente_imp= "" & Request.Form("cliente")
		if cliente_imp<>"" then
			cliente_seleccionado=cliente_imp
		end if
		
		ver_cadena="" & Request.QueryString("p_vercadena")
		
		set rs_impresoras=Server.CreateObject("ADODB.Recordset")
		sql="SELECT 'PENDIENTE ENVIAR ' + CAST(B.CANTIDAD AS VARCHAR(10)) + ' IMP.' AS SN_IMPRESORA, B.ID_PEDIDO"
		sql = sql & " , CONVERT(varchar, A.FECHA, 103) as FECHA_ALTA, 'PENDIENTE' AS ESTADO"
		sql = sql & " FROM PEDIDOS A"
		sql = sql & " INNER JOIN PEDIDOS_DETALLES B ON A.ID=B.ID_PEDIDO"
		sql = sql & " WHERE CODCLI = " & cliente_seleccionado
		sql = sql & " AND PEDIDO_AUTOMATICO='IMPRESORA_GLS'"
		sql = sql & " AND B.ARTICULO=4583"
		sql = sql & " AND B.ESTADO NOT IN ('ENVIADO','RECHAZADO', 'ENVIO PARCIAL', 'ANULADO')"
		sql = sql & " UNION"
		sql = sql & " SELECT SN_IMPRESORA, ID_PEDIDO, CONVERT(varchar, FECHA_ALTA, 103) as FECHA_ALTA, ESTADO FROM GLS_IMPRESORAS"
		sql = sql & " WHERE ID_CLIENTE = " & cliente_seleccionado
		sql = sql & " ORDER BY FECHA_ALTA DESC"
		
		if ver_cadena="SI" then
			response.write("<br>impresoras gls: " & sql)
		end if
		
		
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
response.write("<th>Número de serie</th>")
response.write("<th>Pedido</th>")
response.write("<th>Fecha</th>")
response.write("<th>Estado</th>")
response.write("<th>Acciones</th>")
response.write("</tr>")
response.write("</thead>")
response.write("<tbody>")

	while not rs_impresoras.eof
		response.write("<tr>")
		response.write("<td>" & rs_impresoras("SN_IMPRESORA") & "</td>")
		response.write("<td>" & rs_impresoras("ID_PEDIDO") & "</td>")
		response.write("<td>" & rs_impresoras("FECHA_ALTA") & "</td>")
		response.write("<td>" & rs_impresoras("ESTADO") & "</td>")
		response.write("<td>")
		if rs_impresoras("ESTADO") = "ACTIVA" then
			response.write("<div class='container'>")
			response.write("<div class='form-inline'>")
			response.write("<div class='form-group'>")
			response.write("<select class='form-control mr-2 acciones' name='cmbacciones_" & rs_impresoras("SN_IMPRESORA") & "' id='cmbacciones_" & rs_impresoras("SN_IMPRESORA") & "'>")
			response.write("<option value='' selected>Seleccionar Accion</option>")
			'solo podrán indicar que es defectuosa dentro de los primeros 20 dias desde que se les envia
			if DateDiff("d", rs_impresoras("FECHA_ALTA"), now()) <= 20 then
				response.write("<option value='DEFECTUOSA'>Notificar Imp. DEFECTUOSA</option>")
			end if
			response.write("<option value='AVERIADA'>Notificar Imp. AVERIADA</option>")
			response.write("<option value='SOLICITUD BAJA'>Solicitar BAJA de Imp.</option>")
			response.write("</select>")
			response.write("</div>") 
		
			impresora=rs_impresoras("SN_IMPRESORA")
			estado_imp= "$('#cmbacciones_" & rs_impresoras("SN_IMPRESORA") & "').val()"
			response.write("<button class='btn btn-primary' onclick=""realizar_accion('" & impresora & "')""")
			response.write(" data-toggle='popover'")
			response.write(" data-placement='top'")
			response.write(" data-trigger='hover'")
			response.write(" data-content='Guardar Accion'")
			response.write(" data-original-title=''>")
			response.write("<i class='fas fa-save'></i></button>")
			response.write("</div>")
			response.write("</div>")
		end if
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