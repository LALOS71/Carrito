
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

	IPdfFont objFont = objDoc.Fonts["Helvetica", Missing.Value];

	// Credit card type radio button group
	objPage.Canvas.DrawText( "Credit card type:", "x=10; y=735", objFont );
	
	IPdfAnnot objCCGroup = objPage.CreateRadiobutton("CCType", "Amex", "x=0, y=0, width=0; height=0; NoToggleToOff=true;", null );
	
	// this option is selected by default.
	IPdfAnnot objAmex = objPage.CreateRadiobutton("CCType", "Amex", "x=100;y=723;width=40; height=10; state=1", objCCGroup );
	objPage.Canvas.DrawText( "Amex", "x=113; y=735", objFont );
	
	IPdfAnnot objVisa = objPage.CreateRadiobutton("CCType", "Visa", "x=150;y=723;width=35; height=10", objCCGroup );
	objPage.Canvas.DrawText( "Visa", "x=163; y=735", objFont );
	
	IPdfAnnot objMC = objPage.CreateRadiobutton("CCType", "MC", "x=200;y=723;width=30; height=10;", objCCGroup );
	objPage.Canvas.DrawText( "MC", "x=213; y=735;", objFont );

	// Credit card number textbox
	objPage.Canvas.DrawText( "Credit card number:", "x=10; y=715", objFont );
	IPdfAnnot objCCNumber = objPage.CreateTextbox( "CCNumber", "", "x=100; y=700; width=200; height=17; Border=1", objFont, null );

	// Expiration: two drop-down boxes
	objPage.Canvas.DrawText( "Expires:", "x=10; y=695", objFont );
	String strMonthOptions = "Jan##Feb##Mar##Apr##May##Jun##Jul##Aug##Sep##Oct##Nov##Dec";
	IPdfAnnot objCCMonth = objPage.CreateChoice( "CCMonth", strMonthOptions, objPdf.FormatDate(DateTime.Now, "%b"), "x=100; y=680; width=50; height=17; Combo=true;Border=1", objFont, null );

	String strYearOptions = "";
	for( int y = DateTime.Now.Year; y <= DateTime.Now.Year + 10; y++ )
	{
		strYearOptions += y.ToString() + "##";
	}

	IPdfAnnot objCCYear = objPage.CreateChoice( "CCYear", strYearOptions, DateTime.Now.Year.ToString(), "x=155; y=680; width=50; height=17; Combo=true;Border=1", objFont, null );

	// Create checkbox for "need receipt"
	objPage.Canvas.DrawText( "Need receipt?", "x=10; y=675;", objFont );
	IPdfAnnot objReceipt = objPage.CreateCheckbox( "Receipt", "x=100; y=660; width=15; height=15", null );

	// Create Submit and Reset buttons, assign submit and reset actions to them.
	IPdfAnnot objSubmitButton = objPage.CreatePushbutton("CCSubmit", "Submit Form", "x=10; y=625; width=70; height=20", objFont, null);
	objSubmitButton.SetAction( objDoc.CreateAction("Type=Submit; Html=true", "http://localhost/asppdf/manual_11/11_submit.asp" ) );

	IPdfAnnot objResetButton = objPage.CreatePushbutton("CCReset", "Reset Form", "x=85; y=625; width=70; height=20", objFont, null);
	objResetButton.SetAction( objDoc.CreateAction("Type=Reset", "") );


	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("form.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}


</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 11: Form Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
