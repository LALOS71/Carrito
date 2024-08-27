<HTML>
<HEAD>

<TITLE>AspPDF User Manual Chapter 12: Applying Security Sample</TITLE>
</HEAD>
<BODY>

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Open document to apply security to
	Set Doc1 = Pdf.OpenDocument( Server.MapPath("doc1.pdf") )

	' Copy properties
	Doc.Title = Doc1.Title
	Doc.Creator = Doc1.Creator
	Doc.Producer = Doc1.Producer
	Doc.CreationDate = Doc1.CreationDate
	Doc.ModDate = Doc1.ModDate

	' Apply security to Doc
	Doc.Encrypt "abc", "", 128

	' Append doc1 to doc
	Doc.AppendDocument Doc1

	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("apply.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"
%>

</BODY>
</HTML>
