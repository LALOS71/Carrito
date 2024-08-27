<!--#include file="../DB_Manager.inc"-->
<!--#include file="../Funciones_Mail.asp"-->
<%

Dim s_time
s_time = timer()

ID_ESTADO_SEGUIMIENTO = 3

fecha_hoy = Now()
FECHA = Year(fecha_hoy) & addLeadingZero(Month(fecha_hoy)) & addLeadingZero(Day(fecha_hoy))

'fecha="20240120"
send_reminder()


Dim response_time
response_time = cdbl(timer() - s_time)

'response.write "<br />" & response_time

'
' FUNCIONES
'
Sub send_reminder()

	sql = "SELECT * FROM (" &_
			"SELECT *, ROW_NUMBER() OVER (PARTITION BY PRESUPUESTO ORDER BY PRESUPUESTO, VERSION DESC) AS RowNum " &_
			"FROM GESTION_GRAPHISOFT_PRESUPUESTOS " &_
		  ") AS F WHERE F.RowNum <= 1 AND ID_ESTADO = " & ID_ESTADO_SEGUIMIENTO & " AND PROXIMA_REVISION = '" & FECHA & "';"
	response.write("<br>" & sql)
	Set recordset = execute_sql(conn_gag, sql)
	If Not recordset.BOF Then
		presupuestos = recordset.GetRows()
        For i = 0 To UBound(presupuestos, 2)
			id_presupuesto = presupuestos(0, i)
			response.write "<br />Enviamos mail Recordatorio para el id_presupuesto: " & id_presupuesto
			mail_recordatorio(id_presupuesto)
        Next
	
	End If
End Sub

%>

