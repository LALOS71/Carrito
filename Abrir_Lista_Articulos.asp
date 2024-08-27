    <%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--#include file="Conexion.inc"-->

<%
		

session("cliente") = Request.Form("ocultoCliente")
session("usuario_cod") = Request.Form("ocultoUsuario")
hotel_seleccionado = session("cliente")
empresa_entrada = Request.Form("ocultoempresa")

'response.write("<br> Usuario :"+session("usuario_cod"))

dim hoteles

set hoteles=Server.CreateObject("ADODB.Recordset")
		
sql="Select V_CLIENTES.*, V_empresas.empresa as nombre_empresa, V_empresas.carpeta  from V_CLIENTES"
sql=sql & " inner join V_empresas"
sql=sql & " on V_CLIENTES.empresa=V_empresas.id"
sql=sql & " where V_CLIENTES.id=" & hotel_seleccionado
		
'response.write("<br>" & sql)
		
with hoteles
	.ActiveConnection=connimprenta
	.Source=sql
	.Open
end with       


valido=""
administrador_central="NO"
administrador_empresa=""
if not hoteles.eof then
	contrasenna_hotel=hoteles("contrasenna")			
	session("usuario_carpeta")=hoteles("carpeta")
       						
	valido="SI"		
    session("usuario_empresa")=empresa_entrada

    session("usuario")=hotel_seleccionado
	session("usuario_codigo_externo")=hoteles("codigo_externo")
	session("usuario_nombre")=hoteles("nombre")
	session("usuario_direccion")=hoteles("direccion")
	session("usuario_poblacion")=hoteles("poblacion")
	session("usuario_cp")=hoteles("cp")
	session("usuario_provincia")=hoteles("provincia")
	session("usuario_telefono")=hoteles("telefono")
	session("usuario_fax")=hoteles("fax")
	session("usuario_pedido_minimo_sin_compromiso")=hoteles("pedido_minimo_sin_compromiso")
	session("usuario_pedido_minimo_con_compromiso")=hoteles("pedido_minimo_con_compromiso")
	session("usuario_empresa")=hoteles("nombre_empresa")
	session("usuario_codigo_empresa")=hoteles("empresa")
	session("usuario_marca")=hoteles("marca")
	session("usuario_tipo")=hoteles("tipo")
	session("usuario_requiere_autorizacion")=hoteles("requiere_autorizacion")
				
	session("numero_articulos")=0
	set administrador=Server.CreateObject("ADODB.Recordset")
				
	sql="Select * from V_EMPRESAS_CENTRAL"
	sql=sql & " where CODIGO_AD=" & hotel_seleccionado
	sql=sql & " AND EMPRESA=" & empresa_entrada
				
	'response.write("<br>" & sql)
    'response.write("<br> Empresa :" & Request.Form("empresa_entrada"))				
	with administrador
		.ActiveConnection=connimprenta
		.Source=sql
		.Open
	end with

	if not administrador.eof then
		administrador_central="SI"
	end if
	administrador.close
	set administrador=Nothing
	else
	valido="NO"
	
end if
		
		
		
hoteles.close
connimprenta.close
set hoteles = Nothing
set connimprenta=Nothing
		
	
'response.write("sucursal: " & codigo_sucursal & "<br>Usuario: " & usuario & "<br>Contraseña: " & contrasenna)

'---------------------------
'session("usuario")=Request.Form("ocultoCliente")
'session("usuario_codigo_empresa")=10
'session("usuario_nombre")=hoteles("nombre")

		
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
<title>Carrito Imprenta</title>

<script type="text/javascript">

function abrirArticulos() {
    //alert('abrirArticulos');        
    location.href = "http://192.168.153.132/asp/carrito_imprenta_P/GAG/Lista_Articulos_GAG.asp"    
}   
  
</script>


</head>


<BODY onload="abrirArticulos()">



</body>

</html>

