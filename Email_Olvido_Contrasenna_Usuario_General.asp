<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<!--#include file="Envio_Mails_CDO/Envio_Mail.inc"-->

<%

Function Genera_Clave_Aleatoria()
      Randomize
	  caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
      valor = Int(Rnd * 62) + 1
	  Genera_Clave_Aleatoria=Mid(caracteres,valor,1)
End Function


function revCorreo(Correo)
   ' revisa direcci�n valida
   ' regresa 1 para direcciones invalidas
   ' regresa 0 para direcciones validas
   dim atCnt
   revCorreo = 0

   ' chk length
   if len(Correo) < 5  then
      ' z@q.c deber�a ser la direcci�n mas corta posible
      revCorreo = 1
 
   ' revisa formato
   ' revisa que tenga una @
   elseif instr(Correo,"@") = 0 then
      revCorreo = 1
 
   ' revisa que tenga un .
   elseif instr(Correo,".") = 0 then
      revCorreo = 1
 
   ' revisa que no tenga mas de tres caracteres despues del .
   elseif len(Correo) - instrrev(Correo,".") > 4 then
      revCorreo = 1
 
   ' que no tenga _ despu�s de @
  ' elseif instr(Correo,"_") <> 0 and _
    '   instrrev(Correo,"_") > instrrev(Correo,"@")  then
   '   revCorreo = 1

   else
      ' que tenga solo una @
      atCnt = 0
      for i = 1 to len(Correo)
         if  mid(Correo,i,1) = "@" then
            atCnt = atCnt + 1
         end if
      next
 
      if atCnt > 1 then
         revCorreo = 1
      end if

      ' revisa caracter por caracter
      for i = 1 to len(Correo)
        if  not isnumeric(mid(Correo,i,1)) and _
  (lcase(mid(Correo,i,1)) < "a" or _
  lcase(mid(Correo,i,1)) > "z") and _
  mid(Correo,i,1) <> "_" and _
  mid(Correo,i,1) <> "." and _
  mid(Correo,i,1) <> "@" and _
  mid(Correo,i,1) <> "-" then
            revCorreo = 1
        end if
      next
  end if
end function



	caso=""	
	email=""
	
   
	
	nif = "" & Request.Form("nif")

	'usuario="1R"
	
	
	'response.write("<br>origen: " & origen)
	'response.write("<br>usuario seleccionado: " & usuario_seleccionado)
	'response.write("<br>contrase�a seleccionada: " & contrasenna_seleccionada)
	'response.write("<br>contrase�a antigua: " & contrasenna_antigua_seleccionada)
	'response.write("<br>contrase�a nueva: " & contrasenna_nueva_seleccionada)
	
	
	set usuarios=Server.CreateObject("ADODB.Recordset")
	with usuarios
		.ActiveConnection=connimprenta
		.Source="SELECT IDCLIENTE, NIF, EMAIL"
		.Source= .Source & " FROM [192.168.156.175\SERVERSQL].GAG.dbo.CLIENTES"
		.Source= .Source & " WHERE NIF='" & nif & "'"
		.Source= .Source & " AND IDCADENA=260"
		.Source= .Source & " AND BORRADO=0"

		'response.write("<br><br>consulta: " & .source)
		.Open
	end with

	if not usuarios.eof then
		email="" & usuarios("EMAIL")
		if email="" then
			caso="NO_TIENE_EMAIL"
		  else
		  	if revCorreo(email)<>0 then
				caso="EMAIL_MAL_ESTRUCTURADO"
			end if
		end if
	
	  else
	  	caso="USUARIO_NO_EXISTE"
	end if

	
	usuarios.close
	set usuarios=Nothing
	
	
	'response.write("<br><br>caso: ..." & caso & "...")
	
if caso="" then
		clave_aleatoria=""
		For i=1 to 12
			clave_aleatoria=clave_aleatoria & Genera_Clave_Aleatoria()
			'Response.write ("<br>" & clave_aleatoria)
		Next
		
		
		'Response.write server.HTMLEncode("<br><br>Para el usuario: " & usuario & " hay que mandar un email al correo: " & email & " mandandole la contrase�a: " & clave_aleatoria & " que queda encriptada como: " & clave_encriptada)
		
		
		'----------------------------------------------
		'INICIO DEL ENVIO DE EMAIL
		de = "noreply.gag@globalia-artesgraficas.com"
		para = email
		asunto = "RESTABLECIMIENTO DE CONTRASE�A"
				
		
		mensaje="Se ha modificado la contrase&ntilde;a de acceso a Globalia Artes Gr&aacute;ficas para su usuario."
		mensaje=mensaje & "<br><br>Su nueva contrase&ntilde;a de acceso es: " & clave_aleatoria
		mensaje=mensaje & "<br><br>Por seguridad, nada m&aacute;s validarse, el sistema le pedir&aacute; que cambie la contrase&ntilde;a."
		mensaje=mensaje & "<br><br>Un saludo."
		
		adjunto= ""
		servidor = "GLOBALIA"
		'servidor = "AMAZON"
		respuesta_envio = envio_email(de, para, asunto, mensaje, adjunto, servidor)
			
'-----------------------------------------------------	
'FIN DEL ENVIO DE EMAIL

		sql= "UPDATE [192.168.156.175\SERVERSQL].GAG.dbo.CLIENTES SET CONTRASENA='" & clave_aleatoria & "'"
		sql = sql & ", SALT=NULL"
		sql = sql & " WHERE NIF='" & nif & "'"
		sql = sql & " AND IDCADENA=260"
		sql = sql & " AND BORRADO=0"


		'response.write("<br><br>consulta: " & sql)
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
		connimprenta.Execute sql,,adCmdText + adExecuteNoRecords
		caso="OK"
	
end if		
	
	

'regis.close			
connimprenta.Close
set connimprenta=Nothing	

cadena_json = "{"
cadena_json = cadena_json & """resultado"":""" & caso & """" 
cadena_json = cadena_json & "}"
	
response.write(cadena_json)	

%>
