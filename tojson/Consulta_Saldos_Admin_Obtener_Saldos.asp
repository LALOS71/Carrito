<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	cliente_seleccionado = "" & request.QueryString("p_cliente")
	saldo_seleccionado = "" & request.QueryString("p_saldo")
	ordenante_seleccionado = "" & request.QueryString("p_ordenante")
	tipo_seleccionado = "" & request.QueryString("p_tipo")
	cargo_abono_seleccionado = "" & request.QueryString("p_cargo_abono")
	fecha_ini_seleccionada = "" & request.QueryString("p_fecha_ini")
	fecha_fin_seleccionada = "" & request.QueryString("p_fecha_fin")
	
	ver_cadena = "" & request.QueryString("p_vercadena")
	
	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	
        	
	set saldos=Server.CreateObject("ADODB.Recordset")
		
	with saldos
		.ActiveConnection=connimprenta
		.Source="SELECT A.ID, A.CODCLI, B.NOMBRE + ' (' + CAST(A.CODCLI AS NVARCHAR(7)) + ')' AS NOMBRE_CLIENTE, A.FECHA, A.IMPORTE, D.NOMBRE AS ORDENANTE, C.DESCRIPCION AS TIPO, A.CARGO_ABONO"
		.Source= .Source & ", A.TOTAL_DISFRUTADO, A.OBSERVACIONES"
		.Source= .Source & " FROM SALDOS AS A INNER JOIN V_CLIENTES AS B ON A.CODCLI = B.ID"
		.Source= .Source & " INNER JOIN SALDOS_TIPOS C ON A.TIPO=C.ID"
		.Source= .Source & " INNER JOIN SALDOS_ORDENANTES D ON A.ORDENANTE=D.ID"
		.Source= .Source & " WHERE 1=1"
		if cliente_seleccionado<>"" then
			.Source= .Source & " AND A.CODCLI=" & cliente_seleccionado
		end if
		if saldo_seleccionado<>"" then
			.Source= .Source & " AND A.ID = " & saldo_seleccionado
		end if
		if ordenante_seleccionado<>"" then
			.Source= .Source & " AND A.ORDENANTE = '" & ordenante_seleccionado & "'"
		end if
		if tipo_seleccionado<>"" then
			.Source= .Source & " AND A.TIPO = '" & tipo_seleccionado & "'"
		end if
		if cargo_abono_seleccionado<>"" then
			.Source= .Source & " AND A.CARGO_ABONO = '" & cargo_abono_seleccionado & "'"
		end if
		if fecha_ini_seleccionada<>"" then
			.Source= .Source & " AND (CONVERT(VARCHAR(8), A.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & cdate(fecha_ini_seleccionada) & "', 103) , 112))"
		end if
		if fecha_fin_seleccionada<>"" then
			.Source= .Source & " AND (CONVERT(VARCHAR(8), A.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & cdate(fecha_fin_seleccionada) & "', 103) , 112))"
		end if

		'para que no muestre toda la lista de saldos si no se selecciona nada
		'if ejecutar_consulta<>"SI" then
		'	.Source= .Source & " AND ID=0"
		'end if
			
			
		'.Source= .Source & " ORDER BY ARTICULOS.DESCRIPCION"
		if ver_cadena="SI" then
			response.write("candena consulta: " & .source)
		end if
		.Open
	end with

	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(saldos, "ROWSET") & "}"

	
	set saldos=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>



