<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	set  marcas=Server.CreateObject("ADODB.Recordset")
	
	empresa_seleccionada = "" & request.QueryString("empresa")
	valor_seleccionado = "" & request.QueryString("valor_seleccionado")
	
	if valor_seleccionado="" then
		valor_seleccionado=0
	end if
	
	set stocks_articulo=Server.CreateObject("ADODB.Recordset")
		'hacemos esta consulta rara, para que coga todos los nombres de marca posibles
		' para los articulos, si no hay nada que de opcion a crear stock para ese articulo de esa marca
		'	
		sql="SELECT V_CLIENTES_MARCA.MARCA, V_CLIENTES_MARCA.EMPRESA, a.ID_ARTICULO, a.STOCK, a.STOCK_MINIMO"
		sql=sql & " FROM V_CLIENTES_MARCA LEFT JOIN"
		sql=sql & " (SELECT ARTICULOS_MARCAS.ID_ARTICULO, ARTICULOS_MARCAS.MARCA, ARTICULOS_MARCAS.STOCK, ARTICULOS_MARCAS.STOCK_MINIMO"
		sql=sql & " FROM ARTICULOS_MARCAS"
		sql=sql & " WHERE ARTICULOS_MARCAS.ID_ARTICULO=" & valor_seleccionado & ") as a"
		sql=sql & " ON V_CLIENTES_MARCA.MARCA = a.MARCA"
		if empresa_seleccionada<>"" then
			sql=sql & " WHERE V_CLIENTES_MARCA.EMPRESA=" & empresa_seleccionada
		end if
		sql=sql & " ORDER BY V_CLIENTES_MARCA.MARCA"
		
		
		'response.write("<br>" & sql)
		
		CAMPO_MARCA_ARTICULOS_MARCAS=0
		CAMPO_EMPRESA_ARTICULOS_MARCAS=1
		CAMPO_ID_ARTICULO_ARTICULOS_MARCAS=2
		CAMPO_STOCK_ARTICULOS_MARCAS=3
		CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS=4
		
		with stocks_articulo
			.ActiveConnection=connimprenta
			.CursorType=3 'adOpenStatic
			.Source=sql
			.Open
			vacio_stocks_articulo=false
			if not .BOF then
				mitabla_stocks_articulo=.GetRows()
			  else
				vacio_stocks_articulo=true
			end if
		end with
			 
		stocks_articulo.close
		set stocks_articulo=Nothing
		
		
	
	
	connimprenta.close
	set connimprenta=Nothing
%>


<%if vacio_stocks_articulo=false then %>
	<%for i=0 to UBound(mitabla_stocks_articulo,2)%>
		<table cellpadding="2" cellspacing="1" border="0" width="100%">
			<tr>
				<td width="25%">Stock Marca <%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>: </td>
				<td width="21%" >
				  <input class="txtfield" size="15" name="txtstock_<%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" id="txtstock_<%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" value="<%=mitabla_stocks_articulo(CAMPO_STOCK_ARTICULOS_MARCAS,i)%>"/>
				</td>
				<td width="34%">Stock Mínimo Marca <%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>: </td>
				<td width="20%" >
				  <input class="txtfield" size="15" name="txtstock_minimo_<%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" id="txtstock_minimo_<%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" value="<%=mitabla_stocks_articulo(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,i)%>"/>
				</td>
			</tr>							
		</table>
		<table width="306" cellpadding="0" cellspacing="0">
			<tr><td height="5"></td></tr>
		</table>
	<%next%>
<%end if%>