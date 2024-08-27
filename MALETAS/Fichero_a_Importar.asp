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

	<style>
		body { padding-top: 70px; }
	</style>


	
<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>
<script type="text/javascript" src="plugins/bootstrap-filestyle-1.2.1/bootstrap-filestyle.js"></script>
<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

    </head>
<body>


<!--#include file="menu.asp"-->


<div class="container-fluid" >
	<div class="col-md-10 col-md-offset-1">
		<div class="well well-sm" style="padding-top:20px " >
				<form name="frmimportar_fichero" id="frmimportar_fichero" action="Subir_Documento.asp" method="post" enctype="multipart/form-data">
						<div class="form-group row">    
							<div class="col-md-9">
								<input type="file" id="txtfichero" name="txtfichero" value="" 
										class="filestyle" 
										data-buttonText="&nbsp;Seleccionar Fichero"
										data-buttonName="btn-primary"
										data-buttonBefore="true"
										data-size="lg"
										data-iconName="glyphicon glyphicon-folder-open"
										data-placeholder="Seleccionar un Fichero"
										accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel"
										>
							</div>
							<div class="col-md-3">
							  <button type="button" name="cmdimportar_fichero" id="cmdimportar_fichero" class="btn btn-primary btn-lg">
									<i class="glyphicon glyphicon-open"></i>
									<span>Importar Fichero</span>
							  </button>
							</div>
						</div>	
					</form>
				</div>

	</div>
</div>


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



<script language="javascript">
var j$=jQuery.noConflict();

j$(document).ready(function () {
	//j$("#menu1").removeClass("active").addClass("desactive")
	//j$("#menu2").removeClass("desactive").addClass("active")
	var pathname = window.location.pathname;
	//console.log('url: ' + pathname)
	posicion=pathname.lastIndexOf('/')
	pathname=pathname.substring(posicion + 1,pathname.length)
	//console.log('url truncada: ' + pathname)
	j$('.nav > li > a[href="'+pathname+'"]').parent().addClass('active');

});


j$("#cmdimportar_fichero").on("click", function () {
		cadena_error=''
		if (j$('#txtfichero').val()=='')
			{
			cadena_error=cadena_error + '<br>- Se ha de Seleccionar un Fichero Para Importar...' 
			}
			
			
		if (cadena_error!='')
			{
			cadena="<div class='col-md-10 col-md-offset-1' style='margin-top:7px'>"
			cadena=cadena + "<h4>Se Han Producido los Siguientes Errores:<h4>"
			cadena=cadena + cadena_error
			cadena=cadena + "</div>"
	
			j$("#cabecera_pantalla_avisos").html("Importaci&oacute;n Fichero Excel")
			j$("#body_avisos").html(cadena);
			j$("#pantalla_avisos").modal("show");
			}
		 else
		 	{
			j$("#frmimportar_fichero").submit()
			}
});

</script>
</body>
<%
%>
</html>