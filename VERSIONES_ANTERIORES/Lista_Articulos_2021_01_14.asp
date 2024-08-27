<%@ language=vbscript %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		response.Buffer=true
		numero_registros=0
		
		if session("usuario")="" then
			Response.Redirect("Login_" & session("usuario_carpeta") & ".asp")
		end if
		
		'recordsets
		dim articulos
		
		
		codigo_sap_buscado=Request.Form("txtcodigo_sap")
		articulo_buscado=Request.form("txtdescripcion")
		familia_buscada=Request.form("cmbfamilias")
		agrupacion_familia_buscada="" & Request.form("ocultoagrupacion_familias")
		
		accion=Request.QueryString("acciones")
		
		realizar_consulta="SI"
		if familia_buscada="" and articulo_buscado="" and codigo_sap_buscado="" and agrupacion_familia_buscada="" then
			familia_buscada="TODOS"
			'solo para be live y luabay si no se seleccionada nada no muestra resultados, para el resto
			' de empresas, muestra todos los articulos
			if session("usuario_codigo_empresa")=2 or session("usuario_codigo_empresa")=3 then
				realizar_consulta="NO"
			end if
		end if
		'if familia_buscada="" and articulo_buscado="" and codigo_sap_buscado="" then
		'	familia_buscada="TODOS"
		'end if
		
		

		set tipos_precios=Server.CreateObject("ADODB.Recordset")
		sql="Select tipo_precio from V_CLIENTES where nombre = '" & session("usuario_nombre") & "' and empresa=" & session("usuario_codigo_empresa") 
		with tipos_precios
			.ActiveConnection=connimprenta
			.Source=sql
			.Open
			'response.write("<br>" & sql)
			tipo_precio=tipos_precios("tipo_precio")
		end with
		tipos_precios.close
		set tipos_precios=Nothing



		set familias=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_FAMILIA=0
		CAMPO_EMPRESA_FAMILIA=1
		CAMPO_DESCRIPCION_FAMILIA=2
		with familias
			.ActiveConnection=connimprenta
			.Source="SELECT FAMILIAS.ID, FAMILIAS.CODIGO_EMPRESA, FAMILIAS.DESCRIPCION"
			.Source= .Source & " FROM FAMILIAS LEFT OUTER JOIN FAMILIAS_AGRUPADAS"
			.Source= .Source & " ON FAMILIAS.ID = FAMILIAS_AGRUPADAS.ID_FAMILIA"
			.Source= .Source & " WHERE CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			.Source= .Source & " AND FAMILIAS.ID NOT IN (SELECT ID_FAMILIA FROM FAMILIAS_PROHIBIDAS WHERE CLIENTE = " & session("usuario") & ")"
			
			if agrupacion_familia_buscada<>"" and agrupacion_familia_buscada<>"TODOS" then
				.Source= .Source & " AND GRUPO_FAMILIAS='" & agrupacion_familia_buscada & "'"
			end if
			
			.Source= .Source & " ORDER BY FAMILIAS.DESCRIPCION"

			'response.write("<br>FAMILIAS: " & .source)
			
			.Open
			vacio_familias=false
			if not .BOF then
				tabla_familias=.GetRows()
			  else
				vacio_familias=true
			end if
		end with

		familias.close
		set familias=Nothing


		set agrupacion_familias=Server.CreateObject("ADODB.Recordset")
		'CAMPO_ID_AGRUPACION_FAMILIA=0
		'CAMPO_EMPRESA_AGRUPACION_FAMILIA=1
		'CAMPO_DESCRIPCION_AGRUPACION_FAMILIA=2
		'CAMPO_ID_FAMILIA_AGRUPACION_FAMILIA=3
		CAMPO_DESCRIPCION_AGRUPACION_FAMILIA=0
		
		'session("usuario_codigo_empresa")
		with agrupacion_familias
			.ActiveConnection=connimprenta
			'.Source="SELECT  ID, ID_EMPRESA, GRUPO_FAMILIAS, ID_FAMILIA"
			.Source="SELECT  DISTINCT GRUPO_FAMILIAS"
			.Source= .Source & " FROM FAMILIAS_AGRUPADAS"
			.Source= .Source & " WHERE ID_EMPRESA=" & session("usuario_codigo_empresa")
			.Source= .Source & " ORDER BY GRUPO_FAMILIAS"
			'response.write("<br>" & .source)
			.Open
			vacio_agrupacion_familias=false
			if not .BOF then
				tabla_agrupacion_familias=.GetRows()
			  else
				vacio_agrupacion_familias=true
			end if
		end with

		agrupacion_familias.close
		set agrupacion_familias=Nothing



		set articulos=Server.CreateObject("ADODB.Recordset")
		
		if realizar_consulta="NO" then
			sql="SELECT ID FROM V_EMPRESAS WHERE 1=0" 'PARA QUE NO DEVUELVA NADA SI NO SE INTRODUCEN FILTROS DE BUSQUEDA
		  else
		  	sql="Select articulos.*,"
			sql=sql & " ARTICULOS_EMPRESAS.FAMILIA, FAMILIAS.DESCRIPCION AS nombre_familia"
			
			sql=sql & " from articulos INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO "
			sql=sql & " INNER JOIN FAMILIAS ON ARTICULOS_EMPRESAS.FAMILIA = FAMILIAS.ID "
				
			sql=sql & " where MOSTRAR='SI'"
			
			if codigo_sap_buscado<>"" then
				sql=sql & " and ARTICULOS.codigo_sap like '%" & codigo_sap_buscado & "%'"
			end if
			if articulo_buscado<>"" then
				'sql=sql & " and descripcion like ""*" & articulo_buscado & "*"""
				sql=sql & " and ARTICULOS.descripcion like '%" & articulo_buscado & "%'"
			end if
			if familia_buscada<>"TODOS" and familia_buscada<>"" then
				'response.write("<br>entro a asignar familia: " & familia_buscada)
				sql=sql & " AND ARTICULOS_EMPRESAS.FAMILIA=" & familia_buscada
			end if
			if agrupacion_familia_buscada<>"" and agrupacion_familia_buscada<>"TODOS" then
				sql=sql & " AND ARTICULOS_EMPRESAS.FAMILIA IN (SELECT ID_FAMILIA FROM FAMILIAS_AGRUPADAS"
				sql=sql & " WHERE (ID_EMPRESA = " & session("usuario_codigo_empresa") & ")"
				if agrupacion_familia_buscada<>"TODOS" then
					sql=sql & " AND (GRUPO_FAMILIAS = '" & agrupacion_familia_buscada & "')"
				end if
				
				sql=sql & ")"
			end if
			'response.write("<br>familia_buscada: " & familia_buscada)
			
			sql=sql & " and ARTICULOS_EMPRESAS.codigo_empresa = " & session("usuario_codigo_empresa") 
			sql=sql & " and FAMILIAS.codigo_empresa = " & session("usuario_codigo_empresa") 
	
			sql=sql & " and (ARTICULOS.id in (select codigo_articulo from cantidades_precios where tipo_sucursal='" & tipo_precio & "' "
			sql=sql & " and cantidades_precios.codigo_empresa=" & session("usuario_codigo_empresa") & ")) "
	
			'sql=sql & " and Descripcion <> ''"
			'sql=sql & " and Mostrar_Intranet='SI'"
			'sql=sql & " and Activo = 1"
			'sql=sql & " order by Orden"
			sql=sql & " order by ARTICULOS.compromiso_compra desc, ARTICULOS.Descripcion"
			'response.write("<br>" & sql)
		end if		
		
		with articulos
			.ActiveConnection=connimprenta
			
			.Source=sql
			
			.Open
		end with
		
		dim hoteles

		
		set carrusel=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_CARRUSEL=0
		CAMPO_ORDEN_CARRUSEL=1
		CAMPO_EMPRESAS_CARRUSEL=2
		CAMPO_FICHERO_CARRUSEL=3
		with carrusel
			.ActiveConnection=connimprenta
			.Source="SELECT ID_CARRUSEL, ORDEN, EMPRESAS, FICHERO"
			.Source= .Source & " FROM CARRUSEL"
			.Source= .Source & " WHERE EMPRESAS LIKE '%###" & session("usuario_codigo_empresa") & "###%'"
			.Source= .Source & " ORDER BY ORDEN, ID_CARRUSEL"
			'response.write("<br>FAMILIAS: " & .source)
			.Open
			vacio_carrusel=false
			if not .BOF then
				tabla_carrusel=.GetRows()
			  else
				vacio_carrusel=true
			end if
		end with

		carrusel.close
		set carrusel=Nothing
		
		
		
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
<title>Carrito Imprenta</title>
<link rel="stylesheet" type="text/css" href="estilos.css" />
<link rel="stylesheet" type="text/css" href="carrusel/css/carrusel.css" />


<style>
.botones_agrupacion{
  
  /*background-image:url("images/Boton_Informatica.jpg");*/
  background-repeat:no-repeat;
  background-position:center;
  float:left;
    
  height:100px;
  width:100px;
  float:left;
  
  /*background: url("images/Boton_Informatica.jpg") no-repeat center center fixed; */
  
  -webkit-background-size: cover;
  -moz-background-size: cover;
  -o-background-size: cover;
  background-size: cover;
  
  /*
  filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/Boton_Informatica_.jpg', sizingMethod='scale');
  -ms-filter: "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/Boton_Informatica_.jpg', sizingMethod='scale')";
 */
 }
  
#capa_opaca {
	position:absolute;
	color: black;
	background-color: #C0C0C0;
	left: 0px;
	top: 0px;
	width: 100%;
	height: 100%;
	z-index: 1000;
	text-align: center;
	visibility: visible;
	filter:alpha(opacity=40);
	-moz-opacity:.40;
	opacity:.40;
}

.aviso {
	font-family: Verdana, Arial, Helvetica, sans-serif;
  	font-size: 18px;
  	color: #000000;
  	text-align: center;
	background-color:#33FF33
}  	

#contenedorr3 { 


/* Otros estilos */ 
border:1px solid #333;
background:#eee;
padding:15px;
width:500px;

margin: 250px auto;

-moz-border-radius: 20px; /* Firefox */
-webkit-border-radius: 20px; /* Google Chrome y Safari */
border-radius: 20px; /* CSS3 (Opera 10.5, IE 9 y estándar a ser soportado por todos los futuros navegadores) */
/*
behavior:url(border-radius.htc);/* IE 8.*/

}


	.image_thumb{
			position:relative;
			overflow:hidden;
			padding-bottom:100%;
		}
		.image_thumb img{
			  position: absolute;
			  max-width: 100%;
			  max-height: 100%;
			  top: 50%;
			  left: 50%;
			  transform: translateX(-50%) translateY(-50%);
		}


#columna_izquierda { float: left; }

</style>


<script src="DD_roundies_0_0_2a.js"></script>

<script src="funciones.js" type="text/javascript"></script>
<script language="javascript">
function comprobar_numero_entero(dato)
{
		var cadenachequeo = "0123456789"; 
  		var valido = true; 
  		var lugaresdecimales = 0; 
  		var cadenacompleta = ""; 
		for (i = 0; i < dato.length; i++)
		 { 
    		ch = dato.charAt(i); 
    		for (j = 0; j < cadenachequeo.length; j++) 
      			if (ch == cadenachequeo.charAt(j))
        			break; 
    		if (j == cadenachequeo.length)
			 { 
      			valido = false; 
      			break; 
    		 } 
    		cadenacompleta += ch; 
  		 } 
  	
		if ((!valido) || (dato=='') || (dato<=0))
		 	return (false)
  		  else
		  	return (true);

}

function annadir_al_carrito(articulo)
{
	//alert('hola primero')
	//para que si no existe el objeto porque no hay precios grabados para este articulo
	//   no de error de javascript
    if (document.getElementById('ocultocantidades_precios_' + articulo))
	{
	if (document.getElementById('ocultocantidades_precios_' + articulo).value=='')
		{
		alert('Para Añadir El Artículo al Carrito ha de Seleccionar Las Cantidades/Precios del Mismo')
		}
	  else
		{
		if (document.getElementById('ocultocantidades_precios_' + articulo).value=='OTRAS CANTIDADES')
			{
			//alert('Para poder seleccionar Otras Cantidades/Precios ha de ponerse en contacto con Globalia Artes Graficas')
			//equivalencia de los caracteres especiales y lo que hay que poner en el mailto
			//á é í ó ú Á É Í Ó Ú Ñ ñ ü Ü
			//%E1 %E9 %ED %F3 %FA %C1 %C9 %CD %D3 %DA %D1 %F1 %FC %DC
			//
			//para insertar saltos de linea
			//%0D%0A%0A
			//alert('hola')
			cadena_email='mailto:carlos.gonzalez@globalia-artesgraficas.com'
			cadena_email+= '?subject=Nuevo Escalado Barcel%F3'
			cadena_email+= '&body=Por favor indique el nombre y c%F3digo Sap. del art%EDculo del que desea que le facilitemos'
			cadena_email+= ' un nuevo escalado y a continuaci%F3n la cantidad requerida.'
			cadena_email+= '%0D%0A%0A En breve la encontrar%E1 colgada en el gestor de pedidos.'
			cadena_email+= '%0D%0A%0AUn saludo.'

			location.href=cadena_email
			}
		  else
		  	{
			document.getElementById('ocultoarticulo').value=articulo
			//si es uno de los articulos con compromiso de compra, vendra con xxx en las cantidades
			//  tengo que sustituirlo por lo que el usuario introduzca manualmente en la cantidad del
			//  articulo seleccionado
			//alert('cantidades antes: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
			if (document.getElementById('ocultocantidades_precios_' + articulo).value.indexOf('XXX')!=-1) 
				{
				if (comprobar_numero_entero(document.getElementById('txtcantidad_' + articulo).value))
					{
					document.getElementById('ocultocantidades_precios_' + articulo).value=document.getElementById('ocultocantidades_precios_' + articulo).value.replace('XXX',document.getElementById('txtcantidad_' + articulo).value)
					document.getElementById('ocultocantidades_precios').value=document.getElementById('ocultocantidades_precios_' + articulo).value
					//alert('cantidades despues: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)

					document.getElementById('frmannadir_al_carrito').submit()
					}
				  else
				  	{
						alert('La Cantidad Introducida Ha De Ser Un Número Entero')
						document.getElementById('txtcantidad_' + articulo).value=''
					}
				}
			  else
			  	{
				//cuando el articulo es sin compromiso de compra, ya viene la cantidad bien
				document.getElementById('ocultocantidades_precios').value=document.getElementById('ocultocantidades_precios_' + articulo).value
				//alert('cantidades despues: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
				document.getElementById('frmannadir_al_carrito').submit()
				}
			
			}
	
		}  
	}
  else
  	{
		alert('No Está Autorizado a Pedir Este Artículo')
	}
		
		
}

function seleccionar_fila(articulo, fila_pulsada, numero_filas,cantidades_precio_total_articulo,compromiso_compra)
{
	for (i=1;i<=numero_filas;i++)
	{
	document.getElementById('fila_' + articulo + '_' + i).style.background=''
	document.getElementById ('fila_' + articulo + '_' + i).style.fontWeight = 'normal'
//var fontTest = document.getElementById ('fila_' + articulo + '_' + i)
    //fontTest.style.fontWeight = '900';

	}
	
	document.getElementById('fila_' + articulo + '_' + fila_pulsada).style.background='#E1E1E1' 
	document.getElementById ('fila_' + articulo + '_' + fila_pulsada).style.fontWeight = 'bold'
	//alert('compromiso_compra: ' + compromiso_compra)
	document.getElementById('ocultocantidades_precios_' + articulo).value=cantidades_precio_total_articulo
		
	  	
}

function ir_pto_articulo(pto_articulo, agrupacion)
{
	if (pto_articulo!='')
	{
		window.location='#'+pto_articulo;
	}
	
	if (agrupacion!='')
		{
		activar_agrupacion(agrupacion)
		}
	cerrar_capas('capa_informacion')
}

function activar_agrupacion(agrupacion)
{
	cadena_boton='cmdAgrupacion_' + agrupacion
	cadena_imagen='images/Boton_' + agrupacion + '_Pulsado.jpg'
	//alert('boton pulsado: ' + cadena_boton + '\n\nimagen a cargar: ' + cadena_imagen)
	
	//document.getElementById(cadena_boton).style.backgroundImage='url("' + cadena_imagen + '")';
	//document.getElementById('cmdAgrupacion_CONSUMIBLES').style.backgroundImage='url("images/boton_consumibles_pulsado.jpg")';
	//document.getElementById('cmdAgrupacion_MARKETING').style.backgroundImage="url('images/Boton_Informatica_Pulsado.jpg')"
	document.getElementById(cadena_boton).style.backgroundImage='url(' + cadena_imagen + ')';
	//document.getElementById(cadena_boton).src=cadena_imagen;
	
	//alert('hola')

}
function mostrar_agrupaciones(agrupacion)
{
	activar_agrupacion(agrupacion)
	//alert('en mostrar agrupaciones')
	document.getElementById('cmbfamilias').value="TODOS"
	document.getElementById('ocultoagrupacion_familias').value=agrupacion
	//alert('antes del submit')
	document.getElementById('frmbusqueda').submit()
}

</script>

<script language="javascript">
function mostrar_capas(capa)
{
	//redondear capa para el internet explorer
	DD_roundies.addRule('#contenedorr3', '20px');
	document.getElementById('capa_opaca').style.display=''
	document.getElementById(capa).style.display='';
}

function cerrar_capas(capa)
{	
	document.getElementById('capa_opaca').style.display='none';
	document.getElementById(capa).style.display='none';
}
</script>


</head>
<body onLoad="ir_pto_articulo('<%=pto_articulo%>', '<%=agrupacion_familia_buscada%>')" style="margin-top:0">
<!-- capa opaca para que no deje pulsar nada salvo lo que salga delante (se comporte de forma modal)-->
<div id="capa_opaca" style="display:none;background-color:#000000;position:fixed;top:0px;left:0px;width:105%;min-height:110%;z-index:5;filter:alpha(opacity=50);-moz-opacity:.5;opacity:.5">
</div>

<!-- capa con la informacion a mostrar por encima-->
<div id="capa_informacion" style="display:none;z-index:6;position:fixed;width:100%; height:100%">
		<div id="contenedorr3" class="aviso">
			<p>
				<img src="images/loading4.gif"/>
					<br /><br />
					Espere mientras se carga la página...
			</p>
		</div>
		

</div>
<script language="javascript">
mostrar_capas('capa_informacion')
</script>

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
	
		<div id="columna_izquierda">
	
		<div class="sidebarcell">
			
			<div id="side_freetext_title_39" class="title">
				<br />
				<font size="3"><b>Datos del Cliente</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					<b><%=session("usuario_empresa")%></b>
					<%if session("usuario_codigo_externo") <> "" then%>
						<b>&nbsp;-&nbsp;<%=session("usuario_codigo_externo")%></b>
					<%end if%>
					<br />
					<b><%=session("usuario_nombre")%></b>
					<br />
					<%=session("usuario_marca")%>
					<br />
					<%=session("usuario_direccion")%>
					<br /> 
					<%=session("usuario_poblacion")%>
					<br />
					<%=session("usuario_cp")%>&nbsp;<%=session("usuario_provincia")%>
					<br />
					Tel: <%=session("usuario_telefono")%>
					<br />
					Fax: <%=session("usuario_fax")%>
					<br />
					
					
				</div>
				</div>
			</div>
		</div>
		
		<div class="sidebarcell">
			
			<div id="side_freetext_title_39" class="title">
				<br />
				<font size="3"><b>Datos del Pedido</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					<table width="95%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td width="31%" align="right"><img src="images/Carrito_48x48.png" border="0" /></td>
							<td width="69%">&nbsp;<b><%=session("numero_articulos")%></b> Artículos</td>
						</tr>
					</table>
					
					<br />
					<br />
					<div class="info">
					<table width="95%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td width="50%">
								<a href="Carrito.asp?acciones=<%=accion%>" class="btn-details"><font color="#FFFFFF">Ver Pedido</font></a>
							</td>
							<td width="50%">
								<a href="Vaciar_Carrito.asp" class="btn-details"><font color="#FFFFFF">Borrar Pedido</font></a>
							</td>
						</tr>
					</table>
					</div>
					
				</div>
				</div>
			</div>
		</div>
		
		<div class="sidebarcell">
			
			<div id="side_freetext_title_39" class="title">
				<br />
				<font size="3"><b>Pedidos Realizados</b></font>
			</div>
			<div class="contentcell">
				<div class="sidefreetext" ><div align="left">
					· <a href="Consulta_Pedidos.asp">Consultar</a>
					
				  <div class="info">				  </div>
					
				</div>
				</div>
			</div>
		</div>
		
		<%if not vacio_carrusel then%>
		<div class="sidebarcell">
			<div id="side_freetext_title_39" class="title">
				<br />
				<font size="3"><b>DESTACADOS</b></font>
			</div>
			
						
						<!--COMIENZO DEL CARRUSEL-->
						<script type="text/javascript" src="carrusel/js/carrusel_4_seg.js"></script>
						<div class="contentcell" id="jssor_1" style="position: relative; margin: 0 auto; top: 0px; left: 0px; width: 200px; height: 300px; overflow: hidden; visibility: hidden;">
							<!-- Pantalla de "Cargando..." -->
							<div data-u="loading" style="position: absolute; top: 0px; left: 0px;">
								<div style="filter: alpha(opacity=70); opacity: 0.7; position: absolute; display: block; top: 0px; left: 0px; width: 100%; height: 100%;"></div>
								<div style="position:absolute;display:block;background:url('carrusel/img_carrusel/loading.gif') no-repeat center center;top:0px;left:0px;width:100%;height:100%;"></div>
							</div>
							<div data-u="slides" style="cursor: default; position: relative; top: 0px; left: 0px; width: 200px; height: 300px; overflow: hidden;">
								<%for i=0 to UBound(tabla_carrusel,2)%>
									<div style="display: none;"><img data-u="image" src="carrusel/img_carrusel/<%=tabla_carrusel(campo_fichero_carrusel,i)%>" /></div>
								<%next%>
								
								
							</div>
							<!-- Botones de Navegacion -->
							<!--
							<div data-u="navigator" class="jssorb05" style="bottom:16px;right:16px;" data-autocenter="1">
								<!-- Boton prototipo 
								<div data-u="prototype" style="width:16px;height:16px;"></div>
							</div>
							-->
							
							<!-- Flechas de Navegacion -->
							<span data-u="arrowleft" class="jssora10l" style="top:0px;left:8px;width:28px;height:40px;" data-autocenter="2"></span>
							<span data-u="arrowright" class="jssora10r" style="top:0px;right:8px;width:28px;height:40px;" data-autocenter="2"></span>
						</div>
						<!-- FIN DEL CARRUSEL-->
						<script>
							jssor_1_slider_init();
						</script>
						
						
					</div>
					<!-- FINALIZA EL CARRUSEL-->
				
		</div>
		<%end if%>
		
		
		
		</div><!-- column_izquierda-->
		
	</td>
	<td width="713" valign="top">
		<div id="main">
			<table width="90%" cellspacing="6" cellpadding="0" class="logintable" align="center">
				<tr>
					<!--6.08 - Translate titles and buttons-->
					<td class="al">
						<span class='fontbold'>Busqueda de Productos <%=session("usuario_empresa")%></span>
					</td>
				</tr>
				<tr>
					<td width="50%" class="dottedBorder vt al">
						
	  
						<form name="frmbusqueda" id="frmbusqueda" method="post" action="Lista_Articulos.asp?acciones=<%=accion%>">
							<input type="hidden" id="ocultoagrupacion_familias" name="ocultoagrupacion_familias" value="<%=agrupacion_familia_buscada%>" />
							<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Referencia: </td>
									<td width="20%"><input class="txtfield" size="14" name="txtcodigo_sap" id="txtcodigo_sap" value="<%=codigo_sap_buscado%>" /></td>
									<td width="13%">Descripción: </td>
									<td width="42%"><input class="txtfield" size="44" name="txtdescripcion" id="txtdescripcion" value="<%=articulo_buscado%>" /></td>
									<td width="12%">
										<div align="right">
										  <input class="submitbtn" type="submit" name="Action" id="Action" value="Buscar" />
										</div>
									</td>
								</tr>
								
							</table>
							<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							</table>
							<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Familia: </td>
									<td width="30%">
									

											<select name="cmbfamilias" id="cmbfamilias">
												
												<%if not vacio_familias then%>
													<%for i=0 to UBound(tabla_familias,2)%>
														<%if valor_seleccionado<>"" then
															if cint(valor_seleccionado)=cint(tabla_familias(campo_id_familia,i)) then%>
																<option value="<%=tabla_familias(campo_id_familia,i)%>" selected><%=tabla_familias(campo_descripcion_familia,i)%></option>
														  	<%else%>
																<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=tabla_familias(campo_descripcion_familia,i)%></option>
															<%end if%>
											  			<%else%>
							  								<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=tabla_familias(campo_descripcion_familia,i)%></option>
														<%end if%>
													<%next%>
												<%end if%>
												<option value="TODOS" selected>-- TODOS --</option>
											</select>
											
											<script language="javascript">
													document.getElementById("cmbfamilias").value='<%=familia_buscada%>'
											</script>
											
											
											
										
									</td>
									<td width="11%"></td>
									<td width="46%"></td>
									
								</tr>
								
								
							</table>
							<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							</table>
							<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td>
									  <div align="center" style="width:620px ">
										<%if not vacio_agrupacion_familias then%>
													
													<%for i=0 to UBound(tabla_agrupacion_familias,2)%>
														
														<div  class="botones_agrupacion" name="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" id="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" value="<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" onclick="mostrar_agrupaciones('<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>')" style="background-image:url('images/Boton_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>.jpg')"></div>
														<!--
														<img class="botones_ag" name="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" id="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>"  onclick="mostrar_agrupaciones('<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>')" src="images/Boton_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>.jpg" />
														-->
														
													<%next%>
													<div  class="botones_agrupacion" name="cmdAgrupacion_TODOS" id="cmdAgrupacion_TODOS" onclick="mostrar_agrupaciones('TODOS')" style="background-image:url('images/Boton_TODOS.jpg')" ></div>
														
													
													<%if agrupacion_familia_buscada<>"" then%>
															<script language="javascript">
																//alert('cambio la imagen a <%=agrupacion_familia_buscada%>')
																document.getElementById('cmdAgrupacion_<%=agrupacion_familia_buscada%>').style.backgroundImage="url('images/Boton_<%=agrupacion_familia_buscada%>_Pulsado.jpg')";								
																//document.getElementById('cmdAgrupacion_<%=agrupacion_familia_buscada%>').src = 'images/Boton_<%=agrupacion_familia_buscada%>_Pulsado.jpg'
															</script>
													<%end if%>
                                            <%end if%>
										</div>	
									
									</td>
								</tr>
								
							</table>
							<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							</table>
						</form>
				  </td>
				</tr>
			</table>
			
			<div id="center_newproducts__title_28" class="main-product">
			
			<%while not articulos.eof
				response.flush()%>
				<a name="pto_<%=articulos("id")%>" id="pto_<%=articulos("id")%>"></a>
				<table width="587" class="product-wrapper"  align="center">
				  <tr>
					<!--inicio del articulo-->
					<td width="579" colspan="3" class="vt ac">
						<div id="displaynewproducts0" class="randomproduct">
							<table width="100%" cellspacing="0" cellpadding="0" border="0" class="prod_border_table">
								<tbody>
									<tr>
										<td class="td1">
											<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table1">
												<tbody>
													<tr>
														<td class="td2">
																<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table2">
																	<tbody>
																		<tr>
																			<td class="td3">
																				<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table3">
																					<tbody>
																						<tr>
																							<td width="42%"> <!-- aqui iba class="prod_border_td"-->  
																								<!--<div class="image">-->
																								<center>
																									<table border="0" width="100%" height="100%">
																										<tr><td height="3"></td></tr>
																										<tr>
																											<td valign="middle" align="center">
																												<%if session("usuario_codigo_empresa")=1 then 'BARCELÓ 
																													carpeta_marca=session("usuario_marca")&"/"
																												  else
																													carpeta_marca=""
																												  end if
																												%>
																												<a href="Imagenes_Articulos/<%=carpeta_marca%><%=articulos("id")%>.jpg" target="_blank">
																													<img class="product_thumbnail" src="Imagenes_Articulos/<%=carpeta_marca%>Miniaturas/i_<%=articulos("id")%>.jpg" border="0">
																												</a>
																											</td>
																										</tr>
																										<tr><td height="3"></td></tr>
																									</table>
																								</center>
																								<!--</div>-->
																							</td>
																							<td width="58%" class="prod_border_td">
																								
																								<table border="0" cellpadding="0" cellspacing="0" width="100%" >
																									<tr>
																										<td><h3><%=articulos("descripcion")%></h3></td>
																									</tr>
																									<tr>
																										<td><div align="left"><b>Codigo Sap:</b> <%=articulos("codigo_sap")%><br /></div></td>
																									</tr>
																									<tr>
																										<td><div align="left"><b>Familia:</b> <%=articulos("nombre_familia")%><br /></div></td>
																									</tr>
																									<tr>
																										<td>
																											<div align="left" style="display:none" id="informacion_<%=articulos("ID")%>">
																												
																												<%
																												set multiarticulos=Server.CreateObject("ADODB.Recordset")
		
																												sql="Select *  from descripciones_multiarticulos"
																												sql=sql & " where id_articulo=" & articulos("ID") 
																												sql=sql & " order by id"
																												'response.write("<br>" & sql)
																												
																												with multiarticulos
																													.ActiveConnection=connimprenta
																													
																													.Source=sql
																													
																													.Open
																												end with
																												
																												while not multiarticulos.eof
																												%>
																													<b><%=multiarticulos("caracteristica")%>:</b> <%=multiarticulos("descripcion")%><br />
																												
																												<%
																													multiarticulos.movenext
																												wend
																												%>
																												
																												
																												<%if articulos("tamanno")<>"" then%>
																													<b>Tamaño:</b> <%=articulos("tamanno")%><br />
																												<%end if%>
																												<%if articulos("tamanno_abierto")<>"" then%>
																													<b>Tamaño Abierto:</b> <%=articulos("tamanno_abierto")%><br />
																												<%end if%>
																												<%if articulos("tamanno_cerrado")<>"" then%>
																													<b>Tamaño Cerrado:</b> <%=articulos("tamanno_cerrado")%><br />
																												<%end if%>
																												<%if articulos("papel")<>"" then%>
																													<b>Papel:</b> <%=articulos("papel")%><br />
																												<%end if%>
																												<%if articulos("tintas")<>"" then%>
																													<b>Tintas:</b> <%=articulos("tintas")%><br />
																												<%end if%>
																												<%if articulos("acabado")<>"" then%>
																													<b>Acabado:</b> <%=articulos("acabado")%><br />
																												<%end if%>
																												<%if articulos("fecha")<>"" then%>
																													<b>Fecha:</b> <%=articulos("fecha")%><br />&nbsp;
																												<%end if%>
																												
																												
																												
																												
																												
																												
																											</div>
																										</td>
																									</tr>
																								
																								</table>
																								
																								<div class="info">
																									<table width="100%" >
																										<tr>
																											<td width="50%" class="info_column">
																												<%
																												set cantidades_precios=Server.CreateObject("ADODB.Recordset")
		
																												sql="SELECT * FROM CANTIDADES_PRECIOS"
																												sql=sql & " WHERE CODIGO_ARTICULO=" & articulos("id")
																												sql=sql & " and tipo_sucursal='" & tipo_precio & "' "
																												sql=sql & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
																												sql=sql & " ORDER BY CANTIDAD"
																												'response.write("<br>" & sql)
																												
																												with cantidades_precios
																													.ActiveConnection=connimprenta
																													.CursorType=3 'adOpenStatic
																													.Source=sql
																													.Open
																												end with
																												%>         
																												<span>
																												<%if not cantidades_precios.eof then%>
																													
																													<%if articulos("compromiso_compra")="NO" then%>
																													
																														<table width="95%" cellpadding="0" cellspacing="0" border="0" style="border:2px solid">
																															<tr>
																																<td style="border-bottom:1pt solid">Cantidad</td>
																																<td style="border-left:1pt solid;border-bottom:1pt solid">Precio Pack</td>
																															</tr>
																															
																															<%filas=1
																															'cantidades_precios.movelast
																															'cantidades_precios.movefirst
																															numero_filas=cantidades_precios.recordcount
																															while not cantidades_precios.eof%>
																															
																																<%
																																cantidades_precio_total_articulo=""
																																cantidades_precio_total_articulo=cantidades_precios("cantidad") & "--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																																%>
																																<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','NO')">
																																	<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																																	<td style="border-bottom:1pt solid" align="right"><%=cantidades_precios("cantidad")%>&nbsp;</td>
																																	<td style="border-left:1pt solid;border-bottom:1pt solid" align="right">
																																		<%
																																			IF cantidades_precios("precio_pack")<>"" then
																																				Response.Write(FORMATNUMBER(cantidades_precios("precio_pack"),2) & " €")
																																			  else
																																				Response.Write("")
																																			end if
																																		%>
																																		&nbsp;
																																	</td>
																																</tr>
																																<%
																																filas=filas+1
																																cantidades_precios.movenext%>
																															<%wend%>
																															
																														</table>
																													  <%else%>
																													  
																													  	<table width="99%" cellpadding="0" cellspacing="0" border="0" style="border:2px solid">
																															<tr>
																																<td style="border-bottom:1pt solid">Cantidad</td>
																																<td style="border-left:1pt solid;border-bottom:1pt solid">Precio Unid.</td>
																															</tr>
																															
																															<%filas=1
																															'cantidades_precios.movelast
																															'cantidades_precios.movefirst
																															numero_filas=cantidades_precios.recordcount
																															while not cantidades_precios.eof%>
																															
																																<%
																																'como son articulos con compromiso de compra, la cantidad no es fija, tienen que indicarla
																																cantidades_precio_total_articulo=""
																																cantidades_precio_total_articulo="XXX--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																																%>
																																<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','SI')">
																																	<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																																  <td height="25" align="right" style="border-bottom:1pt solid"><input class="txtfield" size="5" name="txtcantidad_<%=articulos("id")%>" id="txtcantidad_<%=articulos("id")%>" />&nbsp;</td>
																																	<td style="border-left:1pt solid;border-bottom:1pt solid" align="right">
																																		<%
																																			IF cantidades_precios("precio_unidad")<>"" then
																																				Response.Write(cantidades_precios("precio_unidad") & " €/u")
																																			  else
																																				Response.Write("")
																																			end if
																																		%>
																																		&nbsp;
																																	</td>
																																</tr>
																																<%
																																filas=filas+1
																																cantidades_precios.movenext%>
																															<%wend%>
																															
																														</table>
																													<%end if%>
																													  
																												<%end if%>
																												<%
																												cantidades_precios.close
																												set cantidadese_precios=Nothing
																												%>
																												</span><br />
																											</td>
																											<td valign="top" class="divider-vertical2"></td>
																											<td valign="top" class="info_column">
																												<table border="0" cellspacing="0" cellpadding="0" class="input_table" >
																													<tr>
																														<td valign="top">             
																															<a href="#nogoto" onclick="muestra('informacion_<%=articulos("ID")%>')" class="btn-details">+ información</a>
																														</td>
																													</tr>
																												
																													<tr>
																														<td valign="top"> 
																															<table width="80%" cellpadding="0" cellspacing="0" align="center" >
																																<tr>
																																	<td width="33%"><a href="#nogoto" onclick="annadir_al_carrito(<%=articulos("ID")%>)" ><img src="images/Carrito_16x16.png" border="0" />&nbsp;</a></td>
																																	<td width="67%" style="text-align:left"><a href="#nogoto" onclick="annadir_al_carrito(<%=articulos("ID")%>)" ><div class="fontbold"><b>Añadir</b></div></a></td>
																																</tr>
																															</table>            
																															
																														</td>
																													</tr>
																												</table>
																											</td>
																										</tr>
																										<%if articulos("unidades_de_pedido")<>"" then%>
																											<tr><td colspan="3"><b>Unidades de Pedido:</b> <%=articulos("unidades_de_pedido")%></td></tr>
																										<%end if%>
																									</table>
																								</div>
																								<span class="cb"></span>
																							</td>
																						</tr>
																					</tbody>
																				</table>
																				
																			</td>
																		</tr>
																	</tbody>
																</table>
													  </td>
												  </tr>
											  </tbody>
										  </table>
									  </td>
								  </tr>
							  </tbody>
						  </table>
					  </div>
					</td>
						<!--Final del Articulo-->
						
				</tr>	
				
			  </table>
			  <%articulos.movenext%>	
			<%wend%>
				
				
			</div>
			</div>

	
	
	
	</td>
</tr>


</table>

<form name="frmannadir_al_carrito" id="frmannadir_al_carrito" action="Annadir_Articulo.asp?acciones=<%=accion%>" method="post">
	<input type="hidden" name="ocultoarticulo" id="ocultoarticulo" value=""/>
	<input type="hidden" name="ocultocantidades_precios" id="ocultocantidades_precios" value="" />
</form>


				<!-- END SHOPPAGE_HEADER.HTM -->
				
<script src="js/jquery.min_1_11_0.js"></script>
<script src="js/jquery-ui.min_1_10_4.js"></script>
<script>

// para que se ponga visible siempre la columna de la izquierda
$(function() {
            var offset = $("#columna_izquierda").offset();
            var topPadding = 15;
            $(window).scroll(function() {
                if ($(window).scrollTop() > offset.top) {
                    $("#columna_izquierda").stop().animate({
                        marginTop: $(window).scrollTop() - offset.top + topPadding
                    });
                } else {
                    $("#columna_izquierda").stop().animate({
                        marginTop: 0
                    });
                };
            });
        });
</script>       
				

</body>
<%
	articulos.close
	
	connimprenta.close
			  
			
	set articulos=Nothing
	
	set connimprenta=Nothing
%>
</html>

