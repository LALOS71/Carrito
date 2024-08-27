<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->
<!--#include file="../xelupload.asp"-->

<%

	empleado_gls=Request.Querystring("emp")

	if session("usuario")="" then
		if empleado_gls="SI" then
			Response.Redirect("../Login_GLS_Empleados.asp")
		  else
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
		end if
	end if
		
		
		
		estado_consulta="SIN TRATAR"	
		'if session("usuario_tipo")="FRANQUICIA" then
		if session("usuario_tipo")="AGENCIA" then
			'las franquicias solo pueden modificar lo pendiente de pago
			estado_consulta="PENDIENTE PAGO"	
		  else
		  	'estado_consulta="AUTORIZANDO CENTRAL"	
			'QUIEREN QUE AHORA ESTE ESTADO SE LLAME ASI, PENDIENTE AUTORIZACION
			if session("usuario_requiere_autorizacion")="SI" then
				'las oficinas propias sin autorizacion, solo pueden modificar sus pendientes de autorizacion
				' y las que si tienen autorizacion podran cambiar sus sin tratar
				estado_consulta="PENDIENTE AUTORIZACION"	
			end if
		end if
		
	
	
	

		pedido_a_borrar=Request.Form("ocultopedido_a_borrar")
		fecha_pedido=Request.Form("ocultofecha_pedido")
		
		'vemos si lo podemos borrar, no siendo que justo en el tiempo que va desde que selecciona
		' el pedido a borrar y se borra, en la imprenta hayan tramitado algun articulo
		podemos_borrarlo="NO"
		set detalles_pedido=Server.CreateObject("ADODB.Recordset")
		with detalles_pedido
			.ActiveConnection=connimprenta
			.Source="SELECT * FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_a_borrar & " AND ESTADO<>'SIN TRATAR' AND ESTADO<>'PENDIENTE AUTORIZACION' AND ESTADO<>'PENDIENTE PAGO'"
			''response.write("<br>" & .source)
			.Open
		end with
		
		if detalles_pedido.eof then
			podemos_borrarlo="SI"
		end if
		detalles_pedido.close
		set detalles_pedido=Nothing
		
		'cadena_devoluciones_borrar=""
		'set devoluciones_borrar=Server.CreateObject("ADODB.Recordset")
		'with devoluciones_borrar
		'	.ActiveConnection=connimprenta
		'	.Source="SELECT ID_DEVOLUCION FROM DEVOLUCIONES_PEDIDOS WHERE ID_PEDIDO=" & pedido_a_borrar
			''response.write("<br>" & .source)
		'	.Open
		'end with
		
		'while not devoluciones_borrar.eof
		
		'	if cadena_devoluciones_borrar="" then
		'		cadena_devoluciones_borrar=devoluciones_borrar("ID_DEVOLUCION")
		'	  else
		'	'  	cadena_devoluciones_borrar=cadena_devoluciones_borrar & ", " & devoluciones_borrar("ID_DEVOLUCION")
		'	end if
				
		'	devoluciones_borrar.movenext
		'wend
		'devoluciones_borrar.close
		'set devoluciones_borrar=Nothing
		
		'response.write("<br>cadena devoluciones: " & cadena_devoluciones_borrar)
		if podemos_borrarlo="SI" then
				'borro los articulos del pedido, y el pedido
				cadena_ejecucion="DELETE FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_a_borrar
				cadena_ejecucion2="DELETE FROM PEDIDOS WHERE ID=" & pedido_a_borrar
				'cadena_ejecucion3="UPDATE DEVOLUCIONES SET TOTAL_DISFRUTADO=A.TOTAL_DISFRUTADO - ISNULL(B.IMPORTES,0)"
				cadena_ejecucion3="UPDATE DEVOLUCIONES SET TOTAL_DISFRUTADO=ROUND((ISNULL(A.TOTAL_DISFRUTADO,0) - ISNULL(B.IMPORTES,0)),2)"
				
				cadena_ejecucion3=cadena_ejecucion3 & " FROM DEVOLUCIONES A"
				cadena_ejecucion3=cadena_ejecucion3 & " INNER JOIN"
				cadena_ejecucion3=cadena_ejecucion3 & " (SELECT ID_DEVOLUCION, SUM(IMPORTE) AS IMPORTES"
				cadena_ejecucion3=cadena_ejecucion3 & "  FROM DEVOLUCIONES_PEDIDOS"
				cadena_ejecucion3=cadena_ejecucion3 & "  WHERE ID_PEDIDO=" & pedido_a_borrar
				cadena_ejecucion3=cadena_ejecucion3 & "  GROUP BY ID_DEVOLUCION) B"
				cadena_ejecucion3=cadena_ejecucion3 & "  ON A.ID=B.ID_DEVOLUCION"
				
				cadena_ejecucion4="DELETE FROM DEVOLUCIONES_PEDIDOS WHERE ID_PEDIDO=" & pedido_a_borrar
				
				'cadena_ejecucion5="UPDATE SALDOS SET TOTAL_DISFRUTADO=A.TOTAL_DISFRUTADO - ISNULL(B.IMPORTES,0)"
				cadena_ejecucion5="UPDATE SALDOS SET TOTAL_DISFRUTADO=ROUND((ISNULL(A.TOTAL_DISFRUTADO,0) - ISNULL(B.IMPORTES,0)),2)"
				
				cadena_ejecucion5=cadena_ejecucion5 & " FROM SALDOS A"
				cadena_ejecucion5=cadena_ejecucion5 & " INNER JOIN"
				cadena_ejecucion5=cadena_ejecucion5 & " (SELECT ID_SALDO, SUM(IMPORTE) AS IMPORTES"
				cadena_ejecucion5=cadena_ejecucion5 & "  FROM SALDOS_PEDIDOS"
				cadena_ejecucion5=cadena_ejecucion5 & "  WHERE ID_PEDIDO=" & pedido_a_borrar
				cadena_ejecucion5=cadena_ejecucion5 & "  GROUP BY ID_SALDO) B"
				cadena_ejecucion5=cadena_ejecucion5 & "  ON A.ID=B.ID_SALDO"
				
				cadena_ejecucion6="DELETE FROM SALDOS_PEDIDOS WHERE ID_PEDIDO=" & pedido_a_borrar
				connimprenta.BeginTrans 'Comenzamos la Transaccion
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion2,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion3,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion4,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion5,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion6,,adCmdText + adExecuteNoRecords
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
				
				mensaje_aviso=eliminar_pedido_gag_pantalla_avisos_mensaje_aviso
			  else
			  	mensaje_aviso=eliminar_pedido_gag_pantalla_avisos_mensaje_aviso_error
			end if
		
		'si es la cadena General, tenemos que ver si al borrar el pedido se queda sin pedidos, con lo cual
		' tenemos que activar la opcion del descuento del 15% para el primer pedido
		if session("usuario_codigo_empresa")=260 then
			set primer_pedido=Server.CreateObject("ADODB.Recordset")
		
			sql_primer="SELECT COUNT(*) AS PEDIDOS_HECHOS FROM PEDIDOS WHERE CODCLI=" & session("cliente")
			
			'response.write("<br>" & sql)
			cantidad_pedidos=0	
			with primer_pedido
				.ActiveConnection=connimprenta
				.Source=sql_primer
				.Open
			end with
			
			if not primer_pedido.eof then
				cantidad_pedidos=primer_pedido("pedidos_hechos")
			end if
			
			if cantidad_pedidos=0 then
				session("usuario_primer_pedido")="SI"
			  else
				session("usuario_primer_pedido")="NO"
			end if
			
			primer_pedido.close	
			set primer_pedido = Nothing
		end if		
		

%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE><%=eliminar_pedido_gag_title%></TITLE>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="../estilos.css" />
	<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />

</HEAD>
<script language="javascript">
function validar(mensaje)
{
	//alert(mensaje);
	$("#cabecera_pantalla_avisos").html("Avisos")
	$("#body_avisos").html("<br><br><h4>" + mensaje + ".</h4><br><br>");
	$("#pantalla_avisos").modal("show");
					
	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
   
<BODY onload="validar('<%=mensaje_aviso%>')" style="background-color:<%=session("color_asociado_empresa")%> ">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>
<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer" id="botones_avisos">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=eliminar_pedido_gag_pantalla_avisos_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->


<script language="javascript">
$('#pantalla_avisos').on('hidden.bs.modal', function (e) {
  location.href = 'Consulta_Pedidos_Gag.asp?emp=<%=empleado_gls%>'
})

</script>

</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
