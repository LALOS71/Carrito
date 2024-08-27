<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	usuario = "" & request.QueryString("p_usuario")
	usuario_directorio_activo = "" & request.QueryString("p_usuario_directorio_activo")
	
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
		
	
		
	
	'response.write("<br>EMPRESA: " & empresa_seleccionada)
	'response.write("<br>FAMILIA: " & valor_seleccionado)
	'response.write("<br>poblacion: " & poblacion_seleccionada)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		
		
		
		cadena_sql="SELECT A.ID, A.CODCLI, A.FECHA, A.ESTADO, A.USUARIO_DIRECTORIO_ACTIVO, A.TOTAL_ACEPTADO, A.TOTAL_DISFRUTADO"
		cadena_sql= cadena_sql & ", B.NOMBRE + ' ' + B.APELLIDOS AS NOMBRE_EMPLEADO" 
		cadena_sql= cadena_sql & " FROM DEVOLUCIONES A"
		cadena_sql= cadena_sql & " LEFT JOIN EMPLEADOS_GLS B"
		cadena_sql= cadena_sql & " ON A.USUARIO_DIRECTORIO_ACTIVO=B.ID" 
		cadena_sql= cadena_sql & " WHERE A.CODCLI=" & usuario
		if usuario_directorio_activo<>"" then
				cadena_sql= cadena_sql & " AND A.USUARIO_DIRECTORIO_ACTIVO=" & usuario_directorio_activo
		end if
		cadena_sql= cadena_sql & " ORDER BY FECHA DESC"
		
		
			

		
			
	if ver_cadena="SI" then
		'response.write("<br>empresa: " & empresa_seleccionada)
		'response.write("<br>cliente: " & cliente_seleccionado)
		'response.write("<br>estado: " & estado_seleccionado)
		'response.write("<br>numero pedido: " & numero_pedido_seleccionado)
		'response.write("<br>fecha_inicio: " & fecha_i_seleccionada)
		'response.write("<br>fecha fin: " & fecha_f_seleccionada)
		'response.write("<br>pedido automatico: " & pedido_automatico_seleccionado)
	
		response.write("<br>consulta pedidos: " & cadena_sql)
	end if
	
	Set rs = Server.CreateObject("ADODB.recordset")
	
	'porque el sql de produccion es un sql expres que debe tener el formato de
	' de fecha con mes-dia-año, y al lanzar consultas con fechas da error o
	' da resultados raros
	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	
	rs.Open cadena_sql, connimprenta
	Response.ContentType = "application/json"
	cadena_devoluciones=JSONData(rs, "ROWSET")
	cadena_devoluciones=REPLACE(cadena_devoluciones,"\", "\\")
	cadena_devoluciones=REPLACE(cadena_devoluciones, chr(13), "\r\n")
	cadena_devoluciones=REPLACE(cadena_devoluciones, chr(10), "")
	Response.Write "{" & cadena_devoluciones & "}"



	
	connimprenta.close
	set connimprenta=Nothing
%>



