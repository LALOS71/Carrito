
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	int [] arrX = {100, 325, 455, 512, 550, 100, 100};
	int [] arrY = {660, 660, 660, 687, 687, 602, 577};
	String [] arrText = {"John A.", "Smith", "123-56-7890", "1,234",
		 "00", "4300 Cherry Ln.", "New York, NY 10001"};

	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.OpenDocument(Server.MapPath("1040es.pdf"), Missing.Value);

	// Select one of the standard PDF fonts
	IPdfFont objFont = objDoc.Fonts["Helvetica-Bold", Missing.Value];

	// Obtain the only page's canvas
	IPdfCanvas objCanvas = objDoc.Pages[1].Canvas;

	// Create empty param object
	IPdfParam objParam = objPdf.CreateParam( Missing.Value );

	// Fill out three copies of the 1040ES coupon
	for( int i = 0; i < 3; i++ )
	{
		// Go over all items in arrays
		for( int j = 0; j < arrX.Length; j++ )
		{
			objParam["x"].Value = arrX[j];
			objParam["y"].Value = arrY[j] - 263 * i;

			// Draw text on canvas
			objCanvas.DrawText( arrText[j], objParam, objFont );
		}
	}


	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("form.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}

</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 9: Form Fill-Out Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
