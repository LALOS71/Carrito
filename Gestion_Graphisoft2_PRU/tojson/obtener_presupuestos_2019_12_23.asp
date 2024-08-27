<!--#include file="../DB_Manager.inc"-->
<!--#include file="jsonobject/jsonObject.class.inc"-->
<%
    Dim sql
    Dim query_options

    Set JSON = New JSONobject

    Response.LCID = 1034 ' REQUIRED! Set your LCID here (1046 = Brazilian). Could also be the LCID property of the page declaration or the Session.LCID property
    'Response.CharSet = "iso-8859-1"
    Response.ContentType = "application/json"
    
    presupuesto_seleccionado    = "" & request.QueryString("p_presupuesto")
    estados_seleccionados		= "" & request.QueryString("p_estado")
    cliente_seleccionado 		= "" & request.QueryString("p_cliente")
    version_seleccionada 		= "" & request.QueryString("p_version")
    presupuestista_seleccionado = "" & request.QueryString("p_presupuestista")
    fecha_creacion_desde_seleccionada = "" & request.QueryString("p_fecha_creacion_desde")
    fecha_creacion_hasta_seleccionada = "" & request.QueryString("p_fecha_creacion_hasta")
	tipo_cliente_seleccionado = "" & request.QueryString("p_tipo_cliente")
    ejecutar_consulta 			= "" & request.QueryString("p_ejecutar")
	
	ver_cadena 					= "" & request.QueryString("p_vercadena")
	
	if ver_cadena="SI" then
		response.write("<br>presupuesto_seleccionado: " & request.QueryString("p_presupuesto"))    
		response.write("<br>estados_seleccionados: " & request.QueryString("p_estado"))
		response.write("<br>cliente_seleccionado: " & request.QueryString("p_cliente")) 		
		response.write("<br>version_seleccionada: " & request.QueryString("p_version")) 		
		response.write("<br>presupuestista_seleccionado: " & request.QueryString("p_presupuestista")) 
		response.write("<br>fecha_creacion_desde_seleccionada: " & request.QueryString("p_fecha_creacion_desde")) 
		response.write("<br>fecha_creacion_hasta_seleccionada: " & request.QueryString("p_fecha_creacion_hasta")) 
		response.write("<br>tipo_cliente_seleccionado: " & request.QueryString("p_tipo_cliente")) 
		response.write("<br>ejecutar_consulta: " & request.QueryString("p_ejecutar")) 			
	end if

    'sql = "SELECT ID_PRESUPUESTO, ID_ESTADO, CONCAT(PRESUPUESTO, '/', VERSION) AS PRESUPUESTO_VERSION, B.DESCRIPCION AS ESTADO, CLIENTE, PRESUPUESTISTA, FECHA_CREACION, CANTIDAD, IMPORTE, A.DESCRIPCION AS DESCRIPCION FROM GESTION_GRAPHISOFT_PRESUPUESTOS A INNER JOIN GESTION_GRAPHISOFT_ESTADOS_PRESUPUESTOS B ON A.ID_ESTADO=B.ID WHERE 1=1"
	'sql = "SELECT ID_PRESUPUESTO, ID_ESTADO, ISNULL(CAST(PRESUPUESTO AS varchar(MAX)), '') + '/' + ISNULL(CAST(VERSION AS varchar(MAX)), '') AS PRESUPUESTO_VERSION, B.DESCRIPCION AS ESTADO, CLIENTE, PRESUPUESTISTA, FECHA_CREACION, CANTIDAD, IMPORTE, A.DESCRIPCION AS DESCRIPCION FROM GESTION_GRAPHISOFT_PRESUPUESTOS A INNER JOIN GESTION_GRAPHISOFT_ESTADOS_PRESUPUESTOS B ON A.ID_ESTADO=B.ID WHERE 1=1"
	
	sql_conjunto = "(SELECT ID_PRESUPUESTO, A.ID_ESTADO, ISNULL(CAST(PRESUPUESTO AS varchar(MAX)), '') + '/' + ISNULL(CAST(VERSION AS varchar(MAX)), '') AS PRESUPUESTO_VERSION"
	sql_conjunto = sql_conjunto & ", PRESUPUESTO, VERSION, B.DESCRIPCION AS ESTADO, A.ID_CLIENTE, D.CATEGORIA, D.NOMBRE AS CLIENTE, PRESUPUESTISTA, FECHA_CREACION, CANTIDAD, IMPORTE, A.DESCRIPCION AS DESCRIPCION"
	sql_conjunto = sql_conjunto & ", A.ID_SUBESTADO, C.DESCRIPCION AS SUBESTADO"
	sql_conjunto = sql_conjunto & ", ROW_NUMBER() OVER (PARTITION BY PRESUPUESTO ORDER BY PRESUPUESTO, VERSION DESC) AS RowNum"

	sql_conjunto = sql_conjunto & " FROM GESTION_GRAPHISOFT_PRESUPUESTOS A INNER JOIN GESTION_GRAPHISOFT_ESTADOS_PRESUPUESTOS B ON A.ID_ESTADO=B.ID"
	sql_conjunto = sql_conjunto & " LEFT JOIN GESTION_GRAPHISOFT_SUBESTADOS_PRESUPUESTOS C ON A.ID_SUBESTADO=C.ID"
	sql_conjunto = sql_conjunto & " LEFT JOIN GESTION_GRAPHISOFT_CLIENTES D ON A.ID_CLIENTE=D.ID)"
	
	sql = " SELECT * FROM " & sql_conjunto & " AS F WHERE 1=1"

    If presupuesto_seleccionado <> "" Then
        sql = sql & " AND F.PRESUPUESTO = " & presupuesto_seleccionado 
    End If
    If estados_seleccionados <> "" Then
        sql = sql & " AND F.ID_ESTADO IN (" & estados_seleccionados & ")"
    End If
    If cliente_seleccionado <> "" Then
        sql = sql & " AND F.ID_CLIENTE=" & cliente_seleccionado
    End If
    If version_seleccionada <> "" Then
		if version_seleccionada = "ultima" then
	        sql = sql & " AND F.RowNum <= 1"
		else
	        sql = sql & " AND F.VERSION = " & version_seleccionada
		end if
    End If
    If presupuestista_seleccionado <> "" Then
        sql = sql & " AND UPPER(F.PRESUPUESTISTA) LIKE '%" & UCASE(presupuestista_seleccionado) & "%'"
    End If
    If fecha_creacion_desde_seleccionada <> "" Then
        'sql = sql & " AND CONVERT(VARCHAR, F.FECHA_CREACION, 103) >= CONVERT(VARCHAR, '" & cdate(fecha_creacion_desde_seleccionada) & "', 103)"
		sql = sql & " AND F.FECHA_CREACION >= '" & cdate(fecha_creacion_desde_seleccionada) & "'"
    End If

    If fecha_creacion_hasta_seleccionada <> "" Then
        'sql = sql & " AND CONVERT(VARCHAR, F.FECHA_CREACION, 103) <= CONVERT(VARCHAR, '" & cdate(fecha_creacion_hasta_seleccionada) & "', 103)"
		sql = sql & " AND F.FECHA_CREACION <= '" & cdate(fecha_creacion_hasta_seleccionada) & "'"
    End If
	
	If tipo_cliente_seleccionado = "GRUPO" Then
        sql = sql & " AND F.CATEGORIA=0"
    End If
	
	If tipo_cliente_seleccionado = "EXTERNO" Then
        sql = sql & " AND F.CATEGORIA IS NULL"
    End If

    sql = sql & " ORDER BY PRESUPUESTO DESC"
	
	If ver_cadena="SI" 	Then
		RESPONSE.WRITE("<BR>" & sql)
	End If


	'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
	' de fecha con mes-dia-a?o
	query_options = adCmdText + adExecuteNoRecords
	execute_sql_with_options conn_gag, "set dateformat dmy", query_options
	
	'execute_sql_with_options conn_gag, sql_conjunto, query_options

    Set presupuestos = execute_sql(conn_gag, sql)	
    
    
    JSON.defaultPropertyName = "ROWSET"	
    JSON.LoadRecordset presupuestos
    
    'articulos.close
    close_connection(presupuestos)
    close_connection(conn_gag)
    
    JSON.Write()
    
%>