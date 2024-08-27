<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title>Acceso Peticiones</title>
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	
	<link href="estilos.css" rel="stylesheet" type="text/css" />
    <!-- Enhancement: To include TYNT -->
    </head>
<body>

	<form name="frmcarrito" id="frmcarrito" method="post" action="http://carrito.globalia-artesgraficas.com/Validar.asp" >
                <input type="hidden" name="ocultoempresa" id="ocultoempresa" value="250" />
                <input type="hidden" name="cmbclientes" id="cmbclientes" value="9933" />
                <input type="hidden" name="txtcontrasenna" id="txtcontrasenna" value="ECUADOR.C50"/>
				<input class="submitbtn" type="submit" name="Action" id="Action" value="Login" />
	</form>

</body>
</html>