<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
	response.Buffer=true
	numero_registros=0
		
	if session("usuario_admin")="" then
		Response.Redirect("Login_Admin.asp")
	end if
	'response.write("procedencia: " & request.servervariables("http_referer"))
	empresa_seleccionada=Request.Form("cmbempresas")
	familia_seleccionada=Request.Form("cmbfamilias")
	codigo_sap_seleccionado=Request.Form("txtcodigo_sap")
	descripcion_seleccionada=Request.Form("txtdescripcion")
	campo_autorizacion=Request.Form("cmbautorizacion")
	campo_eliminado=Request.Form("cmbeliminado")
	ejecutar_consulta=Request.Form("ocultoejecutar")
		
		
		
		
	'recordsets
	dim empresas
		
		
	'variables
	dim sql
		

set empresas=Server.CreateObject("ADODB.Recordset")
	CAMPO_ID_EMPRESA=0
	CAMPO_EMPRESA_EMPRESA=1
	CAMPO_CARPETA_EMPRESA=2
	with empresas
		.ActiveConnection=connimprenta
		.Source="SELECT V_EMPRESAS.ID, V_EMPRESAS.EMPRESA, V_EMPRESAS.CARPETA"
		.Source= .Source & " FROM V_EMPRESAS"
		.Source= .Source & " ORDER BY EMPRESA"
		.Open
		vacio_empresas=false
		if not .BOF then
			mitabla_empresas=.GetRows()
			else
			vacio_empresas=true
		end if
	end with

	empresas.close
	set empresas=Nothing


	set articulos=Server.CreateObject("ADODB.Recordset")
	CAMPO_ID_ARTICULO=0
	CAMPO_CODIGO_SAP_ARTICULO=1
	CAMPO_EMPRESA_ARTICULO=2
	CAMPO_NOMBRE_EMPRESA_ARTICULO=3
	CAMPO_DESCRIPCION_ARTICULO=4
	CAMPO_CARPETA_ARTICULO=5
	CAMPO_MOSTAR_ARTICULO=6
	CAMPO_AUTORIZACION_ARTICULO=7
		
	with articulos
		.ActiveConnection=connimprenta
		.Source="SELECT ARTICULOS.ID, ARTICULOS.CODIGO_SAP, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, V_EMPRESAS.EMPRESA, "
		.Source= .Source & " ARTICULOS.DESCRIPCION, V_EMPRESAS.CARPETA, ARTICULOS.MOSTRAR, ARTICULOS.REQUIERE_AUTORIZACION "
		.Source= .Source & " FROM ARTICULOS INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO "
		.Source= .Source & " INNER JOIN V_EMPRESAS ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA=V_EMPRESAS.ID "
		.Source= .Source & " WHERE 1=1"
		if campo_eliminado<>"" then
			.Source= .Source & " AND BORRADO='" & campo_eliminado & "' "
		end if
		if codigo_sap_seleccionado<>"" then
			.Source= .Source & " AND ARTICULOS.CODIGO_SAP LIKE '%" & codigo_sap_seleccionado & "%'"
		end if
		if empresa_seleccionada<>"" then
			.Source= .Source & " AND ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & empresa_seleccionada
		end if
		if familia_seleccionada<>"" then
			.Source= .Source & " AND ARTICULOS.ID IN (SELECT ID_ARTICULO FROM ARTICULOS_EMPRESAS WHERE CODIGO_EMPRESA = " & empresa_seleccionada
			.Source= .Source & " AND FAMILIA = " & familia_seleccionada & ")"
		end if
		if descripcion_seleccionada<>"" then
			.Source= .Source & " AND ARTICULOS.DESCRIPCION LIKE '%" & descripcion_seleccionada & "%'"
		end if
			
			
		'para que no muestre toda la lista de articulos si no se selecciona nada
		'if empresa_seleccionada="" and codigo_sap_seleccionado="" and descripcion_seleccionada="" and campo_eliminado="NO" and campo_autorizacion="" then
		if ejecutar_consulta<>"SI" then
			.Source= .Source & " AND ARTICULOS.ID=0"
		end if
			
		if campo_autorizacion<>"" then
			.Source= .Source & " AND ARTICULOS.REQUIERE_AUTORIZACION='" & campo_autorizacion & "'"
		end if
			
		.Source= .Source & " ORDER BY ARTICULOS.DESCRIPCION"
			
		'response.write(.source)
		.Open
		vacio_articulos=false
		if not .BOF then
			mitabla_articulos=.GetRows()
			else
			vacio_articulos=true
		end if
	end with

	articulos.close
	set articulos=Nothing

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
		
		
		
	#capa_opaca {
	position:absolute;
	color: black;
	background-color: #C0C0C0;
	left: 0px;
	top: 0px;
	width: 100%;
	height: 100%;
	z-index: 1000;
	text-align: center;
	visibility: visible;
	filter:alpha(opacity=40);
	-moz-opacity:.40;
	opacity:.40;
}

.aviso {
	font-family: Verdana, Arial, Helvetica, sans-serif;
  	font-size: 18px;
  	color: #000000;
  	text-align: center;
	background-color:#33FF33
}  	

#contenedorr3 { 


/* Otros estilos */ 
border:1px solid #333;
background:#eee;
padding:15px;
width:500px;

margin: 250px auto;

-moz-border-radius: 20px; /* Firefox */
-webkit-border-radius: 20px; /* Google Chrome y Safari */
border-radius: 20px; /* CSS3 (Opera 10.5, IE 9 y estándar a ser soportado por todos los futuros navegadores) */
/*
behavior:url(border-radius.htc);/* IE 8.*/

}


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
   		accion='Lista_Articulos.asp'
	  else
	  	accion='Grabar_Pedido.asp';
	document.getElementById('frmpedido').action=accion
	document.getElementById('frmpedido').submit()	
	

   }
   	

function mostrar_articulo(articulo,accion)
   {
   	//alert('hotel: ' + hotel + ' accion: ' + accion)
   	document.getElementById('ocultoid_articulo').value=articulo
	document.getElementById('ocultoaccion').value=accion
   	document.getElementById('frmmostrar_articulo').submit()	
	

   }

</script>

<script type="text/javascript"> 
function refrescar_pagina()
{
	//alert(document.getElementById("cmbempresas").value)
	Actualizar_Combos('Obtener_Familias.asp',document.getElementById("cmbempresas").value, '<%=familia_seleccionada%>','capa_familias')
	
	
}



</script> 
<script language="javascript" src="Funciones_Ajax.js"></script>

<script src="DD_roundies_0_0_2a.js"></script>
<script language="javascript">
function mostrar_capas(capa)
{
	//redondear capa para el internet explorer
	DD_roundies.addRule('#contenedorr3', '20px');
	document.getElementById('capa_opaca').style.display=''
	document.getElementById(capa).style.display='';
}

function cerrar_capas(capa)
{	
	document.getElementById('capa_opaca').style.display='none';
	document.getElementById(capa).style.display='none';
}
</script>


</head>
<body onload="refrescar_pagina()">
<!-- capa opaca para que no deje pulsar nada salvo lo que salga delante (se comporte de forma modal)-->
<div id="capa_opaca" style="display:none;background-color:#000000;position:fixed;top:0px;left:0px;width:105%;min-height:110%;z-index:5;filter:alpha(opacity=50);-moz-opacity:.5;opacity:.5">
</div>

<!-- capa con la informacion a mostrar por encima-->
<div id="capa_informacion" style="display:none;z-index:6;position:fixed;width:100%; height:100%">
		<div id="contenedorr3" class="aviso">
			<p>
				<img src="images/loading4.gif"/>
					<br /><br />
					Espere mientras se carga la página...
			</p>
		</div>
		

</div>
<script language="javascript">
mostrar_capas('capa_informacion')
</script>



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
				<font size="3"><b>Mantenimientos</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					· <a href="Consulta_Pedidos_Admin.asp">Pedidos</a><br />
					· <a href="Consulta_Articulos_Admin.asp">Artículos</a><br />
					· <a href="Consulta_Clientes_Admin.asp">Clientes</a><br />
					· <a href="Consulta_Informes_Admin.asp">Informes</a><br /><br />										
					· <a href="Carrusel_Admin.asp" target="_blank">Carrusel</a><br />					
					
					<br />
					
					<br /> 
					
					<br />
					
					<br />
					<br />
					
					
				</div>
				</div>
			</div>
		</div>
		
		
	</td>
	<td width="713" valign="top">
		<div id="main">
				
		
		
		
		
		
				<div class="comment_title fontbold">Articulos</div>
				<div class="comment_text"> 
					<form name="frmbuscar_articulos" id="frmbuscar_articulos" method="post" action="Consulta_Articulos_Admin.asp">
							
					<table width="98%" cellspacing="6" cellpadding="0" class="logintable" align="center">
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Opciones de Búsqueda de Art&iacute;culos </span>
							</td>
						</tr>
						
						<tr>
							<td width="50%" class="dottedBorder vt al">
								<input type="hidden" id="ocultoejecutar" name="ocultoejecutar" value="SI" />
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="12%">Empresa: </td>
									<td width="26%">
										<select  name="cmbempresas" id="cmbempresas" onchange="refrescar_pagina()">
											<option value="" selected>* Seleccione *</option>
											<%if vacio_empresas=false then %>
			                            			<%for i=0 to UBound(mitabla_empresas,2)%>
														<option value="<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>"><%=mitabla_empresas(CAMPO_EMPRESA_EMPRESA,i)%></option>
													<%next%>
											<%end if%>
										</select>
										<script language="javascript">
											document.getElementById("cmbempresas").value='<%=empresa_seleccionada%>'
										</script>
									</td>
									<td width="9%">Cod. Sap: </td>
									<td width="53%"><input class="txtfield" size="13" name="txtcodigo_sap" id="txtcodigo_sap" value="<%=codigo_sap_seleccionado%>"/></td>
								  </tr>							
												
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="3"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="12%">Familia: </td>
									<td width="48%">
										<div id="capa_familias">
											<select  name="cmbfamilias" id="cmbfamilias">
												<option value="" selected>* Seleccione *</option>
											</select>
										</div>
										<script language="javascript">
											//document.getElementById("cmbempresas").value='<%=empresa_seleccionada%>'
										</script>
									</td>
									<td width="19%"><strong>Req. Autorización: </strong></td>
									<td width="21%">&nbsp;<select  name="cmbautorizacion" id="cmbautorizacion">
                                        <option value="">* Seleccione *</option>
                                        <option value="NO">NO</option>
                                        <option value="SI">SI</option>
                                      </select>
                                        <script language="JavaScript" type="text/javascript">
											document.getElementById("cmbautorizacion").value='<%=campo_autorizacion%>'
										</script>
                                    </td>
									
								  </tr>							
												
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="3"></td></tr>
							  	</table>
								
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="11%">Descripción: </td>
									<td width="56%"><input class="txtfield" size="58" name="txtdescripcion" id="txtdescripcion" value="<%=descripcion_seleccionada%>" />
									</td>
									<td width="10%"><strong>Eliminado: </strong></td>
									<td width="14%">&nbsp;<select  name="cmbeliminado" id="cmbeliminado">
                                        <option value="">* Selec. *</option>
                                        <option value="NO">NO</option>
                                        <option value="SI">SI</option>
                                      </select>
                                        <script language="JavaScript" type="text/javascript">
											document.getElementById("cmbeliminado").value='<%=campo_eliminado%>'
										</script>
                                    </td>
									<td width="9%">
										<div align="right">
										  <input class="submitbtn" type="submit" name="Action" id="Action" value="Buscar" />
										</div>
										
									</td>
								</tr>							
												
								</table>
								
						  </td>
						</tr>
				  </table>
					
					
					
					
					
					
					
					
					
					
					<br />
					<TABLE width="660">
						<TR>
							<TD width="197">
								<table width="187" height="20" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td width="20"  style="border:1px solid #CCCCCC;background-color:#f8f8f8"></td>
										<td width="167">&nbsp;Artículo Sin Control de Stock</td>
									</tr>
						  	  </table>
								
							</TD>
							<TD width="207">
								<table width="202" height="20" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td width="19"  style="border:1px solid #CCCCCC;background-color:#3399CC"></td>
										<td width="172">&nbsp;Artículo Con Control de Stock</td>
									</tr>
						  	  </table>
							</TD>
							<TD width="240">
								<table width="240" height="20" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td width="19"  style="border:1px solid #CCCCCC;background-color:#FF6633"></td>
										<td width="215">&nbsp;Artículo Por Debajo del Stock Mínimo</td>
									</tr>
						  	  </table>
							</TD>
						</TR>
					</TABLE>
					<br />
					
					
					<table width="689">
						<tr>
							<td width="681">
								<div id="main">
										
								
								
								
								
								
										
											
											<table border="0" cellpadding="1" cellspacing="1" width="101%" class="info_table" style="border-collapse:collapse">
												<tr style="background-color:#FCFCFC" valign="top">
													<th class="menuhdr">Empresa</th>
													<th class="menuhdr">Cod. Sap</th>
													<th class="menuhdr">Artículo</th>
													<th class="menuhdr">Stock</th>
													<th class="menuhdr">Stock Mínimo</th>
													<th class="menuhdr">Se<BR />Muestra</th>
													
													
													
												</tr>
												
												<%if vacio_articulos=false then %>
			                            			<%for i=0 to UBound(mitabla_articulos,2)%>
														<%
															numero_registros=numero_registros + 1
															if numero_registros=10 then
																response.flush()
																numero_registros=0
															end if%>
															
														<tr  valign="top" id="fila_articulo_<%=i%>"
															<%if mitabla_articulos(CAMPO_AUTORIZACION_ARTICULO,i)="SI" then%> 
																	style="border:5px solid black"
															<%end if%>
														>
															<td  id="fila_articulo_<%=i%>_empresa" class="ac item_row" width="72"><font size="2" color="#000000"><%=mitabla_articulos(CAMPO_NOMBRE_EMPRESA_ARTICULO,i)%></font></td>
															<td  id="fila_articulo_<%=i%>_codigo_sap" class="ac item_row" style="text-align:left;" width="59">
																<font size="2" color="#000000">
																<%=mitabla_articulos(CAMPO_CODIGO_SAP_ARTICULO,i)%>
																<BR />
																<%
																set articulos_marcas=Server.CreateObject("ADODB.Recordset")
																sql="SELECT V_CLIENTES_MARCA.MARCA, a.ID_ARTICULO, a.STOCK, a.STOCK_MINIMO"
																sql=sql & " FROM V_CLIENTES_MARCA LEFT JOIN"
																sql=sql & " (SELECT ARTICULOS_MARCAS.ID_ARTICULO, ARTICULOS_MARCAS.MARCA, ARTICULOS_MARCAS.STOCK, ARTICULOS_MARCAS.STOCK_MINIMO"
																sql=sql & " FROM ARTICULOS_MARCAS"
																sql=sql & " WHERE ARTICULOS_MARCAS.ID_ARTICULO=" & mitabla_articulos(CAMPO_Id_ARTICULO,i) & ") as a"
																sql=sql & " ON V_CLIENTES_MARCA.MARCA = a.MARCA"
																sql=sql & " WHERE V_CLIENTES_MARCA.EMPRESA=" & mitabla_articulos(CAMPO_EMPRESA_ARTICULO,i)
																sql=sql & " ORDER BY V_CLIENTES_MARCA.MARCA"
																
																CAMPO_MARCA_ARTICULOS_MARCAS=0
																CAMPO_ID_ARTICULO_ARTICULOS_MARCAS=1
																CAMPO_STOCK_ARTICULOS_MARCAS=2
																CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS=3
																with articulos_marcas
																	.ActiveConnection=connimprenta
																	.Source=sql
																	'RESPONSE.WRITE("<BR>" & .SOURCE)
																	.Open
																	vacio_articulos_marca=false
																	if not .BOF then
																		mitabla_articulos_marca=.GetRows()
																	  else
																		vacio_articulos_marca=true
																	end if
																end with
																
																articulos_marcas.close
																set articulos_marcas=Nothing
																
																if vacio_articulos_marca=false then 
																	articulo_con_control_stock="NO"
																	alerta_articulo_stock="NO"
							                            			for j=0 to UBound(mitabla_articulos_marca,2)%>
																		<%if mitabla_articulos(CAMPO_NOMBRE_EMPRESA_ARTICULO,i)="BARCELÓ" then
																			carpeta_marca=mitabla_articulos_marca(CAMPO_MARCA_ARTICULOS_MARCAS,j)&"/"
																		  else
																			carpeta_marca=""
																		  end if
																		%>
																		<a href="Imagenes_Articulos/<%=carpeta_marca%><%=mitabla_articulos(CAMPO_Id_ARTICULO,i)%>.jpg" target="_blank">
																		<%=mitabla_articulos_marca(CAMPO_MARCA_ARTICULOS_MARCAS,j)%></a>
																		<BR />
																		
																		<%'ahora controlo de que color sale la fila
																		if mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)<>"" or mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)<>"" then
																			articulo_con_control_stock="SI"
																			if mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)<>"" and mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)<>"" then
																				if mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)<= mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j) then
																					alerta_articulo_stock="SI"
																				end if
																			end if
																			
																		end if
																		%>
																		
																<%	
																	next
																end if%>
																
																</font>	
															</td>
															<td  id="fila_articulo_<%=i%>_articulo" width="304" class="al item_row" style="text-align:right;cursor:hand;cursor:pointer" onclick="mostrar_articulo(<%=mitabla_articulos(CAMPO_ID_ARTICULO,i)%>,'MODIFICAR');return false">
																<font size="2" color="#000000">
																<%=mitabla_articulos(CAMPO_DESCRIPCION_ARTICULO,i)%>&nbsp;
																</font>
															</td>
															<td  id="fila_articulo_<%=i%>_stock" class="ac item_row" width="88">
																<font size="1" color="#000000">
																<%
																if vacio_articulos_marca=false then 
							                            			for j=0 to UBound(mitabla_articulos_marca,2)%>
																		<%if mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)<>"" then%>
																			<%=mitabla_articulos_marca(CAMPO_MARCA_ARTICULOS_MARCAS,j)%>:&nbsp;<%=mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)%>
																			<BR />
																		<%end if%>
																<%	
																	next
																end if%>
																
															
															
															
																</font>
															</td>
															<td  id="fila_articulo_<%=i%>_stock_minimo" class="ac item_row" width="94">
																<font size="1" color="#000000">
																<%
																if vacio_articulos_marca=false then 
							                            			for j=0 to UBound(mitabla_articulos_marca,2)%>
																		<% if mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)<>"" then%>
																			<%=mitabla_articulos_marca(CAMPO_MARCA_ARTICULOS_MARCAS,j)%>: <%=mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)%>
																			<BR />
																		<%end if%>
																<%	
																	next
																end if%>
																
																
																</font>
															</td>
															<td  id="fila_articulo_<%=i%>_mostrar" width="54" class="al item_row">
																<font size="2" color="#000000">
																<%=mitabla_articulos(CAMPO_MOSTAR_ARTICULO,i)%>&nbsp;
																</font>
															</td>
															
															
															
														</tr>
														
														<%'coloreo la fila si tiene control de stock
															if articulo_con_control_stock="SI" then
																if alerta_articulo_stock="NO" then
																	color_fila="#3399CC"	'"#0099CC"		'"#99CC99"   '"#66CC99"
																  else
																  	color_fila="#FF6633"
																end if%>
																<script language="javascript">
																	//alert('a la fila <%=i%> le tenemos que poner el color: <%=color_fila%>')
																	document.getElementById('fila_articulo_<%=i%>_empresa').style.backgroundColor='<%=color_fila%>'
																	document.getElementById('fila_articulo_<%=i%>_codigo_sap').style.backgroundColor='<%=color_fila%>'
																	document.getElementById('fila_articulo_<%=i%>_articulo').style.backgroundColor='<%=color_fila%>'
																	document.getElementById('fila_articulo_<%=i%>_stock').style.backgroundColor='<%=color_fila%>'
																	document.getElementById('fila_articulo_<%=i%>_stock_minimo').style.backgroundColor='<%=color_fila%>'
																	document.getElementById('fila_articulo_<%=i%>_mostrar').style.backgroundColor='<%=color_fila%>'
																</script>
																
																
															<%end if%>
														
													<%next%>
													
												<%else%>
													<tr> 
														<td align="center" colspan="6"><b><FONT class="fontbold">NO Hay Artículos Que Cumplan El Critero de Búsqueda...</font></b><br>
														</td>
													</tr>
												<%end if%>
												
												
						
												
								  </table>
											
											
										
								  
								
								
									
									
						
											
											
											
											
											
											
									
									
									
									
								</div>
						
							
							
							
							</td>
						</tr>
						
						
					  </table>
					  
					  <div align="right">
					  <table width="376">
					  		<tr>
								<td width="43" style="border:5px solid black"></td>
								<td width="448" style="color:#000000">&nbsp;&nbsp;Articulos Que Requieren Autorizacion Para Ser Enviados</td>
							</tr>
					  </table>
					  </div>
				  </form>
				</div>
		  <div class="submit_btn_container">	
		  
					<table width="13%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td>
							<input class="submitbtn" type="submit" name="nuevo_articulo" id="nuevo_articulo" value="Añadir Artículo" onclick="mostrar_articulo(0,'ALTA');return false" />
								
							</td>
						</tr>
					</table>
				
		  </div>

		
		
			
			

					
					
					
					
					
					
			
			
			
			
		</div>

	
	
	
	</td>
</tr>


</table>

<form name="frmmostrar_articulo" id="frmmostrar_articulo" action="Ficha_Articulo_Admin.asp" method="post">
	<input type="hidden" value="" name="ocultoid_articulo" id="ocultoid_articulo" />
	<input type="hidden" value="" name="ocultoaccion" id="ocultoaccion" />
</form>

















<script language="javascript">
cerrar_capas('capa_informacion')
</script>

</body>
<%
	
	connimprenta.close
	
	set connimprenta=Nothing

%>
</html>
