<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
	if session("usuario_admin")="" then
		Response.Redirect("Login_GAGAD.asp")
	end if
		
	empresa_seleccionada=Request.Form("cmbempresas")
	nombre_seleccionado=Request.Form("txthotel")
	campo_precio=Request.Form("cmbprecios")
	campo_tipo=Request.Form("cmbtipos")
	campo_marca=Request.Form("cmbmarcas")
		
	'response.write("<br>categoria--tipo--marca: " & campo_precio & "--" & campo_tipo & "--" & campo_marca)
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
	CAMPO_MARCA_HOTEL=4
	CAMPO_TIPO_HOTEL=5
	CAMPO_POBLACION_HOTEL=6
	CAMPO_PROVINCIA_HOTEL=7
	CAMPO_TIPO_PRECIO_HOTEL=8
		
	with hoteles
		.ActiveConnection=connimprenta
		.Source="SELECT V_CLIENTES.ID, V_CLIENTES.EMPRESA, V_EMPRESAS.EMPRESA, V_CLIENTES.NOMBRE, V_CLIENTES.MARCA,"
		.Source= .Source & " V_CLIENTES.TIPO, V_CLIENTES.POBLACION, V_CLIENTES.PROVINCIA, V_CLIENTES.TIPO_PRECIO "
		.Source= .Source & " FROM V_CLIENTES INNER JOIN V_EMPRESAS ON V_CLIENTES.EMPRESA=V_EMPRESAS.ID"
		.Source= .Source & " WHERE 1=1"
		if empresa_seleccionada<>"" then
			.Source= .Source & " AND V_CLIENTES.EMPRESA=" & empresa_seleccionada
		end if
		if nombre_seleccionado<>"" then
			.Source= .Source & " AND V_CLIENTES.NOMBRE LIKE '%" & nombre_seleccionado & "%'"
		end if
		if campo_precio<>"" then
			.Source= .Source & " AND V_CLIENTES.TIPO_PRECIO='" & campo_precio & "'"
		end if
		if campo_tipo<>"" then
			.Source= .Source & " AND V_CLIENTES.TIPO='" & campo_tipo & "'"
		end if
		if campo_marca<>"" then
			.Source= .Source & " AND V_CLIENTES.MARCA='" & campo_marca & "'"
		end if
		'para que no muestre toda la lista de hoteles si no se selecciona nada
		if empresa_seleccionada="" and nombre_seleccionado="" and campo_precio="" and campo_tipo="" and campo_marca="" then
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
	//alert("tama�o: " + s.legth)
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
	Actualizar_Combos('Obtener_Precios_Clientes.asp',document.getElementById("cmbempresas").value, '<%=campo_precio%>', 'capa_precios')
	
	//document.getElementById("cmbprecios").value='<%=campo_precio%>'
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
					� <a href="Consulta_Pedidos_GAGAD.asp">Pedidos</a><br />
					� <a href="Consulta_Articulos_GAGAD.asp">Art�culos</a><br />
					� <a href="Consulta_Clientes_GAGAD.asp">Clientes</a><br />
					� <a href="Consulta_Informes_GAGAD.asp">Informes</a><br /><br />										
					� <a href="Carrusel_Admin.asp" target="_blank">Carrusel</a><br />					
					
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
				
		
		
		
		
		
				<div class="comment_title fontbold">Clientes</div>
				<div class="comment_text"> 
					<form name="frmbuscar_hoteles" id="frmbuscar_hoteles" method="post" action="Consulta_Clientes_GAGAD.asp">
							
					<table width="95%" cellspacing="6" cellpadding="0" class="logintable" align="center">
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Opciones de B�squeda de Clientes </span>
							</td>
						</tr>
						
						<tr>
							<td width="50%" class="dottedBorder vt al">
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="10%">Empresa: </td>
									<td width="22%">
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
									<td width="8%">Cliente: </td>
									<td width="48%"><input class="txtfield" size="44" name="txthotel" id="txthotel" value="<%=nombre_seleccionado%>"/></td>
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
								<tr valign="top">
									<td width="5%" height="26" valign="middle">Tipo:</td>
									<td width="27%" valign="middle">
										
										<div id="capa_tipos">
										<select  name="cmbtipos" id="cmbtipos">
											<option value="" selected>* Seleccione *</option>
										</select>
										</div>
									
								  </td>
									<td width="8%" valign="middle">Marca:</td>
									<td width="25%" valign="middle">
										
										<div id="capa_marcas">
											
											<select name="cmbmarcas" id="cmbmarcas" class="cajatexto">
												<option value="" selected>* Seleccione *</option>
											</select>
										</div>
								  </td>
									<td width="14%" valign="middle">Tipos Precios: </td>
									<td width="21%" valign="middle">
										<div id="capa_precios">
											<select  name="cmbprecios" id="cmbprecios">
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
                                      <th class="menuhdr">Cliente</th>
                                      <th width="65" class="menuhdr">Marca</th>
                                      <th width="82" class="menuhdr">Tipo</th>
                                      <th width="97" class="menuhdr">Poblaci�n</th>
                                      <th width="91" class="menuhdr">Provincia</th>
                                      <th class="menuhdr">T. Precios</th>
                                    </tr>
                                    <%if vacio_hoteles=false then %>
                                    <%for i=0 to UBound(mitabla_hoteles,2)%>
                                    <tr style="cursor:hand;cursor:pointer" valign="top" onclick="mostrar_hotel(<%=mitabla_hoteles(CAMPO_ID_HOTEL,i)%>,'MODIFICAR');return false" onmouseover="javascript:this.style.background='#ffc9a5';" onmouseout="javascript:this.style.background='#FCFCFC'">
                                      <td class="ac item_row" width="87"><%=mitabla_hoteles(CAMPO_NOMBRE_EMPRESA_HOTEL,i)%></td>
                                      <td class="ac item_row" style="text-align:left" width="158"><%=mitabla_hoteles(CAMPO_NOMBRE_HOTEL,i)%></td>
                                      <td width="70" class="ac item_row" style="text-align:right">&nbsp;<%=mitabla_hoteles(CAMPO_MARCA_HOTEL,i)%></td>
                                      <td width="92" class="ac item_row" style="text-align:right">&nbsp;<%=mitabla_hoteles(CAMPO_TIPO_HOTEL,i)%></td>
                                      <td width="97" class="al item_row" style="text-align:right">&nbsp;<%=mitabla_hoteles(CAMPO_POBLACION_HOTEL,i)%></td>
                                      <td width="91" class="al item_row" style="text-align:right">&nbsp;<%=mitabla_hoteles(CAMPO_PROVINCIA_HOTEL,i)%></td>
                                      <td width="81" class="ac item_row" style="text-align:right">&nbsp;<%=mitabla_hoteles(CAMPO_TIPO_PRECIO_HOTEL,i)%></td>
                                    </tr>
                                    <%next%>
                                    <%else%>
                                    <tr>
                                      <td bgcolor="#999966" align="center" colspan="7"><b><font class="fontbold">NO Hay Clientes Que Cumplan El Critero de B�squeda...</font></b><br />
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
		  
					<table width="56%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td>
								<div align="center">
									<b>Para Crear Clientes, se ha de hacer desde el GAG</b>
									<!--
										<input class="submitbtn" type="submit" name="nuevo_hotel" id="nuevo_hotel" value="A�adir Cliente" onclick="mostrar_hotel(0,'ALTA');return false" /> 
									-->
								</div>
								
							</td>
						</tr>
			</table>
				
		  </div>

		
		
			
			

					
					
					
					
					
					
			
			
			
			
		</div>

	
	
	
	</td>
</tr>


</table>


<form name="frmmostrar_hotel" id="frmmostrar_hotel" action="Ficha_Cliente_GAGAD.asp" method="post">
	<input type="hidden" value="" name="ocultoid_hotel" id="ocultoid_hotel" />
	<input type="hidden" value="" name="ocultoaccion" id="ocultoaccion" />
</form>









<script language="javascript">
	refrescar_pagina()
	//document.getElementById("cmbprecios").value='<%=campo_precio%>'
	//document.getElementById("cmbtipos").value='<%=campo_tipo%>'
	//document.getElementById("cmbmarcas").value='<%=campo_marca%>'
</script>









</body>
<%
	
	connimprenta.close
	
	set connimprenta=Nothing

%>
</html>
