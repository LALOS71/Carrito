<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include file="../xelupload.asp"-->

<%

	if session("usuario")="" then
			Response.Redirect("../Login_ATESA.asp")
	end if
		
		pedido_a_modificar=Request.Form("ocultopedido_a_modificar")
		accion=Request.Form("ocultoaccion")
		
		
		if accion="CONFIRMAR" then
				'borro los articulos del pedido, y el pedido
				cadena_ejecucion="UPDATE PEDIDOS_DETALLES SET ESTADO='SIN TRATAR' WHERE ID_PEDIDO=" & pedido_a_modificar
				cadena_ejecucion2="UPDATE PEDIDOS SET ESTADO='SIN TRATAR' WHERE ID=" & pedido_a_modificar
				connimprenta.BeginTrans 'Comenzamos la Transaccion
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion2,,adCmdText + adExecuteNoRecords
				connimprenta.CommitTrans ' finaliza la transaccion
				mensaje_aviso="El Pedido Ha sido Confirmado, Globalia Artes Gráficas podrá empezar a Tramitarlo..."
			  else
			  	'mensaje_aviso="NO SE HA PODIDO BORRAR El Pedido Porque Ya Está Siendo Tramitado por Globalia Artes Gráficas..."
			end if
		
		
		
		
		
		

%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Borrar Pedido</TITLE>
</HEAD>
<script language="javascript">
function validar(mensaje, accion)
{
	
	if (accion=='CONFIRMAR')
		{
		alert(mensaje);
		document.getElementById('frmconfirmar_pedido').submit()	
		}
	
	if (accion=='MODIFICAR')
		{
		document.getElementById('frmmodificar_pedido').submit()	
		}
	
	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

   
<BODY onload="validar('<%=mensaje_aviso%>', '<%=accion%>')">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>
<form name="frmconfirmar_pedido" id="frmconfirmar_pedido" method="post" action="Consulta_Pedidos_Atesa_Central_Admin.asp">
</form>

<form action="Rellenar_Variables_Sesion_Atesa_Central_Admin.asp" method="post" name="frmmodificar_pedido" id="frmmodificar_pedido">
	<input type="hidden" id="ocultopedido_a_modificar" name="ocultopedido_a_modificar" value="<%=pedido_a_modificar%>" />
</form>

</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
