<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<%

			
		accion=Request.Form("accion")
		id=Request.Form("id")
		descripcion_proveedor=Request.Form("descripcion_proveedor")
		orden_proveedor=Request.Form("orden_proveedor")
		borrado_proveedor=Request.Form("borrado_proveedor")
		
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
			cadena_ejecucion ="UPDATE PROVEEDORES SET BORRADO='SI' WHERE ID=" & id
			'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		end if

		if accion="ALTA" then
			cadena_campos="DESCRIPCION, ORDEN, BORRADO"
			cadena_valores="'" & descripcion_proveedor & "', " & orden_proveedor & ", '" & borrado_proveedor & "'"
			
			cadena_ejecucion="INSERT INTO PROVEEDORES (" & cadena_campos & ") VALUES(" & cadena_valores & ")"
								
			'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		end if
		
		if accion="MODIFICACION" then
			cadena_ejecucion="UPDATE PROVEEDORES SET"
			cadena_ejecucion=cadena_ejecucion & " DESCRIPCION='" & descripcion_proveedor & "'"
			cadena_ejecucion=cadena_ejecucion & ", ORDEN=" & orden_proveedor
			cadena_ejecucion=cadena_ejecucion & ", BORRADO='" & borrado_proveedor & "'"
			cadena_ejecucion=cadena_ejecucion & " WHERE ID=" & id
			
			'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		end if
		
		
		
		
		connmaletas.Close
		set connmaletas=Nothing		
%>
