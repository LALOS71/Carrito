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

ruta="Imagenes_Articulos_P_R\"
ruta_miniaturas="Imagenes_Articulos_P_R\Miniaturas\"
response.write("<br>nos vamos a la carpeta: " & Server.MapPath(Ruta))

Set FSO = CreateObject("Scripting.FileSystemObject")




	set articulos=Server.CreateObject("ADODB.Recordset")
	with articulos
		.ActiveConnection=connimprenta
		'RECOGEMOS LOS ARTICULOS NUEVOS
		.Source="SELECT codigo_pruebas, codigo_real FROM ARTICULOS_p_r ORDER BY CODIGO_PRUEBAS desc"
		.Open
	end with



	WHILE NOT ARTICULOS.EOF
	
		RESPONSE.WRITE("<BR>ID pruebas: " & ARTICULOS("codigo_pruebas") & " -- CODIGO real: " & ARTICULOS("CODIGO_real"))
		
		fichero_origen=Server.Mappath(ruta & ARTICULOS("codigo_pruebas") & ".jpg")
		fichero_destino=Server.Mappath(ruta & ARTICULOS("codigo_real") & ".jpg")
		response.write("<br>---------------- origen: " & fichero_origen)
		response.write("<br>---------------- destino: " & fichero_destino)
		
		if fso.fileexists(fichero_origen) then
			response.write("<br>---------------------------- EXISTE EL FICHERO: " & fichero_origen)
              		
			fso.movefile fichero_origen, fichero_destino
		end if
		
		'AHORA VAMOS CON LA MINIATURA
		fichero_origen=Server.Mappath(ruta_miniaturas & "i_" & ARTICULOS("codigo_pruebas") & ".jpg")
		fichero_destino=Server.Mappath(ruta_miniaturas & "i_" & ARTICULOS("codigo_real") & ".jpg")
		response.write("<br>---------------- origen miniatura: " & fichero_origen)
		response.write("<br>---------------- destino miniatura: " & fichero_destino)
		
		if fso.fileexists(fichero_origen) then
			response.write("<br>---------------------------- EXISTE EL FICHERO miniatura: " & fichero_origen)
              		
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