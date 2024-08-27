<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
RESPONSE.Buffer=TRUE

Ruta = Request.QueryString("Path")


set codigos=Server.CreateObject("ADODB.Recordset")
		


If Ruta = "" then
Ruta="/"
Else
Ruta = Ruta & "/"
End if

ruta="IMAGENES_BIEN_SAP\"
response.write("<br>nos vamos a la carpeta: " & Server.MapPath(Ruta))

Set FSO = CreateObject("Scripting.FileSystemObject")




	set articulos=Server.CreateObject("ADODB.Recordset")
	with articulos
		.ActiveConnection=connimprenta
		'RECOGEMOS LOS ARTICULOS NUEVOS
		.Source="SELECT ID, CODIGO_SAP FROM ARTICULOS WHERE ID>=1332 ORDER BY ID"
		.Open
	end with



	WHILE NOT ARTICULOS.EOF
	
		RESPONSE.WRITE("<BR>ID: " & ARTICULOS("ID") & " -- CODIGO SAP: " & ARTICULOS("CODIGO_SAP"))
		
		fichero_origen=Server.Mappath(ruta & ARTICULOS("CODIGO_SAP") & ".jpg")
		fichero_destino=Server.Mappath(ruta & ARTICULOS("id") & ".jpg")
		response.write("<br>---------------- origen: " & fichero_origen)
		response.write("<br>---------------- destino: " & fichero_destino)
		
		if fso.fileexists(fichero_origen) then
			response.write("<br>---------------------------- EXISTE EL FICHERO: " & fichero_origen)
		
			fso.movefile fichero_origen, fichero_destino
		end if
		
		RESPONSE.Flush()
		
		ARTICULOS.MOVENEXT
	WEND



	ARTICULOS.CLOSE
	CONNIMPRENTA.CLOSE
	SET ARTICULOS=NOTHING
	SET CONNIMPRENTA=NOTHING
	
%>