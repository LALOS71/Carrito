<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<%

'Response.ContentEncoding = Encoding.Default 


consulta_filtro="" & Request.Form("ocultosql")


		
		
		

'direccion_ip=Request.ServerVariables("REMOTE_ADDR") 


	set articulos=Server.CreateObject("ADODB.Recordset")
		
		'connimprenta.BeginTrans 'Comenzamos la Transaccion
				
		CAMPO_CODIGO_SAP_ARTICULO=0
		CAMPO_DESCRIPCION_ARTICULO=1
		CAMPO_UNIDADES_DE_PEDIDO_ARTICULO=2
		CAMPO_STOCK_ARTICULO=3
		CAMPO_PRECIO_COSTE_ARTICULO=4
		CAMPO_TOTAL_COSTE_ARTICULO=5
		CAMPO_PROVEEDOR_ARTICULO=6
		CAMPO_EMPRESA_ARTICULO=7
		CAMPO_FAMILIA_ARTICULO=8
		CAMPO_MOSTRAR_ARTICULO=9
	
		with articulos
			.ActiveConnection=connimprenta
			.Source=consulta_filtro
			'response.write("<br>" & .source)			
			.Open
			vacio_articulos=false
			if not .BOF then
				mitabla_articulos=.GetRows()
			  else
				vacio_articulos=true
			end if
		end with
		



Response.ContentType = "application/vnd.ms-excel.numberformat:#.###"
Response.AddHeader "Content-Disposition", "attachment;filename=Listado_Costes_Articulos.xls"
'Response.AddHeader "Content-Disposition", "inline;attachment;filename=Listado_Costes_Articulos.xls"
'Response.AppendHeader(“content-disposition“, “inline; filename=report.xls“);
		

%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">

<title>...:: Informe Imprenta ::...</title>


<style>


.cabeceras_grises{background: #666666;text-align:center;
				font-family:Calibri;font-weight:bold;font-size:15px;color:#eeeeee;}	

body {
	margin-top: 4px;
}

.contenedor_con_borde{ border:1 solid #888888}



/*para que el salto de linea lo deje en la misma celda y no genera una linea nueva*/
br {mso-data-placement:same-cell;}

</style>
</head>

<body bgcolor="#FFFFFF">



<div align="center">	


	<table border="0" cellpadding="0" cellspacing="0" width="99%" >
		<tr style="background-color:#FCFCFC" valign="top">
			<th class="contenedor_con_borde">Referencia</th>
			<th class="contenedor_con_borde">Descripci&oacute;n</th>
			<th class="contenedor_con_borde">Unid. Ped.</th>
			<th class="contenedor_con_borde">Stock</th>
			<th class="contenedor_con_borde">Coste</th>
			<th class="contenedor_con_borde">Coste Total</th>
			<th class="contenedor_con_borde">Proveedor</th>
			<th class="contenedor_con_borde">Empresa</th>
			<th class="contenedor_con_borde">Familia</th>
			<th class="contenedor_con_borde">Mostrar</th>
		</tr>
		
		<%if vacio_articulos=false then %>
				<%for i=0 to UBound(mitabla_articulos,2)%>
					<tr  valign="top">
						<td  class="contenedor_con_borde"><%=mitabla_articulos(CAMPO_CODIGO_SAP_ARTICULO,i)%></td>
						<td  class="contenedor_con_borde"  style="text-align:left"><%=mitabla_articulos(CAMPO_DESCRIPCION_ARTICULO,i)%></td>
						<td  class="contenedor_con_borde">
							<%=mitabla_articulos(CAMPO_UNIDADES_DE_PEDIDO_ARTICULO,i)%>
						</td>
						<td  class="contenedor_con_borde">
							<%=mitabla_articulos(CAMPO_STOCK_ARTICULO,i)%>
						</td>
						<td  class="contenedor_con_borde"><%=mitabla_articulos(CAMPO_PRECIO_COSTE_ARTICULO,i)%></td>
						<td  class="contenedor_con_borde">
							<%=mitabla_articulos(CAMPO_TOTAL_COSTE_ARTICULO,i)%>
						</td>
						<td  class="contenedor_con_borde"><%=mitabla_articulos(CAMPO_PROVEEDOR_ARTICULO,i)%></td>
						<td  class="contenedor_con_borde">
							<%=Mitabla_articulos(CAMPO_EMPRESA_ARTICULO,i)%>
						</td>
						<td  class="contenedor_con_borde">
							<%=mitabla_articulos(CAMPO_FAMILIA_ARTICULO,i)%>
						</td>
						<td  class="contenedor_con_borde">
							<%=mitabla_articulos(CAMPO_MOSTRAR_ARTICULO,i)%>
						</td>
					</tr>
				<%next%>
			<%else%>
				<tr> 
					<td align="center" colspan="10"><b><FONT class="fontbold">NO Hay Art&iacute;culos a Mostrar...</font></b><br>
					</td>
				</tr>
		<%end if%>
		
	</table>

</div>




</body>
<% 
	

%>
</html>
