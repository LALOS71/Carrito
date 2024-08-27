<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
		
	set usuarios=Server.CreateObject("ADODB.Recordset")
		with usuarios
			.ActiveConnection=connmaletas
			.Source="SELECT STUFF("
			.Source= .Source & " (SELECT '#' + USUARIO "
			.Source= .Source & " FROM USUARIOS"
			.Source= .Source & " WHERE BORRADO='NO'"
			.Source= .Source & " FOR XML PATH (''))"
			.Source= .Source & " , 1, 1, '') AS USUARIOS"
			
			'response.write("<br>" & .source)
			.Open
		end with

		cadena_devuelta=""
		if not usuarios.eof then
			cadena_devuelta="#" & usuarios("usuarios") & "#"
		end if
		
		response.write(cadena_devuelta)

		usuarios.close
		set usuarios=Nothing

	
	connmaletas.close
	set connmaletas=Nothing
%>
