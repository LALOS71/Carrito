<!--#include file="DB_Manager.inc"-->
<%
	If env = "prod" Then
		conn_gag.Execute("EXEC GESTION_GRAPHISOFT_MODIFICAR_HOJAS_EXISTENTES")
		conn_gag.Execute("EXEC GESTION_GRAPHISOFT_DE_EMITIDO_A_ENVIADO")
		conn_gag.Execute("EXEC GESTION_GRAPHISOFT_DE_EMITIDO_A_CANCELADO")
	End If
	
	Response.Write 1
	
	close_connection(conn_gag)
%>