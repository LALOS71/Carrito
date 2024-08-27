    <%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
    'para que no se desborde el buffer
	Response.Buffer=true
		
	if session("usuario_admin")="" then
		Response.Redirect("Login_Admin.asp")
	end if
		
	'response.write("<br>agrupacion: " & agrupacion_seleccionada)
		
	'response.write("<br>ocultar sucursales borradas: " & ocultar_sucursales_seleccionada)
	
	'variables
	dim sql
	
	
	
	
	

		set articulos=Server.CreateObject("ADODB.Recordset")
		CAMPO_CODIGO_SAP_ARTICULO=0
		CAMPO_DESCRIPCION_ARTICULO=1
		CAMPO_UNIDADES_DE_PEDIDO_ARTICULO=2
		CAMPO_STOCK_ARTICULO=3
		CAMPO_PRECIO_COSTE_ARTICULO=4
		CAMPO_TOTAL_COSTE_ARTICULO=5
		CAMPO_PROVEEDOR_ARTICULO=6
		CAMPO_EMPRESA_ARTICULO=7
		CAMPO_FAMILIA_ARTICULO=8
		CAMPO_MOSTRAR_ARTICULO=9
		with articulos
			.ActiveConnection=connimprenta
			.Source="SELECT CODIGO_SAP, ARTICULOS.DESCRIPCION, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS_MARCAS.STOCK,"
			.Source= .Source & " PRECIO_COSTE, ARTICULOS.PRECIO_COSTE * ARTICULOS_MARCAS.STOCK AS TOTAL_COSTE,"
			.Source= .Source & " (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=ARTICULOS.PROVEEDOR) AS PROVEEDOR,"
			.Source= .Source & " (SELECT CASE WHEN COUNT(V_EMPRESAS.EMPRESA)>1" 
			.Source= .Source & " THEN 'Varias...'"
			.Source= .Source & " ELSE MIN(V_EMPRESAS.EMPRESA) END AS EMPRESAS"
			.Source= .Source & " FROM ARTICULOS_EMPRESAS INNER JOIN V_EMPRESAS"
			.Source= .Source & " ON V_EMPRESAS.ID=ARTICULOS_EMPRESAS.CODIGO_EMPRESA" 
			.Source= .Source & " WHERE ARTICULOS_EMPRESAS.ID_ARTICULO=ARTICULOS.ID) AS EMPRESAS,"
			.Source= .Source & " (SELECT CASE WHEN COUNT(FAMILIAS.DESCRIPCION)>1"
			.Source= .Source & " THEN 'Varias...'"
			.Source= .Source & " ELSE MIN(FAMILIAS.DESCRIPCION) END AS FAMILIAS"
			.Source= .Source & " FROM ARTICULOS_EMPRESAS INNER JOIN FAMILIAS" 
			.Source= .Source & " ON ARTICULOS_EMPRESAS.FAMILIA=FAMILIAS.ID"
			.Source= .Source & " WHERE ARTICULOS_EMPRESAS.ID_ARTICULO=ARTICULOS.ID) AS FAMILIAS,"
			.Source= .Source & " ARTICULOS.MOSTRAR"
			.Source= .Source & " FROM ARTICULOS LEFT JOIN ARTICULOS_MARCAS"
			.Source= .Source & " ON ARTICULOS.ID=ARTICULOS_MARCAS.ID_ARTICULO"
			.Source= .Source & " WHERE ARTICULOS.BORRADO='NO'"
			.Source= .Source & " AND MARCA NOT IN ('PREMIUM','COMFORT','BARCELO')"
			.Source= .Source & " ORDER BY ARTICULOS.DESCRIPCION"
			
			'response.write("<br>" & .source)
			cadena_consulta=.Source
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
			
	tr:nth-child(odd) {
    	background-color:#dddddd;
	}

	tr:nth-child(even) {
    	background-color:#eeeeee;
	}		
		
</style>
<!-- European format dd-mm-yyyy -->
	<script language="JavaScript" src="js/calendario/calendar1.js"></script>
<!-- Date only with year scrolling -->
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

function activar_articulos_sin_consumo()
{
	if (document.getElementById('chkdiferenciar_articulos').checked)
		{
		document.getElementById('fila_articulos_sin_consumo').style.display='';
		}
	  else
		{
		document.getElementById('chkarticulos_sin_consumo').checked=false;
		document.getElementById('fila_articulos_sin_consumo').style.display='none';
		}
}

function mostrar_capas(capa)
{
	console.log('he pulsado....' + capa)
	if (capa=='empresas')
		{
		console.log('dentro de empresa')
	
		document.getElementById('chkdiferenciar_articulos').checked=false
		document.getElementById('chkarticulos_sin_consumo').checked=false
		document.getElementById('fila_articulos_sin_consumo').style.display='none';
		

		
		document.getElementById('tabla_diferenciar_articulos_relleno').style.display='none';
		document.getElementById('tabla_diferenciar_articulos').style.display='none';
		document.getElementById('tabla_diferenciar_empresas_relleno').style.display='block';
		document.getElementById('tabla_diferenciar_empresas').style.display='block';
		document.getElementById('cmbempresas').style.display='none';
		document.getElementById('cmbarticulos').style.display='block';
		
		document.getElementById('cmbempresas').value='';
		}
	
	if (capa=='articulos')
		{
		console.log('dentro de articuolo')
		document.getElementById('chkdiferenciar_empresas').checked=false

		document.getElementById('tabla_diferenciar_empresas_relleno').style.display='none';
		document.getElementById('tabla_diferenciar_empresas').style.display='none';
		document.getElementById('tabla_diferenciar_articulos_relleno').style.display='block';
		document.getElementById('tabla_diferenciar_articulos').style.display='block';

		document.getElementById('cmbempresas').style.display='block';
		document.getElementById('cmbarticulos').style.display='none';
		
		document.getElementById('cmbarticulos').value='';

		
		
		
		}
	
}
</script>
<script language="vbscript">
	
	
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
				<font size="3"><b>Mantenimientos</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					· <a href="Consulta_Pedidos_Admin.asp">Pedidos</a><br />
					· <a href="Consulta_Articulos_Admin.asp">Artículos</a><br />
					· <a href="Consulta_Clientes_Admin.asp">Clientes</a><br />
					· <a href="Consulta_Informes_Admin.asp">Informes </a><br /><br />										
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
		
			</div>
		</div>
		
		
		
	</td>
	<td width="97%" valign="top">
		<div id="main">
				
					
				<div class="comment_text__" align="center"> 
					<br />
					
					<B>INFORME COSTES ARTICULOS</B>
					<br /><br />

										
											<table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table_">
												<tr style="background-color:#FCFCFC" valign="top">
													<th class="menuhdr">Referencia</th>
													<th class="menuhdr">Descripci&oacute;n</th>
                                                    <th class="menuhdr">Unid. Ped.</th>
													<th class="menuhdr">Stock</th>
													<th class="menuhdr">Coste</th>
													<th class="menuhdr">Coste Total</th>
													<th class="menuhdr">Proveedor</th>
													<th class="menuhdr">Empresa</th>
													<th class="menuhdr">Familia</th>
													<th class="menuhdr">Mostrar</th>
												</tr>
												
												<%if vacio_articulos=false then %>
														<%for i=0 to UBound(mitabla_articulos,2)%>
															<tr  valign="top">
																<td  class="ac item_row" width="82"><%=mitabla_articulos(CAMPO_CODIGO_SAP_ARTICULO,i)%></td>
																<td  class="ac item_row" style="text-align:left" width="76"><%=mitabla_articulos(CAMPO_DESCRIPCION_ARTICULO,i)%></td>
																<td  class="ac item_row" width="101">
																	<%=mitabla_articulos(CAMPO_UNIDADES_DE_PEDIDO_ARTICULO,i)%>
																</td>
																<td  class="ac item_row" width="101">
																	<%=mitabla_articulos(CAMPO_STOCK_ARTICULO,i)%>
																</td>
																<td  class="ac item_row" width="101"><%=mitabla_articulos(CAMPO_PRECIO_COSTE_ARTICULO,i)%></td>
																<td  class="ac item_row" width="101">
																	<%=mitabla_articulos(CAMPO_TOTAL_COSTE_ARTICULO,i)%>
																</td>
																<td  class="al item_row"><%=mitabla_articulos(CAMPO_PROVEEDOR_ARTICULO,i)%></td>
																<td  class="ac item_row" width="101">
																	<%=Mitabla_articulos(CAMPO_EMPRESA_ARTICULO,i)%>
																</td>
																<td  class="ac item_row" width="101">
																	<%=mitabla_articulos(CAMPO_FAMILIA_ARTICULO,i)%>
																</td>
																<td  class="ac item_row" width="101">
																	<%=mitabla_articulos(CAMPO_MOSTRAR_ARTICULO,i)%>
																</td>
															</tr>
														<%next%>
													<%else%>
														<tr> 
															<td align="center" colspan="11"><b><FONT class="fontbold">NO Hay Art&iacute;culos a Mostrar...</font></b><br>
															</td>
														</tr>
												<%end if%>
												
											</table>
									
				  
				</div>
				<br />
				
		  <div class="submit_btn_container__" align="center">	
		  
					<table width="13%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td>
							<form id="frmpasar_excel" name="frmpasar_excel" method="post" action="Informe_Stock_Valorado_Excel.asp">
								<input type="hidden" id="ocultosql" name="ocultosql" value="<%=cadena_consulta%>" />
								<input class="submitbtn" type="submit" name="nuevo_articulo" id="nuevo_articulo" value="Exportar a Excel" />
								
							</form>	
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
		
	connimprenta.close
	
	set connimprenta=Nothing

%>
</html>
