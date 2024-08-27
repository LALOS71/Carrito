<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<%
		Response.Buffer = TRUE
		if session("usuario")="" then
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
		end if
		
		'recordsets
		dim articulos
		
		
		
		codigo_sap_buscado=Request.Form("txtcodigo_sap")
		articulo_buscado=Request.form("txtdescripcion")
		familia_buscada=Request.form("cmbfamilias")
		campo_autorizacion=Request.form("cmbautorizacion")
		descripcion_impresora_buscada=Request.form("txtdescripcion_impresora")
		agrupacion_familia_buscada="" & Request.form("ocultoagrupacion_familias")
		'accion=Request.QueryString("acciones")
		pto_articulo=Request.form("ocultopto_articulo")
		
		'response.write("<br>agrupacion: " & agrupacion_familia_buscada) 
		'response.write("<br>familia buscadan: " & agrupacion_familia_buscada) 
		
		realizar_consulta="SI"
		if familia_buscada="" and articulo_buscado="" and codigo_sap_buscado="" and agrupacion_familia_buscada="" and campo_autorizacion="" then
			familia_buscada="TODOS"
			'realizar_consulta="NO"
			'si no se filtra por nada, que muestre los articulos que no requieren autorizacion
			campo_autorizacion="NO"
		end if
		'if familia_buscada="" and articulo_buscado="" and codigo_sap_buscado="" then
		'	familia_buscada="TODOS"
		'end if
		
		
		
		'aqui viene la accion junto con el pedido y la fecha "MODIFICAR--88--fecha--codigo cliente--codigo externo cliente--nombre cliente"
		acciones=Request.QueryString("acciones")
		'response.write("<br>acciones: " & acciones)
		if acciones<>"" then
			tabla_acciones=Split(acciones,"--")
			accion=tabla_acciones(0)
			pedido_modificar=tabla_acciones(1)
			fecha_pedido=tabla_acciones(2)
			hotel_admin=tabla_acciones(3)
			codigo_externo_modificacion=tabla_acciones(4)
			nombre_modificacion=tabla_acciones(5)
			
			set tipo_oficina_Gag=Server.CreateObject("ADODB.Recordset")
			with tipo_oficina_Gag
				.ActiveConnection=connimprenta
			
				.Source="SELECT PEDIDOS.ID, PEDIDOS.CODCLI, PEDIDOS.CODIGO_EXTERNO, PEDIDOS.PEDIDO, PEDIDOS.FECHA, PEDIDOS.ESTADO,"
				.Source= .Source & " PEDIDOS.FECHA_ENVIADO, V_CLIENTES.EMPRESA, V_CLIENTES.CODIGO_EXTERNO AS Cod_Ext_Ofi, V_CLIENTES.NOMBRE,"
				.Source= .Source & " V_CLIENTES.MARCA, V_CLIENTES.TIPO_PRECIO, V_CLIENTES.DIRECCION,"
				.Source= .Source & " V_CLIENTES.POBLACION, V_CLIENTES.PROVINCIA, V_CLIENTES.CP "
				.Source= .Source & " FROM PEDIDOS" 
				.Source= .Source & " INNER JOIN V_CLIENTES"
				.Source= .Source & " ON PEDIDOS.CODCLI = V_CLIENTES.Id"
				.Source= .Source & " where pedidos.id=" & pedido_modificar
			
				.Open
			end with
			
			if not tipo_oficina_Gag.eof then
				tipo_oficina_modif=tipo_oficina_Gag("tipo_precio")
			end if
			'response.write(tipo_oficina_modif&"<br>")
			tipo_oficina_Gag.close
			set tipo_oficina_Gag=Nothing
			
		end if
		
		
		
		
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
			.Source= .Source & " AND FAMILIAS.ID NOT IN (SELECT ID_FAMILIA FROM FAMILIAS_PROHIBIDAS WHERE CLIENTE = " & hotel_admin & ")"
			
			if agrupacion_familia_buscada<>"" and agrupacion_familia_buscada<>"TODOS" then
				.Source= .Source & " AND GRUPO_FAMILIAS='" & agrupacion_familia_buscada & "'"
			end if
			if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
				.Source= .Source & " AND (GRUPO_FAMILIAS NOT IN ('MARKETING', 'OFICINA', 'ROTULACION', 'VESTUARIO'))"
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
		
		
		with agrupacion_familias
			.ActiveConnection=connimprenta
			'.Source="SELECT  ID, ID_EMPRESA, GRUPO_FAMILIAS, ID_FAMILIA"
			.Source="SELECT  DISTINCT GRUPO_FAMILIAS"
			.Source= .Source & " FROM FAMILIAS_AGRUPADAS"
			.Source= .Source & " WHERE ID_EMPRESA=" & session("usuario_codigo_empresa")
			
			if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
				'pero para portugal desaparecen estas de asm
			  	 .Source= .Source & " AND (GRUPO_FAMILIAS NOT IN ('MARKETING', 'OFICINA', 'ROTULACION', 'VESTUARIO'))"
			end if
			
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
			sql="SELECT ARTICULOS.ID, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, ARTICULOS.CODIGO_SAP, ARTICULOS.CODIGO_EXTERNO,"
			sql=sql & " ARTICULOS.DESCRIPCION, ARTICULOS.TAMANNO, ARTICULOS.TAMANNO_ABIERTO, ARTICULOS.TAMANNO_CERRADO,"
			sql=sql & " ARTICULOS.PAPEL, ARTICULOS.TINTAS, ARTICULOS.ACABADO, ARTICULOS.FECHA, ARTICULOS.COMPROMISO_COMPRA,"
			sql=sql & " ARTICULOS.MOSTRAR, ARTICULOS.MULTIARTICULO, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS_EMPRESAS.FAMILIA,"
			sql=sql & " FAMILIAS.DESCRIPCION AS nombre_familia, MAX(ARTICULOS.REQUIERE_AUTORIZACION) AS REQUIERE_AUTORIZACION,"
			sql=sql & " MAX(ARTICULOS.PACKING) AS PACKING,"
			sql=sql & " MAX(ARTICULOS_PERSONALIZADOS.PLANTILLA_PERSONALIZACION) AS PLANTILLA_PERSONALIZACION"
	
			
			sql=sql & " FROM ARTICULOS INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO "
			sql=sql & " INNER JOIN FAMILIAS ON ARTICULOS_EMPRESAS.FAMILIA = FAMILIAS.ID "
			sql=sql & " INNER JOIN CANTIDADES_PRECIOS ON ARTICULOS.ID = CANTIDADES_PRECIOS.CODIGO_ARTICULO "
			sql=sql & " LEFT JOIN ARTICULOS_PERSONALIZADOS ON ARTICULOS.ID=ARTICULOS_PERSONALIZADOS.ID_ARTICULO"

			
			sql=sql & " WHERE ARTICULOS.MOSTRAR='SI'"
			sql=sql & " AND CANTIDADES_PRECIOS.TIPO_SUCURSAL='" & tipo_oficina_modif & "'"	
			sql=sql & " AND CANTIDADES_PRECIOS.CODIGO_EMPRESA = " & session("usuario_codigo_empresa") 
			if agrupacion_familia_buscada<>"" then
				sql=sql & " AND ARTICULOS_EMPRESAS.FAMILIA IN (SELECT ID_FAMILIA FROM FAMILIAS_AGRUPADAS"
				sql=sql & " WHERE (ID_EMPRESA = " & session("usuario_codigo_empresa") & ")"
				if agrupacion_familia_buscada<>"TODOS" then
					sql=sql & " AND (GRUPO_FAMILIAS = '" & agrupacion_familia_buscada & "')"
				end if
				
				sql=sql & ")"
			end if
			'response.write("<br>familia_buscada: " & familia_buscada)
			if familia_buscada<>"TODOS" then
				'response.write("<br>entro a asignar familia: " & familia_buscada)
				sql=sql & " AND ARTICULOS_EMPRESAS.FAMILIA=" & familia_buscada
			end if
			if codigo_sap_buscado<>"" then
				sql=sql & " AND ARTICULOS.CODIGO_SAP LIKE '%" & codigo_sap_buscado & "%'"
			end if
			if articulo_buscado<>"" then
				'sql=sql & " and descripcion like ""*" & articulo_buscado & "*"""
				'sql=sql & " AND ARTICULOS.DESCRIPCION LIKE '%" & articulo_buscado & "%'"
				sql=sql & " and (articulos.descripcion like '%" & articulo_buscado & "%'"
				
					'BUSCAMOS LA DESCRIPCION DEL ARTICULO O EN LOS DATOS ASOCIADOS COMO COMPONENTE
					'	-impresora asociada
					'	-color del cartucho
					'	-referencia
					sql=sql & " OR ARTICULOS.ID IN (SELECT ID_ARTICULO FROM DESCRIPCIONES_MULTIARTICULOS"
					sql=sql & " WHERE (CARACTERISTICA = 'IMPRESORA' OR CARACTERISTICA = 'COLOR' OR CARACTERISTICA = 'REFERENCIA') AND (DESCRIPCION LIKE '%" & articulo_buscado & "%'))"
				sql=sql & ")"
			end if
			if campo_autorizacion="SI" then
				sql=sql & " AND ARTICULOS.REQUIERE_AUTORIZACION='SI'"
			end if
			if campo_autorizacion="NO" then
				sql=sql & " AND (ARTICULOS.REQUIERE_AUTORIZACION='NO' OR ARTICULOS.REQUIERE_AUTORIZACION IS NULL)"
			end if
			
			
			sql=sql & " AND ARTICULOS_EMPRESAS.CODIGO_EMPRESA = " & session("usuario_codigo_empresa") 
			sql=sql & " AND ARTICULOS_EMPRESAS.FAMILIA NOT IN (SELECT ID_FAMILIA FROM FAMILIAS_PROHIBIDAS WHERE CLIENTE = " & hotel_admin & ")"
			sql=sql & " GROUP BY ARTICULOS.ID, ARTICULOS_EMPRESAS.CODIGO_EMPRESA, ARTICULOS.CODIGO_SAP, ARTICULOS.CODIGO_EXTERNO,"
			sql=sql & " ARTICULOS.DESCRIPCION, ARTICULOS.TAMANNO, ARTICULOS.TAMANNO_ABIERTO, ARTICULOS.TAMANNO_CERRADO,"
			sql=sql & " ARTICULOS.PAPEL, ARTICULOS.TINTAS, ARTICULOS.ACABADO, ARTICULOS.FECHA, ARTICULOS.COMPROMISO_COMPRA,"
			sql=sql & " ARTICULOS.MOSTRAR, ARTICULOS.MULTIARTICULO, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS_EMPRESAS.FAMILIA,"
			sql=sql & " FAMILIAS.DESCRIPCION"
			
			'sql=sql & " and Descripcion <> ''"
			'sql=sql & " and Mostrar_Intranet='SI'"
			'sql=sql & " and Activo = 1"
			'sql=sql & " order by Orden"
			sql=sql & " ORDER BY ARTICULOS.COMPROMISO_COMPRA DESC, ARTICULOS.DESCRIPCION"
		end if		
		
		
		'response.write("<br>Consulta articulos: " & sql)
		with articulos
			.ActiveConnection=connimprenta
			
			.Source=sql
			
			.Open
		end with
		
		
		
		'if familia_buscada="0" then
		'	familia_buscada=""
		'end if
		
		
		
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

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>

<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />
  


<style>
body {padding-top: 10px; margin:0px; background-color:#fff;}

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
  

/*
.centrado_vertical{
    float:none;
    display:inline-block;
    vertical-align:middle;
    margin-right:-4px;
}
*/


@media screen and (min-width: 725px){
   #columna_izquierda_fija{
       position: fixed;
   }
} 

.panel_conmargen
	{
	padding-left:5px; 
	padding-right:5px; 
	padding-bottom:5px; 
	padding-top:5px;
	}
	
.panel_sinmargen
	{
	padding-left:0px; 
	padding-right:0px; 
	padding-bottom:0px; 
	padding-top:0px;
	}
	
.panel_sinmargen_lados
	{
	padding-left:0px; 
	padding-right:0px; 
	}
	
.panel_sinmargen_arribaabajo
	{
	padding-bottom:0px; 
	padding-top:0px;
	}

.panel_connmargen_lados
	{
	padding-left:5px; 
	padding-right:5px; 
	}
	
.panel_conmargen_arribaabajo
	{
	padding-bottom:5px; 
	padding-top:5px;
	}
	
/*para que quite la sombra del panel*/	
.inf_general_art, .inf_pack_stock
	{
	-webkit-box-shadow: none;
    box-shadow: none;
	}
	

.table-borderless td,
.table-borderless th {
    border: 0px !important;
}
</style>


<script src="../funciones.js" type="text/javascript"></script>


<script language="javascript">
function crearAjax() 
{
  var Ajax
 
  if (window.XMLHttpRequest) { // Intento de crear el objeto para Mozilla, Safari,...
    Ajax = new XMLHttpRequest();
    if (Ajax.overrideMimeType) {
      //Se establece el tipo de contenido para el objeto
      //http_request.overrideMimeType('text/xml');
      //http_request.overrideMimeType('text/html; charset=iso-8859-1');
	  Ajax.overrideMimeType('text/html; charset=iso-8859-1');
     }
   } else if (window.ActiveXObject) { // IE
    try { //Primero se prueba con la mas reciente versión para IE
      Ajax = new ActiveXObject("Msxml2.XMLHTTP");
     } catch (e) {
       try { //Si el explorer no esta actualizado se prueba con la versión anterior
         Ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {}
      }
   }
 
  if (!Ajax) {
    alert('¡Por favor, actualice su navegador!');
    return false;
   }
  else
  {
    return Ajax;
  }
}

	

//onclick="mostrar_capa('/Reservas_Web/Incrementar_Visita.asp?Mayorista=MUNDORED','capa_annadir_articulo')"
//mostrar_capa('Annadir_Articulo.asp?acciones=<%=accion%>','capa_annadir_articulo')

function mostrar_capa(pagina,divContenedora,parametros)
{
	//alert('entramos en mostrar capa')
	//alert('parametros.... pagina: ' + pagina + ' divcontenedora: ' + divContenedora)
    var contenedor = document.getElementById(divContenedora);
    
	if (parametros=='')
		{
		var url_final = pagina
		}
	  else
	  	{
	  	var url_final = pagina + '?' + parametros
		}
 
    //contenedor.innerHTML = '<img src="imagenes/loading.gif" />'
	//console.log('url_final: ' + url_final)
    var objAjax = crearAjax()
 
    objAjax.open("GET", url_final)
    objAjax.onreadystatechange = function(){
      if (objAjax.readyState == 4)
	  {
       //Se escribe el resultado en la capa contenedora
	   txt=unescape(objAjax.responseText);
	   txt2=txt.replace(/\+/gi," ");
	   contenedor.innerHTML = txt2;
      }
    }
    objAjax.send(null);
	
}

</script>




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

function annadir_al_carrito(articulo, accion)
{
	permitir_annadir='SI'
	//alert('hola primero')
	//para que si no existe el objeto porque no hay precios grabados para este articulo
	//   no de error de javascript
    if (document.getElementById('ocultocantidades_precios_' + articulo))
	{
	//if (document.getElementById('ocultocantidades_precios_' + articulo).value=='')
	if (document.getElementById('txtcantidad_' + articulo))
		{
		if (document.getElementById('txtcantidad_' + articulo).value=='')
			{
			permitir_annadir='NO'
			}
		}
	  else
	  	{
		permitir_annadir='NO'
		$('#tabla_cantidades_precios_' + articulo + ' tbody tr').each(function (index) 
        	{
			//console.log('colorcito fila ' + index + ': ' + $(this).css('font-weight'))
			if (($(this).css('font-weight')=='bold') || ($(this).css('font-weight')=='700'))
				{
					permitir_annadir='SI'
				}
			
			});
		
		}
		
	if (permitir_annadir=='NO')	
		{
		//alert('Para Añadir El Artículo al Carrito ha de Seleccionar Las Cantidades/Precios del Mismo')
		cadena='<br><BR><H4>Para Añadir El Artículo al Carrito ha de Seleccionar Las Cantidades/Precios del Mismo</H4><BR><br>'
		$("#cabecera_pantalla_avisos").html("Avisos")
		$("#pantalla_avisos .modal-header").show()
		$("#body_avisos").html(cadena + "<br>");
		$("#pantalla_avisos").modal("show");
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
			cadena_email+= '&body=Por favor indique el nombre y Referencia. del art%EDculo del que desea que le facilitemos'
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

					//no hacemos el submit del formulario porque se vuelve a refrescar la pantalla con todos los
					//   articulos y como ya hay muchos, tarda horrores
					//document.getElementById('frmannadir_al_carrito').submit()
					
					//hace la animacion de llevar la imagen al carrito
					meter_al_carrito(articulo)
					
					parametros='acciones=' + accion
					parametros+='&ocultoarticulo=' + document.getElementById('ocultoarticulo').value
					parametros+= '&ocultocantidades_precios=' + document.getElementById('ocultocantidades_precios').value
					pagina_url='Annadir_Articulo_Gag_Central_Admin.asp'
					//pagina_url='Annadir_Articulo_Gag.asp'
					
					//console.log('parametros: ' + parametros)
					//console.log('url: ' + pagina_url)
					mostrar_capa(pagina_url,'capa_annadir_articulo', parametros)
	
					}
				  else
				  	{
						//alert('La Cantidad Introducida Ha De Ser Un Número Entero')
						cadena='<BR><BR><H4>La Cantidad Introducida Ha De Ser Un Número Entero</H4><BR><BR>'
						$("#cabecera_pantalla_avisos").html("Avisos")
						$("#pantalla_avisos .modal-header").show()
						$("#body_avisos").html(cadena + "<br>");
						$("#pantalla_avisos").modal("show");
						

						document.getElementById('txtcantidad_' + articulo).value=''
					}
				}
			  else
			  	{
				//cuando el articulo es sin compromiso de compra, ya viene la cantidad bien
				document.getElementById('ocultocantidades_precios').value=document.getElementById('ocultocantidades_precios_' + articulo).value
				//alert('cantidades despues: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
				
				
				//no hacemos el submit del formulario porque se vuelve a refrescar la pantalla con todos los
					//   articulos y como ya hay muchos, tarda horrores
					//document.getElementById('frmannadir_al_carrito').submit()
					
					//hace la animacion de llevar la imagen al carrito
					meter_al_carrito(articulo)
					
					parametros='acciones=' + accion
					parametros+='&ocultoarticulo=' + document.getElementById('ocultoarticulo').value
					parametros+= '&ocultocantidades_precios=' + document.getElementById('ocultocantidades_precios').value
					pagina_url='Annadir_Articulo_Gag_Central_Admin.asp'
					//pagina_url='Annadir_Articulo_Gag.asp?'
					
					//console.log('parametros: ' + parametros)
					//console.log('url: ' + pagina_url)
					mostrar_capa(pagina_url,'capa_annadir_articulo', parametros)
				}
			
			}
	
		}  
	}
	
	else
	{
		//alert('No Está Autorizado a Pedir Este Artículo')
		cadena='<BR><BR><H4>No Está Autorizado a Pedir Este Artículo</H4><BR><BR>'
		$("#cabecera_pantalla_avisos").html("Avisos")
		$("#pantalla_avisos .modal-header").show()
		$("#body_avisos").html(cadena + "<br>");
		$("#pantalla_avisos").modal("show");
	}
	
	
	//deseleccionamos todas las filas
	if (!document.getElementsByClassName)
		{
		elementos = document.querySelectorAll('.filas_cantidades');
		//alert('usamos queryselector')
		}
	  else
	  	{
		elementos = document.getElementsByClassName('filas_cantidades');
		//alert('usamos by class')
		}
		
	
	//elementos = document.getElementsByClassName('filas_cantidades');
	
	
    for (var i = 0; i < elementos.length; i++)
		{
		elementos[i].style.background='';
		elementos[i].style.fontWeight = 'normal';
		
	    }
		
	//quitamos el contenido de todas las cajas de texto 
	if (!document.getElementsByClassName)
		{
		elementos = document.querySelectorAll('.cantidad_pedida_art');
		//alert('usamos queryselector')
		}
	  else
	  	{
		elementos = document.getElementsByClassName('cantidad_pedida_art');
		//alert('usamos by class')
		}
		
	//elementos = document.getElementsByClassName('cantidad_pedida_art');
    for (var i = 0; i < elementos.length; i++)
		{
		elementos[i].value=''
	    }
		
}

function seleccionar_fila(articulo, fila_pulsada, numero_filas,cantidades_precio_total_articulo,compromiso_compra)
{
/*
console.log('seleccionar_fila:')
console.log('--- articulo: ' + articulo)
console.log('--- fila_pulsada: ' + fila_pulsada)
console.log('--- numero_filas: ' + numero_filas)
console.log('--- cantidades_precio_total_articulo: ' + cantidades_precio_total_articulo)
console.log('--- compromiso de compra: ' + compromiso_compra)
*/
	
	
	/*
	for (i=1;i<=numero_filas;i++)
	{
	document.getElementById('fila_' + articulo + '_' + i).style.background=''
	document.getElementById ('fila_' + articulo + '_' + i).style.fontWeight = 'normal'
//var fontTest = document.getElementById ('fila_' + articulo + '_' + i)
    //fontTest.style.fontWeight = '900';
	console.log('cambiamos el fondo de fila_' + articulo + '_' + i)

	}
	*/
	//deseleccionamos todas las filas
	if (!document.getElementsByClassName)
		{
		elementos = document.querySelectorAll('.filas_cantidades');
		//alert('usamos queryselector')
		}
	  else
	  	{
		elementos = document.getElementsByClassName('filas_cantidades');
		//alert('usamos by class')
		}
		
	//elementos = document.getElementsByClassName('filas_cantidades');
    for (var i = 0; i < elementos.length; i++)
		{
		elementos[i].style.background='';
		elementos[i].style.fontWeight = 'normal';
		
	    }
		
	//quitamos el contenido de todas las cajas de texto
	if (!document.getElementsByClassName)
		{
		elementos = document.querySelectorAll('.cantidad_pedida_art');
		//alert('usamos queryselector')
		}
	  else
	  	{
		elementos = document.getElementsByClassName('cantidad_pedida');
		//alert('usamos by class')
		}
	 
	//elementos = document.getElementsByClassName('cantidad_pedida_art');
    for (var i = 0; i < elementos.length; i++)
		{
		elementos[i].value=''
	    }
		
		
	
	if (compromiso_compra!='SI')
		{
		document.getElementById('fila_' + articulo + '_' + fila_pulsada).style.background='#E1E1E1' 
		document.getElementById ('fila_' + articulo + '_' + fila_pulsada).style.fontWeight = 'bold'
		}
	//alert('compromiso_compra: ' + compromiso_compra)
	document.getElementById('ocultocantidades_precios_' + articulo).value=cantidades_precio_total_articulo
		
	  	
}

function ir_pto_articulo(pto_articulo, agrupacion, empresa, pais)
{
	if (pto_articulo!='')
	{
		window.location='#'+pto_articulo;
	}
	
	if (agrupacion!='')
		{
		activar_agrupacion(agrupacion, empresa, pais)
		}
	//cerrar_capas('capa_informacion')
}

function activar_agrupacion(agrupacion, empresa, pais)
{
	cadena_boton='cmdAgrupacion_' + agrupacion
	if ((empresa=='ASM')&&(pais=='PORTUGAL')&&(agrupacion.indexOf('GLS')==(-1)))
		{
		if (agrupacion.indexOf('TODOS')==(-1))
			{
			//console.log('dentro de activar_agrupacion: 1')
			cadena_imagen='images/' + empresa + '_Boton_' + agrupacion + '_PT_Pulsado.jpg'
			}
		  else
		    {
			//console.log('dentro de activar_agrupacion: 2')
			
			cadena_imagen='images/' + empresa + '_Boton_GLS_' + agrupacion + '_Pulsado.jpg'
			}
		}
	  else
	  	{
		console.log('dentro de activar_agrupacion: 3')
			
		cadena_imagen='images/' + empresa + '_Boton_' + agrupacion + '_Pulsado.jpg'
		}
	
	//console.log('dentro de activar_agrupacion: imagen -- ' + cadena_imagen)

	
	//alert('boton pulsado: ' + cadena_boton + '\n\nimagen a cargar: ' + cadena_imagen)
	
	//document.getElementById(cadena_boton).style.backgroundImage='url("' + cadena_imagen + '")';
	//document.getElementById('cmdAgrupacion_CONSUMIBLES').style.backgroundImage='url("images/boton_consumibles_pulsado.jpg")';
	//document.getElementById('cmdAgrupacion_MARKETING').style.backgroundImage="url('images/Boton_Informatica_Pulsado.jpg')"
	document.getElementById(cadena_boton).style.backgroundImage='url(' + cadena_imagen + ')';
	//document.getElementById(cadena_boton).src=cadena_imagen;
	
	//alert('hola')

}
function mostrar_agrupaciones(agrupacion, empresa, pais)
{
	activar_agrupacion(agrupacion, empresa, pais)
	//alert('en mostrar agrupaciones')
	document.getElementById('cmbfamilias').value="TODOS"
	document.getElementById('ocultoagrupacion_familias').value=agrupacion
	//alert('antes del submit')
	document.getElementById('frmbusqueda').submit()
}


</script>

	

<!--PARA LA ANIMACION DE METER LA IMAGEN DEL ARTICULO EN EL CARRITO DE LA COMPRA-->		
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

	
	

</head>
<body onLoad="ir_pto_articulo('<%=pto_articulo%>', '<%=agrupacion_familia_buscada%>', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>')" style="margin-top:0; background-color:<%=session("color_asociado_empresa")%>">

<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->






<script language="javascript">
	cadena='<div align="center"><br><br><img src="../images/loading4.gif"/><br /><br /><h4>Espere mientras se carga la página...</h4><br></div>'
	$("#cabecera_pantalla_avisos").html("Avisos")
	$("#pantalla_avisos .modal-header").show()
	$("#body_avisos").html(cadena + "<br><br>");
	$("#pantalla_avisos").modal("show");
</script>

<div class="container-fluid">
   <!--PANTALLA-->
  <div class="row____">
    <!--COLUMNA IZQUIERDA -->
    <div class="col-xs-3" id="columna_izquierda_fija">


			  <!--DATOS DEL CLIENTE-->
			  <div class="panel panel-default" style="margin-bottom:0px ">
				<div class="panel-body panel_conmargen">
					<div class="col-md-12">
						<%
						nombre_logo="logo_" & session("usuario_carpeta") & ".png"
						if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
							nombre_logo="Logo_GLS.png"
						end if
						%>
						<div align="center"><img class="img-responsive" src="Images/<%=nombre_logo%>" style="max-height:90px"/></div>
						<br />
						<div align="center">	
							<button type="button" id="cmdarticulos" name="cmdarticulos" class="btn btn-primary btn-md" 
								data-toggle="popover" 
								data-placement="bottom" 
								data-trigger="hover" 
								data-content="Consultar Art&iacute;culos" 
								data-original-title=""
								>
									<i class="glyphicon glyphicon-th-list"></i>
									<span>Art&iacute;culos</span>
							</button>
							<button type="button" id="cmdpedidos" name="cmdpedidos" class="btn btn-primary btn-md" 
								data-toggle="popover" 
								data-placement="bottom" 
								data-trigger="hover" 
								data-content="Consultar Pedidos" 
								data-original-title=""
								>
									<i class="glyphicon glyphicon-list-alt"></i>
									<span>Pedidos</span>
							</button>
						</div>
						
					</div>
				</div>
			  </div>
	
	
			  <!--DATOS DEL PEDIDO-->
			  <div class="panel panel-default" style="margin-bottom:0px; margin-top:7px ">
				<div class="panel-heading"><b>Datos del Pedido</b></div>
				<div class="panel-body panel_sinmargen_lados panel_conmargen_arribaabajo">
					<div class="col-md-12">
						<div class="row">
							<div class="col-md-8" align="center" style="padding-bottom:6px ">
								<div style="display:inline-block"><span><img src="../images/Carrito_48x48.png" border="0" class="shopping-cart"/></span></div>
		
								<!-- NO BORRAR, es la capa que añade articulos al pedido....-->
								<div style="display:inline-block" id="capa_annadir_articulo">&nbsp;<b><%=session("numero_articulos")%></b> Artículos</div>
							</div>
							<div class="col-md-4" align="center">	
								<button type="button" id="cmdver_pedido" name="cmdver_pedido" class="btn btn-primary btn-sm" 
									data-toggle="popover" 
									data-placement="bottom" 
									data-trigger="hover" 
									data-content="Ver Pedido" 
									data-original-title=""
									>
										<i class="glyphicon glyphicon-list-alt"></i>
										<span>Ver</span>
								</button>
								
							</div>
						</div>	
							
						<div>
							<table width="95%" border="0" cellpadding="0" cellspacing="0" align="center">
								<tr>
									<td width="100%"><b>Modificando Pedido:</b>&nbsp;<%=pedido_modificar%></td>
								</tr>
								<tr>
									<td width="100%"><b>Sucursal:</b> <%=codigo_externo_modificacion%> - <%=nombre_modificacion%></td>
								</tr>
								<tr>
									<td width="100%" style="border-bottom:1px dotted #999999"><br /><b>Articulos:</b></td>
								</tr>
								<%i=1
								set articulos_carrito=Server.CreateObject("ADODB.Recordset")
								While i<=Session("numero_articulos")
									id=Session(i)
									sql="SELECT ARTICULOS.DESCRIPCION"
									sql=sql & " FROM ARTICULOS"
									sql=sql & " WHERE ARTICULOS.ID=" & id
									'response.write("<br>" & sql)
		
									with articulos_carrito
										.ActiveConnection=connimprenta
										.Source=sql
										'.source="SELECT ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION as articulo from articulos"
										'response.write("<br>" & .source)
										.Open
									end with
									
									
								%>
									<tr>
										<td width="100%" style="border-bottom:1px dotted #999999"><%=articulos_carrito("Descripcion")%></td>
									</tr>
								<%
									i=i+1
									articulos_carrito.close
								wend
								set articulos_carrito=Nothing
								%>
							
							</table>
						</div>
						
						
					</div>
				</div>
			  </div>
			  
			  
			  
				<!--OFERTAS DESTACADAS... CARRUSEL-->
				<%if not vacio_carrusel then%>
					<div class="panel panel-default" style="margin-bottom:0px;margin-top:7px ">
						<div class="panel-heading"><b>Destacados</b></div>
						<div class="panel-body panel_sinmargen_lados panel_conmargen_arribaabajo">
							<DIV>
							<!--COMIENZO DEL CARRUSEL
								... sacado de jssor slider
									http://www.jssor.com
							-->
							<script type="text/javascript" src="../carrusel/js/carrusel_4_seg.js"></script>
							<div id="jssor_2" style="position: relative; margin: 0 auto; top: 0px; left: 0px; width: 600px; height: 500px; overflow: hidden; visibility: hidden;">
								<!-- Pantalla de "Cargando..." -->
								<div data-u="loading" style="position: absolute; top: 0px; left: 0px;">
									<div style="filter: alpha(opacity=70); opacity: 0.7; position: absolute; display: block; top: 0px; left: 0px; width: 100%; height: 100%;"></div>
									<div style="position:absolute;display:block;background:url('../carrusel/img_carrusel/loading.gif') no-repeat center center;top:0px;left:0px;width:100%;height:100%;"></div>
								</div>
								<div data-u="slides" style="cursor: default; position: relative; top: 0px; left: 0px; width: 600px; height: 500px; overflow: hidden;">
									<%for i=0 to UBound(tabla_carrusel,2)%>
										<div style="display: none;"><img data-u="image" src="../carrusel/img_carrusel/<%=tabla_carrusel(campo_fichero_carrusel,i)%>" /></div>
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
							<script>
								jssor_slider_init('jssor_2');
							</script>
							<!-- FINALIZA EL CARRUSEL-->
							</DIV>
						</div>
					</div>
				<%end if%>		
				<!--FINAL OFERTAS DESTACADAS -- EL CARRUSEL-->
				
			  
    </div>
    <!--FINAL COLUMNA DE LA IZQUIERDA-->
    
    <!--COLUMNA DE LA DERECHA-->
    <div class="col-xs-9 col-xs-offset-3">
      <div class="panel panel-default">
        <div class="panel-heading"><span class='fontbold'>Busqueda de Productos <%=session("usuario_empresa")%></span></div>
        <div class="panel-body">
			<div class="well well-sm">
            	<form class="form-horizontal" role="form" name="frmbusqueda" id="frmbusqueda" method="post" action="Lista_Articulos_Gag_Central_Admin_Pedir.asp?acciones=<%=acciones%>">
					<input type="hidden" class="form-control" id="ocultoagrupacion_familias" name="ocultoagrupacion_familias" value="<%=agrupacion_familia_buscada%>" />
					<div class="form-group">    
					  <label class="col-md-1 control-label" 
							data-toggle="popover" 
							data-placement="bottom" 
							data-trigger="hover" 
							data-content="Referenc&iacute;a" 
							data-original-title=""
							>
							Ref.</label>	 
					  <div class="col-md-2">
						<input type="text" class="form-control" size="14" name="txtcodigo_sap" id="txtcodigo_sap" value="<%=codigo_sap_buscado%>" />
					  </div>
					  
					  <label class="col-md-2 control-label" 
							data-toggle="popover" 
							data-placement="bottom" 
							data-trigger="hover" 
							data-content="Descripci&oacute;n" 
							data-original-title=""
							>
							Desc.</label>	                
					  <div class="col-md-7">
						<input type="text" class="form-control" size="44" name="txtdescripcion" id="txtdescripcion" value="<%=articulo_buscado%>" />
					  </div>
					</div>  
					
					<div class="form-group">    
						<label class="col-md-1 control-label">Familia</label>	                
						<div class="col-md-4">
							<select class="form-control" name="cmbfamilias" id="cmbfamilias">
								<%if not vacio_familias then%>
									<%for i=0 to UBound(tabla_familias,2)%>
										<%if valor_seleccionado<>"" then
											if cint(valor_seleccionado)=cint(tabla_familias(campo_id_familia,i)) then%>
												<option value="<%=tabla_familias(campo_id_familia,i)%>" selected><%=UCASE(tabla_familias(campo_descripcion_familia,i))%></option>
											<%else%>
												<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=UCASE(tabla_familias(campo_descripcion_familia,i))%></option>
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
						</div>
			
						<%
						'el perfil de ASM no tiene que ver este filtro de Requiere Autorizacion
						'UVE tampoco
						'GEOMOON tampoco
						if session("usuario_codigo_empresa")<>4 and session("usuario_codigo_empresa")<>150 and session("usuario_codigo_empresa")<>130 then%>						  
								<label class="col-md-2 control-label" 
									data-toggle="popover" 
									data-placement="bottom" 
									data-trigger="hover" 
									data-content="Requiere Autorizaci&oacute;n" 
									data-original-title=""
									>
									Req. Auto.</label>	                
								<div class="col-md-3">
									<select class="form-control" name="cmbautorizacion" id="cmbautorizacion">
										<option value="">* Seleccione *</option>
										<option value="NO">NO</option>
										<option value="SI">SI</option>
									</select>
									<script language="JavaScript" type="text/javascript">
										document.getElementById("cmbautorizacion").value='<%=campo_autorizacion%>'
									</script>
								</div>
							<%else%>
								<div class="col-md-5"></div>
						<%END IF%>
						<div class="col-md-2">
						  <button type="submit" name="Action" id="Action" class="btn btn-primary btn-sm">
								<i class="glyphicon glyphicon-search"></i>
								<span>Buscar</span>
						  </button>
						</div>
					</div>  
					
					<!--botones para las agrupaciones de familia, para poder filtrar la consulta-->
					<div class="form-group">    
						<div class="col-md-12" align="center">
										<%if not vacio_agrupacion_familias then%>
												<%for i=0 to UBound(tabla_agrupacion_familias,2)%>
													<%'porque hay un boton especial para todo lo de ParcelShop, nos lo saltamos como familia
													if tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)<>"GLS_PARCELSHOP" then
														nombre_imagen = replace(session("usuario_empresa")," ", "_") & "_Boton_" & tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)
														'las oficinas de asm portugal tienen otro boton diferente 
														' para la agrupacion de familias de productos asm, para los productos gls
														' ya esta bien la que hay tambien para españa
														if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" and instr(tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i), "GLS")=0 then
															nombre_imagen=nombre_imagen & "_PT"
														end if
														nombre_imagen=nombre_imagen & ".jpg"
														%>
														<div  class="botones_agrupacion" name="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" id="cmdAgrupacion_<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" value="<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>" onclick="mostrar_agrupaciones('<%=tabla_agrupacion_familias(CAMPO_DESCRIPCION_AGRUPACION_FAMILIA,i)%>', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>')" style="background-image:url('images/<%=nombre_imagen%>');cursor:pointer"></div>
													<%end if%>
												<%next%>
												
												<%										
												'si es una oficina de asm, tiene que haber seleccionado antes que familias van a poder pedir, 
												'o de gls o de asm asi que el boton todos sera diferente segun asm o gls
												if session("usuario_codigo_empresa")=4 then	
													if session("usuario_pais")<>"PORTUGAL" then	
														if session("seleccion_asm_gls")="GLS" then%>
															<div  class="botones_agrupacion" name="cmdAgrupacion_GLS_TODOS" id="cmdAgrupacion_GLS_TODOS" onclick="mostrar_agrupaciones('GLS_TODOS', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>')" style="background-image:url('images/<%=replace(session("usuario_empresa")," ", "_")%>_Boton_GLS_TODOS.jpg');cursor:pointer" ></div>
															<%'para el primer pedido (con 50% de descuento) solo dejamos que pida 
															'cosas GLS
															'response.write("<br>derecho primer pedido: " & session("usuario_derecho_primer_pedido"))
															'response.write("<br>solo mostrar gls: " & solo_mostrar_gls)
															if session("usuario_derecho_primer_pedido")<>"SI"  then
																if solo_mostrar_gls<>"SI" then%>
																	<img class="img-responsive_" id="logo_asm_agrupacion" src="images/Boton_Principal_ASM.jpg" border="0" style="cursor:pointer;float:left"  height="100px" onclick="cambiar_imagen_agrupacion('ASM')" 
																		data-toggle="popover" 
																		data-placement="bottom" 
																		data-trigger="hover" 
																		data-content="<%=lista_articulos_gag_panel_filtros_boton_agrupacion_asm%>" 
																		data-original-title=""
																	/>
																	<img class="img-responsive_" id="logo_gls_parcelshop_agrupacion" src="images/Boton_Principal_GLS_PARCELSHOP.jpg" border="0" style="cursor:pointer;float:left"  height="100px" onclick="cambiar_imagen_agrupacion('GLS_PARCELSHOP')" 
																		data-toggle="popover" 
																		data-placement="bottom" 
																		data-trigger="hover" 
																		data-content="<%=lista_articulos_gag_panel_filtros_boton_agrupacion_gls_parcelshop%>" 
																		data-original-title=""
																		/>
														<%		
																end if
															end if
														end if 'DE seleccion_asm_gls=gls
														if session("seleccion_asm_gls")="ASM" then%>
															<div  class="botones_agrupacion" name="cmdAgrupacion_TODOS" id="cmdAgrupacion_TODOS" onclick="mostrar_agrupaciones('TODOS', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>')" style="background-image:url('images/<%=replace(session("usuario_empresa")," ", "_")%>_Boton_TODOS.jpg');cursor:pointer" ></div>
															<img class="img-responsive_" id="logo_gls_agrupacion" src="images/Boton_Principal_GLS.jpg" border="0" style="cursor:pointer;float:left"  height="100px" onclick="cambiar_imagen_agrupacion('GLS')" 
																data-toggle="popover" 
																data-placement="bottom" 
																data-trigger="hover" 
																data-content="<%=lista_articulos_gag_panel_filtros_boton_agrupacion_gls%>" 
																data-original-title=""
															/>
															<img class="img-responsive_" id="logo_gls_parcelshop_agrupacion" src="images/Boton_Principal_GLS_PARCELSHOP.jpg" border="0" style="cursor:pointer;float:left"  height="100px" onclick="cambiar_imagen_agrupacion('GLS_PARCELSHOP')"
																data-toggle="popover" 
																data-placement="bottom" 
																data-trigger="hover" 
																data-content="<%=lista_articulos_gag_panel_filtros_boton_agrupacion_gls_parcelshop%>" 
																data-original-title=""
															/>
														<%
														end if  
														if session("seleccion_asm_gls")="GLS_PARCELSHOP" then%>
															<div  class="botones_agrupacion" name="cmdAgrupacion_GLS_PARCELSHOP_TODOS" id="cmdAgrupacion_GLS_PARCELSHOP_TODOS" onclick="mostrar_agrupaciones('GLS_PARCELSHOP_TODOS', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>')" style="background-image:url('images/<%=replace(session("usuario_empresa")," ", "_")%>_Boton_GLS_PARCELSHOP_TODOS.jpg');cursor:pointer" ></div>
															<img class="img-responsive_" id="logo_asm_agrupacion" src="images/Boton_Principal_ASM.jpg" border="0" style="cursor:pointer;float:left"  height="100px" onclick="cambiar_imagen_agrupacion('ASM')" 
																data-toggle="popover" 
																data-placement="bottom" 
																data-trigger="hover" 
																data-content="<%=lista_articulos_gag_panel_filtros_boton_agrupacion_asm%>" 
																data-original-title=""
															/>
															<img class="img-responsive_" id="logo_gls_agrupacion" src="images/Boton_Principal_GLS.jpg" border="0" style="cursor:pointer;float:left"  height="100px" onclick="cambiar_imagen_agrupacion('GLS')" 
																data-toggle="popover" 
																data-placement="bottom" 
																data-trigger="hover" 
																data-content="<%=lista_articulos_gag_panel_filtros_boton_agrupacion_gls%>" 
																data-original-title=""
															/>
														<%
														end if 'de sesion_asm_gls=parcelshop  
													  else%>
													  	<div  class="botones_agrupacion" name="cmdAgrupacion_TODOS" id="cmdAgrupacion_TODOS" onclick="mostrar_agrupaciones('TODOS', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>')" style="background-image:url('images/<%=replace(session("usuario_empresa")," ", "_")%>_Boton_GLS_TODOS.jpg');cursor:pointer" ></div>  
													 <%end if ' del usuario_pais<>PORTUGAL
													

												  else%>
													<div  class="botones_agrupacion" name="cmdAgrupacion_TODOS" id="cmdAgrupacion_TODOS" onclick="mostrar_agrupaciones('TODOS', '<%=replace(session("usuario_empresa")," ", "_")%>', '<%=session("usuario_pais")%>')" style="background-image:url('images/<%=replace(session("usuario_empresa")," ", "_")%>_Boton_TODOS.jpg');cursor:pointer" ></div>  
												  
												<%end if 'del usuario_codigo_empresa=4%>
												
												
												
		
												<%if agrupacion_familia_buscada<>"" then%>
														<%if session("seleccion_asm_gls")="GLS" and agrupacion_familia_buscada="TODOS" then%>
																<script language="javascript">
																	//alert('cambio la imagen a <%=agrupacion_familia_buscada%>')
																	console.log('despues de cargar agrupaciones 1, en el javascript de inicializacion: <%=replace(session("usuario_empresa")," ", "_")%>_Boton_GLS_<%=agrupacion_familia_buscada%>_Pulsado.jpg')
																	document.getElementById('cmdAgrupacion_GLS_<%=agrupacion_familia_buscada%>').style.backgroundImage="url('images/<%=replace(session("usuario_empresa")," ", "_")%>_Boton_GLS_<%=agrupacion_familia_buscada%>_Pulsado.jpg')";								
																	//document.getElementById('cmdAgrupacion_<%=agrupacion_familia_buscada%>').src = 'images/Boton_<%=agrupacion_familia_buscada%>_Pulsado.jpg'
																</script>
														<%ELSE
															if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then%>
															
																<script language="javascript">
																	//alert('cambio la imagen a <%=agrupacion_familia_buscada%>')
																	console.log('despues de cargar agrupaciones 2, en el javascript de inicializacion: <%=replace(session("usuario_empresa")," ", "_")%>_Boton_<%=agrupacion_familia_buscada%>_PT_Pulsado.jpg')
																	
																	document.getElementById('cmdAgrupacion_<%=agrupacion_familia_buscada%>').style.backgroundImage="url('images/<%=replace(session("usuario_empresa")," ", "_")%>_Boton_<%=agrupacion_familia_buscada%>_PT_Pulsado.jpg')";								
																	//document.getElementById('cmdAgrupacion_<%=agrupacion_familia_buscada%>').src = 'images/Boton_<%=agrupacion_familia_buscada%>_Pulsado.jpg'
																</script>
															<%else%>
																<script language="javascript">
																	//alert('cambio la imagen a <%=agrupacion_familia_buscada%>')
																	console.log('despues de cargar agrupaciones 3, en el javascript de inicializacion: <%=replace(session("usuario_empresa")," ", "_")%>_Boton_<%=agrupacion_familia_buscada%>_Pulsado.jpg')
																	
																	document.getElementById('cmdAgrupacion_<%=agrupacion_familia_buscada%>').style.backgroundImage="url('images/<%=replace(session("usuario_empresa")," ", "_")%>_Boton_<%=agrupacion_familia_buscada%>_Pulsado.jpg')";								
																	//document.getElementById('cmdAgrupacion_<%=agrupacion_familia_buscada%>').src = 'images/Boton_<%=agrupacion_familia_buscada%>_Pulsado.jpg'
																</script>
															<%end if%>
														<%end if%>
												<%end if%>
										<%end if 'vacio agrupacion familias%>
						</div>
					  </div>	
					
	            </form>
			</div><!--del well de los filtros-->
			
			
			
			<%while not articulos.eof
				response.flush()%>
				<div class="row">
					<!--comienza el articulo IZQUIERDA-->
					<a name="pto_<%=articulos("id")%>" id="pto_<%=articulos("id")%>"></a>
					<div class="col-md-6">
							<div class="panel panel-primary item col_articulo_1 item_<%=articulos("ID")%>">
								<div class="panel-heading"  style="padding-bottom:2px;padding-top:2px"><H5><%=articulos("descripcion")%></H5></div>
								<div class="panel-body" style="padding-left:1px; padding-left:1px; padding-top:0px;">
									<!--informacion general del articulo-->
									<div class="row">
										<div class="col-md-7">
											<div style="padding-top:5px"></div>
											<div class="panel panel-default__ inf_general_art"  onclick="muestra_datos_articulo(<%=articulos("ID")%>)" 
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover" 
												data-content="pulse para ver mas informacion de este articulo" 
												data-original-title=""
												>
												<div class="panel-body" style="cursor:pointer;cursor:hand">
													<div align="left"><b>Referencia:</b> <%=articulos("codigo_sap")%><br></div>
													<div align="left"><b>Familia:</b>  <%=articulos("nombre_familia")%><br></div>
													<%
													'el perfil de ASM no tiene que ver este dato de Requiere Autorizacion
													'UVE tampoco
													'GEOMOON tampoco
													if session("usuario_codigo_empresa")<>4 and session("usuario_codigo_empresa")<>150  and session("usuario_codigo_empresa")<>130 then%>	
														<div align="left"><b>Requiere Autorización:</b>
															<%IF articulos("requiere_autorizacion")="SI" THEN%>
																<B style="color:#FF0000">SI</B>
															<%ELSE%>	
																NO
															<%END IF%>
															<br>
														</div>
													<%end if%>
												</div>
											</div>
										</div><!--col-md-7-->
										<div class="col-md-5">
											<div style="padding-top:5px"></div>
											<div class="panel inf_pack_stock">
												<div class="panel-body">
													<%if articulos("unidades_de_pedido")<>"" then%>
														<div>
															<b>Unidad de Pedido:</b> 
															<br>
															<%=articulos("unidades_de_pedido")%>
														</div>				
													<%end if%>
													<%if articulos("packing")<>"" then%>
														<div><b>Caja Completa:</b> <%=articulos("packing")%></div>				
													<%end if%>
												</div>
											</div>
										</div><!--col-md-5-->
									</div><!--row-->
									<!--fin informacion general del articulo-->
									
									<!--imagen, precios y cantidades del articulo-->
									<div class="col-md-12">
										<!--imagen del articulo-->
										<div class="col-md-6 panel_sinmargen_lados" align="center">
											<div class="thumb-holder" >
												<a href="../Imagenes_Articulos/<%=articulos("id")%>.jpg" target="_blank">
													<img class="img-responsive" src="../Imagenes_Articulos/Miniaturas/i_<%=articulos("id")%>.jpg" border="0" id="img_<%=articulos("id")%>">
												</a>
											</div>
										</div>
										<!-- fin imagen del articulo-->
										
										<!--tabla de precios y cantidades a pedir-->	
										<div class="col-md-6 panel_sinmargen_lados">
											<%
											set cantidades_precios=Server.CreateObject("ADODB.Recordset")
					
											sql="SELECT * FROM CANTIDADES_PRECIOS"
											sql=sql & " WHERE CODIGO_ARTICULO=" & articulos("id")
											sql=sql & " AND TIPO_SUCURSAL='" & tipo_oficina_modif & "'"
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
														
													
											<%if not cantidades_precios.eof then%>
												<%'controlamos si hay que mostrar una lista con cantidades fijas a seleccionar
													'o una caja de texto para poner la cantidad deseada de articulo
												if articulos("compromiso_compra")="NO" then%>
													<div class="col-md-12 panel_sinmargen_lados">
														<div class="panel panel-default" style="padding-bottom:0px ">
															<div class="panel-body--">
																<table class="table table-condensed" id="tabla_cantidades_precios_<%=articulos("id")%>" style="margin-bottom:0px "> 
																	<thead> 
																		<tr> 
																			<th style="text-align:right">Cantidad</th> 
																			<th style="text-align:right">Precio Pack</th> 
																		</tr> 
																	</thead> 
																	<tbody> 
																		<%filas=1
																		'cantidades_precios.movelast
																		'cantidades_precios.movefirst
																		numero_filas=cantidades_precios.recordcount
																		while not cantidades_precios.eof%>
																		
																			<%
																			cantidades_precio_total_articulo=""
																			'RESPONSE.WRITE("<BR>CANTIDAD: " & cantidades_precios("cantidad"))
																			'RESPONSE.WRITE("<BR>PRECIO UNIDAD: " & cantidades_precios("PRECIO_UNIDAD"))
																			'RESPONSE.WRITE("<BR>PRECIO PACK: " & cantidades_precios("PRECIO_PACK"))
																			
																			cantidades_precio_total_articulo=cantidades_precios("cantidad") & "--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																			%>
																			<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','NO')" class="filas_cantidades">
																				<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																				<td align="right"><%=cantidades_precios("cantidad")%>&nbsp;</td>
																				<td align="right">
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
																	</tbody> 
																</table>
															</div>
														</div><!--panel defalut-->
													</div><!--col-md-12-->
															
															
												<%else
													' se muestra una caja de texto para poner la cantidad deseada
													%>
													
													<div class="col-md-12 panel_sinmargen_lados">
														<div class="panel" style="padding-bottom:0px; -webkit-box-shadow: none; box-shadow: none; ">
															<div class="panel-body--">
																
																<table class="table table-borderless"> 
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
																				<tr> 
																					<th width="56%"><b>Precio Unid.</b></th> 
																					<td width="44%">
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
																				<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand; cursor:pointer;" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','SI')" class="filas_cantidades" valign="middle">
																					<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																					<th>Cantidad</th>
																					<td>
																						<input type="text" class="form-control cantidad_pedida_art" size="5" name="txtcantidad_<%=articulos("id")%>" id="txtcantidad_<%=articulos("id")%>" />
																					</td> 
																				</tr> 
																			<%
																			filas=filas+1
																			cantidades_precios.movenext%>
																		<%wend%>
																</table>	
															</div><!-- panel-body -->
														</div><!-- panel-->
													</div><!--col-md-12-->
																		
												<%end if 'COMPRIMISO_COMPRA%>
													  
											<%end if 'CANTIDADES_PRECIOS%>
											<%
											cantidades_precios.close
											set cantidadese_precios=Nothing
											%>
										</div>
										<!--fin tabla precios y cantidades-->			
									</div><!--fin del row-->
									<!--la informacion del articulo-->
									
									<!--boton de añadir y packing-->
									<div class="col-md-12" style="padding-top:10px ">
										<div class="col-md-3">
												<button type="button" name="cmdannadir_carrito" id="cmdannadir_carrito" class="btn btn-primary btn-sm" onclick="annadir_al_carrito(<%=articulos("ID")%>, '<%=acciones%>')" >
													<i class="glyphicon glyphicon-shopping-cart"></i>
													<span>A&ntilde;adir</span>
												</button>
										</div>
										<%IF articulos("plantilla_personalizacion")<>"" then%>
											<div class="col-md-9 ">
												<span class="label label-warning pull-right" 
														style="font-size:18px;"
														data-toggle="popover" 
														data-placement="bottom" 
														data-trigger="hover" 
														data-content="Requiere personalizaci&oacute;n" 
														data-original-title=""
														>
														<i class="glyphicon glyphicon-list-alt" style="padding-top:1px "></i>
												</span>
											</div>
										<%end if%>
									
									</div><!--del row-->
									<!--fin añadir y packing-->
								</div><!--panel-body-->
							</div><!--panel-->
						</div><!--col-md-6-->
						<!--finaliza el articulo IZQUIERDA-->
					
					
					
					<%
					IF not articulos.eof THEN
						articulos.movenext
					END IF
					%>
					
					<%IF not articulos.eof THEN%>
						
						<!--comienza el articulo DERECHA-->
						<a name="pto_<%=articulos("id")%>" id="pto_<%=articulos("id")%>"></a>
						<div class="col-md-6">
							<div class="panel panel-primary item col_articulo_2 item_<%=articulos("ID")%>">
								<div class="panel-heading"  style="padding-bottom:2px;padding-top:2px"><H5><%=articulos("descripcion")%></H5></div>
								<div class="panel-body" style="padding-left:1px; padding-left:1px; padding-top:0px;">
									<!--informacion general del articulo-->
									<div class="row">
										<div class="col-md-7">
											<div style="padding-top:5px"></div>
											<div class="panel panel-default__ inf_general_art"  onclick="muestra_datos_articulo(<%=articulos("ID")%>)" 
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover" 
												data-content="pulse para ver mas informacion de este articulo" 
												data-original-title=""
												>
												<div class="panel-body" style="cursor:pointer;cursor:hand">
													<div align="left"><b>Referencia:</b> <%=articulos("codigo_sap")%><br></div>
													<div align="left"><b>Familia:</b>  <%=articulos("nombre_familia")%><br></div>
													<%
													'el perfil de ASM no tiene que ver este dato de Requiere Autorizacion
													'UVE tampoco
													'GEOMOON tampoco
													if session("usuario_codigo_empresa")<>4 and session("usuario_codigo_empresa")<>150  and session("usuario_codigo_empresa")<>130 then%>	
														<div align="left"><b>Requiere Autorización:</b>
															<%IF articulos("requiere_autorizacion")="SI" THEN%>
																<B style="color:#FF0000">SI</B>
															<%ELSE%>	
																NO
															<%END IF%>
															<br>
														</div>
													<%end if%>
												</div>
											</div>
										</div><!--col-md-7-->
										<div class="col-md-5">
											<div style="padding-top:5px"></div>
											<div class="panel inf_pack_stock">
												<div class="panel-body">
													<%if articulos("unidades_de_pedido")<>"" then%>
														<div>
															<b>Unidad de Pedido:</b> 
															<br>
															<%=articulos("unidades_de_pedido")%>
														</div>				
													<%end if%>
													<%if articulos("packing")<>"" then%>
														<div><b>Caja Completa:</b> <%=articulos("packing")%></div>				
													<%end if%>
												</div>
											</div>
										</div><!--col-md-5-->
									</div><!--row-->
									<!--fin informacion general del articulo-->
									
									<!--imagen, precios y cantidades del articulo-->
									<div class="col-md-12">
										<!--imagen del articulo-->
										<div class="col-md-6 panel_sinmargen_lados" align="center">
											<div class="thumb-holder" >
												<a href="../Imagenes_Articulos/<%=articulos("id")%>.jpg" target="_blank">
													<img class="img-responsive" src="../Imagenes_Articulos/Miniaturas/i_<%=articulos("id")%>.jpg" border="0" id="img_<%=articulos("id")%>">
												</a>
											</div>
										</div>
										<!-- fin imagen del articulo-->
										
										<!--tabla de precios y cantidades a pedir-->	
										<div class="col-md-6 panel_sinmargen_lados">
											<%
											set cantidades_precios=Server.CreateObject("ADODB.Recordset")
					
											sql="SELECT * FROM CANTIDADES_PRECIOS"
											sql=sql & " WHERE CODIGO_ARTICULO=" & articulos("id")
											sql=sql & " AND TIPO_SUCURSAL='" & tipo_oficina_modif & "'"
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
														
													
											<%if not cantidades_precios.eof then%>
												<%'controlamos si hay que mostrar una lista con cantidades fijas a seleccionar
													'o una caja de texto para poner la cantidad deseada de articulo
												if articulos("compromiso_compra")="NO" then%>
													<div class="col-md-12 panel_sinmargen_lados">
														<div class="panel panel-default" style="padding-bottom:0px ">
															<div class="panel-body--">
																<table class="table table-condensed" id="tabla_cantidades_precios_<%=articulos("id")%>" style="margin-bottom:0px "> 
																	<thead> 
																		<tr> 
																			<th style="text-align:right">Cantidad</th> 
																			<th style="text-align:right">Precio Pack</th> 
																		</tr> 
																	</thead> 
																	<tbody> 
																		<%filas=1
																		'cantidades_precios.movelast
																		'cantidades_precios.movefirst
																		numero_filas=cantidades_precios.recordcount
																		while not cantidades_precios.eof%>
																		
																			<%
																			cantidades_precio_total_articulo=""
																			'RESPONSE.WRITE("<BR>CANTIDAD: " & cantidades_precios("cantidad"))
																			'RESPONSE.WRITE("<BR>PRECIO UNIDAD: " & cantidades_precios("PRECIO_UNIDAD"))
																			'RESPONSE.WRITE("<BR>PRECIO PACK: " & cantidades_precios("PRECIO_PACK"))
																			
																			cantidades_precio_total_articulo=cantidades_precios("cantidad") & "--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																			%>
																			<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand;cursor:pointer" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','NO')" class="filas_cantidades">
																				<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																				<td align="right"><%=cantidades_precios("cantidad")%>&nbsp;</td>
																				<td align="right">
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
																	</tbody> 
																</table>
															</div>
														</div><!--panel defalut-->
													</div><!--col-md-12-->
															
															
												<%else
													' se muestra una caja de texto para poner la cantidad deseada
													%>
													
													<div class="col-md-12 panel_sinmargen_lados">
														<div class="panel" style="padding-bottom:0px; -webkit-box-shadow: none; box-shadow: none; ">
															<div class="panel-body--">
																
																<table class="table table-borderless"> 
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
																				<tr> 
																					<th width="56%"><b>Precio Unid.</b></th> 
																					<td width="44%">
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
																				<tr id="fila_<%=articulos("id")%>_<%=filas%>" style="cursor:hand; cursor:pointer;" onclick="seleccionar_fila(<%=articulos("id")%>,<%=filas%>,<%=(numero_filas)%>,'<%=cantidades_precio_total_articulo%>','SI')" class="filas_cantidades" valign="middle">
																					<input type="hidden" id="ocultocantidades_precios_<%=articulos("id")%>" value="" />
																					<th>Cantidad</th>
																					<td>
																						<input type="text" class="form-control cantidad_pedida_art" size="5" name="txtcantidad_<%=articulos("id")%>" id="txtcantidad_<%=articulos("id")%>" />
																					</td> 
																				</tr> 
																			<%
																			filas=filas+1
																			cantidades_precios.movenext%>
																		<%wend%>
																</table>	
															</div><!-- panel-body -->
														</div><!-- panel-->
													</div><!--col-md-12-->
																		
												<%end if 'COMPRIMISO_COMPRA%>
													  
											<%end if 'CANTIDADES_PRECIOS%>
											<%
											cantidades_precios.close
											set cantidadese_precios=Nothing
											%>
										</div>
										<!--fin tabla precios y cantidades-->			
									</div><!--fin del row-->
									<!--la informacion del articulo-->
									
									<!--boton de añadir y packing-->
									<div class="col-md-12" style="padding-top:10px ">
										<div class="col-md-3">
												<button type="button" name="cmdannadir_carrito" id="cmdannadir_carrito" class="btn btn-primary btn-sm" onclick="annadir_al_carrito(<%=articulos("ID")%>, '<%=acciones%>')" >
													<i class="glyphicon glyphicon-shopping-cart"></i>
													<span>A&ntilde;adir</span>
												</button>
										</div>
										<%IF articulos("plantilla_personalizacion")<>"" then%>
											<div class="col-md-9 ">
												<span class="label label-warning pull-right" 
														style="font-size:18px;"
														data-toggle="popover" 
														data-placement="bottom" 
														data-trigger="hover" 
														data-content="Requiere personalizaci&oacute;n" 
														data-original-title=""
														>
														<i class="glyphicon glyphicon-list-alt" style="padding-top:1px "></i>
												</span>
											</div>
										<%end if%>
									
									</div><!--del row-->
									<!--fin añadir y packing-->
								</div><!--panel-body-->
							</div><!--panel-->
						</div><!--col-md-6-->
						<!--finaliza el articulo DERECHA-->
					</div><!--row-->
					<script language="javascript">
						//procedimiento que iguala la altura de las 2 celdas (paneles) de cada fila
						//porque con la clase table_cell... tambien se iguala, pero se descoloca
						//todo a lo ancho
						altura_1=$(".col_articulo_1").height()
						altura_2=$(".col_articulo_2").height()
						altura=altura_1
						if (altura_2>altura)
							{
							altura=altura_2
							}
						
						//$(".col_articulo_1").height(altura)
						//$(".col_articulo_2").height(altura)
						$('.col_articulo_1').css('min-height', altura + 'px')
						$('.col_articulo_2').css('min-height', altura + 'px')
						//console.log('altura1: ' + altura_1 + ' ... altura2: ' + altura_2 + ' ... altura tomada: ' + altura)
						
						$(".col_articulo_1" ).removeClass("col_articulo_1")
						$(".col_articulo_2" ).removeClass("col_articulo_2")

					</script>					
				<%END IF 'IF NOT ARTICULOS.EOF%>	
				<%
				IF not articulos.eof THEN
					articulos.movenext
				END IF
				%>
			<%wend%>
			
        </div><!--panel-body-->
      </div><!--panel-->
    </div>
    <!--FINAL COLUMNA DE LA DERECHA-->
  </div>    
  <!-- FINAL DE LA PANTALLA -->
</div>
<!--FINAL CONTAINER-->
<script language="javascript">
	$("#pantalla_avisos").modal("hide");
</script>



<form name="frmannadir_al_carrito" id="frmannadir_al_carrito" action="Annadir_Articulo_Gag.asp?acciones=<%=accion%>" method="post">
	<input type="hidden" name="ocultoarticulo" id="ocultoarticulo" value=""/>
	<input type="hidden" name="ocultocantidades_precios" id="ocultocantidades_precios" value="" />
</form>


				<!-- END SHOPPAGE_HEADER.HTM -->
				
		
<!--<script type="text/javascript" src="../plugins/jquery/jquery-1.12.4.min.js"></script>-->

		
<script>
$(document).ready(function() {
    //para que se configuren los popover-titles...
	$('[data-toggle="popover"]').popover({html:true});


});

function meter_al_carrito(id_articulo)
{
		//console.log('meter al carrito')
		var cart = $('.shopping-cart');
        var imgtodrag = $("#img_" + id_articulo);
		//var imgtodrag = $(this).parent('.item').find("img").eq(0);
		
		if (imgtodrag) {
            var imgclone = imgtodrag.clone()
				.offset({
                	top: imgtodrag.offset().top,
					left: imgtodrag.offset().left
			 	})
                .css({
                'opacity': '0.5',
                    'position': 'absolute',
                    //'height': '150px',
                    //'width': '150px',
                    'z-index': '100'
            })
                .appendTo($('body'))
				.animate({
                	'top': cart.offset().top + 10,
                    'left': cart.offset().left + 10,
					'width': 75,
                    'height': 75
            }, 1000, 'easeInOutExpo');
            
			setTimeout(function () {
                cart.effect("shake", {
                    times: 2
                }, 200);
            }, 1500);

			imgclone.animate({
                'width': 0,
                    'height': 0
            }, function () {
                $(this).detach()
            });
        }
}

// para que se ponga visible siempre la columna de la izquierda
/*
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
*/		
	
$("#cmdarticulos").on("click", function () {
	location.href='Lista_Articulos_Gag_Central_Admin.asp'
});

$("#cmdpedidos").on("click", function () {
	location.href='Consulta_Pedidos_Gag_Central_Admin.asp'
});

$("#cmdver_pedido").on("click", function () {
	location.href='Carrito_Gag_Central_Admin.asp?acciones=<%=acciones%>'
});



$('.inf_general_art').hover(
       function(){ $(this).addClass('panel-primary') },
       function(){ $(this).removeClass('panel-primary') }
)


muestra_datos_articulo = function(articulo) {
	cadena='<iframe id="iframe_datos_articulo" src="Datos_Articulo_Gag.asp?articulo=' + articulo + '" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe>'
	$("#pantalla_avisos .modal-header").hide()
	$("#body_avisos").html(cadena);
	$("#pantalla_avisos").modal("show");
  };  
</script>       

				
</body>
<%
	articulos.close
	
	connimprenta.close
			  
			
	set articulos=Nothing
	
	set connimprenta=Nothing
%>
</html>

