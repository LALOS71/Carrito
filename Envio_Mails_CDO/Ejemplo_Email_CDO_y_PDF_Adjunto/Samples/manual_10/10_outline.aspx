
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument(Missing.Value);

	// Add new pages
	IPdfPage objPage1 = objDoc.Pages.Add(Missing.Value, Missing.Value, Missing.Value);
	IPdfPage objPage2 = objDoc.Pages.Add(Missing.Value, Missing.Value, Missing.Value);

	// Make document fit window and show outlines
	objDoc.OpenAction = objPage1.CreateDest(Missing.Value);
	objDoc.PageMode = pdfPageMode.pdfUseOutlines;


	// Select one of the standard PDF fonts
	IPdfFont objFont = objDoc.Fonts["Helvetica", Missing.Value];

	// Param string
	String strParams = "x=0; y=650; width=612; alignment=center; size=50";
	
	// Draw text on page
	objPage1.Canvas.DrawText( "Page 1", strParams, objFont );
	objPage2.Canvas.DrawText( "Page 2", strParams, objFont );

	// Build outline hierarchy
	IPdfOutline objOutline = objDoc.Outline;
	IPdfOutlineItem objTitle = objOutline.Add("User Manual", null, null, null, "Bold=true");
	
	IPdfOutlineItem objChapter1 = objOutline.Add("Chapter 1", objPage1.CreateDest(Missing.Value), objTitle, null, "Bold=true; Italic=true");
	IPdfOutlineItem objSection11 = objOutline.Add("Section 1.1", objPage1.CreateDest("XYZ=true;Zoom=2;Top=300"), objChapter1, null, Missing.Value );
	
	IPdfOutlineItem objChapter2 = objOutline.Add("Chapter 2", objPage2.CreateDest(Missing.Value), objTitle, null, "Bold=true; Italic=true");
	IPdfOutlineItem objSection21 = objOutline.Add("Section 2.1", objPage2.CreateDest("XYZ=true;Zoom=2;Top=500"), objChapter2, null, Missing.Value );
	IPdfOutlineItem objSection22 = objOutline.Add("Section 2.2", objPage2.CreateDest("XYZ=true;Zoom=2;Top=200"), objChapter2, null, Missing.Value );

	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("outline.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}





</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 10: Outline Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
