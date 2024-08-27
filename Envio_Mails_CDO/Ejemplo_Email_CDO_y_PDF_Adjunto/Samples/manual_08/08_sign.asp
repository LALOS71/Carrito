<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 8: Digital Signing Sample</TITLE>
</HEAD>
<BODY>

<!-- This code sample requires AspEncrypt V. 2.2.0.2 (www.aspencrypt.com) -->

<!--METADATA TYPE="TypeLib" UUID="{414FEE4B-2879-4090-957E-423567FFCFC6}"-->



<%
	Set Pdf = Server.CreateObject("Persits.Pdf")

	' Create empty document
	Set Doc = Pdf.CreateDocument

	' Set various document properties
	Doc.Title = "AspPDF Chapter 3 Hello World Sample"
	Doc.Creator = "John Smith"

	' Add a new page
	Set Page = Doc.Pages.Add

	' Select one of the standard PDF fonts
	Set Font = Doc.Fonts("Helvetica")

	' Param string
	Params = "x=0; y=650; width=612; alignment=center; size=50"

	' Draw text on page
	Page.Canvas.DrawText "Hello World!", Params, Font

	' Encrypt document, set "no printing/no changing" flags
	Doc.Encrypt "abc", "", 128, pdfFull And (Not pdfPrint) And (Not pdfModify)

	' Sign document with a certificate located in .pfx file
	' This requires AspEncrypt from www.aspencrypt.com
	Set CM = Server.CreateObject("Persits.CryptoManager")
	Set Context = CM.OpenContext("", True)
	Set Msg = Context.CreateMessage
	CM.RevertToSelf ' to avoid "The system cannot find the file specified" error

	' Open cert from .pfx file
	Set Store = CM.OpenStoreFromPFX( Server.MapPath("testcert.pfx"), "test" )
	Set Cert = Store.Certificates(1)
	Msg.SetSignerCert Cert

	' Sign!
	Doc.Sign Msg, "John Smith", "I created this document.", "New York"

	' Save document, the Save method returns generated file name
	Filename = Doc.Save( Server.MapPath("signed.pdf"), False )

	Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"


%>

</BODY>
</HTML>
