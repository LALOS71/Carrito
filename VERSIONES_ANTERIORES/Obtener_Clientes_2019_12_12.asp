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
		set hoteles=Server.CreateObject("ADODB.Recordset")
		
		'sql="Select id, nombre  from hoteles"
		'sql=sql & " order by nombre"
		CAMPO_ID_HOTELES=0
		CAMPO_EMPRESA_HOTELES=1
		CAMPO_NOMBRE_HOTELES=2
		CAMPO_CODIGO_EXTERNO_HOTELES=3
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
		
		with hoteles
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
			vacio_hoteles=false
			if not .BOF then
				tabla_hoteles=.GetRows()
			  else
				vacio_hoteles=true
			end if
		end with
		
	

	hoteles.close
	set hoteles=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>


<%if not vacio_hoteles then%>
	
	<select class="txtfielddropdown" name="cmbhoteles" id="cmbhoteles" size="1">
		<option value=""  selected="selected">Seleccionar Cliente</option>
		<%if not vacio_hoteles then%>
			<%for i=0 to UBound(tabla_hoteles,2)%>
				<%
				if ordenacion="POR_NOMBRE" then
					texto_mostrar=tabla_hoteles(CAMPO_EMPRESA_HOTELES,i) & " - " & tabla_hoteles(CAMPO_NOMBRE_HOTELES,i)
					if tabla_hoteles(CAMPO_CODIGO_EXTERNO_HOTELES,i)<>"" then
						texto_mostrar=texto_mostrar & " (" & tabla_hoteles(CAMPO_CODIGO_EXTERNO_HOTELES,i) & ")"
					end if
				  else
				  	texto_mostrar=""
				  	if tabla_hoteles(CAMPO_CODIGO_EXTERNO_HOTELES,i)<>"" then
						texto_mostrar= tabla_hoteles(CAMPO_CODIGO_EXTERNO_HOTELES,i)
					end if
					texto_mostrar=texto_mostrar & " - " & tabla_hoteles(CAMPO_EMPRESA_HOTELES,i) & " - " & tabla_hoteles(CAMPO_NOMBRE_HOTELES,i)
					
				end if
				
				'texto_mostrar=texto_mostrar & "... " & tabla_hoteles(CAMPO_ID_HOTELES,i)
				%>
				<%if "" & valor_seleccionado="" & tabla_hoteles(CAMPO_ID_HOTELES,i) then%>
					<option value="<%=tabla_hoteles(CAMPO_ID_HOTELES,i)%>" selected><%=texto_mostrar%></option>
				<%else%>
					<option value="<%=tabla_hoteles(CAMPO_ID_HOTELES,i)%>"><%=texto_mostrar%></option>
				<%end if%>
			<%next%>
		<%end if%>
	</select>

<%end if%>


