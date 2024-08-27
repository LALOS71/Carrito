<%@ language=vbscript %>
<!--#include file="../../../../Data/Conexiones/Conexion_Gldistri.inc"-->
<%
		
		
		'recordsets
		dim articulos
		
		
		'variables
		dim codigofamilia
		dim nombrefamilia
		dim codigosucursal
		dim sql
		
		dim mostrarliteral1
		dim mostrarliteral2
		
		mostrarliteral1=1
		mostrarliteral2=1

		
	    
	    set articulos=Server.CreateObject("ADODB.Recordset")
		
		
		
		
		'recojo las variables que se me envian a la pagina
		codigosucursal=Request.QueryString("codsucursal")
		nombresucursal=Request.QueryString("nomsucursal")
		codigofamilia=Request.QueryString("codfamilia")
		nombrefamilia=Request.QueryString("nomfamilia")
		
		'response.write("codigo familia: " & codigofamilia)
		
		logotipo_empresa=Request.QueryString("logo")
		codigo_empresa=Request.QueryString("codigo_empresa")

		
		'establezco los articulos que pertenecen a la familia seleccionada
		if codigofamilia<>"" then
				sql="Select *  from articulos"
				sql=sql & " where familia =  " & codigofamilia 
				sql=sql & " and empresa = " & codigo_empresa
				sql=sql & " and Descripcion <> ''"
				sql=sql & " and Mostrar_Intranet='SI'"
				sql=sql & " and Activo = 1"
				sql=sql & " order by Descripcion"
				with articulos
					.ActiveConnection=conndistribuidora
					.Source=sql
					.Open
				end with
				'response.write(articulos.source)
			else
				nombrefamilia=""
		end if	
		

		
%>
 


<html>

<head>
<meta http-equiv="Content-Language" content="es">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Distribuidora</title>
<style>
	a.enlace { 
			text-decoration:none;
			font: courier }
	a.enlace:link { color:blue}
	a.enlace:visited { color:blue}
	a.enlace:active {color:blue}
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
		scrollbar-arrow-color: #000066; 
		scrollbar-base-color: #000033; 
		scrollbar-dark-shadow-color: #336699; 
		scrollbar-track-color: #336699; 
		scrollbar-face-color: #5e9ace; 
		scrollbar-shadow-color: #DDDDDD; 
		scrollbar-highlight-color: #CCCCCC; 
	
	
	}
	body__AZUL_CLARO {
		SCROLLBAR-FACE-COLOR: #6F9DE7; 
		SCROLLBAR-HIGHLIGHT-COLOR: #333399; 
		SCROLLBAR-SHADOW-COLOR: #ccffff; 
		SCROLLBAR-3DLIGHT-COLOR: #ccffff; 
		SCROLLBAR-ARROW-COLOR: white; 
		SCROLLBAR-TRACK-COLOR: #FFE8B7; 
		SCROLLBAR-DARKSHADOW-COLOR: #333399
	
	}
	body__AZUL_OSCURO {
	scrollbar-arrow-color: #000066; 
	scrollbar-base-color: #000033; 
	scrollbar-dark-shadow-color: #336699; 
	scrollbar-track-color: #336699; 
	scrollbar-face-color: #5e9ace; 
	scrollbar-shadow-color: #DDDDDD; 
	scrollbar-highlight-color: #CCCCCC; 
	}
	
	body__MARRON { 
		scrollbar-face-color: #A28D68; 
		scrollbar-shadow-color: #000000; 
		scrollbar-highlight-color: #000000; 
		scrollbar-3dlight-color: #000000; 
		scrollbar-darkshadow-color: #000000; 
		scrollbar-track-color: #A28D68; 
		scrollbar-arrow-color: #000000; } 

	BODY__ROJO {
	  scrollbar-face-color: #CC3333; 
	  scrollbar-shadow-color: #000000;
	  scrollbar-highlight-color: #000000; 
	  scrollbar-3dlight-color: #999999;
	  scrollbar-darkshadow-color: #505050; 
	  scrollbar-track-color: #cccccc;
	  scrollbar-arrow-color: #cccccc;
	  }
	
	body__MARRON_2 {	  
	  scrollbar-face-color: #663333;
scrollbar-highlight-color: #FFFFFF;
scrollbar-3dlight-color: #FFFFFF;
scrollbar-darkshadow-color:#FFFFFF ;
scrollbar-shadow-color:#FFFFFF;
scrollbar-arrow-color:#000000;
scrollbar-track-color: #000000;
}

body__VERDE_OSCURO{ 
scrollbar-arrow-color: #009100; 
scrollbar-base-color: #008000; 
scrollbar-dark-shadow-color: #008000; 
scrollbar-track-color: #008000; 
scrollbar-face-color: #008000; 
scrollbar-shadow-color: #008000; 
scrollbar-highlight-color: #008000; 
}

</style>

</head>

<body bgcolor="#FFFFFF" topmargin="0">
<div align="center"> </div>
<form id="frmArticulos" name="frmArticulos" method="post" >
  <div align="center">
    <table border="1" width="500" cellspacing="0">
      <tr bgcolor="#CCFFCC">
	  	<% if logotipo_empresa<>"" then%>	
        	<td width="396" bgcolor="#006600">
		<%else%>
		 	<td bgcolor="#006600">
		<%end if%>
          <div align="center"><b><font color="#FFFFFF">FAMILIA</font></b></div>
		  
        </td>
		<% if logotipo_empresa<>"" then%>
			<td width="94" rowspan="2" bgcolor="#006600">
				<div align="center">
					<img src="<%=logotipo_empresa%>" width="90" height="32">
				</div>
			</td>
		<%end if%>
      </tr>
		<tr>
        <td height="26" bgcolor="#CCFFCC"><font size="+1"> 
          <div align="center"><%=nombrefamilia%></div></font></td>
      </tr>
	  
    </table>
	
	
	<%if nombrefamilia="" then%>
			<br><br><br>
			<table align="center" width="70%"  border="1" cellspacing="0" cellpadding="0">
  				<tr>
    				<td bgcolor="#6699CC" align="center"><font color="#FFFFFF" size="4">...Se Ha de Seleccionar una Familia...</font></td>
  				</tr>
			</table>
			 
		<%else%>
	<%if not articulos.bof then %>
	<font size="4"><b>Pulse en el Artículo o en su Imagen para Añadirlo al Carrito</b></font> 	
    		<table align="center" width="90%"  border="1" cellspacing="0" cellpadding="0">
  				<tr>
    				<td bgcolor="#880000" align="center">
					<font color="#FFFFFF" size="4">
						En el caso de necesitar un cofre de una temática no disponible en la Distribuidora, debéis solicitarlo directamente a SMB al mail  <a href="mailto:soportedeventas@smartbox.es ">soportedeventas@smartbox.es </a><strong>(Consultar posibles gastos de envío) </strong> </font>					</td>
  				</tr>
			</table>
    <table width="100%" border="1" cellpadding="0" cellspacing="0">
      <tr> 
        <td bgcolor="#ffffcc" width="10%"> 
          <div align="center"><font size="+1">Imagen</font></div>
        </td>
        <td bgcolor="#ffffcc" width="40%"> 
          <div align="center"><font size="+1">Descripción</font></div>
        </td>
        <td bgcolor="#ffffcc" width="10%"> 
          <div align="center"><font size="+1">Imagen</font></div>
        </td>
        <td bgcolor="#ffffcc" width="40%"> 
          <div align="center"><font size="+1">Descripción</font></div>
        </td>
      </tr>
      <%while not articulos.eof%>
      <tr> 
        <td width="10%"> 
          <div align="center"><a href="anadir.asp?id=<%=articulos("cod")%>&codfamilia=<%=codigofamilia%>&nomfamilia=<%=nombrefamilia%>&codsucursal=<%=codigosucursal%>&logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>" target="_parent"><img src="../Imagenes_Articulos/<%=articulos("cod")%>.jpg" width="48" height="67" border="0"> 
            </a> </div>
        </td>
        <!-- <td><img src="Images/1012.jpg" width="100" height="150"></td>  -->
        <td width="40%"><a class="nosub" href="anadir.asp?id=<%=articulos("cod")%>&codfamilia=<%=codigofamilia%>&nomfamilia=<%=nombrefamilia%>&codsucursal=<%=codigosucursal%>&logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>" target="_parent"><font size="2"><b><%=articulos("descripcion")%></b></font></a>
				
		
		</td>
        <%mostrarliteral1=1%>
        <%articulos.movenext%>
        <%if not articulos.EOF then%>
        <td width="10%"> 
          <div align="center"><a href="anadir.asp?id=<%=articulos("cod")%>&codfamilia=<%=codigofamilia%>&nomfamilia=<%=nombrefamilia%>&codsucursal=<%=codigosucursal%>&logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>" target="_parent"><img src="../Imagenes_Articulos/<%=articulos("cod")%>.jpg" width="48" height="67" border="0"> 
            </a></div>
        </td>
        <!-- <td><img src="Images/1012.jpg" width="100" height="150"></td>  -->
        <td width="40%"><a class="nosub" href="anadir.asp?id=<%=articulos("cod")%>&codfamilia=<%=codigofamilia%>&nomfamilia=<%=nombrefamilia%>&codsucursal=<%=codigosucursal%>&logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>" target="_parent"><b><font size="2"><%=articulos("descripcion")%></font></b></a>
			
		</td>
        <%mostrarliteral2=1%>
        <%articulos.movenext%>
        <%end if%>
      </tr>
    
      <%wend%>
    </table>
			
    <%else%>
		<br><br><br>
			<table align="center" width="70%"  border="1" cellspacing="0" cellpadding="0">
  				<tr>
    				<td bgcolor="#6699CC" align="center"><font color="#FFFFFF" size="4">...No Hay Artículos de esta Familia...</font></td>
  				</tr>
			</table>
    <%end if%>
	<%end if%>
  </div>
</form>
 
 
</body>

</html>
<% 
		  
  		  if codigofamilia<>0 then
		  	articulos.close
		  end if
		  conndistribuidora.close
			  
			
			  set articulos=Nothing
			  
			  set conndistribuidora=Nothing

			%>

