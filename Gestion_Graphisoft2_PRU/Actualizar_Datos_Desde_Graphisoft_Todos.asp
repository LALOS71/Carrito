<!--#include file="DB_Manager.inc"-->
<%
	if Request.QueryString("saltar")<> "SI" then
		If env = "prod" Then
			conn_gag.Execute("EXEC GESTION_GRAPHISOFT_INSERTAR_HOJAS_NUEVAS")
			conn_gag.Execute("EXEC GESTION_GRAPHISOFT_MODIFICAR_HOJAS_EXISTENTES")
			conn_gag.Execute("EXEC GESTION_GRAPHISOFT_DE_EMITIDO_A_ENVIADO")
			conn_gag.Execute("EXEC GESTION_GRAPHISOFT_DE_EMITIDO_A_CANCELADO")
		End If
	end if	
	Response.Write 1
	
	close_connection(conn_gag)
%>