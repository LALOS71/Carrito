
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument(Missing.Value);

	// Add a new page
	IPdfPage objPage = objDoc.Pages.Add(Missing.Value, Missing.Value, Missing.Value);

	// Add annotation with custom appearance
	String strNotice = "This invoice was paid on June 10, 2003.";
	IPdfAnnot objAnnot = objPage.Annots.Add(strNotice, "x=10, y=600; width=182; height=131; Type=Stamp", Missing.Value, Missing.Value);

	// Create a graphics object for this annotation containing an image    
    IPdfGraphics objPaidGraph = objDoc.CreateGraphics("left=0; bottom=0; right=182; top=131");
    IPdfImage objImage = objDoc.OpenImage( Server.MapPath("paid.gif"), Missing.Value );
    objPaidGraph.Canvas.DrawImage( objImage, "x=0, y=0" );

	// Use this graphics object as the annotatoin's appearance
	objAnnot.set_Graphics(0, Missing.Value, objPaidGraph );


	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("appearance.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}





</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 10: Annotation Sample 2 (Appearance)</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
