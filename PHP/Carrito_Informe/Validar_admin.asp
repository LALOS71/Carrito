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
		
	
		'response.write("sucursal: " & codigo_sucursal & "<br>Usuario: " & usuario & "<br>Contraseña: " & contrasenna)
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
			}
		  else
			{
			alert('Contraseña Incorrecta, vuelva a Introducir su Usuario y Contraseña de acceso')
			location.href = "Login_Admin.asp"
			}
			
		

	
			
			
	}
</script>



</HEAD>

<!--
  al cargarse la pagina, aparte de construirse en funcion del
 mayorista al que se accede, se ejecuta la funcion moverse
 ya comentada
-->

<BODY onload="moverse('<%=valido%>')">



</BODY>

</HTML>
