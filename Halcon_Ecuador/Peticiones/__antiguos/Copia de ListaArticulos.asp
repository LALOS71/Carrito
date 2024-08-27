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
		
		set datos_sucursal=Server.CreateObject("ADODB.Recordset")
		
		
		
		
		'recojo las variables que se me envian a la pagina
		codigosucursal=Request.QueryString("codsucursal")
		nombresucursal=Request.QueryString("nomsucursal")
		codigofamilia=Request.QueryString("codfamilia")
		nombrefamilia=Request.QueryString("nomfamilia")
		
		'response.write("codigo familia: " & codigofamilia)
		
		logotipo_empresa=Request.QueryString("logo")
		codigo_empresa=Request.QueryString("codigo_empresa")

		'para detectar si la sucursal tiene ya el mantenimiento
		'   de la Ricoh en coste por pagina
		with datos_sucursal
			.ActiveConnection=conndistribuidora
			.Source="SELECT * FROM SUCURSALES WHERE EMPRESA=" & codigo_empresa
			.Source=.Source & " AND CODIGO='" & codigosucursal & "'"
			'response.write("<br>" & .Source)
			.Open
		end with
		
		mantenimiento_coste_por_pagina="NO"
		if not datos_sucursal.eof then
			if datos_sucursal("impresora_coste_por_pagina") and (codigofamilia=5 or codigofamilia=25) then
				mantenimiento_coste_por_pagina="SI"
			end if
		end if	
		
		
		'establezco los articulos que pertenecen a la familia seleccionada
		if codigofamilia<>"" then
				sql="Select *  from articulos"
				sql=sql & " where familia =  " & codigofamilia 
				sql=sql & " and empresa = " & codigo_empresa
				sql=sql & " and Descripcion <> ''"
				sql=sql & " and Mostrar_Intranet='SI'"
				if mantenimiento_coste_por_pagina="SI" then
					sql=sql & " and Descripcion not like '%ricoh%'"
				end if
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
<script language="javascript">
function parpadear()
	{
		//alert('hola')
		//alert(document.all.enlace_prepagos.style.link.color)
		blink()
		//setTimeout('parpadear_prepagos()', 300)
	}
	
	
var col = new String();
var x=1;var y;
 
function blink()
{
 if(x%2) 
 {
  //col = "rgb(255,0,0)";
  //col = "#FFFFFF"
  //col = "#0000FF"
  col="FFFFFF"
  //Promociones_Vigentes_Parques.style.top='394px'
  //Promociones_Vigentes_Parques.style.left='561px'
   }else{
  //col = "rgb(255,255,255)";
  //col = "#FF9900";
  col="#000000"
  //Promociones_Vigentes_Parques.style.top='399px'
  //Promociones_Vigentes_Parques.style.left='564px'
  //col="darkblue"
  //col="#990000"
 }
 
 texto_parpadeo.style.color=col;
 texto_parpadeo2.style.color=col;
 x++;
 if(x>2)
 	{x=1};
setTimeout("blink()",700);
}



</script>
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
	
	<%if codigofamilia=50 or codigofamilia=51 then%>
			<br>&nbsp;
			<table align="center" width="90%"  border="1" cellspacing="0" cellpadding="0">
  				<tr>
    				<td bgcolor="#880000" align="center">
					<font color="#FFFFFF" size="4">
						En el caso de necesitar un cofre de una temática no disponible en la Distribuidora, 
						debéis solicitarlo directamente a LVEB: Raquel Mendez <a href="mailto:rmendez@lavidaesbella.es">rmendez@lavidaesbella.es</a>
					
					
					</font>
					</td>
  				</tr>
			</table>
			<br>&nbsp;
	<%end if%>
	
	
	
	<%if mantenimiento_coste_por_pagina="SI" then%>
			<br>&nbsp;
			<table align="center" width="90%"  border="1" cellspacing="0" cellpadding="0">
  				<tr>
    				<td bgcolor="#6699CC" align="center">
					<font color="#FFFFFF" size="4" id="texto_parpadeo">
						A partir de ahora, todos los <b>Consumibles de las Impresoras Ricoh</b> (Toner, Toner Residual, 
						Unidad de Transferencia, PCU - Fotoconductor, Fusor  y Kit de Mantenimiento) <b>NO se solicitaran 
						a la Distribuidora</b>, ya que las impresoras Ricoh han pasado a tener un mantenimiento de 
						Coste por Página. Para solicitar cualquiera de estos consumibles, debeis llamar a Soporte de 
						Microinformatica de Salamanca al telefono 902 178 196
					
					
					</font>
					</td>
  				</tr>
			</table>
			<br>&nbsp;
	<%end if%>
	
	
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
	
	<%if mantenimiento_coste_por_pagina="SI" then%>
			<br>&nbsp;
			<table align="center" width="90%"  border="1" cellspacing="0" cellpadding="0">
  				<tr>
    				<td bgcolor="#6699CC" align="center">
					<font color="#FFFFFF" size="4"  id="texto_parpadeo2">
						A partir de ahora, todos los <b>Consumibles de las Impresoras Ricoh</b> (Toner, Toner Residual, 
						Unidad de Transferencia, PCU - Fotoconductor, Fusor  y Kit de Mantenimiento) <b>NO se solicitaran 
						a la Distribuidora</b>, ya que las impresoras Ricoh han pasado a tener un mantenimiento de 
						Coste por Página. Para solicitar cualquiera de estos consumibles, debeis llamar a Soporte de 
						Microinformatica de Salamanca al telefono 902 178 196
					
					
					</font>
					</td>
  				</tr>
			</table>
			<br>&nbsp;
			<script language="javascript">
				parpadear()
			</script>
	<%end if%>
	
  </div>
</form>
 
 
</body>

</html>
<% 
		  
  		  if codigofamilia<>0 then
		  	articulos.close
		  end if
		  datos_sucursal.close
		  conndistribuidora.close
			  
			
			  set articulos=Nothing
			  set datos_sucursal=Nothing
			  
			  set conndistribuidora=Nothing

			%>

