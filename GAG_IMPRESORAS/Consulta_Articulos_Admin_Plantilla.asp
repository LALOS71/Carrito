<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
%>
<html>
<head>
<link href="estilos___.css" rel="stylesheet" type="text/css" />

<!-- Bootstrap CSS CDN -->
    <link rel="stylesheet" type="text/css" href="plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	

    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="style_menu_hamburguesa5.css">

    <!-- Font Awesome JS -->
    <!--
	<script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
	-->
    <script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>




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


			<!--********************************************
			contenido de la pagina
			****************************-->
			<div class="container-fluid">
				<div class="row">
					<div class="col-10"><h1 align="center">Consulta Art&iacute;culos</h1></div>
					<div class="col-sm-4 col-md-2 col-lg-2">
					</div>
				
				</div>
				
			</div><!--del content-fluid-->
        </div><!--fin de content-->
    </div><!--fin de wrapper-->











<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
	
<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>
    
<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>


<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>



<script type="text/javascript">
var j$=jQuery.noConflict();
		
j$(document).ready(function () {
	j$("#menu_articulos").addClass('active')
	
	j$('#sidebarCollapse').on('click', function () {
		j$('#sidebar').toggleClass('active');
		j$(this).toggleClass('active');
	});
	
	
	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true});
	
	j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
	
});
		
</script>


</body>
<%

%>
</html>
