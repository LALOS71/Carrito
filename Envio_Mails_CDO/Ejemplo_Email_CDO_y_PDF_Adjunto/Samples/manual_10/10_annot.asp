<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 10: Annotation Sample</TITLE>
</HEAD>
<BODY>

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Add a new page
	Set Page = Doc.Pages.Add

	' Select one of the standard PDF fonts
	Set Font = Doc.Fonts("Helvetica")

	' Param string
	Params = "x=0; y=650; width=612; alignment=center; size=50"

	' Draw text on page
	Page.Canvas.DrawText "Hello World!", Params, Font

	' Add annotation
	Set Annot = Page.Annots.Add("This is a simple text annotation.", "x=10, y=700; width=200; height=50")

	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("annot.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"


%>

</BODY>
</HTML>
