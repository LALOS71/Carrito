<!--#include file="../DB_Manager.inc"-->
<!--#include file="../Funciones_Mail.asp"-->
<%

Dim s_time
s_time = timer()
' ID de Estado que vamos a consultar
' 1: Emitido
' 4: Consultado
' 5: En estudio
ID_ESTADO_SEGUIMIENTO = 3

ID_ESTADOS 		= Application("CRON_CHECK_STATUS_ID_ESTADOS")
MIN_PRESUPUESTO = Application("CRON_CHECK_STATUS_MIN_PRESUPUESTO")
DAYS_CHECK 		= Application("CRON_CHECK_STATUS_DAYS_CHECK")



change_status()


Dim response_time
response_time = cdbl(timer() - s_time)

dump(response_time)

'
' FUNCIONES
'
Sub change_status()
	'RESPONSE.WRITE("<BR>DENTRO DE CHANGE_STATUS")
	
	fecha_5_dias = DateAdd("d",-DAYS_CHECK,Now())
	fecha_6_meses = DateAdd("m",-6,Now())
	FECHA_ESTADO = Year(fecha_5_dias) & addLeadingZero(Month(fecha_5_dias)) & addLeadingZero(Day(fecha_5_dias))
	FECHA_PRESUPUESTOS = Year(fecha_6_meses) & addLeadingZero(Month(fecha_6_meses)) & addLeadingZero(Day(fecha_6_meses))

	sql = "SELECT ID_PRESUPUESTO, ID_CLIENTE FROM (" &_
			"SELECT *, ROW_NUMBER() OVER (PARTITION BY PRESUPUESTO ORDER BY PRESUPUESTO, VERSION DESC) AS RowNum " &_
			"FROM GESTION_GRAPHISOFT_PRESUPUESTOS " &_
			"" &_
		  ") AS F " &_
		  "WHERE F.RowNum <= 1 " &_
			  "AND ID_ESTADO IN (" & ID_ESTADOS & ") " &_
			  "AND IMPORTE > "&MIN_PRESUPUESTO&" " &_
			  "AND FECHA_CREACION > '" & FECHA_ESTADO & "';"
	
	dump(sql)
	
	Set recordset = execute_sql(conn_gag, sql)
	
	If Not recordset.BOF Then
		presupuestos = recordset.GetRows()
        For i = 0 To UBound(presupuestos, 2)
			id_presupuesto = presupuestos(0, i)
			id_cliente     = presupuestos(1, i)

            <!-- Criterio PRIMER PRESUPUESTO DE CLIENTE o CLIENTE SIN PRESUPUESTOS EN LOS ULTIMOS 6 MESES -->
            sql = "SELECT COUNT(ID_PRESUPUESTO) as TOTAL FROM GESTION_GRAPHISOFT_PRESUPUESTOS" &_
                  " WHERE ID_CLIENTE = " & id_cliente &_
                  " AND NOT ID_PRESUPUESTO = " & id_presupuesto &_
                  " AND FECHA_CREACION > '" & FECHA_PRESUPUESTOS & "';"
				  
		    dump("CONSULTA CONDICIONES PRESUPUESTO: " & sql)
            
            Set recordset2 = execute_sql(conn_gag, sql)
            If Not recordset2.BOF Then
                if recordset2("TOTAL")=0 then
                    sql = "UPDATE GESTION_GRAPHISOFT_PRESUPUESTOS SET ID_ESTADO=" & ID_ESTADO_SEGUIMIENTO & " WHERE ID_PRESUPUESTO=" & id_presupuesto & ";"
                    dump("CONSULTA ACTUALIZACION: " & sql)
                    execute_sql conn_gag, sql
                    enviado = mail_seguimiento(id_presupuesto)
                end if
            End If

        Next
	
	End If
End Sub

%>

