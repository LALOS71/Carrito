<%@ language=vbscript %>

<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	id_pedido = "" & request.QueryString("p")
	tipo = "" & request.QueryString("t")
	ver_cadena="" & Request.QueryString("p_vercadena")
		
	
		cadena_sql="SELECT A.ID AS PEDIDO, C.EMPRESA"
		cadena_sql=cadena_sql & ", CASE WHEN A.DESTINATARIO IS NULL THEN B.NOMBRE ELSE A.DESTINATARIO END AS DESTINATARIO"
		cadena_sql=cadena_sql & ", CASE WHEN A.DESTINATARIO_DIRECCION IS NULL THEN B.DIRECCION ELSE A.DESTINATARIO_DIRECCION END AS DESTINATARIO_DIRECCION"
		cadena_sql=cadena_sql & ", CASE WHEN A.DESTINATARIO_CP IS NULL THEN B.CP ELSE A.DESTINATARIO_CP END AS DESTINATARIO_CP"
		cadena_sql=cadena_sql & ", CASE WHEN A.DESTINATARIO_POBLACION IS NULL THEN B.POBLACION ELSE A.DESTINATARIO_POBLACION END AS DESTINATARIO_POBLACION"
		cadena_sql=cadena_sql & ", CASE WHEN A.DESTINATARIO_PROVINCIA IS NULL THEN B.PROVINCIA ELSE A.DESTINATARIO_PROVINCIA END AS DESTINATARIO_PROVINCIA"
		cadena_sql=cadena_sql & ", CASE WHEN A.DESTINATARIO_TELEFONO IS NULL THEN B.TELEFONO ELSE A.DESTINATARIO_TELEFONO END AS DESTINATARIO_TELEFONO"
		cadena_sql=cadena_sql & ", CASE WHEN A.DESTINATARIO IS NULL THEN B.EMAIL ELSE NULL END AS DESTINATARIO_EMAIL"
		cadena_sql=cadena_sql & ", A.DESTINATARIO_PERSONA_CONTACTO"

		cadena_sql=cadena_sql & " FROM PEDIDOS A"
		cadena_sql=cadena_sql & " INNER JOIN V_CLIENTES B ON A.CODCLI=B.ID"
		cadena_sql=cadena_sql & " INNER JOIN V_EMPRESAS C ON C.ID=B.EMPRESA"
		cadena_sql=cadena_sql & " WHERE A.ID = " & id_pedido




		
		
	if ver_cadena="SI" then
		response.write("<br>consulta: " & cadena_sql)
	end if
			
	Set rs = Server.CreateObject("ADODB.recordset")
	rs.Open cadena_sql, connimprenta

%>
<%if UCASE(tipo)="HTML" then%>
	<HTML>
	<BODY>
	<%
	if not rs.eof then%>
			
			<br /><br />
			<table width="95%" border="1" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td>PEDIDO</td>
					<td>EMPRESA</td>
					<td>CLIENTE</td>
					<td>DIRECCION</td>
					<td>CP</td>
					<td>POBLACION</td>
					<td>PROVINCIA</td>
					<td>TLFNO</td>
					<td>EMAIL</td>
				</tr>
				<tr>
					<td><%=rs("PEDIDO")%></td>
					<td><%=rs("EMPRESA")%></td>
					<td><%=rs("NOMBRE")%></td>
					<td><%=rs("DIRECCION")%></td>
					<td><%=rs("CP")%></td>
					<td><%=rs("POBLACION")%></td>
					<td><%=rs("PROVINCIA")%></td>
					<td><%=rs("TELEFONO")%></td>
					<td><%=rs("EMAIL")%></td>
				</tr>
			</table>
			<BR /><BR /> <BR /><BR />
			<table width="50%" border="1" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td width="25%">PEDIDO</td>
					<td><%=rs("PEDIDO")%></td>
				</tr>
				<tr>
					<td>EMPRESA</td>
					<td><%=rs("EMPRESA")%></td>
				</tr>
				<tr>
					<td>CLIENTE</td>
					<td><%=rs("NOMBRE")%></td>
				</tr>
				<tr>
					<td>DIRECCION</td>
					<td><%=rs("DIRECCION")%></td>
				</tr>
				<tr>
					<td>CP</td>
					<td><%=rs("CP")%></td>
				</tr>
				<tr>
					<td>POBLACION</td>
					<td><%=rs("POBLACION")%></td>
				</tr>
				<tr>
					<td>PROVINCIA</td>
					<td><%=rs("PROVINCIA")%></td>
				</tr>
				<tr>
					<td>TLFNO</td>
					<td><%=rs("TELEFONO")%></td>
				</tr>
				<tr>
					<td>EMAIL</td>
					<td><%=rs("EMAIL")%></td>
				</tr>
			</table>
			<br /><br><br>
			
			<%=rs("PEDIDO")%>
			<br /><%=rs("EMPRESA")%>
			<br /><%=rs("NOMBRE")%>
			<br /><%=rs("DIRECCION")%>
			<br /><%=rs("CP")%>&nbsp;<%=rs("POBLACION")%>
			<br /><%=rs("PROVINCIA")%>
			<br /><%=rs("TELEFONO")%>
			<br /><%=rs("EMAIL")%>
			<br /><br><br>
		<%else%>
			<br /><br />
			<table width="90%" border="1" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td align="center">EL PEDIDO NO EXISTE</td>
				</tr>
			</table>
	<%end if%>
	</BODY>
	</HTML>

<%end if

if UCASE(tipo)="JSON" then
	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(rs, "ROWSET") & "}"
end if

connimprenta.close
set connimprenta=Nothing
%>
