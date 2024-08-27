<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 11: Form Fill-in Sample</TITLE>
</HEAD>
<BODY>

<P>
<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0" STYLE="font-name:arial; font-size: 14">

<FORM ACTION="11_fill.asp" METHOD="POST">

<TR><TD><B>Name</B>:</TD><TD><INPUT SIZE="40" TYPE="TEXT" NAME="Name" VALUE="<% = Request("Name") %>"></TD></TR>

<TR><TD><B>Address</B>:</TD><TD><INPUT SIZE="40" TYPE="TEXT" NAME="Address" VALUE="<% = Request("Address") %>"></TD></TR>

<tr><td colspan="2"><HR></td></tr>

<TR><TD VALIGN="TOP"><B>Marital Status</B>:</TD><TD>
	<INPUT TYPE="RADIO" NAME="Type" VALUE="1"<% If Request("Type") = "1" or Request("Type") = "" Then Response.Write " CHECKED" %>>Single<BR>
	<INPUT TYPE="RADIO" NAME="Type" VALUE="2"<% If Request("Type") = "2" Then Response.Write " CHECKED" %>>Married<BR>
	<INPUT TYPE="RADIO" NAME="Type" VALUE="3"<% If Request("Type") = "3" Then Response.Write " CHECKED" %>>Divorced<BR>
</TD></TR>

<tr><td colspan="2"><HR></td></tr>

<TR><TD VALIGN="CENTER"><B>How did you hear about us?<br>Check all that applies.</B></TD><TD>
	<TABLE BORDER=0 CELLSPACING=2 CELLPADDING=0 STYLE="font-name:arial; font-size: 12">
	<TR><TD><INPUT TYPE="CHECKBOX" NAME="Internet" VALUE="0"<% If Request("Internet") <> "" Then Response.Write " CHECKED" %>></TD><TD>Internet</TD></TR>
	<TR><TD><INPUT TYPE="CHECKBOX" NAME="WordOfMouth" VALUE="1"<% If Request("WordOfMouth") <> "" Then Response.Write " CHECKED" %>></TD><TD>Word of Mouth</TD></TR>
	<TR><TD><INPUT TYPE="CHECKBOX" NAME="Newspaper" VALUE="1"<% If Request("Newspaper") <> "" Then Response.Write " CHECKED" %>></TD><TD>Newspaper Ad</TD></TR>
	</TABLE>
</TD></TR>

<tr><td colspan="2"><HR></td></tr>

<TR><TD COLSPAN="2"><INPUT TYPE="SUBMIT" NAME="Save" VALUE="Generate PDF"></TD></TR>

</FORM>
</TABLE><P>

<%
	If Request("Save") <> "" Then

		Set PDF = Server.CreateObject("Persits.PDF")

		' Open an existing form
		Set Doc = PDF.OpenDocument( Server.MapPath( "SimpleForm.pdf" ) )

		' Create font object
		Set Font = Doc.Fonts("Helvetica-Bold")

		' Remove XFA support from it
		Doc.Form.RemoveXFA

		' Fill in Name
		Set field = Doc.Form.FindField("form1[0].#subform[0].Name[0]")
		field.SetFieldValue Request("Name"), Font

		' Fill in Address
		Set field = Doc.Form.FindField("form1[0].#subform[0].Address[0]")
		field.SetFieldValue Request("Address"), Font
		
		' Fill in marital status
		Set field = Doc.Form.FindField("form1[0].#subform[0].RadioButtonList[0]")
		Set ChildField = field.Children( Request("Type") )
		ChildField.SetFieldValue ChildField.FieldOnValue, Nothing

		' Fill in "How did you hear about us" checkboxes
		If Request("Internet") <> "" Then
			Set field = Doc.Form.FindField("form1[0].#subform[0].Internet[0]")
			field.SetFieldValue field.FieldOnValue, Nothing
		End if

		If Request("WordOfMouth") <> "" Then
			Set field = Doc.Form.FindField("form1[0].#subform[0].WordOfMouth[0]")
			field.SetFieldValue field.FieldOnValue, Nothing
		End if

		If Request("Newspaper") <> "" Then
			Set field = Doc.Form.FindField("form1[0].#subform[0].Newspaper[0]")
			field.SetFieldValue field.FieldOnValue, Nothing
		End if

		'Save document
		Path = Server.MapPath( "filledform.pdf")
		FileName = Doc.Save( Path, false)

		Response.Write "Success! Download your PDF file <A TARGET=""_new"" HREF=" & Filename & ">here</A>"
		
		Set Doc = Nothing
		Set Pdf = Nothing

	End If
%>

</BODY>
</HTML>
