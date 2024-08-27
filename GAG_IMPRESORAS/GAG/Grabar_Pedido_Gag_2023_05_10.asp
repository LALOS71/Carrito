<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include file="../Conexion_GAG.inc"-->
<!--#include file="../xelupload.asp"-->

<script language="javascript" runat="server" src="json2_a.asp"></script>

<script language="JScript" runat="server">
function CheckProperty(obj, propName) {
    return (typeof obj[propName] != "undefined");
}
</script>



<%

sub mail_autorizacion_pedido(pedido)%>
	<!--#include file="../Conexion_ORACLE_Envios_Distri_PRODUCCION.inc"-->


<%
'response.write("<br>dentro de mail_autorizacion_pedido" & .source)
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
	adLongVarChar=201
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
		.Source=.Source & " V_EMPRESAS.CARPETA, V_EMPRESAS_CENTRAL.CODIGO_AD, A.EMAIL AS MAIL_ADMIN, PEDIDOS.PEDIDO_AUTOMATICO"
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
		'response.write("<br>datos mail: " & .source)
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
		'cmd.parameters.append cmd.createparameter("P_MENSAJE",adVarChar,adParamInput,2000)
		cmd.parameters.append cmd.createparameter("P_MENSAJE",adLongVarChar,adParamInput,-1)
		cmd.parameters.append cmd.createparameter("P_HOST",adVarChar,adParamInput,255)
		'cmd.parameters.append cmd.createparameter("C_ALTO_GENERICO",adInteger,adParamInput,2)
		'cmd.parameters.append cmd.createparameter("C_PESO_GENERICO",adDouble,adParamInput)
		
		'cmd.parameters.append cmd.createparameter("texto_explicacion",adVarChar,adParamOutPut,255)
		
		cmd.parameters("P_ENVIA")="carlos.gonzalez@globalia-artesgraficas.com"
		
		
		'para diferenciar los correos a los que se envia cuando estamos en pruebas o en real
		' y no tener que andar comentando y descomentando lineas		
		cadena_asunto=""
		correos_recibe=""
		
		correos_recibe_real= datos_mail("mail_admin") 		
			
		'desde direccion de compras quieren que llegue a nuria melero y miriam.alonso tambien
		'if datos_mail("mail_admin")="direccion.compras@globalia.com" then
		'	correos_recibe_real=correos_recibe_real & ";nuria.melero@globalia.com;miriam.alonso@globalia.com"
		'end if
		
		'para AIR EUROPA
		if session("usuario_codigo_empresa")=40 then
			correos_recibe_real=correos_recibe_real & ";egelabert@air-europa.com;jfigueroa@aireuropa.com"
		end if
		
		'para GROUNDFORCE CARGO
		if session("usuario_codigo_empresa")=50 then
			correos_recibe_real=correos_recibe_real & ";jbatalla@globalia-corp.com"
		end if
		
		'para GLOBALIA HANDLIND
		if session("usuario_codigo_empresa")=30 then
			correos_recibe_real=correos_recibe_real & ";area.tecnica@globalia-corp.com"
		end if
		
		'para ASM, tenenmos que ver si es de GLS o de ASM
		if session("usuario_codigo_empresa")=4 then
			if session("usuario_tipo")="GLS PROPIA" then
				correos_recibe_real="felix.biedma@gls-spain.com"
			end if
		end if
		correos_recibe_real=correos_recibe_real & ";malba@globalia-artesgraficas.com"
		
		if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
			'ENTRONO PRUEBAS
			'carlos.gonzalez@globalia-artesgraficas.com
			'correos_recibe="malba@halconviajes.com;carlos.gonzalez@globalia-artesgraficas.com"
			correos_recibe="malba@globalia-artesgraficas.com"
			cadena_asunto="PRUEBAS..."
		  else
			'ENTORNO REAL
			correos_recibe=correos_recibe_real
			cadena_asunto=""
		end if
		'response.write("<br>" & Request.ServerVariables("SERVER_NAME"))
		cmd.parameters("P_RECIBE")=correos_recibe
		cmd.parameters("P_ASUNTO")=cadena_asunto & "Pedido Num. " & datos_mail("id") & ", Pendiente de Autorizar"
		
		mensaje="El Pedido " & datos_mail("id") & " del Cliente:<BR>"
		mensaje=mensaje & "<BR>&nbsp;&nbsp;&nbsp;<b>" & datos_mail("nombre") & "</b>"
		mensaje=mensaje & "<BR>&nbsp;&nbsp;&nbsp;" & datos_mail("direccion")
		mensaje=mensaje & "<BR>&nbsp;&nbsp;&nbsp;" & datos_mail("cp") & " " & datos_mail("poblacion")
		mensaje=mensaje & "<BR>&nbsp;&nbsp;&nbsp;" & datos_mail("provincia")
		mensaje=mensaje & "<BR>&nbsp;&nbsp;&nbsp;Tlf: " & datos_mail("telefono")
		mensaje=mensaje & "<BR>&nbsp;&nbsp;&nbsp;Fax: " & datos_mail("fax")
		mensaje=mensaje & "<BR>&nbsp;&nbsp;&nbsp;Email: " & datos_mail("email")
		mensaje=mensaje & "<BR>&nbsp;&nbsp;&nbsp;Contacto Jefe de Economato: " & datos_mail("jefe_economato")
		mensaje=mensaje & "<BR><BR>&nbsp;Perteneciente a la Empresa: " & datos_mail("empresa")
		mensaje=mensaje & "<BR><BR><BR>&nbsp;Contiene art&iacute;culos que requieren autorizaci&oacute;n previa para ser tramitado por"
		mensaje=mensaje & " Globalia Artes Gr&aacute;ficas."
		
		
		set datos_pedido=Server.CreateObject("ADODB.Recordset")
		with datos_pedido
			.ActiveConnection=connimprenta
			.Source="SELECT A.ID PEDIDO, A.CODCLI, YEAR(A.FECHA) ANNO"
			.Source=.Source & ", B.ARTICULO"
			.Source=.Source & ", C.CODIGO_SAP, C.DESCRIPCION" 
			.Source=.Source & " FROM PEDIDOS A INNER JOIN PEDIDOS_DETALLES B" 
			.Source=.Source & " ON A.ID = B.ID_PEDIDO"
			.Source=.Source & " INNER JOIN ARTICULOS C"
			.Source=.Source & " ON B.ARTICULO = C.ID"
			.Source=.Source & " WHERE A.ID=" & pedido
			'response.write("<br>datos del pedido: " & .source)
			.Open
		end with
		
		set  fso_json=Server.CreateObject("Scripting.FileSystemObject")
		cadena_datos_articulo=""
		es_de_merchan=""
		while not datos_pedido.eof
			'Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar)
			ruta_json= Server.MapPath("./pedidos/" & datos_pedido("anno") & "/" & datos_pedido("codcli") & "__" & pedido)
			ruta_json= ruta_json & "/json_" & datos_pedido("articulo") & ".json"
			'response.write("<br>ruta articulo: " & ruta_json)
			if fso.FileExists(ruta_json) then
				'response.write("<br>....el articulo existe....")

				set t=fso.OpenTextFile(ruta_json,1,false)
				x=t.ReadAll
				t.close
				'Response.Write("<br>contenido del fichero: " & x)
				
				dim Info : set Info = JSON.parse(x)
				'{"codigo_cliente":"6214","codigo_pedido":"47917","numero_plantillas":-1,
				'	"plantillas":[{"nombre_grupo":"grupomm","expediente":"expmm","total_venta_expediente":"77,65","total_coste_expediente":"77,665","beneficio":"0,225"}]} 
				'{"firstname": "Fabio","lastname": "Nagao","alive": true,"age": 27,"nickname": "nagaozen",
				'		"fruits": ["banana","orange","apple","papaya","pineapple"],
				'       "complex": {"real": 1,"imaginary": 2}}		
				 
				'Response.write(Info.firstname & vbNewline) ' prints Fabio
				'Response.write(Info.alive & vbNewline) ' prints True
				'Response.write(Info.age & vbNewline) ' prints 27
				'Response.write(Info.fruits.get(0) & vbNewline) ' prints banana
				'Response.write(Info.fruits.get(1) & vbNewline) ' prints orange
				'Response.write(Info.complex.real & vbNewline) ' prints 1
				'Response.write(Info.complex.imaginary & vbNewline) ' prints 2	 

				' You can also enumerate object properties ...
				 
				'dim key : for each key in Info.keys()
				'	Response.write( key & vbNewline )
				'next
				
				'Response.write(Info.codigo_cliente & vbNewline) ' prints Fabio
				'Response.write(Info.codigo_pedido & vbNewline) ' prints True
				'Response.write(Info.plantillas.nombre_grupo & vbNewline) ' prints 27
				'Response.write(Info.plantillas.get(0).nombre_grupo & vbNewline) ' prints 27
				'Response.write(Info.plantillas.get(0).expediente & vbNewline) ' prints 27
				'Response.write(Info.plantillas.get(0).total_venta_expediente & vbNewline) ' prints 27
				'Response.write(Info.plantillas.get(0).total_coste_expediente & vbNewline) ' prints 27
				'Response.write(Info.plantillas.get(0).beneficio & vbNewline) ' prints 27
				'Response.write(Info.plantillas.nombre_grupo & vbNewline) ' prints banana
				'Response.write(Info.fruits.get(1) & vbNewline) ' prints orange
				'Response.write(Info.complex.real & vbNewline) ' prints 1
				'Response.write(Info.complex.imaginary & vbNewline) ' prints 2
				 
				
				'solo ponemos en el mail informacion de la plantilla del articulo si el 
				'articulo es de merchandising cuya plantilla tiene el campo total_venta_expediente
				If CheckProperty(Info.plantillas.get(0), "total_venta_expediente") Then
					cadena_datos_articulo=cadena_datos_articulo & "<BR><BR>Articulo: <b>(" & datos_pedido("CODIGO_SAP") & ") " & datos_pedido("DESCRIPCION") & "</b>"
					cadena_datos_articulo=cadena_datos_articulo & "<BR>&nbsp;&nbsp;&nbsp;&nbsp;Nombre del Grupo: " & Info.plantillas.get(0).nombre_grupo
					cadena_datos_articulo=cadena_datos_articulo & "<BR>&nbsp;&nbsp;&nbsp;&nbsp;Expediente: " & Info.plantillas.get(0).expediente
					cadena_datos_articulo=cadena_datos_articulo & "<BR>&nbsp;&nbsp;&nbsp;&nbsp;Total Venta Expediente: " & Info.plantillas.get(0).total_venta_expediente
					cadena_datos_articulo=cadena_datos_articulo & "<BR>&nbsp;&nbsp;&nbsp;&nbsp;Total Coste Expediente: " & Info.plantillas.get(0).total_coste_expediente
					cadena_datos_articulo=cadena_datos_articulo & "<BR>&nbsp;&nbsp;&nbsp;&nbsp;Beneficio: " & Info.plantillas.get(0).beneficio
					es_de_merchan="SI"
				End If				
				
				
				
			end if
			datos_pedido.movenext()
			
		wend		
		
		datos_pedido.close
		set datos_pedido=Nothing
		
		mensaje=mensaje & cadena_datos_articulo
		
		'AHORA PARA AVORIS TODO SE CENTRALIZA EN COMPRAS AVORIS
		'si son envios de merchan para todo GAG, tienen que enviarse a otro autorizador
		'if es_de_merchan="SI" then
		'	correos_recibe_real="direccion.compras@globalia.com;j.martinez@halconviajes.com;nuria.melero@globalia.com;miriam.alonso@globalia.com;spuertolas@halcon-viajes.es;malba@globalia.com"
		'	if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
				'ENTRONO PRUEBAS
				'carlos.gonzalez@globalia-artesgraficas.com
				'correos_recibe="malba@halconviajes.com;carlos.gonzalez@globalia-artesgraficas.com"
		'		correos_recibe="malba@halconviajes.com"
		'		cadena_asunto="PRUEBAS..."
		'	  else
				'ENTORNO REAL
		'		correos_recibe=correos_recibe_real
		'		cadena_asunto=""
		'	end if
		'	cmd.parameters("P_RECIBE")=correos_recibe
		'end if
		

		'AHORA PARA AVORIS TODO SE CENTRALIZA EN COMPRAS AVORIS
		'si son envios de higiene y seguridad de halcon y ecuador, tienen que enviarse a otro autorizador
		'if datos_mail("PEDIDO_AUTOMATICO")="HIGIENE_Y_SEGURIDAD" then
		'	set email_autorizador_higienicos=Server.CreateObject("ADODB.Recordset")
		'	with email_autorizador_higienicos
		'		.ActiveConnection=connimprenta
		'		.Source="SELECT A.EMAIL"
		'		.Source=.Source & " FROM USUARIOS_AUTORIZADORES_ZONAS A"
		'		.Source=.Source & " INNER JOIN USUARIOS_AUTORIZADORES_OFICINAS B" 
		'		.Source=.Source & " ON A.CODIGO_ZONA=B.ZONA"
		'		.Source=.Source & " WHERE CLIENTE=" & datos_mail("CODCLI")
				'response.write("<br>datos del pedido: " & .source)
		'		.Open
		'	end with
			
		'	correo_autorizador_higienicos=""
		'	if not email_autorizador_higienicos.eof then
		'		correo_autorizador_higienicos="" & email_autorizador_higienicos("EMAIL")
		'	end if
		'	email_autorizador_higienicos.close
		'	set email_autorizador_higienicos=nothing
			
		'	if correo_autorizador_higienicos<>"" then
		'		correos_recibe_real = correo_autorizador_higienicos & ";malba@globalia.com"
		'	end if
			
		
			
		'	if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
				'ENTRONO PRUEBAS
				'carlos.gonzalez@globalia-artesgraficas.com
				'correos_recibe="malba@halconviajes.com;carlos.gonzalez@globalia-artesgraficas.com"
		'		correos_recibe="malba@halconviajes.com"
		'		cadena_asunto="PRUEBAS..."
		'	  else
				'ENTORNO REAL
		'		correos_recibe=correos_recibe_real
		'		cadena_asunto=""
		'	end if
		'	cmd.parameters("P_RECIBE")=correos_recibe
		'end if
		
		
		
		mensaje=mensaje & "<BR><BR><BR>&nbsp;Puede acceder al perfil de administrador de este cliente pulsando el siguiente link:"
		'resto_url=Request.ServerVariables("URL")
		'resto_url=replace(resto_url, "Grabar_Pedido_Gag.asp", "Login_" & trim(session("usuario_carpeta")) & ".asp")
		
		if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
			'ENTORNO PRUEBAS		
			if empleado_gls="SI" then
				mensaje=mensaje & "<BR><BR>http://192.168.153.132/asp/carrito_imprenta_gag_BOOT/Login_GLS_Empleados.asp"
			  else
			  	' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
				' 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR tampoco
				if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=80 _
					or session("usuario_codigo_empresa")=90 or session("usuario_codigo_empresa")=130 or session("usuario_codigo_empresa")=170 _
					or session("usuario_codigo_empresa")=210 or session("usuario_codigo_empresa")=230 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 then	
					  	mensaje=mensaje & "<BR><BR>http://192.168.153.132/asp/carrito_imprenta_gag_BOOT/Login_AVORIS_Admin.asp"
				  else
				  		mensaje=mensaje & "<BR><BR>http://192.168.153.132/asp/carrito_imprenta_gag_BOOT/Login_" & trim(session("usuario_carpeta")) & ".asp"
				end if
				
			end if	
			mensaje=mensaje & "<BR><BR>este correo se deberia mandar al administrador: " & correos_recibe_real
		  else
		  	'ENTORNO REAL
			if empleado_gls="SI" then
				mensaje=mensaje & "<BR><BR><BR><BR>http://carrito.globalia-artesgraficas.com/Login_GLS_Empleados.asp"
			  else
			  	' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
				' 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR tampoco
				if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=80 _
					or session("usuario_codigo_empresa")=90 or session("usuario_codigo_empresa")=130 or session("usuario_codigo_empresa")=170 _
					or session("usuario_codigo_empresa")=210 or session("usuario_codigo_empresa")=230 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 then	
						mensaje=mensaje & "<BR><BR>http://carrito.globalia-artesgraficas.com/Login_AVORIS_Admin.asp"
				  else
				  		mensaje=mensaje & "<BR><BR>http://carrito.globalia-artesgraficas.com/Login_" & trim(session("usuario_carpeta")) & ".asp"
				end if
			end if
		end if
		mensaje=mensaje & "<BR><BR><BR>&nbsp;&nbsp;&nbsp;Saludos"
		
		'para saber en pruebas a quien se deberia de enviar este aviso
		'mensaje=mensaje & "<BR><BR><BR><BR><BR>&nbsp;&nbsp;&nbsp;Esto se Deber&iacute;a Enviar a: " & datos_mail("mail_admin")
		
		
		
		
		
		
		
		
		
		
		
		
		cmd.parameters("P_MENSAJE")=mensaje
		'cmd.parameters("P_HOST")="195.76.0.183"
		cmd.parameters("P_HOST")="192.168.150.44"
		   
		'ahora no quierenque les llegue a asm/gls ningun correo de autorizacion
		if session("usuario_codigo_empresa")<>4 then
			cmd.execute()
		end if
		
		
		
		
		set cmd=Nothing
			
	end if
	
	datos_mail.close
	set datos_mail=Nothing
		
	conn_envios_distri.close
	set conn_envios_distri=Nothing

end sub
%>











<%
	Dim up, fich
	set up = new xelUpload
	up.Upload()
		
	empleado_gls=up.Form("ocultoempleado")
	
	'response.write("<br>empleado gls: " & empleado_gls)
	if session("usuario")="" then
		if empleado_gls="SI" then
			Response.Redirect("../Login_GLS_Empleados.asp")
		  else
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
		end if
	end if
	
	
		
		'para ver si es un pago por TRANSFERENCIA o por PICARD
		forma_de_pago = up.Form("optforma_pago")
		
		total_importe = up.Form("ocultototal_pago")
		
		'para ver si es un envio a la difeccion almacenada del cliente, o a otra
		destinatario = up.Form("txtdestinatario_d")
		'response.write("<br>DESTINATARIO de txtdestinatario_d: " & destinatario & "<br>")
		telefono_destinatario = up.Form("txttelefono_destinatario_d")
		direccion_destinatario = up.Form("txtdireccion_destinatario_d")
		poblacion_destinatario = up.Form("txtpoblacion_destinatario_d")
		cp_destinatario = up.Form("txtcp_destinatario_d")
		provincia_destinatario = up.Form("txtprovincia_destinatario_d")
		pais_destinatario = up.Form("txtpais_destinatario_d")
		persona_contacto_destinatario = up.Form("txtpersona_contacto_destinatario_d")
		comentarios_entrega_destinatario = up.Form("txtcomentarios_entrega_destinatario_d")
		
		datos_adicionales_maletas=up.Form("ocultodatos_adicionales_maletas")
		'response.write("<br>datos adicionales maletas: " & datos_adicionales_maletas)
		
		datos_saldos = up.Form("ocultodatos_saldos")
		
		datos_devoluciones = up.Form("ocultodatos_devoluciones")
		
		
		valor_gastos_envio_pedido=up.Form("ocultogastos_envio_pedido")
		
		'response.write("<br>gastos de envio: " & up.Form("ocultogastos_envio_pedido"))
		'response.write("<br>gastos de envio mostrar: " & up.Form("ocultogastos_envio_pedido_mostrar"))
		
		valor_oculto_id=""
		valor_oculto_empresa=""
		valor_oculto_id_oficina=""
		'response.write("<br>0a oficina: " & valor_oculto_id_oficina)
		valor_oculto_nombre_oficina=""
		valor_oculto_direccion_oficina=""		
		valor_oculto_poblacion_oficina=""
		valor_oculto_cp_oficina=""
		valor_oculto_provincia_oficina=""
		valor_oculto_pais_oficina=""
		valor_numero_empleado=""
		valor_horario_entrega=""
		valor_nif_otros=""
		valor_nif=""
		valor_razon_social=""
		valor_enviar_a=""
		valor_telefono=""
		valor_email=""
		valor_observaciones=""
		valor_domicilio_cliente=""
		valor_poblacion_cliente=""
		valor_cp_cliente=""
		valor_provincia_cliente=""
		valor_pais_cliente=""
		valor_domicilio_envio=""
		valor_poblacion_envio=""
		valor_cp_envio=""
		valor_provincia_envio=""
		
		
		'[{"name":"oculto_id","value":""},{"name":"oculto_id_oficina","value":"6214"},{"name":"oculto_nombre_oficina","value":"001-SALAMANCA - CANALEJAS"},
		'{"name":"oculto_poblacion_oficina","value":"SALAMANCA"},{"name":"oculto_cp_oficina","value":"37001"},{"name":"oculto_provincia_oficina","value":"SALAMANCA"},
		'{"name":"oculto_pais_oficina","value":"ESPAÑA"},{"name":"txtnumero_empleado_d","value":"19316"},{"name":"txthorario_entrega_d","value":"asdf"},
		'{"name":"txtnif_d","value":"07973028D"},{"name":"txtrazon_social_d","value":"manuel alba gallego"},{"name":"radio","value":"CLIENTE"},{"name":"txttelefono_d","value":"923w"},
		'{"name":"txtemail_d","value":"m"},{"name":"txtobservaciones_d","value":"sadfasd"},{"name":"txtdomicilio_d","value":"asdf"},{"name":"txtpoblacion_d","value":"asdf"},
		'{"name":"txtcp_d","value":"asdf"},{"name":"txtprovincia_d","value":"asdf"},{"name":"txtpais_d","value":"asdf"},{"name":"txtdomicilio_envio_d","value":""},
		'{"name":"txtpoblacion_envio_d","value":""},{"name":"txtcp_envio_d","value":""},{"name":"txtprovincia_envio_d","value":""}]
		'response.write("<br><br>datos adicionales maletas: " & datos_adicionales_maletas)
		if datos_adicionales_maletas<>"" then
			'response.write("<br><br>datos adicionales maletas antes del replace de comillas dobles: " & datos_adicionales_maletas)
			'datos_adicionales_maletas=replace(datos_adicionales_maletas, """""", "\""""")
			'response.write("<br><br>datos adicionales maletas, despues del replace de comillas dobles: " & datos_adicionales_maletas)
			'datos_adicionales_maletas=replace(datos_adicionales_maletas, """", "\""")
			'response.write("<br><br>datos adicionales maletas, despues del replace de comillas dobles con barra: " & datos_adicionales_maletas)
			dim info_maletas : set info_maletas = JSON.parse(datos_adicionales_maletas)
			'response.write("<br><br>hemos pasado el json.parse")
			
			dim key : for each key in info_maletas.enumerate()
			    'Response.write("<br>elemento: " & key )
				'Response.write("<br>...........nombre: " & info_maletas.get(key).name & vbNewline) ' prints 27
				'Response.write("<br>...........valor: " & info_maletas.get(key).value & vbNewline) ' prints 27
				'Response.write("<br>variable:" & info_maletas.get(key).name & " .. Valor: " & REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")) ' prints 27
					
				Select Case info_maletas.get(key).name
					
					Case "oculto_id"
							valor_oculto_id=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "oculto_empresa"
							valor_oculto_empresa=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "oculto_id_oficina"
							valor_oculto_id_oficina=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
							'response.write("<br>0b oficina: " & valor_oculto_id_oficina)
					Case "oculto_nombre_oficina"
							valor_oculto_nombre_oficina=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "oculto_direccion_oficina"
							valor_oculto_direccion_oficina=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "oculto_poblacion_oficina"
							valor_oculto_poblacion_oficina=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "oculto_cp_oficina"
							valor_oculto_cp_oficina=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "oculto_provincia_oficina"
							valor_oculto_provincia_oficina=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "oculto_pais_oficina"
							valor_oculto_pais_oficina=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtnumero_empleado_d"
							valor_numero_empleado=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txthorario_entrega_d"
							valor_horario_entrega=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "cmbnif_otros"
							valor_nif_otros=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtnif_d"
							valor_nif=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtrazon_social_d"
							valor_razon_social=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "radio"
							valor_enviar_a=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txttelefono_d"
							valor_telefono=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtemail_d"
							valor_email=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtobservaciones_d"
							valor_observaciones=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtdomicilio_d"
							valor_domicilio_cliente=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtpoblacion_d"
							valor_poblacion_cliente=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtcp_d"
							valor_cp_cliente=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtprovincia_d"
							valor_provincia_cliente=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					'Case "txtpais_d"
					'		valor_pais_cliente=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "cmbpaises_d"
							valor_pais_cliente=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtdomicilio_envio_d"
							valor_domicilio_envio=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtpoblacion_envio_d"
							valor_poblacion_envio=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtcp_envio_d"
							valor_cp_envio=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					Case "txtprovincia_envio_d"
							valor_provincia_envio=REPLACE(REPLACE(info_maletas.get(key).value, """", "´"), "'", "´")
					
				End Select
			next
			
		end if		
		
		
		
		'response.write("<br>valor_oculto_id: " & valor_oculto_id)	
		'response.write("<br>valor_oculto_empresa: " & valor_oculto_empresa)	
		'response.write("<br>valor_oculto_id_oficina: " & valor_oculto_id_oficina)	
		'response.write("<br>valor_oculto_nombre_oficina: " & valor_oculto_nombre_oficina)	
		'response.write("<br>valor_oculto_direccion_oficina: " & valor_oculto_direccion_oficina)	
		'response.write("<br>valor_oculto_poblacion_oficina: " & valor_oculto_poblacion_oficina)	
		'response.write("<br>valor_oculto_cp_oficina: " & valor_oculto_cp_oficina)	
		'response.write("<br>valor_oculto_provincia_oficina: " & valor_oculto_provincia_oficina)	
		'response.write("<br>valor_oculto_pais_oficina: " & valor_oculto_pais_oficina)	
		'response.write("<br>valor_numero_empleado: " & valor_numero_empleado)	
		'response.write("<br>valor_horario_entrega: " & valor_horario_entrega)	
		'response.write("<br>valor_nif: " & valor_nif)	
		'response.write("<br>valor_razon_social: " & valor_razon_social)	
		'response.write("<br>valor_enviar_a: " & valor_enviar_a)	
		'response.write("<br>valor_telefono: " & valor_telefono)	
		'response.write("<br>valor_email: " & valor_email)	
		'response.write("<br>valor_observaciones: " & valor_observaciones)	
		'response.write("<br>valor_domicilio_cliente: " & valor_domicilio_cliente)	
		'response.write("<br>valor_poblacion_cliente: " & valor_poblacion_cliente)	
		'response.write("<br>valor_cp_cliente: " & valor_cp_cliente)	
		'response.write("<br>valor_provincia_cliente: " & valor_provincia_cliente)	
		'response.write("<br>valor_pais_cliente: " & valor_pais_cliente)	
		'response.write("<br>valor_domicilio_envio: " & valor_domicilio_envio)	
		'response.write("<br>valor_poblacion_envio: " & valor_poblacion_envio)	
		'response.write("<br>valor_cp_envio: " & valor_cp_envio)	
		'response.write("<br>valor_provincia_envio: " & valor_provincia_envio)	
		

		
		
		
		
		
		set  fso=Server.CreateObject("Scripting.FileSystemObject")
		
		accion=""
		acciones=up.Form("ocultoacciones")
		if acciones<>"" then
			tabla_acciones=Split(acciones,"--")
			accion=tabla_acciones(0)
			pedido_modificar=tabla_acciones(1)
			fecha_pedido=tabla_acciones(2)
		end if
		




	error_mezcla="NO"
	error_mezcla_merchan_personalizable="NO"
	error_mezcla_merchan_no_personalizable="NO"
	error_mezcla_maletas="NO"
	error_mezcla_higienicos="NO"
	error_mezcla_gls_navidad="NO"
	error_mezcla_papeleria_propia="NO"
	'pruebo a no añadir comprobacion para las familias de GLS ROTULACION porque 
	'deberia funcionar ya que la comprobacion se hace antes en la pagina del carrito
	
	
	'por si aplican un descuento en el pedido, lo guardamos en la cabecera del pedido
	descuento_pedido=0
	If up.Form("ocultodescuento_pedido")<>"" Then
		descuento_pedido=up.Form("ocultodescuento_pedido")
	end if
	
	
	'los pedidos con articulos que requieren autorizacion, van a pendientes de autorizacion
	' y el resto va a sin tratar
	estado_consulta="SIN TRATAR"
	estado_consulta_general="SIN TRATAR"
	
	
	
	'**************************************
	'aqui vemos el caso particular de GEOMOON
	'if session("usuario_codigo_empresa")=130 then
			'todas las propias van a pendiente de autorizacion
			'estado_consulta="PENDIENTE AUTORIZACION"
			'ya no requieren autorizacion previa
	'		estado_consulta="SIN TRATAR"
	'END IF
	
	' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
	' 240 FRANQUICIAS HALCON, 250 FANQUICIAS ECUADOR tampoco
	if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=80 _
		or session("usuario_codigo_empresa")=90 or session("usuario_codigo_empresa")=130 or session("usuario_codigo_empresa")=170 _
		or session("usuario_codigo_empresa")=210 or session("usuario_codigo_empresa")=230 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 then		
	
		estado_consulta="PENDIENTE AUTORIZACION"
		'si va a ser una maleta de globalbag, se pone a sin tratar directamente
		'response.write("<br>1 oficina: " & valor_oculto_id_oficina)
		if valor_oculto_id_oficina<>"" then
			estado_consulta="SIN TRATAR"
		end if
		'response.write("<br>.......... estado: " & estado_consulta)
	end if
				
	'**************************************
	'aqui vemos el caso particular de GEOMOON, al ser todo franquicias va a SIN TRATAR
	if session("usuario_codigo_empresa")=130 then
		'ya no requieren autorizacion previa
		estado_consulta="SIN TRATAR"
	END IF
	
	'aqui vemos el caso particulas de las FRANQUICIAS DE HALCON Y ECUADOR, que va a sin tratar, no necesitan autorizador
	if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" then
		estado_consulta="SIN TRATAR"
	end if
	
	'los pedidos de GENERAL CARRITO entran en PENDIENTES DE PAGO, ya sea por transferencia o por tarjeta, no hay un autorizador previo		
	if session("usuario_codigo_empresa")=260 then
		estado_consulta="PENDIENTE PAGO"
	END IF
	
	'**************************************
	'aqui vemos el caso particular de ASM con sus propios estados del pedido
	if session("usuario_codigo_empresa")=4 	then
			'todas las propias van a pendiente de autorizacion
			if session("usuario_tipo")="PROPIA" then
					estado_consulta="PENDIENTE AUTORIZACION"	
			end if
			if session("usuario_tipo")="GLS PROPIA" then
					estado_consulta="PENDIENTE AUTORIZACION"	
			end if
			
			'las franquicias, van a en pendiente de pago, aunque el primer pedido
			if session("usuario_tipo")="AGENCIA" then
				estado_consulta="PENDIENTE PAGO"	
			end if
		  	if session("usuario_tipo")="ARRASTRES" then
				estado_consulta="PENDIENTE PAGO"	
			end if
			
			
			' esta 406 ASM TETUAN es una franquicia no una oficina propia	
			' y es un caso especial, una franquicia, pero se graba en sin tratar
			if session("usuario")=4674 then
				estado_consulta="SIN TRATAR"	
			end if
			
			' esta 739 MATARO NEW es una franquicia no una oficina propia	
			' y es un caso especial, una franquicia, pero se graba en sin tratar
			if session("usuario")=7970 then
				estado_consulta="SIN TRATAR"	
			end if
			
			' esta 526 GLS CORNELLA-MATARO es una franquicia no una oficina propia	
			' y es un caso especial, una franquicia, pero se graba en sin tratar
			if session("usuario")=10264 then
				estado_consulta="SIN TRATAR"	
			end if
			
			
			
			'aqui controlamos el estado de reservado para las franquicias de ASM
			' reservado, si todo el pedido es de GLS
			' pendiente de cobro si todo es de ASM
			' y mensaje de error si se mezclan asm-gls
			conjunto_articulos=""
			cadena_sql=""
			hay_de_gls="NO"
			hay_de_asm="NO"
			
			for i=1 to Session("numero_articulos")
				id=session(i)
				if conjunto_articulos<>"" then
					conjunto_articulos=conjunto_articulos & ", " & id
				 else
				 	conjunto_articulos=id
				end if
			next
			'response.write("<br>los articulos del pedido: " & conjunto_articulos)
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS_AGRUPADAS"
			cadena_sql = cadena_sql & " ON FAMILIAS_AGRUPADAS.ID_FAMILIA=FAMILIAS.ID"
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND FAMILIAS_AGRUPADAS.ID_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS_AGRUPADAS.GRUPO_FAMILIAS) NOT LIKE '%BRANDING%'"
			
			set ver_mezcla=Server.CreateObject("ADODB.Recordset")
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_asm="SI"			
			end if

			ver_mezcla.close
			
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS_AGRUPADAS"
			cadena_sql = cadena_sql & " ON FAMILIAS_AGRUPADAS.ID_FAMILIA=FAMILIAS.ID"
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND FAMILIAS_AGRUPADAS.ID_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS_AGRUPADAS.GRUPO_FAMILIAS) LIKE '%BRANDING%'"
			
			
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_gls="SI"			
			end if
			
			ver_mezcla.close
			set ver_mezcla=Nothing
			
			if hay_de_gls="SI" and hay_de_asm="SI" then
				error_mezcla="SI" 'para que muestre el error
			  else
			  	if hay_de_gls="SI" then 'si todo es gls, lo pasa a RESERVADO
					estado_consulta="RESERVADO"
					estado_consulta_general="RESERVADO"
				end if
	
			end if
			
	end if
	'fin del caso de ASM
	'****************************************
	
	
	
	
	
	'**************************************
	'aqui vemos el caso particular de HALCON (10) Y ECUADOR (20)  que no pueden merzclar los articulos de merchan personalizable
	if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 then
			conjunto_articulos=""
			cadena_sql=""
			hay_de_merchan_personalizable="NO"
			hay_de_resto="NO"
			
			for i=1 to Session("numero_articulos")
				id=session(i)
				if conjunto_articulos<>"" then
					conjunto_articulos=conjunto_articulos & ", " & id
				 else
				 	conjunto_articulos=id
				end if
			next
			'response.write("<br>los articulos del pedido: " & conjunto_articulos)
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) IN ('MERCHANDISING PERSONALIZABLE')"
			
			'response.write("<br>cadena sql: " & cadena_sql)
			set ver_mezcla=Server.CreateObject("ADODB.Recordset")
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_merchan_personalizable="SI"			
			end if

			ver_mezcla.close
			
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) NOT IN ('MERCHANDISING PERSONALIZABLE')"
			
			'response.write("<br>cadena sql: " & cadena_sql)
			
			
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_resto="SI"			
			end if
			
			ver_mezcla.close
			set ver_mezcla=Nothing
			
			if hay_de_merchan_personalizable="SI" and hay_de_resto="SI" then
				error_mezcla_merchan_personalizable="SI" 'para que muestre el error
			end if
			
	end if
	'fin del caso de HALCON Y ECUADOR MERCHAN personalizable
	'****************************************
	
	'**************************************
	'aqui vemos el caso particular de HALCON (10) Y ECUADOR (20)  que no pueden merzclar los articulos de merchan no personalizable
	if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 then
			conjunto_articulos=""
			cadena_sql=""
			hay_de_merchan_no_personalizable="NO"
			hay_de_resto="NO"
			
			for i=1 to Session("numero_articulos")
				id=session(i)
				if conjunto_articulos<>"" then
					conjunto_articulos=conjunto_articulos & ", " & id
				 else
				 	conjunto_articulos=id
				end if
			next
			'response.write("<br>los articulos del pedido: " & conjunto_articulos)
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) IN ('MERCHANDISING NO PERSONALIZABLE')"
			
			'response.write("<br>cadena sql: " & cadena_sql)
			set ver_mezcla=Server.CreateObject("ADODB.Recordset")
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_merchan_no_personalizable="SI"			
			end if

			ver_mezcla.close
			
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) NOT IN ('MERCHANDISING NO PERSONALIZABLE')"
			
			'response.write("<br>cadena sql: " & cadena_sql)
			
			
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_resto="SI"			
			end if
			
			ver_mezcla.close
			set ver_mezcla=Nothing
			
			if hay_de_merchan_no_personalizable="SI" and hay_de_resto="SI" then
				error_mezcla_merchan_no_personalizable="SI" 'para que muestre el error
			end if
			
	end if
	'fin del caso de HALCON Y ECUADOR MERCHAN no personalizable
	'****************************************
	
	
	
	
	'**************************************
	'aqui vemos el caso particular de HALCON (10) Y ECUADOR (20)  que no pueden merzclar LA FAMILIA DE MALETAS CON OTROS ARTICULOS
	if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 then
			conjunto_articulos=""
			cadena_sql=""
			hay_de_maletas="NO"
			hay_de_resto="NO"
			
			for i=1 to Session("numero_articulos")
				id=session(i)
				if conjunto_articulos<>"" then
					conjunto_articulos=conjunto_articulos & ", " & id
				 else
				 	conjunto_articulos=id
				end if
			next
			'response.write("<br>los articulos del pedido: " & conjunto_articulos)
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) IN ('MALETAS GLOBALBAG')"
			
			'response.write("<br>cadena sql: " & cadena_sql)
			set ver_mezcla=Server.CreateObject("ADODB.Recordset")
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_maletas="SI"			
			end if

			ver_mezcla.close
			
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) NOT IN ('MALETAS GLOBALBAG')"
			
			'response.write("<br>cadena sql: " & cadena_sql)
			
			
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_resto="SI"			
			end if
			
			ver_mezcla.close
			set ver_mezcla=Nothing
			
			if hay_de_maletas="SI" and hay_de_resto="SI" then
				error_mezcla_maletas="SI" 'para que muestre el error
			end if
			
	end if
	'fin del caso de HALCON Y ECUADOR MALETAS
	'****************************************
	

	'**************************************
	'aqui vemos el caso particular de HALCON (10) Y ECUADOR (20)  que no pueden merzclar LA FAMILIA DE HIGIENICOS Y SEGURIDAD
	if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 then
			conjunto_articulos=""
			cadena_sql=""
			hay_de_higienicos="NO"
			hay_de_resto="NO"
			
			for i=1 to Session("numero_articulos")
				id=session(i)
				if conjunto_articulos<>"" then
					conjunto_articulos=conjunto_articulos & ", " & id
				 else
				 	conjunto_articulos=id
				end if
			next
			'response.write("<br>los articulos del pedido: " & conjunto_articulos)
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) IN ('HIGIENE Y SEGURIDAD')"
			
			'response.write("<br>cadena sql: " & cadena_sql)
			set ver_mezcla=Server.CreateObject("ADODB.Recordset")
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>....CANDENA PARA VER HIGIENICOS: " & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_higienicos="SI"			
			end if

			ver_mezcla.close
			
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) NOT IN ('HIGIENE Y SEGURIDAD')"
			
			'response.write("<br>cadena sql PARA VER DIFERENTE A HIGIENICOS: " & cadena_sql)
			
			
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_resto="SI"			
			end if
			
			ver_mezcla.close
			set ver_mezcla=Nothing
			
			if hay_de_higienicos="SI" and hay_de_resto="SI" then
				if session("usuario_tipo")<>"FRANQUICIA" then 'para las franquicias si se permite la mezcla de higienicos con el resto
					error_mezcla_higienicos="SI" 'para que muestre el error
				  else
					error_mezcla_higienicos="NO" 
				end if
			end if
				
	end if
	'fin del caso de HALCON Y ECUADOR HIGIENICOS Y SEGURIDAD
	'****************************************
	
	
	'**************************************
	'aqui vemos el caso particular de ECUADOR (20), sus franquicias hasta el 01/10/2021 la papeleria propia se factura a la central
	'  despues se factura a cada oficina
	
	fecha_actual = Date()
	'xFecha = Day(fecha_actual) & "/" & Month(fecha_actual) & "/" & Year(fecha_actual)
	fecha_limite=cdate("01/10/2021")
	diferencia_dias=0
	diferencia_dias=datediff("d", fecha_actual, fecha_limite)
	'response.write("<br>fecha_actural: " & fecha_actual & "<br>fecha limite: " & fecha_limite & "<br>diferencia: " & diferencia_dias)

	if (session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" and diferencia_dias>0 then
			conjunto_articulos=""
			cadena_sql=""
			hay_de_papeleria_propia="NO"
			hay_de_resto="NO"
			
			
			
			for i=1 to Session("numero_articulos")
				id=session(i)
				if conjunto_articulos<>"" then
					conjunto_articulos=conjunto_articulos & ", " & id
				 else
				 	conjunto_articulos=id
				end if
			next
			'response.write("<br>los articulos del pedido: " & conjunto_articulos)
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) IN ('PAPELERÍA PROPIA')"
			
			'response.write("<br>cadena sql para papeleria propia: " & cadena_sql)
			set ver_mezcla=Server.CreateObject("ADODB.Recordset")
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>....CANDENA PARA VER HIGIENICOS: " & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_papeleria_propia="SI"			
			end if

			ver_mezcla.close
			
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) NOT IN ('PAPELERÍA PROPIA')"
			
			'response.write("<br>cadena sql PARA VER DIFERENTE A papeleria propia: " & cadena_sql)
			
			
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_resto="SI"			
			end if
			
			ver_mezcla.close
			set ver_mezcla=Nothing
			
			if hay_de_papeleria_propia="SI" and hay_de_resto="SI" then
				error_mezcla_papeleria_propia="SI" 'para que muestre el error
			  else
				error_mezcla_papeleria_propia="NO" 
			end if
				
			'response.write("<br><br>valore de hay_de_papeleria_propia: " & hay_de_papeleria_propia)
			'response.write("<br>valor de hay_de_resto: " & hay_de_resto)
			'response.write("<br><br>error_mezcla_papeleria_propia: " & error_mezcla_papeleria_propia)
	end if
	'fin del caso de ECUADOR FRANQUICIAS PAPELERIA PROPIA
	
	
	
	'**************************************
	'aqui vemos el caso particular de GLS (4)  que no pueden merzclar LA FAMILIA DE PRODUCTOS NAVIDAD
	'ahora 10/11/2022 ya no se tiene en cuenta esto, se pueden mezclar
	if session("usuario_codigo_empresa")=4 then
			conjunto_articulos=""
			cadena_sql=""
			hay_de_gls_navidad="NO"
			hay_de_gls_navidad_resto="NO"
			
			for i=1 to Session("numero_articulos")
				id=session(i)
				if conjunto_articulos<>"" then
					conjunto_articulos=conjunto_articulos & ", " & id
				 else
				 	conjunto_articulos=id
				end if
			next
			'response.write("<br>los articulos del pedido: " & conjunto_articulos)
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) IN ('GLS PRODUCTOS NAVIDAD')"
			
			'response.write("<br>cadena sql: " & cadena_sql)
			set ver_mezcla=Server.CreateObject("ADODB.Recordset")
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				'10/11/2022 ya se pueden mezclar articulos
				'hay_de_gls_navidad="SI"			
			end if

			ver_mezcla.close
			
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND UPPER(FAMILIAS.DESCRIPCION) NOT IN ('GLS PRODUCTOS NAVIDAD')"
			
			'response.write("<br>cadena sql: " & cadena_sql)
			
			
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				'10/11/2022 ya se pueden mezclar
				'hay_de_gls_navidad_resto="SI"			
			end if
			
			ver_mezcla.close
			set ver_mezcla=Nothing
			
			if hay_de_gls_navidad="SI" and hay_de_gls_navidad_resto="SI" then
				'10/11/2022 ya se pueden mezclar articulos
				'error_mezcla_gls_navidad="SI" 'para que muestre el error
			end if
			
			
			conjunto_articulos=""
			cadena_sql=""
			hay_de_gls_rotulacion="NO"
			
			for i=1 to Session("numero_articulos")
				id=session(i)
				if conjunto_articulos<>"" then
					conjunto_articulos=conjunto_articulos & ", " & id
				 else
				 	conjunto_articulos=id
				end if
			next
			'response.write("<br>los articulos del pedido: " & conjunto_articulos)
			
			'TODAS LAS FAMILIAS NUEVAS DE ROTULACION INTERIOR Y EXTERIOR DE GLS
			'	342	- GLS ROTULACIÓN BANDEROLAS
			'	343	- GLS ROTULACIÓN CORPOREOS
			'	344	- GLS ROTULACIÓN RÓTULOS FACHADA
			'	345	- GLS ROTULACIÓN AGENCIAS
			'	346	- GLS ROTULACIÓN BANDERAS
			'	347	- GLS ROTULACIÓN DESPACHOS
			'	348	- GLS ROTULACIÓN GENERAL
			'	349	- GLS ROTULACIÓN PARKING
			'	350	- GLS ROTULACIÓN PRL
			'	351	- GLS ROTULACIÓN PUERTAS
			'	352	- GLS ROTULACIÓN SEÑALIZACIÓN
			'	353	- GLS ROTULACIÓN SERVICIOS
			'	354	- GLS ROTULACIÓN VESTUARIOS
			'	355	- GLS ROTULACIÓN ASEOS/WC
			'	356	- GLS ROTULACIÓN ZONAS COMUNES
			
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND FAMILIAS.ID>=342"
			cadena_sql = cadena_sql & " AND FAMILIAS.ID<=356"
			
			'response.write("<br>cadena sql: " & cadena_sql)
			set ver_mezcla=Server.CreateObject("ADODB.Recordset")
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_gls_rotulacion="SI"			
			end if

			ver_mezcla.close
			
			cadena_sql = "SELECT * FROM ARTICULOS"
			cadena_sql = cadena_sql & " INNER JOIN ARTICULOS_EMPRESAS"
			cadena_sql = cadena_sql & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
			cadena_sql = cadena_sql & " INNER JOIN FAMILIAS"
			cadena_sql = cadena_sql & " ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA AND FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			cadena_sql = cadena_sql & " AND ARTICULOS.ID IN (" & conjunto_articulos & ")"
			cadena_sql = cadena_sql & " AND (FAMILIAS.ID<342 OR FAMILIAS.ID>356)"
			
			'response.write("<br>cadena sql: " & cadena_sql)
			
			
			with ver_mezcla
				.ActiveConnection=connimprenta
				.Source=cadena_sql
				'response.write("<br>" & .source)
				.Open
			end with
			if not ver_mezcla.eof then
				hay_de_gls_rotulacion_resto="SI"			
			end if
			
			ver_mezcla.close
			set ver_mezcla=Nothing
			
			if hay_de_gls_rotulacion="SI" and hay_de_gls_rotulacion_resto="SI" then
				error_mezcla_gls_rotulacion="SI" 'para que muestre el error
			end if
			
			'comprobamos si se ha pedido una impresora, que tiene id 4583 ahora en pruebas
			'HAY QUE VER SU CODIGO EN REAL
			hay_impresora_gls="NO"
			
			for i=1 to Session("numero_articulos")
				id=session(i)
				if id=4583 then
					hay_impresora_gls="SI"
				end if
			next
			
				
	end if
	'fin del caso de GLS PRODUCTOS NAVIDAD y GLS ROTULACION
	'****************************************
	
	
	
	
	'RESPONSE.WRITE("<BR>ESTADO DEL PEDIDO: " & estado_consulta)
	
		
	'si no se mezclan articulos de asm y gls y tampoco se mezclan articulos de merchandising para halcon y ecuador
	', que deje guardar el pedido y si no, que de error
	if error_mezcla<>"SI" and error_mezcla_merchan_personalizable<>"SI" and error_mezcla_merchan_no_personalizable<>"SI" and error_mezcla_maletas<>"SI" and error_mezcla_higienicos<>"SI" and error_mezcla_papeleria_propia<>"SI" and error_mezcla_gls_navidad<>"SI" then
	
		
		if accion="MODIFICAR" then 'aqui modificamos pedidos
				'vemos si lo podemos modificar, no siendo que justo en el tiempo que va desde que selecciona
				' el pedido a modificar y se modifica, en la imprenta hayan tramitado algun articulo o simplemente
				' la central de atesa lo confirma para la imprenta
				podemos_modificarlo="NO"
				set detalles_pedido=Server.CreateObject("ADODB.Recordset")
				with detalles_pedido
					.ActiveConnection=connimprenta
					'.Source="SELECT * FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_modificar & " AND ESTADO<>'PENDIENTE PAGO'"
					.Source="SELECT * FROM PEDIDOS WHERE ID=" & pedido_modificar & " AND ESTADO<>'SIN TRATAR' AND ESTADO<>'PENDIENTE AUTORIZACION'"
					
					'para GENERAL CARRITO, controlo que el pedido esté en PENDIENTE PAGO, solo asi se puede modificar
					if session("usuario_codigo_empresa")=260 then
						.Source="SELECT * FROM PEDIDOS WHERE ID=" & pedido_modificar & " AND ESTADO <> 'PENDIENTE PAGO'"
					end if
					if session("usuario_codigo_empresa")=4 	then
						'CONTROLO QUE EL PEDIDO ESTE EN PENDIENTE DE PAGO, SOLO ASI SE PUEDE MODIFICAR POR ASM, ANTES DE PAGARLO
						.Source="SELECT * FROM PEDIDOS WHERE ID=" & pedido_modificar & " AND ESTADO<>'" & estado_consulta & "'"
						
						'en asm solo puedo modificarlo en estos 2 estados, pendiente de pago y pendiente de autorizacion
						'.Source="SELECT * FROM PEDIDOS WHERE ID=" & pedido_modificar & " AND ESTADO<>'PENDIENTE PAGO' AND ESTADO<>'PENDIENTE AUTORIZACION'"
						
						
						
						'CASO QUE modifiquemos un pedido pendiente de pago y quitemos todos los articulos de asm y
						' añadamos articulos de gls y lo tenga que pasar a reservado
						if hay_de_gls="SI" then
							.Source="SELECT * FROM PEDIDOS WHERE ID=" & pedido_modificar & " AND ESTADO<>'PENDIENTE PAGO'"
						END IF
					end if
					'response.write("<br>" & .Source)
					.Open
				end with
				
				if detalles_pedido.eof then
					podemos_modificarlo="SI"
				end if
				detalles_pedido.close
				set detalles_pedido=Nothing
				
				
				if podemos_modificarlo="SI" then
					'modifico los articulos del pedido
					' para ello, borro los articulos y añado lo que tenga en el carrito
					cadena_ejecucion="DELETE FROM PEDIDOS_DETALLES WHERE ID_PEDIDO=" & pedido_modificar
					connimprenta.BeginTrans 'Comenzamos la Transaccion
					'response.write("<br>cadena ejecucion a: " & cadena_ejecucion) 
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					
					'cadena_ejecucion3="UPDATE SALDOS SET TOTAL_DISFRUTADO=A.TOTAL_DISFRUTADO - ISNULL(B.IMPORTES,0)"
					cadena_ejecucion3="UPDATE SALDOS SET TOTAL_DISFRUTADO=ROUND((ISNULL(A.TOTAL_DISFRUTADO,0) - ISNULL(B.IMPORTES,0)),2)"
					cadena_ejecucion3=cadena_ejecucion3 & " FROM SALDOS A"
					cadena_ejecucion3=cadena_ejecucion3 & " INNER JOIN"
					cadena_ejecucion3=cadena_ejecucion3 & " (SELECT ID_SALDO, SUM(IMPORTE) AS IMPORTES"
					cadena_ejecucion3=cadena_ejecucion3 & "  FROM SALDOS_PEDIDOS"
					cadena_ejecucion3=cadena_ejecucion3 & "  WHERE ID_PEDIDO=" & pedido_modificar
					cadena_ejecucion3=cadena_ejecucion3 & "  GROUP BY ID_SALDO) B"
					cadena_ejecucion3=cadena_ejecucion3 & "  ON A.ID=B.ID_SALDO"
					
					cadena_ejecucion4="DELETE FROM SALDOS_PEDIDOS WHERE ID_PEDIDO=" & pedido_modificar
					
					
					'cadena_ejecucion5="UPDATE DEVOLUCIONES SET TOTAL_DISFRUTADO=A.TOTAL_DISFRUTADO - ISNULL(B.IMPORTES,0)"
					cadena_ejecucion5="UPDATE DEVOLUCIONES SET TOTAL_DISFRUTADO=ROUND((ISNULL(A.TOTAL_DISFRUTADO,0) - ISNULL(B.IMPORTES,0)),2)"
					cadena_ejecucion5=cadena_ejecucion5 & " FROM DEVOLUCIONES A"
					cadena_ejecucion5=cadena_ejecucion5 & " INNER JOIN"
					cadena_ejecucion5=cadena_ejecucion5 & " (SELECT ID_DEVOLUCION, SUM(IMPORTE) AS IMPORTES"
					cadena_ejecucion5=cadena_ejecucion5 & "  FROM DEVOLUCIONES_PEDIDOS"
					cadena_ejecucion5=cadena_ejecucion5 & "  WHERE ID_PEDIDO=" & pedido_modificar
					cadena_ejecucion5=cadena_ejecucion5 & "  GROUP BY ID_DEVOLUCION) B"
					cadena_ejecucion5=cadena_ejecucion5 & "  ON A.ID=B.ID_DEVOLUCION"
					
					cadena_ejecucion6="DELETE FROM DEVOLUCIONES_PEDIDOS WHERE ID_PEDIDO=" & pedido_modificar
					
					
					connimprenta.Execute cadena_ejecucion3,,adCmdText + adExecuteNoRecords
					connimprenta.Execute cadena_ejecucion4,,adCmdText + adExecuteNoRecords
					connimprenta.Execute cadena_ejecucion5,,adCmdText + adExecuteNoRecords
					connimprenta.Execute cadena_ejecucion6,,adCmdText + adExecuteNoRecords
					
					'response.write("<br>cadena ejecucion3: " & cadena_ejecucion3) 
					'response.write("<br>cadena ejecucion4: " & cadena_ejecucion4) 
					'response.write("<br>cadena ejecucion5: " & cadena_ejecucion5) 
					'response.write("<br>cadena ejecucion6: " & cadena_ejecucion6) 
					
					
					
					'borramos los ficheros json de la carpeta y se vuelven a generar
					fichero_borrar= Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar)
					fichero_borrar= fichero_borrar & "/*.json"
					
					if fso.FileExists(fichero_borrar) then
						fso.DeleteFile(fichero_borrar)	
					end if
					
					for i=1 to Session("numero_articulos")
						id=session(i)
						IF up.Form("ocultocantidad_" & id)<>"" THEN
							cantidad=up.Form("ocultocantidad_" & id)
						  else
							cantidad="null"
						end if
						if up.Form("ocultoprecio_" & id)<>"" then
							precio=up.Form("ocultoprecio_" & id)
						  else
							precio="null"
						end if
						if up.Form("ocultototal_" & id)<>"" then
							total=up.Form("ocultototal_" & id)
						  else
							total="null"
						end if
						'veo si existe porque si se deja vacio no se envia con el formulario y si pregunto por su valor, daria error
						If up.Ficheros.Exists("txtfichero_" & id) Then
							fichero_asociado=up.Ficheros("txtfichero_" & id).Nombre
							'veo si hay que borrar el fichero que habia antes
							if session(i & "_fichero_asociado")<>"" then
								'RESPONSE.WRITE(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado")))
								if fso.FileExists(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado"))) then
									fso.DeleteFile(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado")))
								end if
							end if
						  else
						  	'si no sube ningun fichero, puede que quiera mantener el fichero que habia antes, que se encuentra
							'  en la varible de sesion, y si no hay nada, se queda vacio
							fichero_asociado=session(i & "_fichero_asociado")
						end if
						'response.write("<br>fichero asociado variable: " & up.Ficheros("txtfichero_" & id).Nombre)
						'response.write("<br>fichero asociado variable: " & fichero_asociado)
						'response.write("<br>fichero asociado objeto file: up.Form(""txtfichero_" & id & """) " & up.Form("txtfichero_" & id))
						IF up.Form("ocultoautorizacion_" & id)="SI" THEN
							'CON EL CAMBIO A AVORIS TODO VA A PENDIENTE DE AUTORIZACION.... QUEDA POR CONFIRMAR SI LAS FRANQUICIAS TAMBIEN
							'LAS FRANQUICIAS DE ECUADOR y halcon PASAN DIRECTAMENTE A SIN TRATAR
							'if ((session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20) and session("usuario_tipo")="FRANQUICIA") then
							'	estado_consulta_detalle="SIN TRATAR"
							'	estado_consulta_general="SIN TRATAR"
							'  else
							'  	estado_consulta_detalle="PENDIENTE AUTORIZACION"
							'	estado_consulta_general="PENDIENTE AUTORIZACION"
							'end if
							
							' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
							' 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR tampoco
							if session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80_
								and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170_
								and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 and session("usuario_codigo_empresa")<>240_
								and session("usuario_codigo_empresa")<>250 then		
							
									estado_consulta_detalle="PENDIENTE AUTORIZACION"
									estado_consulta_general="PENDIENTE AUTORIZACION"
									'si va a ser una maleta de globalbag, se pone a sin tratar directamente
									'response.write("<br>2 oficina: " & valor_oculto_id_oficina)
									if valor_oculto_id_oficina<>"" then
										estado_consulta_detalle="SIN TRATAR"
										estado_consulta_general="SIN TRATAR"
									end if
									
									'response.write("<br>......estado consulta general: " & estado_consulta_general)
									'response.write("<br>......estado consulta detalle: " & estado_consulta_detalle)
							  else
							  		'**************************************
									'aqui vemos el caso particular de GEOMOON como todo son franquicias va a sin tratar
									if session("usuario_codigo_empresa")=130 then
										estado_consulta_detalle="SIN TRATAR"
										estado_consulta_general="SIN TRATAR"
									  else
									  	'aqui vemos el caso particulas de las FRANQUICIAS DE HALCON Y ECUADOR, que va a sin tratar, no necesitan autorizador
										if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" then
											'si es una franquicia de ecuador con papeleria propia, hasta el 01/10/2021 tiene que autorizar el pedido compras
											if (session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" and hay_de_papeleria_propia="SI" and diferencia_dias>0 then
												estado_consulta_detalle="PENDIENTE AUTORIZACION"
												estado_consulta_general="PENDIENTE AUTORIZACION"
										      else
											  	if (session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" and hay_de_merchan_personalizable="SI" then
													estado_consulta_detalle="PENDIENTE AUTORIZACION"
													estado_consulta_general="PENDIENTE AUTORIZACION"
												  else
													estado_consulta_detalle="SIN TRATAR"
													estado_consulta_general="SIN TRATAR"
												end if
											end if
										  else
											estado_consulta_detalle="PENDIENTE AUTORIZACION"
											estado_consulta_general="PENDIENTE AUTORIZACION"
											if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250) then 
												'response.write("<br>2b oficina: " & valor_oculto_id_oficina)
												if valor_oculto_id_oficina<>"" then
													estado_consulta_detalle="SIN TRATAR"
													estado_consulta_general="SIN TRATAR"
												end if
												'response.write("<br>......estado consulta general: " & estado_consulta_general)
												'response.write("<br>......estado consulta detalle: " & estado_consulta_detalle)
											end if
										end if
									END IF 'de empresa 130
							end if 'de diferente de las cadenas de avoris
						  else
								'estado_consulta_detalle="SIN TRATAR"
								' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
								' 240 FRANQUICIAS HALCON, FRANQUICIAS ECUADOR tampoco
								if session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80_
									and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170_
									and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 and session("usuario_codigo_empresa")<>240_
									and session("usuario_codigo_empresa")<>250 then		
								
										estado_consulta_detalle="SIN TRATAR"
								  else
										'**************************************
										'aqui vemos el caso particular de GEOMOON, todo son franquicias y va a SIN TRATAR
										if session("usuario_codigo_empresa")=130 then
											estado_consulta_detalle="SIN TRATAR"
											estado_consulta_general="SIN TRATAR"
										  else
										  	'aqui vemos el caso particulas de las FRANQUICIAS DE HALCON Y ECUADOR, que va a sin tratar, no necesitan autorizador
											if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" then
												'si es una franquicia de ecuador con papeleria propia, hasta el 01/10/2021 tiene que autorizar el pedido compras
												if (session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" and hay_de_papeleria_propia="SI" and diferencia_dias>0 then
													estado_consulta_detalle="PENDIENTE AUTORIZACION"
													estado_consulta_general="PENDIENTE AUTORIZACION"
												  else
													if (session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" and hay_de_merchan_personalizable="SI" then
														estado_consulta_detalle="PENDIENTE AUTORIZACION"
														estado_consulta_general="PENDIENTE AUTORIZACION"
													  else
														estado_consulta_detalle="SIN TRATAR"
														estado_consulta_general="SIN TRATAR"
													end if
												end if
											  else
												estado_consulta_detalle="PENDIENTE AUTORIZACION"
												estado_consulta_general="PENDIENTE AUTORIZACION"
												if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250) then 
													'response.write("<br>2c oficina: " & valor_oculto_id_oficina)
													if valor_oculto_id_oficina<>"" then
														estado_consulta_detalle="SIN TRATAR"
														estado_consulta_general="SIN TRATAR"
													end if
													'response.write("<br>......estado consulta general: " & estado_consulta_general)
													'response.write("<br>......estado consulta detalle: " & estado_consulta_detalle)
												end if
											end if
										END IF 'de empresa 130
								end if 'de los diferenes a las cadenas de avoris
						end if 'de ocultoautorizacion
						
						'ASM controla el estado de otra manera
						' Franquicias a Pendiente Cobro
						' Propias a Pendiente Autorizacion
						' 406 a Sin Tratar
						if session("usuario_codigo_empresa")=4 then
							estado_consulta_detalle=estado_consulta
							estado_consulta_general=estado_consulta
							'si es un pedido que ha usado devoluciones y se queda a 0, no tiene que pagar nada, y por eso entra directamente en sin tratar
							' solo en el caso de franquicias, porque para las propias quieren seguir autorizando el pedido aunque sea a 0
							if total_importe=0 and session("usuario_tipo")<>"GLS PROPIA" then
								estado_consulta_detalle="SIN TRATAR"
								estado_consulta_general="SIN TRATAR"
							end if
						end if
						
						'los detalles del pedido para GENERAL CARRITO, tambien se guardan el PENDIENTE PAGO
						if session("usuario_codigo_empresa")=260 then
							estado_consulta_detalle="PENDIENTE PAGO"
							estado_consulta_general="PENDIENTE PAGO"
						end if
						
						'CON EL CAMBIO A AVORIS, ESTO SE HACE MAS ARRIBA
						'GEOMOON para modificar tiene que estar en pendiente autorizacion
						'if session("usuario_codigo_empresa")=130 then
						'	estado_consulta_detalle=estado_consulta
						'	estado_consulta_general=estado_consulta
						'end if
						
						
						'guardo el fichero de texto json con la configuracion personalizada del articulo
						creo_json="NO"
						datos_json=""
						'IF up.Form("ocultodatos_personalizacion_json_" & id)<>"" THEN
						'	datos_json=up.Form("ocultodatos_personalizacion_json_" & id)
						'	if datos_json<>"" then
							'	creo_json="SI"
							'end if
						'end if
						
						'como dan problemas las comillas dobles del json al pasarlo al oculto, lo hago con la variable de sesion
						datos_json=session("json_" & id)
						if datos_json<>"" then
							creo_json="SI"
						end if
						
						'vacio la variable de sesion con los datos json
						session("json_" & id)=""
						
						if creo_json="SI" then
							ruta_fichero_json= Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar)
							ruta_fichero_json= ruta_fichero_json & "/json_" & id & ".json"
							
							'if fso.FileExists(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado"))) then
							'		fso.DeleteFile(Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar & "/" & session(i & "_fichero_asociado")))
							'end if
							
							'--response.write("<br>nombre del fichero a guardar: " & ruta_fichero_json)
							'--response.write("<br>contenido fichero: " & datos_json)
	
							'veo si hay que crear la ruta donde dejar el fichero json						
							ruta=Request.ServerVariables("PATH_TRANSLATED")
							'--response.write("<br>ruta a comprobar para crear: " & ruta)
							longitud_ruta=len(ruta)
							posicion=longitud_ruta
							'response.write("<br>Ruta: " & ruta)
							lugar_encontrado=0
							while posicion>0 and lugar_encontrado=0
								letra_ruta=mid(ruta,posicion,1)
								if letra_ruta="\" then
									lugar_encontrado=posicion
								end if
								'response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
								posicion=posicion-1
							wend
						
							carpeta=left(ruta,lugar_encontrado)
							'--response.write("<br>carpeta a comprobar si hay que crear: " & carpeta)
							carpeta=carpeta & "pedidos"
							
							if not fso.folderexists(carpeta) then
								existe_carpeta="no"
								fso.CreateFolder(carpeta)
							end if
								
							carpeta=carpeta & "\" & year(fecha_pedido)
							if not fso.folderexists(carpeta) then
								existe_carpeta="no"
								fso.CreateFolder(carpeta)
							end if
							
							carpeta=carpeta & "\" & session("usuario") & "__" & pedido_modificar
							if not fso.folderexists(carpeta) then
								existe_carpeta="no"
								fso.CreateFolder(carpeta)
							end if
							
							'--response.write("<br>ruta a comprobar si existe y crearla: " & carpeta)
							
							
							Set fichero_json_crear = fso.CreateTextFile (ruta_fichero_json)
							
							'fichero_json_crear.WriteLine(datos_json)
							'RESPONSE.WRITE("<BR>DATOS_JSON modificanco: " & datos_json)
							fichero_json_crear.Write(datos_json)
							fichero_json_crear.Close()
							'fso.Close()
							
							set fichero_json_crear=Nothing
							'set fso=nothing
	
	
							dim adjunto_m : set adjunto_m = JSON.parse(datos_json)
							nombre_fichero_adjunto=""
							If CheckProperty(adjunto_m.plantillas.get(0), "ocultofichero") Then
								nombre_fichero_adjunto= adjunto_m.plantillas.get(0).ocultofichero
								ruta_fichero_adjunto= Server.MapPath("./pedidos/adjuntos_plantilla/" & nombre_fichero_adjunto)
							End If
							'response.write("<br>fichero adjunto: " & nombre_fichero_adjunto)
							'response.write("<br>ruta completa fichero adjunto: " & ruta_fichero_adjunto)
							if fso.FileExists(ruta_fichero_adjunto) Then
								'movemos el fichero	
								'response.write("<br>el fichero existe y tenemos que moverlo")
								'response.write("<br>fichero a mover: " & ruta_fichero_adjunto)
								'response.write("<br>ruta destino: " & carpeta)
								ruta_destino_adjunto=carpeta & "\" & nombre_fichero_adjunto
								'response.write("<br>nombre fichero destino: " & ruta_destino_adjunto)
							
								largo_fich=len(ruta_destino_adjunto)
								salir="NO"
								while largo_fich>=1 and salir="NO"
								   'response.write("Caracter: " & mid(ruta_destino_adjunto,largo_fich,1) & " Asci: " & Asc(mid(ruta_destino_adjunto,largo_fich,1)) & "<br />")
								   if mid(ruta_destino_adjunto,largo_fich,1)="." then
									'response.write("...Caracter: " & mid(ruta_destino_adjunto,largo_fich,1) & " Asci: " & Asc(mid(ruta_destino_adjunto,largo_fich,1)) & "es un punto<br />")
									salir="SI"
								   end if
								   largo_fich=largo_fich-1
								wend
								
								'response.write("<br>posicion del punto: " & largo_fich)
								'response.write("<br>nombre fichero sin extension: " & left(ruta_destino_adjunto,largo_fich))
								fichero_sin_extension=left(ruta_destino_adjunto,largo_fich)
							
								fso.DeleteFile fichero_sin_extension & ".*"
								
								
								'if fso.FileExists(ruta_destino_adjunto) Then
								'	fso.DeleteFile ruta_destino_adjunto
								'end if
								
								fso.MoveFile ruta_fichero_adjunto, ruta_destino_adjunto
								
							end if
	
						end if ' aqui acabo de subir los ficheros json
						
						
						precio_coste_art=""
						set precio_coste_articulo=Server.CreateObject("ADODB.Recordset")
						with precio_coste_articulo
							.ActiveConnection=connimprenta
							.Source = "SELECT PRECIO_COSTE FROM ARTICULOS WHERE ID=" & id
							'response.write("<br>....CANDENA PARA VER HIGIENICOS: " & .source)
							.Open
						end with
						if not precio_coste_articulo.eof then
							precio_coste_art="" & precio_coste_articulo("PRECIO_COSTE")		
						end if
			
						precio_coste_articulo.close
						set precio_coste_articulo=Nothing
						
						if precio_coste_art="" then
							precio_coste_art="NULL"
						end if
						
						cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION, PRECIO_COSTE"
						cadena_valores=pedido_modificar & ", " & id & ", " & cantidad & ", " & REPLACE(precio,",",".") & ", " & REPLACE(total,",",".") & ", '" & estado_consulta_detalle & "', '" & fichero_asociado & "'"
						
						'para ASM
						if session("usuario_codigo_empresa")=4 then
							cadena_valores=pedido_modificar & ", " & id & ", " & cantidad & ", " & REPLACE(precio,",",".") & ", " & REPLACE(total,",",".") & ", '" & estado_consulta & "', '" & fichero_asociado & "'"
						end if
						cadena_valores=cadena_valores & ", " & REPLACE(precio_coste_art,",",".")
						
						
						cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
						'RESPONSE.WRITE("<BR>cadena ejecucion b: " & CADENA_EJECUCION)
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				
					next
					
					'IF estado_consulta_general="PENDIENTE AUTORIZACION" THEN
						'RESPONSE.WRITE("<BR>UPDATE PEDIDOS SET ESTADO='" & estado_consulta_general & "' WHERE ID=" & pedido_modificar)
						
						'si se modifica un pedido con descuento en asm, hay que guardar el importe del descuento
						'RESPONSE.WRITE("<BR>descuento pedido: " & descuento_pedido)
						
						
						
					'comprobamos si hay que gestionar saldos
					if datos_saldos<>"" then
						'response.write("<br><br>grabamos saldos:" & datos_saldos)
						tabla_saldos=Split(datos_saldos,"@@@")
						for each x in tabla_saldos
							if x <>"" then
								saldo=Split(x, "###")
								'response.write("<br>dentro de cada saldo: " & x)
								id_saldo=saldo(0)
								importe_saldo=saldo(1)
								cargo_abono=saldo(2)
							
								cadena_valores_saldo=pedido_modificar & ", " & id_saldo & ", " & replace(importe_saldo, ",", ".") & ", '" & cargo_abono & "'"
								cadena_ejecucion_saldos="INSERT SALDOS_PEDIDOS (ID_PEDIDO, ID_SALDO, IMPORTE, CARGO_ABONO) values(" & cadena_valores_saldo & ")"
								'RESPONSE.WRITE("<BR>cadena ejecucion saldos: " & cadena_ejecucion_saldos)
								connimprenta.Execute cadena_ejecucion_saldos,,adCmdText + adExecuteNoRecords
								
								cadena_total_disfrutado="UPDATE SALDOS SET TOTAL_DISFRUTADO=(SELECT ROUND(SUM(IMPORTE), 2) FROM SALDOS_PEDIDOS WHERE ID_SALDO=" & id_saldo & ")"
								cadena_total_disfrutado= cadena_total_disfrutado & " WHERE ID=" & id_saldo
								'RESPONSE.WRITE("<BR>cadena actualizacon importe disfrutado saldo: " & cadena_total_disfrutado)
								connimprenta.Execute cadena_total_disfrutado,,adCmdText + adExecuteNoRecords
							end if	
						next
					end if
						
					'comprobamos si hay que gestionar devoluciones
					if datos_devoluciones<>"" then
						'response.write("<br><br>grabamos devoluciones:" & datos_devoluciones)
						tabla_devoluciones=Split(datos_devoluciones,"@@@")
						for each x in tabla_devoluciones
							if x <>"" then
								devolucion=Split(x, "###")
								'response.write("<br>dentro de cada devolucion: " & x)
								id_devolucion=devolucion(0)
								importe_devolucion=devolucion(1)
							
								cadena_valores_devolucion=pedido_modificar & ", " & id_devolucion & ", " & replace(importe_devolucion, ",", ".")
								cadena_ejecucion_devoluciones="INSERT DEVOLUCIONES_PEDIDOS (ID_PEDIDO, ID_DEVOLUCION, IMPORTE) values(" & cadena_valores_devolucion & ")"
								'RESPONSE.WRITE("<BR>cadena ejecucion devoluciones: " & cadena_ejecucion_devoluciones)
								connimprenta.Execute cadena_ejecucion_devoluciones,,adCmdText + adExecuteNoRecords
								
								cadena_total_disfrutado="UPDATE DEVOLUCIONES SET TOTAL_DISFRUTADO=(SELECT ROUND(SUM(IMPORTE), 2) FROM DEVOLUCIONES_PEDIDOS WHERE ID_DEVOLUCION=" & id_devolucion & ")"
								cadena_total_disfrutado= cadena_total_disfrutado & " WHERE ID=" & id_devolucion
								'RESPONSE.WRITE("<BR>cadena actualizacon importe disfrutado devoluciones: " & cadena_total_disfrutado)
								connimprenta.Execute cadena_total_disfrutado,,adCmdText + adExecuteNoRecords
							end if	
						next
					end if
								
						
						
					'VEMOS SI TENEMOS QUE DAR DE ALTA EL CLIENTE O SI YA EXISTE EN NUESTRA BASE DE DATOS	
					if datos_adicionales_maletas<>"" then
						'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
						'damos de alta el cliente de las maletas
						cadena_campos_cliente="IdEmpresa, idCadena" '... el idcadena es 200, la nueva cadena para los clientes de maletas
						cadena_valores_cliente= "1, 200"
						cadena_campos_cliente=cadena_campos_cliente & ", DelGrupo, Borrado" 'campos necesarios para la buena configuracion del cliente
						cadena_valores_cliente=cadena_valores_cliente & ", 0, 0"
						'response.write("<br>cadena valores cliente hasta aqui: " & cadena_valores_cliente)
						cadena_campos_cliente=cadena_campos_cliente & ", idTipoDocumento, NIF, TITULO, TITULOL, TELEF01, EMAIL"
						if valor_nif_otros="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", " & valor_nif_otros 
						end if
						
						if valor_nif="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_nif & "'"
						end if
						if valor_razon_social="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL, NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_razon_social & "', '" & valor_razon_social & "'"
						end if
						if valor_telefono="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_telefono & "'"
						end if
						if valor_email="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_email & "'"
						end if
						'response.write("<br>cadena valores cliente hasta aqui: " & cadena_valores_cliente)												
						cadena_campos_cliente=cadena_campos_cliente & ", DOMICILIO, POBLACION, PROVINCIA, CODPOSTAL, idPais"												
						if valor_domicilio_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_domicilio_cliente & "'"
						end if
						if valor_poblacion_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_poblacion_cliente & "'"
						end if
						if valor_provincia_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_provincia_cliente & "'"
						end if
						'response.write("<br>cadena valores cliente hasta aqui: " & cadena_valores_cliente)
						if valor_cp_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_cp_cliente & "'"
						end if
						if valor_pais_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", " & valor_pais_cliente
						end if
						
						'si marca mandar al domicilio del cliente, ponemos este en la direccion de envio
						if valor_enviar_a="CLIENTE" then
							cadena_campos_cliente=cadena_campos_cliente & ", Direccion_Envio, POBLACIONENVIO, PROVINCIAENVIO, CODPOSTALENVIO"					
							if valor_domicilio_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_domicilio_cliente & "'"
							end if
							if valor_poblacion_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_poblacion_cliente & "'"
							end if
							if valor_provincia_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_provincia_cliente & "'"
							end if
							if valor_cp_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_cp_cliente & "'"
							end if							
					
							'aqui no metemos los campos del destinatario en el pedido porque es el propio cliente el destinatario
						
						end if
						
						'si marca otra direccion, la ponemos en la direccion de envio
						'pero si marca la direccion de envio de la oficina, esa no la ponemos como direccion de envio en la ficha del cliente
						if valor_enviar_a="OTRA_DIRECCION" then
							cadena_campos_cliente=cadena_campos_cliente & ", Direccion_Envio, POBLACIONENVIO, PROVINCIAENVIO, CODPOSTALENVIO"					
							if valor_domicilio_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_domicilio_envio & "'"
							end if
							if valor_poblacion_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_poblacion_envio & "'"
							end if
							if valor_provincia_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_provincia_envio & "'"
							end if
							if valor_cp_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_cp_envio & "'"
							end if		
	
							'metemos otra direccion de envio para el pedido						
							destinatario=valor_razon_social
							'response.write("<br>DESTINATARIO de OTRA DIRECCION: " & destinatario & "<br>")
		
							telefono_destinatario=valor_telefono
							direccion_destinatario=valor_domicilio_envio
							poblacion_destinatario=valor_poblacion_envio
							cp_destinatario=valor_cp_envio
							provincia_destinatario=valor_provincia_envio
												
						
						end if
						
						'si elegimos mandarlo a la oficina, ponemos como datos de la direccion del cliente
						' los mismos, tanto en la direccion fiscal como en la de envio
						if valor_enviar_a="OFICINA" then
							cadena_campos_cliente=cadena_campos_cliente & ", Direccion_Envio, POBLACIONENVIO, PROVINCIAENVIO, CODPOSTALENVIO"					
							if valor_domicilio_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_domicilio_cliente & "'"
							end if
							if valor_poblacion_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_poblacion_cliente & "'"
							end if
							if valor_provincia_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_provincia_cliente & "'"
							end if
							if valor_cp_cliente="" then
								cadena_valores_cliente=cadena_valores_cliente & ", NULL"
							  else
								cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_cp_cliente & "'"
							end if							
					

						
						
							destinatario=valor_oculto_nombre_oficina
							'response.write("<br>DESTINATARIO de OFICINA: " & destinatario & "<br>")
		
							telefono_destinatario=valor_telefono
							direccion_destinatario=valor_oculto_direccion_oficina
							poblacion_destinatario=valor_oculto_poblacion_oficina
							cp_destinatario=valor_oculto_cp_oficina
							provincia_destinatario=valor_oculto_provincia_oficina
						
						end if
						
						'valor_oculto_id_oficina=""
						'valor_oculto_pais_oficina=""
						'valor_numero_empleado=""
						'valor_horario_entrega=""
							
						'valor_enviar_a=""
										
						'valor_observaciones=""
						'valor_pais_cliente
						
						
						'response.write("<br>cadena valores cliente hasta aqui: " & cadena_valores_cliente)
						
						cadena_ejecucion_cliente="INSERT INTO CLIENTES (" & cadena_campos_cliente & ") VALUES (" & cadena_valores_cliente & ")"
						'response.write("<br>insercion de cliente: " & cadena_ejecucion_cliente)
						
						'si es un cliente nuevo o uno ya existente pero que no esta en la cadena 200 (de las maletas) hay que darlo de alta
						' y dentro de la cadena/empresa de las maletas globalbag
						'response.write("<br>valor oculto id: " & valor_oculto_id)
						'response.write("<br>valor oculto emrpesa: " & valor_oculto_empresa)
						if ((valor_oculto_id="") or (valor_oculto_id<>"" and valor_oculto_empresa<>"200")) THEN
							conn_gag.BeginTrans 'Comenzamos la Transaccion
		
							conn_gag.Execute cadena_ejecucion_cliente,,adCmdText + adExecuteNoRecords
							Set valor_nuevo = conn_gag.Execute("SELECT scope_identity()") ' Create a recordset and SELECT the new Identity
							numero_cliente=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
							valor_nuevo.Close
							Set valor_nuevo = Nothing
							'response.write("<br>se ha añadido un nuevo cliente: " & numero_cliente)
							'response.write("<br>datos de las maletas: " & datos_adicionales_maletas)
							conn_gag.CommitTrans
						  else
							numero_cliente=valor_oculto_id
						end if					
						''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
					end if	'FINAL DE LOS DATOS ADICIONALES		
			
						cadena_modificacion_pedido= "UPDATE PEDIDOS SET ESTADO='" & estado_consulta_general & "'"
						
						If (session("usuario_codigo_empresa")=4 or session("usuario_codigo_empresa")=260) and descuento_pedido<>"0" Then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESCUENTO_TOTAL=" & replace(descuento_pedido,",", ".")
						end if
						
						'SI HAY QUE MODIFICAR EL CLIENTE ASIGNADO AL PEDIDO EN LA MODIFICACION....
						if numero_cliente<>"" then
							cliente_a_guardar=numero_cliente
						  else
							cliente_a_guardar=session("usuario")
						end if
						
						if cliente_a_guardar<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", CODCLI=" & cliente_a_guardar
						end if
						if destinatario<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO='" & destinatario & "'"
						  else
						  	cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO=NULL"
						end if
						if telefono_destinatario<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_TELEFONO='" & telefono_destinatario & "'"
						  else
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_TELEFONO=NULL"
						end if
						if direccion_destinatario<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_DIRECCION='" & direccion_destinatario & "'"
						  else
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_DIRECCION=NULL"
						end if
						if poblacion_destinatario<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_POBLACION='" & poblacion_destinatario & "'"
						  ELSE
						  	cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_POBLACION=NULL"
						end if
						if cp_destinatario<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_CP='" & cp_destinatario & "'"
						  else	
						  	cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_CP=NULL"
						end if
						if provincia_destinatario<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_PROVINCIA='" & provincia_destinatario & "'"
					 	  ELSE
						  	cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_PROVINCIA=NULL"
						end if
						if pais_destinatario<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_PAIS='" & pais_destinatario & "'"
						  ELSE
						  	cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_PAIS=NULL"
						end if
						if persona_contacto_destinatario<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_PERSONA_CONTACTO='" & persona_contacto_destinatario & "'"
						  ELSE
						  	cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_PERSONA_CONTACTO=NULL"
						end if
						if comentarios_entrega_destinatario<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_COMENTARIOS_ENTREGA='" & comentarios_entrega_destinatario & "'"
						  ELSE
						  	cadena_modificacion_pedido=cadena_modificacion_pedido & ", DESTINATARIO_COMENTARIOS_ENTREGA=NULL"
						end if
						
						
						if valor_numero_empleado<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", NUMERO_EMPLEADO=" & valor_numero_empleado 
						  else
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", NUMERO_EMPLEADO=NULL"
						end if
						'response.write("<br>3 oficina: " & valor_oculto_id_oficina)
						if valor_oculto_id_oficina<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", CLIENTE_ORIGINAL=" & valor_oculto_id_oficina 
						  else
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", CLIENTE_ORIGINAL=NULL"
						end if
						if valor_horario_entrega<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", HORARIO_ENTREGA='" & valor_horario_entrega & "'"
						  else
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", HORARIO_ENTREGA=NULL"
						end if
															
						if valor_gastos_envio_pedido<>"" and valor_gastos_envio_pedido<>"0" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", GASTOS_ENVIO=" & replace(valor_gastos_envio_pedido,",", ".")
						  else
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", GASTOS_ENVIO=NULL"
						end if	
						
						if valor_enviar_a<>"" then
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DONDE_ENVIO='" & valor_enviar_a & "'"
						  else
							cadena_modificacion_pedido=cadena_modificacion_pedido & ", DONDE_ENVIO=NULL"
						end if	

						cadena_modificacion_pedido=cadena_modificacion_pedido & " WHERE ID=" & pedido_modificar
						
						'RESPONSE.WRITE("<BR><br>CADENA MODIFICACION PEDIDO (3): " & CADENA_MODIFICACION_PEDIDO)
						connimprenta.Execute cadena_modificacion_pedido,,adCmdText + adExecuteNoRecords
						
						
						
					'END IF	
					
					
					'********************
					'aqui enviamos el email para que autoricen el pedido
					'***********************
					'ASM no envia mail, SOLO SI ES DEL TIPO GLS PROPIA
					'response.write("<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>comprobacion del email 1")
					'response.write("<br>pais: " & session("usuario_pais"))
					'response.write("<br>tipo: " & session("usuario_tipo"))
					'response.write("<br>empresa: " & session("usuario_codigo_empresa"))
					'response.write("<br> estado_consulta_general: " &  estado_consulta_general)
					
					connimprenta.CommitTrans ' finaliza la transaccion		
					
					'response.write("<br>controlamos envio de mails... empresa: " & session("usuario_codigo_empresa"))
					if session("usuario_codigo_empresa")<>4 then
						'UVE tampoco envia mail
						if session("usuario_codigo_empresa")<>150 then
							'response.write("<br>.....estado: " & estado_consulta_general)
							if estado_consulta_general="PENDIENTE AUTORIZACION" then
								'response.write("<br>1 - mandamos mail para el pedido: " & pedido_modificar)
								mail_autorizacion_pedido(pedido_modificar)
								'Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar)
							end if
						end if
					  else
					  	if session("usuario_pais")="ESPAÑA" and session("usuario_tipo")="GLS PROPIA" then
							if estado_consulta_general="PENDIENTE AUTORIZACION" then
								'response.write("<br>2 - mandamos mail2")
								mail_autorizacion_pedido(pedido_modificar)
							end if
						end if
					end if					
					
					
					'connimprenta.CommitTrans ' finaliza la transaccion
					
					'si no suben ficheros, no tengo porque crear la carpeta
					if up.Ficheros.Count>0 then
					
						ruta=Request.ServerVariables("PATH_TRANSLATED")
						longitud_ruta=len(ruta)
						posicion=longitud_ruta
						'response.write("<br>Ruta: " & ruta)
						lugar_encontrado=0
						while posicion>0 and lugar_encontrado=0
							letra_ruta=mid(ruta,posicion,1)
							if letra_ruta="\" then
								lugar_encontrado=posicion
							end if
							'response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
							posicion=posicion-1
						wend
					
						carpeta=left(ruta,lugar_encontrado)
						'response.write("<br>" & carpeta)
						carpeta=carpeta & "pedidos"
						
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
							
						carpeta=carpeta & "\" & year(fecha_pedido)
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
						
						carpeta=carpeta & "\" & session("usuario") & "__" & pedido_modificar
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
					end if
					'response.write("<br>" & carpeta)
					For each fich in up.Ficheros.Items	
						'subo el fichero al servidor
						'response.write("<br>" & fich.Nombre)
						'fich.GuardarComo fich.Nombre, ruta
						fich.GuardarComo fich.Nombre, Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar)
						'guardo el nombre del documento en la base de datos
					Next
					
					
					mensaje_aviso="El Pedido Ha sido Modificado con Exito..."
				  else
					mensaje_aviso="NO SE HA PODIDO MODIFICAR El Pedido Porque Ya Está Siendo Tramitado por Globalia Artes Gráficas..."
				end if
			
				
				pedido_pago=pedido_modificar
				'response.write("<br>numero de pedido a modificar: " & pedido_pago)
		
		
			else 'aqui damos de alta pedidos
			
			
				if datos_adicionales_maletas<>"" then
					'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
					'damos de alta el cliente de las maletas
					cadena_campos_cliente="IdEmpresa, idCadena" '... el idcadena es 200, la nueva cadena para los clientes de maletas
					cadena_valores_cliente= "1, 200"
					cadena_campos_cliente=cadena_campos_cliente & ", DelGrupo, Borrado" 'campos necesarios para la buena configuracion del cliente
					cadena_valores_cliente=cadena_valores_cliente & ", 0, 0"
						
					'response.write("<br>cadena valores cliente hasta aqui: " & cadena_valores_cliente)
					cadena_campos_cliente=cadena_campos_cliente & ", idTipoDocumento, NIF, TITULO, TITULOL, TELEF01, EMAIL"
					if valor_nif_otros="" then
						cadena_valores_cliente=cadena_valores_cliente & ", NULL"
					  else
						cadena_valores_cliente=cadena_valores_cliente & ", " & valor_nif_otros 
					end if
					if valor_nif="" then
						cadena_valores_cliente=cadena_valores_cliente & ", NULL"
					  else
						cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_nif & "'"
					end if
					if valor_razon_social="" then
						cadena_valores_cliente=cadena_valores_cliente & ", NULL, NULL"
					  else
						cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_razon_social & "', '" & valor_razon_social & "'"
					end if
					if valor_telefono="" then
						cadena_valores_cliente=cadena_valores_cliente & ", NULL"
					  else
						cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_telefono & "'"
					end if
					if valor_email="" then
						cadena_valores_cliente=cadena_valores_cliente & ", NULL"
					  else
						cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_email & "'"
					end if
					'response.write("<br>cadena valores cliente hasta aqui: " & cadena_valores_cliente)												
					cadena_campos_cliente=cadena_campos_cliente & ", DOMICILIO, POBLACION, PROVINCIA, CODPOSTAL, idPais"												
					if valor_domicilio_cliente="" then
						cadena_valores_cliente=cadena_valores_cliente & ", NULL"
					  else
						cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_domicilio_cliente & "'"
					end if
					if valor_poblacion_cliente="" then
						cadena_valores_cliente=cadena_valores_cliente & ", NULL"
					  else
						cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_poblacion_cliente & "'"
					end if
					if valor_provincia_cliente="" then
						cadena_valores_cliente=cadena_valores_cliente & ", NULL"
					  else
						cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_provincia_cliente & "'"
					end if
					'response.write("<br>cadena valores cliente hasta aqui: " & cadena_valores_cliente)
					if valor_cp_cliente="" then
						cadena_valores_cliente=cadena_valores_cliente & ", NULL"
					  else
						cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_cp_cliente & "'"
					end if
					if valor_pais_cliente="" then
						cadena_valores_cliente=cadena_valores_cliente & ", NULL"
					  else
						cadena_valores_cliente=cadena_valores_cliente & ", " & valor_pais_cliente
					end if
					
					'si marca mandar al domicilio del cliente, ponemos este en la direccion de envio
					if valor_enviar_a="CLIENTE" then
						cadena_campos_cliente=cadena_campos_cliente & ", Direccion_Envio, POBLACIONENVIO, PROVINCIAENVIO, CODPOSTALENVIO"					
						if valor_domicilio_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_domicilio_cliente & "'"
						end if
						if valor_poblacion_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_poblacion_cliente & "'"
						end if
						if valor_provincia_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_provincia_cliente & "'"
						end if
						if valor_cp_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_cp_cliente & "'"
						end if							
				
						'aqui no metemos los campos del destinatario en el pedido porque es el propio cliente el destinatario
					
					end if
					
					'si marca otra direccion, la ponemos en la direccion de envio
					'pero si marca la direccion de envio de la oficina, esa no la ponemos como direccion de envio en la ficha del cliente
					if valor_enviar_a="OTRA_DIRECCION" then
						cadena_campos_cliente=cadena_campos_cliente & ", Direccion_Envio, POBLACIONENVIO, PROVINCIAENVIO, CODPOSTALENVIO"					
						if valor_domicilio_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_domicilio_envio & "'"
						end if
						if valor_poblacion_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_poblacion_envio & "'"
						end if
						if valor_provincia_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_provincia_envio & "'"
						end if
						if valor_cp_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_cp_envio & "'"
						end if		

						'metemos otra direccion de envio para el pedido						
						destinatario=valor_razon_social
						'response.write("<br>DESTINATARIO de OTRA DIRECCION: " & destinatario & "<br>")
		
						telefono_destinatario=valor_telefono
						direccion_destinatario=valor_domicilio_envio
						poblacion_destinatario=valor_poblacion_envio
						cp_destinatario=valor_cp_envio
						provincia_destinatario=valor_provincia_envio
											
					
					end if
					
					'si elegimos mandarlo a la oficina, le ponemos al cliente la misma direccion tanto para la direccion fiscal
					' como para la direccion de envio
					if valor_enviar_a="OFICINA" then
						cadena_campos_cliente=cadena_campos_cliente & ", Direccion_Envio, POBLACIONENVIO, PROVINCIAENVIO, CODPOSTALENVIO"					
						if valor_domicilio_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_domicilio_cliente & "'"
						end if
						if valor_poblacion_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_poblacion_cliente & "'"
						end if
						if valor_provincia_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_provincia_cliente & "'"
						end if
						if valor_cp_cliente="" then
							cadena_valores_cliente=cadena_valores_cliente & ", NULL"
						  else
							cadena_valores_cliente=cadena_valores_cliente & ", '" & valor_cp_cliente & "'"
						end if							
						
						destinatario=valor_oculto_nombre_oficina
						'response.write("<br>DESTINATARIO de OFICINA: " & destinatario & "<br>")
		
						telefono_destinatario=valor_telefono
						direccion_destinatario=valor_oculto_direccion_oficina
						poblacion_destinatario=valor_oculto_poblacion_oficina
						cp_destinatario=valor_oculto_cp_oficina
						provincia_destinatario=valor_oculto_provincia_oficina
					
					end if
					
					'valor_oculto_id_oficina=""
					'valor_oculto_pais_oficina=""
					'valor_numero_empleado=""
					'valor_horario_entrega=""
						
					'valor_enviar_a=""
									
					'valor_observaciones=""
					'valor_pais_cliente
					
					
					'response.write("<br>cadena valores cliente hasta aqui: " & cadena_valores_cliente)
					
					cadena_ejecucion_cliente="INSERT INTO CLIENTES (" & cadena_campos_cliente & ") VALUES (" & cadena_valores_cliente & ")"
					'response.write("<br>insercion de cliente: " & cadena_ejecucion_cliente)
					
					'si es un cliente nuevo o uno ya existente pero que no esta en la cadena 200 (de las maletas) hay que darlo de alta
					'response.write("<br>valor oculto id: " & valor_oculto_id)
					'response.write("<br>valor oculto emrpesa: " & valor_oculto_empresa)
					if ((valor_oculto_id="") or (valor_oculto_id<>"" and valor_oculto_empresa<>"200")) THEN
						conn_gag.BeginTrans 'Comenzamos la Transaccion
	
						conn_gag.Execute cadena_ejecucion_cliente,,adCmdText + adExecuteNoRecords
						Set valor_nuevo = conn_gag.Execute("SELECT scope_identity()") ' Create a recordset and SELECT the new Identity
						numero_cliente=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
						valor_nuevo.Close
						Set valor_nuevo = Nothing
						'response.write("<br>se ha añadido un nuevo cliente: " & numero_cliente)
						'response.write("<br>datos de las maletas: " & datos_adicionales_maletas)
						conn_gag.CommitTrans
					  else
					  	numero_cliente=valor_oculto_id
					end if					
					''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
				end if	'FINAL DE LOS DATOS ADICIONALES		
			
			
				'lo guardamos con el estado de AUTORIZANDO CENTRAL, porque en Asm
				' primero tiene que autorizar el pedido su central para que lo pueda llegar a
				' tramitar la imprenta
				cadena_campos="CODCLI, FECHA, ESTADO, USUARIO_DIRECTORIO_ACTIVO, PEDIDO_AUTOMATICO, DESCUENTO_TOTAL"
				cadena_campos=cadena_campos & ", DESTINATARIO, DESTINATARIO_TELEFONO, DESTINATARIO_DIRECCION, DESTINATARIO_POBLACION"
				cadena_campos=cadena_campos & ", DESTINATARIO_CP, DESTINATARIO_PROVINCIA, DESTINATARIO_PAIS, DESTINATARIO_PERSONA_CONTACTO"
				cadena_campos=cadena_campos & ", DESTINATARIO_COMENTARIOS_ENTREGA, NUMERO_EMPLEADO, CLIENTE_ORIGINAL, HORARIO_ENTREGA"
				cadena_campos=cadena_campos & ", GASTOS_ENVIO, DONDE_ENVIO"
				'si es el primer pedido y como va a ir con descuento, lo tiene que autorizar la central de asm
				'....YA NO HACE FALTA AUTORIZAR SE GRABA NORMAL
				'if session("usuario_derecho_primer_pedido")="SI" then
				'	estado_consulta="AUTORIZACION NUEVA APERTURA"
				'end if
				
				if numero_cliente<>"" then
					cliente_a_guardar=numero_cliente
				  else
				  	cliente_a_guardar=session("usuario")
				end if
								

				if datos_adicionales_maletas<>"" then
					estado_consulta="SIN TRATAR"
				end if
				
				
				
				'ya en 2020 no hace falta dejarlo en reservado
				'if hay_de_gls_navidad="SI" then 'si son articulos de navidd, el pedidos se va a RESERVADO
				'	estado_consulta="RESERVADO"
				'	estado_consulta_general="RESERVADO"
				'end if
				
				'los pedidos de los empleados de gls se crean en sin tratar
				if empleado_gls="SI" then
					estado_consulta="SIN TRATAR"
				end if
				
				
				'si es un pedido que ha usado devoluciones y se queda a 0, no tiene que pagar nada, y por eso entra directamente en sin tratar
				'session("usuario_codigo_empresa")<>4 
				if total_importe=0  and session("usuario_tipo")<>"GLS PROPIA" then
					estado_consulta="SIN TRATAR"
				end if
				
				cadena_valores=cliente_a_guardar & ", '" & DATE() & "', '" & estado_consulta & "', "
				if  session("usuario_directorio_activo")<>"" then
					cadena_valores=cadena_valores & session("usuario_directorio_activo")
				  else
				  	cadena_valores=cadena_valores & "NULL"
				end if
				'response.write("<br><br>cadena valores hasta ahora: " & cadena_valores)
				
				if datos_adicionales_maletas<>"" then
					cadena_valores=cadena_valores & ", 'GLOBALBAG'"
				  else
					if empleado_gls="SI" then
				  		cadena_valores=cadena_valores & ", 'ROPA_EMPLEADO'"
					  else
						if session("usuario_derecho_primer_pedido")="SI" then
							if session("usuario_trato_especial")=1 then
								cadena_valores=cadena_valores & ", 'PRIMER_PEDIDO_REDYSER'"
							  else
								cadena_valores=cadena_valores & ", 'PRIMER_PEDIDO'"  
							end if
						  else
						  	if session("usuario_primer_pedido")="SI" and session("usuario_codigo_empresa")=260 then
						  		cadena_valores=cadena_valores & ", 'PRIMER_PEDIDO_GENERAL'"  
							  else
								if hay_de_merchan_personalizable="SI" then 'si es un pedido de merchandising personalizable de halcon/ecuador
									cadena_valores=cadena_valores & ", 'PEDIDO_MERCHAN_PERSONALIZABLE'"
								  else
									if hay_de_merchan_no_personalizable="SI" then 'si es un pedido de merchandising personalizable de halcon/ecuador
										cadena_valores=cadena_valores & ", 'PEDIDO_MERCHAN_NO_PERSONALIZABLE'"
									  else
										if hay_de_higienicos="SI" then 'si es un pedido de higiene y seguridad
											cadena_valores=cadena_valores & ", 'HIGIENE_Y_SEGURIDAD'"
										  else
											if hay_de_gls_navidad="SI" then 'si son articulos de navidad, el pedidos queda marcado como de NAVIDAD
												cadena_valores=cadena_valores & ", 'NAVIDAD 2022'"
											  else
												if hay_de_papeleria_propia="SI" then 'si son articulos de papeleria propia de franquicias de ecuador
													cadena_valores=cadena_valores & ", 'PAPELERIA PROPIA'"
												  else
												  	if hay_de_gls_rotulacion="SI" then 'si son articulos de Rotulacion, los pedidos quedan marcados como ROTULACION
														cadena_valores=cadena_valores & ", 'ROTULACION'"
													  else
													  	if hay_impresora_gls = "SI" then 'si se pide una impresora, los pedidos quedan marcados como IMPRESORA_GLS
													  		cadena_valores=cadena_valores & ", 'IMPRESORA_GLS'"
														  else
															cadena_valores=cadena_valores & ", NULL"
														end if
													end if 'el de rotulacion
												end if ' el de papeleria propia
											end if 'el de gls navidad
										end if 'el de hay_de_higienicos
									end if 'el de hay_de_merchan_NO_PERSONALIZABLE
								end if ' el de hay_de_merchan_personalizable
							end if 'el primer pedido de la cadena GENERAL
						end if 'el de usuario derecho primer pedido
					end if 'el del empleado_gls
				end if 'el de datos adicionales maletas
				
				'response.write("<br><br>cadena valores hasta tipo pedido automatico: " & cadena_valores)

				
				if descuento_pedido<>"" then
					cadena_valores=cadena_valores & ", " & replace(descuento_pedido,",", ".")
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				if destinatario<>"" then
					cadena_valores=cadena_valores & ", '" & destinatario & "'"
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				if telefono_destinatario<>"" then
					cadena_valores=cadena_valores & ", '" & telefono_destinatario & "'"
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				if direccion_destinatario<>"" then
					cadena_valores=cadena_valores & ", '" & direccion_destinatario & "'"
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				if poblacion_destinatario<>"" then
					cadena_valores=cadena_valores & ", '" & poblacion_destinatario & "'"
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				if cp_destinatario<>"" then
					cadena_valores=cadena_valores & ", '" & cp_destinatario & "'"
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				if provincia_destinatario<>"" then
					cadena_valores=cadena_valores & ", '" & provincia_destinatario & "'"
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				if pais_destinatario<>"" then
					cadena_valores=cadena_valores & ", '" & pais_destinatario & "'"
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				if persona_contacto_destinatario<>"" then
					cadena_valores=cadena_valores & ", '" & persona_contacto_destinatario & "'"
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				if comentarios_entrega_destinatario<>"" then
					cadena_valores=cadena_valores & ", '" & comentarios_entrega_destinatario & "'"
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				if valor_numero_empleado<>"" then
					cadena_valores=cadena_valores & ", " & valor_numero_empleado 
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				'response.write("<br>4 oficina: " & valor_oculto_id_oficina)
				if valor_oculto_id_oficina<>"" then
					cadena_valores=cadena_valores & ", " & valor_oculto_id_oficina 
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
				if valor_horario_entrega<>"" then
					cadena_valores=cadena_valores & ", '" & valor_horario_entrega & "'"
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if
													
				if valor_gastos_envio_pedido<>"" and valor_gastos_envio_pedido<>"0" then
					cadena_valores=cadena_valores & ", " & replace(valor_gastos_envio_pedido,",", ".")
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if	
				
				if valor_enviar_a<>"" then
					cadena_valores=cadena_valores & ", '" & valor_enviar_a & "'"
				  else
				  	cadena_valores=cadena_valores & ", NULL"
				end if		

			
				
				
				
				cadena_ejecucion="Insert into PEDIDOS (" & cadena_campos & ") values(" & cadena_valores & ")"
				'response.write("<br>cadena ejecucion: " & cadena_ejecucion)		   
				connimprenta.BeginTrans 'Comenzamos la Transaccion
				
				'porque el sql de produccion es un sql expres que debe tener el formato de
				' de fecha con mes-dia-año
				connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
				'response.write("<br>cadena ejecucion d: " & cadena_ejecucion) 
				connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				Set valor_nuevo = connimprenta.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
				numero_pedido=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
				valor_nuevo.Close
				Set valor_nuevo = Nothing
				
				
				pedido_pago=numero_pedido
				'response.write("<br>nuevo numero de pedido: " & pedido_pago)
				'si no suben ficheros, no tengo porque crear la carpeta
				if up.Ficheros.Count>0 then
				
					ruta=Request.ServerVariables("PATH_TRANSLATED")
					longitud_ruta=len(ruta)
					posicion=longitud_ruta
					'response.write("<br>Ruta: " & ruta)
					lugar_encontrado=0
					while posicion>0 and lugar_encontrado=0
						letra_ruta=mid(ruta,posicion,1)
						if letra_ruta="\" then
							lugar_encontrado=posicion
						end if
						'response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
						posicion=posicion-1
					wend
				
					carpeta=left(ruta,lugar_encontrado)
					'response.write("<br>" & carpeta)
					carpeta=carpeta & "pedidos"
					
					if not fso.folderexists(carpeta) then
						existe_carpeta="no"
						fso.CreateFolder(carpeta)
					end if
						
					carpeta=carpeta & "\" & year(date())
					if not fso.folderexists(carpeta) then
						existe_carpeta="no"
						fso.CreateFolder(carpeta)
					end if
					
					carpeta=carpeta & "\" & session("usuario") & "__" & numero_pedido
					if not fso.folderexists(carpeta) then
						existe_carpeta="no"
						fso.CreateFolder(carpeta)
					end if
				end if
				
				'response.write("<br>" & carpeta)
				For each fich in up.Ficheros.Items	
					'subo el fichero al servidor
					'response.write("<br>" & fich.Nombre)
					'fich.GuardarComo fich.Nombre, ruta
					fich.GuardarComo fich.Nombre, Server.MapPath("./pedidos/" & year(date()) & "/" & session("usuario") & "__" & numero_pedido)
					'guardo el nombre del documento en la base de datos
				Next
				
				for i=1 to Session("numero_articulos")
					id=session(i)
					IF up.Form("ocultocantidad_" & id)<>"" THEN
						cantidad=up.Form("ocultocantidad_" & id)
					  else
						cantidad="null"
					end if
					if up.Form("ocultoprecio_" & id)<>"" then
						precio=up.Form("ocultoprecio_" & id)
					  else
						precio="null"
					end if
					if up.Form("ocultototal_" & id)<>"" then
						total=up.Form("ocultototal_" & id)
					  else
						total="null"
					end if
					'veo si existe porque si se deja vacio no se envia con el formulario y si pregunto por su valor, daria error
					If up.Ficheros.Exists("txtfichero_" & id) Then
						fichero_asociado=up.Ficheros("txtfichero_" & id).Nombre
					  else
						fichero_asociado=""
					end if
					'response.write("<br>fichero asociado variable: " & up.Ficheros("txtfichero_" & id).Nombre)
					'response.write("<br>fichero asociado variable: " & fichero_asociado)
					'response.write("<br>fichero asociado objeto file: up.Form(""txtfichero_" & id & """) " & up.Form("txtfichero_" & id))
					IF up.Form("ocultoautorizacion_" & id)="SI" THEN
							'CON EL CAMBIO A AVORIS, TODO SON PENDIENTES DE AUTORIZACION.... QUEDA POR CONFIRMAR SI CON LAS FRANQUICIAS TAMBIEN
							'LAS FRANQUICIAS DE ECUADOR PASAN DIRECTAMENTE A SIN TRATAR
							'if ((session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20) and session("usuario_tipo")="FRANQUICIA") then
							'	estado_consulta_detalle="SIN TRATAR"
							'	estado_consulta_general="SIN TRATAR"
							'  else
							'  	estado_consulta_detalle="PENDIENTE AUTORIZACION"
							'	estado_consulta_general="PENDIENTE AUTORIZACION"
							'end if
							
							' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
							' 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR tampoco
							if session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80_
								and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170_
								and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 and session("usuario_codigo_empresa")<>240_
								and session("usuario_codigo_empresa")<>250 then		
							
									estado_consulta_detalle="PENDIENTE AUTORIZACION"
									estado_consulta_general="PENDIENTE AUTORIZACION"
									'si va a ser una maleta de globalbag, se pone a sin tratar directamente
									'response.write("<br>5 oficina: " & valor_oculto_id_oficina)
									if valor_oculto_id_oficina<>"" then
										estado_consulta_detalle="SIN TRATAR"
										estado_consulta_general="SIN TRATAR"
									end if
									'response.write("<br>......estado consulta general: " & estado_consulta_general)
									'response.write("<br>......estado consulta detalle: " & estado_consulta_detalle)
							  else
							  		'aqui vemos el caso particular de GEOMOON
									if session("usuario_codigo_empresa")=130 then
										estado_consulta_detalle="SIN TRATAR"
										estado_consulta_general="SIN TRATAR"
									  else
									  	'aqui vemos el caso particulas de las FRANQUICIAS DE HALCON Y ECUADOR, que va a sin tratar, no necesitan autorizador
										if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" then
											'si es una franquicia de ecuador con papeleria propia, hasta el 01/10/2021 tiene que autorizar el pedido compras
											if (session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" and hay_de_papeleria_propia="SI" and diferencia_dias>0 then
												estado_consulta_detalle="PENDIENTE AUTORIZACION"
												estado_consulta_general="PENDIENTE AUTORIZACION"
										      else
												if (session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" and hay_de_merchan_personalizable="SI" then
													estado_consulta_detalle="PENDIENTE AUTORIZACION"
													estado_consulta_general="PENDIENTE AUTORIZACION"
												  else
													estado_consulta_detalle="SIN TRATAR"
													estado_consulta_general="SIN TRATAR"
												end if
											end if
											
										  else
											estado_consulta_detalle="PENDIENTE AUTORIZACION"
											estado_consulta_general="PENDIENTE AUTORIZACION"
											if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250) then 
												'response.write("<br>5b oficina: " & valor_oculto_id_oficina)
												if valor_oculto_id_oficina<>"" then
													estado_consulta_detalle="SIN TRATAR"
													estado_consulta_general="SIN TRATAR"
												end if
												'response.write("<br>......estado consulta general: " & estado_consulta_general)
												'response.write("<br>......estado consulta detalle: " & estado_consulta_detalle)
											end if
										end if
									END IF 'de empresa 130
							end if ' de diferente de cadenas avoris
							
					  else
							'estado_consulta_detalle="SIN TRATAR"
							' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
							' 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR tampoco
							if session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80_
								and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170_
								and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230  and session("usuario_codigo_empresa")<>240_
								and session("usuario_codigo_empresa")<>250 then		
									estado_consulta_detalle="SIN TRATAR"
							  else
							  		'aqui vemos el caso particular de GEOMOON
									if session("usuario_codigo_empresa")=130 then
										estado_consulta_detalle="SIN TRATAR"
										estado_consulta_general="SIN TRATAR"
									  else
									  	'aqui vemos el caso particulas de las FRANQUICIAS DE HALCON Y ECUADOR, que va a sin tratar, no necesitan autorizador
										if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" then
											'si es una franquicia de ecuador con papeleria propia, hasta el 01/10/2021 tiene que autorizar el pedido compras
											if (session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" and hay_de_papeleria_propia="SI" and diferencia_dias>0 then
												estado_consulta_detalle="PENDIENTE AUTORIZACION"
												estado_consulta_general="PENDIENTE AUTORIZACION"
										      else
											  	if (session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA" and hay_de_merchan_personalizable="SI" then
													estado_consulta_detalle="PENDIENTE AUTORIZACION"
													estado_consulta_general="PENDIENTE AUTORIZACION"
												  else
													estado_consulta_detalle="SIN TRATAR"
													estado_consulta_general="SIN TRATAR"
												end if
											end if
										  else
											estado_consulta_detalle="PENDIENTE AUTORIZACION"
											estado_consulta_general="PENDIENTE AUTORIZACION"
											if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250) then 
												'response.write("<br>5c oficina: " & valor_oculto_id_oficina)
												if valor_oculto_id_oficina<>"" then
													estado_consulta_detalle="SIN TRATAR"
													estado_consulta_general="SIN TRATAR"
												end if
												'response.write("<br>......estado consulta general: " & estado_consulta_general)
												'response.write("<br>......estado consulta detalle: " & estado_consulta_detalle)
											end if
										end if
									END IF 'de emrpesa 130
							end if 'de diferente de cadenas avoris
					end if 'de oculto autorizacon

					'ASM controla el estado de otra manera
					' Franquicias a Pendiente Cobro
					' Propias a Pendiente Autorizacion
					' 406 a Sin Tratar
					if session("usuario_codigo_empresa")=4 then
						estado_consulta_detalle=estado_consulta
						estado_consulta_general=estado_consulta
						'los pedidos que usen devoluciones y se queden a 0, van a sin tratar
						if total_importe=0 and session("usuario_tipo")<>"GLS PROPIA" then
							estado_consulta_detalle="SIN TRATAR"
							estado_consulta_general="SIN TRATAR"
						end if
					end if
					'para los empleados de gls, se crean los pedidos directametne en sin trarar
					if empleado_gls="SI" then
						estado_consulta_detalle="SIN TRATAR"
						estado_consulta_general="SIN TRATAR"
					end if
					
					if session("usuario_codigo_empresa")=260 then
							estado_consulta_detalle=estado_consulta
							estado_consulta_general=estado_consulta
					end if
					
					
					'CON EL CAMBIO A AVORIS, ESO SE HACE MAS ARRIBA
					'GEOMOON para modificar tiene que estar en pendiente autorizacion
					'	if session("usuario_codigo_empresa")=130 then
					'		estado_consulta_detalle=estado_consulta
					'		estado_consulta_general=estado_consulta
					'	end if
					
					'guardo el fichero de texto json con la configuracion personalizada del articulo
					creo_json="NO"
					datos_json=""
					'RESPONSE.WRITE("<BR>OCULTODATOS_PERSONALIZACION_JSON...: " & up.Form("ocultodatos_personalizacion_json_" & id)) 
					'IF up.Form("ocultodatos_personalizacion_json_" & id)<>"" THEN
					'	datos_json=up.Form("ocultodatos_personalizacion_json_" & id)
					'	if datos_json<>"" then
						'	creo_json="SI"
						'end if
					'end if
					
					'como dan problemas las comillas dobles del json al pasarlo al oculto, lo hago con la variable de sesion
						datos_json=session("json_" & id)
						if datos_json<>"" then
							creo_json="SI"
						end if
						
					'vacio la variable de sesion con los datos json
					session("json_" & id)=""
					
					if creo_json="SI" then
						ruta_fichero_json= Server.MapPath("./pedidos/" & year(date()) & "/" & session("usuario") & "__" & numero_pedido)
						ruta_fichero_json= ruta_fichero_json & "/json_" & id & ".json"
						
						'--response.write("<br>nombre del fichero a guardar: " & ruta_fichero_json)
						'--response.write("<br>contenido fichero: " & datos_json)

						'veo si hay que crear la ruta donde dejar el fichero json						
						ruta=Request.ServerVariables("PATH_TRANSLATED")
						'--response.write("<br>ruta a comprobar para crear: " & ruta)
						longitud_ruta=len(ruta)
						posicion=longitud_ruta
						'response.write("<br>Ruta: " & ruta)
						lugar_encontrado=0
						while posicion>0 and lugar_encontrado=0
							letra_ruta=mid(ruta,posicion,1)
							if letra_ruta="\" then
								lugar_encontrado=posicion
							end if
							'response.write("<br>Posicion: " & posicion & " (" & letra_ruta & ")")
							posicion=posicion-1
						wend
					
						carpeta=left(ruta,lugar_encontrado)
						'--response.write("<br>carpeta a comprobar si hay que crear: " & carpeta)
						carpeta=carpeta & "pedidos"
						
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
							
						carpeta=carpeta & "\" & year(date())
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
						
						carpeta=carpeta & "\" & session("usuario") & "__" & numero_pedido
						if not fso.folderexists(carpeta) then
							existe_carpeta="no"
							fso.CreateFolder(carpeta)
						end if
						
						'--response.write("<br>ruta a comprobar si existe y crearla: " & carpeta)
						
						'response.write("<br>datos_json insertando, antes de los replace: " & datos_json)
						
						Set fichero_json_crear = fso.CreateTextFile (ruta_fichero_json)
						'salida.Write ("Texto Normal")
						'si el json no tiene el codigo del pedido, se lo ponemos
						if instr(datos_json, chr(34) & "codigo_pedido" & chr(34) & ":" & chr(34) & chr(34)) then
							'--response.write("<bR>cambio el codigo depedido a: " & numero_pedido)
							cadena_a_cambiar= chr(34) & "codigo_pedido" & chr(34) & ":" & chr(34) & chr(34)
							cadena_sustituta= chr(34) & "codigo_pedido" & chr(34) & ":" & chr(34) & numero_pedido & chr(34)
							'cadena_a_cambiar= "codigo_pedido"
							'cadena_sustituta= "codigo_pedidorrr"
							
							'--response.write("<br>cadena a cambiar: " & cadena_a_cambiar)
							'--response.write("<br>cadena sustituta: " & cadena_sustituta)
							datos_json=replace(datos_json, cadena_a_cambiar , cadena_sustituta)
							'--response.write("<br>datos json: " & datos_json)
						end if
						
						'fichero_json_crear.WriteLine(datos_json)
						'RESPONSE.WRITE("<BR>DATOS_JSON insertando despues de los replace: " & datos_json)
							
						fichero_json_crear.Write(datos_json)
						fichero_json_crear.Close()
						'fso.Close()
						
						set fichero_json_crear=Nothing
						'set fso=nothing

						'aqui vemos si hay adjunto y lo movemos de adjuntos_plantilla a su carpeta de pedido correspondiente
						'ruta_adjunto=Request.ServerVariables("PATH_TRANSLATED")
						
						'response.write("<br><br>------------------------------<br>apartado del logo adjunto")
						'response.write("<br>todo el json: " & datos_json)
						dim adjunto : set adjunto = JSON.parse(datos_json)
						nombre_fichero_adjunto=""
						If CheckProperty(adjunto.plantillas.get(0), "ocultofichero") Then
							nombre_fichero_adjunto= adjunto.plantillas.get(0).ocultofichero
							ruta_fichero_adjunto= Server.MapPath("./pedidos/adjuntos_plantilla/" & nombre_fichero_adjunto)
						End If
						'response.write("<br>fichero adjunto: " & nombre_fichero_adjunto)
						'response.write("<br>ruta completa fichero adjunto: " & ruta_fichero_adjunto)
						if fso.FileExists(ruta_fichero_adjunto) Then
							'movemos el fichero	
							'response.write("<br>el fichero existe y tenemos que moverlo")
							'response.write("<br>fichero a mover: " & ruta_fichero_adjunto)
							'response.write("<br>ruta destino: " & carpeta)
							ruta_destino_adjunto=carpeta & "\" & nombre_fichero_adjunto
							'response.write("<br>nombre fichero destino: " & ruta_destino_adjunto)
						
							
							if fso.FileExists(ruta_destino_adjunto) Then
								fso.DeleteFile ruta_destino_adjunto
							end if
							fso.MoveFile ruta_fichero_adjunto, ruta_destino_adjunto
							
						end if
					
					end if
					
					precio_coste_art=""
					set precio_coste_articulo=Server.CreateObject("ADODB.Recordset")
					with precio_coste_articulo
						.ActiveConnection=connimprenta
						.Source = "SELECT PRECIO_COSTE FROM ARTICULOS WHERE ID=" & id
						'response.write("<br>....CANDENA PARA VER HIGIENICOS: " & .source)
						.Open
					end with
					if not precio_coste_articulo.eof then
						precio_coste_art="" & precio_coste_articulo("PRECIO_COSTE")		
					end if
		
					precio_coste_articulo.close
					set precio_coste_articulo=Nothing
					
					if precio_coste_art="" then
						precio_coste_art="NULL"
					end if
					
					
					
					cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, FICHERO_PERSONALIZACION, PRECIO_COSTE"
					cadena_valores=numero_pedido & ", " & id & ", " & cantidad & ", " & REPLACE(precio,",",".") & ", " & REPLACE(total,",",".") & ", '" & estado_consulta_detalle & "', '" & fichero_asociado & "'"
					cadena_valores=cadena_valores & ", " & REPLACE(precio_coste_art,",",".")
					cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
					'response.write("<br>cadena ejecucion e: " & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			
			next
				
			'comprobamos si hay que gestionar saldos
			if datos_saldos<>"" then
				'response.write("<br><br>grabamos saldos:" & datos_saldos)
				tabla_saldos=Split(datos_saldos,"@@@")
				for each x in tabla_saldos
					if x <>"" then
						saldo=Split(x, "###")
						'response.write("<br>dentro de cada saldo: " & x)
						id_saldo=saldo(0)
						importe_saldo=saldo(1)
						cargo_abono=saldo(2)
						
					
						cadena_valores_saldo=numero_pedido & ", " & id_saldo & ", " & replace(importe_saldo, ",", ".") & ", '" & cargo_abono & "'"
						cadena_ejecucion_saldos="INSERT SALDOS_PEDIDOS (ID_PEDIDO, ID_SALDO, IMPORTE, CARGO_ABONO) values(" & cadena_valores_saldo & ")"
						'RESPONSE.WRITE("<BR>cadena ejecucion saldo b: " & cadena_ejecucion_saldo)
						connimprenta.Execute cadena_ejecucion_saldos,,adCmdText + adExecuteNoRecords
						
						cadena_total_disfrutado="UPDATE SALDOS SET TOTAL_DISFRUTADO=(SELECT ROUND(SUM(IMPORTE), 2) FROM SALDOS_PEDIDOS WHERE ID_SALDO=" & id_saldo & ")"
						cadena_total_disfrutado= cadena_total_disfrutado & " WHERE ID=" & id_saldo
						'RESPONSE.WRITE("<BR>cadena actualizacon importe disfrutado saldos b: " & cadena_total_disfrutado)
						connimprenta.Execute cadena_total_disfrutado,,adCmdText + adExecuteNoRecords
					end if	
				next
			end if	
				
				
			'comprobamos si hay que gestionar devoluciones
			if datos_devoluciones<>"" then
				'response.write("<br><br>grabamos devoluciones:" & datos_devoluciones)
				tabla_devoluciones=Split(datos_devoluciones,"@@@")
				for each x in tabla_devoluciones
					if x <>"" then
						devolucion=Split(x, "###")
						'response.write("<br>dentro de cada devolucion: " & x)
						id_devolucion=devolucion(0)
						importe_devolucion=devolucion(1)
					
						cadena_valores_devolucion=numero_pedido & ", " & id_devolucion & ", " & replace(importe_devolucion, ",", ".")
						cadena_ejecucion_devoluciones="INSERT DEVOLUCIONES_PEDIDOS (ID_PEDIDO, ID_DEVOLUCION, IMPORTE) values(" & cadena_valores_devolucion & ")"
						'RESPONSE.WRITE("<BR>cadena ejecucion devoluciones b: " & cadena_ejecucion_devoluciones)
						connimprenta.Execute cadena_ejecucion_devoluciones,,adCmdText + adExecuteNoRecords
						
						cadena_total_disfrutado="UPDATE DEVOLUCIONES SET TOTAL_DISFRUTADO=(SELECT ROUND(SUM(IMPORTE), 2) FROM DEVOLUCIONES_PEDIDOS WHERE ID_DEVOLUCION=" & id_devolucion & ")"
						cadena_total_disfrutado= cadena_total_disfrutado & " WHERE ID=" & id_devolucion
						'RESPONSE.WRITE("<BR>cadena actualizacon importe disfrutado devoluciones b: " & cadena_total_disfrutado)
						connimprenta.Execute cadena_total_disfrutado,,adCmdText + adExecuteNoRecords
					end if	
				next
			end if
					
			'response.write("<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>comprobacion del email 2")
			'response.write("<br>pais: " & session("usuario_pais"))
			'response.write("<br>tipo: " & session("usuario_tipo"))
			'response.write("<br>empresa: " & session("usuario_codigo_empresa"))
			'response.write("<br>controlamos envio de mails, alta pedido... empresa: " & session("usuario_codigo_empresa"))
					
			'response.write("<br>a) estado_consulta_general: " &  estado_consulta_general)
			IF estado_consulta_general="PENDIENTE AUTORIZACION" THEN
				'response.write("<br>cadena ejecucion f: UPDATE PEDIDOS SET ESTADO='PENDIENTE AUTORIZACION' WHERE ID=" & numero_pedido) 
				connimprenta.Execute "UPDATE PEDIDOS SET ESTADO='PENDIENTE AUTORIZACION' WHERE ID=" & numero_pedido,,adCmdText + adExecuteNoRecords
				'TODOS mandan email menos ASM que solo mandara email cuando la oficina sea una GLS PROPIA, para el resto no
				
				connimprenta.CommitTrans ' finaliza la transaccion
				
				'response.write("<br>controlamos envio de mails... empresa: " & session("usuario_codigo_empresa"))
				if session("usuario_codigo_empresa")=4 then
					if session("usuario_pais")="ESPAÑA" and session("usuario_tipo")="GLS PROPIA" then
						'response.write("<br>3 - mandamos mail 3")
						mail_autorizacion_pedido(numero_pedido)
					end if
				else
					'UVE tampoco manda mail
					if session("usuario_codigo_empresa")<>150 then
						'response.write("<br>.....estado: " & estado_consulta_general)
						'response.write("<br>4 - mandamos mail 4 DEL PEDIDO: " & numero_pedido)
						mail_autorizacion_pedido(numero_pedido)
					end if
				end if
			  else
			  	connimprenta.CommitTrans ' finaliza la transaccion
			END IF	
			'connimprenta.CommitTrans ' finaliza la transaccion
				
				
			'response.write("<br>....TERMINAMOS EL ALTA")
						
			mensaje_aviso="El Pedido <b>" & numero_pedido & "</b> Ha sido Creado con Exito..."			
			
			'no se avisa porque se pasa normal sin necesidad de autorizacion de la central de asm
			'if session("usuario_derecho_primer_pedido")="SI" then
			'	mensaje_aviso= mensaje_aviso & "<br><br><h3 align=center><font color=#880000>Como es un Pedido con Descuento, primero será validado por su central</font></h3>"
			'end if

			'ya tiene un pedido por lo menos, cambiamos la variable de sesion
			session("usuario_primer_pedido")="NO"
			session("usuario_derecho_primer_pedido")="NO"


			'si se crea el pedido todo de material de gls, saca un mensaje especial
			if hay_de_gls="SI" then
				mensaje_aviso="Su reserva de material GLS se ha tramitado correctamente a los precios de descuento. Le informaremos en el momento oportuno para proceder a realizar el pago."
			end if
		end if
		
	'para elimiar las variables de sesion
	Session("numero_articulos")=0
	
	set fso=Nothing
	set up = nothing
  ELSE
  	'aqui gestionamos los errores de merzclar productos
	if error_mezcla="SI" then
		mensaje_aviso="Los pedidos de reserva de material GLS no pueden incluir material de marca ASM."			
	end if
	if error_mezcla_merchan_personalizable="SI" then
		mensaje_aviso="No se pueden mezclar en el mismo pedido articulos de Merchandising Personalizable con el resto de articulos."			
	end if
	if error_mezcla_merchan_no_personalizable="SI" then
		mensaje_aviso="No se pueden mezclar en el mismo pedido articulos de Merchandising No Personalizable con el resto de articulos."			
	end if
	if error_mezcla_maletas="SI" then
		mensaje_aviso="No se pueden mezclar en el mismo pedido articulos de Maletas Globalbag con el resto de articulos."			
	end if
 	if error_mezcla_higienicos="SI" then
		mensaje_aviso="No se pueden mezclar en el mismo pedido articulos de Higiene y Seguridad con el resto de articulos."			
	end if
 	if error_mezcla_gls_navidad="SI" then
		mensaje_aviso="No se pueden mezclar en el mismo pedido articulos de Navidad con el resto de articulos."			
	end if
	if error_mezcla_papeleria_propia="SI" then
		mensaje_aviso="No se pueden mezclar en el mismo pedido articulos de Papeleria Propia con el resto de articulos."			
	end if
	
	
 END IF 'de error_mezcla
%>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<TITLE>Grabar Pedido</TITLE>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="../estilos.css" />
	<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />


<script language="javascript">
function validar(mensaje)
{
	//alert(mensaje);
	if ('<%=forma_de_pago%>'=='REDSYS')
		{
		$("#ocultoaviso").val("NO")
		$("#cabecera_pantalla_avisos").html("Pago con Tarjeta del pedido <%=pedido_pago%>")
		cuerpo = '<form action="../redsys/Pasarela.asp" method="POST" name="frmpago" id="frmpago" target="iframe_tarjeta">'
		cuerpo+= '<input type="hidden" id="ocultoimporte" name="ocultoimporte" value="<%=total_importe%>" />'
		cuerpo+= '<input type="hidden" id="ocultopedido" name="ocultopedido" value="<%=pedido_pago%>" />'
		cuerpo+= '<input type="hidden" id="ocultocliente_sap" name="ocultocliente_sap" value="<%=session("usuario_idsap")%>" />'
		cuerpo+= '<input type="hidden" id="ocultocliente" name="ocultocliente" value="<%=session("usuario")%>" />'
		cuerpo+= '</form>'
		
		
		
		
		cuerpo+= '<iframe id="iframe_tarjeta" name="iframe_tarjeta" src="#" width="99%" height="550px" frameborder="0" transparency="transparency"></iframe>' 
		
		//console.log('********************************')
		//console.log('LLAMADA A LA PASARELA DE PAGO')
		//console.log('********************************')
		//console.log(cuerpo)
		//console.log('********************************')
		$("#body_avisos").html(cuerpo);
		$("#frmpago").submit()
		
		}
	  else
		{
		$("#cabecera_pantalla_avisos").html("Avisos")
		$("#body_avisos").html("<br><br><h4>" + mensaje + "</h4><br><br>");
		}			
		
	$("#pantalla_avisos").modal("show");
				
	

}

</script>
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<script type="text/javascript" src="../plugins/bootbox-4.4.0/bootbox.min.js"></script>
</HEAD>
   
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
  <div class="modal fade" id="pantalla_avisos" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer" id="botones_avisos">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal" id="cmdcerrar">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
	<input type="hidden" id="ocultoaviso" name="ocultoaviso" value="NO" />
  </div>    
  <!-- FIN capa mensajes -->

<form action="Rellenar_Variables_Sesion_Gag.asp?emp=<%=empleado_gls%>" method="post" name="frmmodificar_pedido" id="frmmodificar_pedido">
	<input type="hidden" id="ocultopedido_a_modificar" name="ocultopedido_a_modificar" value="" />
</form>



<script language="javascript">
function modificar_pedido(numero_pedido)
{
	document.getElementById("ocultopedido_a_modificar").value=numero_pedido
	document.getElementById("frmmodificar_pedido").submit()
	
}	


$('#pantalla_avisos').on('hide.bs.modal', function(e){
  /*
  if ('<%=forma_de_pago%>'=='PICARD')
  	{
     e.preventDefault();
     e.stopImmediatePropagation();
     //return false; 
	 bootbox.alert({
				size: 'large',
				message: 'Podrá Realizar el pago con tarjeta de este Pedido accediendo de nuevo a él desde la sección "Consultar Pedidos".',
				callback: function () {$("#pantalla_avisos").modal("hide");}
			})
   	}
*/
});

$('#pantalla_avisos').on('hidden.bs.modal', function (e) {
//console.log('error_mezcla: <%=error_mezcla%>')
//console.log('accion: <%=accion%>')

<%if error_mezcla="SI" and accion="MODIFICAR" then%>
  		//location.href = 'Carrito_Gag.asp'
		//location.href = 'Lista_Articulos_Gag.asp'
		modificar_pedido(<%=pedido_modificar%>)
	 <%else%>
	 	<%if empleado_gls="SI" then%>
		 	location.href = 'Lista_Articulos_Gag_Empleados_GLS.asp'
		<%else%>
			location.href = 'Lista_Articulos_Gag.asp'
		<%end if%>
 <%end if%>
 
})


$("#cmdcerrar").on("click", function () {
	//console.log('valor del oculto mensaje: ' + $("#ocultoaviso").val())
	if ('<%=forma_de_pago%>'=='REDSYS')
  	{
		//para que solo salga cuando pulsamos cerrar con el formulario de la tarjeta visible
		if ($("#ocultoaviso").val()=="NO")
			{
		     alert('Podrá Realizar el pago con tarjeta de este Pedido accediendo de nuevo a él desde la sección "Consultar Pedidos".')
			}
	 
   	}	
});

</script>
</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
