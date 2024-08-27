<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 3: Hello World Sample, SaveToMemory</TITLE>
</HEAD>
<BODY>

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

	' Connect to the database
	Connect = "Driver={Microsoft Access Driver (*.mdb)};DBQ=" & Server.MapPath("..\db\asppdf.mdb")

	' If you use SQL Server, the connecton string must look something like this:
	' Connect = "Provider=SQLOLEDB;Server=MYSRV;Database=master;UID=sa;PWD=xxx"

	' Use ADO Recordset object
	Set rs = Server.CreateObject("adodb.recordset")
	rs.Open "PDFFILES", Connect, 2, 3
	rs.AddNew
	rs("FileBlob").Value = Doc.SaveToMemory
	rs.Update

	Response.Write "Success! File was successfully saved in the AspPDF.mdb database."
%>

</BODY>
</HTML>
