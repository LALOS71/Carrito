<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
		if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
		end if
		
		articulo_seleccionado=Request.Form("ocultoid_articulo")
		accion_seleccionada=Request.Form("ocultoaccion")
		'response.write("<br>-" & articulo_seleccionado&"-")
		
		'recordsets
		dim empresas
		
		
		'variables
		dim sql
		
		
	'Dim imagen As New Bitmap(New Bitmap("D:\Intranet_Local\Asp\Carrito_Imprenta\Imagenes_Articulos\BARCELO\3244.jpg"), 320, 288) 
	
	'imagen.Save("D:\Intranet_Local\Asp\Carrito_Imprenta\Imagenes_Articulos\BARCELO\3244__.jpg", System.Drawing.Imaging.ImageFormat.Jpeg)

	    

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
		
		with articulos
		
			.ActiveConnection=connimprenta
			.Source="SELECT ARTICULOS.ID, ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION,"
			.Source= .Source & " ARTICULOS.TAMANNO, ARTICULOS.TAMANNO_ABIERTO, ARTICULOS.TAMANNO_CERRADO, ARTICULOS.PAPEL,"
			.Source= .Source & " ARTICULOS.TINTAS, ARTICULOS.ACABADO, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.FECHA,"
			.Source= .Source & " ARTICULOS.COMPROMISO_COMPRA, ARTICULOS.MOSTRAR, ARTICULOS.BORRADO, ARTICULOS.REQUIERE_AUTORIZACION, "
			.Source= .Source & " ARTICULOS.PACKING, ARTICULOS.FACTURABLE "
			'.Source= .Source & " ARTICULOS.COMPROMISO_COMPRA, ARTICULOS.MOSTRAR, ARTICULOS.FAMILIA"
			.Source= .Source & " FROM ARTICULOS WHERE ARTICULOS.ID=" & articulo_seleccionado
			'response.write("<br>" & .Source)
			.Open
		end with
		campo_codigo_sap=""
		campo_descripcion=""
		campo_tamanno=""
		campo_tamanno_abierto=""
		campo_tamanno_cerrado=""
		campo_papel=""
		campo_tintas=""
		campo_acabado=""
		campo_unidades_pedido=""
		campo_packing=""
		campo_fecha=""
		campo_compromiso_compra=""
		campo_mostrar=""
		'campo_familia=""
		campo_eliminado=""
		campo_autorizacion=""
		campo_facturable=""
		
		if not articulos.eof then
			campo_codigo_sap=articulos("codigo_sap")
			campo_descripcion=articulos("descripcion")
			campo_tamanno=articulos("tamanno")
			campo_tamanno_abierto=articulos("tamanno_abierto")
			campo_tamanno_cerrado=articulos("tamanno_cerrado")
			campo_papel=articulos("papel")
			campo_tintas=articulos("tintas")
			campo_acabado=articulos("acabado")
			campo_unidades_pedido=articulos("unidades_de_pedido")
			campo_packing=articulos("packing")
			campo_fecha=articulos("fecha")
			campo_compromiso_compra=articulos("compromiso_compra")
			campo_mostrar=articulos("mostrar")
			'campo_familia=articulos("familia")
			campo_eliminado=articulos("borrado")
			campo_autorizacion=articulos("requiere_autorizacion")
			campo_facturable=articulos("facturable")
		end if
		
		
		articulos.close
		set articulos=Nothing
		
		
		set familias=Server.CreateObject("ADODB.Recordset")
		'CAMPO_ID_FAMILIA=0
		'CAMPO_EMPRESA_FAMILIA=1
		'CAMPO_DESCRIPCION_FAMILIA=2
		with familias
			.ActiveConnection=connimprenta
			.CursorType=3 'adOpenStatic
			.Source="SELECT ID, CODIGO_EMPRESA, DESCRIPCION FROM FAMILIAS ORDER BY CODIGO_EMPRESA, DESCRIPCION"
			'response.write("<br>" & .source)
			.Open
			'vacio_familias=false
			'if not .BOF then
				'tabla_familias=.GetRows()
			  'else
				'vacio_familias=true
			'end if
		end with


		'Esta consulta es para saber si el artículo seleccionado es de Barceló o de otros, por el tema del Stock
		set articulos_empresas=Server.CreateObject("ADODB.Recordset")
				
		with articulos_empresas
			.ActiveConnection=connimprenta
			.Source="SELECT ID_ARTICULO, CODIGO_EMPRESA, FAMILIA FROM ARTICULOS_EMPRESAS WHERE ID_ARTICULO=" & articulo_seleccionado & " ORDER BY CODIGO_EMPRESA"
			.Open
		end with
		empresas_barcelo=0
		empresas_otras=0
	  	while not articulos_empresas.eof
			if articulos_empresas("CODIGO_EMPRESA")=1 then
				empresas_barcelo=empresas_barcelo+1
			else
				empresas_otras=empresas_otras+1
			end if
			articulos_empresas.movenext
		wend
		articulos_empresas.close
		set articulos_empresas=Nothing

		set stocks_articulo=Server.CreateObject("ADODB.Recordset")
		'hacemos esta consulta rara, para que coga todos los nombres de marca posibles
		' para los articulos, si no hay nada que de opcion a crear stock para ese articulo de esa marca
		'	
		'sql="SELECT HOTELES_MARCA.MARCA, a.ID_ARTICULO, a.STOCK, a.STOCK_MINIMO"
		'sql=sql & " FROM HOTELES_MARCA LEFT JOIN"
		'sql=sql & " (SELECT ARTICULOS_MARCAS.ID_ARTICULO, ARTICULOS_MARCAS.MARCA, ARTICULOS_MARCAS.STOCK, ARTICULOS_MARCAS.STOCK_MINIMO"
		'sql=sql & " FROM ARTICULOS_MARCAS"
		'sql=sql & " WHERE ARTICULOS_MARCAS.ID_ARTICULO=" & articulo_seleccionado & ") as a"
		'sql=sql & " ON HOTELES_MARCA.MARCA = a.MARCA where hoteles_marca.empresa<>1 "
		'sql=sql & " ORDER BY HOTELES_MARCA.MARCA"
		
		sql="SELECT MARCA, iD_ARTICULO, sTOCK, STOCK_MINIMO from articulos_marcas WHERE ID_ARTICULO=" & articulo_seleccionado 
		sql=sql & " ORDER BY MARCA"
		'response.write("<br>" & sql)
		
		CAMPO_MARCA_ARTICULOS_MARCAS=0
		CAMPO_ID_ARTICULO_ARTICULOS_MARCAS=1
		CAMPO_STOCK_ARTICULOS_MARCAS=2
		CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS=3
		
		with stocks_articulo
			.ActiveConnection=connimprenta
			.CursorType=3 'adOpenStatic
			.Source=sql
			.Open
			vacio_stocks_articulo=false
			if not .BOF then
				mitabla_stocks_articulo=.GetRows()
			  else
				vacio_stocks_articulo=true
			end if
		end with
			 
		stocks_articulo.close
		set stocks_articulo=Nothing
		
		'Si el articulo pertenece a Barceló obtenemos una tabla alternativa de stock por si seleccionan otra empresa.
		' Lo mismo si pertenece a otra empresa, sacamos una tabla alternativa con el stock vacío de Barceló.
		dim mitabla_stocks_articulo_otra
		if empresas_barcelo>0 and empresas_otras=0 then 'Artículo de Barceló
			redim mitabla_stocks_articulo_otra(4,0)
			mitabla_stocks_articulo_otra(0,0)="STANDARD"
		else
			redim mitabla_stocks_articulo_otra(4,2)
			mitabla_stocks_articulo_otra(0,0)="BARCELO"
			mitabla_stocks_articulo_otra(0,1)="COMFORT"
			mitabla_stocks_articulo_otra(0,2)="PREMIUM"
		end if
		
		if empresas_barcelo=0 and empresas_otras=0 then 'Si es un Artículo NUEVO mostramos una tabla vacía u otra según las empresas que seleccionen
			vacio_stocks_articulo=false 
			dim mitabla_stocks_articulo
			redim mitabla_stocks_articulo(4,0)
			mitabla_stocks_articulo(0,0)="STANDARD"

			redim mitabla_stocks_articulo_otra(4,2)
			mitabla_stocks_articulo_otra(0,0)="BARCELO"
			mitabla_stocks_articulo_otra(0,1)="COMFORT"
			mitabla_stocks_articulo_otra(0,2)="PREMIUM"
		end if

		'solo se gestiona el escalado despues de que este dado de alta el articulo
		if accion_seleccionada="MODIFICAR" then
			set tipos_precios=Server.CreateObject("ADODB.Recordset")
				
			with tipos_precios
				.ActiveConnection=connimprenta
				.Source="SELECT V_EMPRESAS.Id, V_EMPRESAS.EMPRESA, V_EMPRESAS_TIPOS_PRECIOS.TIPO_PRECIO "
				.Source=.Source & " FROM ARTICULOS_EMPRESAS INNER JOIN V_EMPRESAS_TIPOS_PRECIOS "
				.Source=.Source & " ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA = V_EMPRESAS_TIPOS_PRECIOS.ID_EMPRESA INNER JOIN "
                .Source=.Source & " V_EMPRESAS ON V_EMPRESAS_TIPOS_PRECIOS.ID_EMPRESA = V_EMPRESAS.Id "
				.Source=.Source & " WHERE ARTICULOS_EMPRESAS.ID_ARTICULO = " & articulo_seleccionado
				.Source=.Source & " ORDER BY V_EMPRESAS.EMPRESA, V_EMPRESAS_TIPOS_PRECIOS.TIPO_PRECIO "
				'response.Write("<br>"&.Source)
				.Open
			end with
		end if																												

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
		
.Estilo1 {color: #B00004}
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


	
	
   function mover_formulario(objetivo)
   {
   	if (objetivo=='volver')
   		accion='Lista_Articulos.asp'
	  else
	  	accion='Grabar_Pedido.asp';
	document.getElementById('frmpedido').action=accion
	document.getElementById('frmpedido').submit()	
	

   }
   	

   
function seleccionar_fila(id_empresa,tipo_precio,fila_pulsada, numero_filas, modo, id_escalado, tipo_oficina)
{
	//en el caso de ser asm, codigo empresa 4, tiene 2 precios diferentes uno para franquicias y otro para propias
	
	/*
	cadena_oficina_intermedio=''
	cadena_oficina_fin=''
	parametro_oficina=''
	
	if (tipo_oficina=='OFICINA')
		{
		cadena_oficina_intermedio='oficinas_'
		cadena_oficina_fin='_oficinas'
		parametro_oficina='OFICINA'
		}
	*/

	if (modo=='MODIFICAR')
		{
		desseleccionar_filas(numero_filas,tipo_precio,id_empresa)
		
		document.getElementById('fila_cantidades_precios_' + id_empresa + '_' + tipo_precio + '_' + fila_pulsada).style.background='#E1E1E1' 
		document.getElementById('fila_cantidades_precios_' + id_empresa + '_' + tipo_precio + '_' + fila_pulsada).style.fontWeight = 'bold'
		//alert('compromiso_compra: ' + compromiso_compra)
		//document.getElementById('ocultocantidades_precios_' + articulo).value=cantidades_precio_total_articulo
		document.getElementById('tabla_modificacion_escalado_' + id_empresa + '_' + tipo_precio).style.display='block'
		document.getElementById('txtcantidad_mantenimiento_' + id_empresa + '_' + tipo_precio).value=document.getElementById('ocultocantidad_' + id_empresa + '_' + tipo_precio + '_' + fila_pulsada).value
		document.getElementById('txtprecio_pack_mantenimiento_' + id_empresa + '_' + tipo_precio).value=document.getElementById('ocultoprecio_pack_' + id_empresa + '_' + tipo_precio + '_' + fila_pulsada).value
		document.getElementById('ocultoid_cantidades_precios_' + id_empresa + '_' + tipo_precio).value=id_escalado
		
		
		document.getElementById('boton_annadir_escalado_' + id_empresa + '_' + tipo_precio).style.display='none'
		document.getElementById('boton_modificar_escalado_' + id_empresa + '_' + tipo_precio).style.display='block'
		document.getElementById('boton_borrar_escalado_' + id_empresa + '_' + tipo_precio).style.display='block'
		}
	
	if (modo=='ALTA')
		{
		//para que no de error, porque desseleccionar_filas, quita el color gris de la fila
		//  seleccionada de la tabla de cantidades y precios. y claro, si no hay filas, no hay controles
		//  y daria error
		//alert('entramos en alta')
		if (x=document.getElementById('fila_cantidades_precios_' + id_empresa + '_' + tipo_precio + '_0'))
			{
			desseleccionar_filas(numero_filas,tipo_precio,id_empresa)
			}
		document.getElementById('tabla_modificacion_escalado_' + id_empresa + '_' + tipo_precio).style.display='block'
		document.getElementById('txtcantidad_mantenimiento_' + id_empresa + '_' + tipo_precio).value=''
		document.getElementById('txtprecio_pack_mantenimiento_' + id_empresa + '_' + tipo_precio).value=''
		
		document.getElementById('boton_annadir_escalado_' + id_empresa + '_' + tipo_precio).style.display='block'
		document.getElementById('boton_modificar_escalado_' + id_empresa + '_' + tipo_precio).style.display='none'
		document.getElementById('boton_borrar_escalado_' + id_empresa + '_' + tipo_precio).style.display='none'
		
		}
	
		
	  	
}

function desseleccionar_filas(numero_filas,tipo_precio,id_empresa)
{
	//en el caso de ser asm, codigo empresa 4, tiene 2 precios diferentes uno para franquicias y otro para propias
	
	/*
	cadena_oficina_intermedio=''
	cadena_oficina_fin=''

	if (tipo_oficina=='OFICINA')
		{
		cadena_oficina_intermedio='oficinas_'
		cadena_oficina_fin='_oficinas'
		}
	*/

	//alert('vamos a deseleccionar las filas, que son: ' + numero_filas)
	for (i=0;i<=numero_filas;i++)
			{
			//alert('fila ' + i)
			document.getElementById('fila_cantidades_precios_' + id_empresa + '_' + tipo_precio + '_' + i).style.background=''
			document.getElementById ('fila_cantidades_precios_' + id_empresa + '_' + tipo_precio + '_' + i).style.fontWeight = 'normal'
			//var fontTest = document.getElementById ('fila_' + articulo + '_' + i)
			//fontTest.style.fontWeight = '900';
			}


}

function seleccionar_fila_precio_unidad(id_empresa,tipo_precio, fila_pulsada, numero_filas, modo, id_escalado, tipo_oficina)
{

	if (modo=='MODIFICAR')
		{
		//desseleccionar_filas(numero_filas)
		
		document.getElementById('fila_precio_unidad_' + id_empresa + '_' + tipo_precio + '_' + fila_pulsada).style.background='#E1E1E1' 
		document.getElementById ('fila_precio_unidad_' + id_empresa + '_' + tipo_precio + '_' + fila_pulsada).style.fontWeight = 'bold'
		//alert('compromiso_compra: ' + compromiso_compra)
		//document.getElementById('ocultocantidades_precios_' + articulo).value=cantidades_precio_total_articulo
		document.getElementById('tabla_modificacion_precio_unidad_' + id_empresa + '_' + tipo_precio).style.display='block'
		document.getElementById('txtprecio_unidad_mantenimiento_' + id_empresa + '_' + tipo_precio).value=document.getElementById('ocultoprecio_unidad_' + id_empresa + '_' + tipo_precio + '_' + fila_pulsada).value
		document.getElementById('ocultoid_cantidades_precios_' + id_empresa + '_' + tipo_precio).value=id_escalado
		
		
		document.getElementById('boton_annadir_escalado_' + id_empresa + '_' + tipo_precio).style.display='none'
		document.getElementById('boton_modificar_escalado_' + id_empresa + '_' + tipo_precio).style.display='block'
		document.getElementById('boton_borrar_escalado_' + id_empresa + '_' + tipo_precio).style.display='block'
		}
	
	if (modo=='ALTA')
		{
		//para que no de error, porque desseleccionar_filas, quita el color gris de la fila
		//  seleccionada de la tabla de cantidades y precios. y claro, si no hay filas, no hay controles
		//  y daria error
		//alert('entramos en alta')
		//if (x=document.getElementById('fila_cantidades_precios_0'))
		//	{
		//	desseleccionar_filas(numero_filas)
		//	}
		document.getElementById('tabla_modificacion_precio_unidad_' + id_empresa + '_' + tipo_precio).style.display='block'
		document.getElementById('txtprecio_unidad_mantenimiento_' + id_empresa + '_' + tipo_precio).value=''
		
		document.getElementById('boton_annadir_escalado_' + id_empresa + '_' + tipo_precio).style.display='block'
		document.getElementById('boton_modificar_escalado_' + id_empresa + '_' + tipo_precio).style.display='none'
		document.getElementById('boton_borrar_escalado_' + id_empresa + '_' + tipo_precio).style.display='none'
		
		}
}

function resaltar(id_empresa,tipo_precio,color,letra)
{
	document.getElementById('boton_nuevo_escalado_' + id_empresa + '_' + tipo_precio).style.background=color;
	document.getElementById('boton_nuevo_escalado_' + id_empresa + '_' + tipo_precio).style.fontWeight=letra;
}
</script>

<script type="text/javascript"> 

function guardar_escalado(id_empresa,tipo_precio,articulo,accion,compromiso_compra, tipo_oficina)
{
	//en el caso de ser asm, codigo empresa 4, tiene 2 precios diferentes uno para franquicias y otro para propias
	/*
	parametro_oficina=''
	cadena_oficina_fin=''
	
	if (tipo_oficina=='OFICINA')
		{
		parametro_oficina='OFICINA'
		cadena_oficina_fin='_oficinas'
		}
	  else
	  	{
		parametro_oficina='PROPIA'
		}
	*/
	
	
	//alert('parametro oficina: ' + parametro_oficina)

	if (compromiso_compra=='NO')
		{
		if ((document.getElementById('txtcantidad_mantenimiento_' + id_empresa + '_' + tipo_precio).value!='') && (document.getElementById('txtprecio_pack_mantenimiento_' + id_empresa + '_' + tipo_precio).value!=''))
			{
			document.getElementById('ocultoarticulo_escalado').value=articulo
			document.getElementById('ocultoaccion_escalado').value=accion
			document.getElementById('ocultoid_escalado').value=document.getElementById('ocultoid_cantidades_precios_' + id_empresa + '_' + tipo_precio).value
			document.getElementById('ocultocompromiso_compra_escalado').value=compromiso_compra
			document.getElementById('ocultocantidad_escalado').value=document.getElementById('txtcantidad_mantenimiento_' + id_empresa + '_' + tipo_precio).value
			document.getElementById('ocultoprecio_unidad_escalado').value=0
			//alert('precio pack: ' + document.getElementById('txtprecio_pack_mantenimiento').value)
			document.getElementById('ocultoprecio_pack_escalado').value=document.getElementById('txtprecio_pack_mantenimiento_' + id_empresa + '_' + tipo_precio).value
			document.getElementById('ocultotipo_oficina').value=tipo_precio
			document.getElementById('ocultoid_empresa').value=id_empresa
			
			document.getElementById('frmguardar_escalados').submit()
			}
		  else
			alert('Ha de Indicar una Cantidad y un Precio del Pack en el Escalado')
		}
	
	if (compromiso_compra=='SI')
		{
		if ((document.getElementById('txtprecio_unidad_mantenimiento_' + id_empresa + '_' + tipo_precio).value!=''))
			{
			document.getElementById('ocultoarticulo_escalado').value=articulo
			document.getElementById('ocultoaccion_escalado').value=accion
			document.getElementById('ocultoid_escalado').value=document.getElementById('ocultoid_cantidades_precios_' + id_empresa + '_' + tipo_precio).value
			document.getElementById('ocultocompromiso_compra_escalado').value=compromiso_compra
			document.getElementById('ocultocantidad_escalado').value=0
			document.getElementById('ocultoprecio_unidad_escalado').value=document.getElementById('txtprecio_unidad_mantenimiento_' + id_empresa + '_' + tipo_precio).value
			document.getElementById('ocultoprecio_pack_escalado').value=0
			document.getElementById('ocultotipo_oficina').value=tipo_precio
			document.getElementById('ocultoid_empresa').value=id_empresa

			document.getElementById('frmguardar_escalados').submit()
			}
		  else
			alert('Ha de Indicar Un Precio por Unidad Para Este Artículo')
		}
}

function comprobar_articulo()
{
	cadena_error=''
	seleccionado_barcelo=0;
	seleccionado_otro=0;
	empresas_seleccionadas=0
	for (i=0;i<document.getElementById("frmhotel").rbempresas.length;i++)
	{
		if ((document.getElementById("frmhotel").rbempresas[i].checked==1) && (document.getElementById("frmhotel").rbempresas[i].value==1))//Barceló
			seleccionado_barcelo=seleccionado_barcelo+1;
		if ((document.getElementById("frmhotel").rbempresas[i].checked==1) && (document.getElementById("frmhotel").rbempresas[i].value!=1))//Otra Empresa
			seleccionado_otro=seleccionado_otro+1;

		if (document.getElementById("frmhotel").rbempresas[i].checked==1)
		{
			empresas_seleccionadas=empresas_seleccionadas+1;
			combo_empresa='cmbfamilias_'+document.getElementById("frmhotel").rbempresas[i].value;
			if (document.getElementById(combo_empresa).value=='')
				cadena_error+= '\n\t- Ha de seleccionar una Familia de artículos para cada Empresa seleccionada...'
		}
	}
	
	if ((seleccionado_barcelo>0) && (seleccionado_otro>0))
		{
		cadena_error+= '\n\t- No se puede asociar a la vez un artículo con Barceló y cualquier otra empresa porque no pueden compartir Stock...';
		}
	if (empresas_seleccionadas==0)
		{
		cadena_error+= '\n\t- Se Ha De Seleccionar al menos una Empresa a la Que Pertenece El Artículo...';
		}
	if (document.getElementById('txtcodigo_sap').value=='')
		{
		cadena_error+= '\n\t- Se Ha De Introducir Un Código De Sap para El Artículo...';
		}
	if (document.getElementById('txtdescripcion').value=='')
		{
		cadena_error+= '\n\t- Se Ha De Introducir La Descripción Del Artículo...';
		}
	if (document.getElementById('cmbcompromiso_de_compra').value=='')
		{
		cadena_error+= '\n\t- Se Ha de Seleccionar si el Articulo Tiene Compromiso de Compra o No...';
		}
	if (document.getElementById('cmbmostrar').value=='')
		{
		cadena_error+= '\n\t- Se Ha de Seleccionar si el Articulo se Muestra o No...';
		}
	
	if (cadena_error!='')
		{
			alert('Se Han Detectado los Siguientes Errores:\n' + cadena_error);
			return false;
		}
	  else
	  	{
			if (('<%=campo_compromiso_compra%>'!='')&&(document.getElementById("cmbcompromiso_de_compra").value!='<%=campo_compromiso_compra%>'))
			{
				if (confirm('Al cambiar el COMPROMISO DE COMPRA se eliminarán los precios del artículo que haya establecido hasta ahora... Desea Continuar?'))
				{
					document.getElementById("oculto_cambio_compromiso_compra").value='S';
					return true;
				}
				else			
					return false;
			}
			else			
			{
				document.getElementById("oculto_cambio_compromiso_compra").value='N';
				return true;
			}
		}
	
}
</script> 

<script type="text/javascript"> 
function refrescar_pagina()
{
	//alert(document.getElementById("cmbempresas").value)
	Actualizar_Combos('Obtener_Stocks_Marcas.asp',document.getElementById("cmbempresas").value, '<%=articulo_seleccionado%>','capa_marcas_stocks')
	
}

//No puede seleccionarse a la vez Barceló con cualquier otra empresa, porque Barceló tiene 3 marcas y no puede compartir stock.
function comprobar_empresas(empresa)
{
	seleccionado_barcelo=0;
	seleccionado_otro=0;
	seleccionado_ASM=0;
	for (i=0;i<document.getElementById("frmhotel").rbempresas.length;i++)
	{
		if ((document.getElementById("frmhotel").rbempresas[i].checked==1) && (document.getElementById("frmhotel").rbempresas[i].value==1))//Barceló
			seleccionado_barcelo=seleccionado_barcelo+1;
		if ((document.getElementById("frmhotel").rbempresas[i].checked==1) && (document.getElementById("frmhotel").rbempresas[i].value!=1))//Otra Empresa
			seleccionado_otro=seleccionado_otro+1;
		
		//Para mostrar o no el combo Familia
		if ((document.getElementById("frmhotel").rbempresas[i].checked==1) && (document.getElementById("frmhotel").rbempresas[i].value==empresa))
		{
			document.getElementById('capa_familias_1_'+empresa).style.display='block';
			document.getElementById('capa_familias_2_'+empresa).style.display='block';
		}
		if ((document.getElementById("frmhotel").rbempresas[i].checked==0) && (document.getElementById("frmhotel").rbempresas[i].value==empresa))
		{
			document.getElementById('capa_familias_1_'+empresa).style.display='none';
			document.getElementById('capa_familias_2_'+empresa).style.display='none';
		}
	}
	if ((seleccionado_barcelo>0) && (seleccionado_otro>0))
		alert('No se puede asociar un artículo con Barceló y cualquier otra empresa porque no pueden compartir Stock...');
	else
	{
		//Mostramos las distintas capas de Stock según las empresas selecionadas
		if ((('<%=empresas_barcelo%>'>0) && (seleccionado_otro>0)) || (('<%=empresas_otras%>'>0) && (seleccionado_barcelo>0)))
		{
			document.getElementById("capa_marcas_stocks").style.display='none';
			document.getElementById("capa_marcas_stocks_otra").style.display='block';
		}
		if ((('<%=empresas_barcelo%>'==0) && (seleccionado_otro>0)) || (('<%=empresas_otras%>'==0) && (seleccionado_barcelo>0)))
		{
			document.getElementById("capa_marcas_stocks_otra").style.display='none';
			document.getElementById("capa_marcas_stocks").style.display='block';
		}
		if (('<%=articulo_seleccionado%>'=='')||('<%=articulo_seleccionado%>'=='0')) //Artículo nuevo
		{
			if (seleccionado_otro>0)
			{
				document.getElementById("capa_marcas_stocks_otra").style.display='none'; //Cuando es un artículo nuevo este es el de Barcelo
				document.getElementById("capa_marcas_stocks").style.display='block'; //Cuando es un artículo nuevo este es el de Otros
			}
			if (seleccionado_barcelo>0)
			{
				document.getElementById("capa_marcas_stocks").style.display='none'; //Cuando es un artículo nuevo este es el de Otros
				document.getElementById("capa_marcas_stocks_otra").style.display='block'; //Cuando es un artículo nuevo este es el de Barcelo
			}
		}
		//Esto es para cambiar la imagen del artículo
		if (('<%=articulo_seleccionado%>'!='')&&('<%=articulo_seleccionado%>'!='0'))
		{
			if ((seleccionado_otro==0) && (seleccionado_barcelo>0))
			{
				id_articulo='<%=articulo_seleccionado%>';
				document.getElementById("imagen_articulo").src='Imagenes_Articulos/Barcelo/Miniaturas/i_'+id_articulo+'.jpg';
				document.getElementById("imagen_enlace").href='Imagenes_Articulos/Barcelo/'+id_articulo+'.jpg';
				document.getElementById("txtmarca").value='BARCELÓ';
			}
			if ((seleccionado_otro>0) && (seleccionado_barcelo==0))
			{
				id_articulo='<%=articulo_seleccionado%>';
				document.getElementById("imagen_articulo").src='Imagenes_Articulos/Miniaturas/i_'+id_articulo+'.jpg';
				document.getElementById("imagen_enlace").href='Imagenes_Articulos/'+id_articulo+'.jpg';
				document.getElementById("txtmarca").value='STANDARD';
			}
		}
	}
	
	//Esto es para ocultar la parte de Cantidades/Precios si se cambian las empresas seleccionadas...
	// Lo hacemos para poder gestionar bien los Precios de cada Tipo de Precios según la empresa, ya que si lo hacemos dinámico 
	// tendríamos que ir cambiando los tipos de precios según la empresa seleccionada...
	if ('<%=accion_seleccionada%>'=='MODIFICAR')
	{
		document.getElementById("capa_modificar_precios_1").style.display='none';
		document.getElementById("capa_modificar_precios_2").style.display='none';
		document.getElementById("capa_modificar_precios_3").style.display='none';
		document.getElementById("capa_no_modificar_precios_1").style.display='block';
		document.getElementById("capa_no_modificar_precios_2").style.display='block';
		document.getElementById("capa_no_modificar_precios_3").style.display='block';
	}
}

function comprobar_eliminado()
{
	if ((document.getElementById("cmbeliminado").value=='SI')&&(document.getElementById("cmbmostrar").value=='SI'))
	{
		alert('Al eliminar un artículo pasará automáticamente a NO MOSTRAR');
		document.getElementById("cmbmostrar").value='NO';
	}
}
function comprobar_eliminado_mostrar()
{
	if ((document.getElementById("cmbeliminado").value=='SI')&&(document.getElementById("cmbmostrar").value=='SI'))
	{
		alert('Si el artículo está eliminado no puede cambiar MOSTRAR a SI');
		document.getElementById("cmbmostrar").value='NO';
	}
}
</script> 
<script language="javascript" src="Funciones_Ajax.js"></script>


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
					· <a href="Consulta_Clientes_Admin.asp">Hoteles</a><br />
					
					<br />
					
					<br /> 
					
					<br />
					
					<br />
					<br />
					
					
				</div>
				</div>
			</div>
		</div>
		
		
		
		
		
	</td>
	<td width="713">
		<div id="main">
				
			<form name="frmhotel" id="frmhotel" method="post" onsubmit=" return comprobar_articulo()" action="Guardar_Articulos_Admin.asp">
						<input type="hidden" name="ocultoarticulo" id="ocultoarticulo" value="<%=articulo_seleccionado%>" />
						<input type="hidden" name="ocultoaccion" id="ocultoaccion" value="<%=accion_seleccionada%>" />
						<input type="hidden" name="oculto_cambio_compromiso_compra" id="oculto_cambio_compromiso_compra" value="N" />
		
				<div class="comment_title fontbold">Datos del Art&iacute;culo </div>
				<div class="comment_text"> 
					
							
					<table width="95%" cellspacing="6" cellpadding="0" class="logintable" align="center">
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Datos Generales</span>
							</td>
						</tr>
						
						<tr>
							<td width="50%" class="dottedBorder vt al">
								
			  
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Codigo Sap: </td>
									<td width="63%"><input class="txtfield" size="15" name="txtcodigo_sap" id="txtcodigo_sap" value="<%=campo_codigo_sap%>"/></td>
									<td width="24%">
										
										
									</td>
								</tr>							
												
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Descripción: </td>
									<td width="83%" >
                                      <input class="txtfield" size="95" name="txtdescripcion" id="txtdescripcion" value="<%=campo_descripcion%>"/>
									</td>
									<td width="4%"></td>
								</tr>							
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Tamaño: </td>
									<td width="83%" >
                                      <input class="txtfield" size="40" name="txttamanno" id="txttamanno" value="<%=campo_tamanno%>"/>
									</td>
									<td width="4%"></td>
								</tr>							
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="16%">Tamaño Abierto: </td>
									<td width="35%" >
                                      <input class="txtfield" size="30" name="txttamanno_abierto" id="txttamanno_abierto" value="<%=campo_tamanno_abierto%>"/>
									</td>
									<td width="17%">Tamaño Cerrado: </td>
									<td width="32%" >
                                      <input class="txtfield" size="30" name="txttamanno_cerrado" id="txttamanno_cerrado" value="<%=campo_tamanno_cerrado%>"/>
									</td>
								</tr>							
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							  	</table>
								
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Papel: </td>
									<td width="83%" >
                                      <input class="txtfield" size="95" name="txtpapel" id="txtpapel" value="<%=campo_papel%>"/>
									</td>
									<td width="4%"></td>
								</tr>							
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Tintas: </td>
									<td width="83%" >
                                      <input class="txtfield" size="95" name="txttintas" id="txttintas" value="<%=campo_tintas%>"/>
									</td>
									<td width="4%"></td>
								</tr>							
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Acabado: </td>
									<td width="83%" >
                                      <input class="txtfield" size="95" name="txtacabado" id="txtacabado" value="<%=campo_acabado%>"/>
									</td>
									<td width="4%"></td>
								</tr>							
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="20%">Unidades de Pedido: </td>
									<td width="76%" >
                                      <input class="txtfield" size="50" name="txtunidades_pedido" id="txtunidades_pedido" value="<%=campo_unidades_pedido%>"/>
									</td>
									<td width="4%"></td>
								</tr>							
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="20%">Packing: </td>
									<td width="76%" >
                                      <input class="txtfield" size="65" maxlength="100" name="txtpacking" id="txtpacking" value="<%=campo_packing%>"/>
									</td>
									<td width="4%"></td>
								</tr>							
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="5"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="13%">Fecha: </td>
									<td width="23%" >
                                      <input class="txtfield" size="15" name="txtfecha" id="txtfecha" value="<%=campo_fecha%>"/>
									</td>
									<td width="24%">Compromiso de Compra: </td>
									<td width="40%">
                                      <select  name="cmbcompromiso_de_compra" id="cmbcompromiso_de_compra">
                                        <option value="" selected>* Seleccione *</option>
										<option value="SI">SI</option>
										<option value="NO">NO</option>
                                        
                                      </select>                                   	  
                                      <script language="javascript">
											document.getElementById("cmbcompromiso_de_compra").value='<%=campo_compromiso_compra%>'
										</script>
								  </td>
								  </tr>							
								</table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="3"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
                                  <tr>
                                    <td width="13%">Mostrar: </td>
                                    <td width="23%"><select  name="cmbmostrar" id="cmbmostrar" onchange="comprobar_eliminado_mostrar()">
                                        <option value="" selected="selected">* Seleccione *</option>
                                        <option value="SI">SI</option>
                                        <option value="NO">NO</option>
                                      </select>
                                        <script language="JavaScript" type="text/javascript">
											document.getElementById("cmbmostrar").value='<%=campo_mostrar%>'
										</script>
                                    </td>
                                    <td width="11%">Facturable:</td>
                                    <td width="11%"><select  name="cmbfacturable" id="cmbfacturable">
                                        <option value="SI" selected>SI</option>
                                        <option value="NO">NO</option>
                                      </select>
                                        <script language="JavaScript" type="text/javascript">
											if ('<%=campo_facturable%>'!='')
												{
												document.getElementById("cmbfacturable").value='<%=campo_facturable%>';
												}
										</script>
                                    </td>
									<td width="11%">Eliminado:</td>
                                    <td width="42%"><select  name="cmbeliminado" id="cmbeliminado" onchange="comprobar_eliminado()">
                                        <option value="SI" style="background-color:#FFCC00;">SI</div></option>
                                        <option value="NO" selected>NO</option>
                                      </select>
                                        <script language="JavaScript" type="text/javascript">
										if (('<%=articulo_seleccionado%>'!='')&&('<%=articulo_seleccionado%>'!='0'))
											document.getElementById("cmbeliminado").value='<%=campo_eliminado%>';
										</script>
                                    </td>
                                  </tr>
                                </table>
								<table width="306" cellpadding="0" cellspacing="0">
									<tr><td height="3"></td></tr>
							  	</table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
                                  <tr>
                                    <td width="21%">Requiere Autorización: </td>
                                    <td width="79%"><select  name="cmbautorizacion" id="cmbautorizacion">
                                        <option value="NO" selected>NO</option>
										<option value="SI">SI</option>
                                        
                                      </select>
                                        <script language="JavaScript" type="text/javascript">
											document.getElementById("cmbautorizacion").value='<%=campo_autorizacion%>'
										</script>
                                    </td>
                                    
                                  </tr>
                                </table>
								
								<table width="306" cellpadding="0" cellspacing="0">
                                  <tr>
                                    <td height="3"></td>
                                  </tr>
                                </table>
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="8%">&nbsp;</td>
								  </tr>
								</table>	
								
								
								
						  </td>
						</tr>
						
						<tr><td class="al">&nbsp;</td></tr>
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Empresas asociadas al Art&iacute;culo</span>
							</td>
						</tr>
						<tr>
							<td width="50%" class="dottedBorder vt al">
							  <table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="90%">
                                        <%if vacio_empresas=false then %>
                                        <%for i=0 to UBound(mitabla_empresas,2)%>
										<table width="337" border="0" cellspacing="0" cellpadding="0">
										  <%if i=0 then
										  	 estilo="style='border-top:1px solid #CCCCCC;border-bottom:1px solid #CCCCCC;border-right:1px solid #CCCCCC;border-left:1px solid #CCCCCC;'"
											else
										  	 estilo="style='border-bottom:1px solid #CCCCCC;border-right:1px solid #CCCCCC;border-left:1px solid #CCCCCC;'"
											end if%>
										  <tr <%=estilo%>>
											<td width="26" height="24">
										      <div align="right">
										        <input name="rbempresas" id="rbempresas" type="checkbox" value="<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>" onclick="comprobar_empresas('<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>')"/>
							                </div></td>
											<td width="129">&nbsp;<%=mitabla_empresas(CAMPO_EMPRESA_EMPRESA,i)%></td>
										    <td width="51">
											<%'if mitabla_empresas(CAMPO_ID_EMPRESA,i)=4 then%>
											<div id="capa_familias_1_<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>" style="display:none ">Familia:</div>
											<%'end if%>
											</td>
										    <td width="131">
											<div id="capa_familias_2_<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>" style="display:none ">
                                                    <select  name="cmbfamilias_<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>" id="cmbfamilias_<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>">
												<%filtro = "codigo_empresa=" & mitabla_empresas(CAMPO_ID_EMPRESA,i)
												  familias.Filter = filtro %>
												    <%if familias.RecordCount>1 then%>
												    <option value="" selected>* Seleccione *</option>
													<%end if%>
														<%while not familias.eof%>
																<option value="<%=cint(familias("ID"))%>"><%=familias("DESCRIPCION")%></option>
														<%familias.movenext
														  wend%>
                                                </select>
                                            </div>
											</td>
										  </tr>
										</table>
                                        <%next%>
                                        <%end if%>
									  	
										<%set articulos_empresas=Server.CreateObject("ADODB.Recordset")
				
										  with articulos_empresas
											.ActiveConnection=connimprenta
											.Source="SELECT ID_ARTICULO, CODIGO_EMPRESA, FAMILIA FROM ARTICULOS_EMPRESAS WHERE ID_ARTICULO=" & articulo_seleccionado & " ORDER BY CODIGO_EMPRESA"
											.Open
										  end with
										  while not articulos_empresas.eof%>
										  
                                      	<script language="javascript">

										 for (i = 0; i < document.getElementById("frmhotel").rbempresas.length; i++)
										 {
  											if (document.getElementById("frmhotel").rbempresas[i].value=='<%=articulos_empresas("CODIGO_EMPRESA")%>')
												document.getElementById("frmhotel").rbempresas[i].checked=1;
											document.getElementById('capa_familias_1_<%=articulos_empresas("CODIGO_EMPRESA")%>').style.display='block';
											document.getElementById('capa_familias_2_<%=articulos_empresas("CODIGO_EMPRESA")%>').style.display='block';
											document.getElementById('cmbfamilias_<%=articulos_empresas("CODIGO_EMPRESA")%>').value='<%=articulos_empresas("FAMILIA")%>'
										 }
										</script>
										  <%articulos_empresas.movenext
										  wend
										  articulos_empresas.close
										  set articulos_empresas=Nothing%>
									</td>
								</tr>							
												
							</table>
						  </td>
						</tr>
						<tr><td class="al">&nbsp;</td></tr>
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Stocks del Artículo</span>
							</td>
						</tr>
						<tr>
							<td width="50%" class="dottedBorder vt al">
								<div id="capa_marcas_stocks" style="display:none">
								<%if vacio_stocks_articulo=false then %>
									<%for i=0 to UBound(mitabla_stocks_articulo,2)%>
										<table cellpadding="2" cellspacing="1" border="0" width="100%">
											<tr>
												<td width="25%">Stock Marca <%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>: </td>
												<td width="21%" >
												  <input class="txtfield" size="15" name="txtstock_<%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" id="txtstock_<%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" value="<%=mitabla_stocks_articulo(CAMPO_STOCK_ARTICULOS_MARCAS,i)%>"/>
												</td>
												<td width="34%">Stock Mínimo Marca <%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>: </td>
												<td width="20%" >
												  <input class="txtfield" size="15" name="txtstock_minimo_<%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" id="txtstock_minimo_<%=mitabla_stocks_articulo(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" value="<%=mitabla_stocks_articulo(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,i)%>"/>
												</td>
											</tr>							
										</table>
										<table width="306" cellpadding="0" cellspacing="0">
											<tr><td height="5"></td></tr>
										</table>
									<%next%>
								<%end if%>
								</div>
								<div id="capa_marcas_stocks_otra" style="display:none">
									<%for i=0 to UBound(mitabla_stocks_articulo_otra,2)%>
										<table cellpadding="2" cellspacing="1" border="0" width="100%">
											<tr>
												<td width="25%">Stock Marca <%=mitabla_stocks_articulo_otra(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>: </td>
												<td width="21%" >
												  <input class="txtfield" size="15" name="txtstock_<%=mitabla_stocks_articulo_otra(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" id="txtstock_<%=mitabla_stocks_articulo_otra(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" value="<%=mitabla_stocks_articulo_otra(CAMPO_STOCK_ARTICULOS_MARCAS,i)%>"/>
												</td>
												<td width="34%">Stock Mínimo Marca <%=mitabla_stocks_articulo_otra(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>: </td>
												<td width="20%" >
												  <input class="txtfield" size="15" name="txtstock_minimo_<%=mitabla_stocks_articulo_otra(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" id="txtstock_minimo_<%=mitabla_stocks_articulo_otra(CAMPO_MARCA_ARTICULOS_MARCAS,i)%>" value="<%=mitabla_stocks_articulo_otra(CAMPO_STOCK_MINIMO_ARTICULOS_MARCAS,i)%>"/>
												</td>
											</tr>							
										</table>
										<table width="306" cellpadding="0" cellspacing="0">
											<tr><td height="5"></td></tr>
										</table>
									<%next%>
								</div>
								<script language="javascript">
									if (('<%=articulo_seleccionado%>'!='')&&('<%=articulo_seleccionado%>'!='0'))
										document.getElementById("capa_marcas_stocks").style.display="block";
								</script>
						  </td>
						</tr>
						
						<tr><td class="al">&nbsp;</td></tr>
						<tr>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Imagen del Artículo <font style="color:#FF0000 "></font></span>
							</td>
						</tr>
			
						<tr>
							<td width="50%" class="dottedBorder vt al">
								
			  
								
								<table cellpadding="2" cellspacing="1" border="0" width="100%">
								<tr>
									<td width="45%" style="text-align:center ">
										<%if articulo_seleccionado&""<>"" and articulo_seleccionado&""<>"0" then%>
											<%if empresas_barcelo>0 then
												carpeta_marca="BARCELO/"
												marca="BARCELÓ"
											  else
											  	carpeta_marca=""
												marca="STANDARD"
											  end if
											%>
											<input id="txtmarca" name="txtmarca" type="text" class='fontbold' style="background-color:#F9F9F9; border:0px solid #ffffff; color:#666666; text-align:center" value="<%=marca%>" size="8" readonly>
											<br />
											<a href="Imagenes_Articulos/<%=carpeta_marca%><%=articulo_seleccionado%>.jpg" target="_blank" id="imagen_enlace">
												<img class="product_thumbnail" src="Imagenes_Articulos/<%=carpeta_marca%>Miniaturas/i_<%=articulo_seleccionado%>.jpg" border="0" id="imagen_articulo"></a>
											<br />
										<%end if%>
									</td>
								</tr>			
								</table>
						  </td>
						</tr>
						
						<%if accion_seleccionada="MODIFICAR" then%>
						<tr id="capa_modificar_precios_1"><td class="al">&nbsp;</td></tr>
						<tr	id="capa_modificar_precios_2">
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
							  <span class='fontbold'>Cantidades y Precios <%if campo_compromiso_compra="NO" then%>(Escalado)<%end if%> <font style="color:#FF0000 "></font></span>
							</td>
						</tr>
						<tr	id="capa_modificar_precios_3">
							<!--6.08 - Translate titles and buttons-->
							<td class="dottedBorder vt al">
						<table width="100%" cellspacing="0" cellpadding="0" align="center">
						<%contador=0
						  while not tipos_precios.eof
						  
							contador=contador+1
							
							set cantidades_precios=Server.CreateObject("ADODB.Recordset")
				
							sql="SELECT CANTIDADES_PRECIOS.Id, CANTIDADES_PRECIOS.CODIGO_ARTICULO, CANTIDADES_PRECIOS.CANTIDAD,"
							sql=sql & " CANTIDADES_PRECIOS.PRECIO_UNIDAD, CANTIDADES_PRECIOS.PRECIO_PACK, CODIGO_EMPRESA "
							sql=sql & " FROM CANTIDADES_PRECIOS WHERE CODIGO_ARTICULO=" & articulo_seleccionado
							sql=sql & " AND TIPO_SUCURSAL='" & tipos_precios("tipo_precio") & "' "
							sql=sql & " AND CODIGO_EMPRESA='" & tipos_precios("ID") & "' "
							sql=sql & " ORDER BY CANTIDAD"
				
							'response.write("<br>" & sql)
							CAMPO_ID_CANTIDADES_PRECIOS=0
							CAMPO_CODIGO_ARTICULO_CANTIDADES_PRECIOS=1
							CAMPO_CANTIDAD_CANTIDADES_PRECIOS=2
							CAMPO_PRECIO_UNIDAD_CANTIDADES_PRECIOS=3
							CAMPO_PRECIO_PACK_CANTIDADES_PRECIOS=4
							
							with cantidades_precios
								.ActiveConnection=connimprenta
								.CursorType=3 'adOpenStatic
								.Source=sql
								.Open
								vacio_cantidades_precios=false
								if not .BOF then
									mitabla_cantidades_precios=.GetRows()
								  else
									vacio_cantidades_precios=true
								end if
							end with
								 
							cantidades_precios.close
							set cantidades_precios=Nothing
						%>
						<%if empresa_anterior<>tipos_precios("empresa") then%>
						<%if contador<>1 then%>
						<tr	>
							<td>&nbsp;</td>
						</tr>
						<%end if%>
						<tr	>
							<!--6.08 - Translate titles and buttons-->
							<td valign="bottom" class="al" style="border-bottom:1px solid #999999">
								<span class='fontbold'><%=tipos_precios("empresa")%><font style="color:#FF0000 "></font></span>
						  </td>
						</tr>
						<%end if%>
						<%empresa_anterior=tipos_precios("empresa")%>
						<tr>
						  <td >
						  <div style="height:10px "></div>
						  <div style="padding-left:17px;">Tipo Precio: <%=tipos_precios("tipo_precio")%><font style="color:#FF0000 "></font></div>
							<table width="95%" align="center">
								<tr>
									<td width="50%" class="dottedBorder vt al">
										
										
											<%if campo_compromiso_compra="NO" then%>
												<table width="100%"  border="0" cellspacing="0" cellpadding="0">
												  <tr>
													<td width="33%" valign="top">
														<table width="90%" cellpadding="0" cellspacing="0" border="0" style="border:2px solid">
															<tr>
																<td style="border-bottom:1pt solid">Cantidad</td>
																<td style="border-left:1pt solid;border-bottom:1pt solid">Precio Pack</td>
															</tr>
															<%if vacio_cantidades_precios=false then %>
															<%for i=0 to UBound(mitabla_cantidades_precios,2)%>
															
																<tr id="fila_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>',<%=i%>,<%=UBound(mitabla_cantidades_precios,2)%>,'MODIFICAR', <%=mitabla_cantidades_precios(CAMPO_ID_CANTIDADES_PRECIOS,i)%>, '')">
																	<td style="border-bottom:1pt solid" align="right">
																		
																		<input type="hidden" name="ocultocantidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" id="ocultocantidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" value="<%=mitabla_cantidades_precios(CAMPO_CANTIDAD_CANTIDADES_PRECIOS,i)%>" />
																		<%=mitabla_cantidades_precios(CAMPO_CANTIDAD_CANTIDADES_PRECIOS,i)%>&nbsp;
																	</td>
																	<td style="border-left:1pt solid;border-bottom:1pt solid" align="right">
																		<%
																			precio_pack=""
																			IF mitabla_cantidades_precios(CAMPO_PRECIO_PACK_CANTIDADES_PRECIOS,i)<>"" then
																				'saco 2 decimales sin separacion de miles porque da error al hacer cuentas...
																				precio_pack=FORMATNUMBER(mitabla_cantidades_precios(CAMPO_PRECIO_PACK_CANTIDADES_PRECIOS,i),2,,,0)
																			end if
																			Response.Write(precio_pack)
																			if precio_pack<>"" then
																				Response.Write(" €")
																			end if
								
																		%>
																		&nbsp;
																		<input type="hidden" name="ocultoprecio_pack_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" id="ocultoprecio_pack_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" value="<%=precio_pack%>" />
																		
																	</td>
																</tr>
															<%next%>
															<%end if%>
														</table>
													
													
													</td>
													<td width="67%" valign="top">
													
														<table width="37%" cellpadding="0" cellspacing="0" border="0" style="border:2px solid;cursor:hand;cursor:pointer">
															<%
																if vacio_cantidades_precios=false then
																	filas_a_desseleccionar=UBound(mitabla_cantidades_precios,2)
																  else
																	filas_a_desseleccionar=0
																end if
															%>
															<tr id="boton_nuevo_escalado_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" onclick="seleccionar_fila('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>',0,<%=filas_a_desseleccionar%>,'ALTA', '', '')" onmouseover="resaltar('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>','#E1E1E1','bold')" onmouseout="resaltar('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>','','normal')">
																<td style="border-bottom:1pt solid" align="center">Añadir Nuevo Escalado</td>
																
															</tr>
													  </table>
														<br />
														
														<table width="95%" height="48" border="0" cellpadding="0" cellspacing="0" id="tabla_modificacion_escalado_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" style="border:2px solid;display:none">
														  <tr>
															<td width="25%" height="16" style="border-bottom:1pt solid">Cantidad</td>
															<td width="25%" style="border-left:1pt solid;border-bottom:1pt solid">Precio Pack</td>
															<td width="50%" style="border-left:1pt solid;border-bottom:1pt solid">Acciones</td>
														  </tr>
														  <tr>
															<td style="border-bottom:1pt solid" align="right"><input class="txtfield" size="8" name="txtcantidad_mantenimiento_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" id="txtcantidad_mantenimiento_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" value=""/>
														&nbsp; </td>
															<td style="border-left:1pt solid;border-bottom:1pt solid" align="right"><input class="txtfield" size="8" name="txtprecio_pack_mantenimiento_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" id="txtprecio_pack_mantenimiento_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" value=""/>
														&nbsp; </td>
															<td style="border-left:1pt solid;border-bottom:1pt solid" align="right"><table width="96%"  border="0" cellspacing="0" cellpadding="0">
																<tr>
																  <td width="27%"  id="boton_annadir_escalado_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>">
																	<table width="58" height="22" border="0" cellpadding="0" cellspacing="0" style="border:1px solid">
																		  <tr>
																			<td width="19%" align="center"><img src="images/annadir.png" border="0" height="16" width="16" /></td>
																			<td width="81%"><a href="#" onclick="guardar_escalado('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>',<%=articulo_seleccionado%>, 'ALTA', '<%=campo_compromiso_compra%>');return false" class="fontbold">&nbsp;Añadir&nbsp;</a></td>
																		  </tr>
																	</table>
																  </td>
																  <td width="35%" id="boton_modificar_escalado_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>">
																	<input type="hidden" name="ocultoid_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" id="ocultoid_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" value="" />
																	<table  width="77" height="22" border="0" cellpadding="0" cellspacing="0" style="border:1px solid">
																		<tr>
																		  <td width="19%" align="center"><img src="images/icono_modificar.png" border="0" height="16" width="16" /></td>
																			<td width="81%"><a href="#" onclick="guardar_escalado('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>',<%=articulo_seleccionado%>, 'MODIFICAR', '<%=campo_compromiso_compra%>');return false" class="fontbold">&nbsp;Modificar&nbsp;</a></td>
																	  </tr>
																	</table>
																  </td>
																  <td width="38%"  id="boton_borrar_escalado_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>">
																	<table width="60" height="22" border="0" cellpadding="0" cellspacing="0" style="border:1px solid">
																		<tr>
																		  <td width="19%" align="center"><img src="images/eliminar.png" border="0" height="16" width="16" /></td>
																			<td width="81%"><a href="#" onclick="guardar_escalado('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>',<%=articulo_seleccionado%>, 'BORRAR', '<%=campo_compromiso_compra%>');return false;" class="fontbold">&nbsp;Borrar&nbsp;</a></td>
																	  </tr>
																	</table>
																  </td>
																</tr>
															</table></td>
														  </tr>
														</table></td>
												  </tr>
												</table>
											<%end if%>
											
											<%if campo_compromiso_compra="SI" then%>
												<table width="100%"  border="0" cellspacing="0" cellpadding="0">
												  <tr>
													<td width="33%" valign="top">
														<table width="74%" cellpadding="0" cellspacing="0" border="0" style="border:2px solid">
															<tr>
																
																<td style="border-left:1pt solid;border-bottom:1pt solid">Precio Unid.</td>
															</tr>
															<%if vacio_cantidades_precios=false then %>
															<%for i=0 to UBound(mitabla_cantidades_precios,2)%>
																<tr id="fila_precio_unidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila_precio_unidad('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>',<%=i%>,<%=UBound(mitabla_cantidades_precios,2)%>,'MODIFICAR', <%=mitabla_cantidades_precios(CAMPO_ID_CANTIDADES_PRECIOS,i)%>)">
																  
																	<td style="border-left:1pt solid;border-bottom:1pt solid" align="right">
																		<%
																			IF mitabla_cantidades_precios(CAMPO_PRECIO_UNIDAD_CANTIDADES_PRECIOS,i)<>"" then
																				Response.Write(mitabla_cantidades_precios(CAMPO_PRECIO_UNIDAD_CANTIDADES_PRECIOS,i) & " €/u")
																			  else
																				Response.Write("")
																			end if
																		%>
																		&nbsp;
																		<input type="hidden" name="ocultoprecio_unidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" id="ocultoprecio_unidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" value="<%=mitabla_cantidades_precios(CAMPO_PRECIO_UNIDAD_CANTIDADES_PRECIOS,i)%>" />
																	</td>
																</tr>
															<%next%>
															<%end if%>
													  </table>
													
													
													</td>
													<td width="67%" valign="top">
														<%if vacio_cantidades_precios=true then %>
														<table width="51%" cellpadding="0" cellspacing="0" border="0" style="border:2px solid;cursor:hand;cursor:pointer">
															
															<tr id="boton_nuevo_escalado_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" onclick="seleccionar_fila_precio_unidad('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>',0,0,'ALTA')" onmouseover="resaltar('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>','#E1E1E1','bold')" onmouseout="resaltar('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>','','normal')">
																<td style="border-bottom:1pt solid" align="center">Añadir Nuevo Precio por Unidad</td>
																
															</tr>
														</table>
														<%end if%>
														<br />
														<table width="95%" height="48" border="0" cellpadding="0" cellspacing="0" id="tabla_modificacion_precio_unidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" name="tabla_modificacion_precio_unidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" style="border:2px solid;display:none;">
														  <tr>
															<td width="19%" style="border-left:1pt solid;border-bottom:1pt solid">Precio Unidad</td>
															<td width="60%" style="border-left:1pt solid;border-bottom:1pt solid">Acciones</td>
														  </tr>
														  <tr>
															
															<td style="border-left:1pt solid;border-bottom:1pt solid" align="right"><input class="txtfield" size="8" name="txtprecio_unidad_mantenimiento_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" id="txtprecio_unidad_mantenimiento_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" value=""/>
														&nbsp; </td>
															<td style="border-left:1pt solid;border-bottom:1pt solid" align="right"><table width="96%"  border="0" cellspacing="0" cellpadding="0">
																<tr>
																  <td width="27%"  id="boton_annadir_escalado_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>">
																	<table width="58" height="22" border="0" cellpadding="0" cellspacing="0" style="border:1px solid">
																		  <tr>
																			<td width="19%" align="center"><img src="images/annadir.png" border="0" height="16" width="16" /></td>
																			<td width="81%"><a href="#" onclick="guardar_escalado('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>',<%=articulo_seleccionado%>, 'ALTA', '<%=campo_compromiso_compra%>');return false" class="fontbold">&nbsp;Añadir&nbsp;</a></td>
																		  </tr>
																	</table>
																  </td>
																  <td width="35%" id="boton_modificar_escalado_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>">
																	<input type="hidden" name="ocultoid_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" id="ocultoid_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>" value="" />
																	<table  width="77" height="22" border="0" cellpadding="0" cellspacing="0" style="border:1px solid">
																		<tr>
																		  <td width="19%" align="center"><img src="images/icono_modificar.png" border="0" height="16" width="16" /></td>
																			<td width="81%"><a href="#" onclick="guardar_escalado('<%=tipos_precios("id")%>','<%=tipos_precios("tipo_precio")%>',<%=articulo_seleccionado%>, 'MODIFICAR', '<%=campo_compromiso_compra%>');return false" class="fontbold">&nbsp;Modificar&nbsp;</a></td>
																	  </tr>
																	</table>
																  </td>
																  <td width="38%"  id="boton_borrar_escalado_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>">
																	
																  </td>
																</tr>
															</table></td>
														  </tr>
														</table></td>
												  </tr>
												</table>
											<%end if%>
										
								  </td>
								</tr>
								<tr><td class="al" height="3"></td></tr>
							</table>
					      </td>
						  </tr>
						    <%tipos_precios.movenext
						    wend
						    tipos_precios.close
						    set tipos_precios=Nothing%>
						</table>
						  </td>
						</tr>
						<tr id="capa_no_modificar_precios_1" style="display:none"><td class="al">&nbsp;</td></tr>
						<tr id="capa_no_modificar_precios_2" style="display:none"	>
							<!--6.08 - Translate titles and buttons-->
							<td class="al">
								<span class='fontbold'>Cantidades y Precios </span>
							</td>
						</tr>
						<tr id="capa_no_modificar_precios_3" style="display:none">
							<td width="50%" class="dottedBorder vt al">
									<strong>Para poder aplicar PRECIOS guarde antes la ficha del artículo y vuelva a entrar...</strong>
							</td>
						</tr>
						<%END IF 'solo se muestra el escalado si el articulo ya esta creado... es decir.. se modifica%>
				  </table>
					<br />
				</div>
		  <div class="submit_btn_container">	
					<table width="13%" border="0" cellpadding="0" cellspacing="0" align="center" class="info_column">
						<tr>
							<td>
								<div align="right">
								  <input class="submitbtn" type="submit" name="cmbguardar" id="cmbguardar" value="Guardar Articulo" />
								</div>
							</td>
						</tr>
					</table>
		  </div>
		</form>
		</div>
	</td>
</tr>
</table>

<form name="frmguardar_escalados" id="frmguardar_escalados" action="Guardar_Escalados_Admin.asp" method="post">
	<input type="hidden" value="" name="ocultoarticulo_escalado" id="ocultoarticulo_escalado" />
	<input type="hidden" value="" name="ocultoaccion_escalado" id="ocultoaccion_escalado" />
	<input type="hidden" value="" name="ocultoid_escalado" id="ocultoid_escalado" />
	<input type="hidden" value="" name="ocultocompromiso_compra_escalado" id="ocultocompromiso_compra_escalado" />
	<input type="hidden" value="" name="ocultocantidad_escalado" id="ocultocantidad_escalado" />
	<input type="hidden" value="" name="ocultoprecio_unidad_escalado" id="ocultoprecio_unidad_escalado" />
	<input type="hidden" value="" name="ocultoprecio_pack_escalado" id="ocultoprecio_pack_escalado" />
	<input type="hidden" value="" name="ocultotipo_oficina" id="ocultotipo_oficina" />
	<input type="hidden" value="" name="ocultoid_empresa" id="ocultoid_empresa" />
</form>

</body>
<%
	familias.close
	set familias=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>
</html>
