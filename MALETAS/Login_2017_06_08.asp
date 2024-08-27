<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
'no funciona.... 
'call Response.AddHeader("Access-Control-Allow-Origin", "http://192.168.153.132")

'para que funcione se pone en el web.config de GAGLogin
'<system.webServer>
'		<httpProtocol>
'			<customHeaders>
'				<add name="Access-Control-Allow-Origin" value="*" />
'				<add name="Access-Control-Allow-Headers" value="Origin, X-Requested-With, Content-Type, Accept" />
'			</customHeaders>
'		</httpProtocol>
'	</system.webServer>
'para que se pueda llamar a la validacion del usuario en real desde el entorno de pruebas

%>
<html>
  <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Login</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="css/ie10-viewport-bug-workaround.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/login.css" rel="stylesheet">

    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
    <script type="text/javascript" src="js/ie-emulation-modes-warning.js"></script>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

	<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
	<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
	
	<script type="text/javascript" src="js/jquery.numeric.js"></script>

  </head>

  <body>

    <div class="container">

      <form class="form-signin" method="post" id="frmlogin" name="frmlogin" action="Fichero_a_Importar.asp">
        <h2 class="form-signin-heading">Acceso</h2>
        <label for="inputEmail" class="sr-only">Usuario</label>
        <input type="text" id="txtusuario" name="txtusuario" class="form-control" placeholder="Usuario" required autofocus>
        <label for="inputPassword" class="sr-only">Password</label>
        <input type="password" id="txtpassword" name="txtpassword" class="form-control" placeholder="Password" required>
        
		<button class="btn btn-lg btn-primary btn-block" type="submit" id="cmdlogin" name="cmdlogin">Login</button>
      </form>

    </div> <!-- /container -->


    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="js/ie10-viewport-bug-workaround.js"></script>
<script language="javascript">	
	var j$=jQuery.noConflict();
	
j$(document).ready(function () {
	// permite solo numeros, usa plugin  "jquery.numeric.js".  false, sin decimales "." o ","->separador decimal,   --   
    j$('#txtusuario').numeric(false); // sin puntuación alguna --

});	
	
	
j$(function () {
    
    
});  // (document).ready,  $(function () ---------------------

	
			
j$("#frmlogin").submit(function( event ) {			
	//http://carrito.globalia-artesgraficas.com/GAGLogin/wsLogin.asmx
		j$.ajax({
			type: "POST", contentType: "application/json; charset=utf-8",
			url: "http://carrito.globalia-artesgraficas.com/GAGLogin/wsLogin.asmx/validarUsuarioLDAP",
			data: '{usuario:' + j$('#txtusuario').val() + ', contrasena:"' + j$('#txtpassword').val() + '" }',        
			dataType: "json",
			success:
				function (data) {
					console.log('valor devuelto: ' + data.d.resulLDAP)
					switch (data.d.resulLDAP) {                     
						case 0: {             
								alert('accediendo')                                                                                               
								//j$("frmlogin").submit();
								break;
								}
						case 1: {                        
								alert('El Usuario NO tiene permisos para el uso de este aplicativo');
								break;
								}
						case 1017: {                        
								alert('Usuario o contraseña Incorrectos ');
								break
								}
						case 20102: {
								alert('Contraseña Caducada ');
								break
								}
						default: {                        
								alert('Validación fallida:' + data.d.resulLDAP);
								break
								}
					}// case --               
				},
			error:
				function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
		}); // $.ajax({
		
		
		  		event.preventDefault();

	});

</script>

	

  </body>
</html>
