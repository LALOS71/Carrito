<%@ language=vbscript %>
<!DOCTYPE html>
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
		Response.ContentType = "text/html"
		'Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
		'Response.CodePage = 65001
		Response.CharSet = "UTF-8"
		
		Response.Buffer = TRUE
		if session("usuario")="" then
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
		end if
		
		'recordsets
		dim articulos
		
		
		if Request.Form("ocultoseleccion_asm_gls")<>"" then
			session("seleccion_asm_gls")=Request.Form("ocultoseleccion_asm_gls")
		end if
		
		
		ver_cadena="" & Request.QueryString("p_vercadena")
		if ver_cadena="" then
			ver_cadena=Request.Form("ocultover_cadena")
		end if
		
		codigo_sap_buscado=Request.Form("txtcodigo_sap")
		articulo_buscado=Request.form("txtdescripcion")
		familia_buscada="" & Request.form("cmbfamilias")
		familias_buscadas_otra="" & Request.Form("cmbfamilias_agrupadas_otra")
		orden_buscado=Request.form("cmborden")
		campo_autorizacion=Request.form("cmbautorizacion")
		descripcion_impresora_buscada=Request.form("txtdescripcion_impresora")
		agrupacion_familia_buscada="" & Request.form("ocultoagrupacion_familias")
		'response.write("<br>AGRUPACION FAMILIA BUSCADA: " & agrupacion_familia_buscada)
		
		accion=Request.QueryString("acciones")
		pto_articulo=Request.form("ocultopto_articulo")
		
		'response.write("<br>accion: " & accion)
		opciones_varias=Split(accion,"--") 

		'para controlar los primeros pedidos de asm-gls, que solo se muestre articulos de gls al modificar el primer pedido
		solo_mostrar_gls="NO"
		pedido_automatico_comprobar=""
		if accion<>"" and session("usuario_codigo_empresa")=4 then
			'response.write("<br>accion(0): " & opciones_varias(0))
			'response.write("<br>accion(1): " & opciones_varias(1))
			'response.write("<br>accion(2): " & opciones_varias(2))
			num_pedido_comprobar=opciones_varias(1)
			if num_pedido_comprobar<>"" then
				set tipo_pedido_modificar=Server.CreateObject("ADODB.Recordset")
				sql="Select pedido_automatico from pedidos where id = " & num_pedido_comprobar  
				with tipo_pedido_modificar
					.ActiveConnection=connimprenta
					.Source=sql
					'response.write("<br>tipo pedido modificar: " & sql)
					.Open
				end with
				pedido_automatico_comprobar=tipo_pedido_modificar("pedido_automatico")
				
				tipo_pedido_modificar.close
				set tipo_pedido_modificar=Nothing
			end if
			
		end if
		if pedido_automatico_comprobar="PRIMER_PEDIDO_REDYSER" then		
			solo_mostrar_gls="SI"
		end if
			
			
		if solo_mostrar_gls="SI" then
			session("seleccion_asm_gls")="GLS"
		end if
		
		'response.write("<br>agrupacion: " & agrupacion_familia_buscada) 
		'response.write("<br>familia buscadan: " & agrupacion_familia_buscada) 
		
		realizar_consulta="SI"
		'si no se filtra por nada que no muestre nada
		if familia_buscada="" and familias_buscadas_otra="" and articulo_buscado="" and codigo_sap_buscado="" and agrupacion_familia_buscada="" and campo_autorizacion="" then
			familia_buscada="TODOS"
			realizar_consulta="NO"
			'si no se filtra por nada, que muestre los articulos que no requieren autorizacion
			campo_autorizacion="NO"
		end if
		'if familia_buscada="" and articulo_buscado="" and codigo_sap_buscado="" then
		'	familia_buscada="TODOS"
		'end if
		
		'if agrupacion_familia_buscada="GLS_TODOS" or agrupacion_familia_buscada="" then
		'	agrupacion_familia_buscada="TODOS"
		'end if
		if agrupacion_familia_buscada="GLS_TODOS" then
			agrupacion_familia_buscada="TODOS"
		end if
		
		
		perfil="" & session("perfil_usuario_directorio_activo")
		
		if ver_cadena="SI" then
			response.write("<br>perfil: " & perfil)
		end if
		
		set familias=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_FAMILIA=0
		CAMPO_EMPRESA_FAMILIA=1
		CAMPO_DESCRIPCION_FAMILIA=2
		with familias
			.ActiveConnection=connimprenta
			.Source="SELECT FAMILIAS.ID, FAMILIAS.CODIGO_EMPRESA,"
			.Source= .Source & " CASE WHEN FAMILIAS_IDIOMAS.DESCRIPCION IS NULL THEN FAMILIAS.DESCRIPCION ELSE" 
			.Source= .Source & " FAMILIAS_IDIOMAS.DESCRIPCION END AS DESCRIPCION_IDIOMA"
			.Source= .Source & " FROM FAMILIAS LEFT OUTER JOIN FAMILIAS_AGRUPADAS"
			.Source= .Source & " ON FAMILIAS.ID = FAMILIAS_AGRUPADAS.ID_FAMILIA"
			.Source= .Source & " LEFT JOIN FAMILIAS_IDIOMAS"
			.Source= .Source & " ON (FAMILIAS.ID=FAMILIAS_IDIOMAS.ID_FAMILIA AND FAMILIAS_IDIOMAS.IDIOMA='" & UCASE(SESSION("idioma")) &"')"
			
			
			.Source= .Source & " WHERE FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			.Source= .Source & " AND FAMILIAS.BORRADO='NO'"
			
			
			.Source= .Source & " AND FAMILIAS.ID NOT IN (SELECT ID_FAMILIA FROM FAMILIAS_PROHIBIDAS WHERE CLIENTE = " & session("usuario") & ")"
			
			if agrupacion_familia_buscada<>"" and agrupacion_familia_buscada<>"TODOS" then
				.Source= .Source & " AND GRUPO_FAMILIAS='" & agrupacion_familia_buscada & "'"
			end if
			
			if session("usuario_codigo_empresa")=30 then
				if perfil<>"TODO" and perfil<>"OPERATIVA" then
					.Source= .Source & " AND (FAMILIAS.ID < 357 OR FAMILIAS.ID > 360)"
				  else
				  	if perfil = "OPERATIVA" then
						.Source= .Source & " AND FAMILIAS.ID >= 357 AND FAMILIAS.ID <= 360"
					end if
				end if
				
			end if
			
			'las familias en asm portugal que no tiene que ver son las de estas agrupaciones
			'if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
			'	.Source= .Source & " AND (GRUPO_FAMILIAS NOT IN ('GLS_PARCELSHOP', 'GLS_PRECINTOS'))"
			'end if
			
			'los productos de navidad se muestran ya a todos
			'QUE NO MUESTRE LA FAMLIA DE PRODUCTOS NAVIDAD EN LAS PROPIAS, SOLO EN FRANQUICIAS DE ESPAÑA
			'if session("usuario_codigo_empresa")=4 and session("usuario_tipo")="AGENCIA" and session("usuario_pais")="ESPAÑA" then
			'	else
			'		.Source= .Source & " AND FAMILIAS.ID<>220"
			'end if
			

			.Source= .Source & " ORDER BY DESCRIPCION_IDIOMA"

			if ver_cadena="SI" then
				response.write("<br>FAMILIAS: " & .source)
			end if
			
			.Open
			vacio_familias=false
			if not .BOF then
				tabla_familias=.GetRows()
			  else
				vacio_familias=true
			end if
		end with

		familias.close
		set familias=Nothing


		set agrupacion_familias=Server.CreateObject("ADODB.Recordset")
		'CAMPO_ID_AGRUPACION_FAMILIA=0
		'CAMPO_EMPRESA_AGRUPACION_FAMILIA=1
		'CAMPO_DESCRIPCION_AGRUPACION_FAMILIA=2
		'CAMPO_ID_FAMILIA_AGRUPACION_FAMILIA=3
		CAMPO_DESCRIPCION_AGRUPACION_FAMILIA=0
		
		
		with agrupacion_familias
			.ActiveConnection=connimprenta
			'.Source="SELECT  ID, ID_EMPRESA, GRUPO_FAMILIAS, ID_FAMILIA"
			.Source="SELECT  DISTINCT GRUPO_FAMILIAS"
			.Source= .Source & " FROM FAMILIAS_AGRUPADAS"
			.Source= .Source & " WHERE ID_EMPRESA=" & session("usuario_codigo_empresa")
			.Source= .Source & " AND BORRADO='NO'"
			
			'se muestran los articulos de navidad solo para las franquicias de España
			if session("usuario_codigo_empresa")=4 and session("usuario_tipo")="AGENCIA" and session("usuario_pais")="ESPAÑA" then
				else
					.Source= .Source & " AND GRUPO_FAMILIAS<>'GLS_PRODUCTOS_NAVIDAD'"
			end if
			.Source= .Source & " ORDER BY GRUPO_FAMILIAS"
			if ver_cadena="SI" then
				response.write("<br>AGRUPACION FAMILIAS: " & .source)
			end if
			.Open
			vacio_agrupacion_familias=false
			if not .BOF then
				tabla_agrupacion_familias=.GetRows()
			  else
				vacio_agrupacion_familias=true
			end if
		end with

		agrupacion_familias.close
		set agrupacion_familias=Nothing


				set agrupacion_familias_otra=Server.CreateObject("ADODB.Recordset")
		'CAMPO_ID_AGRUPACION_FAMILIA=0
		'CAMPO_EMPRESA_AGRUPACION_FAMILIA=1
		'CAMPO_DESCRIPCION_AGRUPACION_FAMILIA=2
		'CAMPO_ID_FAMILIA_AGRUPACION_FAMILIA=3
		CAMPO_GRUPO_FAMILIAS_OTRA=0
		CAMPO_ID_FAMILIAS_OTRA=1
		CAMPO_DESCRIPCION_FAMILIA_OTRA=2
		
		
		with agrupacion_familias_otra
			.ActiveConnection=connimprenta
			.Source="SELECT A.GRUPO_FAMILIAS, A.ID_FAMILIA, B.DESCRIPCION"
			.Source= .Source & " FROM FAMILIAS_AGRUPADAS A"
			.Source= .Source & " INNER JOIN FAMILIAS B"
			.Source= .Source & " ON A.ID_FAMILIA=B.ID"
			.Source= .Source & " WHERE A.ID_EMPRESA=" & session("usuario_codigo_empresa")
			if session("usuario_codigo_empresa")=30 then
				if perfil<>"TODO" and perfil<>"OPERATIVA" then
					.Source= .Source & " AND (B.ID < 357 OR B.ID > 360)"
				  else
				  	if perfil = "OPERATIVA" then
						.Source= .Source & " AND B.ID >= 357 AND B.ID <= 360"
					end if
				end if
			end if
			.Source= .Source & " AND A.BORRADO='NO'"
			.Source= .Source & " ORDER BY A.GRUPO_FAMILIAS, B.DESCRIPCION"

			if ver_cadena="SI" then
				response.write("<br><br>AGRUPACION FAMILIAS OTRA: " & .source)
			end if
			.Open
			vacio_agrupacion_familias_otra=false
			if not .BOF then
				tabla_agrupacion_familias_otra=.GetRows()
			  else
				vacio_agrupacion_familias_otra=true
			end if
		end with

		agrupacion_familias_otra.close
		set agrupacion_familias_otra=Nothing


		
		set tipos_precios=Server.CreateObject("ADODB.Recordset")
		sql="Select tipo_precio from V_CLIENTES where nombre = '" & session("usuario_nombre") & "' and empresa=" & session("usuario_codigo_empresa") 
		with tipos_precios
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
			if ver_cadena="SI" then
				response.write("<br>tipos precios: " & sql)
			end if
			tipo_precio=tipos_precios("tipo_precio")
		end with
		tipos_precios.close
		set tipos_precios=Nothing


		set articulos=Server.CreateObject("ADODB.Recordset")
		
		'PARA QUEDARNOS CON LAS DESCRIPIONES EN INGLES O CASTELLANO
		'(SELECT FAMILIAS.ID, FAMILIAS.CODIGO_EMPRESA,
		'				CASE WHEN FAMILIAS_IDIOMAS.DESCRIPCION IS NULL 
		'				THEN FAMILIAS.DESCRIPCION ELSE FAMILIAS_IDIOMAS.DESCRIPCION END AS DESCRIPCION
		'				FROM FAMILIAS LEFT JOIN FAMILIAS_IDIOMAS
		'				ON (FAMILIAS.ID=FAMILIAS_IDIOMAS.ID_FAMILIA AND FAMILIAS_IDIOMAS.IDIOMA = 'EN')) AS FAMILIAS
		
		'RESPONSE.WRITE("<BR>AGRUPACION_fAMILIA_BUSCADA: " & agrupacion_familia_buscada)
		
		if realizar_consulta="NO" then
			sql="SELECT ID FROM V_EMPRESAS WHERE 1=0" 'PARA QUE NO DEVUELVA NADA SI NO SE INTRODUCEN FILTROS DE BUSQUEDA
		  else
		  	sql= "SELECT CONSULTON.ID, CODIGO_EMPRESA, CODIGO_SAP, CODIGO_EXTERNO,"
			sql=sql & "CASE WHEN DESCRIPCION_GRUPO IS NULL THEN DESCRIPCION_IDIOMA ELSE DESCRIPCION_GRUPO END AS DESCRIPCION_IDIOMA,"
			sql=sql & " TAMANNO, TAMANNO_ABIERTO, TAMANNO_CERRADO, PAPEL, TINTAS, ACABADO, FECHA, COMPROMISO_COMPRA, MOSTRAR," 
			sql=sql & " MULTIARTICULO, UNIDADES_DE_PEDIDO, FAMILIA, nombre_familia, OCULTAR_FAMILIA, REQUIERE_AUTORIZACION, PACKING,"
			sql=sql & " PLANTILLA_PERSONALIZACION, DESCRIPCION, MATERIAL, PERMITE_DEVOLUCION, EN_AVORIS_SOLO_VER, TALLAJES.DESCRIPCION_GRUPO, TALLAJES.DESCRIPCION_TALLA,"
			sql=sql & " TALLAJES.ID_GRUPO, TALLAJES.TEXTO_AGRUPACION, TALLAJES.ORDEN, ARTICULOS_MARCAS.STOCK, ARTICULOS_MARCAS.STOCK_MINIMO,"
			'le añado un campo calculado con las cantidades pendientes leidas de los pedidos
			sql=sql & " (select sum(todo.cantidad_pendiente) as cantidad_pendiente"
			sql=sql & " from"
			sql=sql & " (select articulo as articulo , sum(cantidad) as cantidad_pendiente"
			sql=sql & " From pedidos_detalles"
			sql=sql & " where articulo=CONSULTON.ID"
			sql=sql & " and estado in ('SIN TRATAR', 'EN PROCESO', 'EN PRODUCCION')"
			sql=sql & " GROUP BY articulo"
			sql=sql & " union"
			sql=sql & " select tabla.articulo, sum(tabla.cantidad_pendiente) as cantidad_pendiente"
			sql=sql & " from"
			sql=sql & " (select a.articulo, a.cantidad"
			sql=sql & " ,(a.cantidad - (select sum(cantidad_enviada) from pedidos_envios_parciales"
			sql=sql & " where id_pedido=a.id_pedido and id_articulo=a.articulo and id_articulo=CONSULTON.ID)) as cantidad_pendiente"
			sql=sql & " from pedidos_detalles a"
			sql=sql & " where estado ='ENVIO PARCIAL'"
			sql=sql & " and articulo=CONSULTON.ID) as tabla"
			sql=sql & " group by articulo) todo"
			sql=sql & " group by todo.articulo) AS CANTIDAD_PENDIENTE"		
			'hasta aqui el campo calculado de CANTIDAD_PENDIENTE
			
			'sql=sql & " EXENTO_CONTROL_STOCK"
			
			sql=sql & " FROM (SELECT * FROM"
			sql=sql & " (SELECT ARTICULOS.ID, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, ARTICULOS.CODIGO_SAP, ARTICULOS.CODIGO_EXTERNO,"
			sql=sql & " CASE WHEN ARTICULOS_IDIOMAS.DESCRIPCION IS NULL THEN ARTICULOS.DESCRIPCION ELSE" 
			sql=sql & " ARTICULOS_IDIOMAS.DESCRIPCION END AS DESCRIPCION_IDIOMA,"
			sql=sql & " ARTICULOS.TAMANNO, ARTICULOS.TAMANNO_ABIERTO, ARTICULOS.TAMANNO_CERRADO,"
			sql=sql & " ARTICULOS.PAPEL, ARTICULOS.TINTAS, ARTICULOS.ACABADO, ARTICULOS.FECHA, ARTICULOS.COMPROMISO_COMPRA,"
			sql=sql & " ARTICULOS.MOSTRAR, ARTICULOS.MULTIARTICULO, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS_EMPRESAS.FAMILIA,"
			sql=sql & " FAMILIAS.DESCRIPCION AS nombre_familia, MAX(FAMILIAS.BORRADO) AS OCULTAR_FAMILIA"
			sql=sql & " , MAX(ARTICULOS.REQUIERE_AUTORIZACION) AS REQUIERE_AUTORIZACION, MAX(ARTICULOS.PACKING) AS PACKING"
			sql=sql & ", MAX(ARTICULOS_PERSONALIZADOS.PLANTILLA_PERSONALIZACION) AS PLANTILLA_PERSONALIZACION,"
			sql=sql & " ARTICULOS_IDIOMAS.DESCRIPCION, ARTICULOS.MATERIAL, MAX(ARTICULOS.PERMITE_DEVOLUCION) AS PERMITE_DEVOLUCION"
			sql=sql & ", MAX(ARTICULOS.EN_AVORIS_SOLO_VER) AS EN_AVORIS_SOLO_VER" 
			
			sql=sql & " FROM ARTICULOS INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO "
			'sql=sql & " INNER JOIN FAMILIAS 
			sql=sql & " INNER JOIN" 
			sql=sql & " (SELECT FAMILIAS.ID, FAMILIAS.CODIGO_EMPRESA, FAMILIAS.BORRADO"
			sql=sql & "       , CASE WHEN FAMILIAS_IDIOMAS.DESCRIPCION IS NULL" 
			sql=sql & "           THEN FAMILIAS.DESCRIPCION ELSE FAMILIAS_IDIOMAS.DESCRIPCION END AS DESCRIPCION"
			sql=sql & "        FROM FAMILIAS LEFT JOIN FAMILIAS_IDIOMAS"
			sql=sql & "        ON (FAMILIAS.ID=FAMILIAS_IDIOMAS.ID_FAMILIA AND FAMILIAS_IDIOMAS.IDIOMA = '" & UCASE(SESSION("idioma")) &"')) AS FAMILIAS"
			
			sql=sql & " ON ARTICULOS_EMPRESAS.FAMILIA = FAMILIAS.ID "
			sql=sql & " INNER JOIN CANTIDADES_PRECIOS ON ARTICULOS.ID = CANTIDADES_PRECIOS.CODIGO_ARTICULO "
			sql=sql & " LEFT JOIN ARTICULOS_PERSONALIZADOS ON ARTICULOS.ID=ARTICULOS_PERSONALIZADOS.ID_ARTICULO"
			sql=sql & " LEFT JOIN ARTICULOS_IDIOMAS"
			sql=sql & " ON (ARTICULOS.ID=ARTICULOS_IDIOMAS.ID_ARTICULO AND ARTICULOS_IDIOMAS.IDIOMA='" & UCASE(SESSION("idioma")) &"')"
			
			sql=sql & " WHERE ARTICULOS.MOSTRAR='SI'"
			
			'LOS KITS DE PARCELSHOP SOLO SE MUESTRAN PARA LA OFICINA DE GLS 280-19 GLS PARCELSHOP (8994)
			'3988 - NLPAR07002 FLYER CAMPAÑA ESTO NO ES UN REGALO ES 2022, solo se muestran en la 280-19
			'3989 - NLPAR07002 CARTEL CAMPAÑA ESTO NO ES UN REGALO ES 2022, solo se muestran en la 280-19

			'usuario 8994 - GLS PARCELSHOP, para que solo a este le salgan sus articulos especiales
			if session("usuario")<>8994 then
				sql=sql & " AND (ARTICULOS.ID < 3765 OR ARTICULOS.ID > 3788)  AND ARTICULOS.ID<>3988  AND ARTICULOS.ID<>3989"
			end if
			
			sql=sql & " AND CANTIDADES_PRECIOS.TIPO_SUCURSAL='" & tipo_precio & "'"	
			sql=sql & " AND CANTIDADES_PRECIOS.CODIGO_EMPRESA = " & session("usuario_codigo_empresa") 
			sql=sql & " AND ARTICULOS_EMPRESAS.CODIGO_EMPRESA = " & session("usuario_codigo_empresa") 
			sql=sql & " AND ARTICULOS_EMPRESAS.FAMILIA NOT IN (SELECT ID_FAMILIA FROM FAMILIAS_PROHIBIDAS WHERE CLIENTE = " & session("usuario") & ")"
			
			'response.write("<br>antes de agrupacionfamilia_buscada")
			if agrupacion_familia_buscada<>"" then
				sql=sql & " AND ARTICULOS_EMPRESAS.FAMILIA IN (SELECT ID_FAMILIA FROM FAMILIAS_AGRUPADAS"
				sql=sql & " WHERE (ID_EMPRESA = " & session("usuario_codigo_empresa") & ")"


				'response.write("<br>antes session usuario_codigo_empresa")
				'si es una oficina de asm, tiene que haber seleccionado antes que familias van a poder pedir, o de gls o de asm
				if session("usuario_codigo_empresa")=4 then		
					'response.write("<br>antes seleccion gls")	
					'los de portugal no diferencian la gama gls y la asm
					if session("usuario_pais")<>"PORTUGAL" then
						if session("seleccion_asm_gls")="GLS" then
							sql=sql & " AND (GRUPO_FAMILIAS LIKE '%GLS%')" 
							sql=sql & " AND (GRUPO_FAMILIAS <> 'GLS PARCELSHOP')" 
						end if
						'response.write("<br>antes seleccion gls parcel")	
						if session("seleccion_asm_gls")="GLS_PARCELSHOP" then
							sql=sql & " AND (GRUPO_FAMILIAS = 'GLS PARCELSHOP')" 
						end if
						'response.write("<br>antes seleccion asm")	
						if session("seleccion_asm_gls")="ASM" then
							'response.write("<br>dentro del if de seleccion asm")	
							sql=sql & " AND (GRUPO_FAMILIAS NOT LIKE '%GLS%')" 
						end if
						'response.write("<br>despues seleccion asm")	
					end if
				end if
				
				'response.write("<br>antes agrupacion familia buscada tododos")	
				if agrupacion_familia_buscada<>"TODOS" then
					sql=sql & " AND (FAMILIAS_AGRUPADAS.GRUPO_FAMILIAS = '" & agrupacion_familia_buscada & "')"
				end if
				
				sql=sql & ")"
			end if
						
						
			
			
			
			'response.write("<br>familia_buscada: " & familia_buscada)
			'AQUI VAN LOS FILTROS POR CODIGOS QUE NO SON MULTILIGÜES
			'por si buscamos familias y subfamilias para halcon, ecuador, etc
			if familias_buscadas_otra<>"" then
				sql=sql & " AND ARTICULOS_EMPRESAS.FAMILIA IN (" & familias_buscadas_otra & ")"
			  else
				if familia_buscada<>"TODOS" and familia_buscada<>"" then
					'response.write("<br>entro a asignar familia: " & familia_buscada)
					sql=sql & " AND ARTICULOS_EMPRESAS.FAMILIA=" & familia_buscada
				end if
			end if
			if codigo_sap_buscado<>"" then
				sql=sql & " AND ARTICULOS.CODIGO_SAP LIKE '%" & codigo_sap_buscado & "%'"
			end if
			if campo_autorizacion="SI" then
				sql=sql & " AND ARTICULOS.REQUIERE_AUTORIZACION='SI'"
			end if
			if campo_autorizacion="NO" then
				sql=sql & " AND (ARTICULOS.REQUIERE_AUTORIZACION='NO' OR ARTICULOS.REQUIERE_AUTORIZACION IS NULL)"
			end if
			
						
			
			sql=sql & " GROUP BY ARTICULOS.ID, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, ARTICULOS.CODIGO_SAP, ARTICULOS.CODIGO_EXTERNO,"
			sql=sql & " ARTICULOS.DESCRIPCION, ARTICULOS.TAMANNO, ARTICULOS.TAMANNO_ABIERTO, ARTICULOS.TAMANNO_CERRADO,"
			sql=sql & " ARTICULOS.PAPEL, ARTICULOS.TINTAS, ARTICULOS.MATERIAL, ARTICULOS.ACABADO, ARTICULOS.FECHA,"
			sql=sql & " ARTICULOS.COMPROMISO_COMPRA, ARTICULOS.MOSTRAR, ARTICULOS.MULTIARTICULO, ARTICULOS.UNIDADES_DE_PEDIDO,"
			sql=sql & "  ARTICULOS_EMPRESAS.FAMILIA, FAMILIAS.DESCRIPCION, ARTICULOS_IDIOMAS.DESCRIPCION"
			sql=sql & " ) AS ART"

 			sql=sql & " WHERE 1=1"
			sql=sql & " AND OCULTAR_FAMILIA='NO'"
			
			'la familia de vestuario con el nuevo logo se muestra
			'  - a las franquicias de españa y portugal
			'  - solo a la agencia propia 280-5 COMPRAS (5089) y 280-51 GLS PERDIDAS (7395)
			if session("usuario_codigo_empresa")=4 then
				if session("usuario_tipo")= "GLS PROPIA" AND session("usuario")<>5089 AND session("usuario")<>7395 then
					sql=sql & " AND FAMILIA<>318"
				end if
				'la familia de GLS ROPA NUEVA LINEA (244) solo la ven las propias
				if session("usuario_tipo")<> "GLS PROPIA" then
					sql=sql & " AND FAMILIA<>244"
				end if
				'la familia de GLS ROPA NUEVA LINEA (244) no se ve en portugal
				if session("usuario_pais")="PORTUGAL" then
					sql=sql & " AND FAMILIA<>244"
				end if
			end if
			
			'GROUNDFORCE CONTROLA EL PERFIL DE ENTRADA DE SUS USUARIOS (OFICINA, OPERATIVA Y TODO)
			if session("usuario_codigo_empresa")=30 then
				if perfil<>"TODO" and perfil<>"OPERATIVA" then
					sql = sql & " AND (FAMILIA < 357 OR FAMILIA > 360)"
				  else
				  	if perfil = "OPERATIVA" then
						sql = sql & " AND FAMILIA >= 357 AND FAMILIA <= 360"
					end if
				end if
			end if

			'si es del tipo REDYSER y es su primer pedido, no se muestran todos los articulos
			' solo los de unas pocas familias, y tampoco las tarjetas 2745
			if session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI" then
				sql=sql & " AND (ART.nombre_familia in ('GLS SEGURIDAD', 'GLS ROTULACION', 'GLS DECORACION', 'GLS ROPA NUEVA LINEA', 'GLS VESTUARIO NEGOCIOS', 'GLS VEHICULOS', 'GLS CORPORATIVO', 'GLS MARKETING'))"
			end if

			'ahora no se muestran las tarjetas para las oficinas de REDYSER hasta nuevo aviso
			if session("usuario_trato_especial")=1 then
				sql=sql & " AND ART.id NOT IN (2440, 2706, 2745, 561, 601, 716)"
			end if


			'para que en el caso de asm, al aplicar los filtros y nos las agrupaciones, tambien tenga
			' en cuenta que tiene que mostrar solo lo de asm, o gls, o parcelshop
			if session("usuario_codigo_empresa")=4 then		
				'para portugal no diferencian entre gama gls y gama asm
				if session("usuario_pais")<>"PORTUGAL" then
					if session("seleccion_asm_gls")="GLS" then
						sql=sql & " AND (ART.nombre_familia LIKE '%GLS%')" 
						sql=sql & " AND (ART.nombre_familia <> 'GLS PARCELSHOP')" 
					end if
					if session("seleccion_asm_gls")="GLS_PARCELSHOP" then
						sql=sql & " AND (ART.nombre_familia = 'GLS PARCELSHOP')" 
					end if
					if session("seleccion_asm_gls")="ASM" then
						sql=sql & " AND (ART.nombre_familia NOT LIKE '%GLS%')" 
					end if
				  else 'portugal no ve la familia del vestuario nuevo logo preventa ni los productos de navidad
				  	if session("usuario_tipo")= "GLS PROPIA" then
						sql=sql & " AND (ART.nombre_familia <> 'GLS VESTUARIO NUEVO LOGO')"
					end if
					sql=sql & " AND (ART.nombre_familia <> 'GLS PRODUCTOS NAVIDAD')"
				end if
				'se muestran los articulos de navidad para todo GLS
				'if session("usuario_tipo")="AGENCIA" and session("usuario_pais")="ESPAÑA" then
				'	else
				'		sql=sql & " AND ART.nombre_familia<>'GLS PRODUCTOS NAVIDAD'"
				'end if
			end if

			
 			'AQUI VAN LOS FILTROS DE BUSQUEDA CON TEXTOS MULTILINGüES
			if articulo_buscado<>"" then
				'sql=sql & " and descripcion like ""*" & articulo_buscado & "*"""
				'sql=sql & " AND ARTICULOS.DESCRIPCION LIKE '%" & articulo_buscado & "%'"
				'sql=sql & " and (ART.DESCRIPCION_IDIOMA like '%" & articulo_buscado & "%'"
				sql=sql & " and (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(ART.DESCRIPCION_IDIOMA),'Á','A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U')"
				sql=sql & " like '%" & REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UCASE(articulo_buscado),"Á","A"), "É", "E"), "Í", "I"), "Ó", "O"), "Ú", "U") & "%'"



					'BUSCAMOS LA DESCRIPCION DEL ARTICULO O EN LOS DATOS ASOCIADOS COMO COMPONENTE
					'	-impresora asociada
					'	-color del cartucho
					'	-referencia
					sql=sql & " OR ART.ID IN (SELECT ID_ARTICULO FROM DESCRIPCIONES_MULTIARTICULOS"
					sql=sql & " WHERE (CARACTERISTICA = 'IMPRESORA' OR CARACTERISTICA = 'COLOR' OR CARACTERISTICA = 'REFERENCIA')" 
					sql=sql & " AND (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(DESCRIPCION),'Á','A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U')"
					sql=sql & " LIKE '%" & REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UCASE(articulo_buscado),"Á","A"), "É", "E"), "Í", "I"), "Ó", "O"), "Ú", "U") & "%'))"
					
				sql=sql & ")"
			end if

			'ESTABLECEMOS EL ORDEN
			'YA NO LO PONEMOS... VA A SER ORDENADO SOLO POR LA DESCRIPCION
			'IF orden_buscado="NOMBRE" then
			'	'sql=sql & " ORDER BY ARTICULOS.COMPROMISO_COMPRA DESC, ARTICULOS.CODIGO_SAP"
			'	sql=sql & " ORDER BY ART.DESCRIPCION_IDIOMA"
			'  ELSE
			'  	'sql=sql & " ORDER BY ARTICULOS.COMPROMISO_COMPRA DESC, ARTICULOS.DESCRIPCION"
			'	sql=sql & " ORDER BY ART.CODIGO_SAP"
			'END IF
			
			sql=sql & ") AS CONSULTON"
			sql=sql & " LEFT JOIN TALLAJES"
			sql=sql & " ON TALLAJES.ID_ARTICULO=CONSULTON.ID"
			sql=sql & " LEFT JOIN ARTICULOS_MARCAS"
			sql=sql & " ON ARTICULOS_MARCAS.ID_ARTICULO=CONSULTON.ID"
			'se pone al final, que sino, falla el union
			'sql=sql & " ORDER BY DESCRIPCION_IDIOMA, DESCRIPCION_GRUPO, TALLAJES.ORDEN"



			'2023-03-02 - AHORA TODAS LAS FRANQUICIAS DE GLS PUEDEN PEDIR ESTOS ARTICULOS DE LA FAMILIA GLS SEGURIDAD, Y DE LAS PROPIAS, SOLO COMPRAS 280-5 (5089)
			'	Botas de seguiridad - id grupo tallaje - 2
			'   Punteras - id grupo tallaje - 63
			'   Zapatos de seguiridad - id grupo tallaje - 1
			'   ZAPATOS DE SEGURIDAD NUEVOS - ZAPATO DE SEGURIDAD S3 LOGO GLS - id grupo de tallaje - 262
			if session("usuario_codigo_empresa")=4 and session("usuario")<>5089 and session("usuario_tipo")= "GLS PROPIA" then
				sql=sql & " WHERE ((ID_GRUPO<>2 AND ID_GRUPO<>63 AND ID_GRUPO<>1 AND ID_GRUPO<>262) OR ID_GRUPO='' OR ID_GRUPO IS NULL)"
				'sql=sql & " WHERE (ID_GRUPO<>63 OR ID_GRUPO='' OR ID_GRUPO IS NULL)"
			end if


			' la oficina 9825 - 231 GLS GUARROMAN que es franquicia, puede pedir 
			' el articulo 3418 - RPOPE0610 - PRECINTO DE SEGURIDAD TRAILER, que tienen las propias
			' ahora el articulos es nuevo, 3676 - NLOPE0610 -  PRECINTO DE SEGURIDAD TRAILER
			' de la familia GLS_OPERACIONES. codigo 204 y con el precio de propias
			'response.write("<br>....agrupacion familia buscada....: " & agrupacion_familia_buscada)
			'response.write("<br>....familia buscada....: " & familia_buscada)
			if session("usuario")=9825 then
				sql_aux= " UNION"
				sql_aux=sql_aux & " SELECT A.ID , 4 AS CODIGO_EMPRESA, A.CODIGO_SAP, A.CODIGO_EXTERNO, A.DESCRIPCION AS DESCRIPCION_IDIOMA, A.TAMANNO, A.TAMANNO_ABIERTO"
				sql_aux=sql_aux & ", A.TAMANNO_CERRADO, A.PAPEL, A.TINTAS, A.ACABADO, A.FECHA, A.COMPROMISO_COMPRA, A.MOSTRAR, A.MULTIARTICULO, A.UNIDADES_DE_PEDIDO"
				sql_aux=sql_aux & ", (SELECT FAMILIA FROM ARTICULOS_EMPRESAS WHERE CODIGO_EMPRESA=4 AND ID_ARTICULO=3676 ) AS FAMILIA"
				sql_aux=sql_aux & ", (SELECT FAMILIAS.DESCRIPCION FROM FAMILIAS INNER JOIN ARTICULOS_EMPRESAS ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA"
				sql_aux=sql_aux & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=4 AND ARTICULOS_EMPRESAS.ID_ARTICULO=3676) AS NOMBRE_FAMILIA"
				sql_aux=sql_aux & ", (SELECT FAMILIAS.BORRADO FROM FAMILIAS INNER JOIN ARTICULOS_EMPRESAS ON FAMILIAS.ID=ARTICULOS_EMPRESAS.FAMILIA WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA=4"
				sql_aux=sql_aux & " AND ARTICULOS_EMPRESAS.ID_ARTICULO=3676) AS OCULTAR_FAMILIA"
				sql_aux=sql_aux & ", A.REQUIERE_AUTORIZACION, A.PACKING"
				sql_aux=sql_aux & ", (SELECT PLANTILLA_PERSONALIZACION FROM ARTICULOS_PERSONALIZADOS WHERE ID_ARTICULO=3676) AS PLANTILLA_PERSONALIZACION"
				sql_aux=sql_aux & ", NULL AS DESCRIPCION, A.MATERIAL, A.PERMITE_DEVOLUCION, A.EN_AVORIS_SOLO_VER"
				sql_aux=sql_aux & ", (SELECT DESCRIPCION_GRUPO FROM TALLAJES WHERE ID_ARTICULO=3676) AS DESCRIPCION_GRUPO"
				sql_aux=sql_aux & ", (SELECT DESCRIPCION_TALLA FROM TALLAJES WHERE ID_ARTICULO=3676) AS DESCRIPCION_TALLA"
				sql_aux=sql_aux & ", (SELECT ID_GRUPO FROM TALLAJES WHERE ID_ARTICULO=3676) AS ID_GRUPO"
				sql_aux=sql_aux & ", (SELECT TEXTO_AGRUPACION FROM TALLAJES WHERE ID_ARTICULO=3676) AS TEXTO_AGRUPACION"
				sql_aux=sql_aux & ", (SELECT ORDEN FROM TALLAJES WHERE ID_ARTICULO=3676) AS ORDEN"
				sql_aux=sql_aux & ", (SELECT STOCK FROM ARTICULOS_MARCAS WHERE ID_ARTICULO=3676 AND MARCA='STANDARD') AS STOCK"
				sql_aux=sql_aux & ", (SELECT STOCK_MINIMO FROM ARTICULOS_MARCAS WHERE ID_ARTICULO=3676 AND MARCA='STANDARD') AS STOCK_MINIMO"
				sql_aux=sql_aux & ", (select sum(todo.cantidad_pendiente) as cantidad_pendiente"
				sql_aux=sql_aux & " from (select articulo as articulo , sum(cantidad) as cantidad_pendiente"
				sql_aux=sql_aux & " From pedidos_detalles where articulo=3676 and estado in ('SIN TRATAR', 'EN PROCESO', 'EN PRODUCCION') GROUP BY articulo"
				sql_aux=sql_aux & " union"
				sql_aux=sql_aux & " select tabla.articulo, sum(tabla.cantidad_pendiente) as cantidad_pendiente"
				sql_aux=sql_aux & " from (select a.articulo, a.cantidad ,(a.cantidad - (select sum(cantidad_enviada) from pedidos_envios_parciales"
				sql_aux=sql_aux & " where id_pedido=a.id_pedido and id_articulo=a.articulo and id_articulo=3676)) as cantidad_pendiente"
				sql_aux=sql_aux & " from pedidos_detalles a where estado ='ENVIO PARCIAL' and articulo=3676) as tabla group by articulo)"
				sql_aux=sql_aux & " todo group by todo.articulo) AS CANTIDAD_PENDIENTE"
				sql_aux=sql_aux & " FROM ARTICULOS A"
				sql_aux=sql_aux & " WHERE A.ID=3676"
				
				'de la familia GLS SEGURIDAD, solo la oficina 280-5 COMPRAS (5089) puede pedir los siguientes articulos
				'	Botas de seguiridad - id grupo tallaje - 2
				'   Punteras - id grupo tallaje - 63
				'   Zapatos de seguiridad - id grupo tallaje - 1
				'sql_aux=sql_Aux & " AND ((ID_GRUPO<>2 AND ID_GRUPO<>63 AND ID_GRUPO<>1) OR ID_GRUPO='' OR ID_GRUPO IS NULL)"
				
				if agrupacion_familia_buscada<>"TODOS" and agrupacion_familia_buscada<>"GLS_OPERACIONES" and agrupacion_familia_buscada<>"" then
					sql_aux=sql_aux & " AND  A.ID<>3676"
				end if
				if familia_buscada<>"TODOS" and familia_buscada<>"204" then
					sql_aux=sql_aux & " AND  A.ID<>3676"
				end if
		
				if codigo_sap_buscado<>"" then
					sql_aux=sql_aux & " AND A.CODIGO_SAP LIKE '%" & codigo_sap_buscado & "%'"
				end if
				if campo_autorizacion="SI" then
					sql_aux=sql_aux & " AND A.REQUIERE_AUTORIZACION='SI'"
				end if
				if campo_autorizacion="NO" then
					sql_aux=sql_aux & " AND (A.REQUIERE_AUTORIZACION='NO' OR A.REQUIERE_AUTORIZACION IS NULL)"
				end if
				if articulo_buscado<>"" then
					sql_aux=sql_aux & " AND (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(A.DESCRIPCION),'Á','A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U')"
					sql_aux=sql_aux & " LIKE '%" & REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UCASE(articulo_buscado),"Á","A"), "É", "E"), "Í", "I"), "Ó", "O"), "Ú", "U") & "%')"
				end if
				sql= sql & sql_aux
			end if
							

			if session("usuario_codigo_empresa")=260 then
				sql=sql & " ORDER BY CODIGO_SAP, DESCRIPCION_IDIOMA, DESCRIPCION_GRUPO, TALLAJES.ORDEN"
			  else
			  	sql=sql & " ORDER BY DESCRIPCION_IDIOMA, DESCRIPCION_GRUPO, TALLAJES.ORDEN"
			end if


		end if		'fin if de la cadena de consulta de articulos
		
		
		


		if ver_cadena="SI" then
 			response.write("<br>...agrupacion familia buscada: " & agrupacion_familia_buscada)
			response.write("<br>...familias: " & familia_buscada)
			response.write("<br>...familias otra: " & familias_buscadas_otra)
			response.write("<br>...Consulta articulos: " & sql)
			response.write("<br>...Consulta sql aux: " & sql_aux)
		end if		
		with articulos
			.ActiveConnection=connimprenta
			
			.Source=sql
			
			.Open
		end with
		
		dim hoteles

		
		'if familia_buscada="0" then
		'	familia_buscada=""
		'end if
		
		
		
set carrusel=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_CARRUSEL=0
		CAMPO_ORDEN_CARRUSEL=1
		CAMPO_EMPRESAS_CARRUSEL=2
		CAMPO_FICHERO_CARRUSEL=3
		with carrusel
			.ActiveConnection=connimprenta
			.Source="SELECT ID_CARRUSEL, ORDEN, EMPRESAS, FICHERO"
			.Source= .Source & " FROM CARRUSEL"
			.Source= .Source & " WHERE EMPRESAS LIKE '%###" & session("usuario_codigo_empresa") & "###%'"
			.Source= .Source & " ORDER BY ORDEN, ID_CARRUSEL"
			'response.write("<br>FAMILIAS: " & .source)
			.Open
			vacio_carrusel=false
			if not .BOF then
				tabla_carrusel=.GetRows()
			  else
				vacio_carrusel=true
			end if
		end with

		carrusel.close
		set carrusel=Nothing
		
		
		'response.write("<br>realizar consulta: " & realizar_consulta)
		
	dinero_disponible_devoluciones=0	
	set disponible_devoluciones=Server.CreateObject("ADODB.Recordset")
		CAMPO_DISPONIBLE=0
		with disponible_devoluciones
			.ActiveConnection=connimprenta
			.Source="select ROUND((ISNULL(SUM(TOTAL_ACEPTADO),0) - ISNULL(SUM(TOTAL_DISFRUTADO),0)),2) as DISPONIBLE"
			.Source= .Source & " FROM DEVOLUCIONES"
			.Source= .Source & " WHERE CODCLI = " & session("usuario") 
			.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO IS NULL" 
			.Source= .Source & " AND ESTADO='CERRADA'"
			'response.write("<br>FAMILIAS: " & .source)
			.Open
		end with

		if not disponible_devoluciones.eof then
			dinero_disponible_devoluciones=disponible_devoluciones("DISPONIBLE")	
		end if
		disponible_devoluciones.close
		set disponible_devoluciones=Nothing

		
		
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
			'response.write("<br>SALDOS: " & .source)
			.Open
		end with

		if not disponible_saldos.eof then
			dinero_disponible_saldos=disponible_saldos("DISPONIBLE")	
		end if
		disponible_saldos.close
		set disponible_saldos=Nothing
		
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title><%=lista_articulos_gag_title%></title>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<!--<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-select/css/bootstrap-select.min.css">-->

<link rel="stylesheet"  type="text/css" href="../plugins/bootstrap-selectpicker-1.13.14/dist/css/bootstrap-select.css">


<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />

<!--<link rel="stylesheet"  type="text/css" href="../plugins/bootstrap-multiselect/bootstrap-multiselect.css">-->

<script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>


<style>
body {padding-top: 10px; margin:0px; background-color:#fff;}

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
  

/*
.centrado_vertical{
    float:none;
    display:inline-block;
    vertical-align:middle;
    margin-right:-4px;
}
*/


@media screen and (min-width: 725px){
   #columna_izquierda_fija{
       position: fixed;
   }
} 

.panel_conmargen
	{
	padding-left:5px; 
	padding-right:5px; 
	padding-bottom:5px; 
	padding-top:5px;
	}
	
.panel_sinmargen
	{
	padding-left:0px; 
	padding-right:0px; 
	padding-bottom:0px; 
	padding-top:0px;
	}
	
.panel_sinmargen_lados
	{
	padding-left:0px; 
	padding-right:0px; 
	}
	
.panel_sinmargen_arribaabajo
	{
	padding-bottom:0px; 
	padding-top:0px;
	}

.panel_connmargen_lados
	{
	padding-left:5px; 
	padding-right:5px; 
	}
	
.panel_conmargen_arribaabajo
	{
	padding-bottom:5px; 
	padding-top:5px;
	}

/*para que quite la sombra del panel*/	
.inf_general_art, .inf_pack_stock
	{
	-webkit-box-shadow: none;
    box-shadow: none;
	}


.table-borderless td,
.table-borderless th {
    border: 0px !important;
}

.row_articulos___ {
    display: table;
}
.row_articulos____ [class*="col-"] {
    display: table-cell;
    float: none;
}

.popover {
  max-width: 1000px;
}

.popover_resumen_articulos {
  max-width: 1000px;
}

#popover_resumen_articulos .popover {
  max-width: 1000px;
}


/*para el combo multiselect de familias y subfamilias*/ 
.dropdown-header {
  font-weight: bold !important;
  /*color: #fff !important;*/
  color: #000 !important;
  text-transform: uppercase;
}

.special {
  color: #000 !important;
}

.glyphicon_rotado {
        -moz-transform: scaleX(-1);
        -o-transform: scaleX(-1);
        -webkit-transform: scaleX(-1);
        transform: scaleX(-1);
        filter: FlipH;
        -ms-filter: "FlipH";
}


.vcenter {
   display: inline-block;
   vertical-align: middle;
   float: none;
}


@media (min-width: 1200px) {

     .table-container {
        display: table;
        table-layout: fixed;
        width: 100%;
    }

    .table-container .col-table-cell {
        display: table-cell;
        vertical-align: middle;
        float: none;
    }
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
    }
</style>

<script src="../funciones.js" type="text/javascript"></script>


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
    try { //Primero se prueba con la mas reciente versión para IE
      Ajax = new ActiveXObject("Msxml2.XMLHTTP");
     } catch (e) {
       try { //Si el explorer no esta actualizado se prueba con la versión anterior
         Ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {}
      }
   }
 
  if (!Ajax) {
    alert('<%=lista_articulos_gag_error_ajax%>');
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

</script>




<script language="javascript">
function comprobar_numero_entero(dato)
{
		var cadenachequeo = "0123456789"; 
  		var valido = true; 
  		var lugaresdecimales = 0; 
  		var cadenacompleta = ""; 
		for (i = 0; i < dato.length; i++)
		 { 
    		ch = dato.charAt(i); 
    		for (j = 0; j < cadenachequeo.length; j++) 
      			if (ch == cadenachequeo.charAt(j))
        			break; 
    		if (j == cadenachequeo.length)
			 { 
      			valido = false; 
      			break; 
    		 } 
    		cadenacompleta += ch; 
  		 } 
  	
		if ((!valido) || (dato=='') || (dato<=0))
		 	return (false)
  		  else
		  	return (true);

}

function annadir_al_carrito(articulo, accion, id_grupo, cantidad_minima_tramo, tipo_precio, codigo_empresa, compromiso_compra)
{
	//console.log('dentro de añadir al carrito....')
	//console.log('valor de parametro articulo: ' + articulo)
	//console.log('valor de parametro accion: ' + accion)
	//console.log('valor de parametro id_grupo: ' + id_grupo)
	
	seleccionadas_cantidades='SI'
	seleccionadas_tallas='SI'
	cadena=''
	
	
	//alert('hola primero')
	//para que si no existe el objeto porque no hay precios grabados para este articulo
	//   no de error de javascript
	// oculto_cantidades_precios_xxxx contendrá una lista de parametros separados por dos guiones
	// cantidad--precio_unidad--precio pack--personalizado(kit parcelshop)
    if (document.getElementById('ocultocantidades_precios_' + articulo))
	{
	//console.log('existe ocultocantidades_precios_' + articulo)
	//if (document.getElementById('ocultocantidades_precios_' + articulo).value=='')
	//cuando hay cuadro de texto con cantidades, debe rellenarse la cantidad
	if (document.getElementById('txtcantidad_' + articulo))
		{
		//console.log('TENEMOS CAJA DE TEXTO CON CANTIDADES\n txtcantidad_' + articulo)
		if (document.getElementById('txtcantidad_' + articulo).value=='')
			{
			seleccionadas_cantidades='NO'
			//console.log('txtcantidad_' + articulo + ' está vacia')
			}
		  else
		  	{
			if (parseFloat(document.getElementById('txtcantidad_' + articulo).value) < parseFloat(cantidad_minima_tramo))
				{
				seleccionadas_cantidades='MINIMO'
				}
			}
		}
	  else //si no hay caja de texto para cantidades, es porque hay tabla para seleccionar cantidades/precios
	  	{
		//console.log('TENEMOS TABLA DE CANTIDADES-PRECIOS')
		seleccionadas_cantidades='NO'
		$('#tabla_cantidades_precios_' + articulo + ' tbody tr').each(function (index) 
        	{
			//console.log('colorcito fila ' + index + ': ' + $(this).css('font-weight'))
			if (($(this).css('font-weight')=='bold') || ($(this).css('font-weight')=='700'))
				{
					seleccionadas_cantidades='SI'
					//console.log('.....encontramos fila activada')
				}
			
			});
		}

	//console.log('seleccioandas_cantidades: ' + seleccionadas_cantidades)
	
	if (seleccionadas_cantidades=='NO')	
		{
		//alert('Para Añadir El Artículo al Carrito ha de Seleccionar Las Cantidades/Precios del Mismo')
		cadena='<br><BR><H4><%=lista_articulos_gag_error_annadir_carrito%></H4><BR><br>'
		}
	
	if (seleccionadas_cantidades=='MINIMO')	
		{
		//alert('Para Añadir El Artículo al Carrito ha de Seleccionar Las Cantidades/Precios del Mismo')
		cadena='<br><BR><H4>La Cantidad M&iacute;nima es de ' + cantidad_minima_tramo + '</H4><BR><br>'
		}
	
	//cuando hay un tallaje, tiene que seleccionarse la talla antes de pulsar el boton de añadir	
	
	if (id_grupo!='')	
		{
		//console.log('TENEMOS UNA TABLA DE TALLAJES... tabla_tallajes_' + id_grupo)
		seleccionadas_tallas='NO'
		$('#tabla_tallajes_' + id_grupo + ' tbody tr').each(function (index) 
        	{
			//console.log('colorcito fila ' + index + ': ' + $(this).css('font-weight'))
			if (($(this).css('font-weight')=='bold') || ($(this).css('font-weight')=='700'))
				{
					seleccionadas_tallas='SI'
				}
			
			});
		
		if (seleccionadas_tallas=='NO')	
			{
			if (cadena=='')
				{
				cadena = '<br><BR><H4>Se Ha de Seleccionar La Talla/N&uacute;mero del Articulo Ant&eacute;s de A&ntilde;adirlo...</H4><BR><br>'	
				}
			 else
			 	{
				cadena = cadena + '<H4>Se Ha de Seleccionar La Talla/N&uacute;mero del Articulo Ant&eacute;s de A&ntilde;adirlo...</H4><BR><br>'	
				}
			}
		
		}
		
	//console.log('seleccionadas_cantidades: ' + seleccionadas_cantidades)	
	//console.log('seleccionadas_tallas: ' + seleccionadas_tallas)	
		
	if ((seleccionadas_cantidades=='NO') || (seleccionadas_cantidades=='MINIMO') || (seleccionadas_tallas=='NO'))	
		{
		$("#cabecera_pantalla_avisos").html("<%=lista_articulos_gag_ventana_mensajes_cabezera_avisos%>")
		$("#pantalla_avisos .modal-header").show()
		$("#body_avisos").html(cadena + "<br>");
		$("#pantalla_avisos").modal("show");
		}
	  else
		{
		if (document.getElementById('ocultocantidades_precios_' + articulo).value=='OTRAS CANTIDADES')
			{
			//alert('Para poder seleccionar Otras Cantidades/Precios ha de ponerse en contacto con Globalia Artes Graficas')
			//equivalencia de los caracteres especiales y lo que hay que poner en el mailto
			//á é í ó ú Á É Í Ó Ú Ñ ñ ü Ü
			//%E1 %E9 %ED %F3 %FA %C1 %C9 %CD %D3 %DA %D1 %F1 %FC %DC
			//
			//para insertar saltos de linea
			//%0D%0A%0A
			//alert('hola')
			cadena_email='mailto:carlos.gonzalez@globalia-artesgraficas.com'
			cadena_email+= '?subject=Nuevo Escalado Barcel%F3'
			cadena_email+= '&body=Por favor indique el nombre y Referencia. del art%EDculo del que desea que le facilitemos'
			cadena_email+= ' un nuevo escalado y a continuaci%F3n la cantidad requerida.'
			cadena_email+= '%0D%0A%0A En breve la encontrar%E1 colgada en el gestor de pedidos.'
			cadena_email+= '%0D%0A%0AUn saludo.'

			location.href=cadena_email
			}
		  else
		  	{	//si se ha indicado tallaje, se pone el codigo del articulo cuya talla se ha seleccionado
				if (id_grupo!='')
					{
					document.getElementById('ocultoarticulo').value=document.getElementById('ocultotallaje').value
					}
				  else // y si no hay tallaje, se pone simplemente el codigo del articulo
				  	{
					document.getElementById('ocultoarticulo').value=articulo
					}
					
			//console.log('ocultoarticulo: ' + document.getElementById('ocultoarticulo').value)
			//si es uno de los articulos con compromiso de compra, vendra con xxx en las cantidades
			//  tengo que sustituirlo por lo que el usuario introduzca manualmente en la cantidad del
			//  articulo seleccionado
			//alert('cantidades antes: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
			if (compromiso_compra=='TRAMOS')
				{
				cantidad_seleccionada=document.getElementById('txtcantidad_' + articulo).value
		
				//console.log('es un articulo por tramos de precios')
				cadena_url='Obtener_Precio_Tramo_Articulo.asp?codigo_articulo=' + articulo + '&codigo_empresa=' + codigo_empresa
				cadena_url+='&tipo_sucursal=' + tipo_precio + '&cantidad_introducida=' + document.getElementById('txtcantidad_' + articulo).value
				//console.log('url para ver precio: ' + cadena_url)
				$.ajax({
					type: "post",  
					async: false, // La petición es síncrona
					cache: false,      
					url: cadena_url,
					success: function(respuesta) {
								  //console.log('el precio es de: ' + respuesta)
								  //console.log('cambiamos el  contenido de ocultocantidades_precios_' + articulo)
								  //console.log('cantidaddes...: ' + document.getElementById('txtcantidad_' + articulo).value)
								  //console.log('cantidad_seleccionada: ' + cantidad_seleccionada)
								  //console.log('precios...: ' + respuesta)
								  document.getElementById('ocultocantidades_precios_' + articulo).value= cantidad_seleccionada + ' -- ' + respuesta
								},
					error: function() {
							bootbox.alert({
								message: "Se ha producido un error al tramitar los precios",
								//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
								callback: refrescar_stock()
							})
						}
				});
				//document.getElementById('ocultocantidades_precios_' + articulo).value= document.getElementById('txtcantidad_' + articulo).value + ' -- 999,99'
				}
				
			//console.log('ocultocantidades_precios_' + articulo + ' antes: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)

			if (document.getElementById('ocultocantidades_precios_' + articulo).value.indexOf('XXX')!=-1) 
				{
				//console.log('no tiene xxxx en ocultocantidades_precios_' + articulo)
				//console.log('antes de comprobarnuemeroentero para txtcantidad_' + articulo + ': ' + document.getElementById('txtcantidad_' + articulo).value)
				if (comprobar_numero_entero(document.getElementById('txtcantidad_' + articulo).value))
					{
					//console.log('valor de ocultocantidades_precios_' + articulo + ' antes de quitar posibles xxxx: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
					document.getElementById('ocultocantidades_precios_' + articulo).value=document.getElementById('ocultocantidades_precios_' + articulo).value.replace('XXX',document.getElementById('txtcantidad_' + articulo).value)
					
					//console.log('valor de ocultocantidades_precios antes de asignacion: ' + document.getElementById('ocultocantidades_precios').value)
					//si es un tallaje, cojo el precio correspondiente a la talla seleccionada en la tabla de tallajes y tambien le pongo las cantidades
					if (id_grupo!='')
						{
						document.getElementById('ocultocantidades_precios').value=document.getElementById('txtcantidad_' + articulo).value + '--' + document.getElementById('ocultoprecio_tallaje_seleccionado').value
						}
					  else
					  	{
						document.getElementById('ocultocantidades_precios').value=document.getElementById('ocultocantidades_precios_' + articulo).value
						}
					//alert('cantidades despues: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
					//console.log('valor de ocultocantidades_precios_' + articulo + ' despues: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
					//console.log('valor de ocultocantidades_precios despues de la asignacion: ' + document.getElementById('ocultocantidades_precios').value)

					//no hacemos el submit del formulario porque se vuelve a refrescar la pantalla con todos los
					//   articulos y como ya hay muchos, tarda horrores
					//document.getElementById('frmannadir_al_carrito').submit()
					
					personalizado='NO'
					$('.chkpersonalizar_kit').each(function (index) 
						{
						//console.log('colorcito fila ' + index + ': ' + $(this).css('font-weight'))
						datos=this.id.replace('chkpersonalizar_kit_','')
						datos=datos.split('_')
						//console.log('desde añadir al carrito.... id articulo chk: ' + datos[0])
						//console.log('desde añadir al carrito..... tallaje chk: ' + datos[1])
						//console.log('desde añadir al carrito... tallaje: ' + id_grupo)
						
						if (id_grupo==datos[1])
							{
							//console.log('desde añadir al carrito... coinciden tallaje y chk: ' + id_grupo)
							//console.log('desde añadir al carrito... nombre check: ' + this.id)
							//console.log('desde añadir al carrito... chk checked: ' + this.checked)
							if (this.checked)
								{
								personalizado='SI'
								}
							}
						});
					
					
					
					//hace la animacion de llevar la imagen al carrito
					meter_al_carrito(articulo)
					
					parametros='acciones=' + accion
					parametros+='&ocultoarticulo=' + document.getElementById('ocultoarticulo').value
					parametros+= '&ocultocantidades_precios=' + document.getElementById('ocultocantidades_precios').value
					if (personalizado=='SI')
						{
						parametros+= '----SI'
						}
					  else
					  	{
						parametros+= '----NO'
						}
					pagina_url='Annadir_Articulo_Gag.asp'
					//pagina_url='Annadir_Articulo_Gag.asp'

					//console.log('llamamos a añadir articulos gag')
					//console.log('parametros: ' + parametros)
					//console.log('url: ' + pagina_url)
					mostrar_capa(pagina_url,'capa_annadir_articulo', parametros)
					
					
					

	
					}
				  else
				  	{
						//alert('La Cantidad Introducida Ha De Ser Un Número Entero')
						cadena='<BR><BR><H4><%=lista_articulos_gag_error_no_numero%></H4><BR><BR>'
						$("#cabecera_pantalla_avisos").html("<%=lista_articulos_gag_ventana_mensajes_cabezera_avisos%>")
						$("#pantalla_avisos .modal-header").show()
						$("#body_avisos").html(cadena + "<br>");
						$("#pantalla_avisos").modal("show");
						

						document.getElementById('txtcantidad_' + articulo).value=''
					}
				}
			  else
			  	{
				//cuando el articulo es sin compromiso de compra, ya viene la cantidad bien
				//console.log('es un articulos sin compromiso de compra y ya viene la cantidad-precio bien: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
				document.getElementById('ocultocantidades_precios').value=document.getElementById('ocultocantidades_precios_' + articulo).value
				//alert('cantidades despues: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
				
				
				//no hacemos el submit del formulario porque se vuelve a refrescar la pantalla con todos los
					//   articulos y como ya hay muchos, tarda horrores
					//document.getElementById('frmannadir_al_carrito').submit()
					
					personalizado='NO'
					$('.chkpersonalizar_kit').each(function (index) 
						{
						//console.log('colorcito fila ' + index + ': ' + $(this).css('font-weight'))
						datos=this.id.replace('chkpersonalizar_kit_','')
						datos=datos.split('_')
						//console.log('desde añadir al carrito.... id articulo chk: ' + datos[0])
						//console.log('desde añadir al carrito..... tallaje chk: ' + datos[1])
						//console.log('desde añadir al carrito... tallaje: ' + id_grupo)
						if (id_grupo==datos[1])
							{
							//console.log('desde añadir al carrito... coinciden tallaje y chk: ' + id_grupo)
							//console.log('desde añadir al carrito... nombre check: ' + this.id)
							//console.log('desde añadir al carrito... chk checked: ' + this.checked)
							if (this.checked)
								{
								personalizado='SI'
								}
							}
						});
					
					
					
					//hace la animacion de llevar la imagen al carrito
					meter_al_carrito(articulo)
					
					parametros='acciones=' + accion
					parametros+='&ocultoarticulo=' + document.getElementById('ocultoarticulo').value
					parametros+= '&ocultocantidades_precios=' + document.getElementById('ocultocantidades_precios').value
					if (personalizado=='SI')
						{
						parametros+= '----SI'
						}
					  else
					  	{
						parametros+= '----NO'
						}
					pagina_url='Annadir_Articulo_Gag.asp'
					//pagina_url='Annadir_Articulo_Gag.asp?'
					
					//console.log('llamamos a añandir articulo gag')
					//console.log('parametros: ' + parametros)
					//console.log('url: ' + pagina_url)
					mostrar_capa(pagina_url,'capa_annadir_articulo', parametros)
					
					
				}
			
			}
	
		}  
	}
	
	else
	{
		//alert('No Está Autorizado a Pedir Este Artículo')
		cadena='<BR><BR><H4><%=lista_articulos_gag_error_no_autorizado%></H4><BR><BR>'
		$("#cabecera_pantalla_avisos").html("<%=lista_articulos_gag_ventana_mensajes_cabezera_avisos%>")
		$("#pantalla_avisos .modal-header").show()
		$("#body_avisos").html(cadena + "<br>");
		$("#pantalla_avisos").modal("show");
	}
	
	
	//deseleccionamos todas las filas de la tabla cantidades/precios
	if (!document.getElementsByClassName)
		{
		elementos = document.querySelectorAll('.filas_cantidades');
		//alert('usamos queryselector')
		}
	  else
	  	{
		elementos = document.getElementsByClassName('filas_cantidades');
		//alert('usamos by class')
		}
		
	
	//elementos = document.getElementsByClassName('filas_cantidades');
	
	
    for (var i = 0; i < elementos.length; i++)
		{
		elementos[i].style.background='';
		elementos[i].style.fontWeight = 'normal';
		
	    }
		
	//quitamos el contenido de todas las cajas de texto 
	if (!document.getElementsByClassName)
		{
		elementos = document.querySelectorAll('.cantidad_pedida_art');
		//alert('usamos queryselector')
		}
	  else
	  	{
		elementos = document.getElementsByClassName('cantidad_pedida_art');
		//alert('usamos by class')
		}
		
	//elementos = document.getElementsByClassName('cantidad_pedida_art');
    for (var i = 0; i < elementos.length; i++)
		{
		elementos[i].value=''
	    }
		
	//deseleccionamos todas las filas de la tabla de tallas
	if (!document.getElementsByClassName)
		{
		elementos = document.querySelectorAll('.filas_tallajes');
		//alert('usamos queryselector')
		}
	  else
	  	{
		elementos = document.getElementsByClassName('filas_tallajes');
		//alert('usamos by class')
		}
		
	
	//elementos = document.getElementsByClassName('filas_cantidades');
	
	
    for (var i = 0; i < elementos.length; i++)
		{
		elementos[i].style.background='';
		elementos[i].style.fontWeight = 'normal';
		
	    }
			
		
		
	document.getElementById('ocultocantidades_precios').value=''	
	document.getElementById('ocultocantidades_precios_' + articulo).value=''
	document.getElementById('ocultotallaje').value=''
	document.getElementById('ocultoprecio_tallaje_seleccionado').value=''
	
	
	
	
	
	mostrar_resumen_carrito()
		
}

function seleccionar_fila(articulo, fila_pulsada, numero_filas,cantidades_precio_total_articulo,compromiso_compra)
{
/*
console.log('seleccionar_fila:')
console.log('--- articulo: ' + articulo)
console.log('--- fila_pulsada: ' + fila_pulsada)
console.log('--- numero_filas: ' + numero_filas)
console.log('--- cantidades_precio_total_articulo: ' + cantidades_precio_total_articulo)
console.log('--- compromiso de compra: ' + compromiso_compra)
*/
	
	
	/*
	for (i=1;i<=numero_filas;i++)
	{
	document.getElementById('fila_' + articulo + '_' + i).style.background=''
	document.getElementById ('fila_' + articulo + '_' + i).style.fontWeight = 'normal'
//var fontTest = document.getElementById ('fila_' + articulo + '_' + i)
    //fontTest.style.fontWeight = '900';
	console.log('cambiamos el fondo de fila_' + articulo + '_' + i)

	}
	*/
	//deseleccionamos todas las filas
	if (!document.getElementsByClassName)
		{
		elementos = document.querySelectorAll('.filas_cantidades');
		//alert('usamos queryselector')
		}
	  else
	  	{
		elementos = document.getElementsByClassName('filas_cantidades');
		//alert('usamos by class')
		}
		
	//elementos = document.getElementsByClassName('filas_cantidades');
    for (var i = 0; i < elementos.length; i++)
		{
		elementos[i].style.background='';
		elementos[i].style.fontWeight = 'normal';
		
	    }
		
	//quitamos el contenido de todas las cajas de texto
	if (!document.getElementsByClassName)
		{
		elementos = document.querySelectorAll('.cantidad_pedida_art');
		//alert('usamos queryselector')
		}
	  else
	  	{
		elementos = document.getElementsByClassName('cantidad_pedida');
		//alert('usamos by class')
		}
	 
	//elementos = document.getElementsByClassName('cantidad_pedida_art');
    for (var i = 0; i < elementos.length; i++)
		{
		elementos[i].value=''
	    }
		
		
	
	if (compromiso_compra!='SI')
		{
		document.getElementById('fila_' + articulo + '_' + fila_pulsada).style.background='#E1E1E1' 
		document.getElementById ('fila_' + articulo + '_' + fila_pulsada).style.fontWeight = 'bold'
		}
	//alert('compromiso_compra: ' + compromiso_compra)
	document.getElementById('ocultocantidades_precios_' + articulo).value=cantidades_precio_total_articulo
		
	  	
}


function seleccionar_fila_tallaje(agrupacion_tallaje, fila_pulsada, articulo)
{
	//deseleccionamos todas las filas
	if (!document.getElementsByClassName)
		{
		elementos = document.querySelectorAll('.filas_tallajes');
		//alert('usamos queryselector')
		}
	  else
	  	{
		elementos = document.getElementsByClassName('filas_tallajes');
		//alert('usamos by class')
		}
		
	//elementos = document.getElementsByClassName('filas_cantidades');
    for (var i = 0; i < elementos.length; i++)
		{
		elementos[i].style.background='';
		elementos[i].style.fontWeight = 'normal';
		
	    }
		
	document.getElementById('fila_tallaje_' + agrupacion_tallaje + '_' + fila_pulsada).style.background='#E1E1E1' 
	document.getElementById ('fila_tallaje_' + agrupacion_tallaje + '_' + fila_pulsada).style.fontWeight = 'bold'


	document.getElementById('ocultotallaje').value=articulo
	//console.log('precio del tallaje pulsado: ' + $("#fila_tallaje_" + agrupacion_tallaje + "_" + fila_pulsada + " .ocultoprecio_tallaje").val())
	document.getElementById('ocultoprecio_tallaje_seleccionado').value=$("#fila_tallaje_" + agrupacion_tallaje + "_" + fila_pulsada + " .ocultoprecio_tallaje").val()
		

}


function ir_pto_articulo(pto_articulo, agrupacion, empresa, pais, tipo)
{
	if (pto_articulo!='')
	{
		window.location='#'+pto_articulo;
	}
	
	if (agrupacion!='')
		{
		activar_agrupacion(agrupacion, empresa, pais, tipo)
		}
	//cerrar_capas('capa_informacion')
}

function activar_agrupacion(agrupacion,empresa, pais, tipo)
{
	cadena_boton='cmdAgrupacion_' + agrupacion
	if (
		((empresa=='ASM')&&(pais=='PORTUGAL')&&(agrupacion.indexOf('GLS')==(-1)))
		|| 
		((empresa=='ASM')&&(tipo=='ARRASTRES')&&(agrupacion.indexOf('GLS')==(-1)))
		)
		{
		if (agrupacion.indexOf('TODOS')==(-1))
			{
			//console.log('dentro de activar_agrupacion: 1')
			cadena_imagen='images/' + empresa + '_Boton_' + agrupacion + '_PT_Pulsado.jpg'
			}
		  else
		    {
			//console.log('dentro de activar_agrupacion: 2')
			
			cadena_imagen='images/' + empresa + '_Boton_GLS_' + agrupacion + '_Pulsado.jpg'
			}
		}
	  else
	  	{
		//console.log('dentro de activar_agrupacion: 3')
			
		cadena_imagen='images/' + empresa + '_Boton_' + agrupacion + '_Pulsado.jpg'
		}
	
	//console.log('dentro de activar_agrupacion: imagen -- ' + cadena_imagen)

	
	//alert('boton pulsado: ' + cadena_boton + '\n\nimagen a cargar: ' + cadena_imagen)
	
	//document.getElementById(cadena_boton).style.backgroundImage='url("' + cadena_imagen + '")';
	//document.getElementById('cmdAgrupacion_CONSUMIBLES').style.backgroundImage='url("images/boton_consumibles_pulsado.jpg")';
	//document.getElementById('cmdAgrupacion_MARKETING').style.backgroundImage="url('images/Boton_Informatica_Pulsado.jpg')"
	document.getElementById(cadena_boton).style.backgroundImage='url(' + cadena_imagen + ')';
	//document.getElementById(cadena_boton).src=cadena_imagen;
	
	//alert('hola')

}
function mostrar_agrupaciones(agrupacion, empresa, pais, tipo)
{
	activar_agrupacion(agrupacion, empresa, pais, tipo)
	//alert('en mostrar agrupaciones')
	document.getElementById('cmbfamilias').value="TODOS"
	document.getElementById('ocultoagrupacion_familias').value=agrupacion
	//alert('antes del submit')
	document.getElementById('frmbusqueda').submit()
}


</script>

	

<!--PARA LA ANIMACION DE METER LA IMAGEN DEL ARTICULO EN EL CARRITO DE LA COMPRA-->		
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>


<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>	
<!--
<script type="text/javascript" src="../plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>


<script type="text/javascript" src="../plugins/bootstrap-multiselect/bootstrap-multiselect.js"></script>
-->
<script type="text/javascript" src="../plugins/bootstrap-selectpicker-1.13.14/js/bootstrap-select-new.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-selectpicker-1.13.14/dist/js/i18n/defaults-es_CL.js"></script>


		


</head>
<body onLoad="ir_pto_articulo('<%=pto_articulo%>', '<%=agrupacion_familia_buscada%>', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>', '<%=session("usuario_tipo")%>')" style="margin-top:0; margin-left:0; background-color:<%=session("color_asociado_empresa")%>">

<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=lista_articulos_gag_ventana_mensajes_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->






<script language="javascript">
	cadena='<div align="center"><br><br><img src="../images/loading4.gif"/><br /><br /><h4><%=lista_articulos_gag_ventana_mensajes_espera%></h4><br></div>'
	$("#cabecera_pantalla_avisos").html("<%=lista_articulos_gag_ventana_mensajes_cabezera_avisos%>")
	$("#pantalla_avisos .modal-header").show()
	$("#body_avisos").html(cadena + "<br><br>");
	$("#pantalla_avisos").modal("show");
</script>

<div class="container-fluid">
   <!--PANTALLA-->
  <div class="row____" id="probando">
    <!--COLUMNA IZQUIERDA -->
    <div class="col-xs-3" id="columna_izquierda_fija">


			  <!--DATOS DEL CLIENTE-->
			  <div class="panel panel-default" style="margin-bottom:0px ">
				<div class="panel-body panel_conmargen">
					<div class="col-md-12">
						<%
						nombre_logo="logo_" & session("usuario_carpeta") & ".png"
						if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
							nombre_logo="Logo_GLS.png"
						end if
						%>
						<div align="center"><img class="img-responsive" src="Images/<%=nombre_logo%>" style="max-height:90px"/></div>
						<br />
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
							
							
							
							
							<!-- lo siguiente no se ha de ver en real
							TRATO ESPECIAL: <%=session("usuario_trato_especial")%>
							<br />
							SERIA SU PRIMER PEDIDO: <%=session("usuario_primer_pedido")%>
							<br />
							FECHA ALTA: <%=session("usuario_fecha_alta")%>
							<br />
							DERECHO PRIMER PEDIDO: <%=session("usuario_derecho_primer_pedido")%>
							<br />
							SELECCION MATERIAL: <%=session("seleccion_asm_gls")%>
							<br />
							
							-->
						</div>
					</div>
				</div>
			  </div>
	
			
	
			  <!--DATOS DEL PEDIDO-->
			  <div class="panel panel-default" style="margin-bottom:0px; margin-top:7px ">
				<div class="panel-heading"><b><%=lista_articulos_gag_panel_datos_pedido_cabecera%></b></div>
				<div class="panel-body panel_sinmargen_lados panel_conmargen_arribaabajo">
					<div class="col-md-12">
						<div align="center" style="padding-bottom:6px ">
							<div style="display:inline-block"><span><img src="../images/Carrito_48x48.png" border="0" class="shopping-cart"/></span></div>
	
							<!-- NO BORRAR, es la capa que añade articulos al pedido....-->
							<div style="display:inline-block" id="capa_annadir_articulo">&nbsp;<b><%=session("numero_articulos")%></b> <%=lista_articulos_gag_panel_datos_pedido_articulos%></div>
						</div>
						
						
				
						<div align="center">	
							<button type="button" id="cmdver_pedido" name="cmdver_pedido" class="btn btn-primary btn-sm"
								data-toggle="popover" 
								data-placement="bottom" 
								data-trigger="hover" 
								data-content="<%=lista_articulos_gag_panel_datos_pedido_boton_ver_alter%>" 
								data-original-title=""
								>
									<i class="glyphicon glyphicon-list-alt"></i>
									<span><%=lista_articulos_gag_panel_datos_pedido_boton_ver%></span>
							</button>
							<button type="button" id="cmdborrar_pedido" name="cmdborrar_pedido" class="btn btn-primary btn-sm"
								data-toggle="popover" 
								data-placement="bottom" 
								data-trigger="hover" 
								data-content="<%=lista_articulos_gag_panel_datos_pedido_boton_borrar_alter%>" 
								data-original-title=""
								>
									<i class="glyphicon glyphicon-remove"></i>
									<span><%=lista_articulos_gag_panel_datos_pedido_boton_borrar%></span>
							</button>
						</div>
						
						<div id="capa_resumen_carrito" style="padding-top:5px; ; position: relative; max-height: 200px; overflow: auto; display: block;"></div>
						
					</div>
				</div>
			  </div>

			  <%if session("usuario_codigo_empresa")<>4 then%>
				  <!--PEDIDOS REALIZADOS-->
				  <div class="panel panel-default"  style="margin-bottom:0px; margin-top:7px ">
					<div class="panel-heading"><b><%=lista_articulos_gag_panel_pedidos_cabecera%></b></div>
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
						  
			  
			  
				<!--OFERTAS DESTACADAS... CARRUSEL-->
				<%if not vacio_carrusel then%>
					<div class="panel panel-default" style="margin-bottom:0px;margin-top:7px ">
						<div class="panel-heading"><b><%=lista_articulos_gag_panel_destacados_cabecera%></b></div>
						<div class="panel-body panel_sinmargen_lados panel_conmargen_arribaabajo">
							<DIV>
							<!--COMIENZO DEL CARRUSEL
								... sacado de jssor slider
									http://www.jssor.com
							-->
							<script type="text/javascript" src="../carrusel/js/carrusel_4_seg.js"></script>
							<div id="jssor_2" style="position: relative; margin: 0 auto; top: 0px; left: 0px; width: 600px; height: 500px; overflow: hidden; visibility: hidden;">
								<!-- Pantalla de "Cargando..." -->
								<div data-u="loading" style="position: absolute; top: 0px; left: 0px;">
									<div style="filter: alpha(opacity=70); opacity: 0.7; position: absolute; display: block; top: 0px; left: 0px; width: 100%; height: 100%;"></div>
									<div style="position:absolute;display:block;background:url('../carrusel/img_carrusel/loading.gif') no-repeat center center;top:0px;left:0px;width:100%;height:100%;"></div>
								</div>
								<div data-u="slides" style="cursor: default; position: relative; top: 0px; left: 0px; width: 600px; height: 500px; overflow: hidden;">
									<%for i=0 to UBound(tabla_carrusel,2)%>
										<div style="display: none;"><img data-u="image" src="../carrusel/img_carrusel/<%=tabla_carrusel(campo_fichero_carrusel,i)%>" /></div>
									<%next%>
								</div>
								<!-- Botones de Navegacion -->
								<!--
								<div data-u="navigator" class="jssorb05" style="bottom:16px;right:16px;" data-autocenter="1">
									<!-- Boton prototipo 
									<div data-u="prototype" style="width:16px;height:16px;"></div>
								</div>
								-->
								
								<!-- Flechas de Navegacion -->
								<span data-u="arrowleft" class="jssora10l" style="top:0px;left:8px;width:28px;height:40px;" data-autocenter="2"></span>
								<span data-u="arrowright" class="jssora10r" style="top:0px;right:8px;width:28px;height:40px;" data-autocenter="2"></span>
							</div>
							<script>
								jssor_slider_init('jssor_2');
							</script>
							<!-- FINALIZA EL CARRUSEL-->
							</DIV>
						</div>
					</div>
				<%end if%>		
				<!--FINAL OFERTAS DESTACADAS -- EL CARRUSEL-->
				
	  
	  
  
			  
    </div>
    <!--FINAL COLUMNA DE LA IZQUIERDA-->
    
    <!--COLUMNA DE LA DERECHA-->
    <div class="col-xs-9 col-xs-offset-3">
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
						<div class="col-lg-3" align="center">
							<button type="button" id="cmdconsultar_devoluciones" name="cmdconsultar_devoluciones" class="btn btn-primary btn-block btn-sm">
									<div>
										<span class="fas fa-reply"></span>
										<span class="texto_boton-">&nbsp;Consultar Devoluciones</span>
										<%if dinero_disponible_devoluciones<>0 then%>
											<span class="dinero_disponible">&nbsp;<%=dinero_disponible_devoluciones%>€&nbsp;</span>
										<%end if%>
									</div>
							</button>
						</div>
						
						<%if session("usuario_tipo")<>"GLS PROPIA" then%>
							<div class="col-lg-3" align="center">
								<button type="button" id="cmdconsultar_saldos" name="cmdconsultar_saldos" class="btn btn-primary btn-block  btn-sm">
										<div>
											<i class="fas fa-money-bill-wave"></i>
											<span class="texto_boton-">&nbsp;Consultar Saldos</span>
										  	<%if dinero_disponible_saldos<>0 then%>
												<span class="dinero_disponible">&nbsp;<%=dinero_disponible_saldos%>€&nbsp;</span>
											<%end if%>
										</div>
								</button>
							</div>
						<%end if%>
						<div class="col-lg-3" align="center">
							<button type="button" name="cmdimpresoras" id="cmdimpresoras" class="btn btn-primary btn-block btn-sm">
								<i class="fas fa-print"></i> Gestión Impresoras
							</button>
						</div>

					</div>
				</div>
			</div>
			<!-- pedidos, devoluciones y saldos-->
		<%end if%>
      <div class="panel panel-default">
	  	<%if session("usuario_codigo_empresa")<>4 then%>
			<%cadena_cabecera=replace(lista_articulos_gag_panel_filtros_cabecera,"XXX", session("usuario_empresa"))%>
        	<div class="panel-heading"><span class='fontbold'><%=cadena_cabecera%></span></div>
		<%end if%>
		<div class="panel-body">
			<div class="well well-sm">
				<form class="form-horizontal" role="form" name="frmbusqueda" id="frmbusqueda" method="post" action="Lista_Articulos_Gag.asp?acciones=<%=accion%>">
					<input type="hidden" id="ocultover_cadena" name="ocultover_cadena" value="<%=ver_cadena%>" />
					<input type="hidden" class="form-control" id="ocultoagrupacion_familias" name="ocultoagrupacion_familias" value="<%=agrupacion_familia_buscada%>" />
					<div class="form-group">    
					  <label class="col-md-1 control-label" 
						data-toggle="popover" 
						data-placement="bottom" 
						data-trigger="hover" 
						data-content="<%=lista_articulos_gag_panel_filtros_referencia_alter%>" 
						data-original-title=""
						>
						<%=lista_articulos_gag_panel_filtros_referencia%></label>	 
					  <div class="col-md-2">
						<input type="text" class="form-control" size="14" name="txtcodigo_sap" id="txtcodigo_sap" value="<%=codigo_sap_buscado%>" />
					  </div>
					  
					  <label class="col-md-2 control-label" 
							data-toggle="popover" 
							data-placement="bottom" 
							data-trigger="hover" 
							data-content="<%=lista_articulos_gag_panel_filtros_descripcion_alter%>" 
							data-original-title=""
							>
							<%=lista_articulos_gag_panel_filtros_descripcion%></label>	                
					  <div class="col-md-7">
						<input type="text" class="form-control" size="44" name="txtdescripcion" id="txtdescripcion" value="<%=articulo_buscado%>" />
					  </div>
					</div>  
					
					<div class="form-group">    
						<label class="col-md-1 control-label"><%=lista_articulos_gag_panel_filtros_familia%></label>	                
						<div class="col-md-4">
							<%'response.write("<br>INICIO DEL COMBO")%>
						
							<%' PARA HALCON, ECUADOR, GROUNDFORCE, AIR EUROPA, CALDERON, HALCON VIAJGENS, TRAVEPLAN, TIBILLETE, GLOBALIA, GEOMOON, GLOBALIA CORPORATE TRAVEL
								' MARSOL, AVORIS, FRANQUICIAS HALCON, FRANQUICIAS ECUADOR, GENERAL CARRITO
								'mostramos un combo diferente con familias y agrupaciones de familias
							if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=30 _
								or session("usuario_codigo_empresa")=40 or session("usuario_codigo_empresa")=50 or session("usuario_codigo_empresa")=80 _
								or session("usuario_codigo_empresa")=90 or session("usuario_codigo_empresa")=100 or session("usuario_codigo_empresa")=110 _
								or session("usuario_codigo_empresa")=130 or session("usuario_codigo_empresa")=170 or session("usuario_codigo_empresa")=210 _
								or session("usuario_codigo_empresa")=230 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 _
								or session("usuario_codigo_empresa")=260 then %>
								<!--<select id="cmbfamilias_agrupadas_otra" name="cmbfamilias_agrupadas_otra" multiple="multiple">-->
								<select id="cmbfamilias_agrupadas_otra" name="cmbfamilias_agrupadas_otra" class="form-control selectpicker" multiple data-selected-text-format="count > 3">
							
							
									<%
										grupo_ant=""
										For i = 0 to UBound(tabla_agrupacion_familias_otra, 2)
											grupo_nuevo=tabla_agrupacion_familias_otra(CAMPO_GRUPO_FAMILIAS_OTRA, i)
											If grupo_ant <> grupo_nuevo Then
												if grupo_ant<>"" then
									%>			
													</optgroup>
												<%end if%>	
												<optgroup label="<%=tabla_agrupacion_familias_otra(CAMPO_GRUPO_FAMILIAS_OTRA, i)%>">
									<%		
											End If
									%>
											<option class="special" value="<%=tabla_agrupacion_familias_otra(CAMPO_ID_FAMILIAS_OTRA, i)%>"><%=tabla_agrupacion_familias_otra(CAMPO_DESCRIPCION_FAMILIA_OTRA, i)%></option>

									<%		
											If grupo_ant <> grupo_nuevo Then
												grupo_ant = grupo_nuevo
											End If
										Next
									%>
								</select>
								
								
								
													
							<%else%>
							
								<select class="form-control" name="cmbfamilias" id="cmbfamilias">
									<%if not vacio_familias then%>
										<%for i=0 to UBound(tabla_familias,2)
											'response.write("<br>elemento del combo: " & tabla_familias(campo_descripcion_familia,i))
										
											'si es una oficina REDYSER y es su primer pedido, solo puede ver unas familias
											' concretas... en los siguientes pedidos ya ve el resto
											if session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI" then
												'response.write("<br>.treto especial y primer pedido")
												nombrecito_familia=tabla_familias(campo_descripcion_familia,i)
												if nombrecito_familia="GLS ROTULACION" _
													OR nombrecito_familia="GLS DECORACION" _
													OR nombrecito_familia="GLS VESTUARIO NEGOCIOS" _
													OR nombrecito_familia="GLS VEHICULOS" _
													OR nombrecito_familia="GLS CORPORATIVO" _
													OR nombrecito_familia="GLS MARKETING" _
													OR nombrecito_familia="GLS SEGURIDAD" _
													THEN
													'response.write("<br>..varias familias, rotulacion, corporativo, etc")
													%>
														
														<%if valor_seleccionado<>"" then
															if cint(valor_seleccionado)=cint(tabla_familias(campo_id_familia,i)) then%>
																<option value="<%=tabla_familias(campo_id_familia,i)%>" selected><%=tabla_familias(campo_descripcion_familia,i)%></option>
															<%else%>
																<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=UCASE(tabla_familias(campo_descripcion_familia,i))%></option>
															<%end if%>
														<%else%>
															<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=UCASE(tabla_familias(campo_descripcion_familia,i))%></option>
														<%end if%>
												<%end if%>
											
											  <%else 'de session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI"
													'if session("usuario_pais")="PORTUGAL" and UCASE(tabla_familias(campo_descripcion_familia,i))="GLS PRECINTOS" then
													'el vestuario con el nuevo logo en preventa solo se muestra a las franquicias y los arrastres y la oficina propia 280-5 (5089) y la oficina propia 280-51 GLS PERDIDAS (7395)
													'response.write("<br>.no trato especial ni primer pedido")
													if session("usuario_codigo_empresa")=4 and session("usuario_tipo")= "GLS PROPIA" and session("usuario")<>5089 and session("usuario")<>7395 and UCASE(tabla_familias(campo_descripcion_familia,i))="GLS VESTUARIO NUEVO LOGO"  then
															'response.write("<br>..oficina propia y nuevo logo")
														else
															'response.write("<br>..no oficina propia ni nuevo logo")
															if UCASE(tabla_familias(campo_descripcion_familia,i))="GLS ROPA NUEVA LINEA" then
																'response.write("<br>...ropa nueva linea")
																if session("usuario_tipo")= "GLS PROPIA" then
																	'response.write("<br>....oficina propia")
																	if session("usuario_pais")<>"PORTUGAL" then
																		'response.write("<br>.....no es oficina de portugal")
																		if valor_seleccionado<>"" then
																			if cint(valor_seleccionado)=cint(tabla_familias(campo_id_familia,i)) then%>
																				<option value="<%=tabla_familias(campo_id_familia,i)%>" selected><%=tabla_familias(campo_descripcion_familia,i)%></option>
																			<%else%>
																				<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=UCASE(tabla_familias(campo_descripcion_familia,i))%></option>
																			<%end if%>
																		<%else%>
																			<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=UCASE(tabla_familias(campo_descripcion_familia,i))%></option>
																		<%end if
																	end if
																end if
															else
																'response.write("<br>...no ropa nueva linea")
																if valor_seleccionado<>"" then
																	if cint(valor_seleccionado)=cint(tabla_familias(campo_id_familia,i)) then%>
																		<option value="<%=tabla_familias(campo_id_familia,i)%>" selected><%=tabla_familias(campo_descripcion_familia,i)%></option>
																	<%else%>
																		<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=UCASE(tabla_familias(campo_descripcion_familia,i))%></option>
																	<%end if%>
																<%else%>
																	<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=UCASE(tabla_familias(campo_descripcion_familia,i))%></option>
																<%end if
															end if
															
													end if
												
												end if%>
											
											
										<%next%>
									<%end if%>
									<option value="TODOS" selected>-- <%=lista_articulos_gag_panel_filtros_combo_familia_todos%> --</option>
								</select>
								<%'response.write("<br>FIN")%>
								<script language="javascript">
										document.getElementById("cmbfamilias").value='<%=familia_buscada%>'
								</script>
							<%end if%>
						</div>
						
						<!-- ya no se ordena por referencia ni nombre... al venir lo de las tallas, solo se ordena
						por nombre para que queden todas juntas
						
						<label class="col-md-3 control-label"><%=lista_articulos_gag_panel_filtros_ordenacion%></label>	                
						<div class="col-md-4">
							<select class="form-control" name="cmborden" id="cmborden">
								<option value="REFERENCIA" selected><%=lista_articulos_gag_panel_filtros_ordenacion_sap%></option>
								<option value="NOMBRE"><%=lista_articulos_gag_panel_filtros_ordenacion_nombre%></option>
							</select>
							
							<script language="javascript">
								if ('<%=orden_buscado%>'!='')
									{
									document.getElementById("cmborden").value='<%=orden_buscado%>'
									}
							</script>
						</div>
						-->
					</div>
					
					<div class="form-group">
						<%
							'el perfil de ASM no tiene que ver este filtro de Requiere Autorizacion
							' el de UVE HOTELES TAMPOCO - 150
							' el de IMPRENTA TAMPOCO - 220
							' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
							' 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR y el de GENERAL CARRITO tampoco
							if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150 _
								and session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80 _
								and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170 _
								and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 _
								and session("usuario_codigo_empresa")<>220 and session("usuario_codigo_empresa")<>240 and session("usuario_codigo_empresa")<>250 _
								and session("usuario_codigo_empresa")<>260 then%>		
								<label class="col-md-2 control-label" 
									data-toggle="popover" 
									data-placement="bottom" 
									data-trigger="hover" 
									data-content="<%=lista_articulos_gag_panel_filtros_requiere_autorizacion_alter%>" 
									data-original-title=""
									>
									<%=lista_articulos_gag_panel_filtros_requiere_autorizacion%></label>	                
								<div class="col-md-3">
									<select class="form-control" name="cmbautorizacion" id="cmbautorizacion">
										<option value="">* <%=lista_articulos_gag_panel_filtros_combo_autorizacion%> *</option>
										<option value="NO"><%=lista_articulos_gag_panel_filtros_combo_autorizacion_no%></option>
										<option value="SI"><%=lista_articulos_gag_panel_filtros_combo_autorizacion_si%></option>
									</select>
									<script language="JavaScript" type="text/javascript">
										document.getElementById("cmbautorizacion").value='<%=campo_autorizacion%>'
									</script>
								</div>
							<%else%>
								<div class="col-md-5"></div>							
						<%end if%>
						
						<div class="col-md-2">
						  <button type="submit" name="Action" id="Action" class="btn btn-primary btn-sm">
								<i class="glyphicon glyphicon-search"></i>
								<span><%=lista_articulos_gag_panel_filtros_boton_buscar%></span>
						  </button>
						</div>
					</div>  
					
					<!--botones para las agrupaciones de familia, para poder filtrar la consulta-->
					<%' PARA HALCON, ECUADOR, GROUNDFORCE, AIR EUROPA, CALDERON, HALCON VIAJGENS, TRAVEPLAN, TIBILLETE, GLOBALIA, GEOMOON, GLOBALIA CORPORATE TRAVEL
						' MARSOL, AVORIS, FRNQUICIAS HALCON, FRNAQUICIAS ECUADOR y GENERAL CARRITO
								'mostramos un combo diferente con familias y agrupaciones de familias y no hay botones....
					if session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>30 _
						 and session("usuario_codigo_empresa")<>40 and session("usuario_codigo_empresa")<>50 and session("usuario_codigo_empresa")<>80 _
						 and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>100 and session("usuario_codigo_empresa")<>110 _
						 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170 and session("usuario_codigo_empresa")<>210 _
						 and session("usuario_codigo_empresa")<>230 and session("usuario_codigo_empresa")<>240 and session("usuario_codigo_empresa")<>250 _
						 and session("usuario_codigo_empresa")<>260 then %>
					<div class="form-group">    
						<div class="col-md-12" align="center">
							<%if not vacio_agrupacion_familias then%>
										<%for i=0 to UBound(tabla_agrupacion_familias,2)%>
											<%
												nombre_imagen = replace(session("usuario_empresa")," ", "_") & "_Boton_" & tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)
												
												nombre_imagen=nombre_imagen & ".jpg"
												%>
												
												<%'para asm, si es un arrastre solo se muestran ciertas agrupaciones,
												'para el resto de empresas se muestran todas
												if session("usuario_codigo_empresa")=4 then
													if session("usuario_tipo")<>"ARRASTRES" THEN
														'si es una oficina REDYSER y es su primer pedido, solo puede ver unas familias
														' concretas... en los siguientes pedidos ya ve el resto
														'response.write(session("usuario_pais") & "<br>" & tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i))
														if session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI" then
															nombrecito_familia=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)
															if nombrecito_familia="GLS_ROTULACION" _
																OR nombrecito_familia="GLS_DECORACION" _
																OR nombrecito_familia="GLS_VESTUARIO_NEGOCIOS" _
																OR nombrecito_familia="GLS_VEHICULOS" _
																OR nombrecito_familia="GLS_CORPORATIVO" _
																OR nombrecito_familia="GLS_MARKETING" _
																OR nombrecito_familia="GLS_SEGURIDAD" _
																THEN
																	'if session("usuario_pais")="PORTUGAL" and (nombrecito_familia="GLS_PRECINTOS" or nombrecito_familia="GLS_PARCELSHOP") THEN
																		'else%>
																			<div  class="botones_agrupacion" name="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" id="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" value="<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" onclick="mostrar_agrupaciones('<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>', '<%=session("usuario_tipo")%>')" style="background-image:url('images/<%=nombre_imagen%>');cursor:pointer"></div>
																	<%'end if%>
															<%end if%>
														  <%else 'de session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI"
																nombrecito_familia=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)
																'if session("usuario_pais")="PORTUGAL"  and (nombrecito_familia="GLS_PRECINTOS" or nombrecito_familia="GLS_PARCELSHOP") THEN
																'response.write("<br>nombre familia:" & nombrecito_familia)
																'el vestuario con el nuevo logo en preventa solo se muestra a las franquicias y los arrastres y la oficina propia 280-5 (5089) y 280-51 GLS PERDIDAS (7395)
																if session("usuario_codigo_empresa")=4 and session("usuario_tipo")= "GLS PROPIA" and session("usuario")<>5089 and session("usuario")<>7395 and UCASE(nombrecito_familia)="GLS_VESTUARIO_NUEVO_LOGO"  then
																	else
																		if UCASE(nombrecito_familia)="GLS_ROPA_NUEVA_LINEA" then
																			if session("usuario_tipo")= "GLS PROPIA" then
																				if session("usuario_pais")<>"PORTUGAL" then%>
																					<div  class="botones_agrupacion" name="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" id="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" value="<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" onclick="mostrar_agrupaciones('<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>', '<%=session("usuario_tipo")%>')" style="background-image:url('images/<%=nombre_imagen%>');cursor:pointer"></div>
																				<%end if
																			end if
																		  else%>
																			<div  class="botones_agrupacion" name="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" id="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" value="<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" onclick="mostrar_agrupaciones('<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>', '<%=session("usuario_tipo")%>')" style="background-image:url('images/<%=nombre_imagen%>');cursor:pointer"></div>
																		<%end if%>
																<%end if%>
														<%end if%>
														
													<%else 'de session("usuario_tipo")<>"ARRASTRES"... son arrastres
														nombrecito_familia=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)
														'response.write("<br>familia: " & nombrecito_familia)
														if nombrecito_familia="GLS_VEHICULOS" _
															OR nombrecito_familia="GLS_OPERACIONES" _
															OR nombrecito_familia="GLS_VESTUARIO_NUEVO_LOGO" _
															OR nombrecito_familia="GLS_MARKETING" _
															OR nombrecito_familia="GLS_MATERIAL_OFICINA" _
															OR nombrecito_familia="GLS_INFORMATICA" _
															OR nombrecito_familia="GLS Archivo" _
															OR nombrecito_familia="GLS Articulos Generales" _
															OR nombrecito_familia="GLS Cuadernos y Notas" _
															OR nombrecito_familia="GLS Escritura" _
															OR nombrecito_familia="GLS Etiquetas" _
															OR nombrecito_familia="GLS Ofimática" _
															OR nombrecito_familia="GLS Máquinas" _
															OR nombrecito_familia="GLS Papel" _
															
															THEN%>
																	<div  class="botones_agrupacion" name="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" id="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" value="<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" onclick="mostrar_agrupaciones('<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>', '<%=session("usuario_tipo")%>')" style="background-image:url('images/<%=nombre_imagen%>');cursor:pointer"></div>
														<%end if%>
													<%end if%>
												<%else 'de session("usuario_codigo_empresa")=4%>
													<div  class="botones_agrupacion" name="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" id="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" value="<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" onclick="mostrar_agrupaciones('<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>', '<%=session("usuario_tipo")%>')" style="background-image:url('images/<%=nombre_imagen%>');cursor:pointer"></div>
												<%end if%>
											
										<%next%>
										
										<div  class="botones_agrupacion" name="cmdAgrupacion_TODOS" id="cmdAgrupacion_TODOS" onclick="mostrar_agrupaciones('TODOS', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>', '<%=session("usuario_tipo")%>')" style="background-image:url('images/<%=replace(session("usuario_empresa")," ", "_")%>_Boton_TODOS.jpg');cursor:pointer" ></div>  
										  
										
										
										

										<%if agrupacion_familia_buscada<>"" then%>
														<script language="javascript">
															//alert('cambio la imagen a <%=agrupacion_familia_buscada%>')
															//console.log('despues de cargar agrupaciones 3, en el javascript de inicializacion: <%=replace(session("usuario_empresa")," ", "_")%>_Boton_<%=agrupacion_familia_buscada%>_Pulsado.jpg')
															
															document.getElementById('cmdAgrupacion_<%=agrupacion_familia_buscada%>').style.backgroundImage="url('images/<%=replace(session("usuario_empresa")," ", "_")%>_Boton_<%=agrupacion_familia_buscada%>_Pulsado.jpg')";								
															//document.getElementById('cmdAgrupacion_<%=agrupacion_familia_buscada%>').src = 'images/Boton_<%=agrupacion_familia_buscada%>_Pulsado.jpg'
														</script>
										<%end if%>
								<%end if 'vacio agrupacion familias%>
								
							</div>
					  </div>	
					  <%end if 'final de los botones%>
			
				</form>
			</div><!--del well de los filtros-->
			
			
			<input type="hidden" id="ocultotallaje" value="" />
			<input type="hidden" id="ocultoprecio_tallaje_seleccionado" value="" />
			
			<%
			
			set fs_icono=Server.CreateObject("Scripting.FileSystemObject")
			
			while not articulos.eof
				response.flush()%>
				<div class="row row_articulos">
					<!--comienza el articulo IZQUIERDA-->
					<a name="pto_<%=articulos("id")%>" id="pto_<%=articulos("id")%>"></a>
					<div class="col-md-6">
							<div class="panel panel-primary item col_articulo_1 item_<%=articulos("ID")%>">
								<div class="panel-heading" style="padding-bottom:2px;padding-top:2px">
									<div class="panel-title"><H5><%=REPLACE(REPLACE(articulos("DESCRIPCION_IDIOMA"),".",""), "·","")%></H5></div>
								</div>
								<div class="panel-body" style="padding-left:1px; padding-left:1px; padding-top:0px;">
									<!--informacion general del articulo-->
									<div class="row">
										<div class="col-md-7">
											<div style="padding-top:5px"></div>
											<div class="panel panel-default__ inf_general_art"  onclick="muestra_datos_articulo(<%=articulos("ID")%>, <%=session("usuario_codigo_empresa")%>)"
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover" 
												data-content="<%=lista_articulos_gag_panel_articulos_informacion_alter%>" 
												data-original-title=""
												>
												<div class="panel-body" style="cursor:pointer;cursor:hand">
													
													<%
													'response.write("<br>descripcion grupo: " & articulos("descripcion_grupo"))
													if ("" & articulos("descripcion_grupo"))="" then%>
														<div align="left"><b><%=lista_articulos_gag_panel_articulos_informacion_referencia%>:</b> <%=articulos("codigo_sap")%><br></div>
													<%end if%>
													<div align="left"><b><%=lista_articulos_gag_panel_articulos_informacion_familia%>:</b> <%=articulos("nombre_familia")%><br></div>
													<%
													'el perfil de ASM no tiene que ver este dato de Requiere Autorizacion
													' el de UVE HOTELES TAMPOCO - 150
													' el de IMPRENTA TAMPOCO - 220
													' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
													' 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR y 260 GENERAL CARRITO tampoco
													if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150 _
														and session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80 _
														and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170 _
														and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 _
														and session("usuario_codigo_empresa")<>220 and session("usuario_codigo_empresa")<>240 and session("usuario_codigo_empresa")<>250 _
														and session("usuario_codigo_empresa")<>260 then%>		
														<div align="left"><b><%=lista_articulos_gag_panel_filtros_requiere_autorizacion_alter%>:</b>
															<%IF articulos("requiere_autorizacion")="SI" THEN%>
																<B style="color:#FF0000"><%=lista_articulos_gag_panel_filtros_combo_autorizacion_si%></B>
															<%ELSE%>	
																<%=lista_articulos_gag_panel_filtros_combo_autorizacion_no%>
															<%END IF%>
															<br>
														</div>
													<%end if%>
												</div>
											</div>
											
										</div><!--col-md-7-->
										<div class="col-md-5">
											<div style="padding-top:5px"></div>
											<div class="panel inf_pack_stock">
												<div class="panel-body">
													<%if articulos("unidades_de_pedido")<>"" then%>
														<div>
															<b><%=lista_articulos_gag_panel_articulos_informacion_unidad_pedido%>:</b> 
															<br>
															<%=articulos("unidades_de_pedido")%>
														</div>				
													<%end if%>
													<%if articulos("packing")<>"" then%>
														<div><b><%=lista_articulos_gag_panel_articulos_informacion_caja_completa%>:</b> <%=articulos("packing")%></div>				
													<%end if%>
												</div>
											</div>
										</div><!--col-md-5-->
										
										
									</div><!--row-->
									<!--fin informacion general del articulo-->
									
									<!--imagen, precios y cantidades del articulo-->
									<div class="col-md-12">
										<!--imagen del articulo-->
										<div class="col-md-6 panel_sinmargen_lados" align="center">
											<div class="thumb-holder" >
												<%
												ruta_icono= Server.MapPath("../Imagenes_Articulos/" & articulos("id") & ".jpg")
												if fs_icono.FileExists(ruta_icono) then
												  imagen_a_enlazar="../Imagenes_Articulos/" & articulos("id") & ".jpg"
												  icono_a_mostrar="../Imagenes_Articulos/Miniaturas/i_" & articulos("id") & ".jpg"
												else
												  imagen_a_enlazar="../Imagenes_Articulos/no_imagen.jpg"
												  icono_a_mostrar="../Imagenes_Articulos/Miniaturas/i_no_imagen.jpg"
												end if
												
												%>
												<a href="<%=imagen_a_enlazar%>" target="_blank">
													<img class="img-responsive" src="<%=icono_a_mostrar%>" border="0" id="img_<%=articulos("id")%>"/>
												</a>
											</div>
										</div>
										<!-- fin imagen del articulo-->
										
										<!--tabla de precios y cantidades a pedir-->	
										<div class="col-md-6 panel_sinmargen_lados">
											<%
											set cantidades_precios=Server.CreateObject("ADODB.Recordset")
					
											sql="SELECT * FROM CANTIDADES_PRECIOS"
											sql=sql & " WHERE CODIGO_ARTICULO=" & articulos("id")
											' la oficina 9825 - 231 GLS GUARROMAN que es franquicia, puede pedir 
											' el articulo 3418 - RPOPE0610 - PRECINTO DE SEGURIDAD TRAILER, que tienen las propias
											' ahora el articulos es nuevo, 3676 - NLOPE0610 -  PRECINTO DE SEGURIDAD TRAILER
											' de la familia GLS_OPERACIONES. codigo 204 y con el precio pe propias
											if session("usuario")=9825 and articulos("id")=3676 then
												sql=sql & " AND TIPO_SUCURSAL='PROPIA'"
											  else
												sql=sql & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
											end if
											sql=sql & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
											sql=sql & " ORDER BY CANTIDAD"
											'response.write("<br>CANTIDADES PRECIOS: " & sql)
														
											with cantidades_precios
												.ActiveConnection=connimprenta
												.CursorType=3 'adOpenStatic
												.Source=sql
												.Open
											end with
											%>         
														
											<%
											mostrar_boton="SI"
											
											
											
											IF articulos("stock")<=0 and articulos("stock_minimo")>=1 and mostrar_boton="SI"  then
												mostrar_boton="SIN_STOCK"
											END IF
											
											'si es un tallaje, para que pueda pedir de las tallas que haya
											if mostrar_boton="SIN_STOCK" AND articulos("descripcion_grupo")<>"" THEN
												mostrar_boton="SI"
											end if
											'los clientes de redyser de primer pedido pueden pedir todo aunque no haya stock
											if session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI" then
												mostrar_boton="SI"
											end if
											
											'PARA LAS AGENCIAS PROPIAS DE GLS MENOS LA 280-51, 280-5, 280-01, 280-02, 280-03, 280-04, 81-01 y LAS DE PORTUGAL, NO PUEDEN PEDIR DIRECTAMENTE
											'  - VESTUARIO LABORAL 
											'  - VESTUARIO NEGOCIOS
											'  - ROPA NUEVA LINEA
											
											'response.write("<br>familia: " & articulos("familia") &"<br>cliente: " & session("usuario") & "<br>tipo usuario: " & session("usuario_tipo") & "<br>empresa: " & session("usuario_codigo_empresa"))
											if (articulos("familia")=186 or articulos("familia")=187 or articulos("familia")=227 or articulos("familia")=228 or articulos("familia")=244) and (session("usuario")<>7395 and session("usuario")<>5089 and session("usuario")<>5085 and session("usuario")<>8351 and session("usuario")<>8352 and session("usuario")<>8353 and session("usuario")<>7633) and session("usuario_tipo")="GLS PROPIA" and session("usuario_codigo_empresa")=4 then
												mostrar_boton="NO_VESTUARIO"
											  else
											  	'las nuevas camisas de vestuario de negocio.. ids de 3952 a 3987 solo las pueden pedir 280-5 Compras (5089) y 280-51 Perdidas (7395)
											  	if session("usuario")<>5089 and session("usuario")<>7395 and articulos("id") >= 3952 and articulos("id") <= 3987 then
													if session("usuario_tipo")= "GLS PROPIA" then
														mostrar_boton="NO_VESTUARIO"
													end if
												end if
											end if
											'para HALCON(10) NO FRANQUICIAS, ECUADOR(20) NO FRANQUICIAS, PORTUGAL(80), TRAVELPLAN(90), GLOBALIA CORPORTARE TRAVEL(170)
											' MARSOL(210), AVORIS(230)
											' puede haber articulos con precio asociado pero que no pueden pedrrlos, solo verlos... articulos de material de oficina
											if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 OR session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 then
												if session("usuario_tipo")<>"FRANQUICIA" then
													if articulos("EN_AVORIS_SOLO_VER")="SI" then
														mostrar_boton="EN_AVORIS_SOLO_VER"
													end if
												end if
											  else
											  	'NO PONEMOS GEOMOON (130) PORQUE SON TODO FRANQUICIAS Y PUEDEN PEDIR, COMO las franquicias de halcon y ecuador
											  	if session("usuario_codigo_empresa")=80 or session("usuario_codigo_empresa")=90 or session("usuario_codigo_empresa")=170 _
													or session("usuario_codigo_empresa")=210 or session("usuario_codigo_empresa")=230 then
													if articulos("EN_AVORIS_SOLO_VER")="SI" then
														mostrar_boton="EN_AVORIS_SOLO_VER"
													end if
												end if
											end if
											
											%>
											
													
											<%if not cantidades_precios.eof then%>
												<%'controlamos si hay que mostrar una lista con cantidades fijas a seleccionar
													'o una caja de texto para poner la cantidad deseada de articulo
													'o una tabla de tramos de cantidades con un precio para cada tramo
												Select Case articulos("compromiso_compra")  
    												'********************* MUESTRA LISTA CANTIDADES-PRECIOS
													Case "NO"%>
															<%if ("" & articulos("descripcion_grupo"))="" then%>
																<div class="col-md-12 panel_sinmargen_lados">
																	<div class="panel panel-default" style="padding-bottom:0px ">
																		<div class="panel-body--">
																			<table class="table table-condensed" id="tabla_cantidades_precios_<%=articulos("id")%>" style="margin-bottom:0px "> 
																				<thead> 
																					<tr> 
																						<th style="text-align:right"><%=lista_articulos_gag_panel_articulos_cantidad%></th> 
																						<th style="text-align:right"><%=lista_articulos_gag_panel_articulos_precio_pack%></th> 
																					</tr> 
																				</thead> 
																				<tbody> 
																					<%filas=1
																					cantidad_minima_tramo=""
																					'cantidades_precios.movelast
																					'cantidades_precios.movefirst
																					numero_filas=cantidades_precios.recordcount
																					while not cantidades_precios.eof%>
																					
																						<%
																						cantidades_precio_total_articulo=""
																						'RESPONSE.WRITE("<BR>CANTIDAD: " & cantidades_precios("cantidad"))
																						'RESPONSE.WRITE("<BR>PRECIO UNIDAD: " & cantidades_precios("PRECIO_UNIDAD"))
																						'RESPONSE.WRITE("<BR>PRECIO PACK: " & cantidades_precios("PRECIO_PACK"))
																						
																						cantidades_precio_total_articulo=cantidades_precios("cantidad") & "--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																						%>
																						<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','NO')" class="filas_cantidades">
																							<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																							<td align="right"><%=cantidades_precios("cantidad")%>&nbsp;</td>
																							<td align="right">
																								<%
																									IF cantidades_precios("precio_pack")<>"" then
																										Response.Write(FORMATNUMBER(cantidades_precios("precio_pack"),2) & " €")
																									  else
																										Response.Write("")
																									end if
																								%>
																								&nbsp;
																							</td>
																						</tr>
																						<%
																						filas=filas+1
																						cantidades_precios.movenext%>
																					<%wend%> 
																				</tbody> 
																			</table>
																		</div>
																	</div><!--panel defalut-->
																</div><!--col-md-12-->
															<%end if ' del descripcion_grupo%>
													
													<%'**************************** MUESTRA ' se muestra una caja de texto para poner la cantidad deseada Y PRECIO UNIDAD
													Case "SI"%>
															
															<div class="col-md-12 panel_sinmargen_lados">
																<div class="panel" style="padding-bottom:0px; -webkit-box-shadow: none; box-shadow: none; ">
																	<div class="panel-body--">
																		
																		<table class="table table-borderless"> 
																				<%filas=1
																				cantidad_minima_tramo=""
																				'cantidades_precios.movelast
																				'cantidades_precios.movefirst
																				numero_filas=cantidades_precios.recordcount
																				while not cantidades_precios.eof%>
																					<%
																					'como son articulos con compromiso de compra, la cantidad no es fija, tienen que indicarla
																					cantidades_precio_total_articulo=""
																					cantidades_precio_total_articulo="XXX--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																					%> 
																						<%if ("" & articulos("descripcion_grupo"))="" then%>
																							<tr> 
																								<th width="56%"><b><%=lista_articulos_gag_panel_articulos_precio_unidad%></b></th> 
																								<td width="44%">
																									<%
																									IF cantidades_precios("precio_unidad")<>"" then
																										Response.Write(cantidades_precios("precio_unidad") & " €/u")
																									  else
																										Response.Write("")
																									end if
																									%>
																									&nbsp;
																								</td> 
																							</tr> 
																						<%end if 'del descripcion_grupo%>
																						
																						<%'para que se muestre las cantidades en todos los aritculos, menos en los
																							'de gls, que no se van a pedir de momento
																							if mostrar_boton="SI" then%>
																								<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand; cursor:pointer;" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','SI')" class="filas_cantidades" valign="middle">
																									<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																									<th><%=lista_articulos_gag_panel_articulos_cantidad%></th>
																									<td>
																										<input type="text" class="form-control cantidad_pedida_art" size="5" name="txtcantidad_<%=articulos("id")%>" id="txtcantidad_<%=articulos("id")%>" />
																									</td> 
																								</tr> 
																							<%end if%>
																					<%
																					filas=filas+1
																					cantidades_precios.movenext%>
																				<%wend%>
																		</table>	
																	</div><!-- panel-body -->
																</div><!-- panel-->
															</div><!--col-md-12-->
															
													
													<%Case "TRAMOS"%>
															<%if ("" & articulos("descripcion_grupo"))="" then%>
																<div class="col-md-12 panel_sinmargen_lados">
																	<div class="panel panel-default" style="padding-bottom:0px ">
																		<div class="panel-body--">
																			<table class="table table-condensed" id="tabla_tramos_cantidades_precios_<%=articulos("id")%>" style="margin-bottom:0px "> 
																				<thead> 
																					<tr> 
																						<th style="text-align:center"><%=lista_articulos_gag_panel_articulos_cantidad%></th> 
																						<th style="text-align:right">Precio Ud.</th> 
																					</tr> 
																				</thead> 
																				<tbody> 
																					<%filas=1
																					cantidad_minima_tramo=0
																					'cantidades_precios.movelast
																					'cantidades_precios.movefirst
																					numero_filas=cantidades_precios.recordcount
																					while not cantidades_precios.eof%>
																					
																						<%
																						cantidades_precio_total_articulo=""
																						'RESPONSE.WRITE("<BR>CANTIDAD: " & cantidades_precios("cantidad"))
																						'RESPONSE.WRITE("<BR>PRECIO UNIDAD: " & cantidades_precios("PRECIO_UNIDAD"))
																						'RESPONSE.WRITE("<BR>PRECIO PACK: " & cantidades_precios("PRECIO_PACK"))
																						if filas=1 then
																							cantidad_minima_tramo=cantidades_precios("cantidad")
																						end if
																						cantidades_precio_total_articulo=cantidades_precios("cantidad") & "--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																						%>
																						<tr id="fila_tramo_<%=articulos("id")%>_<%=filas%>" class="filas_cantidades">
																							<td align="left">
																								<%
																								if cantidades_precios("cantidad_superior")<>"" then
																									texto_tramos="de " & cantidades_precios("cantidad") & " a " & cantidades_precios("cantidad_superior")
																								  else
																									texto_tramos="a partir de " & cantidades_precios("cantidad")
																								end if
																								response.write(texto_tramos)
																								%>
																							
																							
																							</td>
																							<td align="right">
																								<%
																									IF cantidades_precios("precio_unidad")<>"" then
																										Response.Write(FORMATNUMBER(cantidades_precios("precio_unidad"),2) & " €")
																									  else
																										Response.Write("")
																									end if
																								%>
																								
																							</td>
																						</tr>
																						<%
																						filas=filas+1
																						cantidades_precios.movenext%>
																					<%wend%> 
																				</tbody> 
																			</table>
																		</div>
																	</div><!--panel defalut-->
																</div><!--col-md-12-->
																
																
																<div class="col-md-12 panel_sinmargen_lados">
																	<div class="panel" style="padding-bottom:0px; -webkit-box-shadow: none; box-shadow: none; ">
																		<div class="panel-body--">
																			
																			<table class="table table-borderless"> 
																					<%'para que se muestre las cantidades en todos los aritculos, menos en los
																								'de gls, que no se van a pedir de momento
																								if mostrar_boton="SI" then%>
																									<tr id="fila_tramo_2_<%=articulos("id")%>_<%=filas%>" class="filas_cantidades" valign="middle">
																										<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																										<th><%=lista_articulos_gag_panel_articulos_cantidad%></th>
																										<td>
																											<input type="text" class="form-control cantidad_pedida_art" size="5" name="txtcantidad_<%=articulos("id")%>" id="txtcantidad_<%=articulos("id")%>" />
																										</td> 
																									</tr> 
																								<%end if%>
																						
																			</table>	
																		</div><!-- panel-body -->
																	</div><!-- panel-->
																</div><!--col-md-12-->
															<%end if 'del descripcion_grupo%>
												
												<%
												End Select%>  
													  
											<%end if 'CANTIDADES_PRECIOS%>
											<%
											cantidades_precios.close
											set cantidadese_precios=Nothing
											%>
										</div>
										<!--fin tabla precios y cantidades-->			
									</div><!--fin del row-->
									<!--la informacion del articulo-->
									
									
									<%
									'solo para los articulos pertenecientes a las familias relaciondas con GLS de asm se muestra este aviso
									'response.write("-" & articulos("familia") & "-")
									if mostrar_boton="NO" then%>
										<br />&nbsp;
										<div class="col-md-10 col-md-offset-2" align="center">
											<div class="alert alert-warning" role="alert"><%=lista_articulos_gag_panel_articulos_alerta_validez%></div>
										</div>
									<%end if%>
									
									<%
									'solo para los articulos pertenecientes a las familias de vestuario de GLS
									' y si la oficina es propia y no es la 280-5, 280-01, 280-02, 280-03, 280-04, 81-01
									if mostrar_boton="NO_VESTUARIO" then%>
										<br />&nbsp;
										<div class="col-md-10 col-md-offset-2" align="center">
											<div class="alert alert-warning" role="alert">Gesti&oacute;n a trav&eacute;s del Site</div>
										</div>
									<%end if%>
									
									<%
									'solo para los articulos que se quedan sin stock
									if mostrar_boton="SIN_STOCK" then
										if session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI" then
											else%>
												<br />&nbsp;
												<div class="col-md-10 col-md-offset-2" align="center">
													No Disponible Temporalmente
												</div>
										<%end if%>
									<%end if%>
									<%
									'para las cadenas de AVORIS, habrá articulos que mostrarán los precios pero no se poddran pedir
									if mostrar_boton="EN_AVORIS_SOLO_VER" then%>
										<br />&nbsp;
										<div class="col-md-10 col-md-offset-2" align="center">
											<div class="alert alert-warning" role="alert">Consultar Departamento de Compras</div>
										</div>
									<%end if%>
									
									
									<!--boton de añadir y packing y tallas-->
									<div class="col-md-12" style="padding-top:10px ">
										<div class="col-md-2">
											<%if mostrar_boton="SI" then%>
												<button type="button" name="cmdannadir_carrito" id="cmdannadir_carrito" class="btn btn-primary btn-sm" onclick="annadir_al_carrito(<%=articulos("ID")%>, '<%=accion%>', '<%=articulos("ID_GRUPO")%>', '<%=cantidad_minima_tramo%>', '<%=tipo_precio%>', '<%=session("usuario_codigo_empresa")%>', '<%=articulos("compromiso_compra")%>')" >
													<i class="glyphicon glyphicon-shopping-cart"></i>
													<span><%=lista_articulos_gag_panel_articulos_boton_annnadir%></span>
												</button>
											<%end if%>
										</div>
										
										<div class="col-md-3">		
											<%IF articulos("plantilla_personalizacion")<>"" then%>
												<div class="col-md-6" id="logo_personalizacion_<%=articulos("id")%>">
													<span class="label label-warning" 
															style="font-size:18px;"
															data-toggle="popover" 
															data-placement="bottom" 
															data-trigger="hover" 
															data-content="<%=lista_articulos_gag_panel_articulos_requiere_personalizacion%>" 
															data-original-title=""
															>
															<i class="glyphicon glyphicon-list-alt" style="padding-top:3px"></i>
													</span>
												</div>
												<%'para los kits parcelshop se muestra primero como no personalizable... pudiendose cambiar desde el check
												if instr("-3765-3766-3767-3768-3769-3770-3771-3772-3773-3774-3775-3776-3777-3778-3779-3780-3781-3782-3783-3784-3785-3786-3787-3788-", _
														"-" & articulos("id") & "-")>0 then%>
														<script language="javascript">
															$('#logo_personalizacion_<%=articulos("id")%>').hide()
														</script>
														
												<%end if%>		
												
											<%end if%>
											
											<%IF articulos("PERMITE_DEVOLUCION")<>"SI" and session("usuario_codigo_empresa")=4 then%>
												<div class="col-md-6">
													<span class="label label-danger" 
															style="font-size:18px;margin-left:3px"
															data-toggle="popover" 
															data-placement="bottom" 
															data-trigger="hover" 
															data-content="No Permite Devolución" 
															data-original-title=""
															>
															<i class="glyphicon glyphicon glyphicon-share-alt glyphicon_rotado" style="padding-top:3px"></i>
													</span>
												</div>
											<%end if%>
										</div>											
										
										<!--tallas y numeros-->
										<%if articulos("descripcion_grupo")<>"" then
											agrupacion_tallaje=articulos("descripcion_grupo")
											cabecera_tallajes=articulos("texto_agrupacion")
											saltar="NO"
											
											if articulos("familia")>=342 and articulos("familia")<=356 then
											%>
												<div class="col-md-7 panel_sinmargen_lados">
											<%else%>
												<div class="col-md-2"> </div>
												<div class="col-md-5 panel_sinmargen_lados">
											<%end if%>
												<%'para los kits de parceshop, muestro un check para que se pueda personalizar o no
												if articulos("ID")>=3765 and articulos("ID")<=3788 then%>
													<div class="form-check" style="text-align:center" >
													  <input class="form-check-input chkpersonalizar_kit" type="checkbox" value="" id="chkpersonalizar_kit_<%=articulos("ID")%>_<%=articulos("ID_GRUPO")%>">
													  <label class="form-check-label" for="chkpersonalizar_kit_<%=articulos("ID")%>_<%=articulos("ID_GRUPO")%>">
														Personalizar Kit
														<span style="font-size: 13px; color: Dodgerblue;" 
																data-toggle="popover"
																data-placement="top"
																data-trigger="hover"
																data-content="Conlleva un Cargo de 15€ adicionales por cada KIT"
																><i class="fas fa-info-circle"></i>
														</span>
													  </label>
													</div>
												<%end if%>

												<div class="panel panel-default" style="padding-bottom:0px ">
												<table class="table table-condensed" id="tabla_tallajes_<%=articulos("ID_GRUPO")%>" style="margin-bottom:0px "> 
													<thead class="cabeceras_tallas" style="cursor:pointer "
														data-toggle="popover" 
														data-placement="top" 
														data-trigger="hover" 
														data-content="Pulsar aqui para Mostrar/Ocultar las diferentes Tallas" 
														data-original-title=""
														> 
														<tr> 
															<th style="text-align:center" colspan="2"><%=cabecera_tallajes%></th> 
														</tr> 
													</thead> 
													<tbody style="display:none "> 
														<%filas_tallaje=1
														'response.write("<br>posible primer movenext")
														while not articulos.eof and saltar="NO"%>
															<%
															
															'if articulos("stock")<=0 or articulos("stock")<=articulos("cantidad_pendiente") then
															IF articulos("stock")<=0 and articulos("stock_minimo")>=1 then
																	if session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI" then%>
																		<tr id="fila_tallaje_<%=articulos("ID_grupo")%>_<%=filas_tallaje%>" style="cursor:hand;cursor:pointer" class="filas_tallajes"
																			onclick="seleccionar_fila_tallaje(<%=articulos("id_grupo")%>,<%=filas_tallaje%>,<%=articulos("id")%>)">
																				<td align="left" ><%=articulos("descripcion_talla")%></td>
																				<td align="right"><span id="visor_precio_tallaje_<%=articulos("ID_grupo")%>_<%=filas_tallaje%>"><%
																					set precios_tallajes=Server.CreateObject("ADODB.Recordset")
															
																					sql_precio_tallajes="SELECT PRECIO_UNIDAD FROM CANTIDADES_PRECIOS"
																					sql_precio_tallajes=sql_precio_tallajes & " WHERE CODIGO_ARTICULO=" & articulos("id")
																					sql_precio_tallajes=sql_precio_tallajes & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
																					sql_precio_tallajes=sql_precio_tallajes & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
																					
																					'response.write("<br>PRECIO_TALLAJES: " & sql_precio_tallajes)
																								
																					precio_tallaje=""			
																					with precios_tallajes
																						.ActiveConnection=connimprenta
																						.CursorType=3 'adOpenStatic
																						.Source=sql_precio_tallajes
																						.Open
																					end with
																					
																					if not precios_tallajes.eof then
																						precio_tallaje=precios_tallajes("PRECIO_UNIDAD")
																						response.write(precio_tallaje & " €")
																					end if
																						
																					precios_tallajes.close
																					set precios_tallajes=nothing
																					%></span>
																					<input type="hidden" class="ocultoprecio_tallaje" value="<%=precio_tallaje%>" />
																				
																				
																				</td>
																		</tr>
																	<%else%>
																		<tr id="fila_tallaje_<%=articulos("ID_grupo")%>_<%=filas_tallaje%>" style="cursor:hand;cursor:pointer" class="filas_tallajes"
																			data-toggle="popover" 
																			data-placement="top" 
																			data-trigger="hover" 
																			data-content="<%=articulos("descripcion_talla")%> No Disponible Temporalmente" 
																			data-original-title="">
																				<td align="left" style="color:#CCCCCC"><%=articulos("descripcion_talla")%></td>
																				<td align="right" style="color:#CCCCCC">
																				<%
																					set precios_tallajes=Server.CreateObject("ADODB.Recordset")
															
																					sql_precio_tallajes="SELECT PRECIO_UNIDAD FROM CANTIDADES_PRECIOS"
																					sql_precio_tallajes=sql_precio_tallajes & " WHERE CODIGO_ARTICULO=" & articulos("id")
																					sql_precio_tallajes=sql_precio_tallajes & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
																					sql_precio_tallajes=sql_precio_tallajes & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
																					
																					'response.write("<br>PRECIO_TALLAJES: " & sql_precio_tallajes)
																								
																					precio_tallaje=""			
																					with precios_tallajes
																						.ActiveConnection=connimprenta
																						.CursorType=3 'adOpenStatic
																						.Source=sql_precio_tallajes
																						.Open
																					end with
																					
																					if not precios_tallajes.eof then
																						precio_tallaje=precios_tallajes("PRECIO_UNIDAD")
																						response.write(precio_tallaje & " €")
																					end if
																						
																					precios_tallajes.close
																					set precios_tallajes=nothing
																					%>
																				</td>
																		</tr>
																	<%end if%>
																<%else%>
																	<tr id="fila_tallaje_<%=articulos("ID_grupo")%>_<%=filas_tallaje%>" style="cursor:hand;cursor:pointer" class="filas_tallajes"
																		onclick="seleccionar_fila_tallaje(<%=articulos("id_grupo")%>,<%=filas_tallaje%>,<%=articulos("id")%>)">
																			<td align="left" ><%=articulos("descripcion_talla")%></td>
																			<td align="right"><span id="visor_precio_tallaje_<%=articulos("ID_grupo")%>_<%=filas_tallaje%>"><%
																					set precios_tallajes=Server.CreateObject("ADODB.Recordset")
															
																					sql_precio_tallajes="SELECT PRECIO_UNIDAD FROM CANTIDADES_PRECIOS"
																					sql_precio_tallajes=sql_precio_tallajes & " WHERE CODIGO_ARTICULO=" & articulos("id")
																					sql_precio_tallajes=sql_precio_tallajes & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
																					sql_precio_tallajes=sql_precio_tallajes & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
																					
																					'response.write("<br>PRECIO_TALLAJES: " & sql_precio_tallajes)
																						
																					precio_tallaje=""			
																					with precios_tallajes
																						.ActiveConnection=connimprenta
																						.CursorType=3 'adOpenStatic
																						.Source=sql_precio_tallajes
																						.Open
																					end with
																					
																					if not precios_tallajes.eof then
																						precio_tallaje=precios_tallajes("PRECIO_UNIDAD")
																						response.write(precio_tallaje & " €")
																					end if
																						
																					precios_tallajes.close
																					set precios_tallajes=nothing
																					%></span>
																					<input type="hidden" class="ocultoprecio_tallaje" value="<%=precio_tallaje%>" />
																			</td>
																	</tr>
															<%end if%>
														
															
															<%
															articulos.movenext
															
															if not articulos.eof then
																'response.write("<br>primer movenext con tallaje<br>nombre: " & articulos("descripcion_idioma") & " -- grupo: " & articulos("descripcion_grupo"))
																filas_tallaje=filas_tallaje + 1
																if agrupacion_tallaje=articulos("descripcion_grupo") then
																	saltar="NO"
																  else
																  	saltar="SI"
																	agrupacion_tallaje=articulos("descripcion_grupo")
																end if
															end if
															%>
														<%wend%>
													</tbody> 
												</table>
												</div>
											</div><!--fin de tallas y numeracion del articulo-->
										  <%else
										  		IF not articulos.eof THEN
											  		articulos.movenext
													'response.write("<br>primer movenext sin tallaje")
												END IF
										end if%>											

									</div><!--del row-->
									<!--fin añadir y packing-->
								</div><!--panel-body-->
							</div><!--panel-->
						</div><!--col-md-6-->
						<!--finaliza el articulo IZQUIERDA-->
					
					
					
					<%
					'****************
					'no hace falta moverse al siguiente si es de los que tienen tallaje, ya se ha movido al siguiente registro al intentar controlar
					' los posibles tallajes del articulo
					'RESPONSE.WRITE("<BR>DESCRIPCION GRUPO: " + articulos("DESCRIPCION_GRUPO"))
					'response.write("<br>posible segundo movenext para saltar al articulos de la derecha")
																
					IF not articulos.eof THEN
						'IF ("" & articulos("DESCRIPCION_GRUPO"))<>"" THEN
						'	articulos.movenext
						'	response.write("<br>segundo movenext<br>nombre: " & articulos("descripcion_idioma") & " -- grupo: " & articulos("descripcion_grupo"))
							
						'END IF
					END IF
					%>
					
					<%IF not articulos.eof THEN%>
						
						<!--comienza el articulo DERECHA-->
						<a name="pto_<%=articulos("id")%>" id="pto_<%=articulos("id")%>"></a>
						<div class="col-md-6">
							<div class="panel panel-primary item col_articulo_2 item_<%=articulos("ID")%>">
								<div class="panel-heading" style="padding-bottom:2px;padding-top:2px">
									<div class="panel-title"><H5><%=REPLACE(REPLACE(articulos("DESCRIPCION_IDIOMA"),".",""), "·","")%></H5></div>
								</div>
							
								<!--
								<div class="panel-heading"  style="padding-bottom:2px;padding-top:2px"></div>
								-->
								<div class="panel-body" style="padding-left:1px; padding-left:1px; padding-top:0px;">
									<!--informacion general del articulo-->
									<div class="row">
										<div class="col-md-7">
											<div style="padding-top:5px"></div>
											<div class="panel panel-default__ inf_general_art"  onclick="muestra_datos_articulo(<%=articulos("ID")%>, <%=session("usuario_codigo_empresa")%>)" 
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover" 
												data-content="<%=lista_articulos_gag_panel_articulos_informacion_alter%>" 
												data-original-title=""
												>
												<div class="panel-body" style="cursor:pointer;cursor:hand">
													<%
													'response.write("<br>descripcion grupo: " & articulos("descripcion_grupo"))
													if ("" & articulos("descripcion_grupo"))="" then%>
														<div align="left"><b><%=lista_articulos_gag_panel_articulos_informacion_referencia%>:</b> <%=articulos("codigo_sap")%><br></div>
													<%end if%>
													<div align="left"><b><%=lista_articulos_gag_panel_articulos_informacion_familia%></b>  <%=articulos("nombre_familia")%><br></div>
													<%
													'el perfil de ASM no tiene que ver este dato de Requiere Autorizacion
													' el de UVE HOTELES TAMPOCO - 150
													' el de IMPRENTA TAMPOCO - 220
													' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
													' 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR tampoco
													if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150 _
														and session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80 _
														and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170 _
														and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 _
														and session("usuario_codigo_empresa")<>220 and session("usuario_codigo_empresa")<>240 and session("usuario_codigo_empresa")<>250 _
														and session("usuario_codigo_empresa")<>260 then%>		
													
														<div align="left"><b><%=lista_articulos_gag_panel_filtros_requiere_autorizacion_alter%>:</b>
															<%IF articulos("requiere_autorizacion")="SI" THEN%>
																<B style="color:#FF0000"><%=lista_articulos_gag_panel_filtros_combo_autorizacion_si%></B>
															<%ELSE%>	
																<%=lista_articulos_gag_panel_filtros_combo_autorizacion_no%>
															<%END IF%>
															<br>
														</div>
													<%end if%>
												</div>
											</div>
											
										</div><!--col-md-7-->
										<div class="col-md-5">
											<div style="padding-top:5px"></div>
											<div class="panel inf_pack_stock">
												<div class="panel-body">
													<%if articulos("unidades_de_pedido")<>"" then%>
														<div>
															<b><%=lista_articulos_gag_panel_articulos_informacion_unidad_pedido%>:</b> 
															<br>
															<%=articulos("unidades_de_pedido")%>
														</div>				
													<%end if%>
													<%if articulos("packing")<>"" then%>
														<div><b><%=lista_articulos_gag_panel_articulos_informacion_caja_completa%>:</b> <%=articulos("packing")%></div>				
													<%end if%>
												</div>
											</div>
										</div><!--col-md-5-->
									</div><!--row-->
									<!--fin informacion general del articulo-->
									
									<!--imagen, precios y cantidades del articulo-->
									<div class="col-md-12">
										<!--imagen del articulo-->
										<div class="col-md-6 panel_sinmargen_lados" align="center">
											<div class="thumb-holder" >
												<%
												ruta_icono= Server.MapPath("../Imagenes_Articulos/" & articulos("id") & ".jpg")
												if fs_icono.FileExists(ruta_icono) then
												  imagen_a_enlazar="../Imagenes_Articulos/" & articulos("id") & ".jpg"
												  icono_a_mostrar="../Imagenes_Articulos/Miniaturas/i_" & articulos("id") & ".jpg"
												else
												  imagen_a_enlazar="../Imagenes_Articulos/no_imagen.jpg"
												  icono_a_mostrar="../Imagenes_Articulos/Miniaturas/i_no_imagen.jpg"
												end if
												
												%>
												<a href="<%=imagen_a_enlazar%>" target="_blank">
													<img src="<%=icono_a_mostrar%>" height="8" border="0" class="img-responsive" id="img_<%=articulos("id")%>"/>
												</a>
												
										  </div>
										</div>
										<!-- fin imagen del articulo-->
										
										<!--tabla de precios y cantidades a pedir-->	
										<div class="col-md-6 panel_sinmargen_lados">
											<%
											set cantidades_precios=Server.CreateObject("ADODB.Recordset")
					
											sql="SELECT * FROM CANTIDADES_PRECIOS"
											sql=sql & " WHERE CODIGO_ARTICULO=" & articulos("id")
											' la oficina 9825 - 231 GLS GUARROMAN que es franquicia, puede pedir 
											' el articulo 3418 - RPOPE0610 - PRECINTO DE SEGURIDAD TRAILER, que tienen las propias
											' ahora el articulos es nuevo, 3676 - NLOPE0610 -  PRECINTO DE SEGURIDAD TRAILER
											' de la familia GLS_OPERACIONES. codigo 204 y con el precio pe propias
											if session("usuario")=9825 and articulos("id")=3676 then
												sql=sql & " AND TIPO_SUCURSAL='PROPIA'"
											  else
												sql=sql & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
											end if
											sql=sql & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
											sql=sql & " ORDER BY CANTIDAD"
											'response.write("<br>" & sql)
														
											with cantidades_precios
												.ActiveConnection=connimprenta
												.CursorType=3 'adOpenStatic
												.Source=sql
												.Open
											end with
											%>         
														
														
											<%
											mostrar_boton="SI"
											
											
											IF articulos("stock")<=0 and articulos("stock_minimo")>=1 and mostrar_boton="SI"  then
												mostrar_boton="SIN_STOCK"
											END IF
											
											if mostrar_boton="SIN_STOCK" AND articulos("descripcion_grupo")<>"" THEN
												mostrar_boton="SI"
											end if
											
											'los clientes de redyser de primer pedido pueden pedir todo aunque no haya stock
											if session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI" then
												mostrar_boton="SI"
											end if
											
											'PARA LAS AGENCIAS PROPIAS DE GLS MENOS LA 280-51, 280-5, 280-01, 280-02, 280-03, 280-04, 81-01, NO PUEDEN PEDIR DIRECTAMENTE
											'  - VESTUARIO LABORAL 
											'  - VESTUARIO NEGOCIOS
											'  - ROPA NUEVA LINEA
											'response.write("<br>familia: " & articulos("familia") &"<br>cliente: " & session("usuario") & "<br>tipo usuario: " & session("usuario_tipo") & "<br>empresa: " & session("usuario_codigo_empresa"))
											if (articulos("familia")=186 or articulos("familia")=187 or articulos("familia")=227 or articulos("familia")=228 or articulos("familia")=244) and (session("usuario")<>7395 and session("usuario")<>5089 and session("usuario")<>5085 and session("usuario")<>8351 and session("usuario")<>8352 and session("usuario")<>8353 and session("usuario")<>7633) and session("usuario_tipo")="GLS PROPIA"  and session("usuario_codigo_empresa")=4 then
												mostrar_boton="NO_VESTUARIO"
											  else
												'las nuevas camisas de vestuario de negocio.. ids de 3952 a 3987 solo las pueden pedir 280-5 Compras (5089) y 280-51 Perdidas (7395)
											  	if session("usuario")<>5089 and session("usuario")<>7395 and articulos("id") >= 3952 and articulos("id") <= 3987 then
													if session("usuario_tipo")= "GLS PROPIA" then
														mostrar_boton="NO_VESTUARIO"
													end if
												end if
											end if
											
											'para HALCON(10) NO FRANQUICIAS, ECUADOR(20) NO FRANQUICIAS, PORTUGAL(80), TRAVELPLAN(90), GLOBALIA CORPORTARE TRAVEL(170)
											' MARSOL(210), AVORIS(230)
											' puede haber articulos con precio asociado pero que no pueden pedrrlos, solo verlos... articulos de material de oficina
											if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 then
												if session("usuario_tipo")<>"FRANQUICIA" then
													if articulos("EN_AVORIS_SOLO_VER")="SI" then
														mostrar_boton="EN_AVORIS_SOLO_VER"
													end if
												end if
											  else
											  	'NO PONEMOS GEOMOON (130) PORQUE SON TODO FRANQUICIAS Y PUEDEN PEDIR, COMO las franquicias de halcon y ecuador
											  	if session("usuario_codigo_empresa")=80 or session("usuario_codigo_empresa")=90 or session("usuario_codigo_empresa")=170 _
													or session("usuario_codigo_empresa")=210 or session("usuario_codigo_empresa")=230 then
													if articulos("EN_AVORIS_SOLO_VER")="SI" then
														mostrar_boton="EN_AVORIS_SOLO_VER"
													end if
												end if
											end if
											%>
													
													
													
											
													
													
													
											<%if not cantidades_precios.eof then%>
												<%'controlamos si hay que mostrar una lista con cantidades fijas a seleccionar
													'o una caja de texto para poner la cantidad deseada de articulo
													'o una tabla de tramos de cantidades con un precio para cada tramo
												Select Case articulos("compromiso_compra")  
    												'********************* MUESTRA LISTA CANTIDADES-PRECIOS
													Case "NO"%>
														<%if ("" & articulos("descripcion_grupo"))="" then%>
															<div class="col-md-12 panel_sinmargen_lados">
																<div class="panel panel-default" style="padding-bottom:0px ">
																	<div class="panel-body--">
																		<table class="table table-condensed" id="tabla_cantidades_precios_<%=articulos("id")%>" style="margin-bottom:0px "> 
																			<thead> 
																				<tr> 
																					<th style="text-align:right"><%=lista_articulos_gag_panel_articulos_cantidad%></th> 
																					<th style="text-align:right"><%=lista_articulos_gag_panel_articulos_precio_pack%></th> 
																				</tr> 
																			</thead> 
																			<tbody> 
																				<%filas=1
																				cantidad_minima_tramo=""
																				'cantidades_precios.movelast
																				'cantidades_precios.movefirst
																				numero_filas=cantidades_precios.recordcount
																				while not cantidades_precios.eof%>
																				
																					<%
																					cantidades_precio_total_articulo=""
																					'RESPONSE.WRITE("<BR>CANTIDAD: " & cantidades_precios("cantidad"))
																					'RESPONSE.WRITE("<BR>PRECIO UNIDAD: " & cantidades_precios("PRECIO_UNIDAD"))
																					'RESPONSE.WRITE("<BR>PRECIO PACK: " & cantidades_precios("PRECIO_PACK"))
																					
																					cantidades_precio_total_articulo=cantidades_precios("cantidad") & "--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																					%>
																					<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','NO')" class="filas_cantidades">
																						<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																						<td align="right"><%=cantidades_precios("cantidad")%>&nbsp;</td>
																						<td align="right">
																							<%
																								IF cantidades_precios("precio_pack")<>"" then
																									Response.Write(FORMATNUMBER(cantidades_precios("precio_pack"),2) & " €")
																								  else
																									Response.Write("")
																								end if
																							%>
																							&nbsp;
																						</td>
																					</tr>
																					<%
																					filas=filas+1
																					cantidades_precios.movenext%>
																				<%wend%> 
																			</tbody> 
																		</table>
																	</div>
																</div><!--panel defalut-->
															</div><!--col-md-12-->											
														<%end if 'de descripcion_grupo ""%>
														
													<%'**************************** MUESTRA ' se muestra una caja de texto para poner la cantidad deseada Y PRECIO UNIDAD
													Case "SI"%>
											
														<div class="col-md-12 panel_sinmargen_lados">
															<div class="panel" style="padding-bottom:0px; -webkit-box-shadow: none; box-shadow: none; ">
																<div class="panel-body--">
																	
																		<table class="table table-borderless"> 
																				<%filas=1
																				cantidad_minima_tramo=""
																				'cantidades_precios.movelast
																				'cantidades_precios.movefirst
																				numero_filas=cantidades_precios.recordcount
																				while not cantidades_precios.eof%>
																					<%
																					'como son articulos con compromiso de compra, la cantidad no es fija, tienen que indicarla
																					cantidades_precio_total_articulo=""
																					cantidades_precio_total_articulo="XXX--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																					%> 
																					
																						<%if ("" & articulos("descripcion_grupo"))="" then%>	
																							<tr> 
																								<th width="56%"><b><%=lista_articulos_gag_panel_articulos_precio_unidad%></b></th> 
																								<td width="44%">
																									<%
																									IF cantidades_precios("precio_unidad")<>"" then
																										Response.Write(cantidades_precios("precio_unidad") & " €/u")
																									  else
																										Response.Write("")
																									end if
																									%>
																									&nbsp;
																								</td> 
																							</tr> 
																						<%end if 'del descripcion_grupo%>
																						
																						<%'para que se muestre las cantidades en todos los aritculos, menos en los
																						'de gls, que no se van a pedir de momento
																						if mostrar_boton="SI" then%>
																							<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand; cursor:pointer;" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','SI')" class="filas_cantidades" valign="middle">
																								<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																								<th><%=lista_articulos_gag_panel_articulos_cantidad%></th>
																								<td>
																									<input type="text" class="form-control cantidad_pedida_art" size="5" name="txtcantidad_<%=articulos("id")%>" id="txtcantidad_<%=articulos("id")%>" />
																								</td> 
																							</tr> 
																						<%END IF%>
																					<%
																					filas=filas+1
																					cantidades_precios.movenext%>
																				<%wend%>
																		</table>	
																	
																</div><!-- panel-body -->
															</div><!-- panel-->
														</div><!--col-md-12-->
													
													<%Case "TRAMOS"%>
															<%if ("" & articulos("descripcion_grupo"))="" then%>
																<div class="col-md-12 panel_sinmargen_lados">
																	<div class="panel panel-default" style="padding-bottom:0px ">
																		<div class="panel-body--">
																			<table class="table table-condensed" id="tabla_tramos_cantidades_precios_<%=articulos("id")%>" style="margin-bottom:0px "> 
																				<thead> 
																					<tr> 
																						<th style="text-align:center"><%=lista_articulos_gag_panel_articulos_cantidad%></th> 
																						<th style="text-align:right">Precio Ud.</th> 
																					</tr> 
																				</thead> 
																				<tbody> 
																					<%filas=1
																					cantidad_minima_tramo=0
																					'cantidades_precios.movelast
																					'cantidades_precios.movefirst
																					numero_filas=cantidades_precios.recordcount
																					while not cantidades_precios.eof%>
																					
																						<%
																						cantidades_precio_total_articulo=""
																						'RESPONSE.WRITE("<BR>CANTIDAD: " & cantidades_precios("cantidad"))
																						'RESPONSE.WRITE("<BR>PRECIO UNIDAD: " & cantidades_precios("PRECIO_UNIDAD"))
																						'RESPONSE.WRITE("<BR>PRECIO PACK: " & cantidades_precios("PRECIO_PACK"))
																						if filas=1 then
																							cantidad_minima_tramo=cantidades_precios("cantidad")
																						end if
																						cantidades_precio_total_articulo=cantidades_precios("cantidad") & "--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																						%>
																						<tr id="fila_tramo_<%=articulos("id")%>_<%=filas%>" class="filas_cantidades">
																							<td align="left">
																								<%
																								if cantidades_precios("cantidad_superior")<>"" then
																									texto_tramos="de " & cantidades_precios("cantidad") & " a " & cantidades_precios("cantidad_superior")
																								  else
																									texto_tramos="a partir de " & cantidades_precios("cantidad")
																								end if
																								response.write(texto_tramos)
																								%>
																							
																							
																							</td>
																							<td align="right">
																								<%
																									IF cantidades_precios("precio_unidad")<>"" then
																										Response.Write(FORMATNUMBER(cantidades_precios("precio_unidad"),2) & " €")
																									  else
																										Response.Write("")
																									end if
																								%>
																								
																							</td>
																						</tr>
																						<%
																						filas=filas+1
																						cantidades_precios.movenext%>
																					<%wend%> 
																				</tbody> 
																			</table>
																		</div>
																	</div><!--panel defalut-->
																</div><!--col-md-12-->
															
															
																<div class="col-md-12 panel_sinmargen_lados">
																	<div class="panel" style="padding-bottom:0px; -webkit-box-shadow: none; box-shadow: none; ">
																		<div class="panel-body--">
																			
																			<table class="table table-borderless"> 
																					<%'para que se muestre las cantidades en todos los aritculos, menos en los
																								'de gls, que no se van a pedir de momento
																								if mostrar_boton="SI" then%>
																									<tr id="fila_tramo_2_<%=articulos("id")%>_<%=filas%>" class="filas_cantidades" valign="middle">
																										<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																										<th><%=lista_articulos_gag_panel_articulos_cantidad%></th>
																										<td>
																											<input type="text" class="form-control cantidad_pedida_art" size="5" name="txtcantidad_<%=articulos("id")%>" id="txtcantidad_<%=articulos("id")%>" />
																										</td> 
																									</tr> 
																								<%end if%>
																						
																			</table>	
																		</div><!-- panel-body -->
																	</div><!-- panel-->
																</div><!--col-md-12-->
															<%end if 'del descripcion_grupo%>
												
												<%
												End Select%>  
													  
											<%end if 'CANTIDADES_PRECIOS%>
											<%
											cantidades_precios.close
											set cantidades_precios=Nothing
											%>
										</div>
										<!--fin tabla precios y cantidades-->			
									</div><!--fin del row-->
									<!--la informacion del articulo-->
									
									<%
									'solo para los articulos pertenecientes a las familias relaciondas con GLS de asm se muestra este aviso
									'response.write("-" & articulos("familia") & "-")
									if mostrar_boton="NO" then%>
										<br />&nbsp;
										<div class="col-md-10 col-md-offset-2" align="center">
											<div class="alert alert-warning" role="alert"><%=lista_articulos_gag_panel_articulos_alerta_validez%></div>
										</div>
									<%end if%>
									
									<%
									'solo para los articulos pertenecientes a las familias de vestuario de GLS
									' y si la oficina es propia y no es la 280-05, 280-01, 280-02, 280-03, 280-04, 81-01
									if mostrar_boton="NO_VESTUARIO" then%>
										<br />&nbsp;
										<div class="col-md-10 col-md-offset-2" align="center">
											<div class="alert alert-warning" role="alert">Gesti&oacute;n a trav&eacute;s del Site</div>
										</div>
									<%end if%>
									
									<%
									'solo para los articulos que se quedan sin stock
									if mostrar_boton="SIN_STOCK" then
										if session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI" then
										  else%>
												<br />&nbsp;
												<div class="col-md-10 col-md-offset-2" align="center">
													No Disponible Temporalmente	
												</div>
										<%end if%>
									<%end if%>
									
									<%
									'para las cadenas de AVORIS, habrá articulos que mostrarán los precios pero no se poddran pedir
									if mostrar_boton="EN_AVORIS_SOLO_VER" then%>
										<br />&nbsp;
										<div class="col-md-10 col-md-offset-2" align="center">
											<div class="alert alert-warning" role="alert">Consultar Departamento de Compras</div>
										</div>
									<%end if%>
									
									<!--boton de añadir y packing y tallas-->
									<div class="col-md-12" style="padding-top:10px ">
										<div class="col-md-2">
											<%if mostrar_boton="SI" then%>
												<button type="button" name="cmdannadir_carrito" id="cmdannadir_carrito" class="btn btn-primary btn-sm" onclick="annadir_al_carrito(<%=articulos("ID")%>, '<%=accion%>', '<%=articulos("id_GRUPO")%>', '<%=cantidad_minima_tramo%>', '<%=tipo_precio%>', '<%=session("usuario_codigo_empresa")%>', '<%=articulos("compromiso_compra")%>')" >
													<i class="glyphicon glyphicon-shopping-cart"></i>
													<span><%=lista_articulos_gag_panel_articulos_boton_annnadir%></span>
												</button>
											<%end if%>
										</div>
										<div class="col-md-3">
											<%IF articulos("plantilla_personalizacion")<>"" then%>
												<div class="col-md-6" id="logo_personalizacion_<%=articulos("id")%>">
													<span class="label label-warning" 
															style="font-size:18px;"
															data-toggle="popover" 
															data-placement="bottom" 
															data-trigger="hover" 
															data-content="<%=lista_articulos_gag_panel_articulos_requiere_personalizacion%>" 
															data-original-title=""
															>
															<i class="glyphicon glyphicon-list-alt" style="padding-top:3px "></i>
													</span>
												</div>
												<%'para los kits parcelshop se muestra primero como no personalizable... pudiendose cambiar desde el check
												if instr("-3765-3766-3767-3768-3769-3770-3771-3772-3773-3774-3775-3776-3777-3778-3779-3780-3781-3782-3783-3784-3785-3786-3787-3788-", _
														"-" & articulos("id") & "-")>0 then%>
														<script language="javascript">
															$('#logo_personalizacion_<%=articulos("id")%>').hide()
														</script>
														
												<%end if%>	
											<%end if%>
											<%IF articulos("PERMITE_DEVOLUCION")<>"SI" and session("usuario_codigo_empresa")=4 then%>
												<div class="col-md-6">
													<span class="label label-danger" 
															style="font-size:18px;margin-left:3px"
															data-toggle="popover" 
															data-placement="bottom" 
															data-trigger="hover" 
															data-content="No Permite Devolución" 
															data-original-title=""
															>
															<i class="glyphicon glyphicon glyphicon-share-alt glyphicon_rotado" style="padding-top:3px"></i>
													</span>
												</div>
											<%end if%>
										</div>										
										
										<!--tallas y numeros-->
										<%if articulos("descripcion_grupo")<>"" then
											agrupacion_tallaje=articulos("descripcion_grupo")
											cabecera_tallajes=articulos("texto_agrupacion")
											saltar="NO"
											
											if articulos("familia")>=342 and articulos("familia")<=356 then
											%>
												
												<div class="col-md-7  panel_sinmargen_lados">
											<%else%>
												<div class="col-md-2"> </div>
												<div class="col-md-5 panel_sinmargen_lados">
											<%end if%>
										
												<%'para los kits de parceshop, muestro un check para que se pueda personalizar o no
												if articulos("ID")>=3765 and articulos("ID")<=3788 then%>
													<div class="form-check" style="text-align:center ">
													  <input class="form-check-input chkpersonalizar_kit" type="checkbox" value="" id="chkpersonalizar_kit_<%=articulos("ID")%>_<%=articulos("ID_GRUPO")%>">
													  <label class="form-check-label" for="chkpersonalizar_kit_<%=articulos("ID")%>_<%=articulos("ID_GRUPO")%>">
														Personalizar Kit
														<span style="font-size: 13px; color: Dodgerblue;" 
																data-toggle="popover"
																data-placement="top"
																data-trigger="hover"
																data-content="Conlleva un Cargo de 15€ adicionales por cada KIT"
																><i class="fas fa-info-circle"></i>
														</span>
													  </label>
													</div>
												<%end if%>
											
											
												<div class="panel panel-default" style="padding-bottom:0px ">
												<table class="table table-condensed" id="tabla_tallajes_<%=articulos("ID_GRUPO")%>" style="margin-bottom:0px "> 
													<thead class="cabeceras_tallas" style="cursor:pointer "
														data-toggle="popover" 
														data-placement="top" 
														data-trigger="hover" 
														data-content="Pulsar aqui para Mostrar/Ocultar las diferentes Tallas" 
														data-original-title=""
														> 
														<tr> 
															<th style="text-align:center" colspan="2"><%=cabecera_tallajes%></th> 
														</tr> 
													</thead> 
													<tbody style="display:none "> 
														<%filas_tallaje=1
														while not articulos.eof and saltar="NO"%>
															<%
															  'if articulos("stock")<=0 or articulos("stock")<=articulos("cantidad_pendiente") then
															  IF articulos("stock")<=0 and articulos("stock_minimo")>=1 then
																	if session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI" then%>
																		<tr id="fila_tallaje_<%=articulos("ID_grupo")%>_<%=filas_tallaje%>" style="cursor:hand;cursor:pointer" class="filas_tallajes"
																			onclick="seleccionar_fila_tallaje(<%=articulos("id_grupo")%>,<%=filas_tallaje%>,<%=articulos("id")%>)">
																			<td align="left" ><%=articulos("descripcion_talla")%></td>
																			<td align="right"><span id="visor_precio_tallaje_<%=articulos("ID_grupo")%>_<%=filas_tallaje%>"><%
																					set precios_tallajes=Server.CreateObject("ADODB.Recordset")
															
																					sql_precio_tallajes="SELECT PRECIO_UNIDAD FROM CANTIDADES_PRECIOS"
																					sql_precio_tallajes=sql_precio_tallajes & " WHERE CODIGO_ARTICULO=" & articulos("id")
																					sql_precio_tallajes=sql_precio_tallajes & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
																					sql_precio_tallajes=sql_precio_tallajes & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
																					
																					'response.write("<br>PRECIO_TALLAJES: " & sql_precio_tallajes)
																								
																					precio_tallaje=""			
																					with precios_tallajes
																						.ActiveConnection=connimprenta
																						.CursorType=3 'adOpenStatic
																						.Source=sql_precio_tallajes
																						.Open
																					end with
																					
																					if not precios_tallajes.eof then
																						precio_tallaje=precios_tallajes("PRECIO_UNIDAD")
																						response.write(precio_tallaje & " €")
																					end if
																						
																					precios_tallajes.close
																					set precios_tallajes=nothing
																					%></span>
																					<input type="hidden" class="ocultoprecio_tallaje" value="<%=precio_tallaje%>" />
																				
																				
																				</td>
																		</tr>
																	<%else%>
																		<tr id="fila_tallaje_<%=articulos("ID_grupo")%>_<%=filas_tallaje%>" style="cursor:hand;cursor:pointer" class="filas_tallajes"
																			data-toggle="popover" 
																			data-placement="top" 
																			data-trigger="hover" 
																			data-content="<%=articulos("descripcion_talla")%> No Disponible Temporalmente" 
																			data-original-title="">
																			<td align="left" style="color:#CCCCCC"><%=articulos("descripcion_talla")%></td>
																			<td align="right" style="color:#CCCCCC">
																				<%
																					set precios_tallajes=Server.CreateObject("ADODB.Recordset")
															
																					sql_precio_tallajes="SELECT PRECIO_UNIDAD FROM CANTIDADES_PRECIOS"
																					sql_precio_tallajes=sql_precio_tallajes & " WHERE CODIGO_ARTICULO=" & articulos("id")
																					sql_precio_tallajes=sql_precio_tallajes & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
																					sql_precio_tallajes=sql_precio_tallajes & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
																					
																					'response.write("<br>PRECIO_TALLAJES: " & sql_precio_tallajes)
																								
																					precio_tallaje=""			
																					with precios_tallajes
																						.ActiveConnection=connimprenta
																						.CursorType=3 'adOpenStatic
																						.Source=sql_precio_tallajes
																						.Open
																					end with
																					
																					if not precios_tallajes.eof then
																						precio_tallaje=precios_tallajes("PRECIO_UNIDAD")
																						response.write(precio_tallaje & " €")
																					end if
																						
																					precios_tallajes.close
																					set precios_tallajes=nothing
																					%>
																				</td>
																		</tr>
																	<%end if%>
																<%else%>
																	<tr id="fila_tallaje_<%=articulos("ID_grupo")%>_<%=filas_tallaje%>" style="cursor:hand;cursor:pointer" class="filas_tallajes"
																		onclick="seleccionar_fila_tallaje(<%=articulos("id_grupo")%>,<%=filas_tallaje%>,<%=articulos("id")%>)">
																		<td align="left" ><%=articulos("descripcion_talla")%></td>
																		<td align="right"><span id="visor_precio_tallaje_<%=articulos("ID_grupo")%>_<%=filas_tallaje%>"><%
																					set precios_tallajes=Server.CreateObject("ADODB.Recordset")
															
																					sql_precio_tallajes="SELECT PRECIO_UNIDAD FROM CANTIDADES_PRECIOS"
																					sql_precio_tallajes=sql_precio_tallajes & " WHERE CODIGO_ARTICULO=" & articulos("id")
																					sql_precio_tallajes=sql_precio_tallajes & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
																					sql_precio_tallajes=sql_precio_tallajes & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
																					
																					'response.write("<br>PRECIO_TALLAJES: " & sql_precio_tallajes)
																						
																					precio_tallaje=""			
																					with precios_tallajes
																						.ActiveConnection=connimprenta
																						.CursorType=3 'adOpenStatic
																						.Source=sql_precio_tallajes
																						.Open
																					end with
																					
																					if not precios_tallajes.eof then
																						precio_tallaje=precios_tallajes("PRECIO_UNIDAD")
																						response.write(precio_tallaje & " €")
																					end if
																						
																					precios_tallajes.close
																					set precios_tallajes=nothing
																					%></span>
																					<input type="hidden" class="ocultoprecio_tallaje" value="<%=precio_tallaje%>" />
																			</td>
																	</tr>
															<%end if%>
															
															<%
															'response.write("<br>posible tercer movenext")
															articulos.movenext
															if not articulos.eof then
																'response.write("<br>tercer movenext<br>nombre: " & articulos("descripcion_idioma") & " -- grupo: " & articulos("descripcion_grupo"))
																
																filas_tallaje=filas_tallaje + 1
																if agrupacion_tallaje=articulos("descripcion_grupo") then
																	saltar="NO"
																  else
																  	saltar="SI"
																	agrupacion_tallaje=articulos("descripcion_grupo")
																end if
															end if
															%>
														<%wend%>
													</tbody> 
												</table>
												</div>
											</div><!--fin de tallas y numeracion del articulo-->
											
											<%else
												articulos.movenext%>
										<%end if%>											

										
										
										
									</div><!--del col-md-12-->
									<!--fin añadir y packing-->
								</div><!--panel-body-->
							</div><!--panel-->
						</div><!--col-md-6-->
						<!--finaliza el articulo DERECHA-->
					</div><!--row-->
					<script language="javascript">
						//procedimiento que iguala la altura de las 2 celdas (paneles) de cada fila
						//porque con la clase table_cell... tambien se iguala, pero se descoloca
						//todo a lo ancho
						altura_1=$(".col_articulo_1").height()
						altura_2=$(".col_articulo_2").height()
						altura=altura_1
						if (altura_2>altura)
							{
							altura=altura_2
							}
						
						//$(".col_articulo_1").height(altura)
						//$(".col_articulo_2").height(altura)
						$('.col_articulo_1').css('min-height', altura + 'px')
						$('.col_articulo_2').css('min-height', altura + 'px')
						//console.log('altura1: ' + altura_1 + ' ... altura2: ' + altura_2 + ' ... altura tomada: ' + altura)
						
						$(".col_articulo_1" ).removeClass("col_articulo_1")
						$(".col_articulo_2" ).removeClass("col_articulo_2")

					</script>					
						
				<%END IF 'IF NOT ARTICULOS.EOF%>	
				<%
				'no hace falta moverse al siguiente si es de los que tienen tallaje, ya se ha movido al siguiente registro al intentar controlar
				' los posibles tallajes del articulo
				'RESPONSE.WRITE("<BR>DESCRIPCION GRUPO: " + articulos("DESCRIPCION_GRUPO"))
				IF not articulos.eof THEN
					IF ("" & articulos("DESCRIPCION_GRUPO"))="" THEN
						'articulos.movenext
						'response.write("<br>cuarto movenext<br>nombre: " & articulos("descripcion_idioma") & " -- grupo: " & articulos("descripcion_grupo"))
					END IF
				END IF
				%>
			<%
			wend
			set fs_icono=nothing
			%>
        </div><!--panel-body-->
      </div><!--panel-->
    </div>
    <!--FINAL COLUMNA DE LA DERECHA-->
  </div>    
  <!-- FINAL DE LA PANTALLA -->
</div>
<!--FINAL CONTAINER-->
<script language="javascript">
	$("#pantalla_avisos").modal("hide");
</script>








<input type="hidden" name="ocultoarticulo" id="ocultoarticulo" value=""/>
<input type="hidden" name="ocultocantidades_precios" id="ocultocantidades_precios" value="" />



<form action="Lista_Articulos_Gag.asp?acciones=<%=accion%>" method="post" id="frmbotones" name="frmbotones">
	<input type="hidden" id="ocultoseleccion_asm_gls" name="ocultoseleccion_asm_gls" value="" />
</form>
				<!-- END SHOPPAGE_HEADER.HTM -->
				
<input type="hidden" id="ocultopersonalizados" name="ocultopersonalizados" value="" />
		
<!--<script type="text/javascript" src="../plugins/jquery/jquery-1.12.4.min.js"></script>-->


<script>


$(document).ready(function() {
    //para que se configuren los popover-titles...
	$('[data-toggle="popover"]').popover({html:true});
	
	//$('#cmbfamilias_agrupadas_otra').multiselect({ enableClickableOptGroups: true, buttonWidth: '100%', nonSelectedText: 'Seleccionar' });
	
	<%' PARA HALCON, ECUADOR, GROUNDFORCE, AIR EUROPA, CALDERON, HALCON VIAJGENS, TRAVEPLAN, TIBILLETE, GLOBALIA, GEOMOON, GLOBALIA CORPORATE TRAVEL, MARSOL Y AVORIS
		'mostramos un combo diferente con familias y agrupaciones de familias
	if session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=30 or session("usuario_codigo_empresa")=40 or session("usuario_codigo_empresa")=50 or session("usuario_codigo_empresa")=80 or session("usuario_codigo_empresa")=90 or session("usuario_codigo_empresa")=100 or session("usuario_codigo_empresa")=110 or session("usuario_codigo_empresa")=130 or session("usuario_codigo_empresa")=170 or session("usuario_codigo_empresa")=210 or session("usuario_codigo_empresa")=230 or session("usuario_codigo_empresa")=240 or session("usuario_codigo_empresa")=250 or session("usuario_codigo_empresa")=260 then %>
		$('.selectpicker').selectpicker();
		$("#cmbfamilias_agrupadas_otra").selectpicker('val', [<%=familias_buscadas_otra%>]);
		
		$(".dropdown-header").each(function (index, header) {
			var header = $(header);
			header.css('cursor', 'pointer');
			header.click(function () {
				var dataoptgroup = $(this).attr("data-optgroup");
				var group_lis = $('li[data-optgroup=' + dataoptgroup + ']').filter('li[data-original-index]');
	
				todas_seleccionadas="SI"
				group_lis.each(function (index, option) {
					if  (!$(option).hasClass('selected'))
						{
						todas_seleccionadas="NO"
						}
				});
				//console.log('todas seleccionadas: ' + todas_seleccionadas)
				if (todas_seleccionadas=='NO')
					{
						group_lis.each(function (index, option) {
							if  (!$(option).hasClass('selected'))
								{
								$(option).find("a").click()
								}
						});
					}
				  else
				  	{
						group_lis.each(function (index, option) {
							$(option).find("a").click()
						});
					}
				
			});
		});
		
		
	<%end if%>
	//console.log('altura columna: ' + $("#probando").height())

	mostrar_resumen_carrito()
});


function meter_al_carrito(id_articulo)
{
		//console.log('meter al carrito')
		var cart = $('.shopping-cart');
        var imgtodrag = $("#img_" + id_articulo);
		//var imgtodrag = $(this).parent('.item').find("img").eq(0);
		
		if (imgtodrag) {
            var imgclone = imgtodrag.clone()
				.offset({
                	top: imgtodrag.offset().top,
					left: imgtodrag.offset().left
			 	})
                .css({
                'opacity': '0.5',
                    'position': 'absolute',
                    //'height': '150px',
                    //'width': '150px',
                    'z-index': '100'
            })
                .appendTo($('body'))
				.animate({
                	'top': cart.offset().top + 10,
                    'left': cart.offset().left + 10,
					'width': 75,
                    'height': 75
            }, 1000, 'easeInOutExpo');
            
			setTimeout(function () {
                cart.effect("shake", {
                    times: 2
                }, 200);
            }, 1500);

			imgclone.animate({
                'width': 0,
                    'height': 0
            }, function () {
                $(this).detach()
            });
        }
}

// para que se ponga visible siempre la columna de la izquierda
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
	location.href='Carrito_Gag.asp?acciones=<%=accion%>'
});

$("#cmdborrar_pedido").on("click", function () {
	pagina_url='Vaciar_Carrito_Gag.asp'
	parametros=''
	mostrar_capa(pagina_url,'capa_annadir_articulo', parametros)
	
	cadena='<BR><BR><H4>El Carrito Ha Sido Vaciado...</H4><BR><BR>'
	$("#cabecera_pantalla_avisos").html("Avisos")
	$("#pantalla_avisos .modal-header").show()
	$("#body_avisos").html(cadena + "<br>");
	$("#pantalla_avisos").modal("show");
	
	mostrar_resumen_carrito()
	//location.href='Vaciar_Carrito_Gag.asp'
});

$("#cmdconsultar_pedidos").on("click", function () {
	location.href='Consulta_Pedidos_Gag.asp'
});
$("#cmdconsultar_devoluciones").on("click", function () {
	location.href='Consulta_Devoluciones_Gag.asp'
});
$("#cmdconsultar_saldos").on("click", function () {
	location.href='Consulta_Saldos_Gag.asp'
});

$("#cmdimpresoras").on("click", function () {
	location.href='Consulta_Impresoras_GLS.asp'
});


$(".chkpersonalizar_kit").on("click", function () {
	//console.log('pulsado el check' + this.id)
	//console.log('marcado: ' + this.checked)
	datos=this.id.replace('chkpersonalizar_kit_','')
	datos=datos.split('_')
	//console.log('id articulo: ' + datos[0])
	//console.log('tallaje: ' + datos[1])
	
	//si es personalizado se incrementan todos los precios 15€
	if (this.checked)
		{
		$("#logo_personalizacion_" + datos[0]).show()
		$('#tabla_tallajes_' + datos[1] + ' .ocultoprecio_tallaje').each(function (index) 
			{
			//console.log('fila tallajes ' + index  )
			//console.log('precio: ' + $(this).val())
			//console.log('precio visor: ' + $("#visor_precio_tallaje_" + datos[1] + "_" + (index+1)).text())
			//console.log('colorcito fila ' + index + ': ' + $(this).css('font-weight'))
			precio_nuevo=parseFloat($(this).val().replace(',', '.')) + 15.00
			precio_nuevo=Math.round10(precio_nuevo, -2)
			$(this).val(precio_nuevo.toString().replace('.', ','))
			$("#visor_precio_tallaje_" + datos[1] + "_" + (index+1)).text(precio_nuevo.toString().replace('.', ',') + ' €')
			//console.log('precio nuevo: ' + $(this).val())
			//console.log('precio visor nuevo: ' + $("#visor_precio_tallaje_" + datos[1] + "_" + (index+1)).text())
			});
		$("#ocultopersonalizados").val($("#ocultopersonalizados").val() + '-' + datos[0] + '-')
		}
	  else
	  	{
		$("#logo_personalizacion_" + datos[0]).hide()
		$('#tabla_tallajes_' + datos[1] + ' .ocultoprecio_tallaje').each(function (index) 
			{
			//console.log('fila tallajes ' + index  )
			//console.log('precio: ' + $(this).val())
			//console.log('precio visor: ' + $("#visor_precio_tallaje_" + datos[1] + "_" + (index+1)).text())
			//console.log('colorcito fila ' + index + ': ' + $(this).css('font-weight'))
			precio_nuevo=parseFloat($(this).val().replace(',', '.')) - 15.00
			precio_nuevo=Math.round10(precio_nuevo, -2)
			$(this).val(precio_nuevo.toString().replace('.', ','))
			$("#visor_precio_tallaje_" + datos[1] + "_" + (index+1)).text(precio_nuevo.toString().replace('.', ',') + ' €')
			//console.log('precio nuevo: ' + $(this).val())
			//console.log('precio visor nuevo: ' + $("#visor_precio_tallaje_" + datos[1] + "_" + (index+1)).text())
			});
		//console.log('-' + datos[1] + '-')	
		$("#ocultopersonalizados").val($("#ocultopersonalizados").val().replace('-' + datos[0] + '-', ''))
		}
		
	//vemos si hay seleccionada alguna fila de la tabla de tallajes
	$('#tabla_tallajes_' + datos[1] + ' .filas_tallajes').each(function (index) 
		{
		//console.log('fila tallaje ' + index)
		fontWeight = $(this).css('font-weight')
		//y guardamos el precio indicado en la tabla de tallajes... 
		//por si pulsa primero la talla y despues el check de personalizacion...  no se actualizaria bien el precio personalizado o no
		//el tallaje seleccionado se pone en negrita
		if (fontWeight == 'bold' || fontWeight == '700')
			{
			//console.log('precio seleccionado en la fila ' + index + ': ' + $('.ocultoprecio_tallaje', this).val())
			//console.log('valor de oculto precio tallaje: ' + $("#ocultoprecio_tallaje_seleccionado").val())
			$("#ocultoprecio_tallaje_seleccionado").val($('.ocultoprecio_tallaje', this).val())
			
			
			}
		});
	
});

$('.cabeceras_tallas tr').on("click",function(){
   var texto_cabecera = $(this).closest('table').find('thead tr th').html();
   /*
   console.log('cabecera antes del cambio: ' + texto_cabecera)
   console.log('index of tallas: ' + texto_cabecera.indexOf("Tallas"))
   console.log('index of numeros: ' + texto_cabecera.indexOf("Números"))
   console.log('index of colores: ' + texto_cabecera.indexOf("Colores"))
   console.log('index of idiomas: ' + texto_cabecera.indexOf("Idiomas"))
   */
   $(this).closest('table').find('tbody').fadeToggle();
   
	if (texto_cabecera.indexOf("Tallas")>0)
		{
		$(this).closest('table').find('thead tr th').html(texto_cabecera == "Ver Tallas" ? "Ocultar Tallas" : "Ver Tallas");
		}
	if (texto_cabecera.indexOf("Números")>0)
		{
		$(this).closest('table').find('thead tr th').html(texto_cabecera == "Ver Números" ? "Ocultar Números" : "Ver Números");
		}
	if (texto_cabecera.indexOf("Colores")>0)
		{
		$(this).closest('table').find('thead tr th').html(texto_cabecera == "Ver Colores" ? "Ocultar Colores" : "Ver Colores");
		}
	if (texto_cabecera.indexOf("Idiomas")>0)
		{
		$(this).closest('table').find('thead tr th').html(texto_cabecera == "Ver Idiomas" ? "Ocultar Idiomas" : "Ver Idiomas");
		}

   
   

});


$("#cmbfamilias").on("change", function () {
<%if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150 AND session("usuario_codigo_empresa")<>130 AND session("usuario_codigo_empresa")<>220 then%>						  
	//la familias de merchan personalizable y no pone vacio el combo de autorizaciones									
	//la familias de merchan personalizable, no personalizable e, higienicos y seguridad pone vacio el combo de autorizaciones									
	if ($("#cmbfamilias").val()==222 || $("#cmbfamilias").val()==223 
			|| $("#cmbfamilias").val()==224 || $("#cmbfamilias").val()==225 
			|| $("#cmbfamilias").val()==245 || $("#cmbfamilias").val()==246 
			|| $("#cmbfamilias").val()==298 || $("#cmbfamilias").val()==299 || $("#cmbfamilias").val()==301
			|| $("#cmbfamilias").val()==314 || $("#cmbfamilias").val()==315 || $("#cmbfamilias").val()==317)
		{
		$("#cmbautorizacion").val('')
		}
<%end if%>
	
});

$('.inf_general_art').hover(
       function(){ $(this).addClass('panel-primary') },
       function(){ $(this).removeClass('panel-primary') }
)

muestra_datos_articulo = function(articulo, empresa) {
	cadena='<iframe id="iframe_datos_articulo" src="Datos_Articulo_Gag.asp?articulo=' + articulo + '&empresa=' + empresa + '" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe>'
	$("#pantalla_avisos .modal-header").hide()
	$("#body_avisos").html(cadena);
	$("#pantalla_avisos").modal("show");
  };  


cambiar_imagen = function(empresa) {
	if (empresa=='ASM')
		{
		$("#logo_asm").attr("src","images/Boton_Principal_ASM_Pulsado.jpg");
		seleccion_asm_gls='ASM'
		}
	if (empresa=='GLS')
	 	{
		$("#logo_gls").attr("src","images/Boton_Principal_GLS_Pulsado.jpg");
		seleccion_asm_gls='GLS'
		}
	if (empresa=='GLS_PARCELSHOP')
	 	{
		$("#logo_gls_parcelshop").attr("src","images/Boton_Principal_GLS_ParcelShop_Pulsado.jpg");
		seleccion_asm_gls='GLS_PARCELSHOP'
		}

	$("#ocultoseleccion_asm_gls").val(seleccion_asm_gls)	
	$("#frmbotones").submit()
  };  

cambiar_imagen_agrupacion = function(empresa) {
	if (empresa=='ASM')
		{
		$("#logo_asm_agrupacion").attr("src","images/Boton_Principal_ASM_Pulsado.jpg");
		seleccion_asm_gls='ASM'
		}
	if (empresa=='GLS')
	 	{
		$("#logo_gls_agrupacion").attr("src","images/Boton_Principal_GLS_Pulsado.jpg");
		seleccion_asm_gls='GLS'
		}
	if (empresa=='GLS_PARCELSHOP')
	 	{
		$("#logo_gls_parcelshop_agrupacion").attr("src","images/Boton_Principal_GLS_PARCELSHOP_Pulsado.jpg");
		seleccion_asm_gls='GLS_PARCELSHOP'
		}

	$("#ocultoseleccion_asm_gls").val(seleccion_asm_gls)	
	$("#frmbotones").submit()
  }; 


mostrar_resumen_carrito = function() {
	$.ajax({
		type: "post",  
		async: false, // La petición es síncrona
		cache: false,      
		url: '../tojson/obtener_resumen_carrito.asp',
		success: function(respuesta) {
					  //console.log('el precio es de: ' + respuesta)
					  //console.log('cambiamos el  contenido de ocultocantidades_precios_' + articulo)
					  //console.log('cantidaddes...: ' + document.getElementById('txtcantidad_' + articulo).value)
					  //console.log('cantidad_seleccionada: ' + cantidad_seleccionada)
					  //console.log('precios...: ' + respuesta)
					  $("#capa_resumen_carrito").html(respuesta)
					},
		error: function() {
				bootbox.alert({
					message: "Se ha producido un error crear el resumen del carrito",
					//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
					//callback: refrescar_stock()
				})
			}
	});
	
	
	

}


// funciones para el redondeo correcto, al final vienen ejemplos de uso
  /**
   * Ajuste decimal de un número.
   *
   * @param {String}  tipo  El tipo de ajuste.
   * @param {Number}  valor El numero.
   * @param {Integer} exp   El exponente (el logaritmo 10 del ajuste base).
   * @returns {Number} El valor ajustado.
   */
function decimalAdjust(type, value, exp) {
    // Si el exp no está definido o es cero...
    if (typeof exp === 'undefined' || +exp === 0) {
      return Math[type](value);
    }
    value = +value;
    exp = +exp;
    // Si el valor no es un número o el exp no es un entero...
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

</script>       



				
</body>
<%
	articulos.close
	
	connimprenta.close
			  
			
	set articulos=Nothing
	
	set connimprenta=Nothing
%>
</html>

