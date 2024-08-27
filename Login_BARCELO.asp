<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->

<%
		
		
		'recordsets
		dim hoteles
		set hoteles=Server.CreateObject("ADODB.Recordset")
		
		empresa_entrada=1
		
		sql="Select id, nombre  from V_CLIENTES"
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

	<title>Acceso Peticiones Barceló</title>
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	
	<link href="estilos.css" rel="stylesheet" type="text/css" />
    <!-- Enhancement: To include TYNT -->
	<script language="javascript">
		function validar(formulario)
			{
				errores='no'
				cadena_errores=''
				if (formulario.cmbhoteles.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '\n\t- Se ha de Seleccionar un Hotel.'
					}
					
				if (formulario.txtcontrasenna.value=='')
					{
						errores='si'
						cadena_errores=cadena_errores + '\n\t- Se ha de Introducir la Contraseña Correspondiente.'
					}
					
				if (errores=='si')
					{
					cadena_errores='Se Han Producido los Siguientes Errores:\n\n' + cadena_errores
					alert(cadena_errores)
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
	<div id="loginform">
  		<table width="38%" cellspacing="6" cellpadding="0" class="logintable" align="center">
  			<tr>
  				<!--6.08 - Translate titles and buttons-->
  				<td class="al">
  					<span class='fontbold'>Login</span>
  				</td>
  			</tr>
  			<tr>
  				<td class="dottedBorder vt al" width="50%">
  					Introduzca su Usuario y Contraseña para Acceder. <br /><br />
  
 					<form name="form1" method="post" action="Validar.asp" onsubmit="return validar(this)">
						<input type="hidden" name="ocultoempresa" id="ocultoempresa" value="<%=empresa_entrada%>" />
						<table cellpadding="2" cellspacing="1" border="0" width="100%">
  							<tr>
								<td width="30%">Usuario: </td>
  								<td>
									<select class="txtfielddropdown" name="cmbhoteles" size="1">
										<option value=""  selected="selected">Seleccionar Hotel</option>
										<%while not hoteles.eof%>
											<option value="<%=hoteles("id")%>"><%=hoteles("nombre")%></option>
											<%hoteles.movenext%>
										<%wend%>
									</select>

								</td>
							</tr>
							<tr>
								<td width="30%">Password: </td>
								<td><input size="24" class="txtfield" type="password" name="txtcontrasenna" /></td>
							</tr>
  							<tr>
  								<td>&nbsp;</td>
								<td>
									<div align="right">
									  <input class="submitbtn" type="submit" name="Action" id="Action" value="Login" />
									</div>
  								</td>
  							</tr>
  						</table>
  					</form>
				</td>
			</tr>
	  </table>
	</div>

</body>
<%
hoteles.close
connimprenta.close

set hoteles=Nothing
set connimpresta=Nothing
%>
</html>