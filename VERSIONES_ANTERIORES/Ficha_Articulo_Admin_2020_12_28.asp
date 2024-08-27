<%@ language=vbscript%>
<!--#include file="Conexion.inc"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
		if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
		end if
		
		articulo_seleccionado=Request.Form("ocultoid_articulo")
		accion_seleccionada=Request.Form("ocultoaccion")
		pestanna_vuelta_seleccionada=Request.Form("ocultopestanna_vuelta")
		'response.write("<br>-pestana vuelta de la ficha: " & pestanna_vuelta_seleccionada)
		
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

		
		set proveedores=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_PROVEEDOR=0
		CAMPO_DESCRIPCION_PROVEEDOR=1
		with proveedores
			.ActiveConnection=connimprenta
			.Source="SELECT ID, DESCRIPCION"
			.Source= .Source & " FROM PROVEEDORES"
			.Source= .Source & " ORDER BY DESCRIPCION"
			.Open
			vacio_proveedores=false
			if not .BOF then
				mitabla_proveedores=.GetRows()
			  else
				vacio_proveedores=true
			end if
		end with

		proveedores.close
		set proveedores=Nothing
		
		
		set articulos=Server.CreateObject("ADODB.Recordset")
		
		with articulos
		
			.ActiveConnection=connimprenta
			.Source="SELECT ARTICULOS.ID, ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION,"
			.Source= .Source & " ARTICULOS.TAMANNO, ARTICULOS.TAMANNO_ABIERTO, ARTICULOS.TAMANNO_CERRADO, ARTICULOS.PAPEL,"
			.Source= .Source & " ARTICULOS.TINTAS, ARTICULOS.ACABADO, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.FECHA,"
			.Source= .Source & " ARTICULOS.COMPROMISO_COMPRA, ARTICULOS.MOSTRAR, ARTICULOS.REQUIERE_HOJA_RUTA, ARTICULOS.BORRADO, ARTICULOS.REQUIERE_AUTORIZACION, "
			.Source= .Source & " ARTICULOS.PACKING, ARTICULOS.FACTURABLE, ARTICULOS.MATERIAL, ARTICULOS.RAPPEL, ARTICULOS.VALOR_RAPPEL,"
			.Source= .Source & " ARTICULOS.PROVEEDOR, ARTICULOS.PRECIO_COSTE, ARTICULOS.REFERENCIA_DEL_PROVEEDOR,"
			.Source= .Source & " ARTICULOS.SOLICITADO_AL_PROVEEDOR, ARTICULOS.PESO"
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
		campo_hoja_ruta=""
		'campo_familia=""
		campo_eliminado=""
		campo_autorizacion=""
		campo_facturable=""
		campo_material=""
		campo_rappel=""
		campo_valor_rappel=""
		campo_precio_coste=""
		campo_proveedor=""
		campo_referencia_del_proveedor=""
		campo_solicitado_al_proveedor=""
		campo_peso=""
		
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
			campo_hoja_ruta=articulos("requiere_hoja_ruta")
			'campo_familia=articulos("familia")
			campo_eliminado=articulos("borrado")
			campo_autorizacion=articulos("requiere_autorizacion")
			campo_facturable=articulos("facturable")
			campo_material=articulos("material")
			campo_rappel=articulos("rappel")
			campo_valor_rappel=articulos("valor_rappel")
			campo_precio_coste=articulos("precio_coste")
			campo_proveedor=articulos("proveedor")
			campo_referencia_del_proveedor=articulos("referencia_del_proveedor")
			campo_solicitado_al_proveedor=articulos("solicitado_al_proveedor")
			campo_peso=articulos("peso")
			
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



		set stocks_articulo=Server.CreateObject("ADODB.Recordset")
		
		sql="SELECT MARCA, iD_ARTICULO, sTOCK, STOCK_MINIMO from articulos_marcas WHERE ID_ARTICULO=" & articulo_seleccionado 
		sql=sql & " AND MARCA='STANDARD' ORDER BY MARCA"
		'response.write("<br>" & sql)
		
		campo_stock=""
		campo_stock_minimo=""
		
		with stocks_articulo
			.ActiveConnection=connimprenta
			.CursorType=3 'adOpenStatic
			.Source=sql
			.Open
		end with
		
		if not stocks_articulo.eof then
			campo_stock=stocks_articulo("STOCK")
			campo_stock_minimo=stocks_articulo("STOCK_MINIMO")
		end if
			 
		stocks_articulo.close
		set stocks_articulo=Nothing
		
		
																											

%>

<html>



<head>


	<title>Ficha Articulo</title>
	
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/autofill/2.2.2/css/autoFill.bootstrap4.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/1.5.1/css/buttons.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.4.1/css/colReorder.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/fixedcolumns/3.2.4/css/fixedColumns.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/fixedheader/3.1.3/css/fixedHeader.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/keytable/2.3.2/css/keyTable.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.2.1/css/responsive.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/rowgroup/1.0.2/css/rowGroup.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/rowreorder/1.2.3/css/rowReorder.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/scroller/1.4.4/css/scroller.bootstrap4.min.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/select/1.2.5/css/select.bootstrap4.min.css"/>

	
	<script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>


	<link rel="stylesheet" href="style_menu_hamburguesa5.css">



<style>
		
		#capa_detalle_pir .modal-dialog  {width:90%;}
		
		.table th { font-size: 13px; }
		.table td { font-size: 12px; }
		
		.dataTables_length {float:left;}
		.dataTables_filter {float:right;}
		.dataTables_info {float:left;}
		.dataTables_paginate {float:right;}
		.dataTables_scroll {clear:both;}
		.toolbar {float:left;}    
		div .dt-buttons {float:right; position:relative;}
		table.dataTable tr.selected.odd {background-color: #9FAFD1;}
		table.dataTable tr.selected.even {background-color: #B0BED9;}
		
		
		
		//para alinear las celdas y la cabecera
		// esta en v2\plugins\dataTable\media\css\jquery.datatables.css
		// pero si lo incluimos entero muestra iconos innecesarios en la cabecera del datatable
		// salen triangulitos para ordenar ascendente o descendentemente
		table.dataTable th.dt-left,
		table.dataTable td.dt-left {text-align:left}
		
		table.dataTable th.dt-center,
		table.dataTable td.dt-center,
		table.dataTable td.dataTables_empty {text-align:center}
		
		table.dataTable th.dt-right,
		table.dataTable td.dt-right {text-align:right}
		
		table.dataTable th.dt-justify,
		table.dataTable td.dt-justify {text-align:justify}
		
		table.dataTable th.dt-nowrap,
		table.dataTable td.dt-nowrap {white-space:nowrap}
		
		table.dataTable thead th.dt-head-left,
		table.dataTable thead td.dt-head-left,
		table.dataTable tfoot th.dt-head-left,
		table.dataTable tfoot td.dt-head-left {text-align:left}
		
		table.dataTable thead th.dt-head-center,
		table.dataTable thead td.dt-head-center,
		table.dataTable tfoot th.dt-head-center,
		table.dataTable tfoot td.dt-head-center {text-align:center}
		
		table.dataTable thead th.dt-head-right,
		table.dataTable thead td.dt-head-right,
		table.dataTable tfoot th.dt-head-right,
		table.dataTable tfoot td.dt-head-right {text-align:right}
		
		table.dataTable thead th.dt-head-justify,
		table.dataTable thead td.dt-head-justify,
		table.dataTable tfoot th.dt-head-justify,
		table.dataTable tfoot td.dt-head-justify {text-align:justify}
		
		table.dataTable thead th.dt-head-nowrap,
		table.dataTable thead td.dt-head-nowrap,
		table.dataTable tfoot th.dt-head-nowrap,
		table.dataTable tfoot td.dt-head-nowrap {white-space:nowrap}
		
		table.dataTable tbody th.dt-body-left,
		table.dataTable tbody td.dt-body-left {text-align:left}
		
		table.dataTable tbody th.dt-body-center,
		table.dataTable tbody td.dt-body-center {text-align:center}
		
		table.dataTable tbody th.dt-body-right,
		table.dataTable tbody td.dt-body-right {text-align:right}
		
		table.dataTable tbody th.dt-body-justify,
		table.dataTable tbody td.dt-body-justify {text-align:justify}
		
		table.dataTable tbody th.dt-body-nowrap,
		table.dataTable tbody td.dt-body-nowrap {white-space:nowrap}
		
		table.dataTable,
		table.dataTable th,
		table.dataTable td{-webkit-box-sizing:content-box;-moz-box-sizing:content-box;box-sizing:content-box}
		
		table.dataTable tbody tr { cursor:pointer}
		//------------------------------------------
		
		
		
		
 
	</style>




<style>
body {
  /*
  font: 14px/1 'Open Sans', sans-serif;
  color: #555;
  */
  
}

main {
  /*min-width: 320px;
  max-width: 1100px;
  */
  padding: 20px;
  margin: 0 auto;
  background: #fff;
}

section {
  display: none;
  padding: 20px 0 0;
  border-top: 1px solid #ddd;
}

input.pestannas {
  display: none;
}

label.pestannas {
  display: inline-block;
  margin: 0 0 -1px;
  padding: 15px 25px;
  font-weight: 600;
  text-align: center;
  color: #bbb;
  border: 1px solid transparent;
}

label.pestannas:before {
  font-weight: normal;
  margin-right: 10px;
}


label.pestannas:hover {
  color: #888;
  cursor: pointer;
}

input.pestannas:checked + label {
  color: #555;
  border: 1px solid #ddd;
  border-top: 2px solid orange;
  border-bottom: 1px solid #fff;
}

#tab1:checked ~ #content1,
#tab2:checked ~ #content2,
#tab3:checked ~ #content3,
#tab4:checked ~ #content4 {
  display: block;
}

.contenido_pestannas {
    border-bottom: 1px solid #ddd;
	border-left: 1px solid #ddd;
	border-right: 1px solid #ddd;
	
}

.row-no-padding {
  [class*="col-"] {
    padding-left: 0 !important;
    padding-right: 0 !important;
  }
}
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


	
	
   	

   


</script>

<script type="text/javascript"> 


function comprobar_articulo()
{
	//console.log('dentro de comprobar articulo')
	cadena_error=''
	seleccionado_barcelo=0;
	seleccionado_otro=0;
	empresas_seleccionadas=0
	
	
	pestanna_vuelta=''
	j$(".contenido_pestannas").each(function(index) 
	{
	 // console.log('objeto: ' + j$(this).prop('id') + ' valor display: ' + j$(this).css('display'))
	  if (j$(this).css('display')=='block')
		{
		pestanna_vuelta=j$(this).prop('id')
		}
	});
	if (pestanna_vuelta!='')
		{
		pestanna_vuelta=pestanna_vuelta.replace('content','tab')
		}
	//console.log('pestaña vuelta: ' + pestanna_vuelta)	
	
	
	if (document.getElementById('txtcodigo_sap').value=='')
		{
		cadena_error+= '&nbsp;&nbsp;&nbsp;- Se Ha De Introducir Una Referencia para El Artículo...<br>';
		}
	if (document.getElementById('txtdescripcion').value=='')
		{
		cadena_error+= '&nbsp;&nbsp;&nbsp;- Se Ha De Introducir La Descripción Del Artículo...<br>';
		}
	if (document.getElementById('cmbcompromiso_de_compra').value=='')
		{
		cadena_error+= '&nbsp;&nbsp;&nbsp;- Se Ha de Seleccionar si el Articulo Tiene Compromiso de Compra o No...<br>';
		}
	if (document.getElementById('cmbmostrar').value=='')
		{
		cadena_error+= '&nbsp;&nbsp;&nbsp;- Se Ha de Seleccionar si el Articulo se Muestra o No...<br>';
		}
	
	seleccionada_empresa=0
	j$(".cmbempresas_familias").each(function(index) 
	{
	  if (j$(this).val()!='')
	  	{
		seleccionada_empresa=1
		}
	});
	
	if (seleccionada_empresa==0)
		{
		cadena_error+= '&nbsp;&nbsp;&nbsp;- Se Ha de Asociar el Articulo con Alguna Empresa y Familia...<br>';
		}
	
	if (cadena_error!='')
		{
			//alert('Se Han Detectado los Siguientes Errores:\n' + cadena_error);

			bootbox.alert({
				size: 'large',
				message: '<h4><p><i class="fas fa-exclamation-circle" style="color:red"></i> Se Han Encontrado Los Siguientes Errores...</p></h4><br><br>' + cadena_error + '<br>'
				//callback: function () {return false;}
			})
			
		}
	  else
	  	{
			if (('<%=campo_compromiso_compra%>'!='')&&(document.getElementById("cmbcompromiso_de_compra").value!='<%=campo_compromiso_compra%>'))
			{
				bootbox.confirm({
					message: "Al cambiar el COMPROMISO DE COMPRA se eliminarán los precios del artículo que haya establecido hasta ahora... Desea Continuar?",
					buttons: {
						confirm: {
							label: 'Si',
							className: 'btn-success'
						},
						cancel: {
							label: 'No',
							className: 'btn-danger'
						}
					},
					callback: function (result) {
						if (result)
							{
							//console.log('valor del id de cantidades precios: ' + j$(tabla).find('input[type=hidden]').val())
							//console.log('metemos el valor de la pestaña: ' + pestanna_vuelta)
							document.getElementById("oculto_pestanna_vuelta").value=pestanna_vuelta;
							document.getElementById("oculto_cambio_compromiso_compra").value='S';
							j$("#frmdatos_articulo").submit();
							}
						  else
						  	{
							//return false;
							}
					}
				});
			
			
				
			}
			else			
			{
				//console.log('metemos el valor de la pestaña: ' + pestanna_vuelta)
				document.getElementById("oculto_pestanna_vuelta").value=pestanna_vuelta;
				document.getElementById("oculto_cambio_compromiso_compra").value='N';
				j$("#frmdatos_articulo").submit();
			}
		}
	
}
</script> 

<script type="text/javascript"> 
function mostrar_capa(pagina,divContenedora, procedencia)
{
	//alert('entramos en mostrar capa')
	//alert('parametros.... pagina: ' + pagina + ' divcontenedora: ' + divContenedora)
    var contenedor = document.getElementById(divContenedora);
    
	
    var url_final = pagina
 
    //contenedor.innerHTML = '<img src="imagenes/loading.gif" />'

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
	if (procedencia=='ENTRADAS')
		{
		refrescar_entrada()
		}
		
	if (procedencia=='SALIDAS')
		{
		refrescar_salida()
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

function comprobar_rappel()
{
	if (j$("#cmbrappel").val()=='NO')
	{
		j$("#txtvalor_rappel").val('')
	}
}

</script> 
<script language="javascript" src="Funciones_Ajax.js"></script>


</head>
<body topmargin="0">

<div class="wrapper">
        <!--#include file="Menu_Hamburguesa.asp"-->

        <!-- Page Content Holder -->
        <div id="content">
			<button type="button" id="sidebarCollapse" class="navbar-btn active">
				<span></span>
				<span></span>
				<span></span>
			</button>


			<!--********************************************
			contenido de la pagina
			****************************-->
			<div class="container-fluid">
			
				<h1 align="center">Art&iacute;culo</h1>
				<div class="panel panel-default">
				  <div class="panel-body">
				  	<form name="frmdatos_articulo" id="frmdatos_articulo" method="post" action="Guardar_Articulos_Admin.asp">
						<input type="hidden" name="ocultoarticulo" id="ocultoarticulo" value="<%=articulo_seleccionado%>" />
						<input type="hidden" name="ocultoaccion" id="ocultoaccion" value="<%=accion_seleccionada%>" />
						<input type="hidden" name="oculto_cambio_compromiso_compra" id="oculto_cambio_compromiso_compra" value="N" />
						<input type="hidden" name="oculto_pestanna_vuelta" id="oculto_pestanna_vuelta" value="" />
									
						<div class="form-group row mx-2">
							<div class="col-sm-3 col-md-3 col-lg-3">
								<label for="txtcodigo_sap" class="control-label">Referencia</label>
								<input type="text" class="form-control" name="txtcodigo_sap" id="txtcodigo_sap" value="<%=campo_codigo_sap%>"/>
							</div>
							<div class="col-sm-9 col-md-9 col-lg-9">
								<label for="txtdescripcion" class="control-label">Descripci&oacute;n</label>
								<input type="text" class="form-control" name="txtdescripcion" id="txtdescripcion" value="<%=campo_descripcion%>"/>
							</div>
						</div>					
					
						
						<div class="form-group col-sm-12 col-md-12 col-lg-12 mx-1 h-100">
							
								<!--pestannas-->
								<main>
									  <input class="pestannas" id="tab1" type="radio" name="tabs" checked>
									  <label for="tab1" class="pestannas"
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover"
												data-content="Datos Generales"
												>General</label>
										  <input class="pestannas" id="tab2" type="radio" name="tabs">
										  <label for="tab2" class="pestannas" id="label2"
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover"
													data-content="Empresas Asociadas"
													>Empresas</label>
										<input class="pestannas" id="tab3" type="radio" name="tabs">
										<label for="tab3" class="pestannas">Entradas/Salidas</label>
										<input class="pestannas" id="tab4" type="radio" name="tabs">
									  	<label for="tab4" class="pestannas"
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover"
												data-content="Cantidades y Precios"
												>Cantidades/Precios</label>
												
<!--***********PESTAÑA INFORMACION GENERAL ********************************-->									
								  <section id="content1" class="contenido_pestannas">
								  		<div class="form-group row h-100">
											<div class="col-3 my-auto">
												<div class="mx-auto text-center">
													<span>
													<%if articulo_seleccionado&""<>"" and articulo_seleccionado&""<>"0" then%>
														<%if empresas_barcelo>0 then
															carpeta_marca="BARCELO/"
															marca="BARCELÓ"
														  else
															carpeta_marca=""
															marca="STANDARD"
														  end if
														%>
														<a href="Imagenes_Articulos/<%=carpeta_marca%><%=articulo_seleccionado%>.jpg" target="_blank" id="imagen_enlace">
															<img class="img-responsive" src="Imagenes_Articulos/<%=carpeta_marca%>Miniaturas/i_<%=articulo_seleccionado%>.jpg" border="0" id="imagen_articulo"></a>
													<%end if%>
													</span>
												</div>	
											</div>
											
											<div class="col-9">
												<div class="form-group row mx-1">
													<div class="col-sm-4 col-md-4 col-lg-4">
														<label for="txttamanno" class="control-label">Tamaño</label>
														<input type="text" class="form-control" name="txttamanno" id="txttamanno" value="<%=campo_tamanno%>"/>
													</div>
													<div class="col-sm-4 col-md-4 col-lg-4">
														<label for="txttamanno_abierto" class="control-label">Tamaño Abierto</label>
														<input type="text" class="form-control" name="txttamanno_abierto" id="txttamanno_abierto" value="<%=campo_tamanno_abierto%>"/>
													</div>
													<div class="col-sm-4 col-md-4 col-lg-4">
														<label for="txttamanno_cerrado" class="control-label">Tamaño Cerrado</label>
														<input type="text" class="form-control" name="txttamanno_cerrado" id="txttamanno_cerrado" value="<%=campo_tamanno_cerrado%>"/>
													</div>
												</div>
												<div class="form-group row mx-1">
													<div class="col-sm-4 col-md-4 col-lg-4">
														<label for="txtpapel" class="control-label">Papel</label>
														<input type="text" class="form-control" name="txtpapel" id="txtpapel" value="<%=campo_papel%>"/>
													</div>
													<div class="col-sm-4 col-md-4 col-lg-4">
														<label for="txttintas" class="control-label">Tintas</label>
														<input type="text" class="form-control" name="txttintas" id="txttintas" value="<%=campo_tintas%>"/>
													</div>
													<div class="col-sm-4 col-md-4 col-lg-4">
														<label for="txtmaterial" class="control-label">Material</label>
														<input type="text" class="form-control" name="txtmaterial" id="txtmaterial" value="<%=campo_material%>"/>
													</div>
												</div>
												<div class="form-group row mx-1">
													<div class="col-sm-12 col-md-12 col-lg-12">
														<label for="txtacabado" class="control-label">Acabado</label>
														<textarea class="form-control" rows="4" name="txtacabado" id="txtacabado"><%=campo_acabado%></textarea>
													</div>
												</div>
											</div>
										</div>	
										<div class="form-group row mx-1">
											<div class="col-sm-4 col-md-4 col-lg-4">
												<label for="txtunidades_pedido" class="control-label">Unidades de Pedido</label>
												<input type="text" class="form-control" name="txtunidades_pedido" id="txtunidades_pedido" value="<%=campo_unidades_pedido%>"/>
											</div>
											<div class="col-sm-4 col-md-4 col-lg-4">
												<label for="txtpacking" class="control-label">Packing</label>
												<input type="text" class="form-control" name="txtpacking" id="txtpacking" value="<%=campo_packing%>"/>
											</div>
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="txtfecha" class="control-label">Fecha</label>
												<input type="text" class="form-control" name="txtfecha" id="txtfecha" value="<%=campo_fecha%>"/>
											</div>
											<div class="col-sm-2 col-md-2 col-lg-1">
												<label for="cmbmostrar" class="control-label">Mostrar</label>
												<select class="form-control"  name="cmbmostrar" id="cmbmostrar" onchange="comprobar_eliminado_mostrar()">
													<option value="" selected="selected">* Seleccione *</option>
													<option value="SI">SI</option>
													<option value="NO">NO</option>
												</select>
												<script language="JavaScript" type="text/javascript">
													document.getElementById("cmbmostrar").value='<%=campo_mostrar%>'
												</script>
											</div>
											<div class="col-sm-2 col-md-2 col-lg-1">
												<label for="cmbhoja_ruta" class="control-label"
													data-toggle="popover"
													data-placement="top"
													data-trigger="hover"
													data-content="¿Requiere Hoja de Ruta?"
													data-original-title=""
													>H. R.</label>
												<select class="form-control"  name="cmbhoja_ruta" id="cmbhoja_ruta">
													<option value="NO" selected>NO</option>
													<option value="SI">SI</option>
													
												</select>
												<script language="JavaScript" type="text/javascript">
													if ('<%=campo_hoja_ruta%>'!='')
														{
														document.getElementById("cmbhoja_ruta").value='<%=campo_hoja_ruta%>'
														}
												</script>
											</div>
										</div>
										<div class="form-group row mx-1">
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="cmbcompromiso_de_compra" class="control-label"
													data-toggle="popover"
													data-placement="top"
													data-trigger="hover"
													data-content="Compromiso de Compra"
													data-original-title=""
													>Comp. Compra</label>
												<select  class="form-control" name="cmbcompromiso_de_compra" id="cmbcompromiso_de_compra">
													<option value="" selected>* Seleccione *</option>
													<option value="SI">SI</option>
													<option value="NO">NO</option>
													<option value="TRAMOS">TRAMOS</option>
												</select>                                   	  
											  	<script language="javascript">
													document.getElementById("cmbcompromiso_de_compra").value='<%=campo_compromiso_compra%>'
												</script>
											</div>
											
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="cmbfacturable" class="control-label">Facturable</label>
												<select  class="form-control" name="cmbfacturable" id="cmbfacturable">
													<option value="SI" selected>SI</option>
													<option value="NO">NO</option>
												</select>
												<script language="JavaScript" type="text/javascript">
													if ('<%=campo_facturable%>'!='')
														{
														document.getElementById("cmbfacturable").value='<%=campo_facturable%>';
														}
												</script>
											</div>
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="cmbeliminado" class="control-label">Eliminado</label>
												<select class="form-control"  name="cmbeliminado" id="cmbeliminado" onchange="comprobar_eliminado()">
													<option value="SI" style="background-color:#FFCC00;">SI</div></option>
													<option value="NO" selected>NO</option>
												</select>
												<script language="JavaScript" type="text/javascript">
												if (('<%=articulo_seleccionado%>'!='')&&('<%=articulo_seleccionado%>'!='0'))
													document.getElementById("cmbeliminado").value='<%=campo_eliminado%>';
												</script>
											</div>
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="cmbautorizacion" class="control-label"
													data-toggle="popover"
													data-placement="top"
													data-trigger="hover"
													data-content="Requiere Autorizaci&oacute;n"
													data-original-title=""
													>Req. Aut.</label>
												<select class="form-control"  name="cmbautorizacion" id="cmbautorizacion">
													<option value="NO" selected>NO</option>
													<option value="SI">SI</option>
												</select>
											  	<%if campo_autorizacion<>"" then%>
													<script language="JavaScript" type="text/javascript">
														document.getElementById("cmbautorizacion").value='<%=campo_autorizacion%>'
													</script>
												<%end if%>
											</div>
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="cmbrappel" class="control-label">Rappel</label>
												<select class="form-control"  name="cmbrappel" id="cmbrappel" onchange="comprobar_rappel()">
													<option value="NO" selected>NO</option>
													<option value="SI">SI</option>
												</select>
												<%if campo_rappel<>"" then%>
													<script language="JavaScript" type="text/javascript">
														document.getElementById("cmbrappel").value='<%=campo_rappel%>'
													</script>
												<%end if%>
											</div>
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="txtvalor_rappel" class="control-label">Valor Rappel</label>
												<input type="text" class="form-control" name="txtvalor_rappel" id="txtvalor_rappel" value="<%=campo_valor_rappel%>"/>
											</div>
										</div>
										
										<div class="form-group row mx-1">
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="txtpeso" class="control-label">Peso (en gramos)</label>
												<input type="text" class="form-control" name="txtpeso" id="txtpeso" value="<%=campo_peso%>"/>
											</div>
											<div class="col-sm-2 col-md-2 col-lg-2">
												<label for="txtprecio_coste" class="control-label">Precio Coste</label>
												<input type="text" class="form-control" name="txtprecio_coste" id="txtprecio_coste" value="<%=campo_precio_coste%>"/>
											</div>
											<div class="col-sm-4 col-md-4 col-lg-4">
												<label for="cmbproveedores" class="control-label">Proveedor</label>
												<select class="form-control" name="cmbproveedores" id="cmbproveedores">
													<option value="" selected="selected">* Seleccione *</option>
													<%if vacio_proveedores=false then %>
														<%for i=0 to UBound(mitabla_proveedores,2)%>
															<option value="<%=mitabla_proveedores(CAMPO_ID_PROVEEDOR,i)%>"><%=mitabla_proveedores(CAMPO_DESCRIPCION_PROVEEDOR,i)%></option>
														<%next%>											
													<%end if%>
												</select>
												<script language="JavaScript" type="text/javascript">
													document.getElementById("cmbproveedores").value='<%=campo_proveedor%>'
												</script>
											</div>
											<div class="col-sm-4 col-md-4 col-lg-4">
												<label for="txtreferencia_del_proveedor" class="control-label" title="Referencia del Proveedor">Referencia Prov.</label>
												<input type="text" class="form-control" name="txtreferencia_del_proveedor" id="txtreferencia_del_proveedor" value="<%=campo_referencia_del_proveedor%>"/>
											</div>
										</div>
										
										<%if campo_solicitado_al_proveedor="SI" then%>
											<div class="form-group row mx-1">		
												<div class="col-12">
													<div class="alert alert-warning" role="alert" align="center">
														Art&iacute;culo Solicitado al Proveedor...
													</div>
												</div>
											</div>
										<%end if%>
										
														
								  </section>
									
<!--***********PESTAÑA EMPRESAS ASOCIADAS ********************************-->																	


								  <section id="content2" class="contenido_pestannas">
								  	<div class="form-group row mx-1">
										<div class="col-sm-12 col-md-10 col-lg-10 mx-auto">
										<table class="table table-striped table-bordered">
											<thead>
												<tr>
													<th scope="col">Empresa</th>
													<th scope="col">Familia</th>
												</tr>
											</thead>
											<tbody>
												<%if vacio_empresas=false then %>
													<%for i=0 to UBound(mitabla_empresas,2)%>
														<tr>
															<td>
																<div class="custom-control custom-checkbox">
																	<input type="checkbox" class="custom-control-input" name="rbempresas_<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>" id="rbempresas_<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>" onclick="mostrar_cmbempresa(this.name)">
																  	<label class="custom-control-label" for="rbempresas_<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>"><%=mitabla_empresas(CAMPO_EMPRESA_EMPRESA,i)%></label>
																</div>
																
															</td>
															<td>
																
																<select class="form-control cmbempresas_familias"  name="cmbfamilias_<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>" id="cmbfamilias_<%=mitabla_empresas(CAMPO_ID_EMPRESA,i)%>" style="display:none ">
																	<%
																	filtro = "codigo_empresa=" & mitabla_empresas(CAMPO_ID_EMPRESA,i)
																	familias.Filter = filtro
																	%>
																	<option value="" selected>* Seleccione *</option>
																	<%while not familias.eof%>
																		<option value="<%=cint(familias("ID"))%>"><%=familias("DESCRIPCION")%></option>
																		<%familias.movenext
																	wend%>
																</select>
																
															
															</td>
														</tr>
													<%next%>
												<%end if%>
											</tbody>
										</table>
										</div>
									</div>
								  
								  	
								  
														
								  </section>
									
									
									
<!--***********PESTAÑA ENTRADAS - SALIDAS ********************************-->										
								
								   <section id="content3" class="contenido_pestannas">
								   		<div class="form-group row mx-1"  id="capa_marcas_stocks">
													<div class="row mx-1">
														<div class="col-3">
															<label for="txtstock" class="control-label">Stock</label>
															<input type="text" class="form-control" name="txtstock" id="txtstock" value="<%=campo_stock%>" readonly style="font-size:24px "/>
														</div>
														<div class="col-4">
															<label for="txtstock_minimo" class="control-label">Stock Mínimo</label>
															<input type="text" class="form-control" name="txtstock_minimo" id="txtstock_minimo" value="<%=campo_stock_minimo%>"/>
														</div>
													</div>
										</div>
										
										
								   
								   		<div class="form-group row mx-2">
											 <div class="card col-12">
												<div class="card-body">
													<h5 class="card-title">Entradas</h5>
													<div class="form-group row mx-1">
														<table id="lista_entradas" name="lista_entradas" class="table table-striped table-bordered compact" cellspacing="0" width="99%">
														  <thead>
															<tr>
															  <th>Fecha</th>
															  <th>Cantidad</th>
															  <th>Albar&aacute;n</th>
															  <th>Tipo</th>
															  <th></th>
															</tr>
														  </thead>
														</table>
													</div> 
													<div class="form-group row mx-1">
																<input type="hidden" value="" name="ocultoid_entrada" id="ocultoid_entrada" />
																<div class="col-sm-3 col-md-3 col-lg-3">
																	<label for="txtfecha_entrada" class="control-label">Fecha Entrada</label>
																	<input type="date" class="form-control" name="txtfecha_entrada" id="txtfecha_entrada"  value="" /> 
																</div>
																<div class="col-sm-2 col-md-2 col-lg-2">
																	<label for="txtcantidad_entrada" class="control-label">Cantidad</label>
																	<input type="text" class="form-control" name="txtcantidad_entrada" id="txtcantidad_entrada" value=""/>
																</div>
																<div class="col-sm-2 col-md-2 col-lg-2">
																	<label for="txtalbaran" class="control-label">Albar&aacute;n</label>
																	<input type="text" class="form-control" name="txtalbaran_entrada" id="txtalbaran_entrada" value=""/>
																</div>
																<div class="col-sm-3 col-md-3 col-lg-3">
																	<label for="cmbtipo_entrada" class="control-label">Tipo Entrada</label>
																	<select class="form-control"  name="cmbtipo_entrada" id="cmbtipo_entrada">
																		<option value="">Seleccionar...</option>
																		<option value="APROVISIONAMIENTO">APROVISIONAMIENTO</option>
																		<option value="DEVOLUCION">DEVOLUCI&Oacute;N</option>
																		<option value="AJUSTE">AJUSTE</option>
																	</select>
																</div>
																<div class="col-sm-2 col-md-2 col-lg-2">
																	<label for="cmdguardar_entrada" class="control-label">&nbsp;&nbsp;</label>
																	<button type="button" class="btn btn-primary btn-block" id="cmdguardar_entradas" name="cmdguardar_entradas"
																		data-toggle="popover"
																		data-placement="bottom"
																		data-trigger="hover"
																		data-content="Guardar Entrada de Material"
																		data-original-title=""
																		>
																		<i class="far fa-save fa-lg"></i> Guardar
																	</button>
																	
																</div>
													</div>	
															   
												</div>
											</div>


											<div class="card col-12 mt-2">
												<div class="card-body">
													<h5 class="card-title">Salidas</h5>
													<div class="form-group row mx-1">
														<table id="lista_salidas" name="lista_salidas" class="table table-striped table-bordered compact" cellspacing="0" width="99%">
														  <thead>
															<tr>
															  <th>Fecha</th>
															  <th>Cantidad</th>
															  <th>Tipo</th>
															  <th>Pedido</th>
															</tr>
														  </thead>
														</table>
													</div> 
													<div class="form-group row mx-1">
																<input type="hidden" value="" name="ocultoid_salida" id="ocultoid_salida" />
																<div class="col-sm-3 col-md-3 col-lg-3">
																	<label for="txtfecha_salida" class="control-label">Fecha Salida</label>
																	<input type="date" class="form-control" name="txtfecha_salida" id="txtfecha_salida"  value="" /> 
																</div>
																<div class="col-sm-3 col-md-3 col-lg-3">
																	<label for="txtcantidad_salida" class="control-label">Cantidad</label>
																	<input type="text" class="form-control" name="txtcantidad_salida" id="txtcantidad_salida" value=""/>
																</div>
																<div class="col-sm-3 col-md-3 col-lg-3">
																	<label for="cmbtipo_salida" class="control-label">Tipo Salida</label>
																	<select class="form-control"  name="cmbtipo_salida" id="cmbtipo_salida">
																		<option value="">Seleccionar...</option>
																		<option value="CAMBIO">CAMBIO</option>
																		<option value="AJUSTE">AJUSTE</option>
																	</select>
																</div>
																<div class="col-sm-2 col-md-2 col-lg-2">
																	<label for="cmdguardar_salida" class="control-label">&nbsp;&nbsp;</label>
																	<button type="button" 
																			class="btn btn-primary btn-block" 
																			id="cmdguardar_salidas" 
																			name="cmdguardar_salidas"
																			data-toggle="popover"
																			data-container="body" 
																			data-placement="bottom"
																			data-trigger="hover"
																			data-content="Guardar Salida de Material"
																			>
																		<i class="far fa-save fa-lg"></i> Guardar
																	</button>
																</div>
													</div>	
															   
												</div><!--card body-->
											</div><!--card-->
										</div>
									 
								  </section>

<!--***********PESTAÑA CANTIDADES / PRECIOS ********************************-->											
								   <section id="content4" class="contenido_pestannas">
										<div class="col-12" id="capa_cantidades_precios_externa" name="capa_cantidades_precios_externa"></div>
								   </section>
								  
								  
								  
<!--*********** FINAL DE LAS PESTAÑAS ********************************-->										  
								  
								  
								</main><!--final de las pestañas-->
								
								
								
						</div><!--del row col-sm-12-->			
						
						<div class="col-12">
							<button type="button" class="btn btn-primary btn-block btn-lg" id="cmdguardar_articulo" name="cmdguardar_articulo"
								data-toggle="popover"
								data-placement="bottom"
								data-trigger="hover"
								data-content="Guardar Art&iacute;culo"
								data-original-title=""
								>
								<i class="far fa-save fa-2x"></i>&nbsp;&nbsp;&nbsp;Guardar Art&iacute;culo
							</button>
						</div>
							
					</form>
				
				  </div><!--PANEL BODY-->
				</div><!--PANEL-->
					
				
				
            </div>
			<!-- /container fluid -->
            
            
        </div><!--fin de content-->
    </div><!--fin de wrapper-->



    
													
	
	
	





<script type="text/javascript" src="js/comun.js"></script>


<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>
    

<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>


<script type="text/javascript" src="plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>


<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/2.5.0/jszip.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/autofill/2.2.2/js/dataTables.autoFill.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/autofill/2.2.2/js/autoFill.bootstrap4.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.bootstrap4.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.colVis.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.flash.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.print.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/colreorder/1.4.1/js/dataTables.colReorder.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/fixedcolumns/3.2.4/js/dataTables.fixedColumns.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/fixedheader/3.1.3/js/dataTables.fixedHeader.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/keytable/2.3.2/js/dataTables.keyTable.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.1/js/dataTables.responsive.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.1/js/responsive.bootstrap4.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/rowgroup/1.0.2/js/dataTables.rowGroup.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/rowreorder/1.2.3/js/dataTables.rowReorder.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/scroller/1.4.4/js/dataTables.scroller.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/select/1.2.5/js/dataTables.select.min.js"></script>

  
<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script>  
  
<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>

<script language="javascript">



</script>


	<script language="javascript">
var j$=jQuery.noConflict();

  

j$(document).ready(function () {
	//para que se configuren los popover-titles...
	j$('[data-toggle="popover"]').popover({html:true, container: 'body'});
	//j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});


	j$("#menu_articulos").addClass('active')
	j$('#sidebarCollapse').on('click', function () {
    	j$('#sidebar').toggleClass('active');
		j$(this).toggleClass('active');
     });
  
	<%if pestanna_vuelta_seleccionada<>"" then%>  
  		j$("#<%=pestanna_vuelta_seleccionada%>").click()
	<%end if%>		
});



  

  
//para solicitar los articulos
mostrar_cmbempresa = function(elemento) {
	valor=elemento.split('_')
	
	//si esta marcado mostramos el combo y si no, lo ocultamos
	if (j$("#" + elemento).prop('checked'))
		{
		j$("#cmbfamilias_" + valor[1]).show()
		}
	  else
	  	{
		j$("#cmbfamilias_" + valor[1]).val('')
		j$("#cmbfamilias_" + valor[1]).hide()
		}
	  	
	
	
};
 

refrescar_entrada = function() {
	j$("#ocultoid_entrada").val('')
	j$("#txtfecha_entrada").val('')
	j$("#txtcantidad_entrada").val('')
	j$("#txtalbaran_entrada").val('')
	j$("#cmbtipo_entrada").val('')
	cargar_entradas();
};	
  
refrescar_salida = function() {
	j$("#ocultoid_salida").val('')
	j$("#txtfecha_salida").val('')
	j$("#txtcantidad_salida").val('')
	j$("#cmbtipo_salida").val('')
	cargar_salidas();
};	
  
refrescar_stock = function() {
	j$.ajax({
		type: "post",        
    	url: 'Obtener_Stock_Ficha_Articulo.asp?q=<%=articulo_seleccionado%>',
	    success: function(respuesta) {
					  //console.log('el stock es de: ' + respuesta)
					  j$("#txtstock").val(respuesta)
					},
    	error: function() {
    			bootbox.alert({
					message: "Se ha producido un error al intentar mostrar el stock actualizado",
					//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
					callback: refrescar_stock()
				})
    		}
  	});
	
	
};	  


 
borrar_entrada = function(id, cantidad, fecha, albaran, tipo, id_articulo) {
	j$.ajax({
		type: "post",        
    	url: 'Borrar_Entradas_Salidas_Articulos.asp?q=' + id 
					+ '&cantidad=' + cantidad 
					+ '&entrada_salida=ENTRADA'
					+ '&fecha=' + fecha
					+ '&albaran=' + albaran
					+ '&tipo=' + tipo
					+ '&id_articulo=' + id_articulo
					,
	    success: function(respuesta) {
					  bootbox.alert({
							message: "Entrada Borrada Correctamente",
							//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
							callback: refrescar_stock()
						})
					},
    	error: function() {
    			bootbox.alert({
					message: "Se ha producido un error al intentar borrar la entrada seleccionada",
					//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
					callback: refrescar_stock()
				})
    		}
  	});
	
	
};	 

 

j$("#cmdguardar_articulo").click(function () {
	comprobar_articulo() 
	

});

j$("#cmdguardar_entradas").click(function () {
	cadena_url='Guardar_Entradas_Salidas_Articulos.asp'
	cadena_url=cadena_url + '?id=' + j$("#ocultoid_entrada").val()
	cadena_url=cadena_url + '&id_articulo=<%=articulo_seleccionado%>'
	cadena_url=cadena_url + '&entrada_salida=ENTRADA'
	cadena_url=cadena_url + '&fecha=' + j$("#txtfecha_entrada").val()
	cadena_url=cadena_url + '&cantidad=' + j$("#txtcantidad_entrada").val()
	cadena_url=cadena_url + '&albaran=' + j$("#txtalbaran_entrada").val()
	cadena_url=cadena_url + '&tipo=' + j$("#cmbtipo_entrada").val()
	
	
	cadena_error=''
	
	if (j$("#txtfecha_entrada").val()=='')
		{
		cadena_error=cadena_error + '- Se Ha De Seleccionar Una Fecha de Entrada.<br>'
		}
	if (j$("#txtcantidad_entrada").val()=='')
		{
		cadena_error=cadena_error + '- Se Ha De Introducir una Cantidad de Material de Entrada.<br>'
		}
	/*el albaran no es obligatorio
	if (j$("#txtalbaran_entrada").val()=='')
		{
		cadena_error=cadena_error + '- Se Ha De Indicar un Albar&aacute;n de Entrada de Material.<br>'
		}
	*/
	if (j$("#cmbtipo_entrada").val()=='')
		{
		cadena_error=cadena_error + '- Se Ha De Seleccionar Un Tipo de Entrada.<br>'
		}
	
	
	
	
	
	if (cadena_error=='')
		{
		//console.log('cadena url: ' + cadena_url)	
		mostrar_capa(cadena_url,'capa_para_ajax', 'ENTRADAS')          
		bootbox.alert({
			message: "Entrada Guardada Correctamente",
			//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
			callback: refrescar_stock()
		})
		
		}
	  else
	  	{
		bootbox.alert({
			size: 'large',
			message: '<h4><p><i class="fas fa-exclamation-circle" style="color:red"></i> Se Han Encontrado Los Siguientes Errores...</p></h4><br><br>' + cadena_error + '<br>'
			//callback: refrescar_entrada()
		})
		}
});

j$("#cmdguardar_salidas").click(function () {
	cadena_url='Guardar_Entradas_Salidas_Articulos.asp'
	cadena_url=cadena_url + '?id=' + j$("#ocultoid_salida").val()
	cadena_url=cadena_url + '&id_articulo=<%=articulo_seleccionado%>'
	cadena_url=cadena_url + '&entrada_salida=SALIDA'
	cadena_url=cadena_url + '&fecha=' + j$("#txtfecha_salida").val()
	cadena_url=cadena_url + '&cantidad=' + j$("#txtcantidad_salida").val()
	cadena_url=cadena_url + '&tipo=' + j$("#cmbtipo_salida").val()
	
	cadena_error=''
	
	if (j$("#txtfecha_salida").val()=='')
		{
		cadena_error=cadena_error + '- Se Ha De Seleccionar Una Fecha de Salida.<br>'
		}
	if (j$("#txtcantidad_salida").val()=='')
		{
		cadena_error=cadena_error + '- Se Ha De Introducir una Cantidad de Material de Salida.<br>'
		}
	  else
	  	{
		if (parseFloat(j$("#txtcantidad_salida").val())>parseFloat(j$("#txtstock").val()))
			{
			cantidades=j$("#txtstock").val()
			if (j$("#txtstock").val()=='')
				{
				cantidades='(null)'
				}
			cadena_error=cadena_error + '- No Se Puede Dar Salida a un Cantidad Superior a ' + cantidades + ', que es el Stock Actual.<br>'
			}
		}
	if (j$("#cmbtipo_salida").val()=='')
		{
		cadena_error=cadena_error + '- Se Ha De Seleccionar Un Tipo de Salida.<br>'
		}
	
	if (cadena_error=='')
		{
		//console.log('cadena url: ' + cadena_url)	
		mostrar_capa(cadena_url,'capa_para_ajax', 'SALIDAS')          
		bootbox.alert({
			message: "Salida Guardada Correctamente",
			//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
			callback: refrescar_stock()
		})
		}
	  else
	  	{
		bootbox.alert({
			size: 'large',
			message: '<h4><p><i class="fas fa-exclamation-circle" style="color:red"></i> Se Han Encontrado Los Siguientes Errores...</p></h4><br><br>' + cadena_error + '<br>'
			//callback: refrescar_entrada()
		})
		}
	
});

//se pulsa la pestaña de entradas/salidas de material
j$("#tab3").click(function () {
	
	cargar_entradas()
	cargar_salidas()

});

//se pulsa la pestaña de cantidades/precios
j$("#tab4").click(function(){

	j$("#capa_cantidades_precios_externa").html('<iframe id="iframe_cantidades_precios" src="Obtener_Cantidades_Precios_Articulo.asp?id_articulo=<%=articulo_seleccionado%>&compromiso_compra=<%=campo_compromiso_compra%>" width="100%" frameborder="0" transparency="transparency" onload="redimensionar_iframe()" scrolling="no"></iframe>');
					
	
	/*
	j$.post("Obtener_Cantidades_Precios_Articulo.asp", {id_articulo: "<%=articulo_seleccionado%>", compromiso_compra: "<%=campo_compromiso_compra%>"}, function(htmlexterno){
			j$("#capa_cantidades_precios_externa").html(htmlexterno);
	});
	*/
	
});

redimensionar_iframe = function() {
//console.log('dentro de redimensionar iframe')
 var cont = j$('#iframe_cantidades_precios').contents().find("body").height() 
 j$('#iframe_cantidades_precios').css('height', (cont + 5)  + "px");
 
 //console.log('tamaño iframe: ' + cont)
 
  }; 

  
calcDataTableHeight = function() {
    return j$(window).height()*55/100;
  }; 

cargar_entradas = function() {  
      var err ="";
		
		//no hay control de errores por filtros no rellenados
		var prm=new ajaxPrm();
        /*
		console.log('pir: ' + j$('#txtpir').val())
		console.log('estado: ' + j$('#cmbestados').val())
		console.log('expedicion: ' + j$('#txtexpedicion').val())
		console.log('fecha inicio orden: ' + j$('#txtfecha_inicio_orden').val())
		console.log('fecha fin orden: ' + j$('#txtfecha_fin_orden').val())
		console.log('fecha inicio envio: ' + j$('#txtfecha_inicio_envio').val())
		console.log('fecha fin envio: ' + j$('#txtfecha_fin_envio').val())
		console.log('fecha inicio entrega: ' + j$('#txtfecha_inicio_entrega').val())
		console.log('fecha fin entrega: ' + j$('#txtfecha_fin_entrega').val())
		*/
		
		
		
		
		/*
		prm.add("p_pir", j$('#txtpir').val());
        prm.add("p_estado", j$('#cmbestados').val());
		prm.add("p_compannia", j$('#cmbcompannias').val());
		prm.add("p_proveedor", j$('#cmbproveedores').val());
		prm.add("p_expedicion", j$('#txtexpedicion').val());
		prm.add("p_fecha_inicio_orden", j$('#txtfecha_inicio_orden').val());
		prm.add("p_fecha_fin_orden", j$('#txtfecha_fin_orden').val());
		prm.add("p_fecha_inicio_envio", j$('#txtfecha_inicio_envio').val());
		prm.add("p_fecha_fin_envio", j$('#txtfecha_fin_envio').val());
		prm.add("p_fecha_inicio_entrega", j$('#txtfecha_inicio_entrega').val());
		prm.add("p_fecha_fin_entrega", j$('#txtfecha_fin_entrega').val());
		*/
        
		prm.add("p_id_articulo", <%=articulo_seleccionado%>);
        prm.add("p_entrada_salida", 'ENTRADA');
		
		j$.fn.dataTable.moment("DD/MM/YYYY HH:mm:ss");
        
        //deseleccioamos el registro de la lista
        j$('#lista_entradas tbody tr').removeClass('selected');
        
        if (typeof lst_entradas== "undefined") {
            lst_entradas = j$("#lista_entradas").DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:"tojson/obtener_entradas_salidas_articulo.asp?"+prm.toString(),
                                                           type:"POST",
                                                           dataSrc:"ROWSET"},
                                                     columnDefs: [
                                                              //{className: "dt-right", targets: [4,5,6,7]}
                                                            ],
                                                     /*
													 columnDefs: [
                                                              {className: "dt-right", targets: [4,5,6,7]},
                                                              {className: "dt-center", targets: [4]}                                                            
                                                            ],
													*/
													 //order:[[ 0, "desc" ]],
													 order:[],
													 columns:[ 	//ejemplo de columna vacia
													 			/*
																{data: function (row, type, set) {
																	return '';
																}},
																*/
													 			{data:"FECHA"},
																{data:"CANTIDAD"},
															  	{data:"ALBARAN"},
																{data:"TIPO"},
																{data: function (row, type, set) {
																			//var salida = '';
																			//for (var p in row) {
																			//	 salida = p + ': ' + row[p] + '\n';
																			//	 console.log(salida);
																			//}
																	return '<i class="fas fa-trash" style="color:red"'
																				+ ' data-toggle="popover_datatable"'
																				+ ' data-container="body"'
																				+ ' data-placement="right"'
																				+ ' data-trigger="hover"'
																				+ ' data-content="Eliminar Entrada"'
																				+ ' onclick="borrar_entrada(' + row.ID 
																						+ ', ' + row.CANTIDAD 
																						+ ', \'' + row.FECHA + '\''
																						+ ', \'' + row.ALBARAN + '\''
																						+ ', \'' + row.TIPO + '\''
																						+ ', ' + row.ID_ARTICULO + ')"></i>';
																	}},
																{data:"ID", visible:false},
																{data:"ID_ARTICULO", visible:false},
																{data:"DESCRIPCION_ART", visible:false},
																{data:"REFERENCIA", visible:false}
                                                            ],
													 rowId: 'extn', //para que se refresque sin perder filtros ni ordenacion
                                                     deferRender:true,
    //  Scroller
                                                     scrollY:calcDataTableHeight() - (calcDataTableHeight()/2) - 50,
                                                     scrollCollapse:true,
                                                   // scrollX:true,
    //  Fin Scroller
    /*
                                                     tableTools:{ sRowSelect: "single",
                                                                  sSwfPath:"/v2/plugins/dataTable/extensions/TableTools/swf/copy_csv_xls_pdf.swf",
                                                                             aButtons:[{sExtends:"copy", sButtonText:"Copiar", sToolTip:"Copiar en Portapapeles", oSelectorOpts: {filter: "applied", order: "current"}, mColumns:[0,1,2,3,4,5,6,7]},
                                                                                       {sExtends:"xls", sButtonText:"Excel", sToolTip:"Exportar a Formato CSV", sFileName:"Trabajadores_Externos.xls", oSelectorOpts: {filter: "applied", order: "current"}, mColumns:[0,1,2,3,4,5,6,7]},
                                                                                       {sExtends:"pdf", sButtonText:"PDF", sPdfOrientation:"landscape", sToolTip:"Exportar a Formato PDF", sFileName:"Trabajadores_Externos.pdf", sTitle:" ", oSelectorOpts: {filter: "applied", order: "current"}, mColumns:[0,1,2,3,4,5,6,7]},
                                                                                       {sExtends:"print", sButtonText:"Imprimir", sToolTip:"Vista Preliminar", sInfo:"<h6>Vista Previa</h6><p>Por favor use la funci&oacute;n de u navegador para imprimir [CRTL + P]. Pulse Escape cuando finalice.</p>"}]},         
    */                                               
                                                   buttons:[{extend:"copy", text:'<i class="far fa-copy"></i>', titleAttr:"Copiar en Portapapeles", title:"Entradas_Articulo_<%=campo_codigo_sap%>",
												   							exportOptions:{columns:[0,1,2,3,6,7,8],
																							format: {
																									//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
																									header: function ( data, columnIdx ) {
																											switch(columnIdx) {
																												case 6:
																													return 'Codigo Articulo';
																													break;
																												case 7:
																													return 'Descripcion Articulo';
																													break;
																												case 8:
																													return 'Referencia Articulo';
																													break;
																												default:
																													return data;
																												}
																										}
																									}
																			
																			
																			
																			}
																		
																		
																		}, 
                                                             {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Entradas_Articulo_<%=campo_codigo_sap%>", extension:".xls", 
															 				exportOptions:{columns:[0,1,2,3,6,7,8],
																							format: {
																									//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
																									header: function ( data, columnIdx ) {
																											switch(columnIdx) {
																												case 6:
																													return 'Codigo Articulo';
																													break;
																												case 7:
																													return 'Descripcion Articulo';
																													break;
																												case 8:
																													return 'Referencia Articulo';
																													break;
																												default:
																													return data;
																												}
																										}
																									}
																			
																			}
																			
																		}, 
                                                             {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Entradas_Articulo_<%=campo_codigo_sap%>", orientation:"landscape", 
															 				exportOptions:{columns:[0,1,2,3,6,7,8],
																							format: {
																									//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
																									header: function ( data, columnIdx ) {
																											switch(columnIdx) {
																												case 6:
																													return 'Codigo Articulo';
																													break;
																												case 7:
																													return 'Descripcion Articulo';
																													break;
																												case 8:
																													return 'Referencia Articulo';
																													break;
																												default:
																													return data;
																												}
																										}
																									}

																			}
																		}, 
                                                             {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Entradas_Articulo_<%=campo_codigo_sap%>", 
															 				exportOptions:{columns:[0,1,2,3,6,7,8],
																							format: {
																									//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
																									header: function ( data, columnIdx ) {
																											switch(columnIdx) {
																												case 6:
																													return 'Codigo Articulo';
																													break;
																												case 7:
																													return 'Descripcion Articulo';
																													break;
																												case 8:
																													return 'Referencia Articulo';
																													break;
																												default:
																													return data;
																												}
																										}
																									}
																			
																			
																			}
																		}
															],
                                                 
													createdRow:function (row, data, index) {
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
																  //j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
                                                                },
													rowCallback:function (row, data, index) {
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
																  //j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
                                                                },
													drawCallback: function () {
															//para que se configuren los popover-titles...
															//j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
														},
                                                    //initComplete: stf.initComplete,                                                            
                                                     language:{url:"plugins/dataTable/lang/Spanish.json"},
                                                     paging:false,
                                                     processing: true,
                                                     searching:true,
													 responsive:true
													 
                                                    });
               	
				j$("#lista_entradas").on("xhr.dt", function() {     
					/*
					var str='<div><a href="#" class="btn btn-primary" onclick="solicitar_articulos()"'
									+ ' data-toggle="popover_datatable"'
									+ ' data-placement="right"'
									+ ' data-trigger="hover"'
									+ ' data-content="Solicitar Art&iacute;culos a Los Proveedores"'
									+ ' data-original-title=""'
									+ '><i class="far fa-list-alt fa-lg"></i>&nbsp;&nbsp;Solicitar Art&iacute;culos</a></div>';
					j$("div.toolbar").html(str);
					*/
					
					/*
					j$("#tb_servicios_ele .dataTables_scrollBody").scroll(function() {
					  j$("#tb_servicios_ele .dataTables_scrollHead").scrollLeft(j$("#tb_servicios_ele .dataTables_scrollBody").scrollLeft());
					});    
					*/
					//
					j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
			   	})
				
				 //controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_entradas tbody").on("click","tr", function() {  
                  if (!j$(this).hasClass("selected") ) {                  
                    //lst_refs.$("tr.selected").removeClass("selected");
                    //j$(this).addClass("selected");
                    
					
					/* mostramos el historico en el click del icono de la maleta
					var table = j$('#lista_pirs').DataTable();
                    row_sel = table.row( this ).data();
					
					j$("#cabecera_pantalla_avisos").html("<h3>Hist&oacute;rico del PIR " + row_sel.PIR + "</h3>")
					j$("#body_avisos").html('<iframe id="iframe_historico_pir" src="Detalle_Historico_Pir.asp?id_pir=' + row_sel.ID + '&pir=' + row_sel.PIR + '" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe>');
					j$("#pantalla_avisos").modal("show");
					*/
                  } 
                  //console.log(row_sel);
					
				  
                });

				//gestiona el dobleclick sobre la fila para mostrar la pantalla de detalle del pir
				j$("#lista_entradas").on("dblclick", "tr", function(e) {
				  var row=lst_refs.row(j$(this).closest("tr")).data() 
				  parametro_id=row.ID
				  
				  j$(this).addClass('selected');
				  
				  //mostrar_articulo(parametro_id)
				});              
				
				
                /*  
          			j$("#stf\\\.lista_tra").on("init.dt", function() {
                    console.log("init.dt"); 
          			});
                
                j$("#stf\\\.lista_tra").on( 'draw.dt', function () {
                    console.log( 'Table redrawn' );
                } );
                */                                                                
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_entradas.ajax.url("tojson/obtener_entradas_salidas_articulo.asp?"+prm.toString());
              lst_entradas.ajax.reload();                  
            }       
      
      
    
	lst_entradas.on( 'buttons-action', function ( e, buttonApi, dataTable, node, config ) {
					//console.log( 'Button '+ buttonApi.text()+' was activated' );
					
				} );

  };


cargar_salidas = function() {  
      var err ="";
		
		//no hay control de errores por filtros no rellenados
		var prm=new ajaxPrm();
        /*
		console.log('pir: ' + j$('#txtpir').val())
		console.log('estado: ' + j$('#cmbestados').val())
		console.log('expedicion: ' + j$('#txtexpedicion').val())
		console.log('fecha inicio orden: ' + j$('#txtfecha_inicio_orden').val())
		console.log('fecha fin orden: ' + j$('#txtfecha_fin_orden').val())
		console.log('fecha inicio envio: ' + j$('#txtfecha_inicio_envio').val())
		console.log('fecha fin envio: ' + j$('#txtfecha_fin_envio').val())
		console.log('fecha inicio entrega: ' + j$('#txtfecha_inicio_entrega').val())
		console.log('fecha fin entrega: ' + j$('#txtfecha_fin_entrega').val())
		*/
		
		
		
		
		/*
		prm.add("p_pir", j$('#txtpir').val());
        prm.add("p_estado", j$('#cmbestados').val());
		prm.add("p_compannia", j$('#cmbcompannias').val());
		prm.add("p_proveedor", j$('#cmbproveedores').val());
		prm.add("p_expedicion", j$('#txtexpedicion').val());
		prm.add("p_fecha_inicio_orden", j$('#txtfecha_inicio_orden').val());
		prm.add("p_fecha_fin_orden", j$('#txtfecha_fin_orden').val());
		prm.add("p_fecha_inicio_envio", j$('#txtfecha_inicio_envio').val());
		prm.add("p_fecha_fin_envio", j$('#txtfecha_fin_envio').val());
		prm.add("p_fecha_inicio_entrega", j$('#txtfecha_inicio_entrega').val());
		prm.add("p_fecha_fin_entrega", j$('#txtfecha_fin_entrega').val());
		*/
        
		prm.add("p_id_articulo", <%=articulo_seleccionado%>);
        prm.add("p_entrada_salida", 'SALIDA');
		
        j$.fn.dataTable.moment("DD/MM/YYYY HH:mm:ss");
		//j$.fn.dataTable.moment("YYYY/MM/DD HH:mm:ss");
		//j$.fn.dataTable.moment("DD/MM/YYYY");
		
        
        //deseleccioamos el registro de la lista
        j$('#lista_salidas tbody tr').removeClass('selected');
        
        if (typeof lst_salidas== "undefined") {
            lst_salidas = j$("#lista_salidas").DataTable({dom:'<"toolbar">Blfrtip',
                                                          ajax:{url:"tojson/obtener_entradas_salidas_articulo.asp?"+prm.toString(),
                                                           type:"POST",
                                                           dataSrc:"ROWSET"},
                                                     columnDefs: [
                                                              //{className: "dt-right", targets: [4,5,6,7]}
															  //{type: 'date', targets: [0] }
                                                            ],
                                                     /*
													 columnDefs: [
                                                              {className: "dt-right", targets: [4,5,6,7]},
                                                              {className: "dt-center", targets: [4]}                                                            
                                                            ],
													*/
													 //order:[[ 0, "desc" ]],
													 order:[],
													 columns:[ 	//ejemplo de columna vacia
													 			/*
																{data: function (row, type, set) {
																	return '';
																}},
																*/
													 			//{data:"FECHA", type:"date", format: "DD/MM/YYYY HH:mm:ss"},
																{data:"FECHA"},
																{data:"CANTIDAD"},
															  	{data:"TIPO"},
																{data:"PEDIDO"},
																{data:"ID", visible:false},
																{data:"ID_ARTICULO", visible:false},
																{data:"DESCRIPCION_ART", visible:false},
																{data:"REFERENCIA", visible:false}
                                                            ],
													 rowId: 'extn', //para que se refresque sin perder filtros ni ordenacion
                                                     deferRender:true,
    //  Scroller
                                                     scrollY:calcDataTableHeight() - (calcDataTableHeight()/2) - 50,
                                                     scrollCollapse:true,
                                                   // scrollX:true,
    //  Fin Scroller
    /*
                                                     tableTools:{ sRowSelect: "single",
                                                                  sSwfPath:"/v2/plugins/dataTable/extensions/TableTools/swf/copy_csv_xls_pdf.swf",
                                                                             aButtons:[{sExtends:"copy", sButtonText:"Copiar", sToolTip:"Copiar en Portapapeles", oSelectorOpts: {filter: "applied", order: "current"}, mColumns:[0,1,2,3,4,5,6,7]},
                                                                                       {sExtends:"xls", sButtonText:"Excel", sToolTip:"Exportar a Formato CSV", sFileName:"Trabajadores_Externos.xls", oSelectorOpts: {filter: "applied", order: "current"}, mColumns:[0,1,2,3,4,5,6,7]},
                                                                                       {sExtends:"pdf", sButtonText:"PDF", sPdfOrientation:"landscape", sToolTip:"Exportar a Formato PDF", sFileName:"Trabajadores_Externos.pdf", sTitle:" ", oSelectorOpts: {filter: "applied", order: "current"}, mColumns:[0,1,2,3,4,5,6,7]},
                                                                                       {sExtends:"print", sButtonText:"Imprimir", sToolTip:"Vista Preliminar", sInfo:"<h6>Vista Previa</h6><p>Por favor use la funci&oacute;n de u navegador para imprimir [CRTL + P]. Pulse Escape cuando finalice.</p>"}]},         
    */                                               
                                                   buttons:[{extend:"copy", text:'<i class="far fa-copy"></i>', titleAttr:"Copiar en Portapapeles", title:"Salidas_Articulo_<%=campo_codigo_sap%>",
												   							exportOptions:{columns:[0,1,2,3,5,6,7],
																							format: {
																									//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
																									header: function ( data, columnIdx ) {
																											switch(columnIdx) {
																												case 5:
																													return 'Codigo Articulo';
																													break;
																												case 6:
																													return 'Descripcion Articulo';
																													break;
																												case 7:
																													return 'Referencia Articulo';
																													break;
																												default:
																													return data;
																												}
																										}
																									}
																			
																			
																			
																			}
																		
																		
																		}, 
                                                             {extend:"excelHtml5", text:'<i class="far fa-file-excel"></i>', titleAttr:"Exportar a Formato Excel", title:"Salidas_Articulo_<%=campo_codigo_sap%>", extension:".xls", 
															 				exportOptions:{columns:[0,1,2,3,5,6,7],
																							format: {
																									//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
																									header: function ( data, columnIdx ) {
																											switch(columnIdx) {
																												case 5:
																													return 'Codigo Articulo';
																													break;
																												case 6:
																													return 'Descripcion Articulo';
																													break;
																												case 7:
																													return 'Referencia Articulo';
																													break;
																												default:
																													return data;
																												}
																										}
																									}
																			
																			}
																			
																		}, 
                                                             {extend:"pdf", text:'<i class="far fa-file-pdf"></i>', titleAttr:"Exportar a Formato PDF", title:"Salidas_Articulo_<%=campo_codigo_sap%>", orientation:"landscape", 
															 				exportOptions:{columns:[0,1,2,3,5,6,7],
																							format: {
																									//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
																									header: function ( data, columnIdx ) {
																											switch(columnIdx) {
																												case 5:
																													return 'Codigo Articulo';
																													break;
																												case 6:
																													return 'Descripcion Articulo';
																													break;
																												case 7:
																													return 'Referencia Articulo';
																													break;
																												default:
																													return data;
																												}
																										}
																									}

																			}
																		}, 
                                                             {extend:"print", text:"<i class='fas fa-print'></i>", titleAttr:"Vista Preliminar", title:"Salidas_Articulo_<%=campo_codigo_sap%>", 
															 				exportOptions:{columns:[0,1,2,3,5,6,7],
																							format: {
																									//PARA PONERLE NOMBRE A LA CABECERA DE LAS COLUMNAS OCULTAS 
																									header: function ( data, columnIdx ) {
																											switch(columnIdx) {
																												case 5:
																													return 'Codigo Articulo';
																													break;
																												case 6:
																													return 'Descripcion Articulo';
																													break;
																												case 7:
																													return 'Referencia Articulo';
																													break;
																												default:
																													return data;
																												}
																										}
																									}
																			
																			
																			}
																		}
															],
                                                 
													createdRow:function (row, data, index) {
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
																  //j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
                                                                },
													rowCallback:function (row, data, index) {
                                                                  //stf.row_sel = data;   
                                                                  //console.log(data);
																  //j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
                                                                },
													drawCallback: function () {
															//para que se configuren los popover-titles...
															//j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
														},
                                                    //initComplete: stf.initComplete,                                                            
                                                     language:{url:"plugins/dataTable/lang/Spanish.json"},
                                                     paging:false,
                                                     processing: true, //para que se procese en el servidor
													 //serverSide: true, // y no tarde tanto en pintar la tabla
													 //deferLoading: 20, // registros que se cargan desde el principio
                                                     searching:true,
													 responsive:true
													 
                                                    });
               	
				j$("#lista_salidas").on("xhr.dt", function() {     
					/*
					var str='<div><a href="#" class="btn btn-primary" onclick="solicitar_articulos()"'
									+ ' data-toggle="popover_datatable"'
									+ ' data-placement="right"'
									+ ' data-trigger="hover"'
									+ ' data-content="Solicitar Art&iacute;culos a Los Proveedores"'
									+ ' data-original-title=""'
									+ '><i class="far fa-list-alt fa-lg"></i>&nbsp;&nbsp;Solicitar Art&iacute;culos</a></div>';
					j$("div.toolbar").html(str);
					*/
					
					/*
					j$("#tb_servicios_ele .dataTables_scrollBody").scroll(function() {
					  j$("#tb_servicios_ele .dataTables_scrollHead").scrollLeft(j$("#tb_servicios_ele .dataTables_scrollBody").scrollLeft());
					});    
					*/
					//
					j$('[data-toggle="popover_datatable"]').popover({html:true, container: 'body'});
			   	})
				
				 //controlamos el click, para seleccionar o desseleccionar la fila
                j$("#lista_salidas tbody").on("click","tr", function() {  
                  if (!j$(this).hasClass("selected") ) {                  
                    //lst_refs.$("tr.selected").removeClass("selected");
                    //j$(this).addClass("selected");
                    
					
					/* mostramos el historico en el click del icono de la maleta
					var table = j$('#lista_pirs').DataTable();
                    row_sel = table.row( this ).data();
					
					j$("#cabecera_pantalla_avisos").html("<h3>Hist&oacute;rico del PIR " + row_sel.PIR + "</h3>")
					j$("#body_avisos").html('<iframe id="iframe_historico_pir" src="Detalle_Historico_Pir.asp?id_pir=' + row_sel.ID + '&pir=' + row_sel.PIR + '" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe>');
					j$("#pantalla_avisos").modal("show");
					*/
                  } 
                  //console.log(row_sel);
					
				  
                });

				//gestiona el dobleclick sobre la fila para mostrar la pantalla de detalle del pir
				j$("#lista_salidas").on("dblclick", "tr", function(e) {
				  var row=lst_refs.row(j$(this).closest("tr")).data() 
				  parametro_id=row.ID
				  
				  j$(this).addClass('selected');
				  
				  //mostrar_articulo(parametro_id)
				});              
				
				
                /*  
          			j$("#stf\\\.lista_tra").on("init.dt", function() {
                    console.log("init.dt"); 
          			});
                
                j$("#stf\\\.lista_tra").on( 'draw.dt', function () {
                    console.log( 'Table redrawn' );
                } );
                */                                                                
              }
            else{     
              //stf.lst_tra.clear().draw();
			  lst_salidas.ajax.url("tojson/obtener_entradas_salidas_articulo.asp?"+prm.toString());
              lst_salidas.ajax.reload();                  
            }       
      
      
    
	lst_salidas.on( 'buttons-action', function ( e, buttonApi, dataTable, node, config ) {
					//console.log( 'Button '+ buttonApi.text()+' was activated' );
					
				} );

  };

j$(window).resize(function() {
  //console.log('dentro de redimensionar ventana')
	var cont = j$('#iframe_cantidades_precios').contents().find("body").height() 
	 j$('#iframe_cantidades_precios').css('height', (cont + 5)  + "px");
 
 //console.log('tamaño iframe: ' + cont)
});


</script>





<%set articulos_empresas=Server.CreateObject("ADODB.Recordset")
								
									  with articulos_empresas
										.ActiveConnection=connimprenta
										.Source="SELECT ID_ARTICULO, CODIGO_EMPRESA, FAMILIA FROM ARTICULOS_EMPRESAS WHERE ID_ARTICULO=" & articulo_seleccionado & " ORDER BY CODIGO_EMPRESA"
										.Open
									  end with
									  while not articulos_empresas.eof%>
									  
										<script language="javascript">
											j$("#rbempresas_<%=articulos_empresas("CODIGO_EMPRESA")%>").prop('checked', true);
											j$("#cmbfamilias_<%=articulos_empresas("CODIGO_EMPRESA")%>").val(<%=articulos_empresas("FAMILIA")%>);
											j$("#cmbfamilias_<%=articulos_empresas("CODIGO_EMPRESA")%>").show()
											//console.log('dando vueltas <%=articulos_empresas("CODIGO_EMPRESA")%>')
										</script>
									  	<%articulos_empresas.movenext
									  wend
									  articulos_empresas.close
									  set articulos_empresas=Nothing%>



<!-- NO BORRAR, es la capa que ejecuta las cosas de ajax....-->
<div id="capa_para_ajax"></div>

</body>
<%
	familias.close
	set familias=Nothing
	
	connimprenta.close
	set connimprenta=Nothing
%>
</html>