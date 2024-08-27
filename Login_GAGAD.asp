<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">





<html xmlns="http://www.w3.org/1999/xhtml">
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title>Acceso Peticiones Globalia Artes Graficas</title>

    <!-- Required meta tags -->
    
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	
	<link rel="stylesheet" href="plugins/bootstrap-4.3.1/css/bootstrap.min.css">
    <!-- Enhancement: To include TYNT -->
	
</head>

<body>




<div class="container h-100">
  <div class="row align-items-center h-100">
    
    <div class="col-6 mx-auto" style="padding-top:30px ">
      	<form name="frmlogin" id="frmlogin" method="post" action="Validar_GAGAD.asp" onsubmit="return validar(this)">
		<div class="card" style="width: 35rem;">
		  <div class="card-body">
			<div align="center"><img class="img-responsive" src="Images/Logo_GAG.png" style="max-height:90px"/></div>
			<br />
			<h5 class="card-title">Gesti&oacute;n Peticiones Globalia Artes Gr&aacute;ficas - Acceso</h5>
			
			<p class="card-text">Introduzca su Usuario y Contraseña para Acceder.</p>
			<div class="form-group">
				<input class="form-control" placeholder="Usuario" name="txtusuario" id="txtusuario" value="">
			</div>
			<div class="form-group">
				<input class="form-control" placeholder="Password" name="txtcontrasenna" id="txtcontrasenna" type="password" value="">
			</div>
			<div align="right">
				  <a href="#" class="btn btn-primary" onclick="$('#frmlogin').submit()">Login</a>
			</div>
		  </div>
		</div>
		</form>
    </div>
    
  </div>
</div>

</body>

<script type="text/javascript" src="plugins/jquery/jquery-3.4.1.min.js"></script>
<script type="text/javascript" src="plugins/popper/popper-1.14.7.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-4.3.1/js/bootstrap.min.js"></script>

<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>


<script language="javascript">
		function validar(formulario)
			{
				errores='no'
				cadena_errores=''
				if (formulario.txtusuario.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Introducir el Usuario.'
					}
					
				if (formulario.txtcontrasenna.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Introducir la Contraseña Correspondiente.'
					}
					
				if (errores=='si')
					{
					cadena_errores='Se Han Producido los Siguientes Errores:<br>' + cadena_errores
					//alert(cadena_errores)
					
					bootbox.alert({
									//size: 'large',
									message: cadena_errores
									//callback: function () {return false;}
								})	
					return false
					}
				  else
				  	{
				  	return true
					}
					
			
			}
			
		$("#txtcontrasenna").on('keyup', function (e) {
			if (e.keyCode === 13) {
				$('#frmlogin').submit()
			}
		});
	</script>
</html>