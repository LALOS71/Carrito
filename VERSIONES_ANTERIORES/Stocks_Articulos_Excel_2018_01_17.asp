<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
		response.buffer=false
		Response.ContentType = "application/vnd.ms-excel.numberformat:#.###"
		Response.AddHeader "Content-Disposition", "attachment;filename=Stock_Articulos.xls" 
		
		
		'recordsets
		dim articulos

		set  articulos=Server.CreateObject("ADODB.Recordset")
	    
	    cadena_consulta=Request.Form("ocultocadena_consulta")
		empresa_seleccionada=Request.Form("ocultoempresas")
		familia_seleccionada=Request.Form("ocultofamilias")
		requiere_autorizacion=Request.Form("ocultoautorizacion")
		
		
		with articulos
			.ActiveConnection=connimprenta
			.Source=cadena_consulta
			'response.write("<br><br>" & .Source)
			.Open
		end with
	
		
		
%>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Informe de Grupos en Negociaci&oacute;n</title>

<STYLE>
.cajatexto {
	BORDER-STYLE:groove;
	FONT-SIZE: 11px; 
	FONT-WEIGHT: bold;
	COLOR: black; 
	FONT-FAMILY: Arial, Helvetica, sans-serif; 
	TEXT-TRANSFORM: Uppercase;
	BACKGROUND-COLOR: lightblue;
}
</STYLE>
</head>

<body class=txt-rojo>
<table border="1" width="100%" cellspacing="0" cellpadding="0">
	<tr>
    	<td colspan="6" align="center" height="26" bgcolor="#CCCCCC"><div align="center"><font face="Arial, Helvetica, sans-serif" size="2"><b>INFORME STOCK DE ARTICULOS A <%=date()%></b></font></div></td>
	</tr>
	<tr>
    	<td colspan="6"><div><font face="Arial, Helvetica, sans-serif" size="2"><b>Filtros Seleccionados:</b></font></div>
	</tr>
	<tr>
		<td bgcolor="#EEEEEE">Empresa:</td>
		<td colspan="2">&nbsp;<%=empresa_seleccionada%></td>
	</tr>
	<tr>			
		<td bgcolor="#EEEEEE">Familia</td>
		<td colspan="2">&nbsp;<%=familia_seleccionada%></td>
	</tr>
	<tr>			
		<td bgcolor="#EEEEEE">Req. Autori.</td>
		<td colspan="2">&nbsp;<%=requiere_autorizacion%></td>
	</tr>
	
  <tr align="center">
    <td width="10%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000033"><b>EMPRESA</b></font></td>
    <td width="10%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000033"><b>REFERENCIA</b></font></td>
    <td width="50%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000033"><b>ARTICULO</b></font></td>
    <td width="10%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000033"><b>STOCK</b></font></td>
    <td width="10%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000033"><b>STOCK MINIMO</b></font></td>
    <td width="10%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000033"><b>SE MUESTRA</b></font></td>
  </tr>
  <%WHILE NOT articulos.eof%>
  		<tr>
			<td width="10%"><font size="1" color="#000033"><%=articulos("empresa")%></font></td>
			<td width="10%"><font size="1" color="#000033"><%=articulos("codigo_sap")%></font></td>
			<td width="50%"><font size="1" color="#000033"><%=articulos("descripcion")%></font></td>
			<%
				set articulos_marcas=Server.CreateObject("ADODB.Recordset")
				sql="SELECT ID_ARTICULO, STOCK, STOCK_MINIMO"
				sql=sql & " FROM ARTICULOS_MARCAS"
				sql=sql & " WHERE ARTICULOS_MARCAS.ID_ARTICULO=" & articulos("id")
				with articulos_marcas
					.ActiveConnection=connimprenta
					.Source=sql
					'RESPONSE.WRITE("<BR>" & .SOURCE)
					.Open
				end with
				
			%>
			<td width="10%"><font size="1" color="#000033"><%=articulos_marcas("stock")%></font></td>
			<td width="10%"><font size="1" color="#000033"><%=articulos_marcas("stock_minimo")%></font></td>
			<td width="10%"><font size="1" color="#000033"><%=articulos("mostrar")%></font></td>
			<%
			articulos_marcas.close
			set articulos_marcos=Nothing
			%>
			
		</tr>
  
  		<%articulos.movenext%>
  <%WEND%>
</table>
</body>
<% 
				'cerramos los objetos que hemos utilizado
			 
			 articulos.close
			 connimprenta.close	
		
			  set articulos=Nothing
			  set connimprenta=Nothing
			 
	
%>
</html>
