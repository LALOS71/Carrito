<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
	<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">

    <title>Login</title>

    <!-- If you're looking for CSS link tags, they're at the end of this document -->

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
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
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

	<!-- modal -->
	<div class="modal fade" id="pantalla_avisos_actualizar_graphisoft" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true" data-backdrop="static" data-keyboard="false">
		<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="cabecera_pantalla_avisos_actualizar_graphisoft">Aviso</h5>
				</div>
				<div class="modal-body" id="body_avisos_actualizar_graphisoft"></div>
				<div class="modal-footer" style="display:none" id="pie_pantalla_avisos_actualizar_graphisoft">
					<button type="button" class="btn btn-secondary" data-dismiss="modal"
						id="cmdcerrar_actualizacion_graphisoft">Cerrar</button>
				</div>
			</div>
		</div>
	</div>
	<!-- /modal -->

    <div class="container overlay">
        <form class="form-signin" method="post" id="frmlogin" name="frmlogin" action="">
            <h2 class="form-signin-heading">Acceso Gestión Graphisoft</h2>
            <div class="form-group">
                <label for="inputEmail" class="sr-only">Usuario</label>
                <input type="text" id="txtusuario" name="txtusuario" class="form-control" placeholder="Usuario"
                    autofocus>
            </div>
            <div class="form-group">
                <label for="inputPassword" class="sr-only">Password</label>
                <input type="password" id="txtpassword" name="txtpassword" class="form-control" placeholder="Password">
            </div>

            <button type="button" class="btn btn-lg btn-primary btn-block" id="cmdlogin" name="cmdlogin">Login</button>
        </form>
    </div> <!-- /container -->


    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="js/ie10-viewport-bug-workaround.js"></script>
    <script src="js/login.js"></script>
    
    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="css/ie10-viewport-bug-workaround.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/login.css" rel="stylesheet">
</body>
</html>