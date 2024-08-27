<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->

<%
		
		
		'recordsets
		dim hoteles
		dim tipo_clientes
		set hoteles=Server.CreateObject("ADODB.Recordset")
		set tipo_clientes=Server.CreateObject("ADODB.Recordset")
		
		empresa_entrada=4
		
		pais=""
		pais=UCASE(Request.QueryString("pais"))
	
		if pais="" then
			pais="ESPAÑA"
		end if
		
		tipo=""
		tipo=UCASE(Request.QueryString("tipo"))
		
		sql="Select id, codigo_externo, nombre  from V_CLIENTES"
		sql=sql & " Where empresa=" & empresa_entrada
		sql=sql & " AND PAIS='" & pais & "'"
		if tipo<>"" then
			sql=sql & " AND TIPO='" & tipo & "'"
		end if
		sql=sql & " AND BORRADO='NO'"
		sql=sql & " order by nombre"
		
		'response.write("<br>" & sql)
		
		with hoteles
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
		
		with tipo_clientes
			.ActiveConnection=connimprenta
			.Source="SELECT ID, TIPO"
			.Source= .Source & " FROM V_CLIENTES_TIPO"
			.Source= .Source & " WHERE EMPRESA = 4"
			.Source= .Source & " ORDER BY ORDEN"
			.Open
		end with
		
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title>Acceso Peticiones GLS</title>
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	
	
	<link rel="stylesheet" type="text/css" href="estilo_gls.css" />
	
	
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
				if (formulario.cmbhoteles.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<h4>- Se ha de Seleccionar una Sucursal.</h4>'
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
 					<form  role="form" name="form1" method="post" action="Validar.asp" onsubmit="return validar(this)">
						<div align="center"><img class="img-responsive" src="GAG/Images/Logo_GLS.png" style="max-height:90px"/></div>
						<br />
					
					
                    <fieldset>
						<div>
							<div class ="col-md-6">
								Seleccione Pa&iacute;s.
								<br />
								<div class = "btn-group btn-group-sm">
								   <button type = "button" class = "btn btn-default" id="boton_espanna">España</button>
								   <button type = "button" class = "btn btn-default" id="boton_portugal">Portugal</button>
								</div>
							</div>
							<div class ="col-md-6">
								Seleccione El Tipo de Oficina
								<br />
								<select class="form-control" name="cmbperfil" id="cmbperfil" size="1">
									<option value=""  selected="selected">Seleccione Tipo</option>
									<%while not tipo_clientes.eof%>
										<option value="<%=ucase(tipo_clientes("tipo"))%>"><%=tipo_clientes("tipo")%></option>
										
										<%tipo_clientes.movenext%>
									<%wend%>
							  	</select>
								
							</div>								
						</div>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<th height="15" scope="col">&nbsp;</th>
						  </tr>
						</table>

						
							
				        	Introduzca su Usuario y Contraseña para Acceder. <br /><br />
	    	  	        
							<div class="form-group">
								<input type="hidden" name="ocultoempresa" id="ocultoempresa" value="<%=empresa_entrada%>" />
							
								<select class="form-control" name="cmbhoteles" size="1">
											<option value=""  selected="selected">Seleccionar cliente</option>
											<%while not hoteles.eof%>
												<option value="<%=hoteles("id")%>">(<%=hoteles("codigo_externo")%>) <%=hoteles("nombre")%></option>
												
												<%hoteles.movenext%>
											<%wend%>
							  </select>
	
							</div>
			    		<div class="form-group">
			    			<input class="form-control" placeholder="Password" name="txtcontrasenna" id="txtcontrasenna" type="password" value="">
			    		</div>
			    		
			    		<input class="btn btn-lg btn-danger btn-block" type="submit" value="Login">
					  
			    	</fieldset>
			      	</form>
			    </div>
			</div>
		</div>
	</div>
</div>






</body>

<script language="javascript">

$('#boton_espanna').on("click",function(){
   $('#boton_espanna').removeClass('btn-default').addClass('btn-primary')
   $('#boton_portugal').removeClass('btn-primary').addClass('btn-default')
   //console.log('pulsado españa')
   location.href = 'Login_GLS.asp?pais=ESPAÑA&tipo=' + $('#cmbperfil').val();
});

$('#boton_portugal').on("click",function(){
   $('#boton_portugal').removeClass('btn-default').addClass('btn-primary')
   $('#boton_espanna').removeClass('btn-primary').addClass('btn-default')
   //console.log('pulsado portugal')
   location.href = 'Login_GLS.asp?pais=PORTUGAL&tipo=' + $('#cmbperfil').val();
});

$("#cmbperfil").change(function(){
    if ($("#boton_espanna").hasClass("btn-primary"))
		{
		location.href = 'Login_GLS.asp?pais=ESPAÑA&tipo=' + $('#cmbperfil').val();
		}
	  else
	  	{
		location.href = 'Login_GLS.asp?pais=PORTUGAL&tipo=' + $('#cmbperfil').val();
		}
});


$(document).ready(function() {
 <%if pais="ESPAÑA" then%>
	$('#boton_espanna').removeClass('btn-default').addClass('btn-primary')
   	$('#boton_portugal').removeClass('btn-primary').addClass('btn-default')
 <%end if%>
 <%if pais="PORTUGAL" then%>
	$('#boton_portugal').removeClass('btn-default').addClass('btn-primary')
    $('#boton_espanna').removeClass('btn-primary').addClass('btn-default')
 <%end if%> 
 
 <%if tipo<>"" then%>
	$('#cmbperfil').val('<%=tipo%>')
	
  <%end if%>
});

</script>
<%
hoteles.close
tipo_clientes.close
connimprenta.close

set hoteles=Nothing
set tipo_clientes=Nothing
set connimpresta=Nothing
%>
</html>