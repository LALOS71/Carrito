<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	articulo_seleccionado=Request.Form("id_articulo")
	campo_compromiso_compra=Request.Form("compromiso_compra")
	
	if articulo_seleccionado="" then
		articulo_seleccionado=Request.QueryString("id_articulo")
	end if
	if campo_compromiso_compra="" then
		campo_compromiso_compra=Request.QueryString("compromiso_compra")
	end if

			set tipos_precios=Server.CreateObject("ADODB.Recordset")
				
			with tipos_precios
				.ActiveConnection=connimprenta
				.Source="SELECT V_EMPRESAS.Id, V_EMPRESAS.EMPRESA, V_EMPRESAS_TIPOS_PRECIOS.TIPO_PRECIO "
				.Source=.Source & " FROM ARTICULOS_EMPRESAS INNER JOIN V_EMPRESAS_TIPOS_PRECIOS "
				.Source=.Source & " ON ARTICULOS_EMPRESAS.CODIGO_EMPRESA = V_EMPRESAS_TIPOS_PRECIOS.ID_EMPRESA INNER JOIN "
                .Source=.Source & " V_EMPRESAS ON V_EMPRESAS_TIPOS_PRECIOS.ID_EMPRESA = V_EMPRESAS.Id "
				.Source=.Source & " WHERE ARTICULOS_EMPRESAS.ID_ARTICULO = " & articulo_seleccionado
				.Source=.Source & " ORDER BY V_EMPRESAS.EMPRESA, V_EMPRESAS_TIPOS_PRECIOS.TIPO_PRECIO "
				'response.Write("<br>tipos precios: " & .Source)
				.Open
			end with
		
%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="plugins/bootstrap-4.0.0/css/bootstrap.min.css">
<script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>	
	
<script type="text/javascript" src="plugins/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/popper/popper-1.14.3.js"></script>

<script type="text/javascript" src="plugins/bootstrap-4.0.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>

<script language="javascript">
var j$=jQuery.noConflict();
</script>
</head>

<body>
<div class="row mx-2">
	<%contador=0
	  while not tipos_precios.eof
	  
		contador=contador+1
		
		set cantidades_precios=Server.CreateObject("ADODB.Recordset")

		sql="SELECT CANTIDADES_PRECIOS.Id, CANTIDADES_PRECIOS.CODIGO_ARTICULO, CANTIDADES_PRECIOS.CANTIDAD,"
		sql=sql & " CANTIDADES_PRECIOS.PRECIO_UNIDAD, CANTIDADES_PRECIOS.PRECIO_PACK, CODIGO_EMPRESA, "
		sql=sql & " CANTIDADES_PRECIOS.CANTIDAD_SUPERIOR"
		sql=sql & " FROM CANTIDADES_PRECIOS WHERE CODIGO_ARTICULO=" & articulo_seleccionado
		sql=sql & " AND TIPO_SUCURSAL='" & tipos_precios("tipo_precio") & "' "
		sql=sql & " AND CODIGO_EMPRESA='" & tipos_precios("ID") & "' "
		sql=sql & " ORDER BY CANTIDAD"

		'response.write("<br> cantidades precios:   " & sql)
		CAMPO_ID_CANTIDADES_PRECIOS=0
		CAMPO_CODIGO_ARTICULO_CANTIDADES_PRECIOS=1
		CAMPO_CANTIDAD_CANTIDADES_PRECIOS=2
		CAMPO_PRECIO_UNIDAD_CANTIDADES_PRECIOS=3
		CAMPO_PRECIO_PACK_CANTIDADES_PRECIOS=4
		CAMPO_CANTIDAD_SUPERIOR_CANTIDADES_PRECIOS=6
		
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
			
			<div class="col-sm-12 col-md-6 col-lg-4 col-xl-3 my-1">
				<div class="card">
					<h5 class="card-header"><%=tipos_precios("empresa")%></h5>
					<div class="card-body">
		<%end if%>
		
						<h6 class="card-title">Precio: <%=tipos_precios("tipo_precio")%></h6>
						<p class="card-text">
							<%
							'RESPONSE.WRITE("<BR>COMPROMISIO DE COMPROA: " & campo_compromiso_compra)
							Select Case campo_compromiso_compra 
								case "SI"%>
										<table class="table table-bordered table-striped table-hover table-sm" id="tabla___<%=tipos_precios("id")%>___<%=tipos_precios("tipo_precio")%>">
											<thead>
												<tr>
													<th>Precio Unid. (€/u)</th>
													<th>
														<div class="btn_add" style="text-align:center">
															<i class="fas fa-plus fa-lg" style="color:green;cursor:hand;cursor:pointer"
																data-toggle="popover" 
																data-placement="top" 
																data-trigger="hover"
																data-content="Añadir un Tipo Precio"
																></i>
														</div>
														<%if vacio_cantidades_precios=false then%>
															<script language="javascript">
																//console.log('quitamos add')
																j$("#tabla___<%=tipos_precios("id")%>___<%=tipos_precios("tipo_precio")%>").find('.btn_add').hide();
															</script>
														<%end if%>
													</th>
												</tr>
											</thead>
											<tbody>
												<%if vacio_cantidades_precios=false then %>
													<%for i=0 to UBound(mitabla_cantidades_precios,2)%>
														<tr id="fila_precio_unidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="cursor:hand;cursor:pointer" row_id="fila_precio_unidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>">
															<td>
																<%
																IF mitabla_cantidades_precios(CAMPO_PRECIO_UNIDAD_CANTIDADES_PRECIOS,i)<>"" then
																	cadena_pre=mitabla_cantidades_precios(CAMPO_PRECIO_UNIDAD_CANTIDADES_PRECIOS,i)
																  else
																	cadena_pre=""
																end if
																%>
																<div class="row_data row_data_precio" edit_type="click" col_name="precio"><%=cadena_pre%></div>
																<input type="hidden" name="oculto_id_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" id="oculto_id_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" value="<%=mitabla_cantidades_precios(CAMPO_ID_CANTIDADES_PRECIOS,i)%>" />
																
															</td>
															<td>
																<div style="text-align:center">
																	<i class="fas fa-pencil-alt fa-lg btn_edit" row_id="fila_precio_unidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:blue;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Editar El Tipo Precio"></i>
																	<i class="fas fa-save fa-lg btn_save" row_id="fila_precio_unidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:darkblue;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Guardar El Tipo Precio"></i>
																	<i class="fas fa-times fa-lg btn_cancel" row_id="fila_precio_unidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:red;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Cancelar"></i>
																	<i class="fas fa-trash-alt fa-lg btn_delete" row_id="fila_precio_unidad_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:darkred;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Borrar El Tipo Precio"></i>
																</div>
															</td>
														</tr>
													<%next%>
												<%end if%>
											</tbody>
										</table>
							
							<%case "NO"%>
										<table class="table table-bordered table-striped table-hover table-sm" id="tabla_escalados___<%=tipos_precios("id")%>___<%=tipos_precios("tipo_precio")%>">
											<thead>
												<tr>
													<th>Cant.</th>
													<th>Precio Pack (€)</th>
													<th>
															<div class="btn_add_escalados" style="text-align:center">
																<i class="fas fa-plus fa-lg" style="color:green;cursor:hand;cursor:pointer"
																	data-toggle="popover" 
																	data-placement="top" 
																	data-trigger="hover"
																	data-content="Añadir un Tipo Precio"
																	></i>
															</div>
															<%if vacio_cantidades_precios=false then%>
																<script language="javascript">
																	//console.log('quitamos add')
																	//j$("#tabla_escalados___<%=tipos_precios("id")%>___<%=tipos_precios("tipo_precio")%>").find('.btn_add_escalados').hide();
																</script>
															<%end if%>
													
													</th>
												</tr>
											</thead>
											<tbody>
												<%if vacio_cantidades_precios=false then %>
													<%for i=0 to UBound(mitabla_cantidades_precios,2)%>
														<tr id="fila_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="cursor:hand;cursor:pointer" row_id="fila_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>">
															<td align="right">
																<div class="row_data row_data_cantidades_escalado" edit_type="click" col_name="cantidades_escalado"><%=mitabla_cantidades_precios(CAMPO_CANTIDAD_CANTIDADES_PRECIOS,i)%></div>
																<input type="hidden" name="oculto_escalado_id_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" id="oculto_escalado_id_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" value="<%=mitabla_cantidades_precios(CAMPO_ID_CANTIDADES_PRECIOS,i)%>" />
															</td>
															<td align="right">
																<%
																	precio_pack=""
																	IF mitabla_cantidades_precios(CAMPO_PRECIO_PACK_CANTIDADES_PRECIOS,i)<>"" then
																		'saco 2 decimales sin separacion de miles porque da error al hacer cuentas...
																		precio_pack=FORMATNUMBER(mitabla_cantidades_precios(CAMPO_PRECIO_PACK_CANTIDADES_PRECIOS,i),2,,,0)
																	end if
																%>
																<div class="row_data row_data_precios_escalado" edit_type="click" col_name="precios_escalado"><%=precio_pack%></div>
															</td>
															<td>
																<div style="text-align:center">
																	<i class="fas fa-pencil-alt fa-lg btn_edit_escalados" row_id="fila_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:blue;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Editar El Tipo Precio"></i>
																	<i class="fas fa-save fa-lg btn_save_escalados" row_id="fila_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:darkblue;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Guardar El Tipo Precio"></i>
																	<i class="fas fa-times fa-lg btn_cancel_escalados" row_id="fila_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:red;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Cancelar"></i>
																	<i class="fas fa-trash-alt fa-lg btn_delete_escalados" row_id="fila_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:darkred;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Borrar El Tipo Precio"></i>
																</div>
															</td>
														</tr>
														
													<%next%>
												<%end if%>
											</tbody>
										</table>
									
							<%case "TRAMOS"%>
										<table class="table table-bordered table-striped table-hover table-sm" id="tabla_tramos___<%=tipos_precios("id")%>___<%=tipos_precios("tipo_precio")%>">
											<thead>
												<tr>
													<th>Cant. Inf.</th>
													<th>Cant. Sup.</th>
													<th>Precio Tramo (€)</th>
													<th>
															<div class="btn_add_tramos" style="text-align:center">
																<i class="fas fa-plus fa-lg" style="color:green;cursor:hand;cursor:pointer"
																	data-toggle="popover" 
																	data-placement="top" 
																	data-trigger="hover"
																	data-content="Añadir un Tipo Precio"
																	></i>
															</div>
															<%if vacio_cantidades_precios=false then%>
																<script language="javascript">
																	//console.log('quitamos add')
																	//j$("#tabla_escalados___<%=tipos_precios("id")%>___<%=tipos_precios("tipo_precio")%>").find('.btn_add_escalados').hide();
																</script>
															<%end if%>
													
													</th>
												</tr>
											</thead>
											<tbody>
												<%if vacio_cantidades_precios=false then %>
													<%for i=0 to UBound(mitabla_cantidades_precios,2)%>
														<tr id="fila_tramos_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="cursor:hand;cursor:pointer" row_id="fila_tramos_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>">
															<td align="right">
																<div class="row_data row_data_cantidades_inferior_tramos" edit_type="click" col_name="cantidades_inferior_tramos"><%=mitabla_cantidades_precios(CAMPO_CANTIDAD_CANTIDADES_PRECIOS,i)%></div>
																<input type="hidden" name="oculto_tramos_id_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" id="oculto_tramos_id_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" value="<%=mitabla_cantidades_precios(CAMPO_ID_CANTIDADES_PRECIOS,i)%>" />
															</td>
															<td align="right">
																<div class="row_data row_data_cantidades_superior_tramos" edit_type="click" col_name="cantidades_superior_tramos"><%=mitabla_cantidades_precios(CAMPO_CANTIDAD_SUPERIOR_CANTIDADES_PRECIOS,i)%></div>
															</td>
															<td align="right">
																<%
																	precio_pack=""
																	IF mitabla_cantidades_precios(CAMPO_PRECIO_UNIDAD_CANTIDADES_PRECIOS,i)<>"" then
																		'saco 2 decimales sin separacion de miles porque da error al hacer cuentas...
																		precio_pack=FORMATNUMBER(mitabla_cantidades_precios(CAMPO_PRECIO_UNIDAD_CANTIDADES_PRECIOS,i),2,,,0)
																	end if
																%>
																<div class="row_data row_data_precios_tramos" edit_type="click" col_name="precios_tramos"><%=precio_pack%></div>
															</td>
															<td>
																<div style="text-align:center">
																	<i class="fas fa-pencil-alt fa-lg btn_edit_tramos" row_id="fila_tramos_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:blue;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Editar El Tipo Precio"></i>
																	<i class="fas fa-save fa-lg btn_save_tramos" row_id="fila_tramos_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:darkblue;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Guardar El Tipo Precio"></i>
																	<i class="fas fa-times fa-lg btn_cancel_tramos" row_id="fila_tramos_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:red;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Cancelar"></i>
																	<i class="fas fa-trash-alt fa-lg btn_delete_tramos" row_id="fila_tramos_cantidades_precios_<%=tipos_precios("id")%>_<%=tipos_precios("tipo_precio")%>_<%=i%>" style="color:darkred;cursor:hand;cursor:pointer"
																		data-toggle="popover" 
																		data-placement="top" 
																		data-trigger="hover"
																		data-content="Borrar El Tipo Precio"></i>
																</div>
															</td>
														</tr>
														
													<%next%>
												<%end if%>
											</tbody>
										</table>
							
						<%end select%>
						</p>

			<%
			empresa_anterior=tipos_precios("empresa")				
			tipos_precios.movenext
			
		if not tipos_precios.eof then	
			if empresa_anterior<>tipos_precios("empresa") then%>
					</div>
				</div>
			</div>
			<%end if%>
		  <%else%>
		  	</div></div></div>
		<%end if%>
	<%
	wend
			
	tipos_precios.close
	set tipos_precios=Nothing
	%>

		
</div>

<div class="post_msg"> </div>
</body>


<script language="javascript">

j$(document).find('.btn_save').hide();
j$(document).find('.btn_cancel').hide(); 
j$(document).find('.btn_delete').hide(); 
j$(document).find('.btn_save_escalados').hide();
j$(document).find('.btn_cancel_escalados').hide(); 
j$(document).find('.btn_delete_escalados').hide(); 
j$(document).find('.btn_save_tramos').hide();
j$(document).find('.btn_cancel_tramos').hide(); 
j$(document).find('.btn_delete_tramos').hide(); 



j$(document).ready(function () {
	//para que se configuren los popover-titles...
	//j$('[data-toggle="popover"]').popover({html:true, container: 'body'});
	
	j$("body").popover({html:true, container: 'body', selector: '[data-toggle="popover"]', placement:'top', trigger: 'hover'});
	j$('.row_data').each(function(index, val) 
		{   
			j$(this).attr('contenteditable', 'false')
		});  
		
});


//--->make div editable > start
j$(document).on('click___', '.row_data', function(event) 
	{
		//console.log('dentro del click del precio')
		event.preventDefault(); 

		if(j$(this).attr('edit_type') == 'button')
		{
			return false; 
		}

		//make div editable
		j$(this).closest('div').attr('contenteditable', 'true');
		//add bg css
		j$(this).addClass('bg-warning').css('padding','5px');
		
		//console.log('valor de la celda: ' + j$(this).html())
		
		j$(this).html(j$(this).html().replace(' €/u', ''))		

		//console.log('valor de la celda 2: ' + j$(this).html())
		
		j$(this).focus();
	})	
//--->make div editable > end


/*
//--->save single field data > start
j$(document).on('focusout', '.row_data', function(event) 
	{
		console.log('en focusout')
		event.preventDefault();

		if(j$(this).attr('edit_type') == 'button')
		{
			return false; 
		}

		var row_id = j$(this).closest('tr').attr('row_id'); 
		
		var row_div = j$(this)				
		.removeClass('bg-warning') //add bg css
		.css('padding','')
		
		var col_name = row_div.attr('col_name'); 
		var col_val = row_div.html(); 

		var arr = {};
		arr[col_name] = col_val;

		//use the "arr"	object for your ajax call
		j$.extend(arr, {row_id:row_id});

		//out put to show
		j$('.post_msg').html( '<pre class="bg-success">'+JSON.stringify(arr, null, 2) +'</pre>');
		
	})	
	//--->save single field data > end
*/


	//--->button > edit > start	
j$(document).on('click', '.btn_edit', function(event) 
	{
		//event.preventDefault();
		
		//compruebo que no haya quedado nada editado con anterioridad
		//console.log("elementos editables: " + j$(".row_data.bg-warning").length)
		if (j$(".row_data.bg-warning").length > 0)
			{
			bootbox.alert({
					size: 'large',
					message: '<h6><p><i class="fas fa-exclamation-circle" style="color:red"></i> No puede editar un Precio si no ha guardado o cancelado el anterior...</p></h6>'
					//callback: refrescar_entrada()
				})
			}
		  else
		  	{
			var tbl_row = j$(this).closest('tr');
		
			var row_id = tbl_row.attr('row_id');
		
			tbl_row.find('.btn_save').show();
			tbl_row.find('.btn_cancel').show();
			tbl_row.find('.btn_delete').show();
		
			//hide edit button
			tbl_row.find('.btn_edit').hide(); 
		
			
			//make the whole row editable
			tbl_row.find('.row_data')
			.attr('contenteditable', 'true')
			.attr('edit_type', 'button')
			.addClass('bg-warning')
			.css('padding','3px')
			
			//--->add the original entry > start
			tbl_row.find('.row_data').each(function(index, val) 
			{  
				//this will help in case user decided to click on cancel button
				j$(this).attr('original_entry', j$(this).html());
			}); 		
			//--->add the original entry > end
			}//fin del if

	});
	//--->button > edit > end

//--->button > cancel > start	
j$(document).on('click', '.btn_cancel', function(event) 
	{
		event.preventDefault();

		var tbl_row = j$(this).closest('tr');

		var row_id = tbl_row.attr('row_id');

		//hide save and cacel buttons
		tbl_row.find('.btn_save').hide();
		tbl_row.find('.btn_cancel').hide();
		tbl_row.find('.btn_delete').hide();

		//show edit button
		tbl_row.find('.btn_edit').show();

		//make the whole row editable
		tbl_row.find('.row_data')
		.attr('edit_type', 'click')
		.removeClass('bg-warning')
		.css('padding','') 

		tbl_row.find('.row_data').each(function(index, val) 
		{   
			j$(this).html( j$(this).attr('original_entry') ); 
			j$(this).attr('contenteditable', 'false')
		});  
	});
	//--->button > cancel > end

//--->button > delete > start	
j$(document).on('click', '.btn_delete', function(event) 
	{
		event.preventDefault();
		
		var tbl_row = j$(this).closest('tr');
		var tabla = j$(this).closest('table');
		
		window.parent.bootbox.confirm({
			message: "¿Está seguro que desea borrar este tipo de precio?",
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
					valor_accion='BORRAR'
					valor_id = j$(tabla).find('input[type=hidden]').val()
					valor_codigo_articulo='<%=articulo_seleccionado%>'
					valor_cantidad=''
					valor_cantidad_superior=''
					valor_precio_unidad=''
					valor_precio_pack=''
					valor_tipo_sucursal=''
					valor_codigo_empresa=''
					
					j$(tbl_row).remove()
					mantenimiento_cantidades_precios(valor_accion, valor_id, valor_codigo_articulo, valor_cantidad, valor_cantidad_superior, valor_precio_unidad, valor_precio_pack, valor_tipo_sucursal, valor_codigo_empresa)
					
					j$(tabla).find('.btn_add').show();
					}
				
			}
		});
		
		
	});
	
	
	
	//--->button > delete > end

//--->button > add > start	
j$(document).on('click', '.btn_add', function(event) 
	{
		//console.log('dentro del click de btn_add')
		event.preventDefault();
		
		
		var tabla = j$(this).closest('table');
		
		tabla.find('.btn_add').hide();
		
		//console.log('id de la tabla: ' + j$(tabla).attr('id'))
		valores=j$(tabla).attr('id').split('___')
		//console.log(valores[0])
		//console.log(valores[1])
		//console.log(valores[2])
		
		//$('#myTable > tbody:last-child').append('<tr>...</tr><tr>...</tr>');
		cadena = '<tr id="fila_precio_unidad_' + valores[1] + '_' + valores[2] + '_0" style="cursor:hand;cursor:pointer" row_id="fila_precio_unidad_' + valores[1] + '_' + valores[2] + '_0">'
		cadena = cadena + '<td>'
		cadena = cadena + '<div class="row_data row_data_precio" edit_type="click" col_name="precio"></div>'
		cadena = cadena + '<input type="hidden" name="oculto_id_' + valores[1] + '_' + valores[2] + '_0" id="oculto_id_' + valores[1] + '_' + valores[2] + '_0" value="" />'
		cadena = cadena + '</td>'
		cadena = cadena + '<td>'
		cadena = cadena + '<div style="text-align:center">'
		cadena = cadena + '<i class="fas fa-pencil-alt fa-lg btn_edit" row_id="fila_precio_unidad_' + valores[1] + '_' + valores[2] + '_0" style="color:blue"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Editar el Tipo Precio"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-save fa-lg btn_save" row_id="fila_precio_unidad_' + valores[1] + '_' + valores[2] + '_0" style="color:darkblue;display:none"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Guardar El Tipo Precio"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-times fa-lg btn_cancel" row_id="fila_precio_unidad_' + valores[1] + '_' + valores[2] + '_0" style="color:red;display:none"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Cancelar"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-trash-alt fa-lg btn_delete" row_id="fila_precio_unidad_' + valores[1] + '_' + valores[2] + '_0" style="color:darkred;display:none"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Borrar El Tipo Precio"></i>'
		cadena = cadena + '</div>'
		cadena = cadena + '</td>'
		cadena = cadena + '<tr>'
		
		//console.log('cadena a añadir: ' + cadena)
		
		j$(tabla).find('tbody:last-child').append(cadena);
		
		
		
	});
	//--->button > add > end



//--->button > delete > start	
j$(document).on('click', '.btn_save', function(event) 
	{
		event.preventDefault();
		
		var tbl_row = j$(this).closest('tr');
		var tabla = j$(this).closest('table');
		
		valores=j$(tabla).attr('id').split('___')
		
		
		//console.log('valor del id de cantidades precios: ' + j$(tbl_row).find('input[type=hidden]').val())
		
		valor_id = j$(tbl_row).find('input[type=hidden]').val()

		if (valor_id=='') //es un alta
			{
			valor_accion='ALTA'
			}
		  else
		  	{
			valor_accion='MODIFICACION'
			}
			
					
					
		valor_codigo_articulo='<%=articulo_seleccionado%>'
		valor_cantidad=''
		valor_cantidad_superior=''
		valor_precio_unidad=j$(tbl_row).find('.row_data.row_data_precio').html().replace(',', '.')
		//console.log('valor del precio unidad: ' + valor_precio_unidad)
		valor_precio_pack=''
		valor_tipo_sucursal=valores[2]
		valor_codigo_empresa=valores[1]
		
		mantenimiento_cantidades_precios(valor_accion, valor_id, valor_codigo_articulo, valor_cantidad, valor_cantidad_superior, valor_precio_unidad, valor_precio_pack, valor_tipo_sucursal, valor_codigo_empresa)
		
		//hide save and cacel buttons
		tbl_row.find('.btn_save').hide();
		tbl_row.find('.btn_cancel').hide();
		tbl_row.find('.btn_delete').hide();

		//show edit button
		tbl_row.find('.btn_edit').show();

		//make the whole row editable
		tbl_row.find('.row_data')
		.attr('edit_type', 'click')
		.removeClass('bg-warning')
		.css('padding','') 

		tbl_row.find('.row_data').each(function(index, val) 
		{   
			j$(this).attr('contenteditable', 'false')
		});  
		
		
		j$("#tab4",window.opener).trigger('click')
		//console.log('contenidoooo: ' + j$('#tab3', window.parent.document).html())
		
		/*
		if (valor_accion=='ALTA')
			{
			j$('#tab4', window.parent.document).click()
			}
		*/
		
		//window.parent.document.getElementById("element_id")
		//j$(window.opener).find('#tab3').trigger('click')
					
	});
	//--->button > delete > end



//funcion para crear, modificar y borrar cantidades precios de articulos	
mantenimiento_cantidades_precios = function(valor_accion, valor_id, valor_codigo_articulo, valor_cantidad, valor_cantidad_superior, valor_precio_unidad, valor_precio_pack, valor_tipo_sucursal, valor_codigo_empresa) {

	/*
	j$.ajax({
		type: "post",        
    	url: 'Mantenimiento_Cantidades_Precios.asp',
		data: '{accion:"' + valor_accion + '", id:' + valor_id + '}',
	    success: function(respuesta) {
					  console.log('el stock es de: ' + respuesta)
					  //j$("#txtstock_STANDARD").val(respuesta)
					},
    	error: function() {
    			bootbox.alert({
					message: "Se ha producido un error al intentar actualizar las Cantidades precios del Articulo",
					//message: '<h4><p><i class="fa fa-spin fa-spinner"></i> Actualizando la Base de Datos...</p></h4>'
					//callback: refrescar_stock()
				})
    		}
  	});	
	*/
	//$(selector).post(URL,data,function(data,status,xhr),dataType)
	texto_error=""
	if (valor_accion=='BORRAR')
		{
		texto_error='Se ha Producido un Error al Eliminar la Cantidad/Precio'
		}
	if (valor_accion=='ALTA')
		{
		texto_error='Se ha Producido un Error al dar de Alta la Cantidad/Precio'
		}
	if (valor_accion=='MODIFICACION')
		{
		texto_error='Se ha Producido un Error al Modificar la Cantidad/Precio'
		}
	
	/*
	console.log('accion: ' + valor_accion)
	console.log('id: ' + valor_id)
	console.log('codigo_articulo: ' + valor_codigo_articulo)
	console.log('cantidad: ' + valor_cantidad)
	console.log('cantidad superior: ' + valor_cantidad_superior)
	console.log('precio unid: ' + valor_precio_unidad) 
	console.log('precio pac: ' + valor_precio_pack) 
	console.log('tipo sucur: ' + valor_tipo_sucursal) 
	console.log('empresa: ' + valor_codigo_empresa)
	*/
	j$.post('Mantenimiento_Cantidades_Precios.asp',
					//'{accion:"' + valor_accion + '", id:' + valor_id + '}',
					{accion:valor_accion,
							id:valor_id,
							codigo_articulo:valor_codigo_articulo, 
							cantidad:valor_cantidad, 
							cantidad_superior:valor_cantidad_superior,
							precio_unidad:valor_precio_unidad, 
							precio_pack:valor_precio_pack, 
							tipo_sucursal:valor_tipo_sucursal, 
							codigo_empresa:valor_codigo_empresa
					},
					
					function(data, status, xhr)
						{
						//console.log('datos devueltos: ' + data)
						//console.log('estatus: ' + status)
						if (status!='success')
							{
							//console.log('datos devueltos error: ' + data)
							//console.log('estatus error: ' + status)
							window.parent.bootbox.alert({
									size: 'large',
									message: '<h6><p><i class="fas fa-exclamation-circle" style="color:red"></i> ' 
													+ texto_error 
													+ '</p></h6>'
													+ '<div class="alert alert-danger" role="alert">'
													+ data
													+ '</div>'
									//callback: refrescar_entrada()
								})
							}
						//refrescamos la pestaña de cantidades precios	
						j$('#tab4', window.parent.document).click()
						
						}
	
	
	
	) // fin post
	
};



	//--->button > edit > start	
j$(document).on('click', '.btn_edit_escalados', function(event) 
	{
		//event.preventDefault();
		
		//compruebo que no haya quedado nada editado con anterioridad
		//console.log("elementos editables: " + j$(".row_data.bg-warning").length)
		if (j$(".row_data.bg-warning").length > 0)
			{
			window.parent.bootbox.alert({
					size: 'large',
					message: '<h6><p><i class="fas fa-exclamation-circle" style="color:red"></i> No puede editar un Precio si no ha guardado o cancelado el anterior...</p></h6>'
					//callback: refrescar_entrada()
				})
			}
		  else
		  	{
			var tbl_row = j$(this).closest('tr');
		
			var row_id = tbl_row.attr('row_id');
		
			tbl_row.find('.btn_save_escalados').show();
			tbl_row.find('.btn_cancel_escalados').show();
			tbl_row.find('.btn_delete_escalados').show();
		
			//hide edit button
			tbl_row.find('.btn_edit_escalados').hide(); 
		
			
			//make the whole row editable
			tbl_row.find('.row_data')
			.attr('contenteditable', 'true')
			.attr('edit_type', 'button')
			.addClass('bg-warning')
			.css('padding','3px')
			
			//--->add the original entry > start
			tbl_row.find('.row_data').each(function(index, val) 
			{  
				//this will help in case user decided to click on cancel button
				j$(this).attr('original_entry', j$(this).html());
			}); 		
			//--->add the original entry > end
			}//fin del if

	});
	//--->button > edit > end

//--->button > cancel > start	
j$(document).on('click', '.btn_cancel_escalados', function(event) 
	{
		event.preventDefault();

		var tbl_row = j$(this).closest('tr');

		var row_id = tbl_row.attr('row_id');

		//hide save and cacel buttons
		tbl_row.find('.btn_save_escalados').hide();
		tbl_row.find('.btn_cancel_escalados').hide();
		tbl_row.find('.btn_delete_escalados').hide();

		//show edit button
		tbl_row.find('.btn_edit_escalados').show();

		//make the whole row editable
		tbl_row.find('.row_data')
		.attr('edit_type', 'click')
		.removeClass('bg-warning')
		.css('padding','') 

		tbl_row.find('.row_data').each(function(index, val) 
		{   
			j$(this).html( j$(this).attr('original_entry') ); 
			j$(this).attr('contenteditable', 'false')
		}); 
		
		//j$(this).closest('table').find('.btn_add_escalados').show(); 
	});
	//--->button > cancel > end
	
//--->button > delete > start	
j$(document).on('click', '.btn_delete_escalados', function(event) 
	{
		event.preventDefault();
		
		var tbl_row = j$(this).closest('tr');
		var tabla = j$(this).closest('table');
		
		window.parent.bootbox.confirm({
			message: "¿Está seguro que desea borrar este tipo de precio?",
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
					valor_accion='BORRAR'
					valor_id = j$(tbl_row).find('input[type=hidden]').val()
					valor_codigo_articulo='<%=articulo_seleccionado%>'
					valor_cantidad=''
					valor_cantidad_superior=''
					valor_precio_unidad=''
					valor_precio_pack=''
					valor_tipo_sucursal=''
					valor_codigo_empresa=''
					
					
					j$(tbl_row).remove()
					if (valor_id!='')
						{
						mantenimiento_cantidades_precios(valor_accion, valor_id, valor_codigo_articulo, valor_cantidad, valor_cantidad_superior, valor_precio_unidad, valor_precio_pack, valor_tipo_sucursal, valor_codigo_empresa)
						}
					
					//j$(tabla).find('.btn_add').show();
					
					tabla.find('.btn_add_escalados').show();
					}
			}
		});
		
		
	});
	//--->button > delete > end

//--->button > add > start	
j$(document).on('click', '.btn_add_escalados', function(event) 
	{
		//console.log('dentro del click de btn_add_escalados')
		event.preventDefault();
		
		var tabla = j$(this).closest('table');
		
		tabla.find('.btn_add_escalados').hide();
		
		//console.log('id de la tabla: ' + j$(tabla).attr('id'))
		valores=j$(tabla).attr('id').split('___')
		//console.log(valores[0])
		//console.log(valores[1])
		//console.log(valores[2])
		
		//$('#myTable > tbody:last-child').append('<tr>...</tr><tr>...</tr>');
		cadena = '<tr id="fila_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x" style="cursor:hand;cursor:pointer" row_id="fila_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x">'
		cadena = cadena + '<td align="right">'
		cadena = cadena + '<div class="row_data row_data_cantidades_escalado" edit_type="click" col_name="cantidades_escalado"></div>'
		cadena = cadena + '<input type="hidden" name="oculto_escalado_id_' + valores[1] + '_' + valores[2] + '_x" id="oculto_escalado_id_' + valores[1] + '_' + valores[2] + '_x" value="" />'
		cadena = cadena + '</td>'
		cadena = cadena + '<td align="right">'
		cadena = cadena + '<div class="row_data row_data_precios_escalado" edit_type="click" col_name="precios_escalado"></div>'
		cadena = cadena + '</td>'
		cadena = cadena + '<td>'
		cadena = cadena + '<div style="text-align:center">'
		cadena = cadena + '<i class="fas fa-pencil-alt fa-lg btn_edit_escalados" row_id="fila_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x" style="color:blue;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Editar el Tipo Precio"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-save fa-lg btn_save_escalados" row_id="fila_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x" style="color:darkblue;display:none;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Guardar El Tipo Precio"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-times fa-lg btn_cancel_escalados" row_id="fila_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x" style="color:red;display:none;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Cancelar"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-trash-alt fa-lg btn_delete_escalados" row_id="fila_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x" style="color:darkred;display:none;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Borrar El Tipo Precio"></i>'
		cadena = cadena + '</div>'
		cadena = cadena + '</td>'
		cadena = cadena + '<tr>'
		
		
		//console.log('cadena a añadir: ' + cadena)
		
		j$(tabla).find('tbody:last-child').append(cadena);
		
		
		
	});
	//--->button > add > end

//--->button > delete > start	
j$(document).on('click', '.btn_save_escalados', function(event) 
	{
		event.preventDefault();
		
		var tbl_row = j$(this).closest('tr');
		var tabla = j$(this).closest('table');
		
		valores=j$(tabla).attr('id').split('___')
		
		
		//console.log('valor del id de cantidades precios: ' + j$(tbl_row).find('input[type=hidden]').val())
		
		valor_id = j$(tbl_row).find('input[type=hidden]').val()

		if (valor_id=='') //es un alta
			{
			valor_accion='ALTA'
			}
		  else
		  	{
			valor_accion='MODIFICACION'
			}
			
					
					
		valor_codigo_articulo='<%=articulo_seleccionado%>'
		valor_cantidad=j$(tbl_row).find('.row_data.row_data_cantidades_escalado').html().replace(',', '.')
		valor_cantidad_superior=''
		valor_precio_unidad=''
		//console.log('valor del precio unidad: ' + valor_precio_unidad)
		valor_precio_pack=j$(tbl_row).find('.row_data.row_data_precios_escalado').html().replace(',', '.')
		valor_tipo_sucursal=valores[2]
		valor_codigo_empresa=valores[1]
		

		mantenimiento_cantidades_precios(valor_accion, valor_id, valor_codigo_articulo, valor_cantidad, valor_cantidad_superior, valor_precio_unidad, valor_precio_pack, valor_tipo_sucursal, valor_codigo_empresa)
		
		
		//hide save and cacel buttons
		tbl_row.find('.btn_save_escalados').hide();
		tbl_row.find('.btn_cancel_escalados').hide();
		tbl_row.find('.btn_delete_escalados').hide();

		//show edit button
		tbl_row.find('.btn_edit_escalados').show();

		//make the whole row editable
		tbl_row.find('.row_data')
		.attr('edit_type', 'click')
		.removeClass('bg-warning')
		.css('padding','') 

		tbl_row.find('.row_data').each(function(index, val) 
		{   
			j$(this).attr('contenteditable', 'false')
		});  
		
		
		//j$("#tab3",window.opener).trigger('click')
		//console.log('contenidoooo: ' + j$('#tab3', window.parent.document).html())
		
		if (valor_accion=='ALTA')
			{
			j$('#tab4', window.parent.document).click()
			}
		
		
		//window.parent.document.getElementById("element_id")
		//j$(window.opener).find('#tab3').trigger('click')
		
		tabla.find('.btn_add_escalados').show();
					
	});
	//--->button > delete > end



j$(document).on('click', '.btn_edit_tramos', function(event) 
	{
		//event.preventDefault();
		
		//compruebo que no haya quedado nada editado con anterioridad
		//console.log("elementos editables: " + j$(".row_data.bg-warning").length)
		if (j$(".row_data.bg-warning").length > 0)
			{
			window.parent.bootbox.alert({
					size: 'large',
					message: '<h6><p><i class="fas fa-exclamation-circle" style="color:red"></i> No puede editar un Precio si no ha guardado o cancelado el anterior...</p></h6>'
					//callback: refrescar_entrada()
				})
			}
		  else
		  	{
			var tbl_row = j$(this).closest('tr');
		
			var row_id = tbl_row.attr('row_id');
		
			tbl_row.find('.btn_save_tramos').show();
			tbl_row.find('.btn_cancel_tramos').show();
			tbl_row.find('.btn_delete_tramos').show();
		
			//hide edit button
			tbl_row.find('.btn_edit_tramos').hide(); 
		
			
			//make the whole row editable
			tbl_row.find('.row_data')
			.attr('contenteditable', 'true')
			.attr('edit_type', 'button')
			.addClass('bg-warning')
			.css('padding','3px')
			
			//--->add the original entry > start
			tbl_row.find('.row_data').each(function(index, val) 
			{  
				//this will help in case user decided to click on cancel button
				j$(this).attr('original_entry', j$(this).html());
			}); 		
			//--->add the original entry > end
			}//fin del if

	});
	//--->button > edit > end

j$(document).on('click', '.btn_cancel_tramos', function(event) 
	{
		event.preventDefault();

		var tbl_row = j$(this).closest('tr');

		var row_id = tbl_row.attr('row_id');

		//hide save and cacel buttons
		tbl_row.find('.btn_save_tramos').hide();
		tbl_row.find('.btn_cancel_tramos').hide();
		tbl_row.find('.btn_delete_tramos').hide();

		//show edit button
		tbl_row.find('.btn_edit_tramos').show();

		//make the whole row editable
		tbl_row.find('.row_data')
		.attr('edit_type', 'click')
		.removeClass('bg-warning')
		.css('padding','') 

		tbl_row.find('.row_data').each(function(index, val) 
		{   
			j$(this).html( j$(this).attr('original_entry') ); 
			j$(this).attr('contenteditable', 'false')
		}); 
		
		//j$(this).closest('table').find('.btn_add_escalados').show(); 
	});
	//--->button > cancel > end

j$(document).on('click', '.btn_delete_tramos', function(event) 
	{
		event.preventDefault();
		
		var tbl_row = j$(this).closest('tr');
		var tabla = j$(this).closest('table');
		
		window.parent.bootbox.confirm({
			message: "¿Está seguro que desea borrar este tipo de precio?",
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
					valor_accion='BORRAR'
					valor_id = j$(tbl_row).find('input[type=hidden]').val()
					valor_codigo_articulo='<%=articulo_seleccionado%>'
					valor_cantidad=''
					valor_cantidad_superior=''
					valor_precio_unidad=''
					valor_precio_pack=''
					valor_tipo_sucursal=''
					valor_codigo_empresa=''
					
					
					j$(tbl_row).remove()
					if (valor_id!='')
						{
						mantenimiento_cantidades_precios(valor_accion, valor_id, valor_codigo_articulo, valor_cantidad, valor_cantidad_superior, valor_precio_unidad, valor_precio_pack, valor_tipo_sucursal, valor_codigo_empresa)
						}
					
					//j$(tabla).find('.btn_add').show();
					
					tabla.find('.btn_add_tramos').show();
					}
			}
		});
		
		
	});
	//--->button > delete > end


j$(document).on('click', '.btn_add_tramos', function(event) 
	{
		//console.log('dentro del click de btn_add_escalados')
		event.preventDefault();
		
		var tabla = j$(this).closest('table');
		
		tabla.find('.btn_add_tramos').hide();
		
		//console.log('id de la tabla: ' + j$(tabla).attr('id'))
		valores=j$(tabla).attr('id').split('___')
		//console.log(valores[0])
		//console.log(valores[1])
		//console.log(valores[2])
		
		//$('#myTable > tbody:last-child').append('<tr>...</tr><tr>...</tr>');
		cadena = '<tr id="fila_tramos_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x" style="cursor:hand;cursor:pointer" row_id="fila_tramos_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x">'
		cadena = cadena + '<td align="right">'
		cadena = cadena + '<div class="row_data row_data_cantidades_inferior_tramos" edit_type="click" col_name="cantidades_inferior_tramos"></div>'
		cadena = cadena + '<input type="hidden" name="oculto_tramos_id_' + valores[1] + '_' + valores[2] + '_x" id="oculto_tramos_id_' + valores[1] + '_' + valores[2] + '_x" value="" />'
		cadena = cadena + '</td>'
		cadena = cadena + '<td align="right">'
		cadena = cadena + '<div class="row_data row_data_cantidades_superior_tramos" edit_type="click" col_name="cantidades_superior_tramos"></div>'
		cadena = cadena + '</td>'
		cadena = cadena + '<td align="right">'
		cadena = cadena + '<div class="row_data row_data_precios_tramos" edit_type="click" col_name="precios_tramos"></div>'
		cadena = cadena + '</td>'
		cadena = cadena + '<td>'
		cadena = cadena + '<div style="text-align:center">'
		cadena = cadena + '<i class="fas fa-pencil-alt fa-lg btn_edit_tramos" row_id="fila_tramos_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x" style="color:blue;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Editar el Tipo Precio"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-save fa-lg btn_save_tramos" row_id="fila_tramos_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x" style="color:darkblue;display:none;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Guardar El Tipo Precio"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-times fa-lg btn_cancel_tramos" row_id="fila_tramos_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x" style="color:red;display:none;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Cancelar"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-trash-alt fa-lg btn_delete_tramos" row_id="fila_tramos_cantidades_precios_' + valores[1] + '_' + valores[2] + '_x" style="color:darkred;display:none;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Borrar El Tipo Precio"></i>'
		cadena = cadena + '</div>'
		cadena = cadena + '</td>'
		cadena = cadena + '<tr>'
		
																
		//console.log('cadena a añadir: ' + cadena)
		
		j$(tabla).find('tbody:last-child').append(cadena);
		
		
		
	});
	//--->button > add > end
	
	
	j$(document).on('click', '.btn_save_tramos', function(event) 
	{
		event.preventDefault();
		
		var tbl_row = j$(this).closest('tr');
		var tabla = j$(this).closest('table');
		
		valores=j$(tabla).attr('id').split('___')
		
		
		//console.log('valor del id de cantidades precios: ' + j$(tbl_row).find('input[type=hidden]').val())
		
		valor_id = j$(tbl_row).find('input[type=hidden]').val()

		if (valor_id=='') //es un alta
			{
			valor_accion='ALTA'
			}
		  else
		  	{
			valor_accion='MODIFICACION'
			}
			
					
					
		valor_codigo_articulo='<%=articulo_seleccionado%>'
		valor_cantidad_inferior=j$(tbl_row).find('.row_data.row_data_cantidades_inferior_tramos').html().replace(',', '.')
		valor_cantidad_superior=j$(tbl_row).find('.row_data.row_data_cantidades_superior_tramos').html().replace(',', '.')
		//console.log('valor del precio unidad: ' + valor_precio_unidad)
		valor_precio_tramo=j$(tbl_row).find('.row_data.row_data_precios_tramos').html().replace(',', '.')
		valor_precio_pack=''
		valor_tipo_sucursal=valores[2]
		valor_codigo_empresa=valores[1]
		

		
		//console.log('accion: ' + valor_accion + '\nid: ' + valor_id + '\ncod articulo: ' + valor_codigo_articulo + '\ncantidad: ' +  valor_cantidad_inferior +   '\ncantidad_superior: ' + valor_cantidad_superior + '\nprecio tramo: ' + valor_precio_tramo  + '\nprecio pack: ' +  valor_precio_pack  + '\ntipo sucursal: ' +  valor_tipo_sucursal  + '\ncodigo empresa: ' +  valor_codigo_empresa)
				
		mantenimiento_cantidades_precios(valor_accion, valor_id, valor_codigo_articulo, valor_cantidad_inferior, valor_cantidad_superior, valor_precio_tramo, valor_precio_pack, valor_tipo_sucursal, valor_codigo_empresa)
		
		//hide save and cacel buttons
		tbl_row.find('.btn_save_tramos').hide();
		tbl_row.find('.btn_cancel_tramos').hide();
		tbl_row.find('.btn_delete_tramos').hide();

		//show edit button
		tbl_row.find('.btn_edit_tramos').show();

		//make the whole row editable
		tbl_row.find('.row_data')
		.attr('edit_type', 'click')
		.removeClass('bg-warning')
		.css('padding','') 

		tbl_row.find('.row_data').each(function(index, val) 
		{   
			j$(this).attr('contenteditable', 'false')
		});  
		
		
		//j$("#tab3",window.opener).trigger('click')
		//console.log('contenidoooo: ' + j$('#tab3', window.parent.document).html())
		
		if (valor_accion=='ALTA')
			{
			j$('#tab4', window.parent.document).click()
			}
		
		
		//window.parent.document.getElementById("element_id")
		//j$(window.opener).find('#tab3').trigger('click')
		
		tabla.find('.btn_add_tramos').show();
					
	});


</script>

</html>