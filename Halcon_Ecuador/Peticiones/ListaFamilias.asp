<%@ language=vbscript %>
<!--#include file="../Conexion_Gldistri.inc"-->
<%
		
		
		'recordsets
		dim familias
		dim codigosucursal
		
		
		'variables
		dim sql
		
		
		codigosucursal=Request.Querystring("codsucursal")
		nombresucursal=Request.QueryString("nomsucursal")
		
		logotipo_empresa=Request.QueryString("logo")
		codigo_empresa=Request.QueryString("codigo_empresa")
		
		
		set  familias=Server.CreateObject("ADODB.Recordset")
		
		
		

		with familias
			.ActiveConnection=conndistribuidora
			.Source="Select *  from familias where mostrar_intranet='SI'"
			.Source= .Source & " And EMPRESA=" & codigo_empresa & " ORDER BY  Descripcion"
			.Open
		end with

		
		
		
		
%>
 


<html>

<head>
<meta http-equiv="Content-Language" content="es">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Distribuidora</title>

<style>
	a.enlace { 
			text-decoration:none;
			font: bold courier}
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
		
body {
	margin-top: 7px;
	
	scrollbar-arrow-color: #000066; 
	scrollbar-base-color: #000033; 
	scrollbar-dark-shadow-color: #336699; 
	scrollbar-track-color: #336699; 
	scrollbar-face-color: #5e9ace; 
	scrollbar-shadow-color: #DDDDDD; 
	scrollbar-highlight-color: #CCCCCC;
}
</style>

</head>

<body bgcolor="#FFFFFF">

<form id="frmArticulos" name="frmArticulos" method="post">
<div align="center">

<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
	<TBODY> 
    <TR>
    	<TD width=16><IMG height=13 src="Imagenes/izq_arriba_gris.gif" width=16></TD>
      	<TD height="5" background=Imagenes/hor_arriba_GRIS.jpg></TD>
      	<TD width=16><IMG height=13 src="Imagenes/arriba_der_gris.gif" width=16></TD>
    </TR>
  	<TR>
		<TD background=Imagenes/vert_izq.gif height="55"><IMG height=6 src="Imagenes/vert_izq.gif" width=16></TD>
        <TD bgColor=#e6e6e6 height="55" align="center">
			
  				
    			<table border="1" width="100%" cellspacing="0">
      				<tr bgcolor="#CCFFCC"> 
        				<td height="35" colspan="2">
							<b><font size="+2"><div align="center">Familias</div></font></b>
						</td>
      				</tr>
				<%if not familias.eof then%>	
	  			<% while not familias.EOF%> 
      				<tr bgcolor="#CCFFCC"> 
        				<td height="29" width="330">
			 				<font size="1" face="Times New Roman, Times, serif"><a class="enlace" href="ListaArticulos.asp?codsucursal=<%=codigosucursal%>&nomsucursal=<%=nombresucursal%>&codfamilia=<%=familias("cod")%>&nomfamilia=<%=familias("descripcion")%>&logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>" target="articulos"><%=familias("descripcion")%></a></font> 
						</td>
        			</tr> 
					<%Familias.MoveNext%>
	   			<% wend %>
				<%else%>
					<tr>
						<td>
							<table align="center" width="99%"  border="1" cellspacing="0" cellpadding="0">
  								<tr>
    								<td bgcolor="#6699CC" align="center"><font color="#FFFFFF" size="2">...No Existen Familias Para Esta Empresa...</font></td>
  								</tr>
							</table>
						</td>	
					</tr>
				<%end if%>	
       			</table>
				
			
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

<table width="100%"  border="0">
  <tr>
    <td>
		<div align="right"><b><a class="nosub" href="../Bottom.asp?codsucursal=<%=codigosucursal%>&empresa=<%=codigo_empresa%>" target="_parent"><font size="2"><<< 
  Atrás</font></a></b> </div>
	</td>
    
  </tr>
  <tr>
    <td>
		<a class="nosub" href="carrito.asp?codsucursal=<%=codigosucursal%>&nomsucursal=<%=nombresucursal%>&logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>" target="_parent"><b><font size="2">Ver 
  			Pedido</font></b></a>
  			&nbsp;&nbsp;&nbsp;&nbsp;
		<a class="nosub" href="vaciar_carro.asp?codsucursal=<%=codigosucursal%>&logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>" target="_parent"><b><font size="2">Vaciar 
		Pedido</font></b></a>
	</td>
  </tr>
  <tr>
  	<td>
		<div align="right"><img src="../Imagenes/carrito.gif"><font size="1">Cesta con 
  <font size="2"><b><%=Session("numero_articulos")%></b></font> Artículos </font></div>
	</td>
  </tr>
</table>
</div>
</form>
</body>
<% 
		  familias.close
  		  
		  conndistribuidora.close
			  
			  set familias=Nothing
			
			  
			  set conndistribuidora=Nothing

			%>

</html>
