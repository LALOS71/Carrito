<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title>Login Empleados GLS</title>
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	
	

	
	
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="estilos.css" />
	<link rel="stylesheet" type="text/css" href="carrusel/css/carrusel.css" />
	
	<style>
		body{padding-top:20px;}
	</style>


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
			    	<h3 class="panel-title">Login Empleados</h3>
					
					
			 	</div>
			  	<div class="panel-body">
 					
						<div align="center"><img class="img-responsive" src="GAG/Images/Logo_GLS.png" style="max-height:90px"/></div>
						<br />
						<br />
						<br />
					
                   

						<div align="center">
							<h3>
				        	... SE ESTÁN REALIZANDO TAREAS DE MANTENIMIENTO DENTRO DE LA APLICACIÓN ...
							<br /><br />
							En breves momentos estará accesible.
							<br /><br />
							Perdonden las molestias.
	    	  	        	</h3>
						</div>						
			    	
			      	
			    </div>
			</div>
		</div>
	</div>
</div>






</body>

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
	//console.log('usuario: ' + j$("#txtusuario").val())
	//console.log('contrasenna: ' + j$("#txtcontrasenna").val())
	
	
	
	cadena_error=''
	if (j$("#txtcontrasenna").val()=='')
		{
		cadena_error=cadena_error + '- Ha de Introducir la Contraseña.<br>'
		}
	
	if (j$("#txtusuario").val()=='')
		{
		cadena_error=cadena_error + '- Ha de Introducir el Usuario.<br>'
		}
	
	if (cadena_error!='')
		{
		bootbox.alert({
				//size: 'large',
				message: '<h3>Se Han Encontrado Los Siguientes Errores</h3><br><br><h5>' + cadena_error + '</h5>'
				//callback: function () {return false;}
			});
		
		}
	  else // comprobamos el usuario y contraseña
		{
		j$.ajax({
				type: 'POST',
				url: 'Validar_Usuario_Contrasenna_GLS.asp',
				data: {
					usuario: j$("#txtusuario").val(),
					contrasenna: j$("#txtcontrasenna").val(),
					origen: 'LOGIN'
				},
				dataType: 'json',
				success:
					function (data) {
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
								cambiar_contrasenna = data.cambiar_contrasenna_usuario_gls
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
								/*
								bootbox.alert({
										//size: 'large',
										message: '<h3>contraseña correcta</h3><br>'
										, callback: function () {
													//console.log('cliente: ' + data.centro_coste_usuario_gls)
													//console.log('usuario: ' + data.id_usuario_gls)
													//alert('hola')
													j$("#ocultocliente_login").val(data.centro_coste_usuario_gls)
													j$("#ocultousuario_login").val(data.id_usuario_gls)
													j$("#ocultonombre_login").val(data.nombre_usuario_gls)
													j$("#ocultoapellidos_login").val(data.apellidos_usuario_gls)
													j$("#frmlogin").submit()
													}
										//podemos volver en el callback
									});  
								*/
													
								j$("#ocultocliente_login").val(data.centro_coste_usuario_gls)
								j$("#ocultousuario_login").val(data.id_usuario_gls)
								j$("#ocultonombre_login").val(data.nombre_usuario_gls)
								j$("#ocultoapellidos_login").val(data.apellidos_usuario_gls)
								j$("#ocultogrupo_empleado_login").val(data.grupo_ropa_usuario_gls)
								j$("#ocultonuevo_empleado_login").val(data.nuevo_usuario_gls)
								j$("#ocultofecha_alta_empleado_login").val(data.fecha_alta_usuario_gls)
								
								//alert('lo devuelto por data: ' + data)
								//console.log('valido: ' + data.valido)
								//console.log('id_usuario_gls: ' + data.id_usuario_gls)
								//console.log('usuario_usuario_gls: ' + data.usuario_usuario_gls)
								//alert('nombre_usuario_gls: ' + data.nombre_usuario_gls)
								//alert('apellidos_usuario_gls: ' + data.apellidos_usuario_gls)
								//console.log('email_usuario_gls: ' + data.email_usuario_gls)
								//console.log('sexo_usuario_gls: ' + data.sexo_usuario_gls)
								//console.log('grupo_ropa_usuario_gls: ' + data.grupo_ropa_usuario_gls)
								//console.log('centro_coste_usuario_gls: ' + data.centro_coste_usuario_gls)
								//console.log('nuevo_usuario_gls: ' + data.nuevo_usuario_gls)
								//console.log('cambiar_contrasenna_usuario_gls: ' + data.cambiar_contrasenna_usuario_gls)
								
								//alert('nombre: ' + j$("#ocultonombre_login").val())
								//alert('apellidos: ' + j$("#ocultoapellidos_login").val())
								
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

})	



j$("#cmdcambiar_contrasenna").click(function () {
	j$("#ocultousuario").val(j$("#txtusuario").val())
	j$("#frmcambiar").submit()
})
</script>


<form method="post" action="Cambiar_Contrasenna_Usuario.asp" name="frmcambiar" id="frmcambiar">
	<input type="hidden" id="ocultousuario" name="ocultousuario" value="" />
</form>


<form method="post" action="GAG/Abrir_Lista_Articulos_GLS.asp" name="frmlogin" id="frmlogin">
	<input type="hidden" id="ocultocliente_login" name="ocultocliente_login" value="" />
	<input type="hidden" id="ocultousuario_login" name="ocultousuario_login" value="" />
	<input type="hidden" id="ocultonombre_login" name="ocultonombre_login" value="" />
	<input type="hidden" id="ocultoapellidos_login" name="ocultoapellidos_login" value="" />
	<input type="hidden" id="ocultogrupo_empleado_login" name="ocultogrupo_empleado_login" value="" />
	<input type="hidden" id="ocultonuevo_empleado_login" name="ocultonuevo_empleado_login" value="" />
	<input type="hidden" id="ocultofecha_alta_empleado_login" name="ocultofecha_alta_empleado_login" value="" />
</form>

</html>