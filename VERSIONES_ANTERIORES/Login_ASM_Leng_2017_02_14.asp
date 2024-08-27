<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<!--#include virtual="/includes/Login_ASM_cons_es.asp"-->
<%
'response.write("idioma " & session("idioma"))
lenguaje=Request.QueryString("set_language")
if lenguaje="" then
	lenguaje=session("idioma")
end if
session("idioma")=lenguaje
response.write("<br>como queda la variable sesion lenguaje en la pagina asp: " & lenguaje)
%>	 

<!--#include virtual="/includes/Idiomas.asp"-->
<%
		response.write("valor del titulo en la pagina asp: " & login_asm_title)
		
		'recordsets
		dim hoteles
		set hoteles=Server.CreateObject("ADODB.Recordset")
		
		empresa_entrada=4
		
		sql="Select id, codigo_externo, nombre  from V_CLIENTES"
		sql=sql & " Where empresa=" & empresa_entrada
		sql=sql & " AND BORRADO='NO'"
		sql=sql & " order by nombre"
		
		'response.write("<br>" & sql)
		
		with hoteles
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
		end with
		
		
		
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<!--
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
-->
<head>

	<title><%=login_asm_title%></title>
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
				if (formulario.cmbhoteles.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<h4>- <%=login_asm_error_sucursal%></h4>'
					}
					
				if (formulario.txtcontrasenna.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<h4>- <%=login_asm_error_pass%></h4>'
					}
					
				if (errores=='si')
					{
					cadena_errores='<h3><%=login_asm_explicacion_errores%></h3><br><br>' + cadena_errores
					//alert(cadena_errores)
					$("#cabecera_pantalla_avisos").html("<%=login_asm_ventana_mensajes_cabecera%>")
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

<%if Request.QueryString("set_language")="" and session("idioma")="" then%>
<script type="text/javascript">
window.onload = function() 
	{
	var ln = x=window.navigator.language||navigator.browserLanguage;
	if(ln == 'en'){
		window.location.href = 'login_asm.asp?set_language=en';//si esta en inglés va a ingles
	}else if(ln == 'es'){
		window.location.href = 'login_asm.asp?set_language=es'; // si es es va a español
	}else{
		window.location.href = 'login_asm.asp?set_language=es'; // si no es ninguna de los dos va a español
		}
	}
</script>
<%end if%>
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
          <p><button type="button" class="btn btn-default" data-dismiss="modal"><%=login_asm_ventana_mensajes_boton_cerrar%></button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->


<div class="container">
	
	
	<div class="row">
		<div class="col-md-3 col-md-offset-9">
			<ul id="portal-languageselector">
				<li class="language-en">
					<a href="login_asm.asp?set_language=en" title="English">English</a>
				</li>
				<li class="language-es">
					<a href="login_asm.asp?set_language=es" title="Español">Español</a>
				</li>
			</ul>
		</div>
	</div>	
		<script language="javascript">
			valor='.language-<%=lenguaje%>'
			$(valor).addClass("currentLanguage")
		</script>

    <div class="row">
		<div class="col-md-6 col-md-offset-3">
    		<div class="panel panel-default">
			  	<div class="panel-heading">
			    	<h3 class="panel-title"><%=login_asm_cabecera_panel%></h3>
			 	</div>
			  	<div class="panel-body">
 					<form  role="form" name="form1" method="post" action="Validar.asp" onsubmit="return validar(this)">
						<div align="center"><img class="img-responsive" src="GAG/Images/logo_asm.png" style="max-height:90px"/></div>
						<br />
						
                    <fieldset>
						<%=login_asm_usuario_y_pass%>
						<br /><br />
			    	  	<div class="form-group">
							<input type="hidden" name="ocultoempresa" id="ocultoempresa" value="<%=empresa_entrada%>" />
						
							<select class="form-control" name="cmbhoteles" size="1">
										<option value=""  selected="selected"><%=login_asm_combo_usuario%></option>
										<%while not hoteles.eof%>
											<option value="<%=hoteles("id")%>">(<%=hoteles("codigo_externo")%>) <%=hoteles("nombre")%></option>
											
											<%hoteles.movenext%>
										<%wend%>
									</select>

			    		</div>
			    		<div class="form-group">
			    			<input class="form-control" placeholder="<%=login_asm_contrasenna_default%>" name="txtcontrasenna" id="txtcontrasenna" type="password" value="">
			    		</div>
			    		
			    		<input class="btn btn-lg btn-danger btn-block" type="submit" value="<%=login_asm_boton_login%>">
					  
			    	</fieldset>
			      	</form>
			    </div>
			</div>
		</div>
	</div>
</div>






</body>
<%
hoteles.close
connimprenta.close

set hoteles=Nothing
set connimpresta=Nothing
%>
</html>