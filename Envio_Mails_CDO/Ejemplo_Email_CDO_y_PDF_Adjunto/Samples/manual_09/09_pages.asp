<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 9: Page Management Sample</TITLE>
</HEAD>
<BODY>

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Open blank PDF form from file
	Set Doc = Pdf.OpenDocument( Server.MapPath("TwoPageDoc.pdf") )

	' insert page before 1st
	Set Page1 = Doc.Pages.Add(, , 1)

	' insert page after 2nd
	Set Page2 = Doc.Pages.Add(, , 3)

	' Remove page 4 (page 2 in original doc)
	Doc.Pages.Remove 4

	' Draw background image on all 3 remaining pages
	Set Image = Doc.OpenImage( Server.MapPath("exclam.gif") )
	For Each Page in Doc.Pages
		Page.Background.DrawImage Image, "x=70, y=220; scalex=2; scaley=2"
	Next

	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("pages.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"
%>

</BODY>
</HTML>
