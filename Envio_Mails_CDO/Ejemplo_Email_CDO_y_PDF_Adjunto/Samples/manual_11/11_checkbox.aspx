
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument(Missing.Value);

	IPdfPage objPage = objDoc.Pages.Add( Missing.Value, Missing.Value, Missing.Value );

	// Draw gray background
	objPage.Canvas.SetFillColor( .64f, .78f, .66f );
	objPage.Canvas.FillRect( 0, 0, objPage.Width, objPage.Height );

	IPdfAnnot objCheckbox = objPage.CreateCheckbox( "Receipt", "x=100; y=660; width=30; height=30", null );

	IPdfGraphics objGrayBack = objDoc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30");
	objGrayBack.Canvas.SetFillColor( .5f, .5f, .5f );
	objGrayBack.Canvas.FillRect( 0, 0, 30, 30 );

	IPdfGraphics objWhiteBack = objDoc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30");
	objWhiteBack.Canvas.SetFillColor( 1, 1, 1 );
	objWhiteBack.Canvas.FillRect( 0, 0, 30, 30 );

	IPdfGraphics objLiteBack = objDoc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30");
	objLiteBack.Canvas.SetFillColor( .82f, .82f, .1f );
	objLiteBack.Canvas.FillRect( 0, 0, 30, 30 );

	IPdfGraphics objOutline = objDoc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30");
	float LineWidth = 3;

	objOutline.Canvas.SetColor( .35f, .6f, .39f );
	objOutline.Canvas.LineWidth = LineWidth;
	objOutline.Canvas.MoveTo( LineWidth /2, LineWidth /2 );
	objOutline.Canvas.LineTo( LineWidth /2, 30 - LineWidth /2 );
	objOutline.Canvas.LineTo( 30 - LineWidth /2, 30 - LineWidth /2 );
	objOutline.Canvas.Stroke();

	objOutline.Canvas.SetColor( .82f, .89f, .83f );
	objOutline.Canvas.MoveTo( 0, LineWidth / 2 );
	objOutline.Canvas.LineTo( 30 - LineWidth / 2, LineWidth / 2 );
	objOutline.Canvas.LineTo( 30 - LineWidth / 2, 30 );
	objOutline.Canvas.Stroke();

	objOutline.Canvas.SetColor( .64f, .78f, .66f );
	objOutline.Canvas.MoveTo( LineWidth, 3 * LineWidth / 2 );
	objOutline.Canvas.LineTo( 30 - 3 * LineWidth / 2, 3 * LineWidth / 2 );
	objOutline.Canvas.LineTo( 30 - 3 * LineWidth / 2, 30 - LineWidth );
	objOutline.Canvas.Stroke();

	objOutline.Canvas.SetColor( 0, 0, 0 );
	objOutline.Canvas.MoveTo( 3 * LineWidth /2, 4 * LineWidth /2 );
	objOutline.Canvas.LineTo( 3 * LineWidth /2, 30 - 3 * LineWidth /2 );
	objOutline.Canvas.LineTo( 30 - 4 * LineWidth /2, 30 - 3 * LineWidth /2 );
	objOutline.Canvas.Stroke();

	objGrayBack.Canvas.DrawGraphics( objOutline, "x=0, y=0" );
	objWhiteBack.Canvas.DrawGraphics( objOutline, "x=0, y=0" );
	objLiteBack.Canvas.DrawGraphics( objOutline, "x=0, y=0" );

	objCheckbox.set_Graphics(0, "Off", objWhiteBack );
	objCheckbox.set_Graphics(1, "Off", objLiteBack );
	objCheckbox.set_Graphics(2, "Off", objGrayBack );

	IPdfFont objFont = objDoc.Fonts["ZapfDingbats", Missing.Value];

	IPdfGraphics objGrayBackChecked = objDoc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30");
	objGrayBackChecked.Canvas.DrawGraphics( objGrayBack, "x=0, y=0" );
	objGrayBackChecked.Canvas.DrawText( "8", "x=8,y=28,size=20", objFont );

	IPdfGraphics objWhiteBackChecked = objDoc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30");
	objWhiteBackChecked.Canvas.DrawGraphics( objWhiteBack, "x=0, y=0" );
	objWhiteBackChecked.Canvas.DrawText( "8", "x=8,y=28,size=20", objFont );
	
	IPdfGraphics objLiteBackChecked = objDoc.CreateGraphics("Left=0; Right=30; Bottom=0; Top=30");
	objLiteBackChecked.Canvas.DrawGraphics( objLiteBack, "x=0, y=0" );
	objLiteBackChecked.Canvas.DrawText( "8", "x=8,y=28,size=20", objFont );

	objCheckbox.set_Graphics(0, "Yes", objWhiteBackChecked );
	objCheckbox.set_Graphics(1, "Yes", objLiteBackChecked );
	objCheckbox.set_Graphics(2, "Yes", objGrayBackChecked );


	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("form.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}


</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 11: Checkbox Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
