 
<%@ language=vbscript %>
<!--#include file="../../../../Data/Conexiones/Conexion_Gldistri.inc"-->
<%
		
	
	'recordsets
	dim sucursales
	
	
	dim codigosucursal
	dim nombresucursal

	'response.write(" hola ")

	codigosucursal=Request.Form("txtsucursal")
	if codigosucursal="" then
		codigosucursal=Request.QueryString("codsucursal")
	end if

	codigofamilia=Request.QueryString("codfamilia")
	nombrefamilia=Request.QueryString("nomfamilia")

	codigo_empresa=Request.Form("ocultocodigo_empresa")
	logotipo_empresa=Request.Form("ocultologotipo_empresa")

	'response.write("familia " & codigofamilia)
	if codigofamilia="" then
		codigofamilia=0
	end if
	'response.write("familia despues " & codigofamilia)
	
	set sucursales=Server.CreateObject("ADODB.Recordset")	

		with sucursales
			.ActiveConnection=conndistribuidora
			.Source="Select sucursal from sucursales where codigo='" & codigosucursal & "'"
			.Source= .Source & " and Empresa =" & codigo_empresa
			.Open
		end with

	nombresucursal=sucursales("sucursal")
	
	'response.write("source: " & sucursales.source)
	'response.write(" nombre suc: " & nombresucursal)

	
	
%>
<html>
<!-- Generated by AceHTML Freeware http://freeware.acehtml.com -->
<!-- Creation date: 09/04/2002 -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title></title>
<meta name="Description" content="">
<meta name="Keywords" content="">
<meta name="Author" content="Manuel Jose">
<meta name="Generator" content="AceHTML 4 Freeware">
</head>
<frameset cols="27%,*" framespacing="0" frameborder="no" border="1"> 
  <frame name="familias" src="ListaFamilias.asp?codsucursal=<%=codigosucursal%>&nomsucursal=<%=nombresucursal%>&logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>">
  <frame name="articulos" src="ListaArticulos.asp?codsucursal=<%=codigosucursal%>&nomsucursal=<%=nombresucursal%>&codfamilia=<%=codigofamilia%>&nomfamilia=<%=nombrefamilia%>&logo=<%=logotipo_empresa%>&codigo_empresa=<%=codigo_empresa%>">
  <noframes> 
  <body>
  </body>
</noframes> </frameset>

  <body>
  </body>



<%
	sucursales.close
	conndistribuidora.close
	
	set sucursales=Nothing
	set conndistribuidora=Nothing
%>
</html>
