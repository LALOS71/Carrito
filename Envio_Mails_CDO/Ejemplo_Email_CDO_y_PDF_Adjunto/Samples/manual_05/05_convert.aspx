<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument(Missing.Value);

	// Open image from file
	IPdfImage objImage = objDoc.OpenImage(Server.MapPath( "atlanticocean.tif" ), Missing.Value );

	// Add empty page. Page size is based on resolution and size of image
	float fWidth = objImage.Width * 72.0f / objImage.ResolutionX;
	float fHeight = objImage.Height * 72.0f / objImage.ResolutionY;
	IPdfPage objPage = objDoc.Pages.Add( fWidth, fHeight, Missing.Value );

	// Draw image
	objPage.Canvas.DrawImage( objImage, "x=0, y=0" );

	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("convert.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A TARGET=\"_new\" HREF=" + strFilename + ">here</A>";
}
</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 5: Image -> PDF Conversion Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>