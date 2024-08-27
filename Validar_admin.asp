<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<%
		dim usuarios

		usuario_seleccionado=Request.Form("txtusuario")
		contrasenna_seleccionada=Request.Form("txtcontrasenna")
		
		set usuarios=Server.CreateObject("ADODB.Recordset")
		
		sql="Select *  from usuarios"
		sql=sql & " where usuario='" & usuario_seleccionado & "'"
		
		'response.write("<br>" & sql)
		
		with usuarios
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with

		valido=""
		if not usuarios.eof then
			contrasenna=usuarios("contrasenna")
			if contrasenna=contrasenna_seleccionada then
				valido="SI"
				session("usuario_admin")=usuario_seleccionado
			  else
			  	valido="NO"
			end if
		end if
		
		
		
		usuarios.close
		connimprenta.close
		set usuarios = Nothing
		set connimprenta=Nothing
		
	
		'response.write("sucursal: " & codigo_sucursal & "<br>Usuario: " & usuario & "<br>Contrase�a: " & contrasenna)
%>
<HTML>
<HEAD>
<TITLE>Validacion Acceso</TITLE>
<META NAME="Generator" CONTENT="Microsoft FrontPage 4.0">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">
<script language="javascript">


	function moverse(sino)
	{
		//alert('validamos 2..3..4..5..6')
		//alert(sino)
		//vemos si hay datos de esa sucursal, es decir, si es correcta
		if (sino=='SI')
			{
				//mostrar_capas('capa_informacion')
					
					location.href = "Consulta_Pedidos_Admin.asp"
				

				//window.close()
				//document.validarimp.submit()
			}
		  else
			{
			alert('Contraseña Incorrecta, vuelva a Introducir su Usuario y Contraseña de acceso')
			location.href = "Login_Admin.asp"
			}
			
		

	
			
			
	}
</script>

<script src="DD_roundies_0_0_2a.js">
//para redondear esquinas en el internet explorer
</script>


<script language="javascript">

function mostrar_capas(capa)
{
	//redondear capa para el internet explorer
	DD_roundies.addRule('#contenedorr3', '20px');
	document.getElementById('capa_opaca').style.display=''
	document.getElementById(capa).style.display='';
}

function cerrar_capas(capa)
{	
	document.getElementById('capa_opaca').style.display='none';
	document.getElementById(capa).style.display='none';
	
	//para que se dirija a la pagina despues de cerrar el popup
	//alert(document.getElementById('ocultoruta').value)
	location.href = "Consulta_Pedidos_Admin.asp"
	
	
}
</script>

<style>

#capa_opaca {
	position:absolute;
	color: black;
	background-color: #C0C0C0;
	left: 0px;
	top: 0px;
	width: 100%;
	height: 100%;
	z-index: 1000;
	text-align: center;
	visibility: visible;
	filter:alpha(opacity=40);
	-moz-opacity:.40;
	opacity:.40;
}

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
padding:15px;
width:500px;

margin: 180px auto;

-moz-border-radius: 20px; /* Firefox */
-webkit-border-radius: 20px; /* Google Chrome y Safari */
border-radius: 20px; /* CSS3 (Opera 10.5, IE 9 y est�ndar a ser soportado por todos los futuros navegadores) */
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

<BODY onload="moverse('<%=valido%>')">
<!-- capa opaca para que no deje pulsar nada salvo lo que salga delante (se comporte de forma modal)-->
<div id="capa_opaca" style="display:none;background-color:#000000;position:fixed;top:0px;left:0px;width:105%;min-height:110%;z-index:5;filter:alpha(opacity=50);-moz-opacity:.5;opacity:.5">
</div>

<!-- capa con la informacion a mostrar por encima-->
<div id="capa_informacion" style="display:none;z-index:6;position:fixed;width:100%; height:100%">
		<div id="contenedorr3" class="aviso">
			<div style="z-index:10" title="Cerrar" align="right"><a href="#" onClick="cerrar_capas('capa_informacion')"><img src="popup/btn_cerrar.png" border="0"></a></div>
			<div style="z-index:11" align="center">
				<a href="popup/Web_Inactiva.jpg" target="_blank">
				<img src="popup/Web_Inactiva_r.jpg" title="Pulse Para Ampliar la Imagen" border="0" /></a>
			</div>
			<br/>
			
		</div>
		

</div>


</BODY>

</HTML>
