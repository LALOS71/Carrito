<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
set empresas=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_EMPRESA=0
		CAMPO_EMPRESA=1
		with empresas
			.ActiveConnection=connimprenta
			.Source="SELECT ID, EMPRESA"
			.Source= .Source & " FROM v_empresas"
			.Source= .Source & " ORDER BY EMPRESA"
			'response.write("<br>FAMILIAS: " & .source)
			.Open
			vacio_empresas=false
			if not .BOF then
				tabla_empresas=.GetRows()
			  else
				vacio_empresas=true
			end if
		end with

		empresas.close
		set empresas=Nothing



set datos_carrusel=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_CARRUSEL=0
		CAMPO_ORDEN_CARRUSEL=1
		CAMPO_EMPRESAS_CARRUSEL=2
		CAMPO_FICHERO_CARRUSEL=3
		with datos_carrusel
			.ActiveConnection=connimprenta
			.Source="SELECT ID_CARRUSEL, ORDEN, EMPRESAS, FICHERO"
			.Source= .Source & " FROM CARRUSEL"
			.Source= .Source & " ORDER BY ID_CARRUSEL"
			'response.write("<br>FAMILIAS: " & .source)
			.Open
			vacio_datos_carrusel=false
			if not .BOF then
				tabla_datos_carrusel=.GetRows()
			  else
				vacio_datos_carrusel=true
			end if
		end with

		datos_carrusel.close
		set datos_carrusel=Nothing

%>



<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrusel</title>
    
    
    <link href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" rel="stylesheet">
	<link href="plugins/bootstrap-pushbuttons/css/buttons.css" rel="stylesheet">
	<link href="plugins/bootstrap-touchspin/css/jquery.bootstrap-touchspin.css" rel="stylesheet" type="text/css" media="all">
    
    <!--<link href="plugins/bootstrap-3.3.6/css/bootstrap-theme.min.css" rel="stylesheet">-->
    
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="css/ie10-viewport-bug-workaround.css" rel="stylesheet">

    <style>
	
		.panel-primary{
    				padding-left: 0;
				    padding-right:0;
				    }
	
		.image_thumb{
			position:relative;
			overflow:hidden;
			padding-bottom:100%;
		}
		.image_thumb img{
			  position: absolute;
			  max-width: 100%;
			  max-height: 100%;
			  top: 50%;
			  left: 50%;
			  transform: translateX(-50%) translateY(-50%);
		}
	</style>
    

</head>

<body style="padding:0px; margin-top:7px; background-color:#fff;font-family:Arial, sans-serif">


<div class="container">
		<div class="well row" style="margin-bottom:8px">
			<button type="button" id="cmdannadir_diapositiva" class="btn btn-primary btn-sm">
				<i class="glyphicon glyphicon-plus"></i>
				<span>A&ntilde;adir Diapositiva</span>
			</button>
			<button type="button" id="cmdguardar" class="btn btn-primary btn-sm">
				<i class="glyphicon glyphicon-upload"></i>
				<span>Guardar Informaci&oacute;n</span>
			</button>
			
        </div>



		<!--PLANTILLA DE REPETICION-->        
		<div class="well plantilla" id="plantilla" name="plantilla" style="display:none">
			<div class="row">
				<div class="col-md-6 panel panel-primary" style="margin-left:5px;margin-right:5px">
					<div class="panel-heading">Imagen Asociada</div>
					<div class="panel-body datos_fichero">
						<div class="col-sm-3 thumbnail_imagen_asociada" style="display:none">
							<a href="#" class="thumbnail">
								<div class="image_thumb">
									<img src="" class="img img-responsive full-width img_asociada" id="img_asociada" name="img_asociada"/>
								</div>
							</a>
						</div>
						<div class="col-sm-2 flechita_thumbnail_preview" style="display:none">
							<span class="glyphicon glyphicon-arrow-right btn-lg" aria-hidden="true"></span>
						</div>
						<div class="col-sm-3 preview_imagen_fichero" style="display:none">
							<a href="#" class="thumbnail">
								<div class="image_thumb">
									<img src="" class="img img-responsive full-width img_fichero" id="img_fichero" name="img_fichero" />
								</div>
							</a>
						</div>
						<input type="file" id="txtfichero" name="txtfichero" size="80"  class="txtfichero" value="">
						<input type="hidden" id="ocultoid_carrusel" name="ocultoid_carrusel" size="80"  class="ocultoid_carrusel" value="">
						<input type="hidden" id="ocultofichero" name="ocultofichero" size="80"  class="ocultofichero" value="">
						<input type="hidden" id="ocultoaccion" name="ocultoaccion" size="80"  class="ocultoaccion" value="">
					</div>
				</div>
				<div class="col-md-3 panel panel-primary" style="margin-left:5px;margin-right:5px">
					<div class="panel-heading">Orden</div>
					<div class="panel-body">
						<input type="text" value="" id="txtorden" name="txtorden" class="txtorden">
					</div>
				</div>
				<div class="col-md-2 cmdcancelar">
					<button type="button" class="btn btn-danger ">
						<i class="glyphicon glyphicon-trash"></i>
						<span>Cancelar</span>
					</button>
				</div>
        	</div>
        	<div class="row text-center">
				    <div class="panel panel-primary col-md-12"  style="margin-top:10px">
      					<div class="panel-heading">Empresas Asociadas</div>
						<div class="panel-body botonesempresas" id="botonesesmpresas" name="botonesempresas">
							
							<%if not vacio_empresas then%>
								<%for i=0 to UBound(tabla_empresas,2)%>
									<button type="button" class="btn btn-push btn-push-default btn-push-sm toggleable" valor="<%=tabla_empresas(campo_id_empresa,i)%>"><%=tabla_empresas(campo_empresa,i)%></button>
								<%next%>
							<%end if%>
							<input type="hidden" class="ocultoempresas" name="ocultoempresas" id="ocultoempresas" value="">
						</div>
					</div>
					
					
					
  			</div>
		</div>
		<!--FIN PLANTILLA DE REPETICION-->  
        

		
		
		<form id="frmdatos" name="frmdatos" method="post" action="Subir_Documento.asp" enctype="multipart/form-data">
        	<!--ZONA DONDE SE IRAN A�ADIENDO LOS ELEMENTOS-->		
      		<div id="datos"></div>
			<input type="hidden" name="ocultonum_elementos" id="ocultonum_elementos" value="" />
      	</form>
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





    <script type="text/javascript" src="plugins/jquery/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="plugins/bootstrap-filestyle-1.2.1/bootstrap-filestyle.js"></script>
	<script type="text/javascript" src="plugins/bootstrap-touchspin/js/jquery.bootstrap-touchspin.js"></script>
    
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="js/ie10-viewport-bug-workaround.js"></script>
    
    
    
<script type="text/javascript">
     var j$=jQuery.noConflict();
        
        
		

    j$("#datos").on("click", ".toggleable", function () {
      if (j$(this).hasClass("btn-push-default"))
        {
        j$(this).removeClass("btn-push-default").addClass("btn-push-primary");        
        }
      else  
        {
        j$(this).removeClass("btn-push-primary").addClass("btn-push-default");        
        }
    });
    
    j$("#cmdannadir_diapositiva").on("click", function () {
		j$("#cmdguardar").show();

		//clona la plantilla dentro del div datos al principio, haciendo un efecto de retardo al mostrarla
		j$(".plantilla:first").clone().prependTo("#datos").hide().fadeIn('slow');
		
		plantillas_clonadas=j$("#datos .plantilla").length
		if (plantillas_clonadas==1)
			{
				valor="1"
			}		  
		 else
		 	{
				valor_id=j$("#datos .plantilla:eq(1)").attr("id");
				valor=valor_id.split("_")[1];
				valor= parseInt(valor) + 1;
			}
			
		j$("#datos .plantilla:first").attr("id", "plantilla_" + valor)
		j$("#datos .plantilla:first").attr("name", "plantilla_" + valor)
		j$("#datos .plantilla:first .txtfichero").attr("id", "txtfichero_" + valor)
		j$("#datos .plantilla:first .txtfichero").attr("name", "txtfichero_" + valor)
		j$("#datos .plantilla:first .ocultoid_carrusel").attr("id", "ocultoid_carrusel_" + valor)
		j$("#datos .plantilla:first .ocultoid_carrusel").attr("name", "ocultoid_carrusel_" + valor)
		j$("#datos .plantilla:first .ocultofichero").attr("id", "ocultofichero_" + valor)
		j$("#datos .plantilla:first .ocultofichero").attr("name", "ocultofichero_" + valor)
		j$("#datos .plantilla:first .ocultoaccion").attr("id", "ocultoaccion_" + valor)
		j$("#datos .plantilla:first .ocultoaccion").attr("name", "ocultoaccion_" + valor)
		j$("#datos .plantilla:first .botonesempresas").attr("id", "botonesempresas_" + valor)
		j$("#datos .plantilla:first .botonesempresas").attr("name", "botonesempresas_" + valor)
		j$("#datos .plantilla:first .ocultoempresas").attr("id", "ocultoempresas_" + valor)
		j$("#datos .plantilla:first .ocultoempresas").attr("name", "ocultoempresas_" + valor)
		j$("#datos .plantilla:first .txtorden").attr("id", "txtorden_" + valor)
		j$("#datos .plantilla:first .txtorden").attr("name", "txtorden_" + valor)
		j$("#txtorden_" + valor).TouchSpin({
									min: 1, 
									initval: 1
									});
		
		
	});
    
	
	
	
	/*
	j$("#frmdatos").submit(function( event ) {
  	  return;
  		//para cuando no queremos que haga submit
		//event.preventDefault();
	});
	*/
	
	j$("#cmdguardar").on("click", function () {
      	cadena_error=""
		j$("#datos .plantilla").each(function(indice, elemento) {
			if ((j$(this).find(".txtfichero").val()=="") && (j$(this).find(".ocultoid_carrusel").val()==""))
				{
					cadena_error=cadena_error + "<br>- Se ha de Seleccionar una Imagen Para La Diapositiva " + (indice + 1)
				}
			  else
			  	{
				if (j$(this).find(".txtfichero").val()!="")
					{
					var ext = (j$(this).find(".txtfichero").val().split(".").pop().toLowerCase());
					if (j$.inArray(ext, ['gif','png','jpg','jpeg']) == -1) 
						{
						cadena_error=cadena_error + "<br>- El fichero a Seleccionar a de ser una imagen (gif, png, jpg, jpeg) para La Diapositiva " + (indice + 1)
						}
					
					}
				}
			
			
			empresas="###"	
			j$(this).find(".btn-push-primary").each(function(indice, elemento) {	
				empresas=empresas + j$(this).attr("valor") + "###";
			});
			
			if (empresas=="###")
				{
					cadena_error=cadena_error + "<br>- Se han de Seleccionar Las Empresas Asociadas a La Diapositiva " + (indice + 1)
				}
			  else
			  	{
				j$(this).find(".ocultoempresas").val(empresas);
				}
			
			if (j$(this).find(".txtorden").val()=="")
				{
					cadena_error=cadena_error + "<br>- Se ha de Indicar un Orden Para La Diapositiva " + (indice + 1)
				}
		});
	  
		if (cadena_error!="")
			{
			cadena_error= "Se han encontrado los siguientes errorores:<br>" + cadena_error
			j$("#cabecera_pantalla_avisos").html("Avisos")
			j$("#body_avisos").html(cadena_error + "<br><br>");
			j$("#pantalla_avisos").modal("show");
			}
		  else
		  	{
			//renombramos elementos porque pueden ir con los ids no consecutivos y en el subir_fichero asp, se nos lia
			// la comprobacion de los nombres o ids
			
			j$("#datos .plantilla").each(function(indice, elemento) {
				j$(this).attr("id", "plantilla_" + indice)
				j$(this).attr("name", "plantilla_" + indice)
				j$(this).find(".txtfichero").attr("id", "txtfichero_" + indice)
				j$(this).find(".txtfichero").attr("name", "txtfichero_" + indice)
				j$(this).find(".ocultoid_carrusel").attr("id", "ocultoid_carrusel_" + indice)
				j$(this).find(".ocultoid_carrusel").attr("name", "ocultoid_carrusel_" + indice)
				j$(this).find(".ocultofichero").attr("id", "ocultofichero_" + indice)
				j$(this).find(".ocultofichero").attr("name", "ocultofichero_" + indice)
				j$(this).find(".ocultoaccion").attr("id", "ocultoaccion_" + indice)
				j$(this).find(".ocultoaccion").attr("name", "ocultoaccion_" + indice)
				j$(this).find(".botonesempresas").attr("id", "botonesempresas_" + indice)
				j$(this).find(".botonesempresas").attr("name", "botonesempresas_" + indice)
				j$(this).find(".ocultoempresas").attr("id", "ocultoempresas_" + indice)
				j$(this).find(".ocultoempresas").attr("name", "ocultoempresas_" + indice)
				j$(this).find(".txtorden").attr("id", "txtorden_" + indice)
				j$(this).find(".txtorden").attr("name", "txtorden_" + indice)

			});
			j$("#ocultonum_elementos").val(j$("#datos .plantilla").length)
			j$("#frmdatos").submit();
			}
     
	});
    
	//borramos esta diapositiva
	j$(document).on("click", ".cmdcancelar", function () {
      	var parent = j$(this).parent().parent()
		//para que desaparezca lentamente
		j$(parent).fadeOut('slow', function () {
				if (j$(parent).find(".ocultoid_carrusel").val()=="")
					{
					j$(parent).remove();
					}
				 else
				 	{
					j$(parent).find(".ocultoaccion").val("BORRAR")
					}
				
				
				if (j$("#datos .plantilla").length==0)
					{
					j$("#cmdguardar").hide();
					}
				  else
					{
					j$("#cmdguardar").show();
					}		
				
			});
	});



    j$(document).on("change", ".txtfichero" , function () {
		if (this.files && this.files[0])
			{
			var reader = new FileReader();
			
			if (j$(this).parent().find(".ocultofichero").val()!="")
				{
				j$(this).parent().find(".flechita_thumbnail_preview").show()
				}
			

			j$(this).parent().find(".preview_imagen_fichero").show()
			elemento=this
            reader.onload = function (e) {
				j$(elemento).parent().find(".img_fichero").attr("src", e.target.result);
				//j$(this).parent().hide()
            }
			reader.readAsDataURL(this.files[0]);
			//j$(this).parent(".preview_imagen_fichero").find(".preview_imagen_asociada").show();
			}
		  else
		  	{
			j$(this).parent().find(".img_fichero").attr("src", "");
			j$(this).parent().find(".flechita_thumbnail_preview").hide()
			j$(this).parent().find(".preview_imagen_fichero").hide()
			}
	
	});
       
	   
	   
	   
	j$(document).on("click", ".thumbnail_imagen_asociada" , function () { 
		mostrar_imagen(j$(this).find(".img_asociada").attr("src"), "Imagen Asociada")  
	
	});
	
	
	j$(document).on("click", ".preview_imagen_fichero" , function () {   
		mostrar_imagen(j$(this).find(".img_fichero").attr("src"), "Nueva Imagen Asociada")  
	});
	
	   
	mostrar_imagen = function (origen, tipo) {
		cadena="<div class='col-md-6 col-md-offset-3' style='margin-top:7px'><a href='#' class='thumbnail'><div class='image_thumb'>"
		cadena=cadena + "<img src='" + origen + "' class='img img-responsive full-width' />"
		cadena=cadena + "</div></a></div>"
	
			j$("#cabecera_pantalla_avisos").html(tipo)
			j$("#body_avisos").html(cadena);
			j$("#pantalla_avisos").modal("show");
	};
    
	
	j$(document).ready(function($) {
		j$("#cmdguardar").hide();
		
		<%if not vacio_datos_carrusel then%>
			<%for i=0 to UBound(tabla_datos_carrusel,2)%>
				j$("#cmdannadir_diapositiva").click();
				
				var empresas="<%=tabla_datos_carrusel(campo_empresas_carrusel,i)%>"
				var tabla_empresas=empresas.split("###")
				j$.each( tabla_empresas, function( index, value ){
					j$("#datos .plantilla:first").find(".toggleable[valor='" + value + "']").removeClass("btn-push-default").addClass("btn-push-primary");
				});
				
				var orden="<%=tabla_datos_carrusel(campo_orden_carrusel,i)%>"
				j$("#datos .plantilla:first").find(".txtorden").val(orden);
				
				var id_carrusel="<%=tabla_datos_carrusel(campo_id_carrusel,i)%>"
				j$("#datos .plantilla:first").find(".ocultoid_carrusel").val(id_carrusel);
				
				var fichero_imagen="<%=tabla_datos_carrusel(campo_fichero_carrusel,i)%>"
				j$("#datos .plantilla:first").find(".ocultofichero").val(fichero_imagen);
				j$("#datos .plantilla:first").find(".datos_fichero .img_asociada").attr("src", "carrusel/img_carrusel/" + fichero_imagen)
				j$("#datos .plantilla:first").find(".thumbnail_imagen_asociada").show();
				
			<%next%>

		<%end if%>		        

		
	});
	
	
	
	
	
 	 
</script>

</body>

</html>
<%
	'articulos.close
	
	connimprenta.close
	
	set articulos=Nothing
	set hoteles=Nothing
	set connimprenta=Nothing

%>
</html>
