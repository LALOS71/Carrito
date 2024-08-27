<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->



<%
		if session("usuario")="" then
			Response.Redirect("../Login_Atesa.asp")
		end if
		
		
		
		
		
		
		
		
		
		
		'recordsets
		dim articulos
		
		
		'variables
		dim sql
		
		carpeta_anno=""
		fecha_pedido=""

	    
	    set articulos=Server.CreateObject("ADODB.Recordset")
		'si entra para modificar un pedido existente
		accion=Request.Form("ocultoaccion")
		if accion="" then
			'aqui viene la accion junto con el pedido "MODIFICAR--88"
			acciones=Request.QueryString("acciones")
			if acciones<>"" then
				tabla_acciones=Split(acciones,"--")
				accion=tabla_acciones(0)
				pedido_modificar=tabla_acciones(1)
				fecha_pedido="" & tabla_acciones(2)
			end if
		end if
		if Request.Form("ocultopedido_modificar")<>"" then
			pedido_modificar=Request.Form("ocultopedido_modificar")
		end if
		if Request.Form("ocultofecha_pedido")<>"" then
			fecha_pedido= "" & Request.Form("ocultofecha_pedido")
		end if
		
		cadena_acciones=accion & "--" & pedido_modificar & "--" & fecha_pedido
		

		if fecha_pedido<>"" then
			carpeta_anno=year(fecha_pedido)
		end if
		





'Recogemos la variable borrar 
borrar=Request.Querystring("borrar")
'RESPONSE.WRITE("<BR>HAY QUE QUITAR EL ARTICULO CON CODIGO: " & BORRAR)

If borrar<>"" Then 'Si se ha pedido el borrado de un articulo
	i=1
	Do While borrar<>Session(i)
		'RESPONSE.WRITE("<BR>SESSION(" & i & "): " & session(i))
		i=i+1
	Loop
	'response.write("<br>y ahora tenemos que mover unos articulos sobre otros... Hay " & Session("numero_articulos") & " articulos en el pedido")
	Session("json_" & Session(i))=""
	For j=i to Session("numero_articulos")
		'RESPONSE.WRITE("<BR>SESSION(" & j & "): " & session(j) & " contendrá a SESSSION(" & j+1 & "): " & session(j+1))
		Session(j)=Session(j+1)
		'RESPONSE.WRITE("<BR>SESSION(" & j & "_cantidades_precios): " & session(j & "_cantidades_precios") & " contendrá a SESSSION(" & j+1 & "_cantidades_precios): " & session(j+1 & "_cantidades_precios"))
		Session(j & "_cantidades_precios")=Session((j+1) & "_cantidades_precios")
		Session(j & "_fichero_asociado")=Session((j+1) & "_fichero_asociado")
		
	Next
	Session("numero_articulos")=Session("numero_articulos")-1
		
	'response.write("<br>y al final quedan " & Session("numero_articulos") & " articulos en el pedido")
	'response.write("<br><br>ahora vemos como ha quedado despues de borrar")
	'For j=1 to Session("numero_articulos")
		'RESPONSE.WRITE("<BR>SESSION(" & j & "): " & session(j)) 
		'RESPONSE.WRITE("<BR>SESSION(" & j & "_cantidades_precios): " & session(j & "_cantidades_precios"))
	'Next
		
	
	
End if

'Si no quedan articulos en el carrito despues del borrado
cadena="Lista_Articulos_Atesa.asp"
If Session("numero_articulos")= 0 Then
	'history.back()
	'Response.Redirect("bottom.asp")
end if


%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
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
   	
function validar(pedido_minimo, total_pedido)
{
	hay_error='NO'
	cadena_error=''
	
	var frm = document.getElementById("frmpedido");
	for (i=0;i<frm.elements.length;i++)
		{
			console.log('ELEMENTO FORMULARIO: ' + frm.elements[i].name + ': ' + frm.elements[i].name.indexOf('ocultoarticulo_personalizable_'))
			if (frm.elements[i].name.indexOf('ocultoarticulo_personalizable_')==0)
				{
				codigo_articulo=frm.elements[i].name.substr(30,frm.elements[i].name.length)
				console.log('codigo_articulo: ' + codigo_articulo)
				console.log('oculto_datos_persionalizacion json: ' + document.getElementById('ocultodatos_personalizacion_json_' + codigo_articulo).value)
				console.log('oculto articulos personalizable: ' + document.getElementById('ocultoarticulo_personalizable_' + codigo_articulo).value)
				if ((document.getElementById('ocultodatos_personalizacion_json_' + codigo_articulo).value=='')&&
						(document.getElementById('ocultoarticulo_personalizable_' + codigo_articulo).value=='SI'))
					{
					hay_error='SI'
					cadena_error+='Antes de Guardar el Pedido, Personalice el Artículo utilizando la plantilla a tal efecto.'
					}
				
				}

		}
	
	console.log('cadena_error: ' + cadena_error)
	
	
	
	if (hay_error=='SI')
		{
		//alert('Se Han Detectado Los Siguientes Errores:\n\n' + cadena_error)
		cadena='<br><BR><H3>Se Han Detectado Los Siguientes Errores:</H3><BR><br><H5>' + cadena_error + '</H5>'
		$("#cabecera_pantalla_avisos").html("Avisos")
		$("#body_avisos").html(cadena + "<br>");
		cadena='<p>'
		cadena += '<button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>'
		cadena += '</p><br>'
		$("#botones_avisos").html(cadena);                          
		$("#pantalla_avisos").modal("show");

		}
	  else
	  	{
			if (pedido_minimo>total_pedido)
				{
					//alert('pedido minimo: ' + pedido_minimo + ' ... total pedido: ' + total_pedido)
					respuesta=confirm('El Pedido Tramitado no llega al importe mínimo con lo que se cobrarán gastos de envio\n\nPulse "Aceptar" para Tramitar el Pedido o "Cancelar" para añadir mas productos al Pedido')
					//alert('respuesta: ' + respuesta)
					if (respuesta)
						{
						document.getElementById('frmpedido').submit()
						}
					  else //redirigimos para que siga pidiendo articulos
						{
						location.href='Lista_Articulos_Atesa.asp?acciones=<%=cadena_acciones%>'
						}
				}
			  else
				{
					document.getElementById('frmpedido').submit()
				}
		}
		
		
		
		
	
	
		
	
}
</script>
<script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

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

	console.log('fichero plantilla: ' + fichero_plantilla)
	console.log('plantilla personalizacion: ' + plantilla_personalizacion)
		
	//console.log('texto paraametro campos: ' + texto_campos)
	texto_querystring='?plant=' + plantilla_personalizacion + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad	+ texto_campos
		
	url_iframe='../Plantillas_Personalizacion/' + fichero_plantilla + texto_querystring
	
	console.log('texto querystring: ' + texto_querystring)
	console.log('url ifrmae: ' + url_iframe)
		
	
	
	$("#cabecera_nueva_plantilla").html('Plantilla a Rellenar');
    
    $('#iframe_nueva_plantilla').attr('src', url_iframe)
    $("#capa_nueva_plantilla").modal("show");
	
	
	
	
}



</script>
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>


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
								<a href="Carrito_Atesa.asp?acciones=<%=cadena_acciones%>" class="btn-details"><font color="#FFFFFF">Ver Pedido</font></a>
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
	<td width="713" valign="top">
		<div id="main">
				
		
		
		
		
		
				<div class="comment_title fontbold">Detalle del Pedido
				<%if accion="MODIFICAR" THEN%>
					&nbsp;-- Modificando Pedido <%=pedido_modificar%>
				<%end if%>
				</div>
				<div class="comment_text"> 
					<form name="frmpedido" id="frmpedido" action="Grabar_Pedido_Atesa.asp" method="post"  enctype="multipart/form-data">
						<input type="hidden" name="ocultoacciones" id="ocultoacciones" value="<%=cadena_acciones%>" />
					  <table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table">
                        <tr style="background-color:#FCFCFC" valign="top">
                          <th class="menuhdr">Cod. Sap</th>
                          <th class="menuhdr">Artículo</th>
                          <th class="menuhdr">Cantidad</th>
                          <th class="menuhdr" colspan="2"></th>

                        </tr>
                        <%if Session("numero_articulos")=0 then%>
                        <tr>
                          <td bgcolor="#999966" align="center" colspan="8"><b><font class="fontbold">El Pedido No Tiene Articulos...</font> &nbsp;&nbsp;&nbsp;<a  href="Lista_Articulos_Atesa.asp">Volver</a></b><br />
                          </td>
                        </tr>
                        <%end if%>
                        <%
							'Iniciamos las variables
							i=1 'contador de articulos
							'Session("total")=0 'precio del pedido
							total_pedido=0
							compromiso_compra_pedido="SI"
							control_compromiso_compra_pedido="SI"
							
							'Comenzamos la impresion de los articulos del carrito
							While i<=Session("numero_articulos")
								id=Session(i)
								cantidades_precios_id=Session(i & "_cantidades_precios")
								calculos_cantidades_precios=split(cantidades_precios_id,"--")
								'multiplico la cantidad por el precio y rendondeo a 2 decimales
								'total_id=round(calculos_cantidades_precios(0) * calculos_cantidades_precios(1), 2)
								'response.write("<br>posicion: " & i & " ...Articulo: " & id & " cantidades_precios: " & cantidades_precios_id)
								'response.write("<br>Articulo: " & id & " cantidades_precios: " & cantidades_precios_id)
								
								sql="SELECT ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION, ARTICULOS.COMPROMISO_COMPRA, "
								sql=sql & " V_EMPRESAS.CARPETA, ARTICULOS_EMPRESAS.CODIGO_EMPRESA"
								sql=sql & " , ARTICULOS_PERSONALIZADOS.PLANTILLA_PERSONALIZACION"
								sql=sql & " FROM ARTICULOS ARTICULOS INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO"
								sql=sql & " INNER JOIN V_EMPRESAS ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA = V_EMPRESAS.Id"
								sql=sql & " LEFT JOIN ARTICULOS_PERSONALIZADOS ON ARTICULOS.ID=ARTICULOS_PERSONALIZADOS.ID_ARTICULO"
										
								sql=sql & " WHERE ARTICULOS.ID=" & id
								'response.write("<br>" & sql)
								
							
											with articulos
												.ActiveConnection=connimprenta
												.Source=sql
												'.source="SELECT ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION as articulo from articulos"
												'response.write("<br>" & .source)
												.Open
											end with
											'SI TODOS LOS ARTICULOS DEL PEDIDO, SON COMPROMISMO DE COMPRA, EL IMPORTE MINIMO SON 199 O 101
											' PERO EN CUANTO HAYA ALGUN ARTICULO SIN COMPROMISO DE COMPRA, EL IMPORTE MINIMO HA DE SER 300
											'response.write("<br>sap: " & articulos("codigo_sap"))
											'response.write("<br>desc: " & articulos("descripcion"))
											'response.write("<br>compromiso compra: " & articulos("compromiso_compra"))
											if articulos("compromiso_compra")="NO" then
												compromiso_compra_pedido="NO"
												'en cuanto hay un articulo sin compromiso de compra
												' el limite del importe del pedido sube...
												control_compromiso_compra_pedido="NO"
												colorcin="#FCFCFC"
											  else
											  	compromiso_compra_pedido="SI"
											  	colorcin="#FFFFCC"
											end if
							
						%>
                        <tr valign="top">
                          <td class="ac item_row" width="64" align="right" style="background-color:<%=colorcin%>">
						  	<%
								articulo_personalizado="NO"
								plantilla_personalizacion= "" & articulos("PLANTILLA_PERSONALIZACION")
								if plantilla_personalizacion<>"" THEN
									articulo_personalizado="SI"
								end if
								datos_json_articulo=session("json_" & id)
								'response.write("<br>PLANTILLA PERSONALIZACION: " & plantilla_personalizacion)
								'response.write("<br>articulo personalizado: " & ARTICULO_PERSONALIZADO)
							%>
							<input type="hidden" class="oculto_articulo" value="<%=id%>">
							<input type="hidden" name="ocultoarticulo_personalizable_<%=id%>" id="ocultoarticulo_personalizable_<%=id%>" value="<%=articulo_personalizado%>">
							<input type="hidden" name="ocultoplantilla_personalizacion_<%=id%>" id="ocultoplantilla_personalizacion_<%=id%>" value="<%=plantilla_personalizacion%>">
							<input type="hidden" name="ocultodatos_personalizacion_json_<%=id%>" id="ocultodatos_personalizacion_json_<%=id%>" value="">
							
							
						  	<a href="../Imagenes_Articulos/<%=id%>.jpg" target="_blank">
								<%=articulos("CODIGO_SAP")%>
							</a>
						  
						  
						  </td>
                          <td class="item_row" style="text-align:left; background-color:<%=colorcin%>" width="257"><%=articulos("DESCRIPCION")%>
						  	<%if articulo_personalizado="SI" then%>
						  		<button type="button" class="btn btn-warning btn-sm"
									id="icono_plantilla_<%=id%>" name="icono_plantilla_<%=id%>" 
									title="Plantilla Para Personalizar el Artículo... PENDIENTE DE RELLENAR"
									onclick="mostrar_capas_new('capa_informacion', '<%=plantilla_personalizacion%>','<%=session("usuario")%>', '<%=carpeta_anno%>', '<%=pedido_modificar%>', '<%=id%>', '<%=calculos_cantidades_precios(0)%>')"
									>
									<i class="fab fa-wpforms"></i>
								</button>
							<%end if%>
							<%if accion="MODIFICAR" then%>
									<%'ahora comprobamos si es un articulo personalizable con plantilla y si ya se ha 
										'guardado el fichero json, para cargarlo en la variable oculta
										
										'si esta vacio recojo el valor desde el fichero, pero si no, lo dejo como esta
										IF Session("json_" & id)="" THEN 
											cadena_texto_json=""
											set fso_json=Server.CreateObject("Scripting.FileSystemObject")
											ruta_fichero_json= Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar)
											ruta_fichero_json= ruta_fichero_json & "/json_" & id & ".json"
											'--response.write("<br>fichero json a comprobar si existe: " & ruta_fichero_json)
											if fso_json.FileExists(ruta_fichero_json) then
												Set contenido_fichero_json = fso_json.OpenTextFile(ruta_fichero_json, 1) 
												'Escribimos su contenido 
												cadena_texto_json=contenido_fichero_json.ReadAll
												'--Response.Write("El contenido es:<br>" & cadena_texto_json)
											end if
											set fso_json=nothing
											if cadena_texto_json<>"" then
												'en el oculto solo detectamos si se ha rellenado los datos de personalizacion o no
												' el valor de esos datos los gestionamos con la variable de sesion
												Session("json_" & id)=cadena_texto_json
											%>
												<%'--response.write("<br />metemos el texto en el oculto y cambiamos el icono...")%>
												<script language="javascript">
													//valor='';
													//valor=valor.'<%=cadena_texto_json%>';
													//valor=valor.replace(/(\r\n|\n|\r)/gm, '')
													console.log('cambio color plantilla 1')
													document.getElementById('ocultodatos_personalizacion_json_<%=id%>').value='COMPLETADO';
													//document.getElementById('icono_plantilla_<%=id%>').src='../images/icono_correcto_verde.png';
													$("#icono_plantilla_<%=id%>").removeClass("btn-warning").addClass("btn-success");
													$("#icono_plantilla_<%=id%>").attr('title', 'Plantilla Para Personalizar El Artículo... YA SE HA COMPLETADO');
													//console.log('cambiamos color boton plantilla')
												</script>
											
											
											<%
											end if
										  else 'la variable de session no esta vacia%>
											<script language="javascript">
												//valor='';
												//valor=valor.'<%=cadena_texto_json%>';
												//valor=valor.replace(/(\r\n|\n|\r)/gm, '')
												console.log('cambio color plantilla 2')
												document.getElementById('ocultodatos_personalizacion_json_<%=id%>').value='COMPLETADO';
												//document.getElementById('icono_plantilla_<%=id%>').src='../images/icono_correcto_verde.png';
												$("#icono_plantilla_<%=id%>").removeClass("btn-warning").addClass("btn-success" );
												$("#icono_plantilla_<%=id%>").attr('title', 'Plantilla Para Personalizar El Artículo... YA SE HA COMPLETADO');
													
												//console.log('cambiamos color boton plantilla 2')
											</script>
										
										<%	
										end if 'de if session("json_"....
										%>
								
								
							  <%else  'de accion MODIFICAR%>
								
								<%if Session("json_" & id)<>"" then%>
									<script language="javascript">
										//valor='';
										//valor=valor.'<%=cadena_texto_json%>';
										//valor=valor.replace(/(\r\n|\n|\r)/gm, '')
										console.log('cambio color plantilla 3')
										document.getElementById('ocultodatos_personalizacion_json_<%=id%>').value='COMPLETADO';
										//document.getElementById('icono_plantilla_<%=id%>').src='../images/icono_correcto_verde.png';
										$("#icono_plantilla_<%=id%>").removeClass("btn-warning").addClass("btn-success" );
										$("#icono_plantilla_<%=id%>").attr('title', 'Plantilla Para Personalizar El Artículo... YA SE HA COMPLETADO');
														
										//console.log('cambiamos color boton plantilla 3')
									</script>
								<%end if%>				
								
								
								
								
							<%end if  'de accion MODIFICAR%>
						  
						   
						  </td>
                          <td width="77" class="ac item_row" style="background-color:<%=colorcin%>">
						  	<input type="hidden" name="ocultocantidad_<%=id%>" id="ocultocantidad_<%=id%>" value="<%=calculos_cantidades_precios(0)%>">
							<%=calculos_cantidades_precios(0)%>
						  </td>
                          <td class="ac item_row" width="66" style="background-color:<%=colorcin%>">
						  	<input type="hidden" name="ocultoprecio_<%=id%>" id="ocultoprecio_<%=id%>" value="<%=calculos_cantidades_precios(1)%>">
							
						  </td>
                          <td class="ac item_row" width="70" style="background-color:<%=colorcin%>;text-align:right">
						  		<%
									if compromiso_compra_pedido="SI" then
										resultado=cdbl(replace(calculos_cantidades_precios(0),".",",")) * cdbl(replace(calculos_cantidades_precios(1),".",","))
									  else
									  	resultado=cdbl(replace(calculos_cantidades_precios(2),".",","))
									end if
									
									'response.write("<br>cantidad: " & calculos_cantidades_precios(0) & " precio unidad: " & calculos_cantidades_precios(1) & " total Pack: " & calculos_cantidades_precios(2))
									'response.write("<br>resultado: " & resultado & " total pedido: " & total_pedido)
									'response.write("<br>resultado: " & replace(resultado,",",".") & " total pedido: " & total_pedido)
									'response.write("<br>resultado: " & cdbl(cstr(resultado)) & " total pedido: " & total_pedido)
									'response.write("<br>compromiso compra: " & compromiso_compra_pedido)
									
									total_pedido=total_pedido + resultado
									'total_pedido=total_pedido + cdbl(replace(resultado,",","."))
									'response.write("<br>sumado con todo lo anterior: " & total_pedido)
								%>
								<input type="hidden" name="ocultototal_<%=id%>" id="ocultototal_<%=id%>" value="<%=resultado%>">
                          </td>
                          <td class="item_row" style="text-align:right; background-color:<%=colorcin%>" width="67" valign="middle">
						  	<table width="76" height="26"  border="0" cellpadding="0" cellspacing="0"  style="border:1px solid">
                              <tr>
                                <td  style="background-color:<%=colorcin%>"><img src="../images/Eliminar.png" border="0" height="16" width="16" /></td>
                                <td style="background-color:<%=colorcin%>" class="item_row"><a href="Carrito_Atesa.asp?borrar=<%=id%>&acciones=<%=cadena_acciones%>" class="fontbold">Quitar</a></td>
                              </tr>
                          </table></td>
                        </tr>
						<%if accion="MODIFICAR" then%>
							<%'ahora nos dicen que solo tienen fichero de personalizacion 
							  '    los que no tienen compromiso de compra
							  '08-05-2014, ahora tambien pueden subir ficheros para las tarjetas de visita
							  '    codigos 564 y 565 en el entorno de pruebas
							  '    y codigos 797 y 887 en el entorno real
                              ' 16/10/15 se añade el código 2065 N007BASE  TARJETA DE VISITA BASE --
								if compromiso_compra_pedido="NO" or id=797 or id=887 or id=2065 then%>
							<%if session(i & "_fichero_asociado")<>"" then%>
							<TR style="background-color:<%=colorcin%>" >
								<td class="item_row" colspan=5 style="background-color:<%=colorcin%>;text-align:right">
									<table width="387" border="0" align="right" cellpadding="0" cellspacing="0" style="background-color:<%=colorcin%>">
										<tr>
											<td width="249" style="background-color:<%=colorcin%>">
												<table width="219px"  border="0" cellpadding="0" cellspacing="0" style="border:1px solid;display:none" id="fila_fichero_<%=id%>">
													<tr>
														<td align="center" >Fichero para Personalizar el Artículo:</td>
															
													</tr>
													<tr>
														<TD>
																<input type="file" name="txtfichero_<%=id%>" id="txtfichero_<%=id%>" value="">
														</td>
													</tr>
											  	</table>
												<table width="219"  border="0" cellpadding="0" cellspacing="0" style="border:1px solid" id="fila_fichero_existente_<%=id%>">
													<tr>
														<td width="88%">Fichero para Personalizar el Artículo:</td>
														<td width="12%"><a href="pedidos/<%=year(fecha_pedido)%>/<%=session("usuario")%>__<%=pedido_modificar%>/<%=session(i & "_fichero_asociado")%>" target="_blank"><img src="../images/clip-16.png" border=0 /></a></td>
													</tr>
										  	  </table>
												 
												
									
											</td>
											<td width="138" style="background-color:<%=colorcin%>">
												<table width="132" border="0" cellpadding="0" cellspacing="0" style="border:1px solid">
													<tr>
														<td width="16%"><img src="../images/icono_modificar.png" border="0" height="16" width="16" /></td>
														<td width="84%"><a href="#" onclick="document.getElementById('fila_fichero_<%=id%>').style.display='block';document.getElementById('fila_fichero_existente_<%=id%>').style.display='none'" class="fontbold">Modificar Fichero</a></td>
													</tr>
											  </table>
											
											</td>
										</tr>
								  </table>
								

								</td>
							</TR>
							<%else%>	
								<tr>
								<td class="item_row" colspan=5 style="background-color:<%=colorcin%>;text-align:right">
									Fichero para Personalizar el Artículo:
								
									<input type="file" name="txtfichero_<%=id%>" id="txtfichero_<%=id%>" value="">
								</td>
								</tr>
							<%end if%>
							<%end if%>
  						  <%else%>
							<%'ahora nos dicen que solo tienen fichero de personalizacion 
							  '    los que no tienen compromiso de compra
							  '08-05-2014, ahora tambien pueden subir ficheros para las tarjetas de visita
							  '    codigos 564 y 565 en el entorno de pruebas
							  '    y codigos 797 y 887 en el entorno real
                              ' 16/10/15 se añade el código 2065 N007BASE  TARJETA DE VISITA BASE --
								if compromiso_compra_pedido="NO" or id=797 or id=887 or id=2065 then%>
							<tr>
								<td class="item_row" colspan=5 style="background-color:<%=colorcin%>;text-align:right">
									Fichero para Personalizar el Artículo:
								
									<input type="file" name="txtfichero_<%=id%>" id="txtfichero_<%=id%>" value="">
								</td>
							</tr>
							<%end if%>
						<%end if%>
						<TR  >
							<td class="item_row" colspan=5 style="background-color:<%=colorcin%>;text-align:right">
								

							</td>
						</TR>
						<TR >
							<td height="2" class="item_row" colspan=5 style="background-color:<%=colorcin%>; border-top-width:1px; border-top-style:dashed;">
								

							</td>
						</TR>
                        <%		
							i=i+1
							articulos.close
						Wend
						
						%>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>
						   	<%
							if control_compromiso_compra_pedido="NO" then
                              	pedido_minimo_permitido= "" & session("usuario_pedido_minimo_sin_compromiso")
      						else
								pedido_minimo_permitido= "" & session("usuario_pedido_minimo_con_compromiso")
							end if
							
							if pedido_minimo_permitido="" then
								pedido_minimo_permitido=0
							end if
							
							%>&nbsp;
                          </td>
                        </tr>
                      </table>
					  <br />
					</form>
				</div>
		  <div class="submit_btn_container">
					<table width="95%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td width="17%">
							
								
								<table border="0" cellpadding="0" cellspacing="0" width="100%" class="btn-details">
									<tr>
										<td width="26%"><img src="../images/Annadir.png" border="0" height="14" width="14" /></td>
										<td width="74%"><a href="Lista_Articulos_Atesa.asp?acciones=<%=cadena_acciones%>"><font color="#FFFFFF">Continuar</font></a></td>
									</tr>
								</table>
								
							</td>
							<td width="17%">
								
								<table border="0" cellpadding="0" cellspacing="0" width="100%" class="btn-details">
									<tr>
										<td width="26%"><img src="../images/Guardar.png" border="0" height="14" width="14" /></td>
										<td width="74%"><a href="#" onclick="validar(<%=REPLACE(pedido_minimo_permitido, ",", ".")%>,<%=REPLACE(total_pedido, ",", ".")%>);return false"><font color="#FFFFFF">Confirmar</font></a></td>
									</tr>
								</table>
								
							</td>
							<td width="66%">
								
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

	<!-- capa para mensajes -->
  <div class="modal fade" id="capa_nueva_mensajes">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_nueva_mensajes"></h4>	    
        </div>	    
        <div class="modal-body" id="body_nueva_mensajes">
        </div> <!-- del modal-body-->     
        <div class="modal-footer" id="botones_nueva_mensajes">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa nueva mensajes -->    

<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer" id="botones_avisos">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=carrito_gag_pantalla_avisos_boton_cerrar_2%></button></p>       
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->


</body>
<%
	'articulos.close
	
	connimprenta.close
	
	set articulos=Nothing
	
	set connimprenta=Nothing

%>
</html>
