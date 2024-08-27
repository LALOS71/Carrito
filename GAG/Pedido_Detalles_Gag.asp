<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
		'Recogemos la variable borrar 
		borrar=Request.Querystring("borrar")

		empleado_gls=Request.Querystring("emp")
		


		if session("usuario")="" then
			if empleado_gls="SI" then
				Response.Redirect("../Login_GLS_Empleados.asp")
			  else
			  	Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
			end if
		end if
		
		
		
		'recordsets
		dim articulos
		
		mostrar_totales="no"
		
		'variables
		dim sql
		
		pedido_seleccionado=Request.QueryString("pedido")
		if pedido_seleccionado="" then
			pedido_seleccionado=0
		end if

	    
	    set articulos=Server.CreateObject("ADODB.Recordset")
		
		'response.write("<br>" & sql)

			with articulos
				.ActiveConnection=connimprenta
				.Source="SELECT PEDIDOS_DETALLES.ARTICULO, ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION, PEDIDOS_DETALLES.CANTIDAD,"
				.Source=.Source & " PEDIDOS_DETALLES.PRECIO_UNIDAD, PEDIDOS_DETALLES.TOTAL, PEDIDOS_DETALLES.ESTADO,"
				.Source=.Source & " PEDIDOS_DETALLES.FICHERO_PERSONALIZACION, PEDIDOS.CODCLI, PEDIDOS.FECHA,"
				.Source=.Source & " V_EMPRESAS.CARPETA, V_CLIENTES.MARCA, V_CLIENTES.NOMBRE AS NOMBRE_CLIENTE,"
				.Source=.Source & " V_CLIENTES.CODIGO_EXTERNO AS COD_CLIENTE, ARTICULOS_PERSONALIZADOS.PLANTILLA_PERSONALIZACION,"
				.Source=.Source & " V_CLIENTES.ID AS ID_CLIENTE,"
				.Source=.Source & " CASE WHEN PEDIDOS_DETALLES.ALBARAN IS NULL THEN NULL ELSE" 
				.Source=.Source & " (SELECT FECHAVALIJA FROM V_DATOS_ALBARANES WHERE IDALBARAN=PEDIDOS_DETALLES.ALBARAN)"
				.Source=.Source & " END AS ENVIO_PROGRAMADO, PEDIDOS.PEDIDO_AUTOMATICO, PEDIDOS.DESCUENTO_TOTAL,"
				.Source=.Source & " V_CLIENTES.PAIS, PEDIDOS.GASTOS_ENVIO"
				
				.Source=.Source & " FROM V_EMPRESAS INNER JOIN (V_CLIENTES "
				.Source=.Source & " INNER JOIN ((PEDIDOS INNER JOIN PEDIDOS_DETALLES"
				.Source=.Source & " ON PEDIDOS.ID = PEDIDOS_DETALLES.ID_PEDIDO)"
				.Source=.Source & " INNER JOIN ARTICULOS ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID)"
				.Source=.Source & " ON V_CLIENTES.Id = PEDIDOS.CODCLI) ON V_EMPRESAS.Id = V_CLIENTES.EMPRESA"
				.Source=.Source & " LEFT JOIN ARTICULOS_PERSONALIZADOS"
				.Source=.Source & " ON ARTICULOS.ID=ARTICULOS_PERSONALIZADOS.ID_ARTICULO"
										
				.Source=.Source & " where pedidos.id=" & pedido_seleccionado
				'RESPONSE.WRITE(.SOURCE)
				.Open
			end with


		


		

		set devoluciones=Server.CreateObject("ADODB.Recordset")
		
		'response.write("<br>" & sql)

		with devoluciones
			.ActiveConnection=connimprenta
			.Source="SELECT ID, ID_PEDIDO, ID_DEVOLUCION, IMPORTE FROM DEVOLUCIONES_PEDIDOS WHERE ID_PEDIDO=" & pedido_seleccionado
			'RESPONSE.WRITE(.SOURCE)
			.Open
		end with


		set saldos=Server.CreateObject("ADODB.Recordset")
		
		'response.write("<br>" & sql)

		with saldos
			.ActiveConnection=connimprenta
			.Source="SELECT ID, ID_PEDIDO, ID_SALDO, IMPORTE, CARGO_ABONO FROM SALDOS_PEDIDOS WHERE ID_PEDIDO=" & pedido_seleccionado
			.Source= .Source & " ORDER BY CARGO_ABONO DESC, ID"
			'RESPONSE.WRITE(.SOURCE)
			.Open
		end with


iva_21=0
%>
<html>
<head>
<title><%=pedido_detalles_gag_title%></title>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />

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


<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

</head>
<body onload="">


<div>
	<b>
		<%=pedido_detalles_gag_pedido_numero%> <%=pedido_seleccionado%>
		<%if not articulos.eof then%>
			&nbsp;&nbsp;&nbsp;&nbsp;Cliente: <%=articulos("nombre_cliente")%> (<%=articulos("cod_cliente")%>)
		<%end if%>
	</b>
</div>
<br />&nbsp;
<div>	
	<table class="table">
		<thead>
			<tr>
				<th class="col-xs-1" title="<%=pedido_detalles_gag_cabecera_columna_sap_alter%>"><%=pedido_detalles_gag_cabecera_columna_sap%></th>
				<th class="col-xs-3"><%=pedido_detalles_gag_cabecera_columna_articulo%></th>
				<th class="col-xs-1"><%=pedido_detalles_gag_cabecera_columna_cantidad%></th>
				<th class="col-xs-2"><%=pedido_detalles_gag_cabecera_columna_precio%></th>
				<th class="col-xs-2"><%=pedido_detalles_gag_cabecera_columna_total%></th>
				<th class="col-xs-2"><%=pedido_detalles_gag_cabecera_columna_estado%></th>
				<th class="col-xs-1" title="<%=pedido_detalles_gag_cabecera_columna_envio_programado_alter%>"><%=pedido_detalles_gag_cabecera_columna_envio_programado%></th>
			</tr>
		</thead>
		<tbody>
			<%if articulos.eof then%>
				<tr> 
					<td align="center" colspan="7"><h4><%=pedido_detalles_gag_no_hay_articulos%></h4><br></td>
				</tr>
			<%end if%>
			
			
			<%
				total_pedido=0
				descuento_total=0
				descuento_total_saldos=0
				descuento_total_devoluciones=0
				pedido_automatico=""
			%>
			
			<%while not articulos.eof%>
				<%
				pais_pedido= "" & articulos("pais")
				mostrar_totales="si"
				%>
			<tr valign="top">
				<td style="text-align:center">
					<a href="../Imagenes_Articulos/<%=articulos("articulo")%>.jpg" target="_blank">
						<%=articulos("CODIGO_SAP")%>
					</a>
				
				</td>
				<td style="text-align:left">
					<%=articulos("DESCRIPCION")%>
					<%if articulos("fichero_personalizacion")<>"" then
						cadena_enlace="pedidos/" & year(articulos("FECHA")) & "/" & articulos("CODCLI") & "__" & pedido_seleccionado
						cadena_enlace=cadena_enlace & "/" & articulos("fichero_personalizacion")
					%>
						<a href="<%=cadena_enlace%>" target="_blank"><i class="glyphicon glyphicon-paperclip" style="color:#ff0000" title="fichero adjunto"></i></a>
				
					<%end if%>
					
					<%if articulos("plantilla_personalizacion")<>"" then
						'para los kits parcelshop pueden venir personalizados o no segun el check
						if instr("-3765-3766-3767-3768-3769-3770-3771-3772-3773-3774-3775-3776-3777-3778-3779-3780-3781-3782-3783-3784-3785-3786-3787-3788-", _
														"-" & articulos("articulo") & "-")>0 then
								
							dim fs
							ruta_fichero_json=Request.ServerVariables("PATH_TRANSLATED")
							posicion=InStrRev(ruta_fichero_json,"\")
							ruta_fichero_json=left(ruta_fichero_json,posicion)
							ruta_fichero_json = ruta_fichero_json & "pedidos\" & year(articulos("fecha")) & "\" & articulos("id_cliente") & "__" & pedido_seleccionado & "\json_" & articulos("articulo") & ".json"
							'response.write("<br>fichero: " &ruta_fichero_json)
							set fs=Server.CreateObject("Scripting.FileSystemObject")
							'response.write("<br>existe el fichero: " & fs.FileExists(ruta_fichero_json))
							if fs.FileExists(ruta_fichero_json) then%>
								<i class="glyphicon glyphicon-list-alt" style="color:#00CC00;cursor:pointer" title="<%=pedido_detalles_gag_plantilla_asociada%>"
									onclick="parent.mostrar_capas_new('capa_informacion', '<%=articulos("plantilla_personalizacion")%>','<%=articulos("id_cliente")%>', '<%=year(articulos("fecha"))%>', '<%=pedido_seleccionado%>', '<%=articulos("articulo")%>', '<%=articulos("cantidad")%>')">
								</i>
							<%end if%>
						  <%else%>
						  	<i class="glyphicon glyphicon-list-alt" style="color:#00CC00;cursor:pointer" title="<%=pedido_detalles_gag_plantilla_asociada%>"
									onclick="parent.mostrar_capas_new('capa_informacion', '<%=articulos("plantilla_personalizacion")%>','<%=articulos("id_cliente")%>', '<%=year(articulos("fecha"))%>', '<%=pedido_seleccionado%>', '<%=articulos("articulo")%>', '<%=articulos("cantidad")%>')">
								</i>
						<%end if%>	
					<%end if%>
				</td>
				<td style="text-align:right"><%=articulos("cantidad")%>&nbsp;</td>
				<td style="text-align:right"><%=articulos("precio_unidad")%> €/u&nbsp;</td>
				<td style="text-align:right">
					<%
					IF articulos("estado")<>"ANULADO" THEN
						total_pedido=total_pedido + articulos("total")
					END IF
					%>
					<%=FORMATNUMBER(articulos("total"),2,-1,0,-1)%>
					 €&nbsp;
				</td>
				
				<td ><%=articulos("estado")%></td>
				<td ><%=articulos("envio_programado")%></td>
			</tr>
			<%		
				pedido_automatico=articulos("pedido_automatico")
				descuento_total="" & articulos("descuento_total")
				if descuento_total="" then
					descuento_total=0
				end if
				gastos_envio=articulos("GASTOS_ENVIO")
				
				articulos.movenext
			Wend
			
			%>
			
			<%if mostrar_totales="si" then%>
				<tr valign="top">
					<th style="text-align:right" colspan="4"><font color="#000000"><%=pedido_detalles_gag_literal_total%></font></th>
					<th style="text-align:right"><font color="#000000"><%=FORMATNUMBER(total_pedido,2,-1,0,-1)%> €</font></th>
					<td ></td>
					<td ></td>
				</tr>
				
				
				
				<%if not devoluciones.eof then
					while not devoluciones.eof%>
						<tr valign="top">
							<th style="text-align:right" colspan="4"><font color="#880000">Devoluci&oacute;n <%=devoluciones("ID_DEVOLUCION")%></font></th>
							<th style="text-align:right"><font color="#880000">-<%=FORMATNUMBER(devoluciones("IMPORTE"),2,-1,0,-1)%> €</font></th>
							<td ></td>
							<td ></td>
						</tr>
						<%
						descuento_total_devoluciones=descuento_total_devoluciones + devoluciones("IMPORTE")
						devoluciones.movenext
					wend%>
					<tr valign="top">
						<th style="text-align:right" colspan="4">Total Descontando Devoluciones</th>
						<th style="text-align:right"><%=FORMATNUMBER((total_pedido - descuento_total_devoluciones),2,-1,0,-1)%> €</th>
						<td ></td>
						<td ></td>
					</tr>
				<%end if%>
				
				<%if pedido_automatico="PRIMER_PEDIDO_REDYSER" then%>
					<tr valign="top">
						<th style="text-align:right" colspan="4"><font color="#880000">Descuento Primer Pedido 50% (Max. 800€)</font></th>
						<th style="text-align:right"><font color="#880000"><%=FORMATNUMBER(descuento_total,2,-1,0,-1)%> €</font></th>
						<td ></td>
						<td ></td>
					</tr>
					<tr valign="top">
						<th style="text-align:right" colspan="4">Total Precio Final</th>
						<th style="text-align:right"><%=FORMATNUMBER((total_pedido - descuento_total_devoluciones - descuento_total),2,-1,0,-1)%> €</th>
						<td ></td>
						<td ></td>
					</tr>
				<%end if%>	
				<%if pedido_automatico="PRIMER_PEDIDO_GENERAL" then%>
					<tr valign="top">
						<th style="text-align:right" colspan="4"><font color="#880000">Descuento Primer Pedido 15%</font></th>
						<th style="text-align:right"><font color="#880000"><%=FORMATNUMBER(descuento_total,2,-1,0,-1)%> €</font></th>
						<td ></td>
						<td ></td>
					</tr>
					<tr valign="top">
						<th style="text-align:right" colspan="4">Total Precio Final</th>
						<th style="text-align:right"><%=FORMATNUMBER((total_pedido - descuento_total_devoluciones - descuento_total),2,-1,0,-1)%> €</th>
						<td ></td>
						<td ></td>
					</tr>
				<%end if%>	
				<%if gastos_envio<>"" AND gastos_envio<>"0" then%>
					<tr valign="top">
						<th style="text-align:right" colspan="4"><font color="#880000">Gastos de Env&iacute;o</font></th>
						<th style="text-align:right"><font color="#880000"><%=FORMATNUMBER(gastos_envio,2,-1,0,-1)%> €</font></th>
						<td ></td>
						<td ></td>
					</tr>
				 <%else
				 	gastos_envio=0
					%>
				<%end if%>										
				
				<%'no uso session("usuario_pais"), porque por ejemplo, si entra la oficina administradora de españa, carga 
					'el iva para un pedido de portugal
				if pais_pedido<>"PORTUGAL" then%>
					<tr valign="top">
						<th style="text-align:right" colspan="4"><font  color="#000000"><%=pedido_detalles_gag_literal_iva_21%> (<%=((total_pedido - descuento_total_devoluciones - descuento_total + gastos_envio) * 0.21)%>)</font></th>
						<th style="text-align:right"><font  color="#000000">
						
							<%
							'response.write("<br>total_pedido: " & total_pedido)
							'response.write("<br>descuento_total: " & descuento_total)
							resultado_iva=((total_pedido - descuento_total_devoluciones - descuento_total + gastos_envio) * 0.21)
							iva_21= round(resultado_iva,2)
							response.write(FORMATNUMBER(iva_21,2,-1,0,-1))
							%> 
							€
							</font>
						</th>
						<td></td>
						<td ></td>
						
					</tr>
				<%end if%>
				
				<tr valign="top">
					<th style="text-align:right" colspan="4"><font  color="#000000"><%=pedido_detalles_gag_literal_total_importe%></font></th>
					<th style="text-align:right"><font  color="#000000">
						<%
							total_pago_iva=(total_pedido - descuento_total_devoluciones - descuento_total + gastos_envio) + iva_21
							
							response.write(FORMATNUMBER(total_pago_iva,2,-1,0,-1))
						%> 
						€
					</font></th>
					<td></td>
					<td ></td>
					
				</tr>
				<%if not saldos.eof then
					while not saldos.eof
						if UCASE(saldos("CARGO_ABONO"))="ABONO" then
							color_saldo="green"
						  else
						  	color_saldo="red"
						end if%>
						<tr valign="top">
							<th style="text-align:right" colspan="4"><font color="<%=color_saldo%>">Saldo <%=saldos("ID_SALDO")%>&nbsp;-&nbsp;<%=UCASE(saldos("CARGO_ABONO"))%></font></th>
							<%if UCASE(saldos("CARGO_ABONO"))="ABONO" then
									mostrar_signo="-"
								else
									mostrar_signo="+"
							end if%>
							<th style="text-align:right"><font color="<%=color_saldo%>"><%=(mostrar_signo & FORMATNUMBER(saldos("IMPORTE"),2,-1,0,-1))%> €</font></th>
							<td ></td>
							<td ></td>
						</tr>
						<%
						if UCASE(saldos("CARGO_ABONO"))="ABONO" then
							descuento_total_saldos=descuento_total_saldos + saldos("IMPORTE")
						  else
							descuento_total_saldos=descuento_total_saldos - saldos("IMPORTE")
						end if
						saldos.movenext
					wend%>
					<tr valign="top">
						<th style="text-align:right" colspan="4">Total Aplicado Saldos</th>
						<th style="text-align:right"><%=FORMATNUMBER((total_pago_iva - descuento_total_saldos),2,-1,0,-1)%> €</th>
						<td ></td>
						<td ></td>
					</tr>
				<%end if%>
				
			<%end if%>
		</tbody>	
		
	</table>
</div>
							
								
								





</body>
<%
	'articulos.close
	articulos.close
	saldos.close
	devoluciones.close
	connimprenta.close
	
	set articulos=Nothing
	set saldos=Nothing
	set devoluciones=Nothing
	set connimprenta=Nothing

%>
</html>
