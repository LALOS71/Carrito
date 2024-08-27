<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title>Login AIR EUROPA</title>
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
			    	<h3 class="panel-title">Login Air Europa</h3>
					
					
			 	</div>
			  	<div class="panel-body">
 					<form  role="form" name="form1" method="post" action="" onsubmit="">
						<div align="center"><img class="img-responsive" src="GAG/Images/Logo_Air_Europa.png" style="max-height:90px"/></div>
						<br />
					
					
                    <fieldset>

						
							
				        	Introduzca su Usuario y Contraseña para Acceder.
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<!--
							<a href="#" title="pulse aquí si ha olvidado su contraseña" id="olvido_contrasenna" name="olvido_contrasenna">¿Ha olvidado su contraseña?</a>
							-->
							<br /><br />
	    	  	        
						<div class="form-group">
			    			<input class="form-control" placeholder="Usuario" name="txtusuario" id="txtusuario" type="text" value="" maxlength="7">						

						</div>
			    		<div class="form-group" id="capa_contrasenna"  name="capa_contrasenna">
			    			<input class="form-control" placeholder="Password" name="txtcontrasenna" id="txtcontrasenna" type="password" value="">
			    		</div>
						<div class="form-group" id="capa_oficinas" name="capa_oficinas" style="display:none"></div>
			    		<div class="row" id="capa_login" name="capa_login">
							<div class="col-sm-3 col-md-3 col-lg-3"></div>
							<div class="col-sm-6 col-md-6 col-lg-6">
								<input class="btn btn-lg btn-primary btn-block" type="button" value="Login" id="cmdlogin">
							</div>
						  
							<!--
							<div class="col-sm-6 col-md-6 col-lg-6">
								<input class="btn btn-lg btn-primary btn-block" type="button" value="Cambiar Contraseña" id="cmdcambiar_contrasenna" disabled>
							</div>
							-->
						</div>
						<div class="row" id="capa_acceder" name="capa_acceder" style="display:none">
							<div class="col-sm-3 col-md-3 col-lg-3"></div>
							<div class="col-sm-6 col-md-6 col-lg-6">
								<input class="btn btn-lg btn-primary btn-block" type="button" value="Acceder" id="cmdacceder" name="cmdacceder" disabled>
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
	  else
	  	{
		var regex = /^[0-9]+$/;
		if (!regex.test(j$("#txtusuario").val())) 
			{
			cadena_error=cadena_error + '- El Usuario ha de ser un dato numérico.<br>'
			}
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
				url: 'Validar_Usuarios_Contrasenna_AIR_EUROPA.asp',
				data: {
					usuario: j$("#txtusuario").val(),
					contrasenna: j$("#txtcontrasenna").val(),
					origen: 'LOGIN'
				},
				dataType: 'json',
				success:
					function (data) {
						//console.log('desde login_gls_empleados vemos data.apellidos: ' + data.apellidos_usuario_gls)
						console.log('respuesta desde el click: ' + data.respuesta)
						if (data.respuesta == 'error') //algo ha ido mal
							{
								bootbox.alert({
									//size: 'large',
									message: '<h3>' + data.descripcion + '</h3><br>'
									, callback: function () {
												if (data.codigo == '1')
													{
													j$("#txtusuario").val('')
													}
												j$("#txtcontrasenna").val('')
												//console.log('ponemos el foco')
												setTimeout(function(){
														 j$('#txtusuario').focus();
													 }, 10);
												}
								}); 
							}
						
						else
							{
							if (data.respuesta == 'ok') 
								{
									//console.log('la respuesta es ok, y el codigo: ' + data.codigo)
									if (data.codigo == '1') //ha hecho login correctamente y hay que montar el combobox con sus oficinas o darle acceso
										{
										configurar_acceso(data.oficinas)
										}

									if (data.codigo == '2') //ha hecho la validacion en el active directory correctamente
										{
										//validamos en el active directory
										configurar_acceso(data.oficinas)
										}
									
								}
							}
							
							
						
		
					},
				error:
					function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
			});
		}

})	


j$("#cmdacceder").on("click",function() {
	//redirijo a la oficina seleccionada en el combobox
	document.getElementById("ocultoCliente").value=document.getElementById("cmboficinas").value
	document.getElementById("ocultoUsuario").value=document.getElementById("txtusuario").value
	document.getElementById("frmlogin").submit()
})

j$(document).on("change", "#cmboficinas", function() {
	console.log('change')
	if (j$(this).val()=='')
		{
		document.getElementById("cmdacceder").disabled=true
		}
	  else
		{
		document.getElementById("cmdacceder").disabled=false
		}
})

j$("#cmdcambiar_contrasenna").click(function () {
	if (j$("#txtusuario").val()=='')
		{
		bootbox.alert({message: 'Ha de introducir el Usuario...'})
		}
	  else
	  	{
		comprobar_usuario_externo(j$("#txtusuario").val())
		}


	j$("#ocultousuario_pws").val(j$("#txtusuario").val())
	j$("#frmcambiar").submit()
})


configurar_acceso = function(oficinas)
{
	//console.log('dentro de configurar acceso')
	texto_combo=''
	texto_combo_cabecera=''
	texto_combo_opciones=''
	//var oficinas = data.oficinas;
	//console.log('oficnas: ' + oficinas)
	var numeroOficinas = oficinas.length;
	//console.log('numero: ' + numeroOficinas)
	if (numeroOficinas > 1) {
	  for (var i = 0; i < numeroOficinas; i++) {
		texto_combo_opciones = texto_combo_opciones + '<option value="' + oficinas[i].codigo + '">' + oficinas[i].nombre + '</option>'
	  }
	  texto_combo_cabecera = '<select class="form-control" id="cmboficinas" name="cmboficinas">'
	  texto_combo_cabecera = texto_combo_cabecera + '<option value="">Seleccione la Oficina con la que Desea Acceder</option>'
	  texto_combo = texto_combo_cabecera + texto_combo_opciones + '</select>'
	  //console.log('textocombo: ' + texto_combo)
	  combobox = document.getElementById("capa_oficinas")
	  combobox.innerHTML = texto_combo
	  combobox.style.display='block'
	  document.getElementById("txtusuario").disabled=true
	  document.getElementById("txtcontrasenna").disabled=true
	  document.getElementById("capa_login").style.display="none"
	  document.getElementById("capa_acceder").style.display="block"
	  
	}
  else
	{
	//se da acceso directamente al sistema al tener solo una oficina asociada
	console.log('accedemos directamente a la oficina: ' + oficinas[0].codigo)
	document.getElementById("ocultoCliente").value=oficinas[0].codigo
	document.getElementById("ocultoUsuario").value=document.getElementById("txtusuario").value
	document.getElementById("frmlogin").submit()
	}
}


j$("#olvido_contrasenna").click(function () {

	if (j$("#txtusuario").val()=='')
		{
		bootbox.alert({message: 'Ha de introducir el Usuario...'})
		}
	  else
	  	{
		valor = comprobar_usuario_externo(j$("#txtusuario").val())
		console.log('valor comprobar usuario externo: ' + valor)

		/*
		cadena = '<h3>El Usuario no existe o es un Usuario del Dominio de Globalia</h3><br>';
					cadena += '<h4>Si es un usuario del dominio de globalia, el cambio de contraseña ha de realizarse desde el portal del empleado</h4>'
					bootbox.alert({
								//size: 'large',
								message: cadena
							})
							
							
							else //no es un usuario del dominio, asi que podemos cambiar la contraseña
				  	{
					//email_olvido_constrasenna(usuario)
		*/
		}

})

comprobar_usuario_externo = function(usuario){

	j$.ajax({
		type: 'POST',
		url: 'Validar_Usuarios_AIR_EUROPA.asp',
		data: {
			usuario: usuario,
			origen: 'COMPROBAR_EXTERNO'
		},
		dataType: 'json',
		success:
			function (data) {
				if (data.respuesta != 'ok') //es un usuario del dominio y no se puede cambiar la contraseña desde aqui
					{
					return 'INTERNO'
					}
				  else //no es un usuario del dominio
				  	{
					return 'EXTERNO'
					}

			},
		error:
			function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
	});

}


email_olvido_contrasenna = function(usuario){

	j$.ajax({
		type: 'POST',
		url: 'Validar_Usuarios_AIR_EUROPA.asp',
		data: {
			usuario: usuario,
			origen: 'EMAIL_CONTRASENNA'
		},
		dataType: 'json',
		success:
			function (data) {
				if (data.respuesta != 'ok') //es un usuario del dominio y no se puede cambiar la contraseña desde aqui
					{
					cadena = '<h3>El Usuario no existe o es un Usuario del Dominio de Globalia</h3><br>';
					cadena += '<h4>Si es un usuario del dominio de globalia, el cambio de contraseña ha de realizarse desde el portal del empleado</h4>'
					bootbox.alert({
								//size: 'large',
								message: cadena
							})
					}
				  else //no es un usuario del dominio, asi que podemos cambiar la contraseña
				  	{
					email_olvido_constrasenna(usuario)
					}

			},
		error:
			function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
	});

}


</script>


<form method="post" action="Cambiar_Contrasenna_Usuario_AIR_EUROPA.asp" name="frmcambiar" id="frmcambiar">
	<input type="hidden" id="ocultousuario_pws" name="ocultousuario_pws" value="" />
</form>


<form method="post" action="GAG/Abrir_Lista_Articulos.asp" name="frmlogin" id="frmlogin" accept-charset="UTF-8">
	<input type="hidden" id="ocultoCliente" name="ocultoCliente" value="" />
	<input type="hidden" id="ocultoUsuario" name="ocultoUsuario" value="" />
</form>

</html>