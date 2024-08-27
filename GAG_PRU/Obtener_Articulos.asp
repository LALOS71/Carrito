<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	valor_seleccionado = "" & request.QueryString("valor_seleccionado")
	orden_seleccionado = "" & request.QueryString("orden")
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>valor seleccionado: " & valor_seleccionado)
	'response.write("<br>orden: " & orden_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
	
	if orden_seleccionado="" then
		orden_seleccionado="CODIGO_SAP"
	end if
	
	set articulos=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_ARTICULO=0
		CAMPO_CODIGO_SAP_ARTICULO=1
		CAMPO_DESCRIPCION_ARTICULO=2
		with articulos
			.ActiveConnection=connimprenta
			.Source="SELECT ARTICULOS.ID, ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION"
			.Source= .Source & " FROM ARTICULOS"
			.Source= .Source & " ORDER BY " & orden_seleccionado
			'RESPONSE.write("<br>" & .source)
			.Open
			vacio_articulos=false
			if not .BOF then
				mitabla_articulos=.GetRows()
			  else
				vacio_articulos=true
			end if
		end with

		articulos.close
		set articulos=Nothing

	
	connimprenta.close
	set connimprenta=Nothing
%>


<%if not vacio_articulos then %>
	<select  name="cmbarticulos" id="cmbarticulos">
		<option value="" selected>* TODOS *</option>
				<%for i=0 to UBound(mitabla_articulos,2)%>
							<%if valor_seleccionado = ("" & mitabla_articulos(CAMPO_ID_ARTICULO,i)) then%>
								<option value="<%=mitabla_articulos(CAMPO_ID_ARTICULO,i)%>" selected><%=mitabla_articulos(CAMPO_CODIGO_SAP_ARTICULO,i)%> - <%=mitabla_articulos(CAMPO_DESCRIPCION_ARTICULO,i)%></option>
							  <%else%>
								<option value="<%=mitabla_articulos(CAMPO_ID_ARTICULO,i)%>"><%=mitabla_articulos(CAMPO_CODIGO_SAP_ARTICULO,i)%> - <%=mitabla_articulos(CAMPO_DESCRIPCION_ARTICULO,i)%></option>
							<%end if%>

				
					
				<%next%>
	</select>
<%end if%>												


