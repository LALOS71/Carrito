<%@ LANGUAGE="VBSCRIPT"%>
<%

Session("numero_articulos")=0

%>
<html>
<head>
<script language="javascript">
	function volver()
	{
		alert('El Carrito ha Sido Vaciado...');
		document.getElementById('frmvaciar_carro').submit()
		//location.href='articulos.asp?codsucursal=' + sucursal + '&codfamilia=6';
			
	}
</script>
</head>
<body onload="volver()">

<form name="frmvaciar_carro" id="frmvaciar_carro" method="post" action="Lista_Articulos.asp">
  
</form>
</body>
</html>