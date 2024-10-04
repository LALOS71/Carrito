<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		if session("usuario_admin")="" then
			Response.Redirect("Login_GAGAD.asp")
		end if
		
		
		'recordsets
		dim articulos
		
		
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
				.Source=.Source & " ARTICULOS.UNIDADES_DE_PEDIDO"
				.Source=.Source & " FROM (PEDIDOS INNER JOIN PEDIDOS_DETALLES"
				.Source=.Source & " ON PEDIDOS.ID = PEDIDOS_DETALLES.ID_PEDIDO)"
				.Source=.Source & " INNER JOIN ARTICULOS"
				.Source=.Source & " ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID"
				.Source=.Source & " where pedidos.id=" & pedido_seleccionado
				'response.write("<br>" & .source)
				.Open
			end with


		





'Recogemos la variable borrar 
borrar=Request.Querystring("borrar")

'Si no quedan articulos en el carrito despues del borrado
cadena="Lista_Articulos.asp"
'response.write("<br>" & sql)


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
	//alert("tama�o: " + s.legth)
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
   	
</script>
<script language="vbscript">
	
	
</script>
</head>
<body onload="">


<table>
<tr>
	<td width="760">
		<div id="main">
				
		
		
		
		
		
				
					<form name="frmpedido" id="frmpedido" action="Grabar_Pedido.asp" method="post">
					<table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table">
						<tr style="background-color:#FCFCFC" valign="top">
							<th class="menuhdr" colspan="7">Pedido Numero: <%=pedido_seleccionado%></th>
							
						</tr>
						<tr style="background-color:#FCFCFC" valign="top">
							<th class="menuhdr">Cod. Sap</th>
							<th class="menuhdr">Art&iacute;culo</th>
							<th class="menuhdr">Cantidad</th>
							<th class="menuhdr">Precio</th>
							<th class="menuhdr">Total</th>
							<th class="menuhdr">Estado</th>
							<th class="menuhdr">
								<img src="images/clip-16.png" />
							</th>
						</tr>
						<%if articulos.eof then%>
							<tr> 
								<td bgcolor="#999966" align="center" colspan="7"><b><FONT class="fontbold">El 
									Pedido No Tiene Articulos...</font></b><br>
								</td>
							</tr>
						<%end if%>
						
						
						
						<%while not articulos.eof%>

						
						<tr style="background-color:#FCFCFC" valign="top">
							<td class="ac item_row" width="68" align="right"><%=articulos("CODIGO_SAP")%></td>
							<td class="item_row" style="text-align:left" width="267">
							
							<%=articulos("DESCRIPCION")%>
							<%
							unidades_pedido="" & articulos("unidades_de_pedido")
							if unidades_pedido<>"" then%>
								<br />(en <%=unidades_pedido%>)
							<%end if%>
							</td>
							<td width="60" class="item_row" style="text-align:right"><%=articulos("cantidad")%>&nbsp;</td>
							<td class="item_row" style="text-align:right" width="72"><%=articulos("precio_unidad")%> �/u&nbsp;</td>
							<td class="item_row" width="108" style="text-align:right"><%=articulos("total")%> �&nbsp;</td>
							<td class="ac item_row" width="130"><%=articulos("estado")%></td>
							
							<td class="ac item_row" width="21">
								
								
								
								<%
								if articulos("fichero_personalizacion")<>"" then
									cadena_enlace="pedidos/" & year(articulos("FECHA")) & "/" & articulos("CODCLI") & "__" & pedido_seleccionado
									cadena_enlace=cadena_enlace & "/" & articulos("fichero_personalizacion")
									%>
									<a href="<%=cadena_enlace%>" target="_blank"><img src="images/clip-16.png" border=0/></a>
									
								<%end if%>
						  </td>
							
							
							
						</tr>
						<%		
							articulos.movenext
						Wend
						
						%>

						
					</table>
					</form>
				
		  
		
		
			
			

					
					
					
					
					
					
			
			
			
			
		</div>

	
	
	
	</td>
</tr>


</table>





















</body>
<%
	'articulos.close
	articulos.close
	connimprenta.close
	
	set articulos=Nothing
	set connimprenta=Nothing

%>
</html>
