<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<!--#include file="../Conexion.inc"-->

<%
'****************************************************************************
'****************************************************************************
' OJO, PORQUE TODO LO QUE SE CAMBIE AQUI, TAMBIEN PUEDE AFECTAR A LA PAGINA 
' DE VALIDACION DEL DIRECTORIO RAIZ, VALIDAR.ASP.. ESA PAGINA ES LA QUE HACE
' LA VALIDACION de usuarios del carrito no la validacion de los usuarios del active directori
' como hace esta..... ASI QUE PUEDE SER QUE TAMBIEN SE TENGA QUE PONER EL CAMBIO
' EN ESA OTRA PAGINA
'***************************************************************************
'****************************************************************************
		

session("cliente") = Request.Form("ocultoCliente")
session("usuario_directorio_activo") = Request.Form("ocultoUsuario")


'response.write("<br><br>usuario: " & session("usuario_directorio_activo"))
'response.write("<br><br>cliente: " & session("cliente"))

hotel_seleccionado = session("cliente")
'response.write("<br> Usuario :"+session("usuario_cod"))
'hotel_seleccionado=6541

'hotel_seleccionado=6235 '031 HALCON propia GLOBALBAG
'hotel_seleccionado=5508 'C21 ECUADOR franquicia GLOBALBAG
'hotel_seleccionado=6059 'Q20 HALCON franquicia GLOBALBAG

'hotel_seleccionado=8600 'R35 HALCON franquicia
'hotel_seleccionado=6214 '001 HALCON propia
'hotel_seleccionado=5656 'K09 ECUADOR franquicia

	
	'hotel_seleccionado=Request.Form("cmbhoteles")
	'contrasenna_seleccionada=Request.Form("txtcontrasenna")
	'empresa_entrada=Request.Form("ocultoempresa")
	

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

'empresa_entrada = Request.Form("ocultoempresa") ' eliminado, ahora se lee del dataset. no viene del formualrio --


perfil_usuario=""
if session("usuario_directorio_activo")<>"" then
	set perfil=Server.CreateObject("ADODB.Recordset")
		
	sql="SELECT PERFIL FROM [192.168.156.175\SERVERSQL].GAG.dbo.USUARIOS"
	sql=sql & " WHERE USUARIO=" & session("usuario_directorio_activo")
	sql=sql & " AND IDCLIENTE=" & session("cliente")
	'response.write("<br>perfil de usuario: " & sql)		
	with perfil
		.ActiveConnection=connimprenta
		.Source=sql
		.Open
	end with   
	if not perfil.eof then
		perfil_usuario=perfil("PERFIL")
	end if
	
	perfil.close
	set perfil=nothing
	
end if

session("perfil_usuario_directorio_activo")= "" & perfil_usuario

'response.write("<br>perfil de usuario: " & session("perfil_usuario_directorio_activo"))


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
					color_empresa="#CE0037"
					
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
					
				Case 240 'FRANQUICIAS HALCON
					color_empresa="#DA291C"
				
				Case 20 'ECUADOR
					color_empresa="#002F6C"
				
				Case 250 'FRANQUICIAS ECUADOR
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
connimprenta.close
set hoteles = Nothing
set connimprenta=Nothing

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

if session("usuario_tipo")="FRANQUICIA" then
		comunicado_globalbag="../popup/Globalbag/Comunicado_Globalbag_Franquicias.pdf"
	  else
	  	comunicado_globalbag="../popup/Globalbag/Comunicado_Globalbag_Propias.pdf"
	end if
		
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
function verpopup(esAdmin, entorno, empresa){

	$("#pantalla_popup_villalar").modal("show");
}


function verpopup_2(esAdmin, entorno, empresa, usuario){
	//los clientes de gag con globalia... 
	//  be live (2), halcon(10), ecuador(20), groundforce(30), air europa(40), calderon(50), halcon viagens(80), 
	//  travelplan(90), tubillete(100), globalia(110), geomoon(130), globalia corporate travel(170)
				
	
	
	//if ((empresa==2)||(empresa==10)||(empresa==20)||(empresa==30)||(empresa==40)||(empresa==50)||(empresa==80)||(empresa==90)||(empresa==100)||(empresa==110)||(empresa==170))	
	
	
	if ((empresa==10)||(empresa==20)||(empresa==240)||(empresa==250))	
		{
		
			//$("#pantalla_popup_globalbag").modal("show");  	
			$("#pantalla_popup_hal-ecu_globalbag_merchan").modal("show");
		}
	  else
	  	{
		if (empresa==40)
			{
			$("#pantalla_popup_air_europa_unidades_pedido").modal("show");
			}
		  else
		  	{
			abrirArticulos(esAdmin, entorno)
			}
		}
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
		
    
    
    if (esAdmin == 'SI')
        location.href = dir+'Lista_Articulos_Gag_Central_Admin.asp' 
        
    else
        location.href = dir+'Lista_Articulos_GAG.asp'
        
 }// abrirArticulos --
  
</script>


</head>



<BODY onload="verpopup_2('<%=administrador_central%>', '<%=entorno_servidor%>', <%=session("usuario_codigo_empresa")%>, '<%=hotel_seleccionado%>')">

<!--
<body onload="moverse_popup_navidad()" style="background-color:<%=session("color_asociado_empresa")%>">
-->

<div class="modal fade" id="pantalla_popup_aviso_navidad" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md" style="width:850px;">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="../popup/Aviso_Navidad_2019_r.jpg" border="0">
				<br />
			</div>
		</div>	
        <div class="modal-footer">  
				<div class="text-right">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
				</div>
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 

<div class="modal fade" id="pantalla_popup_hal-ecu_globalbag_merchan" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="../popup/HAL_ECU_Maletas_Merchan_r.jpg" border="0">
			</div>
		</div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 

<div class="modal fade" id="pantalla_popup_globalbag" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md" style="width:850px;">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<a href="<%=comunicado_globalbag%>" target="_blank">
				<img class="img-responsive" src="../popup/Globalbag/Comunicado_Maletas.jpg" border="0">
				</a>
				<br />
			</div>
		</div>	
        <div class="modal-footer">  
				<div class="text-right">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
				</div>
			
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 
  
   <div class="modal fade" id="pantalla_popup_hal_vec_merchan" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="../popup/Merchandising_HAL_VEC_r.jpg" border="0">
			</div>
		</div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 
  
  
  
  <div class="modal fade" id="pantalla_popup_villalar" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md" style="width:850px;">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="../popup/Aviso_Villalar_r.jpg" border="0">
				<br />
			</div>
		</div>	
        <div class="modal-footer">  
				<div class="text-right">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
				</div>
			
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 


  <div class="modal fade" id="pantalla_popup_air_europa_unidades_pedido" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md" style="width:850px;">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="../popup/Air_Europa_Unidades_de_Pedido_r.jpg" border="0">
				<br />
			</div>
		</div>	
        <div class="modal-footer">  
				<div class="text-right">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
				</div>
			
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 
  
  
</body>

<script language="javascript">

/*
$('#pantalla_popup_globalbag').on('hidden.bs.modal', function (e) {
  abrirArticulos('<%=administrador_central%>', '<%=entorno_servidor%>')
})
*/
function moverse_popup_navidad()
{
	$("#pantalla_popup_aviso_navidad").modal("show");
}

$('#pantalla_popup_aviso_navidad').on('hidden.bs.modal', function (e) {
  verpopup_2('<%=administrador_central%>', '<%=entorno_servidor%>', <%=session("usuario_codigo_empresa")%>, '<%=hotel_seleccionado%>')
})

$('#pantalla_popup_hal-ecu_globalbag_merchan').on('hidden.bs.modal', function (e) {
  $("#pantalla_popup_globalbag").modal("show");  
})

$('#pantalla_popup_globalbag').on('hidden.bs.modal', function (e) {
	abrirArticulos('<%=administrador_central%>', '<%=entorno_servidor%>')	//para que se dirija a la pagina despues de cerrar el popup
})

$('#pantalla_popup_hal_vec_merchan').on('hidden.bs.modal', function (e) {
  abrirArticulos('<%=administrador_central%>', '<%=entorno_servidor%>')
})

$('#pantalla_popup_air_europa_unidades_pedido').on('hidden.bs.modal', function (e) {
  abrirArticulos('<%=administrador_central%>', '<%=entorno_servidor%>')
})

$('#pantalla_popup_villalar').on('hidden.bs.modal', function (e) {
  verpopup_2('<%=administrador_central%>', '<%=entorno_servidor%>', <%=session("usuario_codigo_empresa")%>)
})




</script>
</html>

