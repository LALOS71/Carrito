<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
	sesion_caducada="NO"
	
	if session("usuario")="" then
		sesion_caducada="SI"
	end if
		
	if sesion_caducada= "NO" then
		sn_seleccionada = "" & Request.Form("sn_imp")
		
		ver_cadena="" & Request.QueryString("p_vercadena")
		
		if ver_cadena="SI" then
			response.write("sn: " & sn_seleccionada)
		end if
		'response.write("<br>cliente: " & cliente_seleccionado)
		'response.write("<br>sn: " & sn_seleccionada)
		'response.write("<br>estado: " & estado_seleccionado)
		'response.write("<br>facturable: " & facturable_seleccionado)
		
		set rs_historico=Server.CreateObject("ADODB.Recordset")
		
		sql = "SELECT A.SN_IMPRESORA, A.FECHA, A.ESTADO, B.NOMBRE AS ASOCIADA_A, A.IP_USUARIO, A.PERFIL "
		sql = sql & " FROM GLS_IMPRESORAS_HISTORICO A"
		sql = sql & " LEFT JOIN V_CLIENTES B ON A.ASOCIADA_A=B.ID"
		sql = sql & " WHERE A.SN_IMPRESORA = '" & sn_seleccionada & "'"
		sql = sql & " ORDER BY A.FECHA"

		'response.write("<br>impresoras gls: " & sql)
		if ver_cadena="SI" then
			response.write("<br>impresoras gls: " & sql)
		end if
			
		'response.write("<br>impresoras gls: " & sql)
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
		with rs_historico
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with


		
		response.ContentType = "text/html; charset=UTF-8"		
		response.write("<table id=""lista_historico"" name=""lista_historico"" class=""table table-striped table-bordered"" cellspacing=""0"" width=""98%"">")
		response.write("<thead>")
		response.write("<tr>")
		'response.write("<th>Núm. Serie</th>")
		response.write("<th>Fecha</th>")
		response.write("<th>Estado</th>")
		response.write("<th>Oficina</th>")
		response.write("<th>Usuario</th>")
		response.write("</tr>")
		response.write("</thead>")
		response.write("<tbody>")
						
		while not rs_historico.eof
			response.write("<tr>")
			'response.write("<td>" & rs_historico("SN_IMPRESORA") & "</td>")
			response.write("<td>" & rs_historico("FECHA") & "</td>")
			response.write("<td>" & rs_historico("ESTADO") & "</td>")
			response.write("<td>" & rs_historico("ASOCIADA_A") & "</td>")
			response.write("<td>" & rs_historico("PERFIL") & "</td>")
			response.write("</tr>")
			rs_historico.movenext
		wend
		rs_historico.close
		set rs_historico=Nothing

		response.write("</tbody>")
		response.write("</table>")
	  else
	  	response.ContentType = "text/html; charset=UTF-8"		
		response.write("<h6>Sesión Caducada, Vuelva a Iniciar Sesión en la Aplicación</h6>")  
	 end if
					
					
	connimprenta.close
	set connimprenta=Nothing

%>