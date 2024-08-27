<%@ language=vbscript %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		
		
		'recordsets
		dim articulos
		
		

		set articulos=Server.CreateObject("ADODB.Recordset")
		
		sql="Select *  from articulos"
		'sql=sql & " where familia = 52"
		'sql=sql & " and empresa = 1" 
		'sql=sql & " and Descripcion <> ''"
		'sql=sql & " and Mostrar_Intranet='SI'"
		'sql=sql & " and Activo = 1"
		sql=sql & " order by Orden"
		'sql=sql & " order by Descripcion"
		
		with articulos
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
		
		
		
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
<title>Carrito Imprenta</title>
<link href="estilos.css" rel="stylesheet" type="text/css" />

<script src="funciones.js" type="text/javascript"></script>
</head>
<body>

<table>
<tr>
	<td width="218" valign="top">
		<div class="sidebarcell">
			
			<div id="side_freetext_title_39" class="title">
				<br />
				<font size="3"><b>Datos del Hotel</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					<b>Hotel de Pruebas</b>
					<br />
					C/ Gran Via 33
					<br /> 
					37004 Salamanca
					<br />
					Salamanca
					<br />
					
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
						<span class='fontbold'>Busqueda de Productos Barceló</span>
					</td>
				</tr>
				<tr>
					<td width="50%" class="dottedBorder vt al">
						
	  
						<form name="frmbusqueda" method="post" action="Lista_Articulos.asp">
							<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Código Sap: </td>
									<td width="20%"><input class="txtfield" size="14" name="txtcodigo_sap" /></td>
									<td width="13%">Descripción: </td>
									<td width="42%"><input class="txtfield" size="44" name="txtdescripcion" /></td>
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
				<%while not articulos.eof%>
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
																												<a href="Imagenes_Articulos/<%=articulos("codigo_sap")%>.jpg" target="_blank">
																													<img class="product_thumbnail" src="Imagenes_Articulos/Miniaturas/i_<%=articulos("codigo_sap")%>.jpg" border="0">
																												</a>
																											</td>
																										</tr>
																										<tr><td height="3"></td></tr>
																									</table>
																								</center>
																								<!--</div>-->
																							</td>
																							<td width="58%" class="prod_border_td">
																								
																								<table border="0" cellpadding="0" cellspacing="0" width="100%">
																									<tr>
																										<td><h3><%=articulos("descripcion")%></h3></td>
																									</tr>
																									<tr>
																										<td><div align="left"><b>Codigo Sap:</b> <%=articulos("codigo_sap")%><br /></div></td>
																									</tr>
																									<tr>
																										<td>
																											<div align="left" style="display:none" id="informacion_<%=articulos("codigo_sap")%>">
																												<b>Tamaño:</b> <%=articulos("tamanno")%><br />
																												<b>Tamaño Abierto:</b> <%=articulos("tamanno_abierto")%><br />
																												<b>Tamaño Cerrado:</b> <%=articulos("tamanno_cerrado")%><br />
																												<b>Papel:</b> <%=articulos("papel")%><br />
																												<b>Tintas:</b> <%=articulos("tintas")%><br />
																												<b>Acabado:</b> <%=articulos("acabado")%><br />
																												<b>Fecha:</b> <%=articulos("fecha")%><br />&nbsp;
																											</div>
																										</td>
																									</tr>
																								
																								</table>
																								
																								<div class="info">
																									<table width="100%" >
																										<tr>
																											<td width="50%" class="info_column">         
																												<span class="fontbold">US$5.00</span><br />
																											</td>
																											<td valign="top" class="divider-vertical2"></td>
																											<td valign="top" class="info_column">
																												<table border="0" cellspacing="0" cellpadding="0" class="input_table" >
																													<tr>
																														<td valign="top">             
																															<a href="#nogoto" onclick="muestra('informacion_<%=articulos("codigo_sap")%>')" class="btn-details">+ información</a>
																														</td>
																													</tr>
																												</table>
																											</td>
																										</tr>
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




				<!-- END SHOPPAGE_HEADER.HTM -->

</body>
<%
	articulos.close
	connimprenta.close
			  
			
	set articulos=Nothing
	set connimprenta=Nothing
%>
</html>
