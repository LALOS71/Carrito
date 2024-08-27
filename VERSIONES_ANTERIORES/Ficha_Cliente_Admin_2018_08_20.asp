<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
		end if
		
		hotel_seleccionado=Request.Form("ocultoid_hotel")
		accion_seleccionada=Request.Form("ocultoaccion")
		'response.write("<br>" & accion_seleccionada)
		
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
		
		with hoteles
		
			.ActiveConnection=connimprenta
			.Source="SELECT V_CLIENTES.Id, V_CLIENTES.EMPRESA, V_CLIENTES.CODIGO_EXTERNO, V_CLIENTES.NOMBRE, V_CLIENTES.MARCA, V_CLIENTES.TIPO,"
			.Source= .Source & " V_CLIENTES.DIRECCION, V_CLIENTES.POBLACION, V_CLIENTES.PROVINCIA,"
			.Source= .Source & " V_CLIENTES.CP, V_CLIENTES.JEFE_ECONOMATO, V_CLIENTES.EMAIL, V_CLIENTES.TELEFONO, V_CLIENTES.FAX,"
			.Source= .Source & " V_CLIENTES.NOMBRE_FISCAL_FACTURAR, V_CLIENTES.DIRECCION_FACTURAR, V_CLIENTES.CIUDAD_FACTURAR,"
			.Source= .Source & " V_CLIENTES.PROVINCIA_FACTURAR, V_CLIENTES.CP_FACTURAR, V_CLIENTES.NIF_FACTURAR,"
			.Source= .Source & " V_CLIENTES.CONTRASENNA, V_CLIENTES.PEDIDO_MINIMO_CON_COMPROMISO, V_CLIENTES.PEDIDO_MINIMO_SIN_COMPROMISO,"
			.Source= .Source & " V_CLIENTES.TIPO_PRECIO, V_CLIENTES.REQUIERE_AUTORIZACION, V_CLIENTES.BORRADO, V_CLIENTES.DESCRIPCION_TRATO_ESPECIAL,"
			.Source= .Source & " V_CLIENTES.OBSERVACIONES_TRATO_ESPECIAL"
			.Source= .Source & " FROM V_CLIENTES"
			.Source= .Source & " WHERE V_CLIENTES.ID=" & hotel_seleccionado
			'response.write("<br>" & .Source)
			.Open
		end with
		campo_empresa=""
		campo_codigo_externo=""
		campo_nombre_hotel=""
		campo_marca=""
		campo_tipo=""
		campo_direccion=""
		campo_poblacion=""
		campo_provincia=""
		campo_cp=""
		campo_jefe_economato=""
		campo_email=""
		campo_telefono=""
		campo_fax=""
		campo_nombre_fiscal_facturar=""
		campo_direccion_facturar=""
		campo_ciudad_facturar=""
		campo_provincia_facturar=""
		campo_cp_facturar=""
		campo_nif_facturar=""
		campo_contrasenna=""
		campo_pedido_minimo_con_compromiso=""
		campo_pedido_minimo_sin_compromiso=""
		campo_tipo_precio=""
		campo_requiere_autorizacion=""
		campo_borrado=""
		campo_descripcion_trato_especial=""
		campo_observaciones_trato_especial=""
		
		if not hoteles.eof then
			campo_empresa=hoteles("empresa")
			campo_codigo_externo=hoteles("codigo_externo")
			campo_nombre_hotel=hoteles("nombre")
			campo_marca=hoteles("marca")
			campo_tipo=hoteles("tipo")
			campo_direccion=hoteles("direccion")
			campo_poblacion=hoteles("poblacion")
			campo_provincia=hoteles("provincia")
			campo_cp=hoteles("cp")
			campo_jefe_economato=hoteles("jefe_economato")
			campo_email=hoteles("email")
			campo_telefono=hoteles("telefono")
			campo_fax=hoteles("fax")
			campo_nombre_fiscal_facturar=hoteles("nombre_fiscal_facturar")
			campo_direccion_facturar=hoteles("direccion_facturar")
			campo_ciudad_facturar=hoteles("ciudad_facturar")
			campo_provincia_facturar=hoteles("provincia_facturar")
			campo_cp_facturar=hoteles("cp_facturar")
			campo_nif_facturar=hoteles("nif_facturar")
			campo_contrasenna=hoteles("contrasenna")
			campo_pedido_minimo_con_compromiso=hoteles("pedido_minimo_con_compromiso")
			campo_pedido_minimo_sin_compromiso=hoteles("pedido_minimo_sin_compromiso")
			campo_tipo_precio=hoteles("tipo_precio")
			campo_requiere_autorizacion=hoteles("requiere_autorizacion")
			campo_borrado=hoteles("borrado")
			campo_descripcion_trato_especial=hoteles("descripcion_trato_especial")
			campo_observaciones_trato_especial=hoteles("observaciones_trato_especial")
			
		end if
		
		
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
   	
function mostrar_hotel(hotel)
   {
   	document.getElementById('ocultoid_hotel').value=hotel
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
	Actualizar_Combos('Obtener_Precios_Clientes.asp',document.getElementById("cmbempresas").value, '<%=campo_tipo_precio%>', 'capa_precios')
	
	
}

function guardar_cliente()
{
	if (document.getElementById("cmbprecios").value=='')
		alert('Debe seleccionar un Tipo de Precio para este cliente');
	else
   		document.getElementById('frmhotel').submit();
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
					· <a href="Consulta_Informes_Admin.asp">Informes</a><br />
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
	<td width="713">
		<div id="main">
				
		
		
		
		
				<div class="comment_title fontbold">Datos del Cliente</div>
				<div class="comment_text"> 
					
							
					<table width="95%" cellspacing="6" cellpadding="0" class="logintable" align="center">
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Datos Generales</span>
							</td>
						</tr>
						
						<tr>
							<td width="50%" class="dottedBorder vt al">
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="10%" height="26">Empresa: </td>
									<td width="23%" height="26">
                                      <select  name="cmbempresas" id="cmbempresas" onchange="refrescar_pagina()">
                                        <option value="" selected>* Seleccione *</option>
                                        <%if vacio_empresas=false then %>
                                        <%for i=0 to UBound(mitabla_empresas,2)%>
                                        <option value="<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>"><%=mitabla_empresas(CAMPO_EMPRESA_EMPRESA,i)%></option>
                                        <%next%>
                                        <%end if%>
                                      </select>                                   	  
                                      <script language="javascript">
											document.getElementById("cmbempresas").value='<%=campo_empresa%>'
											
										</script>
								  </td>
									<td width="10%" height="26">Cliente: </td>
									<td width="45%" height="26"><input class="txtfield" size="44" name="txtnombre_hotel" id="txtnombre_hotel" value="<%=campo_nombre_hotel%>"/></td>
									<td width="12%" height="26">
										
										
									</td>
								</tr>							
												
							  </table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="10%" height="26">Marca: </td>
									<td width="23%" height="26" valign="middle">
										<div id="capa_marcas">
											<select name="cmbmarcas" id="cmbmarcas" class="cajatexto">
												<option value="" selected>* Seleccione *</option>
											</select>
										</div>
										
								  </td>
									<td width="6%" height="26">Tipo:</td>
									<td width="23%" height="26" >
										<div id="capa_tipos">
										<select  name="cmbtipos" id="cmbtipos">
											<option value="" selected>* Seleccione *</option>
										</select>
										</div>
										
									
									</td>
									<td width="14%" height="26" valign="middle">Tipos Precios:</td>
									<td width="24%" height="22" valign="middle">
										<div id="capa_precios">
											<select  name="cmbprecios" id="cmbprecios">
												<option value="" selected>* Seleccione *</option>
											</select>
										</div>
								  </td>
								</tr>							
								
								
												
								</table>
								
								
								
								<table cellpadding="0" cellspacing="0" border="0" width="100%">
								<tr>
									<td width="15%" height="26">Código Externo: </td>
									<td width="43%" height="26" >
                                      <input class="txtfield" size="20" name="txtcodigo_externo" id="txtcodigo_externo" value="<%=campo_codigo_externo%>"/>
								  </td>
									<td width="10%" height="26">Borrado:</td>
									<td width="28%" height="26">
										<select name="cmbborrado" id="cmbborrado" class="cajatexto">
												<option value="NO" selected>NO</option>
												<option value="SI">SI</option>
										</select>
										<%if campo_borrado<>"" then%>
											<script language="javascript">
												document.getElementById('cmbborrado').value='<%=campo_borrado%>'
											</script>
										<%end if%>
									</td>
									<td width="4%" height="26">
										
										
									</td>
								</tr>							
								
								
												
							  </table>
								
								
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="15%" height="26">Dirección: </td>
									<td width="43%" height="26" >
                                      <input class="txtfield" size="44" name="txtdireccion" id="txtdireccion" value="<%=campo_direccion%>"/>
								  </td>
									<td width="10%" height="26">C.P.:</td>
									<td width="28%" height="26">
										<input class="txtfield" size="5" name="txtcp" id="txtcp" value="<%=campo_cp%>"/>
										
								  </td>
									<td width="4%" height="26">
										
										
									</td>
								</tr>							
								
								
												
							  </table>
								
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="15%" height="26">Población: </td>
									<td width="43%" height="26" >
										<input class="txtfield" size="44" name="txtpoblacion" id="txtpoblacion" value="<%=campo_poblacion%>"/>
										
								  </td>
									<td width="10%" height="26">Provincia:</td>
									<td width="30%" height="26">
										<input class="txtfield" size="30" name="txtprovincia" id="txtprovincia" value="<%=campo_provincia%>"/>
										
								  </td>
									<td width="2%" height="26">
										
										
									</td>
								</tr>							
							  </table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="15%" height="26">Jefe Economato: </td>
									<td width="43%" height="26" >
										<input class="txtfield" size="44" name="txtjefe_economato" id="txtjefe_economato" value="<%=campo_jefe_economato%>"/>
										
								  </td>
									<td width="10%" height="26">Email:</td>
									<td width="30%" height="26">
										<input class="txtfield" size="30" name="txtemail" id="txtemail" value="<%=campo_email%>"/>
										
								  </td>
									<td width="2%" height="26">
										
										
									</td>
								</tr>							
								
								
												
							  </table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="15%" height="26">Teléfono: </td>
									<td width="43%" height="26" >
										<input class="txtfield" size="15" name="txttelefono" id="txttelefono" value="<%=campo_telefono%>"/>
										
								  </td>
									<td width="10%" height="26">Fax:</td>
									<td width="30%" height="26">
										<input class="txtfield" size="30" name="txtfax" id="txtfax" value="<%=campo_fax%>"/>
										
								  </td>
									<td width="2%" height="26">
										
										
									</td>
								</tr>							
								
								
												
							  </table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="44%" height="26">Pedido Mínimo Con Compromiso de Compra: </td>
									<td width="40%" height="26" >
										<input class="txtfield" size="4" name="txtpedido_minimo_con_compromiso" id="txtpedido_minimo_con_compromiso" value="<%=campo_pedido_minimo_con_compromiso%>"/>
										&nbsp;€
										
								  </td>
									<td width="16%" height="26">
										
										
									</td>
								</tr>							
								
								
												
							  </table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="44%" height="26">Pedido Mínimo Sin Compromiso de Compra: </td>
									<td width="40%" height="26" >
										<input class="txtfield" size="4" name="txtpedido_minimo_sin_compromiso" id="txtpedido_minimo_sin_compromiso" value="<%=campo_pedido_minimo_sin_compromiso%>"/>
										&nbsp;€
										
								  </td>
									<td width="16%" height="26">
										
										
									</td>
								</tr>							
							  </table>
							  <table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="44%" height="26">Requiere Autorización Por Parte de Su Central: </td>
									<td width="40%" height="26" >
										<select name="cmbrequiere_autorizacion" id="cmbrequiere_autorizacion" class="cajatexto">
												<option value="" selected></option>
												<option value="NO">NO</option>
												<option value="SI">SI</option>
											</select>
											
											<script language="javascript">
												document.getElementById('cmbrequiere_autorizacion').value='<%=campo_requiere_autorizacion%>'
											</script>
										
								  </td>
									<td width="16%" height="26">
										
										
									</td>
								</tr>							
							  </table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="15%" height="26">Contraseña: </td>
									<td width="85%" height="26" >
										<input class="txtfield" size="55" maxlength="50" name="txtcontrasenna" id="txtcontrasenna" value="<%=campo_contrasenna%>"/>
										
								  </td>
								</tr>							
							  </table>
   							  
							  <%if campo_descripcion_trato_especial<>"" then%>
								  <table cellpadding="2" cellspacing="1" border="0" width="100%">
									<tr>
										<td width="15%" height="26">Trato Especial: </td>
										<td width="85%" height="26" ><b><%=campo_descripcion_trato_especial%></b> (<%=campo_observaciones_trato_especial%>)</td>
									</tr>							
								  </table>
							  <%end if%>																								
								
								
						  </td>
						</tr>
						<tr><td class="al">&nbsp;</td></tr>
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Datos de Facturación</span>
							</td>
						</tr>
			
						<tr>
							<td width="50%" class="dottedBorder vt al">
								
			  
								
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="14%">Nombre Fiscal: </td>
									<td width="86%" >
										<input class="txtfield" size="60" name="txtnombre_fiscal" id="txtnombre_fiscal" value="<%=campo_nombre_fiscal_facturar%>"/>
										
									</td>
								</tr>							
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="14%">Dirección: </td>
									<td width="42%" >
                                      <input class="txtfield" size="44" name="txtdireccion_facturar" id="txtdireccion_facturar" value="<%=campo_direccion_facturar%>"/>
									</td>
									<td width="15%">C.P.:</td>
									<td width="25%">
										<input class="txtfield" size="5" name="txtcp_facturar" id="txtcp_facturar" value="<%=campo_cp_facturar%>"/>
										
									</td>
									<td width="4%">
										
										
									</td>
								</tr>							
								
								
												
								</table>
								
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td>
									</tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="14%">Población: </td>
									<td width="42%" >
										<input class="txtfield" size="44" name="txtpoblacion_facturar" id="txtpoblacion_facturar" value="<%=campo_ciudad_facturar%>"/>
										
									</td>
									<td width="15%">Provincia:</td>
									<td width="28%">
										<input class="txtfield" size="30" name="txtprovincia_facturar" id="txtprovincia_facturar" value="<%=campo_provincia_facturar%>"/>
										
									</td>
									<td width="1%">
										
										
									</td>
								</tr>							
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td>
									</tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="14%">Nif: </td>
									<td width="42%" >
										<input class="txtfield" size="44" name="txtnif_facturar" id="txtnif_facturar" value="<%=campo_nif_facturar%>"/>
										
									</td>
									<td width="15%"></td>
									<td width="28%"></td>
									<td width="1%"></td>
								</tr>							
								</table>
								
								
						  </td>
						</tr>
				  </table>
					
				  	
					
					
					
					
					
					
					
					
					<br />
					
					
				</div>
		  <div class="submit_btn_container">	
		  
					<table width="75%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td>
								<div align="center">
									<b>Para Modificar los Datos de los Clientes, Utilice el Programa de GAG</b>
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
</form>


















<script language="javascript">
	refrescar_pagina()
	
</script>

</body>
<%
		



	connimprenta.close
	
	set connimprenta=Nothing

%>
</html>
