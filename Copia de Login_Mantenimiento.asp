<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title>En Mantenimiento</title>
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="estilos.css" />
	<link rel="stylesheet" type="text/css" href="carrusel/css/carrusel.css" />

	<style>
		body{padding-top:20px;}
	</style>


    <!-- Enhancement: To include TYNT -->
	<script language="javascript">
		function validar(formulario)
			{
				errores='no'
				cadena_errores=''
				if (formulario.cmbhoteles.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<h4>- Se ha de Seleccionar un Hotel.</h4>'
					}
					
				if (formulario.txtcontrasenna.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<h4>- Se ha de Introducir la Contraseña Correspondiente.</h4>'
					}
					
				if (errores=='si')
					{
					cadena_errores='<h3>Se Han Producido los Siguientes Errores:</h3><br><br>' + cadena_errores
					//alert(cadena_errores)
					$("#cabecera_pantalla_avisos").html("Avisos")
					$("#body_avisos").html(cadena_errores + "<br>");
					$("#pantalla_avisos").modal("show");
					return false
					}
				  else
				  	{
				  	return true
					}
					
			
			}
	</script>
	
<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

    </head>
<body style="background-color:#99CCCC">




<div class="container">
    <div class="row">
		<div class="col-md-8 col-md-offset-2"  style="padding-top:70px">
    		<div class="panel panel-default">
			  	<div class="panel-heading">
			    	<h3 class="panel-title">Gestión Peticiones Globalia Artes Gráficas</h3>
			 	</div>
			  	<div class="panel-body">
 					<h5>
					<b>Se Están realizando tareas de mantenimiento dentro de la aplicación <br /><br />
					En breves momentos estará accesible<br /><br />
					Perdonen las molestias</b>
					</h5>	
			      	
			    </div>
			</div>
		</div>
	</div>
</div>






</body>
</html>