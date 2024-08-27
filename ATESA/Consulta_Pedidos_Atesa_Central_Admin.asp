<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<%
		response.Buffer=true
		numero_registros=0
		
		if session("usuario")="" then
			Response.Redirect("../Login_ATESA.asp")
		end if
		
		cliente_seleccionado=Request.Form("cmbclientes")
		estado_seleccionado=Request.Form("cmbestados")
		numero_pedido_seleccionado=Request.Form("txtpedido")
		fecha_i=Request.Form("txtfecha_inicio")
		fecha_f=Request.Form("txtfecha_fin")
		
		if cliente_seleccionado="" and estado_seleccionado="" and numero_pedido_seleccionado="" and fecha_i="" and fecha_f="" then
				estado_seleccionado="PENDIENTE AUTORIZACION"
		end if
		
		
		
		
		'recordsets
		dim pedidos
		
		
		'variables
		dim sql
		
		
		'porque el sql de produccion es un sql expres que debe tener el formato de
		' de fecha con mes-dia-año, y al lanzar consultas con fechas da error o
		' da resultados raros
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	    
	    set pedidos=Server.CreateObject("ADODB.Recordset")
		
		with pedidos
			.ActiveConnection=connimprenta
			.Source="SELECT  V_CLIENTES.EMPRESA, V_CLIENTES.CODIGO_EXTERNO, V_CLIENTES.NOMBRE, PEDIDOS.ID, PEDIDOS.CODCLI, PEDIDOS.PEDIDO,"
			.Source= .Source & " PEDIDOS.FECHA, PEDIDOS.ESTADO, PEDIDOS.FECHA_ENVIADO"
			.Source= .Source & " FROM  PEDIDOS INNER JOIN V_CLIENTES"
			.Source= .Source & " ON PEDIDOS.CODCLI = V_CLIENTES.Id"
			.Source= .Source & " WHERE V_CLIENTES.EMPRESA=" & session("usuario_codigo_empresa") 
			if estado_seleccionado<>"" then
				.Source= .Source & " AND PEDIDOS.ESTADO='" & estado_seleccionado & "'"
			end if
			if cliente_seleccionado<>"" then
				.Source= .Source & " AND PEDIDOS.CODCLI=" & cliente_seleccionado
			end if
			if numero_pedido_seleccionado<>"" then
				.Source= .Source & " AND PEDIDOS.ID=" & numero_pedido_seleccionado
			end if
			
			if fecha_i<>"" then
				.Source= .Source & " AND (PEDIDOS.FECHA >= '" & fecha_i & "')" 
			end if
			if fecha_f<>"" then
				.Source= .Source & " AND (PEDIDOS.FECHA <= '" & fecha_f & "')"
			end if
			
			
			
			.Source= .Source & " ORDER BY PEDIDOS.FECHA desc, V_CLIENTES.NOMBRE desc"
			.Open
		end with

		

dim clientes
		set clientes=Server.CreateObject("ADODB.Recordset")
		
		'sql="Select id, nombre  from hoteles"
		'sql=sql & " order by nombre"
		
		sql="SELECT  V_CLIENTES.Id, V_EMPRESAS.EMPRESA, V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
		sql=sql & " FROM V_CLIENTES INNER JOIN V_EMPRESAS"
		sql=sql & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
		sql=sql & " WHERE V_EMPRESAS.EMPRESA='" & session("usuario_empresa") & "'"
		sql=sql & " ORDER BY V_EMPRESAS.EMPRESA, V_CLIENTES.NOMBRE"
		
		'response.write("<br>" & sql)
		
		with clientes
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
		



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
   		accion='Lista_Articulos_Atesa.asp'
	  else
	  	accion='Grabar_Pedido_Atesa.asp';
	document.getElementById('frmpedido').action=accion
	document.getElementById('frmpedido').submit()	
	

   }
   
   
</script>

<script type="text/javascript"> 
// Visit DynamicDrive.com 
// OJO NOMBRE DEL IFRAME OJO Cambia solo esto. 
var iframeids=["detalle"] 
//Should script hide iframe from browsers that don't support this script (non IE5+/NS6+ browsers. Recommended): 
var iframehide="yes" 

var getFFVersion=navigator.userAgent.substring(navigator.userAgent.indexOf("Firefox")).split("/")[1] 
var FFextraHeight=parseFloat(getFFVersion)>=0.1? 16 : 0 //extra height in px to add to iframe in FireFox 1.0+ browsers 

function resizeCaller() { 
var dyniframe=new Array() 
for (i=0; i<iframeids.length; i++){ 
if (document.getElementById) 
resizeIframe(iframeids[i]) 
//reveal iframe for lower end browsers? (see var above): 
if ((document.all || document.getElementById) && iframehide=="no"){ 
var tempobj=document.all? document.all[iframeids[i]] : document.getElementById(iframeids[i]) 
tempobj.style.display="block" 
} 
} 
} 

function resizeIframe(frameid){ 
var currentfr=document.getElementById(frameid) 
if (currentfr && !window.opera){ 
currentfr.style.display="block" 
if (currentfr.contentDocument && currentfr.contentDocument.body.offsetHeight) //ns6 syntax 
currentfr.height = currentfr.contentDocument.body.offsetHeight+FFextraHeight; 
else if (currentfr.Document && currentfr.Document.body.scrollHeight) //ie5+ syntax 
currentfr.height = currentfr.Document.body.scrollHeight; 
if (currentfr.addEventListener) 
currentfr.addEventListener("load", readjustIframe, false) 
else if (currentfr.attachEvent){ 
currentfr.detachEvent("onload", readjustIframe) // Bug fix line 
currentfr.attachEvent("onload", readjustIframe) 
} 
} 
} 

function readjustIframe(loadevt) { 
var crossevt=(window.event)? event : loadevt 
var iframeroot=(crossevt.currentTarget)? crossevt.currentTarget : crossevt.srcElement 
if (iframeroot) 
resizeIframe(iframeroot.id); 
} 

function loadintoIframe(iframeid, url){ 
if (document.getElementById) 
document.getElementById(iframeid).src=url 
} 

if (window.addEventListener) 
window.addEventListener("load", resizeCaller, false) 
else if (window.attachEvent) 
window.attachEvent("onload", resizeCaller) 
else 
window.onload=resizeCaller 

function mostrar_detalle(pedido)
{
document.getElementById('detalle').src='Pedido_Detalles_Atesa.asp?pedido=' + pedido
}


var flecha; 

function detener() 
{ 
   clearInterval(flecha); 
} 

function subir() 
{ 
    flecha=setInterval(function(){ 
  document.getElementById("contenidos").scrollTop -=8; 
  },50); 
} 

function bajar() 
{ 
{ 
    flecha=setInterval(function(){ 
  document.getElementById("contenidos").scrollTop +=8; 
  },50); 
} 
} 


function modificar_pedido(numero_pedido, accion)
{
		document.getElementById("ocultopedido_a_modificar").value=numero_pedido
		document.getElementById("ocultoaccion").value=accion
		document.getElementById("frmmodificar_pedido").submit()
		
}
	
function borrar_pedido(numero_pedido,fecha_pedido)
{
	if (confirm('¿Seguro Que Desea Borrar el Pedido Número ' + numero_pedido + '?'))
		{
		document.getElementById("ocultopedido_a_borrar").value=numero_pedido
		document.getElementById("ocultofecha_pedido").value=fecha_pedido
		document.getElementById("frmborrar_pedido").submit()
		}
}
	
</script> 

<!-- European format dd-mm-yyyy -->
	<script language="JavaScript" src="../js/calendario/calendar1.js"></script>
<!-- Date only with year scrolling -->

<script src="DD_roundies_0_0_2a.js"></script>
<script src="../funciones.js" type="text/javascript"></script>
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
<body onload="cerrar_capas('capa_informacion')" >
<!-- capa opaca para que no deje pulsar nada salvo lo que salga delante (se comporte de forma modal)-->
<div id="capa_opaca" style="display:none;background-color:#000000;position:fixed;top:0px;left:0px;width:105%;min-height:110%;z-index:5;filter:alpha(opacity=50);-moz-opacity:.5;opacity:.5">
</div>

<!-- capa con la informacion a mostrar por encima-->
<div id="capa_informacion" style="display:none;z-index:6;position:fixed;width:100%; height:100%">
		<div id="contenedorr3" class="aviso">
			<p>
				<img src="../images/loading4.gif"/>
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
	<td width="713">
		<div id="main">
				
		
		
		
		
		
				<div class="comment_title fontbold">Pedidos Realizados Por <%=session("usuario_empresa")%></div>
				<div class="comment_text"> 
					<form name="frmconsulta_pedidos" action="Consulta_Pedidos_Atesa_Central_Admin.asp" method="post">
					<table width="99%" cellspacing="6" cellpadding="0" class="logintable" align="center">
						<tr>
							<td width="50%" class="dottedBorder vt al">
								
			  
								
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
										<tr>
											<td width="7%">Cliente: </td>
											<td width="53%">
												<!--
												<select class="txtfielddropdown" name="cmbhoteles" id="cmbhoteles" size="1" onfocus="alert('en el focus')" onblur="alert('en el blur')" onchange="alert('en el change')">
												-->
													<select class="txtfielddropdown" name="cmbclientes" id="cmbclientes" size="1">
														<option value=""  selected="selected">Seleccionar Cliente</option>
														<%while not clientes.eof%>
															<%
															'texto_mostrar=clientes("EMPRESA") & " - " & clientes("nombre")
															texto_mostrar=clientes("nombre")
															if clientes("codigo_externo")<>"" then
																texto_mostrar=texto_mostrar & " (" & clientes("codigo_externo") & ")"
															end if
															%>
															<option value="<%=clientes("id")%>"><%=texto_mostrar%></option>
															<%clientes.movenext%>
														<%wend%>
													</select>
													<%if cliente_seleccionado<>"" then%>
														<script language="javascript">
															document.getElementById('cmbclientes').value=<%=cliente_seleccionado%>
														</script>
													<%end if%>
													
													
										  </td>
												<td width="10%">N. Pedido: </td>
												<td width="30%">
													<input class="txtfield" name="txtpedido" id="txtpedido" value="<%=numero_pedido_seleccionado%>" size="8" />
												</td>
									  </tr>
											
							  </table>
										<table width="306" cellpadding="0" cellspacing="0">
											<tr><td height="3"></td></tr>
										</table>
										
										<table cellpadding="2" cellspacing="1" border="0" width="100%">
											<tr>
												<td width="7%">Estado: </td>
												<td width="38%">
													<select class="txtfielddropdown" name="cmbestados" id="cmbestados" size="1">
														<option value=""  selected="selected">Seleccionar Estado</option>
														<option value="PENDIENTE AUTORIZACION">PENDIENTE AUTORIZACION</option>
														<option value="SIN TRATAR">SIN TRATAR</option>
														<option value="RECHAZADO">RECHAZADO</option>
														<option value="EN PROCESO">EN PROCESO</option>
														<option value="EN PRODUCCION">EN PRODUCCION</option>
														<option value="ENVIADO">ENVIADO</option>
													</select>
													<%if estado_seleccionado<>"" then%>
														<script language="javascript">
															document.getElementById("cmbestados").value='<%=estado_seleccionado%>'
														</script>
													<%end if%>
												</td>
												<td  style="padding:10px" width="9%"><font style="COLOR:#000000"><b>F. Ini.:</b></font></td>
												<td width="16%">
													<input type="Text" class="txtfield" name="txtfecha_inicio" id="txtfecha_inicio" value="<%=fecha_i%>" size=7>
													<a href="javascript:cal1.popup();"><img src="../img/cal.gif" width="16" height="16" border="0" alt="Pulsa Aqui para Seleccionar una Fecha de Inicio"></a>
												
												
												</td>
												<td width="6%"><font style="COLOR:#000000"><b>F. Fin:</b></font> </td>
												<td width="15%">
													<input type="Text" class="txtfield" name="txtfecha_fin" id="txtfecha_fin" value="<%=fecha_f%>" size=7>
													<a href="javascript:cal2.popup();"><img src="../img/cal.gif" width="16" height="16" border="0" alt="Pulsa Aqui para Seleccionar una Fecha de Fin"></a>
												
												
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
					</form>
				
				
				
				
				
				
				
				
				
				
					<form name="frmpedido" id="frmpedido" action="Grabar_Pedido_Atesa.asp" method="post">
					<table border="0" cellpadding="0" cellspacing="0" width="97%" align="center">
					<tr>
						<td width="98%" height="8"></td>
						<td width="2%">
							<a href="#" onMouseOver="subir()" onMouseOut="detener()"  style="text-decoration:none "><img src="../images/Flecha_Arriba.gif" border="0" /></a></td>
					</tr>
					<tr>
						<td>
							
							<div id="contenidos" style="height:200px; overflow:hidden">
							<table border="0" cellpadding="1" cellspacing="1" width="100%" class="info_table" align="center">
								<tr style="background-color:#FCFCFC" valign="top">
									<th class="menuhdr" width="185">Cliente</th>
									<th class="menuhdr" width="79">Num. Pedido</th>
									<th class="menuhdr" width="70">Fecha</th>
									<th class="menuhdr" width="134">Estado</th>
									<th class="menuhdr" width="177">Acciones</th>
									
								</tr>
								
								
								
								<%if pedidos.eof then%>
									<tr> 
										<td bgcolor="#999966" align="center" colspan="5"><b><FONT class="fontbold">Aún No Se Han Realizado Pedidos...</font></b><br>
										</td>
									</tr>
								<%end if%>
								
								
								
								<%while not pedidos.eof%>
											<%if numero_registros=200 then
													response.Flush()
													numero_registros=0
												else
													numero_registros=numero_registros + 1
											end if%>
											
											<tr style="background-color:#FCFCFC;cursor:hand;cursor:pointer" valign="top" onmouseover="javascript:this.style.background='#ffc9a5';" onmouseout="javascript:this.style.background='#FCFCFC'">
												<td valign="middle" width="185" class="ac item_row" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("NOMBRE")%>
													<%if pedidos("codigo_externo")<>"" then%>
														&nbsp;(<%=pedidos("CODIGO_EXTERNO")%>)
													<%end if%>
											  </td>
												<td class="ac item_row" width="79" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("id")%></td>
												<td class="ac item_row" width="70" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("fecha")%></td>
												<td width="134" class="ac item_row"  valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("estado")%></td>
												<td width="177" class="ac item_row"  valign="middle">
													<%if pedidos("estado")="PENDIENTE AUTORIZACION" then%>
														<table width="90%" border="0" cellpadding="0" cellspacing="0">
																<tr>
																	<td width="18%"><a href="#" onclick="borrar_pedido(<%=pedidos("id")%>,'<%=pedidos("fecha")%>')" class="fontbold"><img src="../images/Eliminar.png" border="0" height="20" width="20" title="Borrar Pedido" /></a></td>
																	<td width="34%">&nbsp;</td>
																	<td width="10%"><a href="#" onclick="modificar_pedido(<%=pedidos("id")%>, 'CONFIRMAR')" class="fontbold"><img src="../images/Confirmar.png" border="0" height="20" width="20" title="Confirmar Pedido" /></a></td>
																	<td width="34%">&nbsp;</td>
																	<td width="11%"><a href="#" onclick="modificar_pedido(<%=pedidos("id")%>, 'MODIFICAR')" class="fontbold"><img src="../images/icono_modificar.png" border="0" height="20" width="20" title="Modificar Pedido" /></a></td>
																</tr>
														</table>
													<%end if%>
												
												</td>
												
											</tr>
											
								
								
								
								
								
								<%		
									pedidos.movenext
								Wend
								
								%>
		
								
							</table>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<td></td>
						<td>
							<a href="#" onMouseOver="bajar()" onMouseOut="detener()"  style="text-decoration:none "><img src="../images/Flecha_Abajo.gif" border="0" /></a></td>
					</tr>
					
					
				  </table>
							
							
					<iframe id="detalle" name="detalle" src="Pedido_Detalles_Atesa.asp" width="850px" scrolling="no" frameborder="0" allowtransparency="yes"></iframe> 
					</form>
				</div>
		  <div class="submit_btn_container">	
		  
					
		  
		  </div>

		
		
			
			

					
					
					
					
					
					
			
			
			
			
		</div>

	
	
	
	</td>
</tr>


</table>




















<form action="Modificar_Pedido_Atesa_Central_Admin.asp" method="post" name="frmmodificar_pedido" id="frmmodificar_pedido">
	<input type="hidden" id="ocultopedido_a_modificar" name="ocultopedido_a_modificar" value="" />
	<input type="hidden" id="ocultoaccion" name="ocultoaccion" value="" />
</form>
<form action="Eliminar_Pedido_Atesa.asp" method="post" name="frmborrar_pedido" id="frmborrar_pedido">
	<input type="hidden" id="ocultopedido_a_borrar" name="ocultopedido_a_borrar" value="" />
	<input type="hidden" id="ocultofecha_pedido" name="ocultofecha_pedido" value="" />
	<input type="hidden" id="ocultoorigen" name="ocultoorigen" value="ADMIN" />
</form>

<script language="JavaScript">
		
			var cal1 = new calendar1(document.getElementById('txtfecha_inicio'));
			cal1.year_scroll = true;
			cal1.time_comp = false;
	
			var cal2 = new calendar1(document.getElementById('txtfecha_fin'));
			cal2.year_scroll = true;
			cal2.time_comp = false;
	
	</script>
	
</body>
<%
	'articulos.close
	clientes.close
	set clientes=Nothing
	
	
	pedidos.close
	set pedidos=Nothing
	
	connimprenta.close
	set connimprenta=Nothing

%>
</html>
