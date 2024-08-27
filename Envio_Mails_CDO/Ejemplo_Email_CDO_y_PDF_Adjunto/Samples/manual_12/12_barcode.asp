<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 12: Barcode Sample</TITLE>
</HEAD>
<BODY>

<%

Set Pdf = Server.CreateObject("Persits.Pdf")
Set Doc = Pdf.CreateDocument
Set Page = Doc.Pages.Add

strParam = "x=72; y=600; height=96; width=144; type=1" 'Barcode type 1 is UPC-A
strData = "04310070524"
Page.Canvas.DrawBarcode strData, strParam

Filename = Doc.Save( Server.MapPath("Barcode.pdf"), False )

Response.Write "Success! Download your PDF file <A HREF=" & Filename & ">here</A>"

%>

</BODY>
</HTML>