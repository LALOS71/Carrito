<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include file="../xelupload.asp"-->

<%

sub mail_confirmacion_autorizacion_pedido(pedido, accion)%>
	<!--#include file="../Conexion_ORACLE_Envios_Distri_PRODUCCION.inc"-->


<%

'SELECT     PEDIDOS.ID, PEDIDOS.CODCLI, V_CLIENTES.CODIGO_EXTERNO, V_CLIENTES.NOMBRE, V_CLIENTES.DIRECCION, V_CLIENTES.POBLACION, V_CLIENTES.PROVINCIA, V_CLIENTES.CP, 
'                      V_CLIENTES.EMAIL, V_CLIENTES.TELEFONO, V_CLIENTES.JEFE_ECONOMATO, V_CLIENTES.FAX, V_EMPRESAS.EMPRESA, V_EMPRESAS.CARPETA, V_EMPRESAS_CENTRAL.EMPRESA AS Expr1, 
'                      V_EMPRESAS_CENTRAL.CODIGO_AD,A.EMAIL
'FROM         PEDIDOS INNER JOIN
'                      V_CLIENTES ON PEDIDOS.CODCLI = V_CLIENTES.ID INNER JOIN
'                      V_EMPRESAS ON V_CLIENTES.EMPRESA = V_EMPRESAS.ID INNER JOIN
'                      V_EMPRESAS_CENTRAL ON V_EMPRESAS.ID = V_EMPRESAS_CENTRAL.ID
'                      INNER JOIN V_CLIENTES A ON A.ID=V_EMPRESAS_CENTRAL.CODIGO_AD
'WHERE     (PEDIDOS.ID = 15616)   

	adCmdStoredProc=4
	adVarChar=200
	adParamInput=1

'select EMAIL from v_clientes
'where id=(SELECT top 1    V_EMPRESAS_CENTRAL.CODIGO_AD
'FROM         V_CLIENTES INNER JOIN
'                      V_EMPRESAS_CENTRAL ON V_CLIENTES.EMPRESA = V_EMPRESAS_CENTRAL.EMPRESA
'                      where v_clientes.id=6215)

	set datos_mail=Server.CreateObject("ADODB.Recordset")
	with datos_mail
		.ActiveConnection=connimprenta
		.Source="SELECT PEDIDOS.ID, PEDIDOS.CODCLI, V_CLIENTES.CODIGO_EXTERNO, V_CLIENTES.NOMBRE,"
		.Source=.Source & " V_CLIENTES.DIRECCION, V_CLIENTES.POBLACION, V_CLIENTES.PROVINCIA, V_CLIENTES.CP," 
		.Source=.Source & " V_CLIENTES.EMAIL, V_CLIENTES.TELEFONO, V_CLIENTES.JEFE_ECONOMATO, V_CLIENTES.FAX, V_EMPRESAS.EMPRESA," 
		.Source=.Source & " V_EMPRESAS.CARPETA, V_EMPRESAS_CENTRAL.CODIGO_AD, A.EMAIL AS MAIL_ADMIN,"
		.Source=.Source & " A.ID as CODIGO_ADMIN_UNICO, PEDIDOS.PEDIDO_AUTOMATICO"
		.Source=.Source & " FROM PEDIDOS INNER JOIN V_CLIENTES" 
		.Source=.Source & " ON PEDIDOS.CODCLI = V_CLIENTES.ID"
		.Source=.Source & " INNER JOIN V_EMPRESAS"
		.Source=.Source & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.ID"
		.Source=.Source & " INNER JOIN V_EMPRESAS_CENTRAL"
		.Source=.Source & " ON V_EMPRESAS.ID = V_EMPRESAS_CENTRAL.ID"
		.Source=.Source & " INNER JOIN V_CLIENTES A"
		'.Source=.Source & " ON A.ID=V_EMPRESAS_CENTRAL.CODIGO_AD"
		'PARA QUE BUSQUE EL ID EN CADENAS "#XXXX#YYYY#ZZZZ#"
		.Source=.Source & " ON CHARINDEX('#' + CONVERT(VARCHAR, A.ID) + '#', V_EMPRESAS_CENTRAL.CODIGO_AD)>0"
		.Source=.Source & " WHERE (PEDIDOS.ID = " & pedido & ")"
		.Source=.Source & " AND A.ID=" & session("usuario")
		'response.write("<br>" & .source)
		.Open
	end with
		
	if not datos_mail.eof then
		set cmd = Server.CreateObject("ADODB.Command")
		'set cmd2 = Server.CreateObject("ADODB.Command")
		set cmd.ActiveConnection = conn_envios_distri
		'set cmd2.ActiveConnection = conndistribuidora
	
		cmd.CommandText = "PAQUETE_ENVIOS_DISTRI.ENVIAR_MAIL"
		cmd.CommandType = adCmdStoredProc
		
		cmd.parameters.append cmd.createparameter("P_ENVIA",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_RECIBE",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_ASUNTO",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_MENSAJE",adVarChar,adParamInput,2000)
		cmd.parameters.append cmd.createparameter("P_HOST",adVarChar,adParamInput,255)
		'cmd.parameters.append cmd.createparameter("C_ALTO_GENERICO",adInteger,adParamInput,2)
		'cmd.parameters.append cmd.createparameter("C_PESO_GENERICO",adDouble,adParamInput)
		
		'cmd.parameters.append cmd.createparameter("texto_explicacion",adVarChar,adParamOutPut,255)
		
		cmd.parameters("P_ENVIA")=datos_mail("mail_admin")
		
		'para diferenciar los correos a los que se envia cuando estamos en pruebas o en real
		' y no tener que andar comentando y descomentando lineas		
		cadena_asunto=""
		correos_recibe=""
		if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
			'ENTORNO PRUEBAS
			'carlos.gonzalez@globalia-artesgraficas.com
		  	'correos_recibe="malba@halconviajes.com;carlos.gonzalez@globalia-artesgraficas.com"
			correos_recibe="malba@globalia-artesgraficas.com"
			cadena_asunto="PRUEBAS..."
		  else
			'ENTORNO REAL
			correos_recibe= datos_mail("email") & "; malba@globalia-artesgraficas.com"
			cadena_asunto=""
		end if
		'response.write("<br>" & Request.ServerVariables("SERVER_NAME"))
		cmd.parameters("P_RECIBE")=correos_recibe
		cmd.parameters("P_ASUNTO")=cadena_asunto & "Pedido Num. " & datos_mail("id") & " - AUTORIZADO"
		
		IF accion="CANCELAR" then
			cmd.parameters("P_ASUNTO")=cadena_asunto & "Pedido Num. " & datos_mail("id") & " - CANCELADO"
		end if
		
		
		mensaje= "<br>SU PEDIDO CON N&Uacute;MERO " & pedido & " HA SIDO VALIDADO POR"
		mensaje=mensaje & " LOS RESPONSABLES DE COMPRAS."

		if datos_mail("PEDIDO_AUTOMATICO")="PRIMER_PEDIDO_REDYSER" then
			mensaje=mensaje & " <BR><BR>PUEDE PROCEDER A REALIZAR EL INGRESO INDICADO EN EL RESUMEN DEL PEDIDO EN LA SIGUIENTE CUENTA"
			mensaje=mensaje & " <BR><BR>Código I.B.A.N.: ES09 2108 2200 4800 3001 1111"
			mensaje=mensaje & " <BR>Código B.I.C. Unicaja: CSPAES2L"
			mensaje=mensaje & " <BR><BR>PARA AGILIZAR SU PUESTA EN MARCHA POR FAVOR FACILITE EL JUSTIFICANTE DEL INGRESO A TRAVES DEL CORREO"
			mensaje=mensaje & " <BR><BR>carlos.gonzalez@globalia-artesgraficas.com"
			mensaje=mensaje & " <BR><BR>Saludos."
  		  else
			mensaje=mensaje & " <BR><BR>EL PEDIDO SER&Aacute; TRAMITADO EN BREVE."
		end if
		
		
		IF accion="CANCELAR" then
			mensaje= "<br>SU PEDIDO CON N&Uacute;MERO " & pedido & " HA SIDO CANCELADO POR LOS RESPONSABLES DE COMPRAS DE SU EMPRESA."
			mensaje=mensaje & "<br><br>PARA M&Aacute;S INFORMACI&Oacute;N POR FAVOR P&Oacute;NGASE EN CONTACTO CON ELLOS."
		
			mensaje=mensaje & "<br><br><br>Un Saludo."
		END IF


		'mensaje=mensaje & "<BR><BR><BR><BR><BR>&nbsp;&nbsp;&nbsp;Esto se Deber&iacute;a Enviar a: " & datos_mail("email")
		
		if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
			'ENTORNO PRUEBAS		
			mensaje=mensaje & "<BR><BR>este correo se deberia mandar al DESTINATARIO: " & datos_mail("email")
		end if
		
		
		cmd.parameters("P_MENSAJE")=mensaje
		'cmd.parameters("P_HOST")="195.76.0.183"
		cmd.parameters("P_HOST")="192.168.150.44"
		   
		cmd.execute()
		
		
		
		
		
		set cmd=Nothing
			
	end if
	
	datos_mail.close
	set datos_mail=Nothing
		
	conn_envios_distri.close
	set conn_envios_distri=Nothing

end sub
%>

<%

	if session("usuario")="" then
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
	end if
		
		pedido_a_modificar=Request.Form("ocultopedido_a_modificar")
		accion=Request.Form("ocultoaccion")
		
		
		if accion="CONFIRMAR" then
				cadena_estado_mod="SIN TRATAR"
				
				'controlo que si confirmo desde ASM un pedido especial del 50% de descuento, lo paso 
				'a pendiente de pago no a sin tratar
				if session("usuario_codigo_empresa")=4 then
					set tipo_ofi=Server.CreateObject("ADODB.Recordset")
					tipo_oficina_mod="select (select tipo from v_clientes where id=pedidos.codcli) as tipo_oficina"
					tipo_oficina_mod=tipo_oficina_mod & " from pedidos where id = " & pedido_a_modificar

					with tipo_ofi
						.ActiveConnection=connimprenta
						.Source=tipo_oficina_mod
						'response.write("<br>FAMILIAS: " & .source)
						.Open
					end with
					
					if not tipo_ofi.eof then
						if tipo_ofi("tipo_oficina")="AGENCIA" then
							cadena_estado_mod="PENDIENTE PAGO"
						end if
					end if
					
					tipo_ofi.close
					set tipo_ofi=Nothing	
				end if
				
				cadena_ejecucion="UPDATE PEDIDOS_DETALLES SET ESTADO='" & cadena_estado_mod & "' WHERE ID_PEDIDO=" & pedido_a_modificar
				cadena_ejecucion2="UPDATE PEDIDOS SET ESTADO='" & cadena_estado_mod & "' WHERE ID=" & pedido_a_modificar
				connimprenta.BeginTrans 'Comenzamos la Transaccion
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion2,,adCmdText + adExecuteNoRecords
				
				'ahora si hacemos que ASM envie el correo de confirmacion
				'el perfil de ASM no tiene que mandar el correo de confirmacion de gestion del pedido
				'el perfil de UVE no manda correos
				if session("usuario_codigo_empresa")<>150 and session("usuario_codigo_empresa")<>4 then
					mail_confirmacion_autorizacion_pedido pedido_a_modificar, "CONFIRMAR"
				end if
				connimprenta.CommitTrans ' finaliza la transaccion
				mensaje_aviso="El Pedido Ha sido Confirmado, Globalia Artes Gráficas podrá empezar a Tramitarlo..."
			  else
			  	'mensaje_aviso="NO SE HA PODIDO BORRAR El Pedido Porque Ya Está Siendo Tramitado por Globalia Artes Gráficas..."
			end if
		
			if accion="CANCELAR" then
				
				cadena_ejecucion="UPDATE PEDIDOS_DETALLES SET ESTADO='CANCELADO' WHERE ID_PEDIDO=" & pedido_a_modificar
				cadena_ejecucion2="UPDATE PEDIDOS SET ESTADO='CANCELADO' WHERE ID=" & pedido_a_modificar
				connimprenta.BeginTrans 'Comenzamos la Transaccion
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion2,,adCmdText + adExecuteNoRecords
				
				'ahora si hacemos que ASM envie el correo de confirmacion
				'el perfil de ASM no tiene que mandar el correo de confirmacion de gestion del pedido
				'el perfil de UVE no manda correos
				if session("usuario_codigo_empresa")<>150 and session("usuario_codigo_empresa")<>4 then
					mail_confirmacion_autorizacion_pedido pedido_a_modificar, "CANCELAR"
				end if
				connimprenta.CommitTrans ' finaliza la transaccion
				mensaje_aviso="El Pedido Ha sido Cancelado."
			  else
			  	'mensaje_aviso="NO SE HA PODIDO BORRAR El Pedido Porque Ya Está Siendo Tramitado por Globalia Artes Gráficas..."
			end if
		
			if accion="DESCANCELAR" then
				
				cadena_ejecucion="UPDATE PEDIDOS_DETALLES SET ESTADO='PENDIENTE AUTORIZACION' WHERE ID_PEDIDO=" & pedido_a_modificar
				cadena_ejecucion2="UPDATE PEDIDOS SET ESTADO='PENDIENTE AUTORIZACION' WHERE ID=" & pedido_a_modificar
				connimprenta.BeginTrans 'Comenzamos la Transaccion
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				connimprenta.Execute cadena_ejecucion2,,adCmdText + adExecuteNoRecords
				
				'ahora si hacemos que ASM envie el correo de confirmacion
				'el perfil de ASM no tiene que mandar el correo de confirmacion de gestion del pedido
				'el perfil de UVE no manda correos
				''if session("usuario_codigo_empresa")<>150 then
				''	mail_confirmacion_autorizacion_pedido(pedido_a_modificar)
				''end if
				connimprenta.CommitTrans ' finaliza la transaccion
				mensaje_aviso="El Pedido Ha Sido Activado Nuevamente."
			  else
			  	'mensaje_aviso="NO SE HA PODIDO BORRAR El Pedido Porque Ya Está Siendo Tramitado por Globalia Artes Gráficas..."
			end if
		
		
		
		

%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<%'aplicamos un tipo de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />

<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<TITLE>Borrar Pedido</TITLE>
</HEAD>
<script language="javascript">
function validar(mensaje, accion)
{
	
	if ((accion=='CONFIRMAR') || (accion=='CANCELAR') || (accion=='DESCANCELAR'))
		{
		//alert(mensaje);
		$("#cabecera_pantalla_avisos").html("Avisos")
		$("#body_avisos").html("<br><br><h4>" + mensaje + ".</h4><br><br>");
		$("#pantalla_avisos").modal("show");
		}
	
	if (accion=='MODIFICAR')
		{
		$('#frmmodificar_pedido').submit();
		}
	
	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

   
<BODY onload="validar('<%=mensaje_aviso%>', '<%=accion%>')" style="background-color:<%=session("color_asociado_empresa")%> ">
	
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
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->

<form name="frmconfirmar_pedido" id="frmconfirmar_pedido" method="post" action="Consulta_Pedidos_Gag_Central_Admin.asp">
</form>

<form action="Rellenar_Variables_Sesion_Gag_Central_Admin.asp" method="post" name="frmmodificar_pedido" id="frmmodificar_pedido">
	<input type="hidden" id="ocultopedido_a_modificar" name="ocultopedido_a_modificar" value="<%=pedido_a_modificar%>" />
</form>


<script language="javascript">
$('#pantalla_avisos').on('hidden.bs.modal', function (e) {
		$('#frmconfirmar_pedido').submit();
})
</script>
</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
