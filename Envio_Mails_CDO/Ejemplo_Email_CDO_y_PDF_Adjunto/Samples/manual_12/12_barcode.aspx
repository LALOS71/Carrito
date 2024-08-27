
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument(Missing.Value);

	// Set various document properties
	objDoc.Title = "AspPDF Barcode Sample";

	// Add a new page
	IPdfPage objPage = objDoc.Pages.Add(Missing.Value, Missing.Value, Missing.Value);

	// Param string
	String strParams = "x=72; y=600; height=96; width=144; type=1";  //Barcode type 1 is UPC-A	
	String strData = "04310070524";

	// Draw text on page
	objPage.Canvas.DrawBarcode( strData, strParams );

	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("Barcode.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}


</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 12: Barcode Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
