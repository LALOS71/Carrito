<%
	



	Function formatear_fecha(fecha)
	   
	   if fecha<>"" then				
		dia=day(fecha)
		if dia<10 then
			dia="0" & dia
		end if
		mes=month(fecha)
		if mes<10 then
			mes= "0" & mes
		end if
		anno=year(fecha)
		
		fecha_formateada=dia & "-" & mes & "-" & anno	
	     else
		fecha_formateada=""
	   end if


		formatear_fecha=fecha_formateada
	End Function


	Function formatear_hora(hora)
	   
	   if hora<>"" then				
		horas=hour(hora)
		if horas<10 then
			horas="0" & horas
		end if
		minutos=minute(hora)
		if minutos<10 then
			minutos= "0" & minutos
		end if
		
		hora_formateada=horas & ":" & minutos	
	     else
		hora_formateada=""
	   end if
		
		'response.write("<br><br>" & hora_formateada)

		formatear_hora=hora_formateada
	End Function

	Function formatear_importe(importe)
	   
	   if importe<>"" then				
		importe_formateado=FORMATNUMBER(importe,2,-1,,-1)
	      else
		importe_formateado=""
	   end if
		
		'response.write("<br><br>" & importe_formateado)

		formatear_importe=importe_formateado
	End Function


	Function formatear_importe_sin_punto(importe)
	   
	   if importe<>"" then				
		importe_formateado=replace(importe,",",".")
	      else
		importe_formateado=""
	   end if
		
		'response.write("<br><br>" & importe_formateado)

		formatear_importe_sin_punto=importe_formateado
	End Function







	Function formatear_importe_sin_dec(importe)
	    if importe<>"" then				
		 importe_formateado=FORMATNUMBER(importe,0,-1,,-1)
	       else
		 importe_formateado=""
	    end if
		
		'response.write("<br><br>" & importe_formateado)

		formatear_importe_sin_dec=importe_formateado
	End Function


	Function formatear_texto(cadena)		
		descripcion_retocada=""
		descripcion=cadena
		'response.write("<br><br>Descripcion: " & descripcion)
		for i=1 to len(descripcion)
			'response.write("<br>Caracter " & i & ": " & mid(descripcion,i,1) & " Codigo Ascii: " & asc(mid(descripcion,i,1)))
			if asc(mid(descripcion,i,1))=13 then
				descripcion_retocada=descripcion_retocada & "<br>"
			else
				if asc(mid(descripcion,i,1))<>10 then
					descripcion_retocada=descripcion_retocada & mid(descripcion,i,1)
				end if
			
			end if
		next 
   		'response.write("<br><br>Cadena Retocada: " & descripcion_retocada)
		formatear_texto=descripcion_retocada
	End Function
	
	Function formatear_texto_sms(cadena)		
		descripcion_retocada=""
		descripcion=cadena
		'response.write("<br><br>Descripcion: " & descripcion)
		for i=1 to len(descripcion)
			'response.write("<br>Caracter " & i & ": " & mid(descripcion,i,1) & " Codigo Ascii: " & asc(mid(descripcion,i,1)))
			if asc(mid(descripcion,i,1))=13 then
				descripcion_retocada=descripcion_retocada & "\n"
			else
				if asc(mid(descripcion,i,1))<>10 then
					descripcion_retocada=descripcion_retocada & mid(descripcion,i,1)
				end if
			
			end if
		next 
   		'response.write("<br><br>Cadena Retocada: " & descripcion_retocada)
		formatear_texto_sms=descripcion_retocada
	End Function

	Function Capitalize(str)
		'pone la primera letra de cada palabra en mayusculas.

		Dim t
		t = str

		If t <> "" Then
			t = UCase(Mid(t, 1, 1)) & Right(t, Len(t) - 1)

			For i = 1 To Len(t) - 1
				If Mid(t, i, 2) = Chr(13) + Chr(10) Then
					' Capitalize words preceded by carriage return plus
					' linefeed combination.
					t = Mid(t, 1, i) & UCase(Mid(t, i + 2, 1)) & Mid(t, i+3, Len(t))
				End If
				If Mid(t, i, 1) = " " Then
					' Capitalize words preceded by a space:
					t = Mid(t, 1, i) & UCase(Mid(t, i + 1, 1)) & Mid(t, i+2, Len(t))
				End If
			Next
		End If

		Capitalize = t
	End Function



%>