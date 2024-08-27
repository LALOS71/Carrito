<HTML>
<HEAD>
<TITLE>Form Submission Results</TITLE>
</HEAD>
<BODY>

<!-- this script is invoked by a PDF file generated via 11_form.asp/aspx-->

<%

n = Request.TotalBytes
val = Request.BinaryRead( n)
for i = 1 to n
	Response.Write MidB( val, i, 1 )
Next

%>
</BODY>
</HTML>
