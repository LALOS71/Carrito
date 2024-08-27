<%@ language=vbscript %>
<!--#include virtual="/includes/Idiomas.asp"-->

<%
'Recuperamos la referencia del articulo
'articulo=Request.Form("ocultoarticulo")
'cantidades_precios=Request.Form("ocultocantidades_precios")

articulo=Request.QueryString("ocultoarticulo")
cantidades_precios=Request.QueryString("ocultocantidades_precios")
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
								
'response.write("ya existe?: " & ya_existe)								


if ya_existe="NO" then
	'Anadimos un articulo mas al carrito y le damos el valor de la referencia
	' y la cantidad/precio
	Session("numero_articulos")=Session("numero_articulos")+1
	Session(session("numero_articulos"))=articulo
	Session(session("numero_articulos") & "_cantidades_precios")=cantidades_precios
	
	'response.write("<br>sesion.. Numero_articulos: " & Session("numero_articulos"))
	'response.write("<br>sesion.. articulo: " & Session(session("numero_articulos")))
	'response.write("<br>cantidades precios: " & Session(session("numero_articulos") & "_cantidades_precios"))
	
  else
  	'como ya existe, no lo añadimos al carrito, lo modificamos
	' con respecto a las cantidades-precios
	Session(valor_i_cambiar & "_cantidades_precios")=cantidades_precios
end if

'vacio la variable de sesion con los datos json que pueda contener el articulo personalizado
Session("json_" & articulo)=""

'vacio tambien la variable de sesion del fichero asociado para que no se mantenga la antigua
'para que no de problemas con variables de sesion perdidas...
Session(session("numero_articulos") & "_fichero_asociado")="" 
				
%>
<%
'Fijamos en 10 el limite de libros
'If Session("num_articulos")>10 Then
'	Session("num_articulos")=10


%>
<html>
<body>
&nbsp;<b><%=session("numero_articulos")%></b> <%=annadir_articulo_gag_central_admin_literal_articulos%>
</body>
</html>