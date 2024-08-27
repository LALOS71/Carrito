<%@ language=vbscript %>


<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Pagina nueva 2</title>
</head>

<body>
<TABLE BORDER="1">
<TR><TD><B>Server Variable</B></TD><TD><B>Value</B></TD></TR>

<TR>
<TD>Direccion IP del Equipo</TD>
<TD><%= Request.ServerVariables("REMOTE_ADDR") %></TD>
</TR>

</TABLE>
 
</body>
</html>
