<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%

    dim clientes

	'para que no se entre como administrador desde los clientes
	session("usuario_admin")=""
	
	'hotel_seleccionado=Request.Form("cmbhoteles")
	'contrasenna_seleccionada=Request.Form("txtcontrasenna")
	'empresa_entrada=Request.Form("ocultoempresa")
	
	usuario_seleccionado=""
	valido="NO"
	usuario_login=Request.Form("txtusuario")
	contrasenna_seleccionada=Request.Form("txtcontrasenna")
	empresa_entrada=Request.Form("cmbempresas")
	
	set claves=Server.CreateObject("ADODB.Recordset")
		
	sql="SELECT * FROM USUARIOS"
	sql=sql & " WHERE USUARIO='" & usuario_login & "'"
	sql=sql & " AND CONTRASENNA='" & contrasenna_seleccionada & "'"
	sql=sql & " AND MODO='ADMIN_AVORIS'"
		
	'response.write("<br>...administrador avoris: " & sql)
		
	with claves
		.ActiveConnection=connimprenta
		.Source=sql
		.Open
	end with
	
	entrada_administrador="NO"
	if not claves.eof then
		entrada_administrador="SI"
		Select Case empresa_entrada
					Case 10 'HALCON
							usuario_seleccionado=249

					Case 20 'ECUADOR
							usuario_seleccionado=599
							
					Case 80 'HALCON VIAGENS
							usuario_seleccionado=3455
												
					Case 90 'TRAVELPLAN
							usuario_seleccionado=296
							
					Case 210 'MARSOL
							usuario_seleccionado=1929
							
					Case 130 'GEOMOON
							usuario_seleccionado=2497
							
					Case 170 'GLOBALIA CORPORATE TRAVEL
							usuario_seleccionado=8232
							
					Case 230 'AVORIS (Globalia Autocares)
							usuario_seleccionado=9873
		End Select
	end if
	claves.close
	set claves=nothing
		
		
	if entrada_administrador="SI" then
			set clientes=Server.CreateObject("ADODB.Recordset")
				
			sql="SELECT V_CLIENTES.*, V_empresas.empresa as nombre_empresa, V_empresas.carpeta  FROM V_CLIENTES"
			sql=sql & " JOIN V_empresas ON V_CLIENTES.empresa=V_empresas.id"
			sql=sql & " WHERE V_CLIENTES.id=" & usuario_seleccionado
				
			'response.write("<br>...DATOS CLIENTE: " & sql)
				
			with clientes
				.ActiveConnection=connimprenta
				.Source=sql
				.Open
			end with
		
			valido=""
			administrador_central="NO"
			administrador_empresa=""
			mostrar_aviso_popup=""
			if not clientes.eof then
				contrasenna_hotel=clientes("contrasenna")
					
				session("usuario_carpeta")=clientes("carpeta")
						
						
				
					valido="SI"
					session("usuario")=usuario_seleccionado
					session("usuario_codigo_externo")=clientes("codigo_externo")
					session("usuario_nombre")=clientes("nombre")
					session("usuario_direccion")=clientes("direccion")
					session("usuario_poblacion")=clientes("poblacion")
					session("usuario_cp")=clientes("cp")
					session("usuario_provincia")=clientes("provincia")
					session("usuario_telefono")=clientes("telefono")
					session("usuario_fax")=clientes("fax")
					session("usuario_pedido_minimo_sin_compromiso")=clientes("pedido_minimo_sin_compromiso")
					session("usuario_pedido_minimo_con_compromiso")=clientes("pedido_minimo_con_compromiso")
					session("usuario_empresa")=clientes("nombre_empresa")
					session("usuario_codigo_empresa")=clientes("empresa")
					session("usuario_marca")=clientes("marca")
					session("usuario_tipo")=clientes("tipo")
					session("usuario_requiere_autorizacion")=clientes("requiere_autorizacion")
					'session("usuario_directorio_activo")=usuario_directorio_activo
					session("usuario_fecha_alta")=clientes("fecha_alta")
					session("usuario_pais")=clientes("pais")
					session("usuario_trato_especial")=clientes("idtratoespecial")
					session("usuario_idsap")=clientes("idsap")
					
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
					Select Case clientes("empresa")
						Case 1 'BARCELO
							color_empresa="#FFFFFF"
							
						Case 2 'BE LIVE
							color_empresa="#53565A"
						
						'ya quitaremos EL COLOR DE ASM-GLS	
						'Case 4 'ASM
						'	color_empresa="#CE0037"
							
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
													
						'Case 70 'ASM PROPIAS
						'	color_empresa="#CE0037"
		
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
							'color_empresa="#009BB1" 'verde claro
							
						
						Case 150 'UVE HOTELES
							color_empresa="#303E48"
																																																						
						Case Else
							color_empresa="#FFFFFF" 
					End Select
					
					session("color_asociado_empresa")=color_empresa	
					
					session("seleccion_asm_gls")=""
						
					session("numero_articulos")=0
					
					
					
					
					
					set administrador=Server.CreateObject("ADODB.Recordset")
						
					'sql="Select * FROM V_EMPRESAS_CENTRAL"
					'sql=sql & " where CODIGO_AD=" & usuario_seleccionado
					'2016_09_21 para que asm pueda tener 2 oficinas administradoras, una para controlar articulos y pedidos
					'            y otra solo para ver la lista de articulos, precios y stocks
					sql="Select * FROM V_EMPRESAS_CENTRAL"
					sql=sql & " where CODIGO_AD like '%#" & usuario_seleccionado & "#%'"
					sql=sql & " AND EMPRESA=" & empresa_entrada
						
					'response.write("<br>....OFICINAS ADMINISTRADORAS: " & sql)
						
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
			clientes.close		
			set clientes = Nothing
	end if ' entrada_administrador=si
		
	

	connimprenta.close
	set connimprenta=Nothing
		
	
	
	if session("usuario_tipo")="FRANQUICIA" then
		comunicado_globalbag="popup/Globalbag/Comunicado_Globalbag_Franquicias.pdf"
	  else
	  	comunicado_globalbag="popup/Globalbag/Comunicado_Globalbag_Propias.pdf"
	end if
	
	'response.write("sucursal: " & codigo_sucursal & "<br>Usuario: " & usuario & "<br>Contraseña: " & contrasenna)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Validacion Acceso</title>

<meta name="Generator" content="Microsoft FrontPage 4.0" />
<meta name="Keywords" content="" />
<meta name="Description" content="" />

	<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="estilo_gls.css" />
	<%end if%>

	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="estilos.css" />
	<link rel="stylesheet" type="text/css" href="carrusel/css/carrusel.css" />


<script type="text/javascript">

var cadena_regreso=''



function moverse(sino, administrador_central, carpeta, empresa, mostrar_aviso_popup, usuario)	{
	//alert('moverse')
	//alert(sino)
	//vemos si hay datos de esa sucursal, es decir, si es correcta		
	cadena_carpeta=''
	cadena_empresa=''
	
	document.getElementById('ocultomostrar_aviso_popup').value=mostrar_aviso_popup

	//$("#pantalla_popup_villalar").modal("show");

	if ((empresa==4) || (empresa==70)) { //asm	y asm propias
		//cadena_carpeta='ASM/'
	    //cadena_empresa='_Asm'			
		cadena_carpeta='GAG/'
	    cadena_empresa='_Gag'			
	}

	if (empresa==5)  {//atesa		
		cadena_carpeta='ATESA/'
		cadena_empresa='_Atesa'
	}
	
	if (empresa==8) { //mancumunidad peña de francia		
		cadena_carpeta='SIERRA_FRANCIA/'
		cadena_empresa='_Sierra_Francia'			
	}

	//los nuevos clientes de gag... 
	//  be live(2), halcon(10), ecuador(20), groundforce(30), air europa(40), calderon(50), halcon viagens(80), travelplan(90), tubillete(100)
	//  globalia (los gsc)(110), geomoon(130), glovalia corporate travel(170), marsol(210), GAG(220), AVORIS (230)
	if ((empresa==2)||(empresa==10)||(empresa==20)||(empresa==30)||(empresa==40)||(empresa==50)||(empresa==80)||(empresa==90)||(empresa==100)
			||(empresa==110)||(empresa==130)||(empresa==170)||(empresa==210)||(empresa==220)||(empresa==230))	{
	    cadena_carpeta='GAG/'
	    cadena_empresa='_Gag'			
	}		

	
	//PARA LA EMPRESA UVE HOTELES
	if (empresa==150) 
		{
		cadena_carpeta='GAG/'
		cadena_empresa='_Gag'			
		}	
	
		
	//alert('llego al sino: ' + sino)
	if (sino=='SI')
		{	
		if (administrador_central=='SI')
			{
		    ruta_redireccion= cadena_carpeta + 'Lista_Articulos' + cadena_empresa + '_Central_Admin.asp'
			}
		  else 
			{
			ruta_redireccion= cadena_carpeta + 'Lista_Articulos' + cadena_empresa + '.asp'
			}

		location.href=ruta_redireccion
	    }
		else {
		    //alert('Contraseña Incorrecta, vuelva a Seleccionar el Usuario e introduzca su Contraseña de acceso')			
			//alert('<%=validar_error_validacion%>')
			
			$("#cabecera_pantalla_avisos").html("Avisos")
			$("#body_avisos").html("<br><br><h4>Usuario o Contraseña Incorrectos, vuelva a intentarlo.<br><br>");
			$("#pantalla_avisos").modal("show");
					
	   }									
}// moverse --
	

</script>

<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>
<script type="text/javascript" src="plugins/smtpjs/smtp.js"></script>


</head>

<!--  al cargarse la pagina, aparte de construirse en funcion del mayorista al que se accede, se ejecuta la funcion moverse ya comentada -->

<body onload="moverse('<%=valido%>','<%=administrador_central%>','<%=session("usuario_carpeta")%>',<%=empresa_entrada%>, '<%=mostrar_aviso_popup%>',  '<%=usuario_seleccionado%>')" style="background-color:<%=session("color_asociado_empresa")%>">


<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->






<input type="hidden" id="ocultoruta" name="ocultoruta" value="" />
<input type="hidden" id="ocultomostrar_aviso_popup" name="ocultomostrar_aviso_popup" value="" />

<script language="javascript">


$('#pantalla_avisos').on('hidden.bs.modal', function (e) {
  location.href = 'Login_Avoris_Admin.asp'
})






$(document).ready(function () {
	
	//para que se configuren los popover-titles...
	//j$('[data-toggle="popover"]').popover({html:true});
	
	$('[data-toggle="popover"]').popover({html:true, container: 'body'});
	
});
</script>



</body>

</html>
