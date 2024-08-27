<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include file="../Envio_Mails_CDO/Envio_Mail.inc"-->


<%
function obtener_precio_coste(articulo)
	precio_coste=""
	set precios_coste=Server.CreateObject("ADODB.Recordset")
	sql="SELECT PRECIO_COSTE FROM ARTICULOS WHERE ID = " & articulo
	with precios_coste
		.ActiveConnection=connimprenta
		.Source=sql
		.Open
		'response.write("<br>tipos precios: " & sql)
	end with
	if not precios_coste.EOF then
		precio_coste= "" & precios_coste("PRECIO_COSTE")
	end if
	precios_coste.close
	set precios_coste=Nothing
	if precio_coste="" then
		precio_coste = "NULL"
	end if
	
	obtener_precio_coste = precio_coste
end function


'*************************************************************
' con esta pagina daremos de alta de forma automatica un pedido
' para la sucursal indicada

'sucursal para la que se crea el pedido
'280-2 ASM COMERCIAL ------ 5086
sucursal_pedido=5086 


'Datos de la cabecera del Pedido
cadena_campos = "CODCLI, FECHA, ESTADO, PEDIDO_AUTOMATICO, DESTINATARIO, DESTINATARIO_DIRECCION, DESTINATARIO_POBLACION, DESTINATARIO_CP, DESTINATARIO_PROVINCIA, DESTINATARIO_TELEFONO"
cadena_valores = sucursal_pedido & ", '" & DATE() & "', 'SIN TRATAR', '280-2 DUPLA', 'INTERBOX EUROLOGISTICA (Att.: Andra)', 'Avd. del Rio Henares, 38', 'Alovera', '28071', 'Guadalajara', '911 33 48 76'"

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

'RBOP001P MULTISOBRE GLS ESTANDAR PEQUEÑO, codigo de articulo 2683, 250 unidades
'hay una nueva linea de productos por el nuevo logo de GLS
'NLOP001P MULTISOBRE GLS ESTANDAR PEQUEÑO, codigo de articulo 3670, 250 unidades
'se cambia a la gama ECO
'NLOP001ECOP MULTISOBRE GLS ESTANDAR PEQUEÑO 100% RECICLADO, codigo de articulo 4550, 250 unidades




codigo_articulo_pedido=4550
cantidad_pedida=250

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

precio_coste=obtener_precio_coste(codigo_articulo_pedido)

cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION, PRECIO_COSTE"

cadena_valores = numero_pedido & ", " & codigo_articulo_pedido & ", " & cantidad_pedida & ", " 
cadena_valores = cadena_valores & replace(precio_buscado,",",".") & ", " & replace((cantidad_pedida * precio_buscado), ",", ".") & ", 'SIN TRATAR', NULL, " & replace(precio_coste,",",".")

cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
'response.Write("<br>" & cadena_ejecucion)

connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords



'RBOPE0702 ETIQUETA TERMICA ZIGZAG  , codigo de articulo 580 , 25 unidades
codigo_articulo_pedido=580
cantidad_pedida=25

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

precio_coste=obtener_precio_coste(codigo_articulo_pedido)

cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION, PRECIO_COSTE"

cadena_valores = numero_pedido & ", " & codigo_articulo_pedido & ", " & cantidad_pedida & ", " 
cadena_valores = cadena_valores & replace(precio_buscado,",",".") & ", " & replace((cantidad_pedida * precio_buscado), ",", ".") & ", 'SIN TRATAR', NULL, " & replace(precio_coste,",",".")

cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
'response.Write("<br>insercion articulo: " & cadena_ejecucion)
connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords



'ya no se menadan 02/12/2020
'RBOP001M	MULTISOBRE GLS ESTANDAR MEDIANO, codigo de articulo 2684, 250 unidades
'hay una nueva linea de productos por el nuevo logo de GLS
'NLOP001M	MULTISOBRE GLS ESTANDAR MEDIANO, codigo de articulo 3667, 250 unidades


 
codigo_articulo_pedido=3667
cantidad_pedida=250


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

precio_coste=obtener_precio_coste(codigo_articulo_pedido)

cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION, PRECIO_COSTE"

cadena_valores = numero_pedido & ", " & codigo_articulo_pedido & ", " & cantidad_pedida & ", " 
cadena_valores = cadena_valores & replace(precio_buscado,",",".") & ", " & replace((cantidad_pedida * precio_buscado), ",", ".") & ", 'SIN TRATAR', NULL, " & replace(precio_coste,",",".")

cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
'response.Write("<br>" & cadena_ejecucion)
'ya no se mandan

'2021_02_01 -- se dejan de enviar estos sobre de momento hasta nuevo aviso
'connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords


'RPOPE0501	SOBRE CANGURO DAC GLS, codigo de articulo 2896, 10 unidades
'hay una nueva linea de productos por el nuevo logo de GLS
'NLOPE0501	SOBRE CANGURO DAC GLS, codigo de articulo 3512, 10 unidades


 
codigo_articulo_pedido=3512
cantidad_pedida=10


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

precio_coste=obtener_precio_coste(codigo_articulo_pedido)

cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION, PRECIO_COSTE"

cadena_valores = numero_pedido & ", " & codigo_articulo_pedido & ", " & cantidad_pedida & ", " 
cadena_valores = cadena_valores & replace(precio_buscado,",",".") & ", " & replace((cantidad_pedida * precio_buscado), ",", ".") & ", 'SIN TRATAR', NULL, " & replace(precio_coste,",",".")

cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
'response.Write("<br>" & cadena_ejecucion)
connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords



connimprenta.CommitTrans ' finaliza la transaccion
		
		
		

'ENVIAMOS EL CORREO ELECTRONICO

	de = "malba@globalia-artesgraficas.com"
	para = "carlos.gonzalez@globalia-artesgraficas.com; malba@globalia-artesgraficas.com" 		  	
	asunto = "(DUPLA) PEDIDO AUTOMATICO " & numero_pedido & " GLS Suc. 280-2 (" & date() & ")"

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
	mensaje = mensaje & "Con fecha " & date() & " se ha generado de forma autom&aacute;tica el pedido " & numero_pedido & " para la sucursal 280-2 (DUPLA) de GLS."
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
   
   	adjunto = ""
   	servidor = "GLOBALIA"
	'servidor = "AMAZON"
   
	respuesta_envio = envio_email(de, para, asunto, mensaje, adjunto, servidor)
   
		
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pedido AUTOMATICO ASM 280-2 DUPLA</TITLE>
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
<br /><br />
<b>Respuesta Envio email: <%=respuesta_envio%></b>
</BODY>
   <%
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>

