<%@ LANGUAGE="VBSCRIPT"%>
<%
logotipo_empresa=Request.QueryString("logo")
codigo_empresa=Request.QueryString("codigo_empresa")

Session("numero_articulos")=0

%>
<html>
<head>
<script language="javascript">
	function volver()
	{
		alert('El Carrito ha Sido Vaciado...');
		document.frmvaciar_carro.submit()
		//location.href='articulos.asp?codsucursal=' + sucursal + '&codfamilia=6';
			
	}
</script>
</head>
<body onload="volver()">

<form name="frmvaciar_carro" method="post" action="articulos.asp?codsucursal=<%=Request.QueryString("codsucursal")%>&codfamilia=6">
  <input name="ocultocodigo_empresa" type="hidden" value="<%=codigo_empresa%>">	
  <input name="ocultologotipo_empresa" type="hidden" value="<%=logotipo_empresa%>">
</form>
</body>
</html>