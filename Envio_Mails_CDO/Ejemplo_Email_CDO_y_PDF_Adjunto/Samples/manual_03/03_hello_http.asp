<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Set various document properties
	Doc.Title = "AspPDF Chapter 3 Hello World Sample"
	Doc.Creator = "John Smith"

	' Add a new page
	Set Page = Doc.Pages.Add

	' Select one of the standard PDF fonts
	Set Font = Doc.Fonts("Helvetica")

	' Param string
	Params = "x=0; y=650; width=612; alignment=center; size=50"

	' Draw text on page
	Page.Canvas.DrawText "Hello World!", Params, Font

	' Save to HTTP stream
	Doc.SaveHttp "attachment;filename=hello.pdf"
%>
