<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 11: Form Sample</TITLE>
</HEAD>
<BODY>


<%

	Set Pdf = Server.CreateObject("Persits.Pdf")
	Set Doc = Pdf.CreateDocument

	Set Page = Doc.Pages.Add

	Set Font = Doc.Fonts("Helvetica")

	' Credit card type radio button group
	Page.Canvas.DrawText "Credit card type:", "x=10; y=735;", Font
	
	Set CCGroup = Page.CreateRadiobutton("CCType", "Amex", "x=0, y=0, width=0; height=0; NoToggleToOff=true;", Nothing )
	
	' this option is selected by default.
	Set Amex = Page.CreateRadiobutton("CCType", "Amex", "x=100;y=723;width=40; height=10; state=1", CCGroup )
	Page.Canvas.DrawText "Amex", "x=113; y=735;", Font
	
	Set Visa = Page.CreateRadiobutton("CCType", "Visa", "x=150;y=723;width=35; height=10", CCGroup )
	Page.Canvas.DrawText "Visa", "x=163; y=735;", Font
	
	Set MC = Page.CreateRadiobutton("CCType", "MC", "x=200;y=723;width=30; height=10;", CCGroup )
	Page.Canvas.DrawText "MC", "x=213; y=735;", Font

	' Credit card number textbox
	Page.Canvas.DrawText "Credit card number:", "x=10; y=715;", Font
	Set CCNumber = Page.CreateTextbox( "CCNumber", "", "x=100; y=700; width=200; height=17; Border=1", Font, Nothing )

	' Expiration: two drop-down boxes
	Page.Canvas.DrawText "Expires:", "x=10; y=695;", Font
	MonthOptions = "Jan##Feb##Mar##Apr##May##Jun##Jul##Aug##Sep##Oct##Nov##Dec"
	Set CCMonth = Page.CreateChoice( "CCMonth", MonthOptions, Pdf.FormatDate(Now, "%b"), "x=100; y=680; width=50; height=17; Combo=true;Border=1", Font, Nothing )

	YearOptions = ""
	For y = Year(Now) to Year(Now) + 10
		YearOptions = YearOptions & y & "##"
	Next

	Set CCYear = Page.CreateChoice( "CCYear", YearOptions, Pdf.FormatDate(Now, "%Y"), "x=155; y=680; width=50; height=17; Combo=true;Border=1", Font, Nothing )

	' Create checkbox for "need receipt"
	Page.Canvas.DrawText "Need receipt?", "x=10; y=675;", Font
	Set Receipt = Page.CreateCheckbox( "Receipt", "x=100; y=660; width=15; height=15", Nothing )

	' Create Submit and Reset buttons, assign submit and reset actions to them.
	Set SubmitButton = Page.CreatePushbutton("CCSubmit", "Submit Form", "x=10; y=625; width=70; height=20", Font, Nothing)
	SubmitButton.SetAction Doc.CreateAction("Type=Submit; Html=true", "http://localhost/asppdf/manual_11/11_submit.asp" )

	Set ResetButton = Page.CreatePushbutton("CCReset", "Reset Form", "x=85; y=625; width=70; height=20", Font, Nothing)
	ResetButton.SetAction Doc.CreateAction("Type=Reset", "")

	Filename = Doc.Save( Server.MapPath("form.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"

%>

</BODY>
</HTML>
