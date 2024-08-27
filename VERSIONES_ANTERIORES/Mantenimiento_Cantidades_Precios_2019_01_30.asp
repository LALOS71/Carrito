<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<%

		if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
		end if
		
		accion=Request.Form("accion")
		id=Request.Form("id")
		codigo_articulo=Request.Form("codigo_articulo")
		cantidad=Request.Form("cantidad")
		precio_unidad=Request.Form("precio_unidad")
		precio_pack=Request.Form("precio_pack")
		tipo_sucursal=Request.Form("tipo_sucursal")
		codigo_empresa=Request.Form("codigo_empresa")
		
		if cantidad="" then
			cantidad="NULL"
		end if
		if precio_unidad="" then
			precio_unidad="NULL"
		end if
		if precio_pack="" then
			precio_pack="NULL"
		end if
		'response.write("<br>..accion: " & accion & "...")
		'response.write("<br>...id: " & id & "...")
		'response.write("<br>...codigo articulo: " & codigo_articulo & "...")
		'response.write("<br>...cantidad: " & cantidad & "...")
		'response.write("<br>...precio unidad: " & precio_unidad & "...")
		'response.write("<br>...precio pack: " & precio_pack & "...")
		'response.write("<br>...tipo_sucursal: " & tipo_sucursal & "...")
		'response.write("<br>...codigo empresa: " & codigo_empresa & "...")


		if accion="BORRAR" then
			cadena_ejecucion ="DELETE FROM CANTIDADES_PRECIOS WHERE ID=" & id
			'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

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
		
		
		
		
		connimprenta.Close
		set connimprenta=Nothing		
%>
