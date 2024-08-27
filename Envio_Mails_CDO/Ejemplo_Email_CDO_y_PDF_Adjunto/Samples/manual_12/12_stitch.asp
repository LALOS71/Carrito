<HTML>
<HEAD>

<TITLE>AspPDF User Manual Chapter 12: Stitching Sample</TITLE>
</HEAD>
<BODY>

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Open document 1
	Set Doc1 = Pdf.OpenDocument( Server.MapPath("doc1.pdf") )

	' Open document 2
	Set Doc2 = Pdf.OpenDocument( Server.MapPath("doc2.pdf") )

	' Append doc2 to doc1
	Doc1.AppendDocument Doc2

	' Save document, the Save method returns generated file name
	Filename = Doc1.Save( Server.MapPath("stitch.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"
%>

</BODY>
</HTML>
