<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<!--#include file="xelupload.asp"-->

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
Dim up, fich
set up = new xelUpload
up.Upload()

set  fso=Server.CreateObject("Scripting.FileSystemObject")




		
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


'response.write("<br>ruta: " & ruta)
'response.write("<br>posicion: " & posicion)

ruta=left(ruta,posicion)
'response.write("<br>ruta nueva: " & ruta)

ruta=ruta & "carrusel\img_carrusel\"
'response.write("<br>ruta final: " & ruta)

if not fso.folderexists(ruta) then
		existe_carpeta="no"
		fso.CreateFolder(ruta)
end if

'response.write("<br>ficheros subidod: " & up.Ficheros.Count)




		
		if not fso.folderexists(ruta) then
				existe_carpeta="no"
				fso.CreateFolder(ruta)
		else
				existe_carpeta="si"
		end if

		connimprenta.BeginTrans 'Comenzamos la Transaccion
		
		for i=0 to up.Form("ocultonum_elementos") - 1
					IF up.Form("ocultoempresas_" & i)<>"" THEN
						ocultoempresas=up.Form("ocultoempresas_" & i)
					  else
						ocultoempresas="null"
					end if
					if up.Form("txtorden_" & i)<>"" then
						orden=up.Form("txtorden_" & i)
					  else
						orden="null"
					end if

					'ahora vemos si es una inserccion o una modificacion o un borrado
					'si hay id carrusel, es una modificacion, o un borrado si viene el ocultoaccion con BORRAR
					'y si no hay id carrusel, es una inserccion
					if up.Form("ocultoid_carrusel_" & i)<>"" then
						'si hay que borrar, se elimina el fichero y el registro
						if up.Form("ocultoaccion_" & i)="BORRAR" then
							fso.deletefile(ruta & "\" & up.Form("ocultofichero_" & i))
							
							cadena_ejecucion="DELETE CARRUSEL"
							cadena_ejecucion=cadena_ejecucion & " WHERE ID_CARRUSEL=" & up.Form("ocultoid_carrusel_" & i)

						else
											
							'veo si existe porque si se deja vacio no se envia con el formulario y si pregunto por su valor, daria error
							'si existe, hay que subir el fichero nuevo, borrar el antiguo, y hacer el update
							'si no existe, solo hay que hacer el update
							If up.Ficheros.Exists("txtfichero_" & i) Then
								fichero_asociado=up.Ficheros("txtfichero_" & i).Nombre
								fichero_asociado=LimpiarUrl(fichero_asociado)
								while fso.FileExists(ruta & "\" & fichero_asociado)
									'response.write("<br>nombre de fichero original: " & fichero_asociado)
									posicion_ext=InStrRev(fichero_asociado,".")
									nom_fichero=left(fichero_asociado, posicion_ext - 1)
									ext_fichero=right(fichero_asociado, len(fichero_asociado) - posicion_ext + 1)
									fichero_asociado=nom_fichero & "_" & up.Form("ocultoid_carrusel_" & i) & ext_fichero
									'response.write("<br>nombre de fichero: " & nom_fichero)
									'response.write("<br>extension de fichero: " & ext_fichero)
									'response.write("<br>numevo nombre de fichero: " & fichero_asociado)
								wend
								up.Ficheros("txtfichero_" & i).GuardarComo fichero_asociado, ruta
								
								fso.deletefile(ruta & "\" & up.Form("ocultofichero_" & i))
								
								cadena_ejecucion="UPDATE CARRUSEL"
								cadena_ejecucion=cadena_ejecucion & " SET ORDEN=" & orden
								cadena_ejecucion=cadena_ejecucion & " , EMPRESAS='" & ocultoempresas & "'"
								cadena_ejecucion=cadena_ejecucion & " , FICHERO='" & fichero_asociado & "'"
								cadena_ejecucion=cadena_ejecucion & " WHERE ID_CARRUSEL=" & up.Form("ocultoid_carrusel_" & i)
							  else
								cadena_ejecucion="UPDATE CARRUSEL"
								cadena_ejecucion=cadena_ejecucion & " SET ORDEN=" & orden
								cadena_ejecucion=cadena_ejecucion & " , EMPRESAS='" & ocultoempresas & "'"
								cadena_ejecucion=cadena_ejecucion & " WHERE ID_CARRUSEL=" & up.Form("ocultoid_carrusel_" & i)
							end if
						end if
					else 'inserccion
						'veo si existe porque si se deja vacio no se envia con el formulario y si pregunto por su valor, daria error
						If up.Ficheros.Exists("txtfichero_" & i) Then
							fichero_asociado=up.Ficheros("txtfichero_" & i).Nombre
							fichero_asociado=LimpiarUrl(fichero_asociado)
							while fso.FileExists(ruta & "\" & fichero_asociado)
								'response.write("<br>nombre de fichero original: " & fichero_asociado)
								posicion_ext=InStrRev(fichero_asociado,".")
								nom_fichero=left(fichero_asociado, posicion_ext - 1)
								ext_fichero=right(fichero_asociado,len(fichero_asociado) - posicion_ext + 1)
								fichero_asociado=nom_fichero & "_1" & ext_fichero
								'response.write("<br>nombre de fichero: " & nom_fichero)
								'response.write("<br>extension de fichero: " & ext_fichero)
								'response.write("<br>numevo nombre de fichero: " & fichero_asociado)
							wend
							up.Ficheros("txtfichero_" & i).GuardarComo fichero_asociado, ruta
						  else
							fichero_asociado=""
						end if
						cadena_campos="ORDEN, EMPRESAS, FICHERO"
						cadena_valores=orden & ", '" & ocultoempresas &"', '" & fichero_asociado & "'"
						cadena_ejecucion="Insert into CARRUSEL (" & cadena_campos & ") values(" & cadena_valores & ")"
					end if

					
					'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		Next

	
		connimprenta.CommitTrans ' finaliza la transaccion
				
	

'Limpiamos objeto
set up = nothing
%>


		
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<link href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" rel="stylesheet">
<link href="plugins/bootstrap-touchspin/css/jquery.bootstrap-touchspin.css" rel="stylesheet" type="text/css" media="all">
    
<title></title>
<base target="_self">
<script language="javascript">
	
	// funcion para volver a la pagina opciones.asp y
	//    recibe los parametros para que se pueda configurar como estaba antes
	function volver()
	{
		cadena="<div class='col-md-10 col-md-offset-1' style='margin-top:7px'>"
		cadena=cadena + "<h4>El proceso de Actualizacion del carrusel ha finalizado correctamente.<h4>"
		cadena=cadena + "</div>"
	
			j$("#cabecera_pantalla_avisos").html("Actualizaci&oacute;n Carrusel")
			j$("#body_avisos").html(cadena);
			j$("#pantalla_avisos").modal("show");
			
		
			
		
	}
</script>
</head>

<!-- es en la carga de la pagina, cuando se ha de ejecutar la funcion para volver -->
<body onload="volver()">


<form name="frmdocumentacion" method="post" action="Carrusel_Admin.asp">
</form>

<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->


<script type="text/javascript" src="plugins/jquery/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<script>
var j$=jQuery.noConflict();
j$("#pantalla_avisos").on("hidden.bs.modal", function () {   
		document.frmdocumentacion.submit()
});
</script>	

</body>

</html>
