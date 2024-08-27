<!--#include file="../DB_Manager.inc"-->
<!--#include file="../Funciones_Mail.asp"-->
<%	
Dim s_time
s_time = timer()
' ID de Estado que vamos a consultar
' 1: Emitido
' 4: Consultado
' 5: En estudio
'ID_ESTADOS = "1,4,5"
ID_ESTADOS = "1"
ID_ESTADO_SEGUIMIENTO = 3
MIN_PRESUPUESTO = 500

fecha_6_meses = DateAdd("m",-6,Now())
FECHA = Year(fecha_6_meses) & addLeadingZero(Month(fecha_6_meses)) & addLeadingZero(Day(fecha_6_meses))

change_status()


Dim response_time
response_time = cdbl(timer() - s_time)

'response.write "<br />" & response_time

'
' FUNCIONES
'
Sub change_status()
	'RESPONSE.WRITE("<BR>DENTRO DE CHANGE_STATUS")
	
	sql = "SELECT ID_PRESUPUESTO, IMPORTE, ID_CLIENTE FROM (" &_
			"SELECT *, ROW_NUMBER() OVER (PARTITION BY PRESUPUESTO ORDER BY PRESUPUESTO, VERSION DESC) AS RowNum " &_
			"FROM GESTION_GRAPHISOFT_PRESUPUESTOS " &_
			"" &_
		  ") AS F WHERE F.RowNum <= 1 AND ID_ESTADO IN (" & ID_ESTADOS & ");"
	
	Set recordset = execute_sql(conn_gag, sql)
	
	If Not recordset.BOF Then
		presupuestos = recordset.GetRows()
        For i = 0 To UBound(presupuestos, 2)
			is_update      = false
			id_presupuesto = presupuestos(0, i)
			importe 	   = presupuestos(1, i)
			id_cliente     = presupuestos(2, i)
			
			<!-- Criterio PRESUPUESTO  MAYOR A 500 EUROS -->
			if importe>MIN_PRESUPUESTO then
				is_update = true
			else						
				<!-- Criterio PRIMER PRESUPUESTO DE CLIENTE o CLIENTE SIN PRESUPUESTOS EN LOS ULTIMOS 6 MESES -->
				sql = "SELECT COUNT(ID_PRESUPUESTO) as TOTAL FROM GESTION_GRAPHISOFT_PRESUPUESTOS" &_
					  " WHERE ID_CLIENTE = " & id_cliente &_
					  " AND NOT ID_PRESUPUESTO = " & id_presupuesto &_
					  " AND FECHA_CREACION > '" & FECHA & "';"
				'response.write("<br />CONSULTA CONDICIONES PRESUPUESTO" & sql)
				Set recordset2 = execute_sql(conn_gag, sql)
				If Not recordset2.BOF Then
					' response.write(recordset2("TOTAL") & "<br />")
					if recordset2("TOTAL")>0 then
						is_update = true
					end if
				End If
			End If
			
			if is_update then			
				sql = "UPDATE GESTION_GRAPHISOFT_PRESUPUESTOS SET ID_ESTADO=" & ID_ESTADO_SEGUIMIENTO & " WHERE ID_PRESUPUESTO=" & id_presupuesto & ";"
				'response.write("<br />CONSULTA ACTUALIZACION: " & sql)
				execute_sql conn_gag, sql				
				enviado = mail_seguimiento(id_presupuesto)
			end if
        Next
	
	End If
End Sub

function addLeadingZero(value)
    addLeadingZero = value
    if value < 10 then
        addLeadingZero = "0" & value
    end if
end function
%>

