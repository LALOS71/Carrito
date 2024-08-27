<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title>Gesti&oacute;n Peticiones Globalia Artes Gr&aacute;ficas</title>
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	
	<link href="estilos.css" rel="stylesheet" type="text/css" />
    <!-- Enhancement: To include TYNT -->
	<script language="javascript">
		function validar(formulario)
			{
				errores='no'
				cadena_errores=''
				if (formulario.txtusuario.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '\n\t- Se ha de Introducir un Usuario.'
					}
					
				if (formulario.txtcontrasenna.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '\n\t- Se ha de Introducir la Contraseña Correspondiente.'
					}
					
				if (errores=='si')
					{
					cadena_errores='Se Han Producido los Siguientes Errores:\n\n' + cadena_errores
					alert(cadena_errores)
					return false
					}
				  else
				  	{
				  	return true
					}
					
			
			}
	</script>
    </head>
<body>
	<div id="loginform">
  		<table width="51%" cellspacing="6" cellpadding="0" class="logintable" align="center">
  			<tr>
  				<!--6.08 - Translate titles and buttons-->
  				<td class="al">
  					<span class='fontbold'>Gestión Peticiones Globalia Artes Gráficas</span>
  				</td>
  			</tr>
  			<tr>
  				<td class="dottedBorder vt al" width="50%">
  					<b>Se Están realizando tareas de mantenimiento dentro de la aplicación <br /><br />
					En breves momentos estará accesible<br /><br />
					Perdonen las molestias</b>
  
 					<form name="form1" method="post" action="Validar_Admin.asp" onsubmit="return validar(this)">
				  </form>
				</td>
			</tr>
	  </table>
	</div>

</body>
</html>