
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Open a PDF file for text extraction
	IPdfDocument objDoc = objPdf.OpenDocument( Server.MapPath("1040es.pdf"), Missing.Value );

	String strText = "";

	foreach( IPdfPage objPage in objDoc.Pages )
	{
		strText += objPage.ExtractText(Missing.Value);
	}

	lblResult.Text = Server.HtmlEncode( strText );
}





</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 9: Page Management Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
