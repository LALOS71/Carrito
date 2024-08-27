<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
'****************************************************************************
'****************************************************************************
' OJO, PORQUE TODO LO QUE SE CAMBIE AQUI, TAMBIEN PUEDE AFECTAR A LA PAGINA 
' QUE ESTA EN GAG/ABRIR_LISTA_ARTICULOS.ASP... ESTA PAGINA ES LA QUE HACE
' LA VALIDACION PERO PARA LOS USUARIOS DEL ACTIVE DIRECTORI.... ASI QUE 
' PUEDE SER QUE TAMBIEN SE TENGA QUE PONER EL CAMBIO EN ESA OTRA PAGINA
'***************************************************************************
'****************************************************************************

    dim hoteles

	
	hotel_seleccionado=Request.Form("cmbhoteles")
	contrasenna_seleccionada=Request.Form("txtcontrasenna")
	empresa_entrada=Request.Form("ocultoempresa")
		
	'******************************
	' tendrá que controlar Pedro como pasa este parametro 
	'para generar la variable de sesion junto con el resto
	usuario_directorio_activo=Request.Form("ocultousuario_directorio_activo")
		
		
	set hoteles=Server.CreateObject("ADODB.Recordset")
		
	sql="SELECT V_CLIENTES.*, V_empresas.empresa as nombre_empresa, V_empresas.carpeta  FROM V_CLIENTES"
	sql=sql & " JOIN V_empresas ON V_CLIENTES.empresa=V_empresas.id"
	sql=sql & " WHERE V_CLIENTES.id=" & hotel_seleccionado
		
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
				
				
		if contrasenna_hotel=contrasenna_seleccionada then
			valido="SI"
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
			session("usuario_directorio_activo")=usuario_directorio_activo
			session("usuario_fecha_alta")=hoteles("fecha_alta")
			
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
			
			session("usuario_derecho_primer_pedido")="NO"
			'si la fecha de alta es posterior a la fecha limite (01/07/2017) y todavia no ha hecho pedidos
			if hoteles("fecha_alta")<>"" then
				if datediff("d", "01/07/2017", hoteles("fecha_alta"))>=0 then
					if session("usuario_primer_pedido")="SI" then
						session("usuario_derecho_primer_pedido")="SI"
					end if
				end if
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
			Select Case hoteles("empresa")
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
					color_empresa="#FE5000"
				
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
			'sql=sql & " where CODIGO_AD=" & hotel_seleccionado
			'2016_09_21 para que asm pueda tener 2 oficinas administradoras, una para controlar articulos y pedidos
			'            y otra solo para ver la lista de articulos, precios y stocks
			sql="Select * FROM V_EMPRESAS_CENTRAL"
			sql=sql & " where CODIGO_AD like '%#" & hotel_seleccionado & "#%'"
			sql=sql & " AND EMPRESA=" & empresa_entrada
				
			'response.write("<br>" & sql)
				
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
	end if
		
		
	
	hoteles.close
	connimprenta.close

	set hoteles = Nothing
	set connimprenta=Nothing
		
	
	'response.write("sucursal: " & codigo_sucursal & "<br>Usuario: " & usuario & "<br>Contraseña: " & contrasenna)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=validar_title%></title>

<meta name="Generator" content="Microsoft FrontPage 4.0" />
<meta name="Keywords" content="" />
<meta name="Description" content="" />

	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="estilos.css" />
	<link rel="stylesheet" type="text/css" href="carrusel/css/carrusel.css" />


<script type="text/javascript">

var cadena_regreso=''


function moverse(sino, administrador_central, carpeta, empresa)	{
	//alert('validamos 2..3..4..5..6')
	//alert(sino)
	//vemos si hay datos de esa sucursal, es decir, si es correcta		
	cadena_carpeta=''
	cadena_empresa=''
	

	

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
	//  halcon(10), ecuador(20), groundforce(30), air europa(40), calderon(50), halcon viagens(80), travelplan(90), tubillete(100)
	if ((empresa==10)||(empresa==20)||(empresa==30)||(empresa==40)||(empresa==50)||(empresa==80)||(empresa==90)||(empresa==100))	{
	    cadena_carpeta='GAG/'
	    cadena_empresa='_Gag'			
	}		

	//pruebo be live en la nueva GAG
	if (empresa==2) 
		{
		cadena_carpeta='GAG/'
		cadena_empresa='_Gag'			
		}	
	
	//la empresa globalia (los gsc)
	if (empresa==110) 
		{
		cadena_carpeta='GAG/'
		cadena_empresa='_Gag'			
		}	

	if (empresa==130) { // Geomoon 6/6/2016 --
	    cadena_carpeta='GAG/'
	    cadena_empresa='_Gag'			
	}
	
	//PARA LA EMPRESA UVE HOTELES
	if (empresa==150) 
		{
		cadena_carpeta='GAG/'
		cadena_empresa='_Gag'			
		}	
	
	if (sino=='SI')	{	
		if (administrador_central=='SI')	{
		    ruta_redireccion= cadena_carpeta + 'Lista_Articulos' + cadena_empresa + '_Central_Admin.asp'
		}
		else {
			ruta_redireccion= cadena_carpeta + 'Lista_Articulos' + cadena_empresa + '.asp'
		}


	    //location.href=ruta_redireccion
	    /****************************
		YA NO HAY POPUP
		if (empresa==4)  
				{ //ASM			
				//if (<%=hotel_seleccionado%>==7089) // para que solo le salga el mensaje a la oficina zzz
				if ('<%=session("usuario_tipo")%>'=='OFICINA') // para que solo le salga a las franquicias
					{
				    document.getElementById('ocultoruta').value=ruta_redireccion	
				    //mostrar_popup('capa_informacion0')
					$("#pantalla_popup").modal("show");  	
			    	//location.href=ruta_redireccion + '?PRIMERA_ENTRADA=SI'
					}
				  else
				  	{
					location.href=ruta_redireccion
					}
        		}
		    else	
				{
			    location.href=ruta_redireccion
	    		}
		*/
			//location.href=ruta_redireccion

			if (empresa==4)  
				{ //ASM			
				document.getElementById('ocultoruta').value=ruta_redireccion	
				$("#pantalla_popup").modal("show");  	
				}
			  else
				{
				location.href=ruta_redireccion
				}


	    
	    }
		else {
		    //alert('Contraseña Incorrecta, vuelva a Seleccionar el Usuario e introduzca su Contraseña de acceso')			
			//alert('<%=validar_error_validacion%>')
			
			$("#cabecera_pantalla_avisos").html("<%=validar_ventana_mensajes_cabecera%>")
			$("#body_avisos").html("<br><br><h4><%=validar_error_validacion%><br><br>");
			$("#pantalla_avisos").modal("show");
					
	        /* if (cadena_empresa=='') {
		        cadena_empresa='_' + carpeta
		        }
	        */
	        //location.href = 'Login_' + carpeta + '.asp'
			cadena_regreso=carpeta
	   }									
}// moverse --
	

</script>

<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>


</head>

<!--  al cargarse la pagina, aparte de construirse en funcion del mayorista al que se accede, se ejecuta la funcion moverse ya comentada -->

<body onload="moverse('<%=valido%>','<%=administrador_central%>','<%=session("usuario_carpeta")%>',<%=empresa_entrada%>)" style="background-color:<%=session("color_asociado_empresa")%>">

<!--pantalla con el popup a mostrar-->
<div class="modal fade" id="pantalla_popup" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="popup/ASM_GLS_r.jpg" border="0">
			</div>
		</div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=validar_ventana_mensajes_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 


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
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=validar_ventana_mensajes_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->






<input type="hidden" id="ocultoruta" name="ocultoruta" value="" />

<script language="javascript">
$('#pantalla_avisos').on('hidden.bs.modal', function (e) {
  location.href = 'Login_' + cadena_regreso + '.asp'
})

$('#pantalla_popup').on('hidden.bs.modal', function (e) {
  location.href=document.getElementById('ocultoruta').value	//para que se dirija a la pagina despues de cerrar el popup
})



</script>


</body>

</html>
