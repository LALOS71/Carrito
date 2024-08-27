<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->

<%
'Recuperamos la referencia del articulo
pedido_a_modificar=Request.Form("ocultopedido_a_modificar")

empleado_gls=Request.Querystring("emp")


'para controlar si el pedido lo quiere modificar el hotel o la propia imprenta
procedencia=Request.Form("ocultoprocedencia")

set articulos=Server.CreateObject("ADODB.Recordset")
		
		'response.write("<br>" & sql)

			with articulos
				.ActiveConnection=connimprenta
				'.Source="SELECT PEDIDOS_DETALLES.ARTICULO, cast(PEDIDOS_DETALLES.CANTIDAD as nvarchar(50)) & cast('--' as nvarchar(2)) & cast(PEDIDOS_DETALLES.PRECIO_UNIDAD as nvarchar(50))"
				'.Source=.Source & " & cast('--' as nvarchar(2)) & cast(PEDIDOS_DETALLES.TOTAL as nvarchar(50)) as CANTIDADES_PRECIOS, PEDIDOS_DETALLES.FICHERO_PERSONALIZACION,"
				.Source="SELECT PEDIDOS_DETALLES.ARTICULO"
				.Source=.Source & ", (ISNULL(convert(nvarchar(50), PEDIDOS_DETALLES.CANTIDAD), '')"
				.Source=.Source & " + '--' + ISNULL(convert(nvarchar(50),PEDIDOS_DETALLES.PRECIO_UNIDAD), '')"
				.Source=.Source & " + '--' + ISNULL(convert(nvarchar(50), PEDIDOS_DETALLES.TOTAL), '')) as CANTIDADES_PRECIOS"
				.Source=.Source & ", PEDIDOS_DETALLES.FICHERO_PERSONALIZACION, PEDIDOS.FECHA, PEDIDOS.CODCLI, PEDIDOS.PEDIDO_AUTOMATICO"
				
				.Source=.Source & " FROM PEDIDOS_DETALLES INNER JOIN PEDIDOS"
				.Source=.Source & " ON PEDIDOS_DETALLES.ID_PEDIDO=PEDIDOS.ID"
				.Source=.Source & " WHERE PEDIDOS_DETALLES.ID_PEDIDO=" & pedido_a_modificar
				
				'RESPONSE.WRITE("<br>consulta: " & .SOURCE)
				.Open
			end with
			
			if not articulos.eof then
				fecha_pedido=articulos("fecha")
				hotel_pedido=articulos("CODCLI")
			end if
			
			Session("numero_articulos")=0
			while not articulos.eof
				'response.write("<br>articulo: " & articulos("articulo") & " cantidades: " & articulos("cantidades_precios"))
				Session("numero_articulos")=Session("numero_articulos")+1
				'si no lo meto como string, lo entiende como numero y a la hora de mostrar el carrito
				' y operar con el, da problemas, porque con las variables de sesion, directamente si lo
				' interpreta como cadena
				Session(session("numero_articulos"))=cstr(articulos("articulo"))
				Session(session("numero_articulos") & "_cantidades_precios")=articulos("cantidades_precios")
				Session(session("numero_articulos") & "_fichero_asociado")=articulos("fichero_personalizacion")
				
				'para los kits parcelshop pueden venir personalizados o no segun el check
				if instr("-3765-3766-3767-3768-3769-3770-3771-3772-3773-3774-3775-3776-3777-3778-3779-3780-3781-3782-3783-3784-3785-3786-3787-3788-", _
												"-" & articulos("articulo") & "-")>0 then
						
					dim fs
					ruta_fichero_json=Request.ServerVariables("PATH_TRANSLATED")
					posicion=InStrRev(ruta_fichero_json,"\")
					ruta_fichero_json=left(ruta_fichero_json,posicion)
					ruta_fichero_json = ruta_fichero_json & "pedidos\" & year(articulos("fecha")) & "\" & articulos("codcli") & "__" & pedido_a_modificar & "\json_" & articulos("articulo") & ".json"
					'response.write("<br>fichero: " &ruta_fichero_json)
					set fs=Server.CreateObject("Scripting.FileSystemObject")
					'response.write("<br>existe el fichero: " & fs.FileExists(ruta_fichero_json))
					'compruebo si el kit de parcelshop esta personalizado o no comprobando si está el fichero .json
					if fs.FileExists(ruta_fichero_json) then
						Session(session("numero_articulos") & "_cantidades_precios")=Session(session("numero_articulos") & "_cantidades_precios") & "--SI"
					  else
					  	Session(session("numero_articulos") & "_cantidades_precios")=Session(session("numero_articulos") & "_cantidades_precios") & "--NO"
					end if
				end if				
				'para que se refresque el contenido de este articulo con los valores de este pedido y no
				' se mantenga los valores de un pedido anterior con el mismo articulo
				Session("json_" & articulos("articulo"))=""
				
				articulos.movenext
			wend



	'articulos.close
	articulos.close
	connimprenta.close
	
	set articulos=Nothing
	set connimprenta=Nothing


%>
<script language="javascript">
//alert('articulo: <%=articulo%> con cantidades <%=cantidades_precios%>')

</script>
<%
%>
<%
'Fijamos en 10 el limite de libros
'If Session("num_articulos")>10 Then
'	Session("num_articulos")=10


%>
<html>
<script language="javascript">
	function saltar()
	{
		//history.back()
		//alert('familia: ' + familia)
		//alert('articulos.asp?codsucursal=' + sucursal + '&codfamilia=' + familia + '&nomfamilia=' + nombrefamili)
		document.getElementById("frmArticulos").submit()
		//location.href='articulos.asp?codsucursal=' + sucursal + '&codfamilia=' + familia + '&nomfamilia=' + nombrefamili
	}
</script>
<body onload="saltar()" style="background-color:<%=session("color_asociado_empresa")%>">
<%if procedencia="ADMINISTRADOR" then%>
	
	<form id="frmArticulos" name="frmArticulos" method="post" action="Carrito_Admin_Gag.asp">
		<input type="hidden" name="ocultoaccion" id="ocultoaccion" value="MODIFICAR">
		<input type="hidden" name="ocultohotel" id="ocultohotel" value="<%=hotel_pedido%>">
		<input type="hidden" name="ocultopedido_modificar" id="ocultopedido_modificar" value="<%=pedido_a_modificar%>">
		<input type="hidden" name="ocultofecha_pedido" id="ocultofecha_pedido" value="<%=fecha_pedido%>">
		
	</form>
  <%else%>
	
	<form id="frmArticulos" name="frmArticulos" method="post" action="Carrito_Gag.asp?emp=<%=empleado_gls%>">
		<input type="hidden" name="ocultoaccion" id="ocultoaccion" value="MODIFICAR">
		<input type="hidden" name="ocultopedido_modificar" id="ocultopedido_modificar" value="<%=pedido_a_modificar%>">
		<input type="hidden" name="ocultofecha_pedido" id="ocultofecha_pedido" value="<%=fecha_pedido%>">
		
	</form>
<%end if%>
				
</body>
</html>