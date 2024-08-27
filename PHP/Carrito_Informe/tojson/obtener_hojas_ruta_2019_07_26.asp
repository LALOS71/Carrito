<%@ language=vbscript %>
<!--#include file="../Conexion_GAG_PRO.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	hoja_ruta_seleccionada = "" & request.QueryString("p_hoja_ruta")
	estado_seleccionado = "" & request.QueryString("p_estado")
	cliente_seleccionado = "" & request.QueryString("p_cliente")
	referencia_seleccionada = "" & request.QueryString("p_referencia")
	subcontratista_seleccionado = "" & request.QueryString("p_subcontratista")
	fecha_entrega_seleccionada = "" & request.QueryString("p_fecha_entrega")
	ejecutar_consulta = "" & request.QueryString("p_ejecutar")
	
		
	'cualquier insercion nueva de hojas de ruta en graphisoft, la añado a nuestro sistema con el estado de EMITIDO
	'y lo hago antes de cada consulta para que siempre vengan con el estado en la tabla		
	cadena_ejecucion="INSERT GESTION_GRAPHISOFT_HOJAS(HOJA_RUTA,ESTADO)"
	cadena_ejecucion=cadena_ejecucion & " SELECT A.HOJA_DE_RUTA, 'EMITIDO' FROM"
	cadena_ejecucion=cadena_ejecucion & " [MAYLLUGRAPH01\GRAPHISOFT2012].GRAPHIPLUS.dbo.V_GESTION_HOJAS_RUTA A"
	cadena_ejecucion=cadena_ejecucion & " LEFT JOIN GESTION_GRAPHISOFT_HOJAS B"
	cadena_ejecucion=cadena_ejecucion & " ON A.HOJA_DE_RUTA=B.HOJA_RUTA COLLATE Modern_Spanish_CS_AS"
	cadena_ejecucion=cadena_ejecucion & " WHERE B.HOJA_RUTA IS NULL"
	cadena_ejecucion=cadena_ejecucion & " AND A.HOJA_DE_RUTA>2019010000"
	
	conn_gag.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				
        	
	set hojas_ruta=Server.CreateObject("ADODB.Recordset")
		
	with hojas_ruta
		.ActiveConnection=conn_gag
		
		.Source="SELECT"
		'.Source= .Source & " PRESUPUESTISTA"
		.Source= .Source & " A.HOJA_DE_RUTA"
		.Source= .Source & ",B.ESTADO"
		'.Source= .Source & ", FECHA_EMISION"
		'.Source= .Source & ", PRODUCTO"
		.Source= .Source & ", A.CLIENTE_NOMBRE"
		.Source= .Source & ", REPLACE(A.REFERENCIA, '""', '\""') REFERENCIA"
		'.Source= .Source & ", CANTIDAD"
		.Source= .Source & ", A.SUBCONTRATISTA"
		.Source= .Source & ", A.FECHA_ENTREGA"
		.Source= .Source & " FROM [MAYLLUGRAPH01\GRAPHISOFT2012].GRAPHIPLUS.dbo.V_GESTION_HOJAS_RUTA A"	
		.Source= .Source & " LEFT JOIN GESTION_GRAPHISOFT_HOJAS B"
		.Source= .Source & " ON A.HOJA_DE_RUTA=B.HOJA_RUTA COLLATE Modern_Spanish_CS_AS"
		
				
		.Source= .Source & " WHERE 1=1"
		if hoja_ruta_seleccionada<>"" then
			.Source= .Source & " AND UPPER(A.HOJA_DE_RUTA)=" & hoja_ruta_seleccionada 
		end if
		if estado_seleccionado<>"" then
			.Source= .Source & " AND UPPER(B.ESTADO)='" & UCASE(estado_seleccionado) &"'"
		end if
		if cliente_seleccionado<>"" then
			.Source= .Source & " AND UPPER(A.CLIENTE_NOMBRE) LIKE '%" & UCASE(cliente_seleccionado) & "%'"
		end if
		if referencia_seleccionada<>"" then
			.Source= .Source & " AND UPPER(A.REFERENCIA) LIKE '%" & UCASE(referencia_seleccionada) & "%'"
		end if
		if subcontratista_seleccionado<>"" then
			.Source= .Source & " AND UPPER(A.SUBCONTRATISTA) LIKE '%" & UCASE(subcontratista_seleccionado) & "%'"
		end if
		if fecha_entrega_seleccionada<>"" then
			.Source= .Source & " AND CONVERT(VARCHAR, A.FECHA_ENTREGA, 103)=CONVERT(VARCHAR, '" & cdate(fecha_entrega_seleccionada) & "', 103)"
		end if
			
			
		'para que no muestre toda la lista de articulos si no se selecciona nada
		'if empresa_seleccionada="" and codigo_sap_seleccionado="" and descripcion_seleccionada="" and campo_eliminado="NO" and campo_autorizacion="" then
		if ejecutar_consulta<>"SI" then
			.Source= .Source & " AND A.HOJA_DE_RUTA=0"
		end if
			
			
		.Source= .Source & " ORDER BY A.HOJA_DE_RUTA DESC"
			
		'RESPONSE.WRITE("<BR>" & .Source)
		.Open
	end with

	Response.ContentType = "application/json"
	Response.Write "{" & JSONData(hojas_ruta, "ROWSET") & "}"

	'articulos.close
	set hojas_ruta=Nothing
	
	conn_gag.close
	set conn_gag=Nothing
%>



