<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 6: Text Sample</TITLE>
</HEAD>
<BODY>


<form action="06_text.asp" METHOD="POST">
<B>Enter text:</B><BR>
<textarea name="largetext" cols="80" rows="16"><% = Request("largetext") %>
</textarea><BR>

<INPUT TYPE="submit" name="Save" Value="Generate PDF">
</form>

<%
	if Request("Save") <> "" Then

		Set Pdf = Server.CreateObject("Persits.Pdf")

		Set Doc = Pdf.CreateDocument

		' Small pages - to demonstrate text spanning
		Set page = Doc.Pages.Add( 216, 216 )

		' Use Times-Roman font
		Set Font = Doc.Fonts("Times-Roman")
    
		Text = Request("largetext")
		
		' Parameters: X, Y of upper-left corner of text box, Height, Width
		Set param = pdf.CreateParam("x=10;y=206;height=196;width=196; size=30;")
	    
		Do While Len(Text) > 0	
			CharsPrinted = Page.Canvas.DrawText(Text, param, Font )

			' We printed the entire string. Exit loop.
			if CharsPrinted = Len(Text) Then Exit Do

			' Otherwise print remaining text on next page
			Set Page = Page.NextPage

			Text = Right( Text, Len(Text) - CharsPrinted)
		Loop

		' Save document, the Save method returns generated file name
		Filename = Doc.Save( Server.MapPath("text.pdf"), False )

		Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"

	End If
%>

</BODY>
</HTML>
