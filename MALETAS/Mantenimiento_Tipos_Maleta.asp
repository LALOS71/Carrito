<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<%

			
		accion=Request.Form("accion")
		id=Request.Form("id")
		codigo_maleta=Request.Form("codigo_maleta")
		descripcion_maleta=Request.Form("descripcion_maleta")
		orden_maleta=Request.Form("orden_maleta")
		borrado_maleta=Request.Form("borrado_maleta")
		
		'response.write("<br>..accion: " & accion & "...")
		'response.write("<br>...id: " & id & "...")
		'response.write("<br>...codigo articulo: " & codigo_articulo & "...")
		'response.write("<br>...cantidad: " & cantidad & "...")
		'response.write("<br>...precio unidad: " & precio_unidad & "...")
		'response.write("<br>...precio pack: " & precio_pack & "...")
		'response.write("<br>...tipo_sucursal: " & tipo_sucursal & "...")
		'response.write("<br>...codigo empresa: " & codigo_empresa & "...")


		if accion="BORRAR" then
			'no se borra... se marca un campo....
			'cadena_ejecucion ="DELETE FROM CANTIDADES_PRECIOS WHERE ID=" & id
			cadena_ejecucion ="UPDATE TIPOS_MALETA SET BORRADO='SI' WHERE ID=" & id
			'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		end if

		if accion="ALTA" then
			cadena_campos="CODIGO, DESCRIPCION, ORDEN, BORRADO"
			cadena_valores="'" & codigo_maleta & "', '" & descripcion_maleta & "', " & orden_maleta & ", '" & borrado_maleta & "'"
			
			cadena_ejecucion="INSERT INTO TIPOS_MALETA (" & cadena_campos & ") VALUES(" & cadena_valores & ")"
								
			'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		end if
		
		if accion="MODIFICACION" then
			cadena_ejecucion="UPDATE TIPOS_MALETA SET"
			cadena_ejecucion=cadena_ejecucion & " CODIGO='" & codigo_maleta & "'"
			cadena_ejecucion=cadena_ejecucion & ", DESCRIPCION='" & descripcion_maleta & "'"
			cadena_ejecucion=cadena_ejecucion & ", ORDEN=" & orden_maleta
			cadena_ejecucion=cadena_ejecucion & ", BORRADO='" & borrado_maleta & "'"
			cadena_ejecucion=cadena_ejecucion & " WHERE ID=" & id
			
			'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		end if
		
		
		
		
		connmaletas.Close
		set connmaletas=Nothing		
%>
