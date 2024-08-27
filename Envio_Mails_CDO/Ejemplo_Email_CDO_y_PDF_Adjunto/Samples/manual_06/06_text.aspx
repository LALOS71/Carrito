<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

public void GeneratePDF(object sender, System.EventArgs args)
{
	// create instance of the PDF manager
	IPdfManager objPDF = new PdfManager();

	// Create new document
	IPdfDocument objDoc = objPDF.CreateDocument(Missing.Value);

	// Add a page to document. Pages are intentionally small to demonstrate text spanning
	IPdfPage objPage = objDoc.Pages.Add(216, 216, Missing.Value);
    
	// use Times-Roman font
	IPdfFont objFont = objDoc.Fonts["Times-Roman", Missing.Value];

	String strText = txtLargeText.Text;
	
	// Parameters: X, Y of upper-left corner of text box, Height, Width
	IPdfParam objParam = objPDF.CreateParam("x=10;y=206;height=196;width=196; size=30;");
	
	while( strText.Length > 0 )
	{
		// DrawText returns the number of characters that fit in the box allocated.
		int nCharsPrinted = objPage.Canvas.DrawText( strText, objParam, objFont );

		// The entire string printed? Exit loop.
		if( nCharsPrinted == strText.Length )
			break;

		// Otherwise print remaining text on next page
		objPage = objPage.NextPage;

		strText = strText.Substring( nCharsPrinted );
	}

	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("mask.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}


</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 6: Text Sample</TITLE>
</HEAD>
<BODY>

<form runat="server">
<B>Enter text:</B><BR>
<ASP:TextBox runat="server" id="txtLargeText" cols="80" rows="16" TextMode="1"/><BR>

<ASP:Button runat="server" id="Save" name="Save" OnClick="GeneratePDF" Text="Generate PDF"/>
</form>
<P>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
