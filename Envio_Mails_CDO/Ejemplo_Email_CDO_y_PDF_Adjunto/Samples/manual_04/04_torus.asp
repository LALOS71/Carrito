<% Option Explicit %>

<HTML>
<HEAD>
<TITLE>AspPDF Demo: Torus 3D</TITLE>
</HEAD>
<BODY>


<%
	Dim Pdf, Doc, Page
	' create PDF object, create a document, add a page
	Set Pdf = Server.CreateObject("Persits.PdfManager")
	Set Doc = Pdf.CreateDocument	
	Set Page = Doc.Pages.Add

	' Fit this page in viewer window
	Doc.OpenAction = Doc.CreateDest(Page, "Fit=true")

	Dim CenterX, CenterY, pi, p, t, PN, TN, OuterR, GirthR, Alpha, Beta, sa, ca, sb, cb
	Dim i, j, R1, x1, y1, L

	' computer center of page
	CenterX = Page.Width / 2
	CenterY = Page.Height / 2

	pi = 3.1415926
	PN = 30 ' number of steps for variable p
	TN = 10 ' number of steps for variable t
	OuterR = Page.Width / 3	' outer radius
	GirthR = OuterR / 3		' girth

	' will store node coordinates
	Dim X(50, 50)
	Dim Y(50, 50)
	Dim Z(50, 50)

	' will store tile distance information for invisible surface removal purposes
	Dim Dist(2601) ' 51 x 51
	Dim IndexI(2601)
	Dim IndexJ(2601)

	L = OuterR * 3		' Distance from the viewer

	Alpha = pi + pi / 4		' 45 degree rotation around X Axis
	Beta = pi / 6		' 30 degree rotation around Y Axis

	sa = sin(Alpha)
	ca = cos(Alpha)
	sb = sin(Beta)
	cb = cos(Beta)

	' Compute coordinates of tiles
	Dim Count ' number of tiles
	Count = 0
	For j = 0 To TN
		t = 2 * pi * j / TN

		For i = 0 To PN

			R1 = OuterR + GirthR * sin(t)

			p = 2 * pi * i / PN
			X(i, j) = R1 * sin( p )
			Y(i, j) = R1 * cos( p )
			Z(i, j) = GirthR * cos( t )

			' Save distance to viewer based on Z-coordinate of one of tile corners
			Dist(Count) = Z(i, j)
			IndexI(Count) = i
			IndexJ(Count) = j
			Count = Count + 1
		Next
	Next

	' Sort Distance arrays. Use bubble sort since arrays are relatively small
	Dim temp
	For i = 0 To Count - 1
		For j = Count - 1 To i + 1 Step -1
			If Dist(j) < Dist(j-1) Then
				' Swap
				temp = Dist(j)
				Dist(j) = Dist(j-1)
				Dist(j-1) = temp

				temp = IndexI(j)
				IndexI(j) = IndexI(j-1)
				IndexI(j-1) = temp

				temp = IndexJ(j)
				IndexJ(j) = IndexJ(j-1)
				IndexJ(j-1) = temp
			End If
		Next
	Next

	' Display torus in order of proximity to viewer
	Page.Canvas.SetParams("color=darkgray; fillcolor=blue;linewidth=3")
	
	Dim x2, y2, x3, y3, x4, y4, tilecount
	For tilecount = 0 to Count - 1
		i = IndexI(tilecount)
		j = IndexJ(tilecount)

		If i < PN And j < TN Then
			' transform from 3D to 2D
			Call Project( X(i, j), Y(i, j), Z(i, j ), x1, y1)
			Call Project( X(i+1, j), Y(i+1, j), Z(i+1, j ), x2, y2)
			Call Project( X(i+1, j+1), Y(i+1, j+1), Z(i+1, j+1), x3, y3)
			Call Project( X(i+1, j+1), Y(i+1, j+1), Z(i+1, j+1), x3, y3)
			Call Project( X(i, j+1), Y(i, j+1), Z(i, j+1), x4, y4)

			' Draw tile
			Page.Canvas.MoveTo x1, y1
			Page.Canvas.LineTo x2, y2
			Page.Canvas.LineTo x3, y3
			Page.Canvas.LineTo x4, y4
			Page.Canvas.FillStroke
		End If
	Next

	' We use Session ID for file names
	' false means "do not overwrite"
	' The method returns generated file name
	Dim Path, FileName
	Path = Server.MapPath( "torus.pdf" )
	FileName = Doc.Save( Path, false)

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"
	Set Page = Nothing
	Set Doc = Nothing
	Set Pdf = Nothing


Sub Project( x, y, z, byref x1, byref y1 )
	x1 = CenterX + x * (L - z) / L
	y1 = CenterY - (sa * y + ca * z) * (L - z) / L
End Sub

%>

</BODY>
</HTML>
