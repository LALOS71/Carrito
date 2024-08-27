<%@ language=vbscript %>
<!--#include file="../../Data/Conexiones/Conexion_Gldistri.inc"-->
<%
		
		
		'recordsets
		dim articulos
		
		set articulos=Server.CreateObject("ADODB.Recordset")
		
		sql="Select *  from articulos"
		sql=sql & " where familia = 52"
		sql=sql & " and empresa = 1" 
		sql=sql & " and Descripcion <> ''"
		sql=sql & " and Mostrar_Intranet='SI'"
		sql=sql & " and Activo = 1"
		sql=sql & " order by Descripcion"
		with articulos
			.ActiveConnection=conndistribuidora
			.Source=sql
			.Open
		end with
		
		
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
<title>Carrito Imprenta</title>
<link href="estilos.css" rel="stylesheet" type="text/css" />
</head>
<body>

<div id="main">
<div id="center_newproducts__title_28" class="main-product">
<h2>Productos Barceló</h2>
<table width="900" class="product-wrapper">
	<tr>
		<%articulos_por_fila=1
		while not articulos.eof%>
		<!--inicio del articulo-->
		<td class="vt ac" width="33%">
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
																				<td class="prod_border_td"> 
 																					<!--<div class="image">-->
																					<center>
																						<table border="0" width="100">
																							<tr>
																								<td valign="middle" align="center">
 																									<a href="#" onclick="alert('en construccion')">
																									<img class="product_thumbnail" src="../../apps_intranet/administracion/distribuidora/Imagenes_Articulos/<%=articulos("cod")%>.jpg" border="0">
																									</a>
																								</td>
																							</tr>
																						</table>
																					</center>
																					<!--</div>-->
																					<h3><%=articulos("descripcion")%></h3>
																					<div>Descripción que queramos poner....<br /></div>
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
																												<a href="#" onclick="alert('en construccion')" class="btn-details">+ información</a>
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
		<%articulos.movenext%>	
		<%if articulos.eof then%>
			</tr>
		<%else%>
			<%if articulos_por_fila=3 then%>
				<%articulos_por_fila=1%>
				</tr>
			<%else%>
				<%articulos_por_fila=articulos_por_fila + 1%>
			<%end if%>
			
		<%end if%>
		<%wend%>	
			
	  </tr>
	
	
	
	
	</table>
</div>
</div>





















</body>
<%
	articulos.close
	conndistribuidora.close
			  
			
	set articulos=Nothing
	set conndistribuidora=Nothing
%>
</html>
