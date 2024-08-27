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
		cadena_sql="SELECT HISTORICO_PIRS.ID, HISTORICO_PIRS.ID_PIR, HISTORICO_PIRS.PIR"
		cadena_sql=cadena_sql & ", CONVERT(char(10), HISTORICO_PIRS.FECHA, 103) AS FECHA" 
		cadena_sql=cadena_sql & ", CONVERT(char(8), HISTORICO_PIRS.FECHA, 108) AS HORA"
		cadena_sql=cadena_sql & ", HISTORICO_PIRS.ESTADO, HISTORICO_PIRS.ACCION"
		cadena_sql=cadena_sql & ", HISTORICO_PIRS.CAMPO"
		cadena_sql=cadena_sql & ", CASE" 
		cadena_sql=cadena_sql & " 		WHEN HISTORICO_PIRS.CAMPO='ESTADO' THEN (SELECT DESCRIPCION FROM ESTADOS WHERE ID=HISTORICO_PIRS.VALOR_ANTIGUO)"
		cadena_sql=cadena_sql & " 	    WHEN HISTORICO_PIRS.CAMPO='PROVEEDOR' THEN (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=HISTORICO_PIRS.VALOR_ANTIGUO)"
		cadena_sql=cadena_sql & "	    ELSE REPLACE(HISTORICO_PIRS.VALOR_ANTIGUO, '""','\""')"
		cadena_sql=cadena_sql & " END AS VALOR_ANTIGUO"
		cadena_sql=cadena_sql & ", CASE "
		cadena_sql=cadena_sql & " 		WHEN HISTORICO_PIRS.CAMPO='ESTADO' THEN (SELECT DESCRIPCION FROM ESTADOS WHERE ID=HISTORICO_PIRS.VALOR_NUEVO)"
		cadena_sql=cadena_sql & " 		WHEN HISTORICO_PIRS.CAMPO='PROVEEDOR' THEN (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=HISTORICO_PIRS.VALOR_NUEVO)"
		cadena_sql=cadena_sql & " 		ELSE REPLACE(HISTORICO_PIRS.VALOR_NUEVO, '""', '\""')"
		cadena_sql=cadena_sql & "  END AS VALOR_NUEVO"
		cadena_sql=cadena_sql & ", HISTORICO_PIRS.USUARIO, HISTORICO_PIRS.DESCRIPCION"
		cadena_sql=cadena_sql & ", (SELECT USUARIOS.NOMBRE FROM USUARIOS WHERE HISTORICO_PIRS.USUARIO = USUARIOS.USUARIO) AS NOMBRE_USUARIO"
		cadena_sql=cadena_sql & " FROM HISTORICO_PIRS"
		cadena_sql=cadena_sql & " WHERE HISTORICO_PIRS.ID_PIR=" & id_pir
		cadena_sql=cadena_sql & " ORDER BY HISTORICO_PIRS.FECHA DESC"



		
		if ver_cadena="SI" then
			response.write("<br>" & cadena_sql & "<br><br>")
		end if
		
		
		
			
	Set rs = Server.CreateObject("ADODB.recordset")
	rs.Open cadena_sql, connmaletas
	Response.ContentType = "application/json"
	'Response.Write "{" & REPLACE(JSONData(rs, "ROWSET"), "\", "\\") & "}"

	cadena_pirs=JSONData(rs, "ROWSET")
	cadena_pirs=REPLACE(cadena_pirs,"\", "\\")
	cadena_pirs=REPLACE(cadena_pirs, chr(13), "\r\n")
	cadena_pirs=REPLACE(cadena_pirs, chr(10), "")
	Response.Write "{" & cadena_pirs & "}"


	'rs.close
	set rs=Nothing
	
	connmaletas.close
	set connmaletas=Nothing
%>



