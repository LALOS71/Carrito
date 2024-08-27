<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
	if session("usuario")="" then
		response.Redirect("Login.asp")
	end if
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

	<title>Consulta Incidencias</title>
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/font-awesome-4.7.0/css/font-awesome.min.css">

	<style>
		body { padding-top: 70px; }
	</style>


	

    </head>
<body>


<!--#include file="menu.asp"-->


<div class="container-fluid">

	 <!-- Acordion -->
	<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
		<div class="panel panel-info">
			<div class="panel-heading" role="tab" id="heading01" data-toggle="collapse" data-target="#desplegable" style="cursor:pointer">
				<h3 class="panel-title">

					<span
						data-toggle="popover" 
						title="Pulse Alternativamente para ocultar o desplegar esta secci&oacute;n de filtros de b&uacute;squeda" 
						data-placement="bottom" 
						data-trigger="hover"
						
						>
						Filtros de B&uacute;squeda
					</span>
				</h3>
				
			</div>
			
			<div id="desplegable" class=" panel-body panel-collapse collapse " role="tabpanel" aria-labelledby="heading01">
				<form action="" method="post" novalidate="novalidate">
					<div class="row">
						<div class="col-sm-6 col-md-2 col-lg-2">
							<div class="form-group">
								<label for="txtpir" class="control-label">PIR</label>
								<div class="clearfix visible-md-block"></div>
								<input type="" class="form-control" style="width: 100%;"  id="txtpir" name="txtpir" value="" />
							</div>
							<div class="form-group">
								<label for="cmbestados" class="control-label">Estado</label>
								<div class="clearfix visible-md-block"></div>
								<select id="cmbestados" name="cmbestados" data-width="100%">
										<option value="01">Estado 1</option>
										<option value="02">Estado 2</option>
										<option value="03">Enviado</option>
								</select>
							</div>
							<div class="form-group">
								<label for="txtpir" class="control-label">Expedici&oacute;n</label>
								<div class="clearfix visible-md-block"></div>
								<input type="" class="form-control" style="width: 100%;"  id="txtexpedicion" name="txtexpedicion" value="" />
							</div>
						</div><!--columna izquierda-->
	
	
						<div class="col-sm-6 col-md-10 col-lg-10">
							<div class="row">
							<div class="col-sm-6 col-md-6 col-lg-6">
								<div class="panel panel-success">
									<div class="panel-heading" role="tab" id="heading01">
										Fecha Orden <span id="fecmask" style="display:none"> (dd/mm/aaaa)</span>
									</div>
									<div id="p01" class=" panel-body panel-collapse " role="tabpanel" aria-labelledby="heading01">
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_inicio_orden" class="form-control" required="" name="txtfecha_inicio_orden" value="" title="Fecha Orden Desde...">
										</div>
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_fin_orden" class="form-control" required="" name="txtfecha_fin_orden" value="" title="Fecha Orden Hasta...">
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-6 col-md-6 col-lg-6">
								<div class="panel panel-success">
									<div class="panel-heading" role="tab" id="heading01">
										Fecha Envio <span id="fecmask" style="display:none"> (dd/mm/aaaa)</span>
									</div>
									<div id="p01" class=" panel-body panel-collapse " role="tabpanel" aria-labelledby="heading01">
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_inicio_envio" class="form-control" required="" name="txtfecha_inicio_envio" value="" title="Fecha Envio Desde...">
										</div>
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_fin_envio" class="form-control" required="" name="txtfecha_fin_envio" value="" title="Fecha Envio Hasta...">
										</div>
									</div>
								</div>
							</div>
							</div>
							
							<div class="row">&nbsp;</div>
							
							<div class="row">
							<div class="col-sm-6 col-md-6 col-lg-6">
								<div class="panel panel-success">
									<div class="panel-heading" role="tab">
										Fecha Entrega <span id="fecmask" style="display:none"> (dd/mm/aaaa)</span>
									</div>
									<div class=" panel-body panel-collapse " role="tabpanel">
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_inicio_entrega" class="form-control" required="" name="txtfecha_inicio_entrega" value="" title="Fecha Entrega Desde...">
										</div>
										<div class="col-sm-6 col-md-6 col-lg-6">
											<input type="date" id="txtfecha_fin_entrega" class="form-control" required="" name="txtfecha_fin_entrega" value="" title="Fecha Entrega Hasta...">
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-6 col-md-6 col-lg-6 justify-content-center">
								<div class="col-sm-6 col-md-6 col-lg-6">
									<button style="white-space: normal; width: 100%;" class="submit btn btn-lg btn-primary btnbag pull-right" title="Realizar Busqueda">
										<i class="fa fa-search fa-2x"></i><span>&nbsp;Buscar</span>
									</button>
								</div>
							</div>
							</div>
						</div><!--columna derecha-->
	
				  </div>
					<!-- row -->
				</form>
		  </div>
			<!-- panel Body-->
		</div>
		<!-- PANEL-->
	</div> <!-- Acordion -->

</DIV><!--CONTAINER-->







<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>


<script language="javascript">
var j$=jQuery.noConflict();

j$(document).ready(function () {
	var pathname = window.location.pathname;
	console.log('url: ' + pathname)
	posicion=pathname.lastIndexOf('/')
	pathname=pathname.substring(posicion + 1,pathname.length)
	console.log('url truncada: ' + pathname)
	
	//para que se seleccione la opcion de menu correcta
	j$('.nav > li > a[href="'+pathname+'"]').parent().addClass('active');
	
	//para que se reconfigure el combo como del tiepo selectpicker
	j$('#cmbestados').selectpicker()

	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true});

});


</script>
</body>
<%
%>
</html>