<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 6: Chessboard Sample<</TITLE>
</HEAD>
<BODY>

<%

	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Create 8x8 table to depict a chessboard
	Set Table = Doc.CreateTable( "width=200; height=200; rows=8; cols=8; border=1; cellborder=0; cellspacing=2")

	' Select a Chess font to depict chess pieces
	Set Font = Doc.Fonts.LoadFromFile( Server.MapPath("MERIFONT.TTF") )

	Table.Font = Font

	' initialize Pieces array
	Dim Pieces
	Pieces = Array(0,_
	&HF074, &HF06D, &HF076, &HF077, &HF06C, &HF076, &HF06D, &HF074, _
	&HF06F, &HF06F, &HF06F, &HF06F, &HF06F, &HF06F, &HF06F, &HF06F, _
	&HF000, &HF000, &HF000, &HF000, &HF000, &HF000, &HF000, &HF000, _
	&HF000, &HF000, &HF000, &HF000, &HF000, &HF000, &HF000, &HF000, _
	&HF000, &HF000, &HF000, &HF000, &HF000, &HF000, &HF000, &HF000, _
	&HF000, &HF000, &HF000, &HF000, &HF000, &HF000, &HF000, &HF000, _
	&HF070, &HF070, &HF070, &HF070, &HF070, &HF070, &HF070, &HF070, _
	&HF072, &HF06E, &HF062, &HF071, &HF06B, &HF062, &HF06E, &HF072 )

	' go over all cells in the table
	For Each Row in Table.Rows
		For Each Cell in Row.Cells
			' set background on cells which sum of indices is odd
			If (Cell.Index + Row.Index) Mod 2 = 1 Then
				Cell.BgColor = "brown"
			End if
			
			Piece = Pieces( 8 * (Row.Index - 1) + Cell.Index )
			Cell.AddText ChrW(Piece), "size=20; indentx=1; indenty=1"
		
		Next
	Next



	' Add a new page
	Set Page = Doc.Pages.Add

	Page.Canvas.DrawTable Table, "x=206, y=498"

	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("chess.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"

%>

</BODY>
</HTML>
