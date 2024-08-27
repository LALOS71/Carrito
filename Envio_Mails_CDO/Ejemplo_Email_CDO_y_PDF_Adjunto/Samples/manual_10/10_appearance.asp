<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 10: Annotation Sample 2 (Appearance)</TITLE>
</HEAD>
<BODY>

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Add a new page
	Set Page = Doc.Pages.Add

	' Add annotation with custom appearance
	Notice = "This invoice was paid on June 10, 2003."
	Set Annot = Page.Annots.Add(Notice, "x=10, y=600; width=182; height=131; Type=Stamp")

	' Create a graphics object for this annotation containing an image    
    Set PaidGraph = Doc.CreateGraphics("left=0; bottom=0; right=182; top=131")
    Set image = Doc.OpenImage( Server.MapPath("paid.gif") )
    PaidGraph.Canvas.DrawImage image, "x=0, y=0"

	' Use this graphics object as the annotatoin's appearance
	Annot.Graphics(0) = PaidGraph

	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("appearance.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"


%>

</BODY>
</HTML>
