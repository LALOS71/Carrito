<%@ language=vbscript%>

<!--#include file="../Conexion.inc"-->
<!--#include file = "../includes/crypto/Crypto.Class.asp" -->

<%

Function Genera_Clave_Aleatoria()
      Randomize
	  caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
      valor = Int(Rnd * 62) + 1
	  Genera_Clave_Aleatoria=Mid(caracteres,valor,1)
End Function

'response.write("<br><br>clave aleatoria: ")
'For i=1 to 64
'      Response.write (Genera_Clave_Aleatoria())
'Next

'Response.Write("<b>el charset: " & Response.Charset)
'Response.Write("<br>el codepage: " & Response.CodePage)

'Response.CharSet = "ISO-8859-1"
'Response.CodePage = 28591


Response.CharSet = "UTF-8"
Response.CodePage = 65001

'Response.Write("<b>el charset despues: " & Response.Charset)
'Response.Write("<br>el codepage despues: " & Response.CodePage)



	caso=""	
	
	'para MIREIA JOSE JAVIER FERNANDEZ Y LOS USUARIOS DE PREUBAS DE CADA TIPO DE ROPA (1N, 1R, 2N, 2R, 3N, 3R, 5N, 5R)	
	if (session("usuario_directorio_activo")<>2394 and session("usuario_directorio_activo")<>2391 _
		AND session("usuario_directorio_activo")<>1851 AND session("usuario_directorio_activo")<>1852 AND session("usuario_directorio_activo")<>1853 _
		AND session("usuario_directorio_activo")<>1854 AND session("usuario_directorio_activo")<>1855 AND session("usuario_directorio_activo")<>1856 _
		AND session("usuario_directorio_activo")<>1857 AND session("usuario_directorio_activo")<>1858) _ 
		then
			caso="VOLVER_LOGIN"
	end if

    dim usuarios
	
	id_empleado = "" & Request.Form("id_empleado")
	fecha_alta = "" & Request.Form("fecha_alta")
	nif = "" & Request.Form("nif")
	nombre = "" & Request.Form("nombre")
	apellidos = "" & Request.Form("apellidos")
	borrado = "" & Request.Form("borrado")
	email = "" & Request.Form("email")
	grupo_ropa = "" & Request.Form("grupo_ropa")
	centro_coste = "" & Request.Form("centro_coste")
	nuevo = "" & Request.Form("nuevo")
	if nuevo="SI" then
		nuevo="1"
	  else
	  	nuevo="0"
	end if

	
	
	'response.write("<br>origen: " & origen)
	'response.write("<br>usuario seleccionado: " & usuario_seleccionado)
	'response.write("<br>contraseña seleccionada: " & contrasenna_seleccionada)
	'response.write("<br>contraseña antigua: " & contrasenna_antigua_seleccionada)
	'response.write("<br>contraseña nueva: " & contrasenna_nueva_seleccionada)
	'response.write("<br>nombre: " & nombre)
	
	
	if caso<>"VOLVER_LOGIN" then
		set crypt = new crypto 
		
		
		if id_empleado="" then 'es un ALTA
			set empleados = Server.CreateObject("ADODB.Recordset")
				
			sql="SELECT * FROM EMPLEADOS_GLS"
			sql=sql & " WHERE NIF='" & nif & "'"
				
			'response.write("<br>" & sql)
				
			with empleados
				.ActiveConnection=connimprenta
				.Source=sql
				.Open
			end with
			
			caso="ALTA_OK"
			if not empleados.eof then 'ya hay un empleado con el mismo dni
				caso="ALTA_DNI_REPETIDO"
			end if
			empleados.close
			set empleados = Nothing		
			
			if caso="ALTA_OK" then
				'CAST(DATEADD(dd, 1, '" & cdate(fecha_fin_seleccionada) & "') AS SMALLDATETIME)
			
				sql="INSERT INTO EMPLEADOS_GLS (NIF, NOMBRE, APELLIDOS, EMAIL, BORRADO, GRUPO_ROPA, CENTRO_COSTE, CONTRASENNA, NUEVO, FECHA_ALTA, FECHA_NUEVO_INVIERNO, FECHA_NUEVO_VERANO)"
				sql = sql & " VALUES ('" & nif & "', '" & nombre & "', '" & apellidos & "', '" & email & "', '" & borrado & "', " & grupo_ropa
				sql = sql & ", " & centro_coste & ", '" & crypt.hashPassword(nif,"SHA256","b64") & "', " & nuevo & ", '" & cdate(fecha_alta) & "'"
				if nuevo then
					sql = sql & ", getdate(), getdate())"
				  else
				  	sql = sql & ", null, null)"
				end if
				'response.write("<br><br>" & sql)
			
				connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
			end if
	
			
		  else 'es una MODIFICACION
		  
			set empleados = Server.CreateObject("ADODB.Recordset")
				
			sql="SELECT * FROM EMPLEADOS_GLS"
			sql=sql & " WHERE NIF='" & nif & "'"
				
			'response.write("<br>" & sql)
				
			with empleados
				.ActiveConnection=connimprenta
				.Source=sql
				.Open
			end with
			
			caso="MODIFICACION_OK"
			if not empleados.eof then 'ya hay un empleado con el mismo dni, ahora comprobamos que el id sea diferente para saber si es el mismo empleado o es otro
				'response.write("<br>ID: " & empleados("ID"))
				'response.write("<br>id_empleado: " & id_empleado)
				if ("" & empleados("ID")) <> ("" & id_empleado) then
					caso="MODIFICACION_DNI_REPETIDO"
				end if
			end if
			empleados.close
			set empleados = Nothing		
			
			if caso="MODIFICACION_OK" then
				sql="UPDATE EMPLEADOS_GLS SET"
				sql = sql & " NIF='" & nif & "'"
				sql = sql & ", NOMBRE='" & nombre & "'"
				sql = sql & ", APELLIDOS='" & apellidos & "'"
				sql = sql & ", EMAIL='" & email & "'"
				sql = sql & ", BORRADO='" & borrado & "'"
				sql = sql & ", GRUPO_ROPA=" & grupo_ropa
				sql = sql & ", CENTRO_COSTE=" & centro_coste
				sql = sql & ", NUEVO='" & nuevo & "'"
				sql = sql & ", FECHA_ALTA='" & cdate(fecha_alta) & "'"
				if nuevo then
					sql = sql & ", FECHA_NUEVO_INVIERNO=getdate()"
					sql = sql & ", FECHA_NUEVO_VERANO=getdate()"
				end if

				sql = sql & " WHERE ID=" & id_empleado
	
				'response.write("<br><br>" & sql)
			
				connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
				connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
			end if
			
		end if
		
		
		connimprenta.close
		set connimprenta=Nothing
		
		set crypt = nothing
		
	end if 'del caso<> volver login
	
	cadena_json = "{"
	cadena_json = cadena_json & """resultado"":""" & caso & """" 
	'cadena_json = cadena_json & ", ""id_usuario_gls"":""" & id_usuario_gls & """"
	'cadena_json = cadena_json & ", ""usuario_usuario_gls"":""" & usuario_usuario_gls & """"
	'cadena_json = cadena_json & ", ""nombre_usuario_gls"":""" & nombre_usuario_gls & """"
	'cadena_json = cadena_json & ", ""apellidos_usuario_gls"":""" & apellidos_usuario_gls & """"
	'cadena_json = cadena_json & ", ""email_usuario_gls"":""" & email_usuario_gls & """"
	'cadena_json = cadena_json & ", ""borrado_usuario_gls"":""" & borrado_usuario_gls & """"
	'cadena_json = cadena_json & ", ""grupo_ropa_usuario_gls"":""" & grupo_ropa_usuario_gls & """"
	'cadena_json = cadena_json & ", ""centro_coste_usuario_gls"":""" & centro_coste_usuario_gls & """"
	'cadena_json = cadena_json & ", ""nuevo_usuario_usuario_gls"":""" & nuevo_usuario_usuario_gls & """"
    'cadena_json = cadena_json & ", ""cambiar_contrasenna_usuario_gls"":""" & cambiar_contrasenna & """"
	cadena_json = cadena_json & "}"
	
	
	
	response.write(cadena_json)
%>

