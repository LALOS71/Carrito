<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title>Acceso Peticiones Globalia Artes Graficas</title>
	<meta charset="UTF-8">

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
	</script>
	
<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>

    </head>
<body>



<div class="container">
    <div class="row">
		<div class="col-md-6 col-md-offset-3">
    		<div class="panel panel-default">
			  	<div class="panel-heading">
			    	<h3 class="panel-title">Login</h3>
			 	</div>
			  	<div class="panel-body">
 					<form  role="form" name="form1" method="post" action="" onsubmit="">
						<div align="center"><img class="img-responsive" src="GAG/Images/Logo_IMPRENTA.png" style="max-height:90px"/></div>
						<br />
						
                    <fieldset>
						Introduzca su CIF/NIF y Contraseña. 
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="Olvido_Contrasenna_Usuario_General.asp" title="pulse aquí­ si ha olvidado su contraseña"></a>¿Ha olvidado su contraseña?</a>
						<br /><br />
						
			    	  	<div class="form-group">
							<input type="hidden" name="ocultoempresa" id="ocultoempresa" value="260" />
							<input class="form-control" placeholder="CIF/NIF" name="txtusuario" id="txtusuario" type="text" value="" oninput="this.value = this.value.toUpperCase()">
			    		</div>
			    		<div class="form-group">
			    			<input class="form-control" placeholder="Password" name="txtcontrasenna" id="txtcontrasenna" type="password" value="">
			    		</div>
			    		<div class="row">
							<div class="col-sm-6 col-md-6 col-lg-6">
								<input class="btn btn-lg btn-primary btn-block" type="button" value="Login" id="cmdlogin">
							</div>
						  
							<div class="col-sm-6 col-md-6 col-lg-6">
								<input class="btn btn-lg btn-primary btn-block" type="button" value="Cambiar Contraseña" id="cmdcambiar_contrasenna" disabled>
							</div>
							<!--
							<div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 20px;">
								<input class="btn btn-lg btn-primary btn-block" type="button" value="Solicitar alta" id="cmd_solicitaralta" >
							</div>
							-->
						</div>

					  
			    	</fieldset>
			      	</form>
			    </div>
			</div>
		</div>
	</div>
</div>
</body>

<form method="post" action="Cambiar_Contrasenna_Usuario_GENERAL.asp" name="frmcambiar" id="frmcambiar">
	<input type="hidden" id="ocultousuario" name="ocultousuario" value="" />
</form>

<form method="post" action="GAG/Abrir_Lista_Articulos_GENERAL.asp" name="frmlogin" id="frmlogin">
	<input type="hidden" id="ocultocliente_login" name="ocultocliente_login" value="" />
</form>

<script language="javascript">
var j$ = jQuery.noConflict();



j$(document).ready(function() {

});





j$("#txtusuario").on("keyup",function() {
//console.log('valor usuario: ' + j$("#txtusuario").val())
	if (j$("#txtusuario").val()=='')
		{
		j$("#cmdcambiar_contrasenna").prop('disabled', true);
		}
	  else
		{
		j$("#cmdcambiar_contrasenna").prop('disabled', false);
		}
});

j$("#cmdlogin").click(function () {
	errores='no'
	cadena_errores=''
	if (j$("#txtusuario").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir El NIF/CIF del Cliente.<br>'
		}
		
	if (j$("#txtcontrasenna").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir la Contraseña Correspondiente.<br>'
		}
		
	if (errores=='si')
		{
		bootbox.alert({
				//size: 'large',
				message: '<h3>Se Han Encontrado Los Siguientes Errores</h3><br><br><h5>' + cadena_errores + '</h5>'
				//callback: function () {return false;}
			});
		}
	  else // comprobamos el usuario y contraseÃ±a
		{
		j$.ajax({
				type: 'POST',
				url: 'Validar_Usuario_Contrasenna_GENERAL.asp',
				data: {
					usuario: j$("#txtusuario").val(),
					contrasenna: j$("#txtcontrasenna").val(),
					origen: 'LOGIN'
				},
				dataType: 'json',
				success:
					function (data) {
						//console.log('datos devueltos: ' + data)
						switch (data.valido) {
							case 'NO':  //NO EXISTE EL USUARIO

								bootbox.alert({
										//size: 'large',
										message: '<h3>Usuario o Contraseña Incorrecta...</h3><br>'
										, callback: function () {
													j$("#txtusuario").val('')
													j$("#txtcontrasenna").val('')
													//console.log('ponemos el foco')
													setTimeout(function(){
															 j$('#txtusuario').focus();
														 }, 10);
													}
									});  
								break;
							
							case 'SI':  //existe el usuario pero la contraseña es erronea o tiene que cambiarla
								cambiar_contrasenna = data.cambiar_contrasenna_usuario_general
								if (cambiar_contrasenna=='SI')
									{
									bootbox.alert({
										//size: 'large',
										message: '<h3>Hay que Cambiar la Contraseña del Usuario...</h3><br>'
										, callback: function () {
													j$("#ocultousuario").val(j$("#txtusuario").val())
													j$("#frmcambiar").submit()
													
													}
										});
									}
								  else
								  	{
								  	bootbox.alert({
										//size: 'large',
										message: '<h3>Usuario o Constraseña Incorrecta...</h3><br>'
										, callback: function () {
													j$("#txtcontrasenna").val('')
													setTimeout(function(){
															 j$('#txtcontrasenna').focus();
														 }, 10);
													}
										
										});
									}
								break;
							
							case 'CONTRASENNA_CORRECTA':  //NO EXISTE EL USUARIO
													
								j$("#ocultocliente_login").val(data.id_usuario_general)
								j$("#frmlogin").submit()
								break;
		
							default: 
								cadena = '<h3>Se Ha Producido un error...</h3>';
								cadena = cadena + '<br><br>' + data;
								bootbox.alert({
										//size: 'large',
										message: cadena
										//callback: function () {return false;}
									}); 
								
								break;
						}
		
					},
				error:
					function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
			});
		}

		

});

j$("#cmdcambiar_contrasenna").click(function () {
	j$("#ocultousuario").val(j$("#txtusuario").val())
	j$("#frmcambiar").submit()
})

document.querySelector("#cmd_solicitaralta").addEventListener("click",()=>{
	window.location.href="./Solicitar_Alta_Usuarios.php";
})
</script>
<script language="javascript">
	
</script>
		
</html>