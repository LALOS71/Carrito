<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<%@ Page aspCompat="True" debug=true %> 

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument(Missing.Value);

	// Add a new page
	IPdfPage objPage = objDoc.Pages.Add(Missing.Value, Missing.Value, Missing.Value);

	// Select one of the standard PDF fonts
	IPdfFont objFont = objDoc.Fonts["Helvetica", Missing.Value];

	// vertical grid
	for( float x = 0; x < objPage.Width; x += objPage.Width / 20 )
	{
		objPage.Canvas.DrawLine( x, 0, x, objPage.Height );
		objPage.Canvas.DrawText( x.ToString(), "angle=90;y=5;x=" + x.ToString(), objFont );
	}

	// horizontal grid
	for( float y = 0; y <= objPage.Height; y += objPage.Height / 20 )
	{
		objPage.Canvas.DrawLine( 0, y, objPage.Width, y );
		objPage.Canvas.DrawText( y.ToString(), "x=5;y=" + y.ToString(), objFont );
	}

	// Create destination based on URL param
	IPdfParam objParam = objPdf.CreateParam( Missing.Value );
	
	if( Request["FitV"] != null )
	{
		objParam["FitV"].Value	= 1; // true
		objParam["Left"].Value	= float.Parse(Request["Left"]);
	}

	if( Request["FitH"] != null )
	{
		objParam["FitH"].Value	= 1;
		objParam["Top"].Value	= float.Parse(Request["Top"]);
	}

	if( Request["XYZ"] != null )
	{
		objParam["XYZ"].Value	= 1;
		objParam["Top"].Value	= float.Parse(Request["Top"]);
		objParam["Left"].Value	= float.Parse(Request["Left"]);
		objParam["Zoom"].Value	= float.Parse(Request["Zoom"]);
	}

	IPdfDest objDest = objPage.CreateDest( objParam );

	// Assign destination to Doc's OpenAction
	objDoc.OpenAction = objDest;


	// Save document to HTTP stream
	objDoc.SaveHttp( "attachment;filename=destdemo.pdf", Missing.Value );
}
</script>
