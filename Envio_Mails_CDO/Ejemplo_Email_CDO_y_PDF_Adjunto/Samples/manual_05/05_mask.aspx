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

	// Add a new page
	IPdfPage objPage = objDoc.Pages.Add(Missing.Value, Missing.Value, Missing.Value);

	// Draw something
	objPage.Canvas.SetParams( "LineWidth=5; Color=red;" );
	objPage.Canvas.DrawLine( 0, 792, 600, 0 );

	// Open image to become the mask. This has to be a monochrome bitmap
	IPdfImage objImageMask = objDoc.OpenImage( Server.MapPath( "exclam.bmp"), Missing.Value );
	objImageMask.IsMask = true;	// Mark this image object as a mask

	// Open image to be masked
	IPdfImage objImage = objDoc.OpenImage( Server.MapPath( "exclam.gif"), Missing.Value );
	objImage.SetImageMask( objImageMask );

	// Draw masked image
	objPage.Canvas.DrawImage( objImage, "x=10, y=550" );

	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("mask.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}
</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 5: Masking Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
