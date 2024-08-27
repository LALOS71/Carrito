<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	usuario = "" & request.QueryString("p_usuario")
	fecha_ini_seleccionada = "" & request.QueryString("p_fecha_ini")
	fecha_fin_seleccionada = "" & request.QueryString("p_fecha_fin")
	
	
	ver_cadena= "" & request.QueryString("p_vercadena")
	
	
	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	
        	
	set saldos=Server.CreateObject("ADODB.Recordset")
		
	with saldos
		.ActiveConnection=connimprenta
		.Source="SELECT A.ID, A.FECHA, A.IMPORTE, D.NOMBRE AS ORDENANTE, C.DESCRIPCION AS TIPO, CARGO_ABONO, TOTAL_DISFRUTADO, OBSERVACIONES"
		.Source= .Source & " FROM SALDOS AS A INNER JOIN V_CLIENTES AS B ON A.CODCLI = B.ID"
		.Source= .Source & " INNER JOIN SALDOS_TIPOS C ON A.TIPO=C.ID"
		.Source= .Source & " INNER JOIN SALDOS_ORDENANTES D ON A.ORDENANTE=D.ID"
		.Source= .Source & " WHERE A.CODCLI=" & usuario
		if fecha_ini_seleccionada<>"" then
			.Source= .Source & " AND (CONVERT(VARCHAR(8), A.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & cdate(fecha_ini_seleccionada) & "', 103) , 112))"
		end if
		if fecha_fin_seleccionada<>"" then
			.Source= .Source & " AND (CONVERT(VARCHAR(8), A.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & cdate(fecha_fin_seleccionada) & "', 103) , 112))"
		end if

		'.Source= .Source & " ORDER BY ARTICULOS.DESCRIPCION"
		if ver_cadena="SI" then
			response.write("candena consulta: " & .source)
		end if
		.Open
	end with
	
	
	
	
	
	
	
	
	
	
	Response.ContentType = "application/json"
	cadena_articulos_devoluciones=JSONData(saldos, "ROWSET")
	cadena_articulos_devoluciones=REPLACE(cadena_articulos_devoluciones,"\", "\\")
	cadena_articulos_devoluciones=REPLACE(cadena_articulos_devoluciones, chr(13), "\r\n")
	cadena_articulos_devoluciones=REPLACE(cadena_articulos_devoluciones, chr(10), "")
	Response.Write "{" & cadena_articulos_devoluciones & "}"


	set saldos=Nothing

	
	connimprenta.close
	set connimprenta=Nothing
%>



