
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument(Missing.Value);

	// Set various document properties
	objDoc.Title = "AspPDF Chapter 3 Hello World Sample";
	objDoc.Creator = "John Smith";

	// Add a new page
	IPdfPage objPage = objDoc.Pages.Add(Missing.Value, Missing.Value, Missing.Value);

	// Select one of the standard PDF fonts
	IPdfFont objFont = objDoc.Fonts["Helvetica", Missing.Value];

	// Param string
	String strParams = "x=0; y=650; width=612; alignment=center; size=50";
	
	// Draw text on page
	objPage.Canvas.DrawText( "Hello World!", strParams, objFont );

	// Build OLE DB connection string
	String strConnect = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + Server.MapPath("..\\db\\asppdf.mdb");

	// If you use SQL Server, the connecton string must look something like this:
	// strConnect = "Provider=SQLOLEDB;Server=MYSRV;Database=master;UID=sa;PWD=xxx"

	OleDbConnection myConnection = new OleDbConnection( strConnect );
	myConnection.Open();

	OleDbDataAdapter myDataAdapter = new OleDbDataAdapter ("select * from pdffiles", myConnection);
	DataSet myDataSet = new DataSet();
	myDataAdapter.Fill( myDataSet, "pdffiles" );

	DataTable tblImages = myDataSet.Tables["pdffiles"];
	DataRow rowImage;

	// Add a new row
	rowImage = tblImages.NewRow();
	tblImages.Rows.Add( rowImage );
		
	rowImage.BeginEdit();
			
	// Save PDF file blob and in row
	rowImage["FileBlob"]	= objDoc.SaveToMemory();

	rowImage.EndEdit();
			
	// Without this line, Update will fail.
	OleDbCommandBuilder myCB = new OleDbCommandBuilder(myDataAdapter);
	myDataAdapter.Update( myDataSet, "pdffiles" );


	lblResult.Text = "Success! File was successfully saved in the AspPDF.mdb database.";
}





</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 3: Hello World Sample, SaveToMemory</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
