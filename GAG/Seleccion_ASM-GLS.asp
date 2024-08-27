<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>

<meta name="Generator" content="Microsoft FrontPage 4.0" />
<meta name="Keywords" content="" />
<meta name="Description" content="" />

	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="../estilos.css" />

<style>

.modal {
  text-align: center;
  padding: 0!important;
}

.modal:before {
  content: '';
  display: inline-block;
  height: 100%;
  vertical-align: middle;
  margin-right: -4px;
}

.modal-dialog {
  display: inline-block;
  text-align: left;
  vertical-align: middle;
}

</style>
<script type="text/javascript">


function mostrar_capa()	{
	
	/*
	cadena_carpeta=''
	cadena_empresa=''
	
	cadena_carpeta='GAG/'
	cadena_empresa='_Gag'			
	
	ruta_redireccion= cadena_carpeta + 'Lista_Articulos' + cadena_empresa + '.asp'
	location.href=ruta_redireccion
	*/
	cadena='<br><h3 align="center">Seleccione Marca del Material</h3><br>'    
	cadena=cadena + '<img class="img-responsive" id="logo_asm" src="images/Boton_Principal_ASM.jpg" border="0" style="cursor:pointer;float:left"  height="400px" onclick="cambiar_imagen(\'ASM\')" />'
	cadena=cadena + '<img class="img-responsive" id="logo_gls"src="images/Boton_Principal_GLS.jpg" border="0" style="cursor:pointer;float:left"  height="400px" onclick="cambiar_imagen(\'GLS\')" />'    
	$("#body_avisos").html(cadena);
	$("#pantalla_avisos").modal("show");
}// moverse --
	

</script>

<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>


</head>

<!--  al cargarse la pagina, aparte de construirse en funcion del mayorista al que se accede, se ejecuta la funcion moverse ya comentada -->

<body onload="mostrar_capa()" style="background-color:<%=session("color_asociado_empresa")%>">

<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="container-fluid" id="body_avisos" style="min-height:450px"></div>	
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->







<input type="hidden" id="ocultoruta" name="ocultoruta" value="" />

<form action="Lista_Articulos_Gag.asp" method="post" id="frmbotones" name="frmbotones">
	<input type="hidden" id="ocultoseleccion_asm_gls" name="ocultoseleccion_asm_gls" value="" />
</form>

</body>
<script language="javascript">
$('#pantalla_avisos').on('hidden.bs.modal', function (e) {
  location.href = '../Login_ASM.asp'
})


cambiar_imagen = function(empresa) {
	if (empresa=='ASM')
		{
		$("#logo_asm").attr("src","images/Boton_Principal_ASM_Pulsado.jpg");
		seleccion_asm_gls='ASM'
		}
	 else
	 	{
		$("#logo_gls").attr("src","images/Boton_Principal_GLS_Pulsado.jpg");
		seleccion_asm_gls='GLS'
		}
	$("#ocultoseleccion_asm_gls").val(seleccion_asm_gls)	
	$("#frmbotones").submit()
  };  

</script>

</html>
