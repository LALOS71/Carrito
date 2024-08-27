<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
	if session("usuario_admin")="" then
		Response.Redirect("Login_Admin.asp")
	end if
		
	pedido_seleccionado=Request.Form("ocultopedido")
		
	'recordsets
	dim pedidos
		
		
	'variables
	dim sql
			    
	set pedidos=Server.CreateObject("ADODB.Recordset")
		
	with pedidos
		.ActiveConnection=connimprenta
		.Source="SELECT USUARIO_DIRECTORIO_ACTIVO, NombreUsuario, PEDIDOS.ID, PEDIDOS.CODCLI, V_CLIENTES.CODIGO_EXTERNO, V_CLIENTES.NOMBRE, PEDIDOS.PEDIDO, "
		.Source= .Source & " V_CLIENTES.DIRECCION, V_CLIENTES.POBLACION, V_CLIENTES.CP, V_CLIENTES.PROVINCIA, V_CLIENTES.TELEFONO, V_CLIENTES.FAX,"
		.Source= .Source & " PEDIDOS.FECHA, PEDIDOS.ESTADO as ESTADO_PEDIDO, PEDIDOS_DETALLES.ARTICULO, ARTICULOS.ID AS ID_ARTICULO, ARTICULOS.CODIGO_SAP,"
		.Source= .Source & " ARTICULOS.DESCRIPCION, PEDIDOS_DETALLES.CANTIDAD,"
		.Source= .Source & " (SELECT SUM(CANTIDAD_ENVIADA) FROM PEDIDOS_ENVIOS_PARCIALES"
		.Source= .Source & " WHERE ID_PEDIDO=PEDIDOS.ID AND ID_ARTICULO=ARTICULOS.ID) AS CANTIDAD_ENVIADA,"
		.Source= .Source & " PEDIDOS_DETALLES.PRECIO_UNIDAD,"
		.Source= .Source & " PEDIDOS_DETALLES.TOTAL, PEDIDOS_DETALLES.ESTADO as ESTADO_ARTICULO, PEDIDOS_DETALLES.FICHERO_PERSONALIZACION,"
		.Source= .Source & " PEDIDOS_DETALLES.HOJA_RUTA, PEDIDOS_DETALLES.RESTADO_STOCK,"
		.Source= .Source & " V_EMPRESAS.EMPRESA, V_EMPRESAS.CARPETA, V_EMPRESAS.ID as ID_EMPRESA, V_CLIENTES.MARCA,"
		.Source= .Source & " ARTICULOS.UNIDADES_DE_PEDIDO, PEDIDOS.FECHA_ENVIADO, PEDIDOS_DETALLES.ALBARAN,"
		.Source= .Source & " ARTICULOS_PERSONALIZADOS.PLANTILLA_PERSONALIZACION, PEDIDOS.PEDIDO_AUTOMATICO,"
		.Source= .Source & " CASE WHEN PEDIDOS_DETALLES.ALBARAN IS NULL THEN NULL ELSE" 
		.Source= .Source & " (SELECT FECHAVALIJA FROM V_DATOS_ALBARANES WHERE IDALBARAN=PEDIDOS_DETALLES.ALBARAN)"
		.Source= .Source & " END AS ENVIO_PROGRAMADO"
			
		.Source= .Source & " FROM PEDIDOS INNER JOIN PEDIDOS_DETALLES ON PEDIDOS.ID = PEDIDOS_DETALLES.ID_PEDIDO "
		.Source= .Source & " LEFT JOIN ARTICULOS ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID"
		.Source= .Source & " LEFT JOIN V_CLIENTES ON PEDIDOS.CODCLI = V_CLIENTES.Id"
		.Source= .Source & " LEFT JOIN V_EMPRESAS ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
    	.Source= .Source & " LEFT JOIN (SELECT  Usuario, max(NombreUsuario) NombreUsuario FROM V_Usuarios GROUP BY Usuario ) Us ON PEDIDOS.USUARIO_DIRECTORIO_ACTIVO = Us.Usuario"
		.Source= .Source & " LEFT JOIN ARTICULOS_PERSONALIZADOS ON PEDIDOS_DETALLES.ARTICULO=ARTICULOS_PERSONALIZADOS.ID_ARTICULO"

		.Source= .Source & " WHERE PEDIDOS.ID=" & pedido_seleccionado
		'response.write("<br>" & .source)
		.Open
	end with


	set estados=Server.CreateObject("ADODB.Recordset")
	CAMPO_ESTADO=0
	with estados
		.ActiveConnection=connimprenta
		.Source="SELECT ESTADO"
		.Source= .Source & " FROM ESTADOS"
		'porque con los envios parciales actuales no tiene sentido a no ser que se manden las misas cantidades de todos los articulos
		'.Source= .Source & " WHERE ESTADO<> 'ENVIO PARCIAL'" 
		.Source= .Source & " ORDER BY ORDEN"
		.Open
		vacio_estados=false
		if not .BOF then
			mitabla_estados=.GetRows()
			else
			vacio_estados=true
		end if
	end with


	if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
			'ENTORNO PRUEBAS
		  	entorno="PRUEBAS"
		  else
			'ENTORNO REAL
			entorno="REAL"
		end if
		



	total_pedido=0
		
    'funcion para formatear:
    ' - a 2 decimales
    ' - con separadores de miles		
    ' - con el 0 delante de valores entre 0 y 1...

    Function formatear_importe(importe)
	       if importe<>"" then				
		    importe_formateado=FORMATNUMBER(importe,2,-1,,-1)
	          else
		    importe_formateado=""
	       end if
		
		    'response.write("<br><br>" & importe_formateado)

		    formatear_importe=importe_formateado
    End Function

%>
<html>
<head>
  <title></title>
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
		
	.opaco { opacity=.30; filter: alpha(opacity=20); -moz-opacity:0.20;  } 

</style>

<style>
/*--estilos relacionados con las capas para las plantillas de personalizacion de articulos*/
.botones_agrupacion{
  
  /*background-image:url("images/Boton_Informatica.jpg");*/
  background-repeat:no-repeat;
  background-position:center;
  float:left;
    
  height:100px;
  width:100px;
  float:left;
  
  /*background: url("images/Boton_Informatica.jpg") no-repeat center center fixed; */
  
  -webkit-background-size: cover;
  -moz-background-size: cover;
  -o-background-size: cover;
  background-size: cover;
  
  /*
  filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/Boton_Informatica_.jpg', sizingMethod='scale');
  -ms-filter: "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/Boton_Informatica_.jpg', sizingMethod='scale')";
 */
 }
  
#capa_opaca__ {
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
width:940px;

margin: 75px auto;

-moz-border-radius: 20px; /* Firefox */
-webkit-border-radius: 20px; /* Google Chrome y Safari */
border-radius: 20px; /* CSS3 (Opera 10.5, IE 9 y estándar a ser soportado por todos los futuros navegadores) */
/*
behavior:url(border-radius.htc);/* IE 8.*/

}


</style>

<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>

<script language="javascript">

var j$=jQuery.noConflict();


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

	
	
function mover_formulario(objetivo){
if (objetivo=='volver')
   	accion='Lista_Articulos.asp'
	    else
	accion='Grabar_Pedido.asp';

    document.getElementById('frmpedido').action=accion
    document.getElementById('frmpedido').submit()	
	
}
   	

function informacion_adicional(articulo, cadena_stock, cadena_stock_minimo, cadena_marcas)
{
//alert(articulo + ' ' + cadena_stock + ' ' + cadena_stock_minimo + ' ' + cadena_marcas)
	
	if (cadena_stock=='')
		document.getElementById('cuadro_informacion_adicional').style.display='none'
	  else
		{
		document.getElementById('cuadro_informacion_adicional').style.display='block'
		document.getElementById('informacion_adicional_articulo').innerHTML= '&nbsp;' + articulo
		tabla_marcas=cadena_marcas.split('--')
		tabla_stocks=cadena_stock.split('--')
		tabla_stocks_minimos=cadena_stock_minimo.split('--')
		
		cadena_a_mostrar=''
		cadena_a_mostrar_minimos=''
		for (i=0;i<tabla_stocks.length;i++)
			{
				cadena_a_mostrar+=tabla_marcas[i] + ': ' + tabla_stocks[i] + '<br>'
				cadena_a_mostrar_minimos+=tabla_marcas[i] + ': ' + tabla_stocks_minimos[i] + '<br>'
			}
		document.getElementById('informacion_adicional_stock').innerHTML= '&nbsp;' + cadena_a_mostrar
		document.getElementById('informacion_adicional_stock_minimo').innerHTML= '&nbsp;' + cadena_a_mostrar_minimos
		}
}

function guardar_todo_pedido__(numero_pedido)
{
alert('..:: EN MANTENIMIENTO ::..')
}
function guardar_todo_pedido(numero_pedido)
{
	if (document.getElementById('imagen_guardar').className=='opaco')
		{
			alert('primero ha de cambiar el estado del pedido')
		}
	
	if (document.getElementById('imagen_guardar').className=='noopaco')
		{
			//alert('pedido: ' + numero_pedido + ' ... estado: ' + document.getElementById('cmbestados_general').value)
			
			//if (document.getElementById('cmbestados_general').value=='ENVIADO')
			//	{
			//	if (confirm('¿Esta Seguro de querer Pasar a "ENVIADO" el pedido ' + numero_pedido + '? \n(ya que se procederá a restar el stock de articulos, si procede...)'))
			//		{
			//			alert('en construccion...... cambiando el estado de todo el pedido')
			//			document.getElementById('ocultonumero_pedido_cambiar').value=numero_pedido
			//			document.getElementById('ocultonuevo_estado_pedido').value=document.getElementById('cmbestados_general').value
			//			document.getElementById('frmcambiar_todo_pedido').submit()
			//		}				
				
			//	}
			//else
			//	{
			//		alert('en construccion...... cambiando el estado de todo el pedido')
			//		document.getElementById('ocultonumero_pedido_cambiar').value=numero_pedido
			//		document.getElementById('ocultonuevo_estado_pedido').value=document.getElementById('cmbestados_general').value
			//		document.getElementById('frmcambiar_todo_pedido').submit()
			//	}	
			
			
			if (document.getElementById('cmbestados_general').value!='ENVIADO')
				{
				document.getElementById('ocultonumero_pedido_cambiar').value=numero_pedido
				document.getElementById('ocultonuevo_estado_pedido').value=document.getElementById('cmbestados_general').value
				document.getElementById('frmcambiar_todo_pedido').submit()
				}
			  else
			  	{
				alert('..:: EN MANTENIMIENTO ::..')
				}
			
		}
}


function ver_albaran(numero, entorno)
{

	//document.getElementById('frmalbaran').action='http://192.168.153.132/Albagrafic/default.aspx?codigo_albaran=' + numero
	//document.getElementById('frmalbaran').action='http://192.168.150.97/Albagrafic/default.aspx?codigo_albaran=' + numero+'&act=0';
	
	//nueva aplicacion de Albaranes
	if (entorno=='REAL')
		{//entorno real
		document.getElementById('frmalbaran').action='http://intranet.halconviajes.com/GlAlbaran/Glalbaran.aspx?codigo_albaran=' + numero;
		}
	  else
		{//entorno de pruebas
		document.getElementById('frmalbaran').action='http://192.168.153.132/GlAlbaran/Glalbaran.aspx?codigo_albaran=' + numero;
		}
	//alert(document.getElementById('frmalbaran').action)
	document.getElementById('frmalbaran').submit()
	//alert('EN CONSTRUCCION...')
}
</script>
<script language="vbscript">
	
	
</script>

<script type="text/javascript"> 



</script> 

<script language="javascript">
//para mostrar las capas de las plantillas de personalizacon de articulos
function mostrar_capas(capa, plantilla, cliente, anno_pedido, pedido, articulo, cantidad)
{
	//redondear capa para el internet explorer
	DD_roundies.addRule('#contenedorr3', '20px');
	document.getElementById("capa_opaca").style.height = (document.body.scrollHeight + 20) + "px";
	document.getElementById('capa_opaca').style.visibility='visible'
	
	
	texto_querystring='?plant=' + plantilla + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad + '&modo=CONSULTAR&carpeta=gag'
	document.getElementById('iframe_plantillas').src='Plantillas_Personalizacion/Plantilla_Personalizacion.asp' + texto_querystring
	document.getElementById(capa).style.visibility='visible';
	
	
	
	
}


function cerrar_capas(capa)
{	
	document.getElementById('capa_opaca').style.visibility='hidden';
	document.getElementById(capa).style.visibility='hidden';
	
	
}

function ver_estado(articulo, fila, origen)
{
document.getElementById('txtcantidad_a_enviar_' + articulo).value=''
if (document.getElementById('cmbestados_' + articulo).value=='ENVIO PARCIAL')	
	{
	//como muchos objetos se crean o no en funcion de lo que se cargue, compruebo primero
	// que el objeto existe
	//document.getElementById('fila_cantidad_enviada_parcial_' + fila).style.display='none'
	if (document.getElementById('fila_envio_parcial_' + articulo))
		{
		document.getElementById('fila_envio_parcial_' + articulo).style.display='block'
		}
	
	if (document.getElementById('imagen_cancelar_' + articulo))	
		{
		document.getElementById('imagen_cancelar_' + articulo).style.display='block'
		}
	if (origen!='COMBO')
		{
		if (document.getElementById('imagen_annadir_' + articulo))	
			{
			document.getElementById('imagen_annadir_' + articulo).style.display='block'
			}
		}
	}
  else
  	{
	if (document.getElementById('fila_envio_parcial_' + articulo))
		{
		document.getElementById('fila_envio_parcial_' + articulo).style.display='none'
		}
	if (document.getElementById('imagen_cancelar_' + articulo))
		{
		document.getElementById('imagen_cancelar_' + articulo).style.display='none'
		}
	if (document.getElementById('imagen_annadir_' + articulo))	
		{
		document.getElementById('imagen_annadir_' + articulo).style.display='none'
		}
	}

}

function mostrar_tabla_envios_parciales(articulo)
{
	if (document.getElementById('tabla_envios_parciales_' + articulo).style.display=='none')
		{
		document.getElementById('tabla_envios_parciales_' + articulo).style.display='block'
		}
	  else
	  	{
		document.getElementById('tabla_envios_parciales_' + articulo).style.display='none'
		}
}
</script>
<script src="DD_roundies_0_0_2a.js">
//para redondear esquinas en el internet explorer
</script>


</head>
<body onload="">

<!-- capa opaca para que no deje pulsar nada salvo lo que salga delante (se comporte de forma modal)-->
<div id="capa_opaca" style="visibility:hidden;background-color:#000000;position:absolute;top:0px;left:0px;width:105%;min-height:110%;z-index:2;filter:alpha(opacity=50);-moz-opacity:.5;opacity:.5">
</div>

<!-- capa con la informacion a mostrar por encima del carrito-->
<div id="capa_informacion" style="visibility:hidden;z-index:3;position:absolute;width:100%; height:100%">
		<div id="contenedorr3" class="aviso">
			<p>
				<iframe src="" style="height:450px;width:910px" frameborder="0" id="iframe_plantillas" name="iframe_plantillas"></iframe>
			</p>
		</div>
</div>
<!--*******************************************************-->

<table>
<tr>
	<td width="211" valign="top">
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
	<td width="830">
		<div id="main">
				
				<div class="comment_title_new fontbold">Datos del Pedido</div>
				<div class="comment_text" style="width:798px" id="contenido_imprimible"> 
					<form name="frmmodificar_pedido" id="frmmodificar_pedido" method="post" action="Modificar_Pedido_Admin.asp">
							<input type="hidden" name="ocultopedido" id="ocultopedido" value="<%=pedido_seleccionado%>" />
							<input type="hidden" name="ocultoarticulos_cantidades_pedido" id="ocultoarticulos_cantidades_pedido"  value="" />
							<input type="hidden" name="ocultomarca" id="ocultomarca" value="<%=pedidos("marca")%>" />
							<input type="hidden" name="ocultoacciones" id="ocultoacciones" value="" />
							<input type="hidden" name="ocultocodcli" id="ocultocodcli" value="<%=pedidos("codcli")%>" />

                            <!--7/15 añadida direccion + POblacion + `CP-->
                            <input type="hidden" name="ocultoDireccion" id="ocultoDireccion" value="<%=pedidos("direccion")%> <%=chr(10)%> <%=pedidos("cp")%> -  <%=pedidos("Poblacion")%>" />


                            
							
					<table width="98%" cellspacing="6" cellpadding="0" class="logintable" align="center">
						<tr>
							<td width="50%" class="dottedBorder vt al">
								
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
										<tr>
											<td colspan="6" style="text-align:center">Empresa: &nbsp;<font color="#000000"><b><%=pedidos("empresa")%></b></font></td>
											
										</tr>
										<tr>
											<td width="7%"  style="text-align:right">Cliente: </td>
											<td width="36%" style="text-align:CENTER">
												<font color="#000000">
												&nbsp;<b><%=pedidos("nombre")%></b>
												<%if pedidos("codigo_externo")<>"" then%>
													&nbsp;(<%=pedidos("codigo_externo")%>)
												<%end if%>
												<br /><%=pedidos("direccion")%>
												<br /><%=pedidos("poblacion")%>
												<br /><%=pedidos("cp")%>
												<br /><%=pedidos("provincia")%>
												<br />Tel.: <%=pedidos("telefono")%>
												<br />Fax: <%=pedidos("fax")%>
                                                <br />Usuario/Empleado: ( <%=pedidos("USUARIO_DIRECTORIO_ACTIVO")%>) <%=pedidos("NombreUsuario")%>
												</font>	
											
											</td>
											<td width="6%"  style="text-align:right">Marca: </td>
											<td width="15%" style="text-align:left">&nbsp;<font color="#000000"><b>
											<%estado_pedido_mostrado=pedidos("marca")%>
											<%=estado_pedido_mostrado%></b></font></td>
											<td width="8%"  style="text-align:right">Estado: </td>
											<td width="28%"  style="text-align:left">&nbsp;
												<font color="#000000"><b>
												
												<select class="txtfielddropdown" name="cmbestados_general" id="cmbestados_general" size="1" style="font-size:9px" onchange="document.getElementById('imagen_guardar').className='noopaco';document.getElementById('imagen_guardar').style.opacity=1">
														<option value=""  selected="selected">Seleccionar Estado</option>
															<%if vacio_estados=false then %>
																<%for i=0 to UBound(mitabla_estados,2)
																	if mitabla_estados(CAMPO_ESTADO_ESTADO,i)<>"ENVIO PARCIAL" THEN%>
																		<option value="<%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%>"><%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%></option>
																	<%end if%>
																<%next%>
															<%end if%>
												</select>
													<script language="javascript">
														document.getElementById('cmbestados_general').value='<%=pedidos("estado_pedido")%>'
														if ('<%=pedidos("estado_pedido")%>'=='ENVIADO')
															{
															document.getElementById("cmbestados_general").disabled=true;
															}
													</script>
													<% if pedidos("estado_pedido")<>"ENVIADO" then%>
														<img src="images/guardar.png" width="17" height="17" class="opaco" id="imagen_guardar" name="imagen_guardar" onclick="guardar_todo_pedido(<%=pedido_seleccionado%>)"/>
														<script language="javascript">
															document.getElementById('imagen_guardar').style.opacity=.40
														</script>
													<%end if%>
												
												<%
													estado_general_pedido=pedidos("estado_pedido")
													'response.write("<br>" & estado_general_pedido)
												%>
												</b></font></td>
										</tr>
							  </table>
								
						  </td>
						</tr>
				  </table>
					
					<br />
					<TABLE width="660" id="tabla_leyendas">
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
							<TD width="80">
								<table width="80" height="20" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td width="20"  style="border:1px solid #CCCCCC;background-color:#CCCCCC"></td>
										<td width="60">&nbsp;Anulado</td>
									</tr>
						  	  </table>
								
							</TD>
						</TR>
					</TABLE>
					<BR />
					
					<table width="793">
						<tr>
							<td width="785">
								<div id="main">
											
								<table border="0" cellpadding="1" cellspacing="1" width="100%" class="info_table">
									<tr style="background-color:#FCFCFC" valign="top">
										<th class="menuhdr" colspan="10">
											Pedido Numero: <font size="2" color="#000000"><%=pedido_seleccionado%></FONT>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											Fecha Petición: <font size="2" color="#000000"><%=pedidos("fecha")%></font>
											<%if ucase(estado_general_pedido)="ENVIADO" then%>
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												Fecha Envío: <font size="2" color="#000000"><%=pedidos("fecha_enviado")%></font>
											<%end if%>
											<%if pedidos("PEDIDO_AUTOMATICO")<>"" then%>
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												Pedido Automatico: <font size="2" color="#880000"><b>
													<%
														tipo_pedido_auto=pedidos("PEDIDO_AUTOMATICO")
														response.write(tipo_pedido_auto)
													%>
													</b></font>
											<%end if%>
													
										</th>
									</tr>
									<tr style="background-color:#FCFCFC" valign="top">
										<th class="menuhdr">Cod. Sap</th>
										<th class="menuhdr">Artículo</th>
										<th class="menuhdr">Cant.</th>
										<th class="menuhdr">Precio</th>
										<th class="menuhdr">Total</th>
										<th class="menuhdr">Estado</th>
										<th class="menuhdr">Hoja Ruta</th>
										<th width="23" class="menuhdr" style="text-align:center">
											<img src="images/clip-16.png" />
										</th>
										<th class="menuhdr">Alb.</th>
										<th class="menuhdr" title="Fecha del Envio Programado">Envio Prog.</th>
									</tr>
									<%if pedidos.eof then%>
										<tr> 
											<td bgcolor="#999966" align="center" colspan="10"><b><FONT class="fontbold">El 
												Pedido No Tiene Articulos...</font></b><br>
											</td>
										</tr>
									<%end if%>
												
									<%cadena_articulos_cantidades_pedido=""%>
									<%fila=1%>
									<%while not pedidos.eof%>
										<%albaran_asociado="" & pedidos("ALBARAN")%>
										<%'los meto con formato "articulo1::cantidad1::--articulo2::cantidad2::SI"
										if cadena_articulos_cantidades_pedido="" then
											cadena_articulos_cantidades_pedido=pedidos("articulo") & "::" & pedidos("cantidad") & "::" & pedidos("restado_stock")
											else
											cadena_articulos_cantidades_pedido=cadena_articulos_cantidades_pedido & "--" & pedidos("articulo") & "::" & pedidos("cantidad") & "::" & pedidos("restado_stock")
										end if
													
										'response.write("br>" & cadena_articulos_pedido)						
                                        'RESPONSE.WRITE("<BR> Articulo"+ CStr(pedidos("ID_ARTICULO")))
                                        if IsNull(pedidos("ID_ARTICULO")) then
                                            idArticulo = "0"
                                        else
                                            idArticulo = pedidos("ID_ARTICULO")
                                                                                           
                                         end if
                                         %>

										<%'controlamos los stocks para mostrarlos y colorear las filas
										set articulos_marcas=Server.CreateObject("ADODB.Recordset")
										sql="SELECT V_CLIENTES_MARCA.MARCA, a.ID_ARTICULO, a.STOCK, a.STOCK_MINIMO"
										sql=sql & " FROM V_CLIENTES_MARCA LEFT JOIN"
										sql=sql & " (SELECT ARTICULOS_MARCAS.ID_ARTICULO, ARTICULOS_MARCAS.MARCA, ARTICULOS_MARCAS.STOCK, ARTICULOS_MARCAS.STOCK_MINIMO"
										sql=sql & " FROM ARTICULOS_MARCAS"
										'sql=sql & " WHERE ARTICULOS_MARCAS.ID_ARTICULO=" & pedidos("ID_ARTICULO") & ") as a"
                                            sql=sql & " WHERE ARTICULOS_MARCAS.ID_ARTICULO=" & idArticulo & ") as a"
										sql=sql & " ON V_CLIENTES_MARCA.MARCA = a.MARCA"
										sql=sql & " WHERE V_CLIENTES_MARCA.EMPRESA=" & pedidos("ID_EMPRESA")
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
											cadena_stocks=""
											cadena_stocks_minimos=""
											cadena_marcas=""
							                for j=0 to UBound(mitabla_articulos_marca,2)
																
												if cadena_stocks="" then
													cadena_stocks=cadena_stocks & mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)
													else
													cadena_stocks=cadena_stocks & "--" & mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)
												end if
												if cadena_stocks_minimos="" then
													cadena_stocks_minimos=cadena_stocks_minimos & mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)
													else
													cadena_stocks_minimos=cadena_stocks_minimos & "--" & mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)
												end if
												if cadena_marcas="" then
													cadena_marcas=cadena_marcas & mitabla_articulos_marca(CAMPO_MARCA_ARTICULOS_MARCAS,j)
													else
													cadena_marcas=cadena_marcas & "--" & mitabla_articulos_marca(CAMPO_MARCA_ARTICULOS_MARCAS,j)
												end if
																		
												'ahora controlo de que color sale la fila
												if mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)<>"" or mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)<>"" then
													articulo_con_control_stock="SI"
													if mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)<>"" and mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j)<>"" then
														if mitabla_articulos_marca(CAMPO_STOCK_ARTICULOS_MARCAS,j)<= mitabla_articulos_marca(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,j) then
															alerta_articulo_stock="SI"
														end if
													end if
																			
												end if
											next
										end if
										%>
																
									<tr style="background-color:#FCFCFC" valign="top" onmouseover="informacion_adicional('<%=pedidos("DESCRIPCION")%>','<%=cadena_stocks%>', '<%=cadena_stocks_minimos%>', '<%=cadena_marcas%>')">
										<td id="fila_pedido_<%=fila%>_codigo_sap" class="ac item_row" width="72" align="right">
											<%if pedidos("ID_EMPRESA")=1 then 'BARCELÓ 
												carpeta_marca=pedidos("marca")&"/"
												else
												carpeta_marca=""
												end if
											%>
											<a href="Imagenes_Articulos/<%=carpeta_marca%><%=pedidos("ID_ARTICULO")%>.jpg" target="_blank">
												<font size="2" color="#000000"><%=pedidos("CODIGO_SAP")%></font>
											</a>
										</td>
										<td id="fila_pedido_<%=fila%>_descripcion" class="item_row" style="text-align:left" width="213">
											<font size="2" color="#000000"><%=pedidos("DESCRIPCION")%></font>
											<%
												unidades_pedido="" & pedidos("unidades_de_pedido")
												if unidades_pedido<>"" then%>
													<br /><font color="#000000">(en <%=unidades_pedido%>)</font>
												<%end if%>
												
											<%'29-06-2016...  comprobamos si ha de ser un articulo personalizable
												'y luego añadimos a los campos ocultos el valor de la plantilla y si es personalizable o no
												articulo_personalizado="NO"
												plantilla_personalizacion= "" & pedidos("PLANTILLA_PERSONALIZACION")
												if plantilla_personalizacion<>"" THEN
													articulo_personalizado="SI"
												end if
												'response.write("<br>articulo_personalizado: " & articulo_personalizado)	
											
												if articulo_personalizado="SI" then
													carpeta_anno=""
													if pedidos("fecha")<>"" then
														carpeta_anno=year(pedidos("fecha"))
													end if
													pedido_modificar=pedidos("id")
													id=pedidos("articulo")
													cantidad=pedidos("cantidad")
													
													carpeta=""
													if pedidos("empresa")="ABBA HOTELES" OR pedidos("empresa")="BARCELO" then
														carpeta=""
													end if
													if pedidos("empresa")="BE LIVE" _ 
															OR pedidos("empresa")="HALCON" _  
															OR pedidos("empresa")="ECUADOR" _ 
															OR pedidos("empresa")="GROUNDFORCE" _
															OR pedidos("empresa")="AIR EUROPA" _
															OR pedidos("empresa")="CALDERON" _
															OR pedidos("empresa")="HALCON VIAGENS" _
															OR pedidos("empresa")="TRAVELPLAN" _
															OR pedidos("empresa")="TUBILLETE" _
															then
														carpeta="GAG/"
													end if
													
													if pedidos("empresa")="ATESA" then
														carpeta="ATESA/"
													end if
													if pedidos("empresa")="ASM" then
														carpeta="GAG/"
													end if
													'-----9/6/16 ---
													if pedidos("empresa")="GEOMOON" then
														carpeta="GEO/"
													end if
													
												%>
													<img src="images/paper_verde_16x16.png" 
														border=0
														title="Plantilla Para Personalizar el Articulo"
														onclick="mostrar_capas('capa_informacion', '<%=plantilla_personalizacion%>','<%=pedidos("codcli")%>', '<%=carpeta_anno%>', '<%=pedido_modificar%>', '<%=id%>', '<%=cantidad%>')" style="cursor:pointer"
														/>
												<%end if%>
											
										</td>
										<td id="fila_pedido_<%=fila%>_cantidad" width="45" class="item_row" style="text-align:right"><font size="2" color="#000000"><%=pedidos("cantidad")%></font>&nbsp;</td>
										<td id="fila_pedido_<%=fila%>_precio_unidad" class="item_row" style="text-align:right" width="75"><font size="2" color="#000000"><%=pedidos("precio_unidad")%> €/u</font>&nbsp;</td>
										<td id="fila_pedido_<%=fila%>_total" class="item_row" width="68" style="text-align:right">
											<font size="2" color="#000000">
														
												<%
												response.write(formatear_importe(pedidos("total")))
												'los detalles de pedido anulados no acumulan importe en el total del pedido
												if pedidos("estado_articulo")<>"ANULADO" then
													total_pedido=total_pedido + pedidos("total")
												end if
												%>
															
													€</font>&nbsp;
										</td>
										<td id="fila_pedido_<%=fila%>_estado" width="142">
											<div id="tabla_estado_<%=fila%>" style="width:100%">
														<select  name="cmbestados_<%=pedidos("articulo")%>" id="cmbestados_<%=pedidos("articulo")%>" style="font-size:9px;width:138px" onchange="ver_estado('<%=pedidos("articulo")%>','<%=fila%>', 'COMBO')">
														<%if vacio_estados=false then %>
															<%for i=0 to UBound(mitabla_estados,2)%>
																<%'de momento no saco los de envio parcial porque da un error raro
																'if mitabla_estados(CAMPO_ESTADO,i)<>"ENVIO PARCIAL" then%>
																	<option value="<%=mitabla_estados(CAMPO_ESTADO,i)%>"><%=mitabla_estados(CAMPO_ESTADO,i)%></option>
																<%'end if%>
															<%next%>
															<!--AÑADO ESTE AL FINAL MANUALMENTE PORQUE ES UN ESTADO QUE SOLO PUEDE PONER LA IMPRENTA
															Y SOLO EN LOS DETALLES-->
															<option value="ANULADO">ANULADO</option>
														<%end if%>
														</select>
														<script language="javascript">
															document.getElementById("cmbestados_<%=pedidos("articulo")%>").value='<%=pedidos("estado_articulo")%>'
															if ((document.getElementById("cmbestados_<%=pedidos("articulo")%>").value=='ENVIADO') && ('<%=pedidos("ALBARAN")%>'!=''))
																{
																document.getElementById("cmbestados_<%=pedidos("articulo")%>").disabled=true;
																}
															j$("#cmbestados_<%=pedidos("articulo")%>").prop('oldvalue', '<%=pedidos("estado_articulo")%>');
														</script>
											</div>
											<%
											cantidad_enviada_total=""
											'si hay cantidad enviada previamente qu ela muestre, sea cual sea el estado
											'IF pedidos("estado_articulo")="ENVIO PARCIAL" THEN
											IF pedidos("CANTIDAD_ENVIADA")<>"" THEN
												cantidad_enviada_total=pedidos("CANTIDAD_ENVIADA")%>
												<div id="fila_cantidad_enviada_parcial_<%=fila%>" align="center" style="width:100%">
													<font color="#000000">Cantidad ya Enviada:</font>
													<br />
													<font color="#000000" size="3" style="cursor:pointer" onclick="mostrar_tabla_envios_parciales('<%=pedidos("articulo")%>')" title="Pulsar para mostrar/ocultar el detalle de envios"><b><%=pedidos("CANTIDAD_ENVIADA")%></b></font>
													
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<img src="images/Eliminar.png" width="15" height="15" 
															id="imagen_cancelar_<%=pedidos("articulo")%>"
															border=0 style="cursor:pointer;float:right;display:none"
															title="Cancelar"
															onclick="document.getElementById('txtcantidad_a_enviar_<%=pedidos("articulo")%>').value='';
																	document.getElementById('fila_envio_parcial_<%=pedidos("articulo")%>').style.display='none';
																	this.style.display='none';
																	document.getElementById('imagen_annadir_<%=pedidos("articulo")%>').style.display='block'"
															/>
														<img src="images/Annadir.png" width="15" height="15" 
															id="imagen_annadir_<%=pedidos("articulo")%>"
															border=0 style="cursor:pointer;float:right;display:none"
															title="enviar mas cantidad de producto"
															onclick="ver_estado('<%=pedidos("articulo")%>','<%=fila%>', 'IMAGEN');
																	document.getElementById('imagen_annadir_<%=pedidos("articulo")%>').style.display='none'"
															/>
														<%IF pedidos("estado_articulo")="ENVIO PARCIAL" then%>
															<script language="javascript">
																document.getElementById('imagen_annadir_<%=pedidos("articulo")%>').style.display='block'
															</script>
														<%end if%>
													
												</div>
												
											
											<%
												set envios_parciales=Server.CreateObject("ADODB.Recordset")
		
												with envios_parciales
													.ActiveConnection=connimprenta
													.Source="SELECT CANTIDAD_ENVIADA, FECHA, ALBARAN FROM PEDIDOS_ENVIOS_PARCIALES"
													.Source= .Source & " WHERE ID_PEDIDO=" & PEDIDO_SELECCIONADO
													
													.Source= .Source & " AND ID_ARTICULO=" & pedidos("articulo")
													.Source= .Source & " ORDER BY FECHA"
													'response.write("<br>" & .source)
													.Open
												end with

											
												IF not envios_parciales.eof then%>
													<table width="100%"  border="0" cellspacing="0" cellpadding="0" id="tabla_envios_parciales_<%=pedidos("articulo")%>" style="display:none">
														<tr>
															<th scope="col">Fecha</th>
															<th scope="col">Cantidad</th>
														</tr>
														<%while not envios_parciales.eof%>
															<tr>
																<td><%=envios_parciales("fecha")%></td>
																<td align="center">
																	<%=envios_parciales("cantidad_enviada")%>
																	<%if envios_parciales("albaran")<>"" then%>
																		<img src="images/paper_16x16.png" 
																			border=0
																			title="Albar&aacute;n <%=envios_parciales("albaran")%>"
																			onclick="ver_albaran('<%=envios_parciales("albaran")%>', '<%=entorno%>')"
																			style="cursor:pointer"
																			/>
																	<%end if%>
																</td>
															</tr>
														<%
															envios_parciales.movenext
														wend%>
													</table>
												<%end if
												
												envios_parciales.close
												set envios_parciales=Nothing
												%>
											<%end if%>
											<input type="hidden" id="ocultocantidad_enviada_total_<%=pedidos("articulo")%>" name="ocultocantidad_enviada_total_<%=pedidos("articulo")%>" value="<%=cantidad_enviada_total%>" />
											<div id="fila_envio_parcial_<%=pedidos("articulo")%>" name="fila_envio_parcial_<%=pedidos("articulo")%>" style="display:none;width:100%">
												<font color="#000000">Cantidad a Enviar:</font>
												<br />
												<input size="5" type="text" name="txtcantidad_a_enviar_<%=pedidos("articulo")%>" id="txtcantidad_a_enviar_<%=pedidos("articulo")%>" value="" />
											</div>

										</td>
										<td id="fila_pedido_<%=fila%>_hoja_ruta" class="item_row" width="65" style="text-align:right">
											<input size="10" type="text" name="txthoja_ruta_<%=pedidos("articulo")%>" id="txthoja_ruta_<%=pedidos("articulo")%>" value="" />
											<script language="javascript">
												document.getElementById("txthoja_ruta_<%=pedidos("articulo")%>").value='<%=pedidos("hoja_ruta")%>'
											</script>
										</td>
										<td id="fila_pedido_<%=fila%>_fichero_personalizacion" class="ac item_row" width="23">
											<%
											if pedidos("fichero_personalizacion")<>"" then
												
												
												cadena_enlace=""
												if pedidos("empresa")="ABBA HOTELES" OR pedidos("empresa")="BARCELO" then
													cadena_enlace=""
												end if
												
												if pedidos("empresa")="BE LIVE" _ 
														OR pedidos("empresa")="HALCON" _  
														OR pedidos("empresa")="ECUADOR" _ 
														OR pedidos("empresa")="GROUNDFORCE" _
														OR pedidos("empresa")="AIR EUROPA" _
														OR pedidos("empresa")="CALDERON" _
														OR pedidos("empresa")="HALCON VIAGENS" _
														OR pedidos("empresa")="TRAVELPLAN" _
														OR pedidos("empresa")="TUBILLETE" _
														OR pedidos("empresa")="GEOMOON" _
														then
													cadena_enlace="GAG/"
												end if
												
												if pedidos("empresa")="ATESA" then
													cadena_enlace="ATESA/"
												end if
												if pedidos("empresa")="ASM" then
													cadena_enlace="GAG/"
												end if
                                                
                                                'if pedidos("empresa")="GEOMOON" then
												'	cadena_enlace="GEO/"
												'end if
															
												
												cadena_enlace=cadena_enlace & "pedidos/" & year(pedidos("FECHA")) & "/" & pedidos("CODCLI") & "__" & pedido_seleccionado
												cadena_enlace=cadena_enlace & "/" & pedidos("fichero_personalizacion")
												%>
												<a href="<%=cadena_enlace%>" target="_blank"><img src="images/clip-16.png" border=0/></a>
															
											<%end if%>
										</td>
										<td id="fila_pedido_<%=fila%>_albaran" width="50" class="item_row" style="text-align:right"><font size="1" color="#000000">
										<%if pedidos("albaran")<>"" then%>
											<div onclick="ver_albaran('<%=pedidos("albaran")%>', '<%=entorno%>')" style="text-decoration:none;color:#000000;cursor:pointer;cursor:hand">
												<%=pedidos("albaran")%>
											</div>
										<%end if%>
										</font>&nbsp;</td>
										<td id="fila_pedido_<%=fila%>_envio_programado" width="50" class="item_row" style="text-align:right"><font size="1" color="#000000">
											<%=pedidos("envio_programado")%>
										</font>&nbsp;</td>			
									</tr>
									
									<%'coloreo la fila si tiene control de stock o esta el detalle anulado
									color_fila=""
									
									if articulo_con_control_stock="SI" then
										if alerta_articulo_stock="NO" then
											color_fila="#3399CC"	'"#99CC99"   '"#66CC99"
										else
											color_fila="#FF6633"
										end if
									end if
									if pedidos("estado_articulo")="ANULADO" then
											color_fila="#CCCCCC"
									end if
									if color_fila<>"" then
									%>
										<script language="javascript">
											document.getElementById('fila_pedido_<%=fila%>_codigo_sap').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_descripcion').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_cantidad').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_precio_unidad').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_total').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_estado').style.backgroundColor='<%=color_fila%>'
											document.getElementById('tabla_estado_<%=fila%>').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_hoja_ruta').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_fichero_personalizacion').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_albaran').style.backgroundColor='<%=color_fila%>'
											document.getElementById('fila_pedido_<%=fila%>_envio_programado').style.backgroundColor='<%=color_fila%>'
																	
										</script>
													
									<%end if%>
												
									<%
										pedidos.movenext
										fila=fila+1
									Wend
												
									%>
						
									<tr>
										<td style="border-top:1px solid #000000;height:2" colspan="8"></td>
									</tr>
											
									<tr style="background-color:#FCFCFC" valign="top">
										<th class="menuhdr" style="text-align:right" colspan="4"><font color="#000000">Total...</font></th>
										<th class="menuhdr" style="text-align:right"><font color="#000000"><%=formatear_importe(round(total_pedido,2))%> €</font></th>
										<td colspan="5"></td>
									</tr>
									
										<%resultado_descuento=0%>
										<%if tipo_pedido_auto="PRIMER_PEDIDO_REDYSER" then%>
											<tr style="background-color:#FCFCFC" valign="top">
												<th class="menuhdr" style="text-align:right" colspan="4"><font color="#880000">Descuento Primer Pedido 50% (Max. 800€) </font></th>
												<th class="menuhdr" style="text-align:right"><font color="#880000">
													<%
													
													resultado_descuento = total_pedido * 0.50
													if resultado_descuento>800 then
														resultado_descuento=800
													end if
													resultado_descuento = round(resultado_descuento, 2)
													response.write(formatear_importe(resultado_descuento))
													%>
													€
													
													</font></th>
												<td colspan="5"></td>
											</tr>
											<tr style="background-color:#FCFCFC" valign="top">
												<th class="menuhdr" style="text-align:right" colspan="4"><font color="#880000">Total Precio Final</font></th>
												<th class="menuhdr" style="text-align:right"><font color="#880000">
													<%
													resultado_total_descuento = round((total_pedido - resultado_descuento), 2)
													response.write(formatear_importe(resultado_total_descuento))
													%>
													€
													
													</font></th>
												<td colspan="5"></td>
										<%end if%>										
	
									<tr style="background-color:#FCFCFC" valign="top">
										<th class="menuhdr" style="text-align:right" colspan="4"><font  color="#000000">IVA del 21% (<%=round(((total_pedido - resultado_descuento) * 0.21),2)%>)</font></th>
										<th class="menuhdr" style="text-align:right"><font  color="#000000">
													
											<%
											resultado_iva=((total_pedido - resultado_descuento) * 0.21)
											iva_21= round(resultado_iva,2)
											response.write(formatear_importe(iva_21))
											%> 
											€
											</font>
										</th>
										<td colspan="5"></td>
													
									</tr>
									<tr style="background-color:#FCFCFC" valign="top">
										<th class="menuhdr" style="text-align:right" colspan="4"><font  color="#000000">Total Importe a Pagar</font></th>
										<th class="menuhdr" style="text-align:right"><font  color="#000000">
											<%
												total_pago_iva=(total_pedido - resultado_descuento) + iva_21
															
												response.write(formatear_importe(round(total_pago_iva,2)))
											%> 
											€
										</font></th>
										<td colspan="5"></td>
													
									</tr>
								</table>
									                                
                                </div>						
							</td>
					  </tr>
					  </table>
						<br />
						<table id="cuadro_informacion_adicional" width="790" cellspacing="0" cellpadding="0" class="logintable" align="center" style="border: 1px dotted #cccccc;background-color: #F9F9F9;">
						<tr>
							<td width="9%"  style="text-align:right">Articulo: </td>
							<td width="36%" style="text-align:left"><b><div id="informacion_adicional_articulo"></div></b></td>
							<td width="6%"  style="text-align:right">Stock: </td>
							<td width="21%"  style="text-align:left"><b><div id="informacion_adicional_stock" align="center"></div></b></td>
							<td width="12%"  style="text-align:right">Stock Minimo: </td>
							<td width="16%"  style="text-align:left"><b><div id="informacion_adicional_stock_minimo" align="center"></div></b></td>
						</tr>
						</table>
				  </form>
				</div>
		  <div class="submit_btn_container" style="width:808px">	
		  
				
					<table width="84%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td width="111">
								<%if estado_general_pedido<>"ENVIADO" THEN%>
									<a href="#" onclick="guardar_pedido('<%=cadena_articulos_cantidades_pedido%>', 'GUARDAR')" class="btn-details"><font color="#FFFFFF">Guardar</font></a>
								<%end if%>
							</td>
							<td width="137">
							</td>
							<td width="145">
								<a href="#" onclick="guardar_pedido('<%=cadena_articulos_cantidades_pedido%>', 'ALBARAN')" class="btn-details"><font color="#FFFFFF">Crear Albarán</font></a>
							</td>
							<td width="170">
							</td>
							<td width="116">
								<%
								cadena_imprimir_inicio="<html><head><link href=""estilos.css"" rel=""stylesheet"" type=""text/css/"" media=""all""></head><BODY>"
								cadena_imprimir_final="</BODY></HTMIL>"
								
																				
								%>
								<a href="#" onclick="javascript:imprSelec('contenido_imprimible');
														function imprSelec(muestra)
														{var ficha=document.getElementById(muestra);
														var ventimp=window.open(' ','popimpr');
														ventimp.document.write('<html><head>');
														ventimp.document.write('</head>');
														ventimp.document.write('<BODY>');
														ventimp.document.write(ficha.innerHTML);
														ventimp.document.write('<script language=javascript>');
														ventimp.document.write('var head = document.getElementsByTagName(\'head\')[0];');
														ventimp.document.write('var link = document.createElement(\'link\');');
														ventimp.document.write('link.id = \'cssId\';');
														ventimp.document.write('link.rel = \'stylesheet\';');
														ventimp.document.write('link.type = \'text/css\';');
														ventimp.document.write('link.href = \'estilos.css\';');
														ventimp.document.write('link.media = \'all\';');
														ventimp.document.write('head.appendChild(link);')
														ventimp.document.write('document.getElementById(\'tabla_leyendas\').style.display = \'none\';');
														ventimp.document.write('document.getElementById(\'cuadro_informacion_adicional\').style.display = \'none\';');
														ventimp.document.write('</script>');
														ventimp.document.write('</BODY></HTMIL>');
														ventimp.document.close();
														ventimp.print();
														ventimp.close();
														};"
									 class="btn-details"><font color="#FFFFFF">Imprimir</font></a>
							</td>
						</tr>
			</table>
					  
		  </div>
			
		</div>
	</td>
  </tr>
</table>
<BR /><BR />

<form name="frmcambiar_todo_pedido" id="frmcambiar_todo_pedido" method="post" action="Cambiar_Estado_Todo_Pedido.asp">
	<input type="hidden" id="ocultonumero_pedido_cambiar" name="ocultonumero_pedido_cambiar" value="" />
	<input type="hidden" id="ocultonuevo_estado_pedido" name="ocultonuevo_estado_pedido" value="" />
	<input type="hidden" id="ocultomarca_cambio" name="ocultomarca_cambio" value="<%=estado_pedido_mostrado%>" />
</form>

<form name="frmalbaran" id="frmalbaran" method="post" action="" target="_blank">
</form>

<script language="javascript">
	//****************************************
	// con este javascript adaptamos la altura de la capa opaca a la altura del documento, para que no
	//   se pueda pulsar nada cuando esta visible la capa de la informacion de las trajetas
	//document.getElementById('capa_opaca').style.minHeight='110%'
	//alert(window.innerHeight)
	//alert(document.height)
	var B = document.body, 
	   	H = document.documentElement,
    	height

	if (typeof document.height !== 'undefined') 
		{
		height = document.height // For webkit browsers
		} 
	  else 
	  	{
		height = Math.max( B.scrollHeight, B.offsetHeight,H.clientHeight, H.scrollHeight, H.offsetHeight );
		}
	//alert(height)
	height=height + 100
	document.getElementById('capa_opaca').style.minHeight=height + 'px'
	
	//document.getElementById('capa_opaca').style.minHeight='110%'
	//alert(height)
	
	
function guardar_pedido(cadena_articulos_cantidades, accion){
    //console.log('dentro de guardar pedido...')
	//console.log('cadena articulos cantidades: ' + cadena_articulos_cantidades)
	//alert('cadena articulos: ' + cadena_articulos)
    //alert('cadena articulos: ' + document.getElementById('ocultito').value)
    //document.getElementById('ocultopedido').value=document.getElementById('ocultito').value
    //alert('cadena a tratar: ' + cadena_articulos_cantidades)
    tabla_articulos_cantidades=cadena_articulos_cantidades.split('--')
    //alert('tamaño de elementos: ' + tabla_articulos_cantidades.length)
	texto_error=''
    permitir_guardar_pedido='SI'
    for (i=0;i<tabla_articulos_cantidades.length;i++)    {
	    //alert('segunda cadena a tratar: ' + tabla_articulos_cantidades[i])
	    articulo_cantidad=tabla_articulos_cantidades[i].split('::')
	
	    //alert('valor de txthoja_ruta_' + articulo_cantidad[0] + ': ' + document.getElementById('txthoja_ruta_' + articulo_cantidad[0]).value)
	    //alert('valor de cmbestados_' + articulo_cantidad[0] + ': ' + document.getElementById('cmbestados_' + articulo_cantidad[0]).value)	
	    //pongo esto porque si no se pierde el estado en la siguiente pagina
	    document.getElementById('cmbestados_' + articulo_cantidad[0]).disabled=false;
	    /*    ya no es obligatorio poner la hoja de ruta en cada articulo del pedido
	    if ((document.getElementById('cmbestados_' + articulo_cantidad[0]).value!='SIN TRATAR') && (document.getElementById('cmbestados_' + articulo_cantidad[0]).value!='RECHAZADO'))
		    {
			    if (document.getElementById('txthoja_ruta_' + articulo_cantidad[0]).value=='')
				    {
					    permitir_guardar_pedido='NO'
				    }
		    }
	    */
		//controlamos que si se selecciona el envio parcial se haya introducido la cantidad a enviar
		//console.log('articulo: ' + articulo_cantidad[0])
		//console.log('fila_envio_parcial_' + articulo_cantidad[0] + ': ' + document.getElementById('fila_envio_parcial_' + articulo_cantidad[0]).value)
		//console.log('cmbestados_' + articulo_cantidad[0] + ': ' + document.getElementById('cmbestados_' + articulo_cantidad[0]).value)
		//console.log('txtcantidd_a_enviar_' + articulo_cantidad[0] + ': ' + document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value)
		//console.log('contenido de txtcantidad_a_enviar_' + articulo_cantidad[0] + ': ' + document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value)
		//console.log('display de txtcantidad_a_enviar_' + articulo_cantidad[0] + ': ' + document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).style.display)
		//console.log('display de fila_envio_parcial_' + articulo_cantidad[0] + ': ' + document.getElementById('fila_envio_parcial_' + articulo_cantidad[0]).style.display)
		
		
		if ((document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='ENVIO PARCIAL') && (document.getElementById('fila_envio_parcial_' + articulo_cantidad[0]).style.display=='block') && (document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value==''))
			{
			permitir_guardar_pedido='NO'
			texto_error=texto_error + '\n\t- En Los Envios Parciales de Articulos, se ha de indicar la cantidad enviada.'
			}
					
		//console.log('vemos si es un envio parcial y si tiene cantidad enviada para:')
		//console.log('cmbestados_' + articulo_cantidad[0] + ': ' + document.getElementById('cmbestados_' + articulo_cantidad[0]).value)
		//console.log('txtcantidad_a_enviar_' + articulo_cantidad[0] + ': ' + document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value)

		if ((document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='ENVIO PARCIAL') && (document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value!=''))
		    {
				//console.log('comprobamos si nos pasamos de la cantidad enviada')
				total_a_enviar=articulo_cantidad[1]
				cantidad_ya_enviada=document.getElementById('ocultocantidad_enviada_total_' + articulo_cantidad[0]).value
				if (cantidad_ya_enviada=='')
					{
					cantidad_ya_enviada=0
					}
				cantidad_a_enviar=document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value
				if (cantidad_a_enviar=='')
					{
					cantidad_a_enviar=0
					}
				//console.log('total_a_enviar: ' + total_a_enviar)
				//console.log('cantidad_ya_enviada: ' + cantidad_ya_enviada)
				//console.log('cantidad_a_enviar: ' + cantidad_a_enviar)
				//console.log('suma cantidad ya enviada + cantidad a enviar: ' + (parseInt(cantidad_ya_enviada) + parseInt(cantidad_a_enviar)))
				
				if (parseInt(total_a_enviar) < (parseInt(cantidad_ya_enviada) + parseInt(cantidad_a_enviar)))
					{
					//console.log('la cantidad a enviar supera lo que falta por enviar de ese producto')
					permitir_guardar_pedido='NO'
					texto_error=texto_error + '\n\t- Falta Por Enviar Menos Cantidad de La Que Se Indica.'
					}
			    
		    }
		
		//compruebo que lo que se quiere enviar no supere el stock existente	
		if ((document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='ENVIO PARCIAL') || (document.getElementById('cmbestados_' + articulo_cantidad[0]).value=='ENVIADO'))
			{
			
			
			stock_buscado=''
			valor_combo_nuevo=''
			valor_combo_antiguo=''
			valor_combo_nuevo=document.getElementById('cmbestados_' + articulo_cantidad[0]).value
			valor_combo_antiguo=j$('#cmbestados_' + articulo_cantidad[0]).prop('oldvalue')
			
			j$.ajax({
				type: "post",        
				async:false,    
				cache:false, 
				url: 'Obtener_Stock_Ficha_Articulo.asp?q=' + articulo_cantidad[0],
				success: function(respuesta) {
							  //console.log('el stock es de: ' + respuesta)
							//console.log('STOCK DEL ARTICULO ' + articulo_cantidad[0] + ': ' + respuesta)  
							stock_buscado=respuesta
							},
				error: function() {
							//console.log('error al ver el stock del articulo ' + articulo_cantidad[0])
							alert('error al ver el stock del articulo ' + articulo_cantidad[0])
					}
			});
				
			cantidad_control=''
			if (valor_combo_nuevo=='ENVIO PARCIAL')
				{
				cantidad_control=document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value
				}
			  else
				{
				if ((valor_combo_nuevo=='ENVIADO') && (valor_combo_antiguo=='ENVIO PARCIAL'))
					{
					cantidad_ya_enviada=document.getElementById('ocultocantidad_enviada_total_' + articulo_cantidad[0]).value
					//cantidad_a_enviar=document.getElementById('txtcantidad_a_enviar_' + articulo_cantidad[0]).value
					cantidad_control=articulo_cantidad[1] - cantidad_ya_enviada
					}
				  else
				  	{
					cantidad_control=articulo_cantidad[1]
					}
				}
				
			//console.log('CANTIDAD A ENVIAR DEL ARTICULO ' + articulo_cantidad[0] + ': ' + cantidad_control) 
			//console.log('propiedad olvalue de cmbestados_' + articulo_cantidad[0] + ': ' + valor_combo_antiguo)
			//console.log('valor combo nuevo cmbestados_' + articulo_cantidad[0] + ': ' + valor_combo_nuevo)
			
			codigo_referencia=''
			j$('#cmbestados_' + articulo_cantidad[0]).closest("tr").find("td:first-child a:first-child font:first-child").each(function(){
                codigo_referencia+=j$(this).html();
            });
 
            //console.log(codigo_referencia);
			
			//si lo ponemos en enviado desde otro estado, comprobamos que haya stock disponible
			if ((valor_combo_nuevo!=valor_combo_antiguo) || (valor_combo_nuevo=='ENVIO PARCIAL'))
				{
					//console.log('STOCK DEL ARTICULO a comparar ' + articulo_cantidad[0] + ': ' + stock_buscado)  
					//console.log('CANTIDAD DEL ARTICULO a comparar ' + articulo_cantidad[0] + ': ' + cantidad_control)  
					
						if (parseFloat(stock_buscado)<parseFloat(cantidad_control))
							{
								permitir_guardar_pedido='NO'
								texto_error=texto_error + '\n\t- Para el Artículo (' + codigo_referencia + ') Solo se Puede Enviar Como Máximo ' + stock_buscado + ' Unidades, que es Su Stock Actual...'
							}
				}
			} //FIN if ENVIO PARCIAL o ENVIADO
		 		
    }
	
	
	
	
	
	if (permitir_guardar_pedido=='SI')
	{
	    document.getElementById('ocultoarticulos_cantidades_pedido').value=cadena_articulos_cantidades
	    //alert('hola')
	    document.getElementById('ocultoacciones').value=accion
	    document.getElementById('frmmodificar_pedido').submit()
	}
  else
  	{
	    //alert('Para gestionar el Pedido, Han de indicarse las Hojas de Ruta de los Articulos Tratados')
		alert(texto_error)
	}
}// guardar_pedido --

</script>

</body>
<%
	pedidos.close
	estados.close	
	connimprenta.close
	
	set pedidos=Nothing
	set estados=Nothing
	set connimprenta=Nothing

%>
</html>
