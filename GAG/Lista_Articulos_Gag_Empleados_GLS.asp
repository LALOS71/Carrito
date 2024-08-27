<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
'Response.CharSet = "UTF-8"

		Response.Buffer = TRUE
		if session("usuario")="" then
			Response.Redirect("../Login_GLS_Empleados.asp")
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
		orden_buscado=Request.form("cmborden")
		campo_autorizacion=Request.form("cmbautorizacion")
		descripcion_impresora_buscada=Request.form("txtdescripcion_impresora")
		'response.write("<br>AGRUPACION FAMILIA BUSCADA: " & agrupacion_familia_buscada)
		
		accion=Request.QueryString("acciones")
		pto_articulo=Request.form("ocultopto_articulo")
		
		'response.write("<br>accion: " & accion)
		opciones_varias=Split(accion,"--") 

		'para que no se lie con la posicion de meses y dias en las fechas
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExec


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
		'if articulo_buscado="" and codigo_sap_buscado="" and campo_autorizacion="" then
		'	realizar_consulta="NO"
			'si no se filtra por nada, que muestre los articulos que no requieren autorizacion
		'	campo_autorizacion="NO"
		'end if
		
		


		
		set tipos_precios=Server.CreateObject("ADODB.Recordset")
		sql="Select TIPO_PRECIO from V_CLIENTES where NOMBRE = '" & session("usuario_nombre") & "' and EMPRESA=" & session("usuario_codigo_empresa") 
		with tipos_precios
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
			'response.write("<br>tipos precios: " & sql)
			tipo_precio=tipos_precios("tipo_precio")
		end with
		tipos_precios.close
		set tipos_precios=Nothing
		
		
		
		
		
		
		
'************************************************************
'PONEMOS LAS VARIALES DE SESION PARA CONTROLAR LOS TIPOS DE ROPA Y LIMITES DE CANTIDADES QUE PUEDE PEDIR EL EMPLEADO

set gestion_ropa=Server.CreateObject("ADODB.Recordset")

'para que no se lie con la pisicion de meses y dias en las fechas
connimprenta.Execute "set dateformat dmy",,adCmdText + adExec

sql = "SELECT GRUPOS.* "
sql = sql & ", ISNULL(GRUPOS.PEDIDOS_ANT,0) - ISNULL(DEVOLUCIONES.UNIDADES_RESTAR,0) AS CANTIDAD_YA_PEDIDA"
sql = sql & " FROM"
sql = sql & " (SELECT ID, DESCRIPCION, ABREVIATURA, FECHA_DESDE, PERIODICIDAD, CANTIDAD_LIMITE, PERIODO_VENTA, FECHA_ACTUAL"
'sql = sql & "--***************************************"
'sql = sql & "-- CAMPO PARA CALCULAR LA CANTIDAD YA PEDIDA EN FUNCION DE LAS FECHAS DE LOS PEDIDOS"
'sql = sql & "--***************************************"
sql = sql & ", ISNULL((SELECT SUM(Z.CANTIDAD)"
sql = sql & " FROM PEDIDOS_DETALLES Z"
sql = sql & " INNER JOIN"
sql = sql & " (SELECT ID_ARTICULO FROM GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS"
sql = sql & " WHERE GRUPO = " & session("usuario_directorio_activo_grupo_empleado")
'tenemos los pantalones de invierno en 2 grupos, uno en verano y otro en invierno
sql = sql & " AND (PERIODO='TODO' OR PERIODO=TABLA.PERIODO_VENTA)"
sql = sql & ") Y"

sql = sql & " ON Z.ARTICULO=Y.ID_ARTICULO"
sql = sql & " INNER JOIN PEDIDOS X ON Z.ID_PEDIDO=X.ID"
sql = sql & " INNER JOIN V_CLIENTES W ON X.CODCLI=W.ID"
sql = sql & " INNER JOIN GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS V ON Z.ARTICULO=V.ID_ARTICULO"
'tenemos los pantalones de invierno en 2 grupos, uno en verano y otro en invierno
sql = sql & " AND (PERIODO='TODO' OR PERIODO=TABLA.PERIODO_VENTA)"

sql = sql & " INNER JOIN EMPLEADOS_GLS U ON X.USUARIO_DIRECTORIO_ACTIVO= U.ID"
sql = sql & " WHERE X.USUARIO_DIRECTORIO_ACTIVO = " & session("usuario_directorio_activo") 
sql = sql & " AND Z.ESTADO<>'ANULADO'"
sql = sql & " AND Z.ESTADO<>'RECHAZADO'"
sql = sql & " AND V.ID_GRUPO_ROPA=TABLA.ID"
sql = sql & " AND V.GRUPO = " & session("usuario_directorio_activo_grupo_empleado") 
sql = sql & " AND W.EMPRESA=4"
'sql = sql & "-------------------------------------------"
'sql = sql & "-- condicion para comprobar los limites de las fechas de los pedidos"
'sql = sql & "-------------------------------------------"
sql = sql & " AND CONVERT(VARCHAR(8), X.FECHA, 112) >= " 'yyyymmdd
sql = sql & "CONVERT(VARCHAR(8), ("
sql = sql & "SELECT TOP 1"
sql = sql & " CASE WHEN TABLA.PERIODICIDAD=24 THEN"
sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='VERANO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI'"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO'"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())>7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())<7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE()) - 2) AS varchar), 103)"
sql = sql & "	 	END"


sql = sql & "	 WHEN TABLA.PERIODICIDAD=12 THEN "
sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='VERANO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI'"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO'"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE())) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())>7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE())) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())<7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"
sql = sql & "	 	END"

sql = sql & "	 WHEN TABLA.PERIODICIDAD=6 THEN"
sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(DATEPART(year, GETDATE()) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())>7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(DATEPART(year, GETDATE()) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())<7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"
sql = sql & "	 	END"

sql = sql & "	 WHEN TABLA.PERIODICIDAD=0 THEN CONVERT(DATETIME, '01-01-2000', 103)"
sql = sql & " END AS FECHA_LIMITE"

sql = sql & " FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & " WHERE"
sql = sql & "("
sql = sql & "(PERIODO_VENTA='VERANO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & " AND EMPLEADO_NUEVO='SI')"
  else
	sql = sql & " AND EMPLEADO_NUEVO='NO')"
end if
sql = sql & " OR (PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & " AND EMPLEADO_NUEVO='SI'"
  else
	sql = sql & " AND EMPLEADO_NUEVO='NO'"
end if
sql = sql & " AND MES>7))"

sql = sql & " AND PERIODO_VENTA=TABLA.PERIODO_VENTA"

IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & " AND EMPLEADO_NUEVO='SI'"
  else
	sql = sql & " AND EMPLEADO_NUEVO='NO'"
end if
sql = sql & " ORDER BY MES"
sql = sql & ")"
sql = sql & ", 112)"
'sql = sql & "-------------------------------------------"
'sql = sql & "-- fin condicion para comprobar los limites de las fechas de los pedidos"
'sql = sql & "-------------------------------------------"
sql = sql & " GROUP BY V.ID_GRUPO_ROPA), 0) AS PEDIDOS_ANT"
'sql = sql & "--***************************************"
'sql = sql & "-- FIN CAMPO PARA CALCULAR LA CANTIDAD YA PEDIDA EN FUNCION DE LAS FECHAS DE LOS PEDIDOS"
'sql = sql & "--***************************************"
'sql = sql & "--***************************************"
'sql = sql & "-- CAMPO PARA VER LA FECHA LIMITE DESDE LA QUE SE COMPRUEBA LA PERIODICIDAD"
'sql = sql & "--***************************************"
sql = sql & ", CONVERT(VARCHAR(8), ("
sql = sql & "SELECT TOP 1"
sql = sql & " CASE WHEN TABLA.PERIODICIDAD=24 THEN"
sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='VERANO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI'"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO'"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())>7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())<7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE()) - 2) AS varchar), 103)"
sql = sql & "	 	END"


sql = sql & "	 WHEN TABLA.PERIODICIDAD=12 THEN "
sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='VERANO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI'"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO'"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE())) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())>7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE())) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())<7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "					) AS varchar) +  '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"
sql = sql & "	 	END"

sql = sql & "	 WHEN TABLA.PERIODICIDAD=6 THEN"
sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(DATEPART(year, GETDATE()) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())>7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(DATEPART(year, GETDATE()) AS varchar), 103)"
sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())<7"
sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"
sql = sql & "	 	END"

sql = sql & "	 WHEN TABLA.PERIODICIDAD=0 THEN CONVERT(DATETIME, '01-01-2000', 103)"
sql = sql & " END AS FECHA_LIMITE"

sql = sql & " FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & " WHERE"
sql = sql & "("
sql = sql & "(PERIODO_VENTA='VERANO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & " AND EMPLEADO_NUEVO='SI')"
  else
	sql = sql & " AND EMPLEADO_NUEVO='NO')"
end if
sql = sql & " OR (PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & " AND EMPLEADO_NUEVO='SI'"
  else
	sql = sql & " AND EMPLEADO_NUEVO='NO'"
end if
sql = sql & " AND MES>7))"

sql = sql & " AND PERIODO_VENTA=TABLA.PERIODO_VENTA"

IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & " AND EMPLEADO_NUEVO='SI'"
  else
	sql = sql & " AND EMPLEADO_NUEVO='NO'"
end if
sql = sql & " ORDER BY MES"
sql = sql & ")"
sql = sql & ", 112) AS FECHA_LIMITE_PERIODICIDAD"
'sql = sql & "--***************************************"
'sql = sql & "-- FIN CAMPO PARA VER LA FECHA LIMITE DESDE LA QUE SE COMPRUEBA LA PERIODICIDAD"
'sql = sql & "--***************************************"

sql = sql & " FROM"
sql = sql & "(SELECT C.ID, C.DESCRIPCION, C.ABREVIATURA, C.FECHA_DESDE"
'sql = sql & "--***************************************"
'sql = sql & "-- CAMPO PERIODICIDAD DE CADA TIPO DE ROPA"
'sql = sql & "--***************************************"
sql = sql & ", (SELECT TOP 1 PERIODICIDAD"
sql = sql & " FROM GRUPOS_EMPLEADOS_GRUPOS_ROPA_LIMITES"
sql = sql & " WHERE PERIODO_VENTA=A.PERIODO_VENTA"
sql = sql & " AND GRUPO_ROPA = C.ID"
sql = sql & " AND GRUPO_EMPLEADO = " & session("usuario_directorio_activo_grupo_empleado")
sql = sql & " ) AS PERIODICIDAD"
'sql = sql & "--***************************************"
'sql = sql & "-- FINAL PERIODICIDAD DE CADA TIPO DE ROPA"
'sql = sql & "--***************************************"
'sql = sql & "--***************************************"
'sql = sql & "-- CANTIDAD LIMITE DE CADA TIPO DE ROPA"
'sql = sql & "--***************************************"
sql = sql & ", CASE WHEN A.PERIODO_VENTA='VERANO'"
sql = sql & "	THEN CASE WHEN B.EMPLEADO_NUEVO='SI'"
sql = sql & "		THEN NUEVO_VERANO"
sql = sql & "		ELSE REPOSICION_VERANO"
sql = sql & "		END"
sql = sql & "	ELSE CASE WHEN B.EMPLEADO_NUEVO='SI'"
sql = sql & "		THEN NUEVO_INVIERNO"
sql = sql & "		ELSE REPOSICION_INVIERNO"
sql = sql & "		END"
sql = sql & "	END as CANTIDAD_LIMITE"
'sql = sql & "--***************************************"
'sql = sql & "-- FIN CANTIDAD LIMITE DE CADA TIPO DE ROPA"
'sql = sql & "--***************************************"
sql = sql & ", A.PERIODO_VENTA"
sql = sql & ", GETDATE() FECHA_ACTUAL"

sql = sql & " FROM GRUPOS_EMPLEADOS_GRUPOS_ROPA_LIMITES A"
sql = sql & " LEFT JOIN EMPLEADOS_GLS_PERIODOS_VENTA B"
sql = sql & " ON A.PERIODO_VENTA=B.PERIODO_VENTA"
sql = sql & " LEFT JOIN GRUPOS_ROPA_EMPLEADOS_GLS C"
sql = sql & " ON A.GRUPO_ROPA=C.ID"

sql = sql & " WHERE A.GRUPO_EMPLEADO = " & session("usuario_directorio_activo_grupo_empleado")
sql = sql & " AND (B.MES=DATEPART(mm, GETDATE()))"
IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & " AND (B.EMPLEADO_NUEVO='SI')"
  else
	sql = sql & " AND (B.EMPLEADO_NUEVO='NO')"
end if
sql = sql & ")  TABLA"

sql = sql & " WHERE TABLA.CANTIDAD_LIMITE IS NOT NULL"
sql = sql & ") GRUPOS"

'sql = sql & "--***************************************"
'sql = sql & "---LA PARTE AÑADIDA PARA CRUZAR CON LAS DEVOLUCIONES A RESTAR"
'sql = sql & "--***************************************"
 
sql = sql & " LEFT JOIN"

sql = sql & " (SELECT D.ID, D.DESCRIPCION, D.ABREVIATURA, SUM(UNIDADES_ACEPTADAS) AS UNIDADES_RESTAR"
sql = sql & " FROM DEVOLUCIONES A"
sql = sql & " INNER JOIN DEVOLUCIONES_DETALLES B"
sql = sql & " ON A.ID=B.ID_DEVOLUCION"
sql = sql & " INNER JOIN GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS C"
sql = sql & " ON B.ID_ARTICULO=C.ID_ARTICULO AND C.GRUPO=" & session("usuario_directorio_activo_grupo_empleado")
'tenemos los pantalones de invierno en 2 grupos, uno en verano y otro en invierno
'sql = sql & " AND (PERIODO='TODO' OR PERIODO=E.PERIODO_VENTA)"

sql = sql & " INNER JOIN GRUPOS_ROPA_EMPLEADOS_GLS D"
sql = sql & " ON C.ID_GRUPO_ROPA=D.ID"
sql = sql & " INNER JOIN"

sql = sql & " (SELECT GRUPO_ROPA,PERIODICIDAD, PERIODO_VENTA FROM GRUPOS_EMPLEADOS_GRUPOS_ROPA_LIMITES"
sql = sql & " WHERE GRUPO_EMPLEADO=" & session("usuario_directorio_activo_grupo_empleado")
sql = sql & ") E"
sql = sql & " ON E.GRUPO_ROPA=D.ID"

sql = sql & " WHERE A.USUARIO_DIRECTORIO_ACTIVO = " & session("usuario_directorio_activo")
sql = sql & " AND A.ESTADO='CERRADA'"
sql = sql & " AND E.PERIODO_VENTA = (SELECT PERIODO_VENTA"
sql = sql & "  FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "  WHERE MES=DATEPART(mm, GETDATE())"
IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & " AND EMPLEADO_NUEVO='SI')"
  else
	sql = sql & " AND EMPLEADO_NUEVO='NO')"
end if

sql = sql & " AND CONVERT(VARCHAR(8), FECHA_ACEPTACION, 112) >="
sql = sql & " 		CONVERT(VARCHAR(8),"
sql = sql & "			(SELECT TOP 1"
sql = sql & "					CASE WHEN E.PERIODICIDAD=24 "
sql = sql & "						THEN CASE WHEN E.PERIODO_VENTA='VERANO'"
sql = sql & "							THEN CONVERT(DATETIME, '1' + '-' + CAST( (SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "													WHERE E.PERIODO_VENTA='VERANO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & "												AND EMPLEADO_NUEVO='SI')"
  else
	sql = sql & "												AND EMPLEADO_NUEVO='NO')"
end if
sql = sql & "													 AS varchar)"
sql = sql & "													+ '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"

sql = sql & "						WHEN E.PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())>7"
sql = sql & "							THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "									(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "									WHERE E.PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "									) AS varchar) +  '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"
sql = sql & "						WHEN E.PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())<7"
sql = sql & "							THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "									(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "									WHERE E.PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "									) AS varchar) +  '-' + cast((DATEPART(year, GETDATE()) - 2) AS varchar), 103)"
sql = sql & "	 			END"

sql = sql & "				WHEN E.PERIODICIDAD=12"
sql = sql & "					THEN CASE WHEN E.PERIODO_VENTA='VERANO'"
sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST( (SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "													WHERE PERIODO_VENTA='VERANO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & "												AND EMPLEADO_NUEVO='SI')"
  else
	sql = sql & "												AND EMPLEADO_NUEVO='NO')"
end if
sql = sql & "													 AS varchar)"
sql = sql & "													+ '-' + cast((DATEPART(year, GETDATE())) AS varchar), 103)"

sql = sql & "					WHEN E.PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())>7"
sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "								(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "										WHERE PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "								) AS varchar) +  '-' + cast((DATEPART(year, GETDATE())) AS varchar), 103)"
sql = sql & "					WHEN E.PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())<7"
sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST("
sql = sql & "								(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "										WHERE PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
						sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
  				else
						sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
end if
sql = sql & "								) AS varchar) +  '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"
sql = sql & "	 			END"


sql = sql & "	 			WHEN E.PERIODICIDAD=6 THEN"
sql = sql & "					CASE WHEN E.PERIODO_VENTA='VERANO'"
sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(DATEPART(year, GETDATE()) AS varchar), 103)"
sql = sql & "					WHEN E.PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())>7"
sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(DATEPART(year, GETDATE()) AS varchar), 103)"
sql = sql & "					WHEN E.PERIODO_VENTA='INVIERNO' AND DATEPART(MONTH, GETDATE())<7"
sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast((DATEPART(year, GETDATE()) - 1) AS varchar), 103)"
sql = sql & "	 			END"



sql = sql & "				WHEN E.PERIODICIDAD=0 THEN CONVERT(DATETIME, '01-01-2000', 103) END AS FECHA_LIMITE"

 
sql = sql & "			FROM EMPLEADOS_GLS_PERIODOS_VENTA"
sql = sql & "			WHERE"
sql = sql & "				((PERIODO_VENTA='VERANO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & "				AND EMPLEADO_NUEVO='SI')"
  else
	sql = sql & "				AND EMPLEADO_NUEVO='NO')"
end if

sql = sql & "				OR (PERIODO_VENTA='INVIERNO'"
IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & "				AND EMPLEADO_NUEVO='SI'"
  else
	sql = sql & "				AND EMPLEADO_NUEVO='NO'"
end if
sql = sql & "					AND MES>7))"

sql = sql & "				AND PERIODO_VENTA=E.PERIODO_VENTA"
IF session("usuario_directorio_activo_nuevo_empleado") then
	sql = sql & "				AND EMPLEADO_NUEVO='SI'"
  else
	sql = sql & "				AND EMPLEADO_NUEVO='NO'"
end if

sql = sql & "			ORDER BY MES), 112)"

sql = sql & "	GROUP BY D.ID, D.DESCRIPCION, D.ABREVIATURA"
sql = sql & ") DEVOLUCIONES"

sql = sql & " ON GRUPOS.ID=DEVOLUCIONES.ID"

sql = sql & " WHERE FECHA_DESDE IS NULL"
sql = sql & " OR FECHA_DESDE=''"
sql = sql & " OR (CONVERT(VARCHAR(8), FECHA_DESDE, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & session("usuario_directorio_activo_fecha_alta") & "', 103) , 112))" 'pone las 2 fechas en formato yyyymmdd (112--yyyymmdd y 103--dd/mm/yyyy) 


if ver_cadena="SI" then
 	response.write("<br>....GESTION ROPA: " & sql)
end if

connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords

with gestion_ropa
	.ActiveConnection=connimprenta
	.Source=sql
	.Open
end with
		
		
		
		
		
		


		set articulos=Server.CreateObject("ADODB.Recordset")

		'para que no se lie con la posicion de meses y dias en las fechas
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExec		
		
		if realizar_consulta="NO" then
			sql="SELECT ID FROM V_EMPRESAS WHERE 1=0" 'PARA QUE NO DEVUELVA NADA SI NO SE INTRODUCEN FILTROS DE BUSQUEDA
		  else
			sql="SELECT * FROM ("		  
		  	sql=sql & " SELECT CONSULTON.ID, CODIGO_EMPRESA, CODIGO_SAP, CODIGO_EXTERNO,"
			sql=sql & " CASE WHEN DESCRIPCION_GRUPO IS NULL THEN DESCRIPCION_IDIOMA ELSE REPLACE(DESCRIPCION_GRUPO, '.', '') END AS DESCRIPCION_IDIOMA,"
			sql=sql & " TAMANNO, TAMANNO_ABIERTO, TAMANNO_CERRADO, PAPEL, TINTAS, ACABADO, FECHA, COMPROMISO_COMPRA, MOSTRAR," 
			sql=sql & " MULTIARTICULO, UNIDADES_DE_PEDIDO, FAMILIA, nombre_familia, REQUIERE_AUTORIZACION, PACKING,"
			sql=sql & " PLANTILLA_PERSONALIZACION, DESCRIPCION, MATERIAL, PERMITE_DEVOLUCION, TALLAJES.DESCRIPCION_GRUPO, TALLAJES.DESCRIPCION_TALLA,"
			sql=sql & " TALLAJES.ORDEN AS ORDEN_TALLA, TALLAJES.ID_GRUPO, TALLAJES.TEXTO_AGRUPACION, ARTICULOS_MARCAS.STOCK, ARTICULOS_MARCAS.STOCK_MINIMO,"
			'le añado un campo calculado con las cantidades pendientes leidas de los pedidos
			sql=sql & " (select sum(todo.CANTIDAD_PENDIENTE) as CANTIDAD_PENDIENTE"
			sql=sql & " from"
			sql=sql & " (select ARTICULO as ARTICULO , sum(CANTIDAD) as CANTIDAD_PENDIENTE"
			sql=sql & " From PEDIDOS_DETALLES"
			sql=sql & " where ARTICULO=CONSULTON.ID"
			sql=sql & " and ESTADO in ('SIN TRATAR', 'EN PROCESO', 'EN PRODUCCION')"
			sql=sql & " GROUP BY ARTICULO"
			sql=sql & " union"
			sql=sql & " select tabla.ARTICULO, sum(tabla.CANTIDAD_PENDIENTE) as CANTIDAD_PENDIENTE"
			sql=sql & " from"
			sql=sql & " (select a.ARTICULO, a.CANTIDAD"
			sql=sql & " ,(a.CANTIDAD - (select sum(CANTIDAD_ENVIADA) from PEDIDOS_ENVIOS_PARCIALES"
			sql=sql & " where ID_PEDIDO=a.ID_PEDIDO and ID_ARTICULO=a.ARTICULO and ID_ARTICULO=CONSULTON.ID)) as CANTIDAD_PENDIENTE"
			sql=sql & " from PEDIDOS_DETALLES a"
			sql=sql & " where ESTADO ='ENVIO PARCIAL'"
			sql=sql & " and ARTICULO=CONSULTON.ID) as tabla"
			sql=sql & " group by ARTICULO) todo"
			sql=sql & " group by todo.ARTICULO) AS CANTIDAD_PENDIENTE"		
			'hasta aqui el campo calculado de CANTIDAD_PENDIENTE
			
			sql=sql & ", (SELECT TOP(1) ID_GRUPO_ROPA FROM GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS WHERE ID_ARTICULO=CONSULTON.ID"
			'tenemos los pantalones de invierno en 2 grupos, uno en verano y otro en invierno
			sql=sql & " AND (PERIODO='TODO' OR PERIODO='" & gestion_ropa("PERIODO_VENTA") & "')"
			sql=sql & " AND GRUPO=" & session("usuario_directorio_activo_grupo_empleado") & ") AS GRUPO_ROPA"
			sql=sql & ", (SELECT LL.DESCRIPCION FROM GRUPOS_ROPA_EMPLEADOS_GLS LL INNER JOIN (SELECT TOP(1) ID_GRUPO_ROPA FROM GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS WHERE ID_ARTICULO=CONSULTON.ID"
			'tenemos los pantalones de invierno en 2 grupos, uno en verano y otro en invierno
			sql=sql & " AND (PERIODO='TODO' OR PERIODO='" & gestion_ropa("PERIODO_VENTA") & "')"
			sql=sql & " AND GRUPO=" & session("usuario_directorio_activo_grupo_empleado") & ") KK"
			sql=sql & " ON LL.ID= KK.ID_GRUPO_ROPA) AS GRUPO_ROPA_DESCRIPCION"
			sql=sql & ", (SELECT LL.FECHA_DESDE FROM GRUPOS_ROPA_EMPLEADOS_GLS LL INNER JOIN (SELECT TOP(1) ID_GRUPO_ROPA FROM GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS WHERE ID_ARTICULO=CONSULTON.ID"
			'tenemos los pantalones de invierno en 2 grupos, uno en verano y otro en invierno
			sql=sql & " AND (PERIODO='TODO' OR PERIODO='" & gestion_ropa("PERIODO_VENTA") & "')"
			sql=sql & " AND GRUPO=" & session("usuario_directorio_activo_grupo_empleado") & ") KK" 
			sql=sql & " ON LL.ID= KK.ID_GRUPO_ROPA) AS GRUPO_ROPA_FECHA_DESDE"
			'sql=sql & " EXENTO_CONTROL_STOCK"
			
			sql=sql & " FROM (SELECT * FROM"
			sql=sql & " (SELECT ARTICULOS.ID, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, ARTICULOS.CODIGO_SAP, ARTICULOS.CODIGO_EXTERNO,"
			sql=sql & " CASE WHEN ARTICULOS_IDIOMAS.DESCRIPCION IS NULL THEN ARTICULOS.DESCRIPCION ELSE" 
			sql=sql & " ARTICULOS_IDIOMAS.DESCRIPCION END AS DESCRIPCION_IDIOMA,"
			sql=sql & " ARTICULOS.TAMANNO, ARTICULOS.TAMANNO_ABIERTO, ARTICULOS.TAMANNO_CERRADO,"
			sql=sql & " ARTICULOS.PAPEL, ARTICULOS.TINTAS, ARTICULOS.ACABADO, ARTICULOS.FECHA, ARTICULOS.COMPROMISO_COMPRA,"
			sql=sql & " ARTICULOS.MOSTRAR, ARTICULOS.MULTIARTICULO, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS_EMPRESAS.FAMILIA,"
			sql=sql & " FAMILIAS.DESCRIPCION AS nombre_familia, MAX(ARTICULOS.REQUIERE_AUTORIZACION) AS REQUIERE_AUTORIZACION,"
			sql=sql & " MAX(ARTICULOS.PACKING) AS PACKING,"
			sql=sql & " MAX(ARTICULOS_PERSONALIZADOS.PLANTILLA_PERSONALIZACION) AS PLANTILLA_PERSONALIZACION,"
			sql=sql & " ARTICULOS_IDIOMAS.DESCRIPCION, ARTICULOS.MATERIAL, MAX(ARTICULOS.PERMITE_DEVOLUCION) AS PERMITE_DEVOLUCION"
			
			sql=sql & " FROM ARTICULOS INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO "
			'sql=sql & " INNER JOIN FAMILIAS 
			sql=sql & " INNER JOIN" 
			sql=sql & " (SELECT FAMILIAS.ID, FAMILIAS.CODIGO_EMPRESA,"
			sql=sql & "        CASE WHEN FAMILIAS_IDIOMAS.DESCRIPCION IS NULL" 
			sql=sql & "           THEN FAMILIAS.DESCRIPCION ELSE FAMILIAS_IDIOMAS.DESCRIPCION END AS DESCRIPCION"
			sql=sql & "        FROM FAMILIAS LEFT JOIN FAMILIAS_IDIOMAS"
			sql=sql & "        ON (FAMILIAS.ID=FAMILIAS_IDIOMAS.ID_FAMILIA AND FAMILIAS_IDIOMAS.IDIOMA = '" & UCASE(SESSION("idioma")) &"')) AS FAMILIAS"
			
			sql=sql & " ON ARTICULOS_EMPRESAS.FAMILIA = FAMILIAS.ID "
			sql=sql & " INNER JOIN CANTIDADES_PRECIOS ON ARTICULOS.ID = CANTIDADES_PRECIOS.CODIGO_ARTICULO "
			sql=sql & " LEFT JOIN ARTICULOS_PERSONALIZADOS ON ARTICULOS.ID=ARTICULOS_PERSONALIZADOS.ID_ARTICULO"
			sql=sql & " LEFT JOIN ARTICULOS_IDIOMAS"
			sql=sql & " ON (ARTICULOS.ID=ARTICULOS_IDIOMAS.ID_ARTICULO AND ARTICULOS_IDIOMAS.IDIOMA='" & UCASE(SESSION("idioma")) &"')"
			
			sql=sql & " WHERE ARTICULOS.MOSTRAR='SI'"
			sql=sql & " AND CANTIDADES_PRECIOS.TIPO_SUCURSAL='" & tipo_precio & "'"	
			sql=sql & " AND CANTIDADES_PRECIOS.CODIGO_EMPRESA = " & session("usuario_codigo_empresa") 
			sql=sql & " AND ARTICULOS_EMPRESAS.CODIGO_EMPRESA = " & session("usuario_codigo_empresa") 
			sql=sql & " AND ARTICULOS_EMPRESAS.FAMILIA NOT IN (SELECT ID_FAMILIA FROM FAMILIAS_PROHIBIDAS WHERE CLIENTE = " & session("usuario") & ")"
			
			'obligatoriamente, a los empleados de GLS se les muestra solo la familia de GLS ROPA NUEVA LINEA - 244 y GLS SEGURIDAD - 188 (LAS BOTAS Y ZAPATOS DE SEGURIDAD)	
			' Y 318 - GLS VESTUARIO NUEVO LOGO	
			sql=sql & " AND (ARTICULOS_EMPRESAS.FAMILIA=244 OR ARTICULOS_EMPRESAS.FAMILIA=188 OR ARTICULOS_EMPRESAS.FAMILIA=318)"
			
			if codigo_sap_buscado<>"" then
				sql=sql & " AND ARTICULOS.CODIGO_SAP LIKE '%" & codigo_sap_buscado & "%'"
			end if
			if campo_autorizacion="SI" then
				sql=sql & " AND ARTICULOS.REQUIERE_AUTORIZACION='SI'"
			end if
			if campo_autorizacion="NO" then
				sql=sql & " AND (ARTICULOS.REQUIERE_AUTORIZACION='NO' OR ARTICULOS.REQUIERE_AUTORIZACION IS NULL)"
			end if
			
			if campo_autorizacion="NO" then
				sql=sql & " AND (ARTICULOS.REQUIERE_AUTORIZACION='NO' OR ARTICULOS.REQUIERE_AUTORIZACION IS NULL)"
			end if
			
			'muestro solo los articulos que pueden pedir cada grupo concreto de empleados gls
			'if session("usuario_codigo_empresa")=4 and session("usuario_directorio_activo")<>"" and session("usuario_directorio_activo_grupo_empleado")<>"" then
			'	sql=sql & " AND (ARTICULOS.ID IN (SELECT ID_ARTICULO FROM GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS WHERE GRUPO = " & session("usuario_directorio_activo_grupo_empleado") & "))"
			'end if
			
			'muestro solo los articulos que pueden pedir cada grupo concreto de empleados gls y dependiendo del periodo de verano o invierno
			if session("usuario_codigo_empresa")=4 and session("usuario_directorio_activo")<>"" and session("usuario_directorio_activo_grupo_empleado")<>"" then
				'sql=sql & " AND (ARTICULOS.ID IN (SELECT ID_ARTICULO FROM GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS WHERE ID_GRUPO_ROPA IN ("
				'sql=sql & "SELECT GRUPO_ROPA"
				'sql=sql & " FROM GRUPOS_EMPLEADOS_GRUPOS_ROPA_LIMITES A"
				'sql=sql & " LEFT JOIN EMPLEADOS_GLS_PERIODOS_VENTA B"
				'sql=sql & " ON A.PERIODO_VENTA=B.PERIODO_VENTA"
				'sql=sql & " WHERE A.GRUPO_EMPLEADO=" & session("usuario_directorio_activo_grupo_empleado")
				'sql=sql & " AND (B.MES=DATEPART(mm, GETDATE()))"
				'IF session("usuario_directorio_activo_nuevo_empleado") then
				'	sql=sql & " AND (B.EMPLEADO_NUEVO='SI')"
				'  else
				'  	sql=sql & " AND (B.EMPLEADO_NUEVO='NO')"
				'end if
				'sql=sql & ")"
				'sql=sql & " AND GRUPO=" & session("usuario_directorio_activo_grupo_empleado")
				'sql=sql & "))"
				
				
				sql=sql & " AND (ARTICULOS.ID IN (SELECT ID_ARTICULO FROM GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS WHERE ID_GRUPO_ROPA IN ("
				sql=sql & "SELECT GRUPO_ROPA"
				sql=sql & " FROM (SELECT GRUPO_ROPA"
				sql=sql & ", CASE WHEN A.PERIODO_VENTA='VERANO'"
				sql=sql & " 	THEN CASE WHEN B.EMPLEADO_NUEVO='SI'"
				sql=sql & "			THEN NUEVO_VERANO"
				sql=sql & "			ELSE REPOSICION_VERANO"
				sql=sql & "			END"
				sql=sql & "		ELSE CASE WHEN B.EMPLEADO_NUEVO='SI'"
				sql=sql & "			THEN NUEVO_INVIERNO"
				sql=sql & "			ELSE REPOSICION_INVIERNO"
				sql=sql & "			END"
				sql=sql & " END as CANTIDAD_LIMITE"

				sql=sql & " FROM GRUPOS_EMPLEADOS_GRUPOS_ROPA_LIMITES A"
				sql=sql & " LEFT JOIN EMPLEADOS_GLS_PERIODOS_VENTA B"
				sql=sql & " ON A.PERIODO_VENTA=B.PERIODO_VENTA"
				sql=sql & " WHERE A.GRUPO_EMPLEADO=" & session("usuario_directorio_activo_grupo_empleado")
				sql=sql & " AND (B.MES=DATEPART(mm, GETDATE()))"
				IF session("usuario_directorio_activo_nuevo_empleado") then
					sql=sql & " AND (B.EMPLEADO_NUEVO='SI')"
				  else
				  	sql=sql & " AND (B.EMPLEADO_NUEVO='NO')"
				end if
				sql=sql & ") TABLITA"
				sql=sql & " WHERE TABLITA.CANTIDAD_LIMITE IS NOT NULL"
				sql=sql & ")"
				sql=sql & " AND GRUPO=" & session("usuario_directorio_activo_grupo_empleado")
				sql=sql & "))"
			end if
			
			
			

			
			
			
			'si es un empleado nuevo, tenemos que ver si puede pedir dentro del mes despues de su fecha de verano nuevo o invierno nuevo
			'response.write("<br>empresa: " & session("usuario_codigo_empresa"))
			'response.write("<br>usuario nuevo: " & session("usuario_directorio_activo_nuevo_empleado"))
			'response.write("<br>fecha alta: " & session("usuario_directorio_activo_fecha_alta"))
			'response.write("<br>fecha alta mas 3 meses: " & DateAdd("m", 1, session("usuario_directorio_activo_fecha_alta")))
			'response.write("<br>fecha actual: " & now())
			'response.write("<br>date: " & date())
			'response.write("<br>comprobacion fecha alta")
			if session("usuario_codigo_empresa")=4 and session("usuario_directorio_activo_nuevo_empleado") then
				'response.write("<br>usuario nuevo")
				'response.write("<br>fecha_nuevo_Verano: " & session("usuario_directorio_activo_fecha_nuevo_verano"))
				'response.write("<br>fecha_nuevo_invierno: " & session("usuario_directorio_activo_fecha_nuevo_invierno"))
				'response.write("<br>fecha_actual: " & date())
				'response.write("<br>mes actual: " & month(date()))
				
				set periodo_actual_nuevo=Server.CreateObject("ADODB.Recordset")
				'sql_periodos="Select TIPO_PRECIO from V_CLIENTES where NOMBRE = '" & session("usuario_nombre") & "' and EMPRESA=" & session("usuario_codigo_empresa") 
				sql_periodos="SELECT PERIODO_VENTA FROM EMPLEADOS_GLS_PERIODOS_VENTA" 
				sql_periodos=sql_periodos & " WHERE MES = " & month(date()) & " AND EMPLEADO_NUEVO = 'SI'" 
				periodo_buscado=""
				with periodo_actual_nuevo
					.ActiveConnection=connimprenta
					.Source=sql_periodos
					'response.write("<br>sql periodo actual nuevo: " & sql_periodos)
					.Open
					
					if not .eof then
						periodo_buscado = periodo_actual_nuevo("PERIODO_VENTA")
					end if
				end with
				periodo_actual_nuevo.close
				set periodo_actual_nuevo=Nothing
				
				
				'response.write("<br>periodo buscado: " & periodo_buscado)
				
				fecha_sumada=""
				if periodo_buscado="INVIERNO" then
					if session("usuario_directorio_activo_fecha_nuevo_invierno")<>"" then
						fecha_sumada= DateAdd("m", 6, session("usuario_directorio_activo_fecha_nuevo_invierno"))
					end if
				  else
				  	if session("usuario_directorio_activo_fecha_nuevo_verano")<>"" then
					  	fecha_sumada= DateAdd("m", 6, session("usuario_directorio_activo_fecha_nuevo_verano"))
					end if
				end if

				'response.write("<br>fecha sumada: " & fecha_sumada)
				if fecha_sumada="" then
					sql=sql & " AND 1=0"
				  else	
					if fecha_sumada < date() then
						'response.write("<br>fecha alta caducada")
						sql=sql & " AND 1=0"
					end if					
				end if
				
			
			end if
			
			

						
			'CONSUTLA QUE ESTAMOS CONSTRUYENDO PARA LOS LIMITES DE ARTICULOS A PEDIR			
			'SELECT 
			'--*
			'A.ARTICULO, C.FECHA
			' FROM PEDIDOS_DETALLES A
			'INNER JOIN
			'(SELECT ID_ARTICULO FROM GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS
			'WHERE GRUPO=1) B
			'ON A.ARTICULO=B.ID_ARTICULO
			'INNER JOIN PEDIDOS C
			'ON A.ID_PEDIDO=C.ID
			'INNER JOIN V_CLIENTES D
			'ON C.CODCLI=D.ID
			'WHERE C.USUARIO_DIRECTORIO_ACTIVO=748
			'AND D.EMPRESA=4
			
			
			sql=sql & " GROUP BY ARTICULOS.ID, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, ARTICULOS.CODIGO_SAP, ARTICULOS.CODIGO_EXTERNO,"
			sql=sql & " ARTICULOS.DESCRIPCION, ARTICULOS.TAMANNO, ARTICULOS.TAMANNO_ABIERTO, ARTICULOS.TAMANNO_CERRADO,"
			sql=sql & " ARTICULOS.PAPEL, ARTICULOS.TINTAS, ARTICULOS.MATERIAL, ARTICULOS.ACABADO, ARTICULOS.FECHA,"
			sql=sql & " ARTICULOS.COMPROMISO_COMPRA, ARTICULOS.MOSTRAR, ARTICULOS.MULTIARTICULO, ARTICULOS.UNIDADES_DE_PEDIDO,"
			sql=sql & "  ARTICULOS_EMPRESAS.FAMILIA, FAMILIAS.DESCRIPCION, ARTICULOS_IDIOMAS.DESCRIPCION"
			sql=sql & " ) AS ART"

 			sql=sql & " WHERE 1=1"
			
			

			
 			'AQUI VAN LOS FILTROS DE BUSQUEDA CON TEXTOS MULTILINGüES
			if articulo_buscado<>"" then
				'sql=sql & " and descripcion like ""*" & articulo_buscado & "*"""
				'sql=sql & " AND ARTICULOS.DESCRIPCION LIKE '%" & articulo_buscado & "%'"
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

			
			sql=sql & ") AS CONSULTON"
			sql=sql & " LEFT JOIN TALLAJES"
			sql=sql & " ON TALLAJES.ID_ARTICULO=CONSULTON.ID"
			sql=sql & " LEFT JOIN ARTICULOS_MARCAS"
			sql=sql & " ON ARTICULOS_MARCAS.ID_ARTICULO=CONSULTON.ID"
			
			sql=sql & ") TODO"
			sql = sql & " WHERE (TODO.GRUPO_ROPA_FECHA_DESDE IS NULL"
			sql = sql & " OR TODO.GRUPO_ROPA_FECHA_DESDE=''"
			sql = sql & " OR (CONVERT(VARCHAR(8), TODO.GRUPO_ROPA_FECHA_DESDE, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME, '" & session("usuario_directorio_activo_fecha_alta") & "', 103) , 112)))" 'pone las 2 fechas en formato yyyymmdd (112--yyyymmdd y 103--dd/mm/yyyy) 


			sql=sql & " ORDER BY DESCRIPCION_IDIOMA, DESCRIPCION_GRUPO, ORDEN_TALLA"
			

		end if		
		


		if ver_cadena="SI" then
			response.write("<br>...Consulta articulos: " & sql)
		end if
		with articulos
			.ActiveConnection=connimprenta
			
			.Source=sql
			
			.Open
		end with
		
		
		


'vemos los articulos que ya esten seleccionados en cache
dim tabla_aux() 'para guardar el grupo ropa del articulo y la cantidad
contador_articulos=1
recorrer_articulos="" & Session("numero_articulos")
redim tabla_aux(recorrer_articulos,2)
'response.write("<br>numero de articulos: " & recorrer_articulos)
'response.write("<br>ubound tabla: " & UBound(tabla_aux,2))
'response.write("<br>ubound tabla: " & UBound(tabla_aux,1))
if recorrer_articulos<>"" and recorrer_articulos<>0 then
	While int(contador_articulos)<=int(recorrer_articulos)
		id_articulo_ropa=Session(contador_articulos)
		cantidades_precios_id=Session(contador_articulos & "_cantidades_precios")
		calculos_cantidades_precios=split(cantidades_precios_id,"--")
		
		'response.write("<br>datos del articulo numero " & contador_articulos)
		'response.write("<br>id: " & id_articulo_ropa)
		'response.write("<br>cantidades precios 0: " & calculos_cantidades_precios(0))
		'response.write("<br>cantidades precios 1: " & calculos_cantidades_precios(1))
		'response.write("<br>cantidades precios 2: " & calculos_cantidades_precios(2))
		
		set recuperar_grupo_ropa=Server.CreateObject("ADODB.Recordset")
		ropa_sql="SELECT ID_GRUPO_ROPA FROM GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS"
		ropa_sql = ropa_sql & " WHERE ID_ARTICULO =" & id_articulo_ropa
		'tenemos los pantalones de invierno en 2 grupos, uno en verano y otro en invierno
		ropa_sql = ropa_sql & " AND (PERIODO='TODO' OR PERIODO='" & gestion_ropa("PERIODO_VENTA") & "')"
		ropa_sql = ropa_sql & " AND GRUPO=" & session("usuario_directorio_activo_grupo_empleado")

		with recuperar_grupo_ropa
			.ActiveConnection=connimprenta
			.Source=ropa_sql
			'response.write("<br>recuperar grupo ropa: " & ropa_sql)
			.Open
			
		end with
		
		if not recuperar_grupo_ropa.eof then
			grupo_ropa_recuperado=recuperar_grupo_ropa("ID_GRUPO_ROPA")
			'response.write("<br>grupo ropa recupeardo: " & grupo_ropa_recuperado)
			tabla_aux(contador_articulos,1) = grupo_ropa_recuperado
			tabla_aux(contador_articulos,2) = calculos_cantidades_precios(0)
			
			'response.write("<br>tabla_aux(" & contador_articulos & ",1)= grupo ropa... " & grupo_ropa_recuperado)
			'response.write("<br>tabla_aux(" & contador_articulos & ",2)= calculos_cantidades_precios... " & calculos_cantidades_precios(0))
		end if
		recuperar_grupo_ropa.close
		set recuperar_grupo_ropa=Nothing

		
		contador_articulos = contador_articulos + 1
	Wend
	
	
	'for vueltas=1 to recorrer_articulos
	'	response.write("<br><br>datos del elemento " & vueltas)
	'	response.write("<br>grupo ropa: " & tabla_aux(vueltas,1))
	'	response.write("<br>cantidad: " & tabla_aux(vueltas,2))
	'next
	
end if	



dinero_disponible_devoluciones=0	
	set disponible_devoluciones=Server.CreateObject("ADODB.Recordset")
		CAMPO_DISPONIBLE=0
		with disponible_devoluciones
			.ActiveConnection=connimprenta
			.Source="select ROUND((ISNULL(SUM(TOTAL_ACEPTADO),0) - ISNULL(SUM(TOTAL_DISFRUTADO),0)),2) as DISPONIBLE"
			.Source= .Source & " FROM DEVOLUCIONES"
			.Source= .Source & " WHERE CODCLI = " & session("usuario") 
			.Source= .Source & " AND USUARIO_DIRECTORIO_ACTIVO=" & session("usuario_directorio_activo")
			.Source= .Source & " AND ESTADO='CERRADA'"
			'response.write("<br>FAMILIAS: " & .source)
			.Open
		end with

		if not disponible_devoluciones.eof then
			dinero_disponible_devoluciones=disponible_devoluciones("DISPONIBLE")	
		end if
		disponible_devoluciones.close
		set disponible_devoluciones=Nothing


%>

<html  xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
<title><%=lista_articulos_gag_title%></title>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />
  
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
 
.table-xtra-condensed {font-size: 10px;} 
.table-xtra-condensed > thead > tr > th,
.table-xtra-condensed > tbody > tr > th,
.table-xtra-condensed > tfoot > tr > th,
.table-xtra-condensed > thead > tr > td,
.table-xtra-condensed > tbody > tr > td,
.table-xtra-condensed > tfoot > tr > td {
  padding: 2px;
} 


.glyphicon_rotado {
        -moz-transform: scaleX(-1);
        -o-transform: scaleX(-1);
        -webkit-transform: scaleX(-1);
        transform: scaleX(-1);
        filter: FlipH;
        -ms-filter: "FlipH";
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

function annadir_al_carrito(articulo, accion, id_grupo, cantidad_minima_tramo, tipo_precio, codigo_empresa, compromiso_compra, grupo_ropa)
{
	/*alert('hola')
	console.log('dentro de añadir al carrito....')
	console.log('valor de parametro articulo: ' + articulo)
	console.log('valor de parametro accion: ' + accion)
	console.log('valor de parametro id_grupo: ' + id_grupo)
	console.log('valor de parametro CANTIDAD MINIMA TRAMO: ' + cantidad_minima_tramo)	
	console.log('valor de parametro tipo_precio: ' + tipo_precio)
	console.log('valor de parametro codigo_empresa: ' + codigo_empresa)
	console.log('valor de parametro compromiso compra: ' + compromiso_compra)
	console.log('valor de parametro grupo_ropa: ' + grupo_ropa)
	*/
	
	seleccionadas_cantidades='SI'
	seleccionadas_tallas='SI'
	seleccionadas_cantidades_limite_ropa=''
	cadena=''
	
	
	limite_grupo_ropa=$("#ocultogrupo_ropa_" + grupo_ropa + "_limite").val()
	cantidad_ropa_ya_pedida=$("#ocultogrupo_ropa_" + grupo_ropa + "_cantidad_ya_pedida").val()
	cantidad_pedida_ahora=0
	nueva_cantidad_pedida=0
	
	//console.log('limite_grupo_ropa: ' + limite_grupo_ropa)
	//console.log('cantidad_ropa_ ya pedida: ' + cantidad_ropa_ya_pedida)
	
	//alert('hola primero')
	//para que si no existe el objeto porque no hay precios grabados para este articulo
	//   no de error de javascript
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
				
			nueva_cantidad_pedida= parseInt(cantidad_ropa_ya_pedida) + parseInt(document.getElementById('txtcantidad_' + articulo).value)
			if (parseInt(nueva_cantidad_pedida)>parseInt(limite_grupo_ropa))
				{
				seleccionadas_cantidades_limite_ropa='LIMITE_GRUPO_ROPA'
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
		
	if (seleccionadas_cantidades_limite_ropa=='LIMITE_GRUPO_ROPA')	
		{
		//alert('Para Añadir El Artículo al Carrito ha de Seleccionar Las Cantidades/Precios del Mismo')
		cadena='<br><BR><H4>No Puede Superar el L&iacute;mite de Prendas Disponibles para Este Grupo de Ropa</H4><BR><br>'
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
		
	if ((seleccionadas_cantidades=='NO') || (seleccionadas_cantidades=='MINIMO') || (seleccionadas_tallas=='NO') || seleccionadas_cantidades_limite_ropa=='LIMITE_GRUPO_ROPA')	
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
					
					//hace la animacion de llevar la imagen al carrito
					meter_al_carrito(articulo)
					
					//se actualiza los limites de la ropa que se puede pedir		
					if (seleccionadas_cantidades_limite_ropa!='LIMITE_GRUPO_ROPA')
						{
						//ACTUALIZAR TAMBIEN LIMITES ROPA
						$("#ocultogrupo_ropa_" + grupo_ropa + "_cantidad_ya_pedida").val(nueva_cantidad_pedida)
						
						//tenemos que refrescar el cuadro de grupos y limites de ropa
						$("#celda_grupo_ropa_" + grupo_ropa + "_cantidad_ya_pedida").html(nueva_cantidad_pedida)
						}
					
					parametros='acciones=' + accion
					parametros+='&ocultoarticulo=' + document.getElementById('ocultoarticulo').value
					parametros+= '&ocultocantidades_precios=' + document.getElementById('ocultocantidades_precios').value
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
					
					//hace la animacion de llevar la imagen al carrito
					meter_al_carrito(articulo)
					
					//se actualiza los limites de la ropa que se puede pedir		
					if (seleccionadas_cantidades_limite_ropa!='LIMITE_GRUPO_ROPA')
						{
						//ACTUALIZAR TAMBIEN LIMITES ROPA
						$("#ocultogrupo_ropa_" + grupo_ropa + "_cantidad_ya_pedida").val(nueva_cantidad_pedida)
						
						//tenemos que refrescar el cuadro de grupos y limites de ropa
						$("#celda_grupo_ropa_" + grupo_ropa + "_cantidad_ya_pedida").html(nueva_cantidad_pedida)
						}	
					
					parametros='acciones=' + accion
					parametros+='&ocultoarticulo=' + document.getElementById('ocultoarticulo').value
					parametros+= '&ocultocantidades_precios=' + document.getElementById('ocultocantidades_precios').value
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
	//console.log('desde añadir al carrito')
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


</script>

	

<!--PARA LA ANIMACION DE METER LA IMAGEN DEL ARTICULO EN EL CARRITO DE LA COMPRA-->		
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>


<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>	
	

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
                    <%if session("usuario_directorio_activo_nombre")<>"" then%>
                    <div align="left"> <b><%=session("usuario_directorio_activo_nombre")%>&nbsp;<%=session("usuario_directorio_activo_apellidos")%></b> </div>
                    <br />
					<%end if%>
                    <div align="left"> <b><%=session("usuario_empresa")%></b>
                        <%if session("usuario_codigo_externo") <> "" then%>
                        <b>&nbsp;-&nbsp;<%=session("usuario_codigo_externo")%></b>
                        <%end if%>
                        <br />
                        <b><%=session("usuario_nombre")%></b> <br />
                        <%=session("usuario_tipo")%> <br />
                        <%=session("usuario_direccion")%> <br />
                        <%=session("usuario_poblacion")%> <br />
                        <%=session("usuario_cp")%>&nbsp;<%=session("usuario_provincia")%> <br />
                        <%=session("usuario_pais")%> <br />
					    Tel: <%=session("usuario_telefono")%> <br />
					    Fax: <%=session("usuario_fax")%> <br />
		
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
							<%'para Mireia - Jose Javier Fernandez
								'1N, 1R, 2N, 2R, 3N, 3R, 5N, 5R -- 1851, 1852, 1853, 1854, 1855, 1856
								'1857, 1858... SE LES MUESTRA UN BOTON PARA GESTIONAR EMPLEADOSif session("usuario_directorio_activo")=1852 then
								if session("usuario_directorio_activo")=2394 OR session("usuario_directorio_activo")=2391 _
									OR session("usuario_directorio_activo")=1851 OR session("usuario_directorio_activo")=1852 OR session("usuario_directorio_activo")=1853 _
									OR session("usuario_directorio_activo")=1854 OR session("usuario_directorio_activo")=1855 OR session("usuario_directorio_activo")=1856 _
									OR session("usuario_directorio_activo")=1857 OR session("usuario_directorio_activo")=1858 _
									THEN%>
									
										<br />
	    								<button type="button" id="cmdgestion_empleados" name="cmdgestion_empleados" class="btn btn-primary btn-sm btn-block"> 
											<i class="fas fa-users"></i> <span>Gestionar Empleados</span> 
										</button>
							<%end if%>
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
			  
			<!--capa para el recuento de ropa de temporada disponible para el empleado-->
			<%			
			if not gestion_ropa.eof then
				%>
				<div class="panel panel-default" style="margin-bottom:0px; margin-top:7px ">
					<div class="panel-heading clearfix">
						<div  class="pull-left">
							<b>Ropa Disponible Para Empleados del Grupo <%=session("usuario_directorio_activo_grupo_empleado")%></b>
							<br />
							Periodo: <b><%=gestion_ropa("PERIODO_VENTA")%></b> 
							<%if session("usuario_directorio_activo_nuevo_empleado") then%>
								&nbsp;(NUEVO)
							<%else%>
								&nbsp;(REPOSICI&Oacute;N)
							<%end if%>
						</div>
						<div class="btn-group pull-right"
							data-toggle='popover_grupo_ropa'
								data-placement='top'
								data-trigger='hover'
								data-content='Mostrar/Ocultar Cuadro de Ropa Disponible'
								data-original-title=''>
							<i class="glyphicon glyphicon-option-horizontal" 								
								data-toggle="collapse" 
								data-target="#panel_body_ropa"
								style="cursor:pointer"></i>
						</div>
					</div>
					<div class="panel-body panel_sinmargen_lados panel_conmargen_arribaabajo" id="panel_body_ropa">
						<div align="center" class="col-md-12">	
							<table class='table table-striped table-bordered table-sm table-responsive table-xtra-condensed'>
								<thead>
									<tr>
										<th>GRUPO ROPA</th>
										<th 
												data-toggle='popover_grupo_ropa'
												data-placement='top'
												data-trigger='hover'
												data-content='Cantidad M&aacute;xima de Art&iacute;culos de este Tipo que puede Solicitar en un Periodo'
												data-original-title=''
												style="cursor:pointer"
												>LIMITE</th>
										<th
												data-toggle='popover_grupo_ropa'
												data-placement='top'
												data-trigger='hover'
												data-content='Cantidad ya pedida'
												data-original-title=''
												style="cursor:pointer"
												>YA PEDIDOS</th>
									</tr>
								</thead>
								<tbody>
								<%while not gestion_ropa.eof%>
									<%
										abreviatura_grupo_ropa = "" & gestion_ropa("ABREVIATURA")
										descripcion_grupo_ropa = "" & gestion_ropa("DESCRIPCION")
										
										if gestion_ropa("ID") = 3 and session("usuario_directorio_activo_grupo_empleado")=3 then 'camisetas del grupo 3
											abreviatura_grupo_ropa = "CAMISETAS Y POLOS"
											descripcion_grupo_ropa = "CAMISETAS Y POLOS"
										end if
										if gestion_ropa("ID") = 9 and session("usuario_directorio_activo_grupo_empleado")=5 then 'PANTALONES DE VERANO DEL GRUPO 5
											abreviatura_grupo_ropa = "PANT. VER. / BER"
											descripcion_grupo_ropa = "PANTALONES DE VERANO Y BERMUDAS"
										end if
									%>
									<tr>
										<td
											<%if abreviatura_grupo_ropa <> descripcion_grupo_ropa then%>
													data-toggle='popover_grupo_ropa'
													data-placement='top'
													data-trigger='hover'
													data-content='<%=descripcion_grupo_ropa%>'
													data-original-title=''
													style="cursor:pointer"
											<%end if%>
											><%=abreviatura_grupo_ropa%></td>
										<td><%=gestion_ropa("CANTIDAD_LIMITE")%>
											<input type="hidden" name="ocultogrupo_ropa_<%=gestion_ropa("ID")%>_limite" id="ocultogrupo_ropa_<%=gestion_ropa("ID")%>_limite" value="<%=gestion_ropa("CANTIDAD_LIMITE")%>" />
										</td>
										<td>
											<%'miro si hay un pedidos a medias con articulos seleccionados para sumale esta cantidad
											'response.write("<br> sesion " & gestion_ropa("ID") & "_cantidades_precios: " & Session(gestion_ropa("ID") & "_cantidades_precios"))
											'cantidades_precios_extra="" & Session(gestion_ropa("ID") & "_cantidades_precios")
											'if cantidades_precios_extra<>"" then
											'	tabla_cantidades_precios_extra=split(cantidades_precios_extra,"--")
											'	cantidad_extra="" & tabla_cantidades_precios_extra(0)
											'	cantidad_ropa_pedida=int(gestion_ropa("CANTIDAD_YA_PEDIDA")) + int(cantidad_extra)
											'  else
											'	cantidad_ropa_pedida=gestion_ropa("CANTIDAD_YA_PEDIDA")
											'end if
											cantidad_ropa_pedida=gestion_ropa("CANTIDAD_YA_PEDIDA")
											
											'vemos los articulos que ya esten seleccionados en cache
											for vueltas=1 to recorrer_articulos
												'response.write("<br>recuperando cache: " & tabla_aux(vueltas,1))
												if gestion_ropa("ID")=tabla_aux(vueltas,1) then
													cantidad_ropa_pedida=cantidad_ropa_pedida + tabla_aux(vueltas,2)
												end if
											next
											
											
											
											
											
											%>										
											
											<span id="celda_grupo_ropa_<%=gestion_ropa("ID")%>_cantidad_ya_pedida"><%=cantidad_ropa_pedida%></span>
											<input type="hidden" name="ocultogrupo_ropa_<%=gestion_ropa("ID")%>_cantidad_ya_pedida" id="ocultogrupo_ropa_<%=gestion_ropa("ID")%>_cantidad_ya_pedida" value="<%=cantidad_ropa_pedida%>" />
										</td>
									</tr>
									<%
									gestion_ropa.movenext
								wend
								%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				
			<!--capa para el recuento de ropa de temporada disponible para el empleado-->
			  
			  
			  
			  
					
				<%
				end if
				gestion_ropa.close
				set gestion_ropa=Nothing
				%>
			  
    </div>
    <!--FINAL COLUMNA DE LA IZQUIERDA-->
    
    <!--COLUMNA DE LA DERECHA-->
    <div class="col-xs-9 col-xs-offset-3">
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
					</div>
				</div>
			</div>
			<!-- pedidos, devoluciones y saldos-->
	
	
	
	
      <div class="panel panel-default">
		<%cadena_cabecera=replace(lista_articulos_gag_panel_filtros_cabecera,"XXX", session("usuario_empresa"))%>
        <div class="panel-heading"><span class='fontbold'><%=cadena_cabecera%></span></div>
        <div class="panel-body">
			<div class="well well-sm">
				<form class="form-horizontal" role="form" name="frmbusqueda" id="frmbusqueda" method="post" action="Lista_Articulos_Gag_Empleados_GLS.asp?acciones=<%=accion%>">
					<input type="hidden" id="ocultover_cadena" name="ocultover_cadena" value="<%=ver_cadena%>" />
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
						<%
							'el perfil de ASM no tiene que ver este filtro de Requiere Autorizacion
							' el de UVE HOTELES TAMPOCO
							' el de GEOMOON TAMPOCO
							if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150 AND session("usuario_codigo_empresa")<>130 then%>						  
								
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
											<div class="panel panel-default__ inf_general_art"  onclick="muestra_datos_articulo(<%=articulos("ID")%>)"
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
													
													<%
													descripcion_grupo_ropa = articulos("GRUPO_ROPA_DESCRIPCION")
													if articulos("GRUPO_ROPA") = 3 and session("usuario_directorio_activo_grupo_empleado")=3 then 'camisetas del grupo 3
														descripcion_grupo_ropa = "CAMISETAS Y POLOS"
													end if
													if articulos("GRUPO_ROPA") = 9 and session("usuario_directorio_activo_grupo_empleado")=5 then 'PANTALONES DE VERANO DEL GRUPO 5
														descripcion_grupo_ropa = "PANTALONES DE VERANO Y BERMUDAS"
													end if
													%>
													<div align="left"><b>Grupo Ropa:</b> <%=descripcion_grupo_ropa%><br></div>
													<div align="left"><b><%=lista_articulos_gag_panel_articulos_informacion_familia%>:</b> <%=articulos("nombre_familia")%><br></div>
													<%
													'el perfil de ASM no tiene que ver este dato de Requiere Autorizacion
													' y el de UVE tampoco
													' y el de GEOMOON tampoco
													if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150 AND session("usuario_codigo_empresa")<>130 then%>	
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
											sql=sql & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
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
											'  - BICI
											'response.write("<br>familia: " & articulos("familia") &"<br>cliente: " & session("usuario") & "<br>tipo usuario: " & session("usuario_tipo") & "<br>empresa: " & session("usuario_codigo_empresa"))
											if (articulos("familia")=186 or articulos("familia")=187 or articulos("familia")=227 or articulos("familia")=228) and (session("usuario")<>7395 and session("usuario")<>5089 and session("usuario")<>5085 and session("usuario")<>8351 and session("usuario")<>8352 and session("usuario")<>8353 and session("usuario")<>7633) and session("usuario_tipo")="GLS PROPIA" and session("usuario_pais")<>"PORTUGAL" and session("usuario_codigo_empresa")=4 then
												mostrar_boton="NO_VESTUARIO"
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
																						<th style="text-align:right">Precio</th> 
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
									
									<!--boton de añadir y packing y tallas-->
									<div class="col-md-12" style="padding-top:10px ">
										<div class="col-md-2">
												<%if mostrar_boton="SI" then%>
													<button type="button" name="cmdannadir_carrito" id="cmdannadir_carrito" class="btn btn-primary btn-sm" onclick="annadir_al_carrito(<%=articulos("ID")%>, '<%=accion%>', '<%=articulos("ID_GRUPO")%>', '<%=cantidad_minima_tramo%>', '<%=tipo_precio%>', '<%=session("usuario_codigo_empresa")%>', '<%=articulos("compromiso_compra")%>', <%=articulos("GRUPO_ROPA")%>)" >
														<i class="glyphicon glyphicon-shopping-cart"></i>
														<span><%=lista_articulos_gag_panel_articulos_boton_annnadir%></span>
													</button>
												<%end if%>
												
										</div>
										<div class="col-md-3">
										<%IF articulos("plantilla_personalizacion")<>"" then%>
											<div class="col-md-6">
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
										<%end if%>
										<%IF articulos("PERMITE_DEVOLUCION")<>"SI" then%>
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
											%>
											<div class="col-md-3">
											</div>
											<div class="col-md-4 panel_sinmargen_lados">
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
																				<td align="right">
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
																			<td align="right">
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
                              <div class="panel-title">
                                <h5><%=REPLACE(REPLACE(articulos("DESCRIPCION_IDIOMA"),".",""), "·","")%></h5>
                              </div>
                            </div>
                            <!--
								<div class="panel-heading"  style="padding-bottom:2px;padding-top:2px"></div>
								-->
                            <div class="panel-body" style="padding-left:1px; padding-left:1px; padding-top:0px;">
                              <!--informacion general del articulo-->
                              <div class="row">
                                <div class="col-md-7">
                                  <div style="padding-top:5px"></div>
                                  <div class="panel panel-default__ inf_general_art"  onclick="muestra_datos_articulo(<%=articulos("ID")%>)" 
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
                                      <div align="left"><b><%=lista_articulos_gag_panel_articulos_informacion_referencia%>:</b> <%=articulos("codigo_sap")%><br />
                                      </div>
                                      <%end if%>
									  <%
										descripcion_grupo_ropa = articulos("GRUPO_ROPA_DESCRIPCION")
										if articulos("GRUPO_ROPA") = 3 and session("usuario_directorio_activo_grupo_empleado")=3 then 'camisetas del grupo 3
											descripcion_grupo_ropa = "CAMISETAS Y POLOS"
										end if
										if articulos("GRUPO_ROPA") = 9 and session("usuario_directorio_activo_grupo_empleado")=5 then 'PANTALONES DE VERANO DEL GRUPO 5
											descripcion_grupo_ropa = "PANTALONES DE VERANO Y BERMUDAS"
										end if
									  %>
									  <div align="left"><b>Grupo Ropa:</b> <%=descripcion_grupo_ropa%><br></div>
                                      <div align="left"><b><%=lista_articulos_gag_panel_articulos_informacion_familia%></b> <%=articulos("nombre_familia")%><br />
                                      </div>
                                      <%
													'el perfil de ASM no tiene que ver este dato de Requiere Autorizacion
													'y el de UVE tampoco
													'y el de GEOMOON tamopoco
													if session("usuario_codigo_empresa")<>4 and session("usuario_codigo_empresa")<>150 AND session("usuario_codigo_empresa")<>130 then%>
                                      <div align="left"><b><%=lista_articulos_gag_panel_filtros_requiere_autorizacion_alter%>:</b>
                                          <%IF articulos("requiere_autorizacion")="SI" THEN%>
                                          <b style="color:#FF0000"><%=lista_articulos_gag_panel_filtros_combo_autorizacion_si%></b>
                                          <%ELSE%>
                                          <%=lista_articulos_gag_panel_filtros_combo_autorizacion_no%>
                                          <%END IF%>
                                          <br />
                                      </div>
                                      <%end if%>
                                    </div>
                                  </div>
                                </div>
                                <!--col-md-7-->
                                <div class="col-md-5">
                                  <div style="padding-top:5px"></div>
                                  <div class="panel inf_pack_stock">
                                    <div class="panel-body">
                                      <%if articulos("unidades_de_pedido")<>"" then%>
                                      <div> <b><%=lista_articulos_gag_panel_articulos_informacion_unidad_pedido%>:</b> <br />
                                          <%=articulos("unidades_de_pedido")%> </div>
                                      <%end if%>
                                      <%if articulos("packing")<>"" then%>
                                      <div><b><%=lista_articulos_gag_panel_articulos_informacion_caja_completa%>:</b> <%=articulos("packing")%></div>
                                      <%end if%>
                                    </div>
                                  </div>
                                </div>
                                <!--col-md-5-->
                              </div>
                              <!--row-->
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
                                    <a href="<%=imagen_a_enlazar%>" target="_blank"> <img src="<%=icono_a_mostrar%>" height="8" border="0" class="img-responsive" id="img_<%=articulos("id")%>"/> </a> </div>
                                </div>
                                <!-- fin imagen del articulo-->
                                <!--tabla de precios y cantidades a pedir-->
                                <div class="col-md-6 panel_sinmargen_lados">
                                  <%
											set cantidades_precios=Server.CreateObject("ADODB.Recordset")
					
											sql="SELECT * FROM CANTIDADES_PRECIOS"
											sql=sql & " WHERE CODIGO_ARTICULO=" & articulos("id")
											sql=sql & " AND TIPO_SUCURSAL='" & tipo_precio & "'"
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
											'  - BICI
											'response.write("<br>familia: " & articulos("familia") &"<br>cliente: " & session("usuario") & "<br>tipo usuario: " & session("usuario_tipo") & "<br>empresa: " & session("usuario_codigo_empresa"))
											if (articulos("familia")=186 or articulos("familia")=187 or articulos("familia")=227 or articulos("familia")=228) and (session("usuario")<>7395 and session("usuario")<>5089 and session("usuario")<>5085 and session("usuario")<>8351 and session("usuario")<>8352 and session("usuario")<>8353 and session("usuario")<>7633) and session("usuario_tipo")="GLS PROPIA" and session("usuario_pais")<>"PORTUGAL" and session("usuario_codigo_empresa")=4 then
												mostrar_boton="NO_VESTUARIO"
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
                                              <td align="right"><%
																								IF cantidades_precios("precio_pack")<>"" then
																									Response.Write(FORMATNUMBER(cantidades_precios("precio_pack"),2) & " €")
																								  else
																									Response.Write("")
																								end if
																							%>
&nbsp; </td>
                                            </tr>
                                            <%
																					filas=filas+1
																					cantidades_precios.movenext%>
                                            <%wend%>
                                          </tbody>
                                        </table>
                                      </div>
                                    </div>
                                    <!--panel defalut-->
                                  </div>
                                  <!--col-md-12-->
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
                                            <td width="44%"><%
																									IF cantidades_precios("precio_unidad")<>"" then
																										Response.Write(cantidades_precios("precio_unidad") & " €/u")
																									  else
																										Response.Write("")
																									end if
																									%>
&nbsp; </td>
                                          </tr>
                                          <%end if 'del descripcion_grupo%>
                                          <%'para que se muestre las cantidades en todos los aritculos, menos en los
																						'de gls, que no se van a pedir de momento
																						if mostrar_boton="SI" then%>
                                          <tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand; cursor:pointer;" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','SI')" class="filas_cantidades" valign="middle">
                                            <input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
                                            <th><%=lista_articulos_gag_panel_articulos_cantidad%></th>
                                            <td><input type="text" class="form-control cantidad_pedida_art" size="5" name="txtcantidad_<%=articulos("id")%>" id="txtcantidad_<%=articulos("id")%>" />
                                            </td>
                                          </tr>
                                          <%END IF%>
                                          <%
																					filas=filas+1
																					cantidades_precios.movenext%>
                                          <%wend%>
                                        </table>
                                      </div>
                                      <!-- panel-body -->
                                    </div>
                                    <!-- panel-->
                                  </div>
                                  <!--col-md-12-->
                                  <%Case "TRAMOS"%>
                                  <%if ("" & articulos("descripcion_grupo"))="" then%>
                                  <div class="col-md-12 panel_sinmargen_lados">
                                    <div class="panel panel-default" style="padding-bottom:0px ">
                                      <div class="panel-body--">
                                        <table class="table table-condensed" id="tabla_tramos_cantidades_precios_<%=articulos("id")%>" style="margin-bottom:0px ">
                                          <thead>
                                            <tr>
                                              <th style="text-align:center"><%=lista_articulos_gag_panel_articulos_cantidad%></th>
                                              <th style="text-align:right">Precio</th>
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
                                              <td align="left"><%
																								if cantidades_precios("cantidad_superior")<>"" then
																									texto_tramos="de " & cantidades_precios("cantidad") & " a " & cantidades_precios("cantidad_superior")
																								  else
																									texto_tramos="a partir de " & cantidades_precios("cantidad")
																								end if
																								response.write(texto_tramos)
																								%>
                                              </td>
                                              <td align="right"><%
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
                                    </div>
                                    <!--panel defalut-->
                                  </div>
                                  <!--col-md-12-->
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
                                            <td><input type="text" class="form-control cantidad_pedida_art" size="5" name="txtcantidad_<%=articulos("id")%>" id="txtcantidad_<%=articulos("id")%>" />
                                            </td>
                                          </tr>
                                          <%end if%>
                                        </table>
                                      </div>
                                      <!-- panel-body -->
                                    </div>
                                    <!-- panel-->
                                  </div>
                                  <!--col-md-12-->
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
                              </div>
                              <!--fin del row-->
                              <!--la informacion del articulo-->
                              <%
									'solo para los articulos pertenecientes a las familias relaciondas con GLS de asm se muestra este aviso
									'response.write("-" & articulos("familia") & "-")
									if mostrar_boton="NO" then%>
                              <br />
                        &nbsp;
                              <div class="col-md-10 col-md-offset-2" align="center">
                                <div class="alert alert-warning" role="alert"><%=lista_articulos_gag_panel_articulos_alerta_validez%></div>
                              </div>
                              <%end if%>
                              <%
									'solo para los articulos pertenecientes a las familias de vestuario de GLS
									' y si la oficina es propia y no es la 280-05, 280-01, 280-02, 280-03, 280-04, 81-01
									if mostrar_boton="NO_VESTUARIO" then%>
                              <br />
                        &nbsp;
                              <div class="col-md-10 col-md-offset-2" align="center">
                                <div class="alert alert-warning" role="alert">Gesti&oacute;n a trav&eacute;s del Site</div>
                              </div>
                              <%end if%>
                              <%
									'solo para los articulos que se quedan sin stock
									if mostrar_boton="SIN_STOCK" then
										if session("usuario_trato_especial")=1 and session("usuario_derecho_primer_pedido")="SI" then
										  else%>
                              <br />
                        &nbsp;
                              <div class="col-md-10 col-md-offset-2" align="center"> No Disponible Temporalmente </div>
                              <%end if%>
                              <%end if%>
                              <!--boton de añadir y packing y tallas-->
                              <div class="col-md-12" style="padding-top:10px ">
                                <div class="col-md-2">
                                  <%if mostrar_boton="SI" then%>
                                  <button type="button" name="cmdannadir_carrito" id="cmdannadir_carrito" class="btn btn-primary btn-sm" onclick="annadir_al_carrito(<%=articulos("ID")%>, '<%=accion%>', '<%=articulos("id_GRUPO")%>', '<%=cantidad_minima_tramo%>', '<%=tipo_precio%>', '<%=session("usuario_codigo_empresa")%>', '<%=articulos("compromiso_compra")%>', <%=articulos("GRUPO_ROPA")%>)" > <i class="glyphicon glyphicon-shopping-cart"></i> <span><%=lista_articulos_gag_panel_articulos_boton_annnadir%></span> </button>
                                  <%end if%>
                                </div>
								<div class="col-md-3">
								<%IF articulos("plantilla_personalizacion")<>"" then%>
                               		<div class="col-md-6">
										<span class="label label-warning" 
														style="font-size:18px;"
														data-toggle="popover" 
														data-placement="bottom" 
														data-trigger="hover" 
														data-content="<%=lista_articulos_gag_panel_articulos_requiere_personalizacion%>" 
														data-original-title=""
														> <i class="glyphicon glyphicon-list-alt" style="padding-top:3px "></i> </span>
									</div>
								<%end if%>
								
                                
								<%IF articulos("PERMITE_DEVOLUCION")<>"SI" then%>
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
											%>
										
                                <div class="col-md-3"> </div>
                                <div class="col-md-4 panel_sinmargen_lados">
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
                                          <td align="right"><%
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
                                          <td align="right" style="color:#CCCCCC"><%
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
                                          <td align="right"><%
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
                                </div>
                                <!--fin de tallas y numeracion del articulo-->
                                <%else
												articulos.movenext%>
                                <%end if%>
                              </div>
                              <!--del col-md-12-->
                              <!--fin añadir y packing-->
                            </div>
                            <!--panel-body-->
                          </div>
                          <!--panel-->
                        </div>
				  <!--col-md-6-->
                        <!--finaliza el articulo DERECHA-->
                </div>
				<!--row-->
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










<form name="frmannadir_al_carrito" id="frmannadir_al_carrito" action="Annadir_Articulo_Gag.asp?acciones=<%=accion%>" method="post">
	<input type="hidden" name="ocultoarticulo" id="ocultoarticulo" value=""/>
	<input type="hidden" name="ocultocantidades_precios" id="ocultocantidades_precios" value="" />
</form>

<form action="Lista_Articulos_Gag_Empleados_GLS.asp?acciones=<%=accion%>" method="post" id="frmbotones" name="frmbotones">
	<input type="hidden" id="ocultoseleccion_asm_gls" name="ocultoseleccion_asm_gls" value="" />
</form>
				<!-- END SHOPPAGE_HEADER.HTM -->
				
		
<!--<script type="text/javascript" src="../plugins/jquery/jquery-1.12.4.min.js"></script>-->

		
<script>


$(document).ready(function() {
    //para que se configuren los popover-titles...
	$('[data-toggle="popover"]').popover({html:true});
	$('[data-toggle=popover_grupo_ropa]').popover({html: true, container: 'body'})
	
	//console.log('altura columna: ' + $("#probando").height())

	
	mostrar_resumen_carrito()
	//console.log('desde el ready')
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
	
	
$("#cmdgestion_empleados").on("click", function () {
	location.href='Gestionar_Empleados_GLS_Central.asp?emp=SI'
});

$("#cmdver_pedido").on("click", function () {
	location.href='Carrito_Gag.asp?acciones=<%=accion%>&emp=SI'
});

$("#cmdborrar_pedido").on("click", function () {
	pagina_url='Vaciar_Carrito_Gag.asp?emp=SI'
	parametros=''
	mostrar_capa(pagina_url,'capa_annadir_articulo', parametros)
	
	
	/*
	if (seleccionadas_cantidades_limite_ropa!='LIMITE_GRUPO_ROPA')
		{
		//ACTUALIZAR TAMBIEN LIMITES ROPA
		$("#ocultogrupo_ropa_" + grupo_ropa + "_cantidad_ya_pedida").val(nueva_cantidad_pedida)
		
		//tenemos que refrescar el cuadro de grupos y limites de ropa
		$("#celda_grupo_ropa_" + grupo_ropa + "_cantidad_ya_pedida").html(nueva_cantidad_pedida)
		}
	*/
	
	cadena='<BR><BR><H4>El Carrito Ha Sido Vaciado...</H4><BR><BR>'
	$("#cabecera_pantalla_avisos").html("Avisos")
	$("#pantalla_avisos .modal-header").show()
	$("#body_avisos").html(cadena + "<br>");
	$("#pantalla_avisos").modal("show");
	
	
	location.href='Lista_Articulos_Gag_Empleados_GLS.asp'
	
	//mostrar_resumen_carrito()
	//console.log('desde borrar carrito')
	//location.href='Vaciar_Carrito_Gag.asp'
});

$("#cmdconsultar_pedidos").on("click", function () {
	location.href='Consulta_Pedidos_Gag.asp?emp=SI'
});
$("#cmdconsultar_devoluciones").on("click", function () {
	location.href='Consulta_Devoluciones_Gag.asp?emp=SI'
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



$('.inf_general_art').hover(
       function(){ $(this).addClass('panel-primary') },
       function(){ $(this).removeClass('panel-primary') }
)

muestra_datos_articulo = function(articulo) {
	cadena='<iframe id="iframe_datos_articulo" src="Datos_Articulo_Gag.asp?articulo=' + articulo + '" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe>'
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
</script>       

				
</body>
<%
	articulos.close
	
	connimprenta.close
			  
			
	set articulos=Nothing
	
	set connimprenta=Nothing
%>
</html>

