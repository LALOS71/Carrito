<%@ language=vbscript %>

<%
articulo=Request.QueryString("ocultoarticulo")
json_articulo=Request.QueryString("ocultojson")



%>
<script language="javascript">
//alert('articulo: <%=articulo%> con cantidades <%=cantidades_precios%>')

</script>
<%
	'Session("numero_articulos")=Session("numero_articulos")+1
	'Session(session("numero_articulos"))=articulo
	'Session(session("numero_articulos") & "_cantidades_precios")=cantidades_precios
	'Session("json_" & articulo)=replace(json_articulo, """", "&quot;")
	Session("json_" & articulo)=json_articulo
%>
<html>
<body>
</body>
</html>