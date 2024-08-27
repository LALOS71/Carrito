<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	
	id_pir = "" & request.QueryString("p_id_pir")
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		cadena_sql="SELECT ID, ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO, USUARIO, DESCRIPCION," 
		cadena_sql=cadena_sql & " TIPO_INCIDENCIA"
		cadena_sql=cadena_sql & " FROM HISTORICO_PIRS"
		cadena_sql=cadena_sql & " WHERE ID_PIR=" & id_pir
		
		if ver_cadena="SI" then
			response.write("<br>" & cadena_sql & "<br><br>")
		end if
		
		
		
			
	Set rs = Server.CreateObject("ADODB.recordset")
	rs.Open cadena_sql, connmaletas
	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(rs, "ROWSET") & "}"



	
	connmaletas.close
	set connmaletas=Nothing
%>



