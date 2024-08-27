<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->
<script language="javascript" runat="server" src="json2_a.asp"></script>

<script language="JScript" runat="server">
function CheckProperty(obj, propName) {
    return (typeof obj[propName] != "undefined");
}
</script>

<%
		empleado_gls="" & Request.Querystring("emp")

		if session("usuario")="" then
			if empleado_gls="SI" then
				Response.Redirect("../Login_GLS_Empleados.asp")
			  else
			  	Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
			end if
		end if

		impresora_gls="NO"
		
		ver_cadena="" & Request.QueryString("p_vercadena")
		
		
		
		'recordsets
		dim articulos
		
		
		'variables
		dim sql
		
		destinatario=session("usuario_empresa") & " - " & session("usuario_nombre")
		telefono_destinatario=session("usuario_telefono")
		direccion_destinatario=session("usuario_direccion")
		poblacion_destinatario=session("usuario_poblacion")
		cp_destinatario=session("usuario_cp")
		provincia_destinatario=session("usuario_provincia")
		pais_destinatario=session("usuario_pais")
		
		pedido_modificar=""
		control_gastos_envio=""
		
		'vareable para acumular los pesos de ciertos articulos de groundforce que tienen gastos de envio
		peso_articulos_groundforce=0
		
		kits_articulos_personalizados=Request.Querystring("ocultopersonalizados")
		
	    
	    set articulos=Server.CreateObject("ADODB.Recordset")
		'si entra para modificar un pedido existente
		accion=Request.Form("ocultoaccion")
		'response.write("<br>valor de accion recogido de ocultoaccion: " & accion)
		if accion="" then
			'aqui viene la accion junto con el pedido "MODIFICAR--88"
			acciones=Request.QueryString("acciones")
			if acciones<>"" then
				tabla_acciones=Split(acciones,"--")
				accion=tabla_acciones(0)
				pedido_modificar=tabla_acciones(1)
				fecha_pedido=tabla_acciones(2)
				'response.write("<br>valor de accion recogido de querystring acciones: ' & acciones")
		
			end if
		end if
		
		tipo_pedido=""
		if Request.Form("ocultopedido_modificar")<>"" then
			pedido_modificar=Request.Form("ocultopedido_modificar")
		end if
		if Request.Form("ocultofecha_pedido")<>"" then
			fecha_pedido=Request.Form("ocultofecha_pedido")
		end if
		
		cadena_acciones=accion & "--" & pedido_modificar & "--" & fecha_pedido
		
		cadena_json_maletas=""

		'para controlar si es una modificacion de un primer pedido de asm y hacer el descuento
		if pedido_modificar<>"" then
			set tipos_pedido=Server.CreateObject("ADODB.Recordset")
			with tipos_pedido
				.ActiveConnection=connimprenta
				.Source="SELECT PEDIDO_AUTOMATICO, DESTINATARIO, DESTINATARIO_TELEFONO, DESTINATARIO_DIRECCION,"
				.Source=.Source & " DESTINATARIO_POBLACION, DESTINATARIO_CP, DESTINATARIO_PROVINCIA, DESTINATARIO_PAIS, DESTINATARIO_PERSONA_CONTACTO,"
				.Source=.Source & " DESTINATARIO_COMENTARIOS_ENTREGA, NUMERO_EMPLEADO, CLIENTE_ORIGINAL, HORARIO_ENTREGA, GASTOS_ENVIO, DONDE_ENVIO,"
				.Source=.Source & " CODCLI, ESTADO"
				.Source=.Source & " FROM PEDIDOS"
				.Source= .Source & " WHERE ID=" & pedido_modificar
				if ver_cadena="SI" then
					response.write("<br>CONSULTA PEDIDO: " & .source)
				end if
				.OPEN
			end with
	
			if not tipos_pedido.eof then
				tipo_pedido= "" & tipos_pedido("PEDIDO_AUTOMATICO")
				
				if tipos_pedido("DESTINATARIO")<>"" then
					destinatario=tipos_pedido("DESTINATARIO")
				end if
				if tipos_pedido("DESTINATARIO_TELEFONO")<>"" then
					telefono_destinatario=tipos_pedido("DESTINATARIO_TELEFONO")
				end if
				if tipos_pedido("DESTINATARIO_DIRECCION")<>"" then
					direccion_destinatario=tipos_pedido("DESTINATARIO_DIRECCION")
					'para las maletas globalbag
					domicilio_envio=tipos_pedido("DESTINATARIO_DIRECCION")
				end if
				if tipos_pedido("DESTINATARIO_POBLACION")<>"" then
					poblacion_destinatario=tipos_pedido("DESTINATARIO_POBLACION")
					poblacion_envio=tipos_pedido("DESTINATARIO_POBLACION")
				end if
				if tipos_pedido("DESTINATARIO_CP")<>"" then
					cp_destinatario=tipos_pedido("DESTINATARIO_CP")
					cp_envio=tipos_pedido("DESTINATARIO_CP")
				end if
				if tipos_pedido("DESTINATARIO_PROVINCIA")<>"" then
					provincia_destinatario=tipos_pedido("DESTINATARIO_PROVINCIA")
					provincia_envio=tipos_pedido("DESTINATARIO_PROVINCIA")
				end if
				if tipos_pedido("DESTINATARIO_PAIS")<>"" then
					pais_destinatario=tipos_pedido("DESTINATARIO_PAIS")
				end if
				if tipos_pedido("DESTINATARIO_PERSONA_CONTACTO")<>"" then
					persona_contacto_destinatario=tipos_pedido("DESTINATARIO_PERSONA_CONTACTO")
				end if
				if tipos_pedido("DESTINATARIO_COMENTARIOS_ENTREGA")<>"" then
					comentarios_entrega_destinatario=tipos_pedido("DESTINATARIO_COMENTARIOS_ENTREGA")
				end if
				
				if tipos_pedido("GASTOS_ENVIO")<>"" then
					control_gastos_envio="" & tipos_pedido("GASTOS_ENVIO")
				end if
				
				estado_pedido = "" & tipos_pedido("ESTADO")
				
				
				'RECOJO LOS VALORES PARA EL JSON DE LAS MALETAS GLOBALBAG
				if tipos_pedido("CODCLI")<>"" then
					cliente_globalbag=tipos_pedido("CODCLI")
				end if
				if tipos_pedido("CLIENTE_ORIGINAL")<>"" then
					cliente_original_globalbag=tipos_pedido("CLIENTE_ORIGINAL")
					nombre_oficina_globalbag=session("usuario_nombre")
					direccion_oficina_globalbag=session("usuario_direccion")
					poblacion_oficina_globalbag=session("usuario_poblacion")
					cp_oficina_globalbag=session("usuario_cp")
					provincia_oficina_globalbag=session("usuario_provincia")
					pais_oficina_globalbag=session("usuario_pais")
					numero_empleado_globalbag=tipos_pedido("NUMERO_EMPLEADO")
					horario_entrega_globalbag=tipos_pedido("HORARIO_ENTREGA")

					donde_envio_globalbag=tipos_pedido("DONDE_ENVIO")
					
					set obtener_cliente=Server.CreateObject("ADODB.Recordset")
					with obtener_cliente
						.ActiveConnection=connimprenta
						.Source="SELECT NIF_FACTURAR, NOMBRE_FISCAL_FACTURAR, TELEFONO, EMAIL,"
						.Source=.Source & " DIRECCION_FACTURAR, CIUDAD_FACTURAR, PROVINCIA_FACTURAR, CP_FACTURAR, PAIS, IDPAIS"
						.Source=.Source & " FROM V_CLIENTES"
						.Source= .Source & " WHERE ID=" & cliente_globalbag
						if ver_cadena="SI" then
							response.write("<br>CONSULTA CLIENTE: " & .source)
						end if
						.OPEN
					end with
					
					if not obtener_cliente.eof then
						nif_cliente_globalbag=obtener_cliente("NIF_FACTURAR")
						razon_social_cliente_globalbag=obtener_cliente("NOMBRE_FISCAL_FACTURAR")
						telefono_cliente_globalbag=obtener_cliente("TELEFONO")
						email_cliente_globalbag=obtener_cliente("EMAIL")
						domicilio_cliente_globalbag=obtener_cliente("DIRECCION_FACTURAR")
						poblacion_cliente_globalbag=obtener_cliente("CIUDAD_FACTURAR")
						cp_cliente_globalbag=obtener_cliente("CP_FACTURAR")
						provincia_cliente_globalbag=obtener_cliente("PROVINCIA_FACTURAR")
						pais_cliente_globalbag=obtener_cliente("PAIS")
						idpais_cliente_globalbag=obtener_cliente("IDPAIS")
					end if					
					obtener_cliente.close
					set obtener_cliente=nothing
					
					
				end if
			end if
			
			tipos_pedido.close
			set tipos_pedido=Nothing
		end if
					
		'response.write("<br>tipo pedido: " & tipo_pedido)	
		'response.write("<br>destinatario: " & destinatario)	
		'response.write("<br>telefono_destinatario: " & telefono_destinatario)	
		'response.write("<br>direccion_destinatario: " & direccion_destinatario)	
		'response.write("<br>poblacion_destinatario: " & poblacion_destinatario)	
		'response.write("<br>cp_destinatario: " & cp_destinatario)	
		'response.write("<br>provincia_destinatario: " & provincia_destinatario)	
		'response.write("<br>pais_destinatario: " & pais_destinatario)	
		'response.write("<br>cliente_globalbag: " & cliente_globalbag)	
		'response.write("<br>cliente_original_globalbag: " & cliente_original_globalbag)	
		'response.write("<br>nombre_oficina_globalbag: " & nombre_oficina_globalbag)	
		'response.write("<br>direccion_oficina_globalbag: " & direccion_oficina_globalbag)	
		'response.write("<br>poblacion_oficina_globalbag: " & poblacion_oficina_globalbag)	
		'response.write("<br>cp_oficina_globalbag: " & cp_oficina_globalbag)	
		'response.write("<br>provincia_oficina_globalbag: " & provincia_oficina_globalbag)	
		'response.write("<br>pais_oficina_globalbag: " & pais_oficina_globalbag)	
		'response.write("<br>numero_empleado_globalbag: " & numero_empleado_globalbag)	
		'response.write("<br>horario_entrega_globalbag: " & horario_entrega_globalbag)	
		'response.write("<br>donde_envio_globalbag: " & donde_envio_globalbag)	
		'response.write("<br>nif_cliente_globalbag: " & nif_cliente_globalbag)	
		'response.write("<br>razon_social_cliente_globalbag: " & razon_social_cliente_globalbag)	
		'response.write("<br>telefono_cliente_globalbag: " & telefono_cliente_globalbag)	
		
		'response.write("<br>email_cliente_globalbag: " & email_cliente_globalbag)	
		'response.write("<br>domicilio_cliente_globalbag: " & domicilio_cliente_globalbag)	
		'response.write("<br>poblacion_cliente_globalbag: " & poblacion_cliente_globalbag)	
		'response.write("<br>cp_cliente_globalbag: " & cp_cliente_globalbag)	
		'response.write("<br>provincia_cliente_globalbag: " & telefono_cliente_globalbag)	
		'response.write("<br>pais_cliente_globalbag: " & pais_cliente_globalbag)	
		'response.write("<br>domicilio_envio: " & domicilio_envio)	
		'response.write("<br>poblacion_envio: " & poblacion_envio)	
		'response.write("<br>cp_envio: " & cp_envio)	
		'response.write("<br>provincia_envio: " & provincia_envio)	
		
		
		
		
		
		
		
		
		
		
		
		
		
		

'valores para el json con los datos de la plantilla globalbag:
' [{"name":"oculto_id","value":"4252"},{"name":"oculto_empresa","value":"160"},{"name":"oculto_id_oficina","value":"6214"},
'{"name":"oculto_nombre_oficina","value":"001-SALAMANCA - CANALEJAS"},{"name":"oculto_direccion_oficina","value":"PASEO DE CANALEJAS, 14-16"},
'{"name":"oculto_poblacion_oficina","value":"SALAMANCA"},{"name":"oculto_cp_oficina","value":"37001"},{"name":"oculto_provincia_oficina","value":"SALAMANCA"},
'{"name":"oculto_pais_oficina","value":"ESPA�A"},{"name":"txtnumero_empleado_d","value":"1234"},{"name":"txthorario_entrega_d","value":"45677"},
'{"name":"txtnombre_oficina_d","value":"001-SALAMANCA - CANALEJAS"},{"name":"txtdireccion_oficina_d","value":"PASEO DE CANALEJAS, 14-16"},
'{"name":"txtpoblacion_oficina_d","value":"SALAMANCA"},{"name":"txtcp_oficina_d","value":"37001"},{"name":"txtprovincia_oficina_d","value":"SALAMANCA"},
'{"name":"txtpais_oficina_d","value":"ESPA�A"},{"name":"txtnif_d","value":"B37234184"},{"name":"txtrazon_social_d","value":"EL SECRETARIO, S.L."},{"name":"radio","value":"CLIENTE"},
'{"name":"txttelefono_d","value":"923 280 646"},{"name":"txtemail_d","value":""},{"name":"txtdomicilio_d","value":"NORBERTO CUESTA DUTARI, 5"},
'{"name":"txtpoblacion_d","value":"SALAMANCA"},{"name":"txtcp_d","value":"37007"},{"name":"txtprovincia_d","value":"SALAMANCA"},{"name":"txtpais_d","value":"ESPA�A"},
'{"name":"txtdomicilio_envio_d","value":""},{"name":"txtpoblacion_envio_d","value":""},{"name":"txtcp_envio_d","value":""},{"name":"txtprovincia_envio_d","value":""}]

if tipo_pedido="GLOBALBAG" then
	cadena_json_maletas = "[{""name"":""oculto_id"",""value"":""" & cliente_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""oculto_empresa"",""value"":""200""}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""oculto_id_oficina"",""value"":""" & cliente_original_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""oculto_nombre_oficina"",""value"":""" & nombre_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""oculto_direccion_oficina"",""value"":""" & direccion_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""oculto_poblacion_oficina"",""value"":""" & poblacion_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""oculto_cp_oficina"",""value"":""" & cp_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""oculto_provincia_oficina"",""value"":""" & provincia_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""oculto_pais_oficina"",""value"":""" & pais_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtnumero_empleado_d"",""value"":""" & numero_empleado_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txthorario_entrega_d"",""value"":""" & horario_entrega_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtnombre_oficina_d"",""value"":""" & nombre_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtdireccion_oficina_d"",""value"":"""  & direccion_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtpoblacion_oficina_d"",""value"":""" & poblacion_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtcp_oficina_d"",""value"":""" & cp_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtprovincia_oficina_d"",""value"":""" & provincia_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtpais_oficina_d"",""value"":""" & pais_oficina_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtnif_d"",""value"":""" & nif_cliente_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtrazon_social_d"",""value"":""" & razon_social_cliente_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""radio"",""value"":""" & donde_envio_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txttelefono_d"",""value"":""" & telefono_cliente_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtemail_d"",""value"":""" & email_cliente_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtdomicilio_d"",""value"":""" & domicilio_cliente_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtpoblacion_d"",""value"":""" & poblacion_cliente_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtcp_d"",""value"":""" & cp_cliente_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtprovincia_d"",""value"":""" & provincia_cliente_globalbag & """}"
	'cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtpais_d"",""value"":""" & pais_cliente_globalbag & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""cmbpaises_d"",""value"":""" & idpais_cliente_globalbag & """}"
	
	if donde_envio_globalbag<>"CLIENTE" then

	end if
	
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtdomicilio_envio_d"",""value"":"""  & domicilio_envio & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtpoblacion_envio_d"",""value"":""" & poblacion_envio & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtcp_envio_d"",""value"":""" & cp_envio & """}"
	cadena_json_maletas = cadena_json_maletas & ",{""name"":""txtprovincia_envio_d"",""value"":""" & provincia_envio & """}"
	cadena_json_maletas = cadena_json_maletas & "]"


end if 'final tipo pedido globalbag

'response.write("<br>cadena json maletas desde carrito gag, ANTES DE STRINGIFY: " & cadena_json_maletas)
'cadena_json_maletas = JSON.stringify(cadena_json_maletas)
'response.write("<br>cadena json maletas desde carrito gag, DEPSUES DE STRINGIFI: " & cadena_json_maletas)

'cadena_json_maletas=replace(cadena_json_maletas, """","""""")
'response.write("<br>cadena json maletas desde carrito gag, DEPSUES DE poner 2 comillas: " & cadena_json_maletas)




'Recogemos la variable borrar 
borrar=Request.Querystring("borrar")
'RESPONSE.WRITE("<BR>HAY QUE QUITAR EL ARTICULO CON CODIGO: " & BORRAR)

If borrar<>"" Then 'Si se ha pedido el borrado de un articulo
	i=1
	Do While borrar<>Session(i)
		'RESPONSE.WRITE("<BR>SESSION(" & i & "): " & session(i))
		i=i+1
	Loop
	'response.write("<br>y ahora tenemos que mover unos articulos sobre otros... Hay " & Session("numero_articulos") & " articulos en el pedido")
	
	'vacio la variable de sesion con los datos json que pueda contener el articulo personalizado
	'response.write("<br>borramos los datos json de " & session(i) & ": " & Session("json_" & Session(i)))
	Session("json_" & Session(i))=""
	For j=i to Session("numero_articulos")
		'RESPONSE.WRITE("<BR>SESSION(" & j & "): " & session(j) & " contendr� a SESSSION(" & j+1 & "): " & session(j+1))
		Session(j)=Session(j+1)
		'RESPONSE.WRITE("<BR>SESSION(" & j & "_cantidades_precios): " & session(j & "_cantidades_precios") & " contendr� a SESSSION(" & j+1 & "_cantidades_precios): " & session(j+1 & "_cantidades_precios"))
		Session(j & "_cantidades_precios")=Session((j+1) & "_cantidades_precios")
		Session(j & "_fichero_asociado")=Session((j+1) & "_fichero_asociado")
		
	Next
	Session("numero_articulos")=Session("numero_articulos")-1
		
	'response.write("<br>y al final quedan " & Session("numero_articulos") & " articulos en el pedido")
	'response.write("<br><br>ahora vemos como ha quedado despues de borrar")
	'For j=1 to Session("numero_articulos")
		'RESPONSE.WRITE("<BR>SESSION(" & j & "): " & session(j)) 
		'RESPONSE.WRITE("<BR>SESSION(" & j & "_cantidades_precios): " & session(j & "_cantidades_precios"))
	'Next
		
	
	
End if

'Si no quedan articulos en el carrito despues del borrado
cadena="Lista_Articulos_Gag.asp"
If Session("numero_articulos")= 0 Then
	'history.back()
	'Response.Redirect("bottom.asp")
end if


iva_21=0



	dinero_disponible_devoluciones=0	
	set disponible_devoluciones=Server.CreateObject("ADODB.Recordset")
		
		with disponible_devoluciones
			.ActiveConnection=connimprenta
			.Source="select ROUND((ISNULL(SUM(TOTAL_ACEPTADO),0) - ISNULL(SUM(TOTAL_DISFRUTADO),0)),2) as DISPONIBLE"
			.Source= .Source & " FROM DEVOLUCIONES"
			.Source= .Source & " WHERE CODCLI = " & session("usuario") 
			if empleado_gls="SI" then
				.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO=" & session("usuario_directorio_activo")
			  else
				.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO IS NULL" 
			end if
			.Source= .Source & " AND ESTADO='CERRADA'"
			if ver_cadena="SI" then
				response.write("<br>DISPONIBLE_DEVOLUCIONES: " & .source)
			end if
			.Open
		end with

		if not disponible_devoluciones.eof then
			dinero_disponible_devoluciones=disponible_devoluciones("DISPONIBLE")	
		end if
		disponible_devoluciones.close
		set disponible_devoluciones=Nothing


	set devoluciones=Server.CreateObject("ADODB.Recordset")	
		CAMPO_ID_DEVOLUCION=0
		CAMPO_TOTAL_ACEPTADO=1
		CAMPO_TOTAL_DISFRUTADO=2
		CAMPO_TOTAL_DISPONIBLE=3
		with devoluciones
			.ActiveConnection=connimprenta
			
			'si es una devolucion se pueden reutilizar las devoluciones ya asignadas al pedido
			if pedido_modificar<>"" then
				.Source="SELECT A.ID, ISNULL(A.TOTAL_ACEPTADO,0) AS TOTAL_ACEPTADO, ISNULL(A.TOTAL_DISFRUTADO,0) AS TOTAL_DISFRUTADO"
				.Source= .Source & ", ROUND((ISNULL(A.TOTAL_ACEPTADO,0) - ISNULL(A.TOTAL_DISFRUTADO,0) + ISNULL(B.IMPORTE,0)),2) as TOTAL"
				.Source= .Source & " FROM DEVOLUCIONES A"
				.Source= .Source & " LEFT JOIN"
				.Source= .Source & " (SELECT * FROM DEVOLUCIONES_PEDIDOS WHERE ID_PEDIDO=" & pedido_modificar & ") B"
				.Source= .Source & " ON A.ID=B.ID_DEVOLUCION"
				.Source= .Source & " WHERE A.CODCLI = " & session("usuario") 
				if empleado_gls="SI" then
					.Source= .Source & " AND A.USUARIO_DIRECTORIO_ACTIVO=" & session("usuario_directorio_activo")
				  else
					.Source= .Source & " AND A.USUARIO_DIRECTORIO_ACTIVO IS NULL" 
				end if
				.Source= .Source & " AND A.ESTADO='CERRADA'"
			  else
			  	.Source="SELECT ID, ISNULL(TOTAL_ACEPTADO,0) AS TOTAL_ACEPTADO, ISNULL(TOTAL_DISFRUTADO,0) AS TOTAL_DISFRUTADO"
				.Source= .Source & ", ROUND((ISNULL(TOTAL_ACEPTADO,0) - ISNULL(TOTAL_DISFRUTADO,0)),2) as TOTAL"
				.Source= .Source & " FROM DEVOLUCIONES"
				.Source= .Source & " WHERE CODCLI = " & session("usuario") 
				if empleado_gls="SI" then
					.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO=" & session("usuario_directorio_activo")
				  else
					.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO IS NULL" 
				end if
				.Source= .Source & " AND ESTADO='CERRADA'"
			 end if
			if ver_cadena="SI" then
				response.write("<br>devoluciones: " & .source)
			end if
			.Open
			vacio_devoluciones=false
			if not .BOF then
				tabla_devoluciones=.GetRows()
			  else
				vacio_devoluciones=true
			end if
		end with

		devoluciones.close
		set devoluciones=Nothing


set devoluciones_del_pedido=Server.CreateObject("ADODB.Recordset")
pedido_tiene_devoluciones= "NO"
if pedido_modificar<>"" then
	with devoluciones_del_pedido
		.ActiveConnection=connimprenta
		.Source="SELECT ID, ID_PEDIDO, ID_DEVOLUCION, IMPORTE FROM DEVOLUCIONES_PEDIDOS WHERE ID_PEDIDO=" & pedido_modificar
		if ver_cadena="SI" then
			RESPONSE.WRITE("<br>DEVOLUCIONES DEL PEDIDO: " & .SOURCE)
		end if
		.Open
		if not .BOF then
			pedido_tiene_devoluciones= "SI"
		end if
		
		devoluciones_del_pedido.close
	end with
end if

set devoluciones_del_pedido=Nothing


		set saldos=Server.CreateObject("ADODB.Recordset")
		vacio_saldos=true
		CAMPO_ID_SALDO=0
		CAMPO_TOTAL_SALDO=1
		CAMPO_TOTAL_SALDO_DISFRUTADO=2
		CAMPO_TOTAL_SALDO_DISPONIBLE=3
		CAMPO_CARGO_ABONO=4
		with saldos
			.ActiveConnection=connimprenta
			'si es un saldo se pueden reutilizar los saldos ya asignados al pedido
			if pedido_modificar<>"" then
				.Source="SELECT A.ID, ISNULL(A.IMPORTE,0) AS TOTAL_SALDO, ISNULL(A.TOTAL_DISFRUTADO,0) AS TOTAL_DISFRUTADO"
				.Source= .Source & ", ROUND((ISNULL(A.IMPORTE,0) - ISNULL(A.TOTAL_DISFRUTADO,0) + ISNULL(B.IMPORTE,0)),2) as TOTAL_DISPONIBLE"
				.Source= .Source & ", A.CARGO_ABONO"
				'para ordenarlo y que al mostrar el pedido, gaste primero los saldos ya asignados previamete a el
				.Source= .Source & ", CASE WHEN B.IMPORTE IS NULL THEN 2 ELSE 1 END AS ORDEN"
				.Source= .Source & " FROM SALDOS A"
				.Source= .Source & " LEFT JOIN"
				.Source= .Source & " (SELECT * FROM SALDOS_PEDIDOS WHERE ID_PEDIDO=" & pedido_modificar & ") B"
				.Source= .Source & " ON A.ID=B.ID_SALDO"
				.Source= .Source & " WHERE A.CODCLI = " & session("usuario") 
				'para que no tenga en cuenta saldos si es un empleado
				' los saldos son de oficina no de empleado
				if empleado_gls="SI" then
					.Source= .Source & " AND 1=0" 
				end if
				.Source= .Source & " AND ROUND((ISNULL(A.IMPORTE,0) - ISNULL(A.TOTAL_DISFRUTADO,0) + ISNULL(B.IMPORTE,0)),2)<>0"
				.Source= .Source & " ORDER BY A.CARGO_ABONO DESC, ORDEN, A.ID"
				
			  else
			  	.Source="SELECT ID, ISNULL(IMPORTE,0) AS TOTAL_SALDO, ISNULL(TOTAL_DISFRUTADO,0) AS TOTAL_DISFRUTADO"
				.Source= .Source & ", ROUND((ISNULL(IMPORTE,0) - ISNULL(TOTAL_DISFRUTADO,0)),2) as TOTAL_DISPONIBLE"
				.Source= .Source & ", CARGO_ABONO" 
				.Source= .Source & " FROM SALDOS"
				.Source= .Source & " WHERE CODCLI = " & session("usuario")
				'para que no tenga en cuenta saldos si es un empleado
				' los saldos son de oficina no de empleado
				if empleado_gls="SI" then
					.Source= .Source & " AND 1=0" 
				end if
				.Source= .Source & " AND ROUND((ISNULL(IMPORTE,0) - ISNULL(TOTAL_DISFRUTADO,0)),2)<>0"
				.Source= .Source & " ORDER BY CARGO_ABONO DESC, ID"
			end if

			if ver_cadena="SI" then
				response.write("<br>saldos: " & .source)
			end if
			.Open
			
			if not .BOF then
				tabla_saldos=.GetRows()
				vacio_saldos=false
			end if
		end with

		saldos.close
		set saldos=Nothing
		
		
		if empleado_gls<>"SI" then
			dinero_disponible_saldos=0	
			set disponible_saldos=Server.CreateObject("ADODB.Recordset")
			CAMPO_DISPONIBLE_SALDOS=0
			with disponible_saldos
				.ActiveConnection=connimprenta
				.Source="SELECT ROUND(SUM(CASE WHEN CARGO_ABONO='CARGO' THEN (ISNULL(IMPORTE,0) - ISNULL(TOTAL_DISFRUTADO,0)) * (-1)"
				.Source= .Source & " ELSE (ISNULL(IMPORTE,0) - ISNULL(TOTAL_DISFRUTADO,0))"
				.Source= .Source & " END), 2) AS DISPONIBLE"
				.Source= .Source & " FROM SALDOS"
				.Source= .Source & " WHERE CODCLI = " & session("usuario") 
				if ver_cadena="SI" then
					response.write("<br>SALDOS: " & .source)
				end if
				.Open
			end with
		
			if not disponible_saldos.eof then
				dinero_disponible_saldos=disponible_saldos("DISPONIBLE")	
			end if
			disponible_saldos.close
			set disponible_saldos=Nothing
		end if
		
%>
<html>
<head>
<title><%=carrito_gag_title%></title>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />
<link rel="stylesheet" type="text/css" href="../plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min.css">

<script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-touchspin-master/src/jquery.bootstrap-touchspin.css" />

<style>
	#capa_maletas .modal-dialog  {width:90%;}

	body {padding-top: 10px; background-color:#fff;}
	html,body{
		margin:0px;
		height:100%;
		}

	
	a.enlace { 
			text-decoration:none;
			font: bold courier }
	a.enlace:link { color:#990000}
	a.enlace:visited { color:#990000}
	a.enlace:actived {color:#990000}
	a.enlace:hover {
			font: bold italic ;color:blue}
			
	a.nosub { 
			text-decoration:none;
			}
	a.nosub:link { color:blue}
	a.nosub:visited { color:blue}
	a.nosub:actived {color:blue}
	a.nosub:hover {
			font: bold italic ;color:#8080c0}
		
</style>

<style>
/*--estilos relacionados con las capas para las plantillas de personalizacion de articulos*/
.botones_agrupacion{
  
  /*background-image:url("images/Boton_Informatica.jpg");*/
  background-repeat:no-repeat;
  background-position:center;
  float:left;
    
  height:100px;
  width:100px;
  float:left;
  
  /*background: url("images/Boton_Informatica.jpg") no-repeat center center fixed; */
  
  -webkit-background-size: cover;
  -moz-background-size: cover;
  -o-background-size: cover;
  background-size: cover;
  
  /*
  filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/Boton_Informatica_.jpg', sizingMethod='scale');
  -ms-filter: "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/Boton_Informatica_.jpg', sizingMethod='scale')";
 */
 }
  
#capa_opaca__ {
	position:absolute;
	color: black;
	background-color: #C0C0C0;
	left: 0px;
	top: 0px;
	width: 100%;
	height: 100%;
	z-index: 1000;
	text-align: center;
	visibility: visible;
	filter:alpha(opacity=40);
	-moz-opacity:.40;
	opacity:.40;
}

.aviso {
	font-family: Verdana, Arial, Helvetica, sans-serif;
  	font-size: 18px;
  	color: #000000;
  	text-align: center;
	background-color:#33FF33
}  	

#contenedorr3 { 


/* Otros estilos */ 
border:1px solid #333;
background:#eee;
padding:15px;
width:940px;

margin: 75px auto;

-moz-border-radius: 20px; /* Firefox */
-webkit-border-radius: 20px; /* Google Chrome y Safari */
border-radius: 20px; /* CSS3 (Opera 10.5, IE 9 y est�ndar a ser soportado por todos los futuros navegadores) */
/*
behavior:url(border-radius.htc);/* IE 8.*/

}




/*******************************
PARA LA IMAGEN DEL ARTICULO EN EL CARRITO
************/


.image_thumb{
			position:relative;
			overflow:hidden;
			padding-bottom:100%;
}
		
.image_thumb img{
	  position: absolute;
	  max-width: 100%;
	  max-height: 100%;
	  top: 50%;
	  left: 50%;
	  
	  transform: translateX(-50%) translateY(-50%);
	  
}


/*****************************************************
PARA ROTAR Y ANIMAR LOS GLYPHICONS
******************************/

.gly-spin {
  -webkit-animation: spin 2s infinite linear;
  -moz-animation: spin 2s infinite linear;
  -o-animation: spin 2s infinite linear;
  animation: spin 2s infinite linear;
}
@-moz-keyframes spin {
  0% {
    -moz-transform: rotate(0deg);
  }
  100% {
    -moz-transform: rotate(359deg);
  }
}
@-webkit-keyframes spin {
  0% {
    -webkit-transform: rotate(0deg);
  }
  100% {
    -webkit-transform: rotate(359deg);
  }
}
@-o-keyframes spin {
  0% {
    -o-transform: rotate(0deg);
  }
  100% {
    -o-transform: rotate(359deg);
  }
}
@keyframes spin {
  0% {
    -webkit-transform: rotate(0deg);
    transform: rotate(0deg);
  }
  100% {
    -webkit-transform: rotate(359deg);
    transform: rotate(359deg);
  }
}
.gly-rotate-90 {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1);
  -webkit-transform: rotate(90deg);
  -moz-transform: rotate(90deg);
  -ms-transform: rotate(90deg);
  -o-transform: rotate(90deg);
  transform: rotate(90deg);
}
.gly-rotate-180 {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=2);
  -webkit-transform: rotate(180deg);
  -moz-transform: rotate(180deg);
  -ms-transform: rotate(180deg);
  -o-transform: rotate(180deg);
  transform: rotate(180deg);
}
.gly-rotate-270 {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
  -webkit-transform: rotate(270deg);
  -moz-transform: rotate(270deg);
  -ms-transform: rotate(270deg);
  -o-transform: rotate(270deg);
  transform: rotate(270deg);
}
.gly-flip-horizontal {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=0, mirror=1);
  -webkit-transform: scale(-1, 1);
  -moz-transform: scale(-1, 1);
  -ms-transform: scale(-1, 1);
  -o-transform: scale(-1, 1);
  transform: scale(-1, 1);
}
.gly-flip-vertical {
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=2, mirror=1);
  -webkit-transform: scale(1, -1);
  -moz-transform: scale(1, -1);
  -ms-transform: scale(1, -1);
  -o-transform: scale(1, -1);
  transform: scale(1, -1);
}

</style>
<style>
      .icono_boton {
        vertical-align: middle;
        font-size: 40px;
      }
      .texto_boton {
        /*font-family: "Courier-new";*/
		font-size: 1.2rem;
      }
      .contenedor_boton {
        border: 1px solid #666;
        border-radius: 6px;
        display: inline-block;
        margin: 40px;
        padding: 10px;
      }
	  
.dinero_disponible {
        font-weight: bold;
        color: white; /* Cambia el color del texto a blanco */
        background-color: tomato; /* Cambia el color de fondo a tomato */
        border-radius: 5px; /* Hace los bordes del fondo redondeados */
        padding: 2px 5px; /* Agrega un poco de espacio alrededor del texto */
		/*font-size: 11px*/
    }
</style>

<script language="javascript">
function cambiacomaapunto (s)
{
	var saux = "";
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ",")
			saux = saux + ".";
		else
			saux = saux + s.charAt (j);
	}
	return saux;
}

// una vez calculado el resultado tenemos que volver a dejarlo como es devido, con la coma
//    representando los decimales y no el punto
function cambiapuntoacoma(s)
{
	var saux = "";
	//alert("pongo coma")
	//alert("tama�o: " + s.legth)
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ".")
			saux = saux + ",";
		else
			saux = saux + s.charAt (j);
		//alert("total: " + saux)
	}
	return saux;
}

// ademas redondeamos a 2 decimales el resultado
function redondear (v){
	var vaux;
	vaux = Math.round (v * 100);
	vaux =  vaux / 100;
	return  vaux;
}


	
/* parece que no se usa
	
   function mover_formulario(objetivo)
   {
   	if (objetivo=='volver')
   		accion='Lista_Articulos_Gag.asp'
	  else
	  	accion='Grabar_Pedido_Gag.asp';
	document.getElementById('frmpedido').action=accion
	document.getElementById('frmpedido').submit()	
	

   }
*/

   	
function validar(pedido_minimo, impresora_gls)
{
	//console.log('...dentro de validar...')
	hay_error='NO'
	cadena_error=''
	//mostrar_boton_ok_gastos_de_envio='NO'
	
	total_pedido_comprobar = document.getElementById('ocultototal_pedido').value
	total_pedido_con_iva_comprobar = document.getElementById('ocultototal_con_iva_pedido').value
	
	//alert('descuento_pedido: ' + document.getElementById('ocultodescuento_pedido').value)
	//alert('<%=session("usuario_tipo")%>')
	//alert('tipo oficina: <%=session("usuario_tipo")%>\ntotal pedido: ' + document.getElementById('ocultototal_pedido').value + '\npedido minimo: ' + pedido_minimo+ '\npedido con iva: ' + document.getElementById('ocultototal_con_iva_pedido').value)
	if (<%=Session("numero_articulos")%>>0)
		{
		
		//comprobamos que los articulos personalizables con plantillas, se han rellenado los datos
		//		antes de grabar el pedido
		var sAux="";
		var frm = document.getElementById("frmpedido");
		for (i=0;i<frm.elements.length;i++)
		{
			
			//--console.log(frm.elements[i].name + ': ' + frm.elements[i].name.indexOf('ocultoarticulo_personalizable_'))
			if (frm.elements[i].name.indexOf('ocultoarticulo_personalizable_')==0)
				{
				codigo_articulo=frm.elements[i].name.substr(30,frm.elements[i].name.length)
				sAux += "CODIGO: " + codigo_articulo + " ";
				sAux += "NOMBRE: " + frm.elements[i].name + " ";
				sAux += "TIPO :  " + frm.elements[i].type + " "; ;
				sAux += "VALOR: " + frm.elements[i].value + "\n" ;
				
				//si es un kit parcelshop, puede venir personalizado o no
				kits_parcelshop= '-3765-3766-3767-3768-3769-3770-3771-3772-3773-3774-3775-3776-3777-3778-3779-3780-3781-3782-3783-3784-3785-3786-3787-3788-'
				if (kits_parcelshop.indexOf('-' + codigo_articulo + '-')>=0)
					{
					if (esVisible('#icono_plantilla_' + codigo_articulo)) 
						{
						if ((document.getElementById('ocultodatos_personalizacion_json_' + codigo_articulo).value=='')&&
							(document.getElementById('ocultoarticulo_personalizable_' + codigo_articulo).value=='SI'))
							{
							hay_error='SI'
							cadena_error+='<%=carrito_gag_error_articulo_personalizable%>'
							}
						}
					}
				  else
					{  
				
					//console.log('lo que se manda con oculto_datos_personalizacion_json: ' + document.getElementById('ocultodatos_personalizacion_json_' + codigo_articulo).value)
					if ((document.getElementById('ocultodatos_personalizacion_json_' + codigo_articulo).value=='')&&
							(document.getElementById('ocultoarticulo_personalizable_' + codigo_articulo).value=='SI'))
						{
						hay_error='SI'
						cadena_error+='<%=carrito_gag_error_articulo_personalizable%>'
						}
					}
				
				}
		}
		//--alert(sAux);
		
		//comprobamos si se supera el pedido minimo
		//console.log('pedido minimo ' + parseFloat(pedido_minimo))
		//console.log('total pedido '  + parseFloat(total_pedido_comprobar))
		if (parseFloat(pedido_minimo)>parseFloat(total_pedido_comprobar))
			{
				hay_error='SI'
				cadena_error+='<%=carrito_gag_error_pedido_minimo%>'
					
				//si no se supera el importe minimo, para la CADENA GENERAL, se puede dejar crear el pedido pero conlleva unos gastos de envio
				// para el resto de los casos, el pedido no se crea si no se supera el pedido minimo
				<%if session("usuario_codigo_empresa")=260 then%>
				  	hay_error='NO'
					cadena_error+=''
				<%end if%>
				<%if session("usuario_codigo_empresa")=30 or session("usuario_codigo_empresa")=40 then%>
					if (parseFloat($("#ocultogastos_envio_pedido").val()) > 0.0)
						{
						//console.log('NO HAY QUE APLICAR GASTOS DE ENVIO')
						hay_error='NO'
						cadena_error+=''
						}
				<%end if%>	
			}

		if ($("input:radio[name=optdireccion_envio]:checked").val()=='NUEVA')
			{
			if ($('#txtdestinatario_d').val()=='')
				{
				hay_error='SI'
				cadena_error+='<br>- Se Ha de Completar El Destinatario en la Direcci�n de Env�o.'
				}

			if ($('#txttelefono_destinatario_d').val()=='')
				{
				hay_error='SI'
				cadena_error+='<br>- Se Ha de Completar El Tel&eacute;fono en la Direcci�n de Env�o.'
				}
			
			if ($('#txtdireccion_destinatario_d').val()=='')
				{
				hay_error='SI'
				cadena_error+='<br>- Se Ha de Completar La Direcci�n en la Direcci�n de Env�o.'
				}

			if ($('#txtpoblacion_destinatario_d').val()=='')
				{
				hay_error='SI'
				cadena_error+='<br>- Se Ha de Completar La Poblaci�n en la Direcci�n de Env�o.'
				}

			if ($('#txtcp_destinatario_d').val()=='')
				{
				hay_error='SI'
				cadena_error+='<br>- Se Ha de Completar El C�digo Postal en la Direcci�n de Env�o.'
				}

			if ($('#txtprovincia_destinatario_d').val()=='')
				{
				hay_error='SI'
				cadena_error+='<br>- Se Ha de Completar La Provincia en la Direcci�n de Env�o.'
				}

			if ($('#txtpais_destinatario_d').val()=='')
				{
				hay_error='SI'
				cadena_error+='<br>- Se Ha de Completar El Pa�s en la Direcci�n de Env�o.'
				}
			if ($('#txtpersona_contacto_destinatario_d').val()=='')
				{
				hay_error='SI'
				cadena_error+='<br>- Se Ha de Indicar La Persona de Contacto.'
				}
			}
			
		if ($("input:radio[name=optdireccion_envio]:checked").val()=='ACTUAL')
			{
			if ($('#txtpersona_contacto_destinatario_d').val()=='')
				{
				hay_error='SI'
				cadena_error+='<br>- Se Ha de Indicar La Persona de Contacto.'
				}
			}
		
		

		//si es halcon o ecuador, tenemos que ver si no se mezclan las maletas con otros
		//articulos en el pedido
		no_maleta='NO'
		si_maleta='NO'
		no_merchan_personalizable='NO'
		si_merchan_personalizable='NO'
		no_merchan_no_personalizable='NO'
		si_merchan_no_personalizable='NO'
		no_higienico='NO'
		si_higienico='NO'
		no_navidad='NO'
		si_navidad='NO'
		no_papeleria_propia='NO'
		si_papeleria_propia='NO'
		no_rotulacion_gls='NO'
		si_rotulacion_gls='NO'
		
		
		
		<%if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 then%>
			
			
			$(".control_familias").each(function(index, element) {
				// element == this
				//227, 228, 264, 300, 316 son las familias de MALETAS GLOBALBAG en PRODUCCION (HALCON, ECUADOR, IMPRENTA, FRANQUICIAS HALCON Y FRANQUICIAS ECUADOR)
				if ($(element).val()=='227' || $(element).val()=='228' || $(element).val()=='264' || $(element).val()=='300' || $(element).val()=='316')
					{
					si_maleta='SI'
					}
				  else
				  	{
					no_maleta='SI'
					}
				
				//222, 224, 298, 314 SON LAS FAMILIAS DE MERCHANDISIN PERSONALIZABLE PARA HALCON, ECUADOR, FRANQUICIAS HACCON Y FERANQUICIAS ECUADOR
				if ($(element).val()=='222' || $(element).val()=='224' || $(element).val()=='298' || $(element).val()=='314')
					{
					si_merchan_personalizable='SI'
					}
				  else
				  	{
					no_merchan_personalizable='SI'
					}
				//223, 225, 299, 315 SON LAS FAMILIAS DE MERCHANDISIN NO PERSONALIZABLE PARA HALCON, ECUADOR, FRANQUICIAS HACCON Y FERANQUICIAS ECUADOR
				if ($(element).val()=='223' || $(element).val()=='225' || $(element).val()=='299' || $(element).val()=='315')
					{
					si_merchan_no_personalizable='SI'
					}
				  else
				  	{
					no_merchan_no_personalizable='SI'
					}
				
					
				//las franquicias si pueden mezclar loar articulos de higiene con el resto	
				<%if session("usuario_tipo")<>"FRANQUICIA" then%>	
					//245, 246, 301, 317 SON LAS FAMILIAR DE HIGIENE Y SEGURIDAD PARA HALCON, ECUADOR, FRANQUICAIS HALCON Y FRANQUICIAS ECUADOR
					if ($(element).val()=='245' || $(element).val()=='246' || $(element).val()=='301' || $(element).val()=='317')
						{
						si_higienico='SI'
						}
					  else
						{
						no_higienico='SI'
						}
				<%end if%>				
			  });
		<%end if%>
		
		
		<%if session("usuario_codigo_empresa")=4 then%>
			$(".control_familias").each(function(index, element) {
				// element == this
				//220 es la familia de GLS PRODUCTOS NAVIDAD
				if ($(element).val()=='220')
					{
					si_navidad='SI'
					}
				  else
				  	{
					no_navidad='SI'
					}
					
			  });
			$(".control_familias").each(function(index, element) {
				// element == this
				/* TODAS LAS FAMILIAS NUEVAS DE ROTULACION INTERIOR Y EXTERIOR DE GLS
				342	- GLS ROTULACI�N BANDEROLAS
				343	- GLS ROTULACI�N CORPOREOS
				344	- GLS ROTULACI�N R�TULOS FACHADA
				345	- GLS ROTULACI�N AGENCIAS
				346	- GLS ROTULACI�N BANDERAS
				347	- GLS ROTULACI�N DESPACHOS
				348	- GLS ROTULACI�N GENERAL
				349	- GLS ROTULACI�N PARKING
				350	- GLS ROTULACI�N PRL
				351	- GLS ROTULACI�N PUERTAS
				352	- GLS ROTULACI�N SE�ALIZACI�N
				353	- GLS ROTULACI�N SERVICIOS
				354	- GLS ROTULACI�N VESTUARIOS
				355	- GLS ROTULACI�N ASEOS/WC
				356	- GLS ROTULACI�N ZONAS COMUNES
				*/
				if ($(element).val()=='342' || $(element).val()=='343' || $(element).val()=='344' || $(element).val()=='345' || $(element).val()=='346' 
					|| $(element).val()=='347' || $(element).val()=='348' || $(element).val()=='349' || $(element).val()=='350' || $(element).val()=='351' 
					|| $(element).val()=='352' || $(element).val()=='353' || $(element).val()=='354' || $(element).val()=='355' || $(element).val()=='356')
					{
					si_rotulacion_gls='SI'
					}
				  else
				  	{
					no_rotulacion_gls='SI'
					}
					
			  });
		<%end if%>
		
		<%'las franquicias de ecuador hasta el 01/10/2021, la papeleria propia se factura a la central, despues de ese dia
			'se factura a cada oficina
		if ((session("usuario_codigo_empresa")=20 OR session("usuario_codigo_empresa")=250) and session("usuario_tipo")="FRANQUICIA") then
		%>
			var fecha_actual = new Date();
			var fecha_limite = new Date(2021, 9, 1);
			//alert('fecha actual: ' + fecha_actual + '  ....  fecha limite: ' + fecha_limite)
			if (fecha_actual.getTime() < fecha_limite.getTime())
				{
				$(".control_familias").each(function(index, element) {
				// element == this
				//136, 313 es la familia de PAPELERIA PROPIA PARA ECUADOR, FRANQUICIAS ECUADOR
				if ($(element).val()=='136' || $(element).val()=='313')
					{
					si_papeleria_propia='SI'
					}
				  else
				  	{
					no_papeleria_propia='SI'
					}
			  });
				}
			
		
		<%end if%>
		if (no_maleta=='SI' && si_maleta=='SI')
			{
			hay_error='SI'
			cadena_error+='<br>- No se pueden mezclar en el mismo pedido articulos de Maletas Globalbag con el resto de articulos.'
			}
		if (no_maleta=='NO' && si_maleta=='SI')
			{
			if ($('#ocultodatos_adicionales_maletas').val()=='')
				{
				hay_error='SI'
				cadena_error+='<br>- Ha de Rellenar la Plantilla con Los Datos Adicionales para Las Maletas Globalbag.'
				}
			  else
			  	{
				//console.log('datos del formulario para las maletas: ' + $('#ocultodatos_adicionales_maletas').val())
				}
			}
		if (no_merchan_personalizable=='SI' && si_merchan_personalizable=='SI')
			{
			hay_error='SI'
			cadena_error+='<br>- No se pueden mezclar en el mismo pedido articulos de Merchandising Personalizable con el resto de articulos.'
			}
		if (no_merchan_no_personalizable=='SI' && si_merchan_no_personalizable=='SI')
			{
			hay_error='SI'
			cadena_error+='<br>- No se pueden mezclar en el mismo pedido articulos de Merchandising No Personalizable con el resto de articulos.'
			}
			
		if (no_papeleria_propia=='SI' && si_papeleria_propia=='SI')
			{
			hay_error='SI'
			cadena_error+='<br>- No se pueden mezclar en el mismo pedido articulos de Papeler�a Propia con el resto de articulos.'
			}
			
		<%if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250) and session("usuario_tipo")<>"FRANQUICIA" then%>		
			if (no_higienico=='SI' && si_higienico=='SI')
				{
				hay_error='SI'
				cadena_error+='<br>- No se pueden mezclar en el mismo pedido articulos de Higiene y Seguridad con el resto de articulos.'
				}
		<%end if%>
		<%if (session("usuario_codigo_empresa")=4) then%>		
			if (no_navidad=='SI' && si_navidad=='SI')
				{
				hay_error='SI'
				cadena_error+='<br>- No se pueden mezclar en el mismo pedido articulos de Navidad con el resto de articulos.'
				}
			if (no_rotulacion_gls=='SI' && si_rotulacion_gls=='SI')
				{
				hay_error='SI'
				cadena_error+='<br>- No se pueden mezclar en el mismo pedido articulos de Rotulaci�n Interior o Exterior con el resto de articulos.'
				}

		<%end if%>
		}
	  else //NO HAY ARTICULOS
		{
			hay_error='SI'
			cadena_error+='<%=carrito_gag_error_carrito_sin_articulos%>'
		}
	
	// si hay impresoras tenemos que verificar si ha marcado el check con las condiciones antes de guardar
	if (impresora_gls =='SI')
		{
		var checkBox_condiciones = document.getElementById("chkcondidiones_impresoras_gls");
		var checkBox_manual = document.getElementById("chkleido_manual_impresoras_gls");
		
		if (checkBox_condiciones.checked != true){
		    // Checkbox est� marcado
			hay_error='SI'
			cadena_error+='<br>- Se han de aceptar las condiciones generales de cesi�n de las impresoras.'
			}
		if (checkBox_manual.checked != true){
		    // Checkbox est� marcado
			hay_error='SI'
			cadena_error+='<br>- Se ha de indicar que se ha leido el manual de gesti�n de las impresoras.'
			}
		}
	
	if (hay_error=='SI')
		{
		//alert('Se Han Detectado Los Siguientes Errores:\n\n' + cadena_error)
		cadena='<br><BR><H3><%=carrito_gag_error_explicacion%></H3><BR><br><H5>' + cadena_error + '</H5>'
		$("#cabecera_pantalla_avisos").html("<%=carrito_gag_pantalla_avisos_cabecera%>")
		$("#body_avisos").html(cadena + "<br>");
		cadena='<p>'
		cadena += '<button type="button" class="btn btn-default" data-dismiss="modal"><%=carrito_gag_pantalla_avisos_boton_cerrar%></button>'
		cadena += '</p><br>'
		$("#botones_avisos").html(cadena);                          
		$("#pantalla_avisos").modal("show");

		}
	  else
	  	{
			annadir_devoluciones_y_saldos()
			//y mandamos a grabar....
			document.getElementById('frmpedido').submit()
		}
		
}



function annadir_devoluciones_y_saldos()
{
//aqui metemos los datos de las devoluciones
			//formato entre devoluciones: @@@devolucion1@@@devolucion2@@@devolucion3
			//formato dentro de cada devolucion: devoucion###importe
			
			datos_todas_devoluciones=''
			$(".oculto_devoluciones").each(function( index ) {
				cadena_devolucion=''
				id_devolucion=$(this).attr('id_devolucion')
				total_aceptado=parseFloat($(this).attr('total_aceptado').replace(',', '.'))
				total_disfrutado=parseFloat($(this).attr('total_disfrutado').replace(',', '.'))
				total_disponible_ant=parseFloat($(this).attr('total_disponible_ant').replace(',', '.'))
				total_pendiente=parseFloat($(this).attr('total_pendiente').replace(',', '.'))
				importe_actual=parseFloat($(this).val().replace(',', '.'))
			  	
				//solo recojo las devoluciones utilizadas...
				if (importe_actual>0) 
					{
					cadena_devolucion=id_devolucion.toString() + '###' + importe_actual.toString().replace('.', ',')
					//console.log('cadena a enviar para la devolucion: ' + cadena_devolucion );
			  		
					datos_todas_devoluciones=datos_todas_devoluciones + '@@@' + cadena_devolucion
					//console.log('cadena acumulada de devoluciones: ' + datos_todas_devoluciones);
					}
			
			});
			
			//console.log('cadena acumulada FINAL de devoluciones: ' + datos_todas_devoluciones);
			
			//si estan marcadas las devoluciones, entonces utilizamos sus datos al grabar el pedido
			if($("#chkaplicar_devoluciones").is(':checked')) 
				{  
				$("#ocultodatos_devoluciones").val(datos_todas_devoluciones)
				}
			  else 
				{  
				$("#ocultodatos_devoluciones").val('')
				}  
			
			
			
			//aqui metemos los datos de los saldos
			//formato entre saldos: @@@saldo1@@@saldo2@@@saldo3
			//formato dentro de cada saldo: saldo###importe###CARGO O ABONO
			datos_todos_saldos=''
			$("#ocultodatos_saldos").val('')
			$(".oculto_saldos").each(function( index ) {
				cadena_saldo=''
				id_saldo=$(this).attr('id_saldo')
				cargo_abono=$(this).attr('cargo_abono')
				total_saldo=parseFloat($(this).attr('total_saldo').replace(',', '.'))
				total_disfrutado=parseFloat($(this).attr('total_disfrutado').replace(',', '.'))
				total_disponible_ant=parseFloat($(this).attr('total_disponible_ant').replace(',', '.'))
				total_pendiente=parseFloat($(this).attr('total_pendiente').replace(',', '.'))
				importe_actual=parseFloat($(this).val().replace(',', '.'))
				
				//solo recojo los saldos utilizados...
				if (importe_actual>0) 
					{
					cadena_saldo=id_saldo.toString() + '###' + importe_actual.toString().replace('.', ',') + '###' + cargo_abono
					//console.log('cadena a enviar para la devolucion: ' + cadena_devolucion );
			  		
					datos_todos_saldos=datos_todos_saldos + '@@@' + cadena_saldo
					//console.log('cadena acumulada de devoluciones: ' + datos_todas_devoluciones);
					}
			
			});
			$("#ocultodatos_saldos").val(datos_todos_saldos)
	

}


function mostrar_datos_adicionales_maletas()
{
	$("#cabecera_capa_maletas").html('Datos Necesarios En El Pedido de Maletas Globalbag');
	//$('#iframe_capa_maletas').attr('src', url_iframe)
	$("#capa_maletas").modal("show");
}

function esVisible(elemento) {
    var esVisible = false;
    if ($(elemento).is(':visible') && $(elemento).css("visibility") != "hidden" && $(elemento).css("opacity") > 0)
		{
        esVisible = true;
    	}

    return esVisible;
}
	
</script>

<script language="javascript">
//para mostrar las nuevas plantillas
function mostrar_capas_new(capa, plantilla, cliente, anno_pedido, pedido, articulo, cantidad)
{
	//redondear capa para el internet explorer
	//DD_roundies.addRule('#contenedorr3', '20px');
	/*
	var heights = window.innerHeight;
	console.log('altura ventana: ' + window.innerHeight)
	console.log('altura ventana con jquery: ' + $(window).height())
	console.log('altura opaca: ' + document.getElementById("capa_opaca").style.height )
	
	console.log('document.documentElement.clientHeight: ' + document.documentElement.clientHeight)
    console.log('document.body.scrollHeight: ' + document.body.scrollHeight)
    console.log('document.documentElement.ssrollHeight: ' + document.documentElement.scrollHeight)
    console.log('document.body.offsetHeight: ' + document.body.offsetHeight)
    console.log('document.documentElement.offsetHeight: ' + document.documentElement.offsetHeight)
	
	*/
    
	
	
	texto_campos=''
	if (plantilla=='plantilla_a01')
		{
		fichero_plantilla='Plantilla_Personalizacion_con_adjunto.asp'
		plantilla_personalizacion=plantilla
		}
	  else
	  	{
		if (plantilla.indexOf('plantilla_rotulacion_1')>=0)
			{
			parametros_rotulacion=plantilla.split('--')
			fichero_plantilla='Plantilla_Personalizacion_Rotulacion.asp'
			plantilla_personalizacion=parametros_rotulacion[0]
			texto_campos='&campos=' + parametros_rotulacion[1]
			}
		  else
		  	{
			if (plantilla.indexOf('plantilla_rotulacion_3')>=0)
				{
				parametros_rotulacion=plantilla.split('--')
				fichero_plantilla='Plantilla_Personalizacion_Rotulacion_3.asp'
				plantilla_personalizacion=parametros_rotulacion[0]
				texto_campos='&campos=' + parametros_rotulacion[1]
				}
			  else
			  	{
				if (plantilla.indexOf('plantilla_rotulacion_4')>=0)
					{
					parametros_rotulacion=plantilla.split('--')
					fichero_plantilla='Plantilla_Personalizacion_Rotulacion_4.asp'
					plantilla_personalizacion=parametros_rotulacion[0]
					texto_campos='&campos=' + parametros_rotulacion[1]
					}
				  else
				  	{
					fichero_plantilla='Plantilla_Personalizacion.asp'
					plantilla_personalizacion=plantilla
					}
				}
			}
		}
		
	//console.log('texto paraametro campos: ' + texto_campos)
	texto_querystring='?plant=' + plantilla_personalizacion + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad	+ texto_campos
		
	url_iframe='../Plantillas_Personalizacion/' + fichero_plantilla + texto_querystring
	
	
	$("#cabecera_nueva_plantilla").html('Plantilla a Rellenar');
    
    $('#iframe_nueva_plantilla').attr('src', url_iframe)
    $("#capa_nueva_plantilla").modal("show");
	
	
	
	
}


//para mostrar las capas de las plantillas de personalizacon de articulos
function mostrar_capas(capa, plantilla, cliente, anno_pedido, pedido, articulo, cantidad)
{
	//redondear capa para el internet explorer
	//DD_roundies.addRule('#contenedorr3', '20px');
	/*
	var heights = window.innerHeight;
	console.log('altura ventana: ' + window.innerHeight)
	console.log('altura ventana con jquery: ' + $(window).height())
	console.log('altura opaca: ' + document.getElementById("capa_opaca").style.height )
	
	console.log('document.documentElement.clientHeight: ' + document.documentElement.clientHeight)
    console.log('document.body.scrollHeight: ' + document.body.scrollHeight)
    console.log('document.documentElement.ssrollHeight: ' + document.documentElement.scrollHeight)
    console.log('document.body.offsetHeight: ' + document.body.offsetHeight)
    console.log('document.documentElement.offsetHeight: ' + document.documentElement.offsetHeight)
	
	*/
    document.getElementById("capa_opaca").style.height = (document.body.scrollHeight + 20) + "px";
	document.getElementById('capa_opaca').style.visibility='visible'
	
	texto_querystring='?plant=' + plantilla + '&cli=' + cliente + '&anno=' + anno_pedido + '&ped=' + pedido + '&art=' + articulo + '&cant=' + cantidad
	document.getElementById('iframe_plantillas').src='../Plantillas_Personalizacion/Plantilla_Personalizacion.asp' + texto_querystring
	document.getElementById(capa).style.visibility='visible';
	
	
	
}

function cerrar_capas(capa)
{	
	document.getElementById('capa_opaca').style.visibility='hidden';
	document.getElementById(capa).style.visibility='hidden';
	
	
}
</script>


<script language="javascript">
function crearAjax() 
{
  var Ajax
 
  if (window.XMLHttpRequest) { // Intento de crear el objeto para Mozilla, Safari,...
    Ajax = new XMLHttpRequest();
    if (Ajax.overrideMimeType) {
      //Se establece el tipo de contenido para el objeto
      //http_request.overrideMimeType('text/xml');
      //http_request.overrideMimeType('text/html; charset=iso-8859-1');
	  Ajax.overrideMimeType('text/html; charset=iso-8859-1');
     }
   } else if (window.ActiveXObject) { // IE
    try { //Primero se prueba con la mas reciente versi�n para IE
      Ajax = new ActiveXObject("Msxml2.XMLHTTP");
     } catch (e) {
       try { //Si el explorer no esta actualizado se prueba con la versi�n anterior
         Ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {}
      }
   }
 
  if (!Ajax) {
    alert('<%=carrito_gag_error_ajax%>');
    return false;
   }
  else
  {
    return Ajax;
  }
}

	

//onclick="mostrar_capa('/Reservas_Web/Incrementar_Visita.asp?Mayorista=MUNDORED','capa_annadir_articulo')"
//mostrar_capa('Annadir_Articulo.asp?acciones=<%=accion%>','capa_annadir_articulo')

function mostrar_capa(pagina,divContenedora,parametros)
{
	//alert('entramos en mostrar capa')
	//alert('parametros.... pagina: ' + pagina + ' divcontenedora: ' + divContenedora)
    var contenedor = document.getElementById(divContenedora);
    
	if (parametros=='')
		{
		var url_final = pagina
		}
	  else
	  	{
	  	var url_final = pagina + '?' + parametros
		}
 
    //contenedor.innerHTML = '<img src="imagenes/loading.gif" />'
	//console.log('url_final: ' + url_final)
    var objAjax = crearAjax()
 
    objAjax.open("GET", url_final)
    objAjax.onreadystatechange = function(){
      if (objAjax.readyState == 4)
	  {
       //Se escribe el resultado en la capa contenedora
	   txt=unescape(objAjax.responseText);
	   txt2=txt.replace(/\+/gi," ");
	   contenedor.innerHTML = txt2;
      }
    }
    objAjax.send(null);
	
}




recalcular_spin = function (id_objeto_spin) {
	//console.log('...dentro de recalcular spin...')
	if (id_objeto_spin!='')
		{
		id_objeto_spin='#' + id_objeto_spin
		//console.log('dentro del change de spin id: ' + $(id_objeto_spin).attr('id') + ', valor: ' + $(id_objeto_spin).val());
		valor_id=$(id_objeto_spin).attr('valor_id')
		//console.log('el valor del id del articulo es: ' + valor_id)
		cantidad=parseFloat($('#spin_cantidad_' + valor_id).val())
		precio=parseFloat($("#ocultoprecio_" + valor_id).val().replace(',', '.'))
		total= cantidad * precio
		total= Math.round10(total, -2)
		//console.log('cantidad: ' + cantidad);
		//console.log('precio: ' + precio);
		//console.log('total: ' + total);
	
		$("#visor_total_" + valor_id).html(total.toString().replace('.', ',') + ' �')
	
		$("#ocultocantidad_" + valor_id).val(cantidad)
		$("#ocultototal_" + valor_id).val(total.toString().replace('.', ','))
		
		}
		
	total_recalculado=0
	$(".subtotales").each(function(index, element) {
		//console.log('subtotal ' + index + ': ' + $(element).val())
		subtotal=parseFloat($(element).val().replace(',', '.'))
		total_recalculado=total_recalculado + subtotal
		total_recalculado= Math.round10(total_recalculado, -2)
	});

	$("#visor_total_pedido").html(total_recalculado.toString().replace('.', ',') + ' �')
	
	$("#ocultototal_pedido").val(total_recalculado.toString().replace('.', ','))
	
	//recalcular_devoluciones()
	total_descuento_devoluciones=0
	total_pedido_con_devoluciones=parseFloat($("#ocultototal_pedido").val().replace(',', '.'))
				
	if($("#chkaplicar_devoluciones").is(':checked'))
		{
			$(".oculto_devoluciones").each(function( index ) {
				
				cadena_devolucion=''
				id_devolucion=$(this).attr('id_devolucion')
				total_aceptado=parseFloat($(this).attr('total_aceptado').replace(',', '.'))
				total_disfrutado=parseFloat($(this).attr('total_disfrutado').replace(',', '.'))
				total_disponible_ant=parseFloat($(this).attr('total_disponible_ant').replace(',', '.'))
				total_pendiente=parseFloat($(this).attr('total_pendiente').replace(',', '.'))
				importe_actual=parseFloat($(this).val().replace(',', '.'))
				
				//recalculamos los valroes que cogemos de cada devolucion
				cantidad_descontar=0
				sobras=0
				total_pedido_con_devoluciones=total_pedido_con_devoluciones - total_disponible_ant
				if (total_pedido_con_devoluciones<0)
					{
					sobras=(-1) * total_pedido_con_devoluciones
					cantidad_descontar=total_disponible_ant - sobras
					total_pedido_con_devoluciones=0
					}
				  else
					{
					sobras=0
					cantidad_descontar=total_disponible_ant
					}
					
				total_descuento_devoluciones = total_descuento_devoluciones + cantidad_descontar
					
				//retocamos las filas que se visualizan
				redondeo_cantidad=Math.round10(sobras, -2)
				$(this).attr('total_pendiente', redondeo_cantidad.toString().replace('.', ','))
				$("#visor_sobrante_devolucion_" + id_devolucion).html(redondeo_cantidad.toString().replace('.', ',') + ' �')
				
				
				redondeo_cantidad=Math.round10(cantidad_descontar, -2)
				$(this).val(redondeo_cantidad.toString().replace('.', ','))
				$("#visor_descontar_devolucion_" + id_devolucion).html(redondeo_cantidad.toString().replace('.', ',') + ' �')
				$("#visor_total_devolucion_" + id_devolucion).html('-' + redondeo_cantidad.toString().replace('.', ',') + ' �')
				
				//console.log('...analizando si se muestra la linea de devolucion ' + id_devolucion)
				//console.log('::disponible para ocultar: ' + total_disponible_ant)
				//if (total_disponible_ant>0)
				if (cantidad_descontar>0)
					{
					//mostrar_devolucion="table-row"
					//console.log('::mostramos la devolucion: ' + id_devolucion)
					$("#fila_devolucion_" + id_devolucion).show()
					}
				  else
					{
					//mostrar_devolucion="none"
					//console.log('::oclutamos la devolucion: ' + id_devolucion)
					$("#fila_devolucion_" + id_devolucion).hide()
					}
			})
		} // if de si esta marcado aplicar devoluciones
	  else
	  	{
		$(".filas_devolucion").hide()
		}
		
		
	//console.log('::vemos el nuevo descuento total:' + total_descuento_devoluciones)
	redondeo_cantidad=Math.round10(total_descuento_devoluciones, -2)
	//console.log('::ahora lo vemos redondeado: ' + redondeo_cantidad)
	$("#ocultototal_descuento_devoluciones").val(redondeo_cantidad.toString().replace('.', ','))
	
	//console.log('...... calculando el nuevo total desncontado las devoluciones:')
	
	total_pedido_despues_descuento=parseFloat($("#ocultototal_pedido").val().replace(',', '.')) - redondeo_cantidad
	//console.log('....total pedido: ' + $("#ocultototal_pedido").val().replace(',', '.'))
	//console.log('....total devoluciones a descontar: ' + total_descuento_devoluciones)
	//console.log('....total devoluciones a descontar (formateado): ' + redondeo_cantidad)
	//console.log('....nuevo total despues quitar devoluciones: ' + total_pedido_despues_descuento)
	redondeo_cantidad=Math.round10(total_pedido_despues_descuento, -2)
	$("#visor_total_pedido_despues_devoluciones").html(redondeo_cantidad.toString().replace('.', ',') + ' �')

	//no se si hay que poner la variable total_pedido con la resta hecha
	
	
	//ahora vemos si hay algun descuento del pedido
	total_descuento_general=0
	//console.log('importe total del pedido: ' + total_pedido_despues_descuento)
	if($("#ocultodescuento_pedido").length > 0) {
 		total_descuento_general=total_pedido_despues_descuento * 0.15
		total_descuento_general=Math.round10(total_descuento_general, -2)
		//console.log('aplicamos descuento del 15%: ' + total_descuento_general)
		$("#visor_descuento_pedido").html(total_descuento_general.toString().replace('.', ',') + ' �')
		$("#ocultodescuento_pedido").val(total_descuento_general)
	}
	total_pedido_despues_descuento=total_pedido_despues_descuento - total_descuento_general
	//console.log('importe total del pedido despues del descuento: ' + total_pedido_despues_descuento)
	total_pedido_despues_descuento=Math.round10(total_pedido_despues_descuento, -2)
	//console.log('importe total del pedido despues del descuento (formateado): ' + total_pedido_despues_descuento)
	$("#visor_total_pedido_despues_descuento_general").html(total_pedido_despues_descuento.toString().replace('.', ',') + ' �')
	$("#ocultototal_con_descuento_pedido").val(total_pedido_despues_descuento)
	
	recalcular_gastos_envio()
	recalcular_totales()
	
	//alert('...JUSTITO ANTES DE CALCULAR LOS SALDOS...')
	//controlamos los saldos
	total_descuento_saldos=0
	total_pedido_con_saldos=parseFloat($("#ocultototal_con_iva_pedido").val().replace(',', '.'))
	//alert('desde reclacular_spin.... oculto_total_pedido: ' + total_pedido_con_saldos)
	$(".oculto_saldos").each(function( index ) {
		cadena_saldo=''
		id_saldo=$(this).attr('id_saldo')
		cargo_abono=$(this).attr('cargo_abono')
		total_saldo=parseFloat($(this).attr('total_saldo').replace(',', '.'))
		total_disfrutado=parseFloat($(this).attr('total_disfrutado').replace(',', '.'))
		total_disponible_ant=parseFloat($(this).attr('total_disponible_ant').replace(',', '.'))
		total_pendiente=parseFloat($(this).attr('total_pendiente').replace(',', '.'))
		importe_actual=parseFloat($(this).val().replace(',', '.'))
		
		textito= 'id saldo: ' + id_saldo + '\ncargo_abono: ' + cargo_abono + '\ntotal saldo: ' + total_saldo + '\ntotal disfrutado: ' + total_disfrutado 
		textito+= '\ntotal_disponble_ant: ' + total_disponible_ant + '\ntotal pendiente: ' + total_pendiente + '\nimporte actual: ' + importe_actual
		//alert(textito)
		
		//recalculamos los valores que cogemos de cada saldo
		cantidad_descontar=0
		sobras=0
		if (cargo_abono=='ABONO')
			{
			total_pedido_con_saldos=total_pedido_con_saldos - total_disponible_ant
			}
		  else
		 	{
			total_pedido_con_saldos=total_pedido_con_saldos + total_disponible_ant
			}
		//alert('desde reclacular_spin.... total pedido con saldos... nuevo: ' + total_pedido_con_saldos)
		if (total_pedido_con_saldos<0)
			{
			sobras=(-1) * total_pedido_con_saldos
			cantidad_descontar=total_disponible_ant - sobras
			total_pedido_con_saldos=0
			}
		  else
			{
			sobras=0
			cantidad_descontar=total_disponible_ant
			}
		//alert('despues de todo, sobras: ' + sobras + '\ncantidad descontar: ' + cantidad_descontar + '\ntotal pedido con saldos: ' + total_pedido_con_saldos)
		if (cargo_abono=='ABONO')
			{
			total_descuento_saldos = total_descuento_saldos + cantidad_descontar
			}
		  else
			{
			total_descuento_saldos = total_descuento_saldos - cantidad_descontar
			}
			
		//alert('despues de todo, total descuento saldos: ' + total_descuento_saldos)
		//retocamos las filas que se visualizan
		redondeo_cantidad=Math.round10(sobras, -2)
		$(this).attr('total_pendiente', redondeo_cantidad.toString().replace('.', ','))
		$("#visor_sobrante_saldo_" + id_saldo).html(redondeo_cantidad.toString().replace('.', ',') + ' �')
		//alert('despues de todo, total pendiente o sobrante: ' + redondeo_cantidad )
		
		
		redondeo_cantidad=Math.round10(cantidad_descontar, -2)
		$(this).val(redondeo_cantidad.toString().replace('.', ','))
		$("#visor_descontar_saldo_" + id_saldo).html(redondeo_cantidad.toString().replace('.', ',') + ' �')
		if (cargo_abono=='ABONO')
			{
			$("#visor_total_saldo_" + id_saldo).html('-' + redondeo_cantidad.toString().replace('.', ',') + ' �')
			}
		  else
		  	{
			$("#visor_total_saldo_" + id_saldo).html('+' + redondeo_cantidad.toString().replace('.', ',') + ' �')
			}
		
		//console.log('...analizando si se muestra la linea de devolucion ' + id_devolucion)
		//console.log('::disponible para ocultar: ' + total_disponible_ant)
		//if (total_disponible_ant>0)
		//alert('vemos si mostramos u ocultamos la linea... cantidad descontar>0...: ' + cantidad_descontar)
		if (cantidad_descontar>0)
			{
			//mostrar_devolucion="table-row"
			//console.log('::mostramos la devolucion: ' + id_devolucion)
			$("#fila_saldo_" + id_saldo).show()
			}
		  else
			{
			//mostrar_devolucion="none"
			//console.log('::oclutamos la devolucion: ' + id_devolucion)
			$("#fila_saldo_" + id_saldo).hide()
			}
	})
	
	//console.log('::vemos el nuevo descuento total:' + total_descuento_devoluciones)
	redondeo_cantidad_saldos=Math.round10(total_descuento_saldos, -2)
	//console.log('::ahora lo vemos redondeado: ' + redondeo_cantidad)
	$("#ocultototal_descuento_saldos").val(redondeo_cantidad_saldos.toString().replace('.', ','))
	
	//console.log('...... calculando el nuevo total desncontado las devoluciones:')
	
	total_pedido_despues_descuento=parseFloat($("#ocultototal_con_iva_pedido").val().replace(',', '.')) - redondeo_cantidad_saldos
	//console.log('....total pedido: ' + $("#ocultototal_pedido").val().replace(',', '.'))
	//console.log('....total devoluciones a descontar: ' + total_descuento_devoluciones)
	//console.log('....total devoluciones a descontar (formateado): ' + redondeo_cantidad)
	//console.log('....nuevo total despues quitar devoluciones: ' + total_pedido_despues_descuento)
	redondeo_cantidad=Math.round10(total_pedido_despues_descuento, -2)
	$("#visor_total_pedido_despues_saldos").html(redondeo_cantidad.toString().replace('.', ',') + ' �')
	
	//***********************************
	//lo que se pone en pago con tarjeta... EL IMPORTE DESCONTANDO LOS SALDOS QUE PUDIERA HABER
	//*************************************
	$("#ocultototal_pago").val(redondeo_cantidad)
	
	
	//console.log('VALOR DEL PEDIDO: ' + $("#ocultototal_pago").val())
	//console.log('VALOR DEL PEDIDO PARSEFLOAT: ' + parseFloat($("#ocultototal_pago").val().replace(',', '.')))
	if (parseFloat($("#ocultototal_pago").val().replace(',', '.'))>0.00)
		{
		if ($("#modos_de_pago").length){$("#modos_de_pago").show()}
		if ($("#aviso_asm_transferencias").length){$("#aviso_asm_transferencias").show()}
		}
	  else
		{
		if ($("#modos_de_pago").length){$("#modos_de_pago").hide()}
		if ($("#aviso_asm_transferencias").length){$("#aviso_asm_transferencias").hide()}
		}
  

	//console.log('... fin de recalcular_spin....')
};



</script>



<!--PARA LA ANIMACION DE METER LA IMAGEN DEL ARTICULO EN EL CARRITO DE LA COMPRA-->		
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-filestyle-1.2.1/bootstrap-filestyle.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-touchspin-master/src/jquery.bootstrap-touchspin.js"></script>
<script type="text/javascript" src="../plugins/jquery-typeahead-2.10.6/dist/jquery.typeahead.min_unicode.js"></script>


</head>
<body style="background-color:<%=session("color_asociado_empresa")%>">
<!-- capa opaca para que no deje pulsar nada salvo lo que salga delante (se comporte de forma modal)-->
<div id="capa_opaca" style="visibility:hidden;background-color:#000000;position:absolute;top:0px;left:0px;width:105%;min-height:110%;z-index:2;filter:alpha(opacity=50);-moz-opacity:.5;opacity:.5">
</div>

<!-- capa con la informacion a mostrar por encima del carrito-->
<div id="capa_informacion" style="visibility:hidden;z-index:3;position:absolute;width:100%; height:100%">
		<div id="contenedorr3" class="aviso">
			<p>
				<iframe src="" style="height:450px;width:910px" frameborder="0" id="iframe_plantillas" name="iframe_plantillas"></iframe>
			</p>
		</div>
</div>
<!--*******************************************************-->


<form id="frmiframe" target="iframe_capa_maletas" method="post" action="../Plantillas_Personalizacion/Plantilla_Personalizacion_Maletas.asp">
	<input type="hidden" id="oculto_id" name="oculto_id" value="<%=cliente_globalbag%>"/>
	<input type="hidden" id="oculto_empresa" name="oculto_empresa" value="200"/>
	<input type="hidden" id="oculto_id_oficina" name="oculto_id_oficina" value="<%=cliente_original_globalbag%>"/>
	<input type="hidden" id="oculto_nombre_oficina" name="oculto_nombre_oficina" value="<%=nombre_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_direccion_oficina" name="oculto_direccion_oficina" value="<%=direccion_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_poblacion_oficina" name="oculto_poblacion_oficina" value="<%=poblacion_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_cp_oficina" name="oculto_cp_oficina" value="<%=cp_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_provincia_oficina" name="oculto_provincia_oficina" value="<%=provincia_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_pais_oficina" name="oculto_pais_oficina" value="<%=pais_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_numero_empleado_d" name="oculto_numero_empleado_d" value="<%=numero_empleado_globalbag%>"/>
	<input type="hidden" id="oculto_horario_entrega_d" name="oculto_horario_entrega_d" value="<%=horario_entrega_globalbag%>"/>
	<input type="hidden" id="oculto_nombre_oficina_d" name="oculto_nombre_oficina_d" value="<%=nombre_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_direccion_oficina_d" name="oculto_direccion_oficina_d" value="<%=direccion_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_poblacion_oficina_d" name="oculto_poblacion_oficina_d" value="<%=poblacion_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_cp_oficina_d" name="oculto_cp_oficina_d" value="<%=cp_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_provincia_oficina_d" name="oculto_provincia_oficina_d" value="<%=provincia_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_pais_oficina_d" name="oculto_pais_oficina_d" value="<%=pais_oficina_globalbag%>"/>
	<input type="hidden" id="oculto_nif_d" name="oculto_nif_d" value="<%=nif_cliente_globalbag%>"/>
	<input type="hidden" id="oculto_razon_social_d" name="oculto_razon_social_d" value="<%=razon_social_cliente_globalbag%>"/>
	<input type="hidden" id="oculto_radio_d" name="oculto_radio_d" value="<%=donde_envio_globalbag%>"/>
	<input type="hidden" id="oculto_telefono_d" name="oculto_telefono_d" value="<%=telefono_cliente_globalbag%>"/>
	<input type="hidden" id="oculto_email_d" name="oculto_email_d" value="<%=email_cliente_globalbag%>"/>
	<input type="hidden" id="oculto_domicilio_d" name="oculto_domicilio_d" value="<%=domicilio_cliente_globalbag%>"/>
	<input type="hidden" id="oculto_poblacion_d" name="oculto_poblacion_d" value="<%=poblacion_cliente_globalbag%>"/>
	<input type="hidden" id="oculto_cp_d" name="oculto_cp_d" value="<%=cp_cliente_globalbag%>"/>
	<input type="hidden" id="oculto_provincia_d" name="oculto_provincia_d" value="<%=provincia_cliente_globalbag%>"/>
	<input type="hidden" id="oculto_pais_d" name="oculto_pais_d" value="<%=pais_cliente_globalbag%>"/>
	<input type="hidden" id="oculto_idpais_d" name="oculto_idpais_d" value="<%=idpais_cliente_globalbag%>"/>
	<input type="hidden" id="oculto_domicilio_envio_d" name="oculto_domicilio_envio_d" value="<%=domicilio_envio%>"/>
	<input type="hidden" id="oculto_poblacion_envio_d" name="oculto_poblacion_envio_d" value="<%=poblacion_envio%>"/>
	<input type="hidden" id="oculto_cp_envio_d" name="oculto_cp_envio_d" value="<%=cp_envio%>"/>
	<input type="hidden" id="oculto_provincia_envio_d" name="oculto_provincia_envio_d" value="<%=provincia_envio%>"/>
</form>   

<input type="hidden" id="ocultopersonalizados" name="ocultopersonalizados" value="<%=kits_articulos_personalizados%>" />

<div class="container-fluid">
   <!--PANTALLA-->
  <div class="row">
    <!--COLUMNA IZQUIERDA -->
    <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-xs-3" id="columna_izquierda">


			  <!--DATOS DEL CLIENTE-->
			  <div class="panel panel-default">
				<div class="panel-body">
					<div class="col-md-12">
						<%
						nombre_logo="logo_" & session("usuario_carpeta") & ".png"
						if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
							nombre_logo="Logo_GLS.png"
						end if
						%>
						<div align="center"><img class="img-responsive" src="Images/<%=nombre_logo%>" style="max-height:90px"/></div>
						<br />
						<%if empleado_gls="SI" then%>
							<div align="left">
								<b><%=session("usuario_directorio_activo_nombre")%>&nbsp;<%=session("usuario_directorio_activo_apellidos")%></b>
					  		</div>
							<br />
						<%end if%>
						<div align="left">
							<%if session("usuario_codigo_empresa")<>260 then%>
								<b><%=session("usuario_empresa")%></b>
								<%if session("usuario_codigo_externo") <> "" then%>
									<b>&nbsp;-&nbsp;<%=session("usuario_codigo_externo")%></b>
								<%end if%>
								<br />
							<%end if%>
							<b><%=session("usuario_nombre")%></b>
							<br />
							<%if session("usuario_codigo_empresa")<>260 then%>
								<%=session("usuario_tipo")%>
								<br />
							<%end if%>

							<%=session("usuario_direccion")%>
							<br /> 
							<%=session("usuario_poblacion")%>
							<br />
							<%=session("usuario_cp")%>&nbsp;<%=session("usuario_provincia")%>
							<br />
							<%=session("usuario_pais")%>
							<br />
							Tel: <%=session("usuario_telefono")%>
							<br />
							Fax: <%=session("usuario_fax")%>
							<br />
							
						</div>
					</div>
				</div>
			  </div>
	
	
			  <!--DATOS DEL PEDIDO-->
			  <div class="panel panel-default">
				<div class="panel-heading"><b><%=carrito_gag_panel_datos_pedido_cabecera%></b></div>
				<div class="panel-body">
					<div class="col-md-12">
						<div align="center" style="padding-bottom:6px ">
							<div style="display:inline-block"><span><img src="../images/Carrito_48x48.png" border="0" class="shopping-cart"/></span></div>
	
							<!-- NO BORRAR, es la capa que a�ade articulos al pedido....-->
							<div style="display:inline-block" id="capa_annadir_articulo">&nbsp;<b><%=session("numero_articulos")%></b> <%=carrito_gag_panel_datos_pedido_articulos%></div>
						</div>
				
						<div align="center">	
							<%if tipo_pedido<>"IMPRESORA_GLS_ADMIN" THEN%>
								<button type="button" id="cmdver_pedido" name="cmdver_pedido" class="btn btn-primary btn-sm" title="<%=carrito_gag_panel_datos_pedido_boton_ver_alter%>">
										<i class="glyphicon glyphicon-list-alt"></i>
										<span><%=carrito_gag_panel_datos_pedido_boton_ver%></span>
								</button>
								<button type="button" id="cmdborrar_pedido" name="cmdborrar_pedido" class="btn btn-primary btn-sm" title="<%=carrito_gag_panel_datos_pedido_boton_borrar_alter%>">
										<i class="glyphicon glyphicon-remove"></i>
										<span><%=carrito_gag_panel_datos_pedido_boton_borrar%></span>
								</button>
							<%end if%>
						</div>
					</div>
				</div>
			  </div>
			  
			<%if session("usuario_codigo_empresa")<>4 then%>
				  <!--PEDIDOS REALIZADOS-->
				  <div class="panel panel-default">
					<div class="panel-heading"><b><%=carrito_gag_panel_pedidos_cabecera%></b></div>
					<div class="panel-body">
						<div align="center" class="col-md-12">	
							<button type="button" id="cmdconsultar_pedidos" name="cmdconsultar_pedidos" class="btn btn-primary btn-sm">
									<i class="glyphicon glyphicon-search"></i>
									<span>Consultar</span>
							</button>
						</div>
					</div>
				  </div>
			<%end if%>
	  
    </div>
    <!--FINAL COLUMNA DE LA IZQUIERDA-->
    
    <!--COLUMNA DE LA DERECHA-->
    <div class="col-xl-9 col-lg-9 col-md-9 col-sm-9 col-xs-9">
      <form name="frmpedido" id="frmpedido" action="Grabar_Pedido_Gag.asp" method="post"  enctype="multipart/form-data">
			<input type="hidden" name="ocultoacciones" id="ocultoacciones" value="<%=cadena_acciones%>" />
			<input type="hidden" name="ocultoempleado" id="ocultoempleado" value="<%=empleado_gls%>" />
	  
	  <%if session("usuario_codigo_empresa")=4 then%>
			<!-- BOTONES PARA CONSULTAR PEDIDOS, DEVOLUCIONES Y SALDOS-->
			<div class="panel panel-default">
		        <div class="panel-body">
					<div class="row">
						<div class="col-lg-3" align="center">
							<button type="button" id="cmdconsultar_pedidos" name="cmdconsultar_pedidos" class="btn btn-primary btn-block btn-sm">
								<div>
								  <span class="fas fa-box-open icono_boton_"></span>
								  <span class="texto_boton_">&nbsp;Consultar Pedidos</span>
								</div>
							</button>
						</div>
						<%if tipo_pedido<>"IMPRESORA_GLS_ADMIN" THEN%>
							<div class="col-lg-3" align="center">
								<button type="button" id="cmdconsultar_devoluciones" name="cmdconsultar_devoluciones" class="btn btn-primary btn-block btn-sm">
										<div>
											<span class="fas fa-reply"></span>
											<span class="texto_boton-">&nbsp;Consultar Devoluciones</span>
											<%if dinero_disponible_devoluciones<>0 then%>
												<span class="dinero_disponible">&nbsp;<%=dinero_disponible_devoluciones%>�&nbsp;</span>
											<%end if%>
										</div>
								</button>
							</div>
							
							<%if empleado_gls<>"SI" then%>
								<%if session("usuario_tipo")<>"GLS PROPIA" then%>
									<div class="col-lg-3" align="center">
										<button type="button" id="cmdconsultar_saldos" name="cmdconsultar_saldos" class="btn btn-primary btn-block  btn-sm">
												<div>
													<i class="fas fa-money-bill-wave"></i>
													<span class="texto_boton-">&nbsp;Consultar Saldos</span>
													<%if dinero_disponible_saldos<>0 then%>
														<span class="dinero_disponible">&nbsp;<%=dinero_disponible_saldos%>�&nbsp;</span>
													<%end if%>
												</div>
										</button>
									</div>
								<%end if%>
								<div class="col-lg-3" align="center">
									<button type="button" name="cmdimpresoras" id="cmdimpresoras" class="btn btn-primary btn-block btn-sm">
										<i class="fas fa-print"></i> Gesti�n Impresoras
									</button>
								</div>
							<%end if%>
						<%end if%>
					</div>
				</div>
			</div>
			<!-- pedidos, devoluciones y saldos-->
		<%end if%>
	  
	  
	  <div class="panel panel-default">
        <div class="panel-heading">
			<span class='fontbold'>
				<%=carrito_gag_panel_detalle_pedido_cabecera%>
					<%if accion="MODIFICAR" THEN%>
						&nbsp;-- <%=carrito_gag_panel_detalle_pedido_cabecera_modificando%>&nbsp;<%=pedido_modificar%>
					<%end if%>		
			</span>
		</div>
        <div class="panel-body">
		
		
				
							<table class="table" id="tabla_datos"> 
								<thead> 
									<tr> 
										<th class="col-md-2" title="<%=carrito_gag_panel_detalle_pedido_titular_codigo_sap_alter%>"><%=carrito_gag_panel_detalle_pedido_titular_codigo_sap%></th> 
										<th class="col-md-3"><%=carrito_gag_panel_detalle_pedido_titular_articulo%></th> 
										<th class="col-md-2" style="text-align:right"><%=carrito_gag_panel_detalle_pedido_titular_cantidad%></th> 
										<th class="col-md-2" style="text-align:right" title="<%=carrito_gag_panel_detalle_pedido_titular_precio_unidad_alter%>"><%=carrito_gag_panel_detalle_pedido_titular_precio_unidad%></th> 
										<th class="col-md-2" style="text-align:right"><%=carrito_gag_panel_detalle_pedido_titular_total%></th>
										<th class="col-md-1"></th> 
									</tr> 
								</thead> 
								<tbody> 
									<%if Session("numero_articulos")=0 then%>
										<tr>
											<td align="center" colspan="8">
												<b><font class="fontbold"><%=carrito_gag_panel_detalle_pedido_no_articulos%></font> &nbsp;&nbsp;&nbsp;
												<button type="button" id="cmdvolver" name="cmdvolver" class="btn btn-info btn-sm">
														<span><%=carrito_gag_panel_detalle_pedido_volver%></span>
														<i class="glyphicon glyphicon-share-alt"></i>
												</button>
											</td>
										</tr>
									<%end if%>
									
									<%
									'Iniciamos las variables
									i=1 'contador de articulos
									'Session("total")=0 'precio del pedido
									total_pedido=0
									compromiso_compra_pedido="SI"
									control_compromiso_compra_pedido="SI"
									
									HAY_MALETAS_HALCON="NO"
									HAY_MALETAS_ECUADOR="NO"
									
									'para controlar los gastos de envio de las maletas globalbag
									maletas_grandes=0
									maletas_medianas=0
									maletas_pequennas=0
									kit_3_maletas=0
									
									'para controlar los gastos de envio de groundforce y air europa, empresa codigo 30 y 40
									peso_articulos_grounforce=0
											
									'Comenzamos la impresion de los articulos del carrito
									While i<=Session("numero_articulos")
										id=Session(i)
										cantidades_precios_id=Session(i & "_cantidades_precios")
										'response.write("<br>cantidades_precios_id para el id " & id & ": " & Session(i & "_cantidades_precios"))
										' oculto_cantidades_precios_xxxx contendr� una lista de parametros separados por dos guiones
										' cantidad--precio_unidad--precio pack--personalizado(kit parcelshop)
										calculos_cantidades_precios=split(cantidades_precios_id,"--")
										'multiplico la cantidad por el precio y rendondeo a 2 decimales
										'total_id=round(calculos_cantidades_precios(0) * calculos_cantidades_precios(1), 2)
										'response.write("<br>posicion: " & i & " ...Articulo: " & id & " cantidades_precios: " & cantidades_precios_id)
										'response.write("<br>Articulo: " & id & " cantidades_precios: " & cantidades_precios_id)
 
										
										'22-06-2016... A�adimos el left join a articulos_personalizados para ver si hay que personalizarlo
										sql="SELECT ARTICULOS.CODIGO_SAP," 
										sql=sql & " CASE WHEN ARTICULOS_IDIOMAS.DESCRIPCION IS NULL THEN ARTICULOS.DESCRIPCION ELSE" 
										sql=sql & " ARTICULOS_IDIOMAS.DESCRIPCION END AS DESCRIPCION_IDIOMA,"
										sql=sql & " ARTICULOS.COMPROMISO_COMPRA,"
										sql=sql & " V_EMPRESAS.CARPETA, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, ARTICULOS.REQUIERE_AUTORIZACION, "
										sql=sql & " ARTICULOS_PERSONALIZADOS.PLANTILLA_PERSONALIZACION"
										sql=sql & ", ARTICULOS_EMPRESAS.FAMILIA, ARTICULOS.PESO"
										sql=sql & ", DESCRIPCIONES_MULTIARTICULOS.CARACTERISTICA"
										sql=sql & ", DESCRIPCIONES_MULTIARTICULOS.DESCRIPCION AS DESCRIPCION_CARACTERISTICA"

										sql=sql & " FROM ARTICULOS ARTICULOS INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO"
										sql=sql & " INNER JOIN V_EMPRESAS ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA = V_EMPRESAS.Id"
										sql=sql & " LEFT JOIN ARTICULOS_PERSONALIZADOS ON ARTICULOS.ID=ARTICULOS_PERSONALIZADOS.ID_ARTICULO"
										sql=sql & " LEFT JOIN ARTICULOS_IDIOMAS"
										sql=sql & " ON (ARTICULOS.ID=ARTICULOS_IDIOMAS.ID_ARTICULO AND ARTICULOS_IDIOMAS.IDIOMA='" & UCASE(SESSION("idioma")) &"')"
										sql=sql & " LEFT JOIN DESCRIPCIONES_MULTIARTICULOS ON (ARTICULOS.ID=DESCRIPCIONES_MULTIARTICULOS.ID_ARTICULO"
										sql=sql & " AND DESCRIPCIONES_MULTIARTICULOS.CARACTERISTICA='Plazo de Entrega')"
			
										sql=sql & " WHERE ARTICULOS.ID=" & id
										sql=sql & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
										if ver_cadena="SI" then
											Response.write("<br>CONSULTA ARTICULO: " & sql)
										end if
										
									
										with articulos
											.ActiveConnection=connimprenta
											.Source=sql
											'.source="SELECT ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION as articulo from articulos"
											'response.write("<br>" & .source)
											.Open
										end with
										'SI TODOS LOS ARTICULOS DEL PEDIDO, SON COMPROMISMO DE COMPRA, EL IMPORTE MINIMO SON 199 O 101
										' PERO EN CUANTO HAYA ALGUN ARTICULO SIN COMPROMISO DE COMPRA, EL IMPORTE MINIMO HA DE SER 300
										'response.write("<br>sap: " & articulos("codigo_sap"))
										'response.write("<br>desc: " & articulos("descripcion"))
										'response.write("<br>compromiso compra: " & articulos("compromiso_compra"))
										if articulos("compromiso_compra")="NO" then
											compromiso_compra_pedido="NO"
											'en cuanto hay un articulo sin compromiso de compra
											' el limite del importe del pedido sube...
											control_compromiso_compra_pedido="NO"
											colorcin="#FCFCFC"
										  else
											compromiso_compra_pedido="SI"
											colorcin="#FFFFCC"
										end if
									
										familia_articulo=articulos("FAMILIA")
										
										'controla si el pedido tiene impresoras de gls, para que se muestre el check de aceptacion de concidiones
										if id=4583 then
											impresora_gls="SI"
										end if
									%>
								
									<tr >
										<td class="col-md-2">
											<%'22-06-2016...  comprobamos si ha de ser un articulo personalizable
											'y luego a�adimos a los campos ocultos el valor de la plantilla y si es personalizable o no
											articulo_personalizado="NO"
											plantilla_personalizacion= "" & articulos("PLANTILLA_PERSONALIZACION")
											if plantilla_personalizacion<>"" THEN
												articulo_personalizado="SI"
											end if
											datos_json_articulo=session("json_" & id)
											'response.write("<br>datos_json_articulo DE LA VARIABLE DE SESION: " & datos_json_articulo)	
											
											'ojo que los codigos seran diferentes en pruebas que en real
											if id="3166" or id="3165" or id="3164" or id="3157" or id="3156" or id="3155" then
												maletas_grandes=cint(maletas_grandes) + cint(calculos_cantidades_precios(0))
											end if
											if id="3169" or id="3168" or id="3167" or id="3160" or id="3159" or id="3158" then
												maletas_medianas=cint(maletas_medianas) + cint(calculos_cantidades_precios(0))
											end if
											if id="3170" or id="3163" or id="3162" or id="3161" then
												maletas_pequennas=cint(maletas_pequennas) + cint(calculos_cantidades_precios(0))
											end if
											if id="3174" or id="3173" or id="3172" or id="3171" then
												kit_3_maletas=cint(kit_3_maletas) + cint(calculos_cantidades_precios(0))
											end if
											%>
											<input type="hidden" class="oculto_articulo" value="<%=id%>">
											<input type="hidden" name="ocultoarticulo_personalizable_<%=id%>" id="ocultoarticulo_personalizable_<%=id%>" value="<%=articulo_personalizado%>">
											<input type="hidden" name="ocultoplantilla_personalizacion_<%=id%>" id="ocultoplantilla_personalizacion_<%=id%>" value="<%=plantilla_personalizacion%>">
											<input type="hidden" name="ocultodatos_personalizacion_json_<%=id%>" id="ocultodatos_personalizacion_json_<%=id%>" value="">
											<input type="hidden" class="control_familias" name="ocultofamilia_<%=id%>" id="ocultofamilia_<%=id%>" value="<%=familia_articulo%>">

											
											<div align="center">
												<a class="thumbnail" href="../Imagenes_Articulos/<%=id%>.jpg" target="_blank" title="<%=carrito_gag_panel_detalle_pedido_imagen_articulo_alter%>" style="text-decoration:none ">
													<div class="image_thumb">
														<img src="../Imagenes_Articulos/Miniaturas/i_<%=id%>.jpg" class="img img-responsive full-width"/>
													</div>
													<%=articulos("CODIGO_SAP")%>
												</a>
												
											</div>
										  
											
												
									  
										</td>
										<td class="col-md-3">
											<%=articulos("DESCRIPCION_IDIOMA")%>
											<%'ASM no controla lo de articulo requiere autorizacion o no
												' UVE tampoco
												' IMPRENTA TAMPOCO
											' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 180 EUROSTARS, 210 MARSOL, 220 IMPRENTA
											', 230 AVORIS, 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR, 260 GENERAL CARRITO y 280 HOSPES tampoco
											if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150 _
												and session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80 _
												and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170 _
												and session("usuario_codigo_empresa")<>180 and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 _
												and session("usuario_codigo_empresa")<>220 and session("usuario_codigo_empresa")<>240 and session("usuario_codigo_empresa")<>250 _
												and session("usuario_codigo_empresa")<>260 and session("usuario_codigo_empresa")<>280 then%>		
												<%IF ARTICULOS("REQUIERE_AUTORIZACION")="SI" THEN%>
														<%IF ((session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=240_
															or (session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>250)) and session("usuario_tipo")="FRANQUICIA") THEN%>
																<i class="glyphicon glyphicon-ok-sign" style="color:#00ff00" title="<%=carrito_gag_panel_detalle_pedido_no_requiere_autorizacion_alter%>"></i>
																<input type="hidden" name="ocultoautorizacion_<%=id%>" id="ocultoautorizacion_<%=id%>" value="NO">
															<%ELSE%>
																<i class="glyphicon glyphicon-exclamation-sign" style="color:#ff0000" title="<%=carrito_gag_panel_detalle_pedido_requiere_autorizacion_alter%>"></i>
																<input type="hidden" name="ocultoautorizacion_<%=id%>" id="ocultoautorizacion_<%=id%>" value="SI">
														<%END IF%>
													<%ELSE%>
														<i class="glyphicon glyphicon-ok-sign" style="color:#00ff00" title="<%=carrito_gag_panel_detalle_pedido_no_requiere_autorizacion_alter%>"></i>
														<input type="hidden" name="ocultoautorizacion_<%=id%>" id="ocultoautorizacion_<%=id%>" value="NO">
												<%END IF%>
											<%end if%>
											
											<%'controlamos si hay articulos de maletas globalbag de halcon o ecuador
											'para despues mostrar el apartado de destinatario
											'puede que ya no haga falta, por eso lo quito ya que se rellena en la plantilla
											'IF ARTICULOS("FAMILIA")=227 THEN
											'	HAY_MALETAS_HALCON="SI"
											'end if
											'IF ARTICULOS("FAMILIA")=228 THEN
											'	HAY_MALETAS_ECUADOR="SI"
											'end if
											%>
											<%
											plazo_entrega="" & articulos("caracteristica")
											if plazo_entrega<>"" then
												dias_plazo="" & articulos("descripcion_caracteristica")
												if dias_plazo <> "" then
													texto_plazo_entrega= "Plazo de Entrega: " & dias_plazo
													%>
													<div><%=texto_plazo_entrega%></div>
												<%end if
											end if
											%>
												
									  </td>
										<td align="right" class="col-md-2">
											<input type="hidden" name="ocultocantidad_<%=id%>" id="ocultocantidad_<%=id%>" value="<%=calculos_cantidades_precios(0)%>">
											<%'controlo las familias de grounforce sobre las que hay que calcular los gastos de envio en funcion del peso
											peso_articulo="" & articulos("PESO")
											'response.write("<br>PESO ARTICULO: " & peso_articulo)
											'response.write("<br>CANTIDAD: " & calculos_cantidades_precios(0))
											if familia_articulo>=357 and familia_articulo<=361 then
												if peso_articulo="" then
													peso_articulo=0
												end if
												peso_articulos_groundforce = peso_articulos_groundforce + (int(peso_articulo) * calculos_cantidades_precios(0))
												'response.write("<br>PESO * CANTIDAD: " & (clng(peso_articulo) * calculos_cantidades_precios(0)))
												'response.write("<br>PESO TOTAL ARTICULOS GROUNDFORCE: " & peso_articulos_groundforce)
											end if
																						
											
											if compromiso_compra_pedido="NO" OR articulos("compromiso_compra")="TRAMOS" then%>
													<%=calculos_cantidades_precios(0)%>
											  <%else%>
													<%'si son articulos de empleados GLS hay que poner la cantidad sin el spin
													if empleado_gls="SI" then%>
														<%=calculos_cantidades_precios(0)%>
													<%else%>
												  		<div class="col-md-10">
															<input class="spins_cantidades" id="spin_cantidad_<%=id%>" type="text" value="<%=calculos_cantidades_precios(0)%>" name="spin_cantidad_<%=id%>" valor_id="<%=id%>" readonly>
														</div>
															
														<%'la impresora de gls en un pedido pendiente de firma, no dejamos que la quite y 
														   'si puede cambiar la camtidad pero a mayores
														if id=4583 and estado_pedido="PENDIENTE FIRMA" then%>	
															<script>
																$("input[name='spin_cantidad_<%=id%>']").TouchSpin({
																	min: <%=calculos_cantidades_precios(0)%>,
																	max: 50000,
																	verticalbuttons: true
																});
															
																$('#spin_cantidad_<%=id%>').on('change', function () {
																	recalcular_spin($(this).attr('id'))
																});
															
															</script>
														  <%else%>
														  	<script>
																$("input[name='spin_cantidad_<%=id%>']").TouchSpin({
																	min: 1,
																	max: 50000,
																	verticalbuttons: true
																});
															
																$('#spin_cantidad_<%=id%>').on('change', function () {
																	recalcular_spin($(this).attr('id'))
																});
															</script>
														<%end if%>
													<%end if%>
											<%end if%>
											<input type="hidden" name="ocultopeso_<%=id%>" id="ocultopeso_<%=id%>" value="<%=peso_articulo%>">
										</td>
										<td align="right" class="col-md-2">
											<input type="hidden" name="ocultoprecio_<%=id%>" id="ocultoprecio_<%=id%>" value="<%=calculos_cantidades_precios(1)%>">
											<%if compromiso_compra_pedido="SI" then%>
												<%=calculos_cantidades_precios(1)%> �/u
											  <%else%>
												<%response.write("")%>			  		
											<%end if%>
										</td>
										<td align="right" class="col-md-2">
											<%
											if compromiso_compra_pedido="SI" then
												resultado=cdbl(replace(calculos_cantidades_precios(0),".",",")) * cdbl(replace(calculos_cantidades_precios(1),".",","))
											  else
												resultado=cdbl(replace(calculos_cantidades_precios(2),".",","))
											end if
											%>
											<div id="visor_total_<%=id%>"><%Response.write(resultado & " �")%></div>
											 
											<%'response.write("<br>cantidad: " & calculos_cantidades_precios(0) & " precio unidad: " & calculos_cantidades_precios(1) & " total Pack: " & calculos_cantidades_precios(2))
											'response.write("<br>resultado: " & resultado & " total pedido: " & total_pedido)
											'response.write("<br>resultado: " & replace(resultado,",",".") & " total pedido: " & total_pedido)
											'response.write("<br>resultado: " & cdbl(cstr(resultado)) & " total pedido: " & total_pedido)
											'response.write("<br>compromiso compra: " & compromiso_compra_pedido)
											total_pedido=total_pedido + resultado
											'total_pedido=total_pedido + cdbl(replace(resultado,",","."))
											
											%>
											<input type="hidden" class="subtotales" name="ocultototal_<%=id%>" id="ocultototal_<%=id%>" value="<%=resultado%>">
										
											
										</td>
										<td  class="col-md-1">
											<%'la impresora de gls no dejamos eliminarla
											if id<>4583 then%>
												<button type="button" class="btn btn-danger btn-sm" title="<%=carrito_gag_panel_detalle_pedido_boton_eliminar_articulo_alter%>" onclick="location.href='Carrito_Gag.asp?borrar=<%=id%>&acciones=<%=cadena_acciones%>&emp=<%=empleado_gls%>'">
													<i class="glyphicon glyphicon-remove"></i>
												</button>
											  <%else
											  	if estado_pedido<>"PENDIENTE FIRMA" then%>
													<button type="button" class="btn btn-danger btn-sm" title="<%=carrito_gag_panel_detalle_pedido_boton_eliminar_articulo_alter%>" onclick="location.href='Carrito_Gag.asp?borrar=<%=id%>&acciones=<%=cadena_acciones%>&emp=<%=empleado_gls%>'">
														<i class="glyphicon glyphicon-remove"></i>
													</button>
												<%end if%>
											<%end if%>
											
											<%'22-06-2016... comprobamos si es uno de los articulos
												' en los que se tiene que rellenar una plantilla
												' para personalizarlos
											carpeta_anno=""
											if fecha_pedido<>"" then
												carpeta_anno=year(fecha_pedido)
											end if
											if articulo_personalizado="SI" then%>
												<br /><br />
												<%
												es_de_merchan="NO"
												if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250  then
													set ver_familia=Server.CreateObject("ADODB.Recordset")
													with ver_familia
														.ActiveConnection=connimprenta
														.Source="SELECT FAMILIAS.DESCRIPCION" 
														.Source= .Source & " FROM ARTICULOS_EMPRESAS INNER JOIN FAMILIAS"
														.Source= .Source & " ON ARTICULOS_EMPRESAS.FAMILIA = FAMILIAS.ID"
														.Source= .Source & " WHERE ARTICULOS_EMPRESAS.ID_ARTICULO =" & id
														.Source= .Source & " AND ARTICULOS_EMPRESAS.CODIGO_EMPRESA = " & session("usuario_codigo_empresa")
														if ver_cadena="SI" then
															response.write("<br>CONSULTA FAMILIAS: " & .source)
														end if
														.OPEN
													end with
													if not ver_familia.eof then
														'response.write("<br>vemos la familia: " & ver_familia("descripcion"))
														if ver_familia("descripcion")="Merchandising No Personalizable" OR ver_familia("descripcion")="Merchandising Personalizable" THEN
															es_de_merchan="SI"
														end if
													end if
													ver_familia.close
													set ver_familia=Nothing
												end if
												if es_de_merchan="SI" then%>
													<button type="button" class="btn btn-warning"
															id="icono_plantilla_<%=id%>" name="icono_plantilla_<%=id%>" 
															title="<%=carrito_gag_panel_detalle_pedido_boton_plantilla_alter%>"
															onclick="mostrar_capas_new('capa_informacion', '<%=plantilla_personalizacion%>','<%=session("usuario")%>', '<%=carpeta_anno%>', '<%=pedido_modificar%>', '<%=id%>', '<%=calculos_cantidades_precios(0)%>')"
															>
														<i class="glyphicon glyphicon-list-alt"></i>&nbsp;DATOS EXPEDIENTE
													</button>
												<%else
													'response.write("<br>cantidades precios:" & cantidades_precios_id)
													'response.write("<br>cantidad:" & calculos_cantidades_precios(0))
													'response.write("<br>precio:" & calculos_cantidades_precios(1))
													'response.write("<br>precio pack:" & calculos_cantidades_precios(2))
													'if (ubound(calculos_cantidades_precios))=3 then
													'	response.write("<br>personalizado:" & calculos_cantidades_precios(3))
													'end if
													'response.write("<br>tama�o arrai:" & (ubound(calculos_cantidades_precios)))
													
													
													'para los kits parcelshop pueden venir personalizados o no segun el check
													if instr("-3765-3766-3767-3768-3769-3770-3771-3772-3773-3774-3775-3776-3777-3778-3779-3780-3781-3782-3783-3784-3785-3786-3787-3788-", _
														"-" & id & "-")>0 then
														'comprobamos el ultimo parametro que es donde esta si es personalizable o no para estos kits especiales
														if calculos_cantidades_precios(ubound(calculos_cantidades_precios))="SI" then
														%>

														<button type="button" class="btn btn-warning btn-sm"
																id="icono_plantilla_<%=id%>" name="icono_plantilla_<%=id%>" 
																title="<%=carrito_gag_panel_detalle_pedido_boton_plantilla_alter%>"
																onclick="mostrar_capas_new('capa_informacion', '<%=plantilla_personalizacion%>','<%=session("usuario")%>', '<%=carpeta_anno%>', '<%=pedido_modificar%>', '<%=id%>', '<%=calculos_cantidades_precios(0)%>')"
																>
															<i class="glyphicon glyphicon-list-alt"></i>
														</button>
														<%end if%>
													 <%else%>
													  	<button type="button" class="btn btn-warning btn-sm"
																id="icono_plantilla_<%=id%>" name="icono_plantilla_<%=id%>" 
																title="<%=carrito_gag_panel_detalle_pedido_boton_plantilla_alter%>"
																onclick="mostrar_capas_new('capa_informacion', '<%=plantilla_personalizacion%>','<%=session("usuario")%>', '<%=carpeta_anno%>', '<%=pedido_modificar%>', '<%=id%>', '<%=calculos_cantidades_precios(0)%>')"
																>
															<i class="glyphicon glyphicon-list-alt"></i>
														</button>
													  
													<%end if
												end if%>
											<%end if%>

										</td>
									</tr>
									
																
								<!------ PARA CONTROL DEL ADJUNTO------------------------------------------>
								<%if compromiso_compra_pedido="NO" and articulo_personalizado="NO" then%>
									<tr id="linea_fichero_adjunto_<%=id%>">
										<td class="item_row" colspan=6 style="border-top:none">
											
											<div class="row">
												<div class="col-sm-5  col-sm-offset-5">
															<input type="file" name="txtfichero_<%=id%>" id="txtfichero_<%=id%>" value="Seleccionar Fichero" style="display:none">
												</div>
												<div class="col-sm-2" style="text-align:right">
														<%if session(i & "_fichero_asociado")<>"" then%>
															<a href="pedidos/<%=year(fecha_pedido)%>/<%=session("usuario")%>__<%=pedido_modificar%>/<%=session(i & "_fichero_asociado")%>" target="_blank">	
																<button type="button" class="btn btn-primary btn-sm"
																	id="icono_adjunto_<%=id%>" name="icono_adjunto_<%=id%>" 
																	title="<%=carrito_gag_panel_detalle_pedido_boton_mostrar_fichero_adjunto_alter%>"
																	style="display:none"
																	>
																
																		<i class="glyphicon glyphicon-paperclip"></i>
																</button>
															</a>
														
															<button type="button" class="btn btn-primary btn-sm"
																id="icono_modificar_adjunto_<%=id%>" name="icono_modificar_adjunto_<%=id%>" 
																title="<%=carrito_gag_panel_detalle_pedido_boton_modificar_fichero_adjunto_alter%>"
																style="display:none"
																onclick="mostramos_txtfichero('<%=id%>')"
																>
																	<i class="glyphicon glyphicon-pencil"></i>
															</button>
														<%end if%>
													</div>
												
												<%if session(i & "_fichero_asociado")="" then%>
													<script language="javascript">
														$('#icono_adjunto_<%=id%>').hide()
														$('#icono_modificar_adjunto_<%=id%>').hide()
														$('#txtfichero_<%=id%>').show()
													</script>
												<%else%>
													<script language="javascript">
														$('#icono_adjunto_<%=id%>').show()
														$('#icono_modificar_adjunto_<%=id%>').show()
														$('#txtfichero_<%=id%>').hide()
													</script>
												<%end if%>
											</div>
										</td>
									</tr>
								<%end if%>
								<!------ FIN CONTROL DEL ADJUNTO ---------------------------------------->
	
									
			
								
								<%if accion="MODIFICAR" then%>
									<%'ahora comprobamos si es un articulo personalizable con plantilla y si ya se ha 
										'guardado el fichero json, para cargarlo en la variable oculta
										
										'si esta vacio recojo el valor desde el fichero, pero si no, lo dejo como esta
										IF Session("json_" & id)="" THEN 
											cadena_texto_json=""
											set fso_json=Server.CreateObject("Scripting.FileSystemObject")
											ruta_fichero_json= Server.MapPath("./pedidos/" & year(fecha_pedido) & "/" & session("usuario") & "__" & pedido_modificar)
											ruta_fichero_json= ruta_fichero_json & "/json_" & id & ".json"
											'--response.write("<br>fichero json a comprobar si existe: " & ruta_fichero_json)
											if fso_json.FileExists(ruta_fichero_json) then
												Set contenido_fichero_json = fso_json.OpenTextFile(ruta_fichero_json, 1) 
												'Escribimos su contenido 
												cadena_texto_json=contenido_fichero_json.ReadAll
												'--Response.Write("El contenido es:<br>" & cadena_texto_json)
											end if
											set fso_json=nothing
											if cadena_texto_json<>"" then
												'en el oculto solo detectamos si se ha rellenado los datos de personalizacion o no
												' el valor de esos datos los gestionamos con la variable de sesion
												Session("json_" & id)=cadena_texto_json
											%>
												<%'--response.write("<br />metemos el texto en el oculto y cambiamos el icono...")%>
												<script language="javascript">
													//valor='';
													//valor=valor.'<%=cadena_texto_json%>';
													//valor=valor.replace(/(\r\n|\n|\r)/gm, '')
													document.getElementById('ocultodatos_personalizacion_json_<%=id%>').value='COMPLETADO';
													//document.getElementById('icono_plantilla_<%=id%>').src='../images/icono_correcto_verde.png';
													$("#icono_plantilla_<%=id%>").removeClass("btn-warning").addClass("btn-success");
													$("#icono_plantilla_<%=id%>").attr('title', '<%=carrito_gag_panel_detalle_pedido_boton_plantilla_hecha_alter%>');
													//console.log('cambiamos color boton plantilla')
												</script>
											
											
											<%
											end if
										  else 'la variable de session no esta vacia%>
											<script language="javascript">
												//valor='';
												//valor=valor.'<%=cadena_texto_json%>';
												//valor=valor.replace(/(\r\n|\n|\r)/gm, '')
												document.getElementById('ocultodatos_personalizacion_json_<%=id%>').value='COMPLETADO';
												//document.getElementById('icono_plantilla_<%=id%>').src='../images/icono_correcto_verde.png';
												$("#icono_plantilla_<%=id%>").removeClass("btn-warning").addClass("btn-success" );
												$("#icono_plantilla_<%=id%>").attr('title', '<%=carrito_gag_panel_detalle_pedido_boton_plantilla_hecha_alter%>');
													
												//console.log('cambiamos color boton plantilla 2')
											</script>
										
										<%	
										end if 'de if session("json_"....
										%>
								
								
  						  <%else  'de accion MODIFICAR%>
							
							<%if Session("json_" & id)<>"" then%>
								<script language="javascript">
									//valor='';
									//valor=valor.'<%=cadena_texto_json%>';
									//valor=valor.replace(/(\r\n|\n|\r)/gm, '')
									document.getElementById('ocultodatos_personalizacion_json_<%=id%>').value='COMPLETADO';
									//document.getElementById('icono_plantilla_<%=id%>').src='../images/icono_correcto_verde.png';
									$("#icono_plantilla_<%=id%>").removeClass("btn-warning").addClass("btn-success" );
									$("#icono_plantilla_<%=id%>").attr('title', '<%=carrito_gag_panel_detalle_pedido_boton_plantilla_hecha_alter%>');
													
									//console.log('cambiamos color boton plantilla 3')
								</script>
							<%end if%>				
							
							
							
							
						<%end if  'de accion MODIFICAR%>
						
									
									
									
									<%		
										i=i+1
										articulos.close
									Wend
									
									%>
									
									
									<%if Session("numero_articulos")<>0 then%>
										<tr>
										  <td>&nbsp;</td>
										  <th colspan=3 style="text-align:right"><%=carrito_gag_panel_detalle_pedido_total%></th>
										  <th style="text-align:right" id="visor_total_pedido"><%=total_pedido%> �</th>
										  <td>&nbsp;<input name="ocultototal_pedido" id="ocultototal_pedido" type="hidden" value="<%=total_pedido%>" /></td>
										</tr>
										
										<%resultado_descuento=0%>
										
										<%total_descuento_devoluciones=0
										total_pedido_con_devoluciones=total_pedido
										
										if not vacio_devoluciones then
											For i = 0 to UBound(tabla_devoluciones, 2)%>
												<%
													disponible=tabla_devoluciones(CAMPO_TOTAL_DISPONIBLE, i)
													cantidad_descontar=0
													sobras=0
													total_pedido_con_devoluciones=round(cdbl(total_pedido_con_devoluciones) - cdbl(disponible),2)
													if total_pedido_con_devoluciones<0 then
														sobras=(-1) * total_pedido_con_devoluciones
														cantidad_descontar=round(cdbl(disponible) - cdbl(sobras),2)
														total_pedido_con_devoluciones=0
													  else
														sobras=0
														cantidad_descontar=round(cdbl(disponible),2)
													end if
												
													if cantidad_descontar>0 then
														mostrar_devolucion=""
													  else
													  	mostrar_devolucion="none"
													end if
													'importe_disponible=0
													'importe_gastado=0
													'if cdbl(tabla_devoluciones(CAMPO_TOTAL, i))<= total_pedido_con_devoluciones then
													'	total_descuento_devoluciones= cdbl(total_descuento_devoluciones) + cdbl(tabla_devoluciones(CAMPO_TOTAL, i))
													'	importe_disponible=cdbl(tabla_devoluciones(CAMPO_TOTAL, i)
													'	importe_gastado=cdbl(tabla_devoluciones(CAMPO_TOTAL, i)
													'end if
													
												%>
													<tr style="display:<%=mostrar_devolucion%>" id="fila_devolucion_<%=tabla_devoluciones(CAMPO_ID_DEVOLUCION, i)%>" name="fila_devolucion_<%=tabla_devoluciones(CAMPO_ID_DEVOLUCION, i)%>" class="filas_devolucion">
													  <th colspan=4 style="text-align:right;color:red">
														Devoluci&oacute;n <%=tabla_devoluciones(CAMPO_ID_DEVOLUCION, i)%>
														&nbsp;(Cantidad Disponible: <%=tabla_devoluciones(CAMPO_TOTAL_DISPONIBLE, i)%> �
														&nbsp;&nbsp;&nbsp;Cantidad a Utilizar: <span id="visor_descontar_devolucion_<%=tabla_devoluciones(CAMPO_ID_DEVOLUCION, i)%>"><%=cantidad_descontar%> �</span>
														&nbsp;&nbsp;&nbsp;Cantidad Sobrante: <span id="visor_sobrante_devolucion_<%=tabla_devoluciones(CAMPO_ID_DEVOLUCION, i)%>"><%=sobras%> �</span>)
													  </th>
													  <th style="text-align:right;color:red" id="visor_total_devolucion_<%=tabla_devoluciones(CAMPO_ID_DEVOLUCION, i)%>">-<%=cantidad_descontar%> �</th>
													  <td>&nbsp;<input class="oculto_devoluciones" 
																	name="devolucion_<%=tabla_devoluciones(CAMPO_ID_DEVOLUCION, i)%>" 
																	id="devolucion_<%=tabla_devoluciones(CAMPO_ID_DEVOLUCION, i)%>"
																	id_devolucion="<%=tabla_devoluciones(CAMPO_ID_DEVOLUCION, i)%>"
																	total_aceptado="<%=tabla_devoluciones(CAMPO_TOTAL_ACEPTADO, i)%>"
																	total_disfrutado="<%=tabla_devoluciones(CAMPO_TOTAL_DISFRUTADO, i)%>"
																	total_disponible_ant="<%=tabla_devoluciones(CAMPO_TOTAL_DISPONIBLE, i)%>"
																	total_pendiente="<%=sobras%>"
																	 type="hidden" value="<%=cantidad_descontar%>" /></td>
													</tr>
												
													<%		
													total_descuento_devoluciones = total_descuento_devoluciones + cdbl(cantidad_descontar)										
													'total_pedido=cdbl(total_pedido) - cdbl(tabla_devoluciones(CAMPO_TOTAL, i))
													%>
											<%Next%>
												<%total_pedido_descontado_devolucion=round(cdbl(total_pedido) - cdbl(total_descuento_devoluciones), 2)%>
												<tr>
												  <td>&nbsp;</td>
												  <th colspan=3 style="text-align:right;">Total Descontando Devoluciones</th>
												  <th style="text-align:right;" id="visor_total_pedido_despues_devoluciones"><%=total_pedido_descontado_devolucion%> �</th>
												  <td>&nbsp;<input name="ocultototal_descuento_devoluciones"  id="ocultototal_descuento_devoluciones" type="hidden" value="<%=total_descuento_devoluciones%>" />
												  		<input name="ocultodatos_devoluciones" id="ocultodatos_devoluciones" type="hidden" value="" />
												  
												  </td>
												</tr>
											
										<%end if%>
										
										
										<%'descuento para el primer pedido de los clientes GENERAL
										if session("usuario_codigo_empresa")=260 AND (session("usuario_primer_pedido")="SI" OR tipo_pedido="PRIMER_PEDIDO_GENERAL") then
											resultado_descuento = total_pedido * 0.15
											
										%>
											<tr>
											  <td>&nbsp;</td>
											  <th colspan=3 style="text-align:right;color:#880000">Descuento Primer Pedido 15%</th>
											  <th style="text-align:right;color:#880000" id="visor_descuento_pedido">
											  		<%
													resultado_descuento = round(resultado_descuento, 2)
													response.write(resultado_descuento)
													%>
													�
													
											  </th>
											  <td>&nbsp;<input name="ocultodescuento_pedido" id="ocultodescuento_pedido" type="hidden" value="<%=resultado_descuento%>" /></td>
											</tr>
											<tr>
											  <td>&nbsp;</td>
											  <th colspan=3 style="text-align:right;">Total Precio Final</th>
											  <th style="text-align:right;" id="visor_total_pedido_despues_descuento_general">
											  		<%
													resultado_total_descuento = round((total_pedido - resultado_descuento), 2)
													response.write(resultado_total_descuento)
													%>
													�
											  </th>
											  <td>&nbsp;<input name="ocultototal_con_descuento_pedido" id="ocultototal_con_descuento_pedido" type="hidden" value="<%=resultado_total_descuento%>" /></td>
											</tr>
										<%end if%>	
										
										
										
											<tr id="fila_gastos_envio" style="display:none">
											  <td>&nbsp;
											  	<input type="hidden" id="ocultomaletas_grandes" name="ocultomaletas_grandes" value="<%=maletas_grandes%>" />
												<input type="hidden" id="ocultomaletas_medianas" name="ocultomaletas_medianas" value="<%=maletas_medianas%>" />
												<input type="hidden" id="ocultomaletas_pequennas" name="ocultomaletas_pequennas" value="<%=maletas_pequennas%>" />
												<input type="hidden" id="ocultokit_3_maletas" name="ocultokit_3_maletas" value="<%=kit_3_maletas%>" />
												<input type="hidden" id="ocultopeso_groundforce" name="ocultopeso_groundforce" value="<%=peso_articulos_groundforce%>" />
												
												
												<!--
												<br />maletas_peque�as: <%=maletas_pequennas%>
												<br />maletas_medianas: <%=maletas_medianas%>
												<br />maletas_grandes: <%=maletas_grandes%>
												<br />kit 3 maletas: <%=kit_3_maletas%>
												-->
												<%gastos_de_envio_total=0%>
												
												<!--<br /><br />gasto maletas_grandes: <%=maletas_grandes%> * 8,95�-->
												<%
												cadena_gasto=cadena_gasto & maletas_grandes & " * 8,95�"
												gastos_de_envio_total= int(maletas_grandes) * 8.95
												'response.write("<br>(" & gastos_de_envio_total & ")")
												%>
												<!--<br />gasto maletas_medianas: -->
													<%
													
													'como las maletas medianas pueden ir dentro de las grandes
													' y las peque�as dentro de las medianas o grandes, 
													' optimizamos los gastos de envio
													if (cint(maletas_grandes) - cint(maletas_medianas))>=0 then
														calculando=0
													  else
													  	calculando=cint(maletas_medianas) - cint(maletas_grandes)
													end if
													'response.write(calculando & " * 7,95�")
													cadena_gasto=cadena_gasto & " + " & calculando & " * 7,95�"
													gastos_de_envio_total= gastos_de_envio_total + (cint(calculando) * 7.95)
													'response.write("<br>(" & gastos_de_envio_total & ")")
													%>
													<!--<br />gasto maletas_peque�as (dentro de medianas o grandes): -->
													<%
													if cint(maletas_grandes)>= cint(maletas_medianas) then
														valor_correcto=cint(maletas_grandes)
													  else
													  	valor_correcto=cint(maletas_medianas)
													end if
													if (cint(valor_correcto) - cint(maletas_pequennas))>=0 then
														calculando=0
													  else
													  	calculando=cint(maletas_pequennas) - cint(valor_correcto)
													end if
													'response.write(calculando & " * 6,95�")
													cadena_gasto=cadena_gasto & " + " & calculando & " * 6,95�"
													gastos_de_envio_total= gastos_de_envio_total + (cint(calculando) * 6.95)
													'response.write("<br>(" & gastos_de_envio_total & ")")
													%>
												<!--<br />gasto kit 3 maletas: <%=kit_3_maletas%> * 8,95�-->
												<%
												cadena_gasto=cadena_gasto & " + " & kit_3_maletas & " * 8,95�"
												gastos_de_envio_total= gastos_de_envio_total + (cint(kit_3_maletas) * 8.95)
												'response.write("<br>(" & gastos_de_envio_total & ")")
												%>
												<!--
												<br />
												<br />
												CALCULO REALIZADO:<%=cadena_gasto%>
												<br/>GASTOS DE ENVIO: <%=gastos_de_envio_total%>
												-->
											  </td>
											  <th colspan=3 style="text-align:right;color:#880000">
											  		<span id="vcontrol_gastos">Gastos de Envio</span>
											  </th>
											  <th style="text-align:right;color:#880000" id="celda_gastos_de_envio">
											  		<%
													'si es Grounforce o Air Europa, veo si hay gastos de envio...
													'response.write("<br>antes de ver gastos envio groundforce...")
													if session("usuario_codigo_empresa")=30 and peso_articulos_groundforce<>"" then
														'response.write("<br>gastos envio groundforce...")
														codigo_postal_control=right(("000" & session("usuario_cp")), 5)
														inicio_cp = left(codigo_postal_control,2)
														
														'si no es baleares (07) ni canarias (35 o 38) es peninsula, con tarifa general
														if (inicio_cp <> "07") and (inicio_cp <> "35") and (inicio_cp <> "38") then
															codigo_postal_control="00000"
														end if
														'response.write("<br>cp usuario: " & session("usuario_cp"))
														'response.write("<br>codigo postal control: " & codigo_postal_control)
														'response.write("<br>inicio cp: " & inicio_cp)
														
														set cp_gastos_envio=Server.CreateObject("ADODB.Recordset")
														with cp_gastos_envio
															.ActiveConnection=connimprenta
															.Source="SELECT LIMITE_KILOS, PRECIO_LIMITE_KILOS, PRECIO_KILOS_ADICIONALES" 
															.Source= .Source & " FROM GASTOS_ENVIO_KILOS"
															.Source= .Source & " WHERE CP = '" & codigo_postal_control & "'"
															.Source= .Source & " AND EMPRESA = " & session("usuario_codigo_empresa")
															if ver_cadena="SI" then
																response.write("<br>CONSULTA gastos de envio: " & .source)
															end if
															.OPEN
														end with
														kilos_limite = 0
														precio_kilos_limite = 0
														precio_kilos_adicionales = 0
														if not cp_gastos_envio.eof then
															'response.write("<br>vemos la familia: " & ver_familia("descripcion"))
															kilos_limite = cp_gastos_envio("LIMITE_KILOS")
															precio_kilos_limite = cp_gastos_envio("PRECIO_LIMITE_KILOS")
															precio_kilos_adicionales = cp_gastos_envio("PRECIO_KILOS_ADICIONALES")
														end if
														cp_gastos_envio.close
														set cp_gastos_envio = Nothing
														
														
														
														'response.write("<br>peso total: " & peso_articulos_groundforce)
														'response.write("<br>kilos limite: " & kilos_limite)
														'response.write("<br>precio kilos limite: " & precio_kilos_limite)
														'response.write("<br>precio siguientes kilos: " & precio_kilos_adicionales)
														
														'pasamos los kilos a gramos
														kilos_limite = kilos_limite * 1000
														calculo_importe= precio_kilos_limite
														'response.write("<br>calculo importe: " & calculo_importe)
														'response.write("<br>kilos limite en gramos: " & kilos_limite)			
														importe_extra=0
														if clng(peso_articulos_groundforce) > kilos_limite then
															importe_extra= ((clng(peso_articulos_groundforce) - clng(kilos_limite)) * cdbl(precio_kilos_adicionales) / 1000)
															
															'response.write("<br>calculo importe extra: " & importe_extra)
														end if
														calculo_importe = calculo_importe + importe_extra
														
														gastos_de_envio_total=calculo_importe  
														'response.write("<br>importe final gastos envio: " & gastos_de_envio_total)
														'response.write("<br><br><br>")
													end if
													
													
													'TAMBIEN PUEDE SER 0
													resultado_gastos_envio = round(gastos_de_envio_total, 2)
													
													if control_gastos_envio<>"" then
														resultado_gastos_envio = round(control_gastos_envio, 2)
													end if
													oculto_resultado_gastos_envio=resultado_gastos_envio
													
													
													response.write(resultado_gastos_envio)
													%>
													�
											  </th>
											  <script language="javascript">
	   										  	//console.log('control_gastos_envio: <%=control_gastos_envio%>')
											  	//console.log('resultado gastos de envio: <%=resultado_gastos_envio%>')
												//console.log('ocultoresultado gastos de envio: <%=oculto_resultado_gastos_envio%>')
											  </script>
											  <td>&nbsp;
											  		<input type="hidden" id="ocultokilos_limite" name="ocultokilos_limite" value="<%=kilos_limite%>" />
													<input type="hidden" id="ocultoprecio_kilos_limite" name="ocultoprecio_kilos_limite" value="<%=precio_kilos_limite%>" />
													<input type="hidden" id="ocultoprecio_kilos_adicionales" name="ocultoprecio_kilos_adicionales" value="<%=precio_kilos_adicionales%>" />
													
											  		<input name="ocultogastos_envio_pedido" id="ocultogastos_envio_pedido" type="hidden" value="<%=oculto_resultado_gastos_envio%>" />
													<input name="ocultogastos_envio_pedido_mostrar" id="ocultogastos_envio_pedido_mostrar" type="hidden" value="" />
													<%if session("usuario_codigo_empresa")=30 and oculto_resultado_gastos_envio<>"" and oculto_resultado_gastos_envio<>0 then%>
														<script language="javascript">
															//console.log('visualizo la fila_gastos_envio')
															$("#fila_gastos_envio").show()
															//console.log('ocultamos la fila del pedido minimo 1')
															$("#fila_pedido_minimo").hide()
														</script>
													<%else%>
														<script language="javascript">
															//console.log('fila_gastos_envio - display: ' + $("#fila_gastos_envio").css('display'))
															//console.log('fila_gastos_envio - visiviliti: ' + $("#fila_gastos_envio").css("visibility"))
															
															
															if ( $("#fila_gastos_envio").css('display') == 'none' || $("#fila_gastos_envio").css("visibility") == "hidden")
																{
																$("#ocultogastos_envio_pedido_mostrar").val('0')
																//console.log('ponemos los gastos de envio a 0')
																}
															  else
																{
																$("#ocultogastos_envio_pedido_mostrar").val('<%=oculto_resultado_gastos_envio%>')
																//console.log('ponemos unos gastos de envio de :' + $("#ocultogastos_envio_pedido_mostrar").val())
																}
														</script>
													<%end if%>

											  </td>
											</tr>
											
											<%
											'response.write("<br>control_gastos_envio: " & control_gastos_envio)
											if control_gastos_envio<>"" then%>
												<script language="javascript">
													//console.log('muestro la fila_gastos_envio')
													$("#fila_gastos_envio").show()			
													//console.log('ocultamos la fila del pedido minimo 3')	
													$("#fila_pedido_minimo").hide()
												</script>
											<%end if%>
										
										
										
																			

										<tr id="fila_pedido_minimo">
										  <td>&nbsp;</td>
										  <th colspan=3 style="text-align:right"><%=carrito_gag_panel_detalle_pedido_pedido_minimo%>
										  	<%if session("usuario_codigo_empresa")=260 then%>
													<br /><span style="font-size:9px">(para no generar gastos de env&iacute;o)</span>
											<%end if%>
										  </th>
										  <th style="text-align:right">
											<%
											if control_compromiso_compra_pedido="NO" then
												pedido_minimo_permitido=session("usuario_pedido_minimo_sin_compromiso")
											else
												pedido_minimo_permitido=session("usuario_pedido_minimo_con_compromiso")
											end if
											response.write(pedido_minimo_permitido & " �")
											%>
										  </th>
										  <td>&nbsp;</td>
										</tr>
										
										<%'para las franquicias hay que calcular el iva para que hagan
											'el ingreso del total mas el iva
										'****
										'al final se muestra lo del iva a las franquicias y a las propias
										'if session("usuario_tipo")="FRANQUICIA" then%>
										<%
										if session("usuario_pais")<>"PORTUGAL" then%>
											<tr>
											  <td>&nbsp;</td>
											  <th colspan=3 style="text-align:right"><%=carrito_gag_panel_detalle_pedido_iva%></th>
											  <th style="text-align:right" id="celda_iva">
												<%
													resultado_iva=(((total_pedido - resultado_descuento) + resultado_gastos_envio) * 0.21)
													iva_21= round(resultado_iva,2)
													response.write(iva_21)
												%> 
												�
											  </th>
											   <script language="javascript">
											  	//console.log('resultado iva: <%=iva_21%>')
											  </script>
											  <td>&nbsp;<input name="oculto_iva_pedido" id="oculto_iva_pedido" type="hidden" value="<%=iva_21%>" /></td>
											</tr>
										<%end if%>
											<tr>
											  <td>
											  	<button type="button" class="btn btn-warning" style="display:none"
															id="icono_plantilla_maletas" name="icono_plantilla_maletas" 
															title="Rellenar Datos Adicionales Para Las Maletas Globalbag"
															onclick="mostrar_datos_adicionales_maletas()"
															>
														<i class="glyphicon glyphicon-list-alt"></i>&nbsp;DATOS ADICIONALES
												</button>
												<input type="hidden" id="ocultodatos_adicionales_maletas" name="ocultodatos_adicionales_maletas" value="" />
												
											  </td>
											  <th colspan=3 style="text-align:right"><%=carrito_gag_panel_detalle_pedido_total_pagar%></th>
											  <th style="text-align:right" id="celda_total_pago">
											  	<%'response.write("<br>valor de total_pago_iva: " & total_pago_iva)%>
												<%
													total_pago_iva=(total_pedido - resultado_descuento) + resultado_gastos_envio + iva_21 
													
													response.write(total_pago_iva)
												%> 
												�
												<%'response.write("<br>valor de total_pago_iva despues: " & total_pago_iva)%>
												</th>
												<td>&nbsp;<input name="ocultototal_con_iva_pedido" id="ocultototal_con_iva_pedido" type="hidden" value="<%=total_pago_iva%>" /></td>
											</tr>
											
											<%'response.write("<br>valor de total_pago_iva: " & total_pago_iva)%>
											<%
											total_descuento_saldos=0
											total_pedido_con_saldos=total_pago_iva
											'response.write("<br>total pago iva: " & total_pago_iva)
											'response.write("<br>total pedido antes de los saldos: " & total_pedido_con_saldos)
											if not vacio_saldos then
												For i = 0 to UBound(tabla_saldos, 2)
													disponible_saldos=tabla_saldos(CAMPO_TOTAL_SALDO_DISPONIBLE, i)
													'response.write("<br>total pedido con saldos: " & total_pedido_con_saldos)
													'response.write("<br>disponible saldos: " & disponible_saldos)
													if UCASE(tabla_saldos(CAMPO_CARGO_ABONO, i))="CARGO" then
															cantidad_descontar=round(cdbl(disponible_saldos),2)
															sobras=0
															total_pedido_con_saldos=round(cdbl(total_pedido_con_saldos) + cdbl(disponible_saldos),2)
															color_saldo="red"
														else
															cantidad_descontar=0
															sobras=0
															total_pedido_con_saldos=round(cdbl(total_pedido_con_saldos) - cdbl(disponible_saldos),2)
															if total_pedido_con_saldos<0 then
																sobras=(-1) * total_pedido_con_saldos
																cantidad_descontar=round(cdbl(disponible_saldos) - cdbl(sobras),2)
																total_pedido_con_saldos=0
															  else
																sobras=0
																cantidad_descontar=round(cdbl(disponible_saldos),2)
															end if
															color_saldo="green"
													end if
													'response.write("<br>descontamos o sumamos (mostrar ocultar linea): " & cantidad_descontar)
													'response.write("<br>sobras: " & sobras)
													'response.write("<br>cargo o abono: " & UCASE(tabla_saldos(CAMPO_CARGO_ABONO, i)))
													'response.write("<br>total pedido con saldos despues: " & total_pedido_con_saldos)
													if cantidad_descontar>0 then
														mostrar_saldo=""
													  else
														mostrar_saldo="none"
													end if
													'importe_disponible=0
													'importe_gastado=0
													'if cdbl(tabla_devoluciones(CAMPO_TOTAL, i))<= total_pedido_con_devoluciones then
													'	total_descuento_devoluciones= cdbl(total_descuento_devoluciones) + cdbl(tabla_devoluciones(CAMPO_TOTAL, i))
													'	importe_disponible=cdbl(tabla_devoluciones(CAMPO_TOTAL, i)
													'	importe_gastado=cdbl(tabla_devoluciones(CAMPO_TOTAL, i)
													'end if
												
												
												
												
												%>
													<tr style="display:<%=mostrar_saldo%>" id="fila_saldo_<%=tabla_saldos(CAMPO_ID_SALDO, i)%>" name="fila_saldo_<%=tabla_saldos(CAMPO_ID_SALDO, i)%>" class="filas_saldo">
													  <th colspan=4 style="text-align:right;color:<%=color_saldo%>">
														Saldo <%=tabla_saldos(CAMPO_ID_SALDO, i)%>&nbsp;-&nbsp;<%=UCASE(tabla_saldos(CAMPO_CARGO_ABONO, i))%>
														<%if UCASE(tabla_saldos(CAMPO_CARGO_ABONO, i))="ABONO" then%>
															&nbsp;(Importe: <%=tabla_saldos(CAMPO_TOTAL_SALDO_DISPONIBLE, i)%> �
															&nbsp;&nbsp;&nbsp;Cantidad a Utilizar: <span id="visor_descontar_saldo_<%=tabla_saldos(CAMPO_ID_SALDO, i)%>"><%=cantidad_descontar%> �</span>
															&nbsp;&nbsp;&nbsp;Cantidad Pendiente: <span id="visor_sobrante_saldo_<%=tabla_saldos(CAMPO_ID_SALDO, i)%>"><%=sobras%> �</span>)
														<%end if%>
													  </th>
													  <th style="text-align:right;color:<%=color_saldo%>" id="visor_total_saldo_<%=tabla_saldos(CAMPO_ID_SALDO, i)%>">
														<%if UCASE(tabla_saldos(CAMPO_CARGO_ABONO, i))="ABONO" then
																response.write("-" & cantidad_descontar & " �")
															else
																response.write("+" & cantidad_descontar & " �")
														end if%>
													  </th>
													  <td>&nbsp;<input class="oculto_saldos" 
																	name="saldo_<%=tabla_saldos(CAMPO_ID_SALDO, i)%>" 
																	id="saldo_<%=tabla_saldos(CAMPO_ID_SALDO, i)%>"
																	id_saldo="<%=tabla_saldos(CAMPO_ID_SALDO, i)%>"
																	cargo_abono="<%=tabla_saldos(CAMPO_CARGO_ABONO, i)%>"
																	total_saldo="<%=tabla_saldos(CAMPO_TOTAL_SALDO, i)%>"
																	total_disfrutado="<%=tabla_saldos(CAMPO_TOTAL_SALDO_DISFRUTADO, i)%>"
																	total_disponible_ant="<%=tabla_saldos(CAMPO_TOTAL_SALDO_DISPONIBLE, i)%>"
																	total_pendiente="<%=sobras%>"
																	 type="hidden" value="<%=cantidad_descontar%>" /></td>
													</tr>
													<%
													if UCASE(tabla_saldos(CAMPO_CARGO_ABONO, i))="ABONO" then		
														total_descuento_saldos = total_descuento_saldos + cdbl(cantidad_descontar)										
													  else
														total_descuento_saldos = total_descuento_saldos - cdbl(cantidad_descontar)										
													end if
													%>
												<%next%>
												<%'total_pedido_descontado_saldos=round(cdbl(total_pedido) - cdbl(total_descuento_saldos), 2)
												total_pedido_descontado_saldos=round(cdbl(total_pedido_con_saldos), 2)%>
												<tr>
												  <td>&nbsp;</td>
												  <th colspan=3 style="text-align:right;">Total Importe a Pagar Aplicando Saldos</th>
												  <th style="text-align:right;" id="visor_total_pedido_despues_saldos"><%=total_pedido_descontado_saldos%> �</th>
												  <td>&nbsp;<input name="ocultototal_descuento_saldos"  id="ocultototal_descuento_saldos" type="hidden" value="<%=total_descuento_saldos%>" />
														<input name="ocultodatos_saldos" id="ocultodatos_saldos" type="hidden" value="" />
												  
												  </td>
												</tr>
											<%end if%>
											
											
											
											
											<%'de momento Solo Activo en GLS
											 if session("usuario_codigo_empresa")=4 then%>
												<tr>
													<td colspan="3">
														<input class="form-check-input" type="checkbox" value="" id="chkaplicar_devoluciones" checked>
														<label class="form-check-label" for="flexCheckChecked">
															Aplicar Descuento Devoluciones
														</label>
														
													</td>
													<td></td>
													<td></th>
													<td></td>
												</tr>
												<%if impresora_gls="SI" then%>
													<tr>
														<td colspan="3">
															<input class="form-check-input" type="checkbox" value="" id="chkcondidiones_impresoras_gls" name="chkcondidiones_impresoras_gls">
															<label class="form-check-label" for="chkcondidiones_impresoras_gls">
																Aceptar Condiciones de Cesi�n de Las Impresoras. Puede consultarlas <a href="../Documentacion/GLS/GLS_Condiciones_Generales_Cesion_Impresoras.pdf" target="_blank">Aqui.</a>
															</label>
															
														</td>
														<td colspan="3">
															<div class="form-group">
																<div class="form-check form-check-inline">
																  <input class="form-check-input" type="radio" name="optrenting_imp_gls" id="optrenting_imp_gls8" value="8" checked>
																  <label class="form-check-label" for="subscription8">Renting 8�/mes + Cuota Final</label>
																</div>
																<div class="form-check form-check-inline">
																  <input class="form-check-input" type="radio" name="optrenting_imp_gls" id="optrenting_imp_gls10" value="10">
																  <label class="form-check-label" for="subscription10">Renting 10�/mes + Cuota Final de 1�</label>
																</div>
															</div>
														</td>
													</tr>
													<tr>
														<td colspan="3">
															<input class="form-check-input" type="checkbox" value="" id="chkleido_manual_impresoras_gls" name="chkleido_manual_impresoras_gls">
															<label class="form-check-label" for="chkleido_manual_impresoras_gls">
																Leido el Manual de Gesti�n. Puede consultarlo <a href="../Documentacion/GLS/GLS_Manual_Gestion_Impresoras.pdf" target="_blank">Aqui.</a>
															</label>
															
														</td>
														<td></td>
														<td></th>
														<td></td>
													</tr>
												<%end if%>
											<%end if%>
										<%'end if%>
										
									<%end if%>								
									
									
								</tbody> 
							</table>

										
					  
					
					
        </div><!--panel-body-->
      </div><!--panel-->
	 
	 
	 <%'solo para:
	 	' -GLS PROPIAS
		' -HALCON / ECUADOR y solo maletas
		' -MARSOL
		', se puede mostrar este apartado de destinatario del envio
	 if (session("usuario_codigo_empresa")=4 and session("usuario_tipo")="GLS PROPIA") _
	 	OR (session("usuario_codigo_empresa")=210) _
		OR (session("usuario_codigo_empresa")=40) THEN
		' OR (session("usuario_codigo_empresa")=10 AND HAY_MALETAS_HALCON="SI") _ ''' no se usa porque se pone un formulario de envio mas complejo que el de ASM
		' OR (session("usuario_codigo_empresa")=20 AND HAY_MALETAS_ECUADOR="SI") _ ''' no se usa porque se pone un formulario de envio mas complejo que el de ASM
		
		%>
			 
	<!-- Seccion SECCION DE FACTURACION PHP ==================================================================================	-->	

    
		<div class="panel panel-default">
	 				<div class="panel-heading">Direcci&oacute;n de Env&iacute;o del Pedido</div>	
					<div class="panel-body">
						<div align="center" class="col-md-12">	
							<div class="col-md-6 col-lg-6">
								<h4>
									<i class="fas fa-truck fa-3x" style="color:green;vertical-align:middle"></i>
									<input type="radio" name="optfacturacion_actual" id="optfacturacion_actual" checked value="ACTUAL" style="vertical-align:middle ">Proveedor o Agencia a Facturar Actual
								</H4>
							</div>
							<div class="col-md-6 col-lg-6">
								<h4>
									<i class="fas fa-plus-square fa-3x" style="color:blue;vertical-align:middle"></i>
									<input type="radio" name="optfacturacion_nueva" id="optfacturacion_nueva" value="NUEVA" style="vertical-align:middle ">Proveedor o Agencia a Facturar Actual Nueva</h4>
							</div>
						</div>
						<div class="col-sm-12 col-md-12 col-lg-12">
                          <div class="form-group row">
						  	<%'Para la oficina propia 280-5 GLS COMPRAS (5089) y la oficina propia 280-51 GLS PERDIDAS (7395) 
								'Y P280-5 COMPRAS PORTUGAL (11340)  Y P280-51 PERDIDAS PORTUGAL (11341)
								'y la nueva propia de IRLANDA - I280-5 COMPRAS IRLANDA (11537)
								' pueden seleccionar direcciones de envio para oficinas propias y franquicias
							if session("usuario")=5089 or session("usuario")=7395 _
								or session("usuario")=11340 or session("usuario")=11341 _
								or session("usuario")=11537 then%>
								<div class="col-sm-2 col-md-2 col-lg-2">
									<label for="cmbagencia_propia_destinatario_d" class="control-label">Agencia/Propia</label>
									<select class="form-control" name="cmbagencia_propia_destinatario_d" id="cmbagencia_propia_destinatario_d" readonly>
											<option value="PROPIA" selected>PROPIA</option>
											<option value="AGENCIA">AGENCIA</option>
									</select>
								</div>
								<div class="col-sm-8 col-md-8 col-lg-8">
							  <%else%>
							  	<div class="col-sm-10 col-md-10 col-lg-10">
							<%end if%>
								<label for="txtdestinatario_d" class="control-label">Destinatario</label>
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input type="text" placeholder="" autocomplete="off" class="js-typeahead-destinatario form-control" style="width: 100%;"  id="txtdestinatario_d" name="txtdestinatario_d" value="<%=destinatario%>" readonly/>
										</div>
									</div>
								</div>
								<input type="hidden" id="ocultotipo_oficina_destinatario_d" name="ocultotipo_oficina_destinatario_d" value="PROPIA" />
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txttelefono_destinatario_d" class="control-label">Tel&eacute;fono</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txttelefono_destinatario_d" name="txttelefono_destinatario_d" value="<%=telefono_destinatario%>" readonly/>
							</div>
                          </div>
						  
                          <div class="form-group row">
                            <div class="col-sm-7 col-md-7 col-lg-7">
								<label for="txtdireccion_destinatario_d" class="control-label">Direcci&oacute;n</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txtdireccion_destinatario_d" name="txtdireccion_destinatario_d" value="<%=direccion_destinatario%>"  readonly/>
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtpoblacion_destinatario_d" class="control-label">Poblaci&oacute;n</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txtpoblacion_destinatario_d" name="txtpoblacion_destinatario_d" value="<%=poblacion_destinatario%>"  readonly/>
							</div>
                          </div>

						<div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtcp_destinatario_d" class="control-label">C.P.</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txtcp_destinatario_d" name="txtcp_destinatario_d" value="<%=cp_destinatario%>"  readonly/>
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtprovincia_destinatario_d" class="control-label">Provincia</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txtprovincia_destinatario_d" name="txtprovincia_destinatario_d" value="<%=provincia_destinatario%>"  readonly/>
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtpais_destinatario_d" class="control-label">Pa&iacute;s</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txtpais_destinatario_d" name="txtpais_destinatario_d" value="<%=pais_destinatario%>" readonly/>
							</div>
                        </div>
						<div class="form-group row">
                            <div class="col-sm-8 col-md-8 col-lg-8">
								<label for="txtpersona_contacto_destinatario_d" class="control-label">Persona Contacto</label>
								<input type="text" class="form-control" style="width: 100%;" maxlength="50"  id="txtpersona_contacto_destinatario_d" name="txtpersona_contacto_destinatario_d" value="<%=persona_contacto_destinatario%>" />
							</div>
                        </div>
						<%if session("usuario_codigo_empresa")=4 then%>
							<div class="form-group row">
    	                        <div class="col-sm-12 col-md-12 col-lg-12">
									<label for="txtcomentarios_entrega_destinatario_d" class="control-label">Comentarios Entrega</label>
									<input type="text" class="form-control" style="width: 100%;" maxlength="100"  id="txtcomentarios_entrega_destinatario_d" name="txtcomentarios_entrega_destinatario_d" value="<%=comentarios_entrega_destinatario%>" />
								</div>
                    	    </div>
						<%end if%>
					</div>
	  		</div>	
	
	
	<!--==FIN DE SECCION FACTURACION=====================================================================	-->	



	 		<div class="panel panel-default">
	 				<div class="panel-heading">Direcci&oacute;n de Env&iacute;o del Pedido</div>	
					<div class="panel-body">
						<div align="center" class="col-md-12">	
							<div class="col-md-6 col-lg-6">
								<h4>
									<i class="fas fa-truck fa-3x" style="color:green;vertical-align:middle"></i>
									<input type="radio" name="optdireccion_envio" id="optdireccion_envio_actual" checked value="ACTUAL" style="vertical-align:middle ">&nbsp;Direcci&oacute;n Env&iacute;o Actual
								</H4>
							</div>
							<div class="col-md-6 col-lg-6">
								<h4>
									<i class="fas fa-plus-square fa-3x" style="color:blue;vertical-align:middle"></i>
									<input type="radio" name="optdireccion_envio" id="optdireccion_envio_nueva" value="NUEVA" style="vertical-align:middle ">&nbsp;Direcci&oacute;n Env&iacute;o Nueva</h4>
							</div>
						</div>
						<div class="col-sm-12 col-md-12 col-lg-12">
                          <div class="form-group row">
						  	<%'Para la oficina propia 280-5 GLS COMPRAS (5089) y la oficina propia 280-51 GLS PERDIDAS (7395) 
								'Y P280-5 COMPRAS PORTUGAL (11340)  Y P280-51 PERDIDAS PORTUGAL (11341)
								'y la nueva propia de IRLANDA - I280-5 COMPRAS IRLANDA (11537)
								' pueden seleccionar direcciones de envio para oficinas propias y franquicias
							if session("usuario")=5089 or session("usuario")=7395 _
								or session("usuario")=11340 or session("usuario")=11341 _
								or session("usuario")=11537 then%>
								<div class="col-sm-2 col-md-2 col-lg-2">
									<label for="cmbagencia_propia_destinatario_d" class="control-label">Agencia/Propia</label>
									<select class="form-control" name="cmbagencia_propia_destinatario_d" id="cmbagencia_propia_destinatario_d" readonly>
											<option value="PROPIA" selected>PROPIA</option>
											<option value="AGENCIA">AGENCIA</option>
									</select>
								</div>
								<div class="col-sm-8 col-md-8 col-lg-8">
							  <%else%>
							  	<div class="col-sm-10 col-md-10 col-lg-10">
							<%end if%>
								<label for="txtdestinatario_d" class="control-label">Destinatario</label>
								<div class="typeahead__container">
									<div class="typeahead__field">
										<div class="typeahead__query">
											<input type="text" placeholder="" autocomplete="off" class="js-typeahead-destinatario form-control" style="width: 100%;"  id="txtdestinatario_d" name="txtdestinatario_d" value="<%=destinatario%>" readonly/>
										</div>
									</div>
								</div>
								<input type="hidden" id="ocultotipo_oficina_destinatario_d" name="ocultotipo_oficina_destinatario_d" value="PROPIA" />
							</div>
							<div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txttelefono_destinatario_d" class="control-label">Tel&eacute;fono</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txttelefono_destinatario_d" name="txttelefono_destinatario_d" value="<%=telefono_destinatario%>" readonly/>
							</div>
                          </div>
						  
                          <div class="form-group row">
                            <div class="col-sm-7 col-md-7 col-lg-7">
								<label for="txtdireccion_destinatario_d" class="control-label">Direcci&oacute;n</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txtdireccion_destinatario_d" name="txtdireccion_destinatario_d" value="<%=direccion_destinatario%>"  readonly/>
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtpoblacion_destinatario_d" class="control-label">Poblaci&oacute;n</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txtpoblacion_destinatario_d" name="txtpoblacion_destinatario_d" value="<%=poblacion_destinatario%>"  readonly/>
							</div>
                          </div>

						<div class="form-group row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
								<label for="txtcp_destinatario_d" class="control-label">C.P.</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txtcp_destinatario_d" name="txtcp_destinatario_d" value="<%=cp_destinatario%>"  readonly/>
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtprovincia_destinatario_d" class="control-label">Provincia</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txtprovincia_destinatario_d" name="txtprovincia_destinatario_d" value="<%=provincia_destinatario%>"  readonly/>
							</div>
							<div class="col-sm-5 col-md-5 col-lg-5">
								<label for="txtpais_destinatario_d" class="control-label">Pa&iacute;s</label>
								<input type="text" class="form-control" style="width: 100%;"  id="txtpais_destinatario_d" name="txtpais_destinatario_d" value="<%=pais_destinatario%>" readonly/>
							</div>
                        </div>
						<div class="form-group row">
                            <div class="col-sm-8 col-md-8 col-lg-8">
								<label for="txtpersona_contacto_destinatario_d" class="control-label">Persona Contacto</label>
								<input type="text" class="form-control" style="width: 100%;" maxlength="50"  id="txtpersona_contacto_destinatario_d" name="txtpersona_contacto_destinatario_d" value="<%=persona_contacto_destinatario%>" />
							</div>
                        </div>
						<%if session("usuario_codigo_empresa")=4 then%>
							<div class="form-group row">
    	                        <div class="col-sm-12 col-md-12 col-lg-12">
									<label for="txtcomentarios_entrega_destinatario_d" class="control-label">Comentarios Entrega</label>
									<input type="text" class="form-control" style="width: 100%;" maxlength="100"  id="txtcomentarios_entrega_destinatario_d" name="txtcomentarios_entrega_destinatario_d" value="<%=comentarios_entrega_destinatario%>" />
								</div>
                    	    </div>
						<%end if%>
					</div>
	  		</div>
	 <%END IF%>
	  
	  <!-- para seleccionar si el pago es por transferencia o con tarjeta-->
	  <!--para ASM, para las FRANQUICIAS y ARRASTRES DE ASM, con codigo de sap, y que no sea la oficina 739 MATARO NEW (7970)  ni 526 GLS CORNELLA-MATARO (10264)
	  		para GENERAL CARRITO, tambien puede hacer pago con tarjeta -->
	<%IF (session("usuario_codigo_empresa")=4 AND (session("usuario_tipo")="AGENCIA" or session("usuario_tipo")="ARRASTRES") and session("usuario_idsap")<>"" and session("usuario")<>7970 and session("usuario")<>10264) _
			 OR (session("usuario_codigo_empresa")=260 and session("usuario_idsap")<>"") then%>
		
	  <div class="panel panel-default" id="modos_de_pago">
					<div class="panel-body">
						<div align="center" class="col-md-12">	
							<div class="col-md-6 col-lg-6">
								<h4>
									<i class="far fa-money-bill-alt fa-3x" style="color:green;vertical-align:middle"></i>
									<input type="radio" name="optforma_pago" id="optforma_pago_trans" checked value="TRANSFERENCIA" style="vertical-align:middle ">&nbsp;Pago Por Transferencia
								</H4>
							</div>
							<div class="col-md-6 col-lg-6">
								<!--
								<h4><font color="blue"><b>Por motivos de mantenimiento, la opci�n de pago por pasarela de pago estar� deshabilitada hasta nuevo aviso.<br />Disculpen las molestias.</b></font></h4>
								-->
								
								
								<h4>
									<i class="far fa-credit-card fa-3x" style="color:blue;vertical-align:middle"></i>
									<input type="radio" name="optforma_pago" id="optforma_pago_tarj" value="REDSYS" style="vertical-align:middle ">&nbsp;Pago Con Tarjeta</h4>
								
							</div>
						</div>
					</div>
	  </div>
	 <%end if%>
	 
	  	<input type="hidden" name="ocultototal_pago" id="ocultototal_pago" value="<%=total_pago_iva%>" />
	  </form>
	  
	  
	  
	  
	  
	  
	  
	  
		<!-- aviso para ASM, para las FRANQUICIAS y ARRASTRES DE ASM, y que no sea la oficina 739 MATARO NEW (7970) ni 526 GLS CORNELLA-MATARO (10264) -->
		<%IF session("usuario_codigo_empresa")=4 AND (session("usuario_tipo")="AGENCIA" or session("usuario_tipo")="ARRASTRES") and session("usuario")<>7970 and session("usuario")<>10264 then%>

		
			<div class="panel panel-danger" id="aviso_asm_transferencias">
				<div class="panel-heading"><%=carrito_gag_panel_ingreso_cabecera%></div>
				<div class="panel-body">
					<font class="fontbold" style="color:#880000">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						Una vez confirmado el pedido, por favor realice una transferencia indicando el nombre de la base y el n�mero de pedido a la siguiente cuenta de Unicaja:
						<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;C�digo I.B.A.N.: ES54 2103 2200 1800 3001 1111
						<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;C�digo B.I.C. Unicaja: UCJAES2M
						
						<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						Transcurridos 30 dias desde la confirmaci�n del pedido sin recibir el pago correspondiente, se proceder� a la cancelaci�n autom�tica del mismo.
						<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						Tras la confirmaci�n del ingreso procederemos a tramitar el pedido.
						<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Gracias.
					</font>
					<br />&nbsp;
					<br />&nbsp;
					<br />&nbsp;
					<div class="alert alert-danger" role="alert">
						<font class="fontbold"><%=carrito_gag_panel_ingreso_portes%></font>
					</div>
				</div>
			</div>
		<%end if%>	
		<!--fin aviso para ASM-->
	  
	  	<!-- aviso para la opcion de transferencia en la cadena GENERAL-->
	  	<%IF session("usuario_codigo_empresa")=260 then%>
	  	<div class="panel panel-danger" id="aviso_general_transferencias">
				<div class="panel-heading">Aviso</div>
				<div class="panel-body">
					<font class="fontbold" style="color:#880000">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						Una vez confirmado el pedido, por favor realice una transferencia indicando el n�mero de pedido a la siguiente cuenta de Unicaja:
						<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;C�digo I.B.A.N.: ES54 2103 2200 1800 3001 1111
						<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;C�digo B.I.C. Unicaja: UCJAES2M
						
						<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						Transcurridos 30 dias desde la confirmaci�n del pedido sin recibir el pago correspondiente, se proceder� a la cancelaci�n autom�tica del mismo.
						<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						Tras la confirmaci�n del ingreso procederemos a tramitar el pedido.
						<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Gracias.
					</font>
					<br>&nbsp;
				</div>
			</div>
		<%end if%>	  
	  	<div class="panel panel-default">
			<div class="panel-body">
				<div align="center" class="col-md-12">	
					<%if empleado_gls="SI" then
						pagina_acceso="Lista_Articulos_Gag_Empleados_GLS.asp"
					   else
					   	pagina_acceso="Lista_Articulos_Gag.asp"
					end if%>
					
					<%if tipo_pedido<>"IMPRESORA_GLS_ADMIN" THEN%>
						<button type="button" id="cmdcontinuar" name="cmdcontinuar" class="btn btn-primary btn-lg" onclick="location.href='<%=pagina_acceso%>?acciones=<%=cadena_acciones%>'">
								<i class="glyphicon glyphicon-plus"></i>
								<span>&nbsp;Continuar Comprando</span>
						</button>
					<%end if%>
					<button type="button" id="cmdconfirmar" name="cmdconfirmar" class="btn btn-success btn-lg" onclick="validar('<%=pedido_minimo_permitido%>', '<%=impresora_gls%>');return false">
							<i class="glyphicon glyphicon-floppy-disk"></i>
							<span>&nbsp;Confirmar Pedido</span>
					</button>
				</div>
			</div>
		</div>
	
	  
	  
    </div>
    <!--FINAL COLUMNA DE LA DERECHA-->
  </div>    
  <!-- FINAL DE LA PANTALLA -->
</div>
<!--FINAL CONTAINER-->





<!-- capa nuevas plantillas -->
  <div class="modal fade" id="capa_nueva_plantilla">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_nueva_plantilla"></h4>	    
        </div>	    
        <div class="modal-body">
          <form class="form-horizontal row-border">
            <div class="form-group">
              <!--
              <iframe id='gmv.iframe_movilidad' src="" width="100%" height="0" frameborder="0" transparency="transparency" onload="gmv.redimensionar_iframe(this);"></iframe>
              -->
              
              <iframe id='iframe_nueva_plantilla' src="" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe> 	
             </div>                  
          </form>
        </div> <!-- del modal-body-->     
        
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa nuevas plantillas -->    
  
<!-- capa para mensajes -->
  <div class="modal fade" id="capa_nueva_mensajes">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_nueva_mensajes"></h4>	    
        </div>	    
        <div class="modal-body" id="body_nueva_mensajes">
        </div> <!-- del modal-body-->     
        <div class="modal-footer" id="botones_nueva_mensajes">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa nueva mensajes -->    



<!-- capa maletas halcon/ecuador -->
  <div class="modal fade" id="capa_maletas" data-backdrop="static" data-keyboard="false">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_capa_maletas"></h4>	    
        </div>	    
		<%
		'response.write("<br>cadena json maletas en el iframe: " & cadena_json_maletas)
		
		'cadena_json_maletas=replace(cadena_json_maletas, """","""""")
		'response.write("<br><br>cadena json maletas despues de formatear en el iframe: " & cadena_json_maletas)
		
		
		%>
		
        <div class="modal-body">
			
			
          <!--<form class="form-horizontal row-border">-->
            <div class="form-group">
              <!--
              <iframe id='gmv.iframe_movilidad' src="" width="100%" height="0" frameborder="0" transparency="transparency" onload="gmv.redimensionar_iframe(this);"></iframe>
              -->
              <iframe id="iframe_capa_maletas" name="iframe_capa_maletas" src="../Plantillas_Personalizacion/Plantilla_Personalizacion_Maletas.asp" width="99%" height="550px" frameborder="0" transparency="transparency"></iframe> 	
				<script type="text/javascript">
					$("#frmiframe").submit();
				</script>
             </div>                  
          <!--</form>-->
        </div> <!-- del modal-body-->     
        
        <!--
        <div class="modal-footer">                  
          <p>                    
            <button type="button" onclick="alert('en construccion')" class="btn btn-primary" id="gmv.add_usr_btn">Aceptar</button>		    
            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>                  
          </p>                
        </div>
        -->  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>   
  <!-- FIN capa maletas halcon/ecuador -->    
  


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
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=carrito_gag_pantalla_avisos_boton_cerrar_2%></button></p>       
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->





<script language="javascript">

$(document).ready(function () {
	//console.log('...dentro del ready...')
	//recalcular_totales()
	mostrar_ocultar_devoluciones()

	no_maleta='NO'
	si_maleta='NO'
	$(".control_familias").each(function(index, element) {
				// element == this
				//227, 228, 264, 300, 316 son las familias de MALETAS GLOBALBAG en PRODUCCION (HALCON, ECUADOR, IMPRENTA, FRANQUICIAS HALCON Y FRANQUICIAS ECUADOR)
				if ($(element).val()=='227' || $(element).val()=='228' || $(element).val()=='264' || $(element).val()=='300' || $(element).val()=='316')
					{
					si_maleta='SI'
					}
				  else
				  	{
					no_maleta='SI'
					}
				
			  });
	
	if (si_maleta=='SI')
		{
		$("#icono_plantilla_maletas").show()
		}
		
	if ('<%=tipo_pedido%>'=='GLOBALBAG')
		{
		$("#icono_plantilla_maletas").removeClass("btn-warning").addClass("btn-success");
		}
	
	$("#ocultodatos_adicionales_maletas").val('<%=cadena_json_maletas%>')		
	
	$("#txtdestinatario_d").bind('typeahead:selected', function(obj, datum, name) {      
        alert(JSON.stringify(obj)); // object
        // outputs, e.g., {"type":"typeahead:selected","timeStamp":1371822938628,"jQuery19105037956037711017":true,"isTrigger":true,"namespace":"","namespace_re":null,"target":{"jQuery19105037956037711017":46},"delegateTarget":{"jQuery19105037956037711017":46},"currentTarget":
        alert(JSON.stringify(datum)); // contains datum value, tokens and custom fields
        // outputs, e.g., {"redirect_url":"http://localhost/test/topic/test_topic","image_url":"http://localhost/test/upload/images/t_FWnYhhqd.jpg","description":"A test description","value":"A test value","tokens":["A","test","value"]}
        // in this case I created custom fields called 'redirect_url', 'image_url', 'description'   

        alert(JSON.stringify(name)); // contains dataset name
        // outputs, e.g., "my_dataset"
	})
	
	<%if pedido_modificar<>"" and pedido_tiene_devoluciones="NO" then%>
		//console.log('hay que desactivar devoluciones')
		if($("#chkaplicar_devoluciones").is(':checked'))
			{
			//console.log('desseleccionamos')
			//$("#chkaplicar_devoluciones").click()
			//desmarco el chezk de aplicar devoluciones
			$("#chkaplicar_devoluciones").prop("checked", false)
			mostrar_ocultar_devoluciones()
			}
	<%end if%>
})


/*
	$(function() {
            var offset = $("#columna_izquierda").offset();
            var topPadding = 15;
            $(window).scroll(function() {
                if ($(window).scrollTop() > offset.top) {
                    $("#columna_izquierda").stop().animate({
                        marginTop: $(window).scrollTop() - offset.top + topPadding
                    });
                } else {
                    $("#columna_izquierda").stop().animate({
                        marginTop: 0
                    });
                };
            });
        });
*/		


		
$("#cmdver_pedido").on("click", function () {
	location.href='Carrito_Gag.asp?acciones=<%=accion%>&emp=<%=empleado_gls%>&personalizados=' + $("#ocultopersonalizados").val()
});

$("#cmdborrar_pedido").on("click", function () {
	pagina_url='Vaciar_Carrito_Gag.asp'
	parametros=''
	mostrar_capa(pagina_url,'capa_annadir_articulo', parametros)
	
	
	
	cadena='<BR><BR><H4><%=carrito_gag_pantalla_avisos_contenido%></H4><BR><BR>'	
	$("#cabecera_pantalla_avisos").html("<%=carrito_gag_pantalla_avisos_cabecera%>")
	$("#body_avisos").html(cadena + "<br>");
	
	cadena='<p><button type="button" class="btn btn-default" data-dismiss="modal" onclick="volver_carrito()"><%=carrito_gag_pantalla_avisos_boton_cerrar%></button></p><br>'
	$("#botones_avisos").html(cadena)                
	$("#pantalla_avisos").modal("show");
	//location.href='Vaciar_Carrito_Gag.asp'
});

volver_carrito=function(){
	location.href='Carrito_Gag.asp?emp=<%=empleado_gls%>'
}

mostramos_txtfichero=function(id_articulo){
	$('#txtfichero_' + id_articulo).show();
}

$("#cmdconsultar_pedidos").on("click", function () {
	
	//borramos las variables del pedido cuando es un pedido de impresoras para que no acumulen
	<%if tipo_pedido="IMPRESORA_GLS_ADMIN" THEN%>
		pagina_url='Vaciar_Carrito_Gag.asp'
		parametros=''
		mostrar_capa(pagina_url,'capa_annadir_articulo', parametros)
	<%end if%>
	
	location.href='Consulta_Pedidos_Gag.asp?emp=<%=empleado_gls%>'
});

$("#cmdconsultar_devoluciones").on("click", function () {
	location.href='Consulta_Devoluciones_Gag.asp?emp=<%=empleado_gls%>'
});

$("#cmdconsultar_saldos").on("click", function () {
	location.href='Consulta_Saldos_Gag.asp'
});
$("#cmdimpresoras").on("click", function () {
	location.href='Consulta_Impresoras_GLS.asp'
})

$("#cmdvolver").on("click", function () {
	<%if empleado_gls="SI" then%>
		location.href='Lista_Articulos_Gag_Empleados_GLS.asp'
	<%else%>
		location.href='Lista_Articulos_Gag.asp'
	<%end if%>
});


$("input:radio[name=optforma_pago]").on("click", function () {
	//alert($("input:radio[name=optforma_pago]:checked").val())
	if ($("input:radio[name=optforma_pago]:checked").val()=='REDSYS')
		{
		if (document.body.contains(document.getElementById("aviso_asm_transferencias"))) {
			$("#aviso_asm_transferencias").hide()
			}
		if (document.body.contains(document.getElementById("aviso_general_transferencias"))) {
			$("#aviso_general_transferencias").hide()
			}
		}
	  else
	  	{
		if (document.body.contains(document.getElementById("aviso_asm_transferencias"))) {
			$("#aviso_asm_transferencias").show()
			}
		if (document.body.contains(document.getElementById("aviso_general_transferencias"))) {
			$("#aviso_general_transferencias").show()
			}
		}

});

$("input:radio[name=optdireccion_envio]").on("click", function () {
	//alert($("input:radio[name=optforma_pago]:checked").val())
	//console.log('contenido del combo: ' + $('#txtdestinatario_d').source())
	if ($("input:radio[name=optdireccion_envio]:checked").val()=='ACTUAL')
		{
		if( $('#cmbagencia_propia_destinatario_d').length )
			{
			//console.log('hay combo propia-franquicia')
			$('#cmbagencia_propia_destinatario_d').attr('readonly', '')
			}
		$('#txtdestinatario_d').prop('readonly', true)
		$('#txttelefono_destinatario_d').prop('readonly', true)
		$('#txtdireccion_destinatario_d').prop('readonly', true)
		$('#txtpoblacion_destinatario_d').prop('readonly', true)
		$('#txtcp_destinatario_d').prop('readonly', true)
		$('#txtprovincia_destinatario_d').prop('readonly', true)
		$('#txtpais_destinatario_d').prop('readonly', true)
		
		$('#txtdestinatario_d').val('<%=destinatario%>')
		$('#txttelefono_destinatario_d').val('<%=telefono_destinatario%>')
		$('#txtdireccion_destinatario_d').val('<%=direccion_destinatario%>')
		$('#txtpoblacion_destinatario_d').val('<%=poblacion_destinatario%>')
		$('#txtcp_destinatario_d').val('<%=cp_destinatario%>')
		$('#txtprovincia_destinatario_d').val('<%=provincia_destinatario%>')
		$('#txtpais_destinatario_d').val('<%=pais_destinatario%>')
		$('#txtpersona_contacto_destinatario_d').val('<%=persona_contacto_destinatario%>')
		$('#txtcomentarios_entrega_destinatario_d').val('<%=comentarios_entrega_destinatario%>')
		}
	  else
	  	{
		if( $('#cmbagencia_propia_destinatario_d').length )
			{
			//console.log('hay combo propia-franquicia')
			$('#cmbagencia_propia_destinatario_d').removeAttr('readonly')
			}
		$('#txtdestinatario_d').prop('readonly', false)
		
		//si no es un empleado que pueda mandar donde quiera
		if (($('#ocultoempleado').val()=='') && (<%=session("usuario_codigo_empresa")%>==4) )
			{
			$('#txttelefono_destinatario_d').prop('readonly', false)
			$('#txtdireccion_destinatario_d').prop('readonly', false)
			$('#txtpoblacion_destinatario_d').prop('readonly', false)
			$('#txtcp_destinatario_d').prop('readonly', false)
			$('#txtprovincia_destinatario_d').prop('readonly', false)
			$('#txtpais_destinatario_d').prop('readonly', false)
			}
						
		vaciar_campos_destinatario()
		$('#txtdestinatario_d').focus()
		}

});


recalcular_totales=function(){
//alert('recalcular_totales')
//console.log('.....DENTRO DE RECALCULAR TOTALES...')
	

total_pedido=$("#ocultototal_pedido").val()
total_pedido=parseFloat(total_pedido.toString().replace(',','.'))

total_devoluciones=0
//if ($("#ocultototal_descuento_devoluciones").length)
if ($(".oculto_devoluciones").length)
	{
	//aqui recaculamos las devoluciones
	
	
	total_devoluciones=$("#ocultototal_descuento_devoluciones").val()
	total_devoluciones=parseFloat(total_devoluciones.toString().replace(',','.'))
	}

total_saldos=0
if ($(".oculto_saldos").length)
	{
	//aqui recaculamos los saldos
	total_saldos=$("#ocultototal_descuento_saldos").val()
	total_saldos=parseFloat(total_saldos.toString().replace(',','.'))
	}

descuento_pedido=0
if ($("#ocultodescuento_pedido").length)
	{
	descuento_pedido=$("#ocultodescuento_pedido").val()
	descuento_pedido=parseFloat(descuento_pedido.toString().replace(',','.'))
	}

total_con_descuento_pedido=0
if ($("#ocultototal_con_descuento_pedido").length)	
	{
	total_con_descuento_pedido=$("#ocultototal_con_descuento_pedido").val()
	total_con_descuento_pedido=parseFloat(total_con_descuento_pedido.toString().replace(',','.'))
	}
	
gastos_envio_pedido=$("#ocultogastos_envio_pedido").val()
gastos_envio_pedido=parseFloat(gastos_envio_pedido.toString().replace(',','.'))



//si est� oculta la fila del gasto de envio, no tengo que aplicarlo en el total del pedido
if ( $("#fila_gastos_envio").css('display') == 'none' || $("#fila_gastos_envio").css("visibility") == "hidden")
	{
    gastos_envio_pedido_mostrar=0
	}
  else
  	{
	gastos_envio_pedido_mostrar=$("#ocultogastos_envio_pedido").val()
	gastos_envio_pedido_mostrar=parseFloat(gastos_envio_pedido.toString().replace(',','.'))
	}



total_iva=$("#oculto_iva_pedido").val()
total_iva=parseFloat(total_iva.toString().replace(',','.'))

total_con_iva_pedido=$("#ocultototal_con_iva_pedido").val()
total_con_iva_pedido=parseFloat(total_con_iva_pedido.toString().replace(',','.'))


//console.log('.....calculando el nuevo iva')
//console.log('...total_pedido: ' + total_pedido)
//console.log('...total_devo: ' + total_devoluciones)
//console.log('...descuento_pedido: ' + descuento_pedido)
//console.log('...gastos_envio: ' + gastos_envio_pedido_mostrar)

total_nuevo_iva=(((total_pedido - total_devoluciones - descuento_pedido) + gastos_envio_pedido_mostrar) * 0.21)
total_nuevo_iva=Math.round10(total_nuevo_iva, -2)

$("#celda_gastos_de_envio").html(gastos_envio_pedido_mostrar.toString().replace('.',',') + ' �')

//console.log('calculamos el nuevo iva: ' + total_nuevo_iva)

$("#oculto_iva_pedido").val(total_nuevo_iva.toString().replace('.',','))
$("#celda_iva").html(total_nuevo_iva.toString().replace('.',',') + ' �')

total_nuevo_con_iva_pedido= (total_pedido - total_devoluciones - descuento_pedido + gastos_envio_pedido_mostrar + total_nuevo_iva)
total_nuevo_con_iva_pedido=Math.round10(total_nuevo_con_iva_pedido, -2)

$("#ocultototal_con_iva_pedido").val(total_nuevo_con_iva_pedido.toString().replace('.',','))

$("#celda_total_pago").html(total_nuevo_con_iva_pedido.toString().replace('.',',') + ' �')

//***********************************
//lo que se pone en pago con tarjeta
//*************************************
$("#ocultototal_pago").val($("#ocultototal_con_iva_pedido").val())

//console.log('total_pedido: ' + total_pedido)
//console.log('total_devoluciones: ' + total_devoluciones)
//console.log('descuento_pedido: ' + descuento_pedido)
//console.log('total con descuento pedido: ' + total_con_descuento_pedido)
//console.log('gastos de envio: ' + gastos_envio_pedido)
//console.log('gastos de envio a mostrar: ' + gastos_envio_pedido_mostrar)
//console.log('total_iva: ' + total_nuevo_iva)
//console.log('total con iva pedido: ' + total_nuevo_con_iva_pedido)

//console.log('importe pago con tarjeta: ' + $("#ocultototal_pago").val())

//console.log('....total pedido: ' + total_pedido)
//console.log('.... desucento: ' + descuento_pedido)
//console.log('.... gastos enviodesucento: ' + gastos_envio_pedido)
//console.log('.... SUMA: ' + (total_pedido - descuento_pedido + gastos_envio_pedido) )
//console.log('.... resultado: ' + ((total_pedido - descuento_pedido + gastos_envio_pedido)* 0.21) )



//console.log('total_iva nuevo: ' + total_nuevo_iva)
//console.log('total_iva nuevo (formateado): ' + Math.round10(total_nuevo_iva, -2))
//console.log('total con iva pedido nuevo: ' + total_nuevo_con_iva_pedido)
//console.log('total con iva pedido nuevo (formatieado): ' + Math.round10(total_nuevo_con_iva_pedido, -2))

//console.log('.....FIN DE RECALCULAR TOTALES...')
	
}


recalcular_gastos_envio = function ()
{
	//console.log('DENTRO DE RECALCULAR GASTOS DE ENVIO...')
	maletas_grandes=0
	maletas_medianas=0
	maletas_pequennas=0
	kit_3_maletas=0
	
	$(".oculto_articulo").each(function(index, element) 
	{
		id=$(element).val()
		//subtotal=parseFloat($(element).val().replace(',', '.'))
		//total_recalculado=total_recalculado + subtotal
		//total_recalculado= Math.round10(total_recalculado, -2)
		if (id=='3166' || id=='3165' || id=='3164' || id=='3157' || id=='3156' || id=='3155')
			{
			maletas_grandes=parseInt(maletas_grandes) + parseInt($('#ocultocantidad_' + id).val())
			}
		if (id=='3169' || id=='3168' || id=='3167' || id=='3160' || id=='3159' || id=='3158')
			{
			maletas_medianas=parseInt(maletas_medianas) + parseInt($('#ocultocantidad_' + id).val())
			}
		if (id=='3170' || id=='3163' || id=='3162' || id=='3161')
			{
			maletas_pequennas=parseInt(maletas_pequennas) + parseInt($('#ocultocantidad_' + id).val())
			}
		if (id=='3174' || id=='3173' || id=='3172' || id=='3171')
			{
			kit_3_maletas=parseInt(kit_3_maletas) + parseInt($('#ocultocantidad_' + id).val())
			}
	});
	
	gastos_de_envio_total=0
												
	gastos_de_envio_total= parseInt(maletas_grandes) * 8.95
	
	/*como las maletas medianas pueden ir dentro de las grandes
		y las peque�as dentro de las medianas o grandes, 
		optimizamos los gastos de envio*/
	if ((parseInt(maletas_grandes) - parseInt(maletas_medianas))>=0)
		{
		calculando=0
		}
	  else
	  	{
		calculando=parseInt(maletas_medianas) - parseInt(maletas_grandes)
		}

	gastos_de_envio_total= gastos_de_envio_total + (parseInt(calculando) * 7.95)

	if (parseInt(maletas_grandes)>= parseInt(maletas_medianas))
		{
		valor_correcto=parseInt(maletas_grandes)
		}
	  else
	  	{
		valor_correcto=parseInt(maletas_medianas)
		}

	if ((parseInt(valor_correcto) - parseInt(maletas_pequennas))>=0)
		{
		calculando=0
		}
	  else
	  	{
		calculando=parseInt(maletas_pequennas) - parseInt(valor_correcto)
		}


	gastos_de_envio_total= gastos_de_envio_total + (parseInt(calculando) * 6.95)

	gastos_de_envio_total= gastos_de_envio_total + (parseInt(kit_3_maletas) * 8.95)
	
	gastos_de_envio_total=Math.round10(gastos_de_envio_total, -2)
	
	//console.log('gastos de envio calculados para maletas: ' + gastos_de_envio_total)
	$("#ocultogastos_envio_pedido").val(gastos_de_envio_total)
	
	
	
	//console.log('... pedido minimo: <%=pedido_minimo_permitido%> .... total pedido: ' + $("#ocultototal_pedido").val())
	
	if ('<%=session("usuario_codigo_empresa")%>' == '260')
		{
		//console.log('.... es la EMPRESA GENERAL')
		if (parseFloat('<%=pedido_minimo_permitido%>') > parseFloat($("#ocultototal_pedido").val()))
			{
			//console.log('..... mostramos la fila de gastos de envio')
			$("#fila_gastos_envio").show()
			}
		  else
		  	{
			//console.log('..... Ocultamos la fila de gastos de envio')
			$("#fila_gastos_envio").hide()
			
			}
		}
	
	//para Groundforce hay que ver si son los articulos que solo se cobra su gasto de envio, ellos valen 0
	if ('<%=session("usuario_codigo_empresa")%>' == '30')
		{
		//console.log('veo si hay gastos de envio en articulos de groundforce')
		peso_total_groundforce=0
		kilos_limite_groundforce = $("#ocultokilos_limite").val()
		precio_kilos_limite_groundforce = $("#ocultoprecio_kilos_limite").val()
		precio_kilos_adicionales_groundforce = $("#ocultoprecio_kilos_adicionales").val()
		//console.log('kilos limite: ' + kilos_limite_groundforce)
		//console.log('precio kilos limite: ' + precio_kilos_limite_groundforce)
		//console.log('precio kilos adicionales: ' + precio_kilos_adicionales_groundforce)
		
		texto_control=''
		texto_control_operado=''
		$(".oculto_articulo").each(function(index, element) 
			{
			id=$(element).val()
			familia=parseInt($("#ocultofamilia_" + id).val())
			cantidad=parseFloat($('#spin_cantidad_' + id).val())
			peso=parseFloat($('#ocultopeso_' + id).val())
			//console.log('articulo: ' + id)
			//console.log('familia: ' + familia)
			
			//articulos de la famlia de operaciones
			if ((familia>=357) && (familia<=361))
				{
				texto_control = texto_control +  ' + (' +  cantidad + ' * ' + peso + ')'
				texto_control_operado = texto_control_operado + ' + ' + (cantidad * peso)
				//console.log('si tiene gastos de envio')
				//console.log('peso a a�adir: ' + (peso * cantidad))
				peso_total_groundforce= peso_total_groundforce + (peso * cantidad)
				}
			
			})
		
		texto_control += '<br>' + texto_control_operado
		texto_control += '<br>------------<br>Peso total: ' + peso_total_groundforce
		texto_control += '<br><br>kilos limite: ' + kilos_limite_groundforce
		texto_control += '<br>precio kilos limite: ' + precio_kilos_limite_groundforce
		texto_control += '<br>precio kilos adicionales: ' + precio_kilos_adicionales_groundforce
		
		
		//console.log('----nuevo peso total articulos groundforce: ' + peso_total_groundforce)
		nuevo_importe_gastos_envio=0
		nuevo_importe_gastos_envio_adicional=0
		
		if (peso_total_groundforce>0)
			{
			nuevo_importe_gastos_envio = parseFloat($("#ocultoprecio_kilos_limite").val().replace(',', '.'))
			}
			
		//console.log('nuevo importe gastos envio: ' + nuevo_importe_gastos_envio)
		texto_control += '<br><br>nuevo importe gastos envio: ' + nuevo_importe_gastos_envio
		if (parseFloat(peso_total_groundforce) > parseFloat($("#ocultokilos_limite").val()))
			{
			kilos_restantes = parseFloat(peso_total_groundforce) - parseFloat($("#ocultokilos_limite").val())
			texto_control += '<br>gramos restantes: ' + kilos_restantes
			nuevo_importe_gastos_envio_adicional = (kilos_restantes * parseFloat($("#ocultoprecio_kilos_adicionales").val().replace(',', '.'))) / 1000

			texto_control += '<br>importe gastos envio kilos adicionales (' + kilos_restantes + ' * ' + $("#ocultoprecio_kilos_adicionales").val() +') / 1000 = '
			texto_control += nuevo_importe_gastos_envio_adicional

			//console.log('kilos adicionales: ' + kilos_restantes)
			//console.log('importe kilos adicionales: ' + nuevo_importe_gastos_envio_adicional)
			}
			
		texto_control += '<br>' + nuevo_importe_gastos_envio + ' + ' +  nuevo_importe_gastos_envio_adicional
		if (peso_total_groundforce>0)
			{
			nuevo_importe_gastos_envio = nuevo_importe_gastos_envio + nuevo_importe_gastos_envio_adicional
			}
			
		texto_control += '<br>total gastos envio... ' + nuevo_importe_gastos_envio
		
		gastos_de_envio_total=Math.round10(nuevo_importe_gastos_envio, -2)
		texto_control += '<br>total gastos envio formateado: ' + gastos_de_envio_total
		texto_control += '<br>'
		
		$("#ocultogastos_envio_pedido").val(gastos_de_envio_total)
		
		//console.log('nuevo_importe_gastos_envio: ' + nuevo_importe_gastos_envio)
		//console.log('gastos_envio total formateado: ' + gastos_de_envio_total)

		texto_control=''
		texto_control=texto_control + 'Gastos de Envio<br>(por un peso total de ' + peso_total_groundforce + 'g)'
		$("#vcontrol_gastos").html(texto_control)
		
			
		
		if (!(peso_total_groundforce>0))
			{
			$("#fila_gastos_envio").hide()
			}
		  else
		  	{
		  	//console.log('ocultasmo la fila del pedido minimo 2')
			$("#fila_pedido_minimo").hide()
			}
		}
	
	
	
	//si est� oculta la fila del gasto de envio, no tengo que aplicarlo en el total del pedido
	if ($("#fila_gastos_envio").css('display') == 'none' || $("#fila_gastos_envio").css("visibility") == "hidden")
		{
		$("#ocultogastos_envio_pedido_mostrar").val(0)
		$("#ocultogastos_envio_pedido").val(0)
		}
	  else
	  	{
		if ('<%=session("usuario_codigo_empresa")%>' == '260')
			{
			$("#ocultogastos_envio_pedido_mostrar").val('5,9')
			$("#ocultogastos_envio_pedido").val(5.9)
			}
		  else
		  	{
			//console.log('ponemos los gastos de envio que se ven')
			$("#ocultogastos_envio_pedido_mostrar").val(gastos_de_envio_total)
			}
		}
	
	//console.log('.. ocultogastos_envio_pedido definitivos: ' + $("#ocultogastos_envio_pedido").val())
	//console.log('.. ocultogastos_envio_pedido_mostrar definitivo: ' + $("#ocultogastos_envio_pedido_mostrar").val())
	//console.log('FIN DE RECALCULAR GASTOS DE ENVIO...')
	
}



$("#chkaplicar_devoluciones").click(function() { 
	//console.log('picamos en el check de devoluciones... evnento click') 

	mostrar_ocultar_devoluciones()
	
}); 


mostrar_ocultar_devoluciones = function ()
{
	//console.log('dentro de la funcion mostar_ocultar_devoluciones')
	algun_spin=''  
	$('.spins_cantidades').each( function(i,e) {
		/* you can use e.id instead of $(e).attr('id') */
		algun_spin=$(e).attr('id');
	});
	if (algun_spin!='')
		{
		//console.log('refrescamos el carrito')
		nombre_control=algun_spin
		//$(nombre_control).trigger("change")
		//console.log('pasamos como parametro de recalcular_spin: ' + nombre_control)
		recalcular_spin(nombre_control)
		}
	  else
	  	{
		//a lo mejor aqui hay que hacer otro recalculo para elcaso en el que no hay spins
		//console.log('no hay spins, hay')
		recalcular_spin('')
		}

	
	/*
	if($("#chkaplicar_devoluciones").is(':checked')) 
		{  
		console.log('esta check') 
        }
	  else 
	  	{  
		console.log('no esta check') 
        }  
	*/
}

// funciones para el redondeo correcto, al final vienen ejemplos de uso
  /**
   * Ajuste decimal de un n�mero.
   *
   * @param {String}  tipo  El tipo de ajuste.
   * @param {Number}  valor El numero.
   * @param {Integer} exp   El exponente (el logaritmo 10 del ajuste base).
   * @returns {Number} El valor ajustado.
   */
function decimalAdjust(type, value, exp) {
    // Si el exp no est� definido o es cero...
    if (typeof exp === 'undefined' || +exp === 0) {
      return Math[type](value);
    }
    value = +value;
    exp = +exp;
    // Si el valor no es un n�mero o el exp no es un entero...
    if (isNaN(value) || !(typeof exp === 'number' && exp % 1 === 0)) {
      return NaN;
    }
    // Shift
    value = value.toString().split('e');
    value = Math[type](+(value[0] + 'e' + (value[1] ? (+value[1] - exp) : -exp)));
    // Shift back
    value = value.toString().split('e');
    return +(value[0] + 'e' + (value[1] ? (+value[1] + exp) : exp));
  }

  // Decimal round
Math.round10 = function(value, exp) {
      return decimalAdjust('round', value, exp);
    };

  // Decimal floor
Math.floor10 = function(value, exp) {
      return decimalAdjust('floor', value, exp);
    };

  // Decimal ceil
Math.ceil10 = function(value, exp) {
      return decimalAdjust('ceil', value, exp);
    };


/*
//*********************ejemplos de uso de las funciones round
// Round
Math.round10(55.55, -1);   // 55.6
Math.round10(55.549, -1);  // 55.5
Math.round10(55, 1);       // 60
Math.round10(54.9, 1);     // 50
Math.round10(-55.55, -1);  // -55.5
Math.round10(-55.551, -1); // -55.6
Math.round10(-55, 1);      // -50
Math.round10(-55.1, 1);    // -60
Math.round10(1.005, -2);   // 1.01 -- compare this with Math.round(1.005*100)/100 above
// Floor
Math.floor10(55.59, -1);   // 55.5
Math.floor10(59, 1);       // 50
Math.floor10(-55.51, -1);  // -55.6
Math.floor10(-51, 1);      // -60
// Ceil
Math.ceil10(55.51, -1);    // 55.6
Math.ceil10(51, 1);        // 60
Math.ceil10(-55.59, -1);   // -55.5
Math.ceil10(-59, 1);       // -50

*////////////////////////////////////////////

es_empleado_gls=false
if ($('#ocultoempleado').val()=='SI')
	{
	es_empleado_gls=true
	}
	

$(".js-typeahead-destinatario").typeahead({
		
		minLength: 3,
		maxItem: 10,
		order: "asc",
		dynamic: true,
		hint: true,
		accent: true,
		blurOnTab: false,            // Blur Typeahead when Tab key is pressed, if false Tab will go though search results
		mustSelectItem: es_empleado_gls,
	    //generateOnLoad: true,
		//searchOnFocus: true,
		//delay: 500,
		//correlativeTemplate: true,
		backdrop: {
			"background-color": "#fff",
			"opacity": "0.1",
			"filter": "alpha(opacity=10)"
		},
		//backdrop: {
		//	"background-color": "#3879d9",
		//	"opacity": "0.1",
		//	"filter": "alpha(opacity=10)"
		//},
	
		emptyTemplate: "no hay resultados para {{query}}",
		debug: true,
		source: {
			gls_depots: {
				//display: ["REFERENCIA", "TIPO_MALETA", "TAMANNO", "COLOR"],
				display: "NOMBRE",
				ajax: function (query) {
					return {
						type: "POST",
						url: "../tojson/Obtener_Destinatarios_Envios.asp",
						//{"status":true,"error":null,"data":{"user":[{"id":748137,"username":"juliocastrop","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/748137"},{"id":5741776,"username":"solevy","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/5741776"},{"id":906237,"username":"nilovna","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/906237"},{"id":612578,"username":"Thiago Talma","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/612578"},{"id":985837,"username":"ldrrp","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/985837"}],"project":[{"id":2,"project":"jQuery Validation","image":"http:\/\/www.runningcoder.org\/assets\/jqueryvalidation\/img\/jqueryvalidation-preview.jpg","version":"1.4.0","demo":11,"option":14,"callback":8}]}}
						//path: "data.user",
						path: "data",
						data: {empresa: <%=session("usuario_codigo_empresa")%>, tipo: $("#ocultotipo_oficina_destinatario_d").val(), nombre: query},
						callback: {
							
							}
						}
					}
				
	 
			} //maleta
			
		},
		callback: {
			onClick: function (node, a, item, event) {
					//console.log('evento onclick')
		 
					// You can do a simple window.location of the item.href
					//console.log(JSON.stringify(item))
					//alert(JSON.stringify(item));
					
					$("#txttelefono_destinatario_d").val(item.TELEFONO)
					$("#txtdireccion_destinatario_d").val(item.DIRECCION)
					$("#txtpoblacion_destinatario_d").val(item.POBLACION)
					$("#txtcp_destinatario_d").val(item.CP)
					$("#txtprovincia_destinatario_d").val(item.PROVINCIA)
					$("#txtpais_destinatario_d").val(item.PAIS)
		 
				},
			onCancel: function (node, a, item, event) {
					//console.log('evento oncancel')
					$("#txttelefono_destinatario_d").val('')
					$("#txtdireccion_destinatario_d").val('')
					$("#txtpoblacion_destinatario_d").val('')
					$("#txtcp_destinatario_d").val('')
					$("#txtprovincia_destinatario_d").val('')
					$("#txtpais_destinatario_d").val('')
		 			$("#txtpersona_contacto_destinatario_d").val('')
					$("#txtcomentarios_entrega_destinatario_d").val('')
					
		 
				},
			onResult: function (node, query) {console.log('evento onresult')}             // When the result container is displayed
			
				
				
			}
		
	
	});

$("#cmbagencia_propia_destinatario_d").change(function() {
  vaciar_campos_destinatario()
  $('#txtdestinatario_d').focus()
  $("#ocultotipo_oficina_destinatario_d").val($("#cmbagencia_propia_destinatario_d").val())
  if ($("#cmbagencia_propia_destinatario_d").val()=='PROPIA')
  	{
	$(".js-typeahead-destinatario").typeahead({minLength: 0})
	}
  else
  	{
	$(".js-typeahead-destinatario").typeahead({minLength: 3})
	}
	
	
});

$("#txtdestinatario_d").on('keyup', function (event) {
	//console.log('dentro del keyup')
	//si no controlo el enter hace submit del formualario
	if(event.keyCode == 13) {
    	event.preventDefault();
		return false;
		}
	  else
	  	{
		//si es un empleado que al escribir se vacien los textos para que solo se complimenten desde la seleccion de una valor del typeahead
		if ($('#ocultoempleado').val()=='SI')
			{
			$("#txttelefono_destinatario_d").val('')
			$("#txtdireccion_destinatario_d").val('')
			$("#txtpoblacion_destinatario_d").val('')
			$("#txtcp_destinatario_d").val('')
			$("#txtprovincia_destinatario_d").val('')
			$("#txtpais_destinatario_d").val('')
			$("#txtpersona_contacto_destinatario_d").val('')
			$("#txtcomentarios_entrega_destinatario_d").val('')
			}
		}
})

$('#txtdestinatario_d').keydown(function(event){
    //si no controlo el enter hace el submit del formulario
	if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
});

function vaciar_campos_destinatario()
{
	$('#txtdestinatario_d').val('')
	$('#txttelefono_destinatario_d').val('')
	$('#txtdireccion_destinatario_d').val('')
	$('#txtpoblacion_destinatario_d').val('')
	$('#txtcp_destinatario_d').val('')
	$('#txtprovincia_destinatario_d').val('')
	$('#txtpais_destinatario_d').val('')
	$('#txtpersona_contacto_destinatario_d').val('')
	$('#txtcomentarios_entrega_destinatario_d').val('')
	
	$('#txtdestinatario_d').focus()}

</script>


</body>
<%
	'articulos.close
	
	connimprenta.close
	
	set articulos=Nothing
	
	set connimprenta=Nothing

%>
</html>
