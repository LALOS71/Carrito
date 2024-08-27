<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty param objects to be used across the app
	IPdfParam objParam = objPdf.CreateParam(Missing.Value);
	IPdfParam objTextParam = objPdf.CreateParam(Missing.Value);

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument(Missing.Value);

	// Create table with one row (header), and 5 columns
	IPdfTable objTable = objDoc.CreateTable("width=500; height=20; Rows=1; Cols=5; Border=1; CellSpacing=-1; cellpadding=2 ");
	
	// Set default table font
	objTable.Font = objDoc.Fonts["Helvetica", Missing.Value];
	
	IPdfRow objHeaderRow = objTable.Rows[1];
	objParam.Set("alignment=center");
	objHeaderRow.BgColor = 0x90F0FE;
	objHeaderRow.Cells[1].AddText( "Category", objParam, Missing.Value );
	objHeaderRow.Cells[2].AddText( "Description", objParam, Missing.Value );
	objHeaderRow.Cells[3].AddText( "Billable", objParam, Missing.Value );
	objHeaderRow.Cells[4].AddText( "Date", objParam, Missing.Value );
	objHeaderRow.Cells[5].AddText( "Amount", objParam, Missing.Value );

	// Set column widths
	objHeaderRow.Cells[1].Width = 80;
	objHeaderRow.Cells[2].Width = 160;
	objHeaderRow.Cells[3].Width = 50;
	objHeaderRow.Cells[4].Width = 70;
	objHeaderRow.Cells[5].Width = 60;

	objParam.Set( "expand=true" ); // expand cells vertically

	// Build OLE DB connection string
	String strConnect = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + Server.MapPath("..\\db\\asppdf.mdb");

	// If you use SQL Server, the connecton string must look something like this:
	// strConnect = "Provider=SQLOLEDB;Server=MYSRV;Database=master;UID=sa;PWD=xxx"

	OleDbConnection myConnection = new OleDbConnection( strConnect );
	myConnection.Open();

	OleDbDataAdapter myDataAdapter = new OleDbDataAdapter ("select * from report", myConnection);
	DataSet myDataSet = new DataSet();
	myDataAdapter.Fill( myDataSet, "report" );

	// Populate table with data
	DataTable tbl = myDataSet.Tables[0];
	int nCount = tbl.Rows.Count;
	for( int i = 0; i < nCount; i++ )
	{
		IPdfRow objRow = objTable.Rows.Add(20, Missing.Value); // row height
		
		objParam.Add( "alignment=left" );
		objRow.Cells[1].AddText( tbl.Rows[i]["Category"].ToString(), objParam, Missing.Value );
		objRow.Cells[2].AddText( tbl.Rows[i]["Description"].ToString(), objParam, Missing.Value );
		
		objParam.Add( "alignment=center" );

		String strBillable;
		if( tbl.Rows[i]["Billable"].ToString() == "True" )
			strBillable = "Yes";
		else 
			strBillable = "No";

		DateTime dt = new DateTime();
		dt = (DateTime)tbl.Rows[i]["ExpenseDate"];
		objRow.Cells[3].AddText( strBillable, objParam, Missing.Value );
		objRow.Cells[4].AddText( objPdf.FormatDate( dt, "%d %b %Y" ), objParam, Missing.Value );

		float fAmount = Decimal.ToSingle( (Decimal)tbl.Rows[i]["Amount"] );
		objParam.Add( "alignment=right" );
		objRow.Cells[5].AddText( objPdf.FormatNumber( fAmount, "precision=2, delimiter=true"), objParam, Missing.Value );
	}

	// Render table on document, add pages as necessary
	IPdfPage objPage = objDoc.Pages.Add(612, 150, Missing.Value); 
	
	objParam.Clear();
	objParam["x"].Value = (objPage.Width - objTable.Width) / 2; // center table on page
	objParam["y"].Value = objPage.Height - 20;
	objParam["MaxHeight"].Value = 100;
	
	int nFirstRow = 2; // use this to print record count on page
	while( true )
	{
		// Draw table. This method returns last visible row index
		int nLastRow = objPage.Canvas.DrawTable( objTable, objParam );

		// Print record numbers
		objTextParam["x"].Value = (objPage.Width - objTable.Width) / 2;
		objTextParam["y"].Value = objPage.Height - 5;
		objTextParam.Add("color=darkgreen");
		String strTextStr = "Records " + (nFirstRow - 1) + " to " + (nLastRow - 1) + " of " + (objTable.Rows.Count - 1 );
		
		objPage.Canvas.DrawText( strTextStr, objTextParam, objDoc.Fonts["Courier-Bold", Missing.Value] );

		if( nLastRow >= objTable.Rows.Count )
			break; // entire table displayed

		// Display remaining part of table on the next page
		objPage = objPage.NextPage;
		objParam.Add( "RowTo=1; RowFrom=1" );	// Row 1 is header - must always be present.
		objParam["RowFrom1"].Value = nLastRow + 1;	// RowTo1 is omitted and presumed infinite

		nFirstRow = nLastRow + 1;
	}


	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("report.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}





</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 7: Database Report Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
