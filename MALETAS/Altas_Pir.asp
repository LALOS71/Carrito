<%@ language=vbscript%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
	if session("usuario")="" then
		response.Redirect("Login.asp")
	end if
	
%>

<html>



<head>


	<title>Altas Pir</title>
	
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-switch/css/bootstrap-switch.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/media/css/dataTables.bootstrap.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/extensions/Buttons/css/buttons.dataTables.min.css">
  
	
	<link rel="stylesheet" type="text/css" href="plugins/font-awesome-4.7.0/css/font-awesome.min.css">

	<style>
		body { padding-top: 70px; }
		
		.clickable{
		   cursor: pointer;   
		}
	
		.panel-heading span {
			margin-top: -20px;
			font-size: 15px;
		}
		
		.table th { font-size: 13px; }
		.table td { font-size: 12px; }
		
		/*
		.popover-content {
			background-color: #FCD086;
			font-size: 10px;
		}
		.popover.top .arrow:after {
		  bottom: 1px;
		  margin-left: -10px;
		  border-top-color: #FCD086; /*<----here*/
		  /*border-bottom-width: 0;
		  content: " ";
		}
		*/
		
		/*para cambiar el color del fondo del popover
		.popover {background-color: coral;}
		.popover.bottom .arrow::after {border-bottom-color: coral; }
		.popover .popover-content {background-color: coral;}
		.popover.top .arrow:after {border-top-color: coral;}
		*/
		
		.dataTables_length {float:left;}
		.dataTables_filter {float:right;}
		.dataTables_info {float:left;}
		.dataTables_paginate {float:right;}
		.dataTables_scroll {clear:both;}
		.toolbar {float:left;}    
		div .dt-buttons {float:right; position:relative;}
		table.dataTable tr.selected.odd {background-color: #9FAFD1;}
		table.dataTable tr.selected.even {background-color: #B0BED9;}
		
		#iframe_detalle_pir {
 			 height: calc(100vh - 80px);
			}
	</style>
</head>

<body>


<!--#include file="menu.asp"-->


<div class="container-fluid">

	<iframe id='iframe_detalle_pir' src="Detalle_Pir.asp" height="700px" width="100%" frameborder="0" transparency="transparency"></iframe> 	

</div>



<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>

<script>
var j$=jQuery.noConflict();

j$(document).ready(function () {
	var pathname = window.location.pathname;
	
	posicion=pathname.lastIndexOf('/')
	pathname=pathname.substring(posicion + 1,pathname.length)
	
	//para que se seleccione la opcion de menu correcta
	j$('.nav > li > a[href="'+pathname+'"]').parent().addClass('active');
	
	
});
</script>
</body>



</html>