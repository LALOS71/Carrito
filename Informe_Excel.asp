<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<%

'Response.ContentEncoding = Encoding.Default 


consulta_filtro="" & Request.Form("ocultosql")

agrupacion_filtro="" & Request.Form("ocultoagrupacion")
empresa_filtro= "" & Request.Form("ocultoempresa")
articulo_filtro= "" & Request.Form("ocultoarticulo")
reservas_asm_gls_filtro= "" & Request.Form("ocultoreservas_asm_gls")

fecha_inicio_filtro= "" & Request.Form("ocultofecha_inicio")
fecha_fin_filtro= "" & Request.Form("ocultofecha_fin")

diferenciar_empresas_filtro= "" & Request.Form("ocultodiferenciar_empresas")
diferenciar_sucursales_filtro= "" & Request.Form("ocultodiferenciar_sucursales")
diferenciar_articulos_filtro= "" & Request.Form("ocultodiferenciar_articulos")
diferenciar_rappel_filtro="" & Request.Form("ocultodiferenciar_rappel")
diferenciar_costes_filtro="" & Request.Form("ocultodiferenciar_costes")
diferenciar_marca_filtro= "" & Request.Form("ocultodiferenciar_marca")
diferenciar_tipo_filtro= "" & Request.Form("ocultodiferenciar_tipo")

		
		
		

'direccion_ip=Request.ServerVariables("REMOTE_ADDR") 


	set consumos=Server.CreateObject("ADODB.Recordset")
		
		'connimprenta.BeginTrans 'Comenzamos la Transaccion
				
		'porque el sql de produccion es un sql expres que debe tener el formato de
		' de fecha con mes-dia-año
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
				
		with consumos
			.ActiveConnection=connimprenta
			.Source=consulta_filtro
			'response.write("<br>" & .source)			
			.Open
			
		end with
		



Response.ContentType = "application/vnd.ms-excel.numberformat:#.###"
Response.AddHeader "Content-Disposition", "attachment;filename=Listado_Consumos.xls"
		

%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">

<title>...:: Informe Imprenta ::...</title>


<style>

.cajatexto {
	BORDER-STYLE:groove;
	FONT-SIZE: 9px; 
	FONT-WEIGHT: bold;
	COLOR: #003366; 
	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; 
	TEXT-TRANSFORM:capitalize;
	BACKGROUND-COLOR: #FFFFFF;
}

.cajatexto_lectura {
	BORDER-STYLE:groove;
	FONT-SIZE: 9px; 
	FONT-WEIGHT: bold;
	COLOR: #003366; 
	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; 
	BACKGROUND-COLOR: lightcyan;
}

.opciones_menu{margin-left: 5px}
.opciones_menu {margin-right: 6px;text-align: center;font-family:Calibri;font-weight:bold;font-size:14px}
.opciones_menu a{display:block;width: 10em;padding: 5px 0;background: #E7F1F8;text-decoration:none;color: #666}
.opciones_menu a:hover{background: #FFA826;color: #FFF}
#opcion_menu_activo a,#opcion_menu_activo a:hover{background: #FFF;color: #003}

.titulo_opcion{background: #FFFFFF;float:left;text-align:right;;padding-top:3px;padding-bottom:5px;
				font-family:Verdana, Arial, Helvetica, sans-serif;font-size:9px;font-weight:bold;color:#555555}	

.cabeceras_grises{background: #666666;text-align:center;
				font-family:Calibri;font-weight:bold;font-size:15px;color:#eeeeee;}	
.caja_opcion_2{background: #bbbbbb;}	
.titulo_opcion_2{background: #888888;font-family:Calibri;font-weight:bold;font-size:15px;color:#000000}					

body {
	margin-top: 4px;
}





.apartado{clear:both;width:150px;background: #888888;padding:2px 0;text-align:right;
				font-family:Calibri;font-weight:bold;font-size:25px;color:#eeeeee}
				
.texto_apartado{text-align:center;font-family:'Verdana, Arial, Helvetica, sans-serif';font-weight:bold;
										font-size:10px;color:#FFFFFF}
										
.contenedor_con_borde{ border:1 solid #888888}


.boton {
	BORDER-RIGHT: #072a66 1px solid; PADDING-RIGHT: 3px; BORDER-TOP: #072a66 1px solid; 
	PADDING-LEFT: 3px; BACKGROUND: #F0F5FA; PADDING-BOTTOM: 1px; BORDER-LEFT: #072a66 1px solid; PADDING-TOP: 1px; 
	BORDER-BOTTOM: #072a66 1px solid;
	font-family:Verdana, Arial, Helvetica, sans-serif;font-size:9px;font-weight:bold;color:#555555;
 
	}
.boton { cursor:hand; cursor:pointer; }
</style>
</head>

<body bgcolor="#FFFFFF">



<div align="center">	
<form action="Consultas.asp" method="post" name="frmbusqueda" id="frmbusqueda">
	
<table width="90%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="10"></td>
	</tr>
</table>
<!-- INICIO APARTADO DE DATOS BASICOS -->
<table width="882"  border="0" cellspacing="0" cellpadding="0" bordercolor="#9CB6D1">
  <tr>
	<td>
		<div align="left">
			<div id="apartado_datos_basicos" class="apartado" style="width:375px">
			  <table width="100%"  border="0" cellpadding="0" cellspacing="0">
				<tr>
				  <td width="87%" height="16" class="texto_apartado" style="text-align:left ">&nbsp;Filtros de Consulta</td>
				</tr>
			  </table>
			</div>
		</div>
		
	</td>
  </tr>
  <tr>
	<td align="center" class="contenedor_con_borde">
		<!-- linea nombre del viajero y nº expediente-->
		<table width="90%"  border="0" cellspacing="0" cellpadding="0">
			<tr><td height="5"></td></tr>
		</table>
		<table width="97%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="titulo_opcion" style="text-align:left">
				<%if reservas_asm_gls_filtro="SI" then%>
						INFORME DE RESERVAS (PEDIDOS AUN NO ENVIADOS) CON LAS SIGUIENTES CARACTERISTICAS:
					<%ELSE%>
						INFORME DE CONSUMOS CON LAS SIGUIENTES CARACTERISTICAS:
				<%END IF%>
				<br>
				Agrupado Por:&nbsp; 
				<%if agrupacion_filtro="empresa" then%>
					EMPRESAS.
				<%end if%>
				<%if agrupacion_filtro="articulo" then%>
					ARTICULOS.
				<%end if%>
				
				<%if agrupacion_filtro="empresa" then%>
					<br>
					De La Empresa:&nbsp; 
					<%
					if empresa_filtro="" then
						cadena="<< SIN SELECCIONAR >>"
					  else
						cadena=empresa_filtro
					end if
					%>
					<%=cadena%>
				<%end if%>
				
				<%if agrupacion_filtro="articulo" then%>
					<br>
					Del Articulo:&nbsp; 
					<%
					if articulo_filtro="" then
						cadena="<< SIN SELECCIONAR >>"
					  else
						cadena=articulo_filtro
					end if
					%>
					<%=cadena%>
				<%end if%>
				
				
				<br>
				Desde la La Fecha:&nbsp; 
				<%
				if fecha_inicio_filtro="" then
					cadena="<< SIN DETERMINAR >>"
				  else
					cadena=fecha_inicio_filtro
				end if
				%>
				<%=cadena%>
				<br>
				Hasta la Fecha:&nbsp;  
				<%
				if fecha_fin_filtro="" then
					cadena="<< SIN DETERMINAR >>"
				  else
					cadena=fecha_fin_filtro
				end if
				%>
				<%=cadena%>
				<br>
				
			</td>
			
		</tr>
		</TABLE>
		
		<table width="90%"  border="0" cellspacing="0" cellpadding="0">
			<tr><td height="5"></td></tr>
		</table>
		
		<!-- FIN LINEA alojamiento-->
	</td>
  </tr>
  <!-- FIN APARTADO DE DATOS BASICOS -->
  
	<tr><td height="10"></td></tr>
	<!-- APARTADO DE IMSERSO -->
	<tr>
	<td>
		<div align="left">
			<div id="apartado_datos_imserso" class="apartado" style="width:250px">
			  <table width="100%"  border="0" cellpadding="0" cellspacing="0">
				<tr>
				  <td width="87%" height="16" class="texto_apartado" style="text-align:left ">&nbsp;Resultados</td>
				</tr>
			  </table>
			</div>
		</div>
		
	</td>
  </tr>
  <tr>
	<td align="center" class="contenedor_con_borde">
		<!-- linea nombre del viajero y nº expediente-->
		<table width="90%"  border="0" cellspacing="0" cellpadding="0">
			<tr><td height="5"></td></tr>
		</table>
		<!-- FIN LINEA fase-->
		
		<table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table">
			<%if agrupacion_filtro="empresa" then%>
				<tr style="background-color:#FCFCFC" valign="top">
					<th class="menuhdr" style="text-align:center">Empresa</th>
					<%if diferenciar_sucursales_filtro="SI" then%>
						<th class="menuhdr">Codigo</th>
						<th class="menuhdr">Cliente</th>
					<%end if%>
					<%if diferenciar_articulos_filtro="SI" then%>
						<th class="menuhdr">Cod. Sap</th>
						<th class="menuhdr">Artículo</th>
						<th class="menuhdr">Unidades Pedido</th>
						<%if diferenciar_costes_filtro="SI" then%>
							<th class="menuhdr">Coste</th>
							<th class="menuhdr">Proveedor</th>
							<th class="menuhdr">Ref. Prov.</th>
						<%end if%>
					<%end if%>
					<%if diferenciar_marca_filtro="SI" then%>
						<th class="menuhdr">Marca</th>
					<%end if%>
					<%if diferenciar_tipo_filtro="SI" then%>
						<th class="menuhdr">Tipo</th>
					<%end if%>
	
					<th class="menuhdr" style="text-align:center">Cantidad Total</th>
					<th class="menuhdr" style="text-align:center">Total Importe</th>
					<th class="menuhdr" style="text-align:center">Total Coste</th>
					<%'if diferenciar_articulos_seleccionada="SI" then%>
						<th class="menuhdr" style="text-align:center">Unidades Devueltas</th>
						<th class="menuhdr" style="text-align:center">Total Importe Dev.</th>
						<th class="menuhdr" style="text-align:center">Cantidad Neta</th>
						<th class="menuhdr" style="text-align:center">Total Importe Neto</th>
					<%'end if%>
					<%if diferenciar_rappel_filtro="SI" then%>
						<th class="menuhdr">Rappel</th>
						<th class="menuhdr">Valor Rappel</th>
						<th class="menuhdr" style="text-align:center">C&aacute;lculo Rappel</th>
					<%end if%>
				</tr>
				<%vueltas=1
				  if not consumos.eof then %>
					<%while not consumos.eof%>
					
						<tr  valign="top" id="fila_articulo_<%=i%>">
							<%
							vueltas=vueltas + 1
							if vueltas=200 then
								Response.Flush
								vueltas=1
							end if
							%>
							<td  class="ac item_row" width="82"><%=consumos("NOMBRE_EMPRESA")%></td>
							<%if diferenciar_sucursales_filtro="SI" then%>

								<td  class="ac item_row" style="text-align:left; width:30px"><%=consumos("CodCliente")%></td>
								<td  class="ac item_row" style="text-align:left" width="76">
									<%=consumos("NOMBRE")%>
									<%if consumos("CODIGO_EXTERNO")<>"" then%>
										&nbsp(<%=consumos("CODIGO_EXTERNO")%>)
									<%end if%>
								</td>
							<%end if%>
							<%if diferenciar_articulos_filtro="SI" then%>
								<td  class="ac item_row" width="101"><%=consumos("CODIGO_SAP")%></td>
								<td   width="306" class="al item_row" style="text-align:right;"><%=consumos("DESCRIPCION")%>&nbsp;</td>
								<td  class="ac item_row" width="101"><%=consumos("UNIDADES_DE_PEDIDO")%></td>
								
								<%if diferenciar_costes_filtro="SI" then%>
									<td  class="ac item_row" width="101"><%=consumos("PRECIO_COSTE")%></td>
									<td  class="ac item_row" width="101"><%=consumos("PROVEEDOR")%></td>
									<td  class="ac item_row" width="101"><%=consumos("REFERENCIA_DEL_PROVEEDOR")%></td>
								<%end if%>
								
							<%end if%>
							<%if diferenciar_marca_filtro="SI" then%>
								<td  class="ac item_row" width="101"><%=consumos("MARCA")%></td>
							<%end if%>
							<%if diferenciar_tipo_filtro="SI" then%>
								<td  class="ac item_row" width="101"><%=consumos("TIPO")%></td>
							<%end if%>
							<td  class="ar item_row" width="101">
								<%
								if consumos("CANTIDAD_TOTAL")<>"" then
										Response.Write(FORMATNUMBER(consumos("CANTIDAD_TOTAL"),0,-1,0,-1))
									else
										Response.Write("0")
								end if
								%>
							</td>
							<td  class="ar item_row" width="101">
								<%
								if consumos("TOTAL_IMPORTE")<>"" then
										Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE"),2,-1,0,-1))
									else
										Response.Write("0")
								end if
								%>
							</td>
							<td  class="ar item_row" width="101">
								<%
								if consumos("TOTAL_PRECIO_COSTE_PEDIDO")<>"" then
										Response.Write(FORMATNUMBER(consumos("TOTAL_PRECIO_COSTE_PEDIDO"),2,-1,0,-1))
									else
										Response.Write("0")
								end if
								%>
							</td>
							
							<%'if diferenciar_articulos_seleccionada="SI" then%>
									<td  class="ar item_row" width="101">
										<%
										if consumos("UNIDADES_DEVUELTAS")<>"" then
												Response.Write(FORMATNUMBER(consumos("UNIDADES_DEVUELTAS"),0,-1,0,-1))
											else
												Response.Write("0")
										end if
										%>
									</td>
									<td  class="ar item_row" width="101">
										<%
										if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
												Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE_DEVOLUCIONES"),2,-1,0,-1))
											else
												Response.Write("")
										end if
										%>
									</td>
									<td  class="ar item_row" width="101">
										<%
										if consumos("UNIDADES_DEVUELTAS")<>"" then
												Response.Write(FORMATNUMBER((consumos("CANTIDAD_TOTAL") - consumos("UNIDADES_DEVUELTAS")),0,-1,0,-1))
											else
												Response.Write(FORMATNUMBER(consumos("CANTIDAD_TOTAL"),0,-1,0,-1))
										end if
										%>
									</td>
									<td  class="ar item_row" width="101">
										<%
										if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
												Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")),2,-1,0,-1))
											else
												Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE"),2,-1,0,-1))
										end if
										%>
									</td>
							<%'end if%>
							<%if diferenciar_rappel_filtro="SI" then%>
								<td  class="ac item_row" width="101"><%=consumos("RAPPEL")%></td>
								<td  class="ac item_row" width="50"><%=consumos("VALOR_RAPPEL")%></td>
								<td  class="ar item_row" width="101">
								<%
									valor_del_rappel="" & consumos("VALOR_RAPPEL")
									'response.write("<br>diferenciar_tipo_seleccionada: " & diferenciar_tipo_seleccionada)
									'response.write("<br>total importe: " & consumos("TOTAL_IMPORTE"))
									'response.write("<br>valor_rappel: " & valor_del_rappel)
									'response.write("<br>CONSUMOS VALOR RAPPEL: " & consumos("VALOR_RAPPEL"))
									'response.write("<br>tipo_agencia: " & consumos("TIPO"))
									'response.write("<br>total importe DEVOLUCIONES: " & consumos("TOTAL_IMPORTE_DEVOLUCIONES"))
									'response.write("<br>-----<BR>")
									
									if diferenciar_tipo_filtro="SI" then
										if consumos("TOTAL_IMPORTE")<>"" and valor_del_rappel<>"" and (consumos("TIPO")="AGENCIA" OR consumos("TIPO")="ARRASTRES") then
												'Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
												if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
														Response.Write(FORMATNUMBER(((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")) * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1))
													else
														Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1))
												end if
											else
												Response.Write("")
										end if
									  else
										if consumos("TOTAL_IMPORTE")<>"" and valor_del_rappel<>"" then
												'Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
												if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
														Response.Write(FORMATNUMBER(((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")) * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1))
													else
														Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1))
												end if
											else
												Response.Write("")
										end if
									end if
									%>
								</td>
							<%end if%>
						</tr>
						
						<%consumos.movenext%>
					<%wend%>
				 <%else%>
						<tr> 
							<td align="center" colspan="5"><b><FONT class="fontbold">NO Hay Consumos Que Cumplan El Critero de Búsqueda...</font></b><br>
							</td>
						</tr>
				 <%end if%>
			<%end if%>
			
			<%if agrupacion_filtro="articulo" then%>
				<tr style="background-color:#FCFCFC" valign="top">
					<th class="menuhdr" style="text-align:center">Cod. Sap</th>
					<th class="menuhdr" style="text-align:center">Descripci&oacute;n</th>
					<th class="menuhdr" style="text-align:center">Unidades Pedido</th>
					<%if diferenciar_costes_filtro="SI" then%>
						<th class="menuhdr">Coste</th>
						<th class="menuhdr">Proveedor</th>
						<th class="menuhdr">Ref. Prov</th>
					<%end if%>
					<%if diferenciar_empresas_filtro="SI" then%>
						<th class="menuhdr">Empresa</th>
					<%end if%>
					
					<%if diferenciar_sucursales_filtro="SI" then%>
						<th class="menuhdr">Codigo</th>
						<th class="menuhdr">Cliente</th>
					<%end if%>
					<%if diferenciar_marca_filtro="SI" then%>
						<th class="menuhdr">Marca</th>
					<%end if%>
					<%if diferenciar_tipo_filtro="SI" then%>
						<th class="menuhdr">Tipo</th>
					<%end if%>
	
					<th class="menuhdr" style="text-align:center">Cantidad Total</th>
					<th class="menuhdr" style="text-align:center">Total Importe</th>
					<th class="menuhdr" style="text-align:center">Total Coste</th>
					<th class="menuhdr" style="text-align:center">Unidades Devueltas</th>
					<th class="menuhdr" style="text-align:center">Total Importe Dev.</th>
					<th class="menuhdr" style="text-align:center">Cantidad Neta</th>
					<th class="menuhdr" style="text-align:center">Total Importe Neto</th>
					<%if diferenciar_rappel_filtro="SI" then%>
						<th class="menuhdr">Rappel</th>
						<th class="menuhdr">Valor Rappel</th>
						<th class="menuhdr" style="text-align:center">C&aacute;lculo Rappel</th>
					<%end if%>
				</TR>
				
				<%vueltas=1
				  if not consumos.eof then %>
					<%while not consumos.eof%>
					
						<tr  valign="top" id="fila_articulo_<%=i%>">
							<%
							vueltas=vueltas + 1
							if vueltas=200 then
								Response.Flush
								vueltas=1
							end if
							%>
							<td  class="al item_row" width="40"><%=consumos("CODIGO_SAP")%></td>
							<td  class="al item_row" width="124"><%=consumos("ARTICULO")%></td>
							<td  class="ac item_row" width="101"><%=consumos("UNIDADES_DE_PEDIDO")%></td>
							<%if diferenciar_costes_filtro="SI" then%>
								<td  class="ac item_row" width="101"><%=consumos("PRECIO_COSTE")%></td>
								<td  class="ac item_row" width="101"><%=consumos("PROVEEDOR")%></td>
								<td  class="ac item_row" width="101"><%=consumos("REFERENCIA_DEL_PROVEEDOR")%></td>
							<%end if%>
							<%if diferenciar_empresas_filtro="SI" then%>
								<td  class="ac item_row" width="82"><%=consumos("NOMBRE_EMPRESA")%></td>
							<%end if%>
							
							<%if diferenciar_sucursales_filtro="SI" then%>
								<td  class="ac item_row" style="text-align:left; width:30px"><%=consumos("CodCliente")%></td>
								<td  class="ac item_row" style="text-align:left" width="76">
									<%=consumos("NOMBRE")%>
									<%if consumos("CODIGO_EXTERNO")<>"" then%>
										&nbsp(<%=consumos("CODIGO_EXTERNO")%>)
									<%end if%>
								</td>
							<%end if%>
							<%if diferenciar_marca_filtro="SI" then%>
								<td  class="ac item_row" width="101"><%=consumos("MARCA")%></td>
							<%end if%>
							<%if diferenciar_tipo_filtro="SI" then%>
								<td  class="ac item_row" width="101"><%=consumos("TIPO")%></td>
							<%end if%>
							<td  class="ar item_row" width="101">
								<%
								if consumos("CANTIDAD_TOTAL")<>"" then
										Response.Write(FORMATNUMBER(consumos("CANTIDAD_TOTAL"),0,-1,0,-1))
									else
										Response.Write("0")
								end if
								%>
							</td>
							<td  class="ar item_row" width="101">
								<%
								if consumos("TOTAL_IMPORTE")<>"" then
										Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE"),2,-1,0,-1))
									else
										Response.Write("0")
								end if
								%>
							</td>
							<td  class="ar item_row" width="101">
								<%
								if consumos("TOTAL_PRECIO_COSTE_PEDIDO")<>"" then
										Response.Write(FORMATNUMBER(consumos("TOTAL_PRECIO_COSTE_PEDIDO"),2,-1,0,-1))
									else
										Response.Write("0")
								end if
								%>
							</td>
							<td  class="ar item_row" width="101">
								<%
								if consumos("UNIDADES_DEVUELTAS")<>"" then
										Response.Write(FORMATNUMBER(consumos("UNIDADES_DEVUELTAS"),0,-1,0,-1))
									else
										Response.Write("0")
								end if
								%>
							</td>
							<td  class="ar item_row" width="101">
								<%
								if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
										Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE_DEVOLUCIONES"),2,-1,0,-1))
									else
										Response.Write("0")
								end if
								%>
							</td>
							<td  class="ar item_row" width="101">
								<%
								if consumos("UNIDADES_DEVUELTAS")<>"" then
										Response.Write(FORMATNUMBER((consumos("CANTIDAD_TOTAL") - consumos("UNIDADES_DEVUELTAS")),0,-1,0,-1))
									else
										Response.Write(FORMATNUMBER(consumos("CANTIDAD_TOTAL"),0,-1,0,-1))
								end if
								%>
							</td>
							<td  class="ar item_row" width="101">
								<%
								if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
										Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")),2,-1,0,-1))
									else
										Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE"),2,-1,0,-1))
								end if
								%>
							</td>
							<%if diferenciar_rappel_filtro="SI" then%>
								<td  class="ac item_row" width="101"><%=consumos("RAPPEL")%></td>
								<td  class="ac item_row" width="42"><%=consumos("VALOR_RAPPEL")%></td>
								<td  class="ar item_row" width="101">
								<%
									valor_del_rappel="" & consumos("VALOR_RAPPEL")
									if diferenciar_tipo_filtro="SI" then
										if consumos("TOTAL_IMPORTE")<>"" and valor_del_rappel<>"" and (consumos("TIPO")="AGENCIA" OR consumos("TIPO")="ARRASTRES") then
												'Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
												if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
														Response.Write(FORMATNUMBER(((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")) * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1))
													else
														Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1))
												end if
											else
												Response.Write("")
										end if
									  else
										if consumos("TOTAL_IMPORTE")<>"" and valor_del_rappel<>"" then
												'Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
												if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
														Response.Write(FORMATNUMBER(((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")) * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1))
													else
														Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1))
												end if
											else
												Response.Write("")
										end if
									end if
								%>
								</td>
							<%end if%>
							
						</tr>
						
						<%consumos.movenext%>
					<%wend%>

				<%else%>
					<tr> 
						<td align="center" colspan="5"><b><FONT class="fontbold">NO Hay Consumos Que Cumplan El Critero de Búsqueda...</font></b><br>
						</td>
					</tr>
				<%end if%>				
			<%end if%>
			
		</table>
		
		
		
		
		<table width="90%"  border="0" cellspacing="0" cellpadding="0">
			<tr><td height="5"></td></tr>
		</table>
		<!-- INICIO LINEA dnis-->
		<!-- FIN LINEA dnis-->
	</td>
  </tr>
  <!-- FIN APARTADO DATOS IMSERSO-->
  
 
 
 
 <tr><td height="10"></td></tr>
	
  
  
  
  
  

</table>
<!-- FIN FICHA -->
<table width="90%"  border="0" cellspacing="0" cellpadding="0">
  <tr><td height="5"></td></tr>
</table>
<!-- linea botones -->	
<table width="882"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="right">

			


		</td>
	</tr>
</table>
 <!-- FIN linea botones -->	


</form>


</div>




</body>
<% 
	

%>
</html>
