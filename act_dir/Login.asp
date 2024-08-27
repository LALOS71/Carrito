<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
'no funciona.... 
'call Response.AddHeader("Access-Control-Allow-Origin", "*")
'call Response.AddHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept")

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

    
    
	<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
	<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
	
	<script type="text/javascript" src="js/jquery.numeric.js"></script>

	<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="js/ie-emulation-modes-warning.js"></script>


  </head>

  <body>
  
  <!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->

  
  
  

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
		alert('usuario y contraseña: ' + j$('#txtusuario').val() + ' --- ' + j$('#txtpassword').val()) 
		url_final= 'http://carrito.globalia-artesgraficas.com/act_dir/Validar_Usuario_Actdir.asp'
		parametros='username=' + j$('#txtusuario').val() + '&password=' + j$('#txtpassword').val()        
		url_final= url_final + '?' + parametros
		//alert('urlfinal' + url_final)
		j$.ajax({
			type: "POST", 
			contentType: "application/json; charset=utf-8",
			//beforeSend: function (request) {
            //    request.setRequestHeader("Authorization", "Negotiate");
            //},
			url: url_final,
			//data: '{username:' + j$('#txtusuario').val() + ', password:"' + j$('#txtpassword').val() + '" }',        
			success:
				function (data) {
					//console.log('valor devuelto: ' + data)
		
					valores=data.split('||')
					cadena=''
					switch (valores[0]) {                     
							case 0: {             
									alert('accediendo')                                                                                               
									//j$("frmlogin").submit();
									break;
									}
							default: {                        
									cadena='Error: ' + valores[0]
									cadena=cadena + '<br>' + valores[1]
									break
									}
						}// case --               
					
					if (cadena!='')
						{
						j$("#cabecera_pantalla_avisos").html("Error Validaci&oacute;n Usuario")
						j$("#body_avisos").html('<h5>' + cadena '</h5>');
						j$("#pantalla_avisos").modal("show");
						}
				
				},
			error:
				function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
		}); // $.ajax({
		
		
		  		event.preventDefault();

	});

</script>

	

  </body>
</html>
