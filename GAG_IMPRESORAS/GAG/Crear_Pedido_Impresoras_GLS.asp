<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%


		sucursal_pedido = "" & Request.Form("oficina")
		cantidad_pedida = "" & Request.Form("cantidad")
		
		tipo_precio=""
		codigo_empresa=""
		precio_coste=""


		connimprenta.BeginTrans

		sql = "INSERT INTO PEDIDOS (CODCLI, FECHA, ESTADO, PEDIDO_AUTOMATICO)"
		sql = sql & " VALUES (" & sucursal_pedido  & ", GETDATE(), 'PENDIENTE FIRMA', 'IMPRESORA_GLS_ADMIN')"

		connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
		
		Set valor_nuevo = connimprenta.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
		numero_pedido=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
		valor_nuevo.Close
		Set valor_nuevo = Nothing
		
		
		'ahora obtenemos el precio del articulo en funcion del tipo de cliente y empresa
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
		
		'EL ARTICULO EN ESTE CASO ES LA IMPRESORA GLS, 4583
		codigo_articulo_pedido=4583
		
		
		'obtenemos el precio coste y el precio del articulo que se va a pedir, en este caso la impresora 4583
		set cantidades_precios=Server.CreateObject("ADODB.Recordset")
							
		sql="SELECT A.*, B.PRECIO_COSTE FROM CANTIDADES_PRECIOS A"
		sql=sql & " LEFT JOIN ARTICULOS B ON B.ID=A.CODIGO_ARTICULO"
		sql=sql & " WHERE A.CODIGO_ARTICULO=" & codigo_articulo_pedido
		sql=sql & " AND A.TIPO_SUCURSAL='" & tipo_precio & "'"
		sql=sql & " AND A.CODIGO_EMPRESA=" & codigo_empresa
		sql=sql & " ORDER BY A.CANTIDAD"
		'response.write("<br>" & sql)
																
		with cantidades_precios
			.ActiveConnection=connimprenta
			.CursorType=3 'adOpenStatic
			.Source=sql
			.Open
		end with
		
		precio_buscado=""
		if not cantidades_precios.eof then
			precio_buscado="" & cantidades_precios("precio_unidad")
			precio_coste="" & cantidades_precios("precio_coste")
		end if
		cantidades_precios.close
		set cantidades_precios=Nothing
		
		cadena_campos="ID_PEDIDO, ARTICULO, CANTIDAD, PRECIO_UNIDAD, TOTAL, ESTADO, PRECIO_COSTE"
		
		cadena_valores = numero_pedido & ", " & codigo_articulo_pedido & ", " & cantidad_pedida & ", " 
		if precio_buscado = "" or precio_buscado = "0" then
			cadena_valores = cadena_valores & "0, 0, 'PENDIENTE_FIRMA'"
		  else
		  	cadena_valores = cadena_valores & replace(precio_buscado,",",".") & ", " & replace((cantidad_pedida * precio_buscado), ",", ".") & ", 'PENDIENTE_FIRMA'"
		end if
		if precio_coste ="" then
			cadena_valores = cadena_valores & ", NULL"
		  else
			cadena_valores = cadena_valores & ", " & replace(precio_coste,",",".")
		end if
		
		
		cadena_ejecucion="Insert into PEDIDOS_DETALLES (" & cadena_campos & ") values(" & cadena_valores & ")"
		'response.Write("<br>" & cadena_ejecucion)
		
		connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords

		cadena_respuesta = "{""mensaje"": ""mensaje"", ""contenido"": ""Pedido Creado con Éxito""}"
		connimprenta.CommitTrans


		
		Response.ContentType = "application/json; charset=UTF-8"
		Response.Write(cadena_respuesta)
	connimprenta.close
	set connimprenta=Nothing



%>