<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	cantidad=""	
	id_articulo=Request.QueryString("q")
	'response.write("<br>id articulo: " & id_articulo)
	set stock_articulo=Server.CreateObject("ADODB.Recordset")
	sql="SELECT STOCK"
	sql=sql & " FROM ARTICULOS_MARCAS"
	sql=sql & " WHERE ID_ARTICULO = " & id_articulo
	sql=sql & " AND MARCA = 'STANDARD'"
		
	with stock_articulo
		.ActiveConnection=connimprenta
		.CursorType=3 'adOpenStatic
		.Source=sql
		.Open
	end with
		
	if not stock_articulo.eof then
		cantidad=stock_articulo("stock")	
	end if
			 
		stock_articulo.close
		set stock_articulo=Nothing
		
		
	
	
	connimprenta.close
	set connimprenta=Nothing
%>

<%=cantidad%>