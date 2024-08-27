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
		cadena_sql="SELECT HISTORICO_PIRS.ID, HISTORICO_PIRS.ID_PIR, HISTORICO_PIRS.PIR, CONVERT(char(10), HISTORICO_PIRS.FECHA, 103) AS FECHA," 
		cadena_sql=cadena_sql & " CONVERT(char(8), HISTORICO_PIRS.FECHA, 108) AS HORA, HISTORICO_PIRS.ESTADO, HISTORICO_PIRS.ACCION,"
		cadena_sql=cadena_sql & " HISTORICO_PIRS.CAMPO, HISTORICO_PIRS.VALOR_ANTIGUO, HISTORICO_PIRS.VALOR_NUEVO,"
		cadena_sql=cadena_sql & " HISTORICO_PIRS.USUARIO, HISTORICO_PIRS.DESCRIPCION, USUARIOS.NOMBRE AS NOMBRE_USUARIO"
		cadena_sql=cadena_sql & " FROM HISTORICO_PIRS INNER JOIN USUARIOS"
		cadena_sql=cadena_sql & " ON HISTORICO_PIRS.USUARIO = USUARIOS.USUARIO"
		cadena_sql=cadena_sql & " WHERE HISTORICO_PIRS.ID_PIR=" & id_pir
		cadena_sql=cadena_sql & " ORDER BY HISTORICO_PIRS.FECHA DESC"

		
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



