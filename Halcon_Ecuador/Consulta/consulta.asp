<%@ LANGUAGE = VBScript %>
<!--#include  file="../Conexion_Gldistri.inc" -->

<% 
		'recordsets
		dim envios
		'variables de entrada
        dim cod_sucursal
		dim fecha_ini
		dim fecha_fin
		
		
		'variable para almacenar la sentencia SQL
		dim sql
		'variable para almacenar el total enviado
		dim total
		total=0
		'variable para el tipo de consulta
		dim tipo_consulta
		dim hay_datos

		'obtengo los parametros de entrada
        cod_sucursal=Request.Form("c_sucursal")
		fecha_ini=Request.Form("c_desde")
		fecha_fin=Request.Form("c_hasta")
		tipo_consulta=request.Form("opcion_consulta")
		
		codigo_empresa=Request.Form("ocultocodigo_empresa")
		logotipo_empresa=Request.Form("ocultologotipo_empresa")
		'response.write("empresa: " & codigo_empresa)
		'response.write("&nbsp;&nbsp;&nbsp;Logo: " & logotipo_empresa)
		
		'activo el recordset
  		set  envios=Server.CreateObject("ADODB.Recordset")
		
		set  sucursales=Server.CreateObject("ADODB.Recordset")
		with sucursales
			.ActiveConnection=conndistribuidora
			.Source="SELECT COD"
			.Source= .Source & " FROM SUCURSALES"
			.Source= .Source & " WHERE (Empresa =" & codigo_empresa & ")"
			.Source= .Source & " and codigo='" & cod_sucursal & "'"
			.Source= .Source & " and Activa=1"
			.Open
		end with
		codigo_sucursal_bueno=sucursales("cod")
		sucursales.close
		set sucursales=Nothing

        
		'cargo la sentencia del SQL 
		if (tipo_consulta="ENVIADOS") then
		  	sql="SELECT MOVIMIENTOS.NUMERO_MOVIMIENTO, MOVIMIENTOS.CODIGO_ARTICULO, ARTICULOS.DESCRIPCION, FAMILIAS.DESCRIPCION AS NOMBRE_FAMILIA,"
		  	sql=sql&" ARTICULOS.FAMILIA, MOVIMIENTOS.CANTIDAD, MOVIMIENTOS.PESO, MOVIMIENTOS.PRECIO, "
		  	sql=sql&" MOVIMIENTOS.EXPEDIENTE, MOVIMIENTOS.PEDIDO, MOVIMIENTOS.FECHA,MOVIMIENTOS.SUCURSAL, MOVIMIENTOS.PRECIO*MOVIMIENTOS.CANTIDAD AS TOTAL "
		  	sql=sql&" FROM MOVIMIENTOS LEFT OUTER JOIN ARTICULOS ON MOVIMIENTOS.CODIGO_ARTICULO = ARTICULOS.COD "
		  	sql=sql&" LEFT OUTER JOIN FAMILIAS ON ARTICULOS.FAMILIA = FAMILIAS.COD "
		  	sql=sql&" WHERE (MOVIMIENTOS.TIPO_MOVIMIENTO=2) AND (MOVIMIENTOS.SUCURSAL='"&codigo_sucursal_bueno&"') "
		  	sql=sql&" AND (MOVIMIENTOS.FECHA>='"&fecha_ini&"') AND (MOVIMIENTOS.FECHA<='"&fecha_fin&"')"
		  	sql=sql&" ORDER BY MOVIMIENTOS.FECHA"
        else
 		  	sql="SELECT DETALLES_PEDIDOS_SUCURSALES.SUCURSAL, DETALLES_PEDIDOS_SUCURSALES.NUMERO_PEDIDO, DETALLES_PEDIDOS_SUCURSALES.CODIGO_ARTICULO, DETALLES_PEDIDOS_SUCURSALES.CANTIDAD, DETALLES_PEDIDOS_SUCURSALES.EXPEDIENTE,DETALLES_PEDIDOS_SUCURSALES.ESTADO, "
          	sql=sql&" CABECERAS_PEDIDOS_SUCURSALES.FECHA, ARTICULOS.DESCRIPCION,ARTICULOS.FAMILIA, FAMILIAS.DESCRIPCION AS NOMBRE_FAMILIA,ARTICULOS.PRECIO_COMPRA, SUCURSALES.SUCURSAL AS NOMBRE_SUCURSAL "
          	sql=sql&" FROM ((DETALLES_PEDIDOS_SUCURSALES LEFT JOIN CABECERAS_PEDIDOS_SUCURSALES ON (DETALLES_PEDIDOS_SUCURSALES.NUMERO_PEDIDO = CABECERAS_PEDIDOS_SUCURSALES.NUMERO_PEDIDO) AND (DETALLES_PEDIDOS_SUCURSALES.SUCURSAL = CABECERAS_PEDIDOS_SUCURSALES.SUCURSAL)) "
          	sql=sql&" LEFT JOIN ARTICULOS ON DETALLES_PEDIDOS_SUCURSALES.CODIGO_ARTICULO = ARTICULOS.COD) LEFT JOIN SUCURSALES ON DETALLES_PEDIDOS_SUCURSALES.SUCURSAL = SUCURSALES.COD "
			sql=sql&" LEFT OUTER JOIN FAMILIAS ON ARTICULOS.FAMILIA = FAMILIAS.COD "
		  	sql=sql&" WHERE (CABECERAS_PEDIDOS_SUCURSALES.SUCURSAL='"&codigo_sucursal_bueno&"') "
		  	sql=sql&" AND (CABECERAS_PEDIDOS_SUCURSALES.FECHA>='"&fecha_ini&"') AND (CABECERAS_PEDIDOS_SUCURSALES.FECHA<='"&fecha_fin&"') "
			if (tipo_consulta="PENDIENTES") then	
         	   	sql=sql&" AND (DETALLES_PEDIDOS_SUCURSALES.ESTADO='PENDIENTE') "
			end if
		  	sql=sql&" ORDER BY CABECERAS_PEDIDOS_SUCURSALES.FECHA "		  
		end if 
		with envios
			.ActiveConnection=conndistribuidora
			.Source=sql			 			
			.Open
		end with

%>
<html>
<head>
<title>Resultado de la consulta</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<% if envios.eof then %>
<% 	hay_datos="NO" %>
<% else %>
<%  hay_datos="SI" %>
<% end if %>

<% if tipo_consulta="ENVIADOS" then %>
<table width="99%" border="1">
  <tr bgcolor="#99CC99"> 
    <td colspan="6"> 
      <div align="center"> 
	  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
  		<tr>
    		<td><div align="center"><font face="Arial, Helvetica, sans-serif" size="4"><b><i>ENVIOS REALIZADOS 
            A LA SUCURSAL <%=cod_sucursal%> </i></b></font></div></td>
  		</tr>
  		<tr>
    		<td>
				<div align="center">
				    <% if logotipo_empresa<>"" then%>
					  <img src="../<%=logotipo_empresa%>" width="136" height="41">
			        <%end if%>
			      </div></td>
  		</tr>
  		<tr>
    		<td><div align="center"><font face="Arial, Helvetica, sans-serif" size="4"><b><i>ENTRE LAS 
            FECHAS <%=fecha_ini%> y <%=fecha_fin%></i></b></font></div></td>
  		</tr>
	  </table>
      </div>
    </td>
  </tr>
  <tr bgcolor="#99CCCC"> 
    <td width="12%"><b>Fecha envio</b></td>
    <td width="28%" bgcolor="#99CCCC"> 
      <div align="center"><b>Articulo</b></div>
    </td>
    <td width="23%" bgcolor="#99CCCC"> 
      <div align="center"><b>Tipo</b></div>
    </td>
    <td width="12%"> 
      <div align="center"><b>Cantidad</b></div>
    </td>
    <td width="10%"> 
      <div align="center"><b>Precio</b></div>
    </td>
    <td width="15%"> 
      <div align="center"><b>Total</b></div>
    </td>
  </tr>
  <% while not envios.EOF%>
  <tr bgcolor="#FFFFCC"> 
    <td width="12%" height="21"><font face="Arial, Helvetica, sans-serif" size="1"><%=envios("fecha")%></font></td>
    <td width="28%" height="21"><font face="Arial, Helvetica, sans-serif" size="1"><%=envios("descripcion")%></font></td>
    <td width="23%" height="21"><font face="Arial, Helvetica, sans-serif" size="1"><%=envios.fields("NOMBRE_FAMILIA")%></font></td>
    <td width="12%" height="21"> 
      <div align="right"><font face="Arial, Helvetica, sans-serif" size="1"><%=formatnumber(envios("cantidad"),0)%></font></div>
    </td>
    <td width="10%" height="21"> 
      <div align="right"><font face="Arial, Helvetica, sans-serif" size="1"><%=formatnumber(envios("precio"),2)%></font></div>
    </td>
    <td width="15%" height="21"> 
      <div align="right"><font face="Arial, Helvetica, sans-serif" size="1"><%=formatnumber(envios.fields("total"),2)%></font></div>
    </td>
    <%total=total+envios.fields("total")%>
	<%envios.MoveNext%>
  </tr>
  <% wend %>
  <tr bgcolor="#33CCCC" bordercolor="#99CCCC"> 
    <td colspan="4" bgcolor="#99CCCC" bordercolor="#99CCCC"> 
      <div align="right"></div>
    </td>
    <td width="10%" bgcolor="#99CCCC" bordercolor="#99CCCC"> 
      <div align="right"><b>Total........</b></div>
    </td>
    <td width="15%" bgcolor="#99CCCC" bordercolor="#99CCCC"> 
      <div align="right"><font face="Arial, Helvetica, sans-serif" size="3"><b><%=formatnumber(total,2)%></b></font></div>
    </td>
  </tr>
</table>
<% else %>
<table width="99%" border="1">
  <tr bgcolor="#33CCFF"> 
    <td colspan="6"> 
      <div align="center"> 
        <p><font face="Arial, Helvetica, sans-serif" size="4"><b><i>
		  <% if tipo_consulta="PENDIENTES" then %>
		       PEDIDOS PENDIENTES 
		  <% else %>
				PEDIDOS
		   <%end if%>			  
			   REALIZADOS POR LA SUCURSAL <%=cod_sucursal%> </i></b></font></p>
		  	 
        <p><font face="Arial, Helvetica, sans-serif" size="4"><b><i>ENTRE LAS 
          FECHAS <%=fecha_ini%> y <%=fecha_fin%></i></b></font></p>
      </div>
    </td>
  </tr>
  <tr bgcolor="#99CCCC"> 
    <td width="11%" height="21"><b>F. Peticion</b></td>
    <td width="32%" bgcolor="#99CCCC" height="21"> 
      <div align="center"><b>Art&iacute;culo</b></div>
    </td>
    <td width="25%" bgcolor="#99CCCC" height="21"> 
      <div align="center"><b>Tipo</b></div>
    </td>
    <td width="10%" height="21"> 
      <div align="center"><b>Cantidad</b></div>
    </td>
    <td width="11%" height="21"> 
      <div align="center"><b>Precio</b></div>
    </td>
    <td width="11%" height="21"> 
      <div align="center"><b>Estado</b></div>
    </td>
  </tr>
  <% while not envios.EOF%>
  <tr bgcolor="#FFFFCC"> 
    <td width="11%" height="21"><font face="Arial, Helvetica, sans-serif" size="1"><%=envios("fecha")%></font></td>
    <td width="32%" height="21"><font face="Arial, Helvetica, sans-serif" size="1"><%=envios("descripcion")%></font></td>
    <td width="25%" height="21"><font face="Arial, Helvetica, sans-serif" size="1"><%=envios.fields("NOMBRE_FAMILIA")%></font></td>
    <td width="10%" height="21"> 
      <div align="right"><font face="Arial, Helvetica, sans-serif" size="1"><%=formatnumber(envios("cantidad"),0)%></font></div>
    </td>
    <td width="11%" height="21"> 
      <% if isnull(envios("precio_compra")) then %>
      <div align="right"><font face="Arial, Helvetica, sans-serif" size="1">0.00</font></div>  
	  <%else%>
	     <div align="right"><font face="Arial, Helvetica, sans-serif" size="1"><%=formatnumber(envios("precio_compra"),2)%></font></div>
  	  <% end if%> 
    </td>
    <td width="11%" height="21"> 
      <div align="right"><font face="Arial, Helvetica, sans-serif" size="1"><%=envios("estado")%></font></div>
    </td>
    <%envios.MoveNext%>
  </tr>
  <% wend %>
  

  
</table>
<%end if %>
<table width="98%" border="0">
<% if hay_datos="NO" then %>
  <tr> 
    <td height="57"> 
      <p>&nbsp;</p>
      <p align="center"><img src="../imagenes/informacion.gif" width="47" height="38"></p>
      </td>
  </tr>
  <tr>
    <td>
      <div align="center">********** No se han realizado peticiones ni envios 
        de material de esta sucursal en estas fechas ********</div>
    </td>
  </tr>
<% end if %>
  <tr> 
    <td> 
      <div align="center"><a href="../Bottom.asp?empresa=<%=codigo_empresa%>"><img src="../imagenes/atras.gif" width="79" height="50" border="0"></a></div>
    </td>
  </tr>
</table>
</body>
</html>
<% 
		envios.close
  		conndistribuidora.close
		  
  	  	set envios=Nothing
		set conndistribuidora=Nothing
%>
