<%@ language=vbscript %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
	
	
	set precios=Server.CreateObject("ADODB.Recordset")
		CAMPO_TIPO_PRECIO=0
		with precios
			.ActiveConnection=connimprenta
			.Source="SELECT TIPO_PRECIO FROM V_EMPRESAS_TIPOS_PRECIOS "
			if empresa_seleccionada<>"" then
				.Source=.Source & " WHERE ID_EMPRESA=" & empresa_seleccionada
			end if
			.Source= .Source & " ORDER BY TIPO_PRECIO"
			.Open
			vacio_precios=false
			if not .BOF then
				tabla_precios=.GetRows()
			  else
				vacio_precios=true
			end if
		end with

		precios.close
		set precios=Nothing


	
	connimprenta.close
	set connimprenta=Nothing
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Documento sin t&iacute;tulo</title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>

<body>
<%if not vacio_precios then%>
	<select name="cmbprecios" id="cmbprecios">
				<%if UBound(tabla_precios,2)<>0 then%>
				<option value="" selected>* Seleccione *</option>
				<%end if%>
				<%if not vacio_precios and empresa_seleccionada<>"" then%>
						<%for i=0 to UBound(tabla_precios,2)%>
								<%if valor_seleccionado=tabla_precios(CAMPO_TIPO_PRECIO,i) then %>
									<option value="<%=tabla_precios(CAMPO_TIPO_PRECIO,i)%>" selected><%=tabla_precios(CAMPO_TIPO_PRECIO,i)%></option>
								<%else%>
									<option value="<%=tabla_precios(CAMPO_TIPO_PRECIO,i)%>"><%=tabla_precios(CAMPO_TIPO_PRECIO,i)%></option>
								<%end if%>
						<%next%>
				<%end if%>
	</select>
<%end if%>
</body>
</html>

