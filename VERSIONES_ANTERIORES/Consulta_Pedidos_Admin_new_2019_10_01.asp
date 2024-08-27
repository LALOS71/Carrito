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


	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	

    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="style_menu_hamburguesa5.css">

    <!-- Font Awesome JS -->
    <!--
	<script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
	-->
    <script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

	<link rel="stylesheet" href="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min.css">

------------------------------------------------------------

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



</head>
<body>



<div class="wrapper">
	<!--#include file="Menu_Hamburguesa.asp"-->
	
	<!-- Page Content Holder -->
	<div id="content">
		<button type="button" id="sidebarCollapse" class="navbar-btn active">
			<span></span>
			<span></span>
			<span></span>
		</button>
	
	
		<!--********************************************
		contenido de la pagina
		****************************-->
		<div class="container-fluid">
			<div class="row">
				<div class="card col-12">
					<div class="card-body">
						<h5 class="card-title">Opciones de B&uacute;squeda de Pedidos</h5>
						<div class="form-group row mx-2">
							<div class="col-sm-12 col-md-4 col-lg-4">
								<label for="cmbempresas" class="control-label">Empresa</label>
								<select class="form-control" name="cmbempresas" id="cmbempresas">
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
							</div>
							<div class="col-sm-12 col-md-3 col-lg-2">
								<label for="txtfecha_inicio" class="control-label">Fecha de Inicio</label>
								<input type="date" class="form-control" name="txtfecha_inicio" id="txtfecha_inicio"  value="<%=fecha_i%>" /> 
							</div>
							<div class="col-sm-123 col-md-3 col-lg-2">
								<label for="txtfecha_fin" class="control-label">Fecha Fin</label>
								<input type="date" class="form-control" name="txtfecha_fin" id="txtfecha_fin"  value="<%=fecha_f%>" /> 
							</div>
						</div>
						
						<div class="form-group row mx-2">
							<input type="hidden" name="ocultoorden_clientes" id="ocultoorden_clientes" value="<%=orden_clientes%>" />
							<input type="hidden" name="ocultocliente_seleccionado" id="ocultocliente_seleccionado" value="<%=hotel_seleccionado%>" />
							<label for="cmbhoteles" class="control-label">Art&iacute;culo</label>
							<div id="capa_hoteles" style="float:left ">
								<select  class="form-control" name="cmbhoteles" id="cmbhoteles">
									<option value="" selected>* Seleccione *</option>
								</select>
							</div>
								
							<div style="float:left ">
							&nbsp;
							<input class="submitbtn" type="button" name="cmdquitar_seleccion" id="cmdquitar_seleccion" value="X" onclick="quitar_seleccion()"  />
							<input class="submitbtn" type="button" name="cmdcambiar_orden" id="cmdcambiar_orden" value="Reordenar" onclick="cambiar_orden()" />
							</div>
							<br />
							<input  class="form-control" name="chkmostrar_borrados" id="chkmostrar_borrados" type="checkbox" value="SI" onclick="control_borrados()" />&nbsp;Mostrar Borrados
							<%if mostrar_borrados="SI" then%>
								<script language="javascript">
									document.getElementById("chkmostrar_borrados").checked=true
								</script>
							<%end if%>
						
						</div>
						
						
						<div class="form-group row mx-2">
							<label for="cmbarticulos" class="control-label">Art&iacute;culo</label>
							<select class="form-control" name="cmbarticulos" id="cmbarticulos__">
									<option value="" selected>* Seleccione *</option>
							</select>
							<div class="typeahead__container">
								<div class="typeahead__field">
									<div class="typeahead__query">
										<input class="js-typeahead-articulos form-control" name="txtbuscar_articulos" id="txtbuscar_articulos" type="search" placeholder="Buscar Ar&iacute;iculos (por Referencia o Descripci&oacute)" autocomplete="off">
									</div>
								</div>
							</div>
							
							<div class="col-sm-6 col-md-6 col-lg-6">
								<label for="txtcliente" class="control-label">Cliente</label>
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input class="js-typeahead-cliente form-control" name="txtcliente" id="txtcliente" type="search" placeholder="Buscar Cliente" autocomplete="off" value="<%=cliente_seleccionado%>">
										</div>
									</div>
								</div>
								
							</div>
							
							<div class="col-sm-6 col-md-6 col-lg-6">
								<label for="txtarticulo" class="control-label">articulo</label>
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input class="js-typeahead-articulo form-control" name="txtarticulo" id="txtarticulo" type="search" placeholder="Buscar Articulo" autocomplete="off" value="">
										</div>
									</div>
								</div>
								
							</div>
							
						</div>
						
						<div class="form-group row mx-2">
							<div class="col-sm-12 col-md-3 col-lg-3">
								<label for="cmbempresas" class="control-label">Estado</label>
								<select class="form-control" name="cmbestados" id="cmbestados">
										<option value="" selected>* Seleccione *</option>
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
							</div>
							<div class="col-sm-12 col-md-2 col-lg-2">
								<label for="txtpedido" class="control-label">Num. Pedido</label>
								<input type="text" class="form-control" name="txtpedido" id="txtpedido"  value="<%=numero_pedido_seleccionado%>" /> 
							</div>
							<div class="col-sm-12 col-md-3 col-lg-3">
								<label for="cmbpedidos_automaticos" class="control-label">Pedidos Autom&aacute;ticos</label>
								<select class="form-control" name="cmbpedidos_automaticos" id="cmbpedidos_automaticos">
										<option value="" selected>* Seleccione *</option>
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
							</div>
						</div>
						
						
					</div>
				</div>
			</div>
			
		</div><!--del content-fluid-->
	</div><!--fin de content-->
</div><!--fin de wrapper-->


----------------------------------------------------------

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
											<td width="9%">Cliente: </td>
											<td width="91%">
												<!--
												<select class="txtfielddropdown" name="cmbhoteles" id="cmbhoteles" size="1" onfocus="alert('en el focus')" onblur="alert('en el blur')" onchange="alert('en el change')">
												-->
												
											</td>
																						
										</tr>
										
									</table>
									<table width="306" cellpadding="0" cellspacing="0">
										<tr><td height="3"></td></tr>
							  		</table>
									
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
									<tr>
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




--------------------------------------------------------------
<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
	
<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>
    
<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>

<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>

<script type="text/javascript" src="plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min_unicode.js"></script>



<script type="text/javascript">
var j$=jQuery.noConflict();
		
j$(document).ready(function () {
	j$("#menu_pedidos").addClass('active')
	
	j$('#sidebarCollapse').on('click', function () {
		j$('#sidebar').toggleClass('active');
		j$(this).toggleClass('active');
	});
	
	
	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true});
	
	j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
	
	
	//**********************************
	//este control esta en esta url: http://www.runningcoder.org/jquerytypeahead
	
	
	j$.typeahead({
		input: '.js-typeahead-cliente',
		//input: '.typeahead_clientes',
		minLength: 0,
		maxItem: 15,
		order: "asc",
		hint: true,
		accent: true,
		cancelButton: false,
		//searchOnFocus: true,
		backdrop: {
			"background-color": "#3879d9",
			//"background-color": "#fff",
			"opacity": "0.1",
			"filter": "alpha(opacity=10)"
		},
		source: {
			cliente: {
				//display: ["REFERENCIA", "TIPO_MALETA", "TAMANNO", "COLOR"],
				display: "CLIENTE",
				ajax: function (query) {
					return {
						type: "POST",
						url: "Gestion_Graphisoft/tojson/obtener_clientes_graphisoft.asp",
						//{"status":true,"error":null,"data":{"user":[{"id":748137,"username":"juliocastrop","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/748137"},{"id":5741776,"username":"solevy","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/5741776"},{"id":906237,"username":"nilovna","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/906237"},{"id":612578,"username":"Thiago Talma","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/612578"},{"id":985837,"username":"ldrrp","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/985837"}],"project":[{"id":2,"project":"jQuery Validation","image":"http:\/\/www.runningcoder.org\/assets\/jqueryvalidation\/img\/jqueryvalidation-preview.jpg","version":"1.4.0","demo":11,"option":14,"callback":8}]}}
						//path: "data.user",
						path: "data",
						//data: {proveedor: "<%=proveedor%>"},
						callback: {
							
							}
						}
					}
				
	 
			}
			
		},

		callback: {
			onInit: function (node) {
				//console.log('Typeahead Initiated on ' + node.selector);
			}
		},
		debug: true
	});
	
	j$.typeahead({
		input: '.js-typeahead-articulo',
		//input: '.typeahead_clientes',
		minLength: 3,
		maxItem: 15,
		order: "asc",
		hint: true,
		accent: true,
		cancelButton: false,
		//searchOnFocus: true,
		backdrop: {
			"background-color": "#3879d9",
			//"background-color": "#fff",
			"opacity": "0.1",
			"filter": "alpha(opacity=10)"
		},
		source: {
			cliente: {
				//display: ["REFERENCIA", "TIPO_MALETA", "TAMANNO", "COLOR"],
				display: "DESCRIPCION",
				ajax: function (query) {
					return {
						type: "POST",
						url: "tojson/consulta_pedidos_obtener_articulos.asp",
						//{"status":true,"error":null,"data":{"user":[{"id":748137,"username":"juliocastrop","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/748137"},{"id":5741776,"username":"solevy","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/5741776"},{"id":906237,"username":"nilovna","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/906237"},{"id":612578,"username":"Thiago Talma","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/612578"},{"id":985837,"username":"ldrrp","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/985837"}],"project":[{"id":2,"project":"jQuery Validation","image":"http:\/\/www.runningcoder.org\/assets\/jqueryvalidation\/img\/jqueryvalidation-preview.jpg","version":"1.4.0","demo":11,"option":14,"callback":8}]}}
						//path: "data.user",
						path: "data",
						//data: {proveedor: "<%=proveedor%>"},
						callback: {
							
							}
						}
					}
				
	 
			}
			
		},

		callback: {
			onInit: function (node) {
				//console.log('Typeahead Initiated on ' + node.selector);
			}
		},
		debug: true
	});
	
	
	
	
	
	
	
	
	
});
		
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
