<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->

<%
		
		
		'recordsets
		dim clientes
		set clientes=Server.CreateObject("ADODB.Recordset")
		
		empresa_entrada=210
		
		sql="Select id, codigo_externo, nombre  from V_CLIENTES"
		sql=sql & " Where empresa=" & empresa_entrada
		sql=sql & " AND BORRADO='NO'"
		sql=sql & " order by codigo_externo, nombre"
		'response.write("<br>" & sql)
		
		with clientes
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

	<title>Acceso Peticiones MARSOL</title>

    <!-- Required meta tags -->
    
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	
	<link rel="stylesheet" href="plugins/bootstrap-4.3.1/css/bootstrap.min.css">
    <!-- Enhancement: To include TYNT -->
	<script language="javascript">
		function validar(formulario)
			{
				errores='no'
				cadena_errores=''
				if (formulario.cmbhoteles.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Seleccionar una Sucursal.'
					}
					
				if (formulario.txtcontrasenna.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Se ha de Introducir la Contraseña Correspondiente.'
					}
					
				if (errores=='si')
					{
					cadena_errores='Se Han Producido los Siguientes Errores:<br>' + cadena_errores
					//alert(cadena_errores)
					
					bootbox.alert({
									//size: 'large',
									message: cadena_errores
									//callback: function () {return false;}
								})	
					return false
					}
				  else
				  	{
				  	return true
					}
					
			
			}
	</script>
</head>

<body>




<div class="container h-100">
  <div class="row align-items-center h-100">
    
    <div class="col-6 mx-auto" style="padding-top:30px ">
      	<form name="frmlogin" id="frmlogin" method="post" action="Validar.asp" onsubmit="return validar(this)">
		<div class="card" style="width: 30rem;">
		  <div class="card-body">
			<div align="center"><img class="img-responsive" src="GAG/Images/Logo_Marsol.png" style="max-height:90px"/></div>
			<br />
			<h5 class="card-title">Login</h5>
			
			<p class="card-text">Introduzca su Usuario y Contraseña para Acceder.</p>
			<div class="form-group">
				<input type="hidden" name="ocultoempresa" id="ocultoempresa" value="<%=empresa_entrada%>" />
				<select class="form-control" name="cmbhoteles" size="1">
					<option value=""  selected="selected">Seleccionar Sucursal</option>
					<%while not clientes.eof%>
						<option value="<%=clientes("id")%>"><%=clientes("codigo_externo")%> - <%=clientes("nombre")%></option>
						<%clientes.movenext%>
					<%wend%>
				</select>
			</div>
			<div class="form-group">
				<input class="form-control" placeholder="Password" name="txtcontrasenna" id="txtcontrasenna" type="password" value="">
			</div>
			<div align="right">
				  <a href="#" class="btn btn-primary" onclick="$('#frmlogin').submit()">Login</a>
			</div>
		  </div>
		</div>
		</form>
    </div>
    
  </div>
</div>

</body>

<script type="text/javascript" src="plugins/jquery/jquery-3.4.1.min.js"></script>
<script type="text/javascript" src="plugins/popper/popper-1.14.7.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-4.3.1/js/bootstrap.min.js"></script>

<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>
<%
clientes.close
connimprenta.close

set clientes=Nothing
set connimpresta=Nothing
%>
</html>