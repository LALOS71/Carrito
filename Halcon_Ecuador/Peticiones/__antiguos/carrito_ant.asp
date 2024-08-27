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
		
		

	    
	    set articulos=Server.CreateObject("ADODB.Recordset")
		
		datossucursal=Request.QueryString("codsucursal") & " -- " & replace(Request.QueryString("nomsucursal"), "'", "´")

		logotipo_empresa=Request.QueryString("logo")
		codigo_empresa=Request.QueryString("codigo_empresa")
		

		





'Recogemos la variable borrar 
borrar=CInt(Request.Querystring("borrar"))
If borrar<>0 Then 'Si se ha pedido el borrado de un articulo
	i=1
	Do While borrar<>CInt(Session(i))
		i=i+1
	Loop
	For j=i to Session("numero_articulos")
		Session(j)=Session(j+1)
	Next
		Session("numero_articulos")=Session("numero_articulos")-1
End if

'Si no quedan articulos en el carrito despues del borrado
cadena="articulos.asp?codsucursal=" & codigosucursal
If Session("numero_articulos")= 0 Then
	'history.back()
	'Response.Redirect("bottom.asp")
end if
%>
<html>
<head>
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

<script language="javascript">
function cambiacomaapunto (s)
{
	var saux = "";
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ",")
			saux = saux + ".";
		else
			saux = saux + s.charAt (j);
	}
	return saux;
}

// una vez calculado el resultado tenemos que volver a dejarlo como es devido, con la coma
//    representando los decimales y no el punto
function cambiapuntoacoma(s)
{
	var saux = "";
	//alert("pongo coma")
	//alert("tamaño: " + s.legth)
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ".")
			saux = saux + ",";
		else
			saux = saux + s.charAt (j);
		//alert("total: " + saux)
	}
	return saux;
}

// ademas redondeamos a 2 decimales el resultado
function redondear (v){
	var vaux;
	vaux = Math.round (v * 100);
	vaux =  vaux / 100;
	return  vaux;
}


function calculartotal(i)
	{
		
		total=0
		//alert('articulos: ' + i)
		for (var j=1;j<=i;j++)
		{
			//alert('document.frmpedido.precio_' + j + '.value')
			precio=eval('document.frmpedido.precio_' + j + '.value')
			if (precio=='')
				precio=0;
			precio=cambiacomaapunto(precio)
			cantidad=eval('document.frmpedido.c_cantidad_' + j + '.value')
			if (cantidad=='')
				cantidad=0;
			cantidad=cambiacomaapunto(cantidad)
			//alert('precio ' + j + ': ' + precio +'\nCantidad ' + j + ': ' + cantidad)
	
			totalarticulo=(precio * cantidad)
			total=total + totalarticulo
			
			totalarticulo=redondear(totalarticulo)
			totalarticulo=cambiapuntoacoma(totalarticulo.toString())
			eval('document.frmpedido.total_articulo_' + j + '.value="' + totalarticulo + ' €"')
			
		}
		//alert('total: ' + total)
		//total=cambiapuntoacoma(total)
		if (i>0)
		{
			total=redondear(total)
			//alert(total)
			total=cambiapuntoacoma(total.toString())
			document.frmpedido.total.value=total + " €"
			//alert('calculamos total')
		}
	}
	
	
	function validar(num,datossucursal)
	{
		//alert('valido')
		//hay que comprobar repetidos
		i=1
		repetido=false
		while (i<num)
		{
			codigo=eval('document.frmpedido.c_articulo_' + i + '.value')
			for (j=i+1;j<=num;j++)
			{
				codigo_siguiente=eval('document.frmpedido.c_articulo_' + j + '.value')
				if (codigo==codigo_siguiente)
				{
					repetido=true;
					
				}
				//alert('Codigo: ' + codigo + '\nCod. Sig.: ' + codigo_siguiente)
				if (repetido==true)
				{
					j=num+1;
				}
			}
			if (repetido==true)
				{
				i=num+1
				}
			else
				i++;
		}
		//alert('Repetido ???: ' + repetido)
		
		if (repetido==true)
			{
				alert('En el Pedido Hay Articulos REPETIDOS,\n\n elimina una de las lineas Repetidas...	');
				valor=false;
			}
		  else
		  	{	
				valor=dato(num);
			}
		
		if (valor==true)
				{
					cadena='\t\tConfirmación de la Información'
					cadena=cadena + '\n\n¿ Está seguro que desea Realizar la Petición de Estos Artículos para esta SUCURSAL ? \n\n\t'
					cadena=cadena + datossucursal
					if (confirm(cadena))
						{
						mover_formulario('grabar')
						//document.frmpedido.submit()
						}
					  else
					  	{
						alert('\t...Regresamos a la Página Principal...\n\nAsegurese de Seleccionar Correctamente la Sucursal \npara la que Desea Realizar el Pedido')
					  	location.href='../Bottom.asp?empresa=<%=codigo_empresa%>'
						}
				}
	}
	
	
	function recalcular(num)
	{
		valor=dato(num)
		if (valor)
			calculartotal(num)
	}
	
   function mover_formulario(objetivo)
   {
   	if (objetivo=='volver')
   		accion='Articulos.asp?codsucursal=<%=Request.QueryString("codsucursal")%>'
	  else
	  	accion='Grabar_Pedido.asp';
	document.frmpedido.action=accion
	document.frmpedido.submit()	
	

   }
   	
</script>
<script language="vbscript">
	function dato(numero)
			cadena=""
			//alert("valido otra vez" & numero)
			cadena="Se han Encontrado los Siguientes Errores:" & chr(13)
			hayerror=0
			for m=1 to numero
				familia=eval("document.frmpedido.familia_" & m & ".value")
				articulo=eval("document.frmpedido.c_articulo_" & m & ".value")
				cantidad=eval("document.frmpedido.c_cantidad_" & m & ".value")
				if familia=10 or familia=30 then 'si es un articulo de grandes colectivos
					codigo_colectivo=eval("document.frmpedido.txtcodigo_colectivo_" & m & ".value")
				else				  	
					maximo=eval("document.frmpedido.maximo_" & m & ".value")
					minimo=eval("document.frmpedido.minimo_" & m & ".value")
				end if	
				'cadena=cadena & "Datos Linea " & m & ": art: " & articulo
				'cadena=cadena & " cant: " & cantidad & " max: " & maximo
				'cadena=cadena & " min: " & minimo & chr(13)
				if cantidad="" or cantidad="0" then
						cadena=cadena & vbtab & "- Si el Artículo de la Linea " & m & " no quieres pedirlo, Quitalo del Pedido." & chr(13)
						hayerror=1
					else
						if not isnumeric(cantidad) then
							cadena=cadena & vbtab & "- La Cantidad Pedida del Artículo de la Linea " & m & " ha de ser un dato numérico." & chr(13) 
							hayerror=1
							else
								if familia<>10 and familia<>30 then
									if minimo<>"" then
										if clng(cantidad) < clng(minimo) then
										cadena=cadena & vbtab & "- La Cantidad Pedida para el Artículo de la Linea " & m & " ha de ser mayor de " & minimo & "." & chr(13) 
										hayerror=1
										end if
									end if
									if maximo<>"" then
										if clng(cantidad) > clng(maximo) then
										cadena=cadena & vbtab & "- La Cantidad Pedida para el Artículo de la Linea " & m & " ha de ser menor de " & maximo & "." & chr(13) 
										hayerror=1
										end if
									end if
								else
									if codigo_colectivo="" then
										cadena=cadena & vbtab & "- Hay que indicar el Código del Colectivo para el Artículo de la Linea " & m & "." & chr(13)
										hayerror=1
									  else
									  	if len(codigo_colectivo)<>5 then
											cadena=cadena & vbtab & "- El Código del Colectivo para el Artículo de la Linea " & m & " ha de tener 5 Digitos." & chr(13)
										hayerror=1
										end if
									end if
								end if
						end if
				end if
				
			next
			//alert(cadena)
			
			
		'valor = document.frmdatos.[1visita].value
		'	cadena="Se han Encontrado los Siguientes Errores:" & chr(13)
		'	hayerror=0
		'	if valor<>"" then
		'		if not isdate(valor) then
		'			cadena=cadena & vbtab & "- 1º Contacto ha de ser una FECHA valida ( dd/mm/yyyy )" & chr(13)
		'			hayerror=1
		'			
		'		end if
		'	end if
		'	valor = document.frmdatos.[2visita].value
		'	if valor<>"" then
		'		if not isdate(valor) then
		'			cadena=cadena & vbtab & "- 2º Contacto ha de ser una FECHA valida ( dd/mm/yyyy )" & chr(13)
		'			hayerror=1
		'		end if
		'	end if
		'	
		'
			if hayerror then
				alert(cadena)
					dato=false
				else
					'validar formulario
					dato=true
					
			end if
		
	end function
	
	
</script>
</head>
<body onload="calculartotal(<%=Session("numero_articulos")%>)">
<form name="frmpedido" method="post" action="Grabar_Pedido.asp">
  <input name="ocultocodigo_empresa" type="hidden" value="<%=codigo_empresa%>">	
  <input name="ocultologotipo_empresa" type="hidden" value="<%=logotipo_empresa%>">
  <table align="center" width="100%" cellspacing="2" cellpadding="2" border="0">
    <tr> 
      <td bgcolor="#999966" align="center" colspan="8"><FONT face="verdana,arial,helvetica" size=3 color="#ffffff">DETALLE DE PETICION A LA DISTRIBUIDORA</font><br>
      </td>
    </tr>
  </table>
  
  <% if logotipo_empresa<>"" then%>
  	<table align="center" cellspacing="0" cellpadding="0" border="0">
    	<tr> 
      		<td height="37" align="center"  valign="middle">
				<div align="center">
					<img src="<%=logotipo_empresa%>" width="90" height="32">
				</div>
   		  </td>
    	</tr>
  	</table>
  <%end if%>
  <table align="center" width="100%" cellspacing="2" cellpadding="2" border="0">
    <tr> 
      <td bgcolor="#999966" align="center" colspan="8" height="14"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff"><b>Sucursal: 
        <%=datossucursal%> 
        <input type="hidden" name="c_sucursal" value="<%=Request.QueryString("codsucursal")%>">
        </b></font><br>
      </td>
    </tr>
    <tr> 
      <!-- Para cuando sale el articulo y la familia 
      <td bgcolor="#cc9900" colspan="2" ><FONT face="verdana,arial,helvetica" size=2 color="#ffffff">Artículo</font></td>
  	  <td bgcolor="#cc9900" width="170"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff">Familia</font></td>
      -->
      <td bgcolor="#cc9900" ><FONT face="verdana,arial,helvetica" size=2 color="#ffffff">Artículo</font></td>
      <td bgcolor="#cc9900" width="70"> 
        <div align="center"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff">Precio</font></div>
      </td>
      
      <td bgcolor="#cc9900" width="58"> 
        <div align="center"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff">Cantidad</font></div>
      </td>
	  <td width="41" bgcolor="#CC9900">
        <div align="center"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff">Total</font></div>
      </td>
      <td bgcolor="#cc9900" width="33"> 
        <div align="center"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff">Max.</font></div>
      </td>
      <td bgcolor="#cc9900" width="30"> 
        <div align="center"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff">Min.</font></div>
      </td>
	  <td bgcolor="#cc9900" width="77"> 
        <div align="center"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff">Expediente</font></div>
      </td>
      
    </tr>
	
	<%if Session("numero_articulos")=0 then%>
		<tr> 
      		
      <td bgcolor="#999966" align="center" colspan="8"><b><FONT face="verdana,arial,helvetica" size=4 color="#ffffff">El 
        Pedido No Tiene Articulos...</font> &nbsp;&nbsp;&nbsp;<a class="nosub" href="#" onclick="mover_formulario('volver'); return false">Volver</a></b><br>
   		  </td>
    	</tr>
	<%end if%>
	
    <%
'Iniciamos las variables
i=1 'contador de articulos
Session("total")=0 'precio del pedido

'Comenzamos la impresion de los articulos del carrito
While i<=Session("numero_articulos")
	id=Session(i)
'***************************************************	
'Generamos nuestra sentencia SQL y la ejecutamos
' esta sentencia es para cuando queremos mostrar
' el articulo y la familia a la que pertenece
'***************************************************
'sql="SELECT ARTICULOS.CODIGO, ARTICULOS.DESCRIPCION as articulo, FAMILIAS.DESCRIPCION as familia, ARTICULOS.PEDIDO_MAXIMO, ARTICULOS.PEDIDO_MINIMO"
'sql=sql & " FROM ARTICULOS, FAMILIAS WHERE ARTICULOS.FAMILIA = FAMILIAS.CODIGO_FAMILIA"
'sql=sql & " and articulos.codigo=" & id
'**********************************************************************

'*******************************************************
'esta otra sentencia es para mostrar solo datos de la tabla
'  articulos, sin la familia pero con el precio
sql="SELECT ARTICULOS.COD, ARTICULOS.DESCRIPCION as articulo, ARTICULOS.PRECIO_COMPRA, ARTICULOS.PEDIDO_MAXIMO, ARTICULOS.PEDIDO_MINIMO, ARTICULOS.FAMILIA"
sql=sql & " FROM ARTICULOS WHERE articulos.cod=" & id


				with articulos
					.ActiveConnection=conndistribuidora
					.Source=sql
					.Open
				end with


%>

<%'response.write("<br>" & articulos("familia"))%>
<%if articulos("familia")<>10 and articulos("familia")<>30 then
 'si el articulo no es de grandes colectivos
%>
    <tr> 
      
      <!-- esto es para cuando se muestra el articulo y su familia, sin el 
	  		precio
	  <td bgcolor="#cc9900" width="298" > 
        <input type="hidden" name="c_articulo_<%=i%>" value="<%=id%>">
        <FONT face="verdana,arial,helvetica" size=2 color="#ffffff"><%=id%> - 
        <%=articulos("articulo")%></font></td>
      <td bgcolor="#cc9900" width="170"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff">
	  		<%'=articulos("familia")%>
			
			</font></td>
      -->
      <td bgcolor="#cc9900" width="298" > 
        <input type="hidden" name="c_articulo_<%=i%>" value="<%=id%>">
		<input type="hidden" name="familia_<%=i%>" value="<%=articulos("familia")%>">
        <FONT face="verdana,arial,helvetica" size=2 color="#ffffff"><%=id%> - 
        <%=articulos("articulo")%></font></td>
      <td bgcolor="#cc9900" width="70" align="right"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff"> 
        <%=articulos("precio_compra")%>
		<%if articulos("precio_compra")<>"" then%>
		 	€
		<%end if%>
		 </font>
		 <input type="hidden" name="precio_<%=i%>" id="precio_<%=i%>" value="<%=articulos("precio_compra")%>">
	  </td>
      
      <td bgcolor="#cc9900" width="58"> 
        <div align="center"> 
          <%if articulos("pedido_minimo")>0 then%>
          <input type="text" name="c_cantidad_<%=i%>" size="6" style="border-style: groove;font-face:verdana,arial,helvetica;font-size:11px;color:#800000;background-color:#ffcc66" 
						value="<%=articulos("pedido_minimo")%>" 
						onblur="recalcular(<%=Session("numero_articulos")%>)">
          <%else%>
          <input type="text" name="c_cantidad_<%=i%>" size="6" style="border-style: groove;font-face:verdana,arial,helvetica;font-size:11px;color:#800000;background-color:#ffcc66" 
						value="1"
						onblur="recalcular(<%=Session("numero_articulos")%>)">
          <%end if%>
        </div>
      </td>
	  <td width="41" bgcolor="#CC9900">
        <div align="center"><input readonly type="text" class="totales" name="total_articulo_<%=i%>" size="12" style="border-style: none;font-weight:bold;font-face:verdana,arial,helvetica;font-size:11px;color:#FFFFFF;background-color:#cc9900;text-align:right"></div>
      </td>
      <td bgcolor="#cc9900" width="33">&nbsp;<%=articulos("pedido_maximo")%> 
        <input type="hidden" name="maximo_<%=i%>" value="<%=articulos("pedido_maximo")%>">
      </td>
      <td bgcolor="#cc9900" width="30">&nbsp;<%=articulos("pedido_minimo")%> 
        <input type="hidden" name="minimo_<%=i%>" value="<%=articulos("pedido_minimo")%>">
      </td>
	  <td bgcolor="#cc9900" width="77"> 
        <div align="center"> 
          <input type="text" name="c_expediente_<%=i%>" size="12" style="border-style: groove;font-face:verdana,arial,helvetica;font-size:11px;color:#880000;background-color:#ffcc66">
        </div>
      </td>
      <td bgcolor="#cc9900" width="41"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff"><a href="carrito.asp?borrar=<%=id%>&codsucursal=<%=Request.QueryString("codsucursal")%>&nomsucursal=<%=Request.QueryString("nomsucursal")%>&logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>">Quitar</a></font></td>
    </tr>

<%else  'cuando la familia son los grandes colectivos hay que indicar el codigo del colectivo
%>
    <tr> 
      
      <td bgcolor="blue" width="298" > 
        <input type="hidden" name="c_articulo_<%=i%>" value="<%=id%>">
		<input type="hidden" name="familia_<%=i%>" value="<%=articulos("familia")%>">
        <FONT face="verdana,arial,helvetica" size=2 color="#ffffff"><%=id%> - 
        <%=articulos("articulo")%></font></td>
      <td bgcolor="#cc9900" width="70" align="right"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff"> 
        <%=articulos("precio_compra")%>
		<%if articulos("precio_compra")<>"" then%>
		 	€
		<%end if%>
		 </font>
		 <input type="hidden" name="precio_<%=i%>" id="precio_<%=i%>" value="<%=articulos("precio_compra")%>">
	  </td>
      
      <td bgcolor="#cc9900" width="58"> 
        <div align="center"> 
          <%if articulos("pedido_minimo")>0 then%>
          <input type="text" name="c_cantidad_<%=i%>" size="6" style="border-style: groove;font-face:verdana,arial,helvetica;font-size:11px;color:#800000;background-color:#ffcc66" 
						value="<%=articulos("pedido_minimo")%>" 
						onblur="recalcular(<%=Session("numero_articulos")%>)">
          <%else%>
          <input type="text" name="c_cantidad_<%=i%>" size="6" style="border-style: groove;font-face:verdana,arial,helvetica;font-size:11px;color:#800000;background-color:#ffcc66" 
						value="1"
						onblur="recalcular(<%=Session("numero_articulos")%>)">
          <%end if%>
        </div>
      </td>
	  <td width="41" bgcolor="#CC9900">
        <div align="center"><input readonly type="text" class="totales" name="total_articulo_<%=i%>" size="12" style="border-style: none;font-weight:bold;font-face:verdana,arial,helvetica;font-size:11px;color:#FFFFFF;background-color:#cc9900;text-align:right"></div>
      </td>
      <td bgcolor="#cc9900" width="33">
	  	<div align="center"><FONT size=2 color="blue">Codigo Colectivo</font>
	      </div></td>
      <td bgcolor="#cc9900" width="30">
	  	<div align="center">
          <input name="txtcodigo_colectivo_<%=i%>" type="text" style="border-style: groove;font-face:verdana,arial,helvetica;font-size:11px;color:#880000;background-color:#ffcc66" size="6" maxlength="5">
          
        </div></td>
      
	  <td bgcolor="#cc9900" width="77"> 
        <div align="center"> 
          <input type="text" name="c_expediente_<%=i%>" size="12" style="border-style: groove;font-face:verdana,arial,helvetica;font-size:11px;color:#880000;background-color:#ffcc66">
        </div>
      </td>
      <td bgcolor="#cc9900" width="41"><FONT face="verdana,arial,helvetica" size=2 color="#ffffff"><a href="carrito.asp?borrar=<%=id%>&codsucursal=<%=Request.QueryString("codsucursal")%>&nomsucursal=<%=Request.QueryString("nomsucursal")%>&logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>">Quitar</a></font></td>
    </tr>
<%end if%>	

    <%
		if articulos("precio_compra")="" then
			precios=0
		  else
		  	precios=articulos("precio_compra")
		end if
		
	i=i+1
	articulos.close
Wend

%>
<%if Session("numero_articulos")<>0 then %>

    <!-- esta linea se muestra para el caso de mostrar el articulo y su precio
-->
    <tr> 
      <td bgcolor="#cc9900" colspan="3" > 
        <div align="right"><font face="verdana,arial,helvetica" size="2" color="#ffffff"><b>Total 
          Pedido... </b></font></div>
      </td>
      <td bgcolor="#cc9900" width="70"> 
        <input readonly type="text" class="totales" name="total" size="12" style="border-style: none;font-weight:bold;font-face:verdana,arial,helvetica;font-size:11px;color:#880000;background-color:#ffcc66;text-align:right">
      </td>
      <td width="77" > </td>
      <td width="58" > </td>
      <td width="33" > </td>
      <td width="30" > </td>
      
    </tr>
<%end if%>
  </table>
<%if Session("numero_articulos")<>0 then %>
	
  <p>
    <input type="button" name="Submit" value="Enviar"  onclick="return validar(<%=Session("numero_articulos")%>,'<%=datossucursal%>')">
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="nosub" href="#" onclick="mover_formulario('volver'); return false">Continuar 
    con la Petici&oacute;n</a> 
    <%end if%>
  </p>
  
</form>

</body>
<%
	'articulos.close
	conndistribuidora.close
	
	set articulos=Nothing
	set conndistribuidora=Nothing

%>
</html>
