<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 9: Form Fill-Out Sample</TITLE>
</HEAD>
<BODY>

<%
	' Initialize coordinate and text arrays
	Dim arrX
	Dim arrY
	Dim arrText

	arrX = Array(100, 325, 455, 512, 550, 100, 100)
	arrY = Array(660, 660, 660, 687, 687, 602, 577)
	arrText = Array("John A.", "Smith", "123-56-7890", "1,234",_
		 "00", "4300 Cherry Ln.", "New York, NY 10001" )

	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Open blank PDF form from file
	Set Doc = Pdf.OpenDocument( Server.MapPath("1040es.pdf") )

	' Create default font
	Set Font = Doc.Fonts("Helvetica-Bold")

	' Obtain the only page's canvas
	Set Canvas = Doc.Pages(1).Canvas

	' Create empty param object
	Set Param = Pdf.CreateParam

	' Fill out three copies of the 1040ES coupons
	For i = 0 to 2

		' Go over all items in arrays
		For j = 0 to UBound(arrX)

			Param("x") = arrX(j)
			Param("y") = arrY(j) - 263 * i

			' Draw text on canvas
			Canvas.DrawText arrText(j), Param, Font

		Next ' j
	Next ' i


	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("form.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"
%>

</BODY>
</HTML>
