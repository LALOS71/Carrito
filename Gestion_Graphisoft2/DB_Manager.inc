<!--#include file="Conexion_GAG.inc"-->
<%

Function execute_sql(con, query)
    Dim result
    Set result = Server.CreateObject("ADODB.Recordset")

    With result
		.ActiveConnection=con
		.Source=query
		.Open
	End With

    Set execute_sql = result
End Function

Sub execute_sql_with_options(con, query, options)
    con.Execute query,,options
End Sub

%>