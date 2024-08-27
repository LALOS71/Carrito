<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion_ORACLE_Envios_Distri_PRODUCCION_PRU.inc"-->

<%

'*************************************************************


RESPONSE.WRITE("<BR>EMPEZAMOS A CREAR EL COMMAND")		
adCmdStoredProc=4
adVarChar=200
adParamInput=1
		
		set cmd = Server.CreateObject("ADODB.Command")
		'set cmd2 = Server.CreateObject("ADODB.Command")
		set cmd.ActiveConnection = conn_envios_distri
		'set cmd2.ActiveConnection = conndistribuidora
	
		conn_envios_distri.BeginTrans 'Comenzamos la Transaccion
		cmd.CommandText = "PAQUETE_ENVIOS_DISTRI.ENVIAR_MAIL"
		cmd.CommandType = adCmdStoredProc
		
		cmd.parameters.append cmd.createparameter("P_ENVIA",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_RECIBE",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_ASUNTO",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_MENSAJE",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_HOST",adVarChar,adParamInput,255)
		'cmd.parameters.append cmd.createparameter("C_ALTO_GENERICO",adInteger,adParamInput,2)
		'cmd.parameters.append cmd.createparameter("C_PESO_GENERICO",adDouble,adParamInput)
		
		'cmd.parameters.append cmd.createparameter("texto_explicacion",adVarChar,adParamOutPut,255)
		
		'cmd.parameters("P_ENVIA")="plopez@globalia.com"		
		cmd.parameters("P_ENVIA")="malba@halconviajes.com"		

		'para diferenciar los correos a los que se envia cuando estamos en pruebas o en real
		' y no tener que andar comentando y descomentando lineas		
		
		cadena_asunto="pruebas conexion con oracle y envio mail"
	  	correos_recibe="malba@halconviajes.com; malba@ono.com"
		'response.write("<br>" & Request.ServerVariables("SERVER_NAME"))
		cmd.parameters("P_RECIBE")=correos_recibe
		cmd.parameters("P_ASUNTO")= cadena_asunto
		
		mensaje="Con fecha " & date() & " se ha generado de forma automática este correo desde oracle"
		cmd.parameters("P_MENSAJE")=mensaje
		'cmd.parameters("P_HOST")="195.76.0.183"
		cmd.parameters("P_HOST")="192.168.150.44"
		
		RESPONSE.WRITE("<BR>ANTES DEL EXECUTE")   
		cmd.execute()
		
	
		conn_envios_distri.CommitTrans ' finaliza la transaccion
		
		
		set cmd=Nothing
			
	
	
		
	
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>preuba conexion oracle</TITLE>
</HEAD>
<script language="javascript">
//para que se cierre la ventana despues de ejecutarse la tarea programada
//porque si no, se queda abierta en cada ejecucion
function cerrar_ventana()
{
	window.opener = null;
	window.close();
	return false;
}
</script>

   
<BODY onload="cerrar_ventana()">
<b><%=mensaje%></b>	
</BODY>
   <%
   		conn_envios_distri.close
		set conn_envios_distri=Nothing
	
	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>

