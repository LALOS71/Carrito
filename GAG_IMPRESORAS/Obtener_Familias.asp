<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	empresa_seleccionada = "" & request.QueryString("empresa")
	valor_seleccionado = "" & request.QueryString("valor_seleccionado")
	control_cambio=""
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
	
	set familias=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_FAMILIA=0
		CAMPO_EMPRESA_FAMILIA=1
		CAMPO_DESCRIPCION_FAMILIA=2
		CAMPO_BORRADO_FAMILIA=3
		with familias
			.ActiveConnection=connimprenta
			.Source="SELECT ID, CODIGO_EMPRESA, DESCRIPCION, BORRADO"
			.Source= .Source & " FROM FAMILIAS"
			if empresa_seleccionada<>"" then
				.Source=.Source & " WHERE CODIGO_EMPRESA=" & empresa_seleccionada
			end if
			.Source= .Source & " ORDER BY BORRADO, DESCRIPCION"
			'response.write("<br>" & .source)
			.Open
			vacio_familias=false
			if not .BOF then
				tabla_familias=.GetRows()
			  else
				vacio_familias=true
			end if
		end with

		familias.close
		set familias=Nothing

	
	connimprenta.close
	set connimprenta=Nothing
%>


<%if not vacio_familias then%>
	
	<select class="form-control" name="cmbfamilias" id="cmbfamilias">
				<option value="" selected>* Seleccione *</option>
				
				<%if not vacio_familias and empresa_seleccionada<>"" then%>
						<%for i=0 to UBound(tabla_familias,2)%>
							<%if control_cambio<>tabla_familias(campo_borrado_familia,i) then
									control_cambio=tabla_familias(campo_borrado_familia,i)
									if i<>0 then%>
										</optgroup>
									<%end if
									if control_cambio="NO" then%>
										<optgroup label="Vigentes">
									  <%else%>
									  	<optgroup label="Obsoletas">
									<%end if
							end if%>
							
							<%if valor_seleccionado<>"" then
								if cint(valor_seleccionado)=cint(tabla_familias(campo_id_familia,i)) then%>
									<option value="<%=tabla_familias(campo_id_familia,i)%>" selected><%=tabla_familias(campo_descripcion_familia,i)%></option>
							  	<%else%>
									<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=tabla_familias(campo_descripcion_familia,i)%></option>
								<%end if%>
							  <%else%>
							  	<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=tabla_familias(campo_descripcion_familia,i)%></option>
							<%end if%>
						<%next%>
				<%end if%>
				</optgroup>
	</select><%end if%>


