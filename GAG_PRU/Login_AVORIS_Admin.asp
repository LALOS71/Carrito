<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title>Gesti&oacute;n Peticiones AVORIS</title>
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
				if (formulario.txtusuario.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<h4>- Se ha de Introducir un Usuario.</h4>'
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
    <div class="row">
		<div class="col-md-6 col-md-offset-3">
    		<div class="panel panel-default">
			  	<div class="panel-heading">
			    	<h3 class="panel-title">Login</h3>
			 	</div>
			  	<div class="panel-body">
 					<form  role="form" name="form1" method="post" action="Validar_Avoris_Admin.asp" onsubmit="return validar(this)">
						<input name="ocultoempresa" id="ocultoempresa" type="hidden" value="230">
						<div align="center"><img class="img-responsive" src="GAG/Images/Logo_Avoris.png" style="max-height:90px"/></div>
						<br />
						
                    <fieldset>
			    		<div class="form-group">
			    			<input class="form-control" placeholder="Usuario" name="txtusuario" id="txtusuario" type="text" value="">
			    		</div>
						<div class="form-group">
			    			<input class="form-control" placeholder="Password" name="txtcontrasenna" id="txtcontrasenna" type="password" value="">
			    		</div>

			    		<input class="btn btn-lg btn-primary btn-block" type="submit" value="Login">
					  
			    	</fieldset>
			      	</form>
			    </div>
			</div>
		</div>
	</div>
</div>






</body>
<%
%>
</html>