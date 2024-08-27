<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<%
		dim hoteles

		'para controlar el popup de asm
		'diferencia_dias=datediff("d",date(),"31-12-2014")
		diferencia_dias=3

		
		hotel_seleccionado=Request.Form("cmbhoteles")
		contrasenna_seleccionada=Request.Form("txtcontrasenna")
		empresa_entrada=Request.Form("ocultoempresa")
		
		set hoteles=Server.CreateObject("ADODB.Recordset")
		
		sql="Select hoteles.*, empresas.empresa as nombre_empresa, empresas.carpeta  from hoteles"
		sql=sql & " inner join empresas"
		sql=sql & " on hoteles.empresa=empresas.id"
		sql=sql & " where hoteles.id=" & hotel_seleccionado
		
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
				
				session("numero_articulos")=0
				set administrador=Server.CreateObject("ADODB.Recordset")
				
				sql="Select * from EMPRESAS_CENTRAL"
				sql=sql & " where CODIGO_HOTEL=" & hotel_seleccionado
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
<HTML  xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>Validacion Acceso</TITLE>
<META NAME="Generator" CONTENT="Microsoft FrontPage 4.0">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">
<link rel="stylesheet" type="text/css" href="ASM/popups/ventanas-modales.css">
<script language="javascript">


	function moverse(sino, administrador_central, carpeta, empresa)
	{
		//alert('validamos 2..3..4..5..6')
		//alert(sino)
		//vemos si hay datos de esa sucursal, es decir, si es correcta
		
		cadena_carpeta=''
		cadena_empresa=''
		if (empresa==5) //atesa
			{
			cadena_carpeta='ATESA/'
			cadena_empresa='_Atesa'
			}
		if (empresa==4) //asm
			{
			cadena_carpeta='ASM/'
			cadena_empresa='_Asm'
			
			}
		if (empresa==8) //mancumunidad peña de francia
			{
			cadena_carpeta='SIERRA_FRANCIA/'
			cadena_empresa='_Sierra_Francia'
			
			}
		
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
				

				//para mostrar popups antes de entrar sugun la empresa...
				
				if (empresa==4)
					{
					document.getElementById('ocultoruta').value=ruta_redireccion	
					arrancar(<%=diferencia_dias%>)  	
					//location.href=ruta_redireccion + '?PRIMERA_ENTRADA=SI'
					}
				 else
				 	{
					location.href=ruta_redireccion
					}

				
				//window.close()
				//document.validarimp.submit()
				//cuando hay popups hay que quitarlo
				//location.href=ruta_redireccion
			}
		  else
			{
			alert('Contraseña Incorrecta, vuelva a Seleccionar el Usuario e introduzca su Contraseña de acceso')
			
			if (cadena_empresa=='')
				{
				cadena_empresa='_' + carpeta
				}
			
			location.href = 'Login' + cadena_empresa.toUpperCase() + '.asp'
			}
			
			
			
			
	}
	
function arrancar(dias)
{
			//para que solo se muestre el popup dentro de la fecha limite
			if (dias>=0)
				{
				mostrar_capas('capa_asm')	
				}
			  else
			  	{
				//cuando se ha pasado la fecha, para que entre en el carrito
				location.href=document.getElementById('ocultoruta').value
				}
}
</script>

<script src="DD_roundies_0_0_2a.js">
//para redondear esquinas en el internet explorer
</script>


<script language="javascript">
//para mostrar las capas de la plantilla de los acompañantes
function mostrar_capas(capa)
{
	//redondear capa para el internet explorer
	DD_roundies.addRule('#contenedorr3', '20px');
	document.getElementById('capa_opaca').style.visibility='visible'
	document.getElementById(capa).style.visibility='visible';
	
	
	
}

function cerrar_capas(capa)
{	
	document.getElementById('capa_opaca').style.visibility='hidden';
	document.getElementById(capa).style.visibility='hidden';
	
	location.href=document.getElementById('ocultoruta').value
	
	
}
</script>

<style>
/*--estilos relacionados con las capas para las plantillas de personalizacion de articulos*/
.aviso {
	font-family: Verdana, Arial, Helvetica, sans-serif;
  	font-size: 18px;
  	color: #000000;
  	text-align: center;
	background-color:#33FF33
}  	

#contenedorr3 { 


/* Otros estilos */ 
border:1px solid #333;
background:#eee;
padding:7px;
width:460px;

margin: 30px auto;

-moz-border-radius: 20px; /* Firefox */
-webkit-border-radius: 20px; /* Google Chrome y Safari */
border-radius: 20px; /* CSS3 (Opera 10.5, IE 9 y estándar a ser soportado por todos los futuros navegadores) */
/*
behavior:url(border-radius.htc);/* IE 8.*/

}


</style>


</HEAD>

<!--
  al cargarse la pagina, aparte de construirse en funcion del
 mayorista al que se accede, se ejecuta la funcion moverse
 ya comentada
-->

<BODY onload="moverse('<%=valido%>','<%=administrador_central%>','<%=session("usuario_carpeta")%>',<%=empresa_entrada%>)">

<!-- capa opaca para que no deje pulsar nada salvo lo que salga delante (se comporte de forma modal)-->
<div id="capa_opaca" style="visibility:hidden;background-color:#000000;position:absolute;top:0px;left:0px;width:105%;min-height:110%;z-index:5;filter:alpha(opacity=50);-moz-opacity:.5;opacity:.5">
</div>

<!-- capa con la informacion a mostrar por encima del carrito-->
<div id="capa_asm" style="visibility:hidden;z-index:6;position:absolute; height:525px;left:270px;top:10px">
		<div id="contenedorr3" class="aviso">
			<div style="z-index:10" title="Cerrar" align="right"><a href="#" onClick="cerrar_capas('capa_asm')"><img src="ASM/popups/images/btn_cerrar.png" border="0"></a></div>
			<div style="z-index:11" align="center">
				<a href="ASM/popups/Images/Imagen_Popup.jpg" target="_blank">
				<img src="ASM/popups/images/Imagen_Popup_Miniatura.jpg" title="Pulse Para Ampliar la Imagen de Esta Oferta" border="0" /></a>
			</div>
			<br/>
			
		</div>
</div>
<!--*******************************************************-->





<div id="capa_asm_ant" style="visibility:hidden;background-color:#FFFFFF;position:absolute;top:60px;left:270px;width:460px;height:515px;z-index:9;">
		<div style="z-index:10" title="Cerrar" align="right"><a href="#" onClick="cerrar_capas('capa_guias_y_multisobres')"><img src="ASM/popups/images/btn_cerrar.png" border="0"></a></div>
		<div style="z-index:11" align="center">
			<a href="ASM/popups/Images/Agenda_2015_promocion.jpg" target="_blank">
				<img src="ASM/popups/images/Agenda_2015_promocion_1.jpg" title="Pulse Para Ampliar la Imagen de Esta Oferta" /></a>
		</div>
</div>


<input type="hidden" id="ocultoruta" name="ocultoruta" value="" />
</BODY>

</HTML>
