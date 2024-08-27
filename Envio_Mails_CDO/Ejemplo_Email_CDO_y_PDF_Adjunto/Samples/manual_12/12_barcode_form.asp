<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 12: Barcode Sample 2</TITLE>
</HEAD>
<BODY style="font-family: arial; font-size: 12;">

<form action="" METHOD="POST" NAME="MyForm">
<TABLE WIDTH="640" style="font-family: arial; font-size: 12;">
<TR><TD colspan=2>
Enter data and click on the "Generate PDF" button to view a barcode in a PDF file.
</TD></TR>
<tr><td>Barcode Type:</td>
<td><SELECT name="Type">
<%
sSelect = "<OPTION value=1>UPC-A (numeric)<OPTION value=11>Industrial 2/5 (numeric)<OPTION value=17>Code-39 (text)"

iType = request("type")
if iType > 0 then
	sSelect = Replace(sSelect, "=" & iType & ">", "=" & iType & " SELECTED>")
end if

Response.Write sSelect
%>
</select></td></tr>
<tr><td>Barcode Data:</td>
<td><input type="text" name="Data" value="<% if Request("Data") = "" then Response.Write "00123456789" else Response.Write request("data") %>" size=30>
</td></tr>

<tr><td>Color:</td>
<td><select name="color">
<%
dim aColors
aColors = Array("", "Black", "Blue", "Brown", "Cyan", "Green", "Gray", "Red", "Magenta", "Yellow")

for i = 1 to 9
	Response.Write "<OPTION value=""" & aColors(i) & """"
	if Request("color") = aColors(i) then Response.Write " SELECTED"
	Response.Write ">" & aColors(i)
next

%>
</select></td></tr>

<tr><td>Barcode Size:</td>
<td>
<INPUT TYPE="Radio" NAME="Size" VALUE="72" <% if Request("Size") = 72 or request("size") = "" Then Response.write "CHECKED" %>> Small (1 inch)
<INPUT TYPE="Radio" NAME="Size" VALUE="144" <% if Request("Size") = 144 Then Response.write "CHECKED" %>> Medium (2 inches)
<INPUT TYPE="Radio" NAME="Size" VALUE="288" <% if Request("Size") = 288 Then Response.write "CHECKED" %>> Large (4 inches)
</td></tr>
<tr><td>
<INPUT TYPE="submit" name="Save" Value="Generate PDF">
</td></tr>
</table></form>

<%
	if Request("Save") <> "" Then

		Set Pdf = Server.CreateObject("Persits.Pdf")
		Set Doc = Pdf.CreateDocument
		Set Page = Doc.Pages.Add
		Set Canvas = Page.Canvas
		Set Param = Pdf.CreateParam

		Param("x") = 72
		Param("y") = 72 * 10 - Request("size") + 1
		Param("height") = Request("size") * 2/3
		Param("width") = Request("size")
		Param("type") = Request("type")
		Param.Add "color=" & Request("color")

		on error resume next
		Canvas.DrawBarcode Request("Data"), Param
		on error goto 0
		if Err.number > 0 then
			Response.Write "<b><font color=""red"">Error: </font>" & Err.Description & "</b>"
		Else

			Filename = Doc.Save( Server.MapPath("Barcode.pdf"), False )

			Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"
		end if
		
		Set Canvas = Nothing
		Set Page = Nothing
		Set Doc = Nothing
		Set Pdf = Nothing

	End If
%>

</BODY>
</HTML>