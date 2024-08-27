<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->

<%



	if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
	end if
		
	
	articulos_seleccionados=Request.Form("ocultoarticulos")
	valor_seleccinado="SI"
	if articulos_seleccionados="" then
		articulos_seleccionados=Request.QueryString("articulo")
		valor_seleccionado=Request.QueryString("valor")
	  else
		articulos_seleccionados=left(articulos_seleccionados, len(articulos_seleccionados) - 1)
		'response.write("<br>articulos seleccionados: " & articulos_seleccionados)
		
		articulos_seleccionados=right(articulos_seleccionados, len(articulos_seleccionados) - 1)
		'response.write("<br>articulos seleccionados: " & articulos_seleccionados)
		
		articulos_seleccionados=replace(articulos_seleccionados, "#", ",")
		'response.write("<br>articulos seleccionados: " & articulos_seleccionados)
						
		'response.write("<br>articulos: " & articulos_pedido)
		'response.write("<br>marca: " & Request.Form("ocultomarca_cambio"))
		
		'response.write("<br>pedido..." & pedido_seleccionado)
		'response.write("<br>cadena articulos..." & articulos_pedido)
		'response.write("<br>cadena articulos..." & Request.Form("ocultoarticulos_pedido"))
		
		  
	end if
	'response.write("<br>articulos seleccionados: " & articulos_seleccionados)
	
	
	
	'response.write("<br>hola...")
	'como hay que tocar varias cosas de la base de datos, ponemos una transaccion
	connimprenta.BeginTrans 'Comenzamos la Transaccion
	
		cadena_ejecucion="UPDATE ARTICULOS"
		cadena_ejecucion=cadena_ejecucion & " SET SOLICITADO_AL_PROVEEDOR='" & valor_seleccionado & "'"
		cadena_ejecucion=cadena_ejecucion & " WHERE ID IN (" & articulos_seleccionados & ")"
		
		'response.write("<br><br>cadena: " & cadena_ejecucion)
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
			
		
	
	
	connimprenta.CommitTrans ' finaliza la transaccion






   	
			   
   	'connimprenta.BeginTrans 'Comenzamos la Transaccion
	'connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
	
	'connimprenta.CommitTrans ' finaliza la transaccion
	
	
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pedido</TITLE>
</HEAD>

   
<BODY>
</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
