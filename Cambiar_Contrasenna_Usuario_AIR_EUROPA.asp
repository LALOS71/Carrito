<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
usuario_seleccionado="" & Request.Form("ocultousuario_pws")

if usuario_seleccionado="" then
	Response.Redirect("Login_AIR_EUROPA.asp")
end if
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title>Cambiar Contraseña del Usuario</title>
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
			    	<h3 class="panel-title">Cambiar La Contraseña del Usuario <%=usuario_seleccionado%></h3>
					
					
			 	</div>
			  	<div class="panel-body">
 					<form  role="form" name="form1" method="post" action="" onsubmit="">
						<div align="center"><img class="img-responsive" src="GAG/Images/Logo_Air_Europa.png" style="max-height:90px"/></div>
						<br />
					
					
                    <fieldset>
				        	<br />
				        	<br />
	    	  	        
						<div class="form-group">
			    			<input class="form-control contrasennas" placeholder="Contraseña Antigua" name="txtcontrasenna_antigua" id="txtcontrasenna_antigua" type="password" value="">						

						</div>
			    		<div class="form-group">
			    			<input class="form-control contrasennas" placeholder="Nueva Contraseña" name="txtcontrasenna_nueva" id="txtcontrasenna_nueva" type="password" value="">
			    		</div>
						<div class="form-group">
			    			<input class="form-control contrasennas" placeholder="Repita la Nueva Contraseña" name="txtcontrasenna_repeticion" id="txtcontrasenna_repeticion" type="password" value="">
			    		</div>
			    		
			    		<input class="btn btn-lg btn-primary btn-block" type="button" value="Modificar Contraseña" id="cmdmodificar_contrasenna">
					  
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
	comprobar_usuario_externo(<%=usuario_seleccionado%>)

});


/*
por si no queremos que se haga un copia pega en el textbox

j$(".contrasennas").on('paste', function(e){
    e.preventDefault();
    bootbox.alert({
				//size: 'large',
				message: '<h3>Esta Acción Está Prohibida.</h3><br>'
				//callback: function () {return false;}
			});
  })
  
j$(".contrasennas").on('copy', function(e){
    e.preventDefault();
    bootbox.alert({
				//size: 'large',
				message: '<h3>Esta Acción Está Prohibida.</h3><br>'
				//callback: function () {return false;}
			});
  })
*/


j$("#cmdmodificar_contrasenna").click(function () {
	//console.log('usuario: ' + j$("#txtusuario").val())
	//console.log('contrasenna: ' + j$("#txtcontrasenna").val())
	
	
	
	cadena_error=''
	if (j$("#txtcontrasenna_antigua").val()=='')
		{
		cadena_error=cadena_error + '- Ha de Introducir la Contraseña Antigua.<br>'
		}
	
	if (j$("#txtcontrasenna_nueva").val()=='')
		{
		cadena_error=cadena_error + '- Ha de Introducir la Contraseña Nueva.<br>'
		}

	if (j$("#txtcontrasenna_repeticion").val()=='')
		{
		cadena_error=cadena_error + '- Ha de Introducir la Repetición de la Contraseña Nueva.<br>'
		}
		
	if (j$("#txtcontrasenna_nueva").val() != j$("#txtcontrasenna_repeticion").val())
		{
		cadena_error=cadena_error + '- La Contraseña Nueva y su Repetición no Coinciden.<br>'
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
				url: 'Validar_Usuarios_AIR_EUROPA.asp',
				data: {
					usuario: '<%=usuario_seleccionado%>',
					contrasenna_antigua: j$("#txtcontrasenna_antigua").val(),
					contrasenna_nueva: j$("#txtcontrasenna_nueva").val(),
					origen: 'MODIFICAR'
				},
				dataType: 'json',
				success:
					function (data) {
							//tanto si devuelve error o devuelve ok, muestro su correspondiente mensaje
							cadena = '<h4>' + data.descripcion + '</h4>'
							bootbox.alert({
										//size: 'large',
										message: cadena
									}).on('hidden.bs.modal', function () {
										// Este código se ejecuta después de que se cierra el modal
										location.href = 'Login_AIR_EUROPA.asp';
									}); 
							
		
					},
				error:
					function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
			});
			
			
			
		}

})	

comprobar_usuario_externo = function(usuario){

	j$.ajax({
		type: 'POST',
		url: 'Validar_Usuarios_AIR_EUROPA.asp',
		data: {
			usuario: '<%=usuario_seleccionado%>',
			origen: 'COMPROBAR_EXTERNO'
		},
		dataType: 'json',
		success:
			function (data) {
				if (data.respuesta != 'ok')
					{
					cadena = '<h3>El Usuario no existe o es un Usuario del Dominio de Globalia</h3><br>';
					cadena += '<h4>Si es un usuario del dominio de globalia, el cambio de contraseña ha de realizarse desde el portal del empleado</h4>'
					bootbox.alert({
								//size: 'large',
								message: cadena
							}).on('hidden.bs.modal', function () {
								// Este código se ejecuta después de que se cierra el modal
								location.href = 'Login_AIR_EUROPA.asp';
							}); 
					}

			},
		error:
			function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
	});

}


</script>

</html>