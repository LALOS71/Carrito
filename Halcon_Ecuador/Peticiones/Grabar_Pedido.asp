<%@ LANGUAGE = VBScript %>
   
<!-- METADATA Type="TypeLib" File="c:\archivos de programa\archivos comunes\system\ado\msado15.dll" --> 
<!--#include file="../Conexion_Gldistri.inc"-->


<%
   dim codsucursal
   dim codarticulo
   dim expediente
   dim cantidad
   dim fecha
   dim pedido_por
   
   dim numeropedido
   dim sql
   
   	
	'recojo los datos para generar la Cabecera del pedido
	codsucursal=Request.Form("c_sucursal")
	
	codigo_empresa=Request.Form("ocultocodigo_empresa")
	logotipo_empresa=Request.Form("ocultologotipo_empresa")
	
	'direccion_ip=Request.ServerVariables("REMOTE_ADDR") 
	direccion_ip=""
  
	fecha=DATE()
	pedido_por="INTRANET"
	
	set cmd = Server.CreateObject("ADODB.Command")
	'set cmd2 = Server.CreateObject("ADODB.Command")
    set cmd.ActiveConnection = conndistribuidora
    'set cmd2.ActiveConnection = conndistribuidora

	
	set  sucursales=Server.CreateObject("ADODB.Recordset")
	with sucursales
			.ActiveConnection=conndistribuidora
			.Source="SELECT COD"
			.Source= .Source & " FROM SUCURSALES"
			.Source= .Source & " WHERE (Empresa =" & codigo_empresa & ")"
			.Source= .Source & " and codigo='" & codsucursal & "'"
			.Source= .Source & " AND (Activa = 1)"
			.Open
	end with
	codigo_sucursal_bueno=sucursales("cod")
	sucursales.close
	set sucursales=Nothing

   ' Ejecuto el Primer Procedimiento Almacenado, el de la Cabecera del Pedido
   'GRABAR_CABECERA_PEDIDO codsucursal, fecha, 'INTRANET';
   
   conndistribuidora.BeginTrans 'Comenzamos la Transaccion
   cmd.CommandText = "GRABAR_CABECERA_PEDIDO"
   cmd.CommandType = adCmdStoredProc

    ' Query the server for what the parameters are
   	'cmd.parameters.append cmd.createparameter("SUCURSAL",adInteger,adParamInput,4,cint(codsucursal))
	'cmd.parameters.append cmd.createparameter("FECHA",adDate,adParamInput,4,fecha)
	'cmd.parameters.append cmd.createparameter("ARTICULO",adInteger,adParamInput,4,cint(codarticulo))
	'cmd.parameters.append cmd.createparameter("CANTIDAD",adInteger,adParamInput,4,cint(cantidad))
	'cmd.parameters.append cmd.createparameter("EXPEDIENTE",adVarChar,adParamInput,12,expediente)
	'cmd.parameters.append cmd.createparameter("PEDIDO_POR",adVarChar,adParamInput,10,pedido_por)
	
	'Paso los parametros para que se ejecute el comando
	cmd.parameters(1)=codigo_empresa
	cmd.parameters(2)=codigo_sucursal_bueno
	cmd.parameters(3)=fecha
	cmd.parameters(4)=pedido_por
	cmd.parameters(5)=direccion_ip
	   
   	cmd.execute()
	
	'recojo el valor que devuelve el primer procedimiento
	numeropedido=cmd.parameters(6).value
	'response.write numeropedido
	
	'Ejecutamos el segundo procedimiento Almacenado, el de los Detalles
	'GRABAR_DETALLE_PEDIDO numeropedido, codsucursal, codarticulo, cantidad, expediente;		
	cmd.CommandText = "GRABAR_DETALLE_PEDIDO"
    cmd.CommandType = adCmdStoredProc


	for i=1 to Session("numero_articulos")
		familia=Request.Form("familia_" & i)
		codarticulo=Request.Form("c_articulo_" & i)
		expediente=Request.Form("c_expediente_" & i)
		cantidad=Request.Form("c_cantidad_" & i)
		codigo_colectivo=NULL
		if familia=10 or familia=30 then
			codigo_colectivo=Request.Form("txtcodigo_colectivo_" & i)
		end if		
		
	
	
		' le paso los valores al segundo procedimiento
    	cmd.parameters(1)=cint(numeropedido)
		cmd.parameters(2)=codigo_sucursal_bueno
		cmd.parameters(3)=cint(codarticulo)
		cmd.parameters(4)=clng(cantidad)
		cmd.parameters(5)=expediente
		cmd.parameters(6)=codigo_colectivo
		'response.write("<br>Numero Pedido: " & numeropedido)
		'response.write("<br>Sucursal: " & codsucursal)
		'response.write("<br>Codigo Articulo: " & codarticulo)
		'response.write("<br>Cantidad: " & cantidad)
		'response.write("<br>Expediente: " & expediente)
		
   
   		cmd.execute()
	
	next
	
    conndistribuidora.CommitTrans ' finaliza la transaccion
	
	'para elimiar las variables de sesion
	Session("numero_articulos")=0
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pedido</TITLE>
</HEAD>
<script language="javascript">
function validar(sucursal)
{
	alert('La Petición a la Distribuidora ha sido Tramitada con Exito...');
	document.frmgrabar_pedido.submit()	
	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

   
<BODY onload="validar()">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>

<form name="frmgrabar_pedido" method="post" action="../Bottom.asp?empresa=<%=codigo_empresa%>">
</form>

<!--ya no usamos este, en vez de volver a la lista de articulos para poder seguir pidiendo
regresamos a la pagina principal donde se selecciona la oficina
<form name="frmgrabar_pedido" method="post" action="Articulos.asp?codsucursal=<%=codsucursal%>">
  <input name="ocultocodigo_empresa" type="hidden" value="<%=codigo_empresa%>">	
  <input name="ocultologotipo_empresa" type="hidden" value="<%=logotipo_empresa%>">
</form>
-->
</BODY>
   <%	
   		'regis.close			
		conndistribuidora.Close
		'set regis=Nothing
   		set cmd=Nothing
		'set cmd2=Nothing
		set conndistribuidora=Nothing
	%>
   </HTML>
