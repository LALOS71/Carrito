<%@ language=vbscript %>

<%
'Recuperamos la referencia del articulo
id=Request.Querystring("id")
codigofamilia=Request.QueryString("codfamilia")
nombrefamilia=Request.QueryString("nomfamilia")
codigosucursal=Request.QueryString("codsucursal")

logotipo_empresa=Request.QueryString("logo")
codigo_empresa=Request.QueryString("codigo_empresa")

'Anadimos un articulo mas al carrito y le damos el valor de la referencia
Session("numero_articulos")=Session("numero_articulos")+1
Session(session("numero_articulos"))=id
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
		document.frmArticulos.submit()
		//location.href='articulos.asp?codsucursal=' + sucursal + '&codfamilia=' + familia + '&nomfamilia=' + nombrefamili
	}
</script>
<body onload="saltar('<%=codigosucursal%>',<%=codigofamilia%>,'<%=nombrefamilia%>')">
	<form id="frmArticulos" name="frmArticulos" method="post" action="articulos.asp?codsucursal=<%=codigosucursal%>&codfamilia=<%=codigofamilia%>&nomfamilia=<%=nombrefamilia%>">
 			<input name="ocultocodigo_empresa" type="hidden" value="<%=codigo_empresa%>">
			<input name="ocultologotipo_empresa" type="hidden" value="<%=logotipo_empresa%>">
	</form>
				
</body>
</html>