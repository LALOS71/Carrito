<%@ language=vbscript%>

<!--#include file="Conexion_GAG.inc"-->
<!--#include file = "includes\crypto\Crypto.Class.asp" -->

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

Response.Write("<b>el charset: " & Response.Charset)
Response.Write("<br>el codepage: " & Response.CodePage)

'Response.CharSet = "ISO-8859-1"
'Response.CodePage = 28591


Response.CharSet = "UTF-8"
Response.CodePage = 65001

Response.Write("<b>el charset despues: " & Response.Charset)
Response.Write("<br>el codepage despues: " & Response.CodePage)




set empleados = Server.CreateObject("ADODB.Recordset")
set crypt = new crypto
				
sql="SELECT * FROM USUARIOS"
sql=sql & " WHERE EXTERNO=1"
sql=sql & " AND CONTRASENNA IS NULL"


	
'response.write("<br>" & sql)
	
with empleados
	.ActiveConnection=conn_gag
	.Source=sql
	.Open
end with
			
while not empleados.eof
	sql="UPDATE USUARIOS "
	sql = sql & " SET CONTRASENNA = '" & crypt.hashPassword(empleados("USUARIO"),"SHA256","b64") & "'"
	sql = sql & " WHERE IDUSUARIO=" & empleados("IDUSUARIO")
	conn_gag.Execute sql,,adCmdText + adExecuteNoRecords
	empleados.movenext
wend

empleados.close
set empleados = Nothing		

		
conn_gag.close
set conn_gag=Nothing
	
set crypt = nothing
%>

