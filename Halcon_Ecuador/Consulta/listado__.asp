<%@ language=vbscript %>
<!--#include  file="../../../../data/conexiones/conexion_distribuidora_pruebas.inc" -->
<%
			
		
		'recordsets
		dim envios
		
		'variables
		dim sql
  
	    
		
		set  envios=Server.CreateObject("ADODB.Recordset")
		

		

	with envios
			.ActiveConnection=conndistribuidora
			.Source="Select  *  from movimientos where tipo_movimiento=2 and sucursal='001'"
			.Open
		end with

		
%>
 


<html>

<head>
<meta http-equiv="Content-Language" content="es">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Consulta de la Distribuidora</title>

<style>
	a.enlace { 
			text-decoration:none;
			font: bold courier }
	a.enlace:link { color:#990000}
	a.enlace:visited { color:#990000}
	a.enlace:actived {color:#990000}
	a.enlace:hover {
			font: bold italic ;color:blue}
			
	a.nosub { 
			text-decoration:none;
			}
	a.nosub:link { color:blue}
	a.nosub:visited { color:blue}
	a.nosub:actived {color:blue}
	a.nosub:hover {
			font: bold italic ;color:#8080c0}
		
</style>

</head>

<body bgcolor="#FFFFFF">
<div align="center"> </div>



  <div align="center">
    <table border="1" width="98%" cellspacing="0">
      <tr bgcolor="#CCFFCC"> 
        <td height="35" colspan="4"><b><font size="+2"> 
          <div align="center">ENVIOS DE LA DISTRIBUIDORA</div>
          </font></b></td>
        </tr>
      <% while not envios.EOF%>
     <tr bgcolor="#CCFFCC"> 
        <td height="29" width="165"> <font size="1"><%=envios("codigo_articulo")%></font> 
        </td>
        <td height="29" width="165"><font size="1"><%=envios("precio")%></font></td>
        <td height="29" width="330"><font size="1"><%=envios("fecha")%></font></td>
        <%envios.MoveNext%>
     </tr>
   <% wend %>
    </table>
	
	
  </div>
<div align="right"><b><a class="nosub" href="Bottom.asp?codsucursal=<%=codigosucursal%>" target="_parent"><<< 
  Atrás</a></b> </div>
</body>

</html>
<% 
		  envios.close
  		  
		  conndistribuidora.close
			  
			  set envios=Nothing
				  
			  set conndistribuidora=Nothing
%>

