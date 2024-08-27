<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include file="../xelupload.asp"-->
<!--#include file="../Conexion_ORACLE_Envios_Distri_PRODUCCION.inc"-->

<%

'*************************************************************
' con esta pagina daremos de alta de forma automatica un pedido
' para la sucursal indicada

'sucursal para la que se crea el pedido
'280-2 ASM COMERCIAL ------ 5086
sucursal_pedido=5086 


'Datos de la cabecera del Pedido
cadena_campos = "CODCLI, FECHA, ESTADO, PEDIDO_AUTOMATICO, DESTINATARIO, DESTINATARIO_DIRECCION, DESTINATARIO_POBLACION, DESTINATARIO_CP, DESTINATARIO_PROVINCIA"
cadena_valores = sucursal_pedido & ", '" & DATE() & "', 'SIN TRATAR', '280-2 REGENERSIS', 'REGENERSIS (Att: MONTSERRAT HERNÁNDEZ)', 'AVD. LEONARDO DA VINCI, 13', 'MADRID', '28070', 'MADRID'"


cadena_ejecucion="Insert into PEDIDOS (" & cadena_campos & ") values(" & cadena_valores & ")"
'response.write("<br>cadena ejecucion: " & cadena_ejecucion)		   
connimprenta.BeginTrans 'Comenzamos la Transaccion
				
'porque el sql de produccion es un sql expres que debe tener el formato de
' de fecha con mes-dia-año
connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

Set valor_nuevo = connimprenta.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
numero_pedido=valor_nuevo(0)
valor_nuevo.Close
Set valor_nuevo = Nothing
				
				

'obtenemos el tipo de precio a aplicar a los articulos del pedido automatico
'relacionados con la oficina
set tipos_precios=Server.CreateObject("ADODB.Recordset")
sql="Select tipo_precio, empresa from V_CLIENTES where ID = " & sucursal_pedido
with tipos_precios
	.ActiveConnection=connimprenta
	.Source=sql
	.Open
	'response.write("<br>tipos precios: " & sql)
	tipo_precio=tipos_precios("tipo_precio")
	codigo_empresa=tipos_precios("empresa")
end with
tipos_precios.close
set tipos_precios=Nothing


'y ahora vamos a ir añadiendo los detalles del pedido

'DMIS3061 ETIQUETA TERMICA ZIGZAG  , codigo de articulo 580 , 100 unidades
'RBOP001PBUR	MULTISOBRE ESTANDAR PEQUEÑO ACOLCHADO, codigo de articulo 2898, 65 unidades 
codigo_articulo_pedido=2898
cantidad_pedida=65

'obtenemos el precio del articulo que se va a pedir
set cantidades_precios=Server.CreateObject("ADODB.Recordset")
					
sql="SELECT * FROM CANTIDADES_PRECIOS"
sql=sql & " WHERE CODIGO_ARTICULO=" & codigo_articulo_pedido
sql=sql & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
sql=sql & " AND CODIGO_EMPRESA=" & codigo_empresa
sql=sql & " ORDER BY CANTIDAD"
'response.write("<br>" & sql)
														
with cantidades_precios
	.ActiveConnection=connimprenta
	.CursorType=3 'adOpenStatic
	.Source=sql
	.Open
end with

precio_buscado=""
if not cantidades_precios.eof then
	precio_buscado=cantidades_precios("precio_unidad")
end if
cantidades_precios.close
set cantidades_precios=Nothing

cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION"

cadena_valores = numero_pedido & ", " & codigo_articulo_pedido & ", " & cantidad_pedida & ", " 
cadena_valores = cadena_valores & replace(precio_buscado,",",".") & ", " & replace((cantidad_pedida * precio_buscado), ",", ".") & ", 'SIN TRATAR', NULL"

cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
'response.Write("<br>" & cadena_ejecucion)
connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords


connimprenta.CommitTrans ' finaliza la transaccion
		
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
		'cmd.parameters("P_ENVIA")="malba@halconviajes.com"		
		cmd.parameters("P_ENVIA")="malba@globalia-artesgraficas.com"

		'para diferenciar los correos a los que se envia cuando estamos en pruebas o en real
		' y no tener que andar comentando y descomentando lineas		
		
		cadena_asunto=""
		if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" and Request.ServerVariables("SERVER_NAME")<>"10.150.3.20" then
		
			'ENTRONO PRUEBAS
		  	'correos_recibe="malba@halconviajes.com; plopez@globalia.com; carlos.gonzalez@globalia-artesgraficas.com"
			correos_recibe="malba@globalia-artesgraficas.com"
			cadena_asunto="PRUEBAS..."
		  else
			'ENTORNO REAL
			correos_recibe="carlos.gonzalez@globalia-artesgraficas.com; malba@globalia-artesgraficas.com" 		  	
			cadena_asunto=""
		end if
		
		'response.write("<br>" & Request.ServerVariables("SERVER_NAME"))
		cmd.parameters("P_RECIBE")=correos_recibe
		cmd.parameters("P_ASUNTO")= cadena_asunto & "(REGENERSIS) PEDIDO AUTOMATICO " & numero_pedido & " ASM Suc. 280-2 (" & date() & ")"
		
		mensaje="Con fecha " & date() & " se ha generado de forma autom&aacute;tica el pedido " & numero_pedido & " para la sucursal 280-2 (REGENERSIS) de ASM"
		cmd.parameters("P_MENSAJE")=mensaje
		'cmd.parameters("P_HOST")="195.76.0.183"
		cmd.parameters("P_HOST")="192.168.150.44"
		   
		cmd.execute()
		
	
		conn_envios_distri.CommitTrans ' finaliza la transaccion
		
		
		set cmd=Nothing
			
	
	
		
	
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pedido AUTOMATICO ASM 280-2 NORBERT</TITLE>
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

