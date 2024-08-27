<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	set  marcas=Server.CreateObject("ADODB.Recordset")
	
	empresa_seleccionada = "" & request.QueryString("empresa")
	valor_seleccionado = "" & request.QueryString("valor_seleccionado")
	
	'response.write("<br>comunidad: " & comunidad_seleccionada)
	'response.write("<br>provincia: " & provincia_seleccionada)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
	
	CAMPO_EMPRESA=0
	CAMPO_MARCA=1
	CAMPO_ORDEN=2
		
	with marcas
		.ActiveConnection=connimprenta
		.Source="SELECT EMPRESA, MARCA, ORDEN"
		.Source=.Source & " FROM V_CLIENTES_MARCA"
		
		if empresa_seleccionada<>"" then
			.Source=.Source & " WHERE EMPRESA=" & empresa_seleccionada
		end if
		.Source=.Source & " ORDER BY ORDEN"
		
		
	  	'response.write("<br><br>" & .source)
	  	.Open
		
		vacio_marcas=false
		if not .BOF then
			tabla_marcas=.GetRows()
		  else
			vacio_marcas=true
		end if
	end with
	marcas.close
	set  marcas=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>


<%if not vacio_marcas then%>
	
	<select name="cmbmarcas" id="cmbmarcas">
				<option value="" selected>* Seleccione *</option>
				<%if not vacio_marcas and empresa_seleccionada<>"" then%>
						<%for i=0 to UBound(tabla_marcas,2)%>
							<%if valor_seleccionado=tabla_marcas(campo_marca,i) then%>
								<option value="<%=tabla_marcas(campo_marca,i)%>" selected><%=tabla_marcas(campo_marca,i)%></option>
							  <%else%>
							  	<option value="<%=tabla_marcas(campo_marca,i)%>"><%=tabla_marcas(campo_marca,i)%></option>
							<%end if%>
								
						<%next%>
				<%end if%>
	</select>
	
<%end if%>


