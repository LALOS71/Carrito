<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include file="../xelupload.asp"-->
<script language="javascript" runat="server" src="json2_a.asp"></script>

<script language="JScript" runat="server">
function CheckProperty(obj, propName) {
    //return (typeof obj[propName] != "undefined");
	// Verifica si la propiedad existe y si su valor no es null
    return (obj != null && obj.hasOwnProperty(propName) && obj[propName] !== null);
}
</script>

<%

	if session("usuario")="" then
			Response.Redirect("../Login_ATESA.asp")
	end if
		
		Dim up, fich
		set up = new xelUpload
		up.Upload()
		
		set  fso=Server.CreateObject("Scripting.FileSystemObject")
		
		accion=""
		acciones=up.Form("ocultoacciones")
		if acciones<>"" then
			tabla_acciones=Split(acciones,"--")
			accion=tabla_acciones(0)
			pedido_modificar=tabla_acciones(1)
			fecha_pedido=tabla_acciones(2)
		end if
		
		
		
		if accion="MODIFICAR" then 'aqui modificamos pedidos
				'vemos si lo podemos modificar, no siendo que justo en el tiempo que va desde que selecciona
				' el pedido a modificar y se modifica, en la imprenta hayan tramitado algun articulo o simplemente
				' la central de atesa lo confirma para la imprenta
				podemos_modificarlo="NO"
				set detalles_pedido=Server.CreateObject("ADODB.Recordset")
				with detalles_pedido
					.ActiveConnection=connimprenta
					.Source="SELECT * FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_modificar & " AND ESTADO<>'PENDIENTE AUTORIZACION'"
					.Open
				end with
				
				if detalles_pedido.eof then
					podemos_modificarlo="SI"
				end if
				detalles_pedido.close
				set detalles_pedido=Nothing
				
				
				if podemos_modificarlo="SI" then
					'modifico los articulos del pedido
					' para ello, borro los articulos y añado lo que tenga en el carrito
					cadena_ejecucion="DELETE FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_modificar
					'response.write("<br>al ser una modificacion, borro los detalles de ese pedido: " & cadena_ejecucion)
					connimprenta.BeginTrans 'Comenzamos la Transaccion
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					
					for i=1 to Session("numero_articulos")
						'response.write("<br>damos vuelta en con el articulo: " & id)
						id=session(i)
						IF up.Form("ocultocantidad_" & id)<>"" THEN
							cantidad=up.Form("ocultocantidad_" & id)
						  else
							cantidad="null"
						end if
						if up.Form("ocultoprecio_" & id)<>"" then
							precio=up.Form("ocultoprecio_" & id)
						  else
							precio="null"
						end if
						if up.Form("ocultototal_" & id)<>"" then
							total=up.Form("ocultototal_" & id)
						  else
							total="null"
						end if
						'veo si existe porque si se deja vacio no se envia con el formulario y si pregunto por su valor, daria error
						'response.write("<br>vemos si hay fichero asociado")
						
						If up.Ficheros.Exists("txtfichero_" & id) Then
							fichero_asociado=up.Ficheros("txtfichero_" & id).Nombre
							'response.write("<br>como hay fichero asociado: " & fichero_asociado)
							'response.write("<br>compruebo si ya está ese fichero en el servidor, para borrarlo y volverlo a subir")
							'veo si hay que borrar el fichero que habia antes
							if session(i & "_fichero_asociado")<>"" then
								'RESPONSE.WRITE(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado")))
								if fso.FileExists(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado"))) then
									fso.DeleteFile(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado")))
									'response.write("<br>borro el fichero")
								end if
							end if
						  else
						  	'si no sube ningun fichero, puede que quiera mantener el fichero que habia antes, que se encuentra
							'  en la varible de sesion, y si no hay nada, se queda vacio
							fichero_asociado=session(i & "_fichero_asociado")
						end if
						'response.write("<br>fichero asociado variable: " & up.Ficheros("txtfichero_" & id).Nombre)
						'response.write("<br>fichero asociado variable: " & fichero_asociado)
						'response.write("<br>fichero asociado objeto file: up.Form(""txtfichero_" & id & """) " & up.Form("txtfichero_" & id))
						
						
						'''''''''''''''''''''''''''''''''''''''
						''''INICIO SECCION PARA GUARDAR EL JSON de la plantilla
						'guardo el fichero de texto json con la configuracion personalizada del articulo
						'response.write("<br>veo si tiengo que subir un json de plantillas")
						creo_json="NO"
						datos_json=""
						
						'como dan problemas las comillas dobles del json al pasarlo al oculto, lo hago con la variable de sesion
						datos_json=session("json_" & id)
						if datos_json<>"" then
							creo_json="SI"
						end if
						'response.write("<br>este es el contenido json: " & datos_json)
						
						'vacio la variable de sesion con los datos json
						session("json_" & id)=""
						'response.write("<BR>5 - vemos si creamos el fichero json")
						'response.write("<BR>6 - datos_json: " & datos_json)
						if creo_json="SI" then
							ruta_fichero_json= Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar)
							ruta_fichero_json= ruta_fichero_json & "/json_" & id & ".json"
							
							'if fso.FileExists(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado"))) then
							'		fso.DeleteFile(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado")))
							'end if
							
							'--'response.write("<br>nombre del fichero a guardar: " & ruta_fichero_json)
							'--'response.write("<br>contenido fichero: " & datos_json)
		
							'veo si hay que crear la ruta donde dejar el fichero json						
							ruta=Request.ServerVariables("PATH_TRANSLATED")
							'--'response.write("<br>ruta a comprobar para crear: " & ruta)
							longitud_ruta=len(ruta)
							posicion=longitud_ruta
							''response.write("<br>Ruta: " & ruta)
							lugar_encontrado=0
							while posicion>0 and lugar_encontrado=0
								letra_ruta=mid(ruta,posicion,1)
								if letra_ruta="\" then
									lugar_encontrado=posicion
								end if
								''response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
								posicion=posicion-1
							wend
						
							carpeta=left(ruta,lugar_encontrado)
							'--'response.write("<br>carpeta a comprobar si hay que crear: " & carpeta)
							carpeta=carpeta & "pedidos"
							
							if not fso.folderexists(carpeta) then
								existe_carpeta="no"
								fso.CreateFolder(carpeta)
							end if
								
							carpeta=carpeta & "\" & year(fecha_pedido)
							if not fso.folderexists(carpeta) then
								existe_carpeta="no"
								fso.CreateFolder(carpeta)
							end if
							
							carpeta=carpeta & "\" & session("usuario") & "__" & pedido_modificar
							if not fso.folderexists(carpeta) then
								existe_carpeta="no"
								fso.CreateFolder(carpeta)
							end if
							
							'--'response.write("<br>ruta a comprobar si existe y crearla: " & carpeta)
							'response.write("<BR>7 - creamos el fichero en la ruta: " & ruta_fichero_json)
							
							Set fichero_json_crear = fso.CreateTextFile (ruta_fichero_json)
							
							'fichero_json_crear.WriteLine(datos_json)
							'response.write("<BR>DATOS_JSON modificanco: " & datos_json)
							fichero_json_crear.Write(datos_json)
							fichero_json_crear.Close()
							'fso.Close()
							
							set fichero_json_crear=Nothing
							'set fso=nothing
		
		
							dim adjunto_m : set adjunto_m = JSON.parse(datos_json)
							nombre_fichero_adjunto=""
							If CheckProperty(adjunto_m.plantillas.get(0), "ocultofichero") Then
								nombre_fichero_adjunto= adjunto_m.plantillas.get(0).ocultofichero
								ruta_fichero_adjunto= Server.MapPath("./pedidos/adjuntos_plantilla/" & nombre_fichero_adjunto)
							End If
							''response.write("<br>fichero adjunto: " & nombre_fichero_adjunto)
							''response.write("<br>ruta completa fichero adjunto: " & ruta_fichero_adjunto)
							if fso.FileExists(ruta_fichero_adjunto) Then
								'movemos el fichero	
								''response.write("<br>el fichero existe y tenemos que moverlo")
								''response.write("<br>fichero a mover: " & ruta_fichero_adjunto)
								''response.write("<br>ruta destino: " & carpeta)
								ruta_destino_adjunto=carpeta & "\" & nombre_fichero_adjunto
								''response.write("<br>nombre fichero destino: " & ruta_destino_adjunto)
							
								largo_fich=len(ruta_destino_adjunto)
								salir="NO"
								while largo_fich>=1 and salir="NO"
								   ''response.write("Caracter: " & mid(ruta_destino_adjunto,largo_fich,1) & " Asci: " & Asc(mid(ruta_destino_adjunto,largo_fich,1)) & "<br />")
								   if mid(ruta_destino_adjunto,largo_fich,1)="." then
									''response.write("...Caracter: " & mid(ruta_destino_adjunto,largo_fich,1) & " Asci: " & Asc(mid(ruta_destino_adjunto,largo_fich,1)) & "es un punto<br />")
									salir="SI"
								   end if
								   largo_fich=largo_fich-1
								wend
								
								''response.write("<br>posicion del punto: " & largo_fich)
								''response.write("<br>nombre fichero sin extension: " & left(ruta_destino_adjunto,largo_fich))
								fichero_sin_extension=left(ruta_destino_adjunto,largo_fich)
							
								fso.DeleteFile fichero_sin_extension & ".*"
								
								
								'if fso.FileExists(ruta_destino_adjunto) Then
								'	fso.DeleteFile ruta_destino_adjunto
								'end if
								
								'response.write("<BR>7 - movemos fichero... de " & ruta_fichero_adjunto & " a " & ruta_destino_adjunto)
								
								fso.MoveFile ruta_fichero_adjunto, ruta_destino_adjunto
								
							end if
		
						end if ' aqui acabo de subir los ficheros json
						''''''''''''''''''''''''''''
						'''final de seccion para el json
						
						
						
						
						
						
						
						cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION"
						cadena_valores=pedido_modificar & ", " & id & ", " & cantidad & ", " & REPLACE(precio,",",".") & ", " & REPLACE(total,",",".") & ", 'PENDIENTE AUTORIZACION', '" & fichero_asociado & "'"
						cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
						'response.write("<br>inserto el detalle del pedido: " & cadena_ejecucion)
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				
					next
					
					connimprenta.CommitTrans ' finaliza la transaccion
					
					'si no suben ficheros, no tengo porque crear la carpeta
					if up.Ficheros.Count>0 then
					
						ruta=Request.ServerVariables("PATH_TRANSLATED")
						longitud_ruta=len(ruta)
						posicion=longitud_ruta
						'response.write("<br>Ruta: " & ruta)
						lugar_encontrado=0
						while posicion>0 and lugar_encontrado=0
							letra_ruta=mid(ruta,posicion,1)
							if letra_ruta="\" then
								lugar_encontrado=posicion
							end if
							'response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
							posicion=posicion-1
						wend
					
						carpeta=left(ruta,lugar_encontrado)
						'response.write("<br>" & carpeta)
						carpeta=carpeta & "pedidos"
						
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
							
						carpeta=carpeta & "\" & year(fecha_pedido)
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
						
						carpeta=carpeta & "\" & session("usuario") & "__" & pedido_modificar
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
					end if
					'response.write("<br>" & carpeta)
					For each fich in up.Ficheros.Items	
						'subo el fichero al servidor
						'response.write("<br>" & fich.Nombre)
						'fich.GuardarComo fich.Nombre, ruta
						fich.GuardarComo fich.Nombre, Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar)
						'guardo el nombre del documento en la base de datos
					Next
					
					
					mensaje_aviso="El Pedido Ha sido Modificado con Exito..."
				  else
					mensaje_aviso="NO SE HA PODIDO MODIFICAR El Pedido Porque Ya Está Siendo Tramitado por Globalia Artes Gráficas..."
				end if
			
			
			
				
			

		
		
			else 'aqui damos de alta pedidos
				'lo guardamos con el estado de AUTORIZANDO CENTRAL, porque en atesa
				' primero tiene que autorizar el pedido su central para que lo pueda llegar a
				' tramitar la imprenta
				cadena_campos="CODCLI, FECHA, ESTADO"
				cadena_valores=session("usuario") & ", '" & DATE() & "', 'PENDIENTE AUTORIZACION'"
				cadena_ejecucion="Insert into PEDIDOS (" & cadena_campos & ") values(" & cadena_valores & ")"
				'response.write("<br>creamos el pedido. cadena ejecucion: " & cadena_ejecucion)		   
				connimprenta.BeginTrans 'Comenzamos la Transaccion
				
				'porque el sql de produccion es un sql expres que debe tener el formato de
				' de fecha con mes-dia-año
				connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				Set valor_nuevo = connimprenta.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
				numero_pedido=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
				valor_nuevo.Close
				Set valor_nuevo = Nothing
				
				'si no suben ficheros, no tengo porque crear la carpeta
				'response.write("<br>comprobamos si se van a subir ficheros")		   
				if up.Ficheros.Count>0 then
				
					ruta=Request.ServerVariables("PATH_TRANSLATED")
					longitud_ruta=len(ruta)
					posicion=longitud_ruta
					'response.write("<br>Rutafichero a subir: " & ruta)
					lugar_encontrado=0
					while posicion>0 and lugar_encontrado=0
						letra_ruta=mid(ruta,posicion,1)
						if letra_ruta="\" then
							lugar_encontrado=posicion
						end if
						'response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
						posicion=posicion-1
					wend
				
					carpeta=left(ruta,lugar_encontrado)
					'response.write("<br>" & carpeta)
					carpeta=carpeta & "pedidos"
					
					if not fso.folderexists(carpeta) then
						existe_carpeta="no"
						fso.CreateFolder(carpeta)
					end if
						
					carpeta=carpeta & "\" & year(date())
					if not fso.folderexists(carpeta) then
						existe_carpeta="no"
						fso.CreateFolder(carpeta)
					end if
					
					carpeta=carpeta & "\" & session("usuario") & "__" & numero_pedido
					if not fso.folderexists(carpeta) then
						existe_carpeta="no"
						fso.CreateFolder(carpeta)
					end if
				end if
				
				'response.write("<br>" & carpeta)
				For each fich in up.Ficheros.Items	
					'subo el fichero al servidor
					'response.write("<br>" & fich.Nombre)
					'fich.GuardarComo fich.Nombre, ruta
					'response.write("<br>se sube el fichero: " & fich.Nombre & " a la carpeta: " & Server.MapPath("./pedidos/" & year(date()) & "/" & session("usuario") & "__" & numero_pedido))		   
					fich.GuardarComo fich.Nombre, Server.MapPath("./pedidos/" & year(date()) & "/" & session("usuario") & "__" & numero_pedido)
					'guardo el nombre del documento en la base de datos
				Next
				
				for i=1 to Session("numero_articulos")
					id=session(i)
					'response.write("<br>damos la vuelta al articulo: " & id)		   
					
					IF up.Form("ocultocantidad_" & id)<>"" THEN
						cantidad=up.Form("ocultocantidad_" & id)
					  else
						cantidad="null"
					end if
					if up.Form("ocultoprecio_" & id)<>"" then
						precio=up.Form("ocultoprecio_" & id)
					  else
						precio="null"
					end if
					if up.Form("ocultototal_" & id)<>"" then
						total=up.Form("ocultototal_" & id)
					  else
						total="null"
					end if
					'veo si existe porque si se deja vacio no se envia con el formulario y si pregunto por su valor, daria error
					If up.Ficheros.Exists("txtfichero_" & id) Then
						fichero_asociado=up.Ficheros("txtfichero_" & id).Nombre
					  else
						fichero_asociado=""
					end if
					'response.write("<br>fichero asociado variable: " & fichero_asociado)
					'response.write("<br>fichero asociado objeto file: up.Form(""txtfichero_" & id & """) " & up.Form("txtfichero_" & id))
					
					
					'''''''''''''''''''''''''''''''''''
					''''' INICIO SECCION JSON PLANITLLAS
					'guardo el fichero de texto json con la configuracion personalizada del articulo
					'response.write("<br>vemos si hay que subir un json")		   
					
					creo_json="NO"
					datos_json=""
					''response.write("<BR>OCULTODATOS_PERSONALIZACION_JSON...: " & up.Form("ocultodatos_personalizacion_json_" & id)) 
					
					'como dan problemas las comillas dobles del json al pasarlo al oculto, lo hago con la variable de sesion
						datos_json=session("json_" & id)
						if datos_json<>"" then
							creo_json="SI"
						end if
						
					'response.write("<br>datos del json: " & datos_json)	
					'vacio la variable de sesion con los datos json
					session("json_" & id)=""
					
					if creo_json="SI" then
						ruta_fichero_json= Server.MapPath("./pedidos/" & year(date()) & "/" & session("usuario") & "__" & numero_pedido)
						ruta_fichero_json= ruta_fichero_json & "/json_" & id & ".json"
						
						'response.write("<br>nombre del fichero JSONa guardar: " & ruta_fichero_json)
						'response.write("<br>contenido fichero: " & datos_json)

						'veo si hay que crear la ruta donde dejar el fichero json						
						ruta=Request.ServerVariables("PATH_TRANSLATED")
						'--'response.write("<br>ruta a comprobar para crear: " & ruta)
						longitud_ruta=len(ruta)
						posicion=longitud_ruta
						''response.write("<br>Ruta: " & ruta)
						lugar_encontrado=0
						while posicion>0 and lugar_encontrado=0
							letra_ruta=mid(ruta,posicion,1)
							if letra_ruta="\" then
								lugar_encontrado=posicion
							end if
							''response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
							posicion=posicion-1
						wend
					
						carpeta=left(ruta,lugar_encontrado)
						'--'response.write("<br>carpeta a comprobar si hay que crear: " & carpeta)
						carpeta=carpeta & "pedidos"
						
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
							
						carpeta=carpeta & "\" & year(date())
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
						
						carpeta=carpeta & "\" & session("usuario") & "__" & numero_pedido
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
						
						'--'response.write("<br>ruta a comprobar si existe y crearla: " & carpeta)
						
						'response.write("<br>8 - datos_json insertando, antes de los replace: " & datos_json)
						'response.write("<BR>9 - se guarda en esta ruta: " & ruta_fichero_json)
						
						Set fichero_json_crear = fso.CreateTextFile (ruta_fichero_json)
						'salida.Write ("Texto Normal")
						'si el json no tiene el codigo del pedido, se lo ponemos
						if instr(datos_json, chr(34) & "codigo_pedido" & chr(34) & ":" & chr(34) & chr(34)) then
							'--'response.write("<bR>cambio el codigo depedido a: " & numero_pedido)
							cadena_a_cambiar= chr(34) & "codigo_pedido" & chr(34) & ":" & chr(34) & chr(34)
							cadena_sustituta= chr(34) & "codigo_pedido" & chr(34) & ":" & chr(34) & numero_pedido & chr(34)
							'cadena_a_cambiar= "codigo_pedido"
							'cadena_sustituta= "codigo_pedidorrr"
							
							'--'response.write("<br>cadena a cambiar: " & cadena_a_cambiar)
							'--'response.write("<br>cadena sustituta: " & cadena_sustituta)
							datos_json=replace(datos_json, cadena_a_cambiar , cadena_sustituta)
							'response.write("<br>datos json: " & datos_json)
						end if
						
						'fichero_json_crear.WriteLine(datos_json)
						'response.write("<BR>DATOS_JSON insertando despues de los replace: " & datos_json)
							
						fichero_json_crear.Write(datos_json)
						fichero_json_crear.Close()
						'fso.Close()
						
						set fichero_json_crear=Nothing
						'set fso=nothing

						'aqui vemos si hay adjunto y lo movemos de adjuntos_plantilla a su carpeta de pedido correspondiente
						'ruta_adjunto=Request.ServerVariables("PATH_TRANSLATED")
						
						''response.write("<br><br>------------------------------<br>apartado del logo adjunto")
						''response.write("<br>todo el json: " & datos_json)
						dim adjunto : set adjunto = JSON.parse(datos_json)
						nombre_fichero_adjunto=""
						If CheckProperty(adjunto.plantillas.get(0), "ocultofichero") Then
							nombre_fichero_adjunto= adjunto.plantillas.get(0).ocultofichero
							ruta_fichero_adjunto= Server.MapPath("./pedidos/adjuntos_plantilla/" & nombre_fichero_adjunto)
						End If
						''response.write("<br>fichero adjunto: " & nombre_fichero_adjunto)
						''response.write("<br>ruta completa fichero adjunto: " & ruta_fichero_adjunto)
						if fso.FileExists(ruta_fichero_adjunto) Then
							'movemos el fichero	
							''response.write("<br>el fichero existe y tenemos que moverlo")
							''response.write("<br>fichero a mover: " & ruta_fichero_adjunto)
							''response.write("<br>ruta destino: " & carpeta)
							ruta_destino_adjunto=carpeta & "\" & nombre_fichero_adjunto
							''response.write("<br>nombre fichero destino: " & ruta_destino_adjunto)
						
							
							if fso.FileExists(ruta_destino_adjunto) Then
								fso.DeleteFile ruta_destino_adjunto
							end if
							fso.MoveFile ruta_fichero_adjunto, ruta_destino_adjunto
							
						end if
					
					end if
					''''''''''''''''''''''''''''''''''''''
					''''FIN SECCION DEL JSON DE PLANTILLAS
					
					
					
					
					
					
					
					
					
					
					
					'tambien ponemos los detalles del pedido en el estado de AUTORIZANDO CENTRAL para Atesa
					cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION"
					cadena_valores=numero_pedido & ", " & id & ", " & cantidad & ", " & REPLACE(precio,",",".") & ", " & REPLACE(total,",",".") & ", 'PENDIENTE AUTORIZACION', '" & fichero_asociado & "'"
					cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
					'response.write("<br>cadena ejecucion DE INSERSION DE LOS DETALLES DE PEDIDO: " & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			
			next
				
			connimprenta.CommitTrans ' finaliza la transaccion
				
			mensaje_aviso="El Pedido Ha sido Creado con Exito..."			
		end if
		
		
		
		
   
   	
	
	
		
		
	
	
	
	
		
		

	
	
	
	'para elimiar las variables de sesion
	Session("numero_articulos")=0
	
	set fso=Nothing
	set up = nothing
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pedido</TITLE>
</HEAD>
<script language="javascript">
function validar(mensaje)
{
	alert(mensaje);
	document.getElementById('frmgrabar_pedido').submit()	
	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

   
<BODY onload="validar('<%=mensaje_aviso%>')">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>
<form name="frmgrabar_pedido" id="frmgrabar_pedido" method="post" action="Lista_Articulos_Atesa.asp">
</form>
</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
