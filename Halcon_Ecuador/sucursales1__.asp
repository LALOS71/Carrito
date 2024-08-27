<%@ language=vbscript %>
<!--#include file="Conexion_Gldistri.inc"-->

<% 
	'recordsets
		dim sucursales
		
		
		'variables
		dim codsucursal
		

	    
		set  sucursales=Server.CreateObject("ADODB.Recordset")
		
		
		codsucursal=Request.QueryString("codsucursal")
		
		logotipo_empresa=Request.QueryString("logo")
		codigo_empresa=Request.QueryString("codigo_empresa")
		
		'response.write("empresa: " & codigo_empresa)
		'response.write("&nbsp;&nbsp;&nbsp;Logo: " & logotipo_empresa)
		


		with sucursales
			.ActiveConnection=conndistribuidora
			.Source="SELECT COD, CODIGO, SUCURSAL"
			.Source= .Source & " FROM SUCURSALES"
			.Source= .Source & " WHERE (Empresa =" & codigo_empresa & ")"
			.Source= .Source & " AND (Activa = 1)"
			.Source= .Source & " AND (CODIGO<>'')"
			.Source= .Source & " AND (CODIGO<>'0')"
			.Source= .Source & " ORDER BY CODIGO, SUCURSAL"
			'.Source="Select  codigo, sucursal  from sucpcc1 where codigo='995' ORDER BY  codigo"
			
			.Open
		end with
	

		'recojo las variables que se me envian a la pagina
		
		
		
		
		if not sucursales.eof then
			if codsucursal = "" then
				'codsucursal=sucursales("codigo")
			end if
		end if
		
				
		'ponemos a 0 la variable de peticion de articulos
		Session("numero_articulos")=0
		
		
		'for i=1 to 300
		'	response.write(i & " - " & chr(i) & "<br>")
		'next
%>
 


<html>

<head>
<meta http-equiv="Content-Language" content="es">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Distribuidora</title>


<script language="JavaScript">


function seleccionarsuc()
{
	/* refresca el combo de sucursales en funcion del codigo
	     de sucursal que pongamos en la caja de texto   */
	//alert('tecla  ' + document.all.txtsucursal.value)

	document.all.cmbsucursal.value=document.all.txtsucursal.value.toUpperCase()
}

function ponersucursal()
{
	/*  refresca la caja de texto en funcion de la sucursal que
	     seleccionemos en el combo  */
	 
	document.all.txtsucursal.value=document.all.cmbsucursal.value
}

function validar()
{
	if (document.all.cmbsucursal.value=='')
		{
		alert('Se ha de Seleccionar una Sucursal Correcta...')
		return false
		}
	  else
	  	{
	     //alert(document.all.cmbsucursal.option)
	  	//location.href="peticiones/articulos.asp?codsucursal=" + document.all.txtsucursal.value
		//location.href="peticiones.asp?codsucursal=" + document.all.txtsucursal.value
		//alert('seguimos...')
		return true
		}
}


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
			
		.Estilo1 {font-family: Verdana, Arial, Helvetica, sans-serif; color:#FFFFFF; font-weight: bold; font-size: 15px; padding-bottom:5px}

		
			
	.cajatexto {
	BORDER-STYLE:groove;
	FONT-SIZE: 11px; 
	FONT-WEIGHT: bold;
	COLOR: black; 
	FONT-FAMILY: Arial, Helvetica, sans-serif; 
	TEXT-TRANSFORM: Uppercase;
	BACKGROUND-COLOR: lightblue;
}


</style>


<HTML lang=ES>
<HEAD>
<TITLE>
Plantilla	

</TITLE>
<META http-equiv=Content-Type content="text/html; charset=iso-8859-1"><LINK 
href="Imagenes/estils.css" type=text/css rel=stylesheet>
<META content="MSHTML 5.50.4134.600" name=GENERATOR>

</HEAD>
<BODY class=txt-rojo>


<DIV align=center><BR>
	<br>
	<% if logotipo_empresa<>"" then%>
		<div align="center"></div>
	<%end if%>
	<br>
    <br>
    <br>
    <br>
    <TABLE cellSpacing=0 cellPadding=0 width="880" border=0 height="126" >
      <TBODY> 
      <tr bgcolor="#D51619"> 
        					<td width="54" height="10">&nbsp; </td>
        					
        					
      					</tr>
        
        <TD height="128" width="641" align="center" valign="middle" bgcolor="#D51619">
			<%if not sucursales.eof then%>
			<form id="frmArticulos" name="frmArticulos" method="post" action="peticiones/articulos.asp" target="_parent" onsubmit="return validar()">
 				 	<input name="ocultocodigo_empresa" type="hidden" value="<%=codigo_empresa%>">
					<input name="ocultologotipo_empresa" type="hidden" value="<%=logotipo_empresa%>">
					<table border="0" width="97%" cellspacing="0">
				    	<tr bgcolor="#D51619"> 
					  		
                            <td width="338" height="10"><div align="left" class="Estilo1">Sucursal</div></td>
 
      					</tr>
      					<tr bgcolor="#D51619"> 
        					<td height="29" colspan="2" width="435"> 
          							<input style=" width:850px; border-radius:5px; height:40px;border-style:groove;FONT-WEIGHT: bold;BACKGROUND-COLOR: #ffffff" type="text"  class="cajatexto" value="<%=codsucursal%>" name="txtsucursal" id="txtsucursal" maxlength="25" size="20" onKeyUp="seleccionarsuc()">
        					</td>
        					
      					</tr>
      					<tr bgcolor="#D51619"> 
        					<td width="54" height="29">&nbsp; </td>
        					
        					
      					</tr>
      					<tr bgcolor="#D51619"> 
        					 <td width="338" height="10"><div align="left" class="Estilo1">Nombre</div></td>
 
        					
        					
      					</tr>
                        <tr bgcolor="#D51619"> 
        					<td width="435" height="29" colspan="2" bgcolor="#D51619"> 
          						<select  class="cajatexto" id="cmbsucursal" name="cmbsucursal" onChange="ponersucursal()" style=" width:850px; border-radius:5px; height:40px;border-style:groove;FONT-WEIGHT: bold;BACKGROUND-COLOR: #ffffff">
            						<option value="" SELECTED>Selecciona una Sucursal
									<% while not sucursales.EOF             
											If  sucursales("codigo") =codsucursal Then %>
            									<option value="<%=ucase(sucursales("codigo"))%>" SELECTED><%=ucase(sucursales("codigo"))%> - <%=sucursales("sucursal")%> 
            								<% Else%>
            									<option value="<%=ucase(sucursales("codigo"))%>"><%=ucase(sucursales("codigo"))%> - <%=sucursales("sucursal")%> 
            								<%End If%>
											<%sucursales.MoveNext%>
            						<% wend %>
          						</select>
       					  </td>
        					
        					
      					</tr>
                        
                        <tr bgcolor="#D51619"> 
        					 <td width="338" height="10"><div align="left" class="Estilo1"></div></td>
 
        					
        					
      					</tr>
                        
                        <tr bgcolor="#D51619"> 
        					<td height="29" colspan="2" width="435"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
          							<div align="center">
          							  <input style="  height:40px; width:250px; background-color:#E7940C; font-weight:bold; size:25px; color:#ffffff; border-radius:5px;" type="submit" id="continuar" name="continuar" value="EJECUTAR CONSULTA">
   							  </div>
        					</td>
 
        					
        					
   					  </tr>
                        
                        
                        
                        
   				   </table>
   				
			</form>
			<%else%>
			<table align="center" width="80%"  border="1" cellspacing="0" cellpadding="0">
  				<tr>
    				<td bgcolor="#6699CC" align="center"><font color="#FFFFFF" size="2">...No Existen Sucursales Para Esta Empresa...</font></td>
  				</tr>
			</table>
			<%end if%>

		</TD>
		
		
      
    </TR>
  <TR>
        
        
       
      </TR></TBODY></TABLE>
  
  <BR></DIV>
  
  </BODY>
  
  
  </HTML>
<% 
		 	  sucursales.close
			  conndistribuidora.close
		
			  set sucursales=Nothing
			  set conndistribuidora=Nothing
		

%>

