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





<table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table" border="1">
                                    <tr style="background-color:#FCFCFC" valign="top">
                                      <th class="menuhdr">PEDIDO</th>
                                      <th class="menuhdr">CLIENTE</th>
                                      <th width="65" class="menuhdr">FECHA</th>
                                      <th width="82" class="menuhdr">ARTICULO</th>
									  <th width="82" class="menuhdr">ruta</th>
									  <th width="82" class="menuhdr">cadena json</th>
                                      <th width="97" class="menuhdr">telefono</th>
                                      <th width="91" class="menuhdr">fax</th>
									  <th width="91" class="menuhdr">email</th>
									  <th width="91" class="menuhdr">calle</th>
									  <th width="91" class="menuhdr">numero</th>
									  <th width="91" class="menuhdr">poblacion</th>
									  <th width="91" class="menuhdr">cp</th>
									  <th width="91" class="menuhdr">provincia</th>
									  <th width="91" class="menuhdr">email pruebas</th>
                                    </tr>
                                    <%While not pedidos.eof
										cadena_texto_json=""
											set fso_json=Server.CreateObject("Scripting.FileSystemObject")
											ruta_fichero_json= Server.MapPath("./gag/pedidos/" & year(pedidos("fecha")) & "/" & pedidos("codcli") & "__" & pedidos("id"))
											ruta_fichero_json= ruta_fichero_json & "/json_" & pedidos("articulo") & ".json"
											'--response.write("<br>fichero json a comprobar si existe: " & ruta_fichero_json)
											if fso_json.FileExists(ruta_fichero_json) then
												Set contenido_fichero_json = fso_json.OpenTextFile(ruta_fichero_json, 1) 
												'Escribimos su contenido 
												cadena_texto_json=contenido_fichero_json.ReadAll
												'--Response.Write("El contenido es:<br>" & cadena_texto_json)
												Dim plantillas: Set plantillas = JSON.parse(cadena_texto_json)

   											'end if
												%>	
									
												<tr valign="top">
												  <td class="ac item_row" width="87"><%=pedidos("id")%></td>
												  <td class="ac item_row" style="text-align:left" width="158"><%=pedidos("codcli")%></td>
												  <td width="70" class="ac item_row" style="text-align:right"><%=pedidos("fecha")%></td>
												  <td width="92" class="ac item_row" style="text-align:right"><%=pedidos("articulo")%></td>
												  <td width="97" class="al item_row" style="text-align:right"><%=ruta_fichero_json%></td>
												  <td width="91" class="al item_row" style="text-align:right"><%=cadena_texto_json%><td>
												  <td width="81" class="ac item_row" style="text-align:right"><%=plantillas.plantillas.get(0).telefono%></td>
												  <td width="81" class="ac item_row" style="text-align:right"><%=plantillas.plantillas.get(0).fax%></td>
												  <td width="81" class="ac item_row" style="text-align:right"><%=plantillas.plantillas.get(0).email%></td>
												  <td width="81" class="ac item_row" style="text-align:right"><%=plantillas.plantillas.get(0).calle%></td>
												  <td width="81" class="ac item_row" style="text-align:right"><%=plantillas.plantillas.get(0).numero_calle%></td>
												  <td width="81" class="ac item_row" style="text-align:right"><%=plantillas.plantillas.get(0).poblacion%></td>
												  <td width="81" class="ac item_row" style="text-align:right"><%=plantillas.plantillas.get(0).cp%></td>
												  <td width="81" class="ac item_row" style="text-align:right"><%=plantillas.plantillas.get(0).provincia%></td>
												  <td width="81" class="ac item_row" style="text-align:right"><%=plantillas.plantillas.get(0).email_pruebas%></td>
												</tr>
												
											<%end if%>
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
