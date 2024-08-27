<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		
		
	set pedidos=Server.CreateObject("ADODB.Recordset")
	with pedidos
		.ActiveConnection=connimprenta
		.Source="SELECT A.ID, A.CODCLI, A.CODIGO_EXTERNO, A.PEDIDO, A.FECHA, A.ESTADO, A.FECHA_ENVIADO, "
		.Source= .Source & " A.CODCLI_ANT, A.USUARIO_DIRECTORIO_ACTIVO, A.PEDIDO_AUTOMATICO,"
		.Source= .Source & " B.ARTICULO"
		.Source= .Source & " FROM PEDIDOS A INNER JOIN PEDIDOS_DETALLES B"
		.Source= .Source & " ON A.ID = B.ID_PEDIDO"

		.Source= .Source & " WHERE A.ESTADO = 'RESERVADO'"
		.Source= .Source & " ORDER BY a.ID"
		response.write("<br>" & .source)
		.Open
		
	end with

	
%>
<html>
<head>
<link href="estilos.css" rel="stylesheet" type="text/css" />
<style>
	a.enlace { 
			text-decoration:none;
			font: bold courier }
	a.enlace:link { color:#990000}
	a.enlace:visited { color:#990000}
	a.enlace:actived {color:#990000}
	a.enlace:hover {
			font: bold italic ;color:blue}
			
	a.nosub { 
			text-decoration:none;
			}
	a.nosub:link { color:blue}
	a.nosub:visited { color:blue}
	a.nosub:actived {color:blue}
	a.nosub:hover {
			font: bold italic ;color:#8080c0}
		
</style>

<script language="javascript" runat="server" src="json2_a.asp"></script>
<script language="vbscript">
	
	
</script>

<script type="text/javascript"> 


</script> 

</head>
<body onload="">





<table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table">
                                    <tr style="background-color:#FCFCFC" valign="top">
                                      <th class="menuhdr">PEDIDO</th>
                                      <th class="menuhdr">CLIENTE</th>
                                      <th width="65" class="menuhdr">FECHA</th>
                                      <th width="82" class="menuhdr">ARTICULO</th>
                                      <th width="97" class="menuhdr">Población</th>
                                      <th width="91" class="menuhdr">Provincia</th>
                                      <th class="menuhdr">T. Precios</th>
                                    </tr>
                                    <%While not pedidos.eof%>
										<tr valign="top">
										  <td class="ac item_row" width="87"><%=pedidos("id")%></td>
										  <td class="ac item_row" style="text-align:left" width="158"><%=pedidos("codcli")%></td>
										  <td width="70" class="ac item_row" style="text-align:right"><%=pedidos("fecha")%></td>
										  <td width="92" class="ac item_row" style="text-align:right"><%=pedidos("articulo")%></td>
										  <td width="97" class="al item_row" style="text-align:right">aaaa</td>
										  <td width="91" class="al item_row" style="text-align:right">aaa</td>
										  <td width="81" class="ac item_row" style="text-align:right">aaaa</td>
										</tr>
										<%pedidos.movenext%>
									<%wend%>										
                                  </table>
























</body>
<%
	pedidos.close
	set pedidos=Nothing

	
	connimprenta.close
	
	set connimprenta=Nothing

%>
</html>
