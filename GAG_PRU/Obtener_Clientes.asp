<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	empresa_seleccionada = "" & request.QueryString("empresa")
	valor_seleccionado = "" & request.QueryString("valor_seleccionado")
	ordenacion = "" & request.QueryString("orden")
	borrados= "" & request.querystring("borrados")
	if borrados="false" then
		borrados="NO"
	end if
	
	'response.write("<br>empresa seleccionada: " & empresa_seleccionada)
	'response.write("<br>valor_seleccionado(hotel): " & valor_seleccionado)
	'response.write("<br>ordenacion: " & ordenacion)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
	'response.write("<br>borrados: " & request.querystring("borrados"))
	'response.write("<br>variable borrados: " & borrados)
		set clientes=Server.CreateObject("ADODB.Recordset")
		
		'sql="Select id, nombre  from clientes"
		'sql=sql & " order by nombre"
		CAMPO_ID_CLIENTES=0
		CAMPO_EMPRESA_CLIENTES=1
		CAMPO_NOMBRE_CLIENTES=2
		CAMPO_CODIGO_EXTERNO_CLIENTES=3
		sql="SELECT  V_CLIENTES.Id, V_EMPRESAS.EMPRESA, V_CLIENTES.NOMBRE,"
		if ordenacion="POR_ID" then
			sql=sql & "  right('000000' + V_CLIENTES.CODIGO_EXTERNO, 6) as CODIGO_EXTERNO"
		  else
		  	sql=sql & "  V_CLIENTES.CODIGO_EXTERNO"
		end if
		sql=sql & " FROM V_CLIENTES INNER JOIN V_EMPRESAS"
		sql=sql & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
		sql=sql & " WHERE 1=1"
		if empresa_seleccionada<>"" then
			sql=sql & " AND V_CLIENTES.EMPRESA=" & empresa_seleccionada
		end if
		if borrados="" or borrados="NO" or borrados=false then
			sql=sql & " AND BORRADO='NO'"
		end if
		if ordenacion="POR_NOMBRE" then
			sql=sql & " ORDER BY V_empresas.empresa, V_CLIENTES.NOMBRE"
		  else
		  	sql=sql & " ORDER BY right('000000' + V_CLIENTES.CODIGO_EXTERNO, 6), V_empresas.empresa, V_CLIENTES.NOMBRE"
		end if
		'response.write("<br>consulta clientes: " & sql)
		
		with clientes
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
			vacio_clientes=false
			if not .BOF then
				tabla_clientes=.GetRows()
			  else
				vacio_clientes=true
			end if
		end with
		
	

	clientes.close
	set clientes=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>


<%if not vacio_clientes then%>
	
	<select class="form-control" name="cmbclientes" id="cmbclientes">
		<option value=""  selected="selected">Seleccionar Cliente</option>
		<%if not vacio_clientes then%>
			<%for i=0 to UBound(tabla_clientes,2)%>
				<%
				if ordenacion="POR_NOMBRE" then
					texto_mostrar=tabla_clientes(CAMPO_EMPRESA_CLIENTES,i) & " - " & tabla_clientes(CAMPO_NOMBRE_CLIENTES,i)
					if tabla_clientes(CAMPO_CODIGO_EXTERNO_CLIENTES,i)<>"" then
						texto_mostrar=texto_mostrar & " (" & tabla_clientes(CAMPO_CODIGO_EXTERNO_CLIENTES,i) & ")"
					end if
				  else
				  	texto_mostrar=""
				  	if tabla_clientes(CAMPO_CODIGO_EXTERNO_CLIENTES,i)<>"" then
						texto_mostrar= tabla_clientes(CAMPO_CODIGO_EXTERNO_CLIENTES,i)
					end if
					texto_mostrar=texto_mostrar & " - " & tabla_clientes(CAMPO_EMPRESA_CLIENTES,i) & " - " & tabla_clientes(CAMPO_NOMBRE_CLIENTES,i)
					
				end if
				
				'texto_mostrar=texto_mostrar & "... " & tabla_clientes(CAMPO_ID_CLIENTES,i)
				%>
				<%if "" & valor_seleccionado="" & tabla_clientes(CAMPO_ID_clientes,i) then%>
					<option value="<%=tabla_clientes(CAMPO_ID_CLIENTES,i)%>" selected><%=texto_mostrar%></option>
				<%else%>
					<option value="<%=tabla_clientes(CAMPO_ID_CLIENTES,i)%>"><%=texto_mostrar%></option>
				<%end if%>
			<%next%>
		<%end if%>
	</select>

<%end if%>


