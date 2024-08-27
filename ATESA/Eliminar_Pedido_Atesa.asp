<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include file="../xelupload.asp"-->

<%

	if session("usuario")="" then
			Response.Redirect("../Login_ATESA.asp")
	end if
		
		pedido_a_borrar=Request.Form("ocultopedido_a_borrar")
		fecha_pedido=Request.Form("ocultofecha_pedido")
		origen=Request.Form("ocultoorigen")
		
		'vemos si lo podemos borrar, no siendo que justo en el tiempo que va desde que selecciona
		' el pedido a borrar y se borra, en la imprenta hayan tramitado algun articulo
		podemos_borrarlo="NO"
		set detalles_pedido=Server.CreateObject("ADODB.Recordset")
		with detalles_pedido
			.ActiveConnection=connimprenta
			.Source="SELECT * FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_a_borrar & " AND ESTADO<>'PENDIENTE AUTORIZACION'"
			.Open
		end with
		
		if detalles_pedido.eof then
			podemos_borrarlo="SI"
		end if
		detalles_pedido.close
		set detalles_pedido=Nothing
		
		if podemos_borrarlo="SI" then
				'borro los articulos del pedido, y el pedido
				cadena_ejecucion="DELETE FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_a_borrar
				cadena_ejecucion2="DELETE FROM PEDIDOS WHERE ID=" & pedido_a_borrar
				connimprenta.BeginTrans 'Comenzamos la Transaccion
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion2,,adCmdText + adExecuteNoRecords
				connimprenta.CommitTrans ' finaliza la transaccion
				
				'borro el contenido de la carpeta del pedido
				carpeta=Server.MapPath(".")
				'response.write("<br>" & carpeta)		
				carpeta=carpeta & "\pedidos"
				carpeta=carpeta & "\" & year(fecha_pedido)
				carpeta=carpeta & "\" & session("usuario") & "__" & pedido_a_borrar
				'response.write("<br>" & carpeta)		
				
				set  fso=Server.CreateObject("Scripting.FileSystemObject")
				
				if fso.FolderExists(carpeta) then
					fso.DeleteFolder(carpeta)
				end if
    			Set fso = Nothing
				
				mensaje_aviso="El Pedido Ha sido Borrado con Exito..."
			  else
			  	mensaje_aviso="NO SE HA PODIDO BORRAR El Pedido Porque Ya Está Siendo Tramitado por Globalia Artes Gráficas..."
			end if
		
		
		
		
		
		

%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Borrar Pedido</TITLE>
</HEAD>
<script language="javascript">
function validar(mensaje, origen)
{
	alert(mensaje);
	if (origen=='ADMIN')
		{
		document.getElementById('frmborrar_pedido').action='Consulta_Pedidos_Atesa_Central_Admin.asp'
		}	
	document.getElementById('frmborrar_pedido').submit()	
	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

   
<BODY onload="validar('<%=mensaje_aviso%>', '<%=origen%>')">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>
<form name="frmborrar_pedido" id="frmborrar_pedido" method="post" action="Consulta_Pedidos_Atesa.asp">
</form>
</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
