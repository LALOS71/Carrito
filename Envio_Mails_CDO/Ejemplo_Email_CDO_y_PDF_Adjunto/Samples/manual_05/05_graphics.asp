<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 5: Graphics Sample</TITLE>
</HEAD>
<BODY>

<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Add a new page
	Set Page = Doc.Pages.Add

	' Create a new Graphics object
	Set Graphics = Doc.CreateGraphics( "Left=0, Bottom = 0; Right=100; Top=100" )

	' Create a drawing
	With Graphics.Canvas
		.DrawRect 1, 1, 99, 99
		.MoveTo 50, 90
		For i = 0 to 628
			.LineTo 40 * sin(i / 25) + 50, 40 * cos(i / 20) + 50
		Next
		.Fill
		
		.DrawText "AspPDF Rules!", "x=20, y=12; size=8", doc.Fonts("Courier")
	End With

	' Create empty Param object
	Set Param = Pdf.CreateParam

	' Display graphics with rotation
	For angle = 0 To 330 step 30
		Param("x") = 306 + 150 * cos( angle / 360 * 6.28 )
		Param("y") = 396 + 150 * sin( angle / 360 * 6.28 )
		Param("Angle") = Angle
		
		Page.Canvas.DrawGraphics Graphics, Param
	Next
	
	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("graphics.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"
%>

</BODY>
</HTML>
