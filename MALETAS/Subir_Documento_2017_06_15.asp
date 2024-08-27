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


response.write("<br>ruta: " & ruta)
response.write("<br>posicion: " & posicion)

ruta=left(ruta,posicion)
response.write("<br>ruta nueva: " & ruta)

ruta=ruta & "tmp\"
response.write("<br>ruta final: " & ruta)

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

		
		for each fich in up.Ficheros.Items	
			response.write("<br>FICHERO: " & fich.Nombre)	
			fichero_asociado=fich.Nombre
			fichero_asociado=LimpiarUrl(fichero_asociado)
			fich.GuardarComo fichero_asociado, ruta
					
		next
		
		'fso.deletefile(ruta & "\" & fichero_asociado)

		'************************
								
								
		set conn_xls = server.createObject("adodb.connection")
		with conn_xls
			.ConnectionString="Provider=Microsoft.Jet.OLEDB.4.0;" & _
				"Data Source=" & ruta  & "\" & fichero_asociado & ";" & _
				"Extended Properties=Excel 8.0;"
			.Open
		end with

		
		set datos_xls=Server.CreateObject("ADODB.Recordset")
		
		with datos_xls
			.ActiveConnection=conn_xls
			.Source="select * from [HOJA1$]"
			.open
		end with
		
		if not datos_xls.eof then	
			
			
			numCols = datos_xls.Fields.Count
			
			
			response.write("<table  border='1' cellspacing='0' cellpadding='0'>")
			response.write("<tr>")
				For x = 0 To datos_xls.Fields.Count - 1
					'nombre_campo=""
					'nombre_campo=datos_xls.fields(x).name
					response.write("<td>" & datos_xls(x).name & "</td>")
				next
			
				response.write("</tr>")
			
			connmaletas.BeginTrans 'Comenzamos la Transaccion
			cadena_campos="FECHA_ORDEN, ORDEN, AGENTE, EXPEDIENTE, PIR, FECHA_PIR, TAG, NOMBRE, APELLIDOS, DNI,"
			cadena_campos=cadena_Campos & " MOVIL, FIJO, DIRECCION_ENTREGA, CP_ENTREGA, TIPO_DIRECCION_ENTREGA, DESDE_HASTA,"
			cadena_campos=cadena_Campos & " FECHA_DESDE_HASTA, OBSERVACIONES, TIPO_EQUIPAJE_BAG_ORIGINAL, MARCA_BAG_ORIGINAL,"
			cadena_campos=cadena_Campos & " MODELO_BAG_ORIGINAL, MATERIAL_BAG_ORIGINAL, COLOR_BAG_ORIGINAL, LARGO_BAG_ORIGINAL,"
			cadena_campos=cadena_Campos & " ALTO_BAG_ORIGINAL, ANCHO_BAG_ORIGINAL, RUEDAS_BAG_ORIGINAL, ASAS_BAG_ORIGINAL,"
			cadena_campos=cadena_Campos & " CIERRES_BAG_ORIGINAL, CREMALLERA_BAG_ORIGINAL, DANNO, EQUIPAJE, RUTA, VUELOS,"
			cadena_campos=cadena_Campos & " TIPO_BAG_ORIGINAL, FECHA_INICIO, FECHA_ENVIO, FECHA_ENTREGA_PAX, PLAZO_ENTREGA_EN_DIAS,"
			cadena_campos=cadena_Campos & " INCIDENCIA_TRANSPORTE, INCICENCIA, TIPO_BAG_ENTREGADA, TAMANNO_BAG_ENTREGADA,"
			cadena_campos=cadena_Campos & " REFERENCIA_BAG_ENTREGADA, COLOR_BAG_ENTREGADA, NUM_EXPEDICION"

			
			while not datos_xls.eof
				response.write("<tr>")
				For x = 0 To datos_xls.Fields.Count - 1
					'nombre_campo=""
					'nombre_campo=datos_xls.fields(x).name
					response.write("<td>" & datos_xls(x) & "</td>")
					
					
				next
				'cadena_valores="'" & datos_xls("FECHAORDEN") & "', '" & datos_xls("ORDEN") & "', '" & datos_xls("AGENTE") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("EXPEDIENTE") & "', '" & datos_xls("PIR") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("FECHAPIR") & "', '" & datos_xls("TAG") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("NOMBRE") & "', '" & datos_xls("APELLIDOS") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("DNI") & "', '" & datos_xls("MOVIL") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("FIJO") & "', '" & datos_xls("DIRENTREGA") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("CPOSTAL") & "', '" & datos_xls("TIPODIRECCION") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("DESDEHASTA") & "', '" & datos_xls("FECHADESDEHASTA") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("OBSERVACIONES") & "', '" & datos_xls("TIPOEQUIPAJE") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("MARCA") & "', '" & datos_xls("MODELO") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("MATERIAL") & "', '" & datos_xls("COLOR") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("LARGO") & "', '" & datos_xls("ALTO") & "'" 
				'cadena_valores=cadena_valores & ", '" & datos_xls("ANCHO") & "', '" & datos_xls("RUEDAS") & "'" 
				'cadena_valores=cadena_valores & ", '" & datos_xls("ASAS") & "', '" & datos_xls("CIERRES") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("CREMALLERAS") & "', '" & datos_xls("DA—O") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("EQUIPAJE") & "', '" & datos_xls("RUTA") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("VUELOS") & "', '" & datos_xls("TIPO") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("FECHA INICIO") & "', '" & datos_xls("FECHA ENVÕO") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("FECHA ENTREGA PAX") & "', '" & datos_xls("PLAZO ENTREGA EN DÕAS") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("INCIDENCIA TRANSPORTE") & "', '" & datos_xls("INCIDENCIA") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("TIPO BAG ENTREGADA") & "', '" & datos_xls("TAMA—O") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("REFERENCIA") & "', '" & datos_xls("COLOR") & "'"
				'cadena_valores=cadena_valores & ", '" & datos_xls("N∫ EXPEDICION") & "'"
				
				cadena_valores="'" & datos_xls(0) & "', '" & datos_xls(1) & "', '" & datos_xls(2) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(3) & "', '" & datos_xls(4) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(5) & "', '" & datos_xls(6) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(7) & "', '" & datos_xls(8) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(9) & "', '" & datos_xls(10) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(11) & "', '" & datos_xls(12) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(13) & "', '" & datos_xls(14) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(15) & "', '" & datos_xls(16) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(17) & "', '" & datos_xls(18) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(19) & "', '" & datos_xls(20) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(21) & "', '" & datos_xls(22) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(23) & "', '" & datos_xls(24) & "'" 
				cadena_valores=cadena_valores & ", '" & datos_xls(25) & "', '" & datos_xls(26) & "'" 
				cadena_valores=cadena_valores & ", '" & datos_xls(27) & "', '" & datos_xls(28) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(29) & "', '" & datos_xls(30) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(31) & "', '" & datos_xls(32) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(33) & "', '" & datos_xls(34) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(35) & "', '" & datos_xls(36) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(37) & "', '" & datos_xls(38) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(39) & "', '" & datos_xls(40) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(41) & "', '" & datos_xls(42) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(43) & "', '" & datos_xls(44) & "'"
				cadena_valores=cadena_valores & ", '" & datos_xls(45) & "'"
				
				
				
				cadena_ejecucion="Insert into PIRS (" & cadena_campos & ") values(" & cadena_valores & ")"
				response.write("<br><br>" & cadena_ejecucion)
				connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				
				
				response.write("</tr>")
				datos_xls.movenext
			wend			
			
			
			connmaletas.CommitTrans ' finaliza la transaccion

			response.write("</table>")	
		end if
		
datos_xls.close
conn_xls.close
connmaletas.close

set datos_xls=Nothing
set conn_xls=Nothing
set connmaletas=Nothing

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
		cadena=cadena + "<h4>El proceso de importaci&oacute;n ha finalizado correctamente.<h4>"
		cadena=cadena + "</div>"
	
			j$("#cabecera_pantalla_avisos").html("Importaci&oacute;n Fichero Excel")
			j$("#body_avisos").html(cadena);
			j$("#pantalla_avisos").modal("show");
			
		
			
		
	}
</script>
</head>

<!-- es en la carga de la pagina, cuando se ha de ejecutar la funcion para volver -->
<body onload="volver()">


<form name="frmdocumentacion" method="post" action="Fichero_a_Importar.asp">
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
		//document.frmdocumentacion.submit()
});
</script>	

</body>

</html>
