<%@ language=vbscript %>

<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	id_pedido = "" & request.QueryString("p")
	tipo = "" & request.QueryString("t")
	ver_cadena="" & Request.QueryString("p_vercadena")
		

if id_pedido<>"" and tipo<>"" then
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

	if UCASE(tipo)="HTML" then%>
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
					<td>PERSONA DE CONTACTO</td>
				</tr>
				<tr>
					<td><%=rs("PEDIDO")%></td>
					<td><%=rs("EMPRESA")%></td>
					<td><%=rs("DESTINATARIO")%></td>
					<td><%=rs("DESTINATARIO_DIRECCION")%></td>
					<td><%=rs("DESTINATARIO_CP")%></td>
					<td><%=rs("DESTINATARIO_POBLACION")%></td>
					<td><%=rs("DESTINATARIO_PROVINCIA")%></td>
					<td><%=rs("DESTINATARIO_TELEFONO")%></td>
					<td><%=rs("DESTINATARIO_EMAIL")%></td>
					<td><%=rs("DESTINATARIO_PERSONA_CONTACTO")%></td>
				</tr>
			</table>
			<BR /><BR /> <BR /><BR />
			<table width="50%" border="1" cellpadding="0" cellspacing="0" align="center">
				<%
				For i = 0 To rs.Fields.Count - 1
					campo = rs.Fields(i).Name
					valor = rs.Fields(i).Value
					Response.Write("<tr><td width='25%'>" & campo & "</td><td>" & valor & "</td></tr>")
				Next
				%>
			</table>
			<br /><br><br>
			
			<%=rs("PEDIDO")%>
			<br /><%=rs("EMPRESA")%>
			<br /><%=rs("DESTINATARIO")%>
			<br /><%=rs("DESTINATARIO_DIRECCION")%>
			<br /><%=rs("DESTINATARIO_CP")%>&nbsp;<%=rs("DESTINATARIO_POBLACION")%>
			<br /><%=rs("DESTINATARIO_PROVINCIA")%>
			<br /><%=rs("DESTINATARIO_TELEFONO")%>
			<br /><%=rs("DESTINATARIO_EMAIL")%>
			<%if rs("DESTINATARIO_PERSONA_CONTACTO")<>"" then%>
				<br />Att:&nbsp;<%=rs("DESTINATARIO_PERSONA_CONTACTO")%>
			<%end if%>
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

else%>
	<br /><br />
	<table width="90%" border="1" cellpadding="0" cellspacing="0" align="center">
		<%if id_pedido="" then%>
		<tr>
			<td align="center">Falta el Parametro "p" con el codigo del pedido en la url (ejemplo: http://carrito.globalia-artesgraficas.com/tojson/Datos_Clientes.asp?p=23456&t=json)</td>
		</tr>
		<%end if
		if tipo="" then%>
			<tr>
			<td align="center">Falta el Parametro "t" con el tipo de respuesta(json, html) en la url (ejemplo: http://carrito.globalia-artesgraficas.com/tojson/Datos_Clientes.asp?p=23456&t=html)</td>
		</tr>
		<%end if%>
	</table>
<%end if%>