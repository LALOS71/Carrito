<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--#include file="Conexion.inc"-->
<%
		
	'recordsets
	dim hoteles
	set hoteles=Server.CreateObject("ADODB.Recordset")
		
	empresa_entrada= 130 ' 130-> Geomon, 4->ASM
		
	sql="SELECT id, codigo_externo, nombre  FROM V_CLIENTES"
	sql=sql & " WHERE empresa=" & empresa_entrada
	sql=sql & " AND BORRADO='NO'"
	sql=sql & " ORDER by nombre"
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

<title>Acceso Peticiones Geomon</title>
<meta name="description" content="" />
<meta name="keywords" content="" />
	
<link href="estilos.css" rel="stylesheet" type="text/css" />


<script type="text/javascript">
function validar(formulario){
	errores='no'
	cadena_errores=''
	if (formulario.cmbhoteles.value=='')		{
			errores='si'
			cadena_errores=cadena_errores + '\n\t- Se ha de Seleccionar una Sucursal'
		}
					
	if (formulario.txtcontrasenna.value=='')		{
			errores='si'
			cadena_errores=cadena_errores + '\n\t- Se ha de Introducir la Contraseña Correspondiente.'
		}
					
	if (errores=='si') 		{
		    cadena_errores='Se Han Producido los Siguientes Errores:\n\n' + cadena_errores
		    alert(cadena_errores)
		    return false
		}
		else	{
		    return true
	}
								
}// validar(formulario) --

</script>
</head>
<body>
	

<table width="54%" height="253" align="center" cellpadding="0" cellspacing="6" >
    <tr>
        <td><span class='fontbold'>Introduzca su Usuario y Contraseña para Acceder.</span></td>
    </tr>
	<tr>  				
    <td  width="50%" style="background-image:url(GEO/Images/Logo_GEO_Login.jpg); background-repeat:no-repeat" valign="bottom" >
  		<br /><br />
 		<form name="form1" method="post" action="Validar.asp" onsubmit="return validar(this)">
			<input type="hidden" name="ocultoempresa" id="ocultoempresa" value="<%=empresa_entrada%>" />
			<table cellpadding="2" cellspacing="1" border="0" width="100%">
  				<tr>
					<td width="30%" align="right"  style="color:#FFFFFF ">Usuario:&nbsp;</td>
  					<td colspan="2">
						<select class="txtfielddropdown" name="cmbhoteles" size="1">
							<option value=""  selected="selected">Seleccionar Sucursal</option>
							<%while not hoteles.eof%>
								<option value="<%=hoteles("id")%>">(<%=hoteles("codigo_externo")%>) <%=hoteles("nombre")%></option>
								<%hoteles.movenext%>
							<%wend%>
						</select>

					</td>
				</tr>
				<tr><td height="5"></td></tr>
				<tr>
					<td width="30%" align="right" style="color:#FFFFFF ">Password:&nbsp;</td>
					<td width="33%"><input size="24" class="txtfield" type="password" name="txtcontrasenna" /></td>
					<td width="37%">
						<div align="left">
							<input class="submitbtn" type="submit" name="Action" id="Action" value="Login" />
						</div>
  					</td>
				</tr>
  				<tr>
  					<td height="5"></td>								
  				</tr>
  			</table>
  		</form>
	</td>
</tr>
</table>
</body>
<%
hoteles.close
connimprenta.close

set hoteles=Nothing
set connimpresta=Nothing
%>
</html>