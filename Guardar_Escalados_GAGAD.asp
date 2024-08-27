<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->


<%

		if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
		end if
		
		
		
		articulo_seleccionado=Request.Form("ocultoarticulo_escalado")
		accion=Request.Form("ocultoaccion_escalado")
		id_escalado=Request.Form("ocultoid_escalado")
		compromiso_compra=Request.Form("ocultocompromiso_compra_escalado")
		cantidad_escalado=replace(Request.Form("ocultocantidad_escalado"), ",", ".")
		precio_unidad_escalado=replace(Request.Form("ocultoprecio_unidad_escalado"), ",",".")
		precio_pack_escalado=replace(Request.Form("ocultoprecio_pack_escalado"), ",", ".")
		tipo_oficina_escalado=Request.Form("ocultotipo_oficina")
		id_empresa_escalado=Request.Form("ocultoid_empresa")
		
		if compromiso_compra="NO" then
			precio_unitario=Request.Form("ocultoprecio_pack_escalado")/ Request.Form("ocultocantidad_escalado")
		  else
		  	precio_unitario=""
		end if
		
		'response.write("<br>accion: " & accion)
		'response.write("<br>articulo seleccionado: " & articulo_seleccionado)
		'response.write("<br>id_escalado: " & id_escalado)
		'response.write("<br>compromiso_compra: " & compromiso_compra)
		'response.write("<br>cantidad escalado: " & cantidad_escalado)
		'response.write("<br>precio unidad escalado: " & precio_unidad_escalado)
		'response.write("<br>precio pack escalado: " & precio_pack_escalado)
		
		'response.write("<br>precio unitario: " & precio_unitario)
		
		
		
		if accion="ALTA" then
			cadena_campos="CODIGO_ARTICULO, CANTIDAD, PRECIO_UNIDAD, PRECIO_PACK, TIPO_SUCURSAL, CODIGO_EMPRESA "
			
			cadena_valores=articulo_seleccionado & ","
			
			if compromiso_compra="NO" then
				cadena_valores=cadena_valores & " " & cantidad_escalado & ","
				cadena_valores=cadena_valores & " " & replace(precio_unitario, ",", ".") & ","
				cadena_valores=cadena_valores & " " & precio_pack_escalado
			  else
			  	cadena_valores=cadena_valores & " null,"
				cadena_valores=cadena_valores & " " & precio_unidad_escalado & ","
				cadena_valores=cadena_valores & " null"
			end if
						
			cadena_valores=cadena_valores & ", '" & tipo_oficina_escalado & "'"
			cadena_valores=cadena_valores & ", " & id_empresa_escalado
			
			connimprenta.BeginTrans 'Comenzamos la Transaccion
			cadena_ejecucion="Insert into CANTIDADES_PRECIOS (" & cadena_campos & ") values(" & cadena_valores & ")"
			'response.write("<br>" & cadena_ejecucion)
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			connimprenta.CommitTrans ' finaliza la transaccion
			
			mensaje_aviso="El Nuevo Escalado del Articulo Ha Sido Dado de Alta Con Exito..."			
		end if
		
		if accion="BORRAR" then
			connimprenta.BeginTrans 'Comenzamos la Transaccion
			cadena_ejecucion="DELETE FROM CANTIDADES_PRECIOS WHERE ID=" &  ID_ESCALADO
			'response.write("<br>" & cadena_ejecucion)
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			connimprenta.CommitTrans ' finaliza la transaccion
			
	
			mensaje_aviso="El Escalado del Articulo Ha Sido Eliminado Con Exito..."			
		
		end if
		
		
		if accion="MODIFICAR" then 'aqui modificamos articulos
					
			cadena_ejecucion="UPDATE CANTIDADES_PRECIOS SET"
			
			if compromiso_compra="NO" then
				cadena_ejecucion=cadena_ejecucion & " CANTIDAD=" & cantidad_escalado
				cadena_ejecucion=cadena_ejecucion & " , PRECIO_UNIDAD=" & replace(precio_unitario, "," , ".")
				cadena_ejecucion=cadena_ejecucion & " , PRECIO_PACK=" & precio_pack_escalado
			  else
			  	cadena_ejecucion=cadena_ejecucion & " CANTIDAD=null"
				cadena_ejecucion=cadena_ejecucion & " , PRECIO_UNIDAD=" & precio_unidad_escalado
				cadena_ejecucion=cadena_ejecucion & " , PRECIO_PACK=null"
			end if
			cadena_ejecucion=cadena_ejecucion & " , TIPO_SUCURSAL='" & tipo_oficina_escalado & "'"
			cadena_ejecucion=cadena_ejecucion & " , CODIGO_EMPRESA=" & id_empresa_escalado
			cadena_ejecucion=cadena_ejecucion & " WHERE ID=" & id_escalado
			'response.write("<br>" & cadena_ejecucion)
			connimprenta.BeginTrans 'Comenzamos la Transaccion
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			connimprenta.CommitTrans ' finaliza la transaccion
			
			mensaje_aviso="El Escalado del Articulo Ha Sido Modificado Con Exito..."			
		end if
		
		
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
	//document.getElementById('frmgrabar_articulo').submit()	
	document.getElementById('frmmostrar_articulo').submit()	

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
<form name="frmmostrar_articulo" id="frmmostrar_articulo" action="Ficha_Articulo_GAGAD.asp" method="post">
	<input type="hidden" value="<%=articulo_seleccionado%>" name="ocultoid_articulo" id="ocultoid_articulo" />
	<input type="hidden" value="MODIFICAR" name="ocultoaccion" id="ocultoaccion" />
</form>
</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
