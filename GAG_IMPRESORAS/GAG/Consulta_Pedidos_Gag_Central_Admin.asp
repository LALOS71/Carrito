<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->
<%
		response.Buffer=true
		numero_registros=0
		
		if session("usuario")="" then
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
		end if
		
		empresa_seleccionada="" & Request.Form("cmbempresas")
		cadena_empresas=""
		cliente_seleccionado="" & Request.Form("cmbclientes")
		estado_seleccionado=Request.Form("cmbestados")
		numero_pedido_seleccionado=Request.Form("txtpedido")
		fecha_i=Request.Form("txtfecha_inicio")
		fecha_f=Request.Form("txtfecha_fin")
		tipo_cliente_seleccionado=Request.Form("cmbtipos_cliente")
		filtro_pedidos=Request.Form("cmbfiltros")
		'response.write("<br>empresa seleccionada: " & empresa_seleccionada)
		
		'response.write("<br>filtros: " & filtro_pedidos)
		
		'para las cadenas de avoris, tengo que controlar si se muestran juntos pedidos de varias empresas en funcion
		' de la seleccion del combo de emrpesas
		if session("usuario_codigo_empresa")<>230 then
			cadena_empresas=session("usuario_codigo_empresa")
		 else
		 	if empresa_seleccionada="" then
				'si no seleccina empreas en concreto, se muestran los pedidos de HALCON, ECUADOR, PORTUGAL, TRAVELPLAN, GEOMOON
				'   GLOBALIA CORPORATE TRAVEL, MARSOL y AVORIS, FRANQUICIAS HALCON Y FRANQUICIAS ECUADOR
				cadena_empresas="10, 20, 80, 90, 130, 170, 210, 230, 240, 250"
			  else
			  	cadena_empresas=empresa_seleccionada
			end if
		end if
		
		
		if filtro_pedidos="" then
			filtro_pedidos="TODOS"
		end if
		
		if cliente_seleccionado="" and estado_seleccionado="" and numero_pedido_seleccionado="" and fecha_i="" and fecha_f="" then
				estado_seleccionado="PENDIENTE AUTORIZACION"
		end if
		
		mostrar_borrados=Request.Form("chkmostrar_borrados")
		if mostrar_borrados<>"SI" then
			mostrar_borrados="NO"
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
			.Source="SELECT  V_EMPRESAS.EMPRESA AS DESCRIPCION_EMPRESA, V_CLIENTES.EMPRESA, V_CLIENTES.CODIGO_EXTERNO, V_CLIENTES.NOMBRE, V_CLIENTES.TIPO,"
			.Source= .Source & " PEDIDOS.ID, PEDIDOS.CODCLI, PEDIDOS.PEDIDO,"
			.Source= .Source & " PEDIDOS.FECHA, PEDIDOS.ESTADO, PEDIDOS.FECHA_ENVIADO, V_CLIENTES.PAIS, PEDIDOS.PEDIDO_AUTOMATICO"
			.Source= .Source & " FROM  PEDIDOS INNER JOIN V_CLIENTES ON PEDIDOS.CODCLI = V_CLIENTES.Id"
			.Source= .Source & " INNER JOIN V_EMPRESAS ON V_CLIENTES.EMPRESA=V_EMPRESAS.ID"
			.Source= .Source & " WHERE V_CLIENTES.EMPRESA IN (" & cadena_empresas & ")"
			'para gls portugal que solo se muestren los pedidos de las agencias de portugal
			if session("usuario_codigo_empresa")=4 and session("usuario")=7637 then
				.Source= .Source & " AND PAIS='PORTUGAL'"
			end if
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
			
			if tipo_cliente_seleccionado<>"" then
				.Source= .Source & " AND (V_CLIENTES.TIPO='" & tipo_cliente_seleccionado & "')"
			end if
			
			if filtro_pedidos="MERCHAN" then
				.Source= .Source & " AND PEDIDOS.PEDIDO_AUTOMATICO='PEDIDO_MERCHAN'"
			end if
			
			if filtro_pedidos="MATERIAL_OFICINA" then
				.Source= .Source & " AND PEDIDOS.PEDIDO_AUTOMATICO IS NULL"
			end if
			
			if filtro_pedidos="HIGIENICOS" then
				.Source= .Source & " AND PEDIDOS.PEDIDO_AUTOMATICO='HIGIENE_Y_SEGURIDAD'"
			end if
			
			.Source= .Source & " ORDER BY PEDIDOS.FECHA desc, V_CLIENTES.NOMBRE desc"
			'response.write("<br>consulta pedidos: " & .Source)
			.Open
		end with

		
		




		dim tipos_cliente
		set tipos_cliente=Server.CreateObject("ADODB.Recordset")
		
		
		sql="SELECT ID, EMPRESA, TIPO, ORDEN FROM V_CLIENTES_TIPO"
		sql=sql & " WHERE EMPRESA=" & session("usuario_codigo_empresa") 
		sql=sql & " ORDER BY ORDEN"
		
		'response.write("<br>" & sql)
		
		with tipos_cliente
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
		

%>
<html>
<head>
<title><%=consulta_pedidos_gag_central_admin_title%></title>
  
<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
  
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />
<link rel="stylesheet" type="text/css" href="../plugins/datepicker/css/bootstrap-datepicker.css">

	

<!--        <link rel="stylesheet" type="text/css" media="screen" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" />
        <link href="//cdn.rawgit.com/Eonasdan/bootstrap-datetimepicker/e8bddc60e73c1ec2475f827be36e1957af72e2ea/build/css/bootstrap-datetimepicker.css" rel="stylesheet">
-->
  
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
		
#capa_opaca____ {
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

.girado {
        -moz-transform: scaleX(-1);
        -o-transform: scaleX(-1);
        -webkit-transform: scaleX(-1);
        transform: scaleX(-1);
        filter: FlipH;
        -ms-filter: "FlipH";
}

.merchan
{
	color:blue;
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
   		accion='Lista_Articulos_Gag.asp'
	  else
	  	accion='Grabar_Pedido_Gag.asp';
	document.getElementById('frmpedido').action=accion
	document.getElementById('frmpedido').submit()	
	

   }


function control_borrados()
	{
	//console.log('checkbox: ' + document.getElementById('chkmostrar_borrados').checked)
	$("#oculto_valor_cmbclientes").val($("#cmbclientes").val())
	if (document.getElementById('chkmostrar_borrados').checked)
		{
		cargar_clientes('SI')
		}
	  else
	  	{
		cargar_clientes('NO')
		//$("#cmbclientes").val('').change()
		}
	$("#cmbclientes").val($("#oculto_valor_cmbclientes").val()).change()
		
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
document.getElementById('detalle').src='Pedido_Detalles_Gag.asp?pedido=' + pedido
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
	
	
</script> 

<script language="javascript">
function mostrar_capas_new(capa, plantilla, cliente, anno_pedido, pedido, articulo, cantidad)
{
    
	
	texto_querystring='?plant=' + plantilla + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad + '&modo=CONSULTAR&carpeta=GAG'
	
	url_iframe='../Plantillas_Personalizacion/Plantilla_Personalizacion.asp' + texto_querystring
	
	
	$("#cabecera_nueva_plantilla").html('Plantilla a Rellenar');
    
    $('#iframe_nueva_plantilla').attr('src', url_iframe)
    $("#capa_nueva_plantilla").modal("show");
	
	
	
	
}



//para mostrar las capas de las plantillas de personalizacon de articulos
function mostrar_capas(capa, plantilla, cliente, anno_pedido, pedido, articulo, cantidad)
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
    document.getElementById("capa_opaca").style.height = (document.body.scrollHeight + 20) + "px";
	document.getElementById('capa_opaca').style.visibility='visible'
	
	texto_querystring='?plant=' + plantilla + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad + '&modo=CONSULTAR&carpeta=GAG'
	document.getElementById('iframe_plantillas').src='../Plantillas_Personalizacion/Plantilla_Personalizacion.asp' + texto_querystring
	document.getElementById(capa).style.visibility='visible';
	
	
	
}

function cerrar_capas(capa)
{	
	document.getElementById('capa_opaca').style.visibility='hidden';
	document.getElementById(capa).style.visibility='hidden';
	
	
}
</script>


<script src="../funciones.js" type="text/javascript"></script>



<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/iframe_autoheight/jquery.browser.js"></script>
<script type="text/javascript" src="../plugins/iframe_autoheight/jquery.iframe-auto-height.plugin.1.9.5.js"></script>


<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<script type="text/javascript" src="../plugins/datetime-moment/moment-with-locales.js"></script>
<script type="text/javascript" src="../plugins/datepicker/js/bootstrap-datetimepicker.js"></script>






</head>
<body style="background-color:<%=session("color_asociado_empresa")%>">

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



<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"><%=consulta_pedidos_gag_central_admin_pantalla_avisos_cabecera%></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer" id="botones_avisos">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=consulta_pedidos_gag_central_admin_pantalla_avisos_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->

<!--lo quito porque creo que no va a ser necesario
<script language="javascript">
	cadena='<div align="center"><br><br><img src="../images/loading4.gif"/><br /><br /><h4>Espere mientras se carga la página...</h4><br></div>'
	$("#cabecera_pantalla_avisos").html("Avisos")
	$("#body_avisos").html(cadena + "<br><br>");
	$("#pantalla_avisos").modal("show");
</script>
-->

<div class="container-fluid">
   <!--PANTALLA-->
  <div class="row">
    <!--COLUMNA IZQUIERDA -->
    <div class="col-xl-3 col-lg-3 col-md-3 col-sm-4 col-xs-4" id="columna_izquierda">

			 <!--DATOS DEL CLIENTE-->
			  <div class="panel panel-default">
				<div class="panel-body">
					<div class="col-md-12">
						<%
						nombre_logo="logo_" & session("usuario_carpeta") & ".png"
						if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
							nombre_logo="Logo_GLS.png"
						end if
						%>
						<div align="center"><img class="img-responsive" src="Images/<%=nombre_logo%>" style="max-height:90px"/></div>
						<br />
						<div align="center">	
							<button type="button" id="cmdarticulos" name="cmdarticulos" class="btn btn-primary btn-md" title="<%=consulta_pedidos_gag_central_admin_panel_datos_pedido_articulos_alter%>">
									<i class="glyphicon glyphicon-th-list"></i>
									<span><%=consulta_pedidos_gag_central_admin_panel_datos_pedido_articulos%></span>
							</button>
							<button type="button" id="cmdpedidos" name="cmdpedidos" class="btn btn-primary btn-md" title="<%=consulta_pedidos_gag_central_admin_panel_datos_pedido_pedidos_alter%>">
									<i class="glyphicon glyphicon-list-alt"></i>
									<span><%=consulta_pedidos_gag_central_admin_panel_datos_pedido_pedidos%></span>
							</button>
							<%'la central de GLS, es la que lleva la gestion de las impresoras
							if session("usuario")=2784 then%>				
								<div class="row" style="margin-top:5px">
									<div class="col-12 text-center">
									  <button type="button" name="cmdimpresoras" id="cmdimpresoras" class="btn btn-primary btn-md w-100">
											<i class="fas fa-print"></i> Gest. Impresoras
									  </button>
									</div>
								</div>
							<%end if%>
						</div>
						<%if session("usuario_codigo_empresa")=230 then%>
							<br />
							<div align="center">	
									<button type="button" id="cmdinforme_avoris" name="cmdinforme_avoris" class="btn btn-primary btn-md" 
										data-toggle="popover" 
										data-placement="bottom" 
										data-trigger="hover" 
										data-content="Informe Detallado de Pedidos" 
										data-original-title=""
										>
											<i class="glyphicon glyphicon-list"></i>
											<span>Informe Pedidos</span>
									</button>
							</div>
						<%end if%>
						
					</div>
				</div>
			  </div>
			  
			  <%'seccion de informes solo para la central de GLS
				if session("usuario")=2784 then%>	
				<div class="panel panel-default" style="margin-bottom:0px; margin-top:7px ">
					<div class="panel-heading"><b>Informes</b></div>
					<div class="panel-body panel_conmargen">
						<div class="col-md-12">
							<div align="center">	
									<button type="button" id="cmdinformes_GLS" name="cmdinformes_GLS" class="btn btn-primary btn-md" 
										data-toggle="popover" 
										data-placement="bottom" 
										data-trigger="hover" 
										data-content="Informe de Pedidos" 
										data-original-title=""
										>
											<i class="glyphicon glyphicon-file"></i>
											<span>Informe Pedidos</span>
									</button>
							</div>
						</div>
					</div>
				</div>
			<%end if%>	
	  
    </div>
    <!--FINAL COLUMNA DE LA IZQUIERDA-->
    
    <!--COLUMNA DE LA DERECHA-->
    <div class="col-xl-9 col-lg-9 col-md-9 col-sm-8 col-xs-8">
      <div class="panel panel-default">
        <div class="panel-heading"><b><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_cabecera%>&nbsp;<%=session("usuario_empresa")%></b></div>
        <div class="panel-body">
			<div class="well well-sm">
				<form name="frmconsulta_pedidos" action="Consulta_Pedidos_Gag_Central_Admin.asp" method="post">
					<div class="form-group row">   
						<%if session("usuario_codigo_empresa")=230 then%>
							<div class="col-md-1">
								<label class="control-label" title="">Empresas:</label>	 
							</div>
							<div class="col-md-3">
								<div id="capa_cadenas">
									<input type="hidden" id="oculto_valor_cmbcadenas" name="oculto_valor_cmbcadenas" value="" />
									<select class="form-control" name="cmbempresas" id="cmbempresas" size="1">
										<option value=""  selected>Seleccionar Empresa</option>
										<option value="10">HALCÓN VIAJES</option>
										<option value="20">VIAJES ECUADOR</option>
										<option value="80">HALCON VIAGENS</option>
										<option value="90">TRAVELPLAN</option>
										<option value="210">MARSOL</option>
										<option value="170">GLOBALIA CORPORATE TRAVEL</option>
										<option value="130">GEOMOON</option>
										<option value="230">AVORIS</option>
										<option value="240">FRANQUICIAS HALCON</option>
										<option value="250">FRANQUICIAS ECUADOR</option>
									</select>
									<%if empresa_seleccionada<>"" then%>
										<script language="javascript">
											document.getElementById("cmbempresas").value='<%=empresa_seleccionada%>'
										</script>
									<%end if%>
								</div>
							</div>
						<%end if%>
						<div class="col-md-1">
							<label class="control-label" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_cliente_alter%>"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_cliente%></label>	 
						</div>
						<div class="col-md-7">
						  	<div id="capa_clientes">
								<input type="hidden" id="oculto_valor_cmbclientes" name="oculto_valor_cmbclientes" value="" />
								<select class="form-control" name="cmbclientes" id="cmbclientes" size="1">
									<option value=""><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_seleccionar_cliente%></option>
								</select>
							</div>
							
							<input name="chkmostrar_borrados" id="chkmostrar_borrados" type="checkbox" value="SI" onclick="control_borrados()" />&nbsp;Mostrar Borrados
							<%if mostrar_borrados="SI" then%>
								<script language="javascript">
									document.getElementById("chkmostrar_borrados").checked=true
								</script>
							<%end if%>
						</div>
					</div>  

						<div class="form-group row">    
							<label class="col-md-2 control-label" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_filtro_num_pedido_alter%>">N&uacute;m. Ped.</label>	                
							<div class="col-md-2">
								<input type="text" class="form-control" size="8" name="txtpedido" id="txtpedido" value="<%=numero_pedido_seleccionado%>" />
							</div>
							<label class="col-md-2 control-label"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_filtro_estado%></label>	                
							<div class="col-md-6">
								<select class="form-control" name="cmbestados" id="cmbestados" size="1">
									<option value=""  selected="selected"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_filtro_estado_combo_seleccionar%></option>
									<%'CASOS ESPECIALES DE ASM
									if session("usuario_codigo_empresa")=4 then%>
											<option value="AUTORIZACION NUEVA APERTURA">AUTORIZACION NUEVA APERTURA</option>
											<option value="PENDIENTE PAGO">PENDIENTE PAGO (agencias)</option>
											<option value="PENDIENTE AUTORIZACION">PENDIENTE AUTORIZACION (propias)</option>
										<%else
											'UVE no tiene este estado, directamente van a sin tratar los pedidos
											if session("usuario_codigo_empresa")<>150 then%>
												<option value="PENDIENTE AUTORIZACION">PENDIENTE AUTORIZACION</option>
											<%end if%>
									<%end if%>
									<option value="SIN TRATAR">SIN TRATAR</option>
									<option value="RECHAZADO">RECHAZADO</option>
									<option value="EN PROCESO">EN PROCESO</option>
									<option value="PENDIENTE CONFIRMACION">PENDIENTE CONFIRMACION</option>
									<option value="EN PRODUCCION">EN PRODUCCION</option>
									<option value="ENVIADO">ENVIADO</option>
									<option value="CANCELADO">CANCELADO</option>
								</select>
								<%if estado_seleccionado<>"" then%>
									<script language="javascript">
										document.getElementById("cmbestados").value='<%=estado_seleccionado%>'
									</script>
								<%end if%>
							</div>
						</div>  
						
						<div class="form-group row">
							<label class="col-md-2 control-label" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_filtro_fecha_inicio_alter%>"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_filtro_fecha_inicio%></label>	                
						  	<div class="col-md-4">
								<div class="input-group date" id="fecha_inicio">
								  <input type="Text" class="form-control" name="txtfecha_inicio" id="txtfecha_inicio" value="<%=fecha_i%>" size=7>
								  <span class="input-group-addon"><i class="glyphicon glyphicon-calendar text-primary" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_filtro_fecha_inicio_calendar_alter%>"></i></span>
								</div>
								<script type="text/javascript">
									$(function () {
										$('#fecha_inicio').datetimepicker({
											format: 'DD/MM/YYYY'
											});
									});
									
								</script>
							</div>
							
							<label class="col-md-2 control-label" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_filtro_fecha_fin_alter%>"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_filtro_fecha_fin%></label>	                
						  	<div class="col-md-4">
								<div class="input-group date" id="fecha_fin">
								  <input type="Text" class="form-control" name="txtfecha_fin" id="txtfecha_fin" value="<%=fecha_f%>" size=7>
								  <span class="input-group-addon"><i class="glyphicon glyphicon-calendar text-primary" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_filtro_fecha_fin_calendar_alter%>"></i></span>
								</div>
								<script type="text/javascript">
									$(function () {
										$('#fecha_fin').datetimepicker({
											format: 'DD/MM/YYYY'
											});
									});
								</script>
							</div>
						</div>
						
						
						<div class="form-group row">
							<%' para la administracion de asm, ponemos un filtro extra con el tipo de cliente
								'para que puedan diferenciar las de GLs o las de ASm
							if session("usuario_codigo_empresa")=4 then%>
								<label class="col-md-2 control-label"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_filtro_tipos_oficina%></label>	                
								<div class="col-md-4">
									<select class="form-control" name="cmbtipos_cliente" id="cmbtipos_cliente" size="1">
											<option value=""  selected="selected"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_filtro_tipos_oficina_combo%></option>
											<%while not tipos_cliente.eof%>
												<option value="<%=tipos_cliente("tipo")%>"><%=tipos_cliente("tipo")%></option>
												
												<%tipos_cliente.movenext%>
											<%wend%>
									</select>
									<%if tipo_cliente_seleccionado<>"" then%>
										<script language="javascript">
											document.getElementById("cmbtipos_cliente").value='<%=tipo_cliente_seleccionado%>'
										</script>
									<%end if%>
								</div>
							<%end if%>							
							
							<%'para halcon y ecuador, FRANQUICIAS HALCON Y FRANQUICIAS ECUADOR pongo un filtro para los pedidos de merchan, higienicos, o no merchan
							if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 then%>
								<label class="col-md-2 control-label">Filtros:</label>	                
								<div class="col-md-8">
									<select class="form-control" name="cmbfiltros" id="cmbfiltros" size="1">
										<option value="TODOS">Todos Los Pedidos</option>
										<option value="MERCHAN">Pedidos Merchandising</option>
										<option value="MATERIAL_OFICINA">Pedidos Material de Oficina</option>
										<option value="HIGIENICOS">Pedidos Higiene y Seguridad</option>
									</select>
									<%if filtro_pedidos<>"" then%>
										<script language="javascript">
											document.getElementById("cmbfiltros").value='<%=filtro_pedidos%>'
										</script>
									<%end if%>
								</div>
							<%end if%>

							<div class="col-md-2">
							  <button type="submit" name="Action" id="Action" class="btn btn-primary btn-sm">
									<i class="glyphicon glyphicon-search"></i>
									<span><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_buscar%></span>
							  </button>
							</div>
													
						
						
						</div>
						
					</form>
				</div>
		
		
		
				<form name="frmpedido" id="frmpedido" action="Grabar_Pedido_Gag.asp" method="post">
					<table class="col-md-12">
						<tr>
							<td align="center">
								<a href="#" onMouseOver="subir()" onMouseOut="detener()"  style="text-decoration:none " title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_img_ascender%>"><i class="glyphicon glyphicon-chevron-up btn-lg"></i></a>
							</td>
						</tr>
						<tr>
							<td>
								<div id="contenidos" style="height:200px; overflow:hidden">
									
									<table class="table table-hover"> 
										<thead> 
											<tr> 
												<%if session("usuario_codigo_empresa")=230 then%>
													<th class="col-sm-1">Empresa</th> 
													<th class="col-sm-4"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_cabecera_columna_cliente%></th> 
												  <%else%>
												  	<th class="col-sm-5"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_cabecera_columna_cliente%></th> 
												 <%end if%>	
												<th class="col-sm-2" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_cabecera_columna_num_pedido_alter%>"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_cabecera_columna_num_pedido%></th> 
												<th class="col-sm-1"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_cabecera_columna_fecha%></th> 
												<th class="col-sm-2" style="text-align:center"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_cabecera_columna_estado%></th> 
												<th class="col-sm-2" style="text-align:center"><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_cabecera_columna_accion%></th> 
											</tr> 
										</thead> 
										<tbody> 
											
								
											<%if pedidos.eof then%>
												<tr> 
													<td align="center" colspan="5"><h5><%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_no_hay_pedidos%></h5><br></td>
												</tr>
											<%end if%>
											
											
											<%while not pedidos.eof%>
												<%if numero_registros=200 then
														response.Flush()
														numero_registros=0
													else
														numero_registros=numero_registros + 1
												end if%>
												
												<%if pedidos("pedido_automatico")="PEDIDO_MERCHAN" then
													nueva_clase=" merchan"
												  else
												  	nueva_clase=""
												 end if%>
												<tr valign="top">
													<%if session("usuario_codigo_empresa")=230 then%>
														<td class="col-sm-1<%=nueva_clase%>"><%=pedidos("DESCRIPCION_EMPRESA")%></td>
														<td class="col-sm-4<%=nueva_clase%>" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("NOMBRE")%>
															<%if pedidos("codigo_externo")<>"" then%>
																&nbsp;(<%=pedidos("CODIGO_EXTERNO")%>)
															<%end if%>
														</td>
													  <%else%>
													  	<td class="col-sm-5<%=nueva_clase%>" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("NOMBRE")%>
															<%if pedidos("codigo_externo")<>"" then%>
																&nbsp;(<%=pedidos("CODIGO_EXTERNO")%>)
															<%end if%>
														</td>
													 <%end if%>
												  
													<td class="col-sm-2<%=nueva_clase%>" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("id")%></td>
													<td class="col-sm-1<%=nueva_clase%>" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("fecha")%></td>
													<td class="col-sm-2<%=nueva_clase%>" align="center" valign="middle" onclick="mostrar_detalle(<%=pedidos("id")%>);"><%=pedidos("estado")%></td>
													<td class="col-sm-2" align="center" >
														<%'response.write("<br>tipo: " & pedidos("tipo"))%>
														<%'response.write("<br>usuario: " & session("usuario"))%>
														<%'response.write("<br>pais: " & pedidos("pais"))%>
														<%'PARA PODER GESTIONAR LOS PEDIDOS DE NUEVAS APERTURAS EN ASM
														'QUE VAN CON AUTORIZACION PORQUE TIENEN DESCUENTOS
														if pedidos("estado")="AUTORIZACION NUEVA APERTURA" then%>
															<%if session("usuario_codigo_empresa")=4 and session("usuario")=2784 then%>
																<button type="button" class="btn btn-success btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_confirmar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'CONFIRMAR')">
																		<i class="glyphicon glyphicon-ok"></i>
													  			</button>
																<button type="button" class="btn btn-warning btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_cancelar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'CANCELAR')">
																		<i class="glyphicon glyphicon-remove"></i>
													  			</button>
																
																	<button type="button" class="btn btn-primary btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'MODIFICAR')">
																		<i class="glyphicon glyphicon-pencil"></i>
																	</button>
															<%end if%>
														<%END IF%>
														
														<%if pedidos("estado")="PENDIENTE AUTORIZACION" then%>
															<%'para asm, si entra asm central que pueda gestionar los de las ASM propias (DE ESPAÑA)
																' y si entra gls central que pueda gestionar los de las gls propias (DE ESPAÑA)
																' y si entra gls PORTUGAL que pueda gestionar los de las gls propias (DE PORTUGAL)
															if session("usuario_codigo_empresa")=4 then%>
																<% if pedidos("tipo")="GLS PROPIA" and session("usuario")=7730 and pedidos("pais")="ESPAÑA" THEN%>
																	<button type="button" class="btn btn-success btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_confirmar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'CONFIRMAR')">
																		<i class="glyphicon glyphicon-ok"></i>
																	</button>
																	<button type="button" class="btn btn-warning btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_cancelar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'CANCELAR')">
																		<i class="glyphicon glyphicon-remove"></i>
																	</button>
																	<button type="button" class="btn btn-primary btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'MODIFICAR')">
																		<i class="glyphicon glyphicon-pencil"></i>
																	</button>
																<%END IF%>
																<% if (pedidos("tipo")="PROPIA" or pedidos("tipo")="AGENCIA" or pedidos("tipo")="GLS PROPIA") and session("usuario")=2784 and (pedidos("pais")="ESPAÑA" or pedidos("pais")="PORTUGAL") THEN%>
																	<button type="button" class="btn btn-success btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_confirmar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'CONFIRMAR')">
																		<i class="glyphicon glyphicon-ok"></i>
																	</button>
																	<button type="button" class="btn btn-warning btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_cancelar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'CANCELAR')">
																		<i class="glyphicon glyphicon-remove"></i>
																	</button>
																	<button type="button" class="btn btn-primary btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'MODIFICAR')">
																		<i class="glyphicon glyphicon-pencil"></i>
																	</button>
																<%END IF%>
																<% if session("usuario")=7637 and pedidos("pais")="PORTUGAL" THEN%>
																	<button type="button" class="btn btn-success btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_confirmar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'CONFIRMAR')">
																		<i class="glyphicon glyphicon-ok"></i>
																	</button>
																	<button type="button" class="btn btn-warning btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_cancelar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'CANCELAR')">
																		<i class="glyphicon glyphicon-remove"></i>
																	</button>
																	<button type="button" class="btn btn-primary btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'MODIFICAR')">
																		<i class="glyphicon glyphicon-pencil"></i>
																	</button>
																<%END IF%>
															<%else 'resto de empresas%>
																<%'UVE no puede modificar pedidos
																if session("usuario_codigo_empresa")<>150 then%>
																	<button type="button" class="btn btn-success btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_confirmar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'CONFIRMAR')">
																		<i class="glyphicon glyphicon-ok"></i>
																	</button>
																	<button type="button" class="btn btn-warning btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_cancelar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'CANCELAR')">
																		<i class="glyphicon glyphicon-remove"></i>
																	</button>
																	<%' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL
																	 ', 230 AVORIS, 240 FRANQUICIAS HALCON Y 250 FRANQUICIAS ECUADOR tampoco
																	if session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80_
																		and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170_
																		and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 and session("usuario_codigo_empresa")<>240_
																		and session("usuario_codigo_empresa")<>250 then%>						  
																																			
																		<button type="button" class="btn btn-primary btn-xs" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'MODIFICAR')">
																			<i class="glyphicon glyphicon-pencil"></i>
																		</button>
																	<%end if%>
																<%end if%>
															<%end if%>
														<%end if%>
													
														<%if pedidos("estado")="SIN TRATAR" then%>
															
															<%'SE MUESTRA EL BOTON DE MODIFICAR PARA TODAS LAS EMRPESAS, Y EN
															'EL CASO DE ASM PARA LAS FRANQUICIAS y  NO SE MUESTRA
															if session("usuario_codigo_empresa")=4 then%>
																<% if pedidos("tipo")="GLS PROPIA" and session("usuario")=7730 and pedidos("pais")="ESPAÑA" THEN%>
																	<button type="button" class="btn btn-primary btn-sm" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'MODIFICAR')">
																		<i class="glyphicon glyphicon-pencil"></i>
																	</button>
																<%END IF%>
																<% if (pedidos("tipo")="PROPIA" or pedidos("tipo")="GLS PROPIA") and session("usuario")=2784 and (pedidos("pais")="ESPAÑA" OR pedidos("pais")="PORTUGAL") THEN%>
																	<button type="button" class="btn btn-primary btn-sm" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'MODIFICAR')">
																		<i class="glyphicon glyphicon-pencil"></i>
																	</button>
																<%END IF%>
																<% if pedidos("tipo")="PROPIA" and session("usuario")=7637 and pedidos("pais")="PORTUGAL" THEN%>
																	<button type="button" class="btn btn-primary btn-sm" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'MODIFICAR')">
																		<i class="glyphicon glyphicon-pencil"></i>
																	</button>
																<%END IF%>
															<%else 'resto de empresas%>
																<%'UVE no puede modificar pedidos
																if session("usuario_codigo_empresa")<>150 then%>
																	<%' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL
																	   ', 230 AVORIS, 240 FRANQUICIAS HALCON Y 250 FRANQUICIAS ECUADOR tampoco
																	if session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80_
																		and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170_
																		and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 and session("usuario_codigo_empresa")<>240_
																		and session("usuario_codigo_empresa")<>250 then%>						  
																		<button type="button" class="btn btn-primary btn-sm" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_modificar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'MODIFICAR')">
																			<i class="glyphicon glyphicon-pencil"></i>
																		</button>
																	<%end if%>
																	<button type="button" class="btn btn-warning btn-sm" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_cancelar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'CANCELAR')">
																		<i class="glyphicon glyphicon-remove"></i>
																	</button>
																<%end if%>
															<%end if%>
															
														<%end if%>
														<%if pedidos("estado")="CANCELADO" then%>
														
															<%if session("usuario_codigo_empresa")=4 then%>
																<% if pedidos("tipo")="GLS PROPIA" and session("usuario")=7730 and pedidos("pais")="ESPAÑA" THEN%>
																	<button type="button" class="btn btn-warning btn-sm" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_descancelar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'DESCANCELAR')">
																		<i class="glyphicon glyphicon-share-alt girado"></i>
																	</button>
																<%END IF%>
																<% if (pedidos("tipo")="PROPIA" or pedidos("tipo")="GLS PROPIA") and session("usuario")=2784 and (pedidos("pais")="ESPAÑA" OR pedidos("pais")="PORTUGAL") THEN%>
																	<button type="button" class="btn btn-warning btn-sm" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_descancelar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'DESCANCELAR')">
																		<i class="glyphicon glyphicon-share-alt girado"></i>
																	</button>
																<%END IF%>
																<% if pedidos("tipo")="PROPIA" and session("usuario")=7637 and pedidos("pais")="PORTUGAL" THEN%>
																	<button type="button" class="btn btn-warning btn-sm" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_descancelar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'DESCANCELAR')">
																		<i class="glyphicon glyphicon-share-alt girado"></i>
																	</button>
																<%END IF%>
															<%else 'resto de empresas%>
																<%'UVE no puede modificar pedidos
																if session("usuario_codigo_empresa")<>150 then%>
																	<button type="button" class="btn btn-warning btn-sm" title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_boton_descancelar_alter%>" onclick="modificar_pedido(<%=pedidos("id")%>, 'DESCANCELAR')">
																		<i class="glyphicon glyphicon-share-alt girado"></i>
																	</button>
																<%end if%>
															<%end if%>
														
														
														
															
														<%end if%>
													</td>
													<td>
													
													</td>
												</tr>
												
												<%		
												pedidos.movenext
												Wend
												%>
												
												
											
										</tbody> 
									</table>
							  </div>
							
							</td>
						</tr>
						<tr>
							<td align="center">
                              <a href="#" onmouseover="bajar()" onmouseout="detener()"  style="text-decoration:none " title="<%=consulta_pedidos_gag_central_admin_panel_lista_pedidos_img_descender%>"><i class="glyphicon glyphicon-chevron-down btn-lg"></i></a> </td>
						</tr>
					</table>
				</form>

        </div><!--panel-body-->
      </div><!--panel-->


		<!--PEDIDOS REALIZADOS-->
	  <div class="panel panel-default">
	  	<div class="panel-body">
			<iframe class="col-sm-12"  width="100%" id="detalle" name="detalle" src="Pedido_Detalles_Gag.asp" scrolling="no" frameborder="0" allowtransparency="yes"></iframe> 
		</div>
	  </div>



					
    </div>
    <!--FINAL COLUMNA DE LA DERECHA-->
  </div>    
  <!-- FINAL DE LA PANTALLA -->
</div>
<!--FINAL CONTAINER-->

<script language="javascript">
	$("#pantalla_avisos").modal("hide");
</script>






<form action="Modificar_Pedido_Gag_Central_Admin.asp" method="post" name="frmmodificar_pedido" id="frmmodificar_pedido">
	<input type="hidden" id="ocultopedido_a_modificar" name="ocultopedido_a_modificar" value="" />
	<input type="hidden" id="ocultoaccion" name="ocultoaccion" value="" />
</form>


<!--
<script type="text/javascript" src="//code.jquery.com/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
-->
			
			
			



<script language="javascript">
$("#cmdarticulos").on("click", function () {
	location.href='Lista_Articulos_Gag_Central_Admin.asp'
});

$("#cmdpedidos").on("click", function () {
	location.href='Consulta_Pedidos_Gag_Central_Admin.asp'
});

$("#cmdimpresoras").on("click", function () {
	location.href='Consulta_Impresoras_GLS_Central_Admin.asp'
});

$("#cmdinformes_GLS").on("click", function () {
	location.href='Consulta_Informes_Gag_Central_Admin.asp'
});

$("#cmdinforme_avoris").on("click", function () {
	location.href='Informe_Pedidos_Avoris.asp'
});

$('#cmbclientes').change(function () {
     /*
	 var optionSelected = $(this).find("option:selected");
     var valueSelected  = optionSelected.val();
     var textSelected   = optionSelected.text();
	 console.log('valor seleccionado: ' + valueSelected)
	 console.log('texto seleccionado: ' + textSelected)
	 */
 });
$('#cmbempresas').change(function () {
     /*
	 var optionSelected = $(this).find("option:selected");
     var valueSelected  = optionSelected.val();
     var textSelected   = optionSelected.text();
	 console.log('valor seleccionado: ' + valueSelected)
	 console.log('texto seleccionado: ' + textSelected)
	 */
	 //alert('entramos en cambio de cmbempresas')
	 control_borrados()
 });
 
$(document).ready(function () {
	cargar_clientes('<%=mostrar_borrados%>')
});



cargar_clientes = function(borrados) {
	url=''
	empresa='<%=session("usuario_codigo_empresa")%>'
	//si es avoris, tengo que coger como empresa, la que venga seleccionada del combo de empresas
	//  no la de la variable de sesion
	if (empresa=='230')
		{
		empresa=$("#cmbempresas").val()
		}
	if (borrados=='SI')
		{
		url='Obtener_Clientes_Gag_Central_Admin.asp?borrados=SI&usuario=' + empresa
		}
	  else
	  	{
	  	url='Obtener_Clientes_Gag_Central_Admin.asp?usuario=' + empresa
		}
	
	$.getJSON(url, function(json){
				//console.log('borramos el cmbclientes')
				
				clientes = json.CLIENTES; 
				
				//borramos el contenido del combo de clientes
				$('#cmbclientes').empty();
				
				//añadimos la primera opcion
				$('#cmbclientes').append($('<option>').text("Seleccionar Cliente").attr('value', ''));
				
				//rellenamos el combo
				$.each(clientes, function(i, obj){
					$('#cmbclientes').append($('<option>').text(obj.NOMBRE).attr('value', obj.Id));
				});
				//$("#cmbclientes").val('33').change()
				$("#cmbclientes").val('<%=cliente_seleccionado%>').change()
				
		})
		.fail(function( jqxhr, textStatus, error ) {
			var err = textStatus + ", " + error;
			console.log( "Request Failed: " + err );
			});

};

</script>


</body>
<%
	'articulos.close
	
	pedidos.close
	
	
	
	
	connimprenta.close
	
	set articulos=Nothing
	
	
	set pedidos=Nothing
	
	
	set connimprenta=Nothing

%>
</html>
