
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();
	IPdfDocument objDoc = objPdf.CreateDocument( Missing.Value );
	objDoc.ImportFromUrl( "http://www.persits.com", Missing.Value, Missing.Value, Missing.Value );

	String strFilename = objDoc.Save( Server.MapPath("importfromurl.pdf"), false );
	
	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}





</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 13: ImportFromUrl Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
