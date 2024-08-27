<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<%
		response.Buffer=true
		numero_registros=0
		
		if session("usuario")="" then
			Response.Redirect("../Login_ATESA.asp")
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
<link href="../estilos.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../plugins/font-awesome_4_7_0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="../plugins/octicons_6_0_1/lib/octicons.css">

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
<script language="text/javascript">

	
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
</script> 


<script src="../funciones.js" type="text/javascript"></script>
<script language="javascript">

//para mostrar las nuevas plantillas
function mostrar_capas_new(capa, plantilla, cliente, anno_pedido, pedido, articulo, cantidad)
{
	//redondear capa para el internet explorer
	//DD_roundies.addRule('#contenedorr3', '20px');
	/*
	var heights = window.innerHeight;
	console.log('altura ventana: ' + window.innerHeight)
	console.log('altura ventana con jquery: ' + $(window).height())
	console.log('altura opaca: ' + document.getElementById("capa_opaca").style.height )
	
	console.log('document.documentElement.clientHeight: ' + document.documentElement.clientHeight)
    console.log('document.body.scrollHeight: ' + document.body.scrollHeight)
    console.log('document.documentElement.ssrollHeight: ' + document.documentElement.scrollHeight)
    console.log('document.body.offsetHeight: ' + document.body.offsetHeight)
    console.log('document.documentElement.offsetHeight: ' + document.documentElement.offsetHeight)
	
	*/
    
	
	
	texto_campos=''
	fichero_plantilla= plantilla + '.asp'
	plantilla_personalizacion=plantilla

	//console.log('fichero plantilla: ' + fichero_plantilla)
	//console.log('plantilla personalizacion: ' + plantilla_personalizacion)
		
	//console.log('texto paraametro campos: ' + texto_campos)
	texto_querystring='?plant=' + plantilla_personalizacion + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad	+ '&modo=CONSULTAR&carpeta=ATESA' + texto_campos
		
	url_iframe='../Plantillas_Personalizacion/' + fichero_plantilla + texto_querystring
	
	//console.log('texto querystring: ' + texto_querystring)
	//console.log('url ifrmae: ' + url_iframe)
		
	
	
	$("#cabecera_nueva_plantilla").html('Plantilla a Rellenar');
    
    $('#iframe_nueva_plantilla').attr('src', url_iframe)
    $("#capa_nueva_plantilla").modal("show");
	
	
	
	
}



function mostrar_capas(capa)
{
	//redondear capa para el internet explorer
	//DD_roundies.addRule('#contenedorr3', '20px');
	document.getElementById('capa_opaca').style.display=''
	document.getElementById(capa).style.display='';
}

function cerrar_capas(capa)
{	
	document.getElementById('capa_opaca').style.display='none';
	document.getElementById(capa).style.display='none';
}




ver_factura = function(factura, ejercicio) {
	//console.log('factura: ' + factura)
	//console.log('ejercicio: ' + ejercicio)
	
	
	$.ajax({
            type: "POST",
            contentType: "application/json; charset=UTF-8",
            async: false,
            url: "../Genfactura/wsGag_1.asmx/ImprimeFactura",
            data: '{idFactura: '+ factura +   
                ', Ejercicio: ' + ejercicio +
            '}',
            dataType: "json",
            success:
                function (data) {
					//alert('Se ha generdo la factura ' + factura);
					var win = window.open('', '_blank');
				    win.location.href = '../GenFactura/informes/Fact_' + factura + '_' + ejercicio + '.pdf';	
					//console.log('antes de elimiar factura')
					
					setTimeout(function() {
							//console.log('eliminamos despues del paron')
						    eliminar_factura(factura, ejercicio)
					}, (3 * 1000));
					
				 },
            error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            },
        });

	
	
}; 


ver_albaran = function(albaran) {
	//console.log('factura: ' + factura)
	//console.log('ejercicio: ' + ejercicio)
	
	
	$.ajax({
            type: "POST",
            contentType: "application/json; charset=UTF-8",
            async: false,
            url: "../Genfactura/wsGag_1.asmx/imprimeAlbaran",
            data: '{idAlbaran: '+ albaran + '}',
            dataType: "json",
            success:
                function (data) {
					//alert('Se ha generdo la factura ' + factura);
					var win = window.open('', '_blank');
				    win.location.href = '../GenFactura/informes/Alb_' + albaran + '.pdf';	
					//console.log('antes de elimiar factura')
					
					setTimeout(function() {
							//console.log('eliminamos despues del paron')
						    eliminar_albaran(albaran)
					}, (3 * 1000));
					
				 },
            error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            },
        });

	
	
}; 


eliminar_albaran = function(albaran) {
	//console.log('factura a borrar: ' + factura)
	//console.log('ejercicio a borrar: ' + ejercicio)
	
	parametros='tipo_fichero=ALBARAN&albaran=' + albaran
		
	  $.ajax({
	  	type: "POST",
		contentType: "application/json; charset=UTF-8",
		async: false,
		url: "../GenFactura/Borrar_Albaran_Factura.asp?" + parametros,
		//data: parametros,
		dataType: "json",
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		
		
		/*
		async: false,
		url:'../GenFactura/Borrar_Factura.asp', //Url a donde la enviaremos
		type:'POST', //Metodo que usaremos
		contentType:false, //Debe estar en false para que pase el objeto sin procesar
		//data:data, //Le pasamos el objeto que creamos con los archivos
		data: '{factura: '+ factura +   
                ', ejercicio: ' + ejercicio +
            '}',
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		cache:false, //Para que el formulario no guarde cache
		*/
        error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            }

	  })
	
	
	
}; 


eliminar_factura = function(factura, ejercicio) {
	//console.log('factura a borrar: ' + factura)
	//console.log('ejercicio a borrar: ' + ejercicio)
	
	parametros='tipo_fichero=FACTURA&factura=' + factura + '&ejercicio=' + ejercicio
		
	  $.ajax({
	  	type: "POST",
		contentType: "application/json; charset=UTF-8",
		async: false,
		url: "../GenFactura/Borrar_Albaran_Factura.asp?" + parametros,
		//data: parametros,
		dataType: "json",
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		
		
		/*
		async: false,
		url:'../GenFactura/Borrar_Factura.asp', //Url a donde la enviaremos
		type:'POST', //Metodo que usaremos
		contentType:false, //Debe estar en false para que pase el objeto sin procesar
		//data:data, //Le pasamos el objeto que creamos con los archivos
		data: '{factura: '+ factura +   
                ', ejercicio: ' + ejercicio +
            '}',
		processData:false, //Debe estar en false para que JQuery no procese los datos a enviar
		cache:false, //Para que el formulario no guarde cache
		*/
        error: {
                function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
            }

	  })
	
	
	
}; 

</script>

<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>


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
							<td width="31%" align="right"><img src="../images/Carrito_48x48.png" border="0" /></td>
							<td width="69%">&nbsp;<b><%=session("numero_articulos")%></b> Artículos</td>
						</tr>
					</table>
					
					<br />
					<br />
					<div class="info">
					<table width="95%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td width="50%">
								<a href="Carrito_Atesa.asp" class="btn-details"><font color="#FFFFFF">Ver Pedido</font></a>
							</td>
							<td width="50%">
								<a href="Vaciar_Carrito_Atesa.asp" class="btn-details"><font color="#FFFFFF">Borrar Pedido</font></a>
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
					· <a href="Consulta_Pedidos_Atesa.asp">Consultar</a>
					
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
					<form name="frmpedido" id="frmpedido" action="Grabar_Pedido_Atesa.asp" method="post">
					<table border="0" cellpadding="0" cellspacing="0" width="92%" align="center">
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
											<%if numero_registros=200 then
													response.Flush()
													numero_registros=0
												else
													numero_registros=numero_registros + 1
											end if%>
											
											<tr style="background-color:#FCFCFC;cursor:hand;cursor:pointer" valign="top" onmouseover="javascript:this.style.background='#ffc9a5';" onmouseout="javascript:this.style.background='#FCFCFC'">
												<td class="ac item_row" width="107" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("id")%></td>
												<td class="ac item_row" width="113" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("fecha")%></td>
												<td width="183" class="ac item_row"  valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("estado")%></td>
												<td width="211" class="ac item_row">
													<%
													'veo si todos los articulos del pedido estan en AUTORIZANDO CENTRAL, si es asi, dejo que se borre y modifique
													set articulos_pedido=Server.CreateObject("ADODB.Recordset")
													with articulos_pedido
														.ActiveConnection=connimprenta
														.Source="SELECT * FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedidos("id") & " AND ESTADO<>'PENDIENTE AUTORIZACION'"
														.Open
													end with
													
													if articulos_pedido.eof then
													%>
														<table width="90%" border="0" cellpadding="0" cellspacing="0">
															<tr>
																<td width="10%"><img src="../images/Eliminar.png" border="0" height="16" width="16" /></td>
																<td width="18%"><a href="#" onclick="borrar_pedido(<%=pedidos("id")%>,'<%=pedidos("fecha")%>')" class="fontbold">Quitar</a></td>
																<td width="34%">&nbsp;</td>
																<td width="11%"><img src="../images/icono_modificar.png" border="0" height="16" width="16" /></td>
																<td width="27%"><a href="#" onclick="modificar_pedido(<%=pedidos("id")%>)" class="fontbold">Modificar</a></td>
															</tr>
														</table>
													<%
													end if
													articulos_pedido.close
													set articulos_pedido=Nothing
													%>
													
													<%	
														if pedidos("estado")="ENVIO PARCIAL" or pedidos("estado")="ENVIADO" then
															set albaranes=Server.CreateObject("ADODB.Recordset")													
															set facturas=Server.CreateObject("ADODB.Recordset")
															
															with albaranes
																.ActiveConnection=connimprenta
																.Source="SELECT * FROM V_DATOS_ALBARANES"
																.Source= .Source & "  WHERE NPEDIDO = '" & pedidos("id") & "'"
																.Source= .Source & "  AND ANULADO=0"
																
																'response.write("<br>albaranes: " & .source)
																.Open
															end with
															
															if not albaranes.eof then
																while not albaranes.eof
																%>
																	  <span title="Albar&aacute;n&nbsp;<%=albaranes("IDALBARAN")%>">
																	  <svg class="octicon octicon-package  text-success" viewBox="0 0 16 16" version="1.1" height="16" width="16" aria-hidden="true" style="cursor:pointer;vertical-align:top"
																			title="" 
																			onclick="ver_albaran(<%=albaranes("IDALBARAN")%>)"
																			>
																		<path fill-rule="evenodd" d="M1 4.27v7.47c0 .45.3.84.75.97l6.5 1.73c.16.05.34.05.5 0l6.5-1.73c.45-.13.75-.52.75-.97V4.27c0-.45-.3-.84-.75-.97l-6.5-1.74a1.4 1.4 0 0 0-.5 0L1.75 3.3c-.45.13-.75.52-.75.97zm7 9.09l-6-1.59V5l6 1.61v6.75zM2 4l2.5-.67L11 5.06l-2.5.67L2 4zm13 7.77l-6 1.59V6.61l2-.55V8.5l2-.53V5.53L15 5v6.77zm-2-7.24L6.5 2.8l2-.53L15 4l-2 .53z"></path>
																	  </svg>
																	  </span>
																	  
																<%
																	albaranes.movenext
																wend
	
																albaranes.close
																set albaranes=Nothing
															end if
															
														end if
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
							<a href="#" onMouseOver="bajar()" onMouseOut="detener()"  style="text-decoration:none "><img src="../images/Flecha_Abajo.gif" border="0" /></a></td>
					</tr>
					
					
				  </table>
							
							
					<iframe id="detalle" name="detalle" src="Pedido_Detalles_Atesa.asp" width="850px" scrolling="no" frameborder="0" allowtransparency="yes"></iframe> 
					</form>
				</div>
		  <div class="submit_btn_container">	
		  
					<table width="13%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td>
								<a href="Lista_Articulos_Atesa.asp" class="btn-details"><font color="#FFFFFF">Volver</font></a>
							</td>
						</tr>
			</table>
		  
		  </div>

		
		
			
			

					
					
					
					
					
					
			
			
			
			
		</div>

	
	
	
	</td>
</tr>


</table>




<!-- capa nuevas plantillas -->
  <div class="modal fade" id="capa_nueva_plantilla">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_nueva_plantilla"></h4>	    
        </div>	    
        <div class="modal-body">
          <form class="form-horizontal row-border">
            <div class="form-group">
              <!--
              <iframe id='gmv.iframe_movilidad' src="" width="100%" height="0" frameborder="0" transparency="transparency" onload="gmv.redimensionar_iframe(this);"></iframe>
              -->
              
              <iframe id='iframe_nueva_plantilla' src="" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe> 	
            </div>                  
          </form>
        </div> <!-- del modal-body-->     
        
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa nuevas plantillas -->    















<form action="Eliminar_Pedido_Atesa.asp" method="post" name="frmborrar_pedido" id="frmborrar_pedido">
	<input type="hidden" id="ocultopedido_a_borrar" name="ocultopedido_a_borrar" value="" />
	<input type="hidden" id="ocultofecha_pedido" name="ocultofecha_pedido" value="" />
</form>

<form action="Rellenar_Variables_Sesion_Atesa.asp" method="post" name="frmmodificar_pedido" id="frmmodificar_pedido">
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
