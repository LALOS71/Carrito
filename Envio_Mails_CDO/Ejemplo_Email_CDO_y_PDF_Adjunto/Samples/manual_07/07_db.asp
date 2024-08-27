<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 7: Database Report Sample</TITLE>
</HEAD>
<BODY>

<%
	Set PDF = Server.CreateObject("Persits.Pdf")

	' Create empty param objects to be used across the app
	Set Param = PDF.CreateParam
	Set TextParam = PDF.CreateParam

	' Create document
	Set Doc = PDF.CreateDocument

	' Create table with one row (header), and 5 columns
	Set Table = Doc.CreateTable("width=500; height=20; Rows=1; Cols=5; Border=1; CellSpacing=-1; cellpadding=2 ")
	
	' Set default table font
	Table.Font = Doc.Fonts("Helvetica")
	
	Set HeaderRow = Table.Rows(1)
	Param.Set("alignment=center")
	With HeaderRow
		.BGColor = &H90F0FE
		.Cells(1).AddText "Category", Param
		.Cells(2).AddText "Description", Param
		.Cells(3).AddText "Billable", Param
		.Cells(4).AddText "Date", Param
		.Cells(5).AddText "Amount", Param
	End With

	' Set column widths
	With Table.Rows(1)
		.Cells(1).Width = 80
		.Cells(2).Width = 160
		.Cells(3).Width = 50
		.Cells(4).Width = 70
		.Cells(5).Width = 60
	End With

	
	' Populate table with data
	Set Conn = Server.CreateObject("ADODB.Connection")
	Connect = "Driver={Microsoft Access Driver (*.mdb)};DBQ=" & Server.MapPath("..\db\asppdf.mdb")
	Conn.Open Connect

	Set rs = Server.CreateObject("adodb.recordset")
	rs.Open "select * from report order by expensedate", Conn

	param.Set "expand=true" ' expand cell vertically to accomodate text

	Do While Not rs.EOF
		Set Row = Table.Rows.Add(20) ' row height
		
		param.Add "alignment=left"
		Row.Cells(1).AddText rs("Category"), param
		Row.Cells(2).AddText rs("Description"), param
		
		param.Add "alignment=center"
		If rs("Billable") Then Billable = "Yes" Else Billable = "No"
		Row.Cells(3).AddText Billable, param
		Row.Cells(4).AddText pdf.FormatDate( rs("ExpenseDate"), "%d %b %Y" ), param
		
		param.Add "alignment=right"
		Row.Cells(5).AddText pdf.FormatNumber(rs("Amount"), "precision=2, delimiter=true"), param

		rs.MoveNext
	Loop

	' Render table on document
	Set Page = Doc.Pages.Add(612, 150) ' small pages to demonstrate paging functionality
	
	Param.Clear	
	Param("x") = (Page.Width - Table.Width) / 2 ' center table on page
	Param("y") = Page.Height - 20
	Param("MaxHeight") = 100
	
	FirstRow = 2 ' use this to print record count on page
	Do While True
		' Draw table. This method returns last visible row index
		LastRow = Page.Canvas.DrawTable( Table, Param )

		' Print record numbers
		TextParam("x") = (Page.Width - Table.Width) / 2
		TextParam("y") = Page.Height - 5
		TextParam.Add("color=darkgreen")
		TextStr = "Records " & FirstRow - 1 & " to " & LastRow - 1 & " of " & Table.Rows.Count - 1
		Page.Canvas.DrawText TextStr, TextParam, doc.fonts("Courier-Bold")

		if LastRow >= Table.Rows.Count Then Exit Do ' entire table displayed

		' Display remaining part of table on the next page
		Set Page = Page.NextPage
		Param.Add( "RowTo=1; RowFrom=1" ) ' Row 1 is header - must always be present.
		Param("RowFrom1") = LastRow + 1 ' RowTo1 is omitted and presumed infinite

		FirstRow = LastRow + 1
	Loop

	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("report.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"

%>

</BODY>
</HTML>
