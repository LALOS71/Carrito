<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<!--#include file="xelupload.asp"-->

<%
'response.write("<br>dentro de grabar_pedido")
	if session("usuario")="" then
			Response.Redirect("Login.asp")
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
				' el pedido a modificar y se modifica, en la imprenta hayan tramitado algun articulo
				podemos_modificarlo="NO"
				set detalles_pedido=Server.CreateObject("ADODB.Recordset")
				with detalles_pedido
					.ActiveConnection=connimprenta
					.Source="SELECT * FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_modificar & " AND ESTADO<>'SIN TRATAR'"
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
					connimprenta.BeginTrans 'Comenzamos la Transaccion
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					
					for i=1 to Session("numero_articulos")
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
						If up.Ficheros.Exists("txtfichero_" & id) Then
							fichero_asociado=up.Ficheros("txtfichero_" & id).Nombre
							'veo si hay que borrar el fichero que habia antes
							if session(i & "_fichero_asociado")<>"" then
								'RESPONSE.WRITE(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado")))
								if fso.FileExists(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado"))) then
									fso.DeleteFile(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado")))
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
						
						precio_coste_art=""
						set precio_coste_articulo=Server.CreateObject("ADODB.Recordset")
						with precio_coste_articulo
							.ActiveConnection=connimprenta
							.Source = "SELECT PRECIO_COSTE FROM ARTICULOS WHERE ID=" & id
							'response.write("<br>....CANDENA PARA VER HIGIENICOS: " & .source)
							.Open
						end with
						if not precio_coste_articulo.eof then
							precio_coste_art="" & precio_coste_articulo("PRECIO_COSTE")		
						end if
			
						precio_coste_articulo.close
						set precio_coste_articulo=Nothing
						
						if precio_coste_art="" then
							precio_coste_art="NULL"
						end if
						
						cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION, PRECIO_COSTE"
						cadena_valores=pedido_modificar & ", " & id & ", " & cantidad & ", " & REPLACE(precio,",",".") & ", " & REPLACE(total,",",".") & ", 'SIN TRATAR', '" & fichero_asociado & "'"
						cadena_valores=cadena_valores & ", " & REPLACE(precio_coste_art,",",".")
						cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
						'response.write("<br>....CANDENA INSERCION: " & cadena_ejecucion)
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
			
				cadena_campos="CODCLI, FECHA, ESTADO, USUARIO_DIRECTORIO_ACTIVO"
				cadena_valores=session("usuario") & ", '" & DATE() & "', 'SIN TRATAR', "
				if  session("usuario_directorio_activo")<>"" then
					cadena_valores=cadena_valores & session("usuario_directorio_activo")
				  else
				  	cadena_valores=cadena_valores & "NULL"
				end if
				cadena_ejecucion="Insert into PEDIDOS (" & cadena_campos & ") values(" & cadena_valores & ")"
				'response.write("<br>cadena ejecucion: " & cadena_ejecucion)		   
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
					fich.GuardarComo fich.Nombre, Server.MapPath("./pedidos/" & year(date()) & "/" & session("usuario") & "__" & numero_pedido)
					'guardo el nombre del documento en la base de datos
				Next
				
				for i=1 to Session("numero_articulos")
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
					If up.Ficheros.Exists("txtfichero_" & id) Then
						fichero_asociado=up.Ficheros("txtfichero_" & id).Nombre
					  else
						fichero_asociado=""
					end if
					'response.write("<br>fichero asociado variable: " & up.Ficheros("txtfichero_" & id).Nombre)
					'response.write("<br>fichero asociado variable: " & fichero_asociado)
					'response.write("<br>fichero asociado objeto file: up.Form(""txtfichero_" & id & """) " & up.Form("txtfichero_" & id))
					
					precio_coste_art=""
					set precio_coste_articulo=Server.CreateObject("ADODB.Recordset")
					with precio_coste_articulo
						.ActiveConnection=connimprenta
						.Source = "SELECT PRECIO_COSTE FROM ARTICULOS WHERE ID=" & id
						'response.write("<br>....CANDENA PARA VER HIGIENICOS: " & .source)
						.Open
					end with
					if not precio_coste_articulo.eof then
						precio_coste_art="" & precio_coste_articulo("PRECIO_COSTE")		
					end if
		
					precio_coste_articulo.close
					set precio_coste_articulo=Nothing
					
					if precio_coste_art="" then
						precio_coste_art="NULL"
					end if
					cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION, PRECIO_COSTE"
					cadena_valores=numero_pedido & ", " & id & ", " & cantidad & ", " & REPLACE(precio,",",".") & ", " & REPLACE(total,",",".") & ", 'SIN TRATAR', '" & fichero_asociado & "'"
					cadena_valores=cadena_valores & ", " & REPLACE(precio_coste_art,",",".")
					cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
					'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
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
<form name="frmgrabar_pedido" id="frmgrabar_pedido" method="post" action="Lista_Articulos.asp">
</form>
</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
