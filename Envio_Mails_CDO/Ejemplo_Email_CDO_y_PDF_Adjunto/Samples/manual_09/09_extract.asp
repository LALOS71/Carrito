<HTML>
<HEAD>

<TITLE>AspPDF User Manual Chapter 9: Text Extraction Sample</TITLE>
</HEAD>
<BODY>

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Open a PDF file for text extraction
	Set Doc = Pdf.OpenDocument( Server.MapPath("1040es.pdf") )

	Dim TextString

	For Each Page in Doc.Pages
		TextString = TextString & Page.ExtractText
	Next

	Response.Write Server.HtmlEncode( TextString )

%>

</BODY>
</HTML>
