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

	'para que no se entre como administrador desde los clientes
	session("usuario_admin")=""
	
	hotel_seleccionado=Request.Form("cmbhoteles")
	contrasenna_seleccionada=Request.Form("txtcontrasenna")
	empresa_entrada=Request.Form("ocultoempresa")
	'response.write("<br>control: " & hotel_seleccionado)
		
	'******************************
	' tendr� que controlar Pedro como pasa este parametro 
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
	mostrar_aviso_popup=""
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
			session("usuario_pais")=hoteles("pais")
			session("usuario_trato_especial")=hoteles("idtratoespecial")
			session("usuario_idsap")=hoteles("idsap")
			
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
			
			'si es una oficina de ASM-GLS, de tipo REDYSER y todavia no ha hecho pedidos
			'TIENE DERECHO AL DESCUENTO DEL PRIMER PEDIDO
			if session("usuario_codigo_empresa")=4 and session("usuario_trato_especial")=1 then
				if session("usuario_primer_pedido")="SI" then
					session("usuario_derecho_primer_pedido")="SI"
					mostrar_aviso_popup="REDYSER"
				end if
			end if
						
			primer_pedido.close	
			set primer_pedido = Nothing
	
	
			'COMO TODAVIA NO ESTA OPERATIVO LO DEL PRIMER PEDIDO AL 50%, LAS PONEMOS DESACTIVADAS AL ENTRAR
			'****************
			'ya esta operativo desde el 13 de noviembre del 2017
			'session("usuario_primer_pedido")="NO"
			'session("usuario_derecho_primer_pedido")="NO"

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
		
	
	'response.write("sucursal: " & codigo_sucursal & "<br>Usuario: " & usuario & "<br>Contrase�a: " & contrasenna)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=validar_title%></title>

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


function moverse(sino, administrador_central, carpeta, empresa, mostrar_aviso_popup)	{
	//alert('validamos 2..3..4..5..6')
	//alert(sino)
	//vemos si hay datos de esa sucursal, es decir, si es correcta		
	cadena_carpeta=''
	cadena_empresa=''
	
	document.getElementById('ocultomostrar_aviso_popup').value=mostrar_aviso_popup

	

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
	
	if (empresa==8) { //mancumunidad pe�a de francia		
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
	
	//la empresa globalia corporate travel
	if (empresa==170) 
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

		//para atesa y gls mostramos el mensaje de cerrado el 24 y 31 de diciembre
		
		
		


			if (empresa==4)  
				{ //ASM			
				//document.getElementById('ocultoruta').value=ruta_redireccion	
				document.getElementById('ocultoruta').value=ruta_redireccion	
				if ((('<%=session("usuario_tipo")%>'=='AGENCIA') || ('<%=session("usuario_tipo")%>'=='ARRASTRES')) && ('<%=mostrar_aviso_popup%>'!='REDYSER'))
					{
					$("#pantalla_popup_asm_pago_tarjeta").modal("show");  	
					}
				  else
					{
					//$("#pantalla_popup_asm_nuevo_gestor").modal("show");
					
					if (document.getElementById('ocultomostrar_aviso_popup').value=='REDYSER')	
						{
						$("#pantalla_popup_asm_descuento_redyser").modal("show");  
						}
					  else
						{
						if ('<%=session("usuario_tipo")%>'=='GLS PROPIA')
							{
							$("#pantalla_popup_gls_direccion_envio").modal("show");
							}
						  else
						  	{
							location.href=document.getElementById('ocultoruta').value
							}
						}
						
					}


				}
			  else
				{
				//los clientes de atesa
				if (empresa==5)
					{
					//document.getElementById('ocultoruta').value=ruta_redireccion	
					location.href=ruta_redireccion
					}
				//los clientes de gag con globalia... 
				//  be live (2), halcon(10), ecuador(20), groundforce(30), air europa(40), calderon(50), halcon viagens(80), 
				//  travelplan(90), tubillete(100), globalia(110), geomoon(130), globalia corporate travel(170)
				//if ((empresa==2)||(empresa==10)||(empresa==20)||(empresa==30)||(empresa==40)||(empresa==50)||(empresa==80)||(empresa==90)||(empresa==100)||(empresa==110)||(empresa==170))	
				if ((empresa==10)||(empresa==20))	
					{
					//location.href=ruta_redireccion
					document.getElementById('ocultoruta').value=ruta_redireccion
					$("#pantalla_popup_hal_vec_merchan").modal("show");
					//ya no mostramos el popup en GAG
					//document.getElementById('ocultoruta').value=ruta_redireccion	
					//$("#pantalla_popup_globalbag").modal("show");  	
					}
				  else
				  	{
					if (empresa!=5)
						{
						location.href=ruta_redireccion
						}
					}
				}

	    
		
			//location.href=ruta_redireccion
	    }
		else {
		    //alert('Contrase�a Incorrecta, vuelva a Seleccionar el Usuario e introduzca su Contrase�a de acceso')			
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

<script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>
<script type="text/javascript" src="plugins/smtpjs/smtp.js"></script>


</head>

<!--  al cargarse la pagina, aparte de construirse en funcion del mayorista al que se accede, se ejecuta la funcion moverse ya comentada -->

<body onload="moverse('<%=valido%>','<%=administrador_central%>','<%=session("usuario_carpeta")%>',<%=empresa_entrada%>, '<%=mostrar_aviso_popup%>')" style="background-color:<%=session("color_asociado_empresa")%>">

<!--pantalla con el popup a mostrar en ASM-->
<div class="modal fade" id="pantalla_popup_asm_pago_tarjeta" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="popup/GLS_Pasarela_Pago_r.jpg" border="0">
			</div>
		</div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=validar_ventana_mensajes_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 

<div class="modal fade" id="pantalla_popup_asm_descuento_redyser" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="popup/Redyser_r.jpg" border="0">
			</div>
		</div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=validar_ventana_mensajes_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 

<div class="modal fade" id="pantalla_popup_asm_seguimiento" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="popup/GLS_Seguimiento_r.jpg" border="0">
			</div>
		</div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=validar_ventana_mensajes_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 
  

<div class="modal fade" id="pantalla_popup_asm_nuevo_gestor" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="popup/GLS_Gestor_Cuenta_r.jpg" border="0">
			</div>
		</div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=validar_ventana_mensajes_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 

<div class="modal fade" id="pantalla_popup_gls_direccion_envio" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="popup/GLS_Direccion_Envio_r.jpg" border="0">
			</div>
		</div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=validar_ventana_mensajes_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 

<div class="modal fade" id="pantalla_popup_globalbag" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md" style="width:850px;">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="popup/Email_Globalbag/GLOBALBAG_HORIZONTAL_r.jpg" border="0">
				<br />
			</div>
		</div>	
        <div class="modal-footer">  
				<div class="text-right">
					<button type="button" class="btn btn-primary" id="globalbag_web"
						data-toggle="popover"
						data-placement="top"
						data-trigger="hover"
						data-content="Acceder a la Web globalbag.es para mas informaci&oacute;n"
						data-original-title=""
						>
						<i class="fas fa-search"></i>&nbsp;&nbsp;VISITAR WEB
					</button>
					<button type="button" class="btn btn-primary" id="globalbag_plantilla"
						data-toggle="popover"
						data-placement="top"
						data-trigger="hover"
						data-content="Descargar Plantilla para Realizar Pedidos"
						data-original-title=""
						>
						<i class="fas fa-download"></i>&nbsp;&nbsp;PLANTILLA SOLICITUD
					</button>
					<!--
					<button type="button" class="btn btn-primary" id="globalbag_email"
						data-toggle="popover"
						data-placement="top"
						data-trigger="hover"
						data-content="Enviar Informaci&oacute;n por Email"
						data-original-title=""
						>
						<i class="far fa-envelope"></i>&nbsp;&nbsp;COMPARTIR
					</button>
					-->
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
				<img class="img-responsive" src="popup/Merchandising_HAL_VEC_r.jpg" border="0">
			</div>
		</div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 


<div class="modal fade" id="pantalla_popup_aviso_navidades" data-keyboard="false" data-backdrop="static">	
    <div class="modal-dialog modal-md"  style="width:750px;">	  
      <div class="modal-content">	    
        <div class="container-fluid">
			<div class="col-md-12" align="center">
				<img class="img-responsive" src="popup/Aviso_Navidades_r.jpg" border="0">
			</div>
		</div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=validar_ventana_mensajes_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div> 


<!--capa para enviar el email -->
  <div class="modal fade" id="pantalla_emails">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h3 class="modal-title" id="cabecera_pantalla_emails">Enviar Mensajes</h3>	    
        </div>	    
        <div class="container-fluid" id="body_emails">
		
				<br />
				   Por favor, indique su cuenta de mail y la cuenta de email destino
				
				<form role="form" method="post" id="frmenvios_email">
					<div class="row">
						<div class="col-sm-6 form-group">
							<label for="name">
								Email de Origen:</label>
							<input type="text" class="form-control" id="txtemail_origen" name="txtemail_origen" required="">
						</div>
						<div class="col-sm-6 form-group">
							<label for="email">
								Email Destino:</label>
							<input type="email" class="form-control" id="txtemail_destino" name="txtemail_destino" required="">
						</div>
					</div>
				</form>
		</div>	
        <div class="modal-footer">                  
          <p>
		  <button type="button" class="btn btn-primary" id="enviar_email"
						data-toggle="popover"
						data-placement="top"
						data-trigger="hover"
						data-content="Enviar Informaci&oacute;n por Email"
						data-original-title=""
						>
						<i class="far fa-envelope"></i>&nbsp;&nbsp;ENVIAR
					</button>
		  <button type="button" class="btn btn-default" data-dismiss="modal"><%=validar_ventana_mensajes_boton_cerrar%></button>
		  </p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa enviar mail -->


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
<input type="hidden" id="ocultomostrar_aviso_popup" name="ocultomostrar_aviso_popup" value="" />

<script language="javascript">
$('#pantalla_avisos').on('hidden.bs.modal', function (e) {
  location.href = 'Login_' + cadena_regreso + '.asp'
})




$('#pantalla_popup_gls_direccion_envio').on('hidden.bs.modal', function (e) {
  location.href=document.getElementById('ocultoruta').value	//para que se dirija a la pagina despues de cerrar el popup
})

$('#pantalla_popup_asm_pago_tarjeta').on('hidden.bs.modal', function (e) {
  location.href=document.getElementById('ocultoruta').value	//para que se dirija a la pagina despues de cerrar el popup
})

$('#pantalla_popup_asm_descuento_redyser').on('hidden.bs.modal', function (e) {
  location.href=document.getElementById('ocultoruta').value	//para que se dirija a la pagina despues de cerrar el popup
})

$('#pantalla_popup_asm_seguimiento').on('hidden.bs.modal', function (e) {
  location.href=document.getElementById('ocultoruta').value	//para que se dirija a la pagina despues de cerrar el popup
})

/*
$('#pantalla_popup_globalbag').on('hidden.bs.modal', function (e) {
	if ((<%=empresa_entrada%>==10)|| (<%=empresa_entrada%>==20)) //para halcon y ecuador mostramos el aviso de merchan
		{
		$("#pantalla_popup_hal_vec_merchan").modal("show");
		}
	  else
	  	{
		  location.href=document.getElementById('ocultoruta').value	//para que se dirija a la pagina despues de cerrar el popup
	  	}
})
*/

$('#pantalla_popup_hal_vec_merchan').on('hidden.bs.modal', function (e) {
  //console.log('redirigiendo: ' + document.getElementById('ocultoruta').value)
  location.href=document.getElementById('ocultoruta').value	//para que se dirija a la pagina despues de cerrar el popup
})

$('#pantalla_popup_aviso_navidades').on('hidden.bs.modal', function (e) {
if (<%=empresa_entrada%>==4) //si es asm sigue sacando mas popup
	{
	if ((('<%=session("usuario_tipo")%>'=='AGENCIA') || ('<%=session("usuario_tipo")%>'=='ARRASTRES')) && ('<%=mostrar_aviso_popup%>'!='REDYSER'))
		{
		$("#pantalla_popup_asm_pago_tarjeta").modal("show");  	
		}
	  else
		{
		//$("#pantalla_popup_asm_nuevo_gestor").modal("show");
		
		if (document.getElementById('ocultomostrar_aviso_popup').value=='REDYSER')	
			{
			$("#pantalla_popup_asm_descuento_redyser").modal("show");  
			}
		  else
			{
			location.href=document.getElementById('ocultoruta').value
			}
		  	
		}
	}
  else
  	{
	  location.href=document.getElementById('ocultoruta').value	//para que se dirija a la pagina despues de cerrar el popup
	 }
})

//cuando se cierre este popup se abre otro
$('#pantalla_popup_asm_nuevo_gestor').on('hidden.bs.modal', function (e) {
	if (document.getElementById('ocultomostrar_aviso_popup').value=='REDYSER')	
		{
		$("#pantalla_popup_asm_descuento_redyser").modal("show");  
		}
	  else
		{
		if (('<%=session("usuario_tipo")%>'=='AGENCIA')|| ('<%=session("usuario_tipo")%>'=='ARRASTRES'))
			{
			location.href=document.getElementById('ocultoruta').value
			}
		  else
		  	{
			$("#pantalla_popup_asm_seguimiento").modal("show");  
			}
		}

})

$('#globalbag_web').on('click', function (e) {
  window.open('http://www.globalbag.es')
})
$('#globalbag_plantilla').on('click', function (e) {
   window.open('http://carrito.globalia-artesgraficas.com/popup/Email_Globalbag/Plantilla_Globalbag.xlsx')
})
$('#globalbag_email').on('click', function (e) {
	$('#pantalla_emails').modal('show')
})




$(document).ready(function () {
	
	//para que se configuren los popover-titles...
	//j$('[data-toggle="popover"]').popover({html:true});
	
	$('[data-toggle="popover"]').popover({html:true, container: 'body'});
	
});
</script>



</body>

</html>
