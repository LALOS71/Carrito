<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 13: ImportFromUrl Sample</TITLE>
</HEAD>
<BODY>


<%

	Set Pdf = Server.CreateObject("Persits.Pdf")
	Set Doc = Pdf.CreateDocument
	Doc.ImportFromUrl "http://www.persits.com"

	Filename = Doc.Save( Server.MapPath("importfromurl.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"

%>

</BODY>
</HTML>
