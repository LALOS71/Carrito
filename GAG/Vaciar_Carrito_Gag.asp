<%@ LANGUAGE="VBSCRIPT"%>
<%
for i=1 to Session("numero_articulos")
	session(i & "_cantidades_precios")=""
	session(i & "_fichero_asociado")=""
next

Session("numero_articulos")=0
%>
<html>
<head>
</head>
<body>
&nbsp;<b><%=session("numero_articulos")%></b> Art&iacute;culos
</body>
</html>