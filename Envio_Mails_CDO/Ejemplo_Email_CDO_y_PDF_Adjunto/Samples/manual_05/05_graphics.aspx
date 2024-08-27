<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<%@ Page aspCompat="True" debug="true" %> 

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument(Missing.Value);

	// Add a new page
	IPdfPage objPage = objDoc.Pages.Add(Missing.Value, Missing.Value, Missing.Value);

	// Create a new Graphics object
	IPdfGraphics objGraphics = objDoc.CreateGraphics( "Left=0, Bottom = 0; Right=100; Top=100" );

	// Create a drawing
	objGraphics.Canvas.DrawRect( 1, 1, 99, 99 );
	objGraphics.Canvas.MoveTo( 50, 90 );
	for( int i = 0; i <= 628; i++ )
	{
		objGraphics.Canvas.LineTo( (float)(40 * Math.Sin(i / 25.0) + 50), (float)(40 * Math.Cos(i / 20.0) + 50) );
	}
	objGraphics.Canvas.Fill( Missing.Value );
	
	objGraphics.Canvas.DrawText( "AspPDF Rules!", "x=20, y=12; size=8", objDoc.Fonts["Courier", Missing.Value] );

	// Create empty Param object
	IPdfParam objParam = objPdf.CreateParam(Missing.Value);

	// Display graphics with rotation
	for(int angle = 0; angle <= 330; angle +=30 )
	{
		objParam["x"].Value = (float)(306 + 150.0 * Math.Cos( angle / 360.0 * 6.28 ) );
		objParam["y"].Value = (float)(396 + 150.0 * Math.Sin( angle / 360.0 * 6.28 ) );
		objParam["Angle"].Value = angle;
		
		objPage.Canvas.DrawGraphics( objGraphics, objParam );
	}

	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("graphics.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}
</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 5: Graphics Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
