<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	precio_tramo=""	
	codigo_articulo=Request.QueryString("codigo_articulo")
	codigo_empresa=Request.QueryString("codigo_empresa")
	tipo_sucursal=Request.QueryString("tipo_sucursal")
	cantidad_introducida=Request.QueryString("cantidad_introducida")
	
	
	
	'response.write("<br>id articulo: " & id_articulo)
	set precio_tramo_articulo=Server.CreateObject("ADODB.Recordset")
	sql="SELECT PRECIO_UNIDAD"
	sql=sql & " FROM CANTIDADES_PRECIOS"
	sql=sql & " WHERE  CODIGO_ARTICULO = " & codigo_articulo
	sql=sql & " AND  CODIGO_EMPRESA = " & codigo_empresa
	sql=sql & " AND  TIPO_SUCURSAL = '" & tipo_sucursal & "'"
	sql=sql & " AND  CANTIDAD <= " & cantidad_introducida
	sql=sql & " AND  (CANTIDAD_SUPERIOR >= " & cantidad_introducida & " OR CANTIDAD_SUPERIOR IS NULL)"
	
'SELECT * FROM CANTIDADES_PRECIOS
'WHERE     (CODIGO_EMPRESA = 10) 
'AND (CODIGO_ARTICULO = 2892) 
'AND (TIPO_SUCURSAL = 'GENERICO') 
'AND (CANTIDAD <= 5) 
'AND (CANTIDAD_SUPERIOR >= 5 OR CANTIDAD_SUPERIOR IS NULL)
		
	with precio_tramo_articulo
		.ActiveConnection=connimprenta
		.CursorType=3 'adOpenStatic
		.Source=sql
		.Open
	end with
		
	if not precio_tramo_articulo.eof then
		precio_tramo=precio_tramo_articulo("PRECIO_UNIDAD")	
	end if
			 
		precio_tramo_articulo.close
		set precio_tramo_articulo=Nothing
		
		
	
	
	connimprenta.close
	set connimprenta=Nothing
%>

<%=precio_tramo%>