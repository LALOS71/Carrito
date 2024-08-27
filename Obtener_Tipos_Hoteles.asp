<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	empresa_seleccionada = "" & request.QueryString("empresa")
	valor_seleccionado = "" & request.QueryString("valor_seleccionado")
	
	'response.write("<br>comunidad: " & comunidad_seleccionada)
	'response.write("<br>provincia: " & provincia_seleccionada)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
	
	set tipos=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_TIPO=0
		CAMPO_EMPRESA_TIPO=1
		CAMPO_TIPO_TIPO=2
		CAMPO_ORDEN_TIPO=3
		with tipos
			.ActiveConnection=connimprenta
			.Source="SELECT V_CLIENTES_TIPO.ID, V_CLIENTES_TIPO.EMPRESA, V_CLIENTES_TIPO.TIPO"
			.Source= .Source & " FROM V_CLIENTES_TIPO"
			if empresa_seleccionada<>"" then
				.Source=.Source & " WHERE EMPRESA=" & empresa_seleccionada
			end if
			.Source= .Source & " ORDER BY ORDEN"
			'response.write("<br>" & .source)
			.Open
			vacio_tipos=false
			if not .BOF then
				tabla_tipos=.GetRows()
			  else
				vacio_tipos=true
			end if
		end with

		tipos.close
		set tipos=Nothing

	
	connimprenta.close
	set connimprenta=Nothing
%>


<%if not vacio_tipos then%>
	
	<select name="cmbtipos" id="cmbtipos">
				<option value="" selected>* Seleccione *</option>
				<%if not vacio_tipos and empresa_seleccionada<>"" then%>
						<%for i=0 to UBound(tabla_tipos,2)%>
							<%if valor_seleccionado=tabla_tipos(campo_tipo_tipo,i) then%>
								<option value="<%=tabla_tipos(campo_tipo_tipo,i)%>" selected><%=tabla_tipos(campo_tipo_tipo,i)%></option>
							  <%else%>
								<option value="<%=tabla_tipos(campo_tipo_tipo,i)%>"><%=tabla_tipos(campo_tipo_tipo,i)%></option>
							<%end if%>
						<%next%>
				<%end if%>
	</select>
	
<%end if%>


