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
<% For Each strKey In Request.ServerVariables %> 
<TR>
<TD><%= strKey %></TD>
<TD><%= Request.ServerVariables(strKey) %></TD>
</TR>
<% Next %>
</TABLE>
 
</body>
</html>
