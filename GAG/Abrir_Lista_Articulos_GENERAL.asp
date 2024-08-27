<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<!--#include file="../Conexion.inc"-->

<%
'****************************************************************************
'****************************************************************************
' OJO, PORQUE TODO LO QUE SE CAMBIE AQUI, TAMBIEN PUEDE AFECTAR A LA PAGINA 
' DE VALIDACION DEL DIRECTORIO RAIZ, VALIDAR.ASP.. ESA PAGINA ES LA QUE HACE
' LA VALIDACION de usuarios DE LA EMPRESA GENERAL DEL carrito no la validacion de los usuarios del active directori
' como hace esta..... ASI QUE PUEDE SER QUE TAMBIEN SE TENGA QUE PONER EL CAMBIO
' EN ESA OTRA PAGINA
'***************************************************************************
'****************************************************************************
		
'response.write("<br>cliente: " & Request.Form("ocultocliente_login"))
'response.write("<br>usuario: " & Request.Form("ocultousuario_login"))

session("cliente") = Request.Form("ocultocliente_login")


hotel_seleccionado = session("cliente")



dim hoteles

set hoteles=Server.CreateObject("ADODB.Recordset")
		
sql="Select V_CLIENTES.*, V_EMPRESAS.EMPRESA as nombre_empresa, V_EMPRESAS.CARPETA  from V_CLIENTES"
sql=sql & " inner join V_EMPRESAS"
sql=sql & " on V_CLIENTES.EMPRESA=V_EMPRESAS.ID"
sql=sql & " where V_CLIENTES.ID=" & hotel_seleccionado    	
sql=sql & " and V_CLIENTES.EMPRESA=260"	
'response.write("<br>" & sql)		
with hoteles
	.ActiveConnection=connimprenta
	.Source=sql
	.Open
end with       

'empresa_entrada = Request.Form("ocultoempresa") ' eliminado, ahora se lee del dataset. no viene del formualrio --

administrador_central="NO"
administrador_empresa=""
if not hoteles.eof then
	contrasenna_hotel=hoteles("contrasenna")			
	session("usuario_carpeta")=hoteles("carpeta")
       						
    empresa_entrada = hoteles("empresa")
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
				
	session("usuario_fecha_alta")=hoteles("fecha_alta")
	session("usuario_pais")=hoteles("pais")
	
	session("usuario_trato_especial")=hoteles("idtratoespecial")
	session("usuario_idsap")=hoteles("idsap")
	session("usuario_tipoprecio")=hoteles("tipo_precio")
	
	set primer_pedido=Server.CreateObject("ADODB.Recordset")
		
	sql_primer="SELECT COUNT(*) AS PEDIDOS_HECHOS FROM PEDIDOS WHERE CODCLI=" & hotel_seleccionado
	
	'response.write("<br>" & sql)
	cantidad_pedidos=0	
	with primer_pedido
		.ActiveConnection=connimprenta
		.Source=sql_primer
		.Open
	end with
	
	if not primer_pedido.eof then
		cantidad_pedidos=primer_pedido("pedidos_hechos")
	end if
	
	if cantidad_pedidos=0 then
		session("usuario_primer_pedido")="SI"
	  else
		session("usuario_primer_pedido")="NO"
	end if
	
	primer_pedido.close	
	set primer_pedido = Nothing
	
'CADE	1	BARCELO	BARCELO	1	3010
'CADE	2	BE LIVE	BE_LIVE	1	1429
'CADE	3	LUABAY	LUABAY	0	0000000000
'CADE	4	ASM	ASM	1	2784
'CADE	5	ATESA	ATESA	1	623
'CADE	6	CAJA RURAL	CAJA_RURAL	0	0000000000
'CADE	7	ABBA HOTELES	ABBA_HOTELES	1	3814
'CADE	8	SIERRA DE FRANCIA	SIERRA_DE_FRANCIA	1	4675
'CADE	10	HALCON	HALCON	1	249
'CADE	20	ECUADOR	ECUADOR	1	599
'CADE	30	GROUNDFORCE	GROUNDFORCE	1	846
'CADE	40	AIR EUROPA	AIR_EUROPA	1	543
'CADE	50	CALDERON	CALDERON	1	1530
'CADE	60	MELIA	MELIA	0	2739
'CADE	70	ASM PROPIAS	ASM_PROPIAS	1	NULL
'CADE	80	HALCON VIAGENS	HALCON_VIAGENS	1	3455
'CADE	90	TRAVELPLAN	TRAVELPLAN	1	296
'CADE	100	TUBILLETE	TUBILLETE	1	6541
'CADE	110	GLOBALIA	GLOBALIA	1	477
'CADE	120	HACIENDAS	FAMILY	1	6729
'CADE	130	GEOMOON	GEOMOON	1	NULL
'CADE	140	SANTOS	SANTOS	1	0
'CADE	150	UVE HOTELES	UVE_HOTELES	1	#7158#
'CADE	170	GLOBALIA CORPORATE TRAVEL	GLOBALIA_CORPORATE_TRAVEL	1	#8232#

			
			'Esto habra que pillarlo de algun campo de la tabla TABLAS
			Select Case hoteles("empresa")
				Case 1 'BARCELO
					color_empresa="#FFFFFF"
					
				Case 2 'BE LIVE
					color_empresa="#53565A"
					
				Case 4 'ASM
					'color_empresa="#CE0037"
					'para que el acceso de empleados tenga un color de fondo diferente
					color_empresa="#FFFFFF"
					
				Case 5 'ATESA
					color_empresa="#009A44"
					
				Case 6 'CAJA RURAL
					color_empresa="#FFFFFF"
				
				Case 7 'ABBA HOTELES
					color_empresa="#004851"
				
				Case 8 'SIERRA DE FRANCIA
					color_empresa="#FFFFFF"
				
				Case 10 'HALCON
					color_empresa="#DA291C"
				
				Case 20 'ECUADOR
					color_empresa="#002F6C"
					
				Case 30 'GROUNDFORCE
					color_empresa="#00819C"
					
				Case 40 'AIR EUROPA
					color_empresa="#0072CE"
											
				Case 50 'CALDERON
					color_empresa="#F8030C"
											
				Case 60 'MELIA
					color_empresa="#FFFFFF"
											
				Case 70 'ASM PROPIAS
					color_empresa="#CE0037"

				Case 80 'HALCON VIAGENS
					color_empresa="#9D2235"
					
				Case 90 'TRAVELPLAN
					color_empresa="#F8030C"
				
				Case 100 'TUBILLETE
					color_empresa="#1D428A"
				
				Case 110 'GLOBALIA
					color_empresa="#00386B"

				Case 130 'GEOMOON
					'color_empresa="#FE5000"
					color_empresa="#006775" 'verde oscuro
					color_empresa="#009BB1" 'verde claro
				Case 150 'UVE HOTELES
					color_empresa="#303E48"																																				
				Case Else
					color_empresa="#FFFFFF" 
			End Select
			session("color_asociado_empresa")=color_empresa	
				

	
	session("numero_articulos")=0
	set administrador=Server.CreateObject("ADODB.Recordset")
				
	sql="Select * from V_EMPRESAS_CENTRAL"
	'sql=sql & " where CODIGO_AD=" & hotel_seleccionado
	sql=sql & " where CODIGO_AD like '%#" & hotel_seleccionado & "#%'"
			
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
		
end if
		
		
		
hoteles.close
set hoteles = Nothing

entorno_servidor="PRUEBAS"
if Request.ServerVariables("SERVER_NAME")<>"carrito.globalia-artesgraficas.com" then
		'ENTORNO PRUEBAS
		entorno_servidor="PRUEBAS"
	else
		'ENTORNO REAL
		entorno_servidor="REAL"
end if		
	
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

<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />

<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>


<script type="text/javascript">


//para cuando se muestra un popup general antes de los de cada empresa...


function redirigir(esAdmin, entorno, empresa, usuario)
{
		abrirArticulos(esAdmin, entorno)
}



 
function abrirArticulos(esAdmin, entorno) {
    //alert('Administradora:' + esAdmin);
	
	if (entorno=='REAL')
		{
	    var dir = 'https://carrito.globalia-artesgraficas.com/GAG/'; // PROD --              
		}
	  else
	  	{
		var dir = 'http://192.168.153.132/asp/carrito_imprenta_GAG_BOOT/GAG/'; // DES --                   
		}
		
    
    
        location.href = dir + 'Lista_Articulos_GAG.asp'
        
 }// abrirArticulos --
  
</script>


</head>


<BODY onload="redirigir('<%=administrador_central%>', '<%=entorno_servidor%>', <%=session("usuario_codigo_empresa")%>, '<%=hotel_seleccionado%>')">

</body>
</html>

