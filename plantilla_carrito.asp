<%@ language=vbscript %>
<!DOCTYPE html>




<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>plantilla</title>
    <link rel="stylesheet" type="text/css" href="plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	

   
    <!-- Font Awesome JS -->
    <script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>

	
	
	
	 <!-- Our Custom CSS -->
    <link rel="stylesheet" href="style_menu_hamburguesa5.css">


	<link rel="stylesheet"  type="text/css" href="plugins/bootstrap-multiselect/bootstrap-multiselect.css">

    

</head>
<body>
    <div class="wrapper">
	<!--#include file="Menu_Hamburguesa.asp"-->
	
	<!-- Page Content Holder -->
	<div id="content">
		<button type="button" id="sidebarCollapse" class="navbar-btn active">
			<span></span>
			<span></span>
			<span></span>
		</button>
	
	
		<!--
        ********************************************
		contenido de la pagina
		****************************
        -->
		<div class="container-fluid">
            <div class="row mt-1">
                <!--columna derecha-->
                    <h1>CONTENIDO DE LA PÁGINA...</h1>      
                <!-- fin columna derecha-->
            </div>
        </div><!--del content-fluid-->
	</div><!--fin de content-->
</div><!--fin de wrapper-->



<form name="frmmostrar_pedido" id="frmmostrar_pedido" action="Pedido_Admin.asp" method="post">
	<input type="hidden" value="" name="ocultopedido" id="ocultopedido" />
</form>
  
<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
	
<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>
    
<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>





<script type="text/javascript" src="plugins/bootbox-6.0.0/bootbox.min.js"></script>









<script type="text/javascript">

		
$(document).ready(function () {
	$("#menu_pedidos").addClass('active')
	
	$('#sidebarCollapse').on('click', function () {
		$('#sidebar').toggleClass('active');
		$(this).toggleClass('active');
	});
	
});

</script>

</body>
</html>