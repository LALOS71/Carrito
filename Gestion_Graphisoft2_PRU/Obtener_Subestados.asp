<!--#include file="DB_Manager.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	cadena_subestados=""
	cadena_combo_subestados=""
	estado_seleccionado="" & Request.QueryString("codigo_estado")
	subestado_seleccionado= "" & Request.QueryString("codigo_subestado")
	
	'response.write("<br>subestado_seleccionado: " & subestado_seleccionado)
	
	
	CAMPO_ID_SUBESTADOS				= 0
    CAMPO_DESCRIPCION_SUBESTADOS	= 1

	' GetsubEstados query
    sql = "SELECT ID, DESCRIPCION FROM GESTION_GRAPHISOFT_SUBESTADOS_PRESUPUESTOS WHERE ID_ESTADO=" & estado_seleccionado & " ORDER BY ORDEN"
    vacio_subestados = false

	'response.write("<br><br>" & sql)
    Set subestados = execute_sql(conn_gag, sql)
    If Not subestados.BOF Then
        tabla_subestados = subestados.GetRows()
    Else
        vacio_subestados = true
    End If

    close_connection(subestados)
    ' /GetEstados query

    if not vacio_subestados Then
		For i = 0 To UBound(tabla_subestados, 2)
			'response.write("<br>tabla: " & tabla_subestados(CAMPO_ID_SUBESTADOS,i) & " y subestado seleccionado: " & subestado_seleccionado)
			if tabla_subestados(CAMPO_ID_SUBESTADOS,i)<>"" AND subestado_seleccionado<>"" THEN
				if cint(tabla_subestados(CAMPO_ID_SUBESTADOS,i))=cint(subestado_seleccionado) then
					cadena_subestados=cadena_subestados & "<option value=""" & tabla_subestados(CAMPO_ID_SUBESTADOS,i) & """ selected>" & tabla_subestados(CAMPO_DESCRIPCION_SUBESTADOS,i) & "</option>"
					'response.write("<br>cadena subestados iguales: " & cadena_subestados)
				  else
					cadena_subestados=cadena_subestados & "<option value=""" & tabla_subestados(CAMPO_ID_SUBESTADOS,i) & """>" & tabla_subestados(CAMPO_DESCRIPCION_SUBESTADOS,i) & "</option>"
					'response.write("<br>cadena subestados distintos: " & cadena_subestados)
				end if
			  else
			  	cadena_subestados=cadena_subestados & "<option value=""" & tabla_subestados(CAMPO_ID_SUBESTADOS,i) & """>" & tabla_subestados(CAMPO_DESCRIPCION_SUBESTADOS,i) & "</option>"
			end if
		Next
	End If                                    

	'response.write(cadena_subestados)
	if cadena_subestados<>"" then
		cadena_combo_subestados="<label for=""txtsubestado_d"" class=""control-label"">OBSERVACIONES DEL ESTADO</label>"
		cadena_combo_subestados=cadena_combo_subestados & "<select id=""cmbsubestados_d"" name=""cmbsubestados_d"" data-width=""100%"" class=""form-control"">"
		cadena_combo_subestados=cadena_combo_subestados & "<option value="""">Seleccione</option>"
		cadena_combo_subestados=cadena_combo_subestados & cadena_subestados
		cadena_combo_subestados=cadena_combo_subestados & "</select>"
	end if
	response.write(cadena_combo_subestados)
%>

