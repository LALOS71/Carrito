<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title>Solicitud de Alta</title>
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="estilos.css" />
	<link rel="stylesheet" type="text/css" href="carrusel/css/carrusel.css" />

	<style>
		body {padding-top:20px;}
		.mayus {text-transform: uppercase;}
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
			    	<h3 class="panel-title">Solicitud de Alta del Cliente</h3>
			 	</div>
			  	<div class="panel-body">
 					<form  role="form" name="form1" method="post" action="" onsubmit="">
						<div align="center"><img class="img-responsive" src="GAG/Images/Logo_IMPRENTA.png" style="max-height:90px"/></div>
						<br />
						
                    <fieldset>
						Introduzca los siguientes datos necesarios para tramitar el alta. 
						<br /><br />
						
						<input type="hidden" name="ocultoempresa" id="ocultoempresa" value="260" />
			    	  	<div class="form-group">
							<input class="form-control mayus" placeholder="CIF/NIF" name="txtcif" id="txtcif" type="text" value="">
			    		</div>
						<div class="form-group">
							<input class="form-control mayus" placeholder="Razón Social" name="txtrazon_social" id="txtrazon_social" type="text" value="">
			    		</div>
						<div class="form-group">
							<input class="form-control mayus" placeholder="Dirección" name="txtdireccion" id="txtdireccion" type="text" value="">
			    		</div>
						<div class="form-group">
							<input class="form-control mayus" placeholder="Código Postal" name="txtcodigo_postal" id="txtcodigo_postal" type="text" value="">
			    		</div>
						<div class="form-group">
							<input class="form-control mayus" placeholder="Población" name="txtpoblacion" id="txtpoblacion" type="text" value="">
			    		</div>
						<div class="form-group">
							<input class="form-control mayus" placeholder="Provincia" name="txtprovincia" id="txtprovincia" type="text" value="">
			    		</div>
						
						<div class="form-group">
							<input class="form-control mayus" placeholder="Nombre Comercial" name="txtnombre_comercial" id="txtnombre_comercial" type="text" value="">
			    		</div>
						<div class="form-group">
							<input class="form-control mayus" placeholder="Teléfono" name="txttelefono" id="txttelefono" type="text" value="">
			    		</div>
						<div class="form-group">
							<input class="form-control mayus" placeholder="Persona de Contacto" name="txtpersona_contacto" id="txtpersona_contacto" type="text" value="">
			    		</div>
						<div class="form-group">
							<input class="form-control mayus" placeholder="Email" name="txtemail" id="txtemail" type="text" value="">
			    		</div>
						
						<div class="panel panel-default">
							<div class="panel-heading">
								<h3 class="panel-title" style="display: inline;">Dirección de Envío
									<div class="btn-group  pull-right">
									  <a class="btn btn-default btn-sm" id="cmdcopiar_direccion" name="cmdcopiar_direccion">Copiar Dirección Fiscal</a>
									</div>
								  <div class="clearfix"></div>
								</h3>
							</div>
							<div class="panel-body">
								<div class="form-group">
									<input class="form-control mayus" placeholder="Dirección" name="txtdireccion_envio" id="txtdireccion_envio" type="text" value="">
								</div>
								<div class="form-group">
									<input class="form-control mayus" placeholder="Código Postal" name="txtcodigo_postal_envio" id="txtcodigo_postal_envio" type="text" value="">
								</div>
								<div class="form-group">
									<input class="form-control mayus" placeholder="Población" name="txtpoblacion_envio" id="txtpoblacion_envio" type="text" value="">
								</div>
								<div class="form-group">
									<input class="form-control mayus" placeholder="Provincia" name="txtprovincia_envio" id="txtprovincia_envio" type="text" value="">
								</div>
							</div>
						</div>
						
			    		<div class="row">
							<div class="col-sm-6 col-md-6 col-lg-6">
								<input class="btn btn-lg btn-primary btn-block" type="button" value="Guardar" id="cmdguardar">
							</div>
						  
							<div class="col-sm-6 col-md-6 col-lg-6">
								<input class="btn btn-lg btn-primary btn-block" type="button" value="Cancelar" id="cmdcancelar">
							</div>
						</div>

					  
			    	</fieldset>
			      	</form>
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






j$("#cmdguardar").click(function () {
	errores='no'
	cadena_errores=''
	if (j$("#txtcif").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir El NIF/CIF del Cliente.<br>'
		}
		
	if (j$("#txtrazon_social").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir La Razón Social.<br>'
		}
		
	if (j$("#txtdireccion").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir La Dirección.<br>'
		}

	if (j$("#txtcodigo_postal").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir El Código Postal de la Dirección.<br>'
		}

	if (j$("#txtpoblacion").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir La Población de la Dirección.<br>'
		}

	if (j$("#txtprovincia").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir La Provincia de la Dirección.<br>'
		}

	if (j$("#txtnombre_comercial").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir El Nombre Comercial.<br>'
		}
		
	if (j$("#txttelefono").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir El Teléfono.<br>'
		}

	if (j$("#txtpersona_contacto").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir La Persona de Contacto.<br>'
		}

	if (j$("#txtemail").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir El Email.<br>'
		}

	if (j$("#txtdireccion_envio").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir La Dirección de Envío.<br>'
		}
		
	if (j$("#txtcodigo_postal_envio").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir El Código Postal de la Dirección de Envío.<br>'
		}

	if (j$("#txtpoblacion_envio").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir La Población de la Dirección de Envío.<br>'
		}

	if (j$("#txtprovincia_envio").val()=='')
		{
			errores='si'
			cadena_errores=cadena_errores + '- Se ha de Introducir La Provincia de la Dirección de Envío.<br>'
		}

		
	if (errores=='si')
		{
		bootbox.alert({
				//size: 'large',
				message: '<h3>Se Han Encontrado Los Siguientes Errores</h3><br><br><h5>' + cadena_errores + '</h5>'
				//callback: function () {return false;}
			});
		}
	  else // comprobamos el usuario y contraseña
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

j$("#cmdcopiar_direccion").click(function () {
	j$("#txtdireccion_envio").val(j$("#txtdireccion").val())
	j$("#txtcodigo_postal_envio").val(j$("#txtcodigo_postal").val())
	j$("#txtpoblacion_envio").val(j$("#txtpoblacion").val())
	j$("#txtprovincia_envio").val(j$("#txtprovincia").val())
	
})

j$("#cmdcancelar").click(function () {
	j$(".mayus").val("")
	
})
</script>

		
</html>