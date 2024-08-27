
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

float CenterX, CenterY, L;
float sa, ca;

void Project( float x, float y, float z, ref float x1, ref float y1 )
{
	x1 = CenterX + x * (L - z) / L;
	y1 = CenterY - (sa * y + ca * z) * (L - z) / L;
}

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

	//Fit this page in viewer window
	objDoc.OpenAction = objDoc.CreateDest( objPage, "Fit=true");

	float pi, p, t, OuterR, GirthR, Alpha, Beta, sb, cb, R1, x1 = 0, y1 = 0;
	int i, j, PN, TN;

	// computer center of page
	CenterX = objPage.Width / 2;
	CenterY = objPage.Height / 2;

	pi = 3.1415926F;
	PN = 30;					// number of steps for variable p
	TN = 10;					// number of steps for variable t
	OuterR = objPage.Width / 3;	// outer radius
	GirthR = OuterR / 3;		// girth

	// these will store node coordinates
	float [][] X = new float[51][];
	float [][] Y = new float[51][];
	float [][] Z = new float[51][];
	for( i = 0; i < 51; i++ )
	{
		X[i] = new float[51];
		Y[i] = new float[51];
		Z[i] = new float[51];
	}


	// will store tile distance information for invisible surface removal purposes
	float [] Dist	= new float[2601];	// 51 x 51
	int [] IndexI = new int[2601];
	int [] IndexJ = new int[2601];

	L = OuterR * 3;		// Distance from the viewer

	Alpha = pi + pi / 4;		// 45 degree rotation around X Axis
	Beta = pi / 6;				// 30 degree rotation around Y Axis

	sa = (float)Math.Sin(Alpha);
	ca = (float)Math.Cos(Alpha);
	sb = (float)Math.Sin(Beta);
	cb = (float)Math.Cos(Beta);

	// Compute coordinates of tiles
	int Count;	// number of tiles
	Count = 0;
	for( j = 0; j <= TN; j++ )
	{
		t = 2 * pi * j / TN;

		for( i = 0; i <= PN; i++ )
		{
			R1 = OuterR + GirthR * (float)Math.Sin(t);

			// This is the parametiric equation of a torus
			p = 2 * pi * i / PN;
			X[i][j] = R1 * (float)Math.Sin( p );
			Y[i][j] = R1 * (float)Math.Cos( p );
			Z[i][j] = GirthR * (float)Math.Cos( t );

			// Save distance to viewer based on Z-coordinate of one of tile corners
			Dist[Count] = Z[i][j];
			IndexI[Count] = i;
			IndexJ[Count] = j;
			Count = Count + 1;
		}
	}

	// Sort Distance arrays. Use bubble sort since arrays are relatively small
	float fTemp;
	int nTemp;
	for( i = 0 ; i < Count - 1; i++ )
	{
		for( j = Count - 1; j >= i + 1; j-- )
		{
			if( Dist[j] < Dist[j-1] )
			{
				// Swap
				fTemp = Dist[j];
				Dist[j] = Dist[j-1];
				Dist[j-1] = fTemp;

				nTemp = IndexI[j];
				IndexI[j] = IndexI[j-1];
				IndexI[j-1] = nTemp;

				nTemp = IndexJ[j];
				IndexJ[j] = IndexJ[j-1];
				IndexJ[j-1] = nTemp;
			}
		}
	}

	// Display torus in order of proximity to viewer
	objPage.Canvas.SetParams("color=darkgray; fillcolor=blue;linewidth=3");
	
	float x2 = 0, y2 = 0, x3 = 0, y3 = 0, x4 = 0, y4 = 0;
	int tilecount;

	for( tilecount = 0; tilecount <= Count - 1; tilecount++ )
	{
		i = IndexI[tilecount];
		j = IndexJ[tilecount];

		if( i < PN && j < TN )
		{
			// transform from 3D to 2D
			Project( X[i][j],		Y[i][j],		Z[i][j],		ref x1, ref y1);
			Project( X[i+1][j],		Y[i+1][j],		Z[i+1][j],		ref x2, ref y2);
			Project( X[i+1][j+1],	Y[i+1][j+1],	Z[i+1][j+1],	ref x3, ref y3);
			Project( X[i+1][j+1],	Y[i+1][j+1],	Z[i+1][j+1],	ref x3, ref y3);
			Project( X[i][j+1],		Y[i][j+1],		Z[i][j+1],		ref x4, ref y4);
			

			// Draw tile
			objPage.Canvas.MoveTo( x1, y1 );
			objPage.Canvas.LineTo( x2, y2 );
			objPage.Canvas.LineTo( x3, y3 );
			objPage.Canvas.LineTo( x4, y4 );
			objPage.Canvas.FillStroke( Missing.Value);
		}
	}


	// Save document, the Save method returns generated file name
	String strFilename = objDoc.Save( Server.MapPath("torus.pdf"), false );

	lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
}





</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 4: 3D Torus</TITLE>
</HEAD>
<BODY>

<ASP:Label ID="lblResult" runat="server"/>

</BODY>
</HTML>
