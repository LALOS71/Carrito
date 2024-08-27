<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../xelupload.asp"-->

<%
Function LimpiarUrl(texto)
	'response.write("<br>texto que llega: " & texto)
    
    Dim objRegExp
    Set objRegExp = New Regexp
    
    objRegExp.IgnoreCase = True
    objRegExp.Global = True
    
    objRegExp.Pattern = "\s+"
    texto = objRegExp.Replace(texto, " ")
	
	'response.write("<br>texto despues del primer replace: " & texto)
    
    'objRegExp.Pattern = "[(?*"",\\<>&#~%{}+.@:\/!;']+"
	objRegExp.Pattern = "[(?*"",\\<>&#~%{}+@:\/!;']+"
    texto = objRegExp.Replace(texto, "")
	
	'response.write("<br>texto despues del segundo replace: " & texto)
    
    Dim i, s1, s2
    s1 = "¡¿…»Õœ”“⁄‹·‡ËÈÌÔÛÚ˙¸ÒÁ "
    s2 = "AAEEIIOOUUaaeeiioouunc-"
    If Len(texto) <> 0 Then
        For i = 1 To Len(s1)
            texto = Replace(texto, Mid(s1,i,1), Mid(s2,i,1))
        Next
    End If
	
	'response.write("<br>texto despues de quitar acentos: " & texto)

    LimpiarUrl = texto

End Function
%>


<%
todo_ok="NO"
Dim up, fich
set up = new xelUpload
up.Upload()

set  fso=Server.CreateObject("Scripting.FileSystemObject")

anno_adjunto = "" & up.Form("ocultoanno_pedido_adjunto")
cliente_adjunto = "" & up.Form("ocultocliente_adjunto")
pedido_adjunto = "" & up.Form("ocultopedido_adjunto")
articulo_adjunto = "" & up.Form("ocultoarticulo_adjunto")


if anno_adjunto="" then
	anno_adjunto=year(date())
end if

		
'Response.Write("<br>aplicacion: " & codigo_aplicacion)
'Response.Write("<br>nombre: " & nombre_aplicacion)

'Response.Write("<br>tipoacceso: " & tipoacceso)
'Response.Write("<br>usuario: " & usuario)
'Response.Write("<br>codigo_utilizado: " & codigo_utilizado)
'Response.Write("<br>accion: " & accion)
'Response.Write("<br>fichero_a_borrar: " & fichero_a_borrar)



'Response.Write("N˙mero de ficheros subidos: " & up.Ficheros.Count & "<br>")
Response.Flush

'construyo el camino hasta la carpeta de la documentacion
'ruta=Request.ServerVariables("APPL_PHYSICAL_PATH")
ruta=Request.ServerVariables("PATH_TRANSLATED")


posicion=InStrRev(ruta,"\")


response.write("<br>ruta: " & ruta)
'response.write("<br>posicion: " & posicion)

ruta=left(ruta,posicion)
response.write("<br>ruta nueva: " & ruta)

ruta=ruta & "..\GAG\Pedidos\adjuntos_plantilla\"
response.write("<br>ruta final: " & ruta)

if not fso.folderexists(ruta) then
		existe_carpeta="no"
		fso.CreateFolder(ruta)
end if

'response.write("<br>ficheros subidod: " & up.Ficheros.Count)





If up.Ficheros.Exists("txtfichero_logo") Then
	fichero_asociado=up.Ficheros("txtfichero_logo").Nombre
	response.write("<br>fichero asociado: " & fichero_asociado)
	fichero_asociado=LimpiarUrl(fichero_asociado)
	response.write("<br>fichero asociado limpieado: " & fichero_asociado)

		'response.write("<br>nombre de fichero original: " & fichero_asociado)
		posicion_ext=InStrRev(fichero_asociado,".")
		nom_fichero=left(fichero_asociado, posicion_ext - 1)
		ext_fichero=right(fichero_asociado,len(fichero_asociado) - posicion_ext + 1)
		response.write("<br>nombre de fichero: " & nom_fichero)
		response.write("<br>extension de fichero: " & ext_fichero)
		response.write("<br>numevo nombre de fichero: " & fichero_asociado)

	up.Ficheros("my_file").GuardarComo fichero_asociado, ruta
end if

response.write("<br>llegamos al for each")

For each fich in up.Ficheros.Items	

		
		if not fso.folderexists(ruta) then
				existe_carpeta="no"
				fso.CreateFolder(ruta)
		else
				existe_carpeta="si"
		end if

		'subo el fichero al servidor
		response.write("<br>nombre fichero: " & fich.Nombre)
		
		fichero_asociado=fich.Nombre
		'response.write("<br>nombre de fichero original: " & fichero_asociado)
		posicion_ext=InStrRev(fichero_asociado,".")
		nom_fichero=left(fichero_asociado, posicion_ext - 1)
		ext_fichero=right(fichero_asociado,len(fichero_asociado) - posicion_ext + 1)
		response.write("<br>nombre de fichero: " & nom_fichero)
		response.write("<br>extension de fichero: " & ext_fichero)
		response.write("<br>numevo nombre de fichero: " & fichero_asociado)
		
		nuevo_nombre= "Logo_" & cliente_adjunto & "__" & articulo_adjunto & ext_fichero
		
		response.write("<br>nuevo nombre: " & nuevo_nombre)
		fich.GuardarComo nuevo_nombre, ruta
		
		'guardo el nombre del documento en la base de datos
	Next

response.write("<br>despues del for each")
	

'Limpiamos objeto
set up = nothing
todo_ok="SI"
%>


		
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<link href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" rel="stylesheet">
<link href="../plugins/bootstrap-touchspin/css/jquery.bootstrap-touchspin.css" rel="stylesheet" type="text/css" media="all">
    
<title></title>
<base target="_self">

<script language="javascript">

function volver(valor)
{
console.log('entramos en volver')
if (valor=='SI')
	{
	console.log('el valor es si')
	j$('#cmdsubir_adjunto', window.parent.document).html('');
	j$("#guardar_plantillas", window.parent.document).prop("disabled",false);
	console.log('despues de quitar el spin')
	}
}

</script>

</head>

<!-- es en la carga de la pagina, cuando se ha de ejecutar la funcion para volver -->
<body onload="volver('<%=todo_ok%>')">




<script type="text/javascript" src="../plugins/jquery/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<script>
var j$=jQuery.noConflict();
</script>	

</body>

</html>
