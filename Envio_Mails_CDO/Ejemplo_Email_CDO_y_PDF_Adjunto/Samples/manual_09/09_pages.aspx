
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Open blank PDF form from file
	IPdfDocument objDoc = objPdf.OpenDocument( Server.MapPath("TwoPageDoc.pdf"), Missing.Value );

	// insert page before 1st
	IPdfPage objPage1 = objDoc.Pages.Add(Missing.Value, Missing.Value, 1);

	// insert page after 2nd
	IPdfPage objPage2 = objDoc.Pages.Add(Missing.Value, Missing.Value, 3);

	// Remove page 4 (page 2 in original doc)
	objDoc.Pages.Remove( 4 );

	// Draw background image on all 3 remaining pages
	IPdfImage objImage = objDoc.OpenImage( Server.MapPath("exclam.gif"), Missing.Value );

	foreach( IPdfPage objPage in objDoc.Pages )
	{
		objPage.Background.DrawImage( objImage, "x=70, y=220; scalex=2; scaley=2" );
	}

	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("pages.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
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
