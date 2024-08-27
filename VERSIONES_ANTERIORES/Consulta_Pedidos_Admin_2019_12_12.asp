<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->

<%
	response.Buffer=true
	numero_registros=0

	if session("usuario_admin")="" then
		Response.Redirect("Login_Admin.asp")
	end if
		
	hotel_seleccionado=Request.Form("cmbhoteles")
	estado_seleccionado=Request.Form("cmbestados")
	empresa_seleccionada=Request.Form("cmbempresas")    
	numero_pedido_seleccionado=Request.Form("txtpedido")
	fecha_i=Request.Form("txtfecha_inicio")
	fecha_f=Request.Form("txtfecha_fin")
	pedido_automatico_seleccionado=Request.Form("cmbpedidos_automaticos")
		
	orden_clientes=Request.Form("ocultoorden_clientes")
		
	if orden_clientes="" then
		orden_clientes="POR_NOMBRE"
	end if
	mostrar_borrados=Request.Form("chkmostrar_borrados")
	if mostrar_borrados<>"SI" then
		mostrar_borrados="NO"
	end if
	
		
	'RESPONSE.WRITE("<br>borrados: " & mostrar_borrados)
	'RESPONSE.WRITE("<br>orden: " & orden_clientes)
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
		.Source="SELECT PEDIDOS.ID Id, PEDIDOS.CODCLI, V_EMPRESAS.EMPRESA, V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO, PEDIDOS.PEDIDO,"
		.Source= .Source & " PEDIDOS.FECHA, PEDIDOS.ESTADO, V_EMPRESAS.ID AS EMPRESA_ID, V_CLIENTES.TIPO as TIPO_CLIENTE, V_CLIENTES.REQUIERE_AUTORIZACION," 
		.Source= .Source & " PEDIDOS.PEDIDO_AUTOMATICO, isnull(PEDIDOS.GASTOS_ENVIO, 0) GASTOS_ENVIO,"
		.Source= .Source & " Total * 0.21 TotIva_ANT, Total+(Total * 0.21) TotalEnvio_ANT, isnull(Nreg,0) Nreg_aNT,"
       
		.Source= .Source & " ((Total + isnull(PEDIDOS.GASTOS_ENVIO, 0)) * 0.21) TotIva, (Total + isnull(PEDIDOS.GASTOS_ENVIO, 0) + ((Total + isnull(PEDIDOS.GASTOS_ENVIO, 0)) * 0.21)) TotalEnvio, isnull(Nreg,0) Nreg"
        .Source= .Source & " FROM PEDIDOS INNER JOIN V_CLIENTES"
		.Source= .Source & " ON PEDIDOS.CODCLI = V_CLIENTES.Id"
		.Source= .Source & " INNER JOIN V_EMPRESAS"
		.Source= .Source & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
        .Source= .Source & " LEFT JOIN (SELECT ID_Pedido, sum(total) Total, Sum(1) NReg FROM  Pedidos_Detalles where estado<>'ANULADO'  GROUP BY ID_Pedido ) Tot 	ON PEDIDOS.ID = Tot.ID_Pedido "
		.Source= .Source & " WHERE 1=1"
		'solo filtra por empresa cuando se pone solo la empresa, 
		'si se selecciona el cliente, ya no filtra por empresa para
		'que puedan salir tambien los pedidos asociados a este cliente que son de otro cliente y de diferente empresa
		' por ejemplo las oficinas de halcon que generan pedidos para otros clientes no de halcon, sino de la empresa/cadena MALETAS GLOBALBAG
		if empresa_seleccionada<>"" and hotel_seleccionado=""  then
			.Source= .Source & " AND V_EMPRESAS.ID=" & empresa_seleccionada 
		end if
		if estado_seleccionado<>"" then
			.Source= .Source & " AND PEDIDOS.ESTADO='" & estado_seleccionado & "'"
		end if
		if hotel_seleccionado<>"" then
			.Source= .Source & " AND (PEDIDOS.CODCLI=" & hotel_seleccionado
			.Source= .Source & " OR CLIENTE_ORIGINAL=" & hotel_seleccionado & ")"
		end if
		if numero_pedido_seleccionado<>"" then
			.Source= .Source & " AND PEDIDOS.ID=" & numero_pedido_seleccionado
		end if
			
		IF estado_seleccionado="" and hotel_seleccionado="" and empresa_seleccionada="" and numero_pedido_seleccionado="" and fecha_i="" and fecha_f="" and pedido_automatico_seleccionado="" then
			.Source= .Source & " AND PEDIDOS.ESTADO='SIN TRATAR'"
		end if
		if fecha_i<>"" then
			.Source= .Source & " AND (PEDIDOS.FECHA >= '" & fecha_i & "')" 
		end if
		if fecha_f<>"" then
			.Source= .Source & " AND (PEDIDOS.FECHA <= '" & fecha_f & "')"
		end if
		
		if pedido_automatico_seleccionado<>"" then
			if pedido_automatico_seleccionado="TODOS" then
				.Source= .Source & " AND (PEDIDOS.PEDIDO_AUTOMATICO<>'')"
			  else
			  	.Source= .Source & " AND (PEDIDOS.PEDIDO_AUTOMATICO='" & pedido_automatico_seleccionado & "')"
			
			end if
		end if
			
		.Source= .Source & " ORDER BY PEDIDOS.FECHA DESC, PEDIDOS.CODCLI, PEDIDOS.ID"
		'response.write("<br>" & .source)
		cadena_consulta=.Source
		.Open
	end with
    
		
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

	set estados=Server.CreateObject("ADODB.Recordset")
	CAMPO_ID_ESTADO=0
	CAMPO_ESTADO_ESTADO=1
	CAMPO_ORDEN_ESTADO=2
	with estados
		.ActiveConnection=connimprenta
		.Source="SELECT *"
		.Source= .Source & " FROM ESTADOS"
		.Source= .Source & " ORDER BY ORDEN"
		.Open
		vacio_estados=false
		if not .BOF then
			mitabla_estados=.GetRows()
			else
			vacio_estados=true
		end if
	end with

	estados.close
	set estados=Nothing

	
	set pedidos_automaticos=Server.CreateObject("ADODB.Recordset")
	CAMPO_PEDIDO_AUTOMATICO=0
	with pedidos_automaticos
		.ActiveConnection=connimprenta
		.Source="SELECT DISTINCT PEDIDO_AUTOMATICO FROM PEDIDOS WHERE PEDIDO_AUTOMATICO<>'' ORDER BY PEDIDO_AUTOMATICO"
		.Open
		vacio_pedidos_automaticos=false
		if not .BOF then
			mitabla_pedidos_automaticos=.GetRows()
			else
			vacio_pedidos_automaticos=true
		end if
	end with

	pedidos_automaticos.close
	set pedidos_automaticos=Nothing

		
'funcion para formatear:' - a 2 decimales,' - con separadores de miles,' - con el 0 delante de valores entre 0 y 1...
Function formatear_importe(importe)
	   if importe<>"" then				
		importe_formateado=FORMATNUMBER(importe,2,-1,,-1)
        
	      else
		importe_formateado=""
	   end if		
		'response.write("<br><br>" & importe_formateado)
		formatear_importe=importe_formateado
End Function


'response.write("<br>cadena consulta: " & cadena_consulta)
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
		
.opaco { opacity=.30; filter: alpha(opacity=20); -moz-opacity:0.20;  } 

		
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


function cambiacomaapunto (s){
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
function cambiapuntoacoma(s){
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


function mostrar_pedido(pedido, nreg) {
    if (nreg == 0) {
        alert('El pedido ' + pedido + ' No contiene detalles');
        return;
    }    
   	document.getElementById('ocultopedido').value=pedido
   	document.getElementById('frmmostrar_pedido').submit()		    
}// mostrar_pedido --

  
function modificar_pedido(numero_pedido, empresa){
	//alert('ha modificar el pedido')
	document.getElementById("ocultopedido_a_modificar").value=numero_pedido
	document.getElementById("ocultoempresa_pedido").value=empresa
	document.getElementById("frmmodificar_pedido").submit()	
}	  
  
 	
function quitar_seleccion(){
	document.getElementById('cmbhoteles').value=''
	document.getElementById("ocultocliente_seleccionado").value=''
	//document.getElementById('cmbhoteles').focus()
}


function refrescar_pagina(orden,borrados){
	//alert(document.getElementById("cmbempresas").value)
	//console.log('borrados en refrescar pagina: ' + borrados)
	Actualizar_Combos('Obtener_Clientes.asp', document.getElementById("cmbempresas").value, document.getElementById("ocultocliente_seleccionado").value,'capa_hoteles', orden, borrados)
	cerrar_capas('capa_informacion')
	
}

function control_borrados()
	{
	//console.log('checkbox: ' + document.getElementById('chkmostrar_borrados').checked)
	if (document.getElementById('chkmostrar_borrados').checked)
		{
		refrescar_pagina(document.getElementById('ocultoorden_clientes').value, 'SI')
		}
	  else
	  	{
		refrescar_pagina(document.getElementById('ocultoorden_clientes').value, 'NO')
		}
		
	}
	
function cambiar_orden(){
	//alert('refrescar: ' + orden)
	if (document.getElementById('ocultoorden_clientes').value=='POR_ID')
		{
		ordenacion='POR_NOMBRE'
		document.getElementById('ocultoorden_clientes').value='POR_NOMBRE'
		}
	  else
		if (document.getElementById('ocultoorden_clientes').value=='POR_NOMBRE')
			{
			ordenacion='POR_ID'
			document.getElementById('ocultoorden_clientes').value='POR_ID'
			}
		  else
		  	{
			ordenacion='POR_NOMBRE'
			document.getElementById('ocultoorden_clientes').value='POR_NOMBRE'
			}
	  
	  	

	refrescar_pagina(ordenacion, document.getElementById('chkmostrar_borrados').checked)
}


function guardar_todo_pedido(numero_pedido){
	if (document.getElementById('imagen_' + numero_pedido).className=='opaco')
		{
			alert('primero ha de cambiar el estado del pedido')
		}
	
	if (document.getElementById('imagen_' + numero_pedido).className=='noopaco')
		{
			alert('pedido: ' + numero_pedido + ' ... estado: ' + document.getElementById('cmbestados_' + numero_pedido).value)
			
			if (document.getElementById('cmbestados_' + numero_pedido).value=='ENVIADO')
				{
				if (confirm('¿Esta Seguro de querer Pasar a "ENVIADO" el pedido ' + numero_pedido + '? \n(ya que se procederá a restar el stock de articulos, si procede...)'))
					{
						alert('en construccion...... cambiando el estado de todo el pedido')
						document.getElementById('ocultonumero_pedido_cambiar').value=numero_pedido
						document.getElementById('ocultonuevo_estado_pedido').value=document.getElementById('cmbestados_' + numero_pedido).value
						document.getElementById('frmcambiar_todo_pedido').submit()
					}				
				
				}
			else
				{
					alert('en construccion...... cambiando el estado de todo el pedido')
					document.getElementById('ocultonumero_pedido_cambiar').value=numero_pedido
					document.getElementById('ocultonuevo_estado_pedido').value=document.getElementById('cmbestados_' + numero_pedido).value
					document.getElementById('frmcambiar_todo_pedido').submit()
				}	
			
			
		}
}// guardar_todo_pedido --

</script>
<script language="javascript" src="Funciones_Ajax.js"></script>

<!-- European format dd-mm-yyyy -->
	<script language="JavaScript" src="js/calendario/calendar1.js"></script>
<!-- Date only with year scrolling -->

<script src="DD_roundies_0_0_2a.js"></script>
<script src="funciones.js" type="text/javascript"></script>
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
<body onload="refrescar_pagina(document.getElementById('ocultoorden_clientes').value, '<%=mostrar_borrados%>')">
<!-- capa opaca para que no deje pulsar nada salvo lo que salga delante (se comporte de forma modal)-->
<div id="capa_opaca" style="display:none;background-color:#000000;position:fixed;top:0px;left:0px;width:105%;min-height:110%;z-index:5;filter:alpha(opacity=50);-moz-opacity:.5;opacity:.5">
</div>

<!-- capa con la informacion a mostrar por encima-->
<div id="capa_informacion" style="display:none;z-index:6;position:fixed;width:100%; height:100%">
		<div id="contenedorr3" class="aviso">
			<p>
				<img src="images/loading4.gif"/>
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
				<font size="3"><b>Mantenimientos</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					· <a href="Consulta_Pedidos_Admin.asp">Pedidos</a><br />
					· <a href="Consulta_Articulos_Admin.asp">Artículos</a><br />
					· <a href="Consulta_Clientes_Admin.asp">Clientes</a><br />
					· <a href="Consulta_Informes_Admin.asp">Informes</a><br /><br />										
					· <a href="Carrusel_Admin.asp" target="_blank">Carrusel</a><br />					
					<br /><br />	<br />	<br />	<br />									
				</div>
				</div>
			</div>
		</div>
		
	

	</td>
	<td width="713" valign="top">
		<div id="main">						
		    <div class="comment_title fontbold">Consulta de Pedidos</div>
			<div class="comment_text"> 
					<form name="frmconsulta_pedidos" action="Consulta_Pedidos_Admin.asp" method="post">
					<table width="99%" cellspacing="6" cellpadding="0" class="logintable" align="center">
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Opciones de Búsqueda de Pedidos</span>
							</td>
						</tr>
						<tr>
							<td width="50%" class="dottedBorder vt al">								
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
										<tr>
											<td width="9%">Empresa: </td>
											<td width="28%">
												<select  name="cmbempresas" id="cmbempresas"  onchange="refrescar_pagina(document.getElementById('ocultoorden_clientes').value, document.getElementById('chkmostrar_borrados').checked)">
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
											<td  style="padding:10px" width="9%"><font style="COLOR:#000000"><b>F. Ini.:</b></font></td>
										  <td width="22%">
													<input type="Text" class="txtfield" name="txtfecha_inicio" id="txtfecha_inicio" value="<%=fecha_i%>" size=7>
													<a href="javascript:cal1.popup();"><img src="img/cal.gif" width="16" height="16" border="0" alt="Pulsa Aqui para Seleccionar una Fecha de Inicio" /></a>
											  </td>
												<td width="7%"><font style="COLOR:#000000"><b>F. Fin:</b></font> </td>
												<td width="25%">
													<input type="Text" class="txtfield" name="txtfecha_fin" id="txtfecha_fin" value="<%=fecha_f%>" size=7>
													<a href="javascript:cal2.popup();"><img src="img/cal.gif" width="16" height="16" border="0" alt="Pulsa Aqui para Seleccionar una Fecha de Fin"></a>
												
												
												</td>
												
										</tr>
									</table>
									<table width="306" cellpadding="0" cellspacing="0">
										<tr><td height="3"></td></tr>
							  		</table>
									
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
										<tr>
											<td width="9%">Cliente: </td>
											<td width="91%">
												<!--
												<select class="txtfielddropdown" name="cmbhoteles" id="cmbhoteles" size="1" onfocus="alert('en el focus')" onblur="alert('en el blur')" onchange="alert('en el change')">
												-->
												<table width="100%">
													<tr>
														<td>
															<input type="hidden" name="ocultoorden_clientes" id="ocultoorden_clientes" value="<%=orden_clientes%>" />
															<input type="hidden" name="ocultocliente_seleccionado" id="ocultocliente_seleccionado" value="<%=hotel_seleccionado%>" />
															<div id="capa_hoteles" style="float:left ">
																<select  name="cmbhoteles" id="cmbhoteles">
																	<option value="" selected>* Seleccione *</option>
																</select>
															</div>
																
															<div style="float:left ">
															&nbsp;
															<input class="submitbtn" type="button" name="cmdquitar_seleccion" id="cmdquitar_seleccion" value="X" onclick="quitar_seleccion()"  />
															<input class="submitbtn" type="button" name="cmdcambiar_orden" id="cmdcambiar_orden" value="Reordenar" onclick="cambiar_orden()" />
															</div>
															
														</td>
													</tr>
													<tr>
														<td>
															<input name="chkmostrar_borrados" id="chkmostrar_borrados" type="checkbox" value="SI" onclick="control_borrados()" />&nbsp;Mostrar Borrados
															<%if mostrar_borrados="SI" then%>
																<script language="javascript">
																	document.getElementById("chkmostrar_borrados").checked=true
																</script>
															<%end if%>
														</td>
													</tr>
												</table>
											</td>
																						
										</tr>
										
									</table>
									<table width="306" cellpadding="0" cellspacing="0">
										<tr><td height="3"></td></tr>
							  		</table>
									
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
									<tr>
										<td width="9%">Estado: </td>
										<td width="34%">
											<select class="txtfielddropdown" name="cmbestados" id="cmbestados" size="1">
												<option value=""  selected="selected">Seleccionar Estado</option>
												<option value="RESERVADO">RESERVADO</option>
												<%if vacio_estados=false then %>
														<%for i=0 to UBound(mitabla_estados,2)%>
															<option value="<%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%>"><%=mitabla_estados(CAMPO_ESTADO_ESTADO,i)%></option>
														<%next%>
												<%end if%>
											</select>
											<%if estado_seleccionado<>"" then%>
												<script language="javascript">
													document.getElementById("cmbestados").value='<%=estado_seleccionado%>'
												</script>
											<%end if%>
										</td>
										<td width="10%">N. Pedido: </td>
										<td width="38%">
											<input class="txtfield" name="txtpedido" id="txtpedido" value="<%=numero_pedido_seleccionado%>" />
										</td>
										<td width="9%">
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
										<td width="21%">Pedidos Automaticos: </td>
										<td width="49%">
											<select class="txtfielddropdown" name="cmbpedidos_automaticos" id="cmbpedidos_automaticos" size="1">
												<option value=""  selected="selected">Seleccionen Opcion</option>
												<option value="TODOS">TODOS</option>
												<%if vacio_pedidos_automaticos=false then %>
														<%for i=0 to UBound(mitabla_pedidos_automaticos,2)%>
															<option value="<%=mitabla_pedidos_automaticos(CAMPO_pedido_automatico,i)%>"><%=mitabla_pedidos_automaticos(CAMPO_pedido_automatico,i)%></option>
														<%next%>
												<%end if%>
											</select>
											<%if pedido_automatico_seleccionado<>"" then%>
												<script language="javascript">
													document.getElementById("cmbpedidos_automaticos").value='<%=pedido_automatico_seleccionado%>'
												</script>
											<%end if%>
										</td>
										<td width="9%"></td>
										<td width="13%">&nbsp;
										</td>
										<td width="8%">
											<div align="right">											</div>
										</td>
									</tr>
									</table>
									
						  </td>
						</tr>
				  </table>
				  </form>
					<br />
					<table border="0" cellpadding="0" cellspacing="0" width="98%" align="center">
					<tr>
						<td>	                                                       						
							<table border="0" cellpadding="1" cellspacing="1" width="102%" class="info_table" align="center">
								<tr style="background-color:#FCFCFC" valign="top">
									<th class="menuhdr" width="206">Cliente</th>
									<th class="menuhdr" width="87">Num. Pedido</th>
									<th class="menuhdr" width="73">Fecha</th>
									<th class="menuhdr" width="63">Importe</th>
									<th class="menuhdr" width="128">Estado</th>
                                    <th class="menuhdr" width="106">Acción</th>
								</tr>
								<%if pedidos.eof then%>
									<tr> 
										<td bgcolor="#999966" align="center" colspan="5"><b><FONT class="fontbold">Aún No Se Han Realizado Pedidos...</font></b><br>
										</td>
									</tr>
								<%end if%>
								<%vueltas=1
									while not pedidos.eof%>									  
									<%if numero_registros=200 then
												response.Flush()
												numero_registros=0
											else
												numero_registros=numero_registros + 1
										end if%>
											
											
									<%
										IF pedidos("empresa_id")=4 and pedidos("tipo_cliente")="PROPIA" THEN
											color_fila="#FFFFCC"
											else
											color_fila="#FCFCFC"
										END IF
									%>
									<!-- 22/01/14 - Con la excepción de que los pedidos de la oficina 406-TETUAN pasen directamente a 
										            SIN TRATAR, destacamos el registro para que la imprenta sepa que es de esta oficina
														
									    03/04/2014 - como ahora eso pasa con mas oficinas, buscamos la condicion en el campo requiere_autorizacion-->
										
										
									<%'lo mantenemos para diferenciar esta franquicia de las propias
									if pedidos("empresa")="ASM" and pedidos("codigo_externo")="406" and pedidos("nombre")="TETUAN" and pedidos("estado")="SIN TRATAR" then
											color_fila="#E4EFDC"
										end if%>

									<%if pedidos("empresa")="ASM" and pedidos("requiere_autorizacion")="NO" and pedidos("estado")="SIN TRATAR" then
											color_fila="#E4EFDC"
										end if%>

									<tr  style="cursor:hand;cursor:pointer;" valign="top" onmouseover="javascript:this.style.background='#ffc9a5';" onmouseout="javascript:this.style.background='#FCFCFC'">
										<td  onclick="mostrar_pedido(<%=pedidos("id")%> ,<%=pedidos("Nreg")%>);return false" class="item_row" width="206" align="left" style="background-color:<%=color_fila%>;">
										<%=pedidos("empresa")%> -
										<%if pedidos("codigo_externo")<>"" then%>
											&nbsp;(<b><%=pedidos("codigo_externo")%></b>)
										<%end if%>
										&nbsp;<%=pedidos("nombre")%>
										</td>
										
										<td  onclick="mostrar_pedido(<%=pedidos("id")%>,<%=pedidos("Nreg")%>);return false" class="ac item_row" width="87" align="right" style="background-color:<%=color_fila%>;"><%=pedidos("id")%></td>
										<td  onclick="mostrar_pedido(<%=pedidos("id")%>,<%=pedidos("Nreg")%>);return false" class="item_row" style="background-color:<%=color_fila%>;text-align:left" width="73" ><%=pedidos("fecha")%></td>                                            
                                        <td  onclick="mostrar_pedido(<%=pedidos("id")%>,<%=pedidos("Nreg")%>);return false" 
                                            class="item_row" style="background-color:<%=color_fila%>;text-align:left" width="63" >                                        
                                            <%																											
												total=pedidos("TotalEnvio")
                                                response.write(formatear_importe(total))                                                
											%> 
											€
                                        </td>                                                                                                                             
										<td  onclick="mostrar_pedido(<%=pedidos("id")%>,<%=pedidos("Nreg")%>);return false" width="128" class="ac item_row" style="background-color:<%=color_fila%>;"><%=pedidos("estado")%></td>
										<td  width="106" class="ac item_row" style="background-color:<%=color_fila%>;">
											<%if pedidos("pedido_automatico")<>"" then%>
													<%=pedidos("pedido_automatico")%>
													<br />
											<%end if%>
										 <%if pedidos("estado")<>"ENVIADO" and pedidos("empresa_id")<>4 and pedidos("Nreg")<>0 THEN%>
										    <table width="76%" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td width="23%" style="background-color:<%=color_fila%>;"><img src="images/icono_modificar.png" border="0" height="16" width="16" /></td>
												<td width="77%" style="background-color:<%=color_fila%>;">
														
												
														<a href="#" onclick="modificar_pedido(<%=pedidos("id")%>, <%=pedidos("empresa_id")%>)" class="fontbold">Modificar</a>
													    <!--<a href="#" onclick="alert('en construccion')" class="fontbold">Modificar</a> -->																				
												</td>
											</tr>
									</table>
										<%END IF%>
										</td>
									</tr>
								
								<%		
									pedidos.movenext
									if vueltas=800 then
										response.Flush()
										vueltas=0
									else
										vueltas=vueltas+1
									end if
								Wend
									
								%>


									
						</table>							
							
							
						</td>
						
					</tr>
					
					
				  </table>
					
					<br />
					
					
					<div class="submit_btn_container__" align="center">	
							<table width="13%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
								<tr>
									<td>
									<form id="frmpasar_excel" name="frmpasar_excel" method="post" action="Pedidos_Excel.asp">
										<input type="hidden" id="ocultosql" name="ocultosql" value="<%=cadena_consulta%>" />
										<input class="submitbtn" type="submit" name="exportar_excel" id="exportar_excel" value="Exportar a Excel" />
										
									</form>	
									</td>
								</tr>
							</table>
				  </div>
					
				</div>
			
		    <div class="submit_btn_container">			  
				<table width="13%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
					<tr>
						<td>
							<a href="Consulta_Pedidos_Admin.asp" class="btn-details"><font color="#FFFFFF">Volver</font></a>
						</td>
					</tr>
		        </table>		  
		</div>			
		</div>	
	</td>
</tr>


</table>

<form name="frmmostrar_pedido" id="frmmostrar_pedido" action="Pedido_Admin.asp" method="post">
	<input type="hidden" value="" name="ocultopedido" id="ocultopedido" />
</form>


<form action="Modificar_Pedido_Imprenta_Admin.asp" method="post" name="frmmodificar_pedido" id="frmmodificar_pedido">
	<input type="hidden" id="ocultopedido_a_modificar" name="ocultopedido_a_modificar" value="" />
	<input type="hidden" id="ocultoempresa_pedido" name="ocultoempresa_pedido" value="" />
	<input type="hidden" id="ocultoaccion" name="ocultoaccion" value="MODIFICAR" />
</form>



<form name="frmcambiar_todo_pedido" id="frmcambiar_todo_pedido" method="post" action="Cambiar_Estado_Todo_Pedido.asp">
	<input type="hidden" id="ocultonumero_pedido_cambiar" name="ocultonumero_pedido_cambiar" value="" />
	<input type="hidden" id="ocultonuevo_estado_pedido" name="ocultonuevo_estado_pedido" value="" />
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
	
	connimprenta.close
	
	set articulos=Nothing
	set hoteles=Nothing
	set connimprenta=Nothing

%>
</html>
