<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include file="../xelupload.asp"-->

<%

'*************************************************************
' con esta pagina daremos de alta de forma automatica un pedido
' para la sucursal indicada

'sucursal para la que se crea el pedido
'280-2-1 COMERCIAL PLT ------ 6534
sucursal_pedido=6534


'Datos de la cabecera del Pedido
cadena_campos = "CODCLI, FECHA, ESTADO, PEDIDO_AUTOMATICO, DESTINATARIO, DESTINATARIO_DIRECCION, DESTINATARIO_POBLACION, DESTINATARIO_CP, DESTINATARIO_PROVINCIA, DESTINATARIO_PAIS, DESTINATARIO_TELEFONO"
cadena_valores = sucursal_pedido & ", '" & DATE() & "', 'SIN TRATAR', '280-2 GLOBAL_GROUP', 'LT NEGOCIOS GLOBAL GROUP', 'TRAVESSIA INDUSTRIAL, 149 4 B', 'BARCELONA', '08080', 'BARCELONA', 'ESPAÑA', '717105716'"


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
'NLOP001M MULTISOBRE GLS ESTANDAR MEDIANO, codigo de articulo 3667, 20 unidades
'se cambia a la gama ECO
'NLOP001ECOM MULTISOBRE GLS ESTANDAR MEDIANO 100% RECICLADO, codigo de articulo 4551, 20 unidades

codigo_articulo_pedido=4551
cantidad_pedida=20
'codigo_articulo_pedido=3720
'cantidad_pedida=47


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
		

'ENVIAMOS EL CORREO ELECTRONICO


   ' Primero, cree una instancia del objeto de servidor CDO
   Dim objCDO
   Set objCDO = Server.CreateObject("CDO.Message")

	' Especifique la información del correo electrónico, incluyendo remitente, destinatario y cuerpo del mensaje
   objCDO.From     = "malba@globalia-artesgraficas.com"
   
	'para diferenciar los correos a los que se envia cuando estamos en pruebas o en real
	' y no tener que andar comentando y descomentando lineas		
	
	cadena_asunto=""
	if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" and Request.ServerVariables("SERVER_NAME")<>"10.150.3.20" then
		'ENTRONO PRUEBAS
		correos_recibe="malba@globalia-artesgraficas.com"
		'correos_recibe="malba@halconviajes.com"
		cadena_asunto="PRUEBAS..."
	  else
		'ENTORNO REAL
		correos_recibe="carlos.gonzalez@globalia-artesgraficas.com; malba@globalia-artesgraficas.com" 		  	
		'correos_recibe="malba@halconviajes.com"
		cadena_asunto=""
	end if
   
   objCDO.To       = correos_recibe
   objCDO.Subject  = cadena_asunto & "(GLOBAL GROUP) PEDIDO AUTOMATICO " & numero_pedido & " GLS Suc. 280-2-1 COMERCIAL PLT (" & date() & ")"
   'objCDO.TextBody = "cuerpo del mensaje."
   'objCDO.CreateMHTMLBody "http://www.w3schools.com/asp/" 
   
   mensaje = "<div style='background-color:#fff;width:650px;font-family:Open-sans,sans-serif;color:#555454;font-size:13px;line-height:18px;margin:auto'>"
	mensaje = mensaje & "<table style='width:100%' bgcolor='#ffffff'>"
	mensaje = mensaje & "<tbody>"
	mensaje = mensaje & "<tr>"
	mensaje = mensaje & "<td style='border:1px solid #d6d4d4;background-color:#f8f8f8;padding:7px 0'>"
	mensaje = mensaje & "<table style='width:100%'>"
	mensaje = mensaje & "<tbody>"
	mensaje = mensaje & "<tr>"
	mensaje = mensaje & "<td style='padding:7px 0' width='10'>&nbsp;</td>"
	mensaje = mensaje & "<td style='padding:7px 0'>"
	mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
	mensaje = mensaje & "<span style='color:#777'>"
	mensaje = mensaje & "Con fecha " & date() & " se ha generado de forma autom&aacute;tica el pedido " & numero_pedido & " para la sucursal 280-2-1 COMERCIAL PLT (GLOBAL GROUP) de GLS."
	mensaje = mensaje & "<br><br>Un Saludo."
	mensaje = mensaje & "</span>"
	mensaje = mensaje & "</font>"
	mensaje = mensaje & "</td>"
	mensaje = mensaje & "<td style='padding:7px 0' width='10'>&nbsp;</td>"
	mensaje = mensaje & "</tr>"
	mensaje = mensaje & "</tbody>"
	mensaje = mensaje & "</table>"
	mensaje = mensaje & "</td>"
	mensaje = mensaje & "</tr>"
	mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
	mensaje = mensaje & "</tbody>"
	mensaje = mensaje & "</table>"
	mensaje = mensaje & "</div>"
	
	mensaje = replace(mensaje, "á", "&aacute;")
	mensaje = replace(mensaje, "é", "&eacute;")
	mensaje = replace(mensaje, "í", "&iacute;")
	mensaje = replace(mensaje, "ó", "&oacute;")
	mensaje = replace(mensaje, "ú", "&uacute;")
	mensaje = replace(mensaje, "Á", "&Aacute;")
	mensaje = replace(mensaje, "É", "&Eacute;")
	mensaje = replace(mensaje, "Í", "&Iacute;")
	mensaje = replace(mensaje, "Ó", "&Oacute;")
	mensaje = replace(mensaje, "Ú", "&Uacute;")
	mensaje = replace(mensaje, "ñ", "&ntilde;")
	mensaje = replace(mensaje, "Ñ", "&Ntilde;")
	mensaje = replace(mensaje, "ü", "&uuml;")
	mensaje = replace(mensaje, "Ü", "&Uuml;")
	mensaje = replace(mensaje, "ç", "&ccedil;")
	mensaje = replace(mensaje, "Ç", "&Ccedil;")
   
	objCDO.HtmlBody = mensaje

   'configuracion del servidor de emails
   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "192.168.150.44"
   'objMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
   objCDO.Configuration.Fields.Update

   ' Use el método Send del objeto CDO para enviar el correo electrónico con el adjunto
   objCDO.Send

%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pedido AUTOMATICO GLS 280-2-1 COMERCIAL PLT - GLOBAL GROUP</TITLE>
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
   		
	
	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>

