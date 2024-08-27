<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		if session("usuario")="" then
			Response.Redirect("Login.asp")
		end if
		
		
		'recordsets
		dim pedidos
		
		
		'variables
		dim sql
		
		

	    
	    set pedidos=Server.CreateObject("ADODB.Recordset")
		
		with pedidos
			.ActiveConnection=connimprenta
			.Source="SELECT * FROM PEDIDOS WHERE CODCLI=" & session("usuario") & " ORDER BY FECHA desc, id desc"
			.Open
		end with

		




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
   
   
function borrar_pedido(numero_pedido,fecha_pedido)
{
	if (confirm('¿Seguro Que Desea Borrar el Pedido Número ' + numero_pedido + '?'))
		{
		document.getElementById("ocultopedido_a_borrar").value=numero_pedido
		document.getElementById("ocultofecha_pedido").value=fecha_pedido
		document.getElementById("frmborrar_pedido").submit()
		}
}
	
	
function modificar_pedido(numero_pedido)
{
	document.getElementById("ocultopedido_a_modificar").value=numero_pedido
	document.getElementById("frmmodificar_pedido").submit()
	
}	
</script>
<script language="vbscript">
	
	
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
document.getElementById('detalle').src='Pedido_Detalles.asp?pedido=' + pedido
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
</script> 




</head>
<body >


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
				<font size="3"><b>Datos del Cliente</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					<b><%=session("usuario_empresa")%></b>
					<%if session("usuario_codigo_externo") <> "" then%>
						<b>&nbsp;-&nbsp;<%=session("usuario_codigo_externo")%></b>
					<%end if%>
					<br />
					<b><%=session("usuario_nombre")%></b>
					<br />
					<%=session("usuario_marca")%>
					<br />
					<%=session("usuario_direccion")%>
					<br /> 
					<%=session("usuario_poblacion")%>
					<br />
					<%=session("usuario_cp")%>&nbsp;<%=session("usuario_provincia")%>
					<br />
					Tel: <%=session("usuario_telefono")%>
					<br />
					Fax: <%=session("usuario_fax")%>
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
					<br />
					<div class="info">
					<table width="95%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td width="50%">
								<a href="Carrito.asp" class="btn-details"><font color="#FFFFFF">Ver Pedido</font></a>
							</td>
							<td width="50%">
								<a href="Vaciar_Carrito.asp" class="btn-details"><font color="#FFFFFF">Borrar Pedido</font></a>
							</td>
						</tr>
					</table>
					</div>
					
				</div>
				</div>
			</div>
		</div>
		
		<div class="sidebarcell">
			
			<div id="side_freetext_title_39" class="title">
				<br />
				<font size="3"><b>Pedidos Realizados</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					· <a href="Consulta_Pedidos.asp">Consultar</a>
					
				  <div class="info">				  </div>
					
				</div>
				</div>
			</div>
		</div>
		
		
		
	</td>
	<td width="713">
		<div id="main">
				
		
		
		
		
		
				<div class="comment_title fontbold">Pedidos Realizados</div>
				<div class="comment_text"> 
					<form name="frmpedido" id="frmpedido" action="Grabar_Pedido.asp" method="post">
					<table border="0" cellpadding="0" cellspacing="0" width="92%" align="center">
					<tr>
						<td width="98%" height="8"></td>
						<td width="2%">
							<a href="#" onMouseOver="subir()" onMouseOut="detener()"  style="text-decoration:none "><img src="images/Flecha_Arriba.gif" border="0" /></a></td>
					</tr>
					<tr>
						<td>
							
							<div id="contenidos" style="height:200px; overflow:hidden">
							<table border="0" cellpadding="1" cellspacing="1" width="100%" class="info_table" align="center">
								<tr style="background-color:#FCFCFC" valign="top">
									<th class="menuhdr" width="107">Num. Pedido</th>
									<th class="menuhdr" width="113">Fecha</th>
									<th class="menuhdr" width="183">Estado</th>
									<th class="menuhdr" width="211">Acción</th>
								</tr>
								
								
								
								<%if pedidos.eof then%>
									<tr> 
										<td bgcolor="#999966" align="center" colspan="4"><b><FONT class="fontbold">Aún No Se Han Realizado Pedidos...</font></b><br>
										</td>
									</tr>
								<%end if%>
								
								
								
								<%while not pedidos.eof%>
		
											
											<tr style="background-color:#FCFCFC;cursor:hand;cursor:pointer" valign="top" onmouseover="javascript:this.style.background='#ffc9a5';" onmouseout="javascript:this.style.background='#FCFCFC'">
												<td class="ac item_row" width="107" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("id")%></td>
												<td class="ac item_row" width="113" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("fecha")%></td>
												<td width="183" class="ac item_row"  valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("estado")%></td>
												<td width="211" class="ac item_row">
													<%
													'veo si todos los articulos del pedido estan sin tratar, si es asi, dejo que se borre
													set articulos_pedido=Server.CreateObject("ADODB.Recordset")
													with articulos_pedido
														.ActiveConnection=connimprenta
														.Source="SELECT * FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedidos("id") & " AND ESTADO<>'SIN TRATAR'"
														.Open
													end with
													
													if articulos_pedido.eof then
													%>
														<table width="90%" border="0" cellpadding="0" cellspacing="0">
															<tr>
																<td width="10%"><img src="images/Eliminar.png" border="0" height="16" width="16" /></td>
																<td width="18%"><a href="#" onclick="borrar_pedido(<%=pedidos("id")%>,'<%=pedidos("fecha")%>')" class="fontbold">Quitar</a></td>
																<td width="34%">&nbsp;</td>
																<td width="11%"><img src="images/icono_modificar.png" border="0" height="16" width="16" /></td>
																<td width="27%"><a href="#" onclick="modificar_pedido(<%=pedidos("id")%>)" class="fontbold">Modificar</a></td>
															</tr>
														</table>
													<%
													end if
													articulos_pedido.close
													set articulos_pedido=Nothing
													%>
													
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
							<a href="#" onMouseOver="bajar()" onMouseOut="detener()"  style="text-decoration:none "><img src="images/Flecha_Abajo.gif" border="0" /></a></td>
					</tr>
					
					
				  </table>
							
							
					<iframe id="detalle" name="detalle" src="Pedido_Detalles.asp" width="850px" scrolling="no" frameborder="0" allowtransparency="yes"></iframe> 
					</form>
				</div>
		  <div class="submit_btn_container">	
		  
					<table width="13%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td>
								<a href="Lista_Articulos.asp" class="btn-details"><font color="#FFFFFF">Volver</font></a>
							</td>
						</tr>
			</table>
		  
		  </div>

		
		
			
			

					
					
					
					
					
					
			
			
			
			
		</div>

	
	
	
	</td>
</tr>


</table>



















<form action="Eliminar_Pedido.asp" method="post" name="frmborrar_pedido" id="frmborrar_pedido">
	<input type="hidden" id="ocultopedido_a_borrar" name="ocultopedido_a_borrar" value="" />
	<input type="hidden" id="ocultofecha_pedido" name="ocultofecha_pedido" value="" />
</form>

<form action="Rellenar_Variables_Sesion.asp" method="post" name="frmmodificar_pedido" id="frmmodificar_pedido">
	<input type="hidden" id="ocultopedido_a_modificar" name="ocultopedido_a_modificar" value="" />
</form>

</body>
<%
	'articulos.close
	
	connimprenta.close
	
	set articulos=Nothing
	
	set connimprenta=Nothing

%>
</html>
