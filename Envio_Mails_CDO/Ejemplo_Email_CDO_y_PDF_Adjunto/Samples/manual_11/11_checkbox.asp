<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 12: Checkbox Sample</TITLE>
</HEAD>
<BODY>


<%

	Set Pdf = Server.CreateObject("Persits.Pdf")
	Set Doc = Pdf.CreateDocument

	Set Page = Doc.Pages.Add

	' Draw gray background
	Page.Canvas.SetFillColor .64, .78, .66
	Page.Canvas.FillRect 0, 0, Page.Width, Page.Height

	Set Checkbox = Page.CreateCheckbox( "Receipt", "x=100; y=660; width=30; height=30", Nothing )

	Set GrayBack = Doc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30")
	GrayBack.Canvas.SetFillColor .5, .5, .5
	GrayBack.Canvas.FillRect 0, 0, 30, 30

	Set WhiteBack = Doc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30")
	WhiteBack.Canvas.SetFillColor 1, 1, 1
	WhiteBack.Canvas.FillRect 0, 0, 30, 30

	Set LiteBack = Doc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30")
	LiteBack.Canvas.SetFillColor .82, .82, .1
	LiteBack.Canvas.FillRect 0, 0, 30, 30

	Set Outline = Doc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30")
	LineWidth = 3
	With Outline.Canvas
		.SetColor .35, .6, .39
		.LineWidth = LineWidth
		.MoveTo LineWidth /2, LineWidth /2
		.LineTo LineWidth /2, 30 - LineWidth /2
		.LineTo 30 - LineWidth /2, 30 - LineWidth /2
		.Stroke

		.SetColor .82, .89, .83
		.MoveTo 0, LineWidth / 2
		.LineTo 30 - LineWidth / 2, LineWidth / 2
		.LineTo 30 - LineWidth / 2, 30
		.Stroke

		.SetColor .64, .78, .66
		.MoveTo LineWidth, 3 * LineWidth / 2
		.LineTo 30 - 3 * LineWidth / 2, 3 * LineWidth / 2
		.LineTo 30 - 3 * LineWidth / 2, 30 - LineWidth
		.Stroke

		.SetColor 0, 0, 0
		.MoveTo 3 * LineWidth /2, 4 * LineWidth /2
		.LineTo 3 * LineWidth /2, 30 - 3 * LineWidth /2
		.LineTo 30 - 4 * LineWidth /2, 30 - 3 * LineWidth /2
		.Stroke
	End With

	GrayBack.Canvas.DrawGraphics Outline, "x=0, y=0"
	WhiteBack.Canvas.DrawGraphics Outline, "x=0, y=0"
	LiteBack.Canvas.DrawGraphics Outline, "x=0, y=0"

	Checkbox.Graphics(0, "Off") = WhiteBack
	Checkbox.Graphics(1, "Off") = LiteBack
	Checkbox.Graphics(2, "Off") = GrayBack

	Set GrayBackChecked = Doc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30")
	GrayBackChecked.Canvas.DrawGraphics GrayBack, "x=0, y=0"
	GrayBackChecked.Canvas.DrawText "8", "x=8,y=28,size=20", Doc.Fonts("ZapfDingbats")

	Set WhiteBackChecked = Doc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30")
	WhiteBackChecked.Canvas.DrawGraphics WhiteBack, "x=0, y=0"
	WhiteBackChecked.Canvas.DrawText "8", "x=8,y=28,size=20", Doc.Fonts("ZapfDingbats")
	
	Set LiteBackChecked = Doc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30")
	LiteBackChecked.Canvas.DrawGraphics LiteBack, "x=0, y=0"
	LiteBackChecked.Canvas.DrawText "8", "x=8,y=28,size=20", Doc.Fonts("ZapfDingbats")

	Checkbox.Graphics(0, "Yes") = WhiteBackChecked
	Checkbox.Graphics(1, "Yes") = LiteBackChecked
	Checkbox.Graphics(2, "Yes") = GrayBackChecked


	Filename = Doc.Save( Server.MapPath("checkbox.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"

%>

</BODY>
</HTML>
