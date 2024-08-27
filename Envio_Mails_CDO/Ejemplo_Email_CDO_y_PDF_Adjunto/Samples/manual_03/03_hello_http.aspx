<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<%@ Page aspCompat="True" %> 

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument(Missing.Value);

	// Set various document properties
	objDoc.Title = "AspPDF Chapter 3 Hello World Sample";
	objDoc.Creator = "John Smith";

	// Add a new page
	IPdfPage objPage = objDoc.Pages.Add(Missing.Value, Missing.Value, Missing.Value);

	// Select one of the standard PDF fonts
	IPdfFont objFont = objDoc.Fonts["Helvetica", Missing.Value];

	// Param string
	String strParams = "x=0; y=650; width=612; alignment=center; size=50";
	
	// Draw text on page
	objPage.Canvas.DrawText( "Hello World!", strParams, objFont );

	// Save document to HTTP stream
	objDoc.SaveHttp( "attachment;filename=hello.pdf", Missing.Value );
}
</script>
