<%@ language=vbscript %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<%
		Response.Buffer = TRUE
		if session("usuario")="" then
			Response.Redirect("../Login_ATESA.asp")
		end if
		
		'recordsets
		dim articulos
		
		'aqui viene la accion junto con el pedido y la fecha "MODIFICAR--88--fecha--codigo cliente--codigo externo cliente--nombre cliente"
		acciones=Request.QueryString("acciones")
		
		codigo_sap_buscado=Request.Form("txtcodigo_sap")
		articulo_buscado=Request.form("txtdescripcion")
		
		
		set tipos_precios=Server.CreateObject("ADODB.Recordset")
		with tipos_precios
			.ActiveConnection=connimprenta
			.Source="SELECT TIPO_PRECIO FROM V_EMPRESAS_TIPOS_PRECIOS WHERE ID_EMPRESA=5 ORDER BY TIPO_PRECIO"
			.Open
			vacio_tipos_precios=false
			if not .BOF then
				tabla_tipos_precios=.GetRows()
			  else
				vacio_tipos_precios=true
			end if
		end with	
		tipos_precios.close
		set tipos_precios=Nothing
		

		set articulos=Server.CreateObject("ADODB.Recordset")
		
		sql="Select articulos.*, articulos_marcas.stock  from articulos"
		sql=sql & " INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO "
		sql=sql & " INNER JOIN ARTICULOS_MARCAS ON ARTICULOS.ID=ARTICULOS_MARCAS.ID_ARTICULO"
		sql=sql & " where MOSTRAR='SI'"
		if codigo_sap_buscado<>"" then
			sql=sql & " and codigo_sap like '%" & codigo_sap_buscado & "%'"
		end if
		if articulo_buscado<>"" then
			'sql=sql & " and descripcion like ""*" & articulo_buscado & "*"""
			sql=sql & " and descripcion like '%" & articulo_buscado & "%'"
		end if
		sql=sql & " and ARTICULOS_EMPRESAS.codigo_empresa = " & session("usuario_codigo_empresa") 
		sql=sql & " and (articulos.id in (select codigo_articulo from cantidades_precios "
		sql=sql & " where cantidades_precios.codigo_empresa=" & session("usuario_codigo_empresa") & ")) "
		'sql=sql & " and Descripcion <> ''"
		'sql=sql & " and Mostrar_Intranet='SI'"
		'sql=sql & " and Activo = 1"
		'sql=sql & " order by Orden"
		sql=sql & " order by compromiso_compra desc, Descripcion"
		'response.write("<br>" & sql)
		
		with articulos
			.ActiveConnection=connimprenta
			
			.Source=sql
			
			.Open
		end with
		
		dim hoteles
		
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
<title>Carrito Imprenta</title>
<link href="../estilos.css" rel="stylesheet" type="text/css" />

<script src="../funciones.js" type="text/javascript"></script>
</head>
<body>

<table>
<tr>
	<td width="218" valign="top">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
				</td>
			</tr>
			<tr>
				<td>
				</td>
			</tr>
		</table>
		
		<div class="sidebarcell">
			
			<div id="side_freetext_title_39" class="title">
				<br />
				<font size="3"><b>Enlaces Disponibles</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					· <a href="Lista_Articulos_Atesa_Central_Admin.asp">Consultar Artículos <%=session("usuario_empresa")%></a>
					<br />
					· <a href="Consulta_Pedidos_Atesa_Central_Admin.asp">Consultar Pedidos <%=session("usuario_empresa")%></a>
					
				  <div class="info">				  </div>
					
				</div>
				</div>
			</div>
		</div>
		
	</td>
	<td width="713">
		<div id="main">
			<table width="90%" cellspacing="6" cellpadding="0" class="logintable" align="center">
				<tr>
					<!--6.08 - Translate titles and buttons-->
					<td class="al">
						<span class='fontbold'>Busqueda de Productos <%=session("usuario_empresa")%></span>
					</td>
				</tr>
				<tr>
					<td width="50%" class="dottedBorder vt al">
						
	  
						<form name="frmbusqueda" id="frmbusqueda" method="post" action="Lista_Articulos_Atesa_Central_Admin.asp?acciones=<%=acciones%>">
							<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Código Sap: </td>
									<td width="20%"><input class="txtfield" size="14" name="txtcodigo_sap" id="txtcodigo_sap" /></td>
									<td width="13%">Descripción: </td>
									<td width="42%"><input class="txtfield" size="44" name="txtdescripcion" id="txtdescripcion" /></td>
									<td width="12%">
										<div align="right">
										  <input class="submitbtn" type="submit" name="Action" id="Action" value="Buscar" />
										</div>
									</td>
								</tr>
								
							</table>
						</form>
				  </td>
				</tr>
			</table>
			
			<div id="center_newproducts__title_28" class="main-product">
			
			<table width="587" class="product-wrapper">
				<%while not articulos.eof
					response.flush()%>
				
				  <tr>
					<!--inicio del articulo-->
					<td width="579" colspan="3" class="vt ac">
						<div id="displaynewproducts0" class="randomproduct">
							<table width="100%" cellspacing="0" cellpadding="0" border="0" class="prod_border_table">
								<tbody>
									<tr>
										<td class="td1">
											<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table1">
												<tbody>
													<tr>
														<td class="td2">
																<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table2">
																	<tbody>
																		<tr>
																			<td class="td3">
																				<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table3">
																					<tbody>
																						<tr>
																							<td width="42%"> <!-- aqui iba class="prod_border_td"-->  
																								<!--<div class="image">-->
																								<center>
																									<table border="0" width="100%" height="100%">
																										<tr><td height="3"></td></tr>
																										<tr>
																											<td valign="middle" align="center">
																												<%
																												set marcas_articulo=Server.CreateObject("ADODB.Recordset")
																												with marcas_articulo
																													.ActiveConnection=connimprenta
																													.Source="SELECT * FROM ARTICULOS_MARCAS"
																													.Source= .Source & " WHERE ID_ARTICULO=" & articulos("id")
																													.Source= .Source & " ORDER BY MARCA"
																													'response.write(.source)
																													.Open
																												end with
																												
																												while not marcas_articulo.eof
																												%>
																													<span class='fontbold'><%=marcas_articulo("marca")%></span>
																													<br />
																													<a href="../Imagenes_Articulos/<%=articulos("id")%>.jpg" target="_blank">
																														<img class="product_thumbnail" src="../Imagenes_Articulos/Miniaturas/i_<%=articulos("id")%>.jpg" border="0"></a>
																													<br />
																												<%	
																													marcas_articulo.movenext
																												wend
																												
																												marcas_articulo.close
																												set marcas_articulo=Nothing
																												%>
																											</td>
																										</tr>
																										<tr><td height="3"></td></tr>
																									</table>
																								</center>
																								<!--</div>-->
																							</td>
																							<td width="58%" class="prod_border_td">
																								
																								<table border="0" cellpadding="0" cellspacing="0" width="100%" >
																									<tr>
																										<td><h3><%=articulos("descripcion")%></h3></td>
																									</tr>
																									<tr>
																										<td><div align="left"><b>Codigo Sap:</b> <%=articulos("codigo_sap")%><br /></div></td>
																									</tr>
																									<tr>
																										<td>
																											<div align="left" style="display:none" id="informacion_<%=articulos("ID")%>">
																												
																												<%
																												set multiarticulos=Server.CreateObject("ADODB.Recordset")
		
																												sql="Select *  from descripciones_multiarticulos"
																												sql=sql & " where id_articulo=" & articulos("ID") 
																												sql=sql & " order by id"
																												'response.write("<br>" & sql)
																												
																												with multiarticulos
																													.ActiveConnection=connimprenta
																													
																													.Source=sql
																													
																													.Open
																												end with
																												
																												while not multiarticulos.eof
																												%>
																													<b><%=multiarticulos("caracteristica")%>:</b> <%=multiarticulos("descripcion")%><br />
																												
																												<%
																													multiarticulos.movenext
																												wend
																												%>
																												
																												
																												<%if articulos("tamanno")<>"" then%>
																													<b>Tamaño:</b> <%=articulos("tamanno")%><br />
																												<%end if%>
																												<%if articulos("tamanno_abierto")<>"" then%>
																													<b>Tamaño Abierto:</b> <%=articulos("tamanno_abierto")%><br />
																												<%end if%>
																												<%if articulos("tamanno_cerrado")<>"" then%>
																													<b>Tamaño Cerrado:</b> <%=articulos("tamanno_cerrado")%><br />
																												<%end if%>
																												<%if articulos("papel")<>"" then%>
																													<b>Papel:</b> <%=articulos("papel")%><br />
																												<%end if%>
																												<%if articulos("tintas")<>"" then%>
																													<b>Tintas:</b> <%=articulos("tintas")%><br />
																												<%end if%>
																												<%if articulos("acabado")<>"" then%>
																													<b>Acabado:</b> <%=articulos("acabado")%><br />
																												<%end if%>
																												<%if articulos("fecha")<>"" then%>
																													<b>Fecha:</b> <%=articulos("fecha")%><br />&nbsp;
																												<%end if%>
																												
																												
																												
																												
																												
																												
																											</div>
																										</td>
																									</tr>
																								
																								</table>
																								
																								<div class="info">
																									<table width="100%" >
																										<tr>
																											<td width="64%" class="info_column">
																											<%if not vacio_tipos_precios then
																											    for i=0 to UBound(tabla_tipos_precios,2)%>

																												<%'aqui ponemos la relacion de precios para cada tipo de precio
																												set cantidades_precios=Server.CreateObject("ADODB.Recordset")
		
																												sql="SELECT * FROM CANTIDADES_PRECIOS"
																												sql=sql & " WHERE CODIGO_ARTICULO=" & articulos("id")
																												sql=sql & " AND TIPO_SUCURSAL='" & tabla_tipos_precios(0,i) & "' "
																												sql=sql & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
																												sql=sql & " ORDER BY CANTIDAD"
																												'response.write("<br>" & sql)
																												
																												with cantidades_precios
																													.ActiveConnection=connimprenta
																													.CursorType=3 'adOpenStatic
																													.Source=sql
																													.Open
																												end with
																												%>         
																												<span>
																												<%if not cantidades_precios.eof then%>
																													
																													<%if articulos("compromiso_compra")="NO" then%>
																													
																														<table width="100%" cellpadding="0" cellspacing="0" border="0" style="border:2px solid">
																															<tr>
																																<td colspan="2" style="border-bottom:1pt solid"><b>Of. con Tipo Precio <%=tabla_tipos_precios(0,i)%></b></td>
																																
																															</tr>
																															<tr>
																																<td style="border-bottom:1pt solid">Cantidad</td>
																																<td style="border-left:1pt solid;border-bottom:1pt solid">Precio Pack</td>
																															</tr>
																															
																															<%filas=1
																															'cantidades_precios.movelast
																															'cantidades_precios.movefirst
																															numero_filas=cantidades_precios.recordcount
																															while not cantidades_precios.eof%>
																															
																																<%
																																cantidades_precio_total_articulo=""
																																cantidades_precio_total_articulo=cantidades_precios("cantidad") & "--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																																%>
																																<tr id="fila_<%=articulos("id")%>_<%=filas%>_<%=tabla_tipos_precios(0,i)%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila_admin('<%=tabla_tipos_precios(0,i)%>',<%=articulos("id")%>,<%=filas%>,<%=(numero_filas+1)%>,'<%=cantidades_precio_total_articulo%>','NO')">
																																	<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																																	<td style="border-bottom:1pt solid" align="right"><%=cantidades_precios("cantidad")%>&nbsp;</td>
																																	<td style="border-left:1pt solid;border-bottom:1pt solid" align="right">
																																		<%
																																			IF cantidades_precios("precio_pack")<>"" then
																																				Response.Write(FORMATNUMBER(cantidades_precios("precio_pack"),2) & " €")
																																			  else
																																				Response.Write("")
																																			end if
																																		%>
																																		&nbsp;
																																	</td>
																																</tr>
																																<%
																																filas=filas+1
																																cantidades_precios.movenext%>
																															<%wend%>
																															<tr id="fila_<%=articulos("id")%>_<%=filas%>_<%=tabla_tipos_precios(0,i)%>"  style="cursor:hand;cursor:pointer"  onclick="seleccionar_fila_admin('<%=tabla_tipos_precios(0,i)%>',<%=articulos("id")%>,<%=filas%>,<%=numero_filas%>,'OTRAS CANTIDADES')">
																																<td colspan="2">Otras Cantidades</td>
																																	
																															</tr>
																														</table>
																													  <%else%>
																													  
																													  	<table width="100%" cellpadding="0" cellspacing="0" border="0" style="border:2px solid">
																															<tr>
																																<td colspan="2" style="border-bottom:1pt solid"><b>Of. con Tipo Precio <%=tabla_tipos_precios(0,i)%></b></td>
																																
																															</tr>
																															<tr>
																																<td style="border-bottom:1pt solid">Cantidad</td>
																																<td style="border-left:1pt solid;border-bottom:1pt solid">Precio Unid.</td>
																															</tr>
																															
																															<%filas=1
																															'cantidades_precios.movelast
																															'cantidades_precios.movefirst
																															numero_filas=cantidades_precios.recordcount
																															while not cantidades_precios.eof%>
																															
																																<%
																																'como son articulos con compromiso de compra, la cantidad no es fija, tienen que indicarla
																																cantidades_precio_total_articulo=""
																																cantidades_precio_total_articulo="XXX--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																																%>
																																<tr id="fila_<%=articulos("id")%>_<%=filas%>_<%=tabla_tipos_precios(0,i)%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila_admin('<%=tabla_tipos_precios(0,i)%>',<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','SI')">
																																	<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																																  <td height="25" align="right" style="border-bottom:1pt solid">&nbsp;</td>
																																	<td style="border-left:1pt solid;border-bottom:1pt solid" align="right">
																																		<%
																																			IF cantidades_precios("precio_unidad")<>"" then
																																				Response.Write(cantidades_precios("precio_unidad") & " €/u")
																																			  else
																																				Response.Write("")
																																			end if
																																		%>
																																		&nbsp;
																																	</td>
																																</tr>
																																<%
																																filas=filas+1
																																cantidades_precios.movenext%>
																															<%wend%>
																															
																														</table>
																													<%end if%>
																													  
																												<%end if%>
																												<%
																												cantidades_precios.close
																												set cantidadese_precios=Nothing
																												%>
																												</span><br />

																											  <%  next%>
																											  <%end if%>
																												
																											</td>
																											<td width="2%" valign="top" class="divider-vertical2"></td>
																											<td width="34%" valign="top" class="info_column">
																												<table border="0" cellspacing="0" cellpadding="0" class="input_table" >
																													<tr>
																														<td valign="top">             
																															<a href="#nogoto" onclick="muestra('informacion_<%=articulos("ID")%>')" class="btn-details">+ información</a>
																														</td>
																													</tr>
																												
																													<tr>
																														<td valign="top"> 
																															            
																															
																														</td>
																													</tr>
																												</table>
																											</td>
																										</tr>
																										<%if articulos("unidades_de_pedido")<>"" then%>
																											<tr><td colspan="3">
																												<b>Unidades de Pedido:</b> <%=articulos("unidades_de_pedido")%>
																												<br />
																												<b>Stock:</b> <%=articulos("stock")%>
																												</td>
																											</tr>
																										<%end if%>
																									</table>
																								</div>
																								<span class="cb"></span>
																							</td>
																						</tr>
																					</tbody>
																				</table>
																				
																			</td>
																		</tr>
																	</tbody>
																</table>
													  </td>
												  </tr>
											  </tbody>
										  </table>
									  </td>
								  </tr>
							  </tbody>
						  </table>
					  </div>
					</td>
						<!--Final del Articulo-->
						
				</tr>	
				<%articulos.movenext%>	
				<%wend%>
				
				
			  </table>
			</div>
			</div>

	</td>
</tr>

</table>

<form name="frmannadir_al_carrito" id="frmannadir_al_carrito" action="Annadir_Articulo_Atesa.asp?acciones=<%=acciones%>" method="post">
	<input type="hidden" name="ocultoarticulo" id="ocultoarticulo" value=""/>
	<input type="hidden" name="ocultocantidades_precios" id="ocultocantidades_precios" value="" />
</form>


				<!-- END SHOPPAGE_HEADER.HTM -->

</body>
<%
	articulos.close
	
	connimprenta.close
			  
			
	set articulos=Nothing
	
	set connimprenta=Nothing
%>
</html>

