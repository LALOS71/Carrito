<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>


<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	IPdfManager objPdf = new PdfManager();

	// Create empty document
	IPdfDocument objDoc = objPdf.CreateDocument(Missing.Value);

	// Create 8x8 table to depict a chessboard
	IPdfTable objTable = objDoc.CreateTable( "width=200; height=200; rows=8; cols=8; border=1; cellborder=0; cellspacing=2");

	// Select a Chess font to depict chess pieces
	IPdfFont objFont = objDoc.Fonts.LoadFromFile( Server.MapPath("MERIFONT.TTF") );

	objTable.Font = objFont;

	// initialize Pieces array
	int	[] Pieces = {0,
	0xF074, 0xF06D, 0xF076, 0xF077, 0xF06C, 0xF076, 0xF06D, 0xF074,
	0xF06F, 0xF06F, 0xF06F, 0xF06F, 0xF06F, 0xF06F, 0xF06F, 0xF06F,
	0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000,
	0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000,
	0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000,
	0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000, 0xF000,
	0xF070, 0xF070, 0xF070, 0xF070, 0xF070, 0xF070, 0xF070, 0xF070,
	0xF072, 0xF06E, 0xF062, 0xF071, 0xF06B, 0xF062, 0xF06E, 0xF072 };

	// go over all cells in the table
	foreach( IPdfRow objRow in objTable.Rows )
	{
		foreach( IPdfCell objCell in objRow.Cells )
		{
			// set background on cells which sum of indices is odd
			if( (objCell.Index + objRow.Index) % 2 == 1 )
				objCell.BgColor = "brown";
			
			int Piece = Pieces[ 8 * (objRow.Index - 1) + objCell.Index ];

			objCell.AddText( ((char)Piece).ToString(), "size=20; indentx=1; indenty=1", Missing.Value );
		}
	}



	// Add a new page
	IPdfPage objPage = objDoc.Pages.Add( Missing.Value, Missing.Value, Missing.Value );

	objPage.Canvas.DrawTable( objTable, "x=206, y=498" );


	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("hello.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}





</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 7: Chess Sample</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
