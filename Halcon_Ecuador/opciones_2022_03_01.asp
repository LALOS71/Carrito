<%@ language=vbscript %>

<%
	logotipo_empresa=Request.QueryString("logo")
	codigo_empresa=Request.QueryString("codigo_empresa")
	'response.write("empresa: " & codigo_empresa)
	'response.write("&nbsp;&nbsp;&nbsp;Logo: " & logotipo_empresa)
		
%>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">


<script language="JavaScript">

function mostrar(trozo)
		{
		var texto;
		if (trozo.charAt(0)=='f')
			quitartodoflechas();
		  else
		  	quitartodo();
		texto='document.all.' + trozo + '.style.visibility='+ '"visible"';
		
		eval(texto);
		}
	function quitar(trozo)
		{
		var texto;
		texto='document.all.' + trozo + '.style.visibility=' + '"hidden"';
		eval(texto);
		}
		
		function quitartodoflechas()
		{
			quitar('flechaazul1')
			quitar('flechaazul2')
		
		}
		
		function quitartodo()
		{
			quitar('peticiones')
			quitar('consultapedidos')
		}
		
		function cambiarimagen(trozo)
		{
		var texto;
		texto='document.' + trozo + '.src=' + '"imagenes/flechita_rojo.gif"';
		eval(texto);
		
		}

	function arrancar_imprenta(direccion)
	{
	document.getElementById('frmimprenta').action=direccion
	document.getElementById('frmimprenta').submit()
	}
</script>
<style>
.flecha
	{
		visibility:hidden;
	}

	a.enlace { 
			text-decoration:none;
			font: bold courier }
	a.enlace:link { color:#990000}
	a.enlace:visited { color:#990000}
	a.enlace:actived {color:#990000}
	a.enlace:hover {
			font: bold italic ;color:blue}
</style>

</head>

<body bgcolor="#FFFFFF" text="#000000" onload="mostrar('flechaazul1')">
<br>
<% if logotipo_empresa<>"" then%>
	<div align="center">
		<img src="<%=logotipo_empresa%>" width="90" height="32">
	</div>
<%end if%>
<br>
<br><br>
<div align="center">
<TABLE cellSpacing=0 cellPadding=0 width="99%" border=0>
	<TBODY> 
    <TR>
    	<TD width=16><IMG height=13 src="Imagenes/izq_arriba_gris.gif" width=16></TD>
      	<TD height="5" background=Imagenes/hor_arriba_GRIS.jpg></TD>
      	<TD width=16><IMG height=13 src="Imagenes/arriba_der_gris.gif" width=16></TD>
    </TR>
  	<TR>
		<TD background=Imagenes/vert_izq.gif height="55"><IMG height=6 src="Imagenes/vert_izq.gif" width=16></TD>
        <TD bgColor=#e6e6e6 height="55" align="center">
			<table width="97%" border="0">
    			<tr bgcolor="#CCCCCC"> 
      				<td colspan="2" bordercolor="#000066" bgcolor="#CCFFCC">&nbsp;</td>
    			</tr>
    			<tr bgcolor="#CCCCCC"> 
      				<td colspan="2" bordercolor="#000066" bgcolor="#CCFFCC"><img id="flechaazul1" name="flechaazul1" style="visibility:hidden" src="Imagenes/flechita_azul.gif" width="11" height="13">&nbsp;<b><a class="enlace" href="sucursales.asp?logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>" onmouseover="mostrar('flechaazul1')" target="right">Pedir</a></b></td>
    			</tr>
    			<tr bgcolor="#CCCCCC"> 
      				<td colspan="2" height="24" bordercolor="#000066" bgcolor="#CCFFCC"><img id="flechaazul2" style="visibility:hidden" src="Imagenes/flechita_azul.gif" width="11" height="13">&nbsp;<b><a class="enlace" href="Consulta/Inicio_consulta.asp?logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>" onmouseover="mostrar('flechaazul2')" target="right">Consultar</a></b></td>
    			</tr>
    			<tr bgcolor="#CCCCCC"> 
      				<td colspan="2" bordercolor="#000066" bgcolor="#CCFFCC">&nbsp;</td>
    			</tr>
		  </table>
			<br>
			
		
		</TD>
        <TD background=Imagenes/vert_der.gif height="55"><IMG height=6 src="Imagenes/vert_der.gif" width=16></TD>
    </TR>
  	<TR>
    	<TD height="2"><IMG height=13 src="Imagenes/izq_abajo.gif" width=16></TD>
      	<TD background=Imagenes/hor_abajo.gif height="2"></TD>
      	<TD height="2"><IMG height=13 src="Imagenes/abajo_der.gif" width=16></TD>
    </TR>
	</TBODY>
</TABLE>

</div>
<form id="frmimprenta" method="post" action="" target="_blank">
	<input type="hidden" id="ocultoip" name="ocultoip" value="<%=direccion_ip%>">

</form>
  
</body>
</html>
