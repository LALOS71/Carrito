    <%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
    'para que no se desborde el buffer
	Response.Buffer=true
		
	if session("usuario_admin")="" then
		Response.Redirect("Login_Admin.asp")
	end if
		
	agrupacion_seleccionada=Request.Form("optagrupacion")	
	empresa_seleccionada=Request.Form("cmbempresas")
	articulo_seleccionado=Request.Form("cmbarticulos")
	reservas_asm_gls_seleccionada=Request.Form("chkreservas_asm_gls")
	fecha_i=Request.Form("txtfecha_inicio")
	fecha_f=Request.Form("txtfecha_fin")
	diferenciar_empresas_seleccionada=Request.Form("chkdiferenciar_empresas")
	diferenciar_sucursales_seleccionada=Request.Form("chkdiferenciar_sucursales")
	diferenciar_articulos_seleccionada=Request.Form("chkdiferenciar_articulos")
	articulos_sin_consumo_seleccionada=Request.Form("chkarticulos_sin_consumo")
	diferenciar_rappel_seleccionado=Request.Form("chkdiferenciar_rappel")
	diferenciar_marca_seleccionada=Request.Form("chkdiferenciar_marca")
	diferenciar_tipo_seleccionada=Request.Form("chkdiferenciar_tipo")
		
'response.write("<br>diferenciar rappel: " & diferenciar_rappel_seleccionado)
			
		
	if agrupacion_seleccionada="" then
		agrupacion_seleccionada="empresa"
	end if	
	'response.write("<br>agrupacion: " & agrupacion_seleccionada)
		
	'response.write("<br>diferenciar sucursales: " & diferenciar_sucursales_seleccionada)
	'recordsets
	dim empresas
		
		
	'variables
	dim sql
	
	set empresas=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_EMPRESA=0
		CAMPO_EMPRESA_EMPRESA=1
		CAMPO_CARPETA_EMPRESA=2
		with empresas
			.ActiveConnection=connimprenta
			.Source="SELECT V_EMPRESAS.ID, V_EMPRESAS.EMPRESA, V_EMPRESAS.CARPETA"
			.Source= .Source & " FROM V_EMPRESAS"
			.Source= .Source & " ORDER BY EMPRESA"
			.Open
			vacio_empresas=false
			if not .BOF then
				mitabla_empresas=.GetRows()
			  else
				vacio_empresas=true
			end if
		end with

		empresas.close
		set empresas=Nothing


		set articulos=Server.CreateObject("ADODB.Recordset")
		CAMPO_CODIGO_SAP_ARTICULO=0
		CAMPO_DESCRIPCION_ARTICULO=1
		with articulos
			.ActiveConnection=connimprenta
			.Source="SELECT ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION"
			.Source= .Source & " FROM ARTICULOS"
			.Source= .Source & " ORDER BY DESCRIPCION"
			.Open
			vacio_articulos=false
			if not .BOF then
				mitabla_articulos=.GetRows()
			  else
				vacio_articulos=true
			end if
		end with

		articulos.close
		set articulos=Nothing


		set consumos=Server.CreateObject("ADODB.Recordset")
		
		'connimprenta.BeginTrans 'Comenzamos la Transaccion
				
		'porque el sql de produccion es un sql expres que debe tener el formato de
		' de fecha con mes-dia-año
		connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
				
		with consumos
			.ActiveConnection=connimprenta
			
			'hacemos dos consultas, dependiendo de si se agrupa por articulo o por empresa
			if agrupacion_seleccionada="empresa" then
				.Source="SELECT V_EMPRESAS.EMPRESA AS NOMBRE_EMPRESA"
				if diferenciar_sucursales_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ", V_CLIENTES.Id CodCliente, V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					.Source= .Source & ", ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.RAPPEL"
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", V_CLIENTES.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", V_CLIENTES.TIPO"
				end if
				.Source= .Source & ", max(PEDIDOS_DETALLES.ARTICULO) as ID_ARTICULO, sum(PEDIDOS_DETALLES.CANTIDAD) as cantidad_total"
				.Source= .Source & ", ROUND(sum(PEDIDOS_DETALLES.TOTAL),2) AS TOTAL_IMPORTE"
				
				.Source= .Source & " FROM PEDIDOS INNER JOIN PEDIDOS_DETALLES"
				.Source= .Source & " ON PEDIDOS.ID = PEDIDOS_DETALLES.ID_PEDIDO"
				.Source= .Source & " INNER JOIN V_CLIENTES"
				.Source= .Source & " ON PEDIDOS.CODCLI = V_CLIENTES.Id"
				.Source= .Source & " INNER JOIN ARTICULOS"
				.Source= .Source & " ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID"
				.Source= .Source & " INNER JOIN V_EMPRESAS"
				.Source= .Source & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
				.Source= .Source & " WHERE 1=1"
				if reservas_asm_gls_seleccionada="SI" then
						.Source= .Source & " AND PEDIDOS_DETALLES.ESTADO='RESERVADO'"
					else
						.Source= .Source & " AND PEDIDOS.ESTADO='ENVIADO'"
				end if
				
				if fecha_i<>"" then
					if reservas_asm_gls_seleccionada="SI" then
							.Source= .Source & " AND (PEDIDOS.FECHA >= '" & fecha_i & "')" 
						else
							.Source= .Source & " AND (PEDIDOS.FECHA_ENVIADO >= '" & fecha_i & "')" 
					end if
				end if
				if fecha_f<>"" then
					if reservas_asm_gls_seleccionada="SI" then
							.Source= .Source & " AND (PEDIDOS.FECHA <= '" & fecha_f & "')"
						else
							.Source= .Source & " AND (PEDIDOS.FECHA_ENVIADO <= '" & fecha_f & "')"
					end if
				end if
				if empresa_seleccionada<>"" then
					.Source= .Source & " AND (V_CLIENTES.EMPRESA = " & empresa_seleccionada & ")"
				end if
				
				.Source= .Source & " group by V_EMPRESAS.EMPRESA"
				if diferenciar_sucursales_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ",V_CLIENTES.Id,V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					.Source= .Source & ", ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.RAPPEL"
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", V_CLIENTES.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", V_CLIENTES.TIPO"
				end if
				
			else 'cuando agrupamos por articulo
				.Source="SELECT ARTICULOS.CODIGO_SAP as CODIGO_SAP"
				.Source= .Source & ", ARTICULOS.DESCRIPCION as ARTICULO"
				.Source= .Source & ", ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.RAPPEL"
				if diferenciar_empresas_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ", V_EMPRESAS.EMPRESA AS NOMBRE_EMPRESA"
				end if
				if diferenciar_sucursales_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ", V_CLIENTES.Id CodCliente, V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", V_CLIENTES.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", V_CLIENTES.TIPO"
				end if
				
				
				.Source= .Source & ", sum(PEDIDOS_DETALLES.CANTIDAD) as cantidad_total"
				.Source= .Source & ", ROUND(sum(PEDIDOS_DETALLES.TOTAL),2) AS TOTAL_IMPORTE"
				
				.Source= .Source & " FROM PEDIDOS INNER JOIN PEDIDOS_DETALLES"
				.Source= .Source & " ON PEDIDOS.ID = PEDIDOS_DETALLES.ID_PEDIDO"
				.Source= .Source & " INNER JOIN V_CLIENTES"
				.Source= .Source & " ON PEDIDOS.CODCLI = V_CLIENTES.Id"
				.Source= .Source & " INNER JOIN ARTICULOS"
				.Source= .Source & " ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID"
				.Source= .Source & " INNER JOIN V_EMPRESAS"
				.Source= .Source & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
				'.Source= .Source & " WHERE PEDIDOS.ESTADO='ENVIADO'"
				.Source= .Source & " WHERE 1=1"
				if reservas_asm_gls_seleccionada="SI" then
						.Source= .Source & " AND PEDIDOS_DETALLES.ESTADO='RESERVADO'"
					else
						.Source= .Source & " AND PEDIDOS.ESTADO='ENVIADO'"
				end if
				if fecha_i<>"" then
					if reservas_asm_gls_seleccionada="SI" then
							.Source= .Source & " AND (PEDIDOS.FECHA >= '" & fecha_i & "')" 
						else
							.Source= .Source & " AND (PEDIDOS.FECHA_ENVIADO >= '" & fecha_i & "')" 
					end if
				end if
				if fecha_f<>"" then
					if reservas_asm_gls_seleccionada="SI" then
							.Source= .Source & " AND (PEDIDOS.FECHA <= '" & fecha_f & "')"
						else
							.Source= .Source & " AND (PEDIDOS.FECHA_ENVIADO <= '" & fecha_f & "')"
					end if
				end if
				if articulo_seleccionado<>"" then
					.Source= .Source & " AND (ARTICULOS.CODIGO_SAP = '" & articulo_seleccionado & "')"
				end if
				
				
				.Source= .Source & " group by ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.RAPPEL"
				if diferenciar_empresas_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ", V_EMPRESAS.EMPRESA"
				end if
				if diferenciar_sucursales_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ",V_CLIENTES.Id,V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", V_CLIENTES.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", V_CLIENTES.TIPO"
				end if
				
				
				.Source= .Source & " order by ARTICULOS.DESCRIPCION"
				if diferenciar_empresas_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ", V_EMPRESAS.EMPRESA"
				end if
				if diferenciar_sucursales_seleccionada="SI" then
					'.Source= .Source & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
					.Source= .Source & ",V_CLIENTES.Id"
				end if
				if diferenciar_marca_seleccionada="SI" then
					.Source= .Source & ", V_CLIENTES.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					.Source= .Source & ", V_CLIENTES.TIPO"
				end if
			end if
			'response.write("<br><BR>CONSULTA ANTIGUA: " & .source)			
			
			cadena_consulta=.source
			
			
			if articulos_sin_consumo_seleccionada="SI" then
				cadena_articulos="SELECT V_EMPRESAS.EMPRESA AS NOMBRE_EMPRESA, ARTICULOS.ID, ARTICULOS.CODIGO_SAP,"
				cadena_articulos=cadena_articulos & " ARTICULOS.DESCRIPCION, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.RAPPEL"
				if diferenciar_tipo_seleccionada="SI" then
					cadena_articulos=cadena_articulos & ", V_CLIENTES_TIPO.TIPO"
				end if	
				cadena_articulos=cadena_articulos & " FROM ARTICULOS INNER JOIN ARTICULOS_EMPRESAS"
				cadena_articulos=cadena_articulos & " ON ARTICULOS.ID=ARTICULOS_EMPRESAS.ID_ARTICULO"
				cadena_articulos=cadena_articulos & " INNER JOIN V_EMPRESAS"
				cadena_articulos=cadena_articulos & " ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA=V_EMPRESAS.ID"
				if diferenciar_tipo_seleccionada="SI" then
					cadena_articulos=cadena_articulos & " INNER JOIN V_CLIENTES_TIPO"
					cadena_articulos=cadena_articulos & " ON V_EMPRESAS.ID=V_CLIENTES_TIPO.EMPRESA"
				end if
				
				
				cadena_articulos=cadena_articulos & " WHERE ARTICULOS.BORRADO='NO'" 
				if empresa_seleccionada<>"" then
					cadena_articulos=cadena_articulos & " AND ARTICULOS_EMPRESAS.CODIGO_EMPRESA= " & empresa_seleccionada
				end if
				
				cadena_envios="SELECT V_EMPRESAS.EMPRESA AS NOMBRE_EMPRESA"
				if diferenciar_sucursales_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					cadena_envios=cadena_envios & ", ARTICULOS.CODIGO_SAP"
					cadena_envios=cadena_envios & ", ARTICULOS.DESCRIPCION"
					cadena_envios=cadena_envios & ", ARTICULOS.UNIDADES_DE_PEDIDO"
					cadena_envios=cadena_envios & ", ARTICULOS.RAPPEL"
				end if
				if diferenciar_marca_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.TIPO"
				end if

				cadena_envios=cadena_envios & ", max(PEDIDOS_DETALLES.ARTICULO) as ID_ARTICULO"
				cadena_envios=cadena_envios & ", sum(PEDIDOS_DETALLES.CANTIDAD) as cantidad_total"
				cadena_envios=cadena_envios & ", ROUND(sum(PEDIDOS_DETALLES.TOTAL),2) AS TOTAL_IMPORTE"
				
				cadena_envios=cadena_envios & " FROM PEDIDOS INNER JOIN PEDIDOS_DETALLES"
				cadena_envios=cadena_envios & " ON PEDIDOS.ID = PEDIDOS_DETALLES.ID_PEDIDO"
				cadena_envios=cadena_envios & " INNER JOIN V_CLIENTES"
				cadena_envios=cadena_envios & " ON PEDIDOS.CODCLI = V_CLIENTES.Id"
				cadena_envios=cadena_envios & " INNER JOIN ARTICULOS"
				cadena_envios=cadena_envios & " ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID"
				cadena_envios=cadena_envios & " INNER JOIN V_EMPRESAS"
				cadena_envios=cadena_envios & " ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id"
				cadena_envios=cadena_envios & " WHERE PEDIDOS.ESTADO='ENVIADO'"
				if fecha_i<>"" then
					cadena_envios=cadena_envios & " AND (PEDIDOS.FECHA_ENVIADO >= '" & fecha_i & "')" 
				end if
				if fecha_f<>"" then
					cadena_envios=cadena_envios & " AND (PEDIDOS.FECHA_ENVIADO <= '" & fecha_f & "')"
				end if
				if empresa_seleccionada<>"" then
					cadena_envios=cadena_envios & " AND (V_CLIENTES.EMPRESA = " & empresa_seleccionada & ")"
				end if

				cadena_envios=cadena_envios & " GROUP BY V_EMPRESAS.EMPRESA"
				if diferenciar_sucursales_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.NOMBRE, V_CLIENTES.CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					cadena_envios=cadena_envios & ", ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.RAPPEL"
				end if
				if diferenciar_marca_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					cadena_envios=cadena_envios & ", V_CLIENTES.TIPO"
				end if
				
				
				
 
  
 

				consulta_total="SELECT ISNULL(A.NOMBRE_EMPRESA, ISNULL(B.NOMBRE_EMPRESA,'--')) AS NOMBRE_EMPRESA"
				
				if diferenciar_sucursales_seleccionada="SI" then
					consulta_total=consulta_total & ", B.NOMBRE AS NOMBRE"
					consulta_total=consulta_total & ", B.CODIGO_EXTERNO AS CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					consulta_total=consulta_total & ", ISNULL(A.CODIGO_SAP, ISNULL(B.CODIGO_SAP,'--')) AS CODIGO_SAP"
					consulta_total=consulta_total & ", ISNULL(A.DESCRIPCION, ISNULL(B.DESCRIPCION + ' (borrado)','--')) AS DESCRIPCION"
					consulta_total=consulta_total & ", ISNULL(A.UNIDADES_DE_PEDIDO, ISNULL(B.UNIDADES_DE_PEDIDO,'--')) AS UNIDADES_DE_PEDIDO"
					if diferenciar_rappel_seleccionado="SI" then
						consulta_total=consulta_total & ", ISNULL(A.RAPPEL, ISNULL(B.RAPPEL,'--')) AS RAPPEL"
					end if
				end if
				if diferenciar_marca_seleccionada="SI" then
					consulta_total=consulta_total & ", B.MARCA AS MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" then
					consulta_total=consulta_total & ", ISNULL(A.TIPO, ISNULL(B.TIPO,'--')) AS TIPO"
				end if

				consulta_total=consulta_total & ", ISNULL(B.CANTIDAD_TOTAL, 0) AS CANTIDAD_TOTAL"
				consulta_total=consulta_total & ", ISNULL(B.TOTAL_IMPORTE, 0) AS TOTAL_IMPORTE"
				consulta_total=consulta_total & " FROM (" & cadena_articulos & ") AS A"
				consulta_total=consulta_total & " FULL OUTER JOIN (" & cadena_envios & ") AS B"
				consulta_total=consulta_total & " ON A.ID=B.ID_ARTICULO"
				if diferenciar_tipo_seleccionada="SI" then
					consulta_total=consulta_total & " AND A.TIPO=B.TIPO"
				end if
				consulta_total=consulta_total & " ORDER BY NOMBRE_EMPRESA"
				
				if diferenciar_sucursales_seleccionada="SI" then
					consulta_total=consulta_total & ", NOMBRE, CODIGO_EXTERNO"
				end if
				if diferenciar_articulos_seleccionada="SI" then
					consulta_total=consulta_total & ", DESCRIPCION"
					if diferenciar_tipo_seleccionada="SI" then
						consulta_total=consulta_total & " , TIPO"
					end if
				end if
				if diferenciar_marca_seleccionada="SI" then
					consulta_total=consulta_total & ", B.MARCA"
				end if
				if diferenciar_tipo_seleccionada="SI" AND diferenciar_articulos_seleccionada<>"SI" then
					consulta_total=consulta_total & ", B.TIPO"
				end if
				
								
				
				
				'response.write("<br><BR>CADENA_ARTICULOS: " & cadena_articulos)
				'response.write("<br><BR>CADENA_ENVIOS: " & cadena_envios)
				'response.write("<br><BR>CADENA_TOTAL: " & consulta_total)
				.Source=consulta_total
				cadena_consulta=.Source
				
			
			end if
			'response.write("<br><BR>CADENA_ARTICULOS: " & cadena_articulos)
			'response.write("<br><BR>CADENA_ENVIOS: " & cadena_envios)
			'response.write("<br><BR>CADENA_TOTAL: " & consulta_total)
			'response.write("<BR><br><BR>CONSULTA: " & .source)			
			
			
			
			.Open
			
		end with
		'while not consumos.eof
		'	response.write("<br>empresa: " & consumos("nombre_empresa"))
		'	consumos.movenext
		'wend
		'connimprenta.CommitTrans ' finaliza la transaccion

		


%>
<html>
<head>
<link href="estilos.css" rel="stylesheet" type="text/css" />
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
<!-- European format dd-mm-yyyy -->
	<script language="JavaScript" src="js/calendario/calendar1.js"></script>
<!-- Date only with year scrolling -->
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


	
	
   function mover_formulario(objetivo)
   {
   	if (objetivo=='volver')
   		accion='Lista_Articulos.asp'
	  else
	  	accion='Grabar_Pedido.asp';
	document.getElementById('frmpedido').action=accion
	document.getElementById('frmpedido').submit()	
	

   }
   	

function mostrar_articulo(articulo,accion)
   {
   	//alert('hotel: ' + hotel + ' accion: ' + accion)
   	document.getElementById('ocultoid_articulo').value=articulo
	document.getElementById('ocultoaccion').value=accion
   	document.getElementById('frmmostrar_articulo').submit()	
	

   }

function activar_articulos_sin_consumo()
{
	if (document.getElementById('chkdiferenciar_articulos').checked)
		{
		document.getElementById('fila_articulos_sin_consumo').style.display='';
		}
	  else
		{
		document.getElementById('chkarticulos_sin_consumo').checked=false;
		document.getElementById('fila_articulos_sin_consumo').style.display='none';
		}
}

function mostrar_capas(capa)
{
	console.log('he pulsado....' + capa)
	if (capa=='empresas')
		{
		console.log('dentro de empresa')
	
		document.getElementById('chkdiferenciar_articulos').checked=false
		document.getElementById('chkarticulos_sin_consumo').checked=false
		document.getElementById('fila_articulos_sin_consumo').style.display='none';
		

		
		document.getElementById('tabla_diferenciar_articulos_relleno').style.display='none';
		document.getElementById('tabla_diferenciar_articulos').style.display='none';
		document.getElementById('tabla_diferenciar_empresas_relleno').style.display='block';
		document.getElementById('tabla_diferenciar_empresas').style.display='block';
		document.getElementById('cmbempresas').style.display='none';
		document.getElementById('cmbarticulos').style.display='block';
		
		document.getElementById('cmbempresas').value='';
		}
	
	if (capa=='articulos')
		{
		console.log('dentro de articuolo')
		document.getElementById('chkdiferenciar_empresas').checked=false

		document.getElementById('tabla_diferenciar_empresas_relleno').style.display='none';
		document.getElementById('tabla_diferenciar_empresas').style.display='none';
		document.getElementById('tabla_diferenciar_articulos_relleno').style.display='block';
		document.getElementById('tabla_diferenciar_articulos').style.display='block';

		document.getElementById('cmbempresas').style.display='block';
		document.getElementById('cmbarticulos').style.display='none';
		
		document.getElementById('cmbarticulos').value='';

		
		
		
		}
	
}
</script>
<script language="vbscript">
	
	
</script>


</head>
<body onload="">


<table>
<tr>
	<td width="218" valign="top">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
				</td>
			</tr>
			<tr>
				<td>
				</td>
			</tr>
		
		
		</table>
	
	
		<div class="sidebarcell">
			
			<div id="side_freetext_title_39" class="title">
				<br />
				<font size="3"><b>Mantenimientos</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					· <a href="Consulta_Pedidos_Admin.asp">Pedidos</a><br />
					· <a href="Consulta_Articulos_Admin.asp">Artículos</a><br />
					· <a href="Consulta_Clientes_Admin.asp">Clientes</a><br />
					· <a href="Consulta_Informes_Admin.asp">Informes </a><br /><br />										
					· <a href="Carrusel_Admin.asp" target="_blank">Carrusel</a><br />					
					
					<br />
					
					<br /> 
					
					<br />
					
					<br />
					<br />
					
					
				</div>
				</div>
			</div>
		</div>
		
			</div>
		</div>
		
		
		
	</td>
	<td valign="top">
		<div id="main">
				
					
				<div class="fontbold" align="center">INFORMES</div>
				<div class="comment_text__"> 
					<form name="frmbuscar_consumos" id="frmbuscar_consumos" method="post" action="Consulta_Informes_Admin.asp">
							
					<table width="95%" cellspacing="6" cellpadding="0" class="logintable" align="center">
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Opciones de Búsqueda</span>
							</td>
						</tr>
						<tr><td height="5"></td></tr>
						<tr>
							<td width="50%" class="dottedBorder vt al">
								
			  
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
										<tr>
											<td width="30%">Agrupar Por: </td>
											<td align="right">
												<input class="submitbtn" type="submit" name="Action" id="Action" value="Buscar" />
											</td>
										</tr>							
									</table>
									
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
									<tr>
										<td width="4%"></td>
										<td width="4%">
											<input type="radio" id="optagrupacion_empresa" name="optagrupacion" value="empresa" onclick="mostrar_capas('articulos')" checked />
										</td>
										<td width="10%">
											Empresa&nbsp;&nbsp;
										</td>
										<td width="82%">
											<select  name="cmbempresas" id="cmbempresas">
												<option value="" selected>* TODAS *</option>
												<%if vacio_empresas=false then %>
														<%for i=0 to UBound(mitabla_empresas,2)%>
															<option value="<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>"><%=mitabla_empresas(CAMPO_EMPRESA_EMPRESA,i)%></option>
														<%next%>
												<%end if%>
											</select>
											<script language="javascript">
												document.getElementById("cmbempresas").value='<%=empresa_seleccionada%>'
											</script>
											
										</td>
									</tr>							
													
									</table>
									<table border="0" width="100%"><tr><td height="3px"></td></tr></table>
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
									<tr>
										<td width="4%"></td>
										<td width="4%">
												<input type="radio" id="optagrupacion_articulo" name="optagrupacion" value="articulo" onclick="mostrar_capas('empresas')"/> 										
										</td>
										<td width="92%">
												Art&iacute;culo
												<br />
												<select  name="cmbarticulos" id="cmbarticulos">
													<option value="" selected>* TODOS *</option>
													<%if vacio_articulos=false then %>
															<%for i=0 to UBound(mitabla_articulos,2)%>
																<option value="<%=mitabla_articulos(CAMPO_CODIGO_SAP_ARTICULO,i)%>"><%=mitabla_articulos(CAMPO_DESCRIPCION_ARTICULO,i)%></option>
															<%next%>
													<%end if%>
												</select>
												<script language="javascript">
													document.getElementById("cmbarticulos").value='<%=articulo_seleccionado%>'
												</script>
											
										</td>
									</tr>							
													
									</table>
								
									<%if agrupacion_seleccionada="articulo" then%>
											<script language="javascript">
												//alert('dentro de agrupacion_seleccionada <%=agrupacion_seleccionada%>')
												document.getElementById("optagrupacion_<%=agrupacion_seleccionada%>").checked=true
												
												document.getElementById('cmbempresas').style.display='none';
												document.getElementById('cmbarticulos').style.display='block';
											</script>
									  <%else%>
 											<script language="javascript">
												//alert('dentro de agrupacion_seleccionada <%=agrupacion_seleccionada%>')
												document.getElementById("optagrupacion_<%=agrupacion_seleccionada%>").checked=true
											
												document.getElementById('cmbempresas').style.display='block';
												document.getElementById('cmbarticulos').style.display='none';
											</script>

									<%end if%>
								
								
								
									<br />
									<input name="chkreservas_asm_gls" id="chkreservas_asm_gls" type="checkbox" value="SI" />
									<%if reservas_asm_gls_seleccionada="SI" then%>
										<script language="javascript">
											document.getElementById("chkreservas_asm_gls").checked=true
										</script>
									<%end if%>
									<span class='fontbold'>Reservas ASM/GLS</span>
								
								
							</td>
						</tr>
					</table>		
					<table><tr><td height="5"></td></tr></table>
					<table width="95%" cellspacing="6" cellpadding="0" class="logintable" align="center" style="background-color:#778583">
						
						
						<tr>
							<td width="50%">
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td  style="padding:10px" width="14%"><font style="COLOR:#000000"><b>Fecha Inicio:</b></font></td>
									<td width="25%">
										<input type="Text" class="txtfield" name="txtfecha_inicio" id="txtfecha_inicio" value="<%=fecha_i%>" size=10>
                                		<a href="javascript:cal1.popup();"><img src="img/cal.gif" width="16" height="16" border="0" alt="Pulsa Aqui para Seleccionar una Fecha de Inicio"></a>
									
									
									</td>
									<td width="10%"><font style="COLOR:#000000"><b>Fecha Fin:</b></font> </td>
									<td width="29%">
										<input type="Text" class="txtfield" name="txtfecha_fin" id="txtfecha_fin" value="<%=fecha_f%>" size=10>
                                		<a href="javascript:cal2.popup();"><img src="img/cal.gif" width="16" height="16" border="0" alt="Pulsa Aqui para Seleccionar una Fecha de Fin"></a>
									
									
									</td>
									<td width="22%">
										<div align="right">										</div>
										
									</td>
								</tr>							
												
								</table>
								</td>
						</tr>
					</table>
					
						<table id="tabla_diferenciar_empresas_relleno" style="display:none"><tr><td height="5"></td></tr></table>		
						<table id="tabla_diferenciar_empresas" width="95%" cellspacing="6" cellpadding="0" align="center" style="background-color:#6699CC; display:none">
							<tr >
								<td width="50%" >
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
									<tr>
										<td style="padding:10px" width="28%">
										<input name="chkdiferenciar_empresas" id="chkdiferenciar_empresas" type="checkbox" value="SI" />
										<%if diferenciar_empresas_seleccionada="SI" then%>
											<script language="javascript">
												document.getElementById("chkdiferenciar_empresas").checked=true
											</script>
										<%end if%>
										<span class='fontbold' style="color:#FFFFFF ">Diferenciar Empresas</span></td>
									</tr>							
									</table>
							  </td>
							</tr>
						</table>
					<%if agrupacion_seleccionada="articulo" then%>
						<script language="javascript">
								document.getElementById('tabla_diferenciar_empresas_relleno').style.display='block';
								document.getElementById('tabla_diferenciar_empresas').style.display='block';
						</script>
					<%end if%>
					
					
					<table><tr><td height="5"></td></tr></table>		
					<table width="95%" cellspacing="6" cellpadding="0" align="center" style="background-color:#464929">
						
						<tr >
							<td width="50%" >
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td style="padding:10px" width="28%">
									<input name="chkdiferenciar_sucursales" id="chkdiferenciar_sucursales" type="checkbox" value="SI" />
									<%if diferenciar_sucursales_seleccionada="SI" then%>
										<script language="javascript">
											document.getElementById("chkdiferenciar_sucursales").checked=true
										</script>
									<%end if%>
									<span class='fontbold' style="color:#FFFFFF ">Diferenciar Sucursales</span></td>
								  
									<td width="72%" style="color:#FFFFFF ">(util para obtener los consumos detallados de cada oficina de la empresa seleccionada)</td>
									
								</tr>							
												
								</table>
								
						  </td>
						</tr>
					</table>

					<table id="tabla_diferenciar_articulos_relleno" style="display:none"><tr><td height="5"></td></tr></table>		
					<table id="tabla_diferenciar_articulos" width="95%" cellspacing="6" cellpadding="0" align="center" style="background-color:#B09F87; display:none">
						
						<tr>
							<td width="50%">
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="28%" style="padding:10px">
										<input name="chkdiferenciar_articulos" id="chkdiferenciar_articulos" type="checkbox" value="SI" onclick="activar_articulos_sin_consumo()"/>
										<%if diferenciar_articulos_seleccionada="SI" then%>
											<script language="javascript">
												document.getElementById("chkdiferenciar_articulos").checked=true
											</script>
										<%end if%>
										
										<span class='fontbold' style="color:#000000 ">Diferenciar Artículos</span>
									</td>
									<td width="72%"  style="color:#000000 ">(util para obtener los consumos detallados de cada uno de los productos asociados a la empresa seleccionada)</td>
									
								</tr>							
												
								<tr style="display:none" id="fila_articulos_sin_consumo">
									<td width="28%" style="padding:10px;">&nbsp;</td>
										
									<td width="72%"  style="color:#000000;">
									
										<input name="chkarticulos_sin_consumo" id="chkarticulos_sin_consumo" type="checkbox" value="SI" />
										<%if articulos_sin_consumo_seleccionada="SI" then%>
											<script language="javascript">
												document.getElementById("chkarticulos_sin_consumo").checked=true
											</script>
										<%end if%>
										<script language="javascript">
											activar_articulos_sin_consumo()
										</script>
											<span class='fontbold' style="color:#000000;padding-bottom:10px">Mostrar Artículos Sin Consumo</span>
											
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
										<input name="chkdiferenciar_rappel" id="chkdiferenciar_rappel" type="checkbox" value="SI" />
										<%if diferenciar_rappel_seleccionado="SI" then%>
											<script language="javascript">
												document.getElementById("chkdiferenciar_rappel").checked=true
											</script>
										<%end if%>
											<span class='fontbold' style="color:#000000;padding-bottom:10px">Mostrar Informaci&oacute;n Rappel</span>
											
											
								  </td>
									
								</tr>							
								</table>
								
						  </td>
						</tr>
					</table>
						
					<%if agrupacion_seleccionada="empresa" then%>						
						<script language="javascript">
								document.getElementById('tabla_diferenciar_articulos_relleno').style.display='block';
								document.getElementById('tabla_diferenciar_articulos').style.display='block';
						</script>
					<%end if%>	
						
					<table><tr><td height="5"></td></tr></table>		
					<table width="95%" cellspacing="6" cellpadding="0" align="center" style="background-color:#C9CDD1">
						
						<tr>
							<td width="50%" >
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="28%" style="padding:10px">
										<input name="chkdiferenciar_marca" id="chkdiferenciar_marca" type="checkbox" value="SI" />
										<%if diferenciar_marca_seleccionada="SI" then%>
										<script language="javascript">
											document.getElementById("chkdiferenciar_marca").checked=true
										</script>
									<%end if%>
										<span class='fontbold' style="color:#000000 ">Diferenciar Marca</span></td>
								  
									<td width="72%" style="color:#000000 ">(util para BARCELÓ, para obtener los consumos individualizados por marca (Barcelo, Confort, Premium))</td>
									
								</tr>							
												
								</table>
								
						  </td>
						</tr>
					</table>
					<table><tr><td height="5"></td></tr></table>		
					<table width="95%" cellspacing="6" cellpadding="0" align="center" style="background-color:#949CA6">
						
						<tr>
							<td width="50%">
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="28%" style="padding:10px">
										<input name="chkdiferenciar_tipo" id="chkdiferenciar_tipo" type="checkbox" value="SI" />
										<%if diferenciar_tipo_seleccionada="SI" then%>
										<script language="javascript">
											document.getElementById("chkdiferenciar_tipo").checked=true
										</script>
									<%end if%>
										<span class='fontbold' style="color:#000000 ">Diferenciar Tipo</span></td>
								  
									<td width="72%" style="color:#000000 ">(util para ASM, para obtener los consumos individualizados por tipo (Propias y Franquicias))</td>
									
								</tr>							
												
								</table>
								
						  </td>
						</tr>
					</table>
					
					
					
					
					
					
					
					
					
					
					<br />
					<br />
					
					
					
								<div id="main">
										<%if agrupacion_seleccionada="empresa" then%>
										
											<table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table">
												<tr style="background-color:#FCFCFC" valign="top">
													<th class="menuhdr" style="text-align:center">Empresa</th>
													<%if diferenciar_sucursales_seleccionada="SI" then%>
														<th class="menuhdr">Codigo</th>
                                                        <th class="menuhdr">Cliente</th>
													<%end if%>
													<%if diferenciar_articulos_seleccionada="SI" then%>
														<th class="menuhdr">Cod. Sap</th>
														<th class="menuhdr">Artículo</th>
														<th class="menuhdr">Unidades Pedido</th>
														<%if diferenciar_rappel_seleccionado="SI" then%>
															<th class="menuhdr">Rappel</th>
														<%end if%>
													<%end if%>
													<%if diferenciar_marca_seleccionada="SI" then%>
														<th class="menuhdr">Marca</th>
													<%end if%>
													<%if diferenciar_tipo_seleccionada="SI" then%>
														<th class="menuhdr">Tipo</th>
													<%end if%>
			
													<th class="menuhdr" style="text-align:center">Cantidad Total</th>
													<th class="menuhdr" style="text-align:center">Total Importe</th>
													
												</tr>
												
												<%vueltas=1
												  if not consumos.eof then %>
			                            			<%while not consumos.eof%>
													
														<tr  valign="top" id="fila_articulo_<%=i%>">
															<%
															vueltas=vueltas + 1
															if vueltas=200 then
																Response.Flush
																vueltas=1
															end if
															%>
															<td  class="ac item_row" width="82"><%=consumos("NOMBRE_EMPRESA")%></td>
															<%if diferenciar_sucursales_seleccionada="SI" then%>

                                                                <td  class="ac item_row" style="text-align:left; width:30px">
                                                                    <%=consumos("CodCliente")%>
                                                                </td>

																<td  class="ac item_row" style="text-align:left" width="76">
																	<%=consumos("NOMBRE")%>
																	<%if consumos("CODIGO_EXTERNO")<>"" then%>
																		&nbsp(<%=consumos("CODIGO_EXTERNO")%>)
																	<%end if%>
																</td>
															<%end if%>
															<%if diferenciar_articulos_seleccionada="SI" then%>
																<td  class="ac item_row" width="101">
																	<%=consumos("CODIGO_SAP")%>
																</td>
																<td   width="306" class="al item_row" style="text-align:right;" >
																	<%=consumos("DESCRIPCION")%>&nbsp;
																</td>
																<td  class="ac item_row" width="101">
																	<%=consumos("UNIDADES_DE_PEDIDO")%>
																</td>
																<%if diferenciar_rappel_seleccionado="SI" then%>
																	<td  class="ac item_row" width="101">
																		<%=consumos("RAPPEL")%>
																	</td>
																<%end if%>												
															<%end if%>
															<%if diferenciar_marca_seleccionada="SI" then%>
																<td  class="ac item_row" width="101">
																	<%=consumos("MARCA")%>
																</td>
															<%end if%>
															<%if diferenciar_tipo_seleccionada="SI" then%>
																<td  class="ac item_row" width="101">
																	<%=consumos("TIPO")%>
																</td>
															<%end if%>
															<td  class="ar item_row" width="101">
																<%
																if consumos("CANTIDAD_TOTAL")<>"" then
																		Response.Write(FORMATNUMBER(consumos("CANTIDAD_TOTAL"),0,-1,0,-1))
																	else
																		Response.Write("0")
																end if
																%>
															</td>
															<td  class="ar item_row" width="101">
																<%
																if consumos("TOTAL_IMPORTE")<>"" then
																		Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE"),2,-1,0,-1) & "&nbsp;€")
																	else
																		Response.Write("0&nbsp;€")
																end if
																%>
															</td>
															
															
														</tr>
														
														<%consumos.movenext%>
													<%wend%>
													
												<%else%>
													<tr> 
														<td align="center" colspan="5"><b><FONT class="fontbold">NO Hay Consumos Que Cumplan El Critero de Búsqueda...</font></b><br>
														</td>
													</tr>
												<%end if%>
												
												
						
												
											</table>
											
										<%else 'cuando agrupamos por articulos%>
											
											<table border="0" cellpadding="1" cellspacing="1" width="99%" class="info_table">
												<tr style="background-color:#FCFCFC" valign="top">
													<th class="menuhdr" style="text-align:center">Cod. Sap</th>
													<th class="menuhdr" style="text-align:center">Descripci&oacute;n</th>
													<th class="menuhdr" style="text-align:center">Unidades Pedido</th>
													<%if diferenciar_rappel_seleccionado="SI" then%>
														<th class="menuhdr" style="text-align:center">Rappel</th>
													<%end if%>
													<%if diferenciar_empresas_seleccionada="SI" then%>
														<th class="menuhdr">Empresa</th>
													<%end if%>
													
													<%if diferenciar_sucursales_seleccionada="SI" then%>
														<th class="menuhdr">Codigo</th>
                                                        <th class="menuhdr">Cliente</th>
													<%end if%>
													<%if diferenciar_marca_seleccionada="SI" then%>
														<th class="menuhdr">Marca</th>
													<%end if%>
													<%if diferenciar_tipo_seleccionada="SI" then%>
														<th class="menuhdr">Tipo</th>
													<%end if%>
			
													<th class="menuhdr" style="text-align:center">Cantidad Total</th>
													<th class="menuhdr" style="text-align:center">Total Importe</th>
													
												</tr>
												
												<%vueltas=1
												  if not consumos.eof then %>
			                            			<%while not consumos.eof%>
													
														<tr  valign="top" id="fila_articulo_<%=i%>">
															<%
															vueltas=vueltas + 1
															if vueltas=200 then
																Response.Flush
																vueltas=1
															end if
															%>
															<td  class="al item_row" width="40"><%=consumos("CODIGO_SAP")%></td>
															<td  class="al item_row" width="124"><%=consumos("ARTICULO")%></td>
															<td  class="ac item_row" width="101"><%=consumos("UNIDADES_DE_PEDIDO")%></td>
															<%if diferenciar_rappel_seleccionado="SI" then%>
																<td  class="ac item_row" width="82"><%=consumos("RAPPEL")%></td>
															<%end if%>
															<%if diferenciar_empresas_seleccionada="SI" then%>
																<td  class="ac item_row" width="82">
																	<%=consumos("NOMBRE_EMPRESA")%>
																</td>
															<%end if%>
															
															<%if diferenciar_sucursales_seleccionada="SI" then%>

                                                                <td  class="ac item_row" style="text-align:left; width:30px">
                                                                    <%=consumos("CodCliente")%>
                                                                </td>

																<td  class="ac item_row" style="text-align:left" width="76">
																	<%=consumos("NOMBRE")%>
																	<%if consumos("CODIGO_EXTERNO")<>"" then%>
																		&nbsp(<%=consumos("CODIGO_EXTERNO")%>)
																	<%end if%>
																</td>
															<%end if%>
															<%if diferenciar_marca_seleccionada="SI" then%>
																<td  class="ac item_row" width="101">
																	<%=consumos("MARCA")%>
																</td>
															<%end if%>
															<%if diferenciar_tipo_seleccionada="SI" then%>
																<td  class="ac item_row" width="101">
																	<%=consumos("TIPO")%>
																</td>
															<%end if%>
															<td  class="ar item_row" width="101">
																<%
																if consumos("CANTIDAD_TOTAL")<>"" then
																		Response.Write(FORMATNUMBER(consumos("CANTIDAD_TOTAL"),0,-1,0,-1))
																	else
																		Response.Write("0")
																end if
																%>
															</td>
															<td  class="ar item_row" width="101">
																<%
																if consumos("TOTAL_IMPORTE")<>"" then
																		Response.Write(FORMATNUMBER(consumos("TOTAL_IMPORTE"),2,-1,0,-1) & "&nbsp;€")
																	else
																		Response.Write("0&nbsp;€")
																end if
																%>
															</td>
															
															
														</tr>
														
														<%consumos.movenext%>
													<%wend%>
													
												<%else%>
													<tr> 
														<td align="center" colspan="5"><b><FONT class="fontbold">NO Hay Consumos Que Cumplan El Critero de Búsqueda...</font></b><br>
														</td>
													</tr>
												<%end if%>
												
												
						
												
											</table>
											
										
										<%end if%>
											
											
								
									
								</div>
						
							
				  </form>
				</div>
		  <div class="submit_btn_container___" align="center">	
		  
					<table width="13%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td>
							<form id="frmpasar_excel" name="frmpasar_excel" method="post" action="Informe_Excel.asp">
								<input type="hidden" id="ocultosql" name="ocultosql" value="<%=cadena_consulta%>" />
								<input type="hidden" id="ocultoagrupacion" name="ocultoagrupacion" value="<%=agrupacion_seleccionada%>" />
								<input type="hidden" id="ocultoempresa" name="ocultoempresa" value="" />
								<input type="hidden" id="ocultoarticulo" name="ocultoarticulo" value="" />
								<input type="hidden" id="ocultoreservas_asm_gls" name="ocultoreservas_asm_gls" value="<%=reservas_asm_gls_seleccionada%>" />
								<input type="hidden" id="ocultofecha_inicio" name="ocultofecha_inicio" value="<%=fecha_i%>" />
								<input type="hidden" id="ocultofecha_fin" name="ocultofecha_fin" value="<%=fecha_f%>" />
								
								<input type="hidden" id="ocultodiferenciar_empresas" name="ocultodiferenciar_empresas" value="<%=diferenciar_empresas_seleccionada%>" />
								<input type="hidden" id="ocultodiferenciar_sucursales" name="ocultodiferenciar_sucursales" value="<%=diferenciar_sucursales_seleccionada%>" />
								<input type="hidden" id="ocultodiferenciar_articulos" name="ocultodiferenciar_articulos" value="<%=diferenciar_articulos_seleccionada%>" />
								<input type="hidden" id="ocultodiferenciar_rappel" name="ocultodiferenciar_rappel" value="<%=diferenciar_rappel_seleccionado%>" />
								<input type="hidden" id="ocultodiferenciar_marca" name="ocultodiferenciar_marca" value="<%=diferenciar_marca_seleccionada%>" />
								<input type="hidden" id="ocultodiferenciar_tipo" name="ocultodiferenciar_tipo" value="<%=diferenciar_tipo_seleccionada%>" />
							


							
							
							
								<input class="submitbtn" type="submit" name="nuevo_articulo" id="nuevo_articulo" value="Exportar a Excel" />
								
								<script language="javascript">
									//lo pongo aqui en vez de junto al combo porque el ocultoempresa se crea
									//   despues y no me mantendria el valor
									//alert(document.getElementById("cmbempresas").options[document.getElementById("cmbempresas").selectedIndex].text)
									//alert(document.getElementById("cmbempresas").value)
									if (document.getElementById("cmbempresas").value!='')
										{
										document.getElementById("ocultoempresa").value=document.getElementById("cmbempresas").options[document.getElementById("cmbempresas").selectedIndex].text
										}
									else
										{
										document.getElementById("ocultoempresa").value=''
										}
										
									if (document.getElementById("cmbarticulos").value!='')
										{
										document.getElementById("ocultoarticulo").value=document.getElementById("cmbarticulos").options[document.getElementById("cmbarticulos").selectedIndex].text
										}
									else
										{
										document.getElementById("ocultoarticulo").value=''
										}
										
								</script>
							</form>	
							</td>
						</tr>
					</table>
				
		  </div>

		
		
			
			

					
					
					
					
					
					
			
			
			
			
		</div>

	
	
	
	</td>
</tr>


</table>



















<script language="JavaScript">
		
			var cal1 = new calendar1(document.getElementById('txtfecha_inicio'));
			cal1.year_scroll = true;
			cal1.time_comp = false;
	
			var cal2 = new calendar1(document.getElementById('txtfecha_fin'));
			cal2.year_scroll = true;
			cal2.time_comp = false;
	
	</script>

</body>
<%
	consumos.close
	set consumos=Nothing
		
	connimprenta.close
	
	set connimprenta=Nothing

%>
</html>
