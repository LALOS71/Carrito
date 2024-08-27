<%@ language=vbscript %>
<!--#include  file="../../../../data/conexiones/Conexion_Gldistri.inc" -->
<!--#include file="../../../../Data/Includes/formatear_fechas.inc"-->
<%

		'recordsets
		dim sucursales
	    
		logotipo_empresa=Request.QueryString("logo")
		codigo_empresa=Request.QueryString("codigo_empresa")
		'response.write("empresa: " & codigo_empresa)
		'response.write("&nbsp;&nbsp;&nbsp;Logo: " & logotipo_empresa)
		
	
		set  sucursales=Server.CreateObject("ADODB.Recordset")
		with sucursales
			.ActiveConnection=conndistribuidora
			.Source="SELECT COD, CODIGO, SUCURSAL"
			.Source= .Source & " FROM SUCURSALES"
			.Source= .Source & " WHERE (Empresa =" & codigo_empresa & ") AND (Activa = 1)"
			.Source= .Source & " ORDER BY CODIGO, SUCURSAL"
			'.Source="Select  codigo, sucursal  from sucpcc1 where codigo='995' ORDER BY  codigo"
			.Open
		end with
		quitar_calendarios="no"
		if sucursales.eof then
			quitar_calendarios="si"
		end if
	
		dia=day(date())
		if dia<10 then
			dia="0" & dia
		end if
		mes=month(date())
		if mes<10 then
			mes= "0" & mes
		end if
		anno=year(date())
		
		
		fechai="01-" & mes & "-" & anno
		fechaf=dia &"-" & mes & "-" & anno
			

		
		
%>

<html>
<head>
<title>Inicio consula</title>
<script language="JavaScript">
function cambia_combo()
{
	/* refresca el combo de sucursales en funcion del codigo
	     de sucursal que pongamos en la caja de texto   */
//	alert('SALGO')	 
	document.all.combo_sucursal.value=document.all.c_sucursal.value.toUpperCase()
}

function cambia_sucursal()
{
	/*  refresca la caja de texto en funcion de la sucursal que
	     seleccionemos en el combo  */
	document.all.c_sucursal.value=document.all.combo_sucursal.value
}

function validar()
{
	/* valida los datos de la sucursal */
 	valor=validando(document.f_inicio)
	if (valor==false)
	 return (false)
	else
		return (true)
}

	function validando(formulario)
	{
		var cadenaerror=''
		var error=false
		//alert('validando')
		
		
		cadenaerror='Los Siguientes Datos son Erroneos:\n\n'
		if (formulario.c_sucursal.value=='')
			{
				error=true
				cadenaerror+='   - Se Ha de Seleccionar una Sucursal...\n'
			}
		  else
		  	{
			if (formulario.combo_sucursal.value=='')
				{
				error=true
				cadenaerror+='   - La Sucursal Introducida Es Erronea...\n'
				}
			}
		if (formulario.C_Desde.value!='')
		{
		if (comprobar_formato_fecha(formulario.C_Desde.value))
			{
			if (!comprobar_fecha_correcta(formulario.C_Desde.value))
				{
					error=true
					cadenaerror+='   - La Fecha Desde NO Contiene un Valor Coherente...\n'
				}
			}	
		  else
		  	{
				error=true
				cadenaerror+='   - La Fecha Desde ha de Tener El Formato de dd-mm-yyyy\n'
			}	
		}
		else
			{
				error=true
				cadenaerror+='   - La Fecha Desde NO Puede Estar Vacia...\n'
				//document.all.C_hasta.value='<%=fechaf%>'
			}
	
	
		if (formulario.C_hasta.value!='')
		{
		if (comprobar_formato_fecha(formulario.C_hasta.value))
			{
			if (!comprobar_fecha_correcta(formulario.C_hasta.value))
				{
					error=true
					cadenaerror+='   - La Fecha Hasta NO Contiene un Valor Coherente...\n'
				}
			  /*
			  else
			  	if (formulario.txtfecha_fin.value > fecha_limite)	
					{
						//alert('texto:' + formulario.txtfecha_fin.value + ' dia hoy: ' + fecha_limite)
						error=true
						cadenaerror+='   - La Fecha de Fin NO Puede Ser Posterior a la Fecha de Hoy...\n'
						document.all.txtfecha_fin.value='<%=fechaf%>'
					}
				*/
			}	
		  else
		  	{
				error=true
				cadenaerror+='   - La Fecha Hasta ha de Tener El Formato de dd-mm-yyyy\n'
			}	
		}
		else
			{
				error=true
				cadenaerror+='   - La Fecha Hasta NO Puede Estar Vacia...\n'
				//document.all.C_hasta.value='<%=fechaf%>'
			}

	
		
		if (error)
			{
			alert(cadenaerror)
			return (false)
			}
		  else
		  	return (true)	
	
		
	}


</script>



<!-- European format dd-mm-yyyy -->
	<script language="JavaScript" src="../../../../cgi-bin/calendario/calendar1.js"></script>
<!-- Date only with year scrolling -->
<script type="text/javascript" language="javascript" src="../../../../Data/Includes/Comprobar_Formato_Datos.js">
</script>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<LINK href="Imagenes/estils.css" type=text/css rel=stylesheet>
<style>


body{ background-image:url(../../../../administracion/manuales/fondo/Administracion.png); background-repeat: no-repeat; background-position:center top;}

	.cajatexto {
	BORDER-STYLE:groove;
	FONT-SIZE: 11px; 
	FONT-WEIGHT: bold;
	COLOR: black; 
	FONT-FAMILY: Arial, Helvetica, sans-serif; 
	TEXT-TRANSFORM: Uppercase;
	BACKGROUND-COLOR: lightblue;
	}
	
	
	.Estilo1 {font-family: Verdana, Arial, Helvetica, sans-serif; color:#FFFFFF; font-weight: bold; font-size: 15px; padding-bottom:5px}
	
	
	
</style>


</head>

<body  class=txt-rojo>
<form name="f_inicio" method="post" action="consulta.asp" target="_parent" onsubmit="return validar()">
	<input name="ocultocodigo_empresa" type="hidden" value="<%=codigo_empresa%>">
	  <input name="ocultologotipo_empresa" type="hidden" value="<%=logotipo_empresa%>">
 
				
  			
		</TBODY>
  </TABLE>
  
  	<br>
	<% if logotipo_empresa<>"" then%>
		<div align="center">
			
		</div>
	<%end if%>
	<br>
  <br>
  
				    
  <TABLE align="center" cellSpacing=0 cellPadding=0 width="837" border=0 height="126">
      <TBODY> 
    
  <TR>
        
        <TD height="128" width="837" align="center" valign="middle" bgcolor="#D51619">
		<%if not sucursales.eof then%>
		 <table border="0" width="767" cellspacing="0" align="center">
    	
		<tr bgcolor="#D51619"> 
			      
			      <td width="358" height="10"><div align="left" class="Estilo1"></div></td>
                
                   <td width="16" height="10"><div align="left" class="Estilo1"></div></td>
				  
      				
   			  </tr>
				
				
    			
                
                
                
                
                <tr bgcolor="#D51619"> 
      
      <td width="358" height="29"> <div align="left" class="Estilo1">Sucursal</div></td>
      <td width="16" height="29">&nbsp;</td>
      <td width="10" height="29"> <div align="left" class="Estilo1"></div></td>
   
      <td width="358" height="29"> <div align="left" class="Estilo1">Nombre</div></td>
    </tr>
                
                
        <tr bgcolor="#D51619"> 
      
      <td width="358" height="59"> <input  type="text" name="c_sucursal" id="c_sucursal" maxlength="25" onKeyUp="cambia_combo()" style=" width:350px; border-radius:5px; height:40px;border-style:groove;FONT-WEIGHT: bold;BACKGROUND-COLOR: #ffffff"></td>
   
      <td width="16" height="59"> <div align="left" class="Estilo1"></div></td>
      <td width="10" height="59"> <div align="left" class="Estilo1"></div></td>
      <td width="358" height="59"><select class="cajatexto" id="combo_sucursal"  name="combo_sucursal" onChange="cambia_sucursal()" style=" width:350px; border-radius:5px; height:40px;border-style:groove;FONT-WEIGHT: bold;BACKGROUND-COLOR: #ffffff">
          <option value="000">Selecciona una sucursal</option>
		 <% while not sucursales.EOF%>
		 
           <option value="<%=sucursales("codigo")%>"><%=sucursales("codigo")%> - <%=sucursales("sucursal")%> 
		   <%sucursales.MoveNext%>
         <% wend %>	   
        </select></td>
    </tr>        
                
                
                
                
                
                
                
                
                
                
   
      
      
      
      <tr bgcolor="#D51619"> 
      
      <td width="358" height="29"> <div align="left" class="Estilo1">Fecha Desde</div></td>
      
      <td width="16" height="29"> <div align="left" class="Estilo1"></div></td>
      <td width="10" height="29"> <div align="left" class="Estilo1"></div></td>
      <td width="358" height="29"> <div align="left" class="Estilo1">Fecha Hasta</div></td>
    </tr>
                
             
                
    <tr bgcolor="#D51619"> 
      
       <td height="21" width="358"> 
        <input class="cajatexto" type="text" name="C_Desde" size="10" value="<%=fechai%>" style=" width:350; border-radius:5px; height:40px;border-style:groove;FONT-WEIGHT: bold;BACKGROUND-COLOR: #e6e6ff"></td>
      <td width="16" height="29"><a href="javascript:cal1.popup();"><img src="img/cal.gif" width="16" height="16" border="0" alt="Pulsa Aqui para Seleccionar una Fecha de Inicio"></a> </td>
      <td width="10" height="29"></td>
      
       <td height="21" width="358"> 
        <input class="cajatexto" type="text" name="C_hasta" size="10" value="<%=fechaf%>" style=" width:350px; border-radius:5px; height:40px;border-style:groove;FONT-WEIGHT: bold;BACKGROUND-COLOR: #e6e6ff"></td>
      <td width="15" height="29"><a href="javascript:cal2.popup();"><img src="img/cal.gif" width="16" height="16" border="0" alt="Pulsa Aqui para Seleccionar una Fecha Final"></a> </td>
    </tr>
    </table>
    
          <br>
          <table>
    
    <tr bgcolor="#D51619"> 
      
      
      <td height="18" width="208" class="Estilo1"> Enviados: <input type="radio" name="opcion_consulta" value="ENVIADOS" checked><font size="1">(valorado)</font> </td>
      <td height="11" width="165" class="Estilo1"> Pendientes:<input type="radio" name="opcion_consulta" value="PENDIENTES"></td>
      <td height="21" width="113" class="Estilo1"> Todos <input type="radio" name="opcion_consulta" value="TODOS"> </td>
      
    </tr>
    
    
    
    </table>
    <br>
     <br>
      <br>
    <table>
    <tr bgcolor="#D51619"> 
     
      
      <td height="21" width="880"> 
        <div align="center">
          <input type="submit" name="Submit" value="EJECUTAR CONSULTA" style="  height:40px; width:250px; background-color:#E7940C; font-weight:bold; size:25px; color:#ffffff; border-radius:5px;" >
        </div>
      </td>
    </tr>
  </table>
  <br>
	<%else%>
			<table align="center" width="80%"  border="1" cellspacing="0" cellpadding="0">
  				<tr>
    				<td bgcolor="#6699CC" align="center"><font color="#FFFFFF" size="2">...No Existen Sucursales Para Esta Empresa...</font></td>
  				</tr>
			</table>
	<%end if%>
		
		</TD>
		
		
        
    </TR>
  
  </TBODY></TABLE>
  
  
</form>


<script language="JavaScript">
		
			var cal1 = new calendar1(document.forms['f_inicio'].elements['C_Desde']);
			cal1.year_scroll = true;
			cal1.time_comp = false;
	
			var cal2 = new calendar1(document.forms['f_inicio'].elements['C_hasta']);
			cal2.year_scroll = true;
			cal2.time_comp = false;
	
	</script>

</body>
</html>
<% 
		  sucursales.close
  		  
		  conndistribuidora.close
			  
			  set sucursales=Nothing
				  
			  set conndistribuidora=Nothing
%>