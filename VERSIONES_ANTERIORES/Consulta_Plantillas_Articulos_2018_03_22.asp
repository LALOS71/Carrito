<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		
		
	set pedidos=Server.CreateObject("ADODB.Recordset")
	with pedidos
		.ActiveConnection=connimprenta
		'.Source="SELECT A.ID, A.CODCLI, D.NOMBRE, A.CODIGO_EXTERNO, A.PEDIDO, A.FECHA, A.ESTADO, A.FECHA_ENVIADO, "
		'.Source= .Source & " A.CODCLI_ANT, A.USUARIO_DIRECTORIO_ACTIVO, A.PEDIDO_AUTOMATICO,"
		'.Source= .Source & " B.ARTICULO, C.DESCRIPCION, C.CODIGO_SAP "

		'.Source= .Source & " FROM PEDIDOS AS A INNER JOIN PEDIDOS_DETALLES AS B"
		'.Source= .Source & " ON A.ID = B.ID_PEDIDO"
		'.Source= .Source & " LEFT JOIN ARTICULOS AS C"
		'.Source= .Source & " ON B.ARTICULO=C.ID"
		'.Source= .Source & " LEFT JOIN V_CLIENTES AS D"
		'.Source= .Source & " ON D.ID=A.CODCLI"
		
		'.Source= .Source & " WHERE A.ESTADO = 'RESERVADO'"
		'.Source= .Source & " ORDER BY a.ID, b.ARTICULO"
		
		.Source= "SELECT A.ID, A.CODCLI, D.NOMBRE, A.CODIGO_EXTERNO, A.PEDIDO, A.FECHA,"
		.Source= .Source & " A.ESTADO, B.ESTADO AS ESTADO_ARTICULO, A.FECHA_ENVIADO, A.CODCLI_ANT, A.USUARIO_DIRECTORIO_ACTIVO,"
		.Source= .Source & " A.PEDIDO_AUTOMATICO, B.ARTICULO, C.DESCRIPCION, C.CODIGO_SAP"

		.Source= .Source & " FROM PEDIDOS AS A INNER JOIN PEDIDOS_DETALLES AS B"
		.Source= .Source & " ON A.ID = B.ID_PEDIDO"
		.Source= .Source & " LEFT JOIN ARTICULOS AS C"
		.Source= .Source & " ON B.ARTICULO=C.ID"
		.Source= .Source & " LEFT JOIN V_CLIENTES AS D"
		.Source= .Source & " ON D.ID=A.CODCLI"

		'.Source= .Source & " WHERE C.CODIGO_SAP IN ('RBROT003', 'RBROT004H', 'RBROT004')"
		.Source= .Source & " WHERE C.CODIGO_SAP LIKE ('RBCOR002%')"

		.Source= .Source & " ORDER BY a.ID, b.ARTICULO"
		
		
		response.write("<br>" & .source)
		.Open
		
	end with

Response.ContentType = "application/vnd.ms-excel.numberformat:#.###"
Response.AddHeader "Content-Disposition", "attachment;filename=Pedidos_Reservados_ASM-GLS.xls"

%>
<html>
<head>

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
<script language="JScript" runat="server">
function CheckProperty(obj, propName) {
    return (typeof obj[propName] != "undefined");
}
</script>
<script language="vbscript">
	
	
</script>

<script type="text/javascript"> 


</script> 

</head>
<body onload="">





<table border="1" cellpadding="1" cellspacing="1" width="99%">
                                    <tr style="background-color:#FCFCFC" valign="top">
                                      <th class="menuhdr">Pedido</th>
									  <th class="menuhdr">Estado Pedido</th>
                                      <th class="menuhdr">Estado Articulo</th>
                                      <th class="menuhdr">Cliente</th>
                                      <th width="65" class="menuhdr">Fecha</th>
                                      <th width="82" class="menuhdr">Cod. Art</th>
									  <th width="82" class="menuhdr">Articulo</th>
									  <th width="82" class="menuhdr">Ruta</th>
									  <th width="82" class="menuhdr">Cadena json</th>
									  <th width="82" class="menuhdr">Cantidad</th>
									  <th width="82" class="menuhdr">Nombre</th>
									  <th width="82" class="menuhdr">Apellidos</th>
                                      <th width="97" class="menuhdr">Cargo</th>
                                      <th width="97" class="menuhdr">Telefono</th>
                                      <th width="91" class="menuhdr">Fax</th>
									  <th width="91" class="menuhdr">Movil</th>
									  <th width="91" class="menuhdr">Email</th>
									  <th width="91" class="menuhdr">Webb</th>
									  <th width="91" class="menuhdr">Calle</th>
									  <th width="91" class="menuhdr">Numero</th>
									  <th width="91" class="menuhdr">Poblacion</th>
									  <th width="91" class="menuhdr">CP</th>
									  <th width="91" class="menuhdr">Provincia</th>
									  <th width="91" class="menuhdr">Email Pruebas</th>
									  <th width="91" class="menuhdr">Telefono 2</th>
									  <th width="91" class="menuhdr">Horario</th>
									  <th width="91" class="menuhdr">Horario LU-VI</th>
									  <th width="91" class="menuhdr">Horario S&aacute;bados</th>
									  
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
												<%'dim key : for each key in plantillas.plantillas
													For i=0 to plantillas.numero_plantillas - 1%>
												<tr valign="top" >
												  	<td width="87"><%=pedidos("id")%></td>
												  	<td width="87"><%=pedidos("estado")%></td>
												  	<td width="87"><%=pedidos("estado_articulo")%></td>
												  	<td width="158"><%=pedidos("nombre")%></td>
												  	<td width="70"><%=pedidos("fecha")%></td>
												  	<td width="92"><%=pedidos("codigo_sap")%></td>
												  	<td width="92"><%=pedidos("descripcion")%></td>
												  	<td width="97"><%=ruta_fichero_json%></td>
												  	<td width="91"><%=cadena_texto_json%></td>
												  	<td width="81">
												  		<%If CheckProperty(plantillas.plantillas.get(i), "cantidad_tarjetas") Then
																	response.write(plantillas.plantillas.get(i).cantidad_tarjetas)
														End If%>
												  
												  	</td>
												  	<td width="81">
												  		<%If CheckProperty(plantillas.plantillas.get(i), "nombre") Then
																	response.write(plantillas.plantillas.get(i).nombre)
														End If%>
												  	</td>
													<td width="81">
												  		<%If CheckProperty(plantillas.plantillas.get(i), "apellidos") Then
																	response.write(plantillas.plantillas.get(i).apellidos)
														End If%>
													</td>
												  	<td width="81">
												  		<%If CheckProperty(plantillas.plantillas.get(i), "cargo") Then
																	response.write(plantillas.plantillas.get(i).cargo)
														End If%>
													</td>
												  	<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "telefono") Then
																	response.write(plantillas.plantillas.get(i).telefono)
														End If%>
													</td>
												  	<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "fax") Then
																	response.write(plantillas.plantillas.get(i).fax)
														End If%>
														
													</td>
												  	<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "movil") Then
																	response.write(plantillas.plantillas.get(i).movil)
														End If%>
													</td>
												  	<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "email") Then
																	response.write(plantillas.plantillas.get(i).email)
														End If%>
													</td>
												  	<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "web") Then
																	response.write(plantillas.plantillas.get(i).web)
														End If%>
													</td>
												  	<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "calle") Then
																	response.write(plantillas.plantillas.get(i).calle)
														End If%>
													</td>
												  	<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "numero_calle") Then
																	response.write(plantillas.plantillas.get(i).numero_calle)
														End If%>
													</td>
												  	<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "poblacion") Then
																	response.write(plantillas.plantillas.get(i).poblacion)
														End If%>
													</td>
													<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "cp") Then
																	response.write(plantillas.plantillas.get(i).cp)
														End If%>
													</td>
												  	<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "provincia") Then
																	response.write(plantillas.plantillas.get(i).provincia)
														End If%>
													</td>
												  	<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "email_pruebas") Then
																	response.write(plantillas.plantillas.get(i).email_pruebas)
														End If%>
													</td>
												  	<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "telefono2") Then
																	response.write(plantillas.plantillas.get(i).telefono2)
														End If%>
													</td>
													<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "horario") Then
																	response.write(plantillas.plantillas.get(i).horario)
														End If%>
													</td>
													<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "horario_lu_vi") Then
																	response.write(plantillas.plantillas.get(i).horario_lu_vi)
														End If%>
													</td>
													<td width="81">
														<%If CheckProperty(plantillas.plantillas.get(i), "horario_sabados") Then
																	response.write(plantillas.plantillas.get(i).horario_sabados)
														End If%>
													</td>
												</tr>
												<%next%>
												
											<%ELSE%>
												<tr valign="top" >
												  	<td width="87"><%=pedidos("id")%></td>
												  	<td width="158"><%=pedidos("nombre")%></td>
												  	<td width="70"><%=pedidos("fecha")%></td>
												  	<td width="92"><%=pedidos("codigo_sap")%></td>
												  	<td width="92"><%=pedidos("descripcion")%></td>
												  	<td width="97"><%=ruta_fichero_json%></td>
												  	<td width="91"><%=cadena_texto_json%></td>
												  	<td width="81"></td>
												  	<td width="81"></td>
													<td width="81"></td>
												  	<td width="81"></td>
												  	<td width="81"></td>
												  	<td width="81"></td>
												  	<td width="81"></td>
												  	<td width="81"></td>
												  	<td width="81"></td>
												  	<td width="81"></td>
												  	<td width="81"></td>
												  	<td width="81"></td>
													<td width="81"></td>
												  	<td width="81"></td>
												  	<td width="81"></td>
												  	<td width="81"></td>
													<td width="81"></td>
													<td width="81"></td>
													<td width="81"></td>
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
