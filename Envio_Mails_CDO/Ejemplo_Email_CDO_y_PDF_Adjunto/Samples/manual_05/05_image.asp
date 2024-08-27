<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 5: Image Sample</TITLE>
</HEAD>
<BODY>

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Add a new page
	Set Page = Doc.Pages.Add

	' Open image
	Set Image = Doc.OpenImage( Server.MapPath( "painting.jpg") )

	' Create empty param object
	Set Param = Pdf.CreateParam

	For i = 1 To 3
		Param("x") = (Page.Width - Image.Width / i) / 2
		Param("y") = Page.Height - Image.Height * i / 2 - 200
		Param("ScaleX") = 1 / i
		Param("ScaleY") = 1 / i
		Page.Canvas.DrawImage Image, Param
	Next
	
	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("image.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"
%>

</BODY>
</HTML>
