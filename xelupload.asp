<%
'#################################################
'																									
'	Fichero:			xelupload.asp
'	Descripción:		contiene las clases 
'						"xelUpload" y "Fichero"
'						escritas en VBScript
'
'	Autor:				Carlos de la Orden Dijs
'	Email:				carlos@aspfacil.com
'	Fecha:				Septiembre 2001
'	Documentación:		LEEME.TXT
'
'				Ultima versión en 
'	 		http://www.aspfacil.com/
'	
'-------------------------------------------------
'			Ultima modificación	6/9/2001 
'#################################################

Class xelUpload
' Maneja los formularios enviados como 'multipart/form-data' (ficheros)

Public Ficheros
Private eltosForm

'------------------------------------------------------------------------
Private Sub Class_Initialize()
	set Ficheros = Server.CreateObject("Scripting.Dictionary")
	set eltosForm = Server.CreateObject("Scripting.Dictionary")
End Sub
'------------------------------------------------------------------------
Private Sub Class_Terminate()
	if IsObject(Ficheros) then
		Ficheros.RemoveAll
		set Ficheros = nothing
	end if
	if IsObject(eltosForm) then
		eltosForm.RemoveAll
		set eltosForm = nothing
	end if
End Sub
'------------------------------------------------------------------------
'Permite hacer, por ejemplo: Response.Write(upload.Form("nombre"))
Public Property Get Form(campo)
	if eltosForm.Exists(campo) then
		Form = eltosForm.Item(campo)
	else
		Form = ""
	end if
End Property
'------------------------------------------------------------------------
Public Sub Upload()
'Inicia el proceso. Debe llamarse ANTES DE HACER CUALQUIER OTRA COSA

Dim byteDatos, strControl
Dim iPosInicio, iPosFin, iPos, byteLimite, posLimite
Dim iPosFich, iPosLim

byteDatos = Request.BinaryRead(Request.TotalBytes)
iPosInicio = 1
iPosFin = InStrB(iPosInicio, byteDatos, str2byte(chr(13)))
if (iPosFin-iPosInicio) <= 0 then 
'terminamos, no hay nada que leer
	Exit Sub 
end if
'extraemos el limite de principio y fin de los datos (p.e. -----2323g237623)
byteLimite = MidB(byteDatos, iPosInicio, iPosFin-iPosInicio)
posLimite = InStrB(1, byteDatos, byteLimite)

'terminamos cuando la posición del próximo límite sea igual 
'a la del límite final, que lleva "--" detrás.
do until posLimite = InStrB(byteDatos, byteLimite & str2byte("--"))

	iPos = InStrB(posLimite, byteDatos, str2byte("Content-Disposition"))
	iPos = InStrB(iPos, byteDatos, str2byte("name=")) 'nombre del control en <FORM>
	iPosInicio = iPos + 6 'me salto 6 caracteres -> name=" 
	iPosFin = InStrB(iPosInicio, byteDatos, str2byte(chr(34))) 'busco las comillas de cierre
	'y tengo el nombre del control!
	strControl = byte2str(MidB(byteDatos, iPosInicio, iPosFin-iPosInicio))
	'busco ahora los datos en sí del control
	iPosFich =InStrB(posLimite, byteDatos, str2byte("filename="))
	posLimite = InStrB(iPosFin, byteDatos, byteLimite)
	
	'¿fichero o campo del formulario?
	if iPosFich <> 0 and iPosFich < PosLimite then
		'es un fichero, creo un nuevo objeto fichero y lo añado a Ficheros
		Dim oFichero, strNombre, strForm
		set oFichero = new Fichero
		
		iPosInicio = iPosFich + 10 'me salto 10 caracteres -> filename="
		iPosFin = InStrB(iPosInicio, byteDatos, str2byte(chr(34)))
		strNombre = byte2str(MidB(byteDatos, iPosInicio, iPosFin-iPosInicio))
		'quito la ruta inicial
		oFichero.Nombre = Right(strNombre, Len(strNombre)-InStrRev(strNombre, "\")) '"
		
		iPos = InStrB(iPosFin, byteDatos, str2byte("Content-Type:"))
		iPosInicio = iPos + 14 'me salto Content-Type y un espacio!!
		iPosFin = InStrB(iPosInicio, byteDatos, str2byte(chr(13))) 'busco el retorno de carro
		oFichero.TipoContenido = byte2str(MidB(byteDatos, iPosInicio, iPosFin-iPosInicio))
		
		iPosInicio = iPosFin + 4	'me salto los 3 retornos de carro que lleva!!!
		iPosFin = InStrB(iPosInicio, byteDatos, byteLimite)-2 'dos caracteres atrás
		oFichero.Datos = MidB(byteDatos, iPosInicio, iPosFin-iPosInicio)
		if oFichero.Tamano > 0 then 'lo añado a la colección Ficheros!
			Ficheros.Add strControl, oFichero
		end if
	else
		'es un campo del formulario
		iPos = InStrB(iPos, byteDatos, str2byte(chr(13)))
		iPosInicio = iPos + 4
		iPosFin = InStrB(iPosInicio, byteDatos, byteLimite)-2
		'extraigo el valor del control del formulario!
		strForm = byte2str(MidB(byteDatos, iPosInicio, iPosFin-iPosInicio))
		if not eltosForm.Exists(strControl) then
			eltosForm.Add strControl, strForm
		else
			eltosForm.Item(strControl) =  eltosForm.Item(strControl)+","&strForm
		end if
	end if
	'saltamos al siguiente límite
	iPosLimite = InStrB(iPosLimite+LenB(byteLimite), byteDatos, byteLimite)
loop

End Sub
'------------------------------------------------------------------------
Private Function str2byte ( str )
Dim i, strbuf
for i = 1 to Len(str)
	strbuf = strbuf & ChrB(AscB(Mid(str, i, 1)))
next
str2byte = strbuf
End Function
'------------------------------------------------------------------------
Private Function byte2str ( bin )
Dim i, bytebuf
for i = 1 to LenB(bin)
	bytebuf = bytebuf & Chr(AscB(MidB(bin, i, 1)))
next
byte2str = bytebuf
End Function
'------------------------------------------------------------------------
End Class

'############################ Clase Fichero!!! ##########################

Class Fichero
'------------------------------------------------------------------------
Public Nombre
Public TipoContenido
Public Datos

'------------------------------------------------------------------------
Public Property Get Tamano()
	Tamano = LenB(Datos)
End Property
'------------------------------------------------------------------------
Public Sub Guardar(ruta)
Dim oFSO, oFich
Dim i

if ruta = "" or Nombre = "" then Exit Sub
if Mid(ruta, Len(ruta)) <> "\" then		'"	
	'añado la ultima barra a la ruta
	ruta = ruta & "\" 						'"
end if

set oFSO = Server.CreateObject("Scripting.FileSystemObject")
if not oFSO.FolderExists(ruta) then Exit Sub
set oFich = oFSO.CreateTextFile(ruta & Nombre, true)

for i = 1 to LenB(Datos)
	oFich.Write Chr(AscB(MidB(Datos, i, 1)))
next 	

oFich.Close
set oFSO = nothing
End Sub
'------------------------------------------------------------------------
Public Sub GuardarComo(nombrefichero, ruta)
Dim oFSO, oFich, i

if ruta = "" or nombrefichero = "" then Exit Sub
if Mid(ruta, Len(ruta)) <> "\" then		'"	
	'añado la ultima barra a la ruta
	ruta = ruta & "\" 						'"
end if

set oFSO = Server.CreateObject("Scripting.FileSystemObject")
if not oFSO.FolderExists(ruta) then Exit Sub
set oFich = oFSO.CreateTextFile(ruta & nombrefichero, true)

for i = 1 to LenB(Datos)
	oFich.Write Chr(AscB(MidB(Datos, i, 1)))
next 	

oFich.Close
set oFSO = nothing


End Sub
'------------------------------------------------------------------------
Public Sub GuardarBD (byRef field)
if LenB(Datos) = 0 then Exit Sub

field.AppendChunk Datos
End Sub
End Class
'------------------------------------------------------------------------
%>