<%@ language=vbscript %>

<!DOCTYPE  html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		Response.Buffer = TRUE
		'if session("usuario")="" then
		'	Response.Redirect("Login_Admin.asp")
		'end if
		
		'recordsets
		dim articulos
		
		
		codigo_sap_buscado=Request.Form("txtcodigo_sap")
		articulo_buscado=Request.form("txtdescripcion")
		
		'aqui viene la accion junto con el pedido y la fecha "MODIFICAR--88--fecha--codigo cliente--codigo externo cliente--nombre cliente--nombre empresa"
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
			'no necesitamos el nombre de empresa, lo obtenemos en la consulta sql
		end if
		
		set tipo_oficina=Server.CreateObject("ADODB.Recordset")
		with tipo_oficina
			.ActiveConnection=connimprenta
			
			.Source="SELECT V_CLIENTES.TIPO_PRECIO, V_CLIENTES.EMPRESA FROM PEDIDOS INNER JOIN V_CLIENTES ON PEDIDOS.CODCLI = V_CLIENTES.Id "
			.Source= .Source & " where pedidos.id=" & pedido_modificar
			
			.Open
		end with
			
		if not tipo_oficina.eof then
			tipo_precio=tipo_oficina("tipo_precio")
			id_empresa=tipo_oficina("empresa")
		end if
		'response.write(tipo_oficina_modif&"<br>")
		tipo_oficina.close
		set tipo_oficina=Nothing
		

		set articulos=Server.CreateObject("ADODB.Recordset")
		'Al desasociar los artículos de las empresas obtenemos la lista de artículos de la a
		'sql="Select ARTICULOS.*, HOTELES.MARCA, EMPRESAS.CARPETA, EMPRESAS.EMPRESA AS NOMBRE_EMPRESA, EMPRESAS.Id AS CODIGO_EMPRESA_CLIENTE"
		'sql=sql & " FROM ARTICULOS INNER JOIN EMPRESAS"
		'sql=sql & " ON ARTICULOS.CODIGO_EMPRESA = EMPRESAS.Id"
		'sql=sql & " INNER JOIN HOTELES"
		'sql=sql & " ON EMPRESAS.Id = HOTELES.EMPRESA"
		sql="Select ARTICULOS.*, V_CLIENTES.MARCA, V_EMPRESAS.CARPETA, V_EMPRESAS.EMPRESA AS NOMBRE_EMPRESA, ARTICULOS_EMPRESAS.CODIGO_EMPRESA AS CODIGO_EMPRESA_CLIENTE"
		sql=sql & " FROM ARTICULOS INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO "
		sql=sql & " INNER JOIN V_EMPRESAS ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA=V_EMPRESAS.ID "
		sql=sql & " INNER JOIN V_CLIENTES ON V_EMPRESAS.Id = V_CLIENTES.EMPRESA"
		sql=sql & " WHERE ARTICULOS.MOSTRAR = 'SI'"
		sql=sql & " AND V_CLIENTES.ID=" & hotel_admin
		if codigo_sap_buscado<>"" then
			sql=sql & " and ARTICULOS.codigo_sap like '%" & codigo_sap_buscado & "%'"
		end if
		if articulo_buscado<>"" then
			'sql=sql & " and descripcion like ""*" & articulo_buscado & "*"""
			sql=sql & " and ARTICULOS.descripcion like '%" & articulo_buscado & "%'"
		end if
		sql=sql & " and (ARTICULOS.id in (select cantidades_precios.codigo_articulo from cantidades_precios "
		sql=sql & " where tipo_sucursal='" & tipo_precio & "' and codigo_empresa=" & id_empresa & ")) "
		
		'sql=sql & " and Descripcion <> ''"
		'sql=sql & " and Mostrar_Intranet='SI'"
		'sql=sql & " and Activo = 1"
		'sql=sql & " order by Orden"
		'para que al entrar no muestre todo el listado de articulos solo cuando adrede se busque todo dando al boton
		'response.write("<br>url llamada: " & Request.ServerVariables("URL"))
		'response.write("<br>url referer: " & Request.ServerVariables("HTTP_REFERER"))
		'response.write("<br>instr url lista_articulos_imprenta....: " & instr(Request.ServerVariables("HTTP_REFERER"), "Lista_Articulos_Imprenta_Admin_Pedir"))
		if instr(Request.ServerVariables("HTTP_REFERER"), "Lista_Articulos_Imprenta_Admin_Pedir") = 0 then
			if codigo_sap_buscado="" and articulo_buscado="" then
				sql=sql & " and 0=1" 
			end if
		end if
		sql=sql & " order by ARTICULOS.compromiso_compra desc, ARTICULOS.Descripcion"
		'response.write("<br>cadena de consulta: " & sql)
		
		with articulos
			.ActiveConnection=connimprenta
			
			.Source=sql
			
			.Open
		end with
		
		CARPETA_EMPRESA=""
		MARCA_CLIENTE=""
		CODIGO_EMPRESA_CLIENTE=""
		NOMBRE_EMPRESA=""
		if not articulos.eof then
			CARPETA_EMPRESA= articulos("carpeta")
			MARCA_CLIENTE=articulos("marca")
			CODIGO_EMPRESA_CLIENTE=articulos("codigo_empresa_cliente")
			NOMBRE_EMPRESA=articulos("nombre_empresa")
			
		end if
		
		dim hoteles

		
		
		
		
%>

<html>
<head>


<title>Carrito Imprenta</title>
<link href="estilos.css" rel="stylesheet" type="text/css" />

<script src="funciones.js" type="text/javascript"></script>
<script language="javascript">
function comprobar_numero_entero(dato)
{
		var cadenachequeo = "0123456789"; 
  		var valido = true; 
  		var lugaresdecimales = 0; 
  		var cadenacompleta = ""; 
		for (i = 0; i < dato.length; i++)
		 { 
    		ch = dato.charAt(i); 
    		for (j = 0; j < cadenachequeo.length; j++) 
      			if (ch == cadenachequeo.charAt(j))
        			break; 
    		if (j == cadenachequeo.length)
			 { 
      			valido = false; 
      			break; 
    		 } 
    		cadenacompleta += ch; 
  		 } 
  	
		if ((!valido) || (dato=='') || (dato<=0))
		 	return (false)
  		  else
		  	return (true);

}

function annadir_al_carrito(articulo)
{
	//alert('hola primero')
	if (document.getElementById('ocultocantidades_precios_' + articulo).value=='')
		{
		alert('Para Añadir El Artículo al Carrito ha de Seleccionar Las Cantidades/Precios del Mismo')
		}
	  else
		{
		if (document.getElementById('ocultocantidades_precios_' + articulo).value=='OTRAS CANTIDADES')
			{
			//alert('Para poder seleccionar Otras Cantidades/Precios ha de ponerse en contacto con Globalia Artes Graficas')
			//equivalencia de los caracteres especiales y lo que hay que poner en el mailto
			//á é í ó ú Á É Í Ó Ú Ñ ñ ü Ü
			//%E1 %E9 %ED %F3 %FA %C1 %C9 %CD %D3 %DA %D1 %F1 %FC %DC
			//
			//para insertar saltos de linea
			//%0D%0A%0A
			//alert('hola')
			cadena_email='mailto:carlos.gonzalez@globalia-artesgraficas.com'
			cadena_email+= '?subject=Nuevo Escalado Barcel%F3'
			cadena_email+= '&body=Por favor indique el nombre y c%F3digo Sap. del art%EDculo del que desea que le facilitemos'
			cadena_email+= ' un nuevo escalado y a continuaci%F3n la cantidad requerida.'
			cadena_email+= '%0D%0A%0A En breve la encontrar%E1 colgada en el gestor de pedidos.'
			cadena_email+= '%0D%0A%0AUn saludo.'

			location.href=cadena_email
			}
		  else
		  	{
			document.getElementById('ocultoarticulo').value=articulo
			//si es uno de los articulos con compromiso de compra, vendra con xxx en las cantidades
			//  tengo que sustituirlo por lo que el usuario introduzca manualmente en la cantidad del
			//  articulo seleccionado
			//alert('cantidades antes: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
			if (document.getElementById('ocultocantidades_precios_' + articulo).value.indexOf('XXX')!=-1) 
				{
				if (comprobar_numero_entero(document.getElementById('txtcantidad_' + articulo).value))
					{
					document.getElementById('ocultocantidades_precios_' + articulo).value=document.getElementById('ocultocantidades_precios_' + articulo).value.replace('XXX',document.getElementById('txtcantidad_' + articulo).value)
					document.getElementById('ocultocantidades_precios').value=document.getElementById('ocultocantidades_precios_' + articulo).value
					//alert('cantidades despues: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)

					document.getElementById('frmannadir_al_carrito').submit()
					}
				  else
				  	{
						alert('La Cantidad Introducida Ha De Ser Un Número Entero')
						document.getElementById('txtcantidad_' + articulo).value=''
					}
				}
			  else
			  	{
				//cuando el articulo es sin compromiso de compra, ya viene la cantidad bien
				document.getElementById('ocultocantidades_precios').value=document.getElementById('ocultocantidades_precios_' + articulo).value
				//alert('cantidades despues: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
				document.getElementById('frmannadir_al_carrito').submit()
				}
			
			}
	
		}  
}

function seleccionar_fila(articulo, fila_pulsada, numero_filas,cantidades_precio_total_articulo,compromiso_compra)
{
	for (i=1;i<=numero_filas;i++)
	{
	document.getElementById('fila_' + articulo + '_' + i).style.background=''
	document.getElementById ('fila_' + articulo + '_' + i).style.fontWeight = 'normal'
//var fontTest = document.getElementById ('fila_' + articulo + '_' + i)
    //fontTest.style.fontWeight = '900';

	}
	
	document.getElementById('fila_' + articulo + '_' + fila_pulsada).style.background='#E1E1E1' 
	document.getElementById ('fila_' + articulo + '_' + fila_pulsada).style.fontWeight = 'bold'
	//alert('compromiso_compra: ' + compromiso_compra)
	document.getElementById('ocultocantidades_precios_' + articulo).value=cantidades_precio_total_articulo
		
	  	
}
</script>
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
				<font size="3"><b>Mantenimientos</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					· <a href="Consulta_Pedidos_GAGAD.asp">Pedidos</a><br />
					· <a href="Consulta_Articulos_GAGAD.asp">Artículos</a><br />
					· <a href="Consulta_Clientes_GAGAD.asp">Clientes</a><br />
					
					<br />
					
					<br /> 
					
					<br />
					
					<br />
					<br />
					
					
				</div>
				</div>
			</div>
		</div>
		
		<div class="sidebarcell">
			
			<div id="side_freetext_title_39" class="title">
				<br />
				<font size="3"><b>Datos del Pedido</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					<table width="95%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td width="31%" align="right"><img src="images/Carrito_48x48.png" border="0" /></td>
							<td width="69%">&nbsp;<b><%=session("numero_articulos")%></b> Artículos</td>
						</tr>
					</table>
					<br />
					<table width="95%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td width="100%"><b>Modificando Pedido:</b>&nbsp;<%=pedido_modificar%></td>
						</tr>
						<tr>
							<td width="100%"><b>Empresa:</b>&nbsp;<%=NOMBRE_EMPRESA%></td>
						</tr>
						<tr>
							<td width="100%"><b>Sucursal:</b> <%=codigo_externo_modificacion%> - <%=nombre_modificacion%></td>
						</tr>
						<tr>
							<td width="100%" style="border-bottom:1px dotted #999999"><br /><b>Articulos:</b></td>
						</tr>
						<%i=1
						set articulos_carrito=Server.CreateObject("ADODB.Recordset")
						While i<=Session("numero_articulos")
							id=Session(i)
							sql="SELECT ARTICULOS.DESCRIPCION"
							sql=sql & " FROM ARTICULOS"
							sql=sql & " WHERE ARTICULOS.ID=" & id
							'response.write("<br>" & sql)

							with articulos_carrito
								.ActiveConnection=connimprenta
								.Source=sql
								'.source="SELECT ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION as articulo from articulos"
								'response.write("<br>" & .source)
								.Open
							end with
							
							
						%>
							<tr>
								<td width="100%" style="border-bottom:1px dotted #999999"><%=articulos_carrito("Descripcion")%></td>
							</tr>
						<%
							i=i+1
							articulos_carrito.close
						wend
						set articulos_carrito=Nothing
						%>
						
					</table>
					
					
					<br />
					<br />
					<div class="info">
					<table width="95%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td width="50%">
								<a href="Carrito_Imprenta_GAGAD.asp?acciones=<%=acciones%>" class="btn-details"><font color="#FFFFFF">Ver Pedido</font></a>
							</td>
							<td width="50%">
								
							</td>
						</tr>
					</table>
					</div>
					
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
						<span class='fontbold'>Busqueda de Productos <%=NOMBRE_EMPRESA%></span>
					</td>
				</tr>
				<tr>
					<td width="50%" class="dottedBorder vt al">
						
	  
						<form name="frmbusqueda" id="frmbusqueda" method="post" action="Lista_Articulos_Imprenta_GAGAD_Pedir.asp?acciones=<%=acciones%>">
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
			
			
			
			
			
			
			<%while not articulos.eof
				response.flush()%>
				<table width="587" class="product-wrapper">
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
																												<%if articulos("nombre_empresa")="BARCELÓ" then
																													carpeta_marca=MARCA_CLIENTE&"/"
																												  else
																													carpeta_marca=""
																												  end if
																												%>
																												<a href="Imagenes_Articulos/<%=carpeta_marca%><%=articulos("id")%>.jpg" target="_blank">
																													<img class="product_thumbnail" src="Imagenes_Articulos/<%=carpeta_marca%>Miniaturas/i_<%=articulos("id")%>.jpg" border="0">
																												</a>
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
																											<td width="50%" class="info_column">
																												<%
																												set cantidades_precios=Server.CreateObject("ADODB.Recordset")
		
																												sql="SELECT * FROM CANTIDADES_PRECIOS"
																												sql=sql & " WHERE CODIGO_ARTICULO=" & articulos("id")
																												sql=sql & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
																												sql=sql & " AND CODIGO_EMPRESA=" & id_empresa
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
																													
																														<table width="95%" cellpadding="0" cellspacing="0" border="0" style="border:2px solid">
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
																																<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','NO')">
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
																															
																														</table>
																													  <%else%>
																													  
																													  	<table width="99%" cellpadding="0" cellspacing="0" border="0" style="border:2px solid">
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
																																<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','SI')">
																																	<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																																  <td height="25" align="right" style="border-bottom:1pt solid"><input class="txtfield" size="5" name="txtcantidad_<%=articulos("id")%>" id="txtcantidad_<%=articulos("id")%>" />&nbsp;</td>
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
																												set cantidades_precios=Nothing
																												%>
																												</span><br />
																											</td>
																											<td valign="top" class="divider-vertical2"></td>
																											<td valign="top" class="info_column">
																												<table border="0" cellspacing="0" cellpadding="0" class="input_table" >
																													<tr>
																														<td valign="top">             
																															<a href="#nogoto" onclick="muestra('informacion_<%=articulos("ID")%>')" class="btn-details">+ información</a>
																														</td>
																													</tr>
																												
																													<tr>
																														<td valign="top"> 
																															<table width="80%" cellpadding="0" cellspacing="0" align="center" >
																																<tr>
																																	<td width="33%"><a href="#nogoto" onclick="annadir_al_carrito(<%=articulos("ID")%>)" ><img src="images/Carrito_16x16.png" border="0" />&nbsp;</a></td>
																																	<td width="67%" style="text-align:left"><a href="#nogoto" onclick="annadir_al_carrito(<%=articulos("ID")%>)" ><div class="fontbold"><b>Añadir</b></div></a></td>
																																</tr>
																															</table>            
																															
																														</td>
																													</tr>
																												</table>
																											</td>
																										</tr>
																										<%if articulos("unidades_de_pedido")<>"" then%>
																											<tr><td colspan="3"><b>Unidades de Pedido:</b> <%=articulos("unidades_de_pedido")%></td></tr>
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
				
			  </table>
			  <%articulos.movenext%>	
			<%wend%>
				
				
			</div>
			</div>

	
	
	
	</td>
</tr>


</table>

<form name="frmannadir_al_carrito" id="frmannadir_al_carrito" action="Annadir_Articulo_Imprenta_GAGAD.asp?acciones=<%=acciones%>" method="post">
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

