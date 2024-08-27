<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 5: Image -> PDF Conversion Sample</TITLE>
</HEAD>
<BODY>

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Open image from file
	Set Image = Doc.OpenImage(Server.MapPath( "atlanticocean.tif" ) )

	' Add empty page. Page size is based on resolution and size of image
	Width = Image.Width * 72 / Image.ResolutionX
	Height = Image.Height * 72 / Image.ResolutionY
	Set Page = Doc.Pages.Add( Width, Height )

	' Draw image
	Page.Canvas.DrawImage Image, "x=0, y=0"

	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("convert.pdf"), False )

	Response.Write "Success! Download your PDF file <A TARGET=""_new"" HREF=" & Filename & ">here</A>"
%>

</BODY>
</HTML>
