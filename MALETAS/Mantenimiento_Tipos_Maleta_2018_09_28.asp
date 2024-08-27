<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<%

		if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
		end if
		
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
			cadena_campos="CODIGO_ARTICULO, CANTIDAD, PRECIO_UNIDAD, PRECIO_PACK, TIPO_SUCURSAL, CODIGO_EMPRESA"
			cadena_valores=codigo_articulo & ", " & cantidad & ", " & precio_unidad & ", " & precio_pack
			cadena_valores=cadena_valores & ", '" & tipo_sucursal & "', " & codigo_empresa
			
			cadena_ejecucion="INSERT INTO CANTIDADES_PRECIOS (" & cadena_campos & ") VALUES(" & cadena_valores & ")"
								
			'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		end if
		
		if accion="MODIFICACION" then
			cadena_ejecucion="UPDATE CANTIDADES_PRECIOS SET"
			cadena_ejecucion=cadena_ejecucion & " CANTIDAD=" & cantidad
			cadena_ejecucion=cadena_ejecucion & ", PRECIO_UNIDAD=" & precio_unidad
			cadena_ejecucion=cadena_ejecucion & ", PRECIO_PACK=" & precio_pack
			cadena_ejecucion=cadena_ejecucion & " WHERE ID=" & id
			
			'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		end if
		
		
		
		
		connmaletas.Close
		set connmaletas=Nothing		
%>
