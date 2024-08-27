<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->

<%
	Response.CharSet = "iso-8859-1"

	
			set tipos_maleta=Server.CreateObject("ADODB.Recordset")
				
			CAMPO_ID_TIPOS_MALETA=0
			CAMPO_CODIGO_TIPOS_MALETA=1
			CAMPO_DESCRIPCION_TIPOS_MALETA=2
			CAMPO_ORDEN_TIPOS_MALETA=3
			CAMPO_BORRADO_TIPOS_MALETA=4
			with tipos_maleta
				.ActiveConnection=connmaletas
				.Source="SELECT ID, CODIGO, DESCRIPCION, ORDEN, BORRADO"
				.Source=.Source & " FROM TIPOS_MALETA"
				.Source=.Source & " ORDER BY ORDEN"
				'response.Write("<br>"&.Source)
				.Open
				vacio_tipos_maleta=false
				if not .BOF then
					mitabla_tipos_maleta=.GetRows()
				  else
					vacio_tipos_maleta=true
				end if
			end with
			tipos_maleta.close
			set tipos_maleta=Nothing
			
			connmaletas.close
			set connmaletas=Nothing
		
%>
<html>
<head>
	
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-switch/css/bootstrap-switch.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/media/css/dataTables.bootstrap.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/extensions/Buttons/css/buttons.dataTables.min.css">
  
	


<script type="text/javascript" src="plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>	
	
<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>

<script type="text/javascript" src="plugins/dataTable/media/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/media/js/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.flash.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/jszip.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/pdfmake.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/vfs_fonts.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.print.min.js"></script>

<script type="text/javascript" src="plugins/bootstrap-switch/js/bootstrap-switch.min.js"></script>
  
<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script>  

<script type="text/javascript" src="plugins/bootbox-4.4.0/bootbox.min.js"></script>

<script type="text/javascript">  
var j$=jQuery.noConflict();
</script>  
</head>

<body>
<div class="row">
	
			<div class="col-sm-12 col-md-6 col-lg-4 col-xl-3">
				HOLA ANTES
				<BR>
		
							<table class="table table-bordered table-striped table-hover table-sm" id="tabla_tipos_maleta">
									<thead>
										<tr>
											<th>C&oacute;digo</th>
											<th>Descripci&oacute;n</th>
											<th>Orden</th>
											<th>Borrado</th>
											<th>
													<div class="btn_add_tipos_maleta" style="text-align:center">
														<i class="fas fa-plus fa-lg" style="color:green;cursor:hand;cursor:pointer"
															data-toggle="popover" 
															data-placement="right" 
															data-trigger="hover"
															data-content="Añadir un Tipo de Maleta"
															></i>
													</div>
													<%if vacio_tipos_maleta=false then%>
														<script language="javascript">
															console.log('quitamos add')
															//j$("#tabla_tipos_maleta").find('.btn_add_tipos_maleta').hide();
														</script>
													<%end if%>
											</th>
										</tr>
									</thead>
									<tbody>
										<%if vacio_tipos_maleta=false then %>
											<%for i=0 to UBound(mitabla_tipos_maleta,2)%>
												<tr id="fila_tipos_maleta_<%=i%>" style="cursor:hand;cursor:pointer" row_id="fila_tipos_maleta_<%=i%>">
													<td align="right">
														<div class="row_data row_data_tipos_maleta" edit_type="click" col_name="codigo_tipos_maleta"><%=mitabla_tipos_maleta(CAMPO_CODIGO_TIPOS_MALETA,i)%></div>
														<input type="hidden" name="oculto_id_<%=i%>" id="oculto_id_<%=i%>" value="<%=mitabla_tipos_maleta(CAMPO_ID_TIPOS_MALETA,i)%>" />
													</td>
													<td>
														<div class="row_data row_data_tipos_maleta" edit_type="click" col_name="descripcion_tipos_maleta"><%=mitabla_tipos_maleta(CAMPO_DESCRIPCION_TIPOS_MALETA,i)%></div>
													</td>
													<td align="right">
														<div class="row_data row_data_tipos_maleta" edit_type="click" col_name="orden_tipos_maleta"><%=mitabla_tipos_maleta(CAMPO_ORDEN_TIPOS_MALETA,i)%></div>
													</td>
													<td align="center">
														<div class="row_data row_data_tipos_maleta" edit_type="click" col_name="borrado_tipos_maleta"><%=mitabla_tipos_maleta(CAMPO_BORRADO_TIPOS_MALETA,i)%></div>
													</td>
													<td>
														<div style="text-align:center">
															<i class="fas fa-pencil-alt fa-lg btn_edit_tipos_maleta" row_id="fila_tipos_maleta_<%=i%>" style="color:blue;cursor:hand;cursor:pointer"
																data-toggle="popover" 
																data-placement="top" 
																data-trigger="hover"
																data-content="Editar El Tipo de Maleta"></i>
															<i class="fas fa-save fa-lg btn_save_tipos_maleta" row_id="fila_tipos_maleta_<%=i%>" style="color:darkblue;cursor:hand;cursor:pointer"
																data-toggle="popover" 
																data-placement="top" 
																data-trigger="hover"
																data-content="Guardar El Tipo de Maleta"></i>
															<i class="fas fa-times fa-lg btn_cancel_tipos_maleta" row_id="fila_tipos_maleta_<%=i%>" style="color:red;cursor:hand;cursor:pointer"
																data-toggle="popover" 
																data-placement="top" 
																data-trigger="hover"
																data-content="Cancelar"></i>
															<i class="fas fa-trash-alt fa-lg btn_delete_tipos_maleta" row_id="fila_tipos_maleta_<%=i%>" style="color:darkred;cursor:hand;cursor:pointer"
																data-toggle="popover" 
																data-placement="right" 
																data-trigger="hover"
																data-content="Borrar El Tipo de Maleta"></i>
														</div>
													</td>
												</tr>
												
											<%next%>
										<%end if%>
									</tbody>
								</table>
								HOLA DESPUES
								<BR>
							

			</div>
</div>
hola 5
<div class="row">
hola 6
</div>
</body>




<script language="javascript">



j$(document).find('.btn_save').hide();
j$(document).find('.btn_cancel').hide(); 
j$(document).find('.btn_delete').hide(); 
j$(document).find('.btn_save_tipos_maleta').hide();
j$(document).find('.btn_cancel_tipos_maleta').hide(); 
j$(document).find('.btn_delete_tipos_maleta').hide(); 



j$(document).ready(function () {
	//para que se configuren los popover-titles...
	//j$('[data-toggle="popover"]').popover({html:true, container: 'body'});
	
	j$("body").popover({html:true, container: 'body', selector: '[data-toggle="popover"]', trigger: 'hover'});
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
					message: '<h4><p><i class="fas fa-exclamation-circle" style="color:red"></i> No puede editar un Tipo de Malenta si no ha guardado o cancelado el anterior...</p></h4>'
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



//--->button > add > start	
j$(document).on('click', '.btn_add_tipos_maleta', function(event) 
	{
		//console.log('dentro del click de btn_add')
		event.preventDefault();
		
		
		var tabla = j$(this).closest('table');
		
		tabla.find('.btn_add_tipos_maleta').hide();
		
		//console.log('id de la tabla: ' + j$(tabla).attr('id'))
		valores=j$(tabla).attr('id').split('___')
		//console.log(valores[0])
		//console.log(valores[1])
		//console.log(valores[2])
		
		
		
				
		//$('#myTable > tbody:last-child').append('<tr>...</tr><tr>...</tr>');
		cadena = '<tr id="fila_tipos_maleta_0" style="cursor:hand;cursor:pointer" row_id="fila_tipos_maleta_0">'
		cadena = cadena + '<td align="right">'
		cadena = cadena + '<div class="row_data row_data_tipos_maleta" edit_type="click" col_name="codigo_tipos_maleta"></div>'
		cadena = cadena + '<input type="hidden" name="oculto_id_0" id="oculto_id_0" value="" />'
		cadena = cadena + '</td>'
		cadena = cadena + '<td>'
		cadena = cadena + '<div class="row_data row_data_tipos_maleta" edit_type="click" col_name="descripcion_tipos_maleta"></div>'
		cadena = cadena + '</td>'
		cadena = cadena + '<td align="right">'
		cadena = cadena + '<div class="row_data row_data_tipos_maleta" edit_type="click" col_name="orden_tipos_maleta"></div>'
		cadena = cadena + '</td>'
		cadena = cadena + '<td align="center">'
		cadena = cadena + '<div class="row_data row_data_tipos_maleta" edit_type="click" col_name="borrado_tipos_maleta">'
		cadena = cadena + '<select class="form-control"  name="cmbtipos_maleta_0" id="cmbtipos_maleta_0">'
		cadena = cadena + '<option value="SI">SI</option>'
		cadena = cadena + '<option value="NO">NO</option>'
		cadena = cadena + '</select>'
		cadena = cadena + '</div>'
		cadena = cadena + '</td>'
		cadena = cadena + '<td>'
		cadena = cadena + '<div style="text-align:center">'
		cadena = cadena + '<i class="fas fa-pencil-alt fa-lg btn_edit" row_id="fila_tipos_maleta_0" style="color:blue;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Editar el Tipo de Maleta"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-save fa-lg btn_save" row_id="fila_tipos_maleta_0" style="color:darkblue;display:none;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Guardar El Tipo de Maleta"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-times fa-lg btn_cancel" row_id="fila_tipos_maleta_0" style="color:red;display:none;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Cancelar"></i>&nbsp;'
		cadena = cadena + '<i class="fas fa-trash-alt fa-lg btn_delete" row_id="fila_tipos_maleta_0" style="color:darkred;display:none;cursor:hand;cursor:pointer"'
		cadena = cadena + 'data-toggle="popover" data-placement="top" data-trigger="hover" data-content="Borrar El Tipo de Maleta"></i>'
		cadena = cadena + '</div>'
		cadena = cadena + '</td>'
		cadena = cadena + '<tr>'
		
															
		//console.log('cadena a añadir: ' + cadena)
		
		j$(tabla).find('tbody:last-child').append(cadena);
		
		//window.parent.redimensionar_iframe();
		
		
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
		valor_precio_unidad=j$(tbl_row).find('.row_data.row_data_precio').html().replace(',', '.')
		//console.log('valor del precio unidad: ' + valor_precio_unidad)
		valor_precio_pack=''
		valor_tipo_sucursal=valores[2]
		valor_codigo_empresa=valores[1]
		
		mantenimiento_cantidades_precios(valor_accion, valor_id, valor_codigo_articulo, valor_cantidad, valor_precio_unidad, valor_precio_pack, valor_tipo_sucursal, valor_codigo_empresa)
		
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
		
		
		//j$("#tab3",window.opener).trigger('click')
		//console.log('contenidoooo: ' + j$('#tab3', window.parent.document).html())
		
		if (valor_accion=='ALTA')
			{
			j$('#tab4', window.parent.document).click()
			}
		
		
		//window.parent.document.getElementById("element_id")
		//j$(window.opener).find('#tab3').trigger('click')
					
	});
	//--->button > delete > end



//funcion para crear, modificar y borrar los tipos de maleta	
mantenimiento_tipos_maleta = function(valor_accion, valor_id, valor_codigo_maleta, valor_descripcion_maleta, valor_orden_maleta, valor_borrado_maleta) {
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
		texto_error='Se ha Producido un Error al Eliminar El Tipo de Maleta'
		}
	if (valor_accion=='ALTA')
		{
		texto_error='Se ha Producido un Error al dar de Alta El Tipo de Maleta'
		}
	if (valor_accion=='MODIFICACION')
		{
		texto_error='Se ha Producido un Error al Modificar El Tipo de Maleta'
		}
	
	//console.log('id: ' + valor_id)
	//console.log('codigo_articulo: ' + valor_codigo_articulo)
	//console.log('cantridad: ' + valor_cantidad)
	//console.log('precio unid: ' + valor_precio_unidad) 
	//console.log('precio pac: ' + valor_precio_pack) 
	//console.log('tipo sucur: ' + valor_tipo_sucursal) 
	//console.log('empresa: ' + valor_codigo_empresa)
	
	j$.post('Mantenimiento_Tipos_Maleta.asp',
					//'{accion:"' + valor_accion + '", id:' + valor_id + '}',
					{accion:valor_accion,
							id:valor_id,
							codigo_maleta:valor_codigo_maleta, 
							descripcion_maleta:valor_descripcion_maleta, 
							orden_maleta:valor_orden_maleta, 
							borrado_maleta:valor_borrado_maleta 
					},
					function(data, status, xhr)
						{
						//console.log('datos devueltos: ' + data)
						//console.log('estatus: ' + status)
						if (status!='success')
							{
							window.parent.bootbox.alert({
									size: 'large',
									message: '<h4><p><i class="fas fa-exclamation-circle" style="color:red"></i> ' 
													+ texto_error 
													+ '</p></h4>'
													+ '<div class="alert alert-danger" role="alert">'
													+ data
													+ '</div>'
									//callback: refrescar_entrada()
								})
							}
						
						}
	
	
	
	) // fin post
	
};



	//--->button > edit > start	
j$(document).on('click', '.btn_edit_tipos_maleta', function(event) 
	{
		//event.preventDefault();
		
		//compruebo que no haya quedado nada editado con anterioridad
		//console.log("elementos editables: " + j$(".row_data.bg-warning").length)
		if (j$(".row_data.bg-warning").length > 0)
			{
			window.parent.bootbox.alert({
					size: 'large',
					message: '<h4><p><i class="fas fa-exclamation-circle" style="color:red"></i> No puede editar un Tipo de Maleta si no ha guardado o cancelado el anterior...</p></h4>'
					//callback: refrescar_entrada()
				})
			}
		  else
		  	{
			var tbl_row = j$(this).closest('tr');
		
			var row_id = tbl_row.attr('row_id');
		
			tbl_row.find('.btn_save_tipos_maleta').show();
			tbl_row.find('.btn_cancel_tipos_maleta').show();
			tbl_row.find('.btn_delete_tipos_maleta').show();
		
			//hide edit button
			tbl_row.find('.btn_edit_tipos_maleta').hide(); 
		
			
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
j$(document).on('click', '.btn_cancel_tipos_maleta', function(event) 
	{
		event.preventDefault();

		var tbl_row = j$(this).closest('tr');

		var row_id = tbl_row.attr('row_id');

		//hide save and cacel buttons
		tbl_row.find('.btn_save_tipos_maleta').hide();
		tbl_row.find('.btn_cancel_tipos_maleta').hide();
		tbl_row.find('.btn_delete_tipos_maleta').hide();

		//show edit button
		tbl_row.find('.btn_edit_tipos_maleta').show();

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
j$(document).on('click', '.btn_save_tipos_maleta', function(event) 
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
		valor_precio_unidad=''
		//console.log('valor del precio unidad: ' + valor_precio_unidad)
		valor_precio_pack=j$(tbl_row).find('.row_data.row_data_precios_escalado').html().replace(',', '.')
		valor_tipo_sucursal=valores[2]
		valor_codigo_empresa=valores[1]

		mantenimiento_cantidades_precios(valor_accion, valor_id, valor_codigo_articulo, valor_cantidad, valor_precio_unidad, valor_precio_pack, valor_tipo_sucursal, valor_codigo_empresa)
		
		//hide save and cacel buttons
		tbl_row.find('.btn_save_tipos_maleta').hide();
		tbl_row.find('.btn_cancel_tipos_maleta').hide();
		tbl_row.find('.btn_delete_tipos_maleta').hide();

		//show edit button
		tbl_row.find('.btn_edit_tipos_maleta').show();

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
		
		tabla.find('.btn_add_tipos_maleta').show();
					
	});
	//--->button > delete > end












</script>

</html>