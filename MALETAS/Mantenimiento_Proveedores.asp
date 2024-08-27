<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		'Response.CharSet = "iso-8859-1"

			
		accion=Request.Form("accion")
		id=Request.Form("id")
		descripcion_proveedor=Request.Form("descripcion_proveedor")
		orden_proveedor=Request.Form("orden_proveedor")
		borrado_proveedor=Request.Form("borrado_proveedor")
		tipos_maletas_seleccionadas=Request.Form("tipos_maletas_seleccionadas")
		
		response.write("<br>tipos maletas: " & tipos_maletas_seleccionadas)
		tabla_maletas=Split(tipos_maletas_seleccionadas,"#")
		
		
		'response.write("<br>..accion: " & accion & "...")
		'response.write("<br>...id: " & id & "...")
		'response.write("<br>...codigo articulo: " & codigo_articulo & "...")
		'response.write("<br>...cantidad: " & cantidad & "...")
		'response.write("<br>...precio unidad: " & precio_unidad & "...")
		'response.write("<br>...precio pack: " & precio_pack & "...")
		'response.write("<br>...tipo_sucursal: " & tipo_sucursal & "...")
		'response.write("<br>...codigo empresa: " & codigo_empresa & "...")

		connmaletas.BeginTrans

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
			Set valor_nuevo = connmaletas.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
			nuevo_proveedor=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
			valor_nuevo.Close
			Set valor_nuevo = Nothing
			
			for each x in tabla_maletas
				if x<>"" then
					cadena_ejecucion="INSERT INTO PROVEEDORES_TIPOS_MALETA (ID_PROVEEDOR, ID_TIPO_MALETA) VALUES(" & nuevo_proveedor & ", " & x & ")"
					response.write("<br>cadena: " & cadena_ejecucion)
					connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				end if
			next

		end if
		
		if accion="MODIFICACION" then
			cadena_ejecucion="UPDATE PROVEEDORES SET"
			cadena_ejecucion=cadena_ejecucion & " DESCRIPCION='" & descripcion_proveedor & "'"
			cadena_ejecucion=cadena_ejecucion & ", ORDEN=" & orden_proveedor
			cadena_ejecucion=cadena_ejecucion & ", BORRADO='" & borrado_proveedor & "'"
			cadena_ejecucion=cadena_ejecucion & " WHERE ID=" & id
			
			response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			
			cadena_ejecucion="DELETE PROVEEDORES_TIPOS_MALETA WHERE ID_PROVEEDOR=" & id
			response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			
			for each x in tabla_maletas
				if x<>"" then
					cadena_ejecucion="INSERT INTO PROVEEDORES_TIPOS_MALETA (ID_PROVEEDOR, ID_TIPO_MALETA) VALUES(" & id & ", " & x & ")"
					response.write("<br>cadena: " & cadena_ejecucion)
					connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				end if
			next


		end if
		
		connmaletas.CommitTrans ' finaliza la transaccion
			
		
		
		connmaletas.Close
		set connmaletas=Nothing		
%>
