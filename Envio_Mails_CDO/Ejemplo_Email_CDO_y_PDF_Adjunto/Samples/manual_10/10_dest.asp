<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Add a new page
	Set Page = Doc.Pages.Add

	' Select one of the standard PDF fonts
	Set Font = Doc.Fonts("Helvetica")

	' vertical grid
	For x = 0 to Page.Width step Page.Width / 20
		Page.Canvas.DrawLine x, 0, x, Page.Height
		Page.Canvas.DrawText x, "angle=90;y=5;x=" & x, Font
	Next

	' horizontal grid
	For y = 0 to Page.Height step Page.Height / 20
		Page.Canvas.DrawLine 0, y, Page.Width, y
		Page.Canvas.DrawText y, "x=5;y=" & y, Font
	Next

	' Create destination based on URL param
	Set Param = Pdf.CreateParam
	If Request("FitV") <> "" Then
		Param("FitV") = True
		Param("Left") = Request("Left")
	End If

	If Request("FitH") <> "" Then
		Param("FitH") = True
		Param("Top") = Request("Top")
	End If

	If Request("XYZ") <> "" Then
		Param("XYZ") = True
		Param("Top") = Request("Top")
		Param("Left") = Request("Left")
		Param("Zoom") = Request("Zoom")
	End If

	Set Dest = Page.CreateDest(Param)

	' Assign destination to Doc's OpenAction
	Doc.OpenAction = Dest


	' Save to HTTP stream
	Doc.SaveHttp "attachment;filename=destdemo.pdf"
%>
