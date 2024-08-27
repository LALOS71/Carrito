<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 5: Masking Sample</TITLE>
</HEAD>
<BODY>

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Add a new page
	Set Page = Doc.Pages.Add

	' Draw something
	Page.Canvas.SetParams "LineWidth=5; Color=red;"
	Page.Canvas.DrawLine 0, 792, 600, 0

	' Open image to become the mask. This has to be a monochrome bitmap
	Set ImageMask = Doc.OpenImage( Server.MapPath( "exclam.bmp") )
	ImageMask.IsMask = True ' Mark this image object as a mask

	' Open image to be masked
	Set Image = Doc.OpenImage( Server.MapPath( "exclam.gif") )
	Image.SetImageMask ImageMask

	' Draw masked image
	Page.Canvas.DrawImage Image, "x=10, y=550"


	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("mask.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"

%>

</BODY>
</HTML>
