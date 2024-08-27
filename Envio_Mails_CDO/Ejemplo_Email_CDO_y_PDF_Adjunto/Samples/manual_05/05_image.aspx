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

	// Open image
	IPdfImage objImage = objDoc.OpenImage( Server.MapPath( "painting.jpg"), Missing.Value );

	// Create empty param object
	IPdfParam objParam = objPdf.CreateParam(Missing.Value);

	for( int i = 1; i <=3; i++ )
	{
		objParam["x"].Value = (objPage.Width - objImage.Width / i) / 2.0f;
		objParam["y"].Value = objPage.Height - objImage.Height * i / 2.0f - 200;
		objParam["ScaleX"].Value = 1.0f / i;
		objParam["ScaleY"].Value = 1.0f / i;
		objPage.Canvas.DrawImage( objImage, objParam );
	}

	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("image.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}
</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 5: Image Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
