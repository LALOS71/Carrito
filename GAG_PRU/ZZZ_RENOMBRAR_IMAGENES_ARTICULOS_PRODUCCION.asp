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

ruta="IMAGENES_NNN\"
response.write("<br>nos vamos a la carpeta: " & Server.MapPath(Ruta))

Set FSO = CreateObject("Scripting.FileSystemObject")




	set articulos=Server.CreateObject("ADODB.Recordset")
	with articulos
		.ActiveConnection=connimprenta
		'RECOGEMOS LOS ARTICULOS NUEVOS
		'.Source="SELECT articulos.ID, articulos.CODIGO_SAP, articulos_empresas.* FROM ARTICULOS inner join ARTICULOS_EMPRESAS"
		'.Source=.Source & " on articulos.id=articulos_empresas.id_articulo WHERE     (articulos.ID >= 1993)"		
		'.Source=.Source & " and codigo_empresa=80 ORDER BY articulos.ID"
		.Source="SELECT articulos.ID, articulos.CODIGO_SAP, articulos_empresas.* FROM ARTICULOS inner join ARTICULOS_EMPRESAS"
		.Source=.Source & " on articulos.id=articulos_empresas.id_articulo WHERE codigo_empresa=4 AND ARTICULOS.BORRADO='NO'"		
		.Source=.Source & " ORDER BY articulos.ID"
		
		
		.Open
	end with



	WHILE NOT ARTICULOS.EOF
	
		RESPONSE.WRITE("<BR>ID: " & ARTICULOS("ID") & " -- CODIGO SAP: " & ARTICULOS("CODIGO_SAP"))
		
		fichero_origen=Server.Mappath(ruta & ARTICULOS("CODIGO_SAP") & ".jpg")
		fichero_destino=Server.Mappath(ruta & ARTICULOS("id") & ".jpg")
		response.write("<br>---------------- origen: " & fichero_origen)
		response.write("<br>---------------- destino: " & fichero_destino)
		
		if fso.fileexists(fichero_origen) then
			response.write("<br><b><font color='red'>---------------------------- EXISTE EL FICHERO: " & fichero_origen & "</font></b>")
		
			fso.movefile fichero_origen, fichero_destino
			'fso.copyfile fichero_origen, fichero_destino
			
		end if
		
		RESPONSE.Flush()
		
		ARTICULOS.MOVENEXT
	WEND



	ARTICULOS.CLOSE
	
	
	
	set ficheritos=FSO.GetFolder(Server.Mappath(ruta))

	response.write("<br><br>AHORA VEMOS SI HAY TALLAJES DE ARTICULOS PARA COMPIAR LA MISMA IMAGEN")
	response.write("<br><br>CARPETA CON LOS FICHEROS....: " & Server.Mappath(ruta) & "<br>")
	for each x in ficheritos.files
	  'Print the name of all files in the test folder
	  codigo_nombre=left(x.Name, len(x.name) - 4)
	  Response.write("<br><br>Fichero: " & x.Name & " -- Codigo: " & codigo_nombre & "<br>")
	  
	  with articulos
			.ActiveConnection=connimprenta
			'RECOGEMOS LOS ARTICULOS NUEVOS
			'.Source="SELECT articulos.ID, articulos.CODIGO_SAP, articulos_empresas.* FROM ARTICULOS inner join ARTICULOS_EMPRESAS"
			'.Source=.Source & " on articulos.id=articulos_empresas.id_articulo WHERE     (articulos.ID >= 1993)"		
			'.Source=.Source & " and codigo_empresa=80 ORDER BY articulos.ID"
			.Source="select id_articulo from tallajes"
			.Source=.Source & " where id_grupo in"
			.Source=.Source & " (select id_grupo from tallajes where id_articulo='" & codigo_nombre & "')"
			.Source=.Source & " and id_articulo<>'" & codigo_nombre & "'"
			
			.Open
		end with
		
		while not articulos.eof
			response.write("<br>el articulo con codigo: " & codigo_nombre & " tiene el tallaje compartido con: " & articulos("id_articulo"))
			
			fichero_origen=Server.Mappath(ruta & codigo_nombre & ".jpg")
			fichero_destino=Server.Mappath(ruta & ARTICULOS("id_articulo") & ".jpg")
			response.write("<br>.........fichero_origen: " & fichero_origen)
			response.write("<br>.........fichero_origen: " & fichero_destino)
			
			
			fso.copyfile fichero_origen, fichero_destino
			articulos.movenext
		wend
		
		ARTICULOS.CLOSE
		
	next
	
	
	
	
	
	
	CONNIMPRENTA.CLOSE
	SET ARTICULOS=NOTHING
	SET CONNIMPRENTA=NOTHING
	
%>