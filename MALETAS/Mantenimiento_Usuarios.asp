<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		'Response.CharSet = "iso-8859-1"

		accion=Request.Form("accion")
		id=Request.Form("id")
		nombre_usuario=Request.Form("nombre_usuario")
		perfil_usuario=Request.Form("perfil_usuario")
		proveedor_usuario=Request.Form("proveedor_usuario")
		usuario_usuario=Request.Form("usuario_usuario")
		tipo_usuario=Request.Form("tipo_usuario")
		contrasenna_usuario=Request.Form("contrasenna_usuario")
		borrado_usuario=Request.Form("borrado_usuario")
		
		if proveedor_usuario="" then
			proveedor_usuario="NULL"
		end if
		
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
			cadena_ejecucion ="UPDATE USUARIOS SET BORRADO='SI' WHERE ID=" & id
			'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		end if

		if accion="ALTA" then
			cadena_campos="USUARIO, NOMBRE, PERFIL, ID_PROVEEDOR, TIPO_USUARIO, CONTRASENNA, BORRADO"
			cadena_valores="'" & usuario_usuario & "', '" & nombre_usuario & "', '" & perfil_usuario & "'"
			cadena_valores=cadena_valores & ", " & proveedor_usuario & ", '" & tipo_usuario & "', '" & contrasenna_usuario & "'"
			cadena_valores=cadena_valores & ", '" & borrado_usuario & "'"
			

			cadena_ejecucion="INSERT INTO USUARIOS (" & cadena_campos & ") VALUES(" & cadena_valores & ")"
								
			'response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		end if
		
		if accion="MODIFICACION" then
			cadena_ejecucion="UPDATE USUARIOS SET"
			cadena_ejecucion=cadena_ejecucion & " USUARIO='" & usuario_usuario & "'"
			cadena_ejecucion=cadena_ejecucion & ", NOMBRE='" & nombre_usuario & "'"
			cadena_ejecucion=cadena_ejecucion & ", PERFIL='" & perfil_usuario & "'"
			cadena_ejecucion=cadena_ejecucion & ", ID_PROVEEDOR=" & proveedor_usuario
			cadena_ejecucion=cadena_ejecucion & ", TIPO_USUARIO='" & tipo_usuario & "'"
			cadena_ejecucion=cadena_ejecucion & ", CONTRASENNA='" & contrasenna_usuario & "'"
			cadena_ejecucion=cadena_ejecucion & ", BORRADO='" & borrado_usuario & "'"

			cadena_ejecucion=cadena_ejecucion & " WHERE ID=" & id
			
			response.write("<br>cadena ejecucion: " & cadena_ejecucion)
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			
		end if
		
		connmaletas.CommitTrans ' finaliza la transaccion
			
		
		
		connmaletas.Close
		set connmaletas=Nothing		
%>
