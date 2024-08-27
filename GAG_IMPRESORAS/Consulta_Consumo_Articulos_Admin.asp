<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
		end if
		
		empresa_seleccionada=Request.Form("cmbempresas")
		nombre_seleccionado=Request.Form("txthotel")
		campo_categoria=Request.Form("cmbcategorias")
		campo_tipo=Request.Form("cmbtipos")
		campo_marca=Request.Form("cmbmarcas")
		
		'response.write("<br>categoria--tipo--marca: " & campo_categoria & "--" & campo_tipo & "--" & campo_marca)
		'recordsets
		dim empresas
		
		
		'variables
		dim sql
		
		
	'Dim imagen As New Bitmap(New Bitmap("D:\Intranet_Local\Asp\Carrito_Imprenta\Imagenes_Articulos\BARCELO\3244.jpg"), 320, 288) 
	
	'imagen.Save("D:\Intranet_Local\Asp\Carrito_Imprenta\Imagenes_Articulos\BARCELO\3244__.jpg", System.Drawing.Imaging.ImageFormat.Jpeg)

	    

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

		
		
		
		
		set hoteles=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_HOTEL=0
		CAMPO_CODIGO_EMPRESA_HOTEL=1
		CAMPO_NOMBRE_EMPRESA_HOTEL=2
		CAMPO_NOMBRE_HOTEL=3
		CAMPO_CATEGORIA_HOTEL=4
		CAMPO_MARCA_HOTEL=5
		CAMPO_TIPO_HOTEL=6
		CAMPO_POBLACION_HOTEL=7
		CAMPO_PROVINCIA_HOTEL=8
		
		with hoteles
			.ActiveConnection=connimprenta
			.Source="SELECT V_CLIENTES.ID, V_CLIENTES.EMPRESA, V_EMPRESAS.EMPRESA, V_CLIENTES.NOMBRE, V_CLIENTES.CATEGORIA, V_CLIENTES.MARCA,"
			.Source= .Source & " V_CLIENTES.TIPO, V_CLIENTES.POBLACION, V_CLIENTES.PROVINCIA"
			.Source= .Source & " FROM V_CLIENTES INNER JOIN V_EMPRESAS"
			.Source= .Source & " ON V_CLIENTES.EMPRESA=V_EMPRESAS.ID"
			.Source= .Source & " WHERE 1=1"
			if empresa_seleccionada<>"" then
				.Source= .Source & " AND V_CLIENTES.EMPRESA=" & empresa_seleccionada
			end if
			if nombre_seleccionado<>"" then
				.Source= .Source & " AND V_CLIENTES.NOMBRE LIKE '%" & nombre_seleccionado & "%'"
			end if
			if campo_categoria<>"" then
				.Source= .Source & " AND V_CLIENTES.CATEGORIA='" & campo_categoria & "'"
			end if
			if campo_tipo<>"" then
				.Source= .Source & " AND V_CLIENTES.TIPO='" & campo_tipo & "'"
			end if
			if campo_marca<>"" then
				.Source= .Source & " AND V_CLIENTES.MARCA='" & campo_marca & "'"
			end if
			'para que no muestre toda la lista de hoteles si no se selecciona nada
			if empresa_seleccionada="" and nombre_seleccionado="" and campo_categoria="" and campo_tipo="" and campo_marca="" then
				.Source= .Source & " AND V_CLIENTES.ID=0"
			end if
			
			.Source= .Source & " ORDER BY V_CLIENTES.NOMBRE"
			.Open
			vacio_hoteles=false
			if not .BOF then
				mitabla_hoteles=.GetRows()
			  else
				vacio_hoteles=true
			end if
		end with

		hoteles.close
		set hoteles=Nothing


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
   	
function mostrar_hotel(hotel,accion)
   {
   	//alert('hotel: ' + hotel + ' accion: ' + accion)
   	document.getElementById('ocultoid_hotel').value=hotel
	document.getElementById('ocultoaccion').value=accion
   	document.getElementById('frmmostrar_hotel').submit()	
	

   }
</script>
<script language="vbscript">
	
	
</script>

<script type="text/javascript"> 
function refrescar_pagina()
{
	//alert(document.getElementById("cmbempresas").value)
	Actualizar_Combos('Obtener_Marcas_Hoteles.asp',document.getElementById("cmbempresas").value, '<%=campo_marca%>','capa_marcas')
	Actualizar_Combos('Obtener_Tipos_Hoteles.asp',document.getElementById("cmbempresas").value, '<%=campo_tipo%>','capa_tipos')
	Actualizar_Combos('Obtener_Categorias_Hoteles.asp',document.getElementById("cmbempresas").value, '<%=campo_categoria%>', 'capa_categorias')
	
	//document.getElementById("cmbcategorias").value='<%=campo_categoria%>'
	//document.getElementById("cmbtipos").value='<%=campo_tipo%>'
	//document.getElementById("cmbmarcas").value='<%=campo_marca%>'
		
}


</script> 
<script language="javascript" src="Funciones_Ajax.js"></script>

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
				<font size="3"><b>Mantenimientos</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					· <a href="Consulta_Pedidos_Admin.asp">Pedidos</a><br />
					· <a href="Consulta_Articulos_Admin.asp">Artículos</a><br />
					· <a href="Consulta_Clientes_Admin.asp">Clientes</a><br />
					· <a href="Consulta_Consumo_Articulos_Admin.asp">Consulta Consumo Articulos</a><br />
					
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
				<font size="3"><b>Alerta Stocks</b></font>
			</div>
			<div class="contentcell">
				
					<%
					set control_stock=Server.CreateObject("ADODB.Recordset")
					CAMPO_CODIGO_SAP_STOCK=2
					CAMPO_DESCRIPCION_STOCK=3
					CAMPO_MARCA_STOCK=14
					CAMPO_STOCK_STOCK=15
					CAMPO_STOCK_MINIMO_STOCK=16
					CAMPO_EMPRESA_STOCK=17
					with control_stock
						.ActiveConnection=connimprenta
						.Source="SELECT ARTICULOS.ID, ARTICULOS.CODIGO_EMPRESA, ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION,"
						.Source= .Source & " ARTICULOS.TAMANNO, ARTICULOS.TAMANNO_ABIERTO, ARTICULOS.TAMANNO_CERRADO, ARTICULOS.PAPEL,"
						.Source= .Source & " ARTICULOS.TINTAS, ARTICULOS.ACABADO, ARTICULOS.FECHA, ARTICULOS.COMPROMISO_COMPRA,"
						.Source= .Source & " ARTICULOS.MOSTRAR, ARTICULOS.MULTIARTICULO, ARTICULOS_MARCAS.MARCA,"
						.Source= .Source & " ARTICULOS_MARCAS.STOCK, ARTICULOS_MARCAS.STOCK_MINIMO, V_EMPRESAS.EMPRESA"
						.Source= .Source & " FROM (ARTICULOS INNER JOIN ARTICULOS_MARCAS" 
						.Source= .Source & " ON ARTICULOS.ID = ARTICULOS_MARCAS.ID_ARTICULO)" 
						.Source= .Source & " INNER JOIN V_EMPRESAS" 
						.Source= .Source & " ON ARTICULOS.CODIGO_EMPRESA = V_EMPRESAS.Id"
						.Source= .Source & " where stock<=stock_minimo"
						.Source= .Source & " order by V_empresas.empresa, articulos.descripcion, articulos_marcas.marca"
						.Open
						vacio_control_stock=false
						if not .BOF then
							mitabla_control_stock=.GetRows()
						  else
							vacio_control_stock=true
						end if
					end with
			
					control_stock.close
					set control_stock=Nothing




					%>
					
					
					
					
					
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  
						<%if vacio_control_stock=false then %>
							<%
								empresa_vuelta=""
								articulo_vuelta=""
								
							%>
							<%for i=0 to UBound(mitabla_control_stock,2)%>
								  <%
								  'para dejar un espacio entre empresas
								  if i>0 and empresa_vuelta<>mitabla_control_stock(CAMPO_EMPRESA_STOCK,i)  then%>
									  <tr>
										<td colspan="3" height="10"></td>
									  </tr>
									  
								  <%end if%>
								  <%
								  'para dejar un espacio entre articulos
								  if i>0 and articulo_vuelta<>mitabla_control_stock(CAMPO_DESCRIPCION_STOCK,i) then%>
									  <tr style="border:1px solid #000000;;background-color:#000000">
										<td colspan="3" height="2"></td>
									  </tr>
									  
								  <%end if%>
								  <%if empresa_vuelta<>mitabla_control_stock(CAMPO_EMPRESA_STOCK,i) then%>
									  <tr style="border:1px solid #000000;background-color:#777777 ">
										<td colspan="3" style="color:#FFFFFF ">&nbsp;<%=mitabla_control_stock(CAMPO_EMPRESA_STOCK,i)%></td>
									  </tr>
									  <%empresa_vuelta=mitabla_control_stock(CAMPO_EMPRESA_STOCK,i)%>
								  <%end if%>	
								  <%if articulo_vuelta<>mitabla_control_stock(CAMPO_DESCRIPCION_STOCK,i) then%>
									  <tr style="border:1px solid #000000;;background-color:#DDDDDD">
										<td colspan="3">&nbsp;&nbsp;<%=mitabla_control_stock(CAMPO_CODIGO_SAP_STOCK,i)%> - <%=mitabla_control_stock(CAMPO_DESCRIPCION_STOCK,i)%></td>
									  </tr>
									  <%
									  	articulo_vuelta=mitabla_control_stock(CAMPO_DESCRIPCION_STOCK,i)%>
									 
								  <%end if%>
								  <tr align="right" >
									<td style="border:1px solid #000000;"><%=mitabla_control_stock(CAMPO_MARCA_STOCK,i)%></td>
									<td style="border:1px solid #000000;"><%=mitabla_control_stock(CAMPO_STOCK_STOCK,i)%></td>
									<td style="border:1px solid #000000;"><%=mitabla_control_stock(CAMPO_STOCK_MINIMO_STOCK,i)%></td>
								  </tr>
								  
					  		<%next%>
						<%end if%>
				
					</table>

					
					<br /> 
					

					
				</div>
				</div>
		
		
		
	</td>
	<td width="713" valign="top">
		<div id="main">
				
		
		
		
		
		
				<div class="comment_title fontbold">Consulta Del Consumo de Articulos</div>
				<div class="comment_text"> 
					<form name="frmbuscar_hoteles" id="frmbuscar_hoteles" method="post" action="Consulta_Clientes_Admin.asp">
							
					<table width="95%" cellspacing="6" cellpadding="0" class="logintable" align="center">
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Opciones de Búsqueda </span>
							</td>
						</tr>
						
						<tr>
							<td width="50%" class="dottedBorder vt al">
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Empresa: </td>
									<td width="20%">
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
									<td width="10%">Hotel: </td>
									<td width="45%"><input class="txtfield" size="44" name="txthotel" id="txthotel" value="<%=nombre_seleccionado%>"/></td>
									<td width="12%">
										
											<div align="right">
										  		<input class="submitbtn" type="submit" name="Action" id="Action" value="Buscar" />
											</div>
									 </td>
								</tr>
								
												
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="3"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="10%">Categoría: </td>
									<td width="20%">
										<div id="capa_categorias">
											<select  name="cmbcategorias" id="cmbcategorias">
												<option value="" selected>* Seleccione *</option>
											</select>
										</div>
									</td>
									<td width="4%">Tipo:</td>
									<td width="28%">
										
										<div id="capa_tipos">
										<select  name="cmbtipos" id="cmbtipos">
											<option value="" selected>* Seleccione *</option>
										</select>
										</div>
									
									</td>
									<td width="6%">Marca:</td>
									<td width="32%">
										
										<div id="capa_marcas">
											
											<select name="cmbmarcas" id="cmbmarcas" class="cajatexto">
												<option value="" selected>* Seleccione *</option>
											</select>
										</div>
									</td>
								</tr>							
												
								</table>
								
						  </td>
						</tr>
				  </table>
					
					
					
					
					
					
					
					
					
					
					<br />
					
					<table>
						<tr>
							<td width="760">
								<div id="main">							  
								  <table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table">
                                    <tr style="background-color:#FCFCFC" valign="top">
                                      <th class="menuhdr">Empresa</th>
                                      <th class="menuhdr">Hotel</th>
                                      <th class="menuhdr">Cat.</th>
                                      <th width="70" class="menuhdr">Marca</th>
                                      <th width="92" class="menuhdr">Tipo</th>
                                      <th width="97" class="menuhdr">Población</th>
                                      <th width="91" class="menuhdr">Provincia</th>
                                    </tr>
                                    <%if vacio_hoteles=false then %>
                                    <%for i=0 to UBound(mitabla_hoteles,2)%>
                                    <tr style="cursor:hand;cursor:pointer" valign="top" onclick="mostrar_hotel(<%=mitabla_hoteles(CAMPO_ID_HOTEL,i)%>,'MODIFICAR');return false" onmouseover="javascript:this.style.background='#ffc9a5';" onmouseout="javascript:this.style.background='#FCFCFC'">
                                      <td class="ac item_row" width="92"><%=mitabla_hoteles(CAMPO_NOMBRE_EMPRESA_HOTEL,i)%></td>
                                      <td class="ac item_row" style="text-align:left" width="158"><%=mitabla_hoteles(CAMPO_NOMBRE_HOTEL,i)%></td>
                                      <td width="61" class="ac item_row" style="text-align:right">&nbsp;<%=mitabla_hoteles(CAMPO_CATEGORIA_HOTEL,i)%></td>
                                      <td width="70" class="ac item_row" style="text-align:right">&nbsp;<%=mitabla_hoteles(CAMPO_MARCA_HOTEL,i)%></td>
                                      <td width="92" class="ac item_row" style="text-align:right">&nbsp;<%=mitabla_hoteles(CAMPO_TIPO_HOTEL,i)%></td>
                                      <td width="97" class="al item_row" style="text-align:right">&nbsp;<%=mitabla_hoteles(CAMPO_POBLACION_HOTEL,i)%></td>
                                      <td width="91" class="al item_row" style="text-align:right">&nbsp;<%=mitabla_hoteles(CAMPO_PROVINCIA_HOTEL,i)%></td>
                                    </tr>
                                    <%next%>
                                    <%else%>
                                    <tr>
                                      <td bgcolor="#999966" align="center" colspan="7"><b><font class="fontbold">NO Hay Hoteles Que Cumplan El Critero de Búsqueda...</font></b><br />
                                      </td>
                                    </tr>
                                    <%end if%>
                                  </table>
								</div>
						
							
							
							
							</td>
						</tr>
						
						
						</table>
				  </form>
				</div>
		  <div class="submit_btn_container">	
		  
					<table width="13%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td>
								<div align="right">
								  <input class="submitbtn" type="submit" name="nuevo_hotel" id="nuevo_hotel" value="Añadir Hotel" onclick="mostrar_hotel(0,'ALTA');return false" />
								</div>
								
							</td>
						</tr>
					</table>
				
		  </div>

		
		
			
			

					
					
					
					
					
					
			
			
			
			
		</div>

	
	
	
	</td>
</tr>


</table>


<form name="frmmostrar_hotel" id="frmmostrar_hotel" action="Ficha_Hotel_Admin.asp" method="post">
	<input type="hidden" value="" name="ocultoid_hotel" id="ocultoid_hotel" />
	<input type="hidden" value="" name="ocultoaccion" id="ocultoaccion" />
</form>









<script language="javascript">
	refrescar_pagina()
	//document.getElementById("cmbcategorias").value='<%=campo_categoria%>'
	//document.getElementById("cmbtipos").value='<%=campo_tipo%>'
	//document.getElementById("cmbmarcas").value='<%=campo_marca%>'
</script>









</body>
<%
	
	connimprenta.close
	
	set connimprenta=Nothing

%>
</html>
