
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Open Document 1
	IPdfDocument objDoc1 = objPdf.OpenDocument( Server.MapPath("doc1.pdf"), Missing.Value );

	// Open Document 2
	IPdfDocument objDoc2 = objPdf.OpenDocument( Server.MapPath("doc2.pdf"), Missing.Value );

	// Append doc2 to doc1
	objDoc1.AppendDocument( objDoc2 );

	// Save document, the Save method returns generated file name
	String strFilename = objDoc1.Save( Server.MapPath("stitch.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}





</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 12: Stitching Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
