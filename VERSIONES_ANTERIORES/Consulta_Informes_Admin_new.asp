    <%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
    'para que no se desborde el buffer
	Response.Buffer=true
		
	if session("usuario_admin")="" then
		Response.Redirect("Login_Admin.asp")
	end if
		
	ver_cadena="" & Request.QueryString("p_vercadena")
	if ver_cadena="" then
		ver_cadena=Request.Form("ocultover_cadena")
	end if
	
	agrupacion_seleccionada=Request.Form("optagrupacion")	
	empresa_seleccionada=Request.Form("cmbempresas")
	articulo_seleccionado=Request.Form("cmbarticulos")
	ordenacion_seleccionada=Request.Form("optordenacion")	
	
	reservas_asm_gls_seleccionada=Request.Form("chkreservas_asm_gls")
	fecha_i=Request.Form("txtfecha_inicio")
	fecha_f=Request.Form("txtfecha_fin")
	diferenciar_empresas_seleccionada=Request.Form("chkdiferenciar_empresas")
	diferenciar_sucursales_seleccionada=Request.Form("chkdiferenciar_sucursales")
	diferenciar_articulos_seleccionada=Request.Form("chkdiferenciar_articulos")
	articulos_sin_consumo_seleccionada=Request.Form("chkarticulos_sin_consumo")
	diferenciar_rappel_seleccionado=Request.Form("chkdiferenciar_rappel")
	diferenciar_costes_seleccionado=Request.Form("chkdiferenciar_costes")
	diferenciar_marca_seleccionada=Request.Form("chkdiferenciar_marca")
	diferenciar_tipo_seleccionada=Request.Form("chkdiferenciar_tipo")
		
'response.write("<br>diferenciar rappel: " & diferenciar_rappel_seleccionado)
	'response.write("<br>agrupacion articulo: " & request.form("optagrupacion_articulo"))
	'response.write("<br>agrupacion empresa: " & request.form("optagrupacion_empresa"))
	'response.write("<br>agrupacion: " & request.form("optagrupacion"))
					
					
		
	if agrupacion_seleccionada="" then
		agrupacion_seleccionada="empresa"
	end if	
	
	if ordenacion_seleccionada="" then
		ordenacion_seleccionada="codigo_sap"
	end if	
	
	'response.write("<br>agrupacion: " & agrupacion_seleccionada)
		
	'response.write("<br>diferenciar sucursales: " & diferenciar_sucursales_seleccionada)
	'recordsets
	dim empresas
		
		
	'variables
	dim sql
	
	set empresas=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_EMPRESA=0
		CAMPO_EMPRESA_EMPRESA=1
		CAMPO_CARPETA_EMPRESA=2
		with empresas
			.ActiveConnection=connimprenta
			.Source="SELECT V_EMPRESAS.ID, V_EMPRESAS.EMPRESA, V_EMPRESAS.CARPETA"
			.Source= .Source & " FROM V_EMPRESAS"
			.Source= .Source & " ORDER BY EMPRESA"
			.Open
			vacio_empresas=false
			if not .BOF then
				mitabla_empresas=.GetRows()
			  else
				vacio_empresas=true
			end if
		end with

		empresas.close
		set empresas=Nothing


		

		set consumos=Server.CreateObject("ADODB.Recordset")
		
		'connimprenta.BeginTrans 'Comenzamos la Transaccion
				
		'porque el sql de produccion es un sql expres que debe tener el formato de
		' de fecha con mes-dia-año
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
				
		with consumos
			.ActiveConnection=connimprenta
			
			'hacemos dos consultas, dependiendo de si se agrupa por articulo o por empresa
			if agrupacion_seleccionada="empresa" then
				.Source="SELECT  ARTICULOS.*"
				'if diferenciar_articulos_seleccionada="SI" then
					'.Source= .Source & ", DEVOLUCIONES.*"
					.Source= .Source & ", DEVOLUCIONES.UNIDADES_DEVUELTAS"
					.Source= .Source & ", DEVOLUCIONES.TOTAL_DEVOLUCIONES AS TOTAL_IMPORTE_DEVOLUCIONES"
				'end if				
				.Source= .Source & " FROM"
				.Source= .Source & " (SELECT E.EMPRESA AS NOMBRE_EMPRESA"
				if diferenciar_sucursales_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ", D.ID CODCLIENTE, D.NOMBRE, D.CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					.Source= .Source & ", B.ARTICULO AS ID_ARTICULO, F.CODIGO_SAP, F.DESCRIPCION, F.UNIDADES_DE_PEDIDO, F.RAPPEL, F.VALOR_RAPPEL"
					.Source= .Source & ", F.PRECIO_COSTE, (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=F.PROVEEDOR) AS PROVEEDOR"
					.Source= .Source & ", F.REFERENCIA_DEL_PROVEEDOR"
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", D.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", D.TIPO"
				end if

				
				.Source= .Source & ", SUM(A.CANTIDAD) as CANTIDAD_TOTAL"
				'.Source= .Source & ", ROUND(SUM(A.CANTIDAD * (B.TOTAL/B.CANTIDAD)), 2) AS TOTAL_IMPORTE"
				.Source= .Source & ", ROUND(SUM(CASE WHEN B.TOTAL=0 THEN 0 ELSE (A.CANTIDAD * (B.TOTAL/B.CANTIDAD)) END), 2) AS TOTAL_IMPORTE"
				
				.Source= .Source & " FROM ENTRADAS_SALIDAS_ARTICULOS A INNER JOIN PEDIDOS_DETALLES B ON A.PEDIDO=B.ID_PEDIDO AND A.ID_ARTICULO=B.ARTICULO"
				.Source= .Source & " INNER JOIN PEDIDOS C ON A.PEDIDO=C.ID"
				.Source= .Source & " INNER JOIN V_CLIENTES D ON C.CODCLI=D.ID"
				.Source= .Source & " INNER JOIN V_EMPRESAS E ON D.EMPRESA=E.ID"
				.Source= .Source & " INNER JOIN ARTICULOS F ON B.ARTICULO=F.ID"
				
				.Source= .Source & " WHERE 1=1"
				.Source= .Source & " AND A.E_S='SALIDA' AND A.TIPO='PEDIDO'"
				if fecha_i<>"" then
					.Source= .Source & " AND (CONVERT(VARCHAR(8), A.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & fecha_i & "', 103) , 112))" 
				end if
				if fecha_f<>"" then
					.Source= .Source & " AND (CONVERT(VARCHAR(8), A.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & fecha_f & "', 103) , 112))"
				end if
				if empresa_seleccionada<>"" then
					.Source= .Source & " AND (D.EMPRESA = " & empresa_seleccionada & ")"
				end if
				
				.Source= .Source & " GROUP BY E.EMPRESA"
				if diferenciar_sucursales_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ", D.ID, D.NOMBRE, D.CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					.Source= .Source & ", B.ARTICULO, F.CODIGO_SAP, F.DESCRIPCION, F.UNIDADES_DE_PEDIDO, F.RAPPEL, F.VALOR_RAPPEL"
					.Source= .Source & ", F.PRECIO_COSTE, F.PROVEEDOR"
					.Source= .Source & ", F.REFERENCIA_DEL_PROVEEDOR"
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", D.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", D.TIPO"
				end if
				
				.Source= .Source & ") ARTICULOS"

				'if diferenciar_articulos_seleccionada="SI" then
					.Source= .Source & " LEFT JOIN"
					
					.Source= .Source & " (SELECT V.EMPRESA"
					if diferenciar_sucursales_seleccionada="SI" then
						.Source= .Source & ", W.ID AS CODCLIENTE"
					end if
					if diferenciar_articulos_seleccionada="SI" then
						.Source= .Source & ", Z.ID_ARTICULO"
					end if
					if diferenciar_marca_seleccionada="SI" then
						.Source= .Source & ", W.MARCA"
					end if
					if diferenciar_tipo_seleccionada="SI" then
						.Source= .Source & ", W.TIPO" 
					end if
					.Source= .Source & ", SUM(UNIDADES_ACEPTADAS) AS UNIDADES_DEVUELTAS"
					.Source= .Source & ", SUM(ROUND((UNIDADES_ACEPTADAS * (T.TOTAL/T.CANTIDAD)),2)) AS TOTAL_DEVOLUCIONES"
					'.Source= .Source & ", Z.UNIDADES_ACEPTADAS AS UNIDADES_DEVUELTAS"
					'.Source= .Source & ", Z.FECHA_ACEPTACION"
					'.Source= .Source & ", Y.FECHA AS FECHA_SALIDA"
	
					.Source= .Source & " FROM DEVOLUCIONES_DETALLES Z"
					.Source= .Source & " INNER JOIN"
					'.Source= .Source & " ENTRADAS_SALIDAS_ARTICULOS Y"
					.Source= .Source & " (SELECT ID_ARTICULO, PEDIDO, E_S, TIPO, MIN(FECHA) AS FECHA FROM ENTRADAS_SALIDAS_ARTICULOS"
					.Source= .Source & " GROUP BY PEDIDO, ID_ARTICULO, E_S, TIPO) Y"
					.Source= .Source & " ON Z.ID_ARTICULO=Y.ID_ARTICULO AND Z.ID_PEDIDO=Y.PEDIDO AND Z.UNIDADES_ACEPTADAS>=1 AND Y.E_S='SALIDA' AND Y.TIPO='PEDIDO'"
					.Source= .Source & " LEFT JOIN PEDIDOS X ON X.ID=Z.ID_PEDIDO"
					.Source= .Source & " LEFT JOIN V_CLIENTES W ON W.ID=X.CODCLI"
					.Source= .Source & " LEFT JOIN V_EMPRESAS V ON V.ID=W.EMPRESA"
					.Source= .Source & " LEFT JOIN PEDIDOS_DETALLES T ON Z.ID_PEDIDO=T.ID_PEDIDO AND Z.ID_ARTICULO=T.ARTICULO"
					.Source= .Source & " WHERE Z.UNIDADES_ACEPTADAS>=1"
					IF articulo_seleccionado<>"" then
						.Source= .Source & " AND Z.ID_ARTICULO=" & articulo_seleccionado
					END IF
					if fecha_i<>"" then
						'.Source= .Source & " AND (B.FECHA <= '" & fecha_i & "')"
						.Source= .Source & " AND (CONVERT(VARCHAR(8), Y.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & fecha_i & "', 103) , 112))" 'pone las 2 fechas en formato yyyymmdd (112--yyyymmdd y 103--dd/mm/yyyy) 
					end if
					if fecha_f<>"" then
						'.Source= .Source & " AND (B.FECHA <= '" & fecha_f & "')"
						.Source= .Source & " AND (CONVERT(VARCHAR(8), Y.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & fecha_f & "', 103) , 112))" 'pone las 2 fechas en formato yyyymmdd (112--yyyymmdd y 103--dd/mm/yyyy) 
					end if
					.Source= .Source & " GROUP BY V.EMPRESA"
					if diferenciar_sucursales_seleccionada="SI" then
						.Source= .Source & ", W.ID"
					end if
					if diferenciar_articulos_seleccionada="SI" then
						.Source= .Source & ", Z.ID_ARTICULO"
					end if
					if diferenciar_marca_seleccionada="SI" then
						.Source= .Source & ", W.MARCA"
					end if
					if diferenciar_tipo_seleccionada="SI" then
						.Source= .Source & ", W.TIPO"
					end if

					.Source= .Source & ") DEVOLUCIONES"
					
					.Source= .Source & " ON ARTICULOS.NOMBRE_EMPRESA=DEVOLUCIONES.EMPRESA"
					if diferenciar_sucursales_seleccionada="SI" then
						.Source= .Source & " AND ARTICULOS.CODCLIENTE=DEVOLUCIONES.CODCLIENTE" 
					end if
					if diferenciar_articulos_seleccionada="SI" then
						.Source= .Source & " AND ARTICULOS.ID_ARTICULO=DEVOLUCIONES.ID_ARTICULO" 
					end if
					if diferenciar_marca_seleccionada="SI" then
						.Source= .Source & " AND ARTICULOS.MARCA=DEVOLUCIONES.MARCA"
					end if
					if diferenciar_tipo_seleccionada="SI" then
						.Source= .Source & " AND ARTICULOS.TIPO=DEVOLUCIONES.TIPO"
					end if
				'end if
								
				.Source= .Source & " ORDER BY ARTICULOS.NOMBRE_EMPRESA"
				IF diferenciar_sucursales_seleccionada="SI" THEN
					.Source= .Source & ", ARTICULOS.NOMBRE"
				END IF
				if diferenciar_articulos_seleccionada="SI" then
					.Source= .Source & ", ARTICULOS.DESCRIPCION"
				end if
				
			else 'cuando agrupamos por articulo
			
			
				'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
				'NUEVA CONSULTA AÑADIENDO LAS DEVOLUCIONES Y LA FECHA DE SALIDA DEL PRODUCTO ASOCIADO
			
				.Source="SELECT  ARTICULOS.*"
				'.Source= .Source & ", DEVOLUCIONES.*"
				.Source= .Source & ", DEVOLUCIONES.UNIDADES_DEVUELTAS"
				.Source= .Source & ", DEVOLUCIONES.TOTAL_DEVOLUCIONES AS TOTAL_IMPORTE_DEVOLUCIONES"
				.Source= .Source & ", ROUND(CASE WHEN ARTICULOS.TOTAL_IMPORTE=0 THEN 0 "
				.Source= .Source & "	ELSE (DEVOLUCIONES.UNIDADES_DEVUELTAS * (ARTICULOS.TOTAL_IMPORTE/ARTICULOS.CANTIDAD_TOTAL)) END, 2) AS TOTAL_IMPORTE_DEVOLUCIONES"
				.Source= .Source & " FROM"
				.Source= .Source & " (SELECT"
				'.Source= .Source & " MAX(A.ID) AS ID_ARTICULO"
				.Source= .Source & " A.ID AS ID_ARTICULO"
				.Source= .Source & " , A.CODIGO_SAP as CODIGO_SAP"
				.Source= .Source & ", A.DESCRIPCION as ARTICULO"
				.Source= .Source & ", A.UNIDADES_DE_PEDIDO, A.RAPPEL, A.VALOR_RAPPEL, A.PRECIO_COSTE"
				.Source= .Source & ", (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=A.PROVEEDOR) AS PROVEEDOR"
				.Source= .Source & ", A.REFERENCIA_DEL_PROVEEDOR"
				if diferenciar_empresas_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ", F.EMPRESA AS NOMBRE_EMPRESA"
				end if
				if diferenciar_sucursales_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ", E.Id AS CODCLIENTE, E.NOMBRE, E.CODIGO_EXTERNO"
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", E.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", E.TIPO"
				end if

				.Source= .Source & ", SUM(B.CANTIDAD) as CANTIDAD_TOTAL"
				'.Source= .Source & ", B.CANTIDAD as CANTIDAD_TOTAL"
				'.Source= .Source & ", SUM(ROUND(((D.TOTAL / D.CANTIDAD) * B.CANTIDAD), 2)) AS TOTAL_IMPORTE"
				.Source= .Source & ", ROUND(SUM(CASE WHEN D.TOTAL=0 THEN 0 ELSE (B.CANTIDAD * (D.TOTAL/D.CANTIDAD)) END), 2) AS TOTAL_IMPORTE"
				
				'.Source= .Source & ", ROUND(((D.TOTAL / D.CANTIDAD) * B.CANTIDAD), 2) AS TOTAL_IMPORTE"
				'.Source= .Source & ", B.FECHA AS FECHA_ENVIO"
				'********************************************
				'DIFERENTES FORMATOS PARA CONVERTIR FECHAS Y PODER COMPARARLAS
				', CONVERT(VARCHAR(8), B.FECHA, 112) AS FECHA_FORMATEADA
				', CONVERT(VARCHAR(8),'01-04-2021', 112) AS FECHA_LIMITE
				', CONVERT(DATETIME,'01-04-2021') AS FECHA_LIMITE_DATE
				', CONVERT(VARCHAR(8), CONVERT(DATETIME,'01-04-2021') , 112) AS FECHA_LIMITE_DATE_TO_STRING

				.Source= .Source & " FROM ARTICULOS A"
				.Source= .Source & " INNER JOIN ENTRADAS_SALIDAS_ARTICULOS B"
				.Source= .Source & " ON A.ID=B.ID_ARTICULO AND B.E_S='SALIDA' AND B.TIPO='PEDIDO'"
				.Source= .Source & " INNER JOIN PEDIDOS C"
				.Source= .Source & " ON C.ID = B.PEDIDO"
				.Source= .Source & " INNER JOIN PEDIDOS_DETALLES D"
				.Source= .Source & " ON C.ID=D.ID_PEDIDO AND A.ID=D.ARTICULO"
				.Source= .Source & " INNER JOIN V_CLIENTES E"
				.Source= .Source & " ON C.CODCLI = E.Id"
				.Source= .Source & " INNER JOIN V_EMPRESAS F"
				.Source= .Source & " ON E.EMPRESA = F.Id"
				
				'.Source= .Source & " WHERE PEDIDOS.ESTADO='ENVIADO'"
				.Source= .Source & " WHERE 1=1"
				'ESTO YA NO SE COMPRUEBA... YA NO HAY PEDIDOS RESERVADOS
				'if reservas_asm_gls_seleccionada="SI" then
				'		.Source= .Source & " AND PEDIDOS_DETALLES.ESTADO='RESERVADO'"
				'	else
				'		.Source= .Source & " AND PEDIDOS_DETALLES.ESTADO='ENVIADO'"
				'end if

				if fecha_i<>"" then
					'.Source= .Source & " AND (B.FECHA <= '" & fecha_i & "')"
					.Source= .Source & " AND (CONVERT(VARCHAR(8), B.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & fecha_i & "', 103) , 112))" 'pone las 2 fechas en formato yyyymmdd (112--yyyymmdd y 103--dd/mm/yyyy) 
				end if
				if fecha_f<>"" then
					'.Source= .Source & " AND (B.FECHA <= '" & fecha_f & "')"
					.Source= .Source & " AND (CONVERT(VARCHAR(8), B.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & fecha_f & "', 103) , 112))" 'pone las 2 fechas en formato yyyymmdd (112--yyyymmdd y 103--dd/mm/yyyy) 
				end if
				if articulo_seleccionado<>"" then
					'.Source= .Source & " AND (A.CODIGO_SAP = '" & articulo_seleccionado & "')"
					.Source= .Source & " AND (A.ID = " & articulo_seleccionado & ")"
				end if
				
				.Source= .Source & " GROUP BY A.ID, A.CODIGO_SAP, A.DESCRIPCION, A.UNIDADES_DE_PEDIDO, A.RAPPEL, A.VALOR_RAPPEL"
				.Source= .Source & ", A.PRECIO_COSTE, A.PROVEEDOR, A.REFERENCIA_DEL_PROVEEDOR"
				if diferenciar_empresas_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ", F.EMPRESA"
				end if
				if diferenciar_sucursales_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ", E.ID, E.NOMBRE, E.CODIGO_EXTERNO"
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", E.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", E.TIPO"
				end if
				
				'AL MENTERLO EN OTRO SELECT NO SE ORDENA....
				'.Source= .Source & " order by A.DESCRIPCION"
				
				.Source= .Source & ") ARTICULOS"

				.Source= .Source & " LEFT JOIN"

				.Source= .Source & " (SELECT Z.ID_ARTICULO"
				if diferenciar_empresas_seleccionada="SI" then
					.Source= .Source & ", V.EMPRESA"
				end if
				if diferenciar_sucursales_seleccionada="SI" then
					.Source= .Source & ", W.ID AS CODCLIENTE"
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", W.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", W.TIPO" 
				end if
				.Source= .Source & ", SUM(UNIDADES_ACEPTADAS) AS UNIDADES_DEVUELTAS"
				.Source= .Source & ", SUM(ROUND((UNIDADES_ACEPTADAS * (T.TOTAL/T.CANTIDAD)),2)) AS TOTAL_DEVOLUCIONES"
					
				'.Source= .Source & ", Z.UNIDADES_ACEPTADAS AS UNIDADES_DEVUELTAS"
				'.Source= .Source & ", Z.FECHA_ACEPTACION"
				'.Source= .Source & ", Y.FECHA AS FECHA_SALIDA"

				.Source= .Source & " FROM DEVOLUCIONES_DETALLES Z"
				.Source= .Source & " INNER JOIN"
				'.Source= .Source & " ENTRADAS_SALIDAS_ARTICULOS Y"
				.Source= .Source & " (SELECT ID_ARTICULO, PEDIDO, E_S, TIPO, MIN(FECHA) AS FECHA FROM ENTRADAS_SALIDAS_ARTICULOS"
				.Source= .Source & " GROUP BY PEDIDO, ID_ARTICULO, E_S, TIPO) Y"
				.Source= .Source & " ON Z.ID_ARTICULO=Y.ID_ARTICULO AND Z.ID_PEDIDO=Y.PEDIDO AND Z.UNIDADES_ACEPTADAS>=1 AND Y.E_S='SALIDA' AND Y.TIPO='PEDIDO'"
				.Source= .Source & " LEFT JOIN PEDIDOS X ON X.ID=Z.ID_PEDIDO"
				.Source= .Source & " LEFT JOIN V_CLIENTES W ON W.ID=X.CODCLI"
				.Source= .Source & " LEFT JOIN V_EMPRESAS V ON V.ID=W.EMPRESA"
				.Source= .Source & " LEFT JOIN PEDIDOS_DETALLES T ON Z.ID_PEDIDO=T.ID_PEDIDO AND Z.ID_ARTICULO=T.ARTICULO"

				.Source= .Source & " WHERE Z.UNIDADES_ACEPTADAS>=1"
				IF articulo_seleccionado<>"" then
					.Source= .Source & " AND Z.ID_ARTICULO=" & articulo_seleccionado
				END IF
				if fecha_i<>"" then
					'.Source= .Source & " AND (B.FECHA <= '" & fecha_i & "')"
					.Source= .Source & " AND (CONVERT(VARCHAR(8), Y.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & fecha_i & "', 103) , 112))" 'pone las 2 fechas en formato yyyymmdd (112--yyyymmdd y 103--dd/mm/yyyy) 
				end if
				if fecha_f<>"" then
					'.Source= .Source & " AND (B.FECHA <= '" & fecha_f & "')"
					.Source= .Source & " AND (CONVERT(VARCHAR(8), Y.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & fecha_f & "', 103) , 112))" 'pone las 2 fechas en formato yyyymmdd (112--yyyymmdd y 103--dd/mm/yyyy) 
				end if
				.Source= .Source & " GROUP BY Z.ID_ARTICULO"
				if diferenciar_empresas_seleccionada="SI" then
					.Source= .Source & ", V.EMPRESA"
				end if
				if diferenciar_sucursales_seleccionada="SI" then
					.Source= .Source & ", W.ID"
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", W.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", W.TIPO"
				end if
				.Source= .Source & ") DEVOLUCIONES"
				
				.Source= .Source & " ON ARTICULOS.ID_ARTICULO=DEVOLUCIONES.ID_ARTICULO"
				if diferenciar_empresas_seleccionada="SI" then
					.Source= .Source & " AND ARTICULOS.NOMBRE_EMPRESA=DEVOLUCIONES.EMPRESA"
				end if
				if diferenciar_sucursales_seleccionada="SI" then
					.Source= .Source & " AND ARTICULOS.CODCLIENTE=DEVOLUCIONES.CODCLIENTE" 
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & " AND ARTICULOS.MARCA=DEVOLUCIONES.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & " AND ARTICULOS.TIPO=DEVOLUCIONES.TIPO"
				end if
				
				.Source= .Source & " ORDER BY ARTICULOS.ARTICULO"
				if diferenciar_empresas_seleccionada="SI" then
					.Source= .Source & ", ARTICULOS.NOMBRE_EMPRESA"
				end if
				IF diferenciar_sucursales_seleccionada="SI" THEN
					.Source= .Source & ", ARTICULOS.NOMBRE"
				END IF
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", ARTICULOS.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", ARTICULOS.TIPO"
				end if
				
			end if
			'response.write("<br><BR>CONSULTA ANTIGUA: " & .source)			
			
			cadena_consulta=.source
			
			
			if articulos_sin_consumo_seleccionada="SI" then
				cadena_articulos="SELECT V_EMPRESAS.EMPRESA AS NOMBRE_EMPRESA, ARTICULOS.ID, ARTICULOS.CODIGO_SAP,"
				cadena_articulos=cadena_articulos & " ARTICULOS.DESCRIPCION, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.RAPPEL, ARTICULOS.VALOR_RAPPEL"
				cadena_articulos=cadena_articulos & ", ARTICULOS.PRECIO_COSTE, (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=ARTICULOS.PROVEEDOR) AS PROVEEDOR"
				cadena_articulos=cadena_articulos & ", ARTICULOS.REFERENCIA_DEL_PROVEEDOR"
				if diferenciar_tipo_seleccionada="SI" then
					cadena_articulos=cadena_articulos & ", V_CLIENTES_TIPO.TIPO"
				end if	
				cadena_articulos=cadena_articulos & " FROM ARTICULOS INNER JOIN ARTICULOS_EMPRESAS"
				cadena_articulos=cadena_articulos & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
				cadena_articulos=cadena_articulos & " INNER JOIN V_EMPRESAS"
				cadena_articulos=cadena_articulos & " ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA=V_EMPRESAS.ID"
				if diferenciar_tipo_seleccionada="SI" then
					cadena_articulos=cadena_articulos & " INNER JOIN V_CLIENTES_TIPO"
					cadena_articulos=cadena_articulos & " ON V_EMPRESAS.ID=V_CLIENTES_TIPO.EMPRESA"
				end if
				
				
				cadena_articulos=cadena_articulos & " WHERE ARTICULOS.BORRADO='NO'" 
				if empresa_seleccionada<>"" then
					cadena_articulos=cadena_articulos & " AND ARTICULOS_EMPRESAS.CODIGO_EMPRESA= " & empresa_seleccionada
				end if
				
				cadena_envios="SELECT V_EMPRESAS.EMPRESA AS NOMBRE_EMPRESA"
				if diferenciar_sucursales_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.Id CodCliente, V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					cadena_envios=cadena_envios & ", ARTICULOS.CODIGO_SAP"
					cadena_envios=cadena_envios & ", ARTICULOS.DESCRIPCION"
					cadena_envios=cadena_envios & ", ARTICULOS.UNIDADES_DE_PEDIDO"
					cadena_envios=cadena_envios & ", ARTICULOS.RAPPEL"
					cadena_envios=cadena_envios & ", ARTICULOS.VALOR_RAPPEL"
					cadena_envios=cadena_envios & ", ARTICULOS.PRECIO_COSTE"
					cadena_envios=cadena_envios & ", (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=ARTICULOS.PROVEEDOR) AS PROVEEDOR"
					cadena_envios=cadena_envios & ", ARTICULOS.REFERENCIA_DEL_PROVEEDOR"
				

				end if
				if diferenciar_marca_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.TIPO"
				end if
				cadena_envios=cadena_envios & ", max(PEDIDOS_DETALLES.ARTICULO) as ID_ARTICULO"
				'cadena_envios=cadena_envios & ", sum(PEDIDOS_DETALLES.CANTIDAD) as cantidad_total"
				'cadena_envios=cadena_envios & ", ROUND(sum(PEDIDOS_DETALLES.TOTAL),2) AS TOTAL_IMPORTE"
				cadena_envios=cadena_envios & ", SUM(B.CANTIDAD) as CANTIDAD_TOTAL"
				cadena_envios=cadena_envios & ", ROUND(SUM(CASE WHEN PEDIDOS_DETALLES.TOTAL=0 THEN 0 ELSE (B.CANTIDAD * (PEDIDOS_DETALLES.TOTAL/PEDIDOS_DETALLES.CANTIDAD)) END), 2) AS TOTAL_IMPORTE"
				
				cadena_envios=cadena_envios & " FROM ENTRADAS_SALIDAS_ARTICULOS B INNER JOIN PEDIDOS_DETALLES"
				cadena_envios=cadena_envios & " ON PEDIDOS_DETALLES.ARTICULO=B.ID_ARTICULO AND B.E_S='SALIDA' AND B.TIPO='PEDIDO'"
				
				cadena_envios=cadena_envios & " INNER JOIN PEDIDOS"
				cadena_envios=cadena_envios & " ON PEDIDOS.ID = PEDIDOS_DETALLES.ID_PEDIDO"
				
				cadena_envios=cadena_envios & " INNER JOIN V_CLIENTES"
				cadena_envios=cadena_envios & " ON PEDIDOS.CODCLI = V_CLIENTES.Id"
				cadena_envios=cadena_envios & " INNER JOIN ARTICULOS"
				cadena_envios=cadena_envios & " ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID"
				cadena_envios=cadena_envios & " INNER JOIN V_EMPRESAS"
				cadena_envios=cadena_envios & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
				cadena_envios=cadena_envios & " WHERE 1=1"
				if fecha_i<>"" then
					'.Source= .Source & " AND (B.FECHA <= '" & fecha_i & "')"
					cadena_envios=cadena_envios & " AND (CONVERT(VARCHAR(8), B.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & fecha_i & "', 103) , 112))" 'pone las 2 fechas en formato yyyymmdd (112--yyyymmdd y 103--dd/mm/yyyy) 
				end if
				if fecha_f<>"" then
					'.Source= .Source & " AND (B.FECHA <= '" & fecha_f & "')"
					cadena_envios=cadena_envios & " AND (CONVERT(VARCHAR(8), B.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & fecha_f & "', 103) , 112))" 'pone las 2 fechas en formato yyyymmdd (112--yyyymmdd y 103--dd/mm/yyyy) 
				end if
				
				
				if empresa_seleccionada<>"" then
					cadena_envios=cadena_envios & " AND (V_CLIENTES.EMPRESA = " & empresa_seleccionada & ")"
				end if

				cadena_envios=cadena_envios & " GROUP BY V_EMPRESAS.EMPRESA"
				if diferenciar_sucursales_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.Id, V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					cadena_envios=cadena_envios & ", ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.RAPPEL, ARTICULOS.VALOR_RAPPEL"
					cadena_envios=cadena_envios & ", ARTICULOS.PRECIO_COSTE, ARTICULOS.PROVEEDOR, ARTICULOS.REFERENCIA_DEL_PROVEEDOR"
				end if
				if diferenciar_marca_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.TIPO"
				end if
				
				
				consulta_total="SELECT ISNULL(A.NOMBRE_EMPRESA, ISNULL(B.NOMBRE_EMPRESA,'--')) AS NOMBRE_EMPRESA"
				
				if diferenciar_sucursales_seleccionada="SI" then
					consulta_total=consulta_total & ", B.CodCliente"
					consulta_total=consulta_total & ", B.NOMBRE AS NOMBRE"
					consulta_total=consulta_total & ", B.CODIGO_EXTERNO AS CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					consulta_total=consulta_total & ", ISNULL(A.CODIGO_SAP, ISNULL(B.CODIGO_SAP,'--')) AS CODIGO_SAP"
					consulta_total=consulta_total & ", ISNULL(A.DESCRIPCION, ISNULL(B.DESCRIPCION + ' (borrado)','--')) AS DESCRIPCION"
					consulta_total=consulta_total & ", ISNULL(A.UNIDADES_DE_PEDIDO, ISNULL(B.UNIDADES_DE_PEDIDO,'--')) AS UNIDADES_DE_PEDIDO"
					if diferenciar_rappel_seleccionado="SI" then
						consulta_total=consulta_total & ", ISNULL(A.RAPPEL, ISNULL(B.RAPPEL,'--')) AS RAPPEL"
						consulta_total=consulta_total & ", ISNULL(A.VALOR_RAPPEL, ISNULL(B.VALOR_RAPPEL,'--')) AS VALOR_RAPPEL"
						
					end if
					if diferenciar_costes_seleccionado="SI" then
						consulta_total=consulta_total & ", ISNULL(A.PRECIO_COSTE, ISNULL(B.PRECIO_COSTE,'--')) AS PRECIO_COSTE"
						consulta_total=consulta_total & ", ISNULL(A.PROVEEDOR, ISNULL(B.PROVEEDOR,'--')) AS PROVEEDOR"
						consulta_total=consulta_total & ", ISNULL(A.REFENCIA_DEL_PROVEEDOR, ISNULL(B.REFERENCIA_DEL_PROVEEDOR,'--')) AS REFERENCIA_DEL_PROVEEDOR"
					end if
				end if
				if diferenciar_marca_seleccionada="SI" then
					consulta_total=consulta_total & ", B.MARCA AS MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					consulta_total=consulta_total & ", ISNULL(A.TIPO, ISNULL(B.TIPO,'--')) AS TIPO"
				end if

				consulta_total=consulta_total & ", ISNULL(B.CANTIDAD_TOTAL, 0) AS CANTIDAD_TOTAL"
				consulta_total=consulta_total & ", ISNULL(B.TOTAL_IMPORTE, 0) AS TOTAL_IMPORTE"
				consulta_total=consulta_total & " FROM (" & cadena_articulos & ") AS A"
				consulta_total=consulta_total & " FULL OUTER JOIN (" & cadena_envios & ") AS B"
				consulta_total=consulta_total & " ON A.ID=B.ID_ARTICULO"
				if diferenciar_tipo_seleccionada="SI" then
					consulta_total=consulta_total & " AND A.TIPO=B.TIPO"
				end if
				consulta_total=consulta_total & " ORDER BY NOMBRE_EMPRESA"
				
				if diferenciar_sucursales_seleccionada="SI" then
					consulta_total=consulta_total & ", NOMBRE, CodCliente, CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					consulta_total=consulta_total & ", DESCRIPCION"
					if diferenciar_tipo_seleccionada="SI" then
						consulta_total=consulta_total & " , TIPO"
					end if
				end if
				if diferenciar_marca_seleccionada="SI" then
					consulta_total=consulta_total & ", B.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" AND diferenciar_articulos_seleccionada<>"SI" then
					consulta_total=consulta_total & ", B.TIPO"
				end if
				
								
				
				
				'response.write("<br><BR>CADENA_ARTICULOS: " & cadena_articulos)
				'response.write("<br><BR>CADENA_ENVIOS: " & cadena_envios)
				'response.write("<br><BR>CADENA_TOTAL: " & consulta_total)
				.Source=consulta_total
				cadena_consulta=.Source
				
			
			end if
			
			if ver_cadena="SI" then
				response.write("<br><BR>CADENA_ARTICULOS: " & cadena_articulos)
				response.write("<br><BR>CADENA_ENVIOS: " & cadena_envios)
				response.write("<br><BR>CADENA_TOTAL: " & consulta_total)
				response.write("<BR><br><BR>CONSULTA: " & .source)			
			end if
			
			
			
			.Open
			
		end with
		'while not consumos.eof
		'	response.write("<br>empresa: " & consumos("nombre_empresa"))
		'	consumos.movenext
		'wend
		'connimprenta.CommitTrans ' finaliza la transaccion

		


%>
<html>
<head>
<link href="estilos.css" rel="stylesheet" type="text/css" />
<style>
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
<!-- European format dd-mm-yyyy -->
	<script language="JavaScript" src="js/calendario/calendar1.js"></script>
<!-- Date only with year scrolling -->
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
	//alert("tamaño: " + s.legth)
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


	
	
   function mover_formulario(objetivo)
   {
   	if (objetivo=='volver')
   		accion='Lista_Articulos.asp'
	  else
	  	accion='Grabar_Pedido.asp';
	document.getElementById('frmpedido').action=accion
	document.getElementById('frmpedido').submit()	
	

   }
   	

function mostrar_articulo(articulo,accion)
   {
   	//alert('hotel: ' + hotel + ' accion: ' + accion)
   	document.getElementById('ocultoid_articulo').value=articulo
	document.getElementById('ocultoaccion').value=accion
   	document.getElementById('frmmostrar_articulo').submit()	
	

   }

function activar_articulos_sin_consumo()
{
	if (document.getElementById('chkdiferenciar_articulos').checked)
		{
		document.getElementById('fila_articulos_sin_consumo').style.display='';
		}
	  else
		{
		document.getElementById('chkdiferenciar_rappel').checked=false;
		document.getElementById('chkdiferenciar_costes').checked=false;
		document.getElementById('fila_articulos_sin_consumo').style.display='none';
		}
}

function mostrar_capas(capa)
{
	//console.log('he pulsado....' + capa)
	if (capa=='articulos')
		{
		//console.log('dentro de articulos')
	
		document.getElementById('chkdiferenciar_articulos').checked=false
		//document.getElementById('chkarticulos_sin_consumo').checked=false
		document.getElementById('fila_articulos_sin_consumo').style.display='none';
		

		
		document.getElementById('tabla_diferenciar_articulos_relleno').style.display='none';
		document.getElementById('tabla_diferenciar_articulos').style.display='none';
		document.getElementById('tabla_diferenciar_empresas_relleno').style.display='block';
		document.getElementById('tabla_diferenciar_empresas').style.display='block';
		document.getElementById('cmbempresas').style.display='none';
		document.getElementById('cmbarticulos').style.display='block';
		document.getElementById('opciones_ordenacion').style.display='block';
		
		reordenar_articulos('codigo_sap', '')
		document.getElementById('cmbempresas').value='';
		}
	
	if (capa=='empresas')
		{
		//console.log('dentro de empresas')
		document.getElementById('chkdiferenciar_empresas').checked=false

		document.getElementById('tabla_diferenciar_empresas_relleno').style.display='none';
		document.getElementById('tabla_diferenciar_empresas').style.display='none';
		document.getElementById('tabla_diferenciar_articulos_relleno').style.display='block';
		document.getElementById('tabla_diferenciar_articulos').style.display='block';

		document.getElementById('cmbempresas').style.display='block';
		document.getElementById('cmbarticulos').style.display='none';
		document.getElementById('opciones_ordenacion').style.display='none';
		
		
		document.getElementById('cmbarticulos').value='';

		
		
		
		}
	
}

function reordenar_articulos(orden, valor)
{
	Actualizar_Combos('Obtener_Articulos_new.asp', '', valor,'capa_articulos', orden, '')
	/*
	if (valor!='')
		{
		document.getElementById("ocultoarticulo").value=document.getElementById("cmbarticulos").options[document.getElementById("cmbarticulos").selectedIndex].text
		}
	  else
	  	{
		document.getElementById("ocultoarticulo").value=''
		}
	*/
	
}
	

function rellenar_nombre_articulo()
{
if (document.getElementById("cmbarticulos").value!='')
	{
	document.getElementById("ocultoarticulo").value=document.getElementById("cmbarticulos").options[document.getElementById("cmbarticulos").selectedIndex].text
	}
else
	{
	document.getElementById("ocultoarticulo").value=''
	}
										
}	
</script>


	
<script language="javascript" src="Funciones_Ajax.js"></script>

</head>
<body onload="activar_articulos_sin_consumo()">


<table>
<tr>
	<td width="218" valign="top">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
				</td>
			</tr>
			<tr>
				<td>
				</td>
			</tr>
		
		
		</table>
	
	
		<div class="sidebarcell">
			
			<div id="side_freetext_title_39" class="title">
				<br />
				<font size="3"><b>Mantenimientos</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					· <a href="Consulta_Pedidos_Admin.asp">Pedidos</a><br />
					· <a href="Consulta_Articulos_Admin.asp">Artículos</a><br />
					· <a href="Consulta_Clientes_Admin.asp">Clientes</a><br />
					· <a href="Consulta_Informes_Admin.asp">Informes </a><br /><br />	
					· <a href="Informe_Maletas_Globalbag.asp">Informe Maletas Globalbag </a><br /><br />
					· <a href="Consulta_Informe_Stock_Valorado_Admin.asp">Informe Stock Valorado </a><br /><br />									
					· <a href="Carrusel_Admin.asp" target="_blank">Carrusel</a><br />					
					
					<br />
					
					<br /> 
					
					<br />
					
					<br />
					<br />
					
					
				</div>
				</div>
			</div>
		</div>
		
			</div>
		</div>
		
		
		
	</td>
	<td valign="top">
		<div id="main">
				
					
				<div class="fontbold" align="center">INFORMES</div>
				<div class="comment_text__"> 
					<form name="frmbuscar_consumos" id="frmbuscar_consumos" method="post" action="Consulta_Informes_Admin_NEW.asp">
						<input type="hidden" id="ocultover_cadena" name="ocultover_cadena" value="<%=ver_cadena%>" />
							
					<table width="95%" cellspacing="6" cellpadding="0" class="logintable" align="center">
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Opciones de Búsqueda</span>
							</td>
						</tr>
						<tr><td height="5"></td></tr>
						<tr>
							<td width="50%" class="dottedBorder vt al">
								
			  
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
										<tr>
											<td width="30%">Agrupar Por: </td>
											<td align="right">
												<input class="submitbtn" type="submit" name="Action" id="Action" value="Buscar" />
											</td>
										</tr>							
									</table>
									
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
									<tr>
										<td width="4%"></td>
										<td width="4%">
											<input type="radio" id="optagrupacion_empresa" name="optagrupacion" value="empresa" onclick="mostrar_capas('empresas')" checked />
										</td>
										<td width="10%">
											Empresa&nbsp;&nbsp;
										</td>
										<td width="82%">
											<select  name="cmbempresas" id="cmbempresas">
												<option value="" selected>* TODAS *</option>
												<%if vacio_empresas=false then %>
														<%for i=0 to UBound(mitabla_empresas,2)%>
															<option value="<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>"><%=mitabla_empresas(CAMPO_EMPRESA_EMPRESA,i)%></option>
														<%next%>
												<%end if%>
											</select>
											<script language="javascript">
												document.getElementById("cmbempresas").value='<%=empresa_seleccionada%>'
											</script>
											
										</td>
									</tr>							
													
									</table>
									<table border="0" width="100%"><tr><td height="3px"></td></tr></table>
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
									<tr>
										<td width="4%"></td>
										<td width="4%">
												<input type="radio" id="optagrupacion_articulo" name="optagrupacion" value="articulo" onclick="mostrar_capas('articulos')"/> 										
										</td>
										<td width="10%">
												Art&iacute;culo
												
												
											
										</td>
										<td width="82%">
											<div  id="opciones_ordenacion">
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<input type="radio" id="optordenacion_codigo" name="optordenacion" value="codigo_sap" onclick="reordenar_articulos('codigo_sap', document.getElementById('cmbarticulos').value)" checked/>
												Ordenar por C&oacute;digo
												&nbsp;&nbsp;&nbsp;
												<input type="radio" id="optordenacion_descripcion" name="optordenacion" value="descripcion" onclick="reordenar_articulos('descripcion', document.getElementById('cmbarticulos').value)"/>
												Ordenar por Descripci&oacute;n
											</div>
												
										</td>
									</tr>							
													
									</table>
									
									<table border="0" width="100%"><tr><td height="6px"></td></tr></table>
									
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
									<tr>
										<td width="100%">
											<div id="capa_articulos">
												<select  name="cmbarticulos" id="cmbarticulos">
														<option value="" selected>* TODOS *</option>
													</select>
											</div>
										</td>
									</tr>				
									</table>
								
									<%if agrupacion_seleccionada="articulo" then%>
											<script language="javascript">
												//alert('dentro de agrupacion_seleccionada <%=agrupacion_seleccionada%>')
												document.getElementById("optagrupacion_<%=agrupacion_seleccionada%>").checked=true
												
												document.getElementById('cmbempresas').style.display='none';
												document.getElementById('cmbarticulos').style.display='block';
												document.getElementById('opciones_ordenacion').style.display='block';
												<%if ordenacion_seleccionada="descripcion" then%>
													reordenar_articulos('descripcion', '<%=articulo_seleccionado%>')
												<%else%>	
													reordenar_articulos('codigo_sap', '<%=articulo_seleccionado%>')
												<%end if%>	
													
												
											</script>
									  <%else%>
 											<script language="javascript">
												//alert('dentro de agrupacion_seleccionada <%=agrupacion_seleccionada%>')
												document.getElementById("optagrupacion_<%=agrupacion_seleccionada%>").checked=true
											
												document.getElementById('cmbempresas').style.display='block';
												document.getElementById('cmbarticulos').style.display='none';
												document.getElementById('opciones_ordenacion').style.display='none';
											</script>

									<%end if%>
								
								
								
									<br />
									<input name="chkreservas_asm_gls" id="chkreservas_asm_gls" type="checkbox" value="SI" />
									<%if reservas_asm_gls_seleccionada="SI" then%>
										<script language="javascript">
											document.getElementById("chkreservas_asm_gls").checked=true
										</script>
									<%end if%>
									<span class='fontbold'>Reservas ASM/GLS</span>
								
								
							</td>
						</tr>
					</table>		
					<table><tr><td height="5"></td></tr></table>
					<table width="95%" cellspacing="6" cellpadding="0" class="logintable" align="center" style="background-color:#778583">
						
						
						<tr>
							<td width="50%">
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td  style="padding:10px" width="14%"><font style="COLOR:#000000"><b>Fecha Inicio:</b></font></td>
									<td width="25%">
										<input type="Text" class="txtfield" name="txtfecha_inicio" id="txtfecha_inicio" value="<%=fecha_i%>" size=10>
                                		<a href="javascript:cal1.popup();"><img src="img/cal.gif" width="16" height="16" border="0" alt="Pulsa Aqui para Seleccionar una Fecha de Inicio"></a>
									
									
									</td>
									<td width="10%"><font style="COLOR:#000000"><b>Fecha Fin:</b></font> </td>
									<td width="29%">
										<input type="Text" class="txtfield" name="txtfecha_fin" id="txtfecha_fin" value="<%=fecha_f%>" size=10>
                                		<a href="javascript:cal2.popup();"><img src="img/cal.gif" width="16" height="16" border="0" alt="Pulsa Aqui para Seleccionar una Fecha de Fin"></a>
									
									
									</td>
									<td width="22%">
										<div align="right">										</div>
										
									</td>
								</tr>							
												
								</table>
								</td>
						</tr>
					</table>
					
						<table id="tabla_diferenciar_empresas_relleno" style="display:none"><tr><td height="5"></td></tr></table>		
						<table id="tabla_diferenciar_empresas" width="95%" cellspacing="6" cellpadding="0" align="center" style="background-color:#6699CC;display:none">
							<tr >
								<td>
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
									<tr>
										<td style="padding:10px" width="28%">
										<input name="chkdiferenciar_empresas" id="chkdiferenciar_empresas" type="checkbox" value="SI" />
										<%if diferenciar_empresas_seleccionada="SI" then%>
											<script language="javascript">
												document.getElementById("chkdiferenciar_empresas").checked=true
											</script>
										<%end if%>
										<span class='fontbold' style="color:#FFFFFF ">Diferenciar Empresas</span></td>
									</tr>							
									</table>
							  </td>
							</tr>
						</table>
					<%if agrupacion_seleccionada="articulo" then%>
						<script language="javascript">
								document.getElementById('tabla_diferenciar_empresas_relleno').style.display='block';
								document.getElementById('tabla_diferenciar_empresas').style.display='block';
						</script>
					<%end if%>
					
					
					<table><tr><td height="5"></td></tr></table>		
					<table width="95%" cellspacing="6" cellpadding="0" align="center" style="background-color:#464929">
						
						<tr >
							<td width="50%" >
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td style="padding:10px" width="28%">
									<input name="chkdiferenciar_sucursales" id="chkdiferenciar_sucursales" type="checkbox" value="SI" />
									<%if diferenciar_sucursales_seleccionada="SI" then%>
										<script language="javascript">
											document.getElementById("chkdiferenciar_sucursales").checked=true
										</script>
									<%end if%>
									<span class='fontbold' style="color:#FFFFFF ">Diferenciar Sucursales</span></td>
								  
									<td width="72%" style="color:#FFFFFF ">(util para obtener los consumos detallados de cada oficina de la empresa seleccionada)</td>
									
								</tr>							
												
								</table>
								
						  </td>
						</tr>
					</table>

					<table id="tabla_diferenciar_articulos_relleno" style="display:none"><tr><td height="5"></td></tr></table>		
					<table id="tabla_diferenciar_articulos" width="95%" cellspacing="6" cellpadding="0" align="center" style="background-color:#B09F87; display:none">
						
						<tr>
							<td width="50%">
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="28%" style="padding:10px">
										<input name="chkdiferenciar_articulos" id="chkdiferenciar_articulos" type="checkbox" value="SI" onclick="activar_articulos_sin_consumo()"/>
										<%if diferenciar_articulos_seleccionada="SI" then%>
											<script language="javascript">
												document.getElementById("chkdiferenciar_articulos").checked=true
											</script>
										<%end if%>
										
										<span class='fontbold' style="color:#000000 ">Diferenciar Artículos</span>
									</td>
									<td width="72%"  style="color:#000000 ">(util para obtener los consumos detallados de cada uno de los productos asociados a la empresa seleccionada)</td>
									
								</tr>							
												
								<tr style="display:none" id="fila_articulos_sin_consumo">
									<td width="28%" style="padding:10px;">&nbsp;</td>
										
									<td width="72%"  style="color:#000000;">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										  <tr>
											<th scope="col">
												<input name="chkdiferenciar_rappel" id="chkdiferenciar_rappel" type="checkbox" value="SI" />
												<%if diferenciar_rappel_seleccionado="SI" then%>
													<script language="javascript">
														document.getElementById("chkdiferenciar_rappel").checked=true
													</script>
												<%end if%>
												<span class='fontbold' style="color:#000000;padding-bottom:10px">Mostrar Informaci&oacute;n Rappel</span>
											</th>
											<th scope="col">
												<input name="chkdiferenciar_costes" id="chkdiferenciar_costes" type="checkbox" value="SI" />
												<%if diferenciar_costes_seleccionado="SI" then%>
													<script language="javascript">
														document.getElementById("chkdiferenciar_costes").checked=true
													</script>
												<%end if%>
												<span class='fontbold' style="color:#000000;padding-bottom:10px">Mostrar Costes, Proveedor y Ref. Prov.</span>
											</th>
										  </tr>
										</table>
								  </td>
									
								</tr>							
								</table>
								
						  </td>
						</tr>
					</table>
						
					<%if agrupacion_seleccionada="empresa" then%>						
						<script language="javascript">
								document.getElementById('tabla_diferenciar_articulos_relleno').style.display='block';
								document.getElementById('tabla_diferenciar_articulos').style.display='block';
						</script>
					<%end if%>	
						
					<table><tr><td height="5"></td></tr></table>		
					<table width="95%" cellspacing="6" cellpadding="0" align="center" style="background-color:#C9CDD1">
						
						<tr>
							<td width="50%" >
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="28%" style="padding:10px">
										<input name="chkdiferenciar_marca" id="chkdiferenciar_marca" type="checkbox" value="SI" />
										<%if diferenciar_marca_seleccionada="SI" then%>
										<script language="javascript">
											document.getElementById("chkdiferenciar_marca").checked=true
										</script>
									<%end if%>
										<span class='fontbold' style="color:#000000 ">Diferenciar Marca</span></td>
								  
									<td width="72%" style="color:#000000 ">(util para BARCELÓ, para obtener los consumos individualizados por marca (Barcelo, Confort, Premium))</td>
									
								</tr>							
												
								</table>
								
						  </td>
						</tr>
					</table>
					<table><tr><td height="5"></td></tr></table>		
					<table width="95%" cellspacing="6" cellpadding="0" align="center" style="background-color:#949CA6">
						
						<tr>
							<td width="50%">
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="28%" style="padding:10px">
										<input name="chkdiferenciar_tipo" id="chkdiferenciar_tipo" type="checkbox" value="SI" />
										<%if diferenciar_tipo_seleccionada="SI" then%>
										<script language="javascript">
											document.getElementById("chkdiferenciar_tipo").checked=true
										</script>
									<%end if%>
										<span class='fontbold' style="color:#000000 ">Diferenciar Tipo</span></td>
								  
									<td width="72%" style="color:#000000 ">(util para ASM, para obtener los consumos individualizados por tipo (Propias y Franquicias))</td>
									
								</tr>							
												
								</table>
								
						  </td>
						</tr>
					</table>
					
					
					
					
					
					
					
					
					
					
					<br />
					<br />
					
					
					
								<div id="main">
										<%if agrupacion_seleccionada="empresa" then%>
										
											<table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table">
                                              <tr style="background-color:#FCFCFC" valign="top">
                                                <th class="menuhdr" style="text-align:center">Empresa</th>
                                                <%if diferenciar_sucursales_seleccionada="SI" then%>
                                                <th class="menuhdr">Codigo</th>
                                                <th class="menuhdr">Cliente</th>
                                                <%end if%>
                                                <%if diferenciar_articulos_seleccionada="SI" then%>
                                                <th class="menuhdr">Cod. Sap</th>
                                                <th class="menuhdr">Artículo</th>
                                                <th class="menuhdr">Unidades Pedido</th>
													<%if diferenciar_costes_seleccionado="SI" then%>
														<th class="menuhdr">Coste</th>
														<th class="menuhdr">Proveedor</th>
														<th class="menuhdr">Ref. Prov.</th>
													<%end if%>
                                                <%end if%>
                                                <%if diferenciar_marca_seleccionada="SI" then%>
                                                <th class="menuhdr">Marca</th>
                                                <%end if%>
                                                <%if diferenciar_tipo_seleccionada="SI" then%>
                                                <th class="menuhdr">Tipo</th>
                                                <%end if%>
                                                <th class="menuhdr" style="text-align:center">Cantidad Total</th>
                                                <th class="menuhdr" style="text-align:center">Total Importe</th>
                                                <%'if diferenciar_articulos_seleccionada="SI" then%>
                                                <th class="menuhdr" style="text-align:center">Unidades Devueltas</th>
                                                <th class="menuhdr" style="text-align:center">Total Importe Dev.</th>
                                                <th class="menuhdr" style="text-align:center">Cantidad Neta</th>
                                                <th class="menuhdr" style="text-align:center">Total Importe Neto</th>
                                                <%'end if%>
                                                <%if diferenciar_articulos_seleccionada="SI" then
														if diferenciar_rappel_seleccionado="SI" then%>
                                                <th class="menuhdr">Rappel</th>
                                                <th class="menuhdr">Valor Rappel</th>
                                                <th class="menuhdr" style="text-align:center">C&aacute;lculo Rappel</th>
                                                <%end if
													end if%>
                                              </tr>
                                              <%vueltas=1
												  if not consumos.eof then %>
                                              <%while not consumos.eof%>
                                              <tr  valign="top" id="fila_articulo_<%=i%>">
                                                <%
															vueltas=vueltas + 1
															if vueltas=200 then
																Response.Flush
																vueltas=1
															end if
															%>
                                                <td  class="ac item_row" width="82"><%=consumos("NOMBRE_EMPRESA")%></td>
                                                <%if diferenciar_sucursales_seleccionada="SI" then%>
                                                <td  class="ac item_row" style="text-align:left; width:30px"><%=consumos("CodCliente")%> </td>
                                                <td  class="ac item_row" style="text-align:left" width="76"><%=consumos("NOMBRE")%>
                                                    <%if consumos("CODIGO_EXTERNO")<>"" then%>
															&nbsp(<%=consumos("CODIGO_EXTERNO")%>)
      												<%end if%>
                                                </td>
                                                <%end if%>
                                                <%if diferenciar_articulos_seleccionada="SI" then%>
                                                <td  class="ac item_row" width="101"><%=consumos("CODIGO_SAP")%> </td>
                                                <td   width="306" class="al item_row" style="text-align:right;" ><%=consumos("DESCRIPCION")%>&nbsp; </td>
                                                <td  class="ac item_row" width="101"><%=consumos("UNIDADES_DE_PEDIDO")%> </td>
                                                <%if diferenciar_costes_seleccionado="SI" then%>
                                                <td  class="ac item_row" width="101"><%=consumos("PRECIO_COSTE")%> </td>
                                                <td  class="ac item_row" width="101"><%=consumos("PROVEEDOR")%> </td>
                                                <td  class="ac item_row" width="101"><%=consumos("REFERENCIA_DEL_PROVEEDOR")%> </td>
                                                <%end if%>
                                                <%end if%>
                                                <%if diferenciar_marca_seleccionada="SI" then%>
                                                <td  class="ac item_row" width="101"><%=consumos("MARCA")%> </td>
                                                <%end if%>
                                                <%if diferenciar_tipo_seleccionada="SI" then%>
                                                <td  class="ac item_row" width="101"><%=consumos("TIPO")%> </td>
                                                <%end if%>
                                                <td  class="ar item_row" width="101"><%
																if consumos("CANTIDAD_TOTAL")<>"" then
																		Response.Write(FORMATNUMBER(consumos("CANTIDAD_TOTAL"),0,-1,0,-1))
																	else
																		Response.Write("0")
																end if
																%>
                                                </td>
                                                <td  class="ar item_row" width="101"><%
																if consumos("TOTAL_IMPORTE")<>"" then
																		Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE"),2,-1,0,-1) & "&nbsp;€")
																	else
																		Response.Write("0&nbsp;€")
																end if
																%>
                                                </td>
                                                <%'if diferenciar_articulos_seleccionada="SI" then%>
                                                <td  class="ar item_row" width="101"><%
																		if consumos("UNIDADES_DEVUELTAS")<>"" then
																				Response.Write(FORMATNUMBER(consumos("UNIDADES_DEVUELTAS"),0,-1,0,-1))
																			else
																				Response.Write("0")
																		end if
																		%>
                                                </td>
                                                <td  class="ar item_row" width="101"><%
																		if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
																				Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE_DEVOLUCIONES"),2,-1,0,-1) & "&nbsp;€")
																			else
																				Response.Write("0&nbsp;€")
																		end if
																		%>
                                                </td>
                                                <td  class="ar item_row" width="101"><%
																		if consumos("UNIDADES_DEVUELTAS")<>"" then
																				Response.Write(FORMATNUMBER((consumos("CANTIDAD_TOTAL") - consumos("UNIDADES_DEVUELTAS")),0,-1,0,-1))
																			else
																				Response.Write(FORMATNUMBER(consumos("CANTIDAD_TOTAL"),0,-1,0,-1))
																		end if
																		%>
                                                </td>
                                                <td  class="ar item_row" width="101"><%
																		if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
																				Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")),2,-1,0,-1) & "&nbsp;€")
																			else
																				Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE"),2,-1,0,-1) & "&nbsp;€")
																		end if
																		%>
                                                </td>
                                                <%if diferenciar_rappel_seleccionado="SI" then%>
                                                <td  class="ac item_row" width="101"><%=consumos("RAPPEL")%> </td>
                                                <td  class="ac item_row" width="50"><%=consumos("VALOR_RAPPEL")%> </td>
                                                <td  class="ar item_row" width="101"><%
																		valor_del_rappel="" & consumos("VALOR_RAPPEL")
																		'response.write("<br>diferenciar_tipo_seleccionada: " & diferenciar_tipo_seleccionada)
																		'response.write("<br>total importe: " & consumos("TOTAL_IMPORTE"))
																		'response.write("<br>valor_rappel: " & valor_del_rappel)
																		'response.write("<br>CONSUMOS VALOR RAPPEL: " & consumos("VALOR_RAPPEL"))
																		'response.write("<br>tipo_agencia: " & consumos("TIPO"))
																		'response.write("<br>total importe DEVOLUCIONES: " & consumos("TOTAL_IMPORTE_DEVOLUCIONES"))
																		'response.write("<br>-----<BR>")
																		
																		if diferenciar_tipo_seleccionada="SI" then
																			if consumos("TOTAL_IMPORTE")<>"" and valor_del_rappel<>"" and (consumos("TIPO")="AGENCIA" OR consumos("TIPO")="ARRASTRES") then
																					'Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																					if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
																							Response.Write(FORMATNUMBER(((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")) * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																						else
																							Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																					end if
																				else
																					Response.Write("")
																			end if
																		  else
																			if consumos("TOTAL_IMPORTE")<>"" and valor_del_rappel<>"" then
																					'Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																					if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
																							Response.Write(FORMATNUMBER(((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")) * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																						else
																							Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																					end if
																				else
																					Response.Write("")
																			end if
																		end if
																		%></td>
                                                <%end if%>
                                                <%'end if%>
                                              </tr>
                                              <%consumos.movenext%>
                                              <%wend%>
                                              <%else%>
                                              <tr>
                                                <td align="center" colspan="5"><b><font class="fontbold">NO Hay Consumos Que Cumplan El Critero de Búsqueda...</font></b><br />
                                                </td>
                                              </tr>
                                              <%end if%>
                                            </table>
											<%else 'cuando agrupamos por articulos%>
											
											<table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table">
											
											
											
											
                                                
											
											
												<tr style="background-color:#FCFCFC" valign="top">
													<th class="menuhdr" style="text-align:center">Cod. Sap</th>
													<th class="menuhdr" style="text-align:center">Descripci&oacute;n</th>
													<th class="menuhdr" style="text-align:center">Unidades Pedido</th>
													<%if diferenciar_costes_seleccionado="SI" then%>
														<th class="menuhdr" style="text-align:center">Coste</th>
														<th class="menuhdr" style="text-align:center">Proveedor</th>
														<th class="menuhdr" style="text-align:center">Ref. Prov</th>
													<%end if%>
													<%if diferenciar_empresas_seleccionada="SI" then%>
														<th class="menuhdr">Empresa</th>
													<%end if%>
													<%if diferenciar_sucursales_seleccionada="SI" then%>
														<th class="menuhdr">Codigo</th>
                                                        <th class="menuhdr">Cliente</th>
													<%end if%>
													<%if diferenciar_marca_seleccionada="SI" then%>
														<th class="menuhdr">Marca</th>
													<%end if%>
													<%if diferenciar_tipo_seleccionada="SI" then%>
														<th class="menuhdr">Tipo</th>
													<%end if%>
			
													<th class="menuhdr" style="text-align:center">Cantidad Total</th>
													<th class="menuhdr" style="text-align:center">Total Importe</th>
													<th class="menuhdr" style="text-align:center">Unidades Devueltas</th>
													<th class="menuhdr" style="text-align:center">Total Importe Dev.</th>
													<th class="menuhdr" style="text-align:center">Cantidad Neta</th>
													<th class="menuhdr" style="text-align:center">Total Importe Neto</th>
													<%if diferenciar_rappel_seleccionado="SI" then%>
														<th class="menuhdr" style="text-align:center">Rappel</th>
														<th class="menuhdr" style="text-align:center">Valor Rappel</th>
														<th class="menuhdr" style="text-align:center">C&aacute;lculo Rappel</th>
													<%end if%>
												</tr>
												
												<%vueltas=1
												  if not consumos.eof then %>
			                            			<%while not consumos.eof%>
													
														<tr  valign="top" id="fila_articulo_<%=i%>">
															<%
															vueltas=vueltas + 1
															if vueltas=200 then
																Response.Flush
																vueltas=1
															end if
															%>
															<td  class="al item_row" width="40"><%=consumos("CODIGO_SAP")%></td>
															<td  class="al item_row" width="124"><%=consumos("ARTICULO")%></td>
															<td  class="ac item_row" width="101"><%=consumos("UNIDADES_DE_PEDIDO")%></td>
															<%if diferenciar_costes_seleccionado="SI" then%>
																<td  class="ac item_row" width="82"><%=consumos("PRECIO_COSTE")%></td>
																<td  class="ac item_row" width="82"><%=consumos("PROVEEDOR")%></td>
																<td  class="ac item_row" width="82"><%=consumos("REFERENCIA_DEL_PROVEEDOR")%></td>
															<%end if%>
															<%if diferenciar_empresas_seleccionada="SI" then%>
																<td  class="ac item_row" width="82"><%=consumos("NOMBRE_EMPRESA")%></td>
															<%end if%>
															<%if diferenciar_sucursales_seleccionada="SI" then%>
                                                                <td  class="ac item_row" style="text-align:left; width:30px"><%=consumos("CodCliente")%></td>
																<td  class="ac item_row" style="text-align:left" width="76">
																	<%=consumos("NOMBRE")%>
																	<%if consumos("CODIGO_EXTERNO")<>"" then%>
																		&nbsp(<%=consumos("CODIGO_EXTERNO")%>)
																	<%end if%>
																</td>
															<%end if%>
															<%if diferenciar_marca_seleccionada="SI" then%>
																<td  class="ac item_row" width="101"><%=consumos("MARCA")%></td>
															<%end if%>
															<%if diferenciar_tipo_seleccionada="SI" then%>
																<td  class="ac item_row" width="101"><%=consumos("TIPO")%></td>
															<%end if%>
															<td  class="ar item_row" width="101">
																<%
																if consumos("CANTIDAD_TOTAL")<>"" then
																		Response.Write(FORMATNUMBER(consumos("CANTIDAD_TOTAL"),0,-1,0,-1))
																	else
																		Response.Write("0")
																end if
																%>
															</td>
															<td  class="ar item_row" width="101">
																<%
																if consumos("TOTAL_IMPORTE")<>"" then
																		Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE"),2,-1,0,-1) & "&nbsp;€")
																	else
																		Response.Write("0&nbsp;€")
																end if
																%>
															</td>
															<td  class="ar item_row" width="101">
																<%
																if consumos("UNIDADES_DEVUELTAS")<>"" then
																		Response.Write(FORMATNUMBER(consumos("UNIDADES_DEVUELTAS"),0,-1,0,-1))
																	else
																		Response.Write("0")
																end if
																%>
															</td>
															<td  class="ar item_row" width="101">
																<%
																if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
																		Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE_DEVOLUCIONES"),2,-1,0,-1) & "&nbsp;€")
																	else
																		Response.Write("0&nbsp;€")
																end if
																%>
															</td>
															<td  class="ar item_row" width="101">
																<%
																if consumos("UNIDADES_DEVUELTAS")<>"" then
																		Response.Write(FORMATNUMBER((consumos("CANTIDAD_TOTAL") - consumos("UNIDADES_DEVUELTAS")),0,-1,0,-1))
																	else
																		Response.Write(FORMATNUMBER(consumos("CANTIDAD_TOTAL"),0,-1,0,-1))
																end if
																%>
															</td>
															<td  class="ar item_row" width="101">
																<%
																if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
																		Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")),2,-1,0,-1) & "&nbsp;€")
																	else
																		Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE"),2,-1,0,-1) & "&nbsp;€")
																end if
																%>
															</td>
															<%if diferenciar_rappel_seleccionado="SI" then%>
																<td  class="ac item_row" width="82"><%=consumos("RAPPEL")%></td>
																<td  class="ac item_row" width="42"><%=consumos("VALOR_RAPPEL")%></td>
																<td  class="ar item_row" width="101">
																<%
																		valor_del_rappel="" & consumos("VALOR_RAPPEL")
																		if diferenciar_tipo_seleccionada="SI" then
																			if consumos("TOTAL_IMPORTE")<>"" and valor_del_rappel<>"" and (consumos("TIPO")="AGENCIA" OR consumos("TIPO")="ARRASTRES") then
																					'Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																					if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
																							Response.Write(FORMATNUMBER(((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")) * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																						else
																							Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																					end if
																				else
																					Response.Write("")
																			end if
																		  else
																			if consumos("TOTAL_IMPORTE")<>"" and valor_del_rappel<>"" then
																					'Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																					if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
																							Response.Write(FORMATNUMBER(((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")) * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																						else
																							Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;€")
																					end if
																				else
																					Response.Write("")
																			end if
																		end if
																		%>
																</td>
															<%end if%>
														</tr>
														
														<%consumos.movenext%>
													<%wend%>
													
												<%else%>
													<tr> 
														<td align="center" colspan="5"><b><FONT class="fontbold">NO Hay Consumos Que Cumplan El Critero de Búsqueda...</font></b><br>
														</td>
													</tr>
												<%end if%>
												
												
						
												
											</table>
											
										
										<%end if%>
											
											
								
									
								</div>
						
							
				  </form>
				</div>
		  <div class="submit_btn_container___" align="center">	
		  
					<table width="13%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td>
							<form id="frmpasar_excel" name="frmpasar_excel" method="post" action="Informe_Excel_new.asp" onsubmit="rellenar_nombre_articulo()">
								<input type="hidden" id="ocultosql" name="ocultosql" value="<%=cadena_consulta%>" />
								<input type="hidden" id="ocultoagrupacion" name="ocultoagrupacion" value="<%=agrupacion_seleccionada%>" />
								<input type="hidden" id="ocultoempresa" name="ocultoempresa" value="" />
								<input type="hidden" id="ocultoarticulo" name="ocultoarticulo" value="" />
								<input type="hidden" id="ocultoreservas_asm_gls" name="ocultoreservas_asm_gls" value="<%=reservas_asm_gls_seleccionada%>" />
								<input type="hidden" id="ocultofecha_inicio" name="ocultofecha_inicio" value="<%=fecha_i%>" />
								<input type="hidden" id="ocultofecha_fin" name="ocultofecha_fin" value="<%=fecha_f%>" />
								
								<input type="hidden" id="ocultodiferenciar_empresas" name="ocultodiferenciar_empresas" value="<%=diferenciar_empresas_seleccionada%>" />
								<input type="hidden" id="ocultodiferenciar_sucursales" name="ocultodiferenciar_sucursales" value="<%=diferenciar_sucursales_seleccionada%>" />
								<input type="hidden" id="ocultodiferenciar_articulos" name="ocultodiferenciar_articulos" value="<%=diferenciar_articulos_seleccionada%>" />
								<input type="hidden" id="ocultodiferenciar_rappel" name="ocultodiferenciar_rappel" value="<%=diferenciar_rappel_seleccionado%>" />
								<input type="hidden" id="ocultodiferenciar_costes" name="ocultodiferenciar_costes" value="<%=diferenciar_costes_seleccionado%>" />
								<input type="hidden" id="ocultodiferenciar_marca" name="ocultodiferenciar_marca" value="<%=diferenciar_marca_seleccionada%>" />
								<input type="hidden" id="ocultodiferenciar_tipo" name="ocultodiferenciar_tipo" value="<%=diferenciar_tipo_seleccionada%>" />
							


							
							
							
								<input class="submitbtn" type="submit" name="nuevo_articulo" id="nuevo_articulo" value="Exportar a Excel" />
								
								<script language="javascript">
									//lo pongo aqui en vez de junto al combo porque el ocultoempresa se crea
									//   despues y no me mantendria el valor
									//alert(document.getElementById("cmbempresas").options[document.getElementById("cmbempresas").selectedIndex].text)
									//alert(document.getElementById("cmbempresas").value)
									if (document.getElementById("cmbempresas").value!='')
										{
										document.getElementById("ocultoempresa").value=document.getElementById("cmbempresas").options[document.getElementById("cmbempresas").selectedIndex].text
										}
									else
										{
										document.getElementById("ocultoempresa").value=''
										}
										
									//alert('hola')
									/*
									if (document.getElementById("cmbarticulos").value!='')
										{
										document.getElementById("ocultoarticulo").value=document.getElementById("cmbarticulos").options[document.getElementById("cmbarticulos").selectedIndex].text
										}
									else
										{
										document.getElementById("ocultoarticulo").value=''
										}
										
										*/
								</script>
							</form>	
							</td>
						</tr>
					</table>
				
		  </div>

		
		
			
			

					
					
					
					
					
					
			
			
			
			
		</div>

	
	
	
	</td>
</tr>


</table>



















<script language="JavaScript">
		
			var cal1 = new calendar1(document.getElementById('txtfecha_inicio'));
			cal1.year_scroll = true;
			cal1.time_comp = false;
	
			var cal2 = new calendar1(document.getElementById('txtfecha_fin'));
			cal2.year_scroll = true;
			cal2.time_comp = false;
	
	</script>

</body>
<%
	consumos.close
	set consumos=Nothing
		
	connimprenta.close
	
	set connimprenta=Nothing

%>
</html>
