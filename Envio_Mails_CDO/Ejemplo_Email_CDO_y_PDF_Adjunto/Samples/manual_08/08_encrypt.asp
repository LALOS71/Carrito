<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 8: Encryption Sample</TITLE>
</HEAD>
<BODY>

<!--METADATA TYPE="TypeLib" UUID="{414FEE4B-2879-4090-957E-423567FFCFC6}"-->

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Set various document properties
	Doc.Title = "AspPDF Chapter 3 Hello World Sample"
	Doc.Creator = "John Smith"

	' Add a new page
	Set Page = Doc.Pages.Add

	' Select one of the standard PDF fonts
	Set Font = Doc.Fonts("Helvetica")

	' Param string
	Params = "x=0; y=650; width=612; alignment=center; size=50"

	' Draw text on page
	Page.Canvas.DrawText "Hello World!", Params, Font

	' Encrypt document, set "no printing/no changing" flags
	Doc.Encrypt "abc", "xyz", 128, pdfFull And (Not pdfPrint) And (Not pdfModify)

	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("encrypted.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"


%>

</BODY>
</HTML>
