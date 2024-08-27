<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	
	'pir = "" & request.QueryString("p_pir")
	
	codigos_articulos = "" & Request.Form("p_articulos")
	codcli = "" & Request.Form("p_codcli")
	usuario_dir_activo = "" & Request.Form("p_usuario_dir_activo")
	
	
	'response.write("<br>codcli: " + Request.Form("p_codcli"))
	if usuario_dir_activo = "" then
		usuario_dir_activo = "NULL"
	end if
	
	
	ver_cadena= "" & request.QueryString("p_vercadena")
		
	
	'response.write("<br>pirs: " & codigos_pir)
	'response.write("<br>importe facturacion: " & importe_facturacion)
	'response.write("<br>fecha_facturacion: " & fecha_facturacion)
	'response.write("<br>tipo establecimiento: " & tipo_establecimiento_seleccionado)
	'response.write("<br>nombre establecimiento: " & nombre_establecimiento)
		
		
		
		if ver_cadena="SI" then
			response.write("<br>" & cadena_sql & "<br><br>")
		end if
		
		
		'pedidos=Split(codigos_pedidos, "#")
		'articulos= replace(codigos_articulos, "#", ",")
		articulos=codigos_articulos
		articulos= left(articulos, len(articulos)-1)
		articulos= right(articulos, len(articulos)-1)
		'response.write("<br>----lista de articulos-cantidades: ...." & articulos & "...")
		
		a=split(articulos, "#")
		
		
		
		
		connimprenta.BeginTrans 'Comenzamos la Transaccion
		
			'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
			' de fecha con mes-dia-año
			connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
			
			
			cadena_sql="INSERT INTO DEVOLUCIONES (CODCLI, FECHA, ESTADO, USUARIO_DIRECTORIO_ACTIVO)"
			cadena_sql= cadena_sql & " VALUES (" & codcli & ", getdate(), 'SIN TRATAR', "  & usuario_dir_activo & ")"
			
			'response.write("------CADENA DEVOLUCION: " & cadena_sql)
			connimprenta.Execute cadena_sql,,adCmdText + adExecuteNoRecords
			
			
			Set valor_nuevo = connimprenta.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
			nueva_devolucion=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
			valor_nuevo.Close
			Set valor_nuevo = Nothing
			
			
			for each x in a
				articulo_cantidad_total=split(x, "$$$")
				'response.write("<br>---articulo: " & articulo_cantidad_total(0) & " ... nueva cantidad: " & articulo_cantidad_total(1))
				
				cadena_sql="INSERT INTO DEVOLUCIONES_DETALLES (ID_DEVOLUCION, ESTADO, ID_PEDIDO, ID_ARTICULO, CANTIDAD, TOTAL, ALBARAN, IDALBARANDETALLES)"
		
				cadena_sql= cadena_sql & " SELECT " & nueva_devolucion & ", 'SIN TRATAR', B.NPEDIDO, C.ID"
				cadena_sql= cadena_sql & ", " & articulo_cantidad_total(1) & ", ROUND((A.IMPORTE / A.CANTIDAD) * " & articulo_cantidad_total(1) & ", 2) AS TOTAL_NEW"
				cadena_sql= cadena_sql & ", A.IDALBARAN, A.IDALBARANDETALLES"
				cadena_sql= cadena_sql & " FROM V_DATOS_ALBARANES_DETALLES A"
				cadena_sql= cadena_sql & " INNER JOIN V_DATOS_ALBARANES B"
				cadena_sql= cadena_sql & " ON A.IDALBARAN=B.IDALBARAN"
				cadena_sql= cadena_sql & " INNER JOIN ARTICULOS C"	
				cadena_sql= cadena_sql & " ON C.CODIGO_SAP = RTRIM(LEFT(A.CONCEPTO, CHARINDEX('    ', A.CONCEPTO)))"       
				cadena_sql= cadena_sql & " WHERE A.IDALBARANDETALLES = " & articulo_cantidad_total(0)
				
						
				'response.write("<br>...cadena sql DETALLE DEVOLUCION: " & cadena_sql)
				connimprenta.Execute cadena_sql,,adCmdText + adExecuteNoRecords

				
				
			next
			
					
		
		connimprenta.CommitTrans ' finaliza la transaccion
		
			'end if
			'.Source= .Source & " ORDER BY DESCRIPCION"
			'response.write("<br>" & cadena_sql)
			
	


	
	connimprenta.close
	set connimprenta=Nothing
	
	response.write("DEVOLUCION###" & nueva_devolucion)
%>



