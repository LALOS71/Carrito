<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<%

set  fso=Server.CreateObject("Scripting.FileSystemObject")

'factura=Request.Form("factura")
'ejercicio=Request.Form("ejercicio")
tipo_fichero = "" & Request.QueryString("tipo_fichero")
albaran = "" & Request.QueryString("albaran")
factura = "" & Request.QueryString("factura")
ejercicio = "" & Request.QueryString("ejercicio")

'factura="11687"
'ejercicio="2017"

'construyo el camino hasta la carpeta de la documentacion
'ruta=Request.ServerVariables("APPL_PHYSICAL_PATH")
ruta=Request.ServerVariables("PATH_TRANSLATED")

posicion=InStrRev(ruta,"\")


'response.write("<br>ruta: " & ruta)
'response.write("<br>posicion: " & posicion)

ruta=left(ruta,posicion)
'response.write("<br>ruta nueva: " & ruta)

ruta=ruta & "informes\"
'response.write("<br>ruta final: " & ruta)

if tipo_fichero="ALBARAN" then
	ficherito=ruta & "Alb_" & albaran & ".pdf"
  else
	ficherito=ruta & "Fact_" & factura & "_" & ejercicio & ".pdf"
end if
'response.write("<br>ruta final: " & ficherito)
fso.deletefile(ficherito)

%>


		
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
    
<title></title>
</head>
<body></body>
</html>
