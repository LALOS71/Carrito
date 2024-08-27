<%@ language=vbscript CodePage = 65001%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />

<!--#include file="Conexion.inc"-->
<!--'https://github.com/rcdmk/aspJSON-->
<!--#include file=".\Plugins\aspJSON_2\aspJSON1.19.asp" -->

<!--#include file=".\Plugins\FPDF\fpdf.asp" --> 
<%
		Response.ContentType = "text/html"
		Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
		'Response.CodePage = 65001
		'Response.CharSet = "UTF-8"
		Response.CharSet = "ISO-8859-1"
		Response.CodePage = 28591
		

		pedido_seleccionado=Request.Form("ocultopedido_proveedor")
		destino=Request.Form("ocultodestino_proveedor")
		
		if Request.QueryString("p_ped") <> "" then
			pedido_seleccionado = Request.QueryString("p_ped")
		end if
		
		envio_correo="SI"
		if Request.QueryString("p_email") = "NO" then
			envio_correo = "NO"
		end if
		


		dim fso
		set fso=Server.CreateObject("Scripting.FileSystemObject")
		


		mensaje=""
		mensaje_detalles=""
		total_pedido_proveedor=0
		set pedido_al_proveedor=Server.CreateObject("ADODB.Recordset")
		
		cadena_pedido_proveedor="SELECT A.PEDIDO_AUTOMATICO, A.ID AS PEDIDO, A.CODCLI, A.ESTADO, A.FECHA"
		cadena_pedido_proveedor=cadena_pedido_proveedor & ", B.NOMBRE AS DESTINATARIO, B.DIRECCION, B.CP, B.POBLACION, B.CP, B.PROVINCIA, B.TELEFONO, B.EMAIL"
		cadena_pedido_proveedor=cadena_pedido_proveedor & ", A.DESTINATARIO AS DESTINATARIO_ENV"
		cadena_pedido_proveedor=cadena_pedido_proveedor & ", A.DESTINATARIO_DIRECCION AS DIRECCION_ENV"
		cadena_pedido_proveedor=cadena_pedido_proveedor & ", A.DESTINATARIO_POBLACION AS POBLACION_ENV"
		cadena_pedido_proveedor=cadena_pedido_proveedor & ", A.DESTINATARIO_PROVINCIA AS PROVINCIA_ENV"
		cadena_pedido_proveedor=cadena_pedido_proveedor & ", A.DESTINATARIO_CP AS CP_ENV"
		cadena_pedido_proveedor=cadena_pedido_proveedor & ", A.DESTINATARIO_PAIS AS PAIS_ENV"
		cadena_pedido_proveedor=cadena_pedido_proveedor & ", A.DESTINATARIO_TELEFONO AS TELEFONO_ENV"
		cadena_pedido_proveedor=cadena_pedido_proveedor & ", A.DESTINATARIO_PERSONA_CONTACTO AS PERSONA_CONTACTO_ENV"
		
		'cadena_pedido_proveedor=cadena_pedido_proveedor & ", '---',*"
		cadena_pedido_proveedor=cadena_pedido_proveedor & " FROM PEDIDOS A LEFT JOIN V_CLIENTES B ON A.CODCLI=B.ID"
		cadena_pedido_proveedor=cadena_pedido_proveedor & " WHERE A.ID=" & pedido_seleccionado
		'cadena_pedido_proveedor=cadena_pedido_proveedor & " AND A.ESTADO='ENVIADO'"
		cadena_pedido_proveedor=cadena_pedido_proveedor & " AND A.ESTADO='ENVIADO AL PROVEEDOR'"
		cadena_pedido_proveedor=cadena_pedido_proveedor & " AND A.PEDIDO_AUTOMATICO='ROTULACION'"
		
		with pedido_al_proveedor
			.ActiveConnection=connimprenta
			.Source= cadena_pedido_proveedor
			'response.write("<br>1 - consulta generar pedido al proveedor: " & .source)
			.Open
		end with
				
		if not pedido_al_proveedor.eof then
		
			'obtenemos los detalles del pedido
			set detalles_pedido_proveedor=Server.CreateObject("ADODB.Recordset")
			cadena_detalles_pedido_proveedor = "SELECT B.ID, B.CODIGO_SAP, B.REFERENCIA_DEL_PROVEEDOR, B.DESCRIPCION, A.CANTIDAD, B.PRECIO_COSTE"
			cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & ", CAST(ROUND((A.CANTIDAD * B.PRECIO_COSTE),2) AS NUMERIC(36,2)) AS TOTAL"
			cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & ", C.PLANTILLA_PERSONALIZACION"
			cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & " FROM PEDIDOS_DETALLES A LEFT JOIN ARTICULOS B ON A.ARTICULO=B.ID"
			cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & " LEFT JOIN ARTICULOS_PERSONALIZADOS C ON A.ARTICULO=C.ID_ARTICULO"
			cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & " WHERE A.ID_PEDIDO=" & pedido_seleccionado
			cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & " AND A.ESTADO='ENVIADO AL PROVEEDOR'"
			'cadena_detalles_pedido_proveedor = cadena_detalles_pedido_proveedor & " AND A.ALBARAN IS NULL"
				
			
			with detalles_pedido_proveedor
				.ActiveConnection=connimprenta
				.Source= cadena_detalles_pedido_proveedor
				'response.write("<br>2 - consulta generar pedido al proveedor -- detalles: " & .source)
				.Open
			end with
			
			
			''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			'generamos el pdf
			
			'paginas de ayuda del objeto FPDF
			'FPDF.ORG
			'https://web.archive.org/web/20100510144947/http://www.aspxnet.it/public/Default.asp?page=175&idp=21
			'https://sites.google.com/site/aspfpdf/tutorials
			
			'curso completo de uso
			'https://www.youtube.com/playlist?list=PLYAyQauAPx8mv6I7SG-4sNGVngclrO6WQ
			
			'videos para modificar texto que no entre en una celda (wrapping)
			'https://www.youtube.com/watch?v=utjJe90MeEw
			'https://www.youtube.com/watch?v=pELrw9P5ywM
			
			'https://www.youtube.com/watch?v=Vum46ssYIus&list=PLzz7R3Slbh5TjvEM9P7cfTA_clpXX1Rs7
			
			
			'response.write("<br>3 - generamos el pdf...")
			'creamos el pdf a adjuntar
			Set pdf = CreateJsObject("FPDF")
			pdf.CreatePDF()
			
			pdf.SetPath("./Plugins/FPDF/FPDF/") 
			
			'pdf.SetTitle "The title"
			pdf.SetAuthor "Globalia Artes Gráficas"
			'pdf.SetSubject "The subject"
			'pdf.SetKeywords "The list of keywords"
			pdf.SetCreator "Globalia Artes Gráficas"

			pdf.SetFont "Arial","B",16
			pdf.Open() 
			
			
			
			'ejemplo de tabla
			pdf.AddPage("L")
			
			pdf.Cell 50,10, "Pedido: " & pedido_al_proveedor("PEDIDO"), 1, 0, "C"
			pdf.Cell(165)
			pdf.Cell 60,10, "Fecha: " & pedido_al_proveedor("FECHA"),1, 1,"C"
			
			fecha_pedido=pedido_al_proveedor("FECHA")
			usuario_pedido=pedido_al_proveedor("CODCLI")

			fontsize_estandar=12
			fontsizetemporal=fontsize_estandar

			'pdf.SetFont "Arial","B",8
			pdf.Ln()
			
			''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			'aqui comprobamos si la direccion de envio es diferente a la del cliente
			' para postrar solo los datos del cliente o los datos del cliente y tambien la direccion de envio
			if pedido_al_proveedor("DESTINATARIO_ENV")<>"" then
				
				'Colores, ancho de línea y fuente en negrita
				pdf.SetFillColor 178,178,178
				pdf.SetTextColor 255
				pdf.SetDrawColor 178,178,178
				pdf.SetLineWidth .3
				pdf.SetFont "Arial","B",12
	
				
				pdf.Cell 138, 7 , "CLIENTE",1,0,"C",true
				pdf.Cell 138, 7 , "DIRECCION DE ENVIO",1,0,"C",true
				pdf.Ln()
				
				'Restauración de colores y fuentes
				pdf.SetFillColor 224,235,255
				pdf.SetTextColor 0
				pdf.SetFont ""
				pdf.SetFont "Arial","",12
				
				'Datos
				fill = false
				
				
				anchuracelda=138
				alturacelda = 6
				
				cadena_pdf_cliente= "Cliente: " & UCASE(pedido_al_proveedor("DESTINATARIO")) & " (" & UCASE(pedido_al_proveedor("CODCLI")) & ")"
				cadena_pdf_destinatario= "Destinatario: " & UCASE(pedido_al_proveedor("DESTINATARIO_ENV"))
				
				'vemos si hay que partir el texto para que ocupe varias lineas en la celda
				lineas_texto = calcular_lineas_de_texto(cadena_pdf_destinatario, anchuracelda)
				altura_total_celda = lineas_texto * alturacelda
				
				'redimensionamos el tamaño de la fuente para que el texto se adapte al ancho de la celda
				fontsizetemporal=fontsize_estandar
				while (pdf.GetStringWidth(cadena_pdf_cliente) > (anchuracelda - 2))
					fontsizetemporal = fontsizetemporal - 0.1
					pdf.SetFontSize(fontsizetemporal)
				wend

				pdf.Cell anchuracelda, altura_total_celda, cadena_pdf_cliente , "LR", 0,"L", false
				'pdf.Cell anchuras(1),altura_celda_final, posicionxy,"LR",0,"L",fill
				fontsizetemporal=fontsize_estandar
				pdf.SetFontSize(fontsizetemporal)
				
				
				posicionx = pdf.GetX()
				posiciony = pdf.GetY()
				pdf.MultiCell anchuracelda, alturacelda, cadena_pdf_destinatario, "LR", 0,"L", false
				'pdf.Cell anchuracelda, alturacelda, cadena_pdf , "LR", 0,"L", false
				pdf.SetXY (posicionx + anchuracelda), (posiciony + altura_total_celda)
				pdf.Cell(0)
				pdf.Ln()
				
				cadena_pdf_direccion= "Dirección: " & UCASE(pedido_al_proveedor("DIRECCION"))
				cadena_pdf_direccion_env= "Dirección: " & UCASE(pedido_al_proveedor("DIRECCION_ENV"))
				lineas_texto = calcular_lineas_de_texto(cadena_pdf_direccion_env, anchuracelda)
				altura_total_celda = lineas_texto * alturacelda
				
				fontsizetemporal=fontsize_estandar
				while (pdf.GetStringWidth(cadena_pdf_direccion) > (anchuracelda - 2))
					fontsizetemporal = fontsizetemporal - 0.1
					pdf.SetFontSize(fontsizetemporal)
				wend

				pdf.Cell anchuracelda, altura_total_celda, cadena_pdf_direccion, "LR", 0,"L", false
				'pdf.Cell anchuras(1),altura_celda_final, posicionxy,"LR",0,"L",fill
				fontsizetemporal=fontsize_estandar
				pdf.SetFontSize(fontsizetemporal)
				
				
				posicionx = pdf.GetX()
				posiciony = pdf.GetY()
				pdf.MultiCell anchuracelda, alturacelda, cadena_pdf_direccion_env, "LR", 0,"L", false
				'pdf.Cell anchuracelda, alturacelda, cadena_pdf , "LR", 0,"L", false
				pdf.SetXY (posicionx + anchuracelda), (posiciony + altura_total_celda)
				pdf.Cell(0)
				pdf.Ln()
				
				cadena_pdf_poblacion= "Población: " & UCASE(pedido_al_proveedor("POBLACION"))
				cadena_pdf_poblacion_env= "Localidad: " & UCASE(pedido_al_proveedor("POBLACION_ENV"))
				
				fontsizetemporal=fontsize_estandar
				while (pdf.GetStringWidth(cadena_pdf_poblacion) > (anchuracelda - 2))
					fontsizetemporal = fontsizetemporal - 0.1
					pdf.SetFontSize(fontsizetemporal)
				wend

				pdf.Cell anchuracelda, alturacelda, cadena_pdf_poblacion , "LR", 0,"L", false
				fontsizetemporal=fontsize_estandar
				pdf.SetFontSize(fontsizetemporal)
				
				fontsizetemporal=fontsize_estandar
				while (pdf.GetStringWidth(cadena_pdf_poblacion_env) > (anchuracelda - 2))
					fontsizetemporal = fontsizetemporal - 0.1
					pdf.SetFontSize(fontsizetemporal)
				wend

				pdf.Cell anchuracelda, alturacelda, cadena_pdf_poblacion_env , "LR", 0,"L", false
				'pdf.Cell anchuras(1),altura_celda_final, posicionxy,"LR",0,"L",fill
				fontsizetemporal=fontsize_estandar
				pdf.SetFontSize(fontsizetemporal)
				pdf.Ln()
				
				cadena_pdf= "C. P.: " & UCASE(pedido_al_proveedor("CP"))
				pdf.Cell anchuracelda, alturacelda, cadena_pdf , "LR", 0,"L", false
				cadena_pdf= "C. P.: " & UCASE(pedido_al_proveedor("CP_ENV"))
				pdf.Cell anchuracelda, alturacelda, cadena_pdf , "LR", 0,"L", false
				pdf.Ln()
				
				cadena_pdf= "Provincia: " & UCASE(pedido_al_proveedor("PROVINCIA"))
				pdf.Cell anchuracelda, alturacelda, cadena_pdf , "LR", 0,"L", false
				cadena_pdf= "Provincia: " & UCASE(pedido_al_proveedor("PROVINCIA_ENV"))
				pdf.Cell anchuracelda, alturacelda, cadena_pdf , "LR", 0,"L", false
				pdf.Ln()
				
				cadena_pdf= "Teléfono: " & UCASE(pedido_al_proveedor("TELEFONO"))
				pdf.Cell anchuracelda, alturacelda, cadena_pdf , "LR", 0,"L", false
				cadena_pdf= "País: " & UCASE(pedido_al_proveedor("PAIS_ENV"))
				pdf.Cell anchuracelda, alturacelda, cadena_pdf , "LR", 0,"L", false
				pdf.Ln()
				
				cadena_pdf_email= "Email: " & LCASE(pedido_al_proveedor("EMAIL"))
				
				fontsizetemporal=fontsize_estandar
				while (pdf.GetStringWidth(cadena_pdf_email) > (anchuracelda - 2))
					fontsizetemporal = fontsizetemporal - 0.1
					pdf.SetFontSize(fontsizetemporal)
				wend

				pdf.Cell anchuracelda, alturacelda, cadena_pdf_email , "LR", 0,"L", false
				'pdf.Cell anchuras(1),altura_celda_final, posicionxy,"LR",0,"L",fill
				fontsizetemporal=fontsize_estandar
				pdf.SetFontSize(fontsizetemporal)
				
				cadena_pdf= "Teléfono: " & LCASE(pedido_al_proveedor("TELEFONO_ENV"))
				pdf.Cell anchuracelda, alturacelda, cadena_pdf , "LR", 0,"L", false
				pdf.Ln()
				
				cadena_pdf= ""
				pdf.Cell anchuracelda, alturacelda, cadena_pdf , "LR", 0,"L", false
				cadena_pdf= "Persona de Contacto: " & LCASE(pedido_al_proveedor("PERSONA_CONTACTO_ENV"))
				pdf.Cell anchuracelda, alturacelda, cadena_pdf , "LR", 0,"L", false
				pdf.Ln()
				
				pdf.Cell (anchuracelda*2),0,"","T"
				pdf.Ln()
				
				'cadena_pdf= ""
				'pdf.Cell anchuracelda, alturacelda, "", "", 0,"L", false
				'cadena_pdf= "Persona de Contacto: " & LCASE(pedido_al_proveedor("PERSONA_CONTACTO_ENV"))
				'pdf.Cell anchuracelda, alturacelda, "" , "", 0,"L", false
				pdf.Cell anchuracelda, alturacelda, "" , "", 0,"L", false
				pdf.Ln()
				
				

			else 'solo se ponen los datos del cliente
							
				'pdf.Ln()
				pdf.Cell(5)
				pdf.SetFont "Arial","",14
				'pdf.SetFont "Arial","",12
				pdf.Cell 150, 6, "Cliente: " & UCASE(pedido_al_proveedor("DESTINATARIO")) & " (" & UCASE(pedido_al_proveedor("CODCLI")) & ")", 0, 1, "L"
				pdf.Cell(5)
				'pdf.SetFont "Arial","B",14
				pdf.Cell 150, 6, "Dirección: " & UCASE(pedido_al_proveedor("DIRECCION")),  0, 1, "L"
				pdf.Cell(5)
				pdf.Cell 150, 6, "Población: " & UCASE(pedido_al_proveedor("POBLACION")), 0, 1, "L"
				pdf.Cell(5)
				pdf.Cell 150, 6, "C. P.: " & UCASE(pedido_al_proveedor("CP")), 0, 1, "L"
				pdf.Cell(5)
				pdf.Cell 150, 6, "Provincia: " & UCASE(pedido_al_proveedor("PROVINCIA")), 0, 1, "L"
				pdf.Cell(5)
				pdf.Cell 150, 6, "Teléfono: " & UCASE(pedido_al_proveedor("TELEFONO")), 0, 1, "L"
				pdf.Cell(5)
				pdf.Cell 150, 6, "Email: " & LCASE(pedido_al_proveedor("EMAIL")), 0, 1, "L"
				pdf.Ln()
				pdf.Ln()
			end if			
			
			
			'pdf.Ln()

			fontsizetemporal=fontsize_estandar
			pdf.SetFontSize(fontsizetemporal)
			
			
			'Colores, ancho de línea y fuente en negrita
			pdf.SetFillColor 255,0,0
			pdf.SetTextColor 255
			pdf.SetDrawColor 128,0,0
			pdf.SetLineWidth .3
			'pdf.SetFont "","B"
			'pdf.SetFont "Arial","B",16
			
			
			
			'Cabecera de la tabla
			cabeceras = array("IMAGEN", "REF GAG", "REF", "DESCRIPCION", "CANT", "PRECIO", "TOTAL")
			anchuras = array(30, 35, 40, 110, 17, 20, 25) 'ancho total 277
			
			anchototal=0
			
			For Each x In anchuras
			  anchototal= anchototal + x
			Next
			
			
			
			pdf.SetFont "Arial","B",10
			For x=0 to ubound(cabeceras)
				pdf.Cell anchuras(x),7,cabeceras(x),1,0,"C",true
			next
			pdf.Ln()
			
			'Restauración de colores y fuentes
			pdf.SetFillColor 224,235,255
			pdf.SetTextColor 0
			pdf.SetFont ""
			pdf.SetFont "Arial","",10
			fontsize_estandar=10
			'Datos
			fill = false
			
			'response.write("<br>4 - generamos los detalles de articulos en el pdf...")
			while not detalles_pedido_proveedor.eof
				'miramos el campo que es susceptible de ser mas ancho que la columna de la tabla para trocearlo en varias lineas
				' y asi calcular el alto de esa linea en la tabla
				texto_celda=cstr("" & detalles_pedido_proveedor("DESCRIPCION"))
				'texto_celda="texto largo para ver si se adapta a la anchura de la celda y no se descuadra todo, se corta por donde debe para que se vea todo colocadito en su sitio, y esto lo repetimos hasta el infinito y mas alla para ver como se desborda en altura la celda y ver si los bordes que se pintan lo hacen bien o hay que reconfigurar la altura general de cada fila. aprovecho para probar tambien los signos raros Ññáéíóú ÁÉÍÓÚ çÇ ¨ üÜ"
				anchuracelda=anchuras(3)
				altura_celda = 5   'altura normal
				
				if pdf.GetStringWidth(texto_celda) < anchuracelda then
					linea=1
				else
					longitud_texto= len(texto_celda)
					margen_error=10
					caracter_inicio=0
					caracteres_maximos=0
					redim tabla_texto(1)
					cadena_temporal=""
					veces=0
					''response.write("<br>texto: " & texto_celda)
					while (caracter_inicio < longitud_texto)
						while (pdf.GetStringWidth(cadena_temporal) < (anchuracelda - margen_error)) and ((caracter_inicio + caracteres_maximos) < longitud_texto)
							caracteres_maximos=caracteres_maximos + 1
							cadena_temporal=Mid(texto_celda, caracter_inicio + 1, caracteres_maximos)
						wend
						''response.write("<br>cadena temporal: " & cadena_temporal)
						caracter_inicio=caracter_inicio + caracteres_maximos
						ReDim Preserve tabla_texto(UBound(tabla_texto) + 1)
						tabla_texto(UBound(tabla_texto))=cadena_temporal
						veces=veces + 1
						caracteres_maximos=0
						cadena_temporal=""
					wend
					'linea=UBound(tabla_texto) + 1
					linea=veces + 1
				end if
				''response.write("<br>NUMERO DE LINEAS: " & linea)
			
				altura_celda_final=altura_celda * linea
				'si tiene menos altura que la altura de la imagen fuezo a que sea de
				'la misma altura que la imagen
				if altura_celda_final<30 then
					altura_celda_final=30
				end if
			
				lineas_en_blanco=0
				''response.write("<br>lineas imagen: 6")
				''response.write("<br>lineas texto: " & linea)
				''response.write("<br>lineas en blanco: " & (6 - linea))
				''response.write("<br>lineas en blanco incial: " & ((6 - linea) \ 2))
				if linea>1 and altura_celda_final<=30 then
					lineas_en_blanco= ((7 - linea) \ 2)
				end if
			
				
				
				
				imagen_pdf="Imagenes_Articulos/Miniaturas/i_" & detalles_pedido_proveedor("ID") & ".jpg"
				'hay que comprobar la existencia del fichero... si no existe da error
				''response.write("<br>ruta fichero imagen para el pdf con server mappath: " & server.mappath(imagen_pdf))
				posicionxy="x: " & (pdf.GetX() + 1) & " y: " & (pdf.GetY() + 1)
				if pdf.GetY()>180 then
					pdf.AddPage("L")
				end if
				if fso.FileExists(server.mappath(imagen_pdf)) then
					''response.write("<br>el fichero imagen " & server.mappath(imagen_pdf) & " EXISTE.")
					pdf.Image imagen_pdf, (pdf.GetX() + 1), (pdf.GetY() + 1), 28, 28
				  else
				  	''response.write("<br>el fichero imagen " & server.mappath(imagen_pdf) & " NO EXISTE....")
					pdf.Image "Imagenes_Articulos/Miniaturas/i_no_imagen.jpg", (pdf.GetX() + 1), (pdf.GetY() + 1), 28, 28
				end if
				pdf.Cell anchuras(0),altura_celda_final, "","LR",0,"L",fill
				
				'reajusto el tamaño de la letra para que entre el texto en la celda
				fontsizetemporal=fontsize_estandar
				anchuracelda=anchuras(1)
				while (pdf.GetStringWidth(cstr("" & detalles_pedido_proveedor("CODIGO_SAP"))) > (anchuracelda - 2))
					fontsizetemporal = fontsizetemporal - 0.1
					pdf.SetFontSize(fontsizetemporal)
				wend

				pdf.Cell anchuras(1),altura_celda_final, cstr("" & detalles_pedido_proveedor("CODIGO_SAP")),"LR",0,"L",fill
				'pdf.Cell anchuras(1),altura_celda_final, posicionxy,"LR",0,"L",fill
				fontsizetemporal=fontsize_estandar
				pdf.SetFontSize(fontsizetemporal)
				
				anchuracelda=anchuras(2)
				while (pdf.GetStringWidth(cstr("" & detalles_pedido_proveedor("REFERENCIA_DEL_PROVEEDOR"))) > (anchuracelda - 2))
					fontsizetemporal = fontsizetemporal - 0.1
					pdf.SetFontSize(fontsizetemporal)
				wend
				pdf.Cell anchuras(2),altura_celda_final, cstr("" & detalles_pedido_proveedor("REFERENCIA_DEL_PROVEEDOR")),"LR",0,"L",fill
				fontsizetemporal=fontsize_estandar
				pdf.SetFontSize(fontsizetemporal)

				''''''''''''''''''''
				'en este caso, si hay mas de una linea porque la descripcion no entre por el ancho de
				' de la columna, se usa multicell
				posicion_x=pdf.GetX()
				posicion_y=pdf.GetY()
				anchuracelda=anchuras(3)
				if linea>1 then
					if lineas_en_blanco>0 then
						for annadir=1 to lineas_en_blanco
							''response.write("<br>INSERTO LINEA EN BLANCO")
							posicion_x=pdf.GetX()
							posicion_y_bucle=pdf.GetY()
							pdf.MultiCell anchuracelda, altura_celda,"", "LR"
							pdf.SetXY posicion_x, (posicion_y_bucle + altura_celda)
						next
					end if
					pdf.MultiCell anchuracelda, altura_celda,texto_celda, "LR"
					pdf.SetXY (posicion_x + anchuracelda), posicion_y
				  else
				  	pdf.Cell anchuracelda, altura_celda_final, texto_celda,"LR",0,"L",fill
				end if
				  
				''response.write("<br>posicionx despues de insertar celda multilinea: " & pdf.GetX())
				''response.write("<br>posiciony despues de insertar celda multilinea: " & pdf.GetY())
				
				''response.write("<br>anchura de la celda insertada: " & anchura_celda)
				
				pdf.Cell anchuras(4),altura_celda_final, cstr("" & detalles_pedido_proveedor("CANTIDAD")),"LR",0,"R",fill
				pdf.Cell anchuras(5),altura_celda_final, cstr("" & FORMATNUMBER(detalles_pedido_proveedor("PRECIO_COSTE"),2,-1,,-1)),"LR",0,"R",fill
				pdf.Cell anchuras(6),altura_celda_final, cstr("" & FORMATNUMBER(detalles_pedido_proveedor("TOTAL"),2,-1,,-1)),"LR",0,"R",fill
				pdf.Ln()
				pdf.Cell anchototal,0,"","T"
				pdf.Ln()
				'fill = not fill
				total_pedido_proveedor=total_pedido_proveedor + cdbl(detalles_pedido_proveedor("TOTAL"))
					
				detalles_pedido_proveedor.movenext
			wend
			pdf.Cell anchototal,0,"","T"
			pdf.Ln()
			
			pdf.Cell(anchuras(0) + anchuras(1) + anchuras(2) + anchuras(3) + anchuras(4))
			pdf.Cell anchuras(5),10, "TOTAL","LR",0,"R",fill
			pdf.Cell anchuras(6),10, cstr("" & FORMATNUMBER(total_pedido_proveedor,2,-1,,-1)),"LR",0,"R",fill
			pdf.Ln()
			
			'Línea de cierre
			pdf.Cell(anchuras(0) + anchuras(1) + anchuras(2) + anchuras(3) + anchuras(4))
			pdf.Cell (anchuras(5) + anchuras(6)),0,"","T"
			
			
			'''''''''''''''''''''''''''''''''''''''''
			'añadimos las personalizaciones
			'''''''''''''''''''''''''''''''''''''''''
			'response.write("<br>4 - se añaden las personalizaciones de articulos...")
			'https://www.aspjson.com/
			
			Set oJSON = New aspJSON
			
			detalles_pedido_proveedor.movefirst
			while not detalles_pedido_proveedor.eof
				plantilla_personalizacion="" & detalles_pedido_proveedor("PLANTILLA_PERSONALIZACION")
				if plantilla_personalizacion<>"" then
					carpeta_anno=year(fecha_pedido)
					ruta_fichero_json="GAG\Pedidos\" & carpeta_anno & "\" & usuario_pedido & "__" & pedido_seleccionado & "\json_" & detalles_pedido_proveedor("ID") & ".json"
					if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" and Request.ServerVariables("SERVER_NAME")<>"10.150.3.20" then
						'entorno de pruebas
						ruta_fichero_json=Request.ServerVariables("APPL_PHYSICAL_PATH") & "asp\CARRITO_IMPRENTA_GAG_BOOT\" & ruta_fichero_json
					  else
					  	'entorno real
						ruta_fichero_json= Request.ServerVariables("APPL_PHYSICAL_PATH") & ruta_fichero_json
					end if
					
					'response.write("<br>5 - Ruta del fichero json: " & ruta_fichero_json)
					
					Set fso = CreateObject("Scripting.FileSystemObject")
					cadena_json = fso.OpenTextFile(ruta_fichero_json).ReadAll
					''response.write("<br>contenido del fichero: " & cadena_json)
					
					pdf.AddPage("L")
					pdf.SetFont "Arial","B",10
					pdf.Cell(45)
					pdf.Cell 190,7, "PERSONALIZACION DEL ARTICULO",1,0,"C",true
					pdf.Ln()
					cadena_pdf=detalles_pedido_proveedor("DESCRIPCION")
					pdf.Cell(45)
					pdf.Cell 190,7,cadena_pdf,1,0,"C",true
					pdf.Ln()
					cadena_pdf="REF: " & detalles_pedido_proveedor("REFERENCIA_DEL_PROVEEDOR")
					pdf.Cell(45)
					pdf.Cell 95,7, cadena_pdf ,1,0,"C",true
					cadena_pdf="REF GAG: " & detalles_pedido_proveedor("CODIGO_SAP")
					pdf.Cell 95,7, cadena_pdf,1,0,"C",true
					pdf.Ln()
					
					
					'hay que comprobar la existencia del fichero... si no existe da error
					pdf.Cell(45)
					imagen_pdf="Imagenes_Articulos/Miniaturas/i_" & detalles_pedido_proveedor("ID") & ".jpg"
					if fso.FileExists(server.mappath(imagen_pdf)) then
						''response.write("<br>el fichero imagen " & server.mappath(imagen_pdf) & " EXISTE.")
						pdf.Image imagen_pdf, (pdf.GetX() + 1), (pdf.GetY() + 1), 28, 28
					  ELSE
					  	''response.write("<br>el fichero imagen " & server.mappath(imagen_pdf) & " NO EXISTE......")
						pdf.Image "Imagenes_Articulos/Miniaturas/i_no_imagen.jpg", (pdf.GetX() + 1), (pdf.GetY() + 1), 28, 28
					end if
					
					pdf.Cell 30,30, "","LR",0,"L",fill
					

					oJSON.loadJSON(cadena_json)
					'set personalizacion = jsonObj.parse(cadena_json)
					''response.write("<br>codigo cliente: " & oJSON.data("codigo_cliente"))
					''response.write("<br>codigo pedido: " & oJSON.data("codigo_pedido"))
					
					For Each datos_plantilla In oJSON.data("plantillas")
						Set this = oJSON.data("plantillas").item(datos_plantilla)
						''response.write("<br>instr plantilla_rotulacion_4: " & instr(detalles_pedido_proveedor("PLANTILLA_PERSONALIZACION"), "plantilla_rotulacion_4"))	

						'response.write("<br>6 - plantilla personalizacion: " & detalles_pedido_proveedor("PLANTILLA_PERSONALIZACION"))
						'caso de ser las plantillas de 3 o 4 campos
						if instr(detalles_pedido_proveedor("PLANTILLA_PERSONALIZACION"), "plantilla_rotulacion_3")>0 or instr(detalles_pedido_proveedor("PLANTILLA_PERSONALIZACION"), "plantilla_rotulacion_4")>0 then
							''response.write("<br>campo1: " & this.item("campo1"))
							''response.write("<br>descripcion1: " & this.item("descripcion1"))
							''response.write("<br>campo2: " & this.item("campo2"))
							''response.write("<br>descripcion2: " & this.item("descripcion2"))
							''response.write("<br>campo3: " & this.item("campo3"))
							''response.write("<br>descripcion3: " & this.item("descripcion3"))
							if instr(detalles_pedido_proveedor("PLANTILLA_PERSONALIZACION"), "plantilla_rotulacion_4")>0 then
								''response.write("<br>campo4: " & this.item("campo4"))
								''response.write("<br>descripcion4: " & this.item("descripcion4"))
							end if
						
							altura_celda_per=5
							anchura_celda_per=160
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							pdf.MultiCell anchura_celda_per, altura_celda_per,"", "LR"
							pdf.SetXY posicion_x_per, (posicion_y_per + altura_celda_per)
						
							
							cadena_pdf= "  " & this.item("campo1") & ": " & this.item("descripcion1")
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							pdf.MultiCell anchura_celda_per, altura_celda_per, cadena_pdf, "LR"
							pdf.SetXY posicion_x_per, (posicion_y_per + altura_celda_per)

							cadena_pdf= "  " & this.item("campo2") & ": " & this.item("descripcion2")
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							pdf.MultiCell anchura_celda_per, altura_celda_per, cadena_pdf, "LR"
							pdf.SetXY posicion_x_per, (posicion_y_per + altura_celda_per)
							
							cadena_pdf= "  " & this.item("campo3") & ": " & this.item("descripcion3")
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							pdf.MultiCell anchura_celda_per, altura_celda_per, cadena_pdf, "LR"
							pdf.SetXY posicion_x_per, (posicion_y_per + altura_celda_per)

							cadena_pdf= ""
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							if instr(detalles_pedido_proveedor("PLANTILLA_PERSONALIZACION"), "plantilla_rotulacion_4")>0 then
								cadena_pdf= "  " & this.item("campo4") & ": " & this.item("descripcion4")
							end if
							pdf.MultiCell anchura_celda_per, altura_celda_per, cadena_pdf, "LR"
							pdf.SetXY posicion_x_per, (posicion_y_per + altura_celda_per)
							
							cadena_pdf= "  Email Pruebas: " & this.item("email_pruebas")
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							pdf.MultiCell anchura_celda_per, altura_celda_per, cadena_pdf, "LR"

							pdf.SetXY (posicion_x_per + anchura_celda_per), posicion_y_per
					
						end if
						''response.write("<br>instr plantilla_rotulacion_1: " & instr(detalles_pedido_proveedor("PLANTILLA_PERSONALIZACION"), "plantilla_rotulacion_1"))	

						'caso para la plantilla de un solo dato
						if instr(detalles_pedido_proveedor("PLANTILLA_PERSONALIZACION"), "plantilla_rotulacion_1")>0 then
							''response.write("<br>campo: " & this.item("campo"))
							''response.write("<br>descripcion: " & this.item("descripcion"))
						
							altura_celda_per=5
							anchura_celda_per=160
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							pdf.MultiCell anchura_celda_per, altura_celda_per,"", "LR"
							pdf.SetXY posicion_x_per, (posicion_y_per + altura_celda_per)
							
							cadena_pdf= "  " & this.item("campo") & ": " & this.item("descripcion")
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							pdf.MultiCell anchura_celda_per, altura_celda_per, cadena_pdf, "LR"
							pdf.SetXY posicion_x_per, (posicion_y_per + altura_celda_per)
							
							cadena_pdf= ""
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							pdf.MultiCell anchura_celda_per, altura_celda_per, cadena_pdf, "LR"
							pdf.SetXY posicion_x_per, (posicion_y_per + altura_celda_per)
							
							cadena_pdf= "  Email Pruebas: " & this.item("email_pruebas")
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							pdf.MultiCell anchura_celda_per, altura_celda_per, cadena_pdf, "LR"
							pdf.SetXY posicion_x_per, (posicion_y_per + altura_celda_per)
							
							cadena_pdf= ""
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							pdf.MultiCell anchura_celda_per, altura_celda_per, cadena_pdf, "LR"
							pdf.SetXY posicion_x_per, (posicion_y_per + altura_celda_per)
							
							posicion_x_per=pdf.GetX()
							posicion_y_per=pdf.GetY()
							pdf.MultiCell anchura_celda_per, altura_celda_per,"", "LR"
							pdf.SetXY (posicion_x_per + anchura_celda_per), posicion_y_per
						end if
					Next
					pdf.Ln()
					pdf.Cell(45)
					pdf.Cell 190,0,"","T"
					pdf.Ln()

					
				
				end if
				detalles_pedido_proveedor.movenext
			wend
			
			pdf.Ln()
			'response.write("<br>7 - despues de ultimo pdf ln...")
			pdf.Close()
			'response.write("<br>8 - despues del pdf close...")
			
			'response.write("<br>9 - guardamos el pdf " & "TempPDF/Pedido_" & pedido_seleccionado & ".pdf")
			pdf.Output "TempPDF/Pedido_" & pedido_seleccionado & ".pdf", FALSE
			
			'response.write("<br>10 - terminamos el pdf...")
			
			'response.write("<br>11 - GENERAMOS EL EMAIL...")

			
			'''terminamos el pdf
			'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			
				'email del proveedor
				'enviar_a="" & datos_saldo("EMAIL") 	
				enviar_a="soporteglobalia-gls@tecnosenyal.com" 	
				'enviar_a="manuel.alba.gallego@gmail.com" 	
	
				mensaje = "<STYLE>"
				mensaje = mensaje & ".pedido { border: 1px solid black; border-collapse: collapse; }"
				mensaje = mensaje & "</STYLE>"
				mensaje = mensaje & "<div style='background-color:#fff;width:650px;font-family:Open-sans,sans-serif;color:#555454;font-size:13px;line-height:18px;margin:auto'>"
				mensaje = mensaje & "<table style='width:100%' bgcolor='#ffffff'>"
				mensaje = mensaje & "<tbody>"
				mensaje = mensaje & "<tr><td style='border-bottom:4px solid #333333;padding:7px 0'>&nbsp;</td></tr>"
				if enviar_a="" then
					mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
					mensaje = mensaje & "<tr>"
					mensaje = mensaje & "<td style='padding:7px 0'>"
					mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
					mensaje = mensaje & "<span><strong>NO SE HA ENVIADO ESTE AVISO POR EMAIL AL PROVEEDOR, PORQUE EN SU FICHA NO TIENE ASIGNADO NINGUNO.</strong></span>"
					mensaje = mensaje & "</font>"
					mensaje = mensaje & "</td>"
					mensaje = mensaje & "</tr>"
				end if		
				mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
	
				mensaje = mensaje & "<tr>"
				mensaje = mensaje & "<td style='padding:7px 0'>"
				mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
				mensaje = mensaje & "<span>PETICION DE ROTULACION.....</span>"
				mensaje = mensaje & "</font>"

				mensaje = mensaje & "</td>"
				mensaje = mensaje & "</tr>"
	
				mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
	
				mensaje = mensaje & "<tr>"
				mensaje = mensaje & "<td style='border:1px solid #d6d4d4;background-color:#f8f8f8;'>"
				mensaje = mensaje & "<table style='width:100%'>"
				mensaje = mensaje & "<tr>"
				mensaje = mensaje & "<td width='10'></td>"
				mensaje = mensaje & "<td>"
				mensaje = mensaje & "<table width='100%'>"
				mensaje = mensaje & "<tr><td width='50%'><font size='4' face='Open-sans, sans-serif' color='#555454'>"
				mensaje = mensaje & "<b>Pedido: </b></font></td>"
				mensaje = mensaje & "<td width='50%' style='text-align:right'><font size='4' face='Open-sans, sans-serif' color='#555454'>"
				mensaje = mensaje & "<b>FECHA: </b></font></td></tr>"
				mensaje = mensaje & "</table>"
				mensaje = mensaje & "</td>"
				mensaje = mensaje & "</tr>"
				mensaje = mensaje & "</table>"
				mensaje = mensaje & "</td>"
				mensaje = mensaje & "</tr>"
	
				
				mensaje = mensaje & "<tr><td height='2' style='padding:0!important'></td></tr>"
				
				
									

				mensaje = mensaje & mensaje_detalles


									
				
				mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
	
				mensaje = mensaje & "<tr>"
				mensaje = mensaje & "<td style='padding:7px 0'>"
				mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
				mensaje = mensaje & "<span>AAAAAAAAAAAAAAAAAAAAAAAAA.</span>"
				mensaje = mensaje & "</font>"
				mensaje = mensaje & "</td>"
				mensaje = mensaje & "</tr>"
				mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
				mensaje = mensaje & "<tr>"
				mensaje = mensaje & "<td style='padding:7px 0'>"
				mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
				mensaje = mensaje & "<span>Saludos y gracias.</span>"
				mensaje = mensaje & "</font>"
				mensaje = mensaje & "</td>"
				mensaje = mensaje & "</tr>"
				mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
				mensaje = mensaje & "<tr>"
				mensaje = mensaje & "<td style='border-top:4px solid #333333;padding:7px 0'>"
				mensaje = mensaje & "<span></span>"
				mensaje = mensaje & "</td>"
				mensaje = mensaje & "</tr>"
				mensaje = mensaje & "</tbody>"
				mensaje = mensaje & "</table>"
				mensaje = mensaje & "</div>"
			
			
			detalles_pedido_proveedor.close
			set detalles_pedido_proveedor = Nothing			
		end if
		pedido_al_proveedor.close
		set pedido_al_proveedor  = Nothing							
		
		'''''''''''''''''''
		'resto del mensaje a enviar
		''''''''''''''''''''''''''''
		
		
		
		
			
			
			if enviar_a="" then
				correos_recibe_real="carlos.gonzalez@globalia-artesgraficas.com"
			  else
				correos_recibe_real= enviar_a
			end if
				
			correos_recibe_real=correos_recibe_real & ";malba@globalia-artesgraficas.com"
			
			if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
				'ENTRONO PRUEBAS
				'carlos.gonzalez@globalia-artesgraficas.com
				'correos_recibe="malba@halconviajes.com;carlos.gonzalez@globalia-artesgraficas.com"
				'correos_recibe="malba@globalia-artesgraficas.com;soporteglobalia-gls@tecnosenyal.com"
				correos_recibe="malba@globalia-artesgraficas.com"
				cadena_asunto="PRUEBAS... "
			  else
				'ENTORNO REAL
				correos_recibe=correos_recibe_real
				cadena_asunto=""
			end if
			
			if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
				'ENTORNO PRUEBAS		
				mensaje=mensaje & "<BR><BR>este correo se deberia mandar al administrador: " & correos_recibe_real
			end if
			

			
			
			
			
			
			
			' Primero, cree una instancia del objeto de servidor CDO
		   Dim objCDO
		   Set objCDO = Server.CreateObject("CDO.Message")
		
		   ' Especifique la información del correo electrónico, incluyendo remitente, destinatario y cuerpo del mensaje
		   objCDO.From     = "malba@globalia-artesgraficas.com"
		   'objCDO.To       = "malba@globalia-artesgraficas.com;manuel.alba.gallego@gmail.com"
		   objCDO.To       = correos_recibe
		   objCDO.Subject  = cadena_asunto & "Solicitud de Rotulacion GAG - Pedido " & pedido_seleccionado
		   'objCDO.TextBody = "cuerpo del mensaje."
		   'objCDO.CreateMHTMLBody "http://www.w3schools.com/asp/" 
		   
		   ''response.write("<br>MANDAMOS EL EMAIL")
		   ''response.write("<br>CUERPO DEL MENSAJE:<BR>" & mensaje)
		   
		   	mensaje=""
			objCDO.HtmlBody = mensaje
		
		   'configuracion del servidor de emails
		   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		   objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "192.168.150.44"
		   'objMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
		   objCDO.Configuration.Fields.Update
		
			'response.write("<br>12 - VAMOS A ADJUNTAR EL PDF")
			' Especifique la ruta y el nombre del archivo que se desea adjuntar
			ruta=Request.ServerVariables("PATH_TRANSLATED")
			posicion=InStrRev(ruta,"\")
			''response.write("<br>ruta: " & ruta)
			''response.write("<br>posicion: " & posicion)
			ruta=left(ruta,posicion)
			ruta=ruta & "TempPDF\Pedido_" & pedido_seleccionado & ".pdf"
			'response.write("<br>13 - PDF Adjunto EN LA RUTA: " & ruta)
		
		   'objCDO.AddAttachment "D:\Intranets\Ventas\asp\adjunto.txt"
		   objCDO.AddAttachment ruta
		   'objCDO.AddAttachment(canvas)
		
		   ' Use el método Send del objeto CDO para enviar el correo electrónico con el adjunto
		   'response.write("<br>14 - antes del send.")
		   
		  	if envio_correo="SI" then
			   objCDO.Send
			end if
			'response.write("<br>15 - despues del send.")
			
			''response.write("<br>vamos a borrar el fichero: " & server.mappath("TempPDF/Pedido_" & pedido_seleccionado & ".pdf"))
			
			'ya no borramos el fichero, lo dejamos accesible para consultarlo desde la distribuidora
			'if fso.FileExists(server.mappath("TempPDF/Pedido_" & pedido_seleccionado & ".pdf")) then
			'	fso.DeleteFile(server.mappath("TempPDF/Pedido_" & pedido_seleccionado & ".pdf"))
			'end if
			
			set fso=NOTHING
			
'funcion que calcula las lineas en las que se ha de partir un texto en funcion de su tamaño de letra y longitud
'y despues se utiliza multicell en vez de cell para ir añadiendo con multicell cada una de esas lineas			
function calcular_lineas_de_texto(cadena_texto, anchuracelda)			
	if pdf.GetStringWidth(cadena_texto) < anchuracelda then
		lineas_texto = 1
	else
		'nos toca cortar el texto en varias lineas dentro de esa celda
		longitud_texto = len(cadena_texto)
		margen_error = 10
		comienzo = 0
		caracteres_maximos = 0
		dim tabla_textos(10)
		cadena_temporal = ""
		'recorremos el texto
		indice_texto=0
		while (comienzo < longitud_texto)
			while ((pdf.GetStringWidth(cadena_temporal) < (anchuracelda)) and ((comienzo + caracteres_maximos) < longitud_texto))
				caracteres_maximos = caracteres_maximos + 1
				cadena_temporal = Mid(cadena_texto, comienzo + 1, caracteres_maximos)
			wend
			comienzo = comienzo + caracteres_maximos
			tabla_textos(indice_texto)=cadena_temporal
			indice_texto = indice_texto + 1
			caracteres_maximos = 0
			cadena_temporal = ""
		
		wend
		
		lineas_texto = indice_texto
	
	end if			
		
	calcular_lineas_de_texto=lineas_texto
end function
			
			
%>
			
	
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Enviar Email al Proveedor</TITLE>
<script language="javascript">
function volver()
	{
	alert('Pedido de Rotulacion enviado al Proveedor')
	document.getElementById("frmvolver").submit()
	}		
</script>
</HEAD>

<BODY onload="volver()">		
<form name="frmvolver" id="frmvolver" method="post" action="Consulta_Pedidos_Admin.asp">
</form>
		
		
				