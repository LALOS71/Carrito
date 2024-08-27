<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	// create instance of the PDF manager
	IPdfManager objPDF = new PdfManager();

	// Create new document
	IPdfDocument objDoc = objPDF.CreateDocument(Missing.Value);

	// Add a page to document. Pages are intentionally small to demonstrate text spanning
	IPdfPage objPage = objDoc.Pages.Add(300, 300, Missing.Value);
    
	// use Arial font
	IPdfFont objFont = objDoc.Fonts["Arial", Missing.Value];

	String strText = objPDF.LoadTextFromFile( Server.MapPath("html.txt") );
	
	// Parameters: X, Y of upper-left corner of text box, Height, Width
	IPdfParam objParam = objPDF.CreateParam("x=10; y=290; width=280; height=280; html=true");
	
	while( strText.Length > 0 )
	{
		// DrawText returns the number of characters that fit in the box allocated.
		int nCharsPrinted = objPage.Canvas.DrawText( strText, objParam, objFont );

		// HTML tag generated by DrawText to reflect current font state
		String strHtmlTag = objPage.Canvas.HtmlTag;

		// The entire string printed? Exit loop.
		if( nCharsPrinted == strText.Length )
			break;

		// Otherwise print remaining text on next page
		objPage = objPage.NextPage;

		strText = strHtmlTag + strText.Substring( nCharsPrinted );
	}

	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("mask.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}


</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 6: HTML Support Sample</TITLE>
</HEAD>
<BODY>

<form runat="server">
<ASP:Label ID="lblResult" runat="server"/>
</form>

</BODY>
</HTML>
