<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<%
		if session("usuario")="" then
			Response.Redirect("../Login_ATESA.asp")
		end if
		
		'recordsets
		dim articulos
		dim datos_cliente
		
		'variables
		dim sql
		
	    set articulos=Server.CreateObject("ADODB.Recordset")
		'si entra para modificar un pedido existente
		accion=Request.Form("ocultoaccion")
		if accion="" then
			'aqui viene la accion junto con el pedido y la fecha "MODIFICAR--88--fecha--codigo cliente--codigo externo cliente--nombre cliente"
			acciones=Request.QueryString("acciones")
			'response.write("<br>acciones: " & acciones)
			if acciones<>"" then
				tabla_acciones=Split(acciones,"--")
				accion=tabla_acciones(0)
				pedido_modificar=tabla_acciones(1)
				fecha_pedido=tabla_acciones(2)
				hotel_admin=tabla_acciones(3)
				codigo_externo_modificacion=tabla_acciones(4)
				nombre_modificacion=tabla_acciones(5)
			end if
		end if
		if Request.Form("ocultopedido_modificar")<>"" then
			pedido_modificar=Request.Form("ocultopedido_modificar")
		end if
		if Request.Form("ocultofecha_pedido")<>"" then
			fecha_pedido=Request.Form("ocultofecha_pedido")
		end if
		if Request.Form("ocultohotel")<>"" then
			hotel_admin=Request.Form("ocultohotel")
		end if
		
		'es la primera vez que entro a modificarlo
		if nombre_modificacion="" then
				set datos_cliente=Server.CreateObject("ADODB.Recordset")
				with datos_cliente
					.ActiveConnection=connimprenta
					.Source="SELECT * FROM V_CLIENTES WHERE ID=" & hotel_admin
					'response.write("<br>" & .source)
					.Open
				end with
				if not datos_cliente.eof then
					codigo_externo_modificacion=datos_cliente("codigo_externo")
					nombre_modificacion=datos_cliente("nombre")
				end if
				datos_cliente.close
				set datos_cliente=Nothing
		end if
		
		cadena_acciones=accion & "--" & pedido_modificar & "--" & fecha_pedido & "--" & hotel_admin & "--" & codigo_externo_modificacion & "--" & nombre_modificacion


'Recogemos la variable borrar 
borrar=Request.Querystring("borrar")
'RESPONSE.WRITE("<BR>HAY QUE QUITAR EL ARTICULO CON CODIGO: " & BORRAR)

If borrar<>"" Then 'Si se ha pedido el borrado de un articulo
	i=1
	Do While borrar<>Session(i)
		'RESPONSE.WRITE("<BR>SESSION(" & i & "): " & session(i))
		i=i+1
	Loop
	'response.write("<br>y ahora tenemos que mover unos articulos sobre otros... Hay " & Session("numero_articulos") & " articulos en el pedido")
	For j=i to Session("numero_articulos")
		'RESPONSE.WRITE("<BR>SESSION(" & j & "): " & session(j) & " contendrá a SESSSION(" & j+1 & "): " & session(j+1))
		Session(j)=Session(j+1)
		'RESPONSE.WRITE("<BR>SESSION(" & j & "_cantidades_precios): " & session(j & "_cantidades_precios") & " contendrá a SESSSION(" & j+1 & "_cantidades_precios): " & session(j+1 & "_cantidades_precios"))
		Session(j & "_cantidades_precios")=Session((j+1) & "_cantidades_precios")
		Session(j & "_fichero_asociado")=Session((j+1) & "_fichero_asociado")
		
	Next
	Session("numero_articulos")=Session("numero_articulos")-1
		
	'response.write("<br>y al final quedan " & Session("numero_articulos") & " articulos en el pedido")
	'response.write("<br><br>ahora vemos como ha quedado despues de borrar")
	'For j=1 to Session("numero_articulos")
		'RESPONSE.WRITE("<BR>SESSION(" & j & "): " & session(j)) 
		'RESPONSE.WRITE("<BR>SESSION(" & j & "_cantidades_precios): " & session(j & "_cantidades_precios"))
	'Next
		
End if

'Si no quedan articulos en el carrito despues del borrado
cadena="Lista_Articulos_Atesa_Central_Admin.asp"
If Session("numero_articulos")= 0 Then
	'history.back()
	'Response.Redirect("bottom.asp")
end if


%>
<html>
<head>
<link href="../estilos.css" rel="stylesheet" type="text/css" />
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

<script language="javascript">
function cambiacomaapunto (s)
{
	var saux = "";
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ",")
			saux = saux + ".";
		else
			saux = saux + s.charAt (j);
	}
	return saux;
}

// una vez calculado el resultado tenemos que volver a dejarlo como es devido, con la coma
//    representando los decimales y no el punto
function cambiapuntoacoma(s)
{
	var saux = "";
	//alert("pongo coma")
	//alert("tamaño: " + s.legth)
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ".")
			saux = saux + ",";
		else
			saux = saux + s.charAt (j);
		//alert("total: " + saux)
	}
	return saux;
}

// ademas redondeamos a 2 decimales el resultado
function redondear (v){
	var vaux;
	vaux = Math.round (v * 100);
	vaux =  vaux / 100;
	return  vaux;
}

	
   function mover_formulario(objetivo)
   {
   	if (objetivo=='volver')
   		accion='Lista_Articulos_Atesa_Central_Admin.asp'
	  else
	  	accion='Grabar_Pedido_Atesa_Central_Admin.asp';
	document.getElementById('frmpedido').action=accion
	document.getElementById('frmpedido').submit()	
}
   	
function validar(pedido_minimo, total_pedido)
{
	if (pedido_minimo>total_pedido)
		{
			//alert('pedido minimo: ' + pedido_minimo + ' ... total pedido: ' + total_pedido)
			respuesta=confirm('El Pedido Tramitado no llega al importe mínimo con lo que se cobrarán gastos de envio\n\nPulse "Aceptar" para Tramitar el Pedido o "Cancelar" para añadir mas productos al Pedido')
			//alert('respuesta: ' + respuesta)
			if (respuesta)
				{
				document.getElementById('frmpedido').submit()
				}
			  else //redirigimos para que siga pidiendo articulos
			  	{
				location.href='Lista_Articulos_Atesa_Central_Admin_Pedir.asp?acciones=<%=cadena_acciones%>'
				}
		}
	  else
	  	{
			document.getElementById('frmpedido').submit()
		}
}
</script>
</head>
<body onload="">
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
	<td width="713" valign="top">
		<div id="main">
				
				<div class="comment_title fontbold">Detalle del Pedido
				<%if accion="MODIFICAR" THEN%>
					&nbsp;-- Modificando Pedido <%=pedido_modificar%> de la sucursal (<%=codigo_externo_modificacion%>) - <%=nombre_modificacion%>
					<%=texto_cliente%>
				<%end if%>
				</div>
				<div class="comment_text"> 
					<form name="frmpedido" id="frmpedido" action="Grabar_Pedido_Atesa_Central_Admin.asp" method="post"  enctype="multipart/form-data">
						<input type="hidden" name="ocultoacciones" id="ocultoacciones" value="<%=cadena_acciones%>" />
						
					  <table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table">
                        <tr style="background-color:#FCFCFC" valign="top">
                          <th class="menuhdr">Cod. Sap</th>
                          <th class="menuhdr">Artículo</th>
                          <th class="menuhdr">Cantidad</th>
                          <th class="menuhdr">Precio/u</th>
                          <th class="menuhdr">Total</th>
                        </tr>
                        <%if Session("numero_articulos")=0 then%>
                        <tr>
                          <td bgcolor="#999966" align="center" colspan="8"><b><font class="fontbold">El Pedido No Tiene Articulos...</font></b><br />
                          </td>
                        </tr>
                        <%end if%>
                        <%
							'Iniciamos las variables
							i=1 'contador de articulos
							'Session("total")=0 'precio del pedido
							total_pedido=0
							compromiso_compra_pedido="SI"
							control_compromiso_compra_pedido="SI"
							
							'Comenzamos la impresion de los articulos del carrito
							While i<=Session("numero_articulos")
								id=Session(i)
								cantidades_precios_id=Session(i & "_cantidades_precios")
								calculos_cantidades_precios=split(cantidades_precios_id,"--")
								'multiplico la cantidad por el precio y rendondeo a 2 decimales
								'total_id=round(calculos_cantidades_precios(0) * calculos_cantidades_precios(1), 2)
								'response.write("<br>posicion: " & i & " ...Articulo: " & id & " cantidades_precios: " & cantidades_precios_id)
								'response.write("<br>Articulo: " & id & " cantidades_precios: " & cantidades_precios_id)
								
								sql="SELECT ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION, ARTICULOS.COMPROMISO_COMPRA,"
								sql=sql & " V_EMPRESAS.CARPETA, ARTICULOS_EMPRESAS.CODIGO_EMPRESA "
								sql=sql & " FROM ARTICULOS INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO"
								sql=sql & " INNER JOIN V_EMPRESAS ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA = V_EMPRESAS.Id"
								sql=sql & " WHERE ARTICULOS.ID=" & id
								'response.write("<br>" & sql)
								
							
											with articulos
												.ActiveConnection=connimprenta
												.Source=sql
												'.source="SELECT ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION as articulo from articulos"
												'response.write("<br>" & .source)
												.Open
											end with
											'SI TODOS LOS ARTICULOS DEL PEDIDO, SON COMPROMISMO DE COMPRA, EL IMPORTE MINIMO SON 199 O 101
											' PERO EN CUANTO HAYA ALGUN ARTICULO SIN COMPROMISO DE COMPRA, EL IMPORTE MINIMO HA DE SER 300
											'response.write("<br>sap: " & articulos("codigo_sap"))
											'response.write("<br>desc: " & articulos("descripcion"))
											'response.write("<br>compromiso compra: " & articulos("compromiso_compra"))
											if articulos("compromiso_compra")="NO" then
												compromiso_compra_pedido="NO"
												'en cuanto hay un articulo sin compromiso de compra
												' el limite del importe del pedido sube...
												control_compromiso_compra_pedido="NO"
												colorcin="#FCFCFC"
											  else
											  	compromiso_compra_pedido="SI"
											  	colorcin="#FFFFCC"
											end if
							
						%>
                        <tr valign="top">
                          <td class="ac item_row" width="64" align="right" style="background-color:<%=colorcin%>">
						  	<a href="../Imagenes_Articulos/<%=id%>.jpg" target="_blank">
								<%=articulos("CODIGO_SAP")%>
							</a>
						  
						  
						  </td>
                          <td class="item_row" style="text-align:left; background-color:<%=colorcin%>" width="257"><%=articulos("DESCRIPCION")%>
						  
						   
						  </td>
                          <td width="77" class="ac item_row" style="background-color:<%=colorcin%>">
						  	<input type="hidden" name="ocultocantidad_<%=id%>" id="ocultocantidad_<%=id%>" value="<%=calculos_cantidades_precios(0)%>">
							<%=calculos_cantidades_precios(0)%>
						  </td>
                          <td class="ac item_row" width="66" style="background-color:<%=colorcin%>">
						  	<input type="hidden" name="ocultoprecio_<%=id%>" id="ocultoprecio_<%=id%>" value="<%=calculos_cantidades_precios(1)%>">
							<%if compromiso_compra_pedido="SI" then%>
								<%=calculos_cantidades_precios(1)%> €/u
							  <%else%>
							  				
							  	<%response.write("")%>			  		
							<%end if%>
						  </td>
                          <td class="ac item_row" width="70" style="background-color:<%=colorcin%>;text-align:right">
						  		<%
									if compromiso_compra_pedido="SI" then
										resultado=cdbl(replace(calculos_cantidades_precios(0),".",",")) * cdbl(replace(calculos_cantidades_precios(1),".",","))
									  else
									  	resultado=cdbl(replace(calculos_cantidades_precios(2),".",","))
									end if
									Response.write(resultado & " €") 
									'response.write("<br>cantidad: " & calculos_cantidades_precios(0) & " precio unidad: " & calculos_cantidades_precios(1) & " total Pack: " & calculos_cantidades_precios(2))
									'response.write("<br>cantidad*precio unidad: " & cdbl(replace(calculos_cantidades_precios(0),".",","))*cdbl(replace(calculos_cantidades_precios(1),".",",")))
									
									'response.write("<br>resultado: " & resultado & " total pedido: " & total_pedido)
									'response.write("<br>resultado: " & replace(resultado,",",".") & " total pedido: " & total_pedido)
									'response.write("<br>resultado: " & cdbl(cstr(resultado)) & " total pedido: " & total_pedido)
									'response.write("<br>compromiso compra: " & compromiso_compra_pedido)
									total_pedido=total_pedido + resultado
									'total_pedido=total_pedido + cdbl(replace(resultado,",","."))
									
								%>
								<input type="hidden" name="ocultototal_<%=id%>" id="ocultototal_<%=id%>" value="<%=resultado%>">
                          </td>
                          <td class="item_row" style="text-align:right; background-color:<%=colorcin%>" width="67" valign="middle">
						  	<table width="76" height="26"  border="0" cellpadding="0" cellspacing="0"  style="border:1px solid">
                              <tr>
                                <td  style="background-color:<%=colorcin%>"><img src="../images/Eliminar.png" border="0" height="16" width="16" /></td>
                                <td style="background-color:<%=colorcin%>" class="item_row"><a href="Carrito_Atesa_Central_Admin.asp?borrar=<%=id%>&acciones=<%=cadena_acciones%>" class="fontbold">Quitar</a></td>
                              </tr>
                          </table></td>
                        </tr>
						<%if accion="MODIFICAR" then%>
							<%'ahora nos dicen que solo tienen fichero de personalizacion 
							  '    los que no tienen compromiso de compra
							  '08-05-2014, ahora tambien pueden subir ficheros para las tarjetas de visita
							  '    codigos 564 y 565 en el entorno de pruebas
							  '    y codigos 797 y 887 en el entorno real
								if compromiso_compra_pedido="NO" or id=797 or id=887 then%>
							<%if session(i & "_fichero_asociado")<>"" then%>
							<TR style="background-color:<%=colorcin%>" >
								<td class="item_row" colspan=5 style="background-color:<%=colorcin%>;text-align:right">
									<table width="387" border="0" align="right" cellpadding="0" cellspacing="0" style="background-color:<%=colorcin%>">
										<tr>
											<td width="249" style="background-color:<%=colorcin%>">
												<table width="219px"  border="0" cellpadding="0" cellspacing="0" style="border:1px solid;display:none" id="fila_fichero_<%=id%>">
													<tr>
														<td align="center" >Fichero para Personalizar el Artículo:</td>
															
													</tr>
													<tr>
														<TD>
																<input type="file" name="txtfichero_<%=id%>" id="txtfichero_<%=id%>" value="">
														</td>
													</tr>
											  	</table>
												<table width="219"  border="0" cellpadding="0" cellspacing="0" style="border:1px solid" id="fila_fichero_existente_<%=id%>">
													<tr>
														<td width="88%">Fichero para Personalizar el Artículo:</td>
														<td width="12%"><a href="pedidos/<%=year(fecha_pedido)%>/<%=hotel_admin%>__<%=pedido_modificar%>/<%=session(i & "_fichero_asociado")%>" target="_blank"><img src="../images/clip-16.png" border=0 /></a></td>
													</tr>
										  	  </table>
												 
												
									
											</td>
											<td width="138" style="background-color:<%=colorcin%>">
												<table width="132" border="0" cellpadding="0" cellspacing="0" style="border:1px solid">
													<tr>
														<td width="16%"><img src="../images/icono_modificar.png" border="0" height="16" width="16" /></td>
														<td width="84%"><a href="#" onclick="document.getElementById('fila_fichero_<%=id%>').style.display='block';document.getElementById('fila_fichero_existente_<%=id%>').style.display='none'" class="fontbold">Modificar Fichero</a></td>
													</tr>
											  </table>
											
											</td>
										</tr>
								  </table>
								

								</td>
							</TR>
							<%else%>	
								<tr>
								<td class="item_row" colspan=5 style="background-color:<%=colorcin%>;text-align:right">
									Fichero para Personalizar el Artículo:
								
									<input type="file" name="txtfichero_<%=id%>" id="txtfichero_<%=id%>" value="">
								</td>
								</tr>
							<%end if%>
							<%end if%>
  						  <%else%>
							<%'ahora nos dicen que solo tienen fichero de personalizacion 
							  '    los que no tienen compromiso de compra
							  '08-05-2014, ahora tambien pueden subir ficheros para las tarjetas de visita
							  '    codigos 564 y 565 en el entorno de pruebas
							  '    y codigos 797 y 887 en el entorno real
								if compromiso_compra_pedido="NO" or id=797 or id=887 then%>
							<tr>
								<td class="item_row" colspan=5 style="background-color:<%=colorcin%>;text-align:right">
									Fichero para Personalizar el Artículo:
								
									<input type="file" name="txtfichero_<%=id%>" id="txtfichero_<%=id%>" value="">
								</td>
							</tr>
							<%end if%>
						<%end if%>
						<TR  >
							<td class="item_row" colspan=5 style="background-color:<%=colorcin%>;text-align:right">
								

							</td>
						</TR>
						<TR >
							<td height="2" class="item_row" colspan=5 style="background-color:<%=colorcin%>; border-top-width:1px; border-top-style:dashed;">
								

							</td>
						</TR>
                        <%		
							i=i+1
							articulos.close
						Wend
						
						%>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
						  <th class="menuhdr" colspan=2>Total</th>
                          <th style="text-align:right"><%=total_pedido%> €</th>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
						  
                          <th class="menuhdr" colspan=2>Pedido Mínimo</th>
                          <th style="text-align:right">
						   	<%
							if control_compromiso_compra_pedido="NO" then
                              	pedido_minimo_permitido=session("usuario_pedido_minimo_sin_compromiso")
      						else
								pedido_minimo_permitido=session("usuario_pedido_minimo_con_compromiso")
							end if
							response.write(pedido_minimo_permitido & " €")
							%>
                          </th>
                        </tr>
                      </table>
					  <br />
					</form>
				</div>
		  <div class="submit_btn_container">
					<table width="95%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td width="17%">
							
								
								<table border="0" cellpadding="0" cellspacing="0" width="100%" class="btn-details">
									<tr>
										<td width="26%"><img src="../images/Annadir.png" border="0" height="14" width="14" /></td>
										<td width="74%"><a href="Lista_Articulos_Atesa_Central_Admin_Pedir.asp?acciones=<%=cadena_acciones%>"><font color="#FFFFFF">Continuar</font></a></td>
									</tr>
								</table>
								
							</td>
							<td width="17%">
								
								<table border="0" cellpadding="0" cellspacing="0" width="100%" class="btn-details">
									<tr>
										<td width="26%"><img src="../images/Guardar.png" border="0" height="14" width="14" /></td>
										<td width="74%"><a href="#" onclick="validar(<%=pedido_minimo_permitido%>,<%=total_pedido%>);return false"><font color="#FFFFFF">Confirmar</font></a></td>
									</tr>
								</table>
								
							</td>
							<td width="66%">
								
							</td>
						</tr>
					</table>
		  </div>
		</div>
	</td>
  </tr>
</table>

</body>
<%
	'articulos.close
	
	connimprenta.close
	
	set articulos=Nothing
	
	set connimprenta=Nothing

%>
</html>
