<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 10: Outline Sample</TITLE>
</HEAD>
<BODY>

<!--METADATA TYPE="TypeLib" UUID="{414FEE4B-2879-4090-957E-423567FFCFC6}"-->

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Add two pages
	Set Page1 = Doc.Pages.Add
	Set Page2 = Doc.Pages.Add

	' Make document fit window and show outlines
	Doc.OpenAction = Page1.CreateDest
	Doc.PageMode = pdfUseOutlines

	' Select one of the standard PDF fonts
	Set Font = Doc.Fonts("Helvetica")

	' Param string
	Params = "x=0; y=650; width=612; alignment=center; size=50"

	' Draw text on pages
	Page1.Canvas.DrawText "Page 1", Params, Font
	Page2.Canvas.DrawText "Page 2", Params, Font

	' Build outline hierarchy
	Set outline = Doc.Outline
	Set Title = outline.Add("User Manual", Nothing, Nothing, Nothing, "Bold=true")
	
	Set Chapter1 = outline.Add("Chapter 1", Page1.CreateDest, Title, Nothing, "Bold=true; Italic=true")
	Set Section11 = outline.Add("Section 1.1", Page1.CreateDest("XYZ=true;Zoom=2;Top=300"), Chapter1, Nothing )
	
	Set Chapter2 = outline.Add("Chapter 2", Page2.CreateDest, Title, Nothing, "Bold=true; Italic=true")
	Set Section21 = outline.Add("Section 2.1", Page2.CreateDest("XYZ=true;Zoom=2;Top=500"), Chapter2, Nothing )
	Set Section22 = outline.Add("Section 2.2", Page2.CreateDest("XYZ=true;Zoom=2;Top=200"), Chapter2, Nothing )

	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("outline.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"


%>

</BODY>
</HTML>
