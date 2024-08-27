<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->
<%
	articulo_buscado=Request.QueryString("articulo")
	empresa_buscada=Request.QueryString("empresa")
	ver_cadena=Request.QueryString("p_vercadena")
	
	

	set articulos=Server.CreateObject("ADODB.Recordset")
	set tallajes=Server.CreateObject("ADODB.Recordset")
	
	

	sql="SELECT ARTICULOS.ID, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, ARTICULOS.CODIGO_SAP, ARTICULOS.CODIGO_EXTERNO"
	sql=sql & ", CASE WHEN ARTICULOS_IDIOMAS.DESCRIPCION IS NULL THEN ARTICULOS.DESCRIPCION ELSE" 
	sql=sql & " ARTICULOS_IDIOMAS.DESCRIPCION END AS DESCRIPCION_IDIOMA"
	sql=sql & ", ARTICULOS.TAMANNO, ARTICULOS.TAMANNO_ABIERTO, ARTICULOS.TAMANNO_CERRADO"
	sql=sql & ", ARTICULOS.PAPEL, ARTICULOS.TINTAS, ARTICULOS.ACABADO, ARTICULOS.FECHA, ARTICULOS.COMPROMISO_COMPRA"
	sql=sql & ", ARTICULOS.MOSTRAR, ARTICULOS.MULTIARTICULO, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS_EMPRESAS.FAMILIA"
	sql=sql & ", FAMILIAS.DESCRIPCION AS nombre_familia, ARTICULOS.REQUIERE_AUTORIZACION"
	sql=sql & ", ARTICULOS.PACKING, ARTICULOS_PERSONALIZADOS.PLANTILLA_PERSONALIZACION"
	sql=sql & ", ARTICULOS_IDIOMAS.DESCRIPCION,ARTICULOS.MATERIAL"
	sql=sql & " FROM ARTICULOS INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO AND ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & empresa_buscada
	sql=sql & " INNER JOIN" 
	sql=sql & " (SELECT FAMILIAS.ID, FAMILIAS.CODIGO_EMPRESA,"
	sql=sql & "        CASE WHEN FAMILIAS_IDIOMAS.DESCRIPCION IS NULL" 
	sql=sql & "           THEN FAMILIAS.DESCRIPCION ELSE FAMILIAS_IDIOMAS.DESCRIPCION END AS DESCRIPCION"
	sql=sql & "        FROM FAMILIAS LEFT JOIN FAMILIAS_IDIOMAS"
	sql=sql & "        ON (FAMILIAS.ID=FAMILIAS_IDIOMAS.ID_FAMILIA AND FAMILIAS_IDIOMAS.IDIOMA = '" & UCASE(SESSION("idioma")) &"')) AS FAMILIAS"
	
	sql=sql & " ON ARTICULOS_EMPRESAS.FAMILIA = FAMILIAS.ID "
	'sql=sql & " INNER JOIN CANTIDADES_PRECIOS ON ARTICULOS.ID = CANTIDADES_PRECIOS.CODIGO_ARTICULO "
	sql=sql & " LEFT JOIN ARTICULOS_PERSONALIZADOS ON ARTICULOS.ID=ARTICULOS_PERSONALIZADOS.ID_ARTICULO"
	sql=sql & " LEFT JOIN ARTICULOS_IDIOMAS"
	sql=sql & " ON (ARTICULOS.ID=ARTICULOS_IDIOMAS.ID_ARTICULO AND ARTICULOS_IDIOMAS.IDIOMA='" & UCASE(SESSION("idioma")) &"')"
				
	

	'sql=sql & " GROUP BY ARTICULOS.ID, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, ARTICULOS.CODIGO_SAP, ARTICULOS.CODIGO_EXTERNO,"
	'sql=sql & " ARTICULOS.DESCRIPCION, ARTICULOS.TAMANNO, ARTICULOS.TAMANNO_ABIERTO, ARTICULOS.TAMANNO_CERRADO,"
	'sql=sql & " ARTICULOS.PAPEL, ARTICULOS.TINTAS, ARTICULOS.ACABADO, ARTICULOS.FECHA, ARTICULOS.COMPROMISO_COMPRA,"
	'sql=sql & " ARTICULOS.MOSTRAR, ARTICULOS.MULTIARTICULO, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS_EMPRESAS.FAMILIA,"
	'sql=sql & " FAMILIAS.DESCRIPCION, ARTICULOS_IDIOMAS.DESCRIPCION"
	'sql=sql & " ) AS ART"

	sql=sql & " WHERE ARTICULOS.ID=" & articulo_buscado
	

		
		if ver_cadena="SI" then
			response.write("<br><br>Consulta articulos: " & sql)
		end if
		with articulos
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
		
		sql="SELECT * FROM"
		sql=sql & " (SELECT DESCRIPCION_TALLA, (SELECT CODIGO_SAP FROM ARTICULOS WHERE ID=ID_ARTICULO) as REFERENCIA,"
		sql=sql & " (SELECT MOSTRAR FROM ARTICULOS WHERE ID=ID_ARTICULO) as MOSTRAR,"
		sql=sql & " ORDEN, DESCRIPCION_GRUPO"
		sql=sql & " FROM TALLAJES"
		sql=sql & " WHERE ID_GRUPO=(SELECT ID_GRUPO FROM TALLAJES WHERE ID_ARTICULO=" & articulo_buscado & ")) AS A"
		sql=sql & " WHERE A.MOSTRAR='SI'"
		sql=sql & " ORDER BY A.ORDEN"

		if ver_cadena="SI" then
			response.write("<br><br>Tallajes: " & sql)
		end if

		with tallajes
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
		
%>

<html>
<head>
<!--<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
-->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title></title>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>

<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />

<!--PARA LA ANIMACION DE METER LA IMAGEN DEL ARTICULO EN EL CARRITO DE LA COMPRA-->		
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<!--PARA PONERLE ZOOM A LAS IMAGENES AL PASAR POR ENCIMA DE ELLAS
http://www.elevateweb.co.uk/image-zoom/examples-->
<script type="text/javascript" src="../plugins/elevatezoom/jquery.elevatezoom.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>


</head>
<body>


<div class="panel panel-primary item col_articulo_1 item_<%=articulos("ID")%>">
	<div class="panel-heading" style="padding-bottom:2px;padding-top:2px">
		<div class="panel-title"><H5>
			<%
			IF not tallajes.eof then
				RESPONSE.WRITE(tallajes("DESCRIPCION_GRUPO"))
			  else
			  	RESPONSE.WRITE(articulos("DESCRIPCION_IDIOMA"))
			end if
			%>
			</H5></div>
	</div>
	<div class="panel-body" style="padding-left:1px; padding-left:1px; padding-top:0px;">
		<div class="row" style="padding-top:5px"></div>
		<!--informacion general del articulo-->
		<div class="row">
			<!--imagen del articulo-->
			<div class="col-sm-5 col-md-5 col-lg-5 panel_sinmargen_lados">
					<span class="align-middle">
						<a href="../Imagenes_Articulos/<%=articulos("id")%>.jpg" target="_blank">
							<img class="img-responsive" src="../Imagenes_Articulos/<%=articulos("id")%>.jpg" border="0" id="img_<%=articulos("id")%>" data-zoom-image="../Imagenes_Articulos/<%=articulos("id")%>.jpg"/>
						</a>
						<script language="javascript">
							$("#img_<%=articulos("id")%>").elevateZoom({scrollZoom : true, easing : true});
						</script>
					</span>
			</div>
			<!-- fin imagen del articulo-->
			
			<div class="col-sm-7 col-md-7 col-lg-7">
				<div style="padding-top:5px"></div>
				<div class="col-sm-12 col-md-12 col-lg-12">
					<table class="table">
						<thead>
							<th>&nbsp;</th>
							<th></th>
						</thead>
						<tbody>
							<%if tallajes.eof then%>
								<tr>
									<td class="col-sm-3"><b><%=lista_articulos_gag_panel_articulos_informacion_referencia%>:</b></td>
									<td class="col-sm-9"><%=articulos("codigo_sap")%></td>
								</tr>
							<%end if%>
							<tr>
								<td><b><%=lista_articulos_gag_panel_articulos_informacion_familia%>:</b></td>
								<td><%=articulos("nombre_familia")%></td>
							</tr>
							
							<%
							'el perfil de ASM no tiene que ver este dato de Requiere Autorizacion
							' y el de UVE tampoco
							' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
							' 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR tampoco
							' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 220 IMPRENTA
							' 230 AVORIS, 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR y 260 GENERAL CARRITO tampoco
							if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150_
								and session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80_
								and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170_
								and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 and session("usuario_codigo_empresa")<>220_
								and session("usuario_codigo_empresa")<>240 and session("usuario_codigo_empresa")<>250 and session("usuario_codigo_empresa")<>260 then%>	
								
								<tr>
									<td><b><%=lista_articulos_gag_panel_filtros_requiere_autorizacion_alter%>:</b></td>
									<td>
										<%IF articulos("requiere_autorizacion")="SI" THEN%>
											<B style="color:#FF0000"><%=lista_articulos_gag_panel_filtros_combo_autorizacion_si%></B>
										<%ELSE%>	
											<%=lista_articulos_gag_panel_filtros_combo_autorizacion_no%>
										<%END IF%>
									</td>
								</tr>
							<%end if%>
		
							<%'informacion especial del articulo guardada en descripciones Multiarticulos-->
							set multiarticulos=Server.CreateObject("ADODB.Recordset")
	
							sql="Select *  from descripciones_multiarticulos"
							sql=sql & " where id_articulo=" & articulos("ID") 
							sql=sql & " order by CARACTERISTICA, DESCRIPCION"
							
							if ver_cadena="SI" then
								response.write("<br>consulta multiarticulos: " & sql)
							end if
							
							with multiarticulos
								.ActiveConnection=connimprenta
								.Source=sql
								.Open
							end with
							descripcion_ant=""
							while not multiarticulos.eof
							%>
								<%valor_caracteristica=multiarticulos("caracteristica")%>
									<tr>
										<td><b><%=valor_caracteristica%>:</b></td>
										<td><%=multiarticulos("descripcion")%></td>
									</tr>
							<%
								multiarticulos.movenext
							wend
							
							multiarticulos.close
							set multiarticulos = Nothing
							%>
							
							
							<!--informacion secundaria del articulo almacenada en articulos-->
							<%if articulos("unidades_de_pedido")<>"" then%>
								<tr>
									<td><b><%=lista_articulos_gag_panel_articulos_informacion_unidad_pedido%>:</b></td>
									<td><%=articulos("unidades_de_pedido")%></td>
								</tr>
							<%end if%>
							<%if articulos("packing")<>"" then%>
								<tr>
									<td><b><%=lista_articulos_gag_panel_articulos_informacion_caja_completa%>:</b></td>
									<td><%=articulos("packing")%></td>
								</tr>
							<%end if%>
							<%if articulos("tamanno")<>"" then%>
								<tr>
									<td><b><%=lista_articulos_gag_panel_articulos_informacion_tamanno%>:</b></td>
									<td><%=articulos("tamanno")%></td>
								</tr>
							<%end if%>
							<%if articulos("tamanno_abierto")<>"" then%>
								<tr>
									<td><b><%=lista_articulos_gag_panel_articulos_informacion_tamanno_abierto%>:</b></td>
									<td><%=articulos("tamanno_abierto")%></td>
								</tr>
							<%end if%>
							<%if articulos("tamanno_cerrado")<>"" then%>
								<tr>
									<td><b><%=lista_articulos_gag_panel_articulos_informacion_tamanno_cerrado%>:</b></td>
									<td><%=articulos("tamanno_cerrado")%></td>
								</tr>
							<%end if%>
							<%if articulos("papel")<>"" then%>
								<tr>
									<td><b><%=lista_articulos_gag_panel_articulos_informacion_papel%>:</b></td>
									<td><%=articulos("papel")%></td>
								</tr>
							<%end if%>
							<%if articulos("tintas")<>"" then%>
								<tr>
									<td><b><%=lista_articulos_gag_panel_articulos_informacion_tintas%>:</b></td>
									<td><%=articulos("tintas")%></td>
								</tr>
							<%end if%>
							<%if articulos("material")<>"" then%>
								<tr>
									<td><b><%=lista_articulos_gag_panel_articulos_informacion_material%>:</b></td>
									<td><%=articulos("material")%></td>
								</tr>
							<%end if%>
							<%if articulos("acabado")<>"" then%>
								<tr>
									<td><b><%=lista_articulos_gag_panel_articulos_informacion_acabado%>:</b></td>
									<td><%=replace(articulos("acabado"),chr(13),"<br>")%></td>
								</tr>
							<%end if%>
							<%if articulos("fecha")<>"" then%>
								<tr>
									<td><b><%=lista_articulos_gag_panel_articulos_informacion_fecha%>:</b></td>
									<td><%=articulos("fecha")%></td>
								</tr>
							<%end if%>
							
							<%if not tallajes.eof then%>
								<tr>
									
									<td align="center" colspan="2">
										<BR />
										<div class="col-sm-12 col-md-12 col-lg-12">
											<div class="col-sm-2 col-md-2 col-lg-2"></DIV>
											<div class="col-sm-8 col-md-8 col-lg-8">
											<table class="table table-condensed" id="tabla_tallajes" style="margin-bottom:0px "> 
												<thead class="cabeceras_tallas"> 
													<tr> 
														<th style="text-align:center">Tallas / N&uacute;m.</th> 
														<th style="text-align:center">Referencia</th> 
													</tr> 
												</thead> 
												<tbody> 
													<%
													while not tallajes.eof%>
														<tr>
															<td align="left" ><%=tallajes("descripcion_talla")%></td>
															<td align="center" ><%=tallajes("referencia")%></td>
														</tr>
														<%
														tallajes.movenext
														%>
													<%wend%>
												</tbody> 
											</table>
											</DIV>
										</DIV>
									</td>
								</tr>
							<%end if%>			

							
						</tbody>
					  </table>
				</div>
			</div><!--col-md-7-->
			
		</div><!--row-->
		<!--fin informacion general del articulo-->
		
		
		
		
	</div><!--panel-body-->
	</div>
	
</BODY>	
<%
articulos.close
tallajes.close
connimprenta.close

set articulos=Nothing
set tallajes=Nothing
set connimprenta=Nothing	
%>

</HTML>