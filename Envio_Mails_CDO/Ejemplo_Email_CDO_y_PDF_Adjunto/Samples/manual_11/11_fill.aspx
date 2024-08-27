<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script LANGUAGE="JavaScript">

</script>


<script runat="server" LANGUAGE="C#">


public void GeneratePDF(object sender, System.EventArgs args)
{
	// create instance of the PDF manager
	IPdfManager objPDF;
	objPDF = new PdfManager();

	// Open existing form
	IPdfDocument objDoc = objPDF.OpenDocument( Server.MapPath( "SimpleForm.pdf" ), Missing.Value );

    
	IPdfFont objFont = objDoc.Fonts["Helvetica-Bold", Missing.Value]; // a standard font

	// Remove XFA support from it
	objDoc.Form.RemoveXFA();

	// Fill in Name
	IPdfAnnot objField = objDoc.Form.FindField("form1[0].#subform[0].Name[0]");
	objField.SetFieldValue( txtName.Text, objFont );

	// Fill in Address
	objField = objDoc.Form.FindField("form1[0].#subform[0].Address[0]");
	objField.SetFieldValue( txtAddress.Text, objFont );
	
	// Fill in marital status
	int nIndex = 1; 
	if( rdMarried.Checked )
		nIndex = 2;

	if( rdDivorced.Checked )
		nIndex = 3;

	objField = objDoc.Form.FindField("form1[0].#subform[0].RadioButtonList[0]");
	IPdfAnnot objChildField = objField.Children[nIndex];
	objChildField.SetFieldValue( objChildField.FieldOnValue, null );

	// Fill in "How did you hear about us" checkboxes
	if( chkInternet.Checked )
	{
		objField = objDoc.Form.FindField("form1[0].#subform[0].Internet[0]");
		objField.SetFieldValue( objField.FieldOnValue, null );
	}

	if( chkWordOfMouth.Checked )
	{
		objField = objDoc.Form.FindField("form1[0].#subform[0].WordOfMouth[0]");
		objField.SetFieldValue( objField.FieldOnValue, null );
	}

	if( chkNewspaper.Checked )
	{
		objField = objDoc.Form.FindField("form1[0].#subform[0].Newspaper[0]");
		objField.SetFieldValue( objField.FieldOnValue, null );
	}
	

	String strFileName = objDoc.Save( Server.MapPath( "filledform.pdf"), false );

	lblResult.Text = "Success. Your PDF file <font color=gray>" + strFileName + "</font> can be downloaded <A TARGET=\"_new\" HREF=\"" + strFileName + "\"><B>here</B></A>.";
}

</script>

<HTML>
<HEAD>
<TITLE>AspPDF Form Fill-out Demo</TITLE>
</HEAD>
<BODY>

<TABLE WIDTH="640"><TR><TD>
<FONT FACE="Arial" SIZE="2">

<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0" STYLE="font-name:arial; font-size: 12">

<FORM ID="Form" ACTION="11_fill.aspx" runat="server" METHOD="POST">





<TR><TD><B>Name</B>:</TD><TD><ASP:TextBox SIZE="40" TYPE="TEXT" ID="txtName" NAME="Name" runat="server"/></TD></TR>
<TR><TD><B>Address</B>:</TD><TD><ASP:TextBox SIZE="40" TYPE="TEXT" ID="txtAddress" NAME="Address" runat="server"/></TD></TR>

<tr><td colspan="2"><HR></td></tr>

<TR><TD VALIGN="TOP"><B>Marital Status</B>:</TD><TD>
	<ASP:RadioButton ID="rdSingle" VALUE="1" GroupName="gType" runat="server"/>Single<BR>
	<ASP:RadioButton ID="rdMarried" VALUE="2" GroupName="gType" runat="server"/>Married<BR>
	<ASP:RadioButton ID="rdDivorced" VALUE="3" GroupName="gType" runat="server"/>Divorced<BR>
</TD></TR>

<tr><td colspan="2"><HR></td></tr>






<TR><TD VALIGN="CENTER"><B>How did you hear about us?<br>Check all that applies.</B></TD><TD>
	<TABLE BORDER=0 CELLSPACING=2 CELLPADDING=0 STYLE="font-name:arial; font-size: 12">
	<TR><TD><ASP:CheckBox ID="chkInternet" runat="server"/></TD><TD>Internet</TD></TR>
	<TR><TD><ASP:CheckBox ID="chkWordOfMouth" runat="server"/></TD><TD>Word of Mouth</TD></TR>
	<TR><TD><ASP:CheckBox ID="chkNewspaper" runat="server"/></TD><TD>Newspaper Ad</TD></TR>
	</TABLE>
</TD></TR>

<tr><td colspan="2"><HR></td></tr>


<TR><TD COLSPAN="2"><ASP:Button OnClick="GeneratePDF" ID="btnSave" Text="Generate PDF" runat="server"/></TD></TR>

<TR><TD COLSPAN="2">&nbsp;</TD></TR>

<TR><TD COLSPAN="2"><B><ASP:Label ID="lblResult" runat="server"/></B></TD></TR>

</FORM>
</TABLE>


</FONT>
</TABLE
>
</BODY>
</HTML>
