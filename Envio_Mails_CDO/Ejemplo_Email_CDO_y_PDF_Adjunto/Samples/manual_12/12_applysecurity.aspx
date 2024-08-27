
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument( Missing.Value );

	// Open Document 1
	IPdfDocument objDoc1 = objPdf.OpenDocument( Server.MapPath("doc1.pdf"), Missing.Value );

	// Copy properties
	objDoc.Title		= objDoc1.Title;
	objDoc.Creator		= objDoc1.Creator;
	objDoc.Producer		= objDoc1.Producer;
	objDoc.CreationDate = objDoc1.CreationDate;
	objDoc.ModDate		= objDoc1.ModDate;

	// Apply security to Doc
	objDoc.Encrypt( "abc", "", 128, Missing.Value );

	// Append doc1 to doc
	objDoc.AppendDocument( objDoc1 );

	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("apply.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}





</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 12: Applying Security Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
