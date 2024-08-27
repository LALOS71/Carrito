<%@ language=vbscript %>

<%
'Recuperamos la referencia del articulo
articulo=Request.Form("ocultoarticulo")
cantidades_precios=Request.Form("ocultocantidades_precios")
accion=Request.QueryString("acciones")

%>
<script language="javascript">
//alert('articulo: <%=articulo%> con cantidades <%=cantidades_precios%>')

</script>
<%
i=1 'contador de articulos
ya_existe="NO"
valor_i_cambiar=0
'buscamos si ya ha seleccionado el articulo previamente
While i<=Session("numero_articulos")
	if articulo=Session(i) then
		ya_existe="SI"
		valor_i_cambiar=i
	end if
	i=i+1
Wend
								


if ya_existe="NO" then
	'Anadimos un articulo mas al carrito y le damos el valor de la referencia
	' y la cantidad/precio
	Session("numero_articulos")=Session("numero_articulos")+1
	Session(session("numero_articulos"))=articulo
	Session(session("numero_articulos") & "_cantidades_precios")=cantidades_precios
  else
  	'como ya existe, no lo añadimos al carrito, lo modificamos
	' con respecto a las cantidades-precios
	Session(valor_i_cambiar & "_cantidades_precios")=cantidades_precios
end if

'vacio la variable de sesion con los datos json que pueda contener el articulo personalizado
Session("json_" & articulo)=""
%>
<%
'Fijamos en 10 el limite de libros
'If Session("num_articulos")>10 Then
'	Session("num_articulos")=10


%>
<html>
<script language="javascript">
	function saltar(sucursal,familia,nombrefamili)
	{
		//history.back()
		//alert('familia: ' + familia)
		//alert('articulos.asp?codsucursal=' + sucursal + '&codfamilia=' + familia + '&nomfamilia=' + nombrefamili)
		document.getElementById("frmArticulos").submit()
		//location.href='articulos.asp?codsucursal=' + sucursal + '&codfamilia=' + familia + '&nomfamilia=' + nombrefamili
	}
</script>
<body onload="saltar()">
	<form id="frmArticulos" name="frmArticulos" method="post" action="Lista_Articulos_Atesa.asp?acciones=<%=accion%>">
	</form>
				
</body>
</html>