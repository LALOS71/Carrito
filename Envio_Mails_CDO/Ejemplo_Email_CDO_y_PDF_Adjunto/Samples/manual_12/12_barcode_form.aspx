<%@ Page codepage="65001" %>

<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="ASPPDFLib" %>

<script runat="server" LANGUAGE="C#">

void Page_Load(Object Source, EventArgs E)
{
	if( !IsPostBack )
	{
		Size.SelectedIndex = 0;
		Data.Value = "00123456789";
	}

	// to keep sessionID (used for file name generation) from changing every time
	Session["dummy"] = 1; 
}

public void GeneratePDF(object sender, System.EventArgs args)
{
	try
	{
		// create instance of the PDF manager
		IPdfManager objPDF;
		objPDF = new PdfManager();

		// Create new document
		IPdfDocument objDoc = objPDF.CreateDocument(Missing.Value);

		// Add a page to document
		IPdfPage objPage = objDoc.Pages.Add(Missing.Value, Missing.Value, Missing.Value);

		IPdfParam objParam = objPDF.CreateParam(Missing.Value);
	    
		objParam["x"].Value = 72;
		objParam["y"].Value = 72 * 10 - float.Parse(Size.SelectedItem.Value) + 1;
		objParam["height"].Value = float.Parse(Size.SelectedItem.Value) * 2 / 3;
		objParam["width"].Value = float.Parse(Size.SelectedItem.Value);
		objParam["type"].Value = float.Parse(Type.Value);
	    
		//objParam["color"].Value = Color.Value;  'only takes floats?
		objParam.Add("color=" + Color.Value);
	    
		IPdfCanvas objCanvas = objPage.Canvas;

		objCanvas.DrawBarcode(Data.Value, objParam);

		// Save document, the Save method returns generated file name
		String strFilename = objDoc.Save( Server.MapPath("Barcode.pdf"), false );

		lblResult.Text = "Success! Download your PDF file <A HREF=" + strFilename + ">here</A>";
	}
	catch(Exception e)
	{
		lblResult.Text = "<font color=\"red\">Error: </font>" + e.Message;
	}
}


</script>


<HTML>
<HEAD>
<TITLE>AspPDF User Manual Chapter 12: Barcode Sample 2</TITLE>
</HEAD>
<BODY style="font-family: arial; font-size: 12px;">

<form name="frmBarcode" runat="server">
<TABLE WIDTH="640" style="font-family: arial; font-size: 12px;">
<TR><TD colspan=2>
Enter data and click on the "Generate PDF" button to view a barcode in a PDF file.

</TD></TR>
<tr><td>Barcode Type:</td>
<td><SELECT id="Type" runat="server">
<OPTION value=1>UPC-A (numeric)</option>
<OPTION value=11>Industrial 2/5 (numeric)</option>
<OPTION value=17>Code-39 (text)</option>
</select></td></tr>

<tr><td>Barcode Data:</td>
<td><input type="text" id="Data" runat="Server" size="30">
</td></tr>

<tr><td>Color:</td>
<td>
<SELECT id="Color" runat="server">
<OPTION>Black</option>
<OPTION>Blue</option>
<OPTION>Brown</option>
<OPTION>Cyan</option>
<OPTION>Green</option>
<OPTION>Gray</option>
<OPTION>Red</option>
<OPTION>Magenta</option>
<OPTION>Yellow</option>
</SELECT>
</td></tr>

<tr><td>Barcode Size:</td>
<td>
<ASP:RadioButtonList id="Size" runat="server" RepeatDirection="Horizontal" Style="font-name: arial; font-size: 12;">
			<ASP:ListItem Value="72">Small (1 inch)</ASP:ListItem>
			<ASP:ListItem Value="144">Medium (2 inches)</ASP:ListItem>
			<ASP:ListItem Value="288">Large (4 inches)</ASP:ListItem>
</ASP:RadioButtonList></td></tr>
<tr><td>
<INPUT TYPE="SUBMIT" ID="btnSave" Value="Generate PDF" OnServerClick="GeneratePDF" runat="Server">
</td></tr>
</table>
</form>

<B><ASP:Label ID="lblResult" runat="Server"/></B>

</BODY>
</HTML>
